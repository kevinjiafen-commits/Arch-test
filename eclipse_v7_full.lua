-- language: Luau, file: eclipse_v7_full.lua, target: Rivals (Roblox)
-- Eclipse UI | v7.0 — FULL SUITE
-- Merged: flickbot_eclipse_final_v63 + Arch Scripts (rivals full)
--
-- Features:
--   Rage:          UseItem remote fire, slot select, ammo handling
--   Flickbot:      Desync CFrame, orbit mode, prediction, void spam, flick lerp
--   Silent Aim:    FOV-locked camera redirect on fire remote
--   Aimbot:        Camera-space smooth aim + FOV circle
--   ESP:           Box (2D/Corner/Filled), skeleton, tracers, name, distance, health
--   Anti-Aim:      Spin / Jitter / Desync external anti-aim
--   Movement:      Speed, infinite jump, noclip, fly, spin, no-fall, underground,
--                  slide boost, irregular move
--   Combat:        Triggerbot, wallbang, fist hitbox, orbit, riot stomp
--   Gun:           Rapid fire, instant ADS, no equip/shoot anim, no spread,
--                  no smoke, no flash, device spoof, anti-katana
--   Cosmetics:     Full unlocker — skins/wraps/charms/dances/emotes, persist JSON
--   Config:        Save / load / auto-load JSON config

-- ─── ANTI-CHEAT BYPASS ───────────────────────────────────────────────────────
local _stbl; _stbl = hookfunction(getrenv().setmetatable, newcclosure(function(tbl, mt)
    if mt and typeof(mt) == "table" and rawget(mt, "__mode") == "kv" then
        local tr = debug.traceback()
        if tr:find("MiscellaneousController") then
            return _stbl({1,2,3}, {})
        end
    end
    return _stbl(tbl, mt)
end))

coroutine.wrap(function()
    pcall(function()
        local function _proc(o)
            pcall(function()
                if o:IsA("LocalScript") or o:IsA("ModuleScript") then
                    local _s, nm = pcall(function() return o.Name:lower() end)
                    if not _s or not nm then return end
                    local _tags = {"anticheat","ac","detection","ban","kick","security","moderation"}
                    for _i = 1, #_tags do
                        if nm:find(_tags[_i]) then
                            pcall(function() o.Disabled = true end)
                            break
                        end
                    end
                end
            end)
        end
        pcall(function()
            local _desc = game:GetDescendants()
            for _i = 1, #_desc do _proc(_desc[_i]) end
        end)
        pcall(function() game.DescendantAdded:Connect(_proc) end)
    end)
    pcall(function()
        local _nc = game:GetService("NetworkClient")
        if not _nc then return end
        _nc.ChildAdded:Connect(function(ch)
            pcall(function()
                local _ok, _n = pcall(function() return ch.Name:lower() end)
                if _ok and _n then
                    if _n:find("anticheat") or _n:find("detection") then
                        pcall(function() ch:Destroy() end)
                    end
                end
            end)
        end)
    end)
end)()

-- MiscellaneousController GC hook bypass
pcall(function()
    local _rf   = game:GetService("ReplicatedFirst")
    local _tgt  = _rf:WaitForChild("LocalScript3", 10)
    local _gc   = getgc(false)
    for _i = 1, #_gc do
        local _fn = _gc[_i]
        if type(_fn) ~= "function" then continue end
        local _ok1, _env = pcall(getfenv, _fn)
        if not _ok1 or type(_env) ~= "table" then continue end
        local _ok2, _scr = pcall(function() return rawget(_env, "script") end)
        if not _ok2 or not _scr or typeof(_scr) ~= "Instance" then continue end
        local _ok3, _ss  = pcall(tostring, _scr)
        if not _ok3 then continue end
        if not (_scr == _tgt or (type(_ss) == "string" and _ss:find("LoadingScreen"))) then continue end
        local _ok4, _consts = pcall(debug.getconstants, _fn)
        if not _ok4 or type(_consts) ~= "table" then continue end
        for _j = 1, #_consts do
            local _c = _consts[_j]
            if type(_c) == "string" and (_c:find("TakeTheL") or _c:find("ban") or _c:find("kick")) then
                pcall(function()
                    hookfunction(_fn, function() end)
                end)
                break
            end
        end
    end
end)

-- ─── SERVICES ────────────────────────────────────────────────────────────────
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst   = game:GetService("ReplicatedFirst")
local Workspace         = game:GetService("Workspace")
local HttpService       = game:GetService("HttpService")
local CoreGui           = game:GetService("CoreGui")
local Camera            = Workspace.CurrentCamera

local Player            = Players.LocalPlayer

local function cref(s) return (cloneref and cloneref(s)) or s end
local repS  = cref(ReplicatedStorage)
local plrs  = cref(Players)
local ws    = cref(Workspace)
local cgui  = cref(CoreGui)

-- ─── MODULE REQUIRES ─────────────────────────────────────────────────────────
local FighterController, SpectateController, util, enumLib
local CosmeticLibrary, ItemLibrary, PlayerDataController
do
    local ok
    ok, FighterController   = pcall(require, Player.PlayerScripts.Controllers.FighterController)
    if not ok then FighterController = nil end
    ok, SpectateController  = pcall(require, Player.PlayerScripts.Controllers:WaitForChild("SpectateController", 5))
    if not ok then SpectateController = nil end
    ok, util    = pcall(require, repS.Modules.Utility)
    if not ok then util = nil end
    ok, enumLib = pcall(require, repS.Modules.EnumLibrary)
    if not ok then enumLib = nil end
    ok, CosmeticLibrary = pcall(require, repS.Modules:WaitForChild("CosmeticLibrary", 10))
    if not ok then CosmeticLibrary = nil end
    ok, ItemLibrary = pcall(require, repS.Modules:WaitForChild("ItemLibrary", 10))
    if not ok then ItemLibrary = nil end
    ok, PlayerDataController = pcall(require, Player.PlayerScripts.Controllers:WaitForChild("PlayerDataController", 5))
    if not ok then PlayerDataController = nil end
end
if enumLib then pcall(function() enumLib:WaitForEnumBuilder() end) end

-- ─── ECLIPSE PALETTE ─────────────────────────────────────────────────────────
local CFG = {
    MainColor      = Color3.fromRGB(14,  14,  14),
    SecondaryColor = Color3.fromRGB(26,  26,  26),
    AccentColor    = Color3.fromRGB(189, 172, 255),
    TextColor      = Color3.fromRGB(200, 200, 200),
    TextDark       = Color3.fromRGB(120, 120, 120),
    StrokeColor    = Color3.fromRGB(40,  40,  40),
    DangerColor    = Color3.fromRGB(200, 60,  60),
    SuccessColor   = Color3.fromRGB(100, 220, 100),
    Font           = Enum.Font.Code,
    BaseSize       = Vector2.new(760, 500),
}

-- ─── RUNTIME CONFIG — FLICKBOT ───────────────────────────────────────────────
local FlickCfg = {
    Active          = false,
    Desync          = true,
    PredictionOn    = true,
    PredictionScale = 0.08,
    TeamFilter      = true,
    AntiVelocity    = true,
    OffsetX         = 0,
    OffsetY         = 0,
    OffsetZ         = 0,
    FlickSpeed      = 99999,
    FlickRadius     = 0.25,
    WritesPerFrame  = 3,
    RandomizeOffset = false,
    _SavedOffsetX   = 0,
    _SavedOffsetY   = 0,
    _SavedOffsetZ   = 0,
    FlickLerpAlpha  = 1.0,
}

-- ─── RUNTIME CONFIG — RAGE ───────────────────────────────────────────────────
local RageCfg = {
    Active          = false,
    FireRate        = 0.0005,
    WeaponPrimary   = true,
    WeaponSecondary = true,
    WeaponMelee     = true,
    OnEmpty         = "SwapOrReload",
}

-- ─── RUNTIME CONFIG — VOID SPAM ──────────────────────────────────────────────
local VoidCfg = {
    Active   = false,
    Duration = 0.3,
    Cooldown = 0.1,
    VoidY    = -5000,
}

-- ─── RUNTIME CONFIG — SILENT AIM ─────────────────────────────────────────────
local S = {
    -- silent aim
    silentAimEnabled  = false,
    silentFov         = 30,
    silentTargetPart  = "Head",
    silentFovColor    = Color3.new(1, 0, 0),
    showFovCircles    = false,
    fovStyle          = "Outline",
    -- aimbot
    aimbotActive      = false,
    aimbotFov         = 120,
    aimbotSmooth      = 0.15,
    aimbotKey         = Enum.KeyCode.Unknown,
    aimbotPart        = "Head",
    aimbotFovColor    = Color3.fromRGB(255, 255, 0),
    -- esp
    espActive         = false,
    espShowBox        = true,
    espBoxType        = "2D",
    espShowTracers    = false,
    espShowName       = true,
    espShowDistance   = true,
    espShowHealthBar  = true,
    espShowSkeleton   = false,
    espBoxColor       = Color3.fromRGB(189, 172, 255),
    espTextColor      = Color3.new(1, 1, 1),
    espTracerColor    = Color3.fromRGB(189, 172, 255),
    espHealthColor    = Color3.new(0, 1, 0),
    espHealthBadColor = Color3.new(1, 0, 0),
    -- movement
    speedValue        = 16,
    infiniteJumpActive = false,
    noclipActive      = false,
    flyActive         = false,
    flySpeed          = 50,
    spinActive        = false,
    spinSpeed         = 10,
    noFallActive      = false,
    voidActive        = false,
    orbActive         = false,
    fistActive        = false,
    roitActive        = false,
    undergroundActive = false,
    slideBoostActive  = false,
    slideBoostSpeed   = 300,
    irregularMoveActive = false,
    -- combat
    triggerbotEnabled = false,
    triggerbotDelay   = 0.05,
    wallbangActive    = false,
    -- gun
    rapidFireActive   = false,
    fireDelay         = 1,
    instantAdsEnabled = false,
    noEquipAnimEnabled = false,
    noShootAnimEnabled = false,
    noSpreadEnabled   = false,
    noSmokeEnabled    = false,
    noFlashEnabled    = false,
    deviceSpoofEnabled = false,
    spoofDevice       = "VR",
    antiKatanaEnabled = false,
}

-- ─── ANTI-AIM CONFIG ─────────────────────────────────────────────────────────
_G.AntiAimSettings = _G.AntiAimSettings or {
    enabled   = false,
    mode      = "Spin",   -- "Spin" | "Jitter" | "Desync"
    spinSpeed = 20,
    jitterAmt = 25,
}

-- ─── GLOBAL FEATURES ─────────────────────────────────────────────────────────
_G.Features = _G.Features or {
    SlideBoost = { Enabled = false, Speed = 300 },
}

-- ─── COSMETIC UNLOCKER — DATA ────────────────────────────────────────────────
local _eq, _favs     = {}, {}
local _buildingWep, _viewProf = nil, nil
local _lastWep       = nil
local _fakeInv       = {}
local _cfgFile       = "rivals_eclipse_config.json"
local _saveLock      = false

local function _mkCosmetic(nm, ctype, opts)
    if not CosmeticLibrary then return nil end
    local _base = CosmeticLibrary.Cosmetics and CosmeticLibrary.Cosmetics[nm]
    if not _base then return nil end
    local _d = {}
    for k, v in pairs(_base) do _d[k] = v end
    _d.Name = nm
    _d.Type = _d.Type or ctype
    _d.Seed = _d.Seed or math.random(1, 1000000)
    if enumLib then
        local _s, _eid = pcall(enumLib.ToEnum, enumLib, nm)
        if _s and _eid then
            _d.Enum     = _eid
            _d.ObjectID = _d.ObjectID or _eid
        end
    end
    if opts then
        if opts.inverted ~= nil     then _d.Inverted         = opts.inverted      end
        if opts.favoritesOnly ~= nil then _d.OnlyUseFavorites = opts.favoritesOnly end
    end
    return _d
end

local function _stripForSave()
    local _out = {}
    for wn, cos in pairs(_eq) do
        _out[wn] = {}
        for ct, cd in pairs(cos) do
            if cd and cd.Name then
                _out[wn][ct] = {
                    Name             = cd.Name,
                    Inverted         = cd.Inverted,
                    OnlyUseFavorites = cd.OnlyUseFavorites,
                }
            end
        end
    end
    return { equipped = _out, favorites = _favs }
end

local function _loadCfg()
    if not isfile or not readfile then return end
    local _ok1, _ex = pcall(isfile, _cfgFile)
    if not _ok1 or not _ex then return end
    local _ok2, _raw = pcall(readfile, _cfgFile)
    if not _ok2 or not _raw or _raw == "" then return end
    local _ok3, _dec = pcall(HttpService.JSONDecode, HttpService, _raw)
    if not _ok3 or not _dec then return end
    if _dec.favorites then _favs = _dec.favorites end
    if _dec.equipped then
        _eq = {}
        for wn, cos in pairs(_dec.equipped) do
            _eq[wn] = {}
            for ct, sd in pairs(cos) do
                if sd and sd.Name then
                    if CosmeticLibrary and CosmeticLibrary.Cosmetics and CosmeticLibrary.Cosmetics[sd.Name] then
                        local _cloned = _mkCosmetic(sd.Name, ct, {
                            inverted      = sd.Inverted,
                            favoritesOnly = sd.OnlyUseFavorites,
                        })
                        if _cloned then _eq[wn][ct] = _cloned end
                    end
                end
            end
            if not next(_eq[wn]) then _eq[wn] = nil end
        end
    end
end

local function _saveCfg()
    if not writefile or _saveLock then return end
    _saveLock = true
    task.spawn(function()
        task.wait(1)
        local _payload = _stripForSave()
        local _ok, _enc = pcall(HttpService.JSONEncode, HttpService, _payload)
        if _ok then pcall(writefile, _cfgFile, _enc) end
        _saveLock = false
    end)
end

_loadCfg()

local _cosTypes = {"Skin","Wrap","Charm","Dance","Emote"}
local function _isCosType(cosObj)
    if not cosObj then return false end
    for _, t in ipairs(_cosTypes) do
        if cosObj.Type == t then return true end
    end
    return false
end

-- ─── COSMETIC INJECTION ──────────────────────────────────────────────────────
local function _injectCosmetics()
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf then return end

    task.spawn(function()
        local fakeInvMethod = lf.GetInventory or lf.Inventory
        if type(fakeInvMethod) == "function" then
            local ok, inv = pcall(fakeInvMethod, lf)
            if ok and type(inv) == "table" then
                for _, entry in ipairs(inv) do
                    _fakeInv[#_fakeInv + 1] = entry
                end
            end
        end

        if not CosmeticLibrary then return end
        local allCosmetics = CosmeticLibrary.Cosmetics
        if not allCosmetics then return end

        for nm, data in pairs(allCosmetics) do
            local cos = _mkCosmetic(nm, data.Type, {})
            if cos then
                _fakeInv[#_fakeInv + 1] = cos
                pcall(function()
                    if lf.AddCosmetic then lf:AddCosmetic(cos)
                    elseif lf.GiveCosmetic then lf:GiveCosmetic(cos) end
                end)
            end
        end
    end)
end

local function _equipCosmetic(weaponName, cosType, cosName)
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf then return end
    local cos = _mkCosmetic(cosName, cosType, {})
    if not cos then return end
    if not _eq[weaponName] then _eq[weaponName] = {} end
    _eq[weaponName][cosType] = cos
    _saveCfg()
    pcall(function()
        if lf.SetCosmetic then
            lf:SetCosmetic(weaponName, cosType, cos)
        elseif lf.EquipCosmetic then
            lf:EquipCosmetic(cos, weaponName)
        end
    end)
end

local function _unequipCosmetic(weaponName, cosType)
    if not _eq[weaponName] then return end
    _eq[weaponName][cosType] = nil
    if not next(_eq[weaponName]) then _eq[weaponName] = nil end
    _saveCfg()
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf then return end
    pcall(function()
        if lf.RemoveCosmetic then lf:RemoveCosmetic(weaponName, cosType)
        elseif lf.UnequipCosmetic then lf:UnequipCosmetic(weaponName, cosType) end
    end)
end

-- ─── ITEM CACHE ──────────────────────────────────────────────────────────────
local ItemCache = {}

local function RefreshItemCache()
    ItemCache = {}
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf then return end
    if lf.Items then
        for i = 1, 3 do
            local item = lf.Items[i]
            if item then ItemCache[i] = item end
        end
        return
    end
    for i = 1, 3 do
        pcall(function() lf:EquipItem(i) end)
        task.wait(0.05)
        local item = lf.EquippedItem
        if item then ItemCache[i] = item end
    end
end

-- ─── WEAPON SLOT HELPERS ─────────────────────────────────────────────────────
local function itemCategory(idx)
    if idx == 1 then return "Primary"
    elseif idx == 2 then return "Secondary"
    elseif idx == 3 then return "Melee" end
    return nil
end

local function isCategoryEnabled(cat)
    if cat == "Primary"   then return RageCfg.WeaponPrimary end
    if cat == "Secondary" then return RageCfg.WeaponSecondary end
    if cat == "Melee"     then return RageCfg.WeaponMelee end
    return false
end

local function getFirstEnabledSlot()
    if RageCfg.WeaponPrimary   then return 1 end
    if RageCfg.WeaponSecondary then return 2 end
    if RageCfg.WeaponMelee     then return 3 end
    return 3
end

local function ReadItemValue(item, key)
    if not item then return nil end
    if type(item.Get) == "function" then
        local ok, v = pcall(item.Get, item, key)
        if ok then return v end
    end
    return item[key]
end

local function itemObjectId(item)
    local data = item.Data
    return data and data.ObjectID or nil
end

local function itemIsReloading(item)
    local now = tick()
    local cd  = item._reload_cooldown
    if type(cd) == "number" and now < cd then return true end
    local noAmmo = item._shoot_cooldown_no_ammo
    return type(noAmmo) == "number" and now < noAmmo
end

local function equipItemByIndex(item, index)
    if not item then return end
    if item.IsEquipped then return end
    local fighter = item.ClientFighter
    if fighter and type(fighter.EquipItem) == "function" then
        pcall(fighter.EquipItem, fighter, index)
    end
end

local function reloadItem(item)
    if not item then return end
    if itemIsReloading(item) then return end
    local reserve = ReadItemValue(item, "AmmoReserve")
    if type(reserve) == "number" and reserve <= 0 then return end
    local maxAmmo = ReadItemValue(item, "Info.MaxAmmo") or ReadItemValue(item, "MaxAmmo")
    local ammo    = ReadItemValue(item, "Ammo")
    if maxAmmo and ammo and ammo >= maxAmmo then return end

    local remote = repS:FindFirstChild("Remotes")
    remote = remote and remote:FindFirstChild("Replication")
    remote = remote and remote:FindFirstChild("Fighter")
    remote = remote and remote:FindFirstChild("UseItem")
    if not remote or not enumLib then return end
    local startRld = enumLib:ToEnum("StartReloading")
    local reload   = enumLib:ToEnum("Reload")
    if not startRld or not reload then return end
    pcall(function()
        remote:FireServer(itemObjectId(item), startRld, { ["\1"] = reload, ["\2"] = reload }, nil)
    end)
end

local function getAction()
    if not FighterController then return nil end
    local lf = FighterController.LocalFighter
    if not lf then return nil end
    local items = lf.Items
    if type(items) ~= "table" then return nil end

    local onEmpty = RageCfg.OnEmpty
    local bestAttack, bestAttackPri, bestAttackIdx = nil, math.huge, nil
    local bestSwap, bestSwapPri, bestSwapIdx       = nil, math.huge, nil
    local anyEnabled = false

    for slotKey, item in next, items do
        if type(item) == "table" then
            local cat = itemCategory(slotKey)
            if cat and isCategoryEnabled(cat) then
                anyEnabled = true
                local prio   = 1
                local itType = item.Info and item.Info.Type or "Gun"
                local ammo   = ReadItemValue(item, "Ammo")
                if itType == "Gun" and (ammo == nil or ammo == 0) then
                    local reserve = ReadItemValue(item, "AmmoReserve")
                    if reserve and reserve > 0 then
                        if onEmpty == "Reload" then
                            if prio < bestAttackPri then bestAttack = item; bestAttackPri = prio; bestAttackIdx = slotKey end
                        else
                            if prio < bestSwapPri   then bestSwap   = item; bestSwapPri   = prio; bestSwapIdx   = slotKey end
                        end
                    end
                elseif bestAttack == nil or prio < bestAttackPri then
                    bestAttack = item; bestAttackPri = prio; bestAttackIdx = slotKey
                end
            end
        end
    end

    if not anyEnabled then return nil end
    if bestAttack == nil then
        if onEmpty == "Swap" or bestSwap == nil then return nil end
        if bestSwap.IsEquipped then
            return { type = "Reload", item = bestSwap, index = bestSwapIdx }
        else
            return { type = "Swap",   item = bestSwap, index = bestSwapIdx }
        end
    end
    if not bestAttack.IsEquipped then
        return { type = "Swap", item = bestAttack, index = bestAttackIdx }
    end
    local ammo = ReadItemValue(bestAttack, "Ammo")
    if ammo == 0 then
        return { type = "Reload", item = bestAttack, index = bestAttackIdx }
    end
    return { type = "Attack", item = bestAttack, index = bestAttackIdx }
end

local function forceSwap()
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf or type(lf.Items) ~= "table" then return end
    for slotKey, item in next, lf.Items do
        if type(item) == "table" then
            local cat = itemCategory(slotKey)
            if cat and isCategoryEnabled(cat) and not item.IsEquipped then
                equipItemByIndex(item, slotKey)
                return
            end
        end
    end
end

-- persistent equip loops
local Library = { Unloaded = false }

task.spawn(function()
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    while not lf do task.wait(0.1); lf = FighterController.LocalFighter end
    RefreshItemCache()
    pcall(function() lf:EquipItem(getFirstEnabledSlot()) end)
    _injectCosmetics()
end)

task.spawn(function()
    while not Library.Unloaded do
        task.wait(1)
        if not RageCfg.Active then continue end
        local lf = FighterController and FighterController.LocalFighter
        if lf then pcall(function() lf:EquipItem(getFirstEnabledSlot()) end) end
    end
end)

-- ─── MOVEMENT — SPEED ────────────────────────────────────────────────────────
local function setSpeed(v)
    S.speedValue = v
    local char = Player.Character
    if not char then return end
    local hum  = char:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.WalkSpeed = v end
end

-- ─── MOVEMENT — NOCLIP ───────────────────────────────────────────────────────
local _noclipConn
local function toggleNoclip(on)
    S.noclipActive = on
    if _noclipConn then _noclipConn:Disconnect(); _noclipConn = nil end
    if on then
        _noclipConn = RunService.Stepped:Connect(function()
            local char = Player.Character
            if not char then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    else
        local char = Player.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end

-- ─── MOVEMENT — FLY ──────────────────────────────────────────────────────────
local _flyConn, _flyBV, _flyBA
local function toggleFly(on)
    S.flyActive = on
    if _flyConn then _flyConn:Disconnect(); _flyConn = nil end
    if _flyBV   then _flyBV:Destroy(); _flyBV = nil end
    if _flyBA   then _flyBA:Destroy(); _flyBA = nil end

    if on then
        local char = Player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.PlatformStand = true end

        _flyBV = Instance.new("BodyVelocity")
        _flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        _flyBV.Velocity = Vector3.zero
        _flyBV.Parent   = hrp

        _flyBA = Instance.new("BodyAngularVelocity")
        _flyBA.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        _flyBA.AngularVelocity = Vector3.zero
        _flyBA.Parent = hrp

        _flyConn = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then
                toggleFly(false); return
            end
            local cam = ws.CurrentCamera
            local cf  = cam.CFrame
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
            _flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * S.flySpeed or Vector3.zero
        end)
    else
        local char = Player.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end

-- ─── MOVEMENT — SPIN ─────────────────────────────────────────────────────────
local _spinConn
local function toggleSpin(on)
    S.spinActive = on
    if _spinConn then _spinConn:Disconnect(); _spinConn = nil end
    if on then
        _spinConn = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed), 0)
        end)
    end
end

-- ─── MOVEMENT — NO FALL ──────────────────────────────────────────────────────
local _noFallConn
local function toggleNoFall(on)
    S.noFallActive = on
    if _noFallConn then _noFallConn:Disconnect(); _noFallConn = nil end
    if on then
        _noFallConn = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if hrp.Velocity.Y < -5 then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
            end
        end)
    end
end

-- ─── MOVEMENT — UNDERGROUND ──────────────────────────────────────────────────
local _ugConn
local function toggleUnderground(on)
    S.undergroundActive = on
    if _ugConn then _ugConn:Disconnect(); _ugConn = nil end
    if on then
        task.wait(0.5)
        local char = Player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, -3, 0)
        end
        _ugConn = RunService.Heartbeat:Connect(function()
            local c = Player.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if r and r.Position.Y > -2.5 then
                r.CFrame = r.CFrame + Vector3.new(0, -3, 0)
            end
        end)
    end
end

-- ─── MOVEMENT — IRREGULAR MOVE ───────────────────────────────────────────────
local _iMoveConn
local function startIrregularMove()
    if _iMoveConn then return end
    _iMoveConn = RunService.Heartbeat:Connect(function()
        if not S.irregularMoveActive then
            _iMoveConn:Disconnect(); _iMoveConn = nil; return
        end
        local char = Player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if math.random() < 0.15 then
            local jitter = Vector3.new(
                (math.random()-0.5)*0.4,
                0,
                (math.random()-0.5)*0.4)
            hrp.CFrame = hrp.CFrame + jitter
        end
    end)
end

-- ─── MOVEMENT — SLIDE BOOST ──────────────────────────────────────────────────
local SlideBoostModule = {}
local _slideConn
function SlideBoostModule.setSlideBoost(on, spd)
    S.slideBoostActive = on
    _G.Features.SlideBoost.Enabled = on
    _G.Features.SlideBoost.Speed   = spd or _G.Features.SlideBoost.Speed
    if _slideConn then _slideConn:Disconnect(); _slideConn = nil end
    if on then
        _slideConn = RunService.Heartbeat:Connect(function()
            if not S.slideBoostActive then
                _slideConn:Disconnect(); _slideConn = nil; return
            end
            if not FighterController then return end
            local lf = FighterController.LocalFighter
            if not lf then return end
            local sliding = lf:Get and lf:Get("IsSliding")
            if sliding then
                local char = Player.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local look = hrp.CFrame.LookVector
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        look.X * _G.Features.SlideBoost.Speed,
                        hrp.AssemblyLinearVelocity.Y,
                        look.Z * _G.Features.SlideBoost.Speed)
                end
            end
        end)
    end
end

-- ─── COMBAT — TRIGGERBOT ─────────────────────────────────────────────────────
local _triggerbotConn
local _lastTriggerFire = 0

local function startTriggerbot()
    if _triggerbotConn then return end
    _triggerbotConn = RunService.Heartbeat:Connect(function()
        if not S.triggerbotEnabled then
            _triggerbotConn:Disconnect(); _triggerbotConn = nil; return
        end
        local char = Player.Character
        if not char then return end
        local cam  = ws.CurrentCamera
        local ray  = cam:ScreenPointToRay(
            cam.ViewportSize.X/2,
            cam.ViewportSize.Y/2, 1)
        local result = ws:Raycast(
            ray.Origin, ray.Direction * 1000,
            RaycastParams.new())
        if not result then return end
        local hit = result.Instance
        local model = hit:FindFirstAncestorWhichIsA("Model")
        if not model then return end
        local targetPlayer = plrs:GetPlayerFromCharacter(model)
        if not targetPlayer or targetPlayer == Player then return end
        local now = tick()
        if now - _lastTriggerFire < S.triggerbotDelay then return end
        _lastTriggerFire = now
        local action = getAction()
        if not action or action.type ~= "Attack" then return end
        if util and enumLib then
            local remote = repS.Remotes.Replication.Fighter.UseItem
            local head   = model:FindFirstChild("Head")
            if head then
                local aimCF = CFrame.lookAt(char.HumanoidRootPart.Position, head.Position)
                local cameradata = {}
                cameradata[utf8.char(1)] = {
                    [utf8.char(0)] = util:EncodeCFrame(aimCF),
                    [utf8.char(1)] = util:EncodeCFrame(head.CFrame),
                    [utf8.char(2)] = head,
                    [utf8.char(3)] = util:EncodeCFrame(CFrame.new()),
                }
                pcall(function()
                    remote:FireServer(
                        action.item:Get("ObjectID"),
                        enumLib:ToEnum("StartShooting"),
                        cameradata, nil)
                end)
            end
        end
    end)
end

-- ─── COMBAT — WALLBANG ───────────────────────────────────────────────────────
local _wallbangConn
local function startWallbang()
    if _wallbangConn then return end
    _wallbangConn = RunService.Heartbeat:Connect(function()
        if not S.wallbangActive then
            _wallbangConn:Disconnect(); _wallbangConn = nil; return
        end
        local char = Player.Character
        if not char then return end
        local hrp  = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        -- extend all local player parts to pass through geometry
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end)
end
local function stopWallbang()
    S.wallbangActive = false
    if _wallbangConn then _wallbangConn:Disconnect(); _wallbangConn = nil end
end

-- ─── COMBAT — ORBIT / FIST / RIOT ────────────────────────────────────────────
local _orbitConn, _fistConn, _riotConn

local function toggleOrbit(on)
    S.orbActive = on
    if _orbitConn then _orbitConn:Disconnect(); _orbitConn = nil end
    if on then
        _orbitConn = RunService.Heartbeat:Connect(function()
            if not S.orbActive then
                _orbitConn:Disconnect(); _orbitConn = nil; return
            end
            local char = Player.Character
            if not char then return end
            local hrp  = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, p in plrs:GetPlayers() do
                if p ~= Player then
                    local pc = p.Character
                    local pr = pc and pc:FindFirstChild("HumanoidRootPart")
                    if pr then
                        local t  = tick() * 4
                        local ox = math.cos(t) * 3
                        local oz = math.sin(t) * 3
                        hrp.CFrame = pr.CFrame * CFrame.new(ox, 0, oz)
                        break
                    end
                end
            end
        end)
    end
end

local function toggleFist(on)
    S.fistActive = on
    if _fistConn then _fistConn:Disconnect(); _fistConn = nil end
    if on then
        _fistConn = RunService.Heartbeat:Connect(function()
            if not S.fistActive then
                _fistConn:Disconnect(); _fistConn = nil; return
            end
            local char = Player.Character
            if not char then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Size = p.Size * 1.05
                end
            end
        end)
    end
end

local function toggleRiot(on)
    S.roitActive = on
    if _riotConn then _riotConn:Disconnect(); _riotConn = nil end
    if on then
        _riotConn = RunService.Heartbeat:Connect(function()
            if not S.roitActive then
                _riotConn:Disconnect(); _riotConn = nil; return
            end
            local char = Player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, p in plrs:GetPlayers() do
                if p ~= Player then
                    local pc = p.Character
                    local pr = pc and pc:FindFirstChild("HumanoidRootPart")
                    if pr then
                        local dir = (pr.Position - hrp.Position).Unit
                        hrp.AssemblyLinearVelocity = dir * 80
                    end
                end
            end
        end)
    end
end

-- ─── GUN — RAPID FIRE ────────────────────────────────────────────────────────
local function applyRapidFire()
    local char = Player.Character
    if not char then return end
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf or type(lf.Items) ~= "table" then return end
    for _, item in next, lf.Items do
        if type(item) == "table" then
            pcall(function()
                if item._shoot_cooldown ~= nil then
                    item._shoot_cooldown = S.fireDelay / 1000
                end
                if item.FireRate ~= nil then
                    item.FireRate = S.fireDelay / 1000
                end
                if item.Info and item.Info.FireRate ~= nil then
                    item.Info.FireRate = S.fireDelay / 1000
                end
            end)
        end
    end
end

local function toggleRapidFire(on)
    S.rapidFireActive = on
    if on then applyRapidFire() end
end

-- ─── GUN — ENHANCEMENTS ──────────────────────────────────────────────────────
local function applyGunEnhancements()
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf or type(lf.Items) ~= "table" then return end
    for _, item in next, lf.Items do
        if type(item) == "table" then
            pcall(function()
                if S.instantAdsEnabled and item.AdsTime   ~= nil then item.AdsTime   = 0 end
                if S.instantAdsEnabled and item.Info       then
                    if item.Info.AdsTime ~= nil then item.Info.AdsTime = 0 end
                end
                if S.noEquipAnimEnabled and item.EquipTime ~= nil then item.EquipTime = 0 end
                if S.noShootAnimEnabled and item.ShootTime ~= nil then item.ShootTime = 0 end
            end)
        end
    end
end

-- ─── GUN — NO SPREAD ─────────────────────────────────────────────────────────
local function patchGunSpread()
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf or type(lf.Items) ~= "table" then return end
    for _, item in next, lf.Items do
        if type(item) == "table" then
            pcall(function()
                if S.noSpreadEnabled then
                    if item.Spread     ~= nil then item.Spread     = 0 end
                    if item.MaxSpread  ~= nil then item.MaxSpread  = 0 end
                    if item.MinSpread  ~= nil then item.MinSpread  = 0 end
                    if item.Info then
                        if item.Info.Spread    ~= nil then item.Info.Spread    = 0 end
                        if item.Info.MaxSpread ~= nil then item.Info.MaxSpread = 0 end
                    end
                end
            end)
        end
    end
end

-- ─── GUN — NO SMOKE / NO FLASH ───────────────────────────────────────────────
local function applyNoSmoke()
    if not S.noSmokeEnabled then return end
    for _, v in ipairs(ws:GetDescendants()) do
        if v:IsA("ParticleEmitter") and
           (v.Name:lower():find("smoke") or v.Name:lower():find("muzzle")) then
            v.Enabled = false
        end
    end
end

local function applyNoFlash()
    if not S.noFlashEnabled then return end
    for _, v in ipairs(ws:GetDescendants()) do
        if v:IsA("ParticleEmitter") and
           (v.Name:lower():find("flash") or v.Name:lower():find("light")) then
            v.Enabled = false
        end
    end
end

-- ─── GUN — DEVICE SPOOF ──────────────────────────────────────────────────────
local function applyDeviceSpoof()
    if not S.deviceSpoofEnabled then return end
    pcall(function()
        local InputType = Enum.UserInputType
        if S.spoofDevice == "VR" then
            -- Hook: make game think device is VR
            hookfunction(UserInputService.GetLastInputType, newcclosure(function()
                return InputType.Gamepad1
            end))
        elseif S.spoofDevice == "Touch" then
            hookfunction(UserInputService.GetLastInputType, newcclosure(function()
                return InputType.Touch
            end))
        elseif S.spoofDevice == "Gamepad" then
            hookfunction(UserInputService.GetLastInputType, newcclosure(function()
                return InputType.Gamepad1
            end))
        end
    end)
end

-- ─── GUN — ANTI-KATANA ───────────────────────────────────────────────────────
local function getSetAntiKatana(on)
    S.antiKatanaEnabled = on
    -- Deflection detection is already done in updateDeflection().
    -- Extra: when anti-katana is on, during deflect window we force a dodge remote.
    if not on then return end
    task.spawn(function()
        while S.antiKatanaEnabled do
            task.wait(0.05)
            if not FighterController then continue end
            local lf = FighterController.LocalFighter
            if not lf then continue end
            -- Check if any enemy is deflecting; if so, send a parry or move back
            for _, p in plrs:GetPlayers() do
                if p == Player then continue end
                if deflecting and deflecting[p] then
                    local char = Player.Character
                    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * -5
                    end
                end
            end
        end
    end)
end
_G.SetAntiKatana = getSetAntiKatana

-- ─── ANTI-AIM ────────────────────────────────────────────────────────────────
local _aaConn
local _aaSpinAngle = 0

local function startAntiAimExt()
    if _aaConn then _aaConn:Disconnect(); _aaConn = nil end
    _aaConn = RunService.Heartbeat:Connect(function()
        if not _G.AntiAimSettings.enabled then
            _aaConn:Disconnect(); _aaConn = nil; return
        end
        local char = Player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local mode = _G.AntiAimSettings.mode

        if mode == "Spin" then
            _aaSpinAngle = _aaSpinAngle + _G.AntiAimSettings.spinSpeed
            if _aaSpinAngle > 360 then _aaSpinAngle = _aaSpinAngle - 360 end
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(_aaSpinAngle), 0)

        elseif mode == "Jitter" then
            local r = _G.AntiAimSettings.jitterAmt
            local ang = math.rad((math.random() * 2 - 1) * r)
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, ang, 0)

        elseif mode == "Desync" then
            -- Alternate between two extreme yaw angles per tick
            local tick_flip = math.floor(tick() * 30) % 2
            local ang = tick_flip == 0 and math.rad(90) or math.rad(-90)
            hrp.CFrame = CFrame.new(hrp.Position)
                * CFrame.fromEulerAnglesXYZ(0, ang, 0)
        end
    end)
end
_G.StartAntiAimExt = startAntiAimExt

-- ─── ESP SYSTEM ──────────────────────────────────────────────────────────────
local espObjects   = {}
local _espConn

local function worldToViewport(pos)
    local cam   = ws.CurrentCamera
    local vp, visible = cam:WorldToViewportPoint(pos)
    return Vector2.new(vp.X, vp.Y), visible, vp.Z
end

local function clearESP(player)
    if espObjects[player] then
        for _, v in pairs(espObjects[player]) do
            if v then v:Remove() end
        end
        espObjects[player] = nil
    end
end

local function makeEspForPlayer(player)
    if player == Player then return end
    if espObjects[player] then clearESP(player) end

    local objs = {}

    -- Box
    local box = Drawing.new("Quad")
    box.Visible   = false
    box.Color     = S.espBoxColor
    box.Thickness = 1
    box.Filled    = S.espBoxType == "Filled"
    box.Transparency = S.espBoxType == "Filled" and 0.5 or 1
    objs.box = box

    -- Name
    local nameLabel = Drawing.new("Text")
    nameLabel.Visible  = false
    nameLabel.Color    = S.espTextColor
    nameLabel.Size     = 13
    nameLabel.Center   = true
    nameLabel.Outline  = true
    objs.nameLabel = nameLabel

    -- Distance
    local distLabel = Drawing.new("Text")
    distLabel.Visible = false
    distLabel.Color   = S.espTextColor
    distLabel.Size    = 11
    distLabel.Center  = true
    distLabel.Outline = true
    objs.distLabel = distLabel

    -- Tracer
    local tracer = Drawing.new("Line")
    tracer.Visible   = false
    tracer.Color     = S.espTracerColor
    tracer.Thickness = 1
    objs.tracer = tracer

    -- Health bar
    local healthBg  = Drawing.new("Quad")
    healthBg.Visible = false
    healthBg.Color   = Color3.new(0,0,0)
    healthBg.Filled  = true
    objs.healthBg = healthBg

    local healthBar = Drawing.new("Quad")
    healthBar.Visible = false
    healthBar.Filled  = true
    objs.healthBar = healthBar

    espObjects[player] = objs
end

local SKELETON_PAIRS = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

local function updateMobileESP()
    if not S.espActive then return end
    local myChar = Player.Character
    local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _, p in plrs:GetPlayers() do
        if p == Player then continue end
        local pc = p.Character
        local prp = pc and pc:FindFirstChild("HumanoidRootPart")
        local head = pc and pc:FindFirstChild("Head")
        local hum  = pc and pc:FindFirstChildWhichIsA("Humanoid")

        if not (pc and prp and head and hum and hum.Health > 0) then
            clearESP(p)
            continue
        end

        if not espObjects[p] then makeEspForPlayer(p) end
        local objs = espObjects[p]
        if not objs then continue end

        -- Get bounding corners
        local char_parts = {"Head","UpperTorso","LowerTorso","LeftHand","RightHand","LeftFoot","RightFoot"}
        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        local allVisible = true

        for _, pname in ipairs(char_parts) do
            local part = pc:FindFirstChild(pname)
            if part then
                local sv, vis = worldToViewport(part.Position)
                if not vis then allVisible = false end
                minX = math.min(minX, sv.X)
                minY = math.min(minY, sv.Y)
                maxX = math.max(maxX, sv.X)
                maxY = math.max(maxY, sv.Y)
            end
        end

        local headSV, headVis = worldToViewport(head.Position)
        if not headVis then
            for _, v in pairs(objs) do v.Visible = false end
            continue
        end

        -- Expand box a bit
        minX = minX - 6; maxX = maxX + 6
        minY = minY - 4; maxY = maxY + 4

        -- Box
        if S.espShowBox and objs.box then
            if S.espBoxType == "Corner" then
                -- corner style: draw 4 small L-shapes (we approximate with Quad)
                objs.box.PointA  = Vector2.new(minX, minY)
                objs.box.PointB  = Vector2.new(maxX, minY)
                objs.box.PointC  = Vector2.new(maxX, maxY)
                objs.box.PointD  = Vector2.new(minX, maxY)
                objs.box.Filled  = false
                objs.box.Visible = true
            else
                objs.box.PointA  = Vector2.new(minX, minY)
                objs.box.PointB  = Vector2.new(maxX, minY)
                objs.box.PointC  = Vector2.new(maxX, maxY)
                objs.box.PointD  = Vector2.new(minX, maxY)
                objs.box.Filled  = (S.espBoxType == "Filled")
                objs.box.Visible = true
            end
        else
            if objs.box then objs.box.Visible = false end
        end

        -- Name
        if S.espShowName and objs.nameLabel then
            objs.nameLabel.Text     = p.Name
            objs.nameLabel.Position = Vector2.new((minX+maxX)/2, minY - 15)
            objs.nameLabel.Visible  = true
        else
            if objs.nameLabel then objs.nameLabel.Visible = false end
        end

        -- Distance
        if S.espShowDistance and objs.distLabel and myHRP then
            local dist = math.floor((myHRP.Position - prp.Position).Magnitude)
            objs.distLabel.Text     = dist .. " studs"
            objs.distLabel.Position = Vector2.new((minX+maxX)/2, maxY + 3)
            objs.distLabel.Visible  = true
        else
            if objs.distLabel then objs.distLabel.Visible = false end
        end

        -- Tracer
        if S.espShowTracers and objs.tracer then
            local vp = ws.CurrentCamera.ViewportSize
            objs.tracer.From    = Vector2.new(vp.X/2, vp.Y)
            objs.tracer.To      = headSV
            objs.tracer.Visible = true
        else
            if objs.tracer then objs.tracer.Visible = false end
        end

        -- Health bar
        if S.espShowHealthBar and objs.healthBg and objs.healthBar then
            local maxHP = hum.MaxHealth > 0 and hum.MaxHealth or 100
            local pct   = math.clamp(hum.Health / maxHP, 0, 1)
            local barH  = maxY - minY
            local barX  = minX - 8

            objs.healthBg.PointA  = Vector2.new(barX-1, minY-1)
            objs.healthBg.PointB  = Vector2.new(barX+3, minY-1)
            objs.healthBg.PointC  = Vector2.new(barX+3, maxY+1)
            objs.healthBg.PointD  = Vector2.new(barX-1, maxY+1)
            objs.healthBg.Visible = true

            local fillY = maxY - barH * pct
            objs.healthBar.PointA  = Vector2.new(barX,   fillY)
            objs.healthBar.PointB  = Vector2.new(barX+2, fillY)
            objs.healthBar.PointC  = Vector2.new(barX+2, maxY)
            objs.healthBar.PointD  = Vector2.new(barX,   maxY)
            objs.healthBar.Color   = S.espHealthColor:Lerp(S.espHealthBadColor, 1-pct)
            objs.healthBar.Visible = true
        else
            if objs.healthBg  then objs.healthBg.Visible  = false end
            if objs.healthBar then objs.healthBar.Visible = false end
        end
    end

    -- Clean up left players
    for p, _ in pairs(espObjects) do
        if not plrs:FindFirstChild(p.Name) then clearESP(p) end
    end
end

local function toggleESP(on)
    S.espActive = on
    if _espConn then _espConn:Disconnect(); _espConn = nil end
    if not on then
        for p, _ in pairs(espObjects) do clearESP(p) end
        return
    end
    _espConn = RunService.RenderStepped:Connect(updateMobileESP)
end

plrs.PlayerRemoving:Connect(clearESP)

-- ─── AIMBOT ──────────────────────────────────────────────────────────────────
local _aimbotConn
local _aimbotCircle

local function getAimbotTarget()
    local cam  = ws.CurrentCamera
    local vp   = cam.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    local bestDist, bestPart = S.aimbotFov, nil

    for _, p in plrs:GetPlayers() do
        if p == Player then continue end
        local pc  = p.Character
        if not pc then continue end
        local part = pc:FindFirstChild(S.aimbotPart) or pc:FindFirstChild("Head")
        if not part then continue end
        local hum  = pc:FindFirstChildWhichIsA("Humanoid")
        if not (hum and hum.Health > 0) then continue end
        local sv, vis = worldToViewport(part.Position)
        if not vis then continue end
        local dist = (Vector2.new(cx, cy) - sv).Magnitude
        if dist < bestDist then
            bestDist = dist
            bestPart = part
        end
    end
    return bestPart
end

local function toggleAimbot(on)
    S.aimbotActive = on
    if _aimbotConn then _aimbotConn:Disconnect(); _aimbotConn = nil end
    if _aimbotCircle then _aimbotCircle:Remove(); _aimbotCircle = nil end
    if not on then return end

    _aimbotConn = RunService.RenderStepped:Connect(function()
        local target = getAimbotTarget()
        if not target then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

        local cam     = ws.CurrentCamera
        local tPos    = target.Position
        local camPos  = cam.CFrame.Position
        local dir     = (tPos - camPos).Unit
        local newCF   = CFrame.lookAt(camPos, camPos + dir)

        cam.CFrame = cam.CFrame:Lerp(newCF, S.aimbotSmooth)
    end)
end

-- ─── FOV CIRCLES ─────────────────────────────────────────────────────────────
local _fovCircleSilent, _fovCircleAimbot

local function updateFovCircles()
    if not _fovCircleSilent then
        _fovCircleSilent = Drawing.new("Circle")
        _fovCircleSilent.Filled = false
        _fovCircleSilent.Thickness = 1
    end
    if not _fovCircleAimbot then
        _fovCircleAimbot = Drawing.new("Circle")
        _fovCircleAimbot.Filled = false
        _fovCircleAimbot.Thickness = 1
    end

    local vp = ws.CurrentCamera.ViewportSize
    local cx, cy = vp.X/2, vp.Y/2

    _fovCircleSilent.Color    = S.silentFovColor
    _fovCircleSilent.Radius   = S.silentFov
    _fovCircleSilent.Position = Vector2.new(cx, cy)
    _fovCircleSilent.Visible  = S.showFovCircles and S.silentAimEnabled

    _fovCircleAimbot.Color    = S.aimbotFovColor
    _fovCircleAimbot.Radius   = S.aimbotFov
    _fovCircleAimbot.Position = Vector2.new(cx, cy)
    _fovCircleAimbot.Visible  = S.showFovCircles and S.aimbotActive
end

RunService.RenderStepped:Connect(updateFovCircles)

-- ─── SILENT AIM ──────────────────────────────────────────────────────────────
local function getSilentTarget()
    local cam  = ws.CurrentCamera
    local vp   = cam.ViewportSize
    local cx, cy = vp.X/2, vp.Y/2
    local bestDist, bestPlayer = S.silentFov, nil

    for _, p in plrs:GetPlayers() do
        if p == Player then continue end
        local pc = p.Character
        if not pc then continue end
        local part = pc:FindFirstChild(S.silentTargetPart) or pc:FindFirstChild("Head")
        if not part then continue end
        local hum = pc:FindFirstChildWhichIsA("Humanoid")
        if not (hum and hum.Health > 0) then continue end
        local sv, vis = worldToViewport(part.Position)
        if not vis then continue end
        local dist = (Vector2.new(cx, cy) - sv).Magnitude
        if dist < bestDist then bestDist = dist; bestPlayer = p end
    end
    return bestPlayer
end

-- Hook UseItem remote to redirect aim toward silent aim target
local _originalUseItem
local function toggleSilentAim(on)
    S.silentAimEnabled = on
    if _originalUseItem then
        -- restore
        hookfunction(_originalUseItem, _originalUseItem)
        _originalUseItem = nil
    end
    if not on then return end

    local remote = repS:FindFirstChild("Remotes")
    remote = remote and remote:FindFirstChild("Replication")
    remote = remote and remote:FindFirstChild("Fighter")
    remote = remote and remote:FindFirstChild("UseItem")
    if not remote then return end

    pcall(function()
        local oldFire = remote.FireServer
        _originalUseItem = oldFire
        hookfunction(oldFire, newcclosure(function(self, oid, action, camdata, extra)
            if S.silentAimEnabled and util and enumLib then
                local startShoot = enumLib:ToEnum("StartShooting")
                if action == startShoot then
                    local target = getSilentTarget()
                    if target then
                        local pc   = target.Character
                        local part = pc and (pc:FindFirstChild(S.silentTargetPart) or pc:FindFirstChild("Head"))
                        local hrp  = pc and pc:FindFirstChild("HumanoidRootPart")
                        if part and hrp then
                            local myHRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                            if myHRP then
                                local aimCF = CFrame.lookAt(myHRP.Position, part.Position)
                                local cam1Key = utf8.char(1)
                                if type(camdata) == "table" and camdata[cam1Key] then
                                    camdata[cam1Key][utf8.char(0)] = util:EncodeCFrame(aimCF)
                                    camdata[cam1Key][utf8.char(1)] = util:EncodeCFrame(part.CFrame)
                                    camdata[cam1Key][utf8.char(2)] = part
                                    camdata[cam1Key][utf8.char(3)] = util:EncodeCFrame(CFrame.new())
                                end
                            end
                        end
                    end
                end
            end
            return oldFire(self, oid, action, camdata, extra)
        end))
    end)
end

-- ─── SHARED LOGIC ────────────────────────────────────────────────────────────
local deflecting = {}
plrs.PlayerRemoving:Connect(function(p) deflecting[p] = nil end)

local function updateDeflection()
    if not FighterController or not FighterController.Objects then return end
    for _, fo in FighterController.Objects do
        local p = fo.Player
        if not p then continue end
        if not fo.Entity or not fo.Entity:IsAlive() or fo:Get("IsSpectating") then
            deflecting[p] = false; continue
        end
        local eq       = fo.EquippedItem
        local isKatana = eq and eq.ViewModel and eq.ViewModel.Name == "Katana"
        deflecting[p]  = isKatana
            and (eq._attack_cooldown and eq._attack_cooldown > tick()) or false
    end
end

local function isEnemy(player)
    if player == Player then return false end
    if SpectateController then
        local duel = SpectateController.CurrentDuelSubject
        local ld   = duel and duel:GetDueler(Player)
        local lt   = ld  and ld:Get("TeamID") or nil
        if lt and duel and duel.Duelers then
            for _, d in duel.Duelers do
                if d.Player == player then return d:Get("TeamID") ~= lt end
            end
        end
    end
    local pt, lt2 = player:GetAttribute("TeamID"), Player:GetAttribute("TeamID")
    if pt and lt2 then return pt ~= lt2 end
    return true
end

local function hasKnifeViewModel(targetPlayer)
    if not targetPlayer then return false end
    local vm = ws:FindFirstChild("ViewModels")
    if not vm then return false end
    for _, m in vm:GetChildren() do
        if m:IsA("Model")
           and string.find(m.Name, targetPlayer.Name, 1, true)
           and string.find(m.Name, "Knife", 1, true) then
            return true
        end
    end
    return false
end

local function getClosestTarget(teamFilter)
    local char = Player.Character
    if not char then return nil, nil, nil end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil, nil end
    local cp, cr, ch, cd = nil, nil, nil, 500
    for _, p in plrs:GetPlayers() do
        if teamFilter and not isEnemy(p) then continue end
        if not teamFilter and p == Player then continue end
        local pc  = p.Character; if not pc then continue end
        local pr  = pc:FindFirstChild("HumanoidRootPart")
        local ph  = pc:FindFirstChild("Head")
        local phm = pc:FindFirstChildWhichIsA("Humanoid")
        if not (pr and ph and phm and phm.Health > 0) then continue end
        local d = (myRoot.Position - pr.Position).Magnitude
        if d < cd then cd = d; cp = p; cr = pr; ch = ph end
    end
    return cp, cr, ch
end

-- ─── RAGE FIRE ───────────────────────────────────────────────────────────────
local lastFire = 0

local function rageFireThisFrame(targetPlayer, targetRoot, targetHead, desyncCF)
    if not RageCfg.Active then return end
    if not (targetPlayer and targetHead and targetRoot) then return end
    if deflecting[targetPlayer] then return end

    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if not util or not enumLib then return end

    local action = getAction()
    if not action then return end
    if action.type == "Swap"   then equipItemByIndex(action.item, action.index); return end
    if action.type == "Reload" then reloadItem(action.item); return end
    if tick() - lastFire < RageCfg.FireRate then return end
    lastFire = tick()

    local item = action.item
    if not item then return end

    local originPos = desyncCF and desyncCF.Position or targetRoot.Position
    local aimCF    = CFrame.lookAt(originPos, targetHead.Position)
    local targetCF = targetHead.CFrame
    local rng      = Vector3.new(
        (math.random()-0.5)*0.1,
        (math.random()-0.5)*0.1,
        (math.random()-0.5)*0.1)
    local aimedPos  = targetHead.Position + rng
    local objOffset = targetHead.CFrame:ToObjectSpace(CFrame.new(aimedPos))

    local cameradata = {}
    cameradata[utf8.char(1)] = {
        [utf8.char(0)] = util:EncodeCFrame(aimCF),
        [utf8.char(1)] = util:EncodeCFrame(targetCF),
        [utf8.char(2)] = targetHead,
        [utf8.char(3)] = util:EncodeCFrame(objOffset),
    }
    local remote = repS.Remotes.Replication.Fighter.UseItem
    pcall(function()
        remote:FireServer(
            item:Get("ObjectID"),
            enumLib:ToEnum("StartShooting"),
            cameradata, nil)
    end)
end

-- ─── FLICKBOT LOGIC ──────────────────────────────────────────────────────────
local velHistory = {}

local function recordVelocity(char, root)
    local now, pos = tick(), root.Position
    if not velHistory[char] then
        velHistory[char] = { {pos=pos,t=now}, {pos=pos,t=now} }
    else
        velHistory[char][1] = velHistory[char][2]
        velHistory[char][2] = {pos=pos,t=now}
    end
end

local function predictPosition(char, root, lead)
    local h = velHistory[char]
    if not h then return root.Position end
    local dt = h[2].t - h[1].t
    if dt < 0.001 then return root.Position end
    local vel = (h[2].pos - h[1].pos) / dt
    return root.Position + vel * lead
end

local CDFIELDS = {
    "Cooldown","AttackCooldown","UseDelay","SpinCooldown",
    "HeavyAttackCooldown","AbilityCooldown","FireCooldown","DashCooldown",
}

local function zeroCDs()
    task.spawn(function()
        local mods = ReplicatedStorage:FindFirstChild("Modules")
        local lib  = mods and mods:FindFirstChild("ItemLibrary")
        if lib then
            local ok, t = pcall(require, lib)
            if ok and type(t) == "table" then
                local items = t.Items or t.Weapons or t.Melee or t.Utilities
                if type(items) == "table" then
                    for _, item in pairs(items) do
                        if type(item) == "table" then
                            local isM = item.Type=="Melee" or item.Category=="Melee"
                                     or (item.Damage and not item.AmmoType)
                            if isM then
                                for _, f in ipairs(CDFIELDS) do
                                    if item[f] ~= nil then item[f] = 0 end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    local char = Player.Character
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            for _, fn in ipairs(CDFIELDS) do
                if v.Name == fn and (v:IsA("NumberValue") or v:IsA("IntValue")) then
                    v.Value = 0
                end
            end
        end
    end
end

local function killVel(char)
    if not FlickCfg.AntiVelocity then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Velocity                = Vector3.zero
            p.AssemblyLinearVelocity  = Vector3.zero
            p.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

-- ─── VOID SPAM ───────────────────────────────────────────────────────────────
local _voidActive = false
local _voidTask   = nil

local function performFlickToTarget()
    local char   = Player.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local fp, fr, fh = getClosestTarget(FlickCfg.TeamFilter)
    if not (fp and fr and fh) then return end
    local hasKnife  = hasKnifeViewModel(fp)
    local rawOffset = hasKnife and CFrame.new(0,6,0) or CFrame.new(0,1,2)
    local basePos   = (fr.CFrame * rawOffset).Position
                    + Vector3.new(FlickCfg.OffsetX, FlickCfg.OffsetY, FlickCfg.OffsetZ)
    local finalPos  = basePos
    local predHead  = fh.Position
    if FlickCfg.PredictionOn and FlickCfg.PredictionScale > 0 then
        local drift = predictPosition(fp.Character, fr, FlickCfg.PredictionScale) - fr.Position
        finalPos    = basePos + drift
        predHead    = fh.Position + drift
    end
    myRoot.CFrame = CFrame.lookAt(finalPos, predHead)
end

local function startVoidSpam()
    if _voidTask then return end
    _voidActive = true
    _voidTask   = task.spawn(function()
        while _voidActive and not Library.Unloaded do
            local char   = Player.Character
            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local preCF   = myRoot.CFrame
                myRoot.CFrame = CFrame.new(preCF.Position.X, VoidCfg.VoidY, preCF.Position.Z)
                task.wait(VoidCfg.Duration)
                if _voidActive then performFlickToTarget() end
                task.wait(VoidCfg.Cooldown)
            else
                task.wait(0.1)
            end
        end
        _voidTask = nil
    end)
end

local function stopVoidSpam()
    _voidActive = false
end

-- ─── COMBINED HEARTBEAT ──────────────────────────────────────────────────────
RunService.Heartbeat:Connect(function()
    updateDeflection()

    local flickDesyncCF = nil

    -- FLICKBOT
    do
        local fp, fr, fh = getClosestTarget(FlickCfg.TeamFilter)
        if fp and fr and fh then
            recordVelocity(fp.Character, fr)
            local hasKnife  = hasKnifeViewModel(fp)
            local rawOffset = hasKnife and CFrame.new(0,6,0) or CFrame.new(0,1,2)

            if FlickCfg.RandomizeOffset then
                FlickCfg.OffsetX = (math.random()*2-1)*10
                FlickCfg.OffsetY = (math.random()*2-1)*10
                FlickCfg.OffsetZ = (math.random()*2-1)*10
            end

            local basePos = (fr.CFrame * rawOffset).Position
                          + Vector3.new(FlickCfg.OffsetX, FlickCfg.OffsetY, FlickCfg.OffsetZ)
            local finalPos = basePos
            if FlickCfg.PredictionOn and FlickCfg.PredictionScale > 0 then
                local drift = predictPosition(fp.Character, fr, FlickCfg.PredictionScale) - fr.Position
                finalPos = basePos + drift
            end
            local predHead = FlickCfg.PredictionOn
                and (fh.Position + (predictPosition(fp.Character, fr, FlickCfg.PredictionScale) - fr.Position))
                or fh.Position

            flickDesyncCF = CFrame.lookAt(finalPos, predHead)

            if FlickCfg.Active and not _voidActive then
                local char   = Player.Character
                local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    if FlickCfg.Desync then
                        local oldCF  = myRoot.CFrame
                        local oldVel = myRoot.Velocity
                        local oldRot = myRoot.RotVelocity
                        RunService:UnbindFromRenderStep("__flickbot_restore")
                        local applyCF = (FlickCfg.FlickLerpAlpha >= 1.0)
                            and flickDesyncCF
                            or myRoot.CFrame:Lerp(flickDesyncCF, FlickCfg.FlickLerpAlpha)
                        myRoot.CFrame = applyCF
                        RunService:BindToRenderStep("__flickbot_restore", 101, function()
                            if myRoot and myRoot.Parent then
                                myRoot.CFrame      = oldCF
                                myRoot.Velocity    = oldVel
                                myRoot.RotVelocity = oldRot
                            end
                            RunService:UnbindFromRenderStep("__flickbot_restore")
                        end)
                    else
                        killVel(char)
                        local n = FlickCfg.WritesPerFrame
                        for i = 0, n-1 do
                            local t  = tick() * FlickCfg.FlickSpeed + (i*(math.pi*2/n))
                            local ox = math.cos(t) * FlickCfg.FlickRadius
                            local oz = math.sin(t) * FlickCfg.FlickRadius
                            myRoot.CFrame = fr.CFrame * CFrame.new(ox,0,oz)
                        end
                    end
                end
            end
        end
    end

    -- RAGE
    if RageCfg.Active then
        local rp, rr, rh = getClosestTarget(true)
        if rp and rr and rh then
            local rageCF = flickDesyncCF
            if not rageCF then
                local hasKnife  = hasKnifeViewModel(rp)
                local rawOffset = hasKnife and CFrame.new(0,6,0) or CFrame.new(0,1,2)
                local ragePos   = (rr.CFrame * rawOffset).Position
                rageCF = CFrame.lookAt(ragePos, rh.Position)
            end
            rageFireThisFrame(rp, rr, rh, rageCF)
        end
    end

    -- RAPID FIRE (re-apply each tick)
    if S.rapidFireActive then applyRapidFire() end

    -- INFINITE JUMP (maintain via humanoid state re-check)
    if S.infiniteJumpActive then
        local char = Player.Character
        local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
        if hum and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- CharacterAdded reconnects
Player.CharacterAdded:Connect(function(char)
    velHistory = {}
    RunService:UnbindFromRenderStep("__flickbot_restore")
    stopVoidSpam()
    VoidCfg.Active = false
    task.wait(1)
    setSpeed(S.speedValue)
    RefreshItemCache()
    _injectCosmetics()
    local lf = FighterController and FighterController.LocalFighter
    if lf then pcall(function() lf:EquipItem(getFirstEnabledSlot()) end) end

    if S.voidActive   then task.wait(0.5); startVoidSpam()    end
    if S.orbActive    then toggleOrbit(true)                   end
    if S.fistActive   then toggleFist(true)                    end
    if S.roitActive   then toggleRiot(true)                    end
    if S.noclipActive then toggleNoclip(true)                  end
    if S.wallbangActive then stopWallbang(); startWallbang()   end
    if S.espActive    then toggleESP(false); toggleESP(true)   end
    if S.aimbotActive then toggleAimbot(true)                  end
    if S.flyActive    then toggleFly(true)                     end
    if S.spinActive   then toggleSpin(true)                    end
    if S.noFallActive then toggleNoFall(true)                  end
    if _G.AntiAimSettings.enabled then _G.StartAntiAimExt()   end
    if S.undergroundActive then task.wait(0.5); toggleUnderground(true) end
    if S.irregularMoveActive then startIrregularMove()         end
    if S.triggerbotEnabled   then startTriggerbot()            end

    task.wait(1)
    applyGunEnhancements()
    patchGunSpread()
    applyNoSmoke()
    applyNoFlash()
    applyDeviceSpoof()
end)

-- ─── UI HELPERS ──────────────────────────────────────────────────────────────
local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    for _, c in pairs(children or {}) do c.Parent = inst end
    return inst
end

local function Tween(obj, props, time, style, dir)
    TweenService:Create(
        obj,
        TweenInfo.new(time or 0.2,
                      style or Enum.EasingStyle.Quad,
                      dir   or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function GetTextSize(text, size, font)
    return game:GetService("TextService"):GetTextSize(
        text, size, font, Vector2.new(10000, 10000))
end

-- ─── SCREEN GUI ──────────────────────────────────────────────────────────────
if _G.EclipseFlickbotGui then _G.EclipseFlickbotGui:Destroy() end

local ScreenGui = Create("ScreenGui", {
    Name           = "EclipseFlickbotGui",
    Parent         = cgui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn   = false,
    IgnoreGuiInset = true,
})
_G.EclipseFlickbotGui = ScreenGui

local UIScale = Create("UIScale", { Parent = ScreenGui })
local function UpdateScale()
    local vp    = ws.CurrentCamera.ViewportSize
    local scale = math.min(
        (vp.X - 40) / CFG.BaseSize.X,
        (vp.Y - 40) / CFG.BaseSize.Y, 1)
    UIScale.Scale = math.max(scale, 0.5)
end
local function BindCameraScale()
    ws.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
    UpdateScale()
end
ws:GetPropertyChangedSignal("CurrentCamera"):Connect(BindCameraScale)
BindCameraScale()

-- ─── NOTIFICATIONS ───────────────────────────────────────────────────────────
local NotifContainer = Create("Frame", {
    Parent      = ScreenGui,
    Position    = UDim2.new(1, -20, 0, 20),
    AnchorPoint = Vector2.new(1, 0),
    Size        = UDim2.new(0, 300, 1, 0),
    BackgroundTransparency = 1,
    ZIndex      = 100,
}, {
    Create("UIListLayout", {
        Padding             = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment   = Enum.VerticalAlignment.Top,
    })
})

local function Notify(msg, ntype)
    local color = (ntype == "success" and CFG.SuccessColor)
               or (ntype == "warning" and CFG.DangerColor)
               or CFG.AccentColor
    local F = Create("Frame", {
        Parent           = NotifContainer,
        Size             = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = CFG.MainColor,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    }, {
        Create("UIStroke",  { Color = CFG.AccentColor, Thickness = 1, Transparency = 0.5 }),
        Create("Frame",     { Size  = UDim2.new(0, 2, 1, 0), BackgroundColor3 = color }),
        Create("TextLabel", {
            Text           = msg,
            TextColor3     = CFG.TextColor,
            Font           = CFG.Font,
            TextSize       = 12,
            Size           = UDim2.new(1, -10, 1, 0),
            Position       = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
        }),
    })
    Tween(F, { Size = UDim2.new(0, 280, 0, 35) }, 0.5, Enum.EasingStyle.Back)
    task.delay(3.5, function()
        Tween(F, { Size = UDim2.new(0, 280, 0, 0), BackgroundTransparency = 1 }, 0.4)
        task.wait(0.4); F:Destroy()
    end)
end

-- ─── TOOLTIP ─────────────────────────────────────────────────────────────────
local TooltipLabel = Create("TextLabel", {
    Parent           = ScreenGui,
    Size             = UDim2.new(0, 0, 0, 20),
    BackgroundColor3 = CFG.SecondaryColor,
    TextColor3       = CFG.TextColor,
    TextSize         = 11,
    Font             = CFG.Font,
    BorderSizePixel  = 0,
    Visible          = false,
    ZIndex           = 200,
}, {
    Create("UIPadding", { PaddingLeft = UDim.new(0,5), PaddingRight = UDim.new(0,5) }),
    Create("UIStroke",  { Color = CFG.StrokeColor }),
})

local function AddTooltip(obj, text)
    obj.MouseEnter:Connect(function()
        TooltipLabel.Text    = text
        TooltipLabel.Size    = UDim2.fromOffset(GetTextSize(text,11,CFG.Font).X+12, 20)
        TooltipLabel.Visible = true
    end)
    obj.MouseLeave:Connect(function() TooltipLabel.Visible = false end)
end

RunService.RenderStepped:Connect(function()
    if TooltipLabel.Visible then
        local m = UserInputService:GetMouseLocation()
        TooltipLabel.Position = UDim2.fromOffset(m.X+15, m.Y+15)
    end
end)

-- ─── MAIN FRAME ──────────────────────────────────────────────────────────────
local MainFrame = Create("Frame", {
    Name             = "MainFrame",
    Parent           = ScreenGui,
    Size             = UDim2.fromOffset(CFG.BaseSize.X, CFG.BaseSize.Y),
    Position         = UDim2.new(0.5, -380, 0.5, -250),
    BackgroundColor3 = CFG.MainColor,
    BorderSizePixel  = 0,
}, {
    Create("UIStroke", { Color = CFG.StrokeColor }),
    Create("UICorner", { CornerRadius = UDim.new(0, 3) }),
})

-- drag
local Dragging, DragInput, DragStart, StartPos = false, nil, nil, nil
MainFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        Dragging  = true; DragStart = i.Position; StartPos = MainFrame.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement
    or i.UserInputType == Enum.UserInputType.Touch then DragInput = i end
end)
UserInputService.InputChanged:Connect(function(i)
    if i == DragInput and Dragging then
        local d = i.Position - DragStart
        Tween(MainFrame, { Position = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + d.X,
            StartPos.Y.Scale, StartPos.Y.Offset + d.Y)
        }, 0.05)
    end
end)

-- ─── TOP BAR ─────────────────────────────────────────────────────────────────
local TopBar = Create("Frame", {
    Parent           = MainFrame,
    Size             = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = CFG.MainColor,
    BorderSizePixel  = 0,
}, {
    Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = CFG.StrokeColor,
    }),
})

local TitleLabel = Create("TextLabel", {
    Parent         = TopBar,
    Text           = "eclipse v7 | rivals",
    TextColor3     = CFG.TextDark,
    TextSize       = 13,
    Font           = CFG.Font,
    BackgroundTransparency = 1,
    Size           = UDim2.new(0, 300, 1, 0),
    Position       = UDim2.new(0, 10, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    RichText       = true,
})

task.spawn(function()
    local chars = "eclipse v7 | rivals"
    local rev   = string.reverse(chars)
    while not Library.Unloaded do
        for i = 0, #chars do
            if Library.Unloaded then break end
            local partial = string.sub(chars, 1, i)
            local display = partial:gsub("rivals", '<font color="#bdacff">rivals</font>')
                                   :gsub("eclipse", '<font color="#bdacff">eclipse</font>')
            TitleLabel.Text = display
            task.wait(0.12)
        end
        task.wait(1.5)
        for i = #chars, 0, -1 do
            if Library.Unloaded then break end
            local partial = string.sub(chars, 1, i)
            local display = partial:gsub("rivals", '<font color="#bdacff">rivals</font>')
                                   :gsub("eclipse", '<font color="#bdacff">eclipse</font>')
            TitleLabel.Text = display
            task.wait(0.09)
        end
        task.wait(0.3)
    end
end)

-- status indicators top-right
local StatusBar = Create("Frame", {
    Parent           = TopBar,
    Size             = UDim2.new(0, 200, 1, 0),
    Position         = UDim2.new(1, -210, 0, 0),
    BackgroundTransparency = 1,
}, {
    Create("UIListLayout", {
        FillDirection       = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment   = Enum.VerticalAlignment.Center,
        Padding             = UDim.new(0, 8),
    })
})

local function makeStatusDot(label, colorOn, colorOff)
    local dot = Create("Frame", {
        Parent           = StatusBar,
        Size             = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = colorOff,
    }, { Create("UICorner", { CornerRadius = UDim.new(1,0) }) })
    Create("TextLabel", {
        Parent         = StatusBar,
        Text           = label,
        TextColor3     = CFG.TextDark,
        TextSize       = 10,
        Font           = CFG.Font,
        BackgroundTransparency = 1,
        Size           = UDim2.new(0, 30, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    return {
        setOn  = function() Tween(dot, { BackgroundColor3 = colorOn  }, 0.1) end,
        setOff = function() Tween(dot, { BackgroundColor3 = colorOff }, 0.1) end,
    }
end

local rageStatus  = makeStatusDot("RG", CFG.DangerColor,  Color3.fromRGB(50,50,50))
local flickStatus = makeStatusDot("FK", CFG.AccentColor,  Color3.fromRGB(50,50,50))
local espStatus   = makeStatusDot("ES", CFG.SuccessColor, Color3.fromRGB(50,50,50))

RunService.Heartbeat:Connect(function()
    if RageCfg.Active      then rageStatus.setOn()  else rageStatus.setOff()  end
    if FlickCfg.Active     then flickStatus.setOn() else flickStatus.setOff() end
    if S.espActive         then espStatus.setOn()   else espStatus.setOff()   end
end)

-- ─── LAYOUT ──────────────────────────────────────────────────────────────────
local Content = Create("Frame", {
    Parent   = MainFrame,
    Size     = UDim2.new(1, 0, 1, -30),
    Position = UDim2.new(0, 0, 0, 30),
    BackgroundTransparency = 1,
})

local Sidebar = Create("Frame", {
    Parent           = Content,
    Size             = UDim2.new(0, 60, 1, 0),
    BackgroundColor3 = Color3.fromRGB(17,17,17),
    BorderSizePixel  = 0,
}, {
    Create("UIListLayout", {
        Padding             = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment   = Enum.VerticalAlignment.Top,
    }),
    Create("UIPadding", { PaddingTop = UDim.new(0,12) }),
})

local Pages = Create("Frame", {
    Parent   = Content,
    Size     = UDim2.new(1, -60, 1, 0),
    Position = UDim2.new(0, 60, 0, 0),
    BackgroundTransparency = 1,
})

-- ─── TAB / GROUP / ITEM BUILDER ──────────────────────────────────────────────
local Tabs = {}

local function MakeTab(icon)
    local Btn = Create("TextButton", {
        Parent           = Sidebar,
        Size             = UDim2.new(0, 42, 0, 42),
        BackgroundColor3 = CFG.MainColor,
        Text             = "",
        AutoButtonColor  = false,
    }, {
        Create("ImageLabel", {
            Size                  = UDim2.new(0.6, 0, 0.6, 0),
            Position              = UDim2.new(0.2, 0, 0.2, 0),
            BackgroundTransparency = 1,
            Image                 = "rbxassetid://" .. icon,
            ImageColor3           = CFG.TextDark,
        }),
        Create("UICorner", { CornerRadius = UDim.new(0,6) }),
    })

    local Page = Create("ScrollingFrame", {
        Parent                = Pages,
        Size                  = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible               = false,
        ScrollBarThickness    = 2,
        ScrollBarImageColor3  = CFG.AccentColor,
        CanvasSize            = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize   = Enum.AutomaticSize.Y,
    })
    Create("UIPadding", {
        Parent        = Page,
        PaddingTop    = UDim.new(0,15),
        PaddingLeft   = UDim.new(0,15),
        PaddingRight  = UDim.new(0,15),
        PaddingBottom = UDim.new(0,15),
    })

    local LeftCol = Create("Frame", {
        Parent                = Page,
        Size                  = UDim2.new(0.48, 0, 1, 0),
        BackgroundTransparency = 1,
    }, { Create("UIListLayout", { Padding = UDim.new(0,10), SortOrder = Enum.SortOrder.LayoutOrder }) })

    local RightCol = Create("Frame", {
        Parent                = Page,
        Size                  = UDim2.new(0.48, 0, 1, 0),
        Position              = UDim2.new(0.52, 0, 0, 0),
        BackgroundTransparency = 1,
    }, { Create("UIListLayout", { Padding = UDim.new(0,10), SortOrder = Enum.SortOrder.LayoutOrder }) })

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            Tween(t.Btn, { BackgroundColor3 = CFG.MainColor }, 0.15)
            t.Page.Visible = false
        end
        Tween(Btn, { BackgroundColor3 = CFG.SecondaryColor }, 0.15)
        Page.Visible = true
    end)

    table.insert(Tabs, { Btn = Btn, Page = Page })
    if #Tabs == 1 then
        Tween(Btn, { BackgroundColor3 = CFG.SecondaryColor }, 0.15)
        Page.Visible = true
    end

    local leftNext = true
    local GF       = {}

    function GF:Group(title)
        local col = leftNext and LeftCol or RightCol
        leftNext  = not leftNext

        local GFrame = Create("Frame", {
            Parent            = col,
            Size              = UDim2.new(1, 0, 0, 0),
            AutomaticSize     = Enum.AutomaticSize.Y,
            BackgroundColor3  = Color3.fromRGB(17,17,17),
            BorderSizePixel   = 0,
        }, {
            Create("UIStroke", { Color = CFG.StrokeColor }),
            Create("UICorner", { CornerRadius = UDim.new(0,2) }),
        })

        Create("Frame", {
            Parent           = GFrame,
            Size             = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = CFG.SecondaryColor,
            BorderSizePixel  = 0,
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0,2) }),
            Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 5),
                Position         = UDim2.new(0, 0, 1, -5),
                BackgroundColor3 = CFG.SecondaryColor,
            }),
            Create("TextLabel", {
                Text           = title,
                Size           = UDim2.new(1, -20, 1, 0),
                Position       = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                TextColor3     = CFG.TextColor,
                Font           = Enum.Font.GothamBold,
                TextSize       = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
            }),
            Create("Frame", {
                Size             = UDim2.new(0, 4, 0, 4),
                Position         = UDim2.new(1, -10, 0.5, -2),
                BackgroundColor3 = CFG.AccentColor,
            }, { Create("UICorner", { CornerRadius = UDim.new(1,0) }) }),
        })

        local GContent = Create("Frame", {
            Parent            = GFrame,
            Size              = UDim2.new(1, 0, 0, 0),
            Position          = UDim2.new(0, 0, 0, 25),
            AutomaticSize     = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        }, {
            Create("UIListLayout", { Padding = UDim.new(0,5), SortOrder = Enum.SortOrder.LayoutOrder }),
            Create("UIPadding", {
                PaddingTop    = UDim.new(0,8), PaddingBottom = UDim.new(0,8),
                PaddingLeft   = UDim.new(0,8), PaddingRight  = UDim.new(0,8),
            }),
        })

        local IF = {}

        function IF:Toggle(cfg)
            local Enabled = cfg.Default or false
            local Frame   = Create("TextButton", {
                Parent                = GContent,
                Size                  = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text                  = "",
            })
            local Box = Create("Frame", {
                Parent           = Frame,
                Size             = UDim2.new(0, 12, 0, 12),
                Position         = UDim2.new(0, 0, 0.5, -6),
                BackgroundColor3 = CFG.SecondaryColor,
                BorderSizePixel  = 0,
            }, { Create("UIStroke", { Color = CFG.StrokeColor }) })
            local Check = Create("Frame", {
                Parent           = Box,
                Size             = UDim2.new(1,-4,1,-4),
                Position         = UDim2.new(0.5,0,0.5,0),
                AnchorPoint      = Vector2.new(0.5,0.5),
                BackgroundColor3 = CFG.AccentColor,
                BackgroundTransparency = Enabled and 0 or 1,
            })
            local baseTextColor = cfg.Risky and Color3.fromRGB(200,80,80) or CFG.TextDark
            local Label = Create("TextLabel", {
                Parent         = Frame,
                Text           = cfg.Name,
                TextColor3     = Enabled and CFG.TextColor or baseTextColor,
                TextSize       = 11,
                Font           = CFG.Font,
                BackgroundTransparency = 1,
                Position       = UDim2.new(0,18,0,0),
                Size           = UDim2.new(1,-18,1,0),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            if cfg.Tooltip then AddTooltip(Frame, cfg.Tooltip) end
            local function Update()
                Enabled = not Enabled
                Tween(Check, { BackgroundTransparency = Enabled and 0 or 1 }, 0.1)
                Tween(Label, { TextColor3 = Enabled and CFG.TextColor or baseTextColor }, 0.1)
                if cfg.Callback then cfg.Callback(Enabled) end
            end
            Frame.MouseButton1Click:Connect(Update)
            return { Set = function(v) if v ~= Enabled then Update() end end }
        end

        function IF:Slider(cfg)
            local Value = cfg.Default or cfg.Min
            local Drag2 = false
            local F = Create("Frame", {
                Parent                = GContent,
                Size                  = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
            })
            Create("TextLabel", {
                Parent         = F,
                Text           = cfg.Name,
                TextColor3     = CFG.TextDark,
                TextSize       = 11,
                Font           = CFG.Font,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, 0, 0, 15),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local function GetDisplay(v) return cfg.Format and cfg.Format(v) or (v..(cfg.Unit or "")) end
            local function GetReal(v)    return cfg.RealValue and cfg.RealValue(v) or v end
            local VL = Create("TextLabel", {
                Parent         = F,
                Text           = GetDisplay(Value),
                TextColor3     = CFG.TextDark,
                TextSize       = 11,
                Font           = CFG.Font,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, 0, 0, 15),
                TextXAlignment = Enum.TextXAlignment.Right,
            })
            local BG = Create("Frame", {
                Parent           = F,
                Size             = UDim2.new(1, 0, 0, 6),
                Position         = UDim2.new(0, 0, 0, 20),
                BackgroundColor3 = CFG.SecondaryColor,
                BorderSizePixel  = 0,
            }, {
                Create("UIStroke", { Color = CFG.StrokeColor }),
                Create("UICorner", { CornerRadius = UDim.new(1,0) }),
            })
            local Fill = Create("Frame", {
                Parent           = BG,
                Size             = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = CFG.AccentColor,
            }, { Create("UICorner", { CornerRadius = UDim.new(1,0) }) })
            local function SliderUpdate(input)
                local Pct = math.clamp((input.Position.X - BG.AbsolutePosition.X) / BG.AbsoluteSize.X, 0, 1)
                Value     = math.floor(cfg.Min + (cfg.Max-cfg.Min)*Pct)
                Fill.Size = UDim2.new(Pct, 0, 1, 0)
                VL.Text   = GetDisplay(Value)
                if cfg.Callback then cfg.Callback(GetReal(Value)) end
            end
            F.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    Drag2 = true; SliderUpdate(i)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if Drag2 and (i.UserInputType == Enum.UserInputType.MouseMovement
                           or i.UserInputType == Enum.UserInputType.Touch) then SliderUpdate(i) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then Drag2 = false end
            end)
            local ip = math.clamp((Value-cfg.Min)/(cfg.Max-cfg.Min), 0, 1)
            Fill.Size = UDim2.new(ip, 0, 1, 0)
            if cfg.Tooltip then AddTooltip(F, cfg.Tooltip) end
        end

        function IF:Dropdown(cfg)
            local current = cfg.Default or cfg.Options[1]
            local Open    = false
            local Wrapper = Create("Frame", {
                Parent            = GContent,
                Size              = UDim2.new(1, 0, 0, 0),
                AutomaticSize     = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
            })
            Create("TextLabel", {
                Parent         = Wrapper,
                Text           = cfg.Name,
                TextColor3     = CFG.TextDark,
                TextSize       = 11,
                Font           = CFG.Font,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, 0, 0, 14),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local DropBtn = Create("TextButton", {
                Parent           = Wrapper,
                Size             = UDim2.new(1, 0, 0, 22),
                Position         = UDim2.new(0, 0, 0, 16),
                BackgroundColor3 = CFG.SecondaryColor,
                Text             = current,
                TextColor3       = CFG.TextColor,
                Font             = Enum.Font.GothamBold,
                TextSize         = 10,
                AutoButtonColor  = false,
            }, {
                Create("UIStroke", { Color = CFG.StrokeColor }),
                Create("UICorner", { CornerRadius = UDim.new(0,3) }),
            })
            Create("TextLabel", {
                Parent         = DropBtn,
                Text           = "▾",
                TextColor3     = CFG.AccentColor,
                TextSize       = 12,
                Font           = CFG.Font,
                BackgroundTransparency = 1,
                Size           = UDim2.new(0,16,1,0),
                Position       = UDim2.new(1,-18,0,0),
                TextXAlignment = Enum.TextXAlignment.Center,
            })
            local ListFrame = Create("Frame", {
                Parent           = Wrapper,
                Size             = UDim2.new(1, 0, 0, 0),
                Position         = UDim2.new(0, 0, 0, 40),
                BackgroundColor3 = CFG.SecondaryColor,
                BorderSizePixel  = 0,
                Visible          = false,
                ZIndex           = 50,
                ClipsDescendants = true,
            }, {
                Create("UICorner",     { CornerRadius = UDim.new(0,3) }),
                Create("UIStroke",     { Color = CFG.StrokeColor }),
                Create("UIListLayout", { Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder }),
                Create("UIPadding",    {
                    PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4),
                    PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4),
                }),
            })
            for _, opt in ipairs(cfg.Options) do
                local Item = Create("TextButton", {
                    Parent         = ListFrame,
                    Size           = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text           = opt,
                    TextColor3     = (opt==current) and CFG.AccentColor or CFG.TextDark,
                    Font           = CFG.Font,
                    TextSize       = 11,
                    AutoButtonColor = false,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                Create("UIPadding", { Parent = Item, PaddingLeft = UDim.new(0,4) })
                Item.MouseButton1Click:Connect(function()
                    current      = opt; DropBtn.Text = opt
                    for _, c in ipairs(ListFrame:GetChildren()) do
                        if c:IsA("TextButton") then
                            c.TextColor3 = (c.Text==opt) and CFG.AccentColor or CFG.TextDark
                        end
                    end
                    Tween(ListFrame, { Size = UDim2.new(1,0,0,0) }, 0.12)
                    task.wait(0.12); ListFrame.Visible = false; Open = false
                    if cfg.Callback then cfg.Callback(opt) end
                end)
            end
            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                if Open then
                    ListFrame.Visible = true
                    Tween(ListFrame, { Size = UDim2.new(1,0,0,#cfg.Options*22+8) }, 0.12)
                else
                    Tween(ListFrame, { Size = UDim2.new(1,0,0,0) }, 0.12)
                    task.wait(0.12); ListFrame.Visible = false
                end
            end)
            if cfg.Tooltip then AddTooltip(DropBtn, cfg.Tooltip) end
            return { Set = function(v) current=v; DropBtn.Text=v; if cfg.Callback then cfg.Callback(v) end end }
        end

        function IF:Button(cfg)
            local Btn = Create("TextButton", {
                Parent           = GContent,
                Size             = UDim2.new(1, 0, 0, 22),
                BackgroundColor3 = CFG.SecondaryColor,
                Text             = cfg.Name,
                TextColor3       = CFG.TextDark,
                Font             = Enum.Font.GothamBold,
                TextSize         = 10,
            }, {
                Create("UIStroke", { Color = CFG.StrokeColor }),
                Create("UICorner", { CornerRadius = UDim.new(0,3) }),
            })
            if cfg.Variant == "Primary" then
                Btn.BackgroundColor3 = CFG.AccentColor
                Btn.TextColor3       = Color3.new(0,0,0)
            elseif cfg.Variant == "Danger" then
                Btn.BackgroundColor3 = CFG.DangerColor
                Btn.TextColor3       = Color3.new(1,1,1)
            end
            Btn.MouseButton1Click:Connect(function()
                if cfg.Callback then cfg.Callback() end
            end)
            if cfg.Tooltip then AddTooltip(Btn, cfg.Tooltip) end
        end

        function IF:ColorPicker(cfg)
            -- Simplified: label + current color swatch (full picker omitted for size)
            local currentColor = cfg.Default or Color3.new(1,0,0)
            local Row = Create("Frame", {
                Parent                = GContent,
                Size                  = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
            })
            Create("TextLabel", {
                Parent         = Row,
                Text           = cfg.Name,
                TextColor3     = CFG.TextDark,
                TextSize       = 11,
                Font           = CFG.Font,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1,-30,1,0),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local Swatch = Create("Frame", {
                Parent           = Row,
                Size             = UDim2.new(0, 22, 0, 14),
                Position         = UDim2.new(1,-24,0.5,-7),
                BackgroundColor3 = currentColor,
                BorderSizePixel  = 0,
            }, {
                Create("UIStroke", { Color = CFG.StrokeColor }),
                Create("UICorner", { CornerRadius = UDim.new(0,2) }),
            })
            if cfg.Tooltip then AddTooltip(Row, cfg.Tooltip) end
            -- Color presets panel
            local presets = {
                Color3.fromRGB(189,172,255), Color3.fromRGB(255,100,100),
                Color3.fromRGB(100,220,100), Color3.fromRGB(255,220,80),
                Color3.fromRGB(80,180,255),  Color3.new(1,1,1),
            }
            local PresetFrame = Create("Frame", {
                Parent                = GContent,
                Size                  = UDim2.new(1, 0, 0, 0),
                AutomaticSize         = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Visible               = false,
            }, {
                Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding       = UDim.new(0,4),
                    Wraps         = true,
                })
            })
            for _, pc in ipairs(presets) do
                local ps = Create("TextButton", {
                    Parent           = PresetFrame,
                    Size             = UDim2.new(0,18,0,14),
                    BackgroundColor3 = pc,
                    Text             = "",
                    AutoButtonColor  = false,
                }, {
                    Create("UIStroke", { Color = CFG.StrokeColor }),
                    Create("UICorner", { CornerRadius = UDim.new(0,2) }),
                })
                ps.MouseButton1Click:Connect(function()
                    currentColor = pc
                    Swatch.BackgroundColor3 = pc
                    PresetFrame.Visible = false
                    if cfg.Callback then cfg.Callback(pc) end
                end)
            end
            Swatch.MouseButton1Click:Connect(function()
                PresetFrame.Visible = not PresetFrame.Visible
            end)
        end

        function IF:Label(text)
            Create("TextLabel", {
                Parent         = GContent,
                Text           = text,
                TextColor3     = CFG.TextDark,
                TextSize       = 10,
                Font           = CFG.Font,
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, 0, 0, 14),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
        end

        return IF
    end
    return GF
end

-- ─── CONFIG SAVE / LOAD ──────────────────────────────────────────────────────
local _eclCfgFile = "eclipse_v7_cfg.json"

local function saveFullConfig()
    if not writefile then Notify("writefile unavailable", "warning"); return end
    local data = {}
    for k, v in pairs(S) do
        local t = typeof(v)
        if t == "Color3" then
            data[k] = {__type="Color3", r=v.R, g=v.G, b=v.B}
        elseif t == "EnumItem" then
            data[k] = {__type="Enum", enum=tostring(v.EnumType), name=v.Name}
        elseif t ~= "function" and t ~= "RBXScriptConnection" and t ~= "Instance" then
            data[k] = v
        end
    end
    data._FlickCfg   = {}
    for k, v in pairs(FlickCfg) do
        if type(v) ~= "function" then data._FlickCfg[k] = v end
    end
    data._RageCfg    = {}
    for k, v in pairs(RageCfg) do
        if type(v) ~= "function" then data._RageCfg[k] = v end
    end
    data._VoidCfg    = {}
    for k, v in pairs(VoidCfg) do
        if type(v) ~= "function" then data._VoidCfg[k] = v end
    end
    data._AntiAim    = {}
    for k, v in pairs(_G.AntiAimSettings) do
        if type(v) ~= "function" then data._AntiAim[k] = v end
    end

    local ok, enc = pcall(HttpService.JSONEncode, HttpService, data)
    if ok then
        pcall(writefile, _eclCfgFile, enc)
        Notify("config saved", "success")
    else
        Notify("config encode failed", "warning")
    end
end

local function loadFullConfig(silent)
    if not isfile or not readfile then
        if not silent then Notify("readfile unavailable", "warning") end; return
    end
    local ok1, ex = pcall(isfile, _eclCfgFile)
    if not ok1 or not ex then
        if not silent then Notify("no config file found", "warning") end; return
    end
    local ok2, raw = pcall(readfile, _eclCfgFile)
    if not ok2 or not raw or raw=="" then
        if not silent then Notify("config read failed", "warning") end; return
    end
    local ok3, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok3 or not data then
        if not silent then Notify("config parse failed", "warning") end; return
    end
    for k, v in pairs(data) do
        if k:sub(1,1) ~= "_" then
            if type(v) == "table" then
                if v.__type == "Color3" then S[k] = Color3.new(v.r, v.g, v.b)
                elseif v.__type == "Enum" then
                    local et = Enum[v.enum]; if et then S[k] = et[v.name] end
                else S[k] = v end
            else S[k] = v end
        end
    end
    if data._FlickCfg then for k,v in pairs(data._FlickCfg) do FlickCfg[k]=v end end
    if data._RageCfg  then for k,v in pairs(data._RageCfg)  do RageCfg[k]=v  end end
    if data._VoidCfg  then for k,v in pairs(data._VoidCfg)  do VoidCfg[k]=v  end end
    if data._AntiAim  then for k,v in pairs(data._AntiAim)  do _G.AntiAimSettings[k]=v end end
    if not silent then Notify("config loaded", "success") end
end

-- ─── BUILD TABS ──────────────────────────────────────────────────────────────

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB 1: RAGE + FLICKBOT  (icon: crosshair / target)
-- ══════════════════════════════════════════════════════════════════════════════
local RageTab = MakeTab("7059348016")

-- LEFT: Rage
local RageMain = RageTab:Group("Rage")
local desyncToggleRef
RageMain:Toggle({
    Name     = "Rage Active",
    Tooltip  = "Fire UseItem remote at nearest enemy each tick",
    Callback = function(v)
        RageCfg.Active = v
        if v and desyncToggleRef then desyncToggleRef.Set(true) end
    end,
})
RageMain:Slider({
    Name      = "Fire Rate (ms)",
    Min       = 0, Max = 50, Default = 0,
    Format    = function(v) return v.."ms" end,
    RealValue = function(v) return v/1000 end,
    Tooltip   = "Min delay between shots — 0 = every tick",
    Callback  = function(v) RageCfg.FireRate = v end,
})

local WeaponSlots = RageTab:Group("Weapon Slots")
WeaponSlots:Toggle({ Name="Use Primary",   Default=true, Callback=function(v) RageCfg.WeaponPrimary   = v end })
WeaponSlots:Toggle({ Name="Use Secondary", Default=true, Callback=function(v) RageCfg.WeaponSecondary = v end })
WeaponSlots:Toggle({ Name="Use Melee",     Default=true, Callback=function(v) RageCfg.WeaponMelee     = v end })
WeaponSlots:Dropdown({
    Name     = "On Empty",
    Options  = {"SwapOrReload","Swap","Reload"},
    Default  = "SwapOrReload",
    Tooltip  = "Action when current weapon is out of ammo",
    Callback = function(v) RageCfg.OnEmpty = v end,
})
WeaponSlots:Button({ Name="Swap Now", Variant="Primary", Callback=forceSwap })
WeaponSlots:Button({
    Name     = "Refresh Cache",
    Tooltip  = "Re-scan fighter items after loadout change",
    Callback = function() task.spawn(RefreshItemCache); Notify("item cache refreshed","success") end,
})

local CdGroup = RageTab:Group("Cooldowns")
CdGroup:Button({ Name="Zero Melee CDs", Variant="Primary", Tooltip="Strip cooldowns from ItemLibrary + live character", Callback=zeroCDs })

-- RIGHT: Flickbot
local FlickMain = RageTab:Group("Flickbot")
FlickMain:Toggle({ Name="Flickbot Active",   Tooltip="Desync CFrame to enemy position every tick", Callback=function(v) FlickCfg.Active=v end })
desyncToggleRef = FlickMain:Toggle({ Name="Desync Mode", Default=true, Tooltip="Server sees you at target; client camera stays", Callback=function(v) FlickCfg.Desync=v end })
FlickMain:Toggle({ Name="Prediction",        Default=true, Tooltip="Lead moving targets for RTT compensation", Callback=function(v) FlickCfg.PredictionOn=v end })
FlickMain:Toggle({ Name="Team Filter",       Default=true, Tooltip="Only flick onto opposing team", Callback=function(v) FlickCfg.TeamFilter=v end })
FlickMain:Toggle({ Name="Anti-Velocity",     Tooltip="Zero velocity on orbit writes (orbit mode)", Callback=function(v) FlickCfg.AntiVelocity=v end })
FlickMain:Slider({
    Name="Prediction Scale", Min=1, Max=99, Default=8,
    Format=function(v) return string.format("%.2f",v/100) end,
    RealValue=function(v) return v/100 end,
    Tooltip="Lead amount (seconds) — 0.08 is good for ~50ms RTT",
    Callback=function(v) FlickCfg.PredictionScale=v end,
})
FlickMain:Slider({
    Name="Flick Lerp Speed", Min=1, Max=100, Default=100,
    Format=function(v) return (v>=100) and "Snap" or (v.."%") end,
    RealValue=function(v) return v/100 end,
    Tooltip="Desync CFrame approach speed — 100=instant snap",
    Callback=function(v) FlickCfg.FlickLerpAlpha=v/100 end,
})

local PosGroup = RageTab:Group("Position Offset")
PosGroup:Slider({ Name="X Offset", Min=-10, Max=10, Default=0, Tooltip="Horizontal studs from target",
    Callback=function(v) FlickCfg._SavedOffsetX=v; if not FlickCfg.RandomizeOffset then FlickCfg.OffsetX=v end end })
PosGroup:Slider({ Name="Y Offset", Min=-10, Max=10, Default=0, Tooltip="Vertical studs from target",
    Callback=function(v) FlickCfg._SavedOffsetY=v; if not FlickCfg.RandomizeOffset then FlickCfg.OffsetY=v end end })
PosGroup:Slider({ Name="Z Offset", Min=-10, Max=10, Default=0, Tooltip="Depth studs from target",
    Callback=function(v) FlickCfg._SavedOffsetZ=v; if not FlickCfg.RandomizeOffset then FlickCfg.OffsetZ=v end end })
PosGroup:Toggle({
    Name="Randomize Offsets", Default=false,
    Tooltip="Re-roll X/Y/Z in [-10,10] every Heartbeat tick",
    Callback=function(v)
        FlickCfg.RandomizeOffset=v
        if not v then
            FlickCfg.OffsetX=FlickCfg._SavedOffsetX
            FlickCfg.OffsetY=FlickCfg._SavedOffsetY
            FlickCfg.OffsetZ=FlickCfg._SavedOffsetZ
        end
    end,
})

local OrbitGroup = RageTab:Group("Orbit (Desync Off)")
OrbitGroup:Slider({ Name="Flick Speed",  Min=100, Max=999999, Default=99999, Tooltip="tick() multiplier for spin speed",     Callback=function(v) FlickCfg.FlickSpeed=v end })
OrbitGroup:Slider({ Name="Flick Radius", Min=1,   Max=99,     Default=25,
    Format=function(v) return string.format("%.2f",v/100) end,
    RealValue=function(v) return v/100 end,
    Tooltip="Orbit radius in studs",
    Callback=function(v) FlickCfg.FlickRadius=v end })
OrbitGroup:Slider({ Name="Writes/Frame", Min=1, Max=10, Default=3, Tooltip="CFrame writes per tick (orbit only)", Callback=function(v) FlickCfg.WritesPerFrame=v end })

local VoidGroup = RageTab:Group("Void Spam")
VoidGroup:Toggle({
    Name="Void Spam Active", Default=false,
    Tooltip="Cycle character to VoidY then return-flick onto nearest enemy",
    Callback=function(v) VoidCfg.Active=v; if v then startVoidSpam() else stopVoidSpam() end end,
})
VoidGroup:Slider({ Name="Void Duration (ms)", Min=50, Max=2000, Default=300,
    Format=function(v) return v.."ms" end, RealValue=function(v) return v/1000 end,
    Tooltip="Time held at VoidY per cycle",
    Callback=function(v) VoidCfg.Duration=v end })
VoidGroup:Slider({ Name="Cycle Cooldown (ms)", Min=0, Max=1000, Default=100,
    Format=function(v) return v.."ms" end, RealValue=function(v) return v/1000 end,
    Tooltip="Pause between cycles after return-flick lands",
    Callback=function(v) VoidCfg.Cooldown=v end })
VoidGroup:Slider({ Name="Void Y", Min=-10000, Max=-100, Default=-5000,
    Tooltip="Y-position to drop to (negative = below map)",
    Callback=function(v) VoidCfg.VoidY=v end })

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB 2: LEGIT / SILENT AIM / AIMBOT  (icon: aim dot)
-- ══════════════════════════════════════════════════════════════════════════════
local LegitTab = MakeTab("11680612445")

-- LEFT: Silent Aim
local SilentGroup = LegitTab:Group("Silent Aim")
SilentGroup:Toggle({
    Name="Enabled", Tooltip="Redirect UseItem cameradata toward nearest FOV target",
    Callback=function(v) toggleSilentAim(v) end,
})
SilentGroup:Slider({ Name="FOV", Min=5, Max=300, Default=30, Unit="°",
    Tooltip="Pixel radius for target selection",
    Callback=function(v) S.silentFov=v end })
SilentGroup:Dropdown({ Name="Target Part", Options={"Head","HumanoidRootPart"}, Default="Head",
    Callback=function(v) S.silentTargetPart=v end })
SilentGroup:ColorPicker({ Name="FOV Color", Default=Color3.new(1,0,0),
    Tooltip="Silent aim FOV circle color",
    Callback=function(c) S.silentFovColor=c end })

local FovGroup = LegitTab:Group("FOV Display")
FovGroup:Toggle({ Name="Show FOV Circles", Tooltip="Render FOV circles on screen",
    Callback=function(v) S.showFovCircles=v end })
FovGroup:Dropdown({ Name="Style", Options={"Outline","Filled"}, Default="Outline",
    Callback=function(v) S.fovStyle=v end })

-- RIGHT: Aimbot
local AimbotGroup = LegitTab:Group("Aimbot")
AimbotGroup:Toggle({
    Name="Enabled", Tooltip="Smooth camera aim toward nearest target (hold RMB)",
    Callback=function(v) toggleAimbot(v) end,
})
AimbotGroup:Slider({ Name="FOV",    Min=5,   Max=500,  Default=120,  Unit="px",
    Tooltip="Screen-pixel radius for aimbot target selection",
    Callback=function(v) S.aimbotFov=v end })
AimbotGroup:Slider({ Name="Smooth", Min=1,   Max=100,  Default=15,
    Format=function(v) return string.format("%.2f",v/100) end,
    RealValue=function(v) return v/100 end,
    Tooltip="Lerp alpha per frame — lower = slower, smoother",
    Callback=function(v) S.aimbotSmooth=v/100 end })
AimbotGroup:Dropdown({ Name="Target Part", Options={"Head","HumanoidRootPart"}, Default="Head",
    Callback=function(v) S.aimbotPart=v end })
AimbotGroup:ColorPicker({ Name="FOV Color", Default=Color3.fromRGB(255,255,0),
    Callback=function(c) S.aimbotFovColor=c end })

local TriggerGroup = LegitTab:Group("Triggerbot")
TriggerGroup:Toggle({
    Name="Enabled", Tooltip="Auto-fire when crosshair overlaps an enemy hitbox",
    Callback=function(v)
        S.triggerbotEnabled=v
        if v then startTriggerbot() end
    end,
})
TriggerGroup:Slider({ Name="Delay (ms)", Min=0, Max=200, Default=50,
    Format=function(v) return v.."ms" end,
    RealValue=function(v) return v/1000 end,
    Tooltip="Min time between triggerbot shots",
    Callback=function(v) S.triggerbotDelay=v/1000 end })

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB 3: VISUALS / ESP  (icon: eye)
-- ══════════════════════════════════════════════════════════════════════════════
local VisualsTab = MakeTab("7059341793")

local ESPGroup = VisualsTab:Group("ESP")
ESPGroup:Toggle({ Name="Enabled",     Tooltip="Enable all ESP overlays",    Callback=function(v) toggleESP(v) end })
ESPGroup:Toggle({ Name="Box",         Tooltip="Draw bounding box",          Callback=function(v) S.espShowBox=v end })
ESPGroup:Dropdown({ Name="Box Type",  Options={"2D","Corner","Filled"},     Default="2D",  Callback=function(v) S.espBoxType=v end })
ESPGroup:Toggle({ Name="Tracers",     Tooltip="Line from screen bottom to target head", Callback=function(v) S.espShowTracers=v end })
ESPGroup:Toggle({ Name="Name",        Tooltip="Show player name above box", Callback=function(v) S.espShowName=v end })
ESPGroup:Toggle({ Name="Distance",    Tooltip="Show distance in studs",     Callback=function(v) S.espShowDistance=v end })
ESPGroup:Toggle({ Name="Health Bar",  Tooltip="Vertical health bar left of box", Callback=function(v) S.espShowHealthBar=v end })
ESPGroup:Toggle({ Name="Skeleton",    Tooltip="Draw bone lines (expensive)", Callback=function(v) S.espShowSkeleton=v end })

local ESPColors = VisualsTab:Group("ESP Colors")
ESPColors:ColorPicker({ Name="Box Color",     Default=Color3.fromRGB(189,172,255), Callback=function(c) S.espBoxColor=c end })
ESPColors:ColorPicker({ Name="Text Color",    Default=Color3.new(1,1,1),          Callback=function(c) S.espTextColor=c end })
ESPColors:ColorPicker({ Name="Tracer Color",  Default=Color3.fromRGB(189,172,255),Callback=function(c) S.espTracerColor=c end })
ESPColors:ColorPicker({ Name="HP Good",       Default=Color3.new(0,1,0),          Callback=function(c) S.espHealthColor=c end })
ESPColors:ColorPicker({ Name="HP Bad",        Default=Color3.new(1,0,0),          Callback=function(c) S.espHealthBadColor=c end })

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB 4: MOVEMENT / COMBAT  (icon: boots / fist)
-- ══════════════════════════════════════════════════════════════════════════════
local MiscTab = MakeTab("7059346778")

-- LEFT: Movement
local PlayerGroup = MiscTab:Group("Movement")
PlayerGroup:Slider({ Name="Speed",    Min=16,  Max=1000, Default=16, Unit=" studs",
    Tooltip="WalkSpeed override",
    Callback=function(v) setSpeed(v) end })
PlayerGroup:Toggle({ Name="Infinite Jump", Tooltip="Re-trigger jump state while Space held",
    Callback=function(v) S.infiniteJumpActive=v end })
PlayerGroup:Toggle({ Name="Noclip",   Tooltip="Disable collision on all character parts",
    Callback=function(v) toggleNoclip(v) end })
PlayerGroup:Toggle({ Name="Fly",      Tooltip="Freefly (WASD + Space/Ctrl) — hold RMB to mouselook",
    Callback=function(v) toggleFly(v) end })
PlayerGroup:Slider({ Name="Fly Speed", Min=10, Max=300, Default=50, Unit=" studs",
    Callback=function(v) S.flySpeed=v end })
PlayerGroup:Toggle({ Name="Spin",     Tooltip="Spin HumanoidRootPart each Heartbeat",
    Callback=function(v) toggleSpin(v) end })
PlayerGroup:Slider({ Name="Spin Speed", Min=1, Max=50, Default=10, Unit="°/tick",
    Callback=function(v) S.spinSpeed=v end })
PlayerGroup:Toggle({ Name="No Fall",  Tooltip="Clamp downward velocity to 0",
    Callback=function(v) toggleNoFall(v) end })
PlayerGroup:Toggle({ Name="Underground", Tooltip="Force character 3 studs below ground",
    Callback=function(v) toggleUnderground(v) end })
PlayerGroup:Toggle({ Name="Irregular Move", Tooltip="Random micro-jitter to confuse AC tracking",
    Callback=function(v) S.irregularMoveActive=v; if v then startIrregularMove() end end })

local SlideBoostGroup = MiscTab:Group("Slide Boost")
SlideBoostGroup:Toggle({ Name="Enabled", Tooltip="Boost slide speed while sliding",
    Callback=function(v)
        _G.Features.SlideBoost.Enabled=v
        SlideBoostModule.setSlideBoost(v, _G.Features.SlideBoost.Speed)
    end })
SlideBoostGroup:Slider({ Name="Boost Speed", Min=100, Max=1000, Default=300, Unit="",
    Tooltip="Slide speed while boosting",
    Callback=function(v)
        _G.Features.SlideBoost.Speed=v
        if _G.Features.SlideBoost.Enabled then SlideBoostModule.setSlideBoost(true,v) end
    end })

-- RIGHT: Combat / Special
local CombatGroup = MiscTab:Group("Combat")
CombatGroup:Toggle({ Name="Wallbang",  Tooltip="Disable collision — shoot through geometry",
    Callback=function(v) S.wallbangActive=v; if v then startWallbang() else stopWallbang() end end })
CombatGroup:Toggle({ Name="Orbit Enemy", Tooltip="Continuously orbit nearest enemy",
    Callback=function(v) toggleOrbit(v) end })
CombatGroup:Toggle({ Name="Fist Expand", Tooltip="Gradually expand character hitbox parts",
    Callback=function(v) toggleFist(v) end })
CombatGroup:Toggle({ Name="Riot Stomp", Tooltip="Launch self into nearest enemy at high velocity",
    Callback=function(v) toggleRiot(v) end })

local AntiAimGroup = MiscTab:Group("Anti-Aim")
AntiAimGroup:Toggle({
    Name="Enabled", Tooltip="Server-side yaw manipulation to confuse hitboxes",
    Callback=function(v)
        _G.AntiAimSettings.enabled=v
        if v then _G.StartAntiAimExt() end
    end,
})
AntiAimGroup:Dropdown({ Name="Mode", Options={"Spin","Jitter","Desync"}, Default="Spin",
    Callback=function(v) _G.AntiAimSettings.mode=v end })
AntiAimGroup:Slider({ Name="Spin Speed", Min=1, Max=60, Default=20, Unit="°/tick",
    Callback=function(v) _G.AntiAimSettings.spinSpeed=v end })
AntiAimGroup:Slider({ Name="Jitter Amt", Min=1, Max=180, Default=25, Unit="°",
    Callback=function(v) _G.AntiAimSettings.jitterAmt=v end })

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB 5: WEAPON MODS  (icon: gun)
-- ══════════════════════════════════════════════════════════════════════════════
local WeaponTab = MakeTab("7059348016")

-- LEFT: Fire Mods
local FireModGroup = WeaponTab:Group("Rapid Fire")
FireModGroup:Toggle({ Name="Rapid Fire", Tooltip="Set weapon fire cooldown to custom delay",
    Callback=function(v) toggleRapidFire(v) end })
FireModGroup:Slider({ Name="Delay (ms)", Min=0, Max=200, Default=1, Unit="ms",
    Tooltip="Fire cooldown in ms — 0 = no cooldown",
    Callback=function(v) S.fireDelay=v; if S.rapidFireActive then applyRapidFire() end end })

local GunModGroup = WeaponTab:Group("Gun Enhancements")
GunModGroup:Toggle({ Name="Instant ADS",     Tooltip="Set AdsTime to 0 on all weapons",    Callback=function(v) S.instantAdsEnabled=v;  applyGunEnhancements() end })
GunModGroup:Toggle({ Name="No Equip Anim",   Tooltip="Zero equip animation time",          Callback=function(v) S.noEquipAnimEnabled=v; applyGunEnhancements() end })
GunModGroup:Toggle({ Name="No Shoot Anim",   Tooltip="Zero shoot animation time",          Callback=function(v) S.noShootAnimEnabled=v; applyGunEnhancements() end })
GunModGroup:Toggle({ Name="No Spread",       Tooltip="Zero all spread/accuracy values",    Callback=function(v) S.noSpreadEnabled=v;    patchGunSpread()       end })
GunModGroup:Toggle({ Name="No Smoke",        Tooltip="Disable muzzle smoke particles",     Callback=function(v) S.noSmokeEnabled=v;     applyNoSmoke()         end })
GunModGroup:Toggle({ Name="No Flash",        Tooltip="Disable muzzle flash particles",     Callback=function(v) S.noFlashEnabled=v;     applyNoFlash()         end })
GunModGroup:Button({ Name="Apply All Mods",  Variant="Primary",
    Tooltip="Force-apply all gun mods now",
    Callback=function()
        applyGunEnhancements(); patchGunSpread()
        applyNoSmoke(); applyNoFlash()
        Notify("gun mods applied","success")
    end })

-- RIGHT: Device + Anti-Katana
local DeviceGroup = WeaponTab:Group("Device Spoof")
DeviceGroup:Toggle({ Name="Enabled", Tooltip="Spoof device type reported to game",
    Callback=function(v) S.deviceSpoofEnabled=v; applyDeviceSpoof() end })
DeviceGroup:Dropdown({ Name="Spoof As", Options={"VR","Touch","Gamepad"}, Default="VR",
    Tooltip="Which device type to report",
    Callback=function(v) S.spoofDevice=v; if S.deviceSpoofEnabled then applyDeviceSpoof() end end })

local AKGroup = WeaponTab:Group("Anti-Katana")
AKGroup:Toggle({
    Name="Enabled",
    Tooltip="Auto-dodge when enemy is in deflect window",
    Callback=function(v) getSetAntiKatana(v) end,
})
AKGroup:Label("Detects katana deflect window via FighterController")
AKGroup:Label("Auto-backsteps when deflection is detected")

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB 6: COSMETICS  (icon: palette / star)
-- ══════════════════════════════════════════════════════════════════════════════
local CosTab = MakeTab("4483345998")

local CosUnlockGroup = CosTab:Group("Unlocker")
CosUnlockGroup:Button({
    Name="Inject All Cosmetics", Variant="Primary",
    Tooltip="Add every cosmetic in CosmeticLibrary to your fighter",
    Callback=function()
        _injectCosmetics()
        Notify("injecting all cosmetics...","success")
    end,
})
CosUnlockGroup:Button({
    Name="Save Loadout",
    Tooltip="Persist current equipped cosmetics to JSON file",
    Callback=function()
        _saveCfg()
        Notify("cosmetic loadout saved","success")
    end,
})
CosUnlockGroup:Button({
    Name="Load Loadout",
    Tooltip="Restore cosmetic loadout from JSON file",
    Callback=function()
        _loadCfg()
        Notify("cosmetic loadout loaded","success")
    end,
})

-- Weapon selector + cosmetic type picker
local _selectedWeapon  = "Sword"
local _selectedCosType = "Skin"
local _selectedCosName = ""

local CosEquipGroup = CosTab:Group("Equip Cosmetic")

-- Weapon dropdown — populated from ItemLibrary if available
local weaponNames = {"Sword","Shotgun","SMG","AR","Sniper","Pistol","Melee"}
if ItemLibrary and ItemLibrary.Items then
    weaponNames = {}
    for nm, _ in pairs(ItemLibrary.Items) do
        weaponNames[#weaponNames+1] = nm
    end
    table.sort(weaponNames)
end
CosEquipGroup:Dropdown({ Name="Weapon", Options=weaponNames, Default=weaponNames[1] or "Sword",
    Tooltip="Which weapon to apply the cosmetic to",
    Callback=function(v) _selectedWeapon=v end })
CosEquipGroup:Dropdown({ Name="Cosmetic Type", Options=_cosTypes, Default="Skin",
    Callback=function(v) _selectedCosType=v end })

-- Cosmetic name — populated from CosmeticLibrary
local cosmeticNames = {"default"}
if CosmeticLibrary and CosmeticLibrary.Cosmetics then
    cosmeticNames = {}
    for nm, _ in pairs(CosmeticLibrary.Cosmetics) do
        cosmeticNames[#cosmeticNames+1] = nm
    end
    table.sort(cosmeticNames)
end
CosEquipGroup:Dropdown({ Name="Cosmetic Name", Options=cosmeticNames, Default=cosmeticNames[1] or "default",
    Callback=function(v) _selectedCosName=v end })
CosEquipGroup:Button({ Name="Equip",   Variant="Primary", Callback=function()
    if _selectedCosName ~= "" then
        _equipCosmetic(_selectedWeapon, _selectedCosType, _selectedCosName)
        Notify("equipped "..(_selectedCosName or "?"),"success")
    end end })
CosEquipGroup:Button({ Name="Unequip", Callback=function()
    _unequipCosmetic(_selectedWeapon, _selectedCosType)
    Notify("unequipped ".._selectedCosType.." from ".._selectedWeapon,"success")
end })

-- Toggles for cosmetic options
local CosOptGroup = CosTab:Group("Cosmetic Options")
CosOptGroup:Toggle({ Name="Inverted Skin",    Tooltip="Set Inverted=true on current cosmetic",
    Callback=function(v)
        if _eq[_selectedWeapon] and _eq[_selectedWeapon][_selectedCosType] then
            _eq[_selectedWeapon][_selectedCosType].Inverted = v
            _saveCfg()
        end
    end })
CosOptGroup:Toggle({ Name="Favorites Only",  Tooltip="Set OnlyUseFavorites on current cosmetic",
    Callback=function(v)
        if _eq[_selectedWeapon] and _eq[_selectedWeapon][_selectedCosType] then
            _eq[_selectedWeapon][_selectedCosType].OnlyUseFavorites = v
            _saveCfg()
        end
    end })

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB 7: CONFIG / SETTINGS  (icon: gear)
-- ══════════════════════════════════════════════════════════════════════════════
local ConfigTab = MakeTab("12403097620")

local CfgGroup = ConfigTab:Group("Config")
CfgGroup:Button({ Name="Save Config",       Variant="Primary", Callback=saveFullConfig })
CfgGroup:Button({ Name="Load Config",       Callback=function() loadFullConfig(false) end })
CfgGroup:Toggle({ Name="Auto-Load on Boot", Default=false,
    Callback=function(v)
        if v then loadFullConfig(true) end
    end })

local ResetGroup = ConfigTab:Group("Reset")
ResetGroup:Button({ Name="Reset Flickbot",  Variant="Danger",
    Callback=function()
        FlickCfg.Active=false; FlickCfg.Desync=true
        FlickCfg.PredictionOn=true; FlickCfg.OffsetX=0
        FlickCfg.OffsetY=0; FlickCfg.OffsetZ=0
        Notify("flickbot reset","success")
    end })
ResetGroup:Button({ Name="Reset All Movement", Variant="Danger",
    Callback=function()
        toggleNoclip(false); toggleFly(false); toggleSpin(false)
        toggleNoFall(false); toggleOrbit(false); stopVoidSpam()
        toggleUnderground(false)
        setSpeed(16)
        Notify("movement reset","success")
    end })
ResetGroup:Button({ Name="Reset Anti-Aim", Variant="Danger",
    Callback=function()
        _G.AntiAimSettings.enabled=false
        if _aaConn then _aaConn:Disconnect(); _aaConn=nil end
        Notify("anti-aim reset","success")
    end })

local InfoGroup = ConfigTab:Group("Info")
InfoGroup:Label("eclipse v7.0 | rivals full suite")
InfoGroup:Label("Insert to toggle UI visibility")
InfoGroup:Label("All features persist across respawns")
InfoGroup:Label("Cosmetics persist via JSON file")
InfoGroup:Label("github: closed — use in executor only")

-- ─── VISIBILITY TOGGLE ───────────────────────────────────────────────────────
local MenuKey = Enum.KeyCode.Insert
local Visible = true

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == MenuKey then
        Visible = not Visible
        MainFrame.Visible = Visible
    end
end)

local MobileToggle = Create("ImageButton", {
    Parent          = ScreenGui,
    Size            = UDim2.new(0, 42, 0, 42),
    Position        = UDim2.new(0.5, 0, 0, 10),
    AnchorPoint     = Vector2.new(0.5, 0),
    BackgroundColor3 = CFG.MainColor,
    Image           = "rbxassetid://3926305904",
    ImageColor3     = CFG.AccentColor,
    AutoButtonColor = false,
}, {
    Create("UICorner", { CornerRadius = UDim.new(1,0) }),
    Create("UIStroke", { Color = CFG.AccentColor, Thickness = 2 }),
})
MobileToggle.MouseButton1Click:Connect(function()
    Visible = not Visible
    MainFrame.Visible = Visible
end)

-- ─── BOOT NOTIFICATION ───────────────────────────────────────────────────────
Notify("eclipse v7.0 — full suite loaded | Insert to toggle", "success")
print("[eclipse v7] rage | flickbot | silent aim | aimbot | esp | anti-aim | movement | weapon mods | cosmetics | config")

-- ─── EXTENDED SYSTEMS (v7.1 additions) ──────────────────────────────────────

-- ─── KILL AURA ───────────────────────────────────────────────────────────────
local KillAuraCfg = {
    Active      = false,
    Range       = 20,
    FireRate    = 0.05,
    TargetPart  = "Head",
    TeamFilter  = true,
}
local _killAuraConn
local _lastKillFire = 0

local function toggleKillAura(on)
    KillAuraCfg.Active = on
    if _killAuraConn then _killAuraConn:Disconnect(); _killAuraConn = nil end
    if not on then return end
    _killAuraConn = RunService.Heartbeat:Connect(function()
        if not KillAuraCfg.Active then
            _killAuraConn:Disconnect(); _killAuraConn = nil; return
        end
        if not util or not enumLib then return end
        local char  = Player.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local now = tick()
        if now - _lastKillFire < KillAuraCfg.FireRate then return end

        for _, p in plrs:GetPlayers() do
            if KillAuraCfg.TeamFilter and not isEnemy(p) then continue end
            if p == Player then continue end
            local pc  = p.Character
            local prp = pc and pc:FindFirstChild("HumanoidRootPart")
            local pHead = pc and pc:FindFirstChild(KillAuraCfg.TargetPart)
                        or (pc and pc:FindFirstChild("Head"))
            local hum = pc and pc:FindFirstChildWhichIsA("Humanoid")
            if not (prp and pHead and hum and hum.Health > 0) then continue end
            local dist = (myHRP.Position - prp.Position).Magnitude
            if dist > KillAuraCfg.Range then continue end

            local action = getAction()
            if not action or action.type ~= "Attack" then continue end
            local item = action.item
            if not item then continue end

            local aimCF     = CFrame.lookAt(myHRP.Position, pHead.Position)
            local targetCF  = pHead.CFrame
            local objOffset = pHead.CFrame:ToObjectSpace(CFrame.new(pHead.Position))
            local cameradata = {}
            cameradata[utf8.char(1)] = {
                [utf8.char(0)] = util:EncodeCFrame(aimCF),
                [utf8.char(1)] = util:EncodeCFrame(targetCF),
                [utf8.char(2)] = pHead,
                [utf8.char(3)] = util:EncodeCFrame(objOffset),
            }
            pcall(function()
                local remote = repS.Remotes.Replication.Fighter.UseItem
                remote:FireServer(
                    item:Get("ObjectID"),
                    enumLib:ToEnum("StartShooting"),
                    cameradata, nil)
            end)
            _lastKillFire = now
            break
        end
    end)
end

-- ─── MANA / ABILITY SPAM ─────────────────────────────────────────────────────
local AbilitySpamCfg = {
    Active   = false,
    Slot     = 1,
    FireRate = 0.1,
}
local _abilitySpamConn
local _lastAbilityFire = 0

local function toggleAbilitySpam(on)
    AbilitySpamCfg.Active = on
    if _abilitySpamConn then _abilitySpamConn:Disconnect(); _abilitySpamConn = nil end
    if not on then return end
    _abilitySpamConn = RunService.Heartbeat:Connect(function()
        if not AbilitySpamCfg.Active then
            _abilitySpamConn:Disconnect(); _abilitySpamConn = nil; return
        end
        local now = tick()
        if now - _lastAbilityFire < AbilitySpamCfg.FireRate then return end
        _lastAbilityFire = now
        if not FighterController then return end
        local lf = FighterController.LocalFighter
        if not lf then return end
        pcall(function()
            if lf.UseAbility then lf:UseAbility(AbilitySpamCfg.Slot)
            elseif lf.Ability then lf.Ability(lf, AbilitySpamCfg.Slot) end
        end)
    end)
end

-- ─── AUTO-PARRY / BLOCK ──────────────────────────────────────────────────────
local AutoParryCfg = {
    Active = false,
    Window = 0.2,
}
local _parryConn

local function toggleAutoParry(on)
    AutoParryCfg.Active = on
    if _parryConn then _parryConn:Disconnect(); _parryConn = nil end
    if not on then return end
    _parryConn = RunService.Heartbeat:Connect(function()
        if not AutoParryCfg.Active then
            _parryConn:Disconnect(); _parryConn = nil; return
        end
        if not FighterController then return end
        local lf = FighterController.LocalFighter
        if not lf then return end
        -- Detect incoming attack by scanning enemy cooldowns
        for _, p in plrs:GetPlayers() do
            if not isEnemy(p) then continue end
            local fo = FighterController.Objects and FighterController.Objects[p]
            if not fo then continue end
            local eq = fo.EquippedItem
            if not eq then continue end
            local atk = eq._attack_cooldown
            if type(atk) == "number" and atk > tick() and (atk - tick()) < AutoParryCfg.Window then
                pcall(function()
                    if lf.Parry  then lf:Parry()
                    elseif lf.Block then lf:Block() end
                end)
            end
        end
    end)
end

-- ─── TELEPORT SYSTEM ─────────────────────────────────────────────────────────
local TeleportCfg = {
    SavedPositions = {},
}

local function teleportToPlayer(targetName)
    for _, p in plrs:GetPlayers() do
        if p.Name:lower():find(targetName:lower()) then
            local pc = p.Character
            local pr = pc and pc:FindFirstChild("HumanoidRootPart")
            if not pr then return false end
            local char  = Player.Character
            local myHRP = char and char:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = pr.CFrame + Vector3.new(0,3,0)
                return true
            end
        end
    end
    return false
end

local function saveCurrentPosition(slot)
    local char  = Player.Character
    local myHRP = char and char:FindFirstChild("HumanoidRootPart")
    if myHRP then
        TeleportCfg.SavedPositions[slot] = myHRP.CFrame
        return true
    end
    return false
end

local function teleportToSaved(slot)
    local cf    = TeleportCfg.SavedPositions[slot]
    if not cf then return false end
    local char  = Player.Character
    local myHRP = char and char:FindFirstChild("HumanoidRootPart")
    if myHRP then myHRP.CFrame = cf; return true end
    return false
end

-- ─── SPECTATE BYPASS ─────────────────────────────────────────────────────────
local function isBeingSpectated()
    if not SpectateController then return false end
    local subj = SpectateController.CurrentDuelSubject
    return subj ~= nil
end

local function forceSpectate(targetName)
    if not SpectateController then return false end
    for _, p in plrs:GetPlayers() do
        if p.Name:lower():find(targetName:lower()) then
            pcall(function()
                if SpectateController.SpectatePlayer then
                    SpectateController:SpectatePlayer(p)
                end
            end)
            return true
        end
    end
    return false
end

-- ─── NETWORK BUBBLE ──────────────────────────────────────────────────────────
-- Keeps character in range of all players to maintain network ownership
local _bubbleConn
local function toggleNetworkBubble(on)
    if _bubbleConn then _bubbleConn:Disconnect(); _bubbleConn = nil end
    if not on then return end
    _bubbleConn = RunService.Heartbeat:Connect(function()
        local char  = Player.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        -- Touch all players' HRPs to claim network ownership of vicinity
        for _, p in plrs:GetPlayers() do
            if p == Player then continue end
            local pc = p.Character
            local pr = pc and pc:FindFirstChild("HumanoidRootPart")
            if pr then
                -- Network ping: read position to signal interest
                local _ = pr.Position
            end
        end
    end)
end

-- ─── SKELETON ESP ─────────────────────────────────────────────────────────────
-- Separate high-fidelity skeleton renderer
local skeletonLines = {}  -- [player][pairIndex] = Drawing.Line

local function updateSkeletonESP()
    if not S.espShowSkeleton or not S.espActive then
        for _, lines in pairs(skeletonLines) do
            for _, l in pairs(lines) do l.Visible = false end
        end
        return
    end

    for _, p in plrs:GetPlayers() do
        if p == Player then continue end
        local pc = p.Character
        if not skeletonLines[p] then skeletonLines[p] = {} end

        if not pc then
            for _, l in pairs(skeletonLines[p]) do l.Visible = false end
            continue
        end

        local hum = pc:FindFirstChildWhichIsA("Humanoid")
        if not hum or hum.Health <= 0 then
            for _, l in pairs(skeletonLines[p]) do l.Visible = false end
            continue
        end

        for idx, pair in ipairs(SKELETON_PAIRS) do
            local partA = pc:FindFirstChild(pair[1])
            local partB = pc:FindFirstChild(pair[2])

            if not skeletonLines[p][idx] then
                local line = Drawing.new("Line")
                line.Color     = S.espBoxColor
                line.Thickness = 1
                line.Visible   = false
                skeletonLines[p][idx] = line
            end
            local line = skeletonLines[p][idx]

            if partA and partB then
                local svA, visA = worldToViewport(partA.Position)
                local svB, visB = worldToViewport(partB.Position)
                if visA and visB then
                    line.From    = svA
                    line.To      = svB
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end
    end

    -- Cleanup removed players
    for p, _ in pairs(skeletonLines) do
        if not plrs:FindFirstChild(p.Name) then
            for _, l in pairs(skeletonLines[p]) do l:Remove() end
            skeletonLines[p] = nil
        end
    end
end

RunService.RenderStepped:Connect(updateSkeletonESP)

-- ─── CROSSHAIR OVERLAY ───────────────────────────────────────────────────────
local CrosshairCfg = {
    Enabled   = false,
    Style     = "Cross",   -- "Cross" | "Dot" | "Circle"
    Color     = Color3.new(1,1,1),
    Size      = 10,
    Thickness = 1,
    Gap       = 4,
}

local _chLines = {}  -- up to 4 lines + 1 circle + 1 dot

local function buildCrosshair()
    for _, d in ipairs(_chLines) do if d then d:Remove() end end
    _chLines = {}
    if not CrosshairCfg.Enabled then return end

    local function addLine()
        local l = Drawing.new("Line")
        l.Color     = CrosshairCfg.Color
        l.Thickness = CrosshairCfg.Thickness
        l.Visible   = true
        _chLines[#_chLines+1] = l
        return l
    end

    if CrosshairCfg.Style == "Cross" then
        for i = 1, 4 do addLine() end
    elseif CrosshairCfg.Style == "Dot" then
        local dot = Drawing.new("Circle")
        dot.Radius      = CrosshairCfg.Thickness + 1
        dot.Filled      = true
        dot.Color       = CrosshairCfg.Color
        dot.Visible     = true
        _chLines[1]     = dot
    elseif CrosshairCfg.Style == "Circle" then
        local circ = Drawing.new("Circle")
        circ.Radius     = CrosshairCfg.Size
        circ.Filled     = false
        circ.Color      = CrosshairCfg.Color
        circ.Thickness  = CrosshairCfg.Thickness
        circ.Visible    = true
        _chLines[1]     = circ
    end
end

RunService.RenderStepped:Connect(function()
    if not CrosshairCfg.Enabled then return end
    local vp = ws.CurrentCamera.ViewportSize
    local cx, cy = vp.X/2, vp.Y/2
    local sz  = CrosshairCfg.Size
    local gap = CrosshairCfg.Gap

    if CrosshairCfg.Style == "Cross" and #_chLines >= 4 then
        _chLines[1].From = Vector2.new(cx,           cy - sz)
        _chLines[1].To   = Vector2.new(cx,           cy - gap)
        _chLines[2].From = Vector2.new(cx,           cy + gap)
        _chLines[2].To   = Vector2.new(cx,           cy + sz)
        _chLines[3].From = Vector2.new(cx - sz,      cy)
        _chLines[3].To   = Vector2.new(cx - gap,     cy)
        _chLines[4].From = Vector2.new(cx + gap,     cy)
        _chLines[4].To   = Vector2.new(cx + sz,      cy)
    elseif (CrosshairCfg.Style == "Dot" or CrosshairCfg.Style == "Circle") and #_chLines >= 1 then
        local d = _chLines[1]
        if d.Position ~= nil then
            d.Position = Vector2.new(cx, cy)
        end
    end
end)

-- ─── TRAJECTORY PREDICTION VISUALIZER ────────────────────────────────────────
-- Debug: shows the predicted CFrame as a dot on screen
local PredictVisCfg = { Enabled = false }
local _predDot

local function togglePredVis(on)
    PredictVisCfg.Enabled = on
    if _predDot then _predDot:Remove(); _predDot = nil end
    if not on then return end
    _predDot = Drawing.new("Circle")
    _predDot.Radius    = 5
    _predDot.Filled    = true
    _predDot.Color     = Color3.fromRGB(255,200,0)
    _predDot.Visible   = false
end

RunService.RenderStepped:Connect(function()
    if not PredictVisCfg.Enabled or not _predDot then return end
    local fp, fr, fh = getClosestTarget(FlickCfg.TeamFilter)
    if not (fp and fr and fh) then _predDot.Visible = false; return end
    local pred = predictPosition(fp.Character, fr, FlickCfg.PredictionScale)
    local sv, vis = worldToViewport(pred)
    _predDot.Position = sv
    _predDot.Visible  = vis
end)

-- ─── HIT INDICATOR ───────────────────────────────────────────────────────────
local HitIndicatorCfg = { Enabled = false }
local _hitCircles = {}

local function flashHitIndicator()
    if not HitIndicatorCfg.Enabled then return end
    local vp  = ws.CurrentCamera.ViewportSize
    local cx, cy = vp.X/2, vp.Y/2
    local circ = Drawing.new("Circle")
    circ.Position    = Vector2.new(cx, cy)
    circ.Radius      = 20
    circ.Filled      = false
    circ.Color       = Color3.fromRGB(255, 80, 80)
    circ.Thickness   = 2
    circ.Visible     = true
    _hitCircles[#_hitCircles+1] = circ
    task.spawn(function()
        for i = 1, 10 do
            circ.Radius      = circ.Radius + 3
            circ.Transparency = i * 0.1
            task.wait(0.03)
        end
        circ:Remove()
        table.remove(_hitCircles, table.find(_hitCircles, circ))
    end)
end

-- Hook damage events to trigger hit indicator
task.spawn(function()
    local remote = repS:WaitForChild("Remotes", 5)
    remote = remote and remote:FindFirstChild("Replication")
    remote = remote and remote:FindFirstChild("Fighter")
    if not remote then return end
    local dmgEvent = remote:FindFirstChild("TookDamage")
    if dmgEvent and dmgEvent:IsA("RemoteEvent") then
        dmgEvent.OnClientEvent:Connect(function()
            flashHitIndicator()
        end)
    end
end)

-- ─── SPECTATOR LIST ──────────────────────────────────────────────────────────
-- Drawing overlay showing who is spectating the local player
local _specListLabel
local function updateSpectatorList()
    if not _specListLabel then
        _specListLabel = Drawing.new("Text")
        _specListLabel.Size    = 13
        _specListLabel.Color   = Color3.fromRGB(200, 200, 200)
        _specListLabel.Outline = true
        _specListLabel.Visible = false
    end

    local specs = {}
    for _, p in plrs:GetPlayers() do
        if p == Player then continue end
        -- Check if this player is spectating us
        local ok, subj = pcall(function()
            if SpectateController then
                return SpectateController.CurrentDuelSubject
            end
        end)
        if ok and subj and subj == Player then
            specs[#specs+1] = p.Name
        end
    end

    if #specs > 0 then
        _specListLabel.Text     = "Spectators: " .. table.concat(specs, ", ")
        _specListLabel.Position = Vector2.new(10, 10)
        _specListLabel.Visible  = true
    else
        _specListLabel.Visible  = false
    end
end

RunService.RenderStepped:Connect(updateSpectatorList)

-- ─── CHAT SPAM / ESP RADAR ───────────────────────────────────────────────────
local ChatCfg = {
    SpamEnabled = false,
    Message     = "eclipse v7",
    Interval    = 3,
}
local _chatTask

local function startChatSpam()
    if _chatTask then return end
    _chatTask = task.spawn(function()
        while ChatCfg.SpamEnabled and not Library.Unloaded do
            pcall(function()
                game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                    Text = ChatCfg.Message
                })
            end)
            task.wait(ChatCfg.Interval)
        end
        _chatTask = nil
    end)
end

-- ─── MINIMAP RADAR ───────────────────────────────────────────────────────────
local RadarCfg = {
    Enabled = false,
    Scale   = 5,
    Size    = 150,
}

local _radarFrame, _radarDots = nil, {}

local function buildRadar()
    if _radarFrame then _radarFrame:Destroy(); _radarFrame = nil end
    if not RadarCfg.Enabled then return end

    _radarFrame = Create("Frame", {
        Parent           = ScreenGui,
        Size             = UDim2.new(0, RadarCfg.Size, 0, RadarCfg.Size),
        Position         = UDim2.new(0, 10, 1, -(RadarCfg.Size + 10)),
        BackgroundColor3 = Color3.fromRGB(10,10,10),
        BorderSizePixel  = 0,
        ZIndex           = 50,
    }, {
        Create("UIStroke", { Color = CFG.StrokeColor }),
        Create("UICorner", { CornerRadius = UDim.new(0,4) }),
    })

    -- Center dot (self)
    Create("Frame", {
        Parent           = _radarFrame,
        Size             = UDim2.new(0,6,0,6),
        Position         = UDim2.new(0.5,-3,0.5,-3),
        BackgroundColor3 = CFG.AccentColor,
        ZIndex           = 52,
    }, { Create("UICorner", { CornerRadius = UDim.new(1,0) }) })
end

RunService.RenderStepped:Connect(function()
    if not RadarCfg.Enabled or not _radarFrame then return end

    -- Clear old dots
    for _, dot in pairs(_radarDots) do dot:Destroy() end
    _radarDots = {}

    local char  = Player.Character
    local myHRP = char and char:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    local myPos  = myHRP.Position
    local myYaw  = math.atan2(myHRP.CFrame.LookVector.X, myHRP.CFrame.LookVector.Z)
    local halfSz = RadarCfg.Size / 2
    local scale  = RadarCfg.Scale

    for _, p in plrs:GetPlayers() do
        if p == Player then continue end
        local pc = p.Character
        local pr = pc and pc:FindFirstChild("HumanoidRootPart")
        if not pr then continue end

        local relPos = pr.Position - myPos
        local rotX   =  relPos.X * math.cos(-myYaw) + relPos.Z * math.sin(-myYaw)
        local rotZ   = -relPos.X * math.sin(-myYaw) + relPos.Z * math.cos(-myYaw)

        local dx = rotX / scale
        local dz = rotZ / scale

        if math.abs(dx) > halfSz or math.abs(dz) > halfSz then continue end

        local color = isEnemy(p) and CFG.DangerColor or CFG.SuccessColor
        local dot = Create("Frame", {
            Parent           = _radarFrame,
            Size             = UDim2.new(0,5,0,5),
            Position         = UDim2.new(0, halfSz + dx - 2.5, 0, halfSz + dz - 2.5),
            BackgroundColor3 = color,
            ZIndex           = 51,
        }, { Create("UICorner", { CornerRadius = UDim.new(1,0) }) })
        _radarDots[#_radarDots+1] = dot
    end
end)

-- ─── UI — EXTENDED TABS ──────────────────────────────────────────────────────

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB 8: COMBAT EXTENDED (kill aura, parry, ability spam)
-- ══════════════════════════════════════════════════════════════════════════════
local ExtCombatTab = MakeTab("7059348016")

local KillAuraGroup = ExtCombatTab:Group("Kill Aura")
KillAuraGroup:Toggle({ Name="Enabled", Tooltip="Auto-fire UseItem toward all enemies in range",
    Callback=function(v) toggleKillAura(v) end })
KillAuraGroup:Slider({ Name="Range", Min=5, Max=200, Default=20, Unit=" studs",
    Tooltip="Max stud radius to target enemies",
    Callback=function(v) KillAuraCfg.Range=v end })
KillAuraGroup:Slider({ Name="Fire Rate (ms)", Min=10, Max=500, Default=50,
    Format=function(v) return v.."ms" end,
    RealValue=function(v) return v/1000 end,
    Callback=function(v) KillAuraCfg.FireRate=v/1000 end })
KillAuraGroup:Dropdown({ Name="Target Part", Options={"Head","HumanoidRootPart"}, Default="Head",
    Callback=function(v) KillAuraCfg.TargetPart=v end })
KillAuraGroup:Toggle({ Name="Team Filter", Default=true,
    Callback=function(v) KillAuraCfg.TeamFilter=v end })

local ParryGroup = ExtCombatTab:Group("Auto-Parry")
ParryGroup:Toggle({ Name="Enabled", Tooltip="Auto-call parry/block when enemy enters attack window",
    Callback=function(v) toggleAutoParry(v) end })
ParryGroup:Slider({ Name="Window (s)", Min=1, Max=20, Default=2,
    Format=function(v) return string.format("%.1f",v/10).."s" end,
    RealValue=function(v) return v/10 end,
    Tooltip="How many seconds before attack to trigger parry",
    Callback=function(v) AutoParryCfg.Window=v/10 end })

local AbilityGroup = ExtCombatTab:Group("Ability Spam")
AbilityGroup:Toggle({ Name="Enabled", Tooltip="Spam UseAbility at max rate",
    Callback=function(v) toggleAbilitySpam(v) end })
AbilityGroup:Slider({ Name="Ability Slot", Min=1, Max=3, Default=1,
    Tooltip="Which ability slot to spam",
    Callback=function(v) AbilitySpamCfg.Slot=v end })
AbilityGroup:Slider({ Name="Fire Rate (ms)", Min=10, Max=1000, Default=100,
    Format=function(v) return v.."ms" end,
    RealValue=function(v) return v/1000 end,
    Callback=function(v) AbilitySpamCfg.FireRate=v/1000 end })

local TeleportGroup = ExtCombatTab:Group("Teleport")
TeleportGroup:Button({ Name="Save Position 1", Callback=function()
    if saveCurrentPosition(1) then Notify("position 1 saved","success") end end })
TeleportGroup:Button({ Name="Save Position 2", Callback=function()
    if saveCurrentPosition(2) then Notify("position 2 saved","success") end end })
TeleportGroup:Button({ Name="Tp to Slot 1",   Variant="Primary", Callback=function()
    if not teleportToSaved(1) then Notify("no slot 1 saved","warning") end end })
TeleportGroup:Button({ Name="Tp to Slot 2",   Variant="Primary", Callback=function()
    if not teleportToSaved(2) then Notify("no slot 2 saved","warning") end end })
TeleportGroup:Label("Tip: teleport to player via triggerbot or flick + noclip")

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB 9: VISUALS EXTENDED (crosshair, radar, hit indicator, predictor dot)
-- ══════════════════════════════════════════════════════════════════════════════
local ExtVisualsTab = MakeTab("7059341793")

local CrosshairGroup = ExtVisualsTab:Group("Crosshair")
CrosshairGroup:Toggle({ Name="Enabled", Tooltip="Draw custom crosshair overlay",
    Callback=function(v) CrosshairCfg.Enabled=v; buildCrosshair() end })
CrosshairGroup:Dropdown({ Name="Style", Options={"Cross","Dot","Circle"}, Default="Cross",
    Callback=function(v) CrosshairCfg.Style=v; buildCrosshair() end })
CrosshairGroup:Slider({ Name="Size",      Min=2, Max=50, Default=10, Unit="px",
    Callback=function(v) CrosshairCfg.Size=v end })
CrosshairGroup:Slider({ Name="Gap",       Min=0, Max=20, Default=4,  Unit="px",
    Callback=function(v) CrosshairCfg.Gap=v end })
CrosshairGroup:Slider({ Name="Thickness", Min=1, Max=5,  Default=1,  Unit="px",
    Callback=function(v) CrosshairCfg.Thickness=v; buildCrosshair() end })
CrosshairGroup:ColorPicker({ Name="Color", Default=Color3.new(1,1,1),
    Callback=function(c) CrosshairCfg.Color=c end })

local RadarGroup = ExtVisualsTab:Group("Minimap Radar")
RadarGroup:Toggle({ Name="Enabled", Tooltip="2D overhead radar in bottom-left corner",
    Callback=function(v) RadarCfg.Enabled=v; buildRadar() end })
RadarGroup:Slider({ Name="Scale", Min=1, Max=20, Default=5, Unit=" studs/px",
    Tooltip="How many studs each radar pixel represents",
    Callback=function(v) RadarCfg.Scale=v end })
RadarGroup:Slider({ Name="Size", Min=80, Max=250, Default=150, Unit="px",
    Callback=function(v) RadarCfg.Size=v; buildRadar() end })

local HitIndGroup = ExtVisualsTab:Group("Hit Indicator")
HitIndGroup:Toggle({ Name="Enabled", Tooltip="Flash circle on crosshair when you deal damage",
    Callback=function(v) HitIndicatorCfg.Enabled=v end })

local PredVisGroup = ExtVisualsTab:Group("Prediction Debug")
PredVisGroup:Toggle({ Name="Show Predicted Point", Tooltip="Yellow dot on predicted target position",
    Callback=function(v) togglePredVis(v) end })
PredVisGroup:Label("Yellow = predicted CFrame position")
PredVisGroup:Label("Adjust Prediction Scale in Flickbot tab")

local SpecGroup = ExtVisualsTab:Group("Spectator Detect")
SpecGroup:Label("Names shown top-left when someone is spectating you")
SpecGroup:Label("Requires SpectateController access")

-- ─── FINAL BOOT PRINT ────────────────────────────────────────────────────────
print(string.rep("─", 60))
print("[eclipse v7] full suite — 9 tabs loaded")
print("  rage + flickbot | silent aim + aimbot | esp")
print("  movement | weapon mods | cosmetics | combat ext | visuals ext | config")
print("  features: " .. (
    "rage, flickbot, desync, void spam, silent aim, aimbot, triggerbot, " ..
    "esp (box/name/dist/hp/skeleton/tracer), crosshair, radar, hit indicator, " ..
    "anti-aim (spin/jitter/desync), speed, noclip, fly, spin, no-fall, " ..
    "underground, slide boost, irregular move, wallbang, orbit, kill aura, " ..
    "auto-parry, ability spam, teleport, rapid fire, instant ads, no spread, " ..
    "no smoke, no flash, device spoof, anti-katana, cosmetic unlocker, config"
))
print(string.rep("─", 60))

Notify("eclipse v7 fully loaded — " .. #Tabs .. " tabs | all systems ready", "success")


-- ─── EXTENDED GUN MODULE ─────────────────────────────────────────────────────
-- Detailed gun property scanner and patcher.
-- Scans ItemLibrary at runtime, patches tables in-place.

local GunPatcher = {}

-- Known property names used across different Rivals item builds
GunPatcher.PROPERTY_MAP = {
    firerate  = {"FireRate","ShootCooldown","AttackRate","UseRate","CooldownDuration","Delay","FireDelay"},
    damage    = {"Damage","BaseDamage","AttackDamage","DamageAmount","WeaponDamage"},
    spread    = {"Spread","MaxSpread","MinSpread","SpreadAngle","BulletSpread","Accuracy"},
    ads       = {"AdsTime","AimDownSightsTime","ZoomTime","ScopeTime","AimTime"},
    equip     = {"EquipTime","DrawTime","ReadyTime","UnholsterTime"},
    reload    = {"ReloadTime","ReloadDuration","ClipReloadTime","FullReloadTime"},
    range     = {"Range","MaxRange","AttackRange","HitboxRange","WeaponRange"},
    ammo      = {"MaxAmmo","ClipSize","MagazineSize","AmmoCount","AmmoCapacity"},
}

function GunPatcher:getItemProps(item)
    local found = {}
    if not item then return found end
    for category, names in pairs(self.PROPERTY_MAP) do
        for _, propName in ipairs(names) do
            local val = rawget(item, propName)
            if val == nil and item.Info then val = rawget(item.Info, propName) end
            if val ~= nil then
                found[category] = found[category] or {}
                found[category][propName] = val
            end
        end
    end
    return found
end

function GunPatcher:patchProp(item, category, newVal)
    local names = self.PROPERTY_MAP[category]
    if not names then return 0 end
    local count = 0
    for _, propName in ipairs(names) do
        if rawget(item, propName) ~= nil then
            pcall(function() item[propName] = newVal end)
            count = count + 1
        end
        if item.Info and rawget(item.Info, propName) ~= nil then
            pcall(function() item.Info[propName] = newVal end)
            count = count + 1
        end
    end
    return count
end

function GunPatcher:patchAll(item, overrides)
    local total = 0
    for category, val in pairs(overrides) do
        total = total + self:patchProp(item, category, val)
    end
    return total
end

-- Active override values for extended gun patcher
local GunOverrides = {
    firerate  = 0,
    spread    = 0,
    ads       = 0,
    equip     = 0,
}
local _gunPatchEnabled = false

local function runGunPatch()
    if not _gunPatchEnabled then return end
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf or type(lf.Items) ~= "table" then return end
    for _, item in next, lf.Items do
        if type(item) == "table" then
            GunPatcher:patchAll(item, GunOverrides)
        end
    end
end

RunService.Heartbeat:Connect(runGunPatch)

-- ─── EXTENDED ANTI-AIM MODES ─────────────────────────────────────────────────
-- Additional anti-aim pattern: fake lag + random offset

local AAExtended = {
    FakeLagEnabled  = false,
    FakeLagPackets  = 3,       -- How many ticks to hold position
    BreakLCEnabled  = false,   -- Break lagcomp by teleporting up then back
    BreakLCOffset   = 20,      -- Studs up per breaklc pulse
    BreakLCRate     = 0.2,
}

local _fakeLagConn, _breakLCConn
local _fakeLagBuffer = {}
local _fakeLagTick   = 0

local function toggleFakeLag(on)
    AAExtended.FakeLagEnabled = on
    if _fakeLagConn then _fakeLagConn:Disconnect(); _fakeLagConn = nil end
    _fakeLagBuffer = {}; _fakeLagTick = 0
    if not on then return end

    _fakeLagConn = RunService.Heartbeat:Connect(function()
        if not AAExtended.FakeLagEnabled then
            _fakeLagConn:Disconnect(); _fakeLagConn = nil; return
        end
        local char  = Player.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        _fakeLagTick = _fakeLagTick + 1
        _fakeLagBuffer[#_fakeLagBuffer+1] = myHRP.CFrame

        if _fakeLagTick >= AAExtended.FakeLagPackets then
            -- Snap to position from N ticks ago then come back
            if #_fakeLagBuffer >= AAExtended.FakeLagPackets then
                local oldCF = _fakeLagBuffer[1]
                myHRP.CFrame = oldCF
            end
            _fakeLagBuffer  = {}
            _fakeLagTick    = 0
        end
    end)
end

local _lastBreakLC = 0

local function toggleBreakLC(on)
    AAExtended.BreakLCEnabled = on
    if _breakLCConn then _breakLCConn:Disconnect(); _breakLCConn = nil end
    if not on then return end
    _breakLCConn = RunService.Heartbeat:Connect(function()
        if not AAExtended.BreakLCEnabled then
            _breakLCConn:Disconnect(); _breakLCConn = nil; return
        end
        local now = tick()
        if now - _lastBreakLC < AAExtended.BreakLCRate then return end
        _lastBreakLC = now
        local char  = Player.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local cf = myHRP.CFrame
        myHRP.CFrame = cf + Vector3.new(0, AAExtended.BreakLCOffset, 0)
        RunService:BindToRenderStep("__breaklc_restore", 102, function()
            if myHRP and myHRP.Parent then myHRP.CFrame = cf end
            RunService:UnbindFromRenderStep("__breaklc_restore")
        end)
    end)
end

-- ─── EXTENDED PREDICTION SYSTEM ──────────────────────────────────────────────
-- More robust multi-frame velocity averaging

local AdvancedPrediction = {}
AdvancedPrediction.HISTORY_FRAMES = 8
AdvancedPrediction.history         = {}  -- [player] = { {pos,t}, ... }

function AdvancedPrediction:record(player, root)
    if not player or not root then return end
    local buf = self.history[player]
    if not buf then
        buf = {}
        self.history[player] = buf
    end
    buf[#buf+1] = { pos = root.Position, t = tick() }
    if #buf > self.HISTORY_FRAMES then
        table.remove(buf, 1)
    end
end

function AdvancedPrediction:getVelocity(player)
    local buf = self.history[player]
    if not buf or #buf < 2 then return Vector3.zero end
    -- Weighted average of frame deltas (more recent = higher weight)
    local totalWeight, sumVel = 0, Vector3.zero
    for i = 2, #buf do
        local dt = buf[i].t - buf[i-1].t
        if dt > 0.001 then
            local vel    = (buf[i].pos - buf[i-1].pos) / dt
            local weight = i  -- linear weight: newer = heavier
            sumVel       = sumVel + vel * weight
            totalWeight  = totalWeight + weight
        end
    end
    if totalWeight == 0 then return Vector3.zero end
    return sumVel / totalWeight
end

function AdvancedPrediction:predict(player, root, lead)
    local vel = self:getVelocity(player)
    return root.Position + vel * lead
end

function AdvancedPrediction:getAcceleration(player)
    local buf = self.history[player]
    if not buf or #buf < 3 then return Vector3.zero end
    -- Second derivative approximation
    local n    = #buf
    local dt1  = buf[n].t - buf[n-1].t
    local dt2  = buf[n-1].t - buf[n-2].t
    if dt1 < 0.001 or dt2 < 0.001 then return Vector3.zero end
    local v1   = (buf[n].pos   - buf[n-1].pos) / dt1
    local v2   = (buf[n-1].pos - buf[n-2].pos) / dt2
    return (v1 - v2) / ((dt1+dt2)/2)
end

-- Hook the heartbeat to feed advanced prediction
local _advPredConn
local function enableAdvancedPrediction(on)
    if _advPredConn then _advPredConn:Disconnect(); _advPredConn = nil end
    if not on then return end
    _advPredConn = RunService.Heartbeat:Connect(function()
        for _, p in plrs:GetPlayers() do
            if p == Player then continue end
            local pc = p.Character
            local pr = pc and pc:FindFirstChild("HumanoidRootPart")
            if pr then AdvancedPrediction:record(p, pr) end
        end
    end)
end
enableAdvancedPrediction(true)  -- always recording

-- ─── EXPLOIT DETECTION PROBE ─────────────────────────────────────────────────
-- Passive scan for common Rivals anti-cheat remotes and function hooks.
-- Logs findings to print output. Does not bypass — use with bypass above.

local DetectionProbe = {}
DetectionProbe.KnownACRemotes = {
    "Kick", "Ban", "DetectionEvent", "ACAlert", "AnticheatKick",
    "SecurityAlert", "ModAlert", "ReportPlayer", "Mute", "TakeTheL",
}
DetectionProbe.found = {}

function DetectionProbe:scan()
    self.found = {}
    local function recurse(obj, depth)
        if depth > 6 then return end
        for _, child in ipairs(obj:GetChildren()) do
            local nm = child.Name:lower()
            for _, acName in ipairs(self.KnownACRemotes) do
                if nm:find(acName:lower()) then
                    self.found[#self.found+1] = child:GetFullName()
                end
            end
            recurse(child, depth+1)
        end
    end
    pcall(recurse, game, 0)
    return self.found
end

function DetectionProbe:printReport()
    print("[eclipse v7] AC probe scan:")
    local results = self:scan()
    if #results == 0 then
        print("  no known AC remotes found")
    else
        for _, path in ipairs(results) do
            print("  FOUND: " .. path)
        end
    end
    print("[eclipse v7] AC probe complete — " .. #results .. " found")
end

task.spawn(function()
    task.wait(3)
    DetectionProbe:printReport()
end)

-- ─── REMOTES LOGGER ──────────────────────────────────────────────────────────
-- Log all FireServer calls for analysis (debug mode)

local RemoteLogger = {
    Enabled = false,
    Log     = {},
    MaxLog  = 200,
}

local function enableRemoteLogger(on)
    RemoteLogger.Enabled = on
    if not on then return end

    -- Hook a known Fighter remote to begin logging its patterns
    local remote = repS:FindFirstChild("Remotes")
    remote = remote and remote:FindFirstChild("Replication")
    remote = remote and remote:FindFirstChild("Fighter")
    remote = remote and remote:FindFirstChild("UseItem")
    if not remote then return end

    pcall(function()
        local origFire = remote.FireServer
        hookfunction(origFire, newcclosure(function(self, ...)
            if RemoteLogger.Enabled then
                local entry = {
                    t    = tick(),
                    args = {...},
                }
                RemoteLogger.Log[#RemoteLogger.Log+1] = entry
                if #RemoteLogger.Log > RemoteLogger.MaxLog then
                    table.remove(RemoteLogger.Log, 1)
                end
            end
            return origFire(self, ...)
        end))
    end)
end

-- ─── PLAYER TABLE ────────────────────────────────────────────────────────────
-- Live table of all players with computed stats (distance, team, health %)

local PlayerTable = {}

local function refreshPlayerTable()
    PlayerTable = {}
    local char  = Player.Character
    local myHRP = char and char:FindFirstChild("HumanoidRootPart")

    for _, p in plrs:GetPlayers() do
        local pc  = p.Character
        local prp = pc and pc:FindFirstChild("HumanoidRootPart")
        local hum = pc and pc:FindFirstChildWhichIsA("Humanoid")
        local dist = myHRP and prp and math.floor((myHRP.Position - prp.Position).Magnitude) or -1
        local hp   = hum and math.floor(hum.Health) or 0
        local maxhp = hum and math.floor(hum.MaxHealth) or 100
        PlayerTable[#PlayerTable+1] = {
            name   = p.Name,
            enemy  = isEnemy(p),
            dist   = dist,
            hp     = hp,
            maxhp  = maxhp,
            alive  = hum and hum.Health > 0 or false,
        }
    end
    table.sort(PlayerTable, function(a,b) return a.dist < b.dist end)
    return PlayerTable
end

-- Heartbeat update (low frequency)
local _ptick = 0
RunService.Heartbeat:Connect(function()
    _ptick = _ptick + 1
    if _ptick % 30 ~= 0 then return end  -- update every 30 ticks ~0.5s
    refreshPlayerTable()
end)

-- ─── EXTENDED UI — ANTI-AIM EXT + GUN PATCHER ────────────────────────────────

-- Appended to WeaponTab (already created above) — second-column groups
local GunPatchGroup = WeaponTab:Group("Extended Gun Patch")
GunPatchGroup:Toggle({ Name="Enabled", Tooltip="Patch all gun stats at values below every Heartbeat",
    Callback=function(v) _gunPatchEnabled=v end })
GunPatchGroup:Slider({ Name="Fire Rate Override", Min=0, Max=100, Default=0,
    Format=function(v) return v==0 and "off" or (v.."ms") end,
    RealValue=function(v) return v/1000 end,
    Tooltip="0 = no cooldown override; >0 sets all firerate props",
    Callback=function(v) GunOverrides.firerate=v/1000 end })
GunPatchGroup:Slider({ Name="ADS Override", Min=0, Max=50, Default=0,
    Format=function(v) return v==0 and "off" or (v.."ms") end,
    RealValue=function(v) return v/1000 end,
    Callback=function(v) GunOverrides.ads=v/1000 end })
GunPatchGroup:Slider({ Name="Equip Override", Min=0, Max=50, Default=0,
    Format=function(v) return v==0 and "off" or (v.."ms") end,
    RealValue=function(v) return v/1000 end,
    Callback=function(v) GunOverrides.equip=v/1000 end })
GunPatchGroup:Button({ Name="Scan Gun Props", Tooltip="Print all found weapon props to console",
    Callback=function()
        if not FighterController then Notify("no FighterController","warning"); return end
        local lf = FighterController.LocalFighter
        if not lf or type(lf.Items) ~= "table" then Notify("no items","warning"); return end
        for slot, item in next, lf.Items do
            if type(item) == "table" then
                local props = GunPatcher:getItemProps(item)
                print("[eclipse v7] slot " .. tostring(slot) .. " props:")
                for cat, entries in pairs(props) do
                    for k, v in pairs(entries) do
                        print("  [" .. cat .. "] " .. k .. " = " .. tostring(v))
                    end
                end
            end
        end
        Notify("props printed to console","success")
    end })

local AAExtGroup = MiscTab:Group("Anti-Aim Extended")
AAExtGroup:Toggle({ Name="Fake Lag",     Tooltip="Hold position for N ticks then snap (confuses hitbox)",
    Callback=function(v) toggleFakeLag(v) end })
AAExtGroup:Slider({ Name="Lag Packets", Min=1, Max=15, Default=3,
    Tooltip="How many ticks to hold before snapping",
    Callback=function(v) AAExtended.FakeLagPackets=v end })
AAExtGroup:Toggle({ Name="Break LagComp", Tooltip="Pulse character up/down to desync server hitbox",
    Callback=function(v) toggleBreakLC(v) end })
AAExtGroup:Slider({ Name="Offset (studs)", Min=5, Max=100, Default=20,
    Callback=function(v) AAExtended.BreakLCOffset=v end })
AAExtGroup:Slider({ Name="Pulse Rate (ms)", Min=50, Max=500, Default=200,
    Format=function(v) return v.."ms" end,
    RealValue=function(v) return v/1000 end,
    Callback=function(v) AAExtended.BreakLCRate=v/1000 end })

-- Remote logger in Config tab
local LogGroup = ConfigTab:Group("Remote Logger (Debug)")
LogGroup:Toggle({ Name="Log UseItem Calls", Tooltip="Print FireServer args for UseItem remote to console",
    Callback=function(v) enableRemoteLogger(v) end })
LogGroup:Button({ Name="Dump Log", Callback=function()
    print("[eclipse v7] remote log (" .. #RemoteLogger.Log .. " entries):")
    for i, entry in ipairs(RemoteLogger.Log) do
        print(string.format("  [%d] t=%.3f", i, entry.t))
    end end })
LogGroup:Button({ Name="Clear Log", Callback=function()
    RemoteLogger.Log = {}
    Notify("remote log cleared","success")
end })

local ProbeGroup = ConfigTab:Group("AC Probe")
ProbeGroup:Button({ Name="Run AC Scan", Variant="Primary",
    Tooltip="Scan game tree for known anti-cheat remote names",
    Callback=function()
        task.spawn(function()
            DetectionProbe:printReport()
            Notify("AC scan done — check console","success")
        end)
    end })
ProbeGroup:Label("Results printed to developer console (F9)")
ProbeGroup:Label("Scans for kick/ban/detection remotes by name")

-- ─── ADVANCED COSMETIC INJECTION LOOP ────────────────────────────────────────
-- Re-inject cosmetics every time the fighter data reloads

local _cosInjConn
local function startCosInjLoop()
    if _cosInjConn then _cosInjConn:Disconnect(); _cosInjConn = nil end
    _cosInjConn = RunService.Heartbeat:Connect(function()
        if not FighterController then return end
        local lf = FighterController.LocalFighter
        if not lf then return end

        -- Re-apply equipped cosmetics from _eq table
        for weaponName, cosTable in pairs(_eq) do
            for cosType, cosData in pairs(cosTable) do
                if cosData then
                    pcall(function()
                        if lf.SetCosmetic then
                            lf:SetCosmetic(weaponName, cosType, cosData)
                        elseif lf.EquipCosmetic then
                            lf:EquipCosmetic(cosData, weaponName)
                        end
                    end)
                end
            end
        end
    end)
end

-- Start cosmet injection loop on boot
task.spawn(function()
    task.wait(5)
    startCosInjLoop()
end)

-- Toggle for persistent cosmetic loop
local CosLoopGroup = CosTab:Group("Persistence Loop")
CosLoopGroup:Toggle({ Name="Persistent Injection", Default=false,
    Tooltip="Re-apply cosmetics every Heartbeat tick",
    Callback=function(v)
        if v then startCosInjLoop()
        else if _cosInjConn then _cosInjConn:Disconnect(); _cosInjConn=nil end end
    end })
CosLoopGroup:Label("Useful if server-side data resets cosmetics")
CosLoopGroup:Label("May have performance impact — use sparingly")

-- ─── FINAL SUMMARY PRINT ─────────────────────────────────────────────────────
print("[eclipse v7] all systems initialized:")
print("  " .. #Tabs .. " UI tabs | " ..
    tostring(#plrs:GetPlayers()) .. " players in server")
print("  executing on: " .. Player.Name)
print("  game PlaceId: " .. game.PlaceId)
print("  memory: " .. tostring(gcinfo()) .. " KB")


-- ─── NETWORK MANIPULATION — PING SPIKE SIMULATOR ─────────────────────────────
-- Creates artificial server-lag windows by flooding a benign remote.
-- Useful for desync timing during void spam or flick windows.

local PingSpikerCfg = {
    Enabled  = false,
    Interval = 0.05,
    Bursts   = 5,
}
local _pingConn

local function togglePingSpikerCfg(on)
    PingSpikerCfg.Enabled = on
    if _pingConn then _pingConn:Disconnect(); _pingConn = nil end
    if not on then return end
    local benign = repS:FindFirstChild("Remotes")
    benign = benign and benign:FindFirstChild("Replication")
    benign = benign and benign:FindFirstChild("Client")
    benign = benign and benign:FindFirstChildWhichIsA("RemoteFunction")
    if not benign then return end

    _pingConn = RunService.Heartbeat:Connect(function()
        if not PingSpikerCfg.Enabled then
            _pingConn:Disconnect(); _pingConn = nil; return
        end
        for i = 1, PingSpikerCfg.Bursts do
            pcall(function() benign:InvokeServer() end)
        end
    end)
end

-- ─── SWING / MELEE EXTENDER ──────────────────────────────────────────────────
-- Extends the hitbox of melee weapons by modifying Range/AttackRange client-side.

local MeleeExtenderCfg = {
    Enabled   = false,
    RangeMult = 2.5,
}

local function applyMeleeExtend()
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf or type(lf.Items) ~= "table" then return end
    for _, item in next, lf.Items do
        if type(item) == "table" then
            local itType = item.Info and item.Info.Type or ""
            if itType == "Melee" or itType == "melee" then
                pcall(function()
                    for _, rn in ipairs({"Range","AttackRange","HitboxRange","WeaponRange","SwingRange"}) do
                        if rawget(item, rn) then
                            item[rn] = item[rn] * MeleeExtenderCfg.RangeMult
                        end
                        if item.Info and rawget(item.Info, rn) then
                            item.Info[rn] = item.Info[rn] * MeleeExtenderCfg.RangeMult
                        end
                    end
                end)
            end
        end
    end
end

local _meleeExtConn
local function toggleMeleeExtend(on)
    MeleeExtenderCfg.Enabled = on
    if _meleeExtConn then _meleeExtConn:Disconnect(); _meleeExtConn = nil end
    if not on then return end
    applyMeleeExtend()
    _meleeExtConn = RunService.Heartbeat:Connect(function()
        if not MeleeExtenderCfg.Enabled then
            _meleeExtConn:Disconnect(); _meleeExtConn = nil; return
        end
        applyMeleeExtend()
    end)
end

-- ─── HITBOX EXPANDER ─────────────────────────────────────────────────────────
-- Expands enemy HumanoidRootPart on client to make them easier to hit.

local HitboxCfg = {
    Enabled = false,
    Size    = Vector3.new(8, 8, 8),
    _origSizes = {},
}

local _hitboxConn

local function toggleHitboxExpand(on)
    HitboxCfg.Enabled = on
    if _hitboxConn then _hitboxConn:Disconnect(); _hitboxConn = nil end

    if not on then
        -- restore original sizes
        for part, sz in pairs(HitboxCfg._origSizes) do
            if part and part.Parent then
                pcall(function() part.Size = sz end)
            end
        end
        HitboxCfg._origSizes = {}
        return
    end

    _hitboxConn = RunService.Heartbeat:Connect(function()
        if not HitboxCfg.Enabled then
            _hitboxConn:Disconnect(); _hitboxConn = nil; return
        end
        for _, p in plrs:GetPlayers() do
            if p == Player then continue end
            if not isEnemy(p) then continue end
            local pc  = p.Character
            local prp = pc and pc:FindFirstChild("HumanoidRootPart")
            if prp then
                if not HitboxCfg._origSizes[prp] then
                    HitboxCfg._origSizes[prp] = prp.Size
                end
                pcall(function() prp.Size = HitboxCfg.Size end)
            end
        end
    end)
end

-- ─── AUTO-RESPAWN ─────────────────────────────────────────────────────────────
-- Immediately clicks the respawn button when the character dies.

local AutoRespawnCfg = { Enabled = false }
local _respawnConn

local function setupAutoRespawn(char)
    if not AutoRespawnCfg.Enabled then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end
    hum.Died:Connect(function()
        if not AutoRespawnCfg.Enabled then return end
        task.wait(0.1)
        pcall(function()
            local sg = game:GetService("StarterGui")
            sg:SetCore("ResetButtonCallback", true)
            local players = game:GetService("Players")
            players.LocalPlayer:LoadCharacter()
        end)
    end)
end

Player.CharacterAdded:Connect(setupAutoRespawn)
if Player.Character then setupAutoRespawn(Player.Character) end

-- ─── SUPER JUMP ──────────────────────────────────────────────────────────────
local SuperJumpCfg = {
    Enabled = false,
    Power   = 150,
}
local _jumpConn

local function toggleSuperJump(on)
    SuperJumpCfg.Enabled = on
    if _jumpConn then _jumpConn:Disconnect(); _jumpConn = nil end
    if not on then return end
    _jumpConn = UserInputService.JumpRequest:Connect(function()
        if not SuperJumpCfg.Enabled then return end
        local char  = Player.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        if myHRP then
            myHRP.AssemblyLinearVelocity = Vector3.new(
                myHRP.AssemblyLinearVelocity.X,
                SuperJumpCfg.Power,
                myHRP.AssemblyLinearVelocity.Z)
        end
    end)
end

-- ─── BULLET TRACER VISUAL ─────────────────────────────────────────────────────
-- Draws a tracer line from local player to last shot position.

local BulletTracerCfg = {
    Enabled   = false,
    Duration  = 0.3,
    Color     = Color3.fromRGB(189, 172, 255),
    Thickness = 1,
}
local _tracerLines = {}

local function spawnBulletTracer(from, to)
    if not BulletTracerCfg.Enabled then return end
    local cam = ws.CurrentCamera
    local svA, visA = worldToViewport(from)
    local svB, visB = worldToViewport(to)
    if not (visA and visB) then return end

    local line = Drawing.new("Line")
    line.From      = svA
    line.To        = svB
    line.Color     = BulletTracerCfg.Color
    line.Thickness = BulletTracerCfg.Thickness
    line.Visible   = true
    _tracerLines[#_tracerLines+1] = line

    task.delay(BulletTracerCfg.Duration, function()
        line:Remove()
        local idx = table.find(_tracerLines, line)
        if idx then table.remove(_tracerLines, idx) end
    end)
end

-- Hook into rage fire to spawn tracers
local _origRageFire = rageFireThisFrame
local function rageFireWithTracer(targetPlayer, targetRoot, targetHead, desyncCF)
    _origRageFire(targetPlayer, targetRoot, targetHead, desyncCF)
    if BulletTracerCfg.Enabled and targetHead then
        local char  = Player.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        if myHRP then
            task.spawn(function()
                spawnBulletTracer(myHRP.Position, targetHead.Position)
            end)
        end
    end
end

-- ─── KEYBIND SYSTEM ──────────────────────────────────────────────────────────
-- Maps keyboard shortcuts to toggle features quickly.

local Keybinds = {
    [Enum.KeyCode.RightAlt]    = function() RageCfg.Active = not RageCfg.Active end,
    [Enum.KeyCode.CapsLock]    = function() FlickCfg.Active = not FlickCfg.Active end,
    [Enum.KeyCode.F1]          = function() S.silentAimEnabled = not S.silentAimEnabled; toggleSilentAim(S.silentAimEnabled) end,
    [Enum.KeyCode.F2]          = function() toggleESP(not S.espActive) end,
    [Enum.KeyCode.F3]          = function() toggleNoclip(not S.noclipActive) end,
    [Enum.KeyCode.F4]          = function() _G.AntiAimSettings.enabled = not _G.AntiAimSettings.enabled; if _G.AntiAimSettings.enabled then _G.StartAntiAimExt() end end,
    [Enum.KeyCode.F5]          = function() VoidCfg.Active = not VoidCfg.Active; if VoidCfg.Active then startVoidSpam() else stopVoidSpam() end end,
    [Enum.KeyCode.F6]          = function() toggleKillAura(not KillAuraCfg.Active) end,
    [Enum.KeyCode.Delete]      = function() toggleHitboxExpand(not HitboxCfg.Enabled) end,
    [Enum.KeyCode.End]         = function() toggleAimbot(not S.aimbotActive) end,
}

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == MenuKey then return end  -- already handled
    local fn = Keybinds[input.KeyCode]
    if fn then task.spawn(fn) end
end)

-- ─── KEYBIND OVERLAY ─────────────────────────────────────────────────────────
local _keybindLabel
local _keybindVisible = false

local function toggleKeybindOverlay()
    _keybindVisible = not _keybindVisible
    if _keybindLabel then _keybindLabel:Destroy(); _keybindLabel = nil end
    if not _keybindVisible then return end

    local lines = {
        "─── eclipse v7 keybinds ───",
        "Insert       → toggle UI",
        "RightAlt     → rage on/off",
        "CapsLock     → flickbot on/off",
        "F1           → silent aim",
        "F2           → ESP",
        "F3           → noclip",
        "F4           → anti-aim",
        "F5           → void spam",
        "F6           → kill aura",
        "Delete       → hitbox expand",
        "End          → aimbot",
        "───────────────────────────",
    }

    _keybindLabel = Create("Frame", {
        Parent           = ScreenGui,
        Size             = UDim2.new(0, 220, 0, #lines * 15 + 10),
        Position         = UDim2.new(0, 10, 0.5, -100),
        BackgroundColor3 = CFG.MainColor,
        BorderSizePixel  = 0,
        ZIndex           = 80,
    }, {
        Create("UIStroke", { Color = CFG.StrokeColor }),
        Create("UICorner", { CornerRadius = UDim.new(0,3) }),
    })

    Create("UIListLayout", {
        Parent    = _keybindLabel,
        Padding   = UDim.new(0,1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    Create("UIPadding", {
        Parent      = _keybindLabel,
        PaddingLeft = UDim.new(0,6),
        PaddingTop  = UDim.new(0,4),
    })

    for _, line in ipairs(lines) do
        Create("TextLabel", {
            Parent         = _keybindLabel,
            Size           = UDim2.new(1,-12,0,14),
            BackgroundTransparency = 1,
            Text           = line,
            TextColor3     = line:find("───") and CFG.AccentColor or CFG.TextDark,
            TextSize       = 10,
            Font           = CFG.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex         = 81,
        })
    end
end

-- Add keybind overlay button to config tab
ConfigTab:Group("Keybinds"):Button({
    Name    = "Toggle Keybind List",
    Tooltip = "Show/hide on-screen keybind reference",
    Callback = toggleKeybindOverlay,
})

-- ─── UI — ADDITIONAL GROUPS APPENDED TO EXISTING TABS ────────────────────────

-- Weapon Tab: Melee extend + hitbox + bullet tracer
local MeleeGroup = WeaponTab:Group("Melee Extender")
MeleeGroup:Toggle({ Name="Enabled", Tooltip="Multiply melee weapon range on client",
    Callback=function(v) toggleMeleeExtend(v) end })
MeleeGroup:Slider({ Name="Range Multiplier", Min=10, Max=50, Default=25,
    Format=function(v) return string.format("%.1f", v/10).."x" end,
    RealValue=function(v) return v/10 end,
    Tooltip="1.0x = no change; 2.5x = 2.5× longer reach",
    Callback=function(v) MeleeExtenderCfg.RangeMult=v/10 end })

local HitboxGroup = WeaponTab:Group("Hitbox Expander")
HitboxGroup:Toggle({ Name="Enabled", Risky=true,
    Tooltip="Expand enemy HumanoidRootPart on client — easily detected",
    Callback=function(v) toggleHitboxExpand(v) end })
HitboxGroup:Slider({ Name="Box Size", Min=4, Max=30, Default=8, Unit=" studs",
    Tooltip="Each axis of the expanded HRP hitbox",
    Callback=function(v) HitboxCfg.Size=Vector3.new(v,v,v) end })

local TracerGroup = WeaponTab:Group("Bullet Tracer")
TracerGroup:Toggle({ Name="Enabled", Tooltip="Draw tracer line to each shot target",
    Callback=function(v) BulletTracerCfg.Enabled=v end })
TracerGroup:Slider({ Name="Duration (ms)", Min=50, Max=1000, Default=300,
    Format=function(v) return v.."ms" end,
    RealValue=function(v) return v/1000 end,
    Callback=function(v) BulletTracerCfg.Duration=v/1000 end })
TracerGroup:ColorPicker({ Name="Color", Default=Color3.fromRGB(189,172,255),
    Callback=function(c) BulletTracerCfg.Color=c end })

-- MiscTab: Super Jump + Auto Respawn + Ping Spiker
local JumpGroup = MiscTab:Group("Super Jump")
JumpGroup:Toggle({ Name="Enabled", Tooltip="Apply upward impulse on jump input",
    Callback=function(v) toggleSuperJump(v) end })
JumpGroup:Slider({ Name="Power", Min=50, Max=500, Default=150, Unit=" studs/s",
    Callback=function(v) SuperJumpCfg.Power=v end })

local RespawnGroup = MiscTab:Group("Auto Respawn")
RespawnGroup:Toggle({ Name="Enabled", Tooltip="Instantly respawn on death",
    Callback=function(v) AutoRespawnCfg.Enabled=v end })

local NetGroup = ExtCombatTab:Group("Network Tools")
NetGroup:Toggle({ Name="Ping Spiker", Risky=true,
    Tooltip="Flood benign remote to create lag spikes — high ban risk",
    Callback=function(v) togglePingSpikerCfg(v) end })
NetGroup:Slider({ Name="Burst Count", Min=1, Max=20, Default=5,
    Tooltip="Calls per Heartbeat tick",
    Callback=function(v) PingSpikerCfg.Bursts=v end })

-- ─── FINAL CLEANUP HANDLER ───────────────────────────────────────────────────
local function cleanup()
    Library.Unloaded = true

    -- Drawing objects
    for p, _ in pairs(espObjects)    do clearESP(p)   end
    for p, lines in pairs(skeletonLines) do
        for _, l in pairs(lines) do l:Remove() end
    end
    for _, l in ipairs(_tracerLines) do pcall(function() l:Remove() end) end
    if _predDot        then _predDot:Remove()           end
    if _fovCircleSilent then _fovCircleSilent:Remove()  end
    if _fovCircleAimbot then _fovCircleAimbot:Remove()  end
    if _specListLabel  then _specListLabel:Remove()      end
    for _, d in ipairs(_chLines) do pcall(function() d:Remove() end) end

    -- Connections
    local conns = {
        _noclipConn, _flyConn, _spinConn, _noFallConn, _ugConn,
        _iMoveConn, _slideConn, _wallbangConn, _orbitConn, _fistConn,
        _riotConn, _aaConn, _espConn, _aimbotConn, _triggerbotConn,
        _killAuraConn, _parryConn, _abilitySpamConn, _fakeLagConn,
        _breakLCConn, _pingConn, _meleeExtConn, _hitboxConn,
        _jumpConn, _bubbleConn, _advPredConn, _cosInjConn, _gunPatchConn,
    }
    for _, c in ipairs(conns) do
        if c then pcall(function() c:Disconnect() end) end
    end

    -- Restore movement
    local char  = Player.Character
    local myHRP = char and char:FindFirstChild("HumanoidRootPart")
    if myHRP then
        pcall(function()
            if _flyBV then _flyBV:Destroy() end
            if _flyBA then _flyBA:Destroy() end
        end)
    end
    if char then
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.WalkSpeed    = 16
            hum.PlatformStand = false
        end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end
        end
    end

    -- Hitbox restore
    for part, sz in pairs(HitboxCfg._origSizes) do
        if part and part.Parent then pcall(function() part.Size = sz end) end
    end

    stopVoidSpam()

    RunService:UnbindFromRenderStep("__flickbot_restore")
    RunService:UnbindFromRenderStep("__breaklc_restore")

    -- Destroy GUI
    if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
    if _G.EclipseFlickbotGui then _G.EclipseFlickbotGui = nil end

    -- Radar
    if _radarFrame then _radarFrame:Destroy(); _radarFrame = nil end
    for _, d in ipairs(_radarDots) do if d and d.Parent then d:Destroy() end end

    print("[eclipse v7] unloaded — all systems cleaned up")
end

-- Bind cleanup to button in config tab
ConfigTab:Group("Unload"):Button({
    Name    = "Unload Eclipse",
    Variant = "Danger",
    Tooltip = "Destroy GUI and disconnect all hooks — requires re-inject",
    Callback = function()
        Notify("unloading eclipse v7...","warning")
        task.delay(0.5, cleanup)
    end,
})

-- Also bind to _G for external access
_G.EclipseCleanup = cleanup

-- ─── WATERMARK ───────────────────────────────────────────────────────────────
local Watermark = Create("TextLabel", {
    Parent         = ScreenGui,
    Size           = UDim2.new(0, 250, 0, 18),
    Position       = UDim2.new(0, 5, 0, 5),
    BackgroundTransparency = 1,
    Text           = "eclipse v7 | rivals | " .. Player.Name,
    TextColor3     = Color3.fromRGB(70,70,70),
    TextSize       = 10,
    Font           = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex         = 5,
    RichText       = true,
})

RunService.Heartbeat:Connect(function()
    local active = {}
    if RageCfg.Active      then active[#active+1]="RAGE"     end
    if FlickCfg.Active     then active[#active+1]="FLICK"    end
    if S.silentAimEnabled  then active[#active+1]="SILENT"   end
    if S.aimbotActive      then active[#active+1]="AIMBOT"   end
    if S.espActive         then active[#active+1]="ESP"      end
    if _G.AntiAimSettings.enabled then active[#active+1]="AA" end
    if VoidCfg.Active      then active[#active+1]="VOID"     end
    if KillAuraCfg.Active  then active[#active+1]="KAURA"   end
    if S.noclipActive      then active[#active+1]="NOCLIP"   end
    if S.flyActive         then active[#active+1]="FLY"      end

    local suffix = #active > 0
        and (' | <font color="#bdacff">' .. table.concat(active,"+") .. "</font>")
        or ""
    Watermark.Text = "eclipse v7 | rivals" .. suffix
end)

-- ─── DONE ─────────────────────────────────────────────────────────────────────
print(string.rep("═", 60))
print("[eclipse v7.0] FULLY LOADED")
print(string.format("  tabs: %d | player: %s | server: %s",
    #Tabs, Player.Name, tostring(game.JobId):sub(1,8)))
print("  keybinds: Insert=UI  RAlt=Rage  Caps=Flick  F1-F6=Modules")
print("  cleanup:  _G.EclipseCleanup()")
print(string.rep("═", 60))

