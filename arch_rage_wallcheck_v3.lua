-- language: Lua, file: arch_rage_wallcheck_v3.lua, target: Roblox Executor
-- Complete Arch Script — wallcheck v3 logic wired into Rage tab via Rayfield UI
-- Paste whole file into executor and execute

-- ══════════════════════════════════════════════════════════════════════════
--  RAYFIELD UI LOAD
-- ══════════════════════════════════════════════════════════════════════════
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name                    = "Arch Script",
    Icon                    = 0,
    LoadingTitle            = "Arch Script",
    LoadingSubtitle         = "Initialising...",
    Theme                   = "Default",
    DisableRayfieldPrompts  = false,
    DisableBuildWarnings    = false,
    ConfigurationSaving = {
        Enabled  = true,
        FolderName = "ArchScript",
        FileName   = "Config",
    },
})

-- ══════════════════════════════════════════════════════════════════════════
--  TABS  (add more here as your Arch build grows)
-- ══════════════════════════════════════════════════════════════════════════
local RageTab   = Window:CreateTab("Rage",   4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)
local MiscTab   = Window:CreateTab("Misc",   4483362458)

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
--  CONFIG  (persists across hot-reload via getgenv)
-- ══════════════════════════════════════════════════════════════════════════
getgenv().RageCFG = getgenv().RageCFG or {
    Enabled    = false,
    FireRate   = 0.0005,   -- seconds between shots (lower = faster)
    WeaponSlot = "Melee",  -- "Primary" | "Secondary" | "Melee"
}
local CFG = getgenv().RageCFG

-- ══════════════════════════════════════════════════════════════════════════
--  STATE
-- ══════════════════════════════════════════════════════════════════════════
local SLOTS      = { Primary = 1, Secondary = 2, Melee = 3 }
local deflecting = {}
local lastFire   = 0
local eqThread   = nil
local hbConn     = nil

-- ══════════════════════════════════════════════════════════════════════════
--  RAGE TAB — UI
-- ══════════════════════════════════════════════════════════════════════════
RageTab:CreateSection("Auto Attack")

RageTab:CreateToggle({
    Name         = "Auto Attack",
    CurrentValue = CFG.Enabled,
    Flag         = "RageAutoAttack",
    Callback     = function(v)
        CFG.Enabled = v
    end,
})

RageTab:CreateSlider({
    Name         = "Fire Rate (ms)",
    Range        = {0, 500},
    Increment    = 1,
    Suffix       = "ms",
    CurrentValue = math.floor(CFG.FireRate * 1000),
    Flag         = "RageFireRate",
    Callback     = function(v)
        CFG.FireRate = v / 1000
    end,
})

RageTab:CreateDropdown({
    Name          = "Weapon Slot",
    Options       = {"Primary", "Secondary", "Melee"},
    CurrentOption = {CFG.WeaponSlot},
    Flag          = "RageWeaponSlot",
    Callback      = function(v)
        -- Rayfield returns a table; unwrap if needed
        CFG.WeaponSlot = type(v) == "table" and v[1] or v
    end,
})

-- ══════════════════════════════════════════════════════════════════════════
--  VISUAL TAB — placeholder (add your ESP / Highlight etc. here)
-- ══════════════════════════════════════════════════════════════════════════
VisualTab:CreateSection("Coming Soon")

-- ══════════════════════════════════════════════════════════════════════════
--  MISC TAB — placeholder
-- ══════════════════════════════════════════════════════════════════════════
MiscTab:CreateSection("Coming Soon")

-- ══════════════════════════════════════════════════════════════════════════
--  HELPERS  (wallcheck v3 logic, variable-renamed for clarity)
-- ══════════════════════════════════════════════════════════════════════════

plrs.PlayerRemoving:Connect(function(p)
    deflecting[p] = nil
end)

-- Mark each fighter as deflecting if they are mid-Katana parry window
local function updateDeflection()
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

-- Team-aware enemy check with duel + attribute fallback
local function isEnemy(p)
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

-- Return the nearest living enemy + their HumanoidRootPart + Head
local function getClosestTarget()
    local char = lplr.Character
    if not char then return nil, nil, nil end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil, nil end
    local bp, br, bh, bd = nil, nil, nil, 500
    for _, p in plrs:GetPlayers() do
        if not isEnemy(p) then continue end
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

-- True if the target is currently wielding a Knife ViewModel
local function hasKnifeViewModel(tp)
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

-- Build the spoofed CFrame used as the desync origin
local function buildDesyncCF(tp, tr, th)
    if not (tr and th) then return nil end
    local pos = hasKnifeViewModel(tp)
        and (tr.CFrame * CFrame.new(0, 6, 0)).Position   -- knife: aim above root
        or  (tr.CFrame * CFrame.new(0, 1, 2)).Position   -- default: aim behind-above
    return CFrame.lookAt(pos, th.Position)
end

-- ══════════════════════════════════════════════════════════════════════════
--  EQUIP LOOP
--  Waits for LocalFighter on first run, then keeps the selected weapon
--  equipped every second while the toggle is on.
-- ══════════════════════════════════════════════════════════════════════════
local function startEquipLoop()
    if eqThread then pcall(task.cancel, eqThread) end
    eqThread = task.spawn(function()
        -- Wait for LocalFighter to be ready (e.g. after respawn)
        local lf = FighterCtrl.LocalFighter
        while not lf do
            task.wait(0.1)
            lf = FighterCtrl.LocalFighter
        end
        pcall(function()
            lf:EquipItem(SLOTS[CFG.WeaponSlot] or 3)
        end)

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
--    1. Refresh deflection map for all fighters
--    2. Find nearest enemy
--    3. Spoof local HumanoidRootPart CFrame to desync origin
--       (restored on the very next RenderStep — client-side only)
--    4. If all gates pass, fire UseItem remote with aim data
-- ══════════════════════════════════════════════════════════════════════════
local function startHeartbeat()
    if hbConn then hbConn:Disconnect() end
    hbConn = runS.Heartbeat:Connect(function()
        updateDeflection()

        local tp, tr, th = getClosestTarget()
        local desyncCF   = buildDesyncCF(tp, tr, th)

        -- ── CFrame spoof (restore before next render) ────────────────────
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

        -- ── Fire gates ───────────────────────────────────────────────────
        if not CFG.Enabled                                         then return end
        if not tp or not th or not tr                             then return end
        if deflecting[tp]                                         then return end
        if not lplr.Character                                     then return end
        if not lplr.Character:FindFirstChild("HumanoidRootPart")  then return end
        if not FighterCtrl or not FighterCtrl.LocalFighter        then return end

        local item = FighterCtrl.LocalFighter.EquippedItem
        if not item                              then return end
        if tick() - lastFire < CFG.FireRate      then return end
        lastFire = tick()

        -- ── Aim construction ─────────────────────────────────────────────
        local originPos = desyncCF and desyncCF.Position or tr.Position
        local aimCF     = CFrame.lookAt(originPos, th.Position)
        local targetCF  = th.CFrame

        -- Tiny random spread keeps the pattern from being pixel-perfect
        local rng = Vector3.new(
            (math.random() - 0.5) * 0.1,
            (math.random() - 0.5) * 0.1,
            (math.random() - 0.5) * 0.1
        )
        local aimedPos       = th.Position + rng
        local objSpaceOffset = th.CFrame:ToObjectSpace(CFrame.new(aimedPos))

        -- ── Camera data payload — mirrors original wallcheck encoding ─────
        local cameradata = {}
        cameradata[utf8.char(1)] = {
            [utf8.char(0)] = util:EncodeCFrame(aimCF),
            [utf8.char(1)] = util:EncodeCFrame(targetCF),
            [utf8.char(2)] = th,
            [utf8.char(3)] = util:EncodeCFrame(objSpaceOffset),
        }

        -- ── Fire remote ──────────────────────────────────────────────────
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
startEquipLoop()
startHeartbeat()

-- Load saved flags (Rayfield config persistence)
Rayfield:LoadConfiguration()
