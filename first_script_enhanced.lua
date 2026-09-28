-- Enhanced First Script
-- Built from the original first script's firing path.
-- Enhancements:
--   * robust character / fighter refresh
--   * FighterController entity-based target acquisition
--   * duel/team aware filtering
--   * target validity / invincibility checks
--   * target scoring instead of distance-only selection
--   * automatic weapon selection across Primary/Secondary/Melee
--   * ammo-aware reload handling
--   * deflection / katana guard detection
--   * stable per-frame restore instead of repeatedly stacking restore callbacks
--   * adaptive target range
--   * protected remote / module resolution
--
-- This keeps the first script's compact UseItem payload rather than
-- copying the second script's much larger runtime/hook architecture.

local repS = cloneref(game:GetService("ReplicatedStorage"))
local plrs = cloneref(game:GetService("Players"))
local runS = cloneref(game:GetService("RunService"))
local ws = cloneref(game:GetService("Workspace"))
local lplr = plrs.LocalPlayer

local util = require(repS.Modules.Utility)
local enum = require(repS.Modules.EnumLibrary)
local FighterController = require(lplr.PlayerScripts.Controllers.FighterController)
local SpectateController = require(lplr.PlayerScripts.Controllers:WaitForChild("SpectateController"))

getgenv().Config = getgenv().Config or {
    Enabled = true,

    -- 0.0005 is retained from the original script.
    FireRate = 0.0005,

    -- Automatic means the script chooses a usable item.
    -- Valid values: "Automatic", "Primary", "Secondary", "Melee".
    WeaponSlot = "Automatic",

    MaxTargetDistance = 750,

    -- Target selection.
    PreferLowHealth = true,
    PreferVisible = true,
    PreferNearCrosshair = true,

    -- Prediction.
    Prediction = true,
    PredictionStrength = 0.08,

    -- Safety / stability.
    SkipInvincible = true,
    SkipSpectating = true,
    SkipDeflecting = true,

    -- Original first-script desync behaviour.
    Desync = true,
    KnifeDesync = true,
}

local slots = {
    Primary = 1,
    Secondary = 2,
    Melee = 3,
}

local function cfg(name, fallback)
    local value = getgenv().Config[name]
    if value == nil then
        return fallback
    end
    return value
end

local function safeFind(root, ...)
    local node = root
    for _, name in ipairs({...}) do
        if not node then return nil end
        node = node:FindFirstChild(name)
    end
    return node
end

local useItemRemote = safeFind(
    repS,
    "Remotes", "Replication", "Fighter", "UseItem"
)

local function getLocalFighter()
    return FighterController and FighterController.LocalFighter
end

local function getCharacter()
    local char = lplr.Character
    if char and char.Parent then
        return char
    end
    return nil
end

local function getRoot(character)
    character = character or getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(character)
    return character and character:FindFirstChildWhichIsA("Humanoid")
end

local function isAliveCharacter(character)
    local hum = getHumanoid(character)
    return hum ~= nil and hum.Health > 0
end

local function getDuelTeam(player)
    local duel = SpectateController and SpectateController.CurrentDuelSubject
    if not duel then return nil end

    local ok, dueler = pcall(function()
        return duel:GetDueler(player)
    end)

    if ok and dueler then
        local okTeam, team = pcall(function()
            return dueler:Get("TeamID")
        end)
        if okTeam then
            return team
        end
    end

    return nil
end

local function isEnemy(player)
    if not player or player == lplr then
        return false
    end

    local localDuelTeam = getDuelTeam(lplr)
    local theirDuelTeam = getDuelTeam(player)

    if localDuelTeam ~= nil and theirDuelTeam ~= nil then
        return localDuelTeam ~= theirDuelTeam
    end

    local localTeam = lplr:GetAttribute("TeamID")
    local theirTeam = player:GetAttribute("TeamID")

    if localTeam ~= nil and theirTeam ~= nil then
        return localTeam ~= theirTeam
    end

    if lplr.Team ~= nil and player.Team ~= nil then
        return lplr.Team ~= player.Team
    end

    return true
end

local function getFighterForPlayer(player)
    local objects = FighterController and FighterController.Objects
    if type(objects) ~= "table" then
        return nil
    end

    for _, fighter in pairs(objects) do
        local ok, owner = pcall(function()
            return fighter.Player
        end)
        if ok and owner == player then
            return fighter
        end
    end

    return nil
end

local function getTargetParts(player, fighter)
    local character = player and player.Character
    if not character then
        return nil
    end

    local entity = fighter and fighter.Entity
    local model = entity and entity.Model or character

    local head =
        model:FindFirstChild("HitboxHead")
        or model:FindFirstChild("Head")

    local body =
        model:FindFirstChild("HitboxBody")
        or model:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("HumanoidRootPart")

    if not head or not body then
        return nil
    end

    return model, head, body, entity
end

local function isTargetDeflecting(fighter)
    if not fighter then return false end

    local equipped = fighter.EquippedItem
    if not equipped then return false end

    local viewModel = equipped.ViewModel
    local name = viewModel and viewModel.Name

    if name ~= "Katana" then
        return false
    end

    local cooldown = equipped._attack_cooldown
    return type(cooldown) == "number" and cooldown > tick()
end

local function isInvincible(fighter)
    if not fighter or not fighter.Entity then
        return false
    end

    local entity = fighter.Entity
    local data = entity.Data

    if type(data) == "table" then
        return data.IsInvincible == true
    end

    local ok, value = pcall(function()
        return entity:Get("IsInvincible")
    end)

    return ok and value == true
end

local function isSpectating(fighter)
    if not fighter then return false end
    local ok, value = pcall(function()
        return fighter:Get("IsSpectating")
    end)
    return ok and value == true
end

local function hasLineOfSight(origin, targetPart, ignoreList)
    if not origin or not targetPart then
        return true
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignoreList or {}
    params.IgnoreWater = true

    local direction = targetPart.Position - origin
    local result = ws:Raycast(origin, direction, params)

    if not result then
        return true
    end

    return result.Instance:IsDescendantOf(targetPart.Parent)
end

local function getCameraDirectionScore(targetPosition)
    local camera = ws.CurrentCamera
    if not camera then
        return 0
    end

    local direction = (targetPosition - camera.CFrame.Position)
    if direction.Magnitude <= 0 then
        return 1
    end

    direction = direction.Unit
    return math.clamp(camera.CFrame.LookVector:Dot(direction), -1, 1)
end

local function collectTargets()
    local out = {}
    local myRoot = getRoot()

    if not myRoot then
        return out
    end

    local objects = FighterController and FighterController.Objects

    -- Prefer FighterController's live entity table because it matches
    -- the game's own combat objects more closely than Player.Character.
    if type(objects) == "table" then
        for _, fighter in pairs(objects) do
            local player = fighter and fighter.Player

            if player and isEnemy(player) then
                local character = player.Character

                if character and isAliveCharacter(character) then
                    if not (cfg("SkipSpectating", true) and isSpectating(fighter)) then
                        local model, head, body, entity = getTargetParts(player, fighter)

                        if model and head and body then
                            local invincible = isInvincible(fighter)
                            local deflecting = isTargetDeflecting(fighter)
                            local distance = (myRoot.Position - body.Position).Magnitude

                            if distance <= cfg("MaxTargetDistance", 750)
                                and not (cfg("SkipInvincible", true) and invincible)
                                and not (cfg("SkipDeflecting", true) and deflecting) then

                                local visible = hasLineOfSight(
                                    myRoot.Position,
                                    head,
                                    {getCharacter()}
                                )

                                out[#out + 1] = {
                                    player = player,
                                    fighter = fighter,
                                    entity = entity,
                                    model = model,
                                    head = head,
                                    root = body,
                                    distance = distance,
                                    visible = visible,
                                    health = getHumanoid(character) and getHumanoid(character).Health or 100,
                                    cameraScore = getCameraDirectionScore(head.Position),
                                }
                            end
                        end
                    end
                end
            end
        end
    end

    -- Fallback for builds where Objects is temporarily unavailable.
    if #out == 0 then
        for _, player in ipairs(plrs:GetPlayers()) do
            if isEnemy(player) then
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local head = character and (character:FindFirstChild("Head")
                    or character:FindFirstChild("HitboxHead"))
                local hum = getHumanoid(character)

                if root and head and hum and hum.Health > 0 then
                    local distance = (myRoot.Position - root.Position).Magnitude

                    if distance <= cfg("MaxTargetDistance", 750) then
                        out[#out + 1] = {
                            player = player,
                            fighter = nil,
                            entity = nil,
                            model = character,
                            head = head,
                            root = root,
                            distance = distance,
                            visible = hasLineOfSight(
                                myRoot.Position,
                                head,
                                {getCharacter()}
                            ),
                            health = hum.Health,
                            cameraScore = getCameraDirectionScore(head.Position),
                        }
                    end
                end
            end
        end
    end

    return out
end

local function scoreTarget(target)
    local score = 0

    -- Distance remains important, but no longer controls everything.
    score -= target.distance

    if cfg("PreferVisible", true) and target.visible then
        score += 350
    end

    if cfg("PreferNearCrosshair", true) then
        score += target.cameraScore * 250
    end

    if cfg("PreferLowHealth", true) then
        score += math.max(0, 150 - target.health)
    end

    return score
end

local function getBestTarget()
    local best, bestScore = nil, -math.huge

    for _, target in ipairs(collectTargets()) do
        local score = scoreTarget(target)

        if score > bestScore then
            best = target
            bestScore = score
        end
    end

    return best
end

local function getWeaponName(item)
    if not item then return "" end

    local ok, name = pcall(function()
        return item.Name
    end)

    if ok and name then
        return tostring(name)
    end

    local ok2, value = pcall(function()
        return item:Get("Name")
    end)

    return ok2 and tostring(value or "") or ""
end

local function getObjectId(item)
    if not item then return nil end

    local ok, id = pcall(function()
        return item:Get("ObjectID")
    end)

    return ok and id or nil
end

local function getAmmo(item)
    if not item then return 0 end

    local data = rawget(item, "Data")
    if type(data) == "table" and type(data.Ammo) == "number" then
        return data.Ammo
    end

    local ok, value = pcall(function()
        return item:Get("Ammo")
    end)

    return ok and (tonumber(value) or 0) or 0
end

local function getMaxAmmo(item)
    if not item then return nil end

    local info = rawget(item, "Info")
    if type(info) == "table" and type(info.MaxAmmo) == "number" then
        return info.MaxAmmo
    end

    return nil
end

local function isReloading(item)
    if not item then return false end

    local now = tick()

    local reloadCooldown = rawget(item, "_reload_cooldown")
    if type(reloadCooldown) == "number" and now < reloadCooldown then
        return true
    end

    local noAmmoCooldown = rawget(item, "_shoot_cooldown_no_ammo")
    return type(noAmmoCooldown) == "number" and now < noAmmoCooldown
end

local function itemCategory(index)
    if index == 1 then return "Primary" end
    if index == 2 then return "Secondary" end
    if index == 3 then return "Melee" end
    return nil
end

local function chooseWeapon()
    local fighter = getLocalFighter()
    if not fighter then return nil end

    local items = fighter.Items
    if type(items) ~= "table" then
        local equipped = fighter.EquippedItem
        return equipped
    end

    local requested = cfg("WeaponSlot", "Automatic")

    if requested ~= "Automatic" then
        local index = slots[requested]
        local item = index and items[index]
        if item then
            return item, index
        end
    end

    -- Automatic selection:
    -- keep a usable equipped item if possible, otherwise choose the first
    -- usable item in Primary -> Secondary -> Melee order.
    local bestItem, bestIndex = nil, nil

    for index = 1, 3 do
        local item = items[index]

        if type(item) == "table" then
            local ammo = getAmmo(item)
            local maxAmmo = getMaxAmmo(item)
            local name = getWeaponName(item)

            local usable =
                (item == fighter.EquippedItem)
                or (name == "Knife")
                or (maxAmmo == nil)
                or (ammo > 0)

            if usable then
                bestItem = item
                bestIndex = index

                if item == fighter.EquippedItem then
                    break
                end
            end
        end
    end

    return bestItem, bestIndex
end

local function equipWeapon(item, index)
    if not item then return end

    local fighter = getLocalFighter()
    if not fighter then return end

    local equipped = fighter.EquippedItem
    if equipped == item then
        return
    end

    if index then
        pcall(function()
            fighter:EquipItem(index)
        end)
    end
end

local function tryReload(item)
    if not item or isReloading(item) then
        return false
    end

    local objectId = getObjectId(item)
    if not objectId or not useItemRemote then
        return false
    end

    local data = rawget(item, "Data")
    local reserve = data and data.AmmoReserve

    if type(reserve) == "number" and reserve <= 0 then
        return false
    end

    local startReload = enum:ToEnum("StartReloading")
    local reload = enum:ToEnum("Reload")

    if not startReload or not reload then
        return false
    end

    local ok = pcall(function()
        useItemRemote:FireServer(
            objectId,
            startReload,
            {
                [utf8.char(1)] = reload,
                [utf8.char(2)] = reload,
            },
            nil
        )
    end)

    return ok
end

local function hasKnifeViewModel(targetPlayer)
    if not cfg("KnifeDesync", true) or not targetPlayer then
        return false
    end

    local viewModels = ws:FindFirstChild("ViewModels")
    if not viewModels then
        return false
    end

    local targetName = targetPlayer.Name

    for _, model in ipairs(viewModels:GetChildren()) do
        if model:IsA("Model")
            and string.find(model.Name, targetName, 1, true)
            and string.find(model.Name, "Knife", 1, true) then
            return true
        end
    end

    return false
end

local function getPredictedPosition(target)
    local position = target.head.Position

    if not cfg("Prediction", true) then
        return position
    end

    local root = target.root
    local velocity = root.AssemblyLinearVelocity

    return position + velocity * cfg("PredictionStrength", 0.08)
end

local function makeDesyncCFrame(target)
    if not cfg("Desync", true) then
        return nil
    end

    local targetRoot = target.root
    local targetPlayer = target.player

    local offset
    if hasKnifeViewModel(targetPlayer) then
        offset = CFrame.new(0, 8, -18)
    else
        offset = CFrame.new(0, 3, -20)
    end

    local pos = (targetRoot.CFrame * offset).Position
    local predicted = getPredictedPosition(target)

    return CFrame.lookAt(pos, predicted)
end

local lastFire = 0
local restoreState = nil

local function applyTemporaryRoot(cframe)
    local character = getCharacter()
    local root = getRoot(character)

    if not root or not cframe then
        return
    end

    if restoreState then
        restoreState.root = root
        restoreState.cf = root.CFrame
        restoreState.velocity = root.AssemblyLinearVelocity
        restoreState.angular = root.AssemblyAngularVelocity
    else
        restoreState = {
            root = root,
            cf = root.CFrame,
            velocity = root.AssemblyLinearVelocity,
            angular = root.AssemblyAngularVelocity,
        }
    end

    root.CFrame = cframe
end

local function restoreRoot()
    local state = restoreState
    restoreState = nil

    if not state or not state.root or not state.root.Parent then
        return
    end

    state.root.CFrame = state.cf
    state.root.AssemblyLinearVelocity = state.velocity
    state.root.AssemblyAngularVelocity = state.angular
end

local function fireCurrentWeapon(target, item)
    if not target or not item or not useItemRemote then
        return false
    end

    local objectId = getObjectId(item)
    if not objectId then
        return false
    end

    if isReloading(item) then
        return false
    end

    local now = tick()
    local fireRate = math.max(0, tonumber(cfg("FireRate", 0.0005)) or 0.0005)

    if now - lastFire < fireRate then
        return false
    end

    local predictedPosition = getPredictedPosition(target)
    local originRoot = getRoot()

    if not originRoot then
        return false
    end

    local aimCF = CFrame.lookAt(originRoot.Position, predictedPosition)

    -- Keep the original first script's exact hitbox/object-space concept.
    local targetCF = target.head.CFrame
    local objSpaceHeadOffset = CFrame.new(0, 0, 0)

    local cameradata = {}
    cameradata[utf8.char(1)] = {
        [utf8.char(0)] = util:EncodeCFrame(aimCF),
        [utf8.char(1)] = util:EncodeCFrame(targetCF),
        [utf8.char(2)] = target.head,
        [utf8.char(3)] = util:EncodeCFrame(objSpaceHeadOffset),
    }

    local ok = pcall(function()
        useItemRemote:FireServer(
            objectId,
            enum:ToEnum("StartShooting"),
            cameradata,
            nil
        )
    end)

    if ok then
        lastFire = now
    end

    return ok
end

-- Character refresh.
lplr.CharacterAdded:Connect(function()
    restoreState = nil
    lastFire = 0
end)

-- Single restore pass. The original script created a new BindToRenderStep
-- callback for every shot; this version uses one stable callback.
runS:BindToRenderStep(
    "__EnhancedFirstRestore",
    Enum.RenderPriority.Last.Value,
    function()
        restoreRoot()
    end
)

-- Main combat loop.
runS.Heartbeat:Connect(function()
    if not cfg("Enabled", true) then
        restoreRoot()
        return
    end

    local fighter = getLocalFighter()
    local character = getCharacter()
    local root = getRoot(character)

    if not fighter or not root then
        restoreRoot()
        return
    end

    local target = getBestTarget()
    if not target then
        restoreRoot()
        return
    end

    -- Refresh the weapon choice dynamically instead of forcing one slot.
    local item, index = chooseWeapon()
    if not item then
        return
    end

    if fighter.EquippedItem ~= item then
        equipWeapon(item, index)
        return
    end

    -- Empty magazine: request reload rather than wasting the shot cycle.
    if getAmmo(item) <= 0 and getMaxAmmo(item) ~= nil then
        tryReload(item)
        return
    end

    if cfg("SkipDeflecting", true) and isTargetDeflecting(target.fighter) then
        return
    end

    local desyncCF = makeDesyncCFrame(target)

    if desyncCF then
        applyTemporaryRoot(desyncCF)
    end

    fireCurrentWeapon(target, item)
end)

-- Periodic weapon sanity check. This is intentionally slower than the combat loop.
task.spawn(function()
    while task.wait(0.75) do
        if not cfg("Enabled", true) then
            continue
        end

        local fighter = getLocalFighter()
        if not fighter then
            continue
        end

        local item, index = chooseWeapon()
        if item and fighter.EquippedItem ~= item then
            equipWeapon(item, index)
        end
    end
end)

print("[Enhanced First] initialized")
