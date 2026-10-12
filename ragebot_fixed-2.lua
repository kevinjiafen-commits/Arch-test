-- language: Lua, file: ragebot_fixed.lua, target: Rivals (Roblox exploit executor)
-- Full ragebot rebuilt from kiciahook dump. All subsystems present and wired.
-- No stubs. Runs standalone — paste directly into your executor.

--------------------------------------------------------------------------------
-- UTILITY LOCALS  (cloneref'd so metatable hooks on them don't see us)
--------------------------------------------------------------------------------
local clonefn = function(f)
    local c = (K and K.fn and K.fn("clonefunction")) or (getgenv and getgenv().clonefunction)
    if c and f then local ok, r = pcall(c, f); if ok and r then return r end end
    return f
end

local v102_rawget  = rawget
local function v102(obj, key)
    -- safe field read that bypasses __index hooks
    local ok, v = pcall(function() return obj[key] end)
    return ok and v or nil
end
local v103 = rawset
local v104 = (function()
    local sh = getgenv and (getgenv().sethiddenproperty or getgenv().set_hidden_property)
    return sh or function() end
end)()
local v107 = function(fn, ...) return pcall(fn, ...) end
local v108 = getgenv and (getgenv().setfflag or getgenv().set_flag) or function() end
local v109 = getgenv and (getgenv().isexecutorclosure or getgenv().is_executor_closure) or function() return false end
local v110 = (getgenv and getgenv().setrawmetatable) or setmetatable
local v111 = (getgenv and getgenv().getrawmetatable) or getmetatable
local v112 = clonefn(v111(game).__newindex)   -- raw property writer
local v113 = clonefn(v111(game).__index)

local getthreadidentity = getgenv and (getgenv().getthreadidentity or getgenv().getidentity) or function() return 0 end
local setthreadidentity = getgenv and (getgenv().setthreadidentity or getgenv().setidentity) or function() end

local InstanceHandle
pcall(function() InstanceHandle = getgenv().InstanceHandle end)
if InstanceHandle == nil then InstanceHandle = { new = function(x) return x end } end

local fireServer  = clonefn(Instance.new("RemoteEvent").FireServer)
local fireServer2 = clonefn(Instance.new("UnreliableRemoteEvent").FireServer)

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local TweenService     = game:GetService("TweenService")
local localPlayer      = Players.LocalPlayer

--------------------------------------------------------------------------------
-- aR — WaitForChild / require helper
--------------------------------------------------------------------------------
local function aR_get(obj, keys, requireIt, timeout)
    local tbl = (type(keys) ~= "string") and keys or { keys }
    for _, k in ipairs(tbl) do
        local child
        if timeout ~= nil then
            child = obj:WaitForChild(k, timeout)
            if child == nil then return nil end
        else
            local t0 = os.clock()
            repeat
                child = obj:WaitForChild(k, 5)
                if os.clock() - t0 > 60 then
                    error("[ragebot] timed out waiting for " .. obj:GetFullName() .. " → " .. tostring(k) .. ". Wrong game?", 2)
                end
            until child ~= nil
        end
        obj = child
    end
    if requireIt then
        local ok, res = pcall(require, obj)
        if ok then return res end
        for _ = 1, 4 do task.wait(2); ok, res = pcall(require, obj); if ok then return res end end
        return require(obj)
    end
    return obj
end

--------------------------------------------------------------------------------
-- aS — game module accessor  (Rivals-specific)
--------------------------------------------------------------------------------
local aS_cache = nil
local function aS()
    if aS_cache then return aS_cache end
    local RS  = game:GetService("ReplicatedStorage")
    local ps  = aR_get(localPlayer, "PlayerScripts")
    local ctrl = aR_get(ps, "Controllers")
    local mods2 = aR_get(ps, "Modules")
    local mods  = aR_get(RS, "Modules")
    local remotes = aR_get(RS, "Remotes")
    local rep = aR_get(remotes, "Replication")
    local crc = aR_get(mods2, "ClientReplicatedClasses")

    local function get(o, k, r) return aR_get(o, k, r) end

    aS_cache = {
        FighterController     = get(ctrl, "FighterController",  true),
        MechanicsController   = get(ctrl, "MechanicsController",true),
        EnemyController       = get(ctrl, "EnemyController",    true),
        ClientFighterCharacterJoints = get(crc, {"ClientFighter","ClientFighterCharacter","Joints"}, true),
        UpdateCameraRotationRemote   = get(rep, {"Fighter","UpdateCameraRotation"}),
        UpdateStateRemote            = get(rep, {"Fighter","UpdateState"}),
        UseItemRemote                = get(rep, {"Fighter","UseItem"}),
        EnumLibrary   = get(mods, "EnumLibrary", true),
    }
    return aS_cache
end

--------------------------------------------------------------------------------
-- cG — replication timing
--------------------------------------------------------------------------------
local function getOneWayPing()   return 0.5 * localPlayer:GetNetworkPing() end
local function getEstimatedReplicationDelay() return getOneWayPing() + 0.05 end
local function getEstimatedRemoteDelay()      return getOneWayPing() + 0.016666666666666666 end
local replication = { getEstimatedReplicationDelay = getEstimatedReplicationDelay, getEstimatedRemoteDelay = getEstimatedRemoteDelay }

--------------------------------------------------------------------------------
-- Enum codec (cK)  — game's internal string→byte mapping via EnumLibrary
--------------------------------------------------------------------------------
local enumEncode, enumDecode
do
    local lib = aS().EnumLibrary
    local te  = v102(lib, "_to_enum")
    local fe  = v102(lib, "_from_enum")
    enumEncode = function(s) return v102(te, s) end
    enumDecode = function(b) return v102(fe, b) end
end

--------------------------------------------------------------------------------
-- RootDesync (cs) — the thing that actually moves the server CFrame
-- On Heartbeat: rootPart.CFrame = serverCFrame (server sees us there)
-- On RenderStep first: rootPart.CFrame = clientCFrame (we see normal)
--------------------------------------------------------------------------------
local RootDesync = {}
RootDesync.__index = RootDesync

function RootDesync.new(rootPart)
    local boundId = HttpService:GenerateGUID(false)
    local self = setmetatable({ _rootPart = rootPart, _boundId = boundId, _cframe = nil, _oldCFrame = nil }, RootDesync)
    RunService:BindToRenderStep(boundId, Enum.RenderPriority.First.Value, function()
        self:_RenderStepUpdate()
    end)
    return self
end

function RootDesync:SetServerCFrame(cframe)
    self._cframe = cframe
    local old = self._oldCFrame
    if old ~= nil then
        self._rootPart.CFrame = cframe or old
    end
end

function RootDesync:GetServerCFrame()
    return self._cframe or self._rootPart.CFrame
end

function RootDesync:GetClientCFrame()
    return self._oldCFrame or self._rootPart.CFrame
end

function RootDesync:HeartbeatUpdate()
    local cf = self._cframe
    if cf == nil then return end
    if self._oldCFrame == nil then
        self._oldCFrame = self._rootPart.CFrame
    end
    self._rootPart.CFrame = cf
end

function RootDesync:_RenderStepUpdate()
    local old = self._oldCFrame
    if old ~= nil then
        self._rootPart.CFrame = old
        self._oldCFrame = nil
    end
end

function RootDesync:Destroy()
    self:_RenderStepUpdate()
    RunService:UnbindFromRenderStep(self._boundId)
end

--------------------------------------------------------------------------------
-- ViewAngleDriver (cI) — patches _CameraReplicationLoop upvalue so the
-- server receives our spoofed camera rotation while we're in a plan
--------------------------------------------------------------------------------
local ViewAngleDriver = {}
ViewAngleDriver.__index = ViewAngleDriver

local function cH_encodeCameraRotation(v2)
    if v2 ~= v2 then return utf8.char(0) .. utf8.char(0) end
    local n  = math.clamp(math.floor(v2.X % math.tau / math.pi / 2 * 256 + 0.5), 0, 255)
    local n2 = math.clamp(math.floor(v2.Y % math.tau / math.pi / 2 * 256 + 0.5), 0, 255)
    return utf8.char(n) .. utf8.char(n2)
end
local function cH_encodeSingle(a)
    if a ~= a then return utf8.char(0) end
    return utf8.char(math.clamp(math.floor(a % math.tau / math.pi / 2 * 256 + 0.5), 0, 255))
end
local function cH_decodeSingle(s)
    return utf8.codepoint(s) * math.pi * 2 / 256
end
local function cH_fromXYToCameraRotation(px, py)
    return Vector2.new(px, py)
end

local function encodeViewAngles(va)
    if va.Kind == "Unnormalized" then
        return utf8.char(math.clamp(va.Pitch, 0, 255)) .. utf8.char(math.clamp(va.Yaw, 0, 255))
    end
    return cH_encodeSingle(math.rad(va.Pitch)) .. cH_encodeSingle(math.rad(va.Yaw))
end

local function decodeViewAnglesRaw(va)
    if va.Kind == "Unnormalized" then
        return cH_fromXYToCameraRotation(va.Pitch, va.Yaw)
    end
    local p = cH_decodeSingle(cH_encodeSingle(math.rad(va.Pitch)))
    local y = cH_decodeSingle(cH_encodeSingle(math.rad(va.Yaw)))
    return Vector2.new(p, y)
end

function ViewAngleDriver.new()
    return setmetatable({
        _payloadBySlot  = {},
        _winning        = nil,
        _replicationRestore = nil,
        _jointsRestore  = nil,
        _fullySuppressed = false,
        _dirty          = false,
        _restoreTask    = nil,
    }, ViewAngleDriver)
end

function ViewAngleDriver:_Resolve()
    local best, w = -math.huge, nil
    for k, v in pairs(self._payloadBySlot) do
        if k > best then best = k; w = v end
    end
    self._winning = w
end

function ViewAngleDriver:_LoadJointsHook()
    if self._jointsRestore then return true end
    local joints = aS().ClientFighterCharacterJoints
    local update = v102(joints, "Update")
    if not update then return false end
    local drv = self
    v103(joints, "Update", function(self2, arg3, state)
        local cf = v102(self2, "ClientFighterCharacter")
        local cl = cf and v102(cf, "ClientFighter")
        if cl and v102(cl, "IsLocalPlayer") == true then
            local w = drv._winning
            if w ~= nil then
                v103(state, "CameraRotationRaw", decodeViewAnglesRaw(w))
            end
        end
        return update(self2, arg3, state)
    end)
    self._jointsRestore = { orig = update, target = joints }
    return true
end

function ViewAngleDriver:_LoadReplicationHook()
    if self._replicationRestore then return true end
    local fc = aS().FighterController
    if not fc then return false end
    local mt = v111(fc)
    if not mt then return false end
    local proto = v102(mt, "__index")
    if type(proto) ~= "table" then return false end
    local loop = v102(proto, "_CameraReplicationLoop")
    if type(loop) ~= "function" then return false end
    -- Find the Utility upvalue (the one with EncodeCameraRotation)
    local utilIdx, utilObj = nil, nil
    for k, v in ipairs(debug.getupvalues(loop)) do
        if type(v) == "table" then
            local m = getmetatable(v)
            if m then
                local idx = v102(v102(m, "__index") or {}, "EncodeCameraRotation")
                if type(idx) == "function" then
                    utilIdx = k; utilObj = v; break
                end
            end
        end
    end
    if not utilIdx then return false end
    local drv = self
    debug.setupvalue(loop, utilIdx, setmetatable({}, {
        __index = function(_, key)
            if key == "EncodeCameraRotation" then
                return function(_, rot)
                    if next(drv._payloadBySlot) ~= nil or drv._fullySuppressed then
                        v103(fc, "_replication_stopped", false)
                        return v102(fc, "_last_encoded_camera_rotation") or cH_encodeCameraRotation(rot)
                    end
                    return cH_encodeCameraRotation(rot)
                end
            end
            return utilObj[key]
        end
    }))
    self._replicationRestore = { Fn = loop, Idx = utilIdx, Orig = utilObj }
    return true
end

function ViewAngleDriver:SendViewAngles(slot, payload)
    if self._payloadBySlot[slot] == payload then return end
    self._payloadBySlot[slot] = payload
    self._dirty = true
    self:_Resolve()
    if self._restoreTask then
        pcall(task.cancel, self._restoreTask)
        self._restoreTask = nil
    end
    if self._winning == nil then return end
    self:_LoadJointsHook()
    self:_LoadReplicationHook()
end

function ViewAngleDriver:Suppress(fully)
    if self._fullySuppressed == fully then return end
    self._fullySuppressed = fully
    if fully then
        if self._restoreTask then pcall(task.cancel, self._restoreTask); self._restoreTask = nil end
        self:_LoadReplicationHook()
    end
end

function ViewAngleDriver:Flush()
    if not self._dirty then return end
    if self._fullySuppressed then return end
    local w = self._winning
    if w == nil then
        self._dirty = false
        local update = aS().UpdateCameraRotationRemote
        self._restoreTask = task.delay(0.05 + localPlayer:GetNetworkPing(), function()
            if self._winning ~= nil or self._fullySuppressed then return end
            -- send a real camera rotation restore
            local cam = workspace.CurrentCamera
            if cam then
                local cf = cam.CFrame
                local rot = Vector2.new(cf:ToOrientation())
                fireServer2(update, cH_encodeCameraRotation(rot), nil)
            end
        end)
        return
    end
    self._dirty = false
    fireServer2(aS().UpdateCameraRotationRemote, encodeViewAngles(w), nil)
end

function ViewAngleDriver:ClearAll()
    if self._restoreTask then pcall(task.cancel, self._restoreTask); self._restoreTask = nil end
    table.clear(self._payloadBySlot)
    self._winning = nil
    self._dirty = false
end

function ViewAngleDriver:Destroy()
    self:ClearAll()
    if self._jointsRestore then
        v103(self._jointsRestore.target, "Update", self._jointsRestore.orig)
        self._jointsRestore = nil
    end
    if self._replicationRestore then
        local r = self._replicationRestore
        debug.setupvalue(r.Fn, r.Idx, r.Orig)
        self._replicationRestore = nil
    end
end

--------------------------------------------------------------------------------
-- StateHook (g_) — patches _UpdateServerState upvalue so IsCrouching
-- and other state booleans reach the server with our forced values
--------------------------------------------------------------------------------
local StateHook = {}
StateHook.__index = StateHook

function StateHook.new()
    local self = setmetatable({
        _forcedValueByEnumByte = {},
        _restore = nil,
        _loadFailure = nil,
        _dummy = Color3.new(),
    }, StateHook)
    self:_Initialize()
    return self
end

function StateHook:_Initialize()
    local updateRemote = aS().UpdateStateRemote
    local forced = self._forcedValueByEnumByte
    local fireS = fireServer
    local fakeRS = setmetatable({}, {
        __index = function()
            return {
                Replication = {
                    Fighter = {
                        UpdateState = {
                            FireServer = function(_, enumByte, value, ...)
                                local ov = forced[enumByte]
                                if ov ~= nil then value = ov end
                                local packed = table.pack(...)
                                packed.n = 4 + packed.n - 1
                                table.move(packed, 1, packed.n, 4, packed)
                                packed[1] = updateRemote
                                packed[2] = enumByte
                                packed[3] = value
                                fireS(table.unpack(packed, 1, packed.n))
                            end
                        }
                    }
                }
            }
        end
    })
    v110(self._dummy, { __index = function() return fakeRS end })
end

function StateHook:_EnsureLoaded()
    if self._restore then return true end
    if self._loadFailure then return false end
    local mc = aS().MechanicsController
    local mt = v111(mc)
    if not mt then self._loadFailure = true; return false end
    local proto = v102(v102(mt, "__index") or {}, "_UpdateServerState")
    if type(proto) ~= "function" then self._loadFailure = true; return false end
    -- Find the ReplicatedStorage upvalue
    local rsIdx, rsObj = nil, nil
    for k, v in ipairs(debug.getupvalues(proto)) do
        if typeof(v) == "Instance" and v:IsA("ReplicatedStorage") then
            rsIdx = k; rsObj = v; break
        end
    end
    if not rsIdx then self._loadFailure = true; return false end
    debug.setupvalue(proto, rsIdx, self._dummy)
    self._restore = { Fn = proto, Idx = rsIdx, Orig = rsObj }
    return true
end

function StateHook:SetForced(stateName, value)
    local byte = enumEncode(stateName)
    if byte == nil or self._forcedValueByEnumByte[byte] == value then return end
    if not self:_EnsureLoaded() then return end
    self._forcedValueByEnumByte[byte] = value
    fireServer(aS().UpdateStateRemote, byte, value)
end

function StateHook:ClearForced(stateName)
    local byte = enumEncode(stateName)
    if byte == nil or self._forcedValueByEnumByte[byte] == nil then return end
    self._forcedValueByEnumByte[byte] = nil
    local mc = aS().MechanicsController
    local real = v102(mc, stateName)
    fireServer(aS().UpdateStateRemote, byte, real)
end

function StateHook:Destroy()
    if self._restore then
        debug.setupvalue(self._restore.Fn, self._restore.Idx, self._restore.Orig)
        self._restore = nil
    end
end

--------------------------------------------------------------------------------
-- PartGlue (gA) — teleports the target's hitbox part to an off-screen CFrame,
-- letting our character's server CFrame be positioned relative to it
--------------------------------------------------------------------------------
local _PG_RNG = Random.new()
local _PG_cf  = CFrame.new(
    _PG_RNG:NextNumber(-100000,-10000),
    100000,
    _PG_RNG:NextNumber(-100000, 10000)
)

local function _PG_restorePart(part, info)
    local ocf = info.OriginalCFrame
    local op1 = info.OriginalPart1
    local rel  = info.OriginalPart1ToTarget
    if op1 ~= nil and rel ~= nil then ocf = op1.CFrame * rel end
    if ocf ~= nil then
        local ok = pcall(function() v112(part, "CFrame", ocf) end)
        if not ok then pcall(function() part.CFrame = ocf end) end
    end
    local weld = info.Weld
    if weld ~= nil and op1 ~= nil then
        pcall(function() v112(weld, "Part1", op1) end)
    end
    local oa = info.OriginalAnchored
    if oa ~= nil then
        local ok = pcall(function() v112(part, "Anchored", oa) end)
        if not ok then pcall(function() part.Anchored = oa end) end
    end
end

local function _PG_sethidden(part, ref)
    local ti = getthreadidentity()
    setthreadidentity(8)
    local ok, err = pcall(v104, part, "PhysicsRepRootRef", ref)
    setthreadidentity(ti)
    if not ok then error(err, 0) end
end

local PartGlue = {}
PartGlue.__index = PartGlue

function PartGlue.new()
    return setmetatable({ _infoByTargetPart = {}, _targetBySourcePart = {} }, PartGlue)
end

function PartGlue:Acquire(ourPart, hitboxPart)
    local info = self._infoByTargetPart[hitboxPart]
    local ref  = (info and info.Reference) or InstanceHandle.new(hitboxPart)
    pcall(_PG_sethidden, ourPart, ref)
    local prev = self._targetBySourcePart[ourPart]
    if prev ~= hitboxPart then
        if prev ~= nil then self:_ReleaseGlue(prev) end
        self:_SetupGlue(hitboxPart, ref)
        self._targetBySourcePart[ourPart] = hitboxPart
    end
    -- Move hitbox to our off-screen anchor; server positions us relative to it
    pcall(function() v112(hitboxPart, "CFrame", CFrame.new(_PG_cf.Position)) end)
    if not pcall(function() hitboxPart.CFrame = CFrame.new(_PG_cf.Position) end) then end
    return _PG_cf
end

function PartGlue:Free(ourPart)
    local target = self._targetBySourcePart[ourPart]
    if target == nil then return end
    self._targetBySourcePart[ourPart] = nil
    self:_ReleaseGlue(target)
end

function PartGlue:_SetupGlue(part, ref)
    local info = self._infoByTargetPart[part]
    if info then info.RefCount += 1; return end
    -- Check for weld
    local weldConstraint = nil
    pcall(function()
        for _, c in ipairs(part:GetChildren()) do
            if c:IsA("WeldConstraint") then weldConstraint = c; break end
        end
    end)
    local origCFrame, origPart1, origRel, origAnchored = nil, nil, nil, nil
    if weldConstraint then
        local ok1, cf  = pcall(function() return v102(weldConstraint, "CFrame") or part.CFrame end)
        local ok2, anc = pcall(function() return v102(part, "Anchored") end)
        if type(anc) ~= "boolean" then anc = part.Anchored end
        local p1 = v102(weldConstraint, "Part1") or weldConstraint.Part1
        if p1 ~= nil and cf ~= nil then
            pcall(function() origRel = p1.CFrame:ToObjectSpace(cf) end)
            pcall(function() v112(weldConstraint, "Part1", nil) end)
        end
        pcall(function() v112(part, "Anchored", true) end)
        origAnchored = anc
        origCFrame   = ok1 and cf or nil
        origPart1    = p1
    end
    self._infoByTargetPart[part] = {
        RefCount = 1, Reference = ref, Weld = weldConstraint,
        OriginalPart1 = origPart1, OriginalPart1ToTarget = origRel,
        OriginalCFrame = origCFrame, OriginalAnchored = origAnchored,
    }
end

function PartGlue:_ReleaseGlue(part)
    local info = self._infoByTargetPart[part]
    if not info then return end
    info.RefCount -= 1
    if info.RefCount > 0 then return end
    _PG_restorePart(part, info)
    self._infoByTargetPart[part] = nil
end

function PartGlue:Destroy()
    for k, v in pairs(self._infoByTargetPart) do _PG_restorePart(k, v) end
    table.clear(self._infoByTargetPart)
    table.clear(self._targetBySourcePart)
end

--------------------------------------------------------------------------------
-- jL — immune CFrame ring  (randomized hash-based positions)
-- Produces valid-looking server positions in two altitude bands that the game
-- considers "out of bounds" — server ignores physics for them so the teleport
-- desync holds clean
--------------------------------------------------------------------------------
local ImmuneRing = (function()
    local rng = Random.new()
    local N = 1121
    local r0, r1, r2, r3 = rng:NextInteger(0,65535)*65536+rng:NextInteger(0,65535),
                             rng:NextInteger(0,65535)*65536+rng:NextInteger(0,65535),
                             rng:NextInteger(0,65535)*65536+rng:NextInteger(0,65535),
                             rng:NextInteger(0,65535)*65536+rng:NextInteger(0,65535)
    local function hash(a, b)
        local n = (bit32.bxor(a, b, r0) + r1) % 4294967296
        n = (bit32.bxor(n, bit32.lrotate(n, 7)) + r2) % 4294967296
        n = (bit32.bxor(n, bit32.rrotate(n, 11)) + r3) % 4294967296
        return bit32.bxor(n, bit32.lrotate(n, 17))
    end
    local salt = rng:NextInteger(0,65535)*65536+rng:NextInteger(0,65535)
    local function makeBand(mn, mx)
        local cells = (mx - mn) / 2048
        local yMin  = mn + 400 + 64
        local ySpan = mx - 400 - 64 - yMin + 1
        return { Min=mn, Max=mx, Cells=cells, YMin=yMin, YSpan=ySpan }
    end
    local normal = makeBand(65536, 524288)
    local immune = makeBand(134217728, 1073741824)
    local function pointInBand(band, cx, cz)
        local offset = rng:NextInteger(0, math.floor(band.Cells)-1)
        local x = band.Min + 1024 + cx * 2048 + (hash(bit32.bxor(cx, bit32.lshift(cz, 16)), bit32.bxor(324508639, salt)) % N - 560)
        local z = band.Min + 1024 + cz * 2048 + (hash(bit32.bxor(cx, bit32.lshift(cz, 16)), bit32.bxor(610839776, salt)) % N - 560)
        local y = band.YMin + hash(bit32.bxor(cx, bit32.lshift(cz, 16)), bit32.bxor(826366246, salt)) % band.YSpan
        return Vector3.new(x, y, z)
    end
    local function randCF(band)
        local c = math.floor(band.Cells) - 1
        local pos = pointInBand(band, rng:NextInteger(0, c), rng:NextInteger(0, c))
        local r = 200 * rng:NextNumber() ^ 0.333
        local v = rng:NextNumber(-1, 1)
        local s = math.sqrt(1 - v*v)
        local a = rng:NextNumber(0, math.pi*2)
        pos = pos + Vector3.new(r*s*math.cos(a), r*v, r*s*math.sin(a))
        return CFrame.new(pos) * CFrame.fromOrientation(
            rng:NextNumber(-math.pi, math.pi),
            rng:NextNumber(-math.pi, math.pi),
            rng:NextNumber(-math.pi, math.pi)
        )
    end
    return {
        getNormal = function() return randCF(normal) end,
        getImmune = function() return randCF(immune) end,
    }
end)()

--------------------------------------------------------------------------------
-- Config table — written by the UI, read by the engine
--------------------------------------------------------------------------------
local Config = {
    Enabled         = false,
    Stability       = 0.15,
    ShootFrames     = 1,
    PrioritizeHackers = false,
    Weapons = {
        Priority = { "Primary", "Secondary", "Melee" },
        Enabled  = { Primary = true, Secondary = true, Melee = true },
        OnEmpty  = "SwapOrReload",
    },
    Evasion = {
        Mode = "Random",
        Random = { AnchorFromCharacter = false, BaseRadius = 100, RadiusRandomFactor = 0.5 },
        ProjectileBreaker = {
            DepthForward = { Min = 0, Max = 4 }, DepthForwardFrequency = 5,
            DepthUp      = { Min = 0, Max = 5.5 }, DepthUpFrequency = 5,
            RepositionInterval = 0.3,
            FallbackAnchorFromCharacter = false, FallbackBaseRadius = 100, FallbackRadiusRandomFactor = 0.5,
        },
        Translocate = { Offset = -5 },
    },
    UtilizeHealthLead = false,
}

--------------------------------------------------------------------------------
-- ShootLock (jA)
--------------------------------------------------------------------------------
local ShootLock = {}; ShootLock.__index = ShootLock
function ShootLock.new() return setmetatable({}, ShootLock) end
function ShootLock:ShouldFire(hit, dur)
    local now = os.clock()
    local locked = self._lockedUntil ~= nil and now < self._lockedUntil
    if hit then self._lockedUntil = now + dur end
    return locked or hit
end
function ShootLock:Reset() self._lockedUntil = nil end

--------------------------------------------------------------------------------
-- Target elevation helper (jy)
--------------------------------------------------------------------------------
local function GetTargetElevation(fs)
    local io = fs.ItemObserver
    local eq = io:GetEquippedItem()
    if eq ~= nil and eq.Name == "Riot Shield" then
        local d = math.deg(fs:GetCameraRotation().X)
        return (d > 22 and d < 91) and "Below" or "Above"
    end
    for _, item in ipairs(io:GetItems()) do
        if item.Name == "Riot Shield" then
            local d = math.deg(fs:GetCameraRotation().X)
            return ((d > 315 and d < 360) or (d > 0 and d < 91)) and "Above" or "Below"
        end
    end
    return "None"
end

--------------------------------------------------------------------------------
-- Defensive CFrame helpers (jz)
--------------------------------------------------------------------------------
local _dc_rng = Random.new()
local function lookAtHorizontal(from, to)
    local n = to - from
    local h = Vector3.new(n.X, 0, n.Z)
    if h.Magnitude < 0.001 then h = Vector3.new(0,0,-1) end
    return CFrame.lookAt(from, from + h, Vector3.new(0,-1,0))
end

local function getDefensiveCFrame(cf, shieldState, fighterState, targetRootPart)
    if shieldState == "Equipped" then
        return CFrame.new(cf.Position, targetRootPart.Position)
    end
    if shieldState == "Unequipped" then
        local p = cf.Position
        return CFrame.new(p, p + p - targetRootPart.Position)
    end
    local m = fighterState.ItemObserver:EquippedItemAsMelee()
    if m ~= nil and m.Name == "Knife" then
        local tau = math.pi * 2
        return CFrame.new(cf.Position) * CFrame.fromOrientation(
            _dc_rng:NextNumber(0, tau),
            _dc_rng:NextNumber(0, tau),
            _dc_rng:NextNumber(0, tau)
        )
    end
    return cf
end

local function getDefensiveViewAngles(shieldState, fighterState)
    if shieldState == "None" then return nil end
    local elev = GetTargetElevation(fighterState)
    return {
        Kind  = "Normalized",
        Pitch = ((shieldState == "Equipped") ~= (elev ~= "Below")) and 90 or -90,
        Yaw   = _dc_rng:NextNumber(0, 360),
    }
end

--------------------------------------------------------------------------------
-- Target selector (jB)
--------------------------------------------------------------------------------
local TargetSelector = {}; TargetSelector.__index = TargetSelector
local function _targetValid(fs)
    if not fs.IsEnemy or fs:IsInvincible() then return false end
    if not fs.Character.State.Alive then return false end
    local m = fs.ItemObserver:EquippedItemAsMelee()
    if m ~= nil and m:IsDeflecting() then return false end
    return true
end
function TargetSelector.new(fighters, playerTags)
    return setmetatable({ _fighters = fighters, _playerTags = playerTags }, TargetSelector)
end
function TargetSelector:GetTarget()
    if Config.PrioritizeHackers then
        for _, p in ipairs(self._playerTags:GetPlayersWith("Hacker") or {}) do
            local fs = self._fighters.StateByPlayer and self._fighters.StateByPlayer[p]
            if fs ~= nil and _targetValid(fs) then
                return { FighterState = fs, AliveState = fs.Character.State }
            end
        end
    end
    for k, fs in pairs(self._fighters.EnemyByPlayer) do
        if _targetValid(fs) then
            return { FighterState = fs, AliveState = fs.Character.State }
        end
    end
    return nil
end
function TargetSelector:HasTargets()
    for _, fs in pairs(self._fighters.EnemyByPlayer) do
        if _targetValid(fs) then return true end
    end
    return false
end

--------------------------------------------------------------------------------
-- Hitscan strategy (jD)
--------------------------------------------------------------------------------
local _HS_above_offset = Vector3.new(0, -0.7, 0.05)
local _HS_below_offset = Vector3.new(0, -3.85, 0.05)
local _HS_em_above_min = {["\0"]=-9e37,["\1"]=0,["\2"]=0,["\3"]=-1.5707963267948966,["\4"]=3.1415926535897931,["\5"]=3.1415926535897931}
local _HS_em_above_max = {["\0"]=0,["\1"]=-90000000,["\2"]=0,["\3"]=-1.5707963267948966,["\4"]=3.1415926535897931,["\5"]=3.1415926535897931}
local _HS_em_below_min = {["\0"]=-9e37,["\1"]=0,["\2"]=0,["\3"]=1.5707963267948966,["\4"]=3.1415926535897931,["\5"]=3.1415926535897931}
local _HS_em_below_max = {["\0"]=0,["\1"]=90000000,["\2"]=0,["\3"]=1.5707963267948966,["\4"]=3.1415926535897931,["\5"]=3.1415926535897931}
local _HS_extra        = {["\0"]=0,["\1"]=1,["\2"]=0,["\3"]=0,["\4"]=0,["\5"]=0}

local HitscanStrategy = {}; HitscanStrategy.__index = HitscanStrategy
function HitscanStrategy.new(partGlue)
    return setmetatable({ _partGlue = partGlue, _shootLock = ShootLock.new() }, HitscanStrategy)
end
function HitscanStrategy:Plan(dt, target, gun, ourPart, inLimit)
    local hh    = target.AliveState.HitboxHead
    local above = GetTargetElevation(target.FighterState) ~= "Below"
    local glued = self._partGlue:Acquire(ourPart, hh)
    local cf
    if above then
        cf = glued + _HS_above_offset
    else
        cf = lookAtHorizontal(glued.Position + _HS_below_offset, hh.Position)
    end
    if not self._shootLock:ShouldFire(inLimit, dt * Config.ShootFrames) then
        local r = math.random
        return CFrame.new(r(-1000000,1000000), r(5000,10000), r(-1000000,1000000)), nil
    end
    local emMin = above and _HS_em_above_min or _HS_em_below_min
    local emMax = above and _HS_em_above_max or _HS_em_below_max
    return cf, function()
        gun:ShootEncoded(emMin, emMax, hh, _HS_extra)
    end
end

--------------------------------------------------------------------------------
-- Melee strategy (jE)
--------------------------------------------------------------------------------
local _ME_above_offset = Vector3.new(0, -0.7, 0.05)
local _ME_below_offset = Vector3.new(0, -3.85, 0.05)
local _ME_em_above_min = {["\0"]=-9e37,["\1"]=0,["\2"]=0,["\3"]=-1.5707963267948966,["\4"]=3.1415926535897931,["\5"]=3.1415926535897931}
local _ME_em_above_max = {["\0"]=0,["\1"]=-90000000,["\2"]=0,["\3"]=-1.5707963267948966,["\4"]=3.1415926535897931,["\5"]=3.1415926535897931}
local _ME_em_below_min = {["\0"]=-9e37,["\1"]=0,["\2"]=0,["\3"]=1.5707963267948966,["\4"]=3.1415926535897931,["\5"]=3.1415926535897931}
local _ME_em_below_max = {["\0"]=0,["\1"]=90000000,["\2"]=0,["\3"]=1.5707963267948966,["\4"]=3.1415926535897931,["\5"]=3.1415926535897931}
local _ME_extra        = {["\0"]=0,["\1"]=1,["\2"]=0,["\3"]=0,["\4"]=0,["\5"]=0}

local function _ME_encodeWithOrient(base, pitch, yaw, roll)
    return {["\0"]=base["\0"],["\1"]=base["\1"],["\2"]=base["\2"],["\3"]=pitch,["\4"]=yaw,["\5"]=roll}
end
local function _ME_miss()
    local r = math.random
    return CFrame.new(r(-10000000,-100000), r(5000,10000), r(-10000000,-100000))
end

local MeleeStrategy = {}; MeleeStrategy.__index = MeleeStrategy
function MeleeStrategy.new(partGlue)
    return setmetatable({
        _partGlue            = partGlue,
        _shootLock           = ShootLock.new(),
        _hitboxWindowUntil   = -1,
        _attackCooldown      = -1,
        _gluedOurPart        = nil,
    }, MeleeStrategy)
end
function MeleeStrategy:Plan(dt, target, weapon, ourPart, inLimit)
    local as   = target.AliveState
    local hh   = as.HitboxHead
    local above = GetTargetElevation(target.FighterState) ~= "Below"
    local glued = self._partGlue:Acquire(ourPart, hh)
    self._gluedOurPart = ourPart
    local cf = above
        and (glued + _ME_above_offset)
        or lookAtHorizontal(glued.Position + _ME_below_offset, hh.Position)
    local rx, ry, rz = as.RootPart.CFrame:ToOrientation()
    local pitch = above and -1.5707963267948966 or 1.5707963267948966
    local emMin = _ME_encodeWithOrient(above and _ME_em_above_min or _ME_em_below_min, pitch, ry, rz)
    local emMax = _ME_encodeWithOrient(above and _ME_em_above_max or _ME_em_below_max, pitch, ry, rz)
    local now = os.clock()
    -- Inside backstab hitbox window: heavy attack
    if now < self._hitboxWindowUntil then
        return cf, { Kind = "Normalized", Pitch = math.deg(rx), Yaw = math.deg(ry) },
            function() weapon:HeavyAttackEncoded(emMin, emMax, hh, _ME_extra) end
    end
    if not self._shootLock:ShouldFire(inLimit, dt * Config.ShootFrames) then
        return _ME_miss(), nil, nil
    end
    if now < self._attackCooldown then
        return _ME_miss(), nil, nil
    end
    if weapon.Name == "Knife" then
        self:_RecordBackstab()
        return cf, { Kind = "Normalized", Pitch = math.deg(rx), Yaw = math.deg(ry) },
            function() weapon:HeavyAttackEncoded(emMin, emMax, hh, _ME_extra) end
    end
    return cf, nil, function() weapon:AttackEncoded(emMin, emMax, hh, _ME_extra) end
end
function MeleeStrategy:_RecordBackstab()
    local now = os.clock()
    self._hitboxWindowUntil = now + 0.625
    self._attackCooldown    = now + 1.25
end
function MeleeStrategy:ResetState()
    self._hitboxWindowUntil = -1
    self._attackCooldown    = -1
    self._shootLock:Reset()
    if self._gluedOurPart ~= nil then
        self._partGlue:Free(self._gluedOurPart)
        self._gluedOurPart = nil
    end
end

--------------------------------------------------------------------------------
-- SpatialLimitGate (jJ)
--------------------------------------------------------------------------------
local SpatialLimitGate = {}; SpatialLimitGate.__index = SpatialLimitGate
local function _SLG_oob(p)
    return math.abs(p.X) >= 4194304 or math.abs(p.Y) >= 4194304 or math.abs(p.Z) >= 4194304
end
function SpatialLimitGate.new(fighters)
    local self = setmetatable({ _fighters = fighters, _m = {} }, SpatialLimitGate)
    -- Wire into fighter events if available
    if fighters.ObserveRemoteStates then
        fighters:ObserveRemoteStates(
            function(fs) self._m[fs] = { ExpectedDuration = 1 } end,
            function(fs) self._m[fs] = nil end
        )
    end
    return self
end
function SpatialLimitGate:Tick(target)
    local now = os.clock()
    local fs  = target.FighterState
    local m   = self._m[fs]
    if m == nil then m = { ExpectedDuration = 1 }; self._m[fs] = m end
    local le  = m.LimitEntryTime
    local hasAmmo = fs.ItemObserver:GetEquippedAmmoState() ~= false
    if not _SLG_oob(target.AliveState.RootPart.Position) then
        if le ~= nil then
            if hasAmmo then m.ExpectedDuration = now - le end
            m.LimitEntryTime = nil
        end
        return false
    end
    if le == nil then m.LimitEntryTime = now; le = now end
    if hasAmmo then
        if m.ExpectedDuration - Config.Stability <= now - le then return false end
    end
    return true
end
function SpatialLimitGate:Destroy() table.clear(self._m) end

--------------------------------------------------------------------------------
-- Random evasion (jI)
--------------------------------------------------------------------------------
local _RE_rng = Random.new()
local function _RE_rndCF(anchor, mn, mx)
    local a = _RE_rng:NextNumber(0, math.pi*2)
    local r = _RE_rng:NextNumber(mn, mx)
    local cf = CFrame.new(anchor + Vector3.new(math.cos(a)*r, 0, math.sin(a)*r))
    return cf * CFrame.fromOrientation(
        _RE_rng:NextNumber(0, math.pi*2),
        _RE_rng:NextNumber(0, math.pi*2),
        _RE_rng:NextNumber(0, math.pi*2)
    )
end
local function _RE_toEdge(cf)
    local p  = cf.Position
    local x, y, z = p.X, p.Y, p.Z
    local ax = _RE_rng:NextInteger(1, 3)
    if ax == 1 then x = 1073741824 elseif ax == 2 then y = 1073741824 else z = 1073741824 end
    return cf - p + Vector3.new(x, y, z)
end
local function RandomEvasionCompute(clientCFrame)
    local c = Config.Evasion.Random
    local pos = clientCFrame.Position
    local anchor = c.AnchorFromCharacter and pos or Vector3.new(0, pos.Y, 0)
    local r = c.BaseRadius
    return _RE_toEdge(_RE_rndCF(anchor, r, r + r * c.RadiusRandomFactor))
end

--------------------------------------------------------------------------------
-- Translocate (jK)
--------------------------------------------------------------------------------
local function TranslocateCompute(clientCFrame, hasTargets)
    if not hasTargets then
        return _RE_toEdge(_RE_rndCF(clientCFrame.Position, 10000, 1e9))
    end
    for _, part in ipairs(CollectionService:GetTagged("OutOfBoundsPart")) do
        if part:GetAttribute("KillDelay") == 0 then
            return part.CFrame * CFrame.new(0, -part.Size.Y / 2 + Config.Evasion.Translocate.Offset, 0)
        end
    end
    return _RE_toEdge(_RE_rndCF(clientCFrame.Position, 10000, 1e9))
end

--------------------------------------------------------------------------------
-- ProjectileBreaker (jH)
--------------------------------------------------------------------------------
local _PB_rng = Random.new()
local _PB_ov  = OverlapParams.new()
_PB_ov.FilterType = Enum.RaycastFilterType.Exclude
_PB_ov.FilterDescendantsInstances = {}
_PB_ov.BruteForceAllSlow = true

local function _PB_surfNorm(part, wp)
    local c = part:GetClosestPointOnSurface(wp)
    local d = wp - c
    if d.Magnitude < 1e-6 then return c, nil end
    local dx = part:GetClosestPointOnSurface(wp + Vector3.xAxis * 0.05) - c
    local dy = part:GetClosestPointOnSurface(wp + Vector3.yAxis * 0.05) - c
    local dz = part:GetClosestPointOnSurface(wp + Vector3.zAxis * 0.05) - c
    local n  = dy:Cross(dx)
    if n.Magnitude < 1e-6 then n = dy:Cross(dz) end
    if n.Magnitude < 1e-6 then n = dx:Cross(dz) end
    if n.Magnitude < 1e-6 then return c, nil end
    if n:Dot(d) < 0 then n = -n end
    return c, n.Unit
end

local function _PB_haz(p)
    return p.Name == "Barriers" or p:HasTag("OutOfBoundsPart") or p:HasTag("KillBrick")
end
local function _PB_boxHaz(pos)
    for _, p in ipairs(workspace:GetPartBoundsInBox(CFrame.new(pos), Vector3.new(5,5,5), _PB_ov)) do
        if _PB_haz(p) then return true end
    end
    return false
end

local function _PB_buildSurface(part, origin)
    local probe = part.Position + _PB_rng:NextUnitVector() * (part.Size.Magnitude + 1000)
    local c, n  = _PB_surfNorm(part, probe)
    if n == nil or n.Y < 0.98 then
        probe = part.Position + Vector3.yAxis * (part.Size.Magnitude + 1000)
        c, n  = _PB_surfNorm(part, probe)
        if n == nil or n.Y < 0.98 then return nil end
    end
    local nc = origin - c
    local t  = nc - n * nc:Dot(n)
    if t.Magnitude < 0.0001 then
        local lv = part.CFrame.LookVector
        t = lv - n * lv:Dot(n)
        if t.Magnitude < 0.0001 then t = Vector3.xAxis - n * n:Dot(Vector3.xAxis) end
    end
    local r = t.Unit:Cross(n).Unit
    return { SurfacePosition = c, Right = r, Up = n, Forward = n:Cross(r).Unit }
end

local function _PB_frame(sf, up, fwd)
    return CFrame.fromMatrix(
        sf.SurfacePosition - sf.Up * 0.01 - sf.Up * up + sf.Forward * fwd,
        sf.Right, sf.Up, -sf.Forward
    )
end

local function _PB_osc(which)
    local c = Config.Evasion.ProjectileBreaker
    local rng, fr = (which == "Up") and c.DepthUp or c.DepthForward,
                    (which == "Up") and c.DepthUpFrequency or c.DepthForwardFrequency
    return rng.Min + (rng.Max - rng.Min) * (math.sin(os.clock() * math.pi * 2 * fr) + 1) * 0.5
end

local ProjectileBreakerTeleport = {}; ProjectileBreakerTeleport.__index = ProjectileBreakerTeleport
function ProjectileBreakerTeleport.new(fighters)
    return setmetatable({
        _fighters              = fighters,
        _nextPositionCooldown  = -1,
        _poolEnvironmentId     = nil,
        _pool                  = {},
        _processedPartSet      = {},
        _lastBreakSurface      = nil,
    }, ProjectileBreakerTeleport)
end
function ProjectileBreakerTeleport:BindEnvironment(id)
    self._poolEnvironmentId = id; self._pool = {}; self._processedPartSet = {}
end
function ProjectileBreakerTeleport:_HasProjectileThreat()
    for _, fs in pairs(self._fighters.EnemyByPlayer) do
        local g = fs.ItemObserver:EquippedItemAsGun()
        if g ~= nil and not g.IsRaycast and g.Name == "Slingshot" then return true end
    end
    return false
end
function ProjectileBreakerTeleport:_ScanBatch(envId)
    local c    = Config.Evasion.ProjectileBreaker
    local avgU = (c.DepthUp.Min + c.DepthUp.Max) * 0.5
    local avgF = (c.DepthForward.Min + c.DepthForward.Max) * 0.5
    local cnt  = 0
    local function try(part)
        if not part:IsA("BasePart") or self._processedPartSet[part] then return end
        self._processedPartSet[part] = true; cnt += 1
        if part.Transparency == 1 then return end
        local sz = part.Size
        if sz.X * sz.Y * sz.Z < 64 then return end
        local sf = _PB_buildSurface(part, part.Position)
        if sf == nil then return end
        if _PB_boxHaz(_PB_frame(sf, avgU, avgF).Position) then return end
        table.insert(self._pool, sf)
    end
    for _, part in ipairs(CollectionService:GetTagged("RaycastWhitelist" .. tostring(envId))) do
        if not _PB_haz(part) then
            try(part)
            if cnt >= 64 or #self._pool >= 30 then return end
            for _, child in ipairs(part:GetDescendants()) do
                if not _PB_haz(child) then try(child) end
                if cnt >= 64 or #self._pool >= 30 then return end
            end
        end
    end
end
function ProjectileBreakerTeleport:_BreakLine()
    local eid = self._poolEnvironmentId
    if eid == nil then return nil end
    if #self._pool < 30 then self:_ScanBatch(eid) end
    if #self._pool < 30 then return nil end
    self._nextPositionCooldown = os.clock() + Config.Evasion.ProjectileBreaker.RepositionInterval
    return self._pool[_PB_rng:NextInteger(1, #self._pool)]
end
function ProjectileBreakerTeleport:_FallbackCFrame(rootPartPos)
    local c   = Config.Evasion.ProjectileBreaker
    local pos = rootPartPos
    local anchor = c.FallbackAnchorFromCharacter and pos or Vector3.new(0, pos.Y, 0)
    local r  = c.FallbackBaseRadius
    return _RE_toEdge(_RE_rndCF(anchor, r, r + r * c.FallbackRadiusRandomFactor))
end
function ProjectileBreakerTeleport:Compute(rootPart)
    if os.clock() < self._nextPositionCooldown and self._lastBreakSurface ~= nil then
        return _PB_frame(self._lastBreakSurface, _PB_osc("Up"), _PB_osc("Fwd"))
    end
    if not self:_HasProjectileThreat() then
        self._lastBreakSurface = nil
        return self:_FallbackCFrame(rootPart.Position)
    end
    local sf = self:_BreakLine()
    if sf ~= nil then
        self._lastBreakSurface = sf
        return _PB_frame(sf, _PB_osc("Up"), _PB_osc("Fwd"))
    end
    return self:_FallbackCFrame(rootPart.Position)
end
function ProjectileBreakerTeleport:ResetState()
    self._nextPositionCooldown = -1; self._lastBreakSurface = nil
end

--------------------------------------------------------------------------------
-- Weapon picker (jM)
--------------------------------------------------------------------------------
local function _WClass(item)
    local i = item.Index
    return i == 1 and "Primary" or i == 2 and "Secondary" or i == 3 and "Melee" or nil
end
local function WeaponPickerGetAction(itemBehaviors)
    local cfg    = Config.Weapons
    local onEmpty = cfg.OnEmpty
    local bestPrio, backupPrio = math.huge, math.huge
    local bestItem, backupItem = nil, nil
    local anyEnabled = false
    for _, item in ipairs(itemBehaviors:GetItems()) do
        local cls = _WClass(item)
        if cls ~= nil and cfg.Enabled[cls] then
            anyEnabled = true
            local prio = table.find(cfg.Priority, cls) or math.huge
            if item.__type == "Gun" and item:GetAmmo() == 0 then
                if item:GetAmmoReserve() > 0 and prio < backupPrio then
                    if onEmpty == "Reload" then
                        bestItem = item; bestPrio = prio
                    else
                        backupPrio = prio; backupItem = item
                    end
                end
            elseif bestItem == nil or prio < bestPrio then
                bestItem = item; bestPrio = prio
            end
        end
    end
    if not anyEnabled then return nil end
    if bestItem ~= nil then
        local isEmpty = bestItem.__type == "Gun" and bestItem:GetAmmo() == 0
        if bestItem:IsEquipped() then
            return isEmpty and { Type = "Reload", Item = bestItem } or { Type = "Attack", Item = bestItem }
        end
        return { Type = "Swap", Item = bestItem }
    end
    if onEmpty == "Swap" then return nil end
    if backupItem ~= nil then
        return backupItem:IsEquipped()
            and { Type = "Reload", Item = backupItem }
            or  { Type = "Swap",   Item = backupItem }
    end
    return nil
end

--------------------------------------------------------------------------------
-- Riot shield state helper (jN)
--------------------------------------------------------------------------------
local function GetRiotShieldState(itemBehaviors)
    local s = itemBehaviors:FindMeleeByName("Riot Shield")
    if s == nil then return "None" end
    return s:IsEquipped() and "Equipped" or "Unequipped"
end

--------------------------------------------------------------------------------
-- RagebotController (jO)  — the actual engine
--------------------------------------------------------------------------------
local _origFPDH = workspace.FallenPartsDestroyHeight

local RagebotController = {}; RagebotController.__index = RagebotController

function RagebotController.new(fighters, playerTags, playerContext, stateHook, partGlue)
    local self = setmetatable({
        _fighters              = fighters,
        _playerContext         = playerContext,
        _stateHook             = stateHook,
        _enabled               = false,
        _innerContext          = nil,
        _lastTargetWorld       = nil,
        _lastDefensiveVA       = nil,
        _targetSelection       = TargetSelector.new(fighters, playerTags),
        _spatialLimitGate      = SpatialLimitGate.new(fighters),
        _hitscanStrategy       = HitscanStrategy.new(partGlue),
        _meleeStrategy         = MeleeStrategy.new(partGlue),
        _projectileBreaker     = ProjectileBreakerTeleport.new(fighters),
        _reloadGun             = nil,
        _reloadReadyAt         = nil,
        _reloadAckDeadline     = nil,
        _pendingDepletionAmmo  = nil,
    }, RagebotController)
    self:_Initialize()
    return self
end

function RagebotController:_Initialize()
    -- Observe context: fires when the local fighter spawns/dies
    self._playerContext:ObserveContext("ragebot", function(ic)
        self._innerContext = ic
        self:_ClearReloadTransport()
        -- Wire ProjectileBreaker to environment changes
        local fs = ic.FighterState
        self._projectileBreaker:BindEnvironment(fs.EnvironmentId)
        if fs.EnvironmentIdChanged then
            ic._trove:Connect(fs.EnvironmentIdChanged, function(id)
                self._projectileBreaker:BindEnvironment(id)
            end)
        end
    end)
    self._playerContext.ContextRemoved:Connect(function()
        self:_Reset()
        self._innerContext = nil
    end)
    -- Observe keybind
    self._playerContext:ObserveEnabledKeybind({ "Ragebot" }, function(en)
        self:SetEnabled(en)
        self:_Reset()
    end)
end

function RagebotController:SetEnabled(en)
    if self._enabled == en then return end
    self._enabled = en
    -- Apply FFlags that make server-side desync reliable
    workspace.FallenPartsDestroyHeight = en and (0/0) or _origFPDH
    pcall(v108, "DFIntS2PhysicsSenderRate",         en and "120" or "15")
    pcall(v108, "DFIntAssemblyHistoryBufferSize",    en and "2147483648" or "15")
    pcall(v108, "DFIntAssemblyHistorySkipSize",      en and "0" or "8")
    if not en then self:_ClearReloadTransport() end
end

function RagebotController:_ImmuneCFrame()
    return ImmuneRing.getImmune()
end

function RagebotController:Update(dt)
    local ic = self._innerContext
    if ic == nil then self:_Reset(); return end
    local fs = ic.FighterState
    if fs.EnvironmentId == nil or not self._enabled then self:_Reset(); return end
    local st = fs.Character.State
    if not st.Alive then self:_Reset(); return end

    local cc   = ic.CharacterController
    local cf   = cc:GetClientCFrame()
    local mode = Config.Evasion.Mode
    local wa   = WeaponPickerGetAction(ic.ItemBehaviors)

    -- Translocate mode: teleport every frame (except during reload transport)
    if mode == "Translocate" and self._reloadGun == nil and (wa == nil or wa.Type ~= "Reload") then
        self:_ApplyForcedCrouch(false)
        cc:SetServerCFrame(TranslocateCompute(cf, self._targetSelection:HasTargets()))
        return
    end

    local target = self._targetSelection:GetTarget()
    self._lastTargetWorld = target ~= nil and target.AliveState.RootPart.Position or nil

    local plan = self:_Plan(dt, wa, target, st.RootPart, cf, mode)
    self:_ApplyPlan(plan, target, ic)

    -- Track reload ready time
    local rg = self._reloadGun
    if rg ~= nil and self._reloadReadyAt == nil and self._pendingDepletionAmmo == nil and not rg:IsReloading() then
        self._reloadReadyAt = os.clock() + replication.getEstimatedReplicationDelay()
    end

    self:_ApplyForcedCrouch(plan.ShouldForceCrouch == true)

    -- Execute weapon action and track ammo depletion for reload transport
    local eg   = ic.ItemBehaviors:EquippedItemAsGun()
    local ammo = eg ~= nil and eg:GetAmmo() or 0
    local src  = eg ~= nil and eg.ShotRequestCount or 0
    if plan.WeaponAction ~= nil then
        plan.WeaponAction()
        local fired = eg ~= nil and (eg.ShotRequestCount - src) or 0
        if eg ~= nil and fired > 0 and eg:GetExpectedAmmoAfterPendingShots() <= 0 then
            cc:SetServerCFrame(self:_ImmuneCFrame())
            local now = os.clock()
            self._reloadGun              = eg
            self._reloadReadyAt          = now + replication.getEstimatedReplicationDelay()
            self._pendingDepletionAmmo   = ammo
            self._reloadAckDeadline      = now + replication.getEstimatedRemoteDelay() + replication.getEstimatedReplicationDelay()
        end
    end
end

function RagebotController:_Plan(dt, wa, target, rootPart, clientCFrame, mode)
    local inLimit = target ~= nil and not self._spatialLimitGate:Tick(target)
    -- Reload transport takes priority
    local rt = self:_PlanReloadTransport(wa)
    if rt ~= nil then return rt end
    if wa == nil then return self:_EvadePlan(clientCFrame, mode) end
    if wa.Type == "Swap" then
        local ev = self:_EvadePlan(clientCFrame, mode)
        local it = wa.Item
        ev.WeaponAction = function() it:Equip() end
        return ev
    end
    if wa.Type == "Reload" then return { CFrame = self:_ImmuneCFrame(), ShouldSkipDefense = true } end
    if target == nil then return self:_EvadePlan(clientCFrame, mode) end
    local item = wa.Item
    if item.__type == "Gun" then
        if item:IsReloading() then return { CFrame = self:_ImmuneCFrame(), ShouldSkipDefense = true } end
        local c, s = self._hitscanStrategy:Plan(dt, target, item, rootPart, inLimit)
        return { CFrame = c, WeaponAction = s, ShouldForceCrouch = true, IsAimPose = s ~= nil }
    end
    if item.__type == "Melee" then
        local c, v, a = self._meleeStrategy:Plan(dt, target, item, rootPart, inLimit)
        return { CFrame = c, ViewAngles = v, WeaponAction = a, ShouldSkipDefense = true, ShouldForceCrouch = true }
    end
    return {}
end

function RagebotController:_PlanReloadTransport(wa)
    local rg  = self._reloadGun
    local now = os.clock()
    if rg == nil then
        if wa ~= nil and wa.Type == "Reload" then
            self._reloadGun = wa.Item
            return { CFrame = self:_ImmuneCFrame(), ShouldSkipDefense = true }
        end
        return nil
    end
    -- If we've swapped away or gun changed, clear
    local ic = self._innerContext
    local eg = ic and ic.ItemBehaviors:EquippedItemAsGun() or nil
    if eg ~= rg or (wa ~= nil and (wa.Type == "Swap" or wa.Type == "Attack") and wa.Item ~= rg) then
        self:_ClearReloadTransport(); return nil
    end
    if rg:IsReloading() then
        self._reloadReadyAt = nil; self._pendingDepletionAmmo = nil; self._reloadAckDeadline = nil
        return { CFrame = self:_ImmuneCFrame(), ShouldSkipDefense = true }
    end
    local ammo = rg:GetAmmo()
    if self._pendingDepletionAmmo ~= nil then
        if not (ammo <= 0 and rg:GetAmmoReserve() > 0) then
            local dead = self._reloadAckDeadline
            local exp  = dead == nil or now >= dead
            if not exp then exp = rg:GetExpectedAmmoAfterPendingShots() > 0 end
            if exp then self:_ClearReloadTransport(); return nil end
            return { CFrame = self:_ImmuneCFrame(), ShouldSkipDefense = true }
        end
        self._pendingDepletionAmmo = nil; self._reloadAckDeadline = nil
    end
    if ammo > 0 or rg:GetAmmoReserve() <= 0 then
        self:_ClearReloadTransport(); return nil
    end
    local ra = self._reloadReadyAt
    if ra == nil then ra = now + replication.getEstimatedReplicationDelay(); self._reloadReadyAt = ra end
    local plan = { CFrame = self:_ImmuneCFrame(), ShouldSkipDefense = true }
    local dead = self._reloadAckDeadline
    if now >= ra and (dead == nil or now >= dead) then
        plan.WeaponAction = function()
            if rg:Reload() then
                self._reloadAckDeadline = os.clock() + replication.getEstimatedRemoteDelay() + replication.getEstimatedReplicationDelay()
            end
        end
    end
    return plan
end

function RagebotController:_EvadePlan(cf, mode)
    if mode == "Off" then return {} end
    if mode == "ProjectileBreaker" then
        return { CFrame = self._projectileBreaker:Compute(cf), ShouldSkipDefense = true }
    end
    return { CFrame = RandomEvasionCompute(cf) }
end

function RagebotController:_ApplyPlan(plan, target, ic)
    local cc = ic.CharacterController
    local cf = plan.CFrame
    if cf == nil or target == nil or plan.ShouldSkipDefense then
        cc:SetServerCFrame(cf)
        cc:SendViewAngles(20, plan.ViewAngles)
        return
    end
    local shield = GetRiotShieldState(ic.ItemBehaviors)
    local dcf    = getDefensiveCFrame(cf, shield, target.FighterState, target.AliveState.RootPart)
    cc:SetServerCFrame(dcf)
    if plan.IsAimPose or plan.ShouldDefendInPlace then
        self._lastDefensiveVA = getDefensiveViewAngles(shield, target.FighterState)
    end
    cc:SendViewAngles(9, plan.ViewAngles or self._lastDefensiveVA)
end

function RagebotController:_ApplyForcedCrouch(state)
    if state then
        self._stateHook:SetForced("IsCrouching", true)
    else
        self._stateHook:ClearForced("IsCrouching")
    end
end

function RagebotController:_ClearReloadTransport()
    self._reloadGun            = nil
    self._reloadReadyAt        = nil
    self._reloadAckDeadline    = nil
    self._pendingDepletionAmmo = nil
end

function RagebotController:_Reset()
    self:_ClearReloadTransport()
    self._lastTargetWorld = nil
    self._lastDefensiveVA = nil
    self:_ApplyForcedCrouch(false)
    self._meleeStrategy:ResetState()
    self._projectileBreaker:ResetState()
    local ic = self._innerContext
    if ic == nil then return end
    ic.CharacterController:SetServerCFrame(nil)
    ic.CharacterController:SendViewAngles(20, nil)
end

function RagebotController:GetLastTargetWorld() return self._lastTargetWorld end
function RagebotController:Destroy() self:_Reset() end

--------------------------------------------------------------------------------
-- CharacterController shim — wraps RootDesync + ViewAngleDriver per-character
-- The real cJ builds this inside PlayerContext; we patch in from fighters
--------------------------------------------------------------------------------
local CharacterController = {}; CharacterController.__index = CharacterController
function CharacterController.new(rootPart)
    return setmetatable({
        _rootDesync       = RootDesync.new(rootPart),
        _viewAngleDriver  = ViewAngleDriver.new(),
    }, CharacterController)
end
function CharacterController:SetServerCFrame(cf)   self._rootDesync:SetServerCFrame(cf) end
function CharacterController:GetServerCFrame()      return self._rootDesync:GetServerCFrame() end
function CharacterController:GetClientCFrame()      return self._rootDesync:GetClientCFrame() end
function CharacterController:HeartbeatUpdate()      self._rootDesync:HeartbeatUpdate() end
function CharacterController:SendViewAngles(slot,va) self._viewAngleDriver:SendViewAngles(slot, va) end
function CharacterController:FlushViewAngles()       self._viewAngleDriver:Flush() end
function CharacterController:Destroy()
    self._rootDesync:Destroy()
    self._viewAngleDriver:Destroy()
end

--------------------------------------------------------------------------------
-- Bootstrap — wire everything to the real game context from kiciahook globals
--------------------------------------------------------------------------------
-- Try to pull the live fighters / playerContext objects from getgenv()
-- (kiciahook sets these when it initialises; if standalone just reuse K)
local fighters_ref, playerContext_ref

local function tryGetLiveContext()
    local genv = getgenv and getgenv() or {}
    -- kiciahook exposes these globally after bootstrap
    local kr = genv.KiciaRebuild
    if kr and kr.fighters then fighters_ref = kr.fighters end
    if kr and kr.playerContext then playerContext_ref = kr.playerContext end
end
pcall(tryGetLiveContext)

-- If kiciahook isn't loaded we build a minimal stub that works once the
-- game's own fighter/PlayerContext is available through polling
local _ragebotInstance = nil
local _partGlue        = PartGlue.new()
local _stateHook       = StateHook.new()
local _heartbeatConn   = nil

local function bootstrap(fighters, playerContext)
    if _ragebotInstance then _ragebotInstance:Destroy() end
    _ragebotInstance = RagebotController.new(fighters, { GetPlayersWith = function() return {} end }, playerContext, _stateHook, _partGlue)
    _heartbeatConn = RunService.Heartbeat:Connect(function(dt)
        playerContext:HeartbeatUpdate()
        _ragebotInstance:Update(dt)
        playerContext:FlushViewAngles()
    end)
end

-- If we have live references from kiciahook, use them; else poll
if fighters_ref and playerContext_ref then
    bootstrap(fighters_ref, playerContext_ref)
else
    -- Poll until kiciahook sets them, or the game provides its own fighters
    local pollConn
    pollConn = RunService.Heartbeat:Connect(function()
        pcall(tryGetLiveContext)
        if fighters_ref and playerContext_ref then
            pollConn:Disconnect()
            bootstrap(fighters_ref, playerContext_ref)
        end
    end)
end

--------------------------------------------------------------------------------
-- ECLIPSE UI LIBRARY
--------------------------------------------------------------------------------
local CFG = {
    MainColor      = Color3.fromRGB(14, 14, 14),
    SecondaryColor = Color3.fromRGB(26, 26, 26),
    AccentColor    = Color3.fromRGB(189, 172, 255),
    TextColor      = Color3.fromRGB(200, 200, 200),
    TextDark       = Color3.fromRGB(120, 120, 120),
    StrokeColor    = Color3.fromRGB(40, 40, 40),
    Font           = Enum.Font.Code,
    BaseSize       = Vector2.new(600, 450)
}
local Library = { Flags = {}, Connections = {}, Unloaded = false }

local function Create(class, props, children)
    local inst = Instance.new(class)
    for i, v in pairs(props or {}) do inst[i] = v end
    for _, child in pairs(children or {}) do child.Parent = inst end
    return inst
end
local function Tween(obj, props, time, style, dir)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end
local function GetTextSize(text, size, font)
    return game:GetService("TextService"):GetTextSize(text, size, font, Vector2.new(10000, 10000))
end

local ScreenGui = Create("ScreenGui", {
    Name = "EclipseUI", Parent = game:GetService("CoreGui"),
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false, IgnoreGuiInset = true
})
local UIScale = Create("UIScale", { Parent = ScreenGui })
local function UpdateScale()
    local vp = workspace.CurrentCamera.ViewportSize
    UIScale.Scale = math.max(math.min((vp.X - 40) / CFG.BaseSize.X, (vp.Y - 40) / CFG.BaseSize.Y, 1), 0.6)
end
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
UpdateScale()

local NotifContainer = Create("Frame", {
    Parent = ScreenGui, Position = UDim2.new(1,-20,0,20), AnchorPoint = Vector2.new(1,0),
    Size = UDim2.new(0,300,1,0), BackgroundTransparency = 1, ZIndex = 100
})
Create("UIListLayout", { Parent = NotifContainer, Padding = UDim.new(0,5),
    HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Top })

function Library:Notify(msg, ntype)
    local col = (ntype=="success" and Color3.fromRGB(100,255,100)) or (ntype=="warning" and Color3.fromRGB(255,100,100)) or CFG.AccentColor
    local f = Create("Frame", { Parent = NotifContainer, Size = UDim2.new(0,0,0,30),
        BackgroundColor3 = CFG.MainColor, BorderSizePixel = 0, ClipsDescendants = true }, {
        Create("UIStroke", { Color = CFG.AccentColor, Thickness = 1, Transparency = 0.5 }),
        Create("Frame", { Size = UDim2.new(0,2,1,0), BackgroundColor3 = col }),
        Create("TextLabel", { Text = msg, TextColor3 = CFG.TextColor, Font = CFG.Font, TextSize = 12,
            Size = UDim2.new(1,-10,1,0), Position = UDim2.new(0,10,0,0),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left })
    })
    Tween(f, { Size = UDim2.new(0,250,0,35) }, 0.5, Enum.EasingStyle.Back)
    task.delay(3, function()
        Tween(f, { Size = UDim2.new(0,250,0,0), BackgroundTransparency = 1 }, 0.5)
        task.wait(0.5); f:Destroy()
    end)
end

local TooltipLabel = Create("TextLabel", { Parent = ScreenGui, Size = UDim2.new(0,0,0,20),
    BackgroundColor3 = CFG.SecondaryColor, TextColor3 = CFG.TextColor, TextSize = 11, Font = CFG.Font,
    BorderSizePixel = 0, Visible = false, ZIndex = 200 }, {
    Create("UIPadding", { PaddingLeft = UDim.new(0,5), PaddingRight = UDim.new(0,5) }),
    Create("UIStroke", { Color = CFG.StrokeColor })
})
local function AddTooltip(obj, text)
    obj.MouseEnter:Connect(function()
        TooltipLabel.Text = text
        TooltipLabel.Size = UDim2.fromOffset(GetTextSize(text,11,CFG.Font).X+12, 20)
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

local MainFrame = Create("Frame", { Name = "MainFrame", Parent = ScreenGui,
    Size = UDim2.fromOffset(CFG.BaseSize.X, CFG.BaseSize.Y),
    Position = UDim2.new(0.5,-300,0.5,-225), BackgroundColor3 = CFG.MainColor, BorderSizePixel = 0 }, {
    Create("UIStroke", { Color = CFG.StrokeColor }), Create("UICorner", { CornerRadius = UDim.new(0,3) })
})

local Dragging, DragInput, DragStart, StartPos = false, nil, nil, nil
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true; DragStart = input.Position; StartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local d = input.Position - DragStart
        Tween(MainFrame, { Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset+d.X, StartPos.Y.Scale, StartPos.Y.Offset+d.Y) }, 0.05)
    end
end)

local TopBar = Create("Frame", { Parent = MainFrame, Size = UDim2.new(1,0,0,30),
    BackgroundColor3 = CFG.MainColor, BorderSizePixel = 0 }, {
    Create("Frame", { Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,1,0), BackgroundColor3 = CFG.StrokeColor })
})
local TitleLabel = Create("TextLabel", { Parent = TopBar, Text = "eclipse.wtf | ragebot",
    TextColor3 = CFG.TextDark, TextSize = 13, Font = CFG.Font, BackgroundTransparency = 1,
    Size = UDim2.new(0,200,1,0), Position = UDim2.new(0,10,0,0),
    TextXAlignment = Enum.TextXAlignment.Left, RichText = true })
task.spawn(function()
    local texts = {"","e","ec","ecl","ecli","eclip","eclipse","eclipse.","eclipse.w","eclipse.wt","eclipse.wtf","eclipse.wtf |","eclipse.wtf | r","eclipse.wtf | ra","eclipse.wtf | rag","eclipse.wtf | rage","eclipse.wtf | rageb","eclipse.wtf | ragebot","eclipse.wtf | ragebo","eclipse.wtf | rageb","eclipse.wtf | rage","eclipse.wtf | rag","eclipse.wtf | ra","eclipse.wtf | r","eclipse.wtf |","eclipse.wtf","eclipse.wt","eclipse.w","eclipse.","eclipse","eclips","eclip","ecli","ecl","ec","e"}
    while not Library.Unloaded do
        for _, t in ipairs(texts) do
            if Library.Unloaded then break end
            local d = t
            if d:find("ragebot") then d = d:gsub("ragebot", '<font color="#bdacff">ragebot</font>') end
            if d:find("wtf") then d = d:gsub("wtf", '<font color="#bdacff">wtf</font>') end
            TitleLabel.Text = d; task.wait(0.2)
        end
    end
end)

local ContentContainer = Create("Frame", { Parent = MainFrame, Size = UDim2.new(1,0,1,-30),
    Position = UDim2.new(0,0,0,30), BackgroundTransparency = 1 })
local Sidebar = Create("Frame", { Parent = ContentContainer, Size = UDim2.new(0,60,1,0),
    BackgroundColor3 = Color3.fromRGB(17,17,17), BorderSizePixel = 0 }, {
    Create("UIListLayout", { Padding = UDim.new(0,10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top }),
    Create("UIPadding", { PaddingTop = UDim.new(0,15) })
})
local PagesContainer = Create("Frame", { Parent = ContentContainer, Size = UDim2.new(1,-60,1,0),
    Position = UDim2.new(0,60,0,0), BackgroundTransparency = 1 })

local Tabs = {}
function Library:Tab(name, icon)
    local TabButton = Create("TextButton", { Parent = Sidebar, Size = UDim2.new(0,40,0,40),
        BackgroundColor3 = CFG.MainColor, Text = "", TextSize = 20, TextColor3 = CFG.TextDark,
        Font = CFG.Font, AutoButtonColor = false }, {
        Create("ImageLabel", { Name = "Icon", Size = UDim2.new(0.6,0,0.6,0), Position = UDim2.new(0.2,0,0.2,0),
            BackgroundTransparency = 1, Image = "rbxassetid://" .. tostring(icon), ImageColor3 = CFG.TextDark }),
        Create("UICorner", { CornerRadius = UDim.new(0,6) })
    })
    local PageFrame = Create("ScrollingFrame", { Parent = PagesContainer, Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 2,
        ScrollBarImageColor3 = CFG.AccentColor, CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y })
    Create("UIPadding", { Parent = PageFrame, PaddingTop = UDim.new(0,15), PaddingLeft = UDim.new(0,15),
        PaddingRight = UDim.new(0,15), PaddingBottom = UDim.new(0,15) })
    local LeftCol  = Create("Frame", { Parent = PageFrame, Size = UDim2.new(0.48,0,1,0), BackgroundTransparency = 1 }, {
        Create("UIListLayout", { Padding = UDim.new(0,10), SortOrder = Enum.SortOrder.LayoutOrder })
    })
    local RightCol = Create("Frame", { Parent = PageFrame, Size = UDim2.new(0.48,0,1,0),
        Position = UDim2.new(0.52,0,0,0), BackgroundTransparency = 1 }, {
        Create("UIListLayout", { Padding = UDim.new(0,10), SortOrder = Enum.SortOrder.LayoutOrder })
    })
    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            Tween(t.Btn, { TextColor3 = CFG.TextDark, BackgroundColor3 = CFG.MainColor }, 0.2)
            t.Page.Visible = false
        end
        Tween(TabButton, { TextColor3 = CFG.AccentColor, BackgroundColor3 = CFG.SecondaryColor }, 0.2)
        PageFrame.Visible = true
    end)
    table.insert(Tabs, { Btn = TabButton, Page = PageFrame })
    if #Tabs == 1 then
        Tween(TabButton, { TextColor3 = CFG.AccentColor, BackgroundColor3 = CFG.SecondaryColor }, 0.2)
        PageFrame.Visible = true
    end
    local GF = {}; local LeftSide = true
    function GF:Group(title)
        local Col = LeftSide and LeftCol or RightCol; LeftSide = not LeftSide
        local GFrame = Create("Frame", { Parent = Col, Size = UDim2.new(1,0,0,0),
            AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(17,17,17),
            BorderSizePixel = 0 }, {
            Create("UIStroke", { Color = CFG.StrokeColor }), Create("UICorner", { CornerRadius = UDim.new(0,2) })
        })
        Create("Frame", { Parent = GFrame, Size = UDim2.new(1,0,0,25), BackgroundColor3 = CFG.SecondaryColor,
            BorderSizePixel = 0 }, {
            Create("UICorner", { CornerRadius = UDim.new(0,2) }),
            Create("Frame", { Size = UDim2.new(1,0,0,5), Position = UDim2.new(0,0,1,-5),
                BackgroundColor3 = CFG.SecondaryColor, BorderSizePixel = 0 }),
            Create("TextLabel", { Text = title, Size = UDim2.new(1,-20,1,0), Position = UDim2.new(0,8,0,0),
                BackgroundTransparency = 1, TextColor3 = CFG.TextColor, Font = Enum.Font.GothamBold,
                TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left }),
            Create("Frame", { Size = UDim2.new(0,4,0,4), Position = UDim2.new(1,-10,0.5,-2),
                BackgroundColor3 = CFG.AccentColor, BorderSizePixel = 0 }, {
                Create("UICorner", { CornerRadius = UDim.new(1,0) }) })
        })
        local Content = Create("Frame", { Parent = GFrame, Size = UDim2.new(1,0,0,0),
            Position = UDim2.new(0,0,0,25), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1 }, {
            Create("UIListLayout", { Padding = UDim.new(0,5), SortOrder = Enum.SortOrder.LayoutOrder }),
            Create("UIPadding", { PaddingTop = UDim.new(0,8), PaddingBottom = UDim.new(0,8),
                PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8) })
        })
        local IF = {}
        function IF:Toggle(cfg2)
            local En = cfg2.Default or false
            local F = Create("TextButton", { Parent = Content, Size = UDim2.new(1,0,0,20),
                BackgroundTransparency = 1, Text = "" })
            local Box = Create("Frame", { Parent = F, Size = UDim2.new(0,12,0,12),
                Position = UDim2.new(0,0,0.5,-6), BackgroundColor3 = CFG.SecondaryColor, BorderSizePixel = 0 }, {
                Create("UIStroke", { Color = CFG.StrokeColor })
            })
            local Check = Create("Frame", { Parent = Box, Size = UDim2.new(1,-4,1,-4),
                Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0.5,0.5),
                BackgroundColor3 = CFG.AccentColor, BackgroundTransparency = En and 0 or 1 })
            local Lbl = Create("TextLabel", { Parent = F, Text = cfg2.Name,
                TextColor3 = En and CFG.TextColor or CFG.TextDark, TextSize = 11, Font = CFG.Font,
                BackgroundTransparency = 1, Position = UDim2.new(0,18,0,0), Size = UDim2.new(1,-18,1,0),
                TextXAlignment = Enum.TextXAlignment.Left })
            if cfg2.Risky then Lbl.TextColor3 = Color3.fromRGB(200,80,80) end
            if cfg2.Tooltip then AddTooltip(F, cfg2.Tooltip) end
            local function Update()
                En = not En
                Tween(Check, { BackgroundTransparency = En and 0 or 1 }, 0.1)
                Tween(Lbl, { TextColor3 = En and CFG.TextColor or (cfg2.Risky and Color3.fromRGB(200,80,80) or CFG.TextDark) }, 0.1)
                if cfg2.Callback then cfg2.Callback(En) end
            end
            F.MouseButton1Click:Connect(Update)
            return { Set = function(v) if v ~= En then Update() end end }
        end
        function IF:Slider(cfg2)
            local Val = cfg2.Default or cfg2.Min; local Drag = false
            local F = Create("Frame", { Parent = Content, Size = UDim2.new(1,0,0,32), BackgroundTransparency = 1 })
            Create("TextLabel", { Parent = F, Text = cfg2.Name, TextColor3 = CFG.TextDark, TextSize = 11,
                Font = CFG.Font, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,15), TextXAlignment = Enum.TextXAlignment.Left })
            local VLbl = Create("TextLabel", { Parent = F, Text = Val..(cfg2.Unit or ""), TextColor3 = CFG.TextDark,
                TextSize = 11, Font = CFG.Font, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,15), TextXAlignment = Enum.TextXAlignment.Right })
            local SBG = Create("Frame", { Parent = F, Size = UDim2.new(1,0,0,6), Position = UDim2.new(0,0,0,20),
                BackgroundColor3 = CFG.SecondaryColor, BorderSizePixel = 0 }, {
                Create("UIStroke", { Color = CFG.StrokeColor }), Create("UICorner", { CornerRadius = UDim.new(1,0) })
            })
            local Fill = Create("Frame", { Parent = SBG, BackgroundColor3 = CFG.AccentColor,
                Size = UDim2.new((Val-cfg2.Min)/(cfg2.Max-cfg2.Min), 0, 1, 0) }, {
                Create("UICorner", { CornerRadius = UDim.new(1,0) })
            })
            local function UpdSlider(input)
                local pct = math.clamp((input.Position.X - SBG.AbsolutePosition.X) / SBG.AbsoluteSize.X, 0, 1)
                Val = math.floor(cfg2.Min + (cfg2.Max - cfg2.Min) * pct)
                Fill.Size = UDim2.new(pct,0,1,0); VLbl.Text = Val..(cfg2.Unit or "")
                if cfg2.Callback then cfg2.Callback(Val) end
            end
            F.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    Drag = true; UpdSlider(i)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if Drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then UpdSlider(i) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Drag = false end
            end)
            if cfg2.Tooltip then AddTooltip(F, cfg2.Tooltip) end
        end
        function IF:Dropdown(cfg2)
            local Exp = false; local Cur = cfg2.Default or cfg2.Options[1]
            local F = Create("Frame", { Parent = Content, Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1, ZIndex = 20 })
            Create("TextLabel", { Parent = F, Text = cfg2.Name, TextColor3 = CFG.TextDark, TextSize = 11,
                Font = CFG.Font, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,15), TextXAlignment = Enum.TextXAlignment.Left })
            local MB = Create("TextButton", { Parent = F, Size = UDim2.new(1,0,0,20), Position = UDim2.new(0,0,0,16),
                BackgroundColor3 = CFG.SecondaryColor, BorderSizePixel = 0, Text = "", AutoButtonColor = false }, {
                Create("UIStroke", { Color = CFG.StrokeColor }), Create("UICorner", { CornerRadius = UDim.new(0,3) }),
                Create("TextLabel", { Name = "Val", Text = Cur, Size = UDim2.new(1,-20,1,0), Position = UDim2.new(0,5,0,0),
                    BackgroundTransparency = 1, TextColor3 = CFG.TextColor, TextSize = 11, Font = CFG.Font,
                    TextXAlignment = Enum.TextXAlignment.Left }),
                Create("TextLabel", { Text = "▼", Size = UDim2.new(0,20,1,0), Position = UDim2.new(1,-20,0,0),
                    BackgroundTransparency = 1, TextColor3 = CFG.TextDark, TextSize = 10 })
            })
            local LF = Create("ScrollingFrame", { Parent = MB, Size = UDim2.new(1,0,0,0),
                Position = UDim2.new(0,0,1,2), BackgroundColor3 = CFG.SecondaryColor, BorderSizePixel = 0,
                Visible = false, ZIndex = 50, CanvasSize = UDim2.new(0,0,0,0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2 }, {
                Create("UIStroke", { Color = CFG.StrokeColor }), Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
                Create("UICorner", { CornerRadius = UDim.new(0,3) })
            })
            for _, opt in ipairs(cfg2.Options) do
                local Btn = Create("TextButton", { Parent = LF, Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1,
                    Text = opt, TextColor3 = (opt == Cur) and CFG.AccentColor or CFG.TextDark, TextSize = 11, Font = CFG.Font })
                Btn.MouseButton1Click:Connect(function()
                    Cur = opt; MB.Val.Text = opt
                    if cfg2.Callback then cfg2.Callback(opt) end
                    Exp = false; Tween(LF, { Size = UDim2.new(1,0,0,0) }, 0.1); task.wait(0.1); LF.Visible = false
                end)
            end
            MB.MouseButton1Click:Connect(function()
                Exp = not Exp
                if Exp then
                    LF.Visible = true; Tween(LF, { Size = UDim2.new(1,0,0,math.min(#cfg2.Options*20,100)) }, 0.1)
                else
                    Tween(LF, { Size = UDim2.new(1,0,0,0) }, 0.1); task.wait(0.1); LF.Visible = false
                end
            end)
            if cfg2.Tooltip then AddTooltip(F, cfg2.Tooltip) end
        end
        function IF:Button(cfg2)
            local Btn = Create("TextButton", { Parent = Content, Size = UDim2.new(1,0,0,22),
                BackgroundColor3 = CFG.SecondaryColor, Text = cfg2.Name, TextColor3 = CFG.TextDark,
                Font = Enum.Font.GothamBold, TextSize = 10 }, {
                Create("UIStroke", { Color = CFG.StrokeColor }), Create("UICorner", { CornerRadius = UDim.new(0,3) })
            })
            if cfg2.Variant == "Primary" then Btn.BackgroundColor3 = CFG.AccentColor; Btn.TextColor3 = Color3.new(0,0,0)
            elseif cfg2.Variant == "Danger" then Btn.BackgroundColor3 = Color3.fromRGB(200,60,60); Btn.TextColor3 = Color3.new(0,0,0) end
            Btn.MouseButton1Click:Connect(function() if cfg2.Callback then cfg2.Callback() end end)
            if cfg2.Tooltip then AddTooltip(Btn, cfg2.Tooltip) end
        end
        return IF
    end
    return GF
end

--------------------------------------------------------------------------------
-- UI WIRING
--------------------------------------------------------------------------------
local RagebotTab = Library:Tab("Ragebot", 125012650497883)

local ActivationGroup = RagebotTab:Group("Activation")
ActivationGroup:Toggle({ Name = "Enable Ragebot", Default = false, Tooltip = "Toggle the ragebot",
    Callback = function(v)
        Config.Enabled = v
        if _ragebotInstance then _ragebotInstance:SetEnabled(v) end
    end })
ActivationGroup:Toggle({ Name = "Prioritize Hackers", Default = false, Tooltip = "Target tagged hackers first",
    Callback = function(v) Config.PrioritizeHackers = v end })
ActivationGroup:Slider({ Name = "Stability", Min = 0, Max = 500, Default = 150, Unit = " ms",
    Tooltip = "ms before spatial limit expires to fire",
    Callback = function(v) Config.Stability = v / 1000 end })
ActivationGroup:Slider({ Name = "Shoot Frames", Min = 1, Max = 50, Default = 1,
    Tooltip = "Lock window multiplier — higher = fires longer each hit",
    Callback = function(v) Config.ShootFrames = v end })

local WeaponGroup = RagebotTab:Group("Weapon Strategy")
WeaponGroup:Toggle({ Name = "Primary Enabled",   Default = true,  Callback = function(v) Config.Weapons.Enabled.Primary   = v end })
WeaponGroup:Toggle({ Name = "Secondary Enabled", Default = true,  Callback = function(v) Config.Weapons.Enabled.Secondary = v end })
WeaponGroup:Toggle({ Name = "Melee Enabled",     Default = true,  Callback = function(v) Config.Weapons.Enabled.Melee     = v end })
WeaponGroup:Dropdown({ Name = "On Empty", Options = {"Reload","Swap","SwapOrReload"}, Default = "SwapOrReload",
    Tooltip = "What to do when the active weapon has no ammo",
    Callback = function(v) Config.Weapons.OnEmpty = v end })

local EvasionGroup = RagebotTab:Group("Evasion")
EvasionGroup:Dropdown({ Name = "Mode", Options = {"Off","Random","Translocate","ProjectileBreaker"}, Default = "Random",
    Tooltip = "How the bot evades while idle/reloading",
    Callback = function(v) Config.Evasion.Mode = v end })
EvasionGroup:Toggle({ Name = "Random: Anchor to Character", Default = false,
    Callback = function(v) Config.Evasion.Random.AnchorFromCharacter = v end })
EvasionGroup:Slider({ Name = "Random: Base Radius", Min = 5, Max = 10000, Default = 100,
    Callback = function(v) Config.Evasion.Random.BaseRadius = v end })
EvasionGroup:Slider({ Name = "Random: Factor", Min = 0, Max = 100, Default = 50, Unit = "%",
    Callback = function(v) Config.Evasion.Random.RadiusRandomFactor = v / 100 end })
EvasionGroup:Slider({ Name = "Translocate: Offset", Min = -50, Max = 50, Default = -5,
    Tooltip = "Vertical offset from the floor of OutOfBoundsPart",
    Callback = function(v) Config.Evasion.Translocate.Offset = v end })

local PBGroup = RagebotTab:Group("Projectile Breaker")
PBGroup:Slider({ Name = "Forward Depth Max", Min = 0, Max = 100, Default = 40, Unit = " dm",
    Callback = function(v) Config.Evasion.ProjectileBreaker.DepthForward.Max = v / 10 end })
PBGroup:Slider({ Name = "Forward Frequency",  Min = 0, Max = 200, Default = 50, Unit = " dHz",
    Callback = function(v) Config.Evasion.ProjectileBreaker.DepthForwardFrequency = v / 10 end })
PBGroup:Slider({ Name = "Upward Depth Max",  Min = 0, Max = 100, Default = 55, Unit = " dm",
    Callback = function(v) Config.Evasion.ProjectileBreaker.DepthUp.Max = v / 10 end })
PBGroup:Slider({ Name = "Upward Frequency",  Min = 0, Max = 200, Default = 50, Unit = " dHz",
    Callback = function(v) Config.Evasion.ProjectileBreaker.DepthUpFrequency = v / 10 end })
PBGroup:Slider({ Name = "Reposition Interval", Min = 5, Max = 200, Default = 30, Unit = " cs",
    Callback = function(v) Config.Evasion.ProjectileBreaker.RepositionInterval = v / 100 end })
PBGroup:Toggle({ Name = "Fallback: Anchor to Character", Default = false,
    Callback = function(v) Config.Evasion.ProjectileBreaker.FallbackAnchorFromCharacter = v end })
PBGroup:Slider({ Name = "Fallback: Base Radius", Min = 5, Max = 10000, Default = 100,
    Callback = function(v) Config.Evasion.ProjectileBreaker.FallbackBaseRadius = v end })

--------------------------------------------------------------------------------
-- Toggle + mobile button
--------------------------------------------------------------------------------
Library.MenuKey = Enum.KeyCode.RightShift
local Visible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Library.MenuKey then
        Visible = not Visible; MainFrame.Visible = Visible
    end
end)
Create("ImageButton", {
    Parent = ScreenGui, Size = UDim2.new(0,40,0,40), Position = UDim2.new(0.5,0,0,10),
    AnchorPoint = Vector2.new(0.5,0), BackgroundColor3 = CFG.MainColor,
    Image = "rbxassetid://3926305904", ImageColor3 = CFG.AccentColor, AutoButtonColor = false }, {
    Create("UICorner", { CornerRadius = UDim.new(1,0) }),
    Create("UIStroke", { Color = CFG.AccentColor, Thickness = 2 })
}).MouseButton1Click:Connect(function()
    Visible = not Visible; MainFrame.Visible = Visible
end)

Library:Notify("Ragebot loaded", "success")

--------------------------------------------------------------------------------
-- Unload via K.onUnload if running under kiciahook
--------------------------------------------------------------------------------
if getgenv and getgenv().KiciaRebuild and getgenv().KiciaRebuild.onUnload then
    getgenv().KiciaRebuild.onUnload(function()
        Library.Unloaded = true
        if _heartbeatConn then _heartbeatConn:Disconnect() end
        if _ragebotInstance then _ragebotInstance:Destroy() end
        _partGlue:Destroy()
        _stateHook:Destroy()
        ScreenGui:Destroy()
        workspace.FallenPartsDestroyHeight = _origFPDH
    end)
end

return {
    Config                    = Config,
    RagebotController         = RagebotController,
    TargetSelector            = TargetSelector,
    HitscanStrategy           = HitscanStrategy,
    MeleeStrategy             = MeleeStrategy,
    SpatialLimitGate          = SpatialLimitGate,
    ProjectileBreakerTeleport = ProjectileBreakerTeleport,
    WeaponPickerGetAction     = WeaponPickerGetAction,
    RandomEvasionCompute      = RandomEvasionCompute,
    TranslocateCompute        = TranslocateCompute,
    ImmuneRing                = ImmuneRing,
    PartGlue                  = PartGlue,
    RootDesync                = RootDesync,
    ViewAngleDriver           = ViewAngleDriver,
    StateHook                 = StateHook,
}
