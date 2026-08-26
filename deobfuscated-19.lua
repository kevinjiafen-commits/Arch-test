-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
local v3 = unpack or table.unpack
local s1 = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
t2.value1 = loadstring(game:HttpGet(s1 .. "Library.lua"))()
local v5 = loadstring(game:HttpGet(s1 .. "addons/ThemeManager.lua"))()
local v6 = loadstring(game:HttpGet(s1 .. "addons/SaveManager.lua"))()
t2.value2 = t2.value1.Options
t2.value3 = t2.value1.Toggles
t2.value1.ForceCheckbox = false
t2.value1.ShowToggleFrameInKeybinds = true
local v7 = t2.value1:CreateWindow({
	Title = "Oishi Hub",
	Footer = "v1.02",
	Icon = 95816097006870,
	NotifySide = "Right",
	ShowCustomCursor = true
})
t2.value4 = game:GetService("Players")
t2.value5 = game:GetService("UserInputService")
t2.value6 = game:GetService("RunService")
t2.value7 = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
t2.value8 = game:GetService("Workspace")
game:GetService("HttpService")
t2.value9 = t2.value4.LocalPlayer
local PlayerGui = t2.value9:WaitForChild("PlayerGui")

t2.value10 = t2.value8.CurrentCamera
if t2.value5.TouchEnabled then
    t1.value1 = not t2.value5.KeyboardEnabled
end
local v9 = v7:AddTab("Main", "crosshair")
local v10 = v7:AddTab("Ragebot", "target")
local v11 = v7:AddTab("ESP", "eye")

t1.value1 = v7:AddTab("Visual", "palette")

local v12 = v7:AddTab("Misc", "wrench")
local v13 = v7:AddTab("Animation", "activity")
local v14 = v7:AddTab("Config", "save")
local v15 = v7:AddTab("UI Settings", "settings")
local t3 = {
	Main = v9,
	Ragebot = v10,
	ESP = v11,
	Visual = t1.value1,
	Misc = v12,
	Animation = v13,
	Config = v14,
	["UI Settings"] = v15
}
local color3 = Color3.fromRGB(0, 150, 255)
local color3_2 = Color3.fromRGB(255, 255, 255)
local color3_3 = Color3.fromRGB(0, 255, 0)
local color3_4 = Color3.fromRGB(255, 255, 255)
local color3_5 = Color3.fromRGB(255, 255, 255)

t1.value1 = Color3.fromRGB(0, 150, 255)
t1.value1 = {
	Ragebot = false,
	AutoShoot = false,
	AutoShootDelay = 0.1,
	RapidFire = false,
	Fly = false,
	FlySpeed = 80,
	InfiniteJump = false,
	Noclip = false,
	Esp = false,
	EspBoxes = false,
	EspNames = false,
	EspHealth = false,
	EspDistance = false,
	EspHealthNumber = false,
	EspTracers = false,
	EspBoxOutline = false,
	EspBoxColor = color3,
	EspNameColor = color3_2,
	EspHealthColor = color3_3,
	EspDistanceColor = color3_4,
	EspHealthNumberColor = color3_5,
	EspTracerColor = t1.value1,
	AnimationEnabled = false,
	AnimationPreset = "Underground Glitch",
	AnimationSpeed = 2,
	AimbotEnabled = false,
	AimbotShowFOV = false,
	AimbotTargetPart = "Head",
	AimbotFOVRadius = 500,
	AimbotSmoothness = 0,
	AimbotCurve = "Instant",
	AimbotFollowMuzzle = false,
	AimbotTeamCheck = true,
	AimbotAliveCheck = true,
	AimbotWallCheck = false,
	LegitConfigEnabled = false,
	RagebotConfigEnabled = false,
	UnlockAllEnabled = false,
	CustomFOVEnabled = false,
	CustomFOVValue = 70,
	DeviceSpoofEnabled = false,
	DeviceSpoofType = "None"
}
t2.value11 = t1.value1
function t1.value1(p1)
    if not p1 then
        return false
    end

    local Team = t2.value9.Team
    local v126 = Team and Team.TeamColor
    local TeamID = t2.value9:GetAttribute("TeamID")
    local Team2 = p1.Team
    local v129 = Team2 and Team2.TeamColor
    local TeamID2 = p1:GetAttribute("TeamID")

    if Team and (Team2 and Team == Team2) then
        return true
    end

    if v126 and (v129 and v126 == v129) then
        return true
    end

    if TeamID and (TeamID2 and TeamID == TeamID2) then
        return true
    end

    return false
end
t2.value12 = t1.value1
function t2.value13()
    local Character = t2.value9.Character

    if not Character then
        return false
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid or Humanoid.Health <= 0 then
        return false
    end

    return true
end
t2.value14 = false
t2.value15 = nil
t2.value16 = nil
t2.value17 = nil
t2.value18 = nil
t2.value19 = nil
t2.value20 = nil
function t1.value1(p2)
    local v132 = ({
		PC = "MouseKeyboard",
		Computer = "MouseKeyboard",
		Mobile = "Touch",
		Controller = "Gamepad",
		Console = "Gamepad",
		VR = "VR"
	})[p2]

    if not v132 then
        return
    end

    pcall(function()
        if t2.value7:FindFirstChild("Remotes") and t2.value7.Remotes:FindFirstChild("Replication") then
            t2.value7.Remotes.Replication.Fighter.SetControls:FireServer(v132)
        end
    end)
end
t2.value21 = {
	"PC",
	"Mobile",
	"Controller",
	"VR"
}
t2.value22 = t1.value1
t2.value23 = nil
function t2.value23()
    if t2.value15 then
        t2.value15:Disconnect()
    end
end
function t2.value24()
    t2.value23()
    t2.value6.Heartbeat:Connect(function()
        local v479 = t2.value21[math.random(1, #t2.value21)]

        t2.value22(v479)
        task.wait(1)
    end)
end
function t2.value25(p3)
    t2.value14 = p3
    t2.value11.DeviceSpoofEnabled = p3

    if p3 then
        if t2.value11.DeviceSpoofType == "Random" then
            t2.value24()

            return
        end

        if t2.value11.DeviceSpoofType ~= "None" then
            t2.value23()
            t2.value22(t2.value11.DeviceSpoofType)

            return
        end
    else
        t2.value23()
    end
end
t2.value26 = nil
function t2.value27(p4)
    t2.value11.DeviceSpoofType = p4

    if t2.value14 then
        if p4 == "Random" then
            t2.value24()

            return
        end

        if p4 ~= "None" then
            t2.value23()
            t2.value22(p4)

            return
        end

        t2.value23()
    end
end
t2.value20 = false
function t1.value1()
    t2.value17 = false
end
t2.value26 = 70
t2.value18 = nil
function t2.value28()
    if t2.value20 then
        return
    end

    t2.value20 = true
    t2.value18 = t2.value6.RenderStepped:Connect(function()
        if t2.value20 and t2.value10 then
            t2.value10.FieldOfView = t2.value26
        end
    end)
end
function t2.value29(p5)
    if p5 then
        t2.value28()

        return
    end

    if t2.value18 then
        t2.value18:Disconnect()
    end

    if t2.value10 then
        t2.value10.FieldOfView = 70
    end
end
function t2.value30(p6)
    t2.value26 = p6
    t2.value11.CustomFOVValue = p6

    if t2.value20 and t2.value10 then
        t2.value10.FieldOfView = p6
    end
end
t2.value17 = false
function t2.value31()
    if t2.value17 then
        return
    end

    t2.value17 = true
    pcall(function()
        local Controllers = t2.value9.PlayerScripts.Controllers
        local EnumLibrary = require(t2.value7.Modules:WaitForChild("EnumLibrary", 10))

        if EnumLibrary then
            EnumLibrary:WaitForEnumBuilder()
        end

        local CosmeticLibrary = require(t2.value7.Modules:WaitForChild("CosmeticLibrary", 10))

        local function v475(p7, p8)
            local v552 = p8 or CosmeticLibrary.Cosmetics[p7]

            if not v552 then
                return false
            end

            local v553 = v552.Type or ""
            local v554 = v553 == "Skin"

            if not v554 then
                v554 = v553 == "SkinType"

                if not v554 then
                    v554 = v553 == "WeaponSkin"

                    if not v554 then
                        v554 = v553 == "GunSkin"

                        if not v554 then
                            v554 = v553 == "Charm"

                            if not v554 then
                                v554 = v553 == "WeaponCharm"

                                if not v554 then
                                    v554 = v553 == "GunCharm"

                                    if not v554 then
                                        v554 = v553 == "Wrap"

                                        if not v554 then
                                            v554 = v553 == "Wrapping"

                                            if not v554 then
                                                v554 = v553 == "WeaponWrap"

                                                if not v554 then
                                                    v554 = v553 == "GunWrap"

                                                    if not v554 then
                                                        v554 = v553 == "SkinWrap"

                                                        if not v554 then
                                                            v554 = v553 == "Dance"

                                                            if not v554 then
                                                                v554 = v553 == "Emote"

                                                                if not v554 then
                                                                    v554 = v553 == "DanceEmote"

                                                                    if not v554 then
                                                                        v554 = v553 == "Taunt"

                                                                        if not v554 then
                                                                            v554 = v553 == "Finisher"

                                                                            if not v554 then
                                                                                v554 = v553 == "KillEffect"

                                                                                if not v554 then
                                                                                    v554 = v553 == "DeathEffect"

                                                                                    if not v554 then
                                                                                        v554 = v553 == "Execution"

                                                                                        if not v554 then
                                                                                            v554 = v553 == "FinisherMove"

                                                                                            if not v554 then
                                                                                                v554 = v553 == "Special"

                                                                                                if not v554 then
                                                                                                    v554 = v553 == "GunFinisher"

                                                                                                    if not v554 then
                                                                                                        v554 = v553 == "WeaponFinisher"

                                                                                                        if not v554 then
                                                                                                            v554 = string.lower(p7):find("skin") ~= nil

                                                                                                            if not v554 then
                                                                                                                v554 = string.lower(p7):find("charm") ~= nil

                                                                                                                if not v554 then
                                                                                                                    v554 = string.lower(p7):find("wrap") ~= nil

                                                                                                                    if not v554 then
                                                                                                                        v554 = string.lower(p7):find("wrapping") ~= nil

                                                                                                                        if not v554 then
                                                                                                                            v554 = string.lower(p7):find("dance") ~= nil

                                                                                                                            if not v554 then
                                                                                                                                v554 = string.lower(p7):find("emote") ~= nil

                                                                                                                                if not v554 then
                                                                                                                                    v554 = string.lower(p7):find("taunt") ~= nil

                                                                                                                                    if not v554 then
                                                                                                                                        v554 = string.lower(p7):find("finish") ~= nil

                                                                                                                                        if not v554 then
                                                                                                                                            v554 = string.lower(p7):find("kill") ~= nil or (string.lower(p7):find("execution") ~= nil or string.lower(p7):find("special") ~= nil)
                                                                                                                                        end
                                                                                                                                    end
                                                                                                                                end
                                                                                                                            end
                                                                                                                        end
                                                                                                                    end
                                                                                                                end
                                                                                                            end
                                                                                                        end
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            return v554
        end

        local PlayerDataController = require(Controllers:WaitForChild("PlayerDataController", 10))
        local OwnsCosmetic = CosmeticLibrary.OwnsCosmetic

        function CosmeticLibrary.OwnsCosmetic(p9, p10, p11, p12)
            if p11:find("MISSING_") then
                return OwnsCosmetic(p9, p10, p11, p12)
            end

            if v475(p11) then
                return true
            end

            return OwnsCosmetic(p9, p10, p11, p12)
        end

        local Get = PlayerDataController.Get

        function PlayerDataController.Get(p13, p14)
            local v561 = Get(p13, p14)

            if p14 == "CosmeticInventory" then
                local t4 = {}

                if v561 then
                    for k, v in pairs(v561) do
                        t4[k] = v
                    end
                end

                return setmetatable(t4, {
					__index = function(_, p16)
                    if v475(p16) then
                        return true
                    end

                    return nil
                end
				})
            end

            return v561
        end
    end)
end
t2.value32 = t1.value1
function t2.value33(p17)
    if p17 then
        t2.value31()

        return
    end

    t2.value32()
end
t2.value34 = nil
t2.value35 = false
t2.value36 = nil
t1.value1 = Vector3
t1.value1 = t1.value1.new(0, -1000, 0)
t2.value37 = t1.value1
function t1.value1()
    if t2.value34 then
        return
    end

    t2.value35 = true
    t2.value36 = nil

    local value7 = t2.value7
    local value9 = t2.value9
    local Gun = require(value9.PlayerScripts.Modules.ItemTypes.Gun)
    local Utility = require(value7.Modules.Utility)
    local self = setmetatable({}, {
		__index = function(_, p19)
        local Character = value9.Character

        if not Character then
            return nil
        end

        if p19 == "root" then
            return Character:FindFirstChild("HumanoidRootPart")
        end

        if p19 == "head" then
            return Character:FindFirstChild("Head")
        end

        return nil
    end
	})

    t2.value34 = {
		Active = true
	}

    local value34 = t2.value34

    function value34.FindTarget(_)
        local Character = value9.Character
        if not Character then
            return nil
        end
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            return nil
        end
        local v486
        local huge = math.huge
        local _next = next
        local v489, v490 = t2.value4:GetPlayers()
        while true do
            local v491

            v490, v491 = _next(v489, v490)

            if not v490 then
                break
            end

            if v491 ~= value9 and not t2.value12(v491) then
                local Character2 = v491.Character

                if Character2 then
                    local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")
                    local Head = Character2:FindFirstChild("Head")
                    local Humanoid = Character2:FindFirstChildWhichIsA("Humanoid")
                    local v496 = HumanoidRootPart2

                    if v496 then
                        v496 = Head

                        if v496 then
                            v496 = Humanoid and Humanoid.Health > 0
                        end
                    end

                    if v496 then
                        local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude

                        if Magnitude < huge then
                            v486 = v491
                            huge = Magnitude
                        end
                    end
                end
            end
        end

        return v486
    end

    value34.Connection = t2.value6.Heartbeat:Connect(function()
        if not value34.Active then
            return
        end

        value34.Target = value34:FindTarget()

        if value34.Target and value34.Target.Character then
            local Head = value34.Target.Character:FindFirstChild("Head")

            if Head then
                local root = self.root

                if root then
                    local rootCFrame = root.CFrame
                    local rootVelocity = root.Velocity
                    local RotVelocity = root.RotVelocity

                    root.CFrame = Head.CFrame
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    t2.value36 = Head.Position
                    t2.value6:BindToRenderStep("WallbangRestore", 101, function()
                        root.CFrame = rootCFrame
                        root.Velocity = rootVelocity
                        root.RotVelocity = RotVelocity
                        t2.value6:UnbindFromRenderStep("WallbangRestore")
                    end)

                    return
                end
            end
        else
            local root = self.root

            if root then
                local rootCFrame = root.CFrame
                local rootVelocity = root.Velocity
                local RotVelocity = root.RotVelocity

                root.CFrame = CFrame.new(t2.value37)
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero
                t2.value36 = t2.value37
                t2.value6:BindToRenderStep("WallbangVoid", 101, function()
                    root.CFrame = rootCFrame
                    root.Velocity = rootVelocity
                    root.RotVelocity = RotVelocity
                    t2.value6:UnbindFromRenderStep("WallbangVoid")
                end)
            end
        end
    end)

    local StartShooting = Gun.StartShooting

    value34.OldShootFunc = StartShooting

    function Gun.StartShooting(p21, ...)
        local t5 = { StartShooting(p21, ...) }

        if not p21.ClientFighter or not p21.ClientFighter.IsLocalPlayer then
            return unpack(t5)
        end

        local v509 = t5[3]

        if not v509 or typeof(v509) ~= "table" then
            return unpack(t5)
        end

        t5[4] = true

        local value34Target = value34.Target

        if not value34.Active or (not value34Target or not value34Target.Character) then
            return unpack(t5)
        end

        local Head = value34Target.Character:FindFirstChild("Head")

        if not Head then
            return unpack(t5)
        end

        local HeadPosition = Head.Position
        local v513 = Head.CFrame:ToObjectSpace(CFrame.new(HeadPosition + Vector3.new(math.random() * 0.1, math.random() * 0.1, math.random() * 0.1)))
        local v514 = utf8.char(0)
        local v515 = Utility
        local t6 = { CFrame.new(HeadPosition, HeadPosition + Head.CFrame.LookVector) }

        v509[v514] = v515:EncodeCFrame(v3(t6))
        v509[utf8.char(1)] = Utility:EncodeCFrame(CFrame.new(HeadPosition))
        v509[utf8.char(2)] = Head
        v509[utf8.char(3)] = Utility:EncodeCFrame(v513)

        return unpack(t5)
    end
    function value34.Shutdown(p22)
        p22.Active = false
        t2.value36 = nil

        if p22.Connection then
            p22.Connection:Disconnect()
        end

        if p22.OldShootFunc then
            Gun.StartShooting = p22.OldShootFunc
        end

        t2.value6:UnbindFromRenderStep("WallbangRestore")
        t2.value6:UnbindFromRenderStep("WallbangVoid")
    end
end
t2.value38 = t1.value1
t2.value39 = nil
function t1.value1(p23)
    if p23 then
        t2.value38()

        return
    end

    t2.value39()
end
function t2.value39()
    if t2.value34 then
        t2.value34:Shutdown()
        t2.value34 = nil
    end

    t2.value35 = false
    t2.value36 = nil
end
t2.value40 = t1.value1
t2.value41 = false
t2.value42 = nil
t2.value43 = 0
t2.value44 = 0
t1.value1 = require(t2.value7.Modules.Utility)
t2.value45 = t1.value1
t2.value46 = require(t2.value7.Modules.EnumLibrary)

function t1.value1(p24, p25)
    local v148 = p25 / 2
    local t7 = {}
    local v150 = true

    for i = -1, 1, 2 do
        for j = -1, 1, 2 do
            for k = -1, 1, 2 do
                local v154 = p24 * Vector3.new(v148.X * i, v148.Y * j, v148.Z * k)
                local v155, v156 = t2.value10:WorldToViewportPoint(v154)

                if not v156 then
                    v150 = false
                end

                table.insert(t7, Vector2.new(v155.X, v155.Y))
            end
        end
    end

    return t7, v150
end
t2.value47 = {
	"Medkit",
	"Grenade",
	"Flashbang",
	"Jump Pad",
	"Molotov",
	"Satchel",
	"Smoke Grenade",
	"War Horn",
	"Subspace Tripmine",
	"Warpstone"
}
function t2.value48()
    local Character = t2.value9.Character
    if not Character then
        return nil
    end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then
        return nil
    end
    local v159
    local n1 = 1e999
    for _, player in ipairs(t2.value4:GetPlayers()) do
        if player ~= t2.value9 and not t2.value12(player) then
            local Character3 = player.Character

            if Character3 then
                local Humanoid = Character3:FindFirstChildOfClass("Humanoid")

                if Humanoid and (Humanoid.Health > 0 and not Character3:FindFirstChildOfClass("ForceField")) then
                    local HumanoidRootPart3 = Character3:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart3 then
                        local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart3.Position).Magnitude

                        if Magnitude < n1 then
                            n1 = Magnitude
                            v159 = Character3
                        end
                    end
                end
            end
        end
    end

    return v159
end
function t2.value49()
    local ViewModels = t2.value8:FindFirstChild("ViewModels")

    if not ViewModels then
        return nil
    end

    local FirstPerson = ViewModels:FindFirstChild("FirstPerson")

    if not FirstPerson then
        return nil
    end

    for _, child in ipairs(FirstPerson:GetChildren()) do
        local v178 = child.Name:find("-")

        if v178 then
            return child.Name:sub(v178 + 1):match("^%s*(.-)%s*$")
        end
    end

    return nil
end
t2.value9.CharacterAdded:Connect(function()
    t2.value44 = tick()
    t2.value43 = 0
end)

function t2.value50()
    if not t2.value41 then
        return
    end

    if not t2.value13() then
        return
    end

    if tick() - t2.value44 < 5.2 then
        return
    end

    local v180 = t2.value49()
    local g183

    if v180 then
        if not v180 then
            v180 = false
        else
            g183 = nil

            for _, v in ipairs(t2.value47) do
                if v180 == v then
                    v180 = true
                    g183 = true
                end

                if g183 then
                    break
                end
            end

            if not g183 then
                v180 = false
            end
        end
    end

    g183 = false

    if v180 then
        return
    end

    local timestamp = tick()
    local value11 = t2.value11

    if timestamp - t2.value43 < (value11.AutoShootDelay or 0.1) then
        return
    end

    local v186 = t2.value48()

    if not v186 then
        return
    end

    local Head = v186:FindFirstChild("Head")

    if not Head then
        return
    end

    local player = t2.value4:GetPlayerFromCharacter(v186)

    if not player or t2.value12(player) then
        return
    end

    pcall(function()
        local FighterController = require(t2.value9.PlayerScripts.Controllers.FighterController)
        local v523 = FighterController.LocalFighter and FighterController.LocalFighter.EquippedItem

        if not v523 then
            return
        end

        local v524 = v523:Get("ObjectID")

        if not v524 then
            return
        end

        local Character = t2.value9.Character
        local v526 = Character and Character:FindFirstChild("HumanoidRootPart")
        local v527 = v526 and v526.Position or Head.Position

        if t2.value35 and t2.value36 then
            v527 = t2.value36
        end

        local v528 = utf8.char(1)
        local v529 = utf8.char(0)
        local value45 = t2.value45
        local t8 = { CFrame.new(v527, Head.Position) }
        local v532 = value45:EncodeCFrame(v3(t8))
        local v533 = utf8.char(1)
        local v534 = t2.value45:EncodeCFrame(CFrame.new(v527, Head.Position))
        local v535 = utf8.char(2)
        local v536 = Head
        local v537 = utf8.char(3)
        local v538 = t2.value45:EncodeCFrame(CFrame.new(0.43, 0.25, 0.42))
        local t9 = {
			[v528] = {
				[v529] = v532,
				[v533] = v534,
				[v535] = v536,
				[v537] = v538
			}
		}

        t2.value7.Remotes.Replication.Fighter.UseItem:FireServer(v524, t2.value46:ToEnum("StartShooting"), t9, nil)
    end)
end
function t2.value51()
    if t2.value41 then
        return
    end

    t2.value41 = true
    t2.value44 = tick()
    t2.value6.Heartbeat:Connect(function()
        if t2.value41 then
            t2.value50()
        end
    end)
end
t2.value52 = nil
function t2.value53()
    t2.value41 = false
    t2.value43 = 0

    if t2.value42 then
        t2.value42:Disconnect()
    end
end
function t2.value54(p26)
    if p26 then
        t2.value51()

        return
    end

    t2.value53()
end
function t2.value55(p27)
    t2.value11.AutoShootDelay = p27
end
t2.value52 = false
function t2.value56()
    if t2.value52 then
        return
    end

    t2.value52 = true
    pcall(function()
        local Items = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary).Items

        for _, v in pairs(Items) do
            if typeof(v) == "table" then
                if v.ShootSpread then
                    v.ShootSpread = 0
                end

                if v.ShootAccuracy then
                    v.ShootAccuracy = 0
                end

                if v.ShootRecoil then
                    v.ShootRecoil = 0
                end

                if v.ShootCooldown then
                    v.ShootCooldown = 0.001
                end

                if v.ShootBurstCooldown then
                    v.ShootBurstCooldown = 0.001
                end

                if v.AttackCooldown then
                    v.AttackCooldown = 0.001
                end

                if v.SwingCooldown then
                    v.SwingCooldown = 0.001
                end

                if v.MeleeCooldown then
                    v.MeleeCooldown = 0.001
                end

                if v.Cooldown then
                    v.Cooldown = 0.001
                end

                if v.RecoveryTime then
                    v.RecoveryTime = 0.001
                end

                if v.ResetTime then
                    v.ResetTime = 0.001
                end

                if v.ReloadTime then
                    v.ReloadTime = 0.001
                end

                if v.ChargeTime then
                    v.ChargeTime = 0.001
                end
            end
        end
    end)
end
function t2.value57()
    t2.value52 = false
end
function t2.value58(p28)
    if p28 then
        t2.value56()

        return
    end

    t2.value57()
end
t2.value59 = false
t2.value60 = nil
t2.value61 = nil
t2.value62 = nil
t2.value63 = nil
t2.value64 = nil
local function v22()
    local v191 = t2.value9.Character or t2.value9.CharacterAdded:Wait()

    t2.value63 = v191:WaitForChild("Humanoid")
    t2.value64 = v191:WaitForChild("HumanoidRootPart")

    if t2.value59 then
        if t2.value60 then
            t2.value60:Destroy()
        end

        t2.value63.PlatformStand = true
        t2.value60 = Instance.new("Attachment", t2.value64)
        t2.value61 = Instance.new("LinearVelocity", t2.value60)
        t2.value61.MaxForce = 9000000000
        t2.value61.VectorVelocity = Vector3.zero
        t2.value61.Attachment0 = t2.value60
        t2.value62 = Instance.new("AlignOrientation", t2.value60)
        t2.value62.MaxTorque = 9000000000
        t2.value62.Responsiveness = 200
        t2.value62.Mode = Enum.OrientationAlignmentMode.OneAttachment
        t2.value62.Attachment0 = t2.value60
    end
end
local value9 = t2.value9
t2.value65 = nil
local CharacterAdded = value9.CharacterAdded
local Connect = CharacterAdded.Connect
t2.value66 = nil
Connect(CharacterAdded, function()
    task.wait(0.1)
    v22()
end)
v22()
t2.value67 = require(t2.value9.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
local RenderStepped = t2.value6.RenderStepped
t2.value68 = nil
RenderStepped:Connect(function()
    local value59 = t2.value59

    if value59 then
        value59 = t2.value64 and (t2.value10 and (t2.value61 and t2.value62))
    end

    if value59 then
        local value10 = t2.value10
        local MoveVector = t2.value67:GetMoveVector()
        local v195 = t2.value11.FlySpeed or 80

        if MoveVector.Magnitude > 0 then
            t2.value61.VectorVelocity = (value10.CFrame.LookVector * -MoveVector.Z + value10.CFrame.RightVector * MoveVector.X).Unit * v195
        else
            t2.value61.VectorVelocity = Vector3.zero
        end

        t2.value62.CFrame = value10.CFrame
    end
end)

function t2.value69()
    v22()
end
t2.value70 = nil
function t2.value71(p29)
    if p29 then
        t2.value69()

        return
    end

    if t2.value63 then
        t2.value63.PlatformStand = false
    end

    if t2.value60 then
        t2.value60:Destroy()
    end
end
t2.value72 = nil
function t2.value73(p30)
    t2.value11.FlySpeed = p30
end
t2.value68 = false
t2.value72 = nil
function t2.value74()
    if t2.value68 then
        return
    end

    t2.value68 = true
    t2.value72 = t2.value5.JumpRequest:Connect(function()
        if not t2.value68 then
            return
        end

        local Character = t2.value9.Character

        if not Character then
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if Humanoid and Humanoid.Health > 0 then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end
function t2.value75()
    if t2.value72 then
        t2.value72:Disconnect()
    end
end
function t2.value76(p31)
    if p31 then
        t2.value74()

        return
    end

    t2.value75()
end
t2.value16 = false
t2.value19 = nil
function t2.value77()
    if t2.value16 then
        return
    end

    t2.value16 = true
    t2.value19 = t2.value6.Stepped:Connect(function()
        if not t2.value16 then
            return
        end

        local Character = t2.value9.Character

        if not Character then
            return
        end

        local GetDescendants = Character.GetDescendants

        for _, v in pairs(GetDescendants(Character)) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end)
end
function t2.value78()
    t2.value16 = false

    if t2.value19 then
        t2.value19:Disconnect()
        t2.value19 = nil
    end
end
function t2.value79(p32)
    if p32 then
        t2.value77()

        return
    end

    t2.value78()
end
t2.value70 = false
t2.value65 = {}
t2.value66 = nil
t2.value80 = pcall(function()
    return Drawing.new
end)

local function v27(p33, p34)
    if not t2.value80 then
        return nil
    end

    local ok, result = pcall(function()
        return Drawing.new(p33)
    end)
    local v207 = result

    if not ok then
        return nil
    end

    for k, v in pairs(p34) do
        local v210 = v

        pcall(function()
            v207[k] = v210
        end)
    end

    return v207
end
local function v28(_)
    local t10 = {}

    if t2.value11.EspBoxes then
        if t2.value11.EspBoxOutline then
            local v213 = v27
            local color3_6 = Color3.new(0, 0, 0)

            t10.BoxOutline = v213("Square", {
				Visible = false,
				Thickness = 3,
				Filled = false,
				Color = color3_6
			})
        end

        local v215 = v27
        local v216 = t2.value11.EspBoxColor or Color3.fromRGB(0, 150, 255)

        t10.Box = v215("Square", {
			Visible = false,
			Thickness = 1.5,
			Filled = false,
			Color = v216
		})
    end

    if t2.value11.EspNames then
        local v217 = v27
        local color3_7 = Color3.new(0, 0, 0)
        local v219 = t2.value11.EspNameColor or Color3.new(1, 1, 1)

        t10.Name = v217("Text", {
			Visible = false,
			Center = true,
			Outline = true,
			OutlineColor = color3_7,
			Size = 13,
			Font = 2,
			Color = v219
		})
    end

    if t2.value11.EspHealth then
        local v220 = v27
        local color3_8 = Color3.new(0, 0, 0)

        t10.HealthBarBG = v220("Line", {
			Visible = false,
			Thickness = 5,
			Color = color3_8
		})

        local v222 = v27
        local v223 = t2.value11.EspHealthColor or Color3.new(0, 1, 0)

        t10.HealthBar = v222("Line", {
			Visible = false,
			Thickness = 3,
			Color = v223
		})
    end

    if t2.value11.EspDistance then
        local v224 = v27
        local color3_9 = Color3.new(0, 0, 0)
        local v226 = t2.value11.EspDistanceColor or Color3.new(1, 1, 1)

        t10.Distance = v224("Text", {
			Visible = false,
			Center = true,
			Outline = true,
			OutlineColor = color3_9,
			Size = 11,
			Font = 2,
			Color = v226
		})
    end

    if t2.value11.EspHealthNumber then
        local v227 = v27
        local color3_10 = Color3.new(0, 0, 0)
        local v229 = t2.value11.EspHealthNumberColor or Color3.new(1, 1, 1)

        t10.HealthNumber = v227("Text", {
			Visible = false,
			Center = true,
			Outline = true,
			OutlineColor = color3_10,
			Size = 11,
			Font = 2,
			Color = v229
		})
    end

    if t2.value11.EspTracers then
        local v230 = v27
        local v231 = t2.value11.EspTracerColor or Color3.fromRGB(0, 150, 255)

        t10.Tracer = v230("Line", {
			Visible = false,
			Thickness = 1,
			Color = v231
		})
    end

    return t10
end
t2.value81 = t1.value1
function t2.value82(p36)
    for _, v in pairs(p36) do
        local v173 = v

        if v173 and v173.Visible then
            pcall(function()
                v173.Visible = false
            end)
        end
    end
end
local function v29()
    if not t2.value70 then
        for _, v in pairs(t2.value65) do
            t2.value82(v)
        end

        return
    end

    for _, player in ipairs(t2.value4:GetPlayers()) do
        local v236 = player

        if v236 == t2.value9 then
        elseif t2.value12(v236) then
            if t2.value65[v236] then
                t2.value82(t2.value65[v236])
            end
        else
            local Character = v236.Character
            local v238 = Character and Character:FindFirstChildOfClass("Humanoid")

            if Character and (v238 and v238.Health > 0) then
                local EspBoxes = t2.value11.EspBoxes

                if not EspBoxes then
                    EspBoxes = t2.value11.EspNames

                    if not EspBoxes then
                        EspBoxes = t2.value11.EspHealth

                        if not EspBoxes then
                            EspBoxes = t2.value11.EspDistance or (t2.value11.EspHealthNumber or t2.value11.EspTracers)
                        end
                    end
                end

                if EspBoxes then
                    local ok, result, v242 = pcall(Character.GetBoundingBox, Character)

                    if ok then
                        ok = result and v242
                    end

                    if ok then
                        local v244, t11Result = t2.value81(result, v242)
                        if not t11Result then
                            if t2.value65[v236] then
                                t2.value82(t2.value65[v236])
                            end
                        else
                            local v245 = t2.value65[v236] or v28(v236)

                            t2.value65[v236] = v245

                            local n2 = -1e999
                            local v247 = -1e999
                            local n3 = 1e999
                            local n4 = 1e999
                            local u250 = v247

                            for _, v in ipairs(v244) do
                                n4 = math.min(n4, v.X)
                                n3 = math.min(n3, v.Y)
                                n2 = math.max(n2, v.X)
                                u250 = math.max(u250, v.Y)
                            end

                            local v253 = u250 - n3
                            local v254 = n2 - n4
                            local v255 = v254 * 0.7
                            local v256 = n4 + (v254 - v255) / 2
                            local v257 = math.clamp(v238.Health / v238.MaxHealth, 0, 1)
                            local Head = Character:FindFirstChild("Head")

                            if v245.BoxOutline and (t2.value11.EspBoxes and t2.value11.EspBoxOutline) then
                                pcall(function()
                                    v245.BoxOutline.Visible = true
                                    v245.BoxOutline.Position = Vector2.new(v256 - 1, n3 - 1)
                                    v245.BoxOutline.Size = Vector2.new(v255 + 2, v253 + 2)
                                end)
                            end

                            if v245.Box and t2.value11.EspBoxes then
                                pcall(function()
                                    v245.Box.Visible = true
                                    v245.Box.Position = Vector2.new(v256, n3)
                                    v245.Box.Size = Vector2.new(v255, v253)
                                end)
                            end

                            if v245.Name and t2.value11.EspNames then
                                pcall(function()
                                    v245.Name.Visible = true
                                    v245.Name.Text = v236.Name
                                    v245.Name.Position = Vector2.new(v256 + v255 / 2, n3 - 16)
                                end)
                            end

                            local v259 = v253 * v257

                            if v245.HealthBarBG and t2.value11.EspHealth then
                                pcall(function()
                                    v245.HealthBarBG.Visible = true
                                    v245.HealthBarBG.From = Vector2.new(v256 - 6, u250)
                                    v245.HealthBarBG.To = Vector2.new(v256 - 6, n3)
                                end)
                            end

                            if v245.HealthBar and t2.value11.EspHealth then
                                pcall(function()
                                    v245.HealthBar.Visible = true

                                    if v257 > 0.7 then
                                        v245.HealthBar.Color = t2.value11.EspHealthColor or Color3.fromRGB(0, 255, 0)
                                    elseif v257 > 0.3 then
                                        v245.HealthBar.Color = Color3.fromRGB(255, 165, 0)
                                    else
                                        v245.HealthBar.Color = Color3.fromRGB(255, 0, 0)
                                    end

                                    v245.HealthBar.From = Vector2.new(v256 - 6, u250)
                                    v245.HealthBar.To = Vector2.new(v256 - 6, u250 - v259)
                                end)
                            end

                            if v245.Distance and (t2.value11.EspDistance and Head) then
                                local v260 = t2.value9.Character and t2.value9.Character:FindFirstChild("HumanoidRootPart")

                                if v260 then
                                    pcall(function()
                                        local v547 = math.floor((v260.Position - Head.Position).Magnitude)

                                        v245.Distance.Visible = true
                                        v245.Distance.Text = v547 .. "m"
                                        v245.Distance.Position = Vector2.new(v256 + v255 / 2, u250 + 4)
                                    end)
                                end
                            end

                            if v245.HealthNumber and t2.value11.EspHealthNumber then
                                pcall(function()
                                    v245.HealthNumber.Visible = true
                                    v245.HealthNumber.Text = math.floor(v238.Health) .. "/" .. math.floor(v238.MaxHealth)
                                    v245.HealthNumber.Position = Vector2.new(v256 + v255 / 2, u250 + 16)
                                end)
                            end

                            if v245.Tracer and t2.value11.EspTracers then
                                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                                if HumanoidRootPart then
                                    pcall(function()
                                        local v548 = t2.value10:WorldToViewportPoint(HumanoidRootPart.Position)
                                        local ViewportSize = t2.value10.ViewportSize

                                        v245.Tracer.Visible = true
                                        v245.Tracer.From = Vector2.new(ViewportSize.X / 2, ViewportSize.Y)
                                        v245.Tracer.To = Vector2.new(v548.X, v548.Y)
                                    end)
                                end
                            end
                        end
                    end
                end
            elseif t2.value65[v236] then
                t2.value82(t2.value65[v236])
            end
        end
    end
end
function t2.value83()
    t2.value70 = false

    if t2.value66 then
        t2.value66:Disconnect()
        t2.value66 = nil
    end

    for _, v in pairs(t2.value65) do
        local v200 = v

        pcall(function()
            for _, v2 in pairs(v200) do
                if v2 and v2.Remove then
                    v2:Remove()
                end
            end
        end)
    end

    t2.value65 = {}
end
function t2.value84(p37)
    if p37 then
        t2.value70 = true

        if t2.value66 then
            t2.value66:Disconnect()
        end

        t2.value6.RenderStepped:Connect(v29)

        return
    end

    t2.value83()
end
t2.value85 = nil
function t2.value85()
    if t2.value70 then
        t2.value83()
        t2.value70 = true

        if t2.value66 then
            t2.value66:Disconnect()
        end

        t2.value6.RenderStepped:Connect(v29)
    end
end
function t1.value1(p38)
    t2.value11.EspBoxOutline = p38
    t2.value85()
end
function t2.value86(p39)
    t2.value11.EspBoxes = p39
    t2.value85()
end
function t2.value87(p40)
    t2.value11.EspNames = p40
    t2.value85()
end
function t2.value88(p41)
    t2.value11.EspHealth = p41
    t2.value85()
end
function t2.value89(p42)
    t2.value11.EspDistance = p42
    t2.value85()
end
function t2.value90(p43)
    t2.value11.EspHealthNumber = p43
    t2.value85()
end
function t2.value91(p44)
    t2.value11.EspTracers = p44
    t2.value85()
end
t2.value92 = t1.value1
function t2.value93(p45)
    t2.value11.EspBoxColor = p45
    t2.value85()
end
function t2.value94(p46)
    t2.value11.EspNameColor = p46
    t2.value85()
end
function t2.value95(p47)
    t2.value11.EspHealthColor = p47
    t2.value85()
end
function t1.value1(p48)
    t2.value11.EspTracerColor = p48
    t2.value85()
end
function t2.value96(p49)
    t2.value11.EspDistanceColor = p49
    t2.value85()
end
function t2.value97(p50)
    t2.value11.EspHealthNumberColor = p50
    t2.value85()
end
t2.value98 = t1.value1
t1.value1 = t2.value4.PlayerRemoving
t1.value1:Connect(function(p51)
    if t2.value65[p51] then
        for _, v in pairs(t2.value65[p51]) do
            local v279 = v

            pcall(function()
                if v279 and v279.Remove then
                    v279:Remove()
                end
            end)
        end

        t2.value65[p51] = nil
    end
end)
t1.value1 = {
	enabled = false,
	animationId = "",
	loop = true,
	speed = 2,
	serverSide = true,
	jitter = false,
	jitterId = "",
	jitterSpeed = 0.1,
	spawnProof = true
}
t2.value99 = t1.value1
t2.value100 = {}
t1.value1 = {
	["Underground Glitch"] = "138847307095534",
	Orbit = "133811691098518",
	Tweaking = "114353590132838",
	["Kicking Feet"] = "131879764029003",
	["Low Cortisol"] = "125822752810863",
	Floss = "72174079036035",
	["Take the L"] = "112884830175040",
	["Upside Down"] = "128616002281906",
	["Michael Myers Shake"] = "123682198526131",
	Headless = "74738520664045",
	["Wall Peek L"] = "123671647250039",
	["Glitch Through"] = "85364072005108",
	Spin = "97064653080056"
}
t2.value101 = t1.value1
function t2.value102()
    for _, v in ipairs(t2.value100) do
        local v282 = v

        pcall(function()
            v282:Stop(0)
            v282:Destroy()
        end)
    end

    t2.value100 = {}
end
function t2.value103(p52)
    if not p52 then
        return nil
    end

    local Humanoid = p52:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return nil
    end

    local Animator = Humanoid:FindFirstChildOfClass("Animator")

    if not Animator then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    return Animator
end
function t2.value104(p53)
    local u287 = p53
    local ok, result = pcall(function()
        return game:GetObjects("rbxassetid://" .. u287)
    end)
    local v290 = not ok
    if not v290 then
        v290 = not result or #result == 0
    end
    if v290 then
        return nil
    end
    local v291, v292, v293 = ipairs(result)
    local v294
    repeat
        v293, v294 = v291(v292, v293)

        if not v293 then
            for _, v in ipairs(result) do
                local GetDescendants = v.GetDescendants

                for _, v4 in ipairs(GetDescendants(v)) do
                    if v4:IsA("Animation") and v4.AnimationId ~= "" then
                        return v4
                    end
                end
            end

            return nil
        end
    until v294:IsA("Animation") and v294.AnimationId ~= ""

    return v294
end
t2.value105 = nil
function t2.value105(p54, p55, p56, p57)
    if not p54 or p55 == "" then
        return nil
    end

    local v309 = t2.value103(p54)

    if not v309 then
        return nil
    end

    local u310 = t2.value104(p55)

    if not u310 then
        u310 = Instance.new("Animation")
        u310.AnimationId = "rbxassetid://" .. p55
    end

    local ok, result = pcall(function()
        return v309:LoadAnimation(u310)
    end)
    local v313 = not ok

    if not v313 then
        v313 = not result
    end

    if v313 then
        pcall(function()
            u310:Destroy()
        end)

        return nil
    end

    result.Looped = p57
    result.Priority = Enum.AnimationPriority.Action4
    result:Play(0.1, 1, p56)

    return result
end
function t2.value106()
    t2.value102()

    if not t2.value99.enabled or t2.value99.animationId == "" then
        return
    end

    local Character = t2.value9.Character

    if Character then
        local v301 = t2.value105(Character, t2.value99.animationId, t2.value99.speed, t2.value99.loop)

        if v301 then
            table.insert(t2.value100, v301)
        end
    end

    local Live = t2.value8:FindFirstChild("Live")

    if Live then
        local t2value9Name = Live:FindFirstChild(t2.value9.Name)

        if t2value9Name then
            local v304 = t2.value105(t2value9Name, t2.value99.animationId, t2.value99.speed, t2.value99.loop)

            if v304 then
                table.insert(t2.value100, v304)
            end
        end
    end
end
t2.value6.Heartbeat:Connect(function()
    if not t2.value99.enabled then
        return
    end

    if #t2.value100 == 0 and t2.value99.animationId ~= "" then
        t2.value106()
    end

    for _, v in ipairs(t2.value100) do
        local v316 = v

        pcall(function()
            v316:AdjustSpeed(t2.value99.speed)
        end)
    end
end)

local value9_2 = t2.value9
function t1.value1(p58)
    t2.value11.AnimationSpeed = p58
    t2.value99.speed = p58
end
value9_2.CharacterAdded:Connect(function()
    task.wait(0.5)

    if t2.value99.enabled and t2.value99.spawnProof then
        t2.value106()
    end
end)

function t2.value107(p59)
    if p59 then
        t2.value99.enabled = true

        local v319 = t2.value101[t2.value11.AnimationPreset]

        if v319 then
            t2.value99.animationId = v319
        end

        t2.value99.speed = t2.value11.AnimationSpeed
        t2.value99.loop = true
        t2.value99.serverSide = true
        t2.value106()

        return
    end

    t2.value99.enabled = false
    t2.value102()
end
function t2.value108(p60)
    t2.value11.AnimationPreset = p60

    local v321 = t2.value101[p60]

    if v321 then
        t2.value99.animationId = v321

        if t2.value99.enabled then
            t2.value106()
        end
    end
end
t2.value109 = t1.value1
t2.value110 = Instance.new("ScreenGui")

local value110 = t2.value110
t1.value1 = "Name"
value110[t1.value1] = "AimbotFOV"
local value110_2 = t2.value110
t1.value1 = "ResetOnSpawn"
value110_2[t1.value1] = false
local value110_3 = t2.value110
t1.value1 = "IgnoreGuiInset"
value110_3[t1.value1] = true
local value110_4 = t2.value110
t1.value1 = "DisplayOrder"
value110_4[t1.value1] = 999998
local value110_5 = t2.value110
t1.value1 = "ZIndexBehavior"
value110_5[t1.value1] = Enum.ZIndexBehavior.Sibling
local value110_6 = t2.value110
t1.value1 = "Parent"
value110_6[t1.value1] = PlayerGui
t2.value111 = {
	enabled = false,
	masterEnabled = false,
	keyMode = "toggle",
	showFov = false,
	targetPart = "Head",
	fovRadius = 500,
	smoothness = 0,
	aimCurve = "Instant",
	followMuzzle = false,
	lockedTarget = nil,
	smoothCF = nil,
	teamCheck = true,
	aliveCheck = true,
	wallCheck = false
}
local color3_11 = Color3.fromRGB(255, 255, 255)
local color3_12 = Color3.fromRGB(255, 255, 255)
local color3_13 = Color3.fromRGB(255, 255, 255)

t1.value1 = Color3.fromRGB(0, 0, 0)
t2.value112 = {
	OutlineColor1 = color3_11,
	OutlineColor2 = color3_12,
	OutlineRotation = 0,
	OutlineThickness = 1.5,
	OutlineTransparency = 0,
	FilledEnabled = false,
	FilledColor1 = color3_13,
	FilledColor2 = t1.value1,
	FilledRotation = 0,
	FilledTransparency = 0.7,
	FilledAnimated = false,
	FilledSpeed = 1,
	SpinOn = false,
	SpinSpd = 1
}
local v40 = (function(p61, p62)
    local Frame = Instance.new("Frame")

    Frame.Name = p61
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Visible = false
    Frame.Parent = t2.value110

    local Frame2 = Instance.new("Frame")

    Frame2.Size = UDim2.new(1, 0, 1, 0)
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame2.BackgroundTransparency = p62.FilledTransparency
    Frame2.BorderSizePixel = 0
    Frame2.Visible = false
    Frame2.ZIndex = 1
    Frame2.Parent = Frame

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame2

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, p62.FilledColor1),
		ColorSequenceKeypoint.new(1, p62.FilledColor2)
	})
    UIGradient.Rotation = p62.FilledRotation
    UIGradient.Parent = Frame2

    local Frame3 = Instance.new("Frame")

    Frame3.Size = UDim2.new(1, 0, 1, 0)
    Frame3.BackgroundTransparency = 1
    Frame3.BorderSizePixel = 0
    Frame3.ZIndex = 2
    Frame3.Parent = Frame

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = Frame3

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Thickness = p62.OutlineThickness
    UIStroke.Transparency = p62.OutlineTransparency
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame3

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, p62.OutlineColor1),
		ColorSequenceKeypoint.new(1, p62.OutlineColor2)
	})
    UIGradient2.Rotation = p62.OutlineRotation
    UIGradient2.Parent = UIStroke

    return {
		container = Frame,
		fill = Frame2,
		fillgrad = UIGradient,
		stroke = UIStroke,
		strokegrad = UIGradient2
	}
end)("AimbotFOV", t2.value112)

function t1.value1()
    t2.value111.lockedTarget = nil
    t2.value111.smoothCF = nil
end
t2.value113 = v40.container
local _ = v40.fill
t2.value114 = v40.fillgrad
local _ = v40.stroke
t2.value115 = v40.strokegrad
t2.value116 = nil
t2.value117 = nil
function t2.value116(p63, p64)
    if not p64 then
        p64 = t2.value10
    end

    if not p64 or not p63 then
        return nil, false
    end

    local v363, v364 = p64:WorldToViewportPoint(p63)

    if not v364 or v363.Z <= 0 then
        return v363, false
    end

    return v363, true
end
function t2.value118(p65)
    if not p65 then
        p65 = t2.value10
    end

    if not p65 then
        return Vector2.zero
    end

    local ViewportSize = p65.ViewportSize

    return Vector2.new(ViewportSize.X * 0.5, ViewportSize.Y * 0.5)
end
function t2.value119(p66)
    if not p66 then
        return nil
    end
    local v360, t12Result = t2.value116(p66, t2.value10)
    if not t12Result then
        return nil
    end

    return Vector2.new(v360.X, v360.Y)
end
local function v43()
    local Character = t2.value9.Character

    if not Character then
        local CurrentCamera = workspace.CurrentCamera

        return CurrentCamera and CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 4 or Vector3.zero
    end

    local ViewModels = t2.value8:FindFirstChild("ViewModels")

    if ViewModels then
        local FirstPerson = ViewModels:FindFirstChild("FirstPerson")

        if FirstPerson then
            for _, child in ipairs(FirstPerson:GetChildren()) do
                if not child:IsA("Model") then
                    continue
                end

                local ItemVisual = child:FindFirstChild("ItemVisual")

                if ItemVisual then
                    local Body = ItemVisual:FindFirstChild("Body")

                    if Body then
                        local BodyPrimary = Body:FindFirstChild("BodyPrimary")

                        if BodyPrimary then
                            local _muzzle = BodyPrimary:FindFirstChild("_muzzle")

                            if _muzzle and _muzzle:IsA("Attachment") then
                                return _muzzle.WorldPosition
                            end
                        end
                    end
                end

                local Muzzle = child:FindFirstChild("Muzzle")

                if not Muzzle then
                    Muzzle = child:FindFirstChild("MuzzleFlash")

                    if not Muzzle then
                        Muzzle = child:FindFirstChild("Barrel")

                        if not Muzzle then
                            Muzzle = child:FindFirstChild("GunTip")
                        end
                    end
                end

                if Muzzle then
                    if Muzzle:IsA("Attachment") then
                        return Muzzle.WorldPosition
                    end

                    if Muzzle:IsA("BasePart") then
                        return Muzzle.Position
                    end
                end

                for _, child2 in ipairs(child:GetChildren()) do
                    if not child2:IsA("BasePart") then
                        continue
                    end

                    local v384 = child2.Name:lower()

                    if v384:find("tip") or (v384:find("barrel") or v384:find("muzzle")) then
                        return child2.Position
                    end
                end

                local v385 = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")

                if v385 then
                    return v385.Position
                end
            end
        end
    end

    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        return CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 4
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    return HumanoidRootPart and HumanoidRootPart.Position or Vector3.zero
end
t2.value120 = nil
function t2.value120()
    if t2.value111.followMuzzle then
        local v389 = t2.value119((v43()))

        if v389 then
            return v389
        end
    end

    return t2.value118(t2.value10)
end
function t2.value121()
    if t2.value111.followMuzzle then
        return t2.value120()
    end

    local MouseLocation = t2.value5:GetMouseLocation()

    return Vector2.new(MouseLocation.X, MouseLocation.Y)
end
function t2.value122(p67)
    if not t2.value111.teamCheck then
        return false
    end

    if not p67 then
        return false
    end

    local TeamID = t2.value9:GetAttribute("TeamID")
    local TeamID3 = p67:GetAttribute("TeamID")

    if TeamID then
        TeamID = TeamID3 and TeamID == TeamID3
    end

    if TeamID then
        return true
    end

    if t2.value9.Team and (p67.Team and t2.value9.Team == p67.Team) then
        return true
    end

    return false
end
function t2.value123(p68)
    if not t2.value111.aliveCheck then
        return true
    end

    if not p68 then
        return false
    end

    local Character = p68.Character

    if not Character then
        return false
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid or Humanoid.Health <= 0 then
        return false
    end

    return true
end
t2.value124 = nil
function t2.value124(p69)
    if not t2.value111.wallCheck then
        return true
    end

    if not p69 or not p69.Character then
        return false
    end

    local v326 = p69.Character:FindFirstChild(t2.value111.targetPart) or p69.Character:FindFirstChild("Head")

    if not v326 then
        return false
    end

    local CFramePosition = t2.value10.CFrame.Position
    local Position = v326.Position
    local Unit = (Position - CFramePosition).Unit
    local Magnitude = (Position - CFramePosition).Magnitude
    local raycastParams = RaycastParams.new()

    raycastParams.FilterDescendantsInstances = { t2.value9.Character }
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true

    local raycastResult = workspace:Raycast(CFramePosition, Unit * Magnitude, raycastParams)

    if not raycastResult then
        return true
    end

    if raycastResult.Instance:FindFirstAncestorOfClass("Model") == p69.Character then
        return true
    end

    return raycastResult.Instance:IsDescendantOf(p69.Character)
end
function t2.value125(p70)
    if not p70 then
        return false
    end

    if p70 == t2.value9 then
        return false
    end

    if t2.value122(p70) then
        return false
    end

    if not t2.value123(p70) then
        return false
    end

    if not t2.value124(p70) then
        return false
    end

    local Character = p70.Character

    if not Character then
        return false
    end

    if Character:FindFirstChildOfClass("ForceField") then
        return false
    end

    return true
end
local function v44()
    local fovRadius = t2.value111.fovRadius
    local v393
    local v394 = t2.value121()
    if not v394 then
        return nil
    end
    local value10 = t2.value10
    for _, player in ipairs(t2.value4:GetPlayers()) do
        if player ~= t2.value9 and (player.Character and t2.value125(player)) then
            local t2value111targetPart = player.Character:FindFirstChild(t2.value111.targetPart)

            if t2value111targetPart and t2value111targetPart:IsDescendantOf(workspace) then
                local v399, v400 = t2.value116(t2value111targetPart.Position, value10)

                if v400 then
                    local v401 = v399.X - v394.X
                    local v402 = v399.Y - v394.Y
                    local v403 = math.sqrt(v401 * v401 + v402 * v402)

                    if v403 < fovRadius then
                        v393 = t2value111targetPart
                        fovRadius = v403
                    end
                end
            end
        end
    end

    return v393
end
function t2.value126(p71)
    local smoothness = t2.value111.smoothness

    if smoothness <= 0 then
        return 1
    end

    local v345 = math.clamp(tonumber(smoothness) or 2, 0.1, 10)
    local v346 = t2.value111.aimCurve or "Linear"
    local v347 = 6 / v345

    if v346 == "Instant" then
        return 1
    end

    if v346 == "Expo" then
        return 1 - math.exp(-(4 / v345) * p71)
    end

    if v346 == "EaseIn" then
        local v348 = math.clamp(v347 * p71, 0, 1)

        return v348 * v348
    end

    if v346 == "EaseOut" then
        local v349 = math.clamp(v347 * p71, 0, 1)

        return 1 - (1 - v349) * (1 - v349)
    end

    if v346 == "EaseInOut" then
        local v350 = math.clamp(v347 * p71, 0, 1)

        if v350 < 0.5 then
            return 2 * v350 * v350
        end

        return 1 - (-2 * v350 + 2) ^ 2 / 2
    end

    if v346 == "Cubic" then
        local v351 = math.clamp(v347 * p71, 0, 1)

        return v351 * v351 * v351
    end

    return math.clamp(v347 * p71, 0, 1)
end
t2.value127 = t1.value1
function t2.value128(p72)
    if not p72 then
        p72 = t2.value10
    end

    if not p72 then
        return nil
    end

    local p72CFrame = p72.CFrame
    local p72CFramePosition = p72CFrame.Position
    local LookVector = p72CFrame.LookVector
    local RightVector = p72CFrame.RightVector
    local Unit = RightVector:Cross(LookVector).Unit

    return CFrame.fromMatrix(p72CFramePosition, RightVector, Unit, -LookVector)
end
t2.value117 = nil
pcall(function()
    local CameraController = t2.value9.PlayerScripts:WaitForChild("Controllers", 10):FindFirstChild("CameraController")

    if CameraController and CameraController:IsA("ModuleScript") then
        t2.value117 = require(CameraController)
    end
end)
t2.value6:BindToRenderStep("InstanceAimbotUpdate", Enum.RenderPriority.Camera.Value + 1, function(p73)
    local value111 = t2.value111
    local v406 = p73 or 0.0041666666666667

    if not value111.enabled then
        t2.value127()

        return
    end

    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    if not t2.value111.lockedTarget then
        t2.value111.lockedTarget = v44()
        t2.value111.smoothCF = t2.value128(CurrentCamera)

        if not t2.value111.lockedTarget then
            return
        end
    end

    local v408 = not t2.value111.lockedTarget.Parent

    if not v408 then
        v408 = not t2.value111.lockedTarget:IsDescendantOf(workspace)
    end

    if v408 then
        t2.value127()

        return
    end

    local player = t2.value4:GetPlayerFromCharacter(t2.value111.lockedTarget.Parent)

    if player and not t2.value125(player) then
        t2.value127()

        return
    end

    local Character = t2.value9.Character

    if not Character then
        return
    end

    if not Character:FindFirstChild("Head") then
        t2.value127()

        return
    end

    if not t2.value117 then
        return
    end

    if not t2.value111.smoothCF then
        t2.value111.smoothCF = t2.value128(CurrentCamera)
    end

    local cFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, t2.value111.lockedTarget.Position)
    local v412 = t2.value126(v406)

    t2.value111.smoothCF = t2.value111.smoothCF:Lerp(cFrame, v412)

    if t2.value117 and t2.value117.MimicRotation then
        pcall(function()
            t2.value117:MimicRotation(t2.value111.smoothCF)
        end)
    end
end)

local RenderStepped2 = t2.value6.RenderStepped
local Connect2 = RenderStepped2.Connect
function t1.value1(p74)
    t2.value111.smoothness = p74
    t2.value11.AimbotSmoothness = p74
end
Connect2(RenderStepped2, function()
    if t2.value113.Visible then
        local v414 = t2.value120()
        local fovRadius = t2.value111.fovRadius

        t2.value113.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
        t2.value113.Position = UDim2.fromOffset(v414.X - fovRadius, v414.Y - fovRadius)

        if t2.value112.FilledAnimated then
            t2.value114.Rotation = math.sin(tick() * t2.value112.FilledSpeed) * 180 + t2.value112.FilledRotation
        elseif t2.value112.SpinOn then
            t2.value114.Rotation = t2.value112.FilledRotation + tick() * t2.value112.SpinSpd * 90 % 360
        end

        if t2.value112.SpinOn then
            t2.value115.Rotation = t2.value112.OutlineRotation + tick() * t2.value112.SpinSpd * 90 % 360
        end
    end
end);
(function()
    t2.value113.Visible = t2.value111.showFov

    if not t2.value111.enabled then
        t2.value127()

        return
    end
end)()
function t2.value129(p75)
    t2.value111.enabled = p75
    t2.value11.AimbotEnabled = p75

    if not p75 then
        t2.value127()
    end
end
function t2.value130(p76)
    t2.value111.targetPart = p76
    t2.value11.AimbotTargetPart = p76
    t2.value127()
end
function t2.value131(p77)
    t2.value111.fovRadius = p77
    t2.value11.AimbotFOVRadius = p77
end
t2.value132 = t1.value1
function t2.value133(p78)
    t2.value111.aimCurve = p78
    t2.value11.AimbotCurve = p78
end
function t1.value1(p79)
    t2.value111.teamCheck = p79
    t2.value11.AimbotTeamCheck = p79
end
function t2.value134(p80)
    t2.value111.followMuzzle = p80
    t2.value11.AimbotFollowMuzzle = p80
end
t2.value135 = t1.value1
function t2.value136(p81)
    t2.value111.aliveCheck = p81
    t2.value11.AimbotAliveCheck = p81
end
function t2.value137(p82)
    t2.value111.wallCheck = p82
    t2.value11.AimbotWallCheck = p82
end
t2.value138 = nil
function t2.value138()
    if t2.value11.Ragebot then
        t2.value11.Ragebot = false
        t2.value39()
        t2.value3.Ragebot:SetValue(false)
    end

    if t2.value11.AutoShoot then
        t2.value11.AutoShoot = false
        t2.value53()
        t2.value3.AutoShoot:SetValue(false)
    end

    if t2.value11.RapidFire then
        t2.value11.RapidFire = false
        t2.value57()
        t2.value3.RapidFire:SetValue(false)
    end

    if t2.value11.Fly then
        t2.value11.Fly = false

        if t2.value63 then
            t2.value63.PlatformStand = false
        end

        if t2.value60 then
            t2.value60:Destroy()
        end

        t2.value3.Fly:SetValue(false)
    end

    if t2.value11.InfiniteJump then
        t2.value11.InfiniteJump = false
        t2.value75()
        t2.value3.InfiniteJump:SetValue(false)
    end

    if t2.value11.Noclip then
        t2.value11.Noclip = false
        t2.value78()
        t2.value3.Noclip:SetValue(false)
    end

    if t2.value11.AnimationEnabled then
        t2.value11.AnimationEnabled = false
        t2.value107(false)
        t2.value3.AnimationEnabled:SetValue(false)
    end

    if t2.value11.AimbotEnabled then
        t2.value11.AimbotEnabled = false
        t2.value129(false)
        t2.value3.AimbotEnabled:SetValue(false)
    end

    if t2.value11.Esp then
        t2.value11.Esp = false
        t2.value83()
        t2.value3.Esp:SetValue(false)
    end
end
function t2.value139()
    t2.value138()
    t2.value11.AimbotEnabled = true
    t2.value11.AimbotShowFOV = true
    t2.value11.AimbotSmoothness = 0
    t2.value11.AimbotCurve = "Instant"
    t2.value11.AimbotWallCheck = true
    t2.value11.AimbotAliveCheck = true
    t2.value11.AimbotTeamCheck = true
    t2.value11.AimbotFollowMuzzle = true
    t2.value129(true)
    t2.value111.showFov = true
    t2.value11.AimbotShowFOV = true
    t2.value113.Visible = true
    t2.value134(true)
    t2.value135(true)
    t2.value136(true)
    t2.value137(true)
    t2.value3.AimbotEnabled:SetValue(true)
    t2.value3.AimbotShowFOV:SetValue(true)
    t2.value3.AimbotFollowMuzzle:SetValue(true)
    t2.value3.AimbotTeamCheck:SetValue(true)
    t2.value3.AimbotAliveCheck:SetValue(true)
    t2.value3.AimbotWallCheck:SetValue(true)
    t2.value11.Esp = true
    t2.value11.EspBoxes = true
    t2.value11.EspHealth = true
    t2.value11.EspNames = true
    t2.value11.EspDistance = true
    t2.value11.EspTracers = true
    t2.value70 = true

    if t2.value66 then
        t2.value66:Disconnect()
    end

    t2.value6.RenderStepped:Connect(v29)
    t2.value3.Esp:SetValue(true)
    t2.value3.EspBoxes:SetValue(true)
    t2.value3.EspHealth:SetValue(true)
    t2.value3.EspNames:SetValue(true)
    t2.value3.EspDistance:SetValue(true)
    t2.value3.EspTracers:SetValue(true)
end
function t2.value140()
    t2.value138()
    t2.value11.Ragebot = true
    t2.value11.AutoShoot = true
    t2.value11.RapidFire = true
    t2.value38()
    t2.value51()
    t2.value56()
    t2.value3.Ragebot:SetValue(true)
    t2.value3.AutoShoot:SetValue(true)
    t2.value3.RapidFire:SetValue(true)
    t2.value11.Esp = true
    t2.value11.EspBoxes = true
    t2.value11.EspHealth = true
    t2.value11.EspNames = true
    t2.value11.EspDistance = true
    t2.value11.EspTracers = true
    t2.value70 = true

    if t2.value66 then
        t2.value66:Disconnect()
    end

    t2.value6.RenderStepped:Connect(v29)
    t2.value3.Esp:SetValue(true)
    t2.value3.EspBoxes:SetValue(true)
    t2.value3.EspHealth:SetValue(true)
    t2.value3.EspNames:SetValue(true)
    t2.value3.EspDistance:SetValue(true)
    t2.value3.EspTracers:SetValue(true)
    t2.value11.Fly = true
    t2.value11.InfiniteJump = true
    t2.value11.Noclip = true
    t2.value69()
    t2.value74()
    t2.value77()
    t2.value3.Fly:SetValue(true)
    t2.value3.InfiniteJump:SetValue(true)
    t2.value3.Noclip:SetValue(true)
    t2.value11.AnimationEnabled = true
    t2.value11.AnimationPreset = "Spin"
    t2.value11.AnimationSpeed = 500
    t2.value107(true)
    t2.value3.AnimationEnabled:SetValue(true)
    t2.value2.AnimationPreset:SetValue("Spin")
    t2.value2.AnimationSpeed:SetValue(500)
end
local v47 = t3.Main:AddLeftGroupbox("Aimbot", "crosshair")
local AddToggle = v47.AddToggle
local AimbotEnabled = t2.value11.AimbotEnabled
AddToggle(v47, "AimbotEnabled", {
	Text = "Enable Aimbot",
	Default = AimbotEnabled,
	Tooltip = "Toggles the aimbot",
	Callback = function(p83)
    t2.value11.AimbotEnabled = p83
    t2.value129(p83)
end
})
local value11 = t2.value11
local AddToggle2 = v47.AddToggle
local AimbotShowFOV = value11.AimbotShowFOV
AddToggle2(v47, "AimbotShowFOV", {
	Text = "Show FOV Circle",
	Default = AimbotShowFOV,
	Tooltip = "Shows the aimbot FOV circle",
	Callback = function(p84)
    t2.value11.AimbotShowFOV = p84
    t2.value111.showFov = p84
    t2.value11.AimbotShowFOV = p84
    t2.value113.Visible = p84
end
})
local AimbotTargetPart = t2.value11.AimbotTargetPart
local AddDropdown = v47.AddDropdown
function t1.value1(p85)
    t2.value11.AimbotTargetPart = p85
    t2.value130(p85)
end
AddDropdown(v47, "AimbotTargetPart", {
	Values = {
		"Head",
		"HumanoidRootPart",
		"Torso",
		"UpperTorso",
		"LowerTorso"
	},
	Default = AimbotTargetPart,
	Text = "Target Part",
	Tooltip = "Which body part to aim at",
	Callback = t1.value1
})
local AimbotFOVRadius = t2.value11.AimbotFOVRadius
v47:AddSlider("AimbotFOVRadius", {
	Text = "FOV Radius",
	Default = AimbotFOVRadius,
	Min = 50,
	Max = 1000,
	Rounding = 0,
	Compact = false,
	Callback = function(p86)
    t2.value11.AimbotFOVRadius = p86
    t2.value131(p86)
end
})
local AddSlider = v47.AddSlider
local AimbotSmoothness = t2.value11.AimbotSmoothness
AddSlider(v47, "AimbotSmoothness", {
	Text = "Smoothness",
	Default = AimbotSmoothness,
	Min = 0,
	Max = 10,
	Rounding = 0,
	Compact = false,
	Callback = function(p87)
    t2.value11.AimbotSmoothness = p87
    t2.value132(p87)
end
})
local AimbotCurve = t2.value11.AimbotCurve
local AddDropdown2 = v47.AddDropdown
function t1.value1(p88)
    t2.value11.AimbotCurve = p88
    t2.value133(p88)
end
AddDropdown2(v47, "AimbotCurve", {
	Values = {
		"Linear",
		"Instant",
		"Expo",
		"EaseIn",
		"EaseOut",
		"EaseInOut",
		"Cubic"
	},
	Default = AimbotCurve,
	Text = "Aim Curve",
	Tooltip = "The aiming curve type",
	Callback = t1.value1
})
local AimbotFollowMuzzle = t2.value11.AimbotFollowMuzzle
v47:AddToggle("AimbotFollowMuzzle", {
	Text = "Follow Muzzle",
	Default = AimbotFollowMuzzle,
	Tooltip = "FOV circle follows the gun muzzle",
	Callback = function(p89)
    t2.value11.AimbotFollowMuzzle = p89
    t2.value134(p89)
end
})
local value11_2 = t2.value11
local AddToggle3 = v47.AddToggle
local AimbotTeamCheck = value11_2.AimbotTeamCheck
AddToggle3(v47, "AimbotTeamCheck", {
	Text = "Team Check",
	Default = AimbotTeamCheck,
	Tooltip = "Ignores teammates",
	Callback = function(p90)
    t2.value11.AimbotTeamCheck = p90
    t2.value135(p90)
end
})
local AimbotAliveCheck = t2.value11.AimbotAliveCheck
v47:AddToggle("AimbotAliveCheck", {
	Text = "Alive Check",
	Default = AimbotAliveCheck,
	Tooltip = "Only targets alive players",
	Callback = function(p91)
    t2.value11.AimbotAliveCheck = p91
    t2.value136(p91)
end
})
local value11_3 = t2.value11
local AddToggle4 = v47.AddToggle
local AimbotWallCheck = value11_3.AimbotWallCheck
AddToggle4(v47, "AimbotWallCheck", {
	Text = "Wall Check",
	Default = AimbotWallCheck,
	Tooltip = "Only targets visible players",
	Callback = function(p92)
    t2.value11.AimbotWallCheck = p92
    t2.value137(p92)
end
})
local v68 = t3.Ragebot:AddLeftGroupbox("Main", "target")
local Ragebot = t2.value11.Ragebot
v68:AddToggle("Ragebot", {
	Text = "Ragebot (Wallbang)",
	Default = Ragebot,
	Risky = true,
	Tooltip = "Enables wallbang/ragebot",
	Callback = function(p93)
    t2.value11.Ragebot = p93
    t2.value40(p93)
end
})
local AddToggle5 = v68.AddToggle
local AutoShoot = t2.value11.AutoShoot
function t1.value1(p94)
    t2.value11.AutoShoot = p94
    t2.value54(p94)
end
AddToggle5(v68, "AutoShoot", {
	Text = "Auto Shoot",
	Default = AutoShoot,
	Tooltip = "Automatically shoots at enemies",
	Callback = t1.value1
})
local AutoShootDelay = t2.value11.AutoShootDelay
v68:AddSlider("AutoShootDelay", {
	Text = "Shoot Delay",
	Default = AutoShootDelay,
	Min = 0.1,
	Max = 10,
	Rounding = 1,
	Compact = false,
	Callback = function(p95)
    t2.value11.AutoShootDelay = p95
    t2.value55(p95)
end
})
local RapidFire = t2.value11.RapidFire
local AddToggle6 = v68.AddToggle
function t1.value1(p96)
    t2.value11.RapidFire = p96
    t2.value58(p96)
end
AddToggle6(v68, "RapidFire", {
	Text = "Rapid Fire",
	Default = RapidFire,
	Tooltip = "Modifies weapon cooldowns for rapid fire",
	Callback = t1.value1
})
local v75 = t3.ESP:AddLeftGroupbox("Main", "eye")
local Esp = t2.value11.Esp
local AddToggle7 = v75.AddToggle
function t1.value1(p97)
    t2.value11.Esp = p97
    t2.value84(p97)
end
AddToggle7(v75, "Esp", {
	Text = "Enable ESP",
	Default = Esp,
	Tooltip = "Master ESP toggle",
	Callback = t1.value1
})
local v78 = t3.ESP:AddLeftGroupbox("Box ESP", "square")
local EspBoxes = t2.value11.EspBoxes
local AddToggle8 = v78.AddToggle
function t1.value1(p98)
    t2.value11.EspBoxes = p98
    t2.value86(p98)
end
AddToggle8(v78, "EspBoxes", {
	Text = "Box ESP",
	Default = EspBoxes,
	Callback = t1.value1
})
local AddToggle9 = v78.AddToggle
local EspBoxOutline = t2.value11.EspBoxOutline
function t1.value1(p99)
    t2.value11.EspBoxOutline = p99
    t2.value92(p99)
end
AddToggle9(v78, "EspBoxOutline", {
	Text = "Box Outline",
	Default = EspBoxOutline,
	Callback = t1.value1
})
local v83 = v78:AddLabel("Box Color")
local v84 = t2.value11.EspBoxColor or Color3.fromRGB(0, 150, 255)
local AddColorPicker = v83.AddColorPicker
function t1.value1(p100)
    t2.value11.EspBoxColor = p100
    t2.value93(p100)
end
AddColorPicker(v83, "EspBoxColor", {
	Default = v84,
	Title = "Box Color",
	Callback = t1.value1
})
local v86 = t3.ESP:AddRightGroupbox("Health", "heart")
local EspHealth = t2.value11.EspHealth
function t1.value1(p101)
    t2.value11.EspHealth = p101
    t2.value88(p101)
end
v86:AddToggle("EspHealth", {
	Text = "Health Bar",
	Default = EspHealth,
	Callback = t1.value1
})
v86:AddLabel("Health Color"):AddColorPicker("EspHealthColor", {
	Default = t2.value11.EspHealthColor or Color3.fromRGB(0, 255, 0),
	Title = "Health Color",
	Callback = function(p102)
    t2.value11.EspHealthColor = p102
    t2.value95(p102)
end
})
local AddToggle10 = v86.AddToggle
local EspHealthNumber = t2.value11.EspHealthNumber
function t1.value1(p103)
    t2.value11.EspHealthNumber = p103
    t2.value90(p103)
end
AddToggle10(v86, "EspHealthNumber", {
	Text = "Health Number",
	Default = EspHealthNumber,
	Callback = t1.value1
})
v86:AddLabel("Health Number Color"):AddColorPicker("EspHealthNumberColor", {
	Default = t2.value11.EspHealthNumberColor or Color3.new(1, 1, 1),
	Title = "Health Number Color",
	Callback = function(p104)
    t2.value11.EspHealthNumberColor = p104
    t2.value97(p104)
end
})
local v90 = t3.ESP:AddRightGroupbox("Information", "info")
local AddToggle11 = v90.AddToggle
t1.value1 = t2.value11.EspNames
AddToggle11(v90, "EspNames", {
	Text = "Name ESP",
	Default = t1.value1,
	Callback = function(p105)
    t2.value11.EspNames = p105
    t2.value87(p105)
end
})
local v92 = v90:AddLabel("Name Color")
local v93 = t2.value11.EspNameColor or Color3.new(1, 1, 1)
local AddColorPicker2 = v92.AddColorPicker
function t1.value1(p106)
    t2.value11.EspNameColor = p106
    t2.value94(p106)
end
AddColorPicker2(v92, "EspNameColor", {
	Default = v93,
	Title = "Name Color",
	Callback = t1.value1
})
t1.value1 = t2.value11.EspDistance
v90:AddToggle("EspDistance", {
	Text = "Distance ESP",
	Default = t1.value1,
	Callback = function(p107)
    t2.value11.EspDistance = p107
    t2.value89(p107)
end
})
local v95 = v90:AddLabel("Distance Color")
local v96 = t2.value11.EspDistanceColor or Color3.new(1, 1, 1)

function t1.value1(p108)
    t2.value11.EspDistanceColor = p108
    t2.value96(p108)
end
v95:AddColorPicker("EspDistanceColor", {
	Default = v96,
	Title = "Distance Color",
	Callback = t1.value1
})
t1.value1 = t2.value11.EspTracers
v90:AddToggle("EspTracers", {
	Text = "Tracer ESP",
	Default = t1.value1,
	Callback = function(p109)
    t2.value11.EspTracers = p109
    t2.value91(p109)
end
})
local v97 = v90:AddLabel("Tracer Color")
local v98 = t2.value11.EspTracerColor or Color3.fromRGB(0, 150, 255)

function t1.value1(p110)
    t2.value11.EspTracerColor = p110
    t2.value98(p110)
end
v97:AddColorPicker("EspTracerColor", {
	Default = v98,
	Title = "Tracer Color",
	Callback = t1.value1
})
local v99 = t3.Visual:AddLeftGroupbox("Visual", "palette")

t1.value1 = t2.value11.UnlockAllEnabled
v99:AddToggle("UnlockAll", {
	Text = "Unlock All",
	Default = t1.value1,
	Tooltip = "Unlocks all cosmetics",
	Callback = function(p111)
    t2.value11.UnlockAllEnabled = p111
    t2.value33(p111)
end
})
t1.value1 = t2.value11.CustomFOVEnabled
v99:AddToggle("CustomFOV", {
	Text = "Custom FOV",
	Default = t1.value1,
	Tooltip = "Enables custom FOV",
	Callback = function(p112)
    t2.value11.CustomFOVEnabled = p112
    t2.value29(p112)
end
})
local value11_4 = t2.value11
local AddSlider2 = v99.AddSlider
t1.value1 = value11_4.CustomFOVValue
AddSlider2(v99, "CustomFOVValue", {
	Text = "FOV Value",
	Default = t1.value1,
	Min = 30,
	Max = 120,
	Rounding = 0,
	Compact = false,
	Callback = function(p113)
    t2.value11.CustomFOVValue = p113
    t2.value30(p113)
end
})
local v102 = t3.Visual:AddRightGroupbox("Device Spoof", "monitor")
local DeviceSpoofEnabled = t2.value11.DeviceSpoofEnabled
v102:AddToggle("DeviceSpoof", {
	Text = "Enable Device Spoof",
	Default = DeviceSpoofEnabled,
	Tooltip = "Spoofs your device type",
	Callback = function(p114)
    t2.value11.DeviceSpoofEnabled = p114
    t2.value25(p114)
end
})
t1.value1 = {
	"None",
	"Random",
	"PC",
	"Mobile",
	"Controller",
	"VR"
}
local DeviceSpoofType = t2.value11.DeviceSpoofType
v102:AddDropdown("DeviceSpoofType", {
	Values = t1.value1,
	Default = DeviceSpoofType,
	Text = "Device Type",
	Tooltip = "What device to spoof as",
	Callback = function(p115)
    t2.value11.DeviceSpoofType = p115
    t2.value27(p115)
end
})
local v105 = t3.Misc:AddLeftGroupbox("Movement", "move")

t1.value1 = t2.value11.Fly
v105:AddToggle("Fly", {
	Text = "Fly",
	Default = t1.value1,
	Tooltip = "Enables flying",
	Callback = function(p116)
    t2.value11.Fly = p116
    t2.value71(p116)
end
})
t1.value1 = t2.value11.FlySpeed
v105:AddSlider("FlySpeed", {
	Text = "Fly Speed",
	Default = t1.value1,
	Min = 1,
	Max = 500,
	Rounding = 0,
	Compact = false,
	Callback = function(p117)
    t2.value11.FlySpeed = p117
    t2.value73(p117)
end
})
local v106 = t3.Misc:AddRightGroupbox("Player", "user")
local InfiniteJump = t2.value11.InfiniteJump
v106:AddToggle("InfiniteJump", {
	Text = "Infinite Jump",
	Default = InfiniteJump,
	Tooltip = "Allows infinite jumping",
	Callback = function(p118)
    t2.value11.InfiniteJump = p118
    t2.value76(p118)
end
})
local Noclip = t2.value11.Noclip
v106:AddToggle("Noclip", {
	Text = "Noclip",
	Default = Noclip,
	Tooltip = "Walk through walls",
	Callback = function(p119)
    t2.value11.Noclip = p119
    t2.value79(p119)
end
})
local v109 = t3.Animation:AddLeftGroupbox("Animation", "activity")
local AddToggle12 = v109.AddToggle
local AnimationEnabled = t2.value11.AnimationEnabled
AddToggle12(v109, "AnimationEnabled", {
	Text = "Enable Animation",
	Default = AnimationEnabled,
	Tooltip = "Plays custom animations",
	Callback = function(p120)
    t2.value11.AnimationEnabled = p120
    t2.value107(p120)
end
})
local value11_5 = t2.value11
local AddSlider3 = v109.AddSlider
local AnimationSpeed = value11_5.AnimationSpeed
function t1.value1(p121)
    t2.value11.AnimationSpeed = p121
    t2.value109(p121)
end
AddSlider3(v109, "AnimationSpeed", {
	Text = "Animation Speed",
	Default = AnimationSpeed,
	Min = 1,
	Max = 500,
	Rounding = 0,
	Compact = false,
	Callback = t1.value1
})
t1.value1 = {
	"Underground Glitch",
	"Orbit",
	"Tweaking",
	"Kicking Feet",
	"Low Cortisol",
	"Floss",
	"Take the L",
	"Upside Down",
	"Michael Myers Shake",
	"Headless",
	"Wall Peek L",
	"Glitch Through",
	"Spin"
}
local AnimationPreset = t2.value11.AnimationPreset
v109:AddDropdown("AnimationPreset", {
	Values = t1.value1,
	Default = AnimationPreset,
	Text = "Animation Preset",
	Tooltip = "Which animation to play",
	Callback = function(p122)
    t2.value11.AnimationPreset = p122
    t2.value108(p122)
end
})
t1.value1 = t3.Config:AddLeftGroupbox("Configs", "save")

local LegitConfigEnabled = t2.value11.LegitConfigEnabled
t1.value1.AddToggle(t1.value1, "LegitConfig", {
	Text = "Enable Legit Config",
	Default = LegitConfigEnabled,
	Tooltip = "Enables legit settings",
	Callback = function(p123)
    if p123 then
        t2.value11.LegitConfigEnabled = true
        t2.value11.RagebotConfigEnabled = false
        t2.value3.RagebotConfig:SetValue(false)
        t2.value139()

        return
    end

    t2.value11.LegitConfigEnabled = false
    t2.value138()
end
})
local RagebotConfigEnabled = t2.value11.RagebotConfigEnabled
t1.value1.AddToggle(t1.value1, "RagebotConfig", {
	Text = "Enable Ragebot Config",
	Default = RagebotConfigEnabled,
	Tooltip = "Enables ragebot settings",
	Risky = true,
	Callback = function(p124)
    if p124 then
        t2.value11.RagebotConfigEnabled = true
        t2.value11.LegitConfigEnabled = false
        t2.value3.LegitConfig:SetValue(false)
        t2.value140()

        return
    end

    t2.value11.RagebotConfigEnabled = false
    t2.value138()
end
})
t1.value1 = t3["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

local KeybindFrameVisible = t2.value1.KeybindFrame.Visible
t1.value1:AddToggle("KeybindMenuOpen", {
	Default = KeybindFrameVisible,
	Text = "Open Keybind Menu",
	Callback = function(p125)
    t2.value1.KeybindFrame.Visible = p125
end
})
local AddToggle13 = t1.value1.AddToggle
local ShowCustomCursor = t2.value1.ShowCustomCursor
AddToggle13(t1.value1, "ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = ShowCustomCursor,
	Callback = function(p126)
    t2.value1.ShowCustomCursor = p126
end
})
t1.value1.AddDropdown(t1.value1, "NotificationSide", {
	Values = {
		"Left",
		"Right"
	},
	Default = "Right",
	Text = "Notification Side",
	Callback = function(p127)
    t2.value1:SetNotifySide(p127)
end
})
t1.value1.AddDropdown(t1.value1, "DPIDropdown", {
	Values = {
		"50%",
		"75%",
		"100%",
		"125%",
		"150%",
		"175%",
		"200%"
	},
	Default = "100%",
	Text = "DPI Scale",
	Callback = function(p128)
    local num = tonumber((p128:gsub("%%", "")))

    t2.value1:SetDPIScale(num)
end
})
t1.value1:AddDivider()
t1.value1:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
	Default = "RightShift",
	NoUI = true,
	Text = "Menu keybind"
})
t1.value1:AddButton("Unload", function()
    t2.value1:Unload()
end)
t2.value1.ToggleKeybind = t2.value2.MenuKeybind
v5:SetLibrary(t2.value1)
v6:SetLibrary(t2.value1)
v6:IgnoreThemeSettings()
v6:SetIgnoreIndexes({ "MenuKeybind" })
v5:SetFolder("OishiHub")
v6:SetFolder("OishiHub")
v6:BuildConfigSection(t3["UI Settings"])
v5:ApplyToTab(t3["UI Settings"])

local LoadAutoloadConfig = v6.LoadAutoloadConfig
function t1.value1()
    t2.value39()
    t2.value53()
    t2.value57()

    if t2.value63 then
        t2.value63.PlatformStand = false
    end

    if t2.value60 then
        t2.value60:Destroy()
    end

    t2.value75()
    t2.value78()
    t2.value83()
    t2.value107(false)
    t2.value129(false)
    t2.value32()

    if t2.value18 then
        t2.value18:Disconnect()
    end

    if t2.value10 then
        t2.value10.FieldOfView = 70
    end

    t2.value25(false)
end
LoadAutoloadConfig(v6)
t2.value1:OnUnload(t1.value1)
t2.value1:Notify({
	Title = "Oishi Hub",
	Description = "Successfully loaded!",
	Time = 3
})
