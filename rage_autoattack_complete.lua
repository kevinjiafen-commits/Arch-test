-- language: Lua, file: rage_autoattack_complete.lua, target: Roblox Executor + Arch Script UI
-- Paste this block AFTER your Arch Script RageTab is defined.
-- Point the RageTab lookup below at your actual tab object if the auto-detect misses it.
-- Requires: FighterController, SpectateController, Utility, EnumLibrary in RepS / PlayerScripts

-- ══════════════════════════════════════════════════════════════════════════
--  SERVICES
-- ══════════════════════════════════════════════════════════════════════════
local repS  = cloneref(game:GetService("ReplicatedStorage"))
local plrs  = cloneref(game:GetService("Players"))
local runS  = cloneref(game:GetService("RunService"))
local ws    = cloneref(game:GetService("Workspace"))
local lplr  = plrs.LocalPlayer

-- ══════════════════════════════════════════════════════════════════════════
--  GAME MODULES
-- ══════════════════════════════════════════════════════════════════════════
local util         = require(repS.Modules.Utility)
local enum         = require(repS.Modules.EnumLibrary)
local FighterCtrl  = require(lplr.PlayerScripts.Controllers.FighterController)
local SpectateCtrl = require(lplr.PlayerScripts.Controllers:WaitForChild("SpectateController"))

-- ══════════════════════════════════════════════════════════════════════════
--  CONFIG  (getgenv survives hot-reload / re-require)
-- ══════════════════════════════════════════════════════════════════════════
getgenv().RageCFG = getgenv().RageCFG or {
    Enabled    = false,
    FireRate   = 0.0005,   -- seconds between shots  (lower = faster)
    WeaponSlot = "Melee",  -- "Primary" | "Secondary" | "Melee"
}
local CFG = getgenv().RageCFG

-- ══════════════════════════════════════════════════════════════════════════
--  STATE
-- ══════════════════════════════════════════════════════════════════════════
local SLOTS      = { Primary = 1, Secondary = 2, Melee = 3 }
local deflecting = {}
local lastFire   = 0
local hbConn     = nil   -- Heartbeat connection
local eqThread   = nil   -- equip-loop thread

-- ══════════════════════════════════════════════════════════════════════════
--  ARCH SCRIPT GUI BINDINGS
--
--  Arch Script typically stores tab objects in getgenv().ArchTabs.
--  If your build uses a different table name, swap the line below.
--  RageTab:AddToggle / AddSlider / AddDropdown match the standard Arch API.
--  If your fork uses a different call shape (e.g. :Toggle / :Slider),
--  adjust accordingly — the callbacks and flags are identical.
-- ══════════════════════════════════════════════════════════════════════════
local RageTab = (getgenv().ArchTabs and getgenv().ArchTabs["Rage"])
             or (getgenv().Tabs      and getgenv().Tabs["Rage"])
             or nil

if RageTab then

    -- Section divider
    pcall(function()
        RageTab:AddSection({ Name = "Auto Attack" })
    end)

    -- ── Master enable toggle ─────────────────────────────────────────────
    RageTab:AddToggle({
        Name     = "Auto Attack",
        Default  = CFG.Enabled,
        Flag     = "RageAutoAttack",
        Callback = function(v)
            CFG.Enabled = v
        end,
    })

    -- ── Fire rate slider  (display in ms, store as seconds) ──────────────
    RageTab:AddSlider({
        Name      = "Fire Rate (ms)",
        Min       = 0,
        Max       = 500,
        Default   = math.floor(CFG.FireRate * 1000),
        Increment = 1,
        Flag      = "RageFireRateMS",
        Callback  = function(v)
            CFG.FireRate = v / 1000
        end,
    })

    -- ── Weapon slot dropdown ─────────────────────────────────────────────
    RageTab:AddDropdown({
        Name     = "Weapon Slot",
        Default  = CFG.WeaponSlot,
        Options  = { "Primary", "Secondary", "Melee" },
        Flag     = "RageWeaponSlot",
        Callback = function(v)
            CFG.WeaponSlot = v
        end,
    })

else
    -- Headless fallback — edit getgenv().RageCFG from the executor console
    warn("[RageAutoAttack] RageTab not found — headless mode. Edit getgenv().RageCFG manually.")
end

-- ══════════════════════════════════════════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════════════════════════════════════════

-- Clean up deflect map when players leave
plrs.PlayerRemoving:Connect(function(p)
    deflecting[p] = nil
end)

-- Scan every fighter's equipped item; mark if actively deflecting with Katana
local function _updateDeflection()
    if not FighterCtrl or not FighterCtrl.Objects then return end
    for _, fo in FighterCtrl.Objects do
        local p = fo.Player
        if not p then continue end
        if not fo.Entity or not fo.Entity:IsAlive() or fo:Get("IsSpectating") then
            deflecting[p] = false
            continue
        end
        local eq    = fo.EquippedItem
        local isKat = eq and eq.ViewModel and eq.ViewModel.Name == "Katana"
        deflecting[p] = isKat
            and (eq._attack_cooldown and eq._attack_cooldown > tick())
            or false
    end
end

-- Team-aware enemy check; falls back to attribute-based team ID
local function _isEnemy(p)
    if p == lplr then return false end
    local duel     = SpectateCtrl.CurrentDuelSubject
    local myDueler = duel and duel:GetDueler(lplr)
    local myTeam   = myDueler and myDueler:Get("TeamID")
    if myTeam and duel and duel.Duelers then
        for _, d in duel.Duelers do
            if d.Player == p then
                return d:Get("TeamID") ~= myTeam
            end
        end
    end
    local pt = p:GetAttribute("TeamID")
    local lt = lplr:GetAttribute("TeamID")
    if pt and lt then return pt ~= lt end
    return true
end

-- Return nearest living enemy player + their Root + Head
local function _closest()
    local char = lplr.Character
    if not char then return nil, nil, nil end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil, nil end
    local bp, br, bh, bd = nil, nil, nil, 500
    for _, p in plrs:GetPlayers() do
        if not _isEnemy(p) then continue end
        local pc   = p.Character
        local pr   = pc and pc:FindFirstChild("HumanoidRootPart")
        local ph   = pc and pc:FindFirstChild("Head")
        local phum = pc and pc:FindFirstChildWhichIsA("Humanoid")
        if not (pr and ph and phum and phum.Health > 0) then continue end
        local d = (myRoot.Position - pr.Position).Magnitude
        if d < bd then bd = d; bp = p; br = pr; bh = ph end
    end
    return bp, br, bh
end

-- True if target is holding a Knife ViewModel (triggers higher desync offset)
local function _hasKnife(tp)
    if not tp then return false end
    local vm = ws:FindFirstChild("ViewModels")
    if not vm then return false end
    for _, m in vm:GetChildren() do
        if m:IsA("Model")
           and m.Name:find(tp.Name, 1, true)
           and m.Name:find("Knife",  1, true) then
            return true
        end
    end
    return false
end

-- Build the spoofed origin CFrame used for desync + aim vector
local function _buildDesyncCF(tp, tr, th)
    if not (tr and th) then return nil end
    local offsetPos = _hasKnife(tp)
        and (tr.CFrame * CFrame.new(0, 6, 0)).Position   -- knife: aim above root
        or  (tr.CFrame * CFrame.new(0, 1, 2)).Position   -- default: slightly behind
    return CFrame.lookAt(offsetPos, th.Position)
end

-- ══════════════════════════════════════════════════════════════════════════
--  EQUIP LOOP
--  Waits for LocalFighter on first run, then re-equips the chosen slot
--  every second while Enabled. Survives fighter re-spawns.
-- ══════════════════════════════════════════════════════════════════════════
local function _startEquipLoop()
    if eqThread then
        pcall(task.cancel, eqThread)
    end
    eqThread = task.spawn(function()
        -- Initial equip — wait until LocalFighter is ready
        local lf = FighterCtrl.LocalFighter
        while not lf do
            task.wait(0.1)
            lf = FighterCtrl.LocalFighter
        end
        pcall(function()
            lf:EquipItem(SLOTS[CFG.WeaponSlot] or 3)
        end)

        -- Sustained equip — keeps slot hot through respawns / forced unequips
        while true do
            task.wait(1)
            if not CFG.Enabled then continue end
            local f = FighterCtrl.LocalFighter
            if f then
                pcall(function()
                    f:EquipItem(SLOTS[CFG.WeaponSlot] or 3)
                end)
            end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════════════════
--  MAIN HEARTBEAT
--  Every frame:
--    1. Refresh deflection map
--    2. Find closest enemy
--    3. Spoof local root CFrame to desync origin (restored next RenderStep)
--    4. If Enabled and all gates pass, fire UseItem remote
-- ══════════════════════════════════════════════════════════════════════════
local function _startHeartbeat()
    if hbConn then
        hbConn:Disconnect()
    end
    hbConn = runS.Heartbeat:Connect(function()
        _updateDeflection()

        local tp, tr, th = _closest()
        local desyncCF   = _buildDesyncCF(tp, tr, th)

        -- ── CFrame spoof — restore on the very next RenderStep ──────────
        if desyncCF and lplr.Character then
            local myRoot = lplr.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local oldCF     = myRoot.CFrame
                local oldVel    = myRoot.Velocity
                local oldRotVel = myRoot.RotVelocity
                myRoot.CFrame   = desyncCF
                runS:BindToRenderStep("__restore", 101, function()
                    if myRoot then
                        myRoot.CFrame      = oldCF
                        myRoot.Velocity    = oldVel
                        myRoot.RotVelocity = oldRotVel
                    end
                    runS:UnbindFromRenderStep("__restore")
                end)
            end
        end

        -- ── Fire gates ──────────────────────────────────────────────────
        if not CFG.Enabled                                         then return end
        if not tp or not th or not tr                             then return end
        if deflecting[tp]                                         then return end
        if not lplr.Character                                     then return end
        if not lplr.Character:FindFirstChild("HumanoidRootPart")  then return end
        if not FighterCtrl or not FighterCtrl.LocalFighter        then return end

        local item = FighterCtrl.LocalFighter.EquippedItem
        if not item                                               then return end
        if tick() - lastFire < CFG.FireRate                       then return end
        lastFire = tick()

        -- ── Aim vector ──────────────────────────────────────────────────
        local originPos = desyncCF and desyncCF.Position or tr.Position
        local aimCF     = CFrame.lookAt(originPos, th.Position)
        local targetCF  = th.CFrame

        -- Small random spread so every shot is not pixel-perfect
        local randomOff = Vector3.new(
            (math.random() - 0.5) * 0.1,
            (math.random() - 0.5) * 0.1,
            (math.random() - 0.5) * 0.1
        )
        local aimedPos       = th.Position + randomOff
        local objSpaceOffset = th.CFrame:ToObjectSpace(CFrame.new(aimedPos))

        -- ── Camera data payload (mirrors original wallcheck encoding) ────
        local cameradata = {}
        cameradata[utf8.char(1)] = {
            [utf8.char(0)] = util:EncodeCFrame(aimCF),
            [utf8.char(1)] = util:EncodeCFrame(targetCF),
            [utf8.char(2)] = th,
            [utf8.char(3)] = util:EncodeCFrame(objSpaceOffset),
        }

        -- ── Fire the remote ─────────────────────────────────────────────
        repS.Remotes.Replication.Fighter.UseItem:FireServer(
            item:Get("ObjectID"),
            enum:ToEnum("StartShooting"),
            cameradata,
            nil
        )
    end)
end

-- ══════════════════════════════════════════════════════════════════════════
--  INIT
-- ══════════════════════════════════════════════════════════════════════════
_startEquipLoop()
_startHeartbeat()
