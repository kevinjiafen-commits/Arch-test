-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = game:GetService("RunService"),
	value2 = game:GetService("Players"),
	value3 = game:GetService("Workspace"),
	value4 = game:GetService("UserInputService"),
	value5 = game:GetService("Lighting")
}

t1.value6 = t1.value3.CurrentCamera
t1.value7 = t1.value2.LocalPlayer
t1.value8 = {
	enabled = false,
	masterEnabled = false,
	keyMode = "toggle",
	targetPart = "Head",
	fovRadius = 500,
	smoothness = 2,
	aimCurve = "Linear",
	followMuzzle = false,
	teamCheck = true,
	aliveCheck = true,
	wallCheck = false,
	showFov = false,
	lockedTarget = nil,
	smoothCF = nil
}
local color3 = Color3.fromRGB(255, 255, 255)
local color3_2 = Color3.fromRGB(255, 255, 255)
local color3_3 = Color3.fromRGB(255, 255, 255)
local color3_4 = Color3.fromRGB(0, 0, 0)

t1.value9 = {
	OutlineColor1 = color3,
	OutlineColor2 = color3_2,
	OutlineRotation = 0,
	OutlineThickness = 1.5,
	OutlineTransparency = 0,
	FilledEnabled = false,
	FilledColor1 = color3_3,
	FilledColor2 = color3_4,
	FilledRotation = 0,
	FilledTransparency = 0.7,
	FilledAnimated = false,
	FilledSpeed = 1,
	SpinOn = false,
	SpinSpd = 1
}
t1.value10 = Instance.new("ScreenGui")
t1.value10.Name = "AimbotFOV"
t1.value10.ResetOnSpawn = false
local value10 = t1.value10
t1.value11 = nil
value10.IgnoreGuiInset = true
t1.value10.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t1.value10.Parent = game.CoreGui
local v7 = (function(p1, p2)
    local Frame = Instance.new("Frame")

    Frame.Name = p1
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Visible = false
    Frame.Parent = t1.value10

    local Frame2 = Instance.new("Frame")

    Frame2.Size = UDim2.new(1, 0, 1, 0)
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame2.BackgroundTransparency = p2.FilledTransparency
    Frame2.BorderSizePixel = 0
    Frame2.Visible = false
    Frame2.ZIndex = 1
    Frame2.Parent = Frame
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, p2.FilledColor1),
		ColorSequenceKeypoint.new(1, p2.FilledColor2)
	})
    UIGradient.Rotation = p2.FilledRotation
    UIGradient.Parent = Frame2

    local Frame3 = Instance.new("Frame")

    Frame3.Size = UDim2.new(1, 0, 1, 0)
    Frame3.BackgroundTransparency = 1
    Frame3.BorderSizePixel = 0
    Frame3.ZIndex = 2
    Frame3.Parent = Frame
    Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Thickness = p2.OutlineThickness
    UIStroke.Transparency = p2.OutlineTransparency
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame3

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, p2.OutlineColor1),
		ColorSequenceKeypoint.new(1, p2.OutlineColor2)
	})
    UIGradient2.Rotation = p2.OutlineRotation
    UIGradient2.Parent = UIStroke

    return {
		container = Frame,
		fill = Frame2,
		fillgrad = UIGradient,
		stroke = UIStroke,
		strokegrad = UIGradient2
	}
end)("AimbotFOV", t1.value9)

t1.value12 = v7.container
t1.value13 = v7.fill
t1.value14 = v7.fillgrad
t1.value15 = v7.stroke
t1.value16 = v7.strokegrad
function t1.value17(p3, p4)
    if not p4 then
        p4 = t1.value6
    end

    if not p4 or not p3 then
        return nil, false
    end

    local v160, v161 = p4:WorldToViewportPoint(p3)

    if not v161 or v160.Z <= 0 then
        return v160, false
    end

    return v160, true
end
function t1.value18(p5)
    if not p5 then
        p5 = t1.value6
    end

    if not p5 then
        return Vector2.zero
    end

    local ViewportSize = p5.ViewportSize

    return Vector2.new(ViewportSize.X * 0.5, ViewportSize.Y * 0.5)
end
function t1.value19(p6)
    if not p6 then
        return nil
    end

    local v163, v164 = t1.value17(p6, t1.value6)

    if not v164 then
        return nil
    end

    return Vector2.new(v163.X, v163.Y)
end
t1.value20 = nil
function t1.value20()
    local Character = t1.value7.Character

    if not Character then
        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera then
            CurrentCamera = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 4
        end

        if not CurrentCamera then
            CurrentCamera = Vector3.zero
        end

        return CurrentCamera
    end

    local ViewModels = t1.value3:FindFirstChild("ViewModels")

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
                            local v178 = _muzzle

                            if _muzzle then
                                v178 = _muzzle:IsA("Attachment")
                            end

                            if v178 then
                                return _muzzle.WorldPosition
                            end
                        end
                    end
                end

                local Muzzle = child:FindFirstChild("Muzzle")

                if not Muzzle then
                    Muzzle = child:FindFirstChild("MuzzleFlash")

                    if not Muzzle then
                        Muzzle = child:FindFirstChild("Barrel") or child:FindFirstChild("GunTip")
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

                    local v182 = child2.Name:lower()
                    local v183 = v182:find("tip")

                    if not v183 then
                        v183 = v182:find("barrel") or v182:find("muzzle")
                    end

                    if v183 then
                        return child2.Position
                    end
                end

                local PrimaryPart = child.PrimaryPart

                if not PrimaryPart then
                    PrimaryPart = child:FindFirstChildWhichIsA("BasePart")
                end

                if PrimaryPart then
                    return PrimaryPart.Position
                end
            end
        end
    end

    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        return CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 4
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local v187 = HumanoidRootPart and HumanoidRootPart.Position

    if not v187 then
        v187 = Vector3.zero
    end

    return v187
end
function t1.value21()
    if t1.value8.followMuzzle then
        local v167 = t1.value19(t1.value20())

        if v167 then
            return v167
        end
    end

    return t1.value18(t1.value6)
end
local function v8()
    if t1.value8.followMuzzle then
        return t1.value21()
    end

    local MouseLocation = t1.value4:GetMouseLocation()

    return Vector2.new(MouseLocation.X, MouseLocation.Y)
end
function t1.value22(p7)
    if not p7 then
        return false
    end

    if p7 == t1.value7 then
        return false
    end

    if t1.value8.teamCheck then
        local TeamID = t1.value7:GetAttribute("TeamID")
        local TeamID2 = p7:GetAttribute("TeamID")

        if TeamID then
            TeamID = TeamID2 and TeamID == TeamID2
        end

        if TeamID then
            return false
        end

        local Team = t1.value7.Team

        if Team then
            Team = p7.Team

            if Team then
                Team = t1.value7.Team == p7.Team
            end
        end

        if Team then
            return false
        end
    end

    if t1.value8.aliveCheck then
        local Character = p7.Character

        if not Character then
            return false
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid or Humanoid.Health <= 0 then
            return false
        end

        if Character:FindFirstChildOfClass("ForceField") then
            return false
        end
    end

    return true
end
function t1.value23(p8)
    if not t1.value8.wallCheck then
        return true
    end

    if not p8 or not p8.Character then
        return false
    end

    local v145 = p8.Character:FindFirstChild(t1.value8.targetPart) or p8.Character:FindFirstChild("Head")

    if not v145 then
        return false
    end

    local CFramePosition = t1.value6.CFrame.Position
    local Position = v145.Position
    local Unit = (Position - CFramePosition).Unit
    local Magnitude = (Position - CFramePosition).Magnitude
    local raycastParams = RaycastParams.new()

    raycastParams.FilterDescendantsInstances = { t1.value7.Character }
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true

    local raycastResult = workspace:Raycast(CFramePosition, Unit * Magnitude, raycastParams)

    if not raycastResult then
        return true
    end

    if raycastResult.Instance:FindFirstAncestorOfClass("Model") == p8.Character then
        return true
    end

    return raycastResult.Instance:IsDescendantOf(p8.Character)
end
local function v9()
    local v210
    local fovRadius = t1.value8.fovRadius
    local v212 = v8()
    if not v212 then
        return nil
    end
    local value6 = t1.value6
    for _, player in ipairs(t1.value2:GetPlayers()) do
        local v216 = player ~= t1.value7

        if v216 then
            v216 = player.Character and t1.value22(player)
        end

        if v216 then
            local t1value8targetPart = player.Character:FindFirstChild(t1.value8.targetPart)
            local v218 = t1value8targetPart

            if t1value8targetPart then
                v218 = t1value8targetPart:IsDescendantOf(workspace)
            end

            if v218 then
                local v220, t2Result = t1.value17(t1value8targetPart.Position, value6)
                if t2Result then
                    local v221 = v220.X - v212.X
                    local v222 = v220.Y - v212.Y
                    local v223 = math.sqrt(v221 * v221 + v222 * v222)

                    if v223 < fovRadius and t1.value23(player) then
                        fovRadius = v223
                        v210 = t1value8targetPart
                    end
                end
            end
        end
    end

    return v210
end
function t1.value24(p9)
    local v190 = math.clamp(tonumber(t1.value8.smoothness) or 2, 0.1, 10)
    local v191 = t1.value8.aimCurve or "Linear"
    local v192 = 6 / v190

    if v191 == "Instant" then
        return 1
    end

    if v191 == "Expo" then
        return 1 - math.exp(-(4 / v190) * p9)
    end

    if v191 == "EaseIn" then
        local v193 = math.clamp(v192 * p9, 0, 1)

        return v193 * v193
    end

    if v191 == "EaseOut" then
        local v194 = math.clamp(v192 * p9, 0, 1)

        return 1 - (1 - v194) * (1 - v194)
    end

    if v191 == "EaseInOut" then
        local v195 = math.clamp(v192 * p9, 0, 1)

        if v195 < 0.5 then
            return 2 * v195 * v195
        end

        return 1 - (-2 * v195 + 2) ^ 2 / 2
    end

    if v191 == "Cubic" then
        local v196 = math.clamp(v192 * p9, 0, 1)

        return v196 * v196 * v196
    end

    return math.clamp(v192 * p9, 0, 1)
end
function t1.value25()
    t1.value8.lockedTarget = nil
    t1.value8.smoothCF = nil
end
function t1.value26(p10)
    if not p10 then
        p10 = t1.value6
    end

    if not p10 then
        return nil
    end

    local p10CFrame = p10.CFrame
    local p10CFramePosition = p10CFrame.Position
    local LookVector = p10CFrame.LookVector
    local RightVector = p10CFrame.RightVector
    local Unit = RightVector:Cross(LookVector).Unit

    return CFrame.fromMatrix(p10CFramePosition, RightVector, Unit, -LookVector)
end
t1.value11 = nil
pcall(function()
    local CameraController = t1.value7.PlayerScripts:WaitForChild("Controllers", 10):FindFirstChild("CameraController")
    local v135 = CameraController

    if CameraController then
        v135 = CameraController:IsA("ModuleScript")
    end

    if v135 then
        t1.value11 = require(CameraController)
    end
end)

function t1.value27()
    t1.value12.Visible = t1.value8.showFov

    if not t1.value8.enabled then
        t1.value25()

        return
    end
end
t1.value1:BindToRenderStep("InstanceAimbotUpdate", Enum.RenderPriority.Camera.Value + 1, function(p11)
    local enabled = t1.value8.enabled
    local v226 = p11 or 0.0041666666666667

    if not enabled then
        t1.value25()

        return
    end

    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    t1.value6 = CurrentCamera

    if not t1.value8.lockedTarget then
        t1.value8.lockedTarget = v9()
        t1.value8.smoothCF = t1.value26(CurrentCamera)

        if not t1.value8.lockedTarget then
            return
        end
    end

    local v228 = not t1.value8.lockedTarget.Parent

    if not v228 then
        v228 = not t1.value8.lockedTarget:IsDescendantOf(workspace)
    end

    if v228 then
        t1.value25()

        return
    end

    local player = t1.value2:GetPlayerFromCharacter(t1.value8.lockedTarget.Parent)

    if player then
        if not t1.value22(player) then
            t1.value25()

            return
        end

        if t1.value8.wallCheck and not t1.value23(player) then
            t1.value25()

            return
        end
    end

    local Character = t1.value7.Character

    if not Character then
        return
    end

    if not Character:FindFirstChild("Head") then
        t1.value25()

        return
    end

    if not t1.value11 then
        return
    end

    if not t1.value8.smoothCF then
        t1.value8.smoothCF = t1.value26(CurrentCamera)
    end

    local cFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, t1.value8.lockedTarget.Position)
    local v232 = t1.value24(v226)

    t1.value8.smoothCF = t1.value8.smoothCF:Lerp(cFrame, v232)

    local value11 = t1.value11

    if value11 then
        value11 = t1.value11.MimicRotation
    end

    if value11 then
        pcall(function()
            t1.value11:MimicRotation(t1.value8.smoothCF)
        end)
    end
end)
t1.value1.RenderStepped:Connect(function()
    if t1.value12.Visible then
        local v234 = t1.value21()
        local fovRadius = t1.value8.fovRadius

        t1.value12.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
        t1.value12.Position = UDim2.fromOffset(v234.X - fovRadius, v234.Y - fovRadius)

        if t1.value9.FilledAnimated then
            t1.value14.Rotation = math.sin(tick() * t1.value9.FilledSpeed) * 180 + t1.value9.FilledRotation
        elseif t1.value9.SpinOn then
            t1.value14.Rotation = t1.value9.FilledRotation + tick() * t1.value9.SpinSpd * 90 % 360
        end

        if t1.value9.SpinOn then
            t1.value16.Rotation = t1.value9.OutlineRotation + tick() * t1.value9.SpinSpd * 90 % 360
        end
    end
end)
t1.value27()
local v10 = getgenv()
local value8 = t1.value8
local value9 = t1.value9
v10.Aimbot = {
	Enable = function()
    t1.value8.enabled = true
    t1.value8.masterEnabled = true
    t1.value27()
end,
	Disable = function()
    t1.value8.enabled = false
    t1.value8.masterEnabled = false
    t1.value27()
end,
	Toggle = function()
    t1.value8.enabled = not t1.value8.enabled
    t1.value8.masterEnabled = t1.value8.enabled
    t1.value27()
end,
	SetTargetPart = function(p12)
    t1.value8.targetPart = p12
    t1.value25()
end,
	SetFOV = function(p13)
    t1.value8.fovRadius = p13
end,
	SetSmoothness = function(p14)
    t1.value8.smoothness = math.clamp(p14, 0.1, 10)
end,
	SetAimCurve = function(p15)
    t1.value8.aimCurve = p15
end,
	SetTeamCheck = function(p16)
    t1.value8.teamCheck = p16
    t1.value25()
end,
	SetAliveCheck = function(p17)
    t1.value8.aliveCheck = p17
    t1.value25()
end,
	SetWallCheck = function(p18)
    t1.value8.wallCheck = p18
    t1.value25()
end,
	SetFollowMuzzle = function(p19)
    t1.value8.followMuzzle = p19
end,
	ShowFOV = function()
    t1.value8.showFov = true
    t1.value12.Visible = true
end,
	HideFOV = function()
    t1.value8.showFov = false
    t1.value12.Visible = false
end,
	SetFOVOutlineColors = function(p20, p21)
    t1.value9.OutlineColor1 = p20
    t1.value9.OutlineColor2 = p21
    t1.value16.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, p20),
			ColorSequenceKeypoint.new(1, p21)
		})
end,
	SetFOVFillColors = function(p22, p23)
    t1.value9.FilledColor1 = p22
    t1.value9.FilledColor2 = p23
    t1.value14.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, p22),
			ColorSequenceKeypoint.new(1, p23)
		})
end,
	SetFOVFilled = function(p24)
    t1.value9.FilledEnabled = p24
    t1.value13.Visible = p24
end,
	SetFOVSpin = function(p25)
    t1.value9.SpinOn = p25
end,
	SetFOVSpinSpeed = function(p26)
    t1.value9.SpinSpd = p26
end,
	SetFOVThickness = function(p27)
    t1.value9.OutlineThickness = p27
    t1.value15.Thickness = p27
end,
	Config = value8,
	FOVConfig = value9,
	GetLockedTarget = function()
    return t1.value8.lockedTarget
end,
	ClearTarget = t1.value25
}
print("[Instance Aimbot] All features loaded!")
_G.Config = _G.Config or {}
local Config = _G.Config
local Box = _G.Config.Box
if not Box then
    local color3_5 = Color3.fromRGB(255, 255, 255)
    local color3_6 = Color3.fromRGB(255, 255, 255)
    local color3_7 = Color3.fromRGB(255, 255, 255)
    local t3 = {
		Enable = false,
		Thickness = 4
	}
    local color3_8 = Color3.fromRGB(0, 255, 0)
    local color3_9 = Color3.fromRGB(255, 255, 0)
    local color3_10 = Color3.fromRGB(255, 0, 0)
    local t4 = {
		Color1 = color3_8,
		Color2 = color3_9,
		Color3 = color3_10
	}

    Box = {
		MasterEnabled = false,
		Enable = false,
		OutlineColor = color3_5,
		OutlineColor2 = color3_6,
		FillColor = color3_7,
		Healthbar = t3,
		HealthLerpColors = t4
	}
end
Config.Box = Box
local Config2 = _G.Config
local Filled = _G.Config.Filled
if not Filled then
    local color3_11 = Color3.fromRGB(255, 255, 255)
    local color3_12 = Color3.fromRGB(255, 255, 255)

    Filled = {
		Enable = false,
		Transparency = 0.7,
		ColorStart = color3_11,
		ColorEnd = color3_12,
		Rotation = 0,
		Animated = false,
		Speed = 1
	}
end
Config2.Filled = Filled
local Config3 = _G.Config
local Glow = _G.Config.Glow
if not Glow then
    local color3_13 = Color3.fromRGB(255, 255, 255)
    local color3_14 = Color3.fromRGB(255, 255, 255)

    Glow = {
		Enable = false,
		Transparency = 0.5,
		ColorStart = color3_13,
		ColorEnd = color3_14,
		Rotation = 0
	}
end
Config3.Glow = Glow
local Config4 = _G.Config
local TextESP = _G.Config.TextESP
if not TextESP then
    local color3_15 = Color3.fromRGB(255, 255, 255)
    local color3_16 = Color3.fromRGB(255, 255, 255)
    local color3_17 = Color3.fromRGB(255, 255, 255)
    local color3_18 = Color3.fromRGB(255, 255, 255)
    local color3_19 = Color3.fromRGB(255, 255, 255)
    local color3_20 = Color3.fromRGB(255, 255, 255)

    TextESP = {
		Names = false,
		Distance = false,
		Tools = false,
		NameSize = 8,
		DistanceSize = 8,
		ToolsSize = 8,
		NameColor = color3_15,
		NameColor2 = color3_16,
		DistanceColor = color3_17,
		DistanceColor2 = color3_18,
		ToolColor = color3_19,
		ToolColor2 = color3_20
	}
end
Config4.TextESP = TextESP
local Config5 = _G.Config
local Skeleton = _G.Config.Skeleton
if not Skeleton then
    local color3_21 = Color3.fromRGB(255, 255, 255)
    local color3_22 = Color3.fromRGB(255, 255, 255)

    Skeleton = {
		Enable = false,
		Color = color3_21,
		Color2 = color3_22,
		Thickness = 1
	}
end
Config5.Skeleton = Skeleton
local Config6 = _G.Config
local Tracers = _G.Config.Tracers
if not Tracers then
    local color3_23 = Color3.fromRGB(255, 255, 255)
    local color3_24 = Color3.fromRGB(255, 255, 255)

    Tracers = {
		Enable = false,
		Color = color3_23,
		Color2 = color3_24,
		Thickness = 1,
		FromBottom = true
	}
end
Config6.Tracers = Tracers
local Config7 = _G.Config
local Chams = _G.Config.Chams
if not Chams then
    local color3_25 = Color3.fromRGB(255, 255, 255)
    local color3_26 = Color3.fromRGB(255, 255, 255)

    Chams = {
		Enable = false,
		Color = color3_25,
		Color2 = color3_26,
		Transparency = 0
	}
end
Config7.Chams = Chams
_G.ESPObjects = _G.ESPObjects or {}
t1.value28 = _G.ESPObjects
t1.value29 = Instance.new("ScreenGui")
t1.value29.Name = "ESP"
t1.value29.DisplayOrder = 9000000000
t1.value29.ResetOnSpawn = false
t1.value29.IgnoreGuiInset = true
t1.value29.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t1.value29.Parent = game.CoreGui
local function v51(p28)
    local v270, v271 = t1.value6:WorldToViewportPoint(p28)
    local v272 = not v271

    if not v272 then
        v272 = v270.Z <= 0
    end

    if v272 then
        return nil, false
    end

    return Vector2.new(v270.X, v270.Y), true
end
function t1.value30(p29)
    if not p29 or p29 == t1.value7 then
        return true
    end

    local TeamID = t1.value7:GetAttribute("TeamID")
    local TeamID3 = p29:GetAttribute("TeamID")

    if TeamID ~= nil and TeamID3 ~= nil then
        return TeamID == TeamID3
    end

    local Team = t1.value7.Team

    if Team then
        Team = p29.Team

        if Team then
            Team = t1.value7.Team == p29.Team
        end
    end

    return Team
end
function t1.value31(p30)
    local Character = p30.Character

    if not Character then
        return false
    end

    local BodyEffects = Character:FindFirstChild("BodyEffects")

    if BodyEffects then
        local v268 = BodyEffects:FindFirstChild("K.O")

        if not v268 then
            v268 = BodyEffects:FindFirstChild("KO")
        end

        return v268 and v268.Value
    end

    return false
end
function t1.value32(p31)
    local Character = p31.Character
    local Character2 = t1.value7.Character

    if Character and Character2 then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart and HumanoidRootPart2 then
            return (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude
        end
    end

    return 1e999
end
function t1.value33(p32)
    if not p32 then
        return "None"
    end

    local ViewModels = workspace:FindFirstChild("ViewModels")

    if not ViewModels then
        return "None"
    end

    for _, child in ipairs(ViewModels:GetChildren()) do
        local v281 = (function(p33)
            local t5 = {}

            for match in p33:gmatch("[^-]+") do
                table.insert(t5, match:match("^%s*(.-)%s*$"))
            end

            local v532 = #t5 >= 2

            if v532 then
                v532 = t5[1] == p32.Name
            end

            if v532 then
                return t5[2]
            end

            return nil
        end)(child.Name)

        if v281 then
            return v281
        end
    end

    return "None"
end
function t1.value34(p34, p35, p36)
    return Color3.new(p34.R + (p35.R - p34.R) * p36, p34.G + (p35.G - p34.G) * p36, p34.B + (p35.B - p34.B) * p36)
end
function t1.value35(p37)
    local HealthLerpColors = _G.Config.Box.HealthLerpColors

    if p37 > 0.5 then
        return t1.value34(HealthLerpColors.Color2, HealthLerpColors.Color1, (p37 - 0.5) * 2)
    end

    return t1.value34(HealthLerpColors.Color3, HealthLerpColors.Color2, p37 * 2)
end
function t1.value36(p38)
    local n1 = -1e999
    local n2 = 1e999
    local v292 = -1e999
    local n3 = 1e999
    local GetDescendants = p38.GetDescendants
    local v295 = false
    for v298, v299 in ipairs(GetDescendants(p38)) do

        if v299:IsA("BasePart") and v299.Transparency < 1 then
            local CFrame2 = v299.CFrame
            local v301 = v299.Size / 2
            local t6 = {
				CFrame2 * Vector3.new(-v301.X, -v301.Y, -v301.Z),
				CFrame2 * Vector3.new(v301.X, -v301.Y, -v301.Z),
				CFrame2 * Vector3.new(-v301.X, v301.Y, -v301.Z),
				CFrame2 * Vector3.new(v301.X, v301.Y, -v301.Z),
				CFrame2 * Vector3.new(-v301.X, -v301.Y, v301.Z),
				CFrame2 * Vector3.new(v301.X, -v301.Y, v301.Z),
				CFrame2 * Vector3.new(-v301.X, v301.Y, v301.Z),
				CFrame2 * Vector3.new(v301.X, v301.Y, v301.Z)
			}

            for _, v in ipairs(t6) do
                local v306, t7Result = v51(v)
                if t7Result then
                    v295 = true
                    n3 = math.min(n3, v306.X)
                    n2 = math.min(n2, v306.Y)
                    n1 = math.max(n1, v306.X)
                    v292 = math.max(v292, v306.Y)
                end
            end
        end
    end
    if not v295 then
        return nil, nil
    end

    return Vector2.new(n1 - n3, v292 - n2), Vector2.new(n3, n2)
end
function t1.value37(p39)
    if t1.value28[p39] then
        return
    end

    local t8 = {}
    local drawing = Drawing.new("Square")
    local drawing2 = Drawing.new("Square")
    local drawing3 = Drawing.new("Square")

    t8.box = {
		square = drawing,
		outline = drawing2,
		inline = drawing3
	}
    t8.bars = {
		hpOutline = Drawing.new("Square"),
		hpBars = {}
	}

    for i = 1, 50 do
        t8.bars.hpBars[i] = Drawing.new("Line")
    end

    t8.skeleton = {
		lines = {},
		outlines = {}
	}

    for i = 1, 15 do
        t8.skeleton.outlines[i] = Drawing.new("Line")
        t8.skeleton.outlines[i].Color = Color3.new(0, 0, 0)
        t8.skeleton.outlines[i].Thickness = 3
        t8.skeleton.lines[i] = Drawing.new("Line")
    end

    t8.tracer = Drawing.new("Line")
    t8.nameLabel = Drawing.new("Text")
    t8.nameLabel.Size = 13
    t8.nameLabel.Font = 2
    t8.nameLabel.Outline = true
    t8.nameLabel.Center = true
    t8.distLabel = Drawing.new("Text")
    t8.distLabel.Size = 13
    t8.distLabel.Font = 2
    t8.distLabel.Outline = true
    t8.distLabel.Center = true
    t8.weaponLabel = Drawing.new("Text")
    t8.weaponLabel.Size = 13
    t8.weaponLabel.Font = 2
    t8.weaponLabel.Outline = true
    t8.weaponLabel.Center = true
    t8.filled = Instance.new("Frame")
    t8.filled.BackgroundColor3 = Color3.new(1, 1, 1)
    t8.filled.BackgroundTransparency = _G.Config.Filled.Transparency
    t8.filled.BorderSizePixel = 0
    t8.filled.Visible = false
    t8.filled.ZIndex = 2
    t8.filled.Parent = t1.value29
    t8.filledGrad = Instance.new("UIGradient")
    t8.filledGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, _G.Config.Filled.ColorStart),
		ColorSequenceKeypoint.new(1, _G.Config.Filled.ColorEnd)
	})
    t8.filledGrad.Parent = t8.filled
    t8.glow = Instance.new("ImageLabel")
    t8.glow.Image = "rbxassetid://110204605000367"
    t8.glow.ScaleType = Enum.ScaleType.Slice
    t8.glow.SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
    t8.glow.BackgroundTransparency = 1
    t8.glow.Visible = false
    t8.glow.ZIndex = 1
    t8.glow.Parent = t1.value29
    t8.glowGrad = Instance.new("UIGradient")
    t8.glowGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, _G.Config.Glow.ColorStart),
		ColorSequenceKeypoint.new(1, _G.Config.Glow.ColorEnd)
	})
    t8.glowGrad.Parent = t8.glow
    t1.value28[p39] = t8
end
function t1.value38(p40)
    local v253 = t1.value28[p40]

    if not v253 then
        return
    end

    v253.box.square.Visible = false
    v253.box.outline.Visible = false
    v253.box.inline.Visible = false
    v253.bars.hpOutline.Visible = false

    for _, v in ipairs(v253.bars.hpBars) do
        v.Visible = false
    end

    for i = 1, 15 do
        v253.skeleton.lines[i].Visible = false
        v253.skeleton.outlines[i].Visible = false
    end

    v253.tracer.Visible = false
    v253.nameLabel.Visible = false
    v253.distLabel.Visible = false
    v253.weaponLabel.Visible = false
    v253.filled.Visible = false
    v253.glow.Visible = false

    if v253.cham then
        v253.cham.Enabled = false
    end
end
t1.value39 = {
	{
		"UpperTorso",
		"Head"
	},
	{
		"UpperTorso",
		"LowerTorso"
	},
	{
		"UpperTorso",
		"LeftUpperArm"
	},
	{
		"LeftUpperArm",
		"LeftLowerArm"
	},
	{
		"LeftLowerArm",
		"LeftHand"
	},
	{
		"UpperTorso",
		"RightUpperArm"
	},
	{
		"RightUpperArm",
		"RightLowerArm"
	},
	{
		"RightLowerArm",
		"RightHand"
	},
	{
		"LowerTorso",
		"LeftUpperLeg"
	},
	{
		"LeftUpperLeg",
		"LeftLowerLeg"
	},
	{
		"LeftLowerLeg",
		"LeftFoot"
	},
	{
		"LowerTorso",
		"RightUpperLeg"
	},
	{
		"RightUpperLeg",
		"RightLowerLeg"
	},
	{
		"RightLowerLeg",
		"RightFoot"
	}
}
t1.value40 = {
	{
		"Torso",
		"Head"
	},
	{
		"Torso",
		"Left Arm"
	},
	{
		"Torso",
		"Right Arm"
	},
	{
		"Torso",
		"Left Leg"
	},
	{
		"Torso",
		"Right Leg"
	}
}
t1.value1:BindToRenderStep("ESPUpdate", Enum.RenderPriority.Last.Value, function(_)
    if not _G.Config.Box.MasterEnabled then
        for _, v in pairs(t1.value28) do
            t1.value38(v)
        end

        return
    end

    for _, player in ipairs(t1.value2:GetPlayers()) do
        if player ~= t1.value7 then
            if t1.value30(player) then
                t1.value38(player)
            else
                local Character = player.Character

                if not Character or t1.value31(player) then
                    t1.value38(player)
                else
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    local v321 = not Humanoid
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                    if not v321 then
                        v321 = not HumanoidRootPart or Humanoid.Health <= 0
                    end

                    if v321 then
                        t1.value38(player)
                    else
                        local v324, t9Result = v51(HumanoidRootPart.Position)
                        if not t9Result then
                            t1.value38(player)
                        else
                            if not t1.value28[player] then
                                t1.value37(player)
                            end

                            local v325 = t1.value28[player]
                            local v326 = t1.value32(player)
                            local v327, v328 = t1.value36(Character)

                            if not v327 then
                                t1.value38(player)
                            else
                                local vector2 = Vector2.new(math.max(v327.X, 4), (math.max(v327.Y, 8)))
                                local vector2_2 = Vector2.new(math.floor(v328.X), (math.floor(v328.Y)))

                                if _G.Config.Box.Enable then
                                    v325.box.square.Visible = true
                                    v325.box.square.Position = vector2_2
                                    v325.box.square.Size = vector2
                                    v325.box.square.Color = t1.value34(_G.Config.Box.OutlineColor, _G.Config.Box.OutlineColor2, 0.5)
                                    v325.box.square.Thickness = 1
                                    v325.box.square.Filled = false
                                    v325.box.outline.Visible = true
                                    v325.box.outline.Position = vector2_2 - Vector2.new(1, 1)
                                    v325.box.outline.Size = vector2 + Vector2.new(2, 2)
                                    v325.box.outline.Color = Color3.new(0, 0, 0)
                                    v325.box.outline.Thickness = 1
                                    v325.box.outline.Filled = false
                                    v325.box.inline.Visible = true
                                    v325.box.inline.Position = vector2_2 + Vector2.new(1, 1)
                                    v325.box.inline.Size = Vector2.new(math.max(vector2.X - 2, 2), (math.max(vector2.Y - 2, 4)))
                                    v325.box.inline.Color = Color3.new(0, 0, 0)
                                    v325.box.inline.Thickness = 1
                                    v325.box.inline.Filled = false
                                else
                                    v325.box.square.Visible = false
                                    v325.box.outline.Visible = false
                                    v325.box.inline.Visible = false
                                end

                                if _G.Config.Filled.Enable then
                                    v325.filled.Visible = true
                                    v325.filled.Position = UDim2.fromOffset(vector2_2.X, vector2_2.Y)
                                    v325.filled.Size = UDim2.fromOffset(vector2.X, vector2.Y)
                                    v325.filledGrad.Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, _G.Config.Filled.ColorStart),
										ColorSequenceKeypoint.new(1, _G.Config.Filled.ColorEnd)
									})

                                    if _G.Config.Filled.Animated then
                                        v325.filledGrad.Rotation = math.sin(tick() * _G.Config.Filled.Speed) * 180
                                    end
                                else
                                    v325.filled.Visible = false
                                end

                                local Enable = _G.Config.Glow.Enable

                                if Enable then
                                    Enable = _G.Config.Box.Enable
                                end

                                if Enable then
                                    v325.glow.Visible = true
                                    v325.glow.ImageTransparency = _G.Config.Glow.Transparency
                                    v325.glow.Position = UDim2.fromOffset(vector2_2.X - 21, vector2_2.Y - 21)
                                    v325.glow.Size = UDim2.fromOffset(vector2.X + 42, vector2.Y + 42)
                                    v325.glowGrad.Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, _G.Config.Glow.ColorStart),
										ColorSequenceKeypoint.new(1, _G.Config.Glow.ColorEnd)
									})
                                else
                                    v325.glow.Visible = false
                                end

                                if _G.Config.Box.Healthbar.Enable then
                                    local v332 = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)
                                    local v333 = math.ceil(vector2.Y * v332)
                                    local v334 = vector2_2.X - 5
                                    local v335 = vector2_2.Y + (vector2.Y - v333)

                                    v325.bars.hpOutline.Visible = true
                                    v325.bars.hpOutline.Position = Vector2.new(v334 - 1, vector2_2.Y - 1)
                                    v325.bars.hpOutline.Size = Vector2.new(3, vector2.Y + 2)
                                    v325.bars.hpOutline.Color = Color3.new(0, 0, 0)
                                    v325.bars.hpOutline.Filled = false

                                    local v336 = math.max(math.min(math.floor(v333 / 2), 50), 10)

                                    for i = 1, 50 do
                                        local v338 = i

                                        if v338 <= v336 then
                                            local v339 = v333 / v336
                                            local v340 = (v338 - 1) * v339
                                            local v341 = 1 - (v340 + (vector2.Y - v333)) / vector2.Y

                                            v325.bars.hpBars[v338].Visible = true
                                            v325.bars.hpBars[v338].From = Vector2.new(v334, v335 + v340)
                                            v325.bars.hpBars[v338].To = Vector2.new(v334 + 1, v335 + v340)
                                            v325.bars.hpBars[v338].Color = t1.value35(v341)
                                            v325.bars.hpBars[v338].Thickness = math.max(v339, 1)
                                        else
                                            v325.bars.hpBars[v338].Visible = false
                                        end
                                    end
                                else
                                    v325.bars.hpOutline.Visible = false

                                    for _, v in ipairs(v325.bars.hpBars) do
                                        v.Visible = false
                                    end
                                end

                                if _G.Config.TextESP.Names then
                                    v325.nameLabel.Visible = true
                                    v325.nameLabel.Text = player.Name
                                    v325.nameLabel.Position = Vector2.new(vector2_2.X + vector2.X / 2, vector2_2.Y - 15)
                                    v325.nameLabel.Color = t1.value34(_G.Config.TextESP.NameColor, _G.Config.TextESP.NameColor2, 0.5)
                                else
                                    v325.nameLabel.Visible = false
                                end

                                if _G.Config.TextESP.Distance then
                                    v325.distLabel.Visible = true
                                    v325.distLabel.Text = string.format("%.0f studs", v326)
                                    v325.distLabel.Position = Vector2.new(vector2_2.X + vector2.X / 2, vector2_2.Y + vector2.Y + 2)
                                    v325.distLabel.Color = t1.value34(_G.Config.TextESP.DistanceColor, _G.Config.TextESP.DistanceColor2, 0.5)
                                else
                                    v325.distLabel.Visible = false
                                end

                                if _G.Config.TextESP.Tools then
                                    v325.weaponLabel.Visible = true
                                    v325.weaponLabel.Text = t1.value33(player)
                                    v325.weaponLabel.Position = Vector2.new(vector2_2.X + vector2.X + 5, vector2_2.Y)
                                    v325.weaponLabel.Color = t1.value34(_G.Config.TextESP.ToolColor, _G.Config.TextESP.ToolColor2, 0.5)
                                else
                                    v325.weaponLabel.Visible = false
                                end

                                if _G.Config.Skeleton.Enable then
                                    local v344 = Humanoid.RigType == Enum.HumanoidRigType.R15 and t1.value39 or t1.value40

                                    for i = 1, 15 do
                                        local v346 = v344[i]
                                        local v347 = v325.skeleton.lines[i]
                                        local v348 = v325.skeleton.outlines[i]

                                        if v346 then
                                            local v349 = Character:FindFirstChild(v346[1])
                                            local v350 = Character:FindFirstChild(v346[2])

                                            if v349 and v350 then
                                                local Position = v349.Position
                                                local v352, v353 = t1.value6:WorldToViewportPoint(Position)
                                                local v354 = not v353

                                                if not v354 then
                                                    v354 = v352.Z <= 0
                                                end

                                                local v355, v356

                                                if v354 then
                                                    v355 = nil
                                                    v356 = false
                                                else
                                                    v355 = Vector2.new(v352.X, v352.Y)
                                                    v356 = true
                                                end

                                                local Position2 = v350.Position
                                                local v358, v359 = t1.value6:WorldToViewportPoint(Position2)
                                                local v360 = not v359

                                                if not v360 then
                                                    v360 = v358.Z <= 0
                                                end

                                                local v361, v362

                                                if v360 then
                                                    v361 = nil
                                                    v362 = false
                                                else
                                                    v361 = Vector2.new(v358.X, v358.Y)
                                                    v362 = true
                                                end

                                                if v356 and v362 then
                                                    local vector2_3 = Vector2.new(v355.X, v355.Y)
                                                    local vector2_4 = Vector2.new(v361.X, v361.Y)

                                                    v348.Visible = true
                                                    v348.From = vector2_3
                                                    v348.To = vector2_4
                                                    v348.Thickness = _G.Config.Skeleton.Thickness + 2
                                                    v347.Visible = true
                                                    v347.From = vector2_3
                                                    v347.To = vector2_4
                                                    v347.Thickness = _G.Config.Skeleton.Thickness
                                                    v347.Color = t1.value34(_G.Config.Skeleton.Color, _G.Config.Skeleton.Color2, (vector2_3.X + vector2_4.X) * 0.5 / (vector2_2.X + vector2.X))
                                                else
                                                    v347.Visible = false
                                                    v348.Visible = false
                                                end
                                            else
                                                v347.Visible = false
                                                v348.Visible = false
                                            end
                                        else
                                            v347.Visible = false
                                            v348.Visible = false
                                        end
                                    end
                                else
                                    for i = 1, 15 do
                                        v325.skeleton.lines[i].Visible = false
                                        v325.skeleton.outlines[i].Visible = false
                                    end
                                end

                                if _G.Config.Tracers.Enable then
                                    v325.tracer.Visible = true
                                    v325.tracer.To = Vector2.new(v324.X, v324.Y)

                                    local tracer = v325.tracer
                                    local FromBottom = _G.Config.Tracers.FromBottom

                                    if FromBottom then
                                        FromBottom = Vector2.new(t1.value6.ViewportSize.X / 2, t1.value6.ViewportSize.Y)
                                    end

                                    if not FromBottom then
                                        FromBottom = Vector2.new(t1.value6.ViewportSize.X / 2, 0)
                                    end

                                    tracer.From = FromBottom
                                    v325.tracer.Color = t1.value34(_G.Config.Tracers.Color, _G.Config.Tracers.Color2, 0.5)
                                    v325.tracer.Thickness = _G.Config.Tracers.Thickness
                                else
                                    v325.tracer.Visible = false
                                end

                                if _G.Config.Chams.Enable then
                                    if not v325.cham then
                                        v325.cham = Instance.new("Highlight")
                                        v325.cham.Parent = Character
                                        v325.cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    end

                                    v325.cham.Enabled = true
                                    v325.cham.FillColor = _G.Config.Chams.Color
                                    v325.cham.OutlineColor = _G.Config.Chams.Color2
                                    v325.cham.FillTransparency = _G.Config.Chams.Transparency
                                    v325.cham.OutlineTransparency = math.clamp(_G.Config.Chams.Transparency, 0, 1)
                                elseif v325.cham then
                                    v325.cham.Enabled = false
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

for _, player in ipairs(t1.value2:GetPlayers()) do
    if player ~= t1.value7 then
        t1.value37(player)
    end
end
t1.value2.PlayerAdded:Connect(function(player)
    if player ~= t1.value7 then
        t1.value37(player)
    end
end)
t1.value2.PlayerRemoving:Connect(function(player)
    if not t1.value28[player] then
        return
    end

    local v310 = t1.value28[player]

    v310.box.square:Remove()
    v310.box.outline:Remove()
    v310.box.inline:Remove()
    v310.bars.hpOutline:Remove()

    for _, v in ipairs(v310.bars.hpBars) do
        v:Remove()
    end

    for i = 1, 15 do
        v310.skeleton.lines[i]:Remove()
        v310.skeleton.outlines[i]:Remove()
    end

    v310.tracer:Remove()
    v310.nameLabel:Remove()
    v310.distLabel:Remove()
    v310.weaponLabel:Remove()
    v310.filled:Destroy()
    v310.glow:Destroy()
    t1.value28[player] = nil
end)
print("[ESP] Loaded!")
t1.value41 = {
	enabled = false,
	current = "Default",
	disabledElements = {}
}
local t10 = {
	SkyboxBk = "rbxassetid://91458024",
	SkyboxDn = "rbxassetid://91457980",
	SkyboxFt = "rbxassetid://91458024",
	SkyboxLf = "rbxassetid://91458024",
	SkyboxRt = "rbxassetid://91458024",
	SkyboxUp = "rbxassetid://91458002"
}
local t11 = {
	SkyboxBk = "rbxassetid://218955819",
	SkyboxDn = "rbxassetid://218953419",
	SkyboxFt = "rbxassetid://218954524",
	SkyboxLf = "rbxassetid://218958493",
	SkyboxRt = "rbxassetid://218957134",
	SkyboxUp = "rbxassetid://218950090"
}
local t12 = {
	SkyboxBk = "rbxassetid://5752463190",
	SkyboxDn = "rbxassetid://5752463190",
	SkyboxFt = "rbxassetid://5752463190",
	SkyboxLf = "rbxassetid://5752463190",
	SkyboxRt = "rbxassetid://5752463190",
	SkyboxUp = "rbxassetid://5752463190"
}
local t13 = {
	SkyboxBk = "rbxassetid://159454299",
	SkyboxDn = "rbxassetid://159454296",
	SkyboxFt = "rbxassetid://159454293",
	SkyboxLf = "rbxassetid://159454286",
	SkyboxRt = "rbxassetid://159454300",
	SkyboxUp = "rbxassetid://159454288"
}
local t14 = {
	SkyboxBk = "rbxassetid://1417494030",
	SkyboxDn = "rbxassetid://1417494146",
	SkyboxFt = "rbxassetid://1417494253",
	SkyboxLf = "rbxassetid://1417494402",
	SkyboxRt = "rbxassetid://1417494499",
	SkyboxUp = "rbxassetid://1417494643"
}
local t15 = {
	SkyboxBk = "rbxassetid://570557514",
	SkyboxDn = "rbxassetid://570557775",
	SkyboxFt = "rbxassetid://570557559",
	SkyboxLf = "rbxassetid://570557620",
	SkyboxRt = "rbxassetid://570557672",
	SkyboxUp = "rbxassetid://570557727"
}
local t16 = {
	SkyboxBk = "rbxassetid://264908339",
	SkyboxDn = "rbxassetid://264907909",
	SkyboxFt = "rbxassetid://264909420",
	SkyboxLf = "rbxassetid://264909758",
	SkyboxRt = "rbxassetid://264908886",
	SkyboxUp = "rbxassetid://264907379"
}
local t17 = {
	SkyboxBk = "rbxassetid://7245418472",
	SkyboxDn = "rbxassetid://7245418472",
	SkyboxFt = "rbxassetid://7245418472",
	SkyboxLf = "rbxassetid://7245418472",
	SkyboxRt = "rbxassetid://7245418472",
	SkyboxUp = "rbxassetid://7245418472"
}
local t18 = {
	SkyboxBk = "rbxassetid://1876545003",
	SkyboxDn = "rbxassetid://1876544331",
	SkyboxFt = "rbxassetid://1876542941",
	SkyboxLf = "rbxassetid://1876543392",
	SkyboxRt = "rbxassetid://1876543764",
	SkyboxUp = "rbxassetid://1876544642"
}
local t19 = {
	SkyboxBk = "rbxassetid://5084575798",
	SkyboxDn = "rbxassetid://5084575916",
	SkyboxFt = "rbxassetid://5103949679",
	SkyboxLf = "rbxassetid://5103948542",
	SkyboxRt = "rbxassetid://5103948784",
	SkyboxUp = "rbxassetid://5084576400"
}
local t20 = {
	SkyboxBk = "rbxassetid://401664839",
	SkyboxDn = "rbxassetid://401664862",
	SkyboxFt = "rbxassetid://401664960",
	SkyboxLf = "rbxassetid://401664881",
	SkyboxRt = "rbxassetid://401664901",
	SkyboxUp = "rbxassetid://401664936"
}
local t21 = {
	SkyboxBk = "rbxassetid://149397684",
	SkyboxDn = "rbxassetid://149397686",
	SkyboxFt = "rbxassetid://149397688",
	SkyboxLf = "rbxassetid://149397692",
	SkyboxRt = "rbxassetid://149397697",
	SkyboxUp = "rbxassetid://149397702"
}
local t22 = {
	SkyboxBk = "rbxassetid://12063984",
	SkyboxDn = "rbxassetid://12064107",
	SkyboxFt = "rbxassetid://12064152",
	SkyboxLf = "rbxassetid://12064121",
	SkyboxRt = "rbxassetid://12064115",
	SkyboxUp = "rbxassetid://12064131"
}
local t23 = {
	SkyboxBk = "rbxassetid://144933338",
	SkyboxDn = "rbxassetid://144931530",
	SkyboxFt = "rbxassetid://144933262",
	SkyboxLf = "rbxassetid://144933244",
	SkyboxRt = "rbxassetid://144933299",
	SkyboxUp = "rbxassetid://144931564"
}
local t24 = {
	SkyboxBk = "rbxassetid://169210090",
	SkyboxDn = "rbxassetid://169210108",
	SkyboxFt = "rbxassetid://169210121",
	SkyboxLf = "rbxassetid://169210133",
	SkyboxRt = "rbxassetid://169210143",
	SkyboxUp = "rbxassetid://169210149"
}
local t25 = {
	SkyboxBk = "rbxassetid://5346760450",
	SkyboxDn = "rbxassetid://5346760689",
	SkyboxFt = "rbxassetid://5346760919",
	SkyboxLf = "rbxassetid://5346761102",
	SkyboxRt = "rbxassetid://5346761335",
	SkyboxUp = "rbxassetid://5346761509"
}
local t26 = {
	SkyboxBk = "rbxassetid://129876530632297",
	SkyboxDn = "rbxassetid://108406529909981",
	SkyboxFt = "rbxassetid://104400530594543",
	SkyboxLf = "rbxassetid://73372229972523",
	SkyboxRt = "rbxassetid://87408857415924",
	SkyboxUp = "rbxassetid://13781740568136"
}
local t27 = {
	SkyboxBk = "rbxassetid://214399891",
	SkyboxDn = "rbxassetid://214399887",
	SkyboxFt = "rbxassetid://214399894",
	SkyboxLf = "rbxassetid://214405668",
	SkyboxRt = "rbxassetid://214399899",
	SkyboxUp = "rbxassetid://214399889"
}
local t28 = {
	SkyboxBk = "rbxassetid://15962101128",
	SkyboxDn = "rbxassetid://15970246218",
	SkyboxFt = "rbxassetid://15962101128",
	SkyboxLf = "rbxassetid://15962101128",
	SkyboxRt = "rbxassetid://15962101128",
	SkyboxUp = "rbxassetid://15962901054"
}
local t29 = {
	SkyboxBk = "rbxassetid://12474836637",
	SkyboxDn = "rbxassetid://12474837052",
	SkyboxFt = "rbxassetid://12474836748",
	SkyboxLf = "rbxassetid://12474836935",
	SkyboxRt = "rbxassetid://12474836446",
	SkyboxUp = "rbxassetid://12474835757"
}
local t30 = {
	SkyboxBk = "rbxassetid://252760981",
	SkyboxDn = "rbxassetid://252763035",
	SkyboxFt = "rbxassetid://252761439",
	SkyboxLf = "rbxassetid://252760980",
	SkyboxRt = "rbxassetid://252760986",
	SkyboxUp = "rbxassetid://252762652"
}
local t31 = {
	SkyboxBk = "rbxassetid://340908398",
	SkyboxDn = "rbxassetid://340908450",
	SkyboxFt = "rbxassetid://340908468",
	SkyboxLf = "rbxassetid://340908504",
	SkyboxRt = "rbxassetid://340908530",
	SkyboxUp = "rbxassetid://340908586"
}
local t32 = {
	SkyboxBk = "rbxassetid://402229526",
	SkyboxDn = "rbxassetid://402229596",
	SkyboxFt = "rbxassetid://402229293",
	SkyboxLf = "rbxassetid://402229368",
	SkyboxRt = "rbxassetid://402229417",
	SkyboxUp = "rbxassetid://402229564"
}
t1.value42 = {
	Default = t10,
	Neptune = t11,
	["Among Us"] = t12,
	Nebula = t13,
	Vaporwave = t14,
	Clouds = t15,
	Twilight = t16,
	DaBaby = t17,
	Minecraft = t18,
	Chill = t19,
	Redshift = t20,
	["Blue Stars"] = t21,
	["Blue Aurora"] = t22,
	Realistic = t23,
	StarsShader = t24,
	Gloomy = t25,
	["Nebula Purple"] = t26,
	Jungle = t27,
	Spongebob = t28,
	["mountain scape"] = t29,
	["yellowy cloud"] = t30,
	Aurora = t31,
	["winter mountain"] = t32,
	stormy = {
		SkyboxBk = "rbxassetid://255027929",
		SkyboxDn = "rbxassetid://255027967",
		SkyboxFt = "rbxassetid://255027923",
		SkyboxLf = "rbxassetid://255027938",
		SkyboxRt = "rbxassetid://255027946",
		SkyboxUp = "rbxassetid://255027960"
	}
}
t1.value43 = nil
t1.value44 = nil
t1.value44 = nil
function t1.value45()
    if t1.value44 then
        t1.value44:Disconnect()
        t1.value44 = nil
    end

    if t1.value43 then
        t1.value43:Destroy()
        t1.value43 = nil
    end

    if not t1.value41.enabled then
        return
    end

    t1.value43 = Instance.new("Sky")
    t1.value43.Name = "CustomSkybox"
    t1.value43.Parent = t1.value5

    local v369 = t1.value42[t1.value41.current]

    if not v369 then
        v369 = t1.value42.Default
    end

    t1.value43.SkyboxBk = v369.SkyboxBk
    t1.value43.SkyboxDn = v369.SkyboxDn
    t1.value43.SkyboxFt = v369.SkyboxFt
    t1.value43.SkyboxLf = v369.SkyboxLf
    t1.value43.SkyboxRt = v369.SkyboxRt
    t1.value43.SkyboxUp = v369.SkyboxUp

    local function v370(p42)
        for _, v in ipairs(t1.value41.disabledElements) do
            if v == p42 then
                return true
            end
        end

        return false
    end

    t1.value43.SunAngularSize = not v370("Sun") and 20 or 0
    t1.value43.MoonAngularSize = not v370("Moon") and 11 or 0
    t1.value43.StarCount = not v370("Stars") and 3000 or 0
    t1.value44 = t1.value1.RenderStepped:Connect(function()
        if not t1.value41.enabled then
            return
        end

        for _, child in ipairs(t1.value5:GetChildren()) do
            local v538 = child:IsA("Sky")

            if v538 then
                v538 = child ~= t1.value43
            end

            if v538 then
                child:Destroy()
            end
        end
    end)
end
getgenv().SkyChanger = {
	Enable = function()
    t1.value41.enabled = true
    t1.value45()
end,
	Disable = function()
    t1.value41.enabled = false
    t1.value45()
end,
	SetSkybox = function(p43)
    if t1.value42[p43] then
        t1.value41.current = p43
        t1.value45()
    end
end,
	ToggleElement = function(p44)
    for i, v in ipairs(t1.value41.disabledElements) do
        if v == p44 then
            table.remove(t1.value41.disabledElements, i)
            t1.value45()

            return
        end
    end

    table.insert(t1.value41.disabledElements, p44)
    t1.value45()
end,
	GetSkyboxes = function()
    return t1.value42
end,
	Config = t1.value41
}
print("[SkyChanger] Loaded!")

local color3_27 = Color3.fromRGB(255, 255, 255)

t1.value46 = {
	chams = false,
	transparency = 0,
	material = "ForceField",
	texture = "",
	wireframe = false,
	offset = false,
	x_offset = 0,
	y_offset = 0,
	z_offset = 0,
	override_fps = false,
	fps_multi = 60,
	appearance = false,
	color = color3_27,
	appearance_material = "Metal",
	appearance_transparency = 0,
	no_textures = false,
	no_clothes = false,
	disable = {}
}
local Brick = Enum.Material.Brick
local Concrete = Enum.Material.Concrete
local CorrodedMetal = Enum.Material.CorrodedMetal
local DiamondPlate = Enum.Material.DiamondPlate
local Foil = Enum.Material.Foil
local ForceField = Enum.Material.ForceField
local Glass = Enum.Material.Glass
local Granite = Enum.Material.Granite
local Grass = Enum.Material.Grass
local Ice = Enum.Material.Ice
local Marble = Enum.Material.Marble
local Metal = Enum.Material.Metal
local Neon = Enum.Material.Neon
local Pebble = Enum.Material.Pebble
local Plastic = Enum.Material.Plastic
local Sand = Enum.Material.Sand
local Slate = Enum.Material.Slate
local SmoothPlastic = Enum.Material.SmoothPlastic
local Wood = Enum.Material.Wood
t1.value47 = {
	Brick = Brick,
	Concrete = Concrete,
	CorrodedMetal = CorrodedMetal,
	DiamondPlate = DiamondPlate,
	Foil = Foil,
	ForceField = ForceField,
	Glass = Glass,
	Granite = Granite,
	Grass = Grass,
	Ice = Ice,
	Marble = Marble,
	Metal = Metal,
	Neon = Neon,
	Pebble = Pebble,
	Plastic = Plastic,
	Sand = Sand,
	Slate = Slate,
	SmoothPlastic = SmoothPlastic,
	Wood = Wood
}
t1.value48 = {
	parts = {},
	connections = {},
	wireframeCache = {},
	appearanceCache = {},
	last_x = nil,
	last_y = nil,
	last_z = nil,
	_offset = nil,
	_offset_inv = nil,
	vm_model = nil
}
t1.value49 = Instance.new("ViewportFrame")
t1.value49.Name = "ViewmodelChamsViewport"
t1.value49.Size = UDim2.fromScale(1, 1)
t1.value49.BackgroundTransparency = 1
t1.value49.Parent = game.CoreGui
local function v97()
    for _, v in ipairs(t1.value48.connections) do
        v:Disconnect()
    end
    table.clear(t1.value48.connections)
    for v385, v386 in pairs(t1.value48.parts) do

        if v386.glow then
            v386.glow:Destroy()
        end

        t1.value48.parts[v385] = nil
    end
    for _, v in pairs(t1.value48.wireframeCache) do
        if v then
            v:Destroy()
        end
    end
    table.clear(t1.value48.wireframeCache)
    table.clear(t1.value48.appearanceCache)
    t1.value48.vm_model = nil
end
function t1.value50(p45)
    if not p45 then
        return
    end

    local function v376(p46)
        if t1.value48.parts[p46] then
            return
        end

        local clone = p46:Clone()
        local GetDescendants = clone.GetDescendants

        for _, v in ipairs(GetDescendants(clone)) do
            local v544 = v:IsA("Script")

            if not v544 then
                v544 = v:IsA("LocalScript")

                if not v544 then
                    v544 = v:IsA("Animator")

                    if not v544 then
                        v544 = v:IsA("Motor6D")

                        if not v544 then
                            v544 = v:IsA("Weld")

                            if not v544 then
                                v544 = v:IsA("WeldConstraint")

                                if not v544 then
                                    v544 = v:IsA("Attachment")

                                    if not v544 then
                                        v544 = v:IsA("Decal")

                                        if not v544 then
                                            v544 = v:IsA("Texture")

                                            if not v544 then
                                                v544 = v:IsA("SurfaceAppearance")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if v544 then
                v:Destroy()
            end
        end

        local SpecialMesh = clone:FindFirstChildOfClass("SpecialMesh")

        if clone:IsA("MeshPart") then
            clone.TextureID = ""
            clone.MaterialVariant = ""
        end

        if SpecialMesh then
            SpecialMesh.TextureId = ""
        end

        clone.Name = ""
        clone.Anchored = true
        clone.CanCollide = false
        clone.CanQuery = false
        clone.CanTouch = false
        clone.CastShadow = false
        clone.Color = t1.value46.color

        local v546 = t1.value47[t1.value46.material]

        if not v546 then
            v546 = Enum.Material.ForceField
        end

        clone.Material = v546
        clone.Transparency = t1.value46.transparency
        clone.Reflectance = 0

        local texture = t1.value46.texture

        if texture then
            texture = t1.value46.texture ~= ""
        end

        if texture then
            local v548 = "rbxassetid://" .. tostring(t1.value46.texture)

            if clone:IsA("MeshPart") then
                clone.TextureID = v548
            elseif SpecialMesh then
                SpecialMesh.TextureId = v548
            end
        end

        clone.Parent = t1.value49
        t1.value48.parts[p46] = {
			glow = clone,
			mesh = SpecialMesh
		}
        table.insert(t1.value48.connections, p46.Destroying:Connect(function()
            local v557 = t1.value48.parts[p46]

            if v557 then
                v557.glow:Destroy()
                t1.value48.parts[p46] = nil
            end
        end))
        table.insert(t1.value48.connections, p46.AncestryChanged:Connect(function(_, parent)
            if not parent then
                local v560 = t1.value48.parts[p46]

                if v560 then
                    v560.glow:Destroy()
                    t1.value48.parts[p46] = nil
                end
            end
        end))
    end

    local GetDescendants = p45.GetDescendants

    for _, v in ipairs(GetDescendants(p45)) do
        local v380 = v:IsA("BasePart")

        if v380 then
            v380 = not string.find(v.Name, "HumanoidRootPart")

            if v380 then
                v380 = not string.find(v.Name, "Camera")

                if v380 then
                    v380 = not string.find(v.Name, "Primary")

                    if v380 then
                        v380 = v.Name ~= "LeftItem"

                        if v380 then
                            v380 = v.Name ~= "RightItem"
                        end
                    end
                end
            end
        end

        if v380 then
            v376(v)
        end
    end

    table.insert(t1.value48.connections, p45.DescendantAdded:Connect(function(descendant)
        local v550 = descendant:IsA("BasePart")

        if v550 then
            v550 = not string.find(descendant.Name, "HumanoidRootPart")

            if v550 then
                v550 = not string.find(descendant.Name, "Camera")

                if v550 then
                    v550 = not string.find(descendant.Name, "Primary")

                    if v550 then
                        v550 = descendant.Name ~= "LeftItem"

                        if v550 then
                            v550 = descendant.Name ~= "RightItem"
                        end
                    end
                end
            end
        end

        if v550 then
            v376(descendant)
        end
    end))
end
function t1.value51()
    for _, v in pairs(t1.value48.parts) do
        local glow = v.glow

        if glow then
            glow.Transparency = t1.value46.transparency
            glow.Color = t1.value46.color

            local v392 = t1.value47[t1.value46.material]

            if not v392 then
                v392 = Enum.Material.ForceField
            end

            glow.Material = v392

            if glow:IsA("MeshPart") then
                local texture = t1.value46.texture

                if texture then
                    texture = t1.value46.texture ~= ""
                end

                if texture then
                    glow.TextureID = "rbxassetid://" .. t1.value46.texture
                else
                    glow.TextureID = ""
                end
            elseif v.mesh then
                local texture = t1.value46.texture

                if texture then
                    texture = t1.value46.texture ~= ""
                end

                if texture then
                    v.mesh.TextureId = "rbxassetid://" .. t1.value46.texture
                else
                    v.mesh.TextureId = ""
                end
            end
        end
    end
end
t1.value1.RenderStepped:Connect(function()
    local v395 = not t1.value46.chams

    if not v395 then
        v395 = not next(t1.value48.parts)
    end

    if v395 then
        return
    end

    for k, v in pairs(t1.value48.parts) do
        local v398 = k

        if v398.Parent and v.glow then
            v.glow.CFrame = v398.CFrame
            v.glow.Size = v398.Size
        end
    end
end)
task.spawn(function()
    task.wait(3)
    pcall(function()
        local ClientViewModel = t1.value7.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")

        if not ClientViewModel then
            return
        end

        local lib = require(ClientViewModel)
        local new = lib.new

        function lib.new(p48, p49)
            local ClientFighter = p49.ClientFighter

            if ClientFighter then
                ClientFighter = p49.ClientFighter.Player
            end

            local v564 = new(p48, p49)

            if ClientFighter == t1.value7 then
                task.defer(function()
                    if v564.Model then
                        v97()

                        if t1.value46.chams then
                            t1.value50(v564.Model)
                            t1.value48.vm_model = v564.Model
                        end
                    end
                end)
            end

            return v564
        end
    end)
end)
task.spawn(function()
    task.wait(3)
    pcall(function()
        local ClientViewModel = t1.value7.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")

        if not ClientViewModel then
            return
        end

        local lib = require(ClientViewModel)

        if lib.Update then
            local Update = lib.Update

            function lib.Update(p50, ...)
                if not p50.ClientItem.ClientFighter.IsLocalPlayer or not p50:IsEquipped() then
                    return Update(p50, ...)
                end
                local t33 = {}
                if t1.value46.override_fps then
                    t33.Info = p50.Info
                    p50.Info.FramesPerSecond = t1.value46.fps_multi
                end
                if t1.value46.offset then
                    local v567 = t1.value48.last_x ~= t1.value46.x_offset

                    if not v567 then
                        v567 = t1.value48.last_y ~= t1.value46.y_offset

                        if not v567 then
                            v567 = t1.value48.last_z ~= t1.value46.z_offset
                        end
                    end

                    if v567 then
                        t1.value48.last_x = t1.value46.x_offset
                        t1.value48.last_y = t1.value46.y_offset
                        t1.value48.last_z = t1.value46.z_offset
                        t1.value48._offset = CFrame.new(t1.value46.x_offset, t1.value46.y_offset, t1.value46.z_offset)
                        t1.value48._offset_inv = t1.value48._offset:Inverse()
                    end

                    p50._root_part_offset_override = t1.value48._offset
                    p50._root_part_offset_override_inverse = t1.value48._offset_inv
                end
                local descendants = p50.Model:GetDescendants()
                local v569
                while true do
                    local v570

                    v569, v570 = descendants(nil, v569)

                    if not v569 then
                        break
                    end

                    local v571 = v570.Name == "ShirtTexture"

                    if not v571 then
                        v571 = v570:IsA("Texture")

                        if not v571 then
                            v571 = v570:IsA("Decal")
                        end
                    end

                    if v571 then
                        local v572 = t1.value48.appearanceCache[v570]

                        if not v572 then
                            v572 = {
								Parent = v570.Parent
							}
                            t1.value48.appearanceCache[v570] = v572
                        end

                        local v573 = v570.Name == "ShirtTexture"

                        if v573 then
                            v573 = t1.value46.no_clothes
                        end

                        if not v573 then
                            v573 = v570:IsA("Texture") or v570:IsA("Decal")

                            if v573 then
                                v573 = t1.value46.no_textures
                            end
                        end

                        if v573 then
                            if v570.Parent then
                                v572.Parent = v570.Parent
                                v570.Parent = nil
                            end
                        else
                            local Parent = v572.Parent

                            if Parent then
                                Parent = v570.Parent ~= v572.Parent
                            end

                            if Parent then
                                v570.Parent = v572.Parent
                            end
                        end
                    else
                        local v575 = v570:IsA("BasePart")

                        if v575 then
                            v575 = not string.find(v570.Name, "HumanoidRootPart")

                            if v575 then
                                v575 = not string.find(v570.Name, "Camera")

                                if v575 then
                                    v575 = not string.find(v570.Name, "Primary")

                                    if v575 then
                                        v575 = v570.Name ~= "LeftItem"

                                        if v575 then
                                            v575 = v570.Name ~= "RightItem"
                                        end
                                    end
                                end
                            end
                        end

                        if v575 then
                            local v576 = t1.value48.appearanceCache[v570]

                            if not v576 then
                                local Color = v570.Color
                                local Material = v570.Material

                                v576 = {
									Color = Color,
									Material = Material
								}
                                t1.value48.appearanceCache[v570] = v576
                            end

                            local color = t1.value46.color
                            local v580 = t1.value47[t1.value46.appearance_material]

                            if not v580 then
                                v580 = Enum.Material.Metal
                            end

                            local appearance_transparency = t1.value46.appearance_transparency

                            if t1.value46.appearance then
                                if color ~= v570.Color then
                                    v570.Color = color
                                end

                                if v580 ~= v570.Material then
                                    v570.Material = v580
                                end

                                if appearance_transparency ~= v570.LocalTransparencyModifier then
                                    v570.LocalTransparencyModifier = appearance_transparency
                                end
                            else
                                if v570.Color ~= v576.Color then
                                    v570.Color = v576.Color
                                end

                                if v570.Material ~= v576.Material then
                                    v570.Material = v576.Material
                                end

                                if v570.LocalTransparencyModifier ~= 0 then
                                    v570.LocalTransparencyModifier = 0
                                end
                            end

                            local v582 = t1.value48.wireframeCache[v570]

                            if not v582 then
                                v582 = Instance.new("WireframeHandleAdornment")
                                v582.Adornee = v570
                                v582.AlwaysOnTop = true
                                v582.ZIndex = 10
                                v582.Transparency = 0
                                v582.Parent = workspace.CurrentCamera
                                t1.value48.wireframeCache[v570] = v582
                            end

                            if t1.value46.wireframe then
                                if not v582.Visible then
                                    v582.Visible = true
                                end

                                if color ~= v582.Color3 then
                                    v582.Color3 = color
                                end
                            elseif v582.Visible then
                                v582.Visible = false
                            end
                        end
                    end
                end
                local disable = t1.value46.disable
                if table.find(disable, "sway") then
                    t33._sway_spring = p50._sway_spring
                    p50._sway_spring.Value = Vector2.zero
                end
                if table.find(disable, "bobbing") then
                    t33._bobbing_value_spring = p50._bobbing_value_spring
                    p50._bobbing_value_spring.Target = Vector2.zero
                    p50._bobbing_value_spring.Value = Vector2.zero
                end
                if table.find(disable, "tilt") then
                    t33._tilt_spring = p50._tilt_spring
                    p50._tilt_spring.Target = Vector2.zero
                    p50._tilt_spring.Value = Vector2.zero
                end
                if table.find(disable, "equip animation") then
                    t33._equip_spring = p50._equip_spring
                    p50._equip_spring.Value = 0
                end
                if table.find(disable, "slide animation") then
                    t33._sliding_spring = p50._sliding_spring
                    p50._sliding_spring.Target = 0
                    p50._sliding_spring.Value = 0
                end
                if table.find(disable, "sprint animation") then
                    t33._sprinting_spring = p50._sprinting_spring
                    p50._sprinting_spring.Target = 0
                    p50._sprinting_spring.Value = 0
                end
                if table.find(disable, "jump animation") then
                    t33._landing_spring = p50._landing_spring
                    p50._landing_spring.Velocity = 0
                    p50._landing_spring.Target = 0
                    p50._landing_spring.Value = 0
                    t33._jump_spring = p50._jump_spring
                    p50._jump_spring.Target = 0
                    p50._jump_spring.Value = 0
                end
                if table.find(disable, "aiming animation") then
                    t33._aim_spring = p50._aim_spring
                    p50._aim_spring.Value = p50._aim_spring.Target
                end
                if table.find(disable, "shoot animation") then
                    t33._recoil_spring = p50._recoil_spring
                    p50._recoil_spring.Target = Vector3.zero
                    p50._recoil_spring.Value = Vector3.zero
                    t33._unrecoil_spring = p50._unrecoil_spring
                    p50._unrecoil_spring.Target = Vector3.zero
                    p50._unrecoil_spring.Value = Vector3.zero
                end
                local v584 = Update(p50, ...)
                for k, v in pairs(t33) do
                    p50[k] = v
                end

                return v584
            end
        end
    end)
end)
print("[Viewmodel Chams] Loaded")

local s1 = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
t1.value52 = loadstring(game:HttpGet(s1 .. "Library.lua"))()
local v99 = loadstring(game:HttpGet(s1 .. "addons/ThemeManager.lua"))()
local v100 = loadstring(game:HttpGet(s1 .. "addons/SaveManager.lua"))()
local Options = t1.value52.Options
local _ = t1.value52.Toggles
t1.value52.ForceCheckbox = false
t1.value52.ShowToggleFrameInKeybinds = true
t1.value53 = t1.value52:CreateWindow({
	Title = "Aimbot + ESP + World",
	Footer = "version: 1.0",
	Icon = 95816097006870,
	NotifySide = "Right",
	ShowCustomCursor = true
})
local v103 = t1.value53:AddTab("Aimbot", "crosshair")
local v104 = t1.value53:AddTab("ESP", "eye")
local v105 = t1.value53:AddTab("World", "globe")
local v106 = t1.value53:AddTab("UI Settings", "settings")
local t34 = {
	Aimbot = v103,
	ESP = v104,
	World = v105,
	["UI Settings"] = v106
}
local Aimbot = t34.Aimbot
local v109 = Aimbot:AddLeftGroupbox("Main", "crosshair")

v109:AddToggle("AimbotEnabled", {
	Text = "Enabled",
	Tooltip = "Master toggle for aimbot",
	Default = false,
	Callback = function(p51)
    if p51 then
        getgenv().Aimbot.Enable()

        return
    end

    getgenv().Aimbot.Disable()
end
})
v109:AddLabel("Keybind"):AddKeyPicker("AimbotKey", {
	Default = "MB2",
	SyncToggleState = false,
	Mode = "Toggle",
	Text = "Toggle Aimbot",
	NoUI = false,
	Callback = function(_)
    getgenv().Aimbot.Toggle()
end
})
v109:AddToggle("ShowFOV", {
	Text = "Show FOV Circle",
	Tooltip = "Display the FOV circle",
	Default = false,
	Callback = function(p53)
    if p53 then
        getgenv().Aimbot.ShowFOV()

        return
    end

    getgenv().Aimbot.HideFOV()
end
})
v109:AddToggle("FollowMuzzle", {
	Text = "Follow Muzzle",
	Tooltip = "Aim from weapon muzzle instead of screen center",
	Default = false,
	Callback = function(p54)
    getgenv().Aimbot.SetFollowMuzzle(p54)
end
})
local v110 = Aimbot:AddRightGroupbox("Targeting", "target")

v110:AddDropdown("TargetPart", {
	Values = {
		"Head",
		"HumanoidRootPart",
		"Torso",
		"UpperTorso",
		"LowerTorso",
		"Closest",
		"Random"
	},
	Default = "Head",
	Text = "Target Part",
	Tooltip = "Which body part to aim at",
	Callback = function(p55)
    getgenv().Aimbot.SetTargetPart(p55)
end
})
v110:AddSlider("FOVRadius", {
	Text = "FOV Radius",
	Default = 500,
	Min = 50,
	Max = 1000,
	Rounding = 0,
	Suffix = "px",
	Callback = function(p56)
    getgenv().Aimbot.SetFOV(p56)
end
})
v110:AddToggle("TeamCheck", {
	Text = "Team Check",
	Default = true,
	Callback = function(p57)
    getgenv().Aimbot.SetTeamCheck(p57)
end
})
v110:AddToggle("AliveCheck", {
	Text = "Alive Check",
	Default = true,
	Callback = function(p58)
    getgenv().Aimbot.SetAliveCheck(p58)
end
})
v110:AddToggle("WallCheck", {
	Text = "Wall Check",
	Default = false,
	Callback = function(p59)
    getgenv().Aimbot.SetWallCheck(p59)
end
})
local v111 = Aimbot:AddLeftGroupbox("Aiming", "sliders")

v111:AddSlider("Smoothness", {
	Text = "Smoothness",
	Default = 2,
	Min = 0.1,
	Max = 10,
	Rounding = 1,
	Suffix = "",
	Callback = function(p60)
    getgenv().Aimbot.SetSmoothness(p60)
end
})
v111:AddDropdown("AimCurve", {
	Values = {
		"Linear",
		"Expo",
		"EaseIn",
		"EaseOut",
		"EaseInOut",
		"Cubic",
		"Instant"
	},
	Default = "Linear",
	Text = "Aim Curve",
	Tooltip = "How the aim movement interpolates",
	Callback = function(p61)
    getgenv().Aimbot.SetAimCurve(p61)
end
})
local v112 = Aimbot:AddRightGroupbox("FOV Circle", "circle")

v112:AddToggle("FOVFilled", {
	Text = "Filled",
	Default = false,
	Callback = function(p62)
    getgenv().Aimbot.SetFOVFilled(p62)
end
})
v112:AddLabel("Outline Color"):AddColorPicker("OutlineColor1", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Outline Color 1",
	Callback = function(p63)
    local OutlineColor2 = getgenv().Aimbot.FOVConfig.OutlineColor2

    getgenv().Aimbot.SetFOVOutlineColors(p63, OutlineColor2)
end
})
v112:AddLabel("Outline Color 2"):AddColorPicker("OutlineColor2", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Outline Color 2",
	Callback = function(p64)
    local OutlineColor1 = getgenv().Aimbot.FOVConfig.OutlineColor1

    getgenv().Aimbot.SetFOVOutlineColors(OutlineColor1, p64)
end
})
v112:AddLabel("Fill Color 1"):AddColorPicker("FillColor1", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Fill Color 1",
	Callback = function(p65)
    local FilledColor2 = getgenv().Aimbot.FOVConfig.FilledColor2

    getgenv().Aimbot.SetFOVFillColors(p65, FilledColor2)
end
})
v112:AddLabel("Fill Color 2"):AddColorPicker("FillColor2", {
	Default = Color3.fromRGB(0, 0, 0),
	Title = "Fill Color 2",
	Callback = function(p66)
    local FilledColor1 = getgenv().Aimbot.FOVConfig.FilledColor1

    getgenv().Aimbot.SetFOVFillColors(FilledColor1, p66)
end
})
v112:AddSlider("OutlineThickness", {
	Text = "Outline Thickness",
	Default = 1.5,
	Min = 0.5,
	Max = 5,
	Rounding = 1,
	Callback = function(p67)
    getgenv().Aimbot.SetFOVThickness(p67)
end
})
v112:AddToggle("FOVSpin", {
	Text = "Spin",
	Default = false,
	Callback = function(p68)
    getgenv().Aimbot.SetFOVSpin(p68)
end
})
v112:AddSlider("SpinSpeed", {
	Text = "Spin Speed",
	Default = 1,
	Min = 0.1,
	Max = 10,
	Rounding = 1,
	Callback = function(p69)
    getgenv().Aimbot.SetFOVSpinSpeed(p69)
end
})
v112:AddToggle("FilledAnimated", {
	Text = "Filled Animated",
	Default = false,
	Callback = function(p70)
    getgenv().Aimbot.FOVConfig.FilledAnimated = p70
end
})
v112:AddSlider("FilledSpeed", {
	Text = "Fill Anim Speed",
	Default = 1,
	Min = 0.1,
	Max = 10,
	Rounding = 1,
	Callback = function(p71)
    getgenv().Aimbot.FOVConfig.FilledSpeed = p71
end
})
local ESP = t34.ESP
ESP:AddLeftGroupbox("ESP Master", "eye"):AddToggle("ESPMasterEnabled", {
	Text = "Enabled",
	Tooltip = "Master toggle for ESP",
	Default = false,
	Callback = function(p72)
    _G.Config.Box.MasterEnabled = p72
end
})
local v114 = ESP:AddRightGroupbox("Box", "box")

v114:AddToggle("ESPBoxEnable", {
	Text = "Box Enabled",
	Default = false,
	Callback = function(p73)
    _G.Config.Box.Enable = p73
end
})
v114:AddLabel("Outline Color 1"):AddColorPicker("ESPBoxOutlineColor1", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Outline Color 1",
	Callback = function(p74)
    _G.Config.Box.OutlineColor = p74
end
})
v114:AddLabel("Outline Color 2"):AddColorPicker("ESPBoxOutlineColor2", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Outline Color 2",
	Callback = function(p75)
    _G.Config.Box.OutlineColor2 = p75
end
})
v114:AddToggle("ESPHealthbarEnable", {
	Text = "Healthbar",
	Default = false,
	Callback = function(p76)
    _G.Config.Box.Healthbar.Enable = p76
end
})
v114:AddSlider("ESPHealthbarThickness", {
	Text = "Healthbar Thickness",
	Default = 4,
	Min = 1,
	Max = 10,
	Rounding = 0,
	Callback = function(p77)
    _G.Config.Box.Healthbar.Thickness = p77
end
})
v114:AddLabel("Health Color 1"):AddColorPicker("ESPHealthColor1", {
	Default = Color3.fromRGB(0, 255, 0),
	Title = "Health Color 1 (High)",
	Callback = function(p78)
    _G.Config.Box.HealthLerpColors.Color1 = p78
end
})
v114:AddLabel("Health Color 2"):AddColorPicker("ESPHealthColor2", {
	Default = Color3.fromRGB(255, 255, 0),
	Title = "Health Color 2 (Mid)",
	Callback = function(p79)
    _G.Config.Box.HealthLerpColors.Color2 = p79
end
})
v114:AddLabel("Health Color 3"):AddColorPicker("ESPHealthColor3", {
	Default = Color3.fromRGB(255, 0, 0),
	Title = "Health Color 3 (Low)",
	Callback = function(p80)
    _G.Config.Box.HealthLerpColors.Color3 = p80
end
})
local v115 = ESP:AddLeftGroupbox("Filled", "square")

v115:AddToggle("ESPFilledEnable", {
	Text = "Filled",
	Default = false,
	Callback = function(p81)
    _G.Config.Filled.Enable = p81
end
})
v115:AddSlider("ESPFilledTransparency", {
	Text = "Transparency",
	Default = 0.7,
	Min = 0,
	Max = 1,
	Rounding = 2,
	Callback = function(p82)
    _G.Config.Filled.Transparency = p82
end
})
v115:AddLabel("Color Start"):AddColorPicker("ESPFilledColorStart", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Fill Color Start",
	Callback = function(p83)
    _G.Config.Filled.ColorStart = p83
end
})
v115:AddLabel("Color End"):AddColorPicker("ESPFilledColorEnd", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Fill Color End",
	Callback = function(p84)
    _G.Config.Filled.ColorEnd = p84
end
})
v115:AddToggle("ESPFilledAnimated", {
	Text = "Animated",
	Default = false,
	Callback = function(p85)
    _G.Config.Filled.Animated = p85
end
})
v115:AddSlider("ESPFilledSpeed", {
	Text = "Animation Speed",
	Default = 1,
	Min = 0.1,
	Max = 10,
	Rounding = 1,
	Callback = function(p86)
    _G.Config.Filled.Speed = p86
end
})
local v116 = ESP:AddRightGroupbox("Glow", "sparkles")

v116:AddToggle("ESPGlowEnable", {
	Text = "Glow",
	Default = false,
	Callback = function(p87)
    _G.Config.Glow.Enable = p87
end
})
v116:AddSlider("ESPGlowTransparency", {
	Text = "Transparency",
	Default = 0.5,
	Min = 0,
	Max = 1,
	Rounding = 2,
	Callback = function(p88)
    _G.Config.Glow.Transparency = p88
end
})
v116:AddLabel("Color Start"):AddColorPicker("ESPGlowColorStart", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Glow Color Start",
	Callback = function(p89)
    _G.Config.Glow.ColorStart = p89
end
})
v116:AddLabel("Color End"):AddColorPicker("ESPGlowColorEnd", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Glow Color End",
	Callback = function(p90)
    _G.Config.Glow.ColorEnd = p90
end
})
local v117 = ESP:AddLeftGroupbox("Text ESP", "type")

v117:AddToggle("ESPNames", {
	Text = "Names",
	Default = false,
	Callback = function(p91)
    _G.Config.TextESP.Names = p91
end
})
v117:AddToggle("ESPDistance", {
	Text = "Distance",
	Default = false,
	Callback = function(p92)
    _G.Config.TextESP.Distance = p92
end
})
v117:AddToggle("ESPTools", {
	Text = "Tools",
	Default = false,
	Callback = function(p93)
    _G.Config.TextESP.Tools = p93
end
})
v117:AddSlider("ESPNameSize", {
	Text = "Name Size",
	Default = 8,
	Min = 5,
	Max = 20,
	Rounding = 0,
	Callback = function(p94)
    _G.Config.TextESP.NameSize = p94
end
})
v117:AddSlider("ESPDistanceSize", {
	Text = "Distance Size",
	Default = 8,
	Min = 5,
	Max = 20,
	Rounding = 0,
	Callback = function(p95)
    _G.Config.TextESP.DistanceSize = p95
end
})
v117:AddSlider("ESPToolsSize", {
	Text = "Tools Size",
	Default = 8,
	Min = 5,
	Max = 20,
	Rounding = 0,
	Callback = function(p96)
    _G.Config.TextESP.ToolsSize = p96
end
})
v117:AddLabel("Name Color 1"):AddColorPicker("ESPNameColor1", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Name Color 1",
	Callback = function(p97)
    _G.Config.TextESP.NameColor = p97
end
})
v117:AddLabel("Name Color 2"):AddColorPicker("ESPNameColor2", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Name Color 2",
	Callback = function(p98)
    _G.Config.TextESP.NameColor2 = p98
end
})
v117:AddLabel("Distance Color 1"):AddColorPicker("ESPDistanceColor1", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Distance Color 1",
	Callback = function(p99)
    _G.Config.TextESP.DistanceColor = p99
end
})
v117:AddLabel("Distance Color 2"):AddColorPicker("ESPDistanceColor2", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Distance Color 2",
	Callback = function(p100)
    _G.Config.TextESP.DistanceColor2 = p100
end
})
v117:AddLabel("Tool Color 1"):AddColorPicker("ESPToolColor1", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Tool Color 1",
	Callback = function(p101)
    _G.Config.TextESP.ToolColor = p101
end
})
v117:AddLabel("Tool Color 2"):AddColorPicker("ESPToolColor2", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Tool Color 2",
	Callback = function(p102)
    _G.Config.TextESP.ToolColor2 = p102
end
})
local v118 = ESP:AddRightGroupbox("Skeleton", "bone")

v118:AddToggle("ESPSkeletonEnable", {
	Text = "Skeleton",
	Default = false,
	Callback = function(p103)
    _G.Config.Skeleton.Enable = p103
end
})
v118:AddLabel("Color 1"):AddColorPicker("ESPSkeletonColor1", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Skeleton Color 1",
	Callback = function(p104)
    _G.Config.Skeleton.Color = p104
end
})
v118:AddLabel("Color 2"):AddColorPicker("ESPSkeletonColor2", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Skeleton Color 2",
	Callback = function(p105)
    _G.Config.Skeleton.Color2 = p105
end
})
v118:AddSlider("ESPSkeletonThickness", {
	Text = "Thickness",
	Default = 1,
	Min = 1,
	Max = 5,
	Rounding = 0,
	Callback = function(p106)
    _G.Config.Skeleton.Thickness = p106
end
})
local v119 = ESP:AddLeftGroupbox("Tracers", "trending-up")

v119:AddToggle("ESPTracersEnable", {
	Text = "Tracers",
	Default = false,
	Callback = function(p107)
    _G.Config.Tracers.Enable = p107
end
})
v119:AddToggle("ESPTracersFromBottom", {
	Text = "From Bottom",
	Default = true,
	Callback = function(p108)
    _G.Config.Tracers.FromBottom = p108
end
})
v119:AddSlider("ESPTracersThickness", {
	Text = "Thickness",
	Default = 1,
	Min = 1,
	Max = 5,
	Rounding = 0,
	Callback = function(p109)
    _G.Config.Tracers.Thickness = p109
end
})
v119:AddLabel("Color 1"):AddColorPicker("ESPTracersColor1", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Tracer Color 1",
	Callback = function(p110)
    _G.Config.Tracers.Color = p110
end
})
v119:AddLabel("Color 2"):AddColorPicker("ESPTracersColor2", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Tracer Color 2",
	Callback = function(p111)
    _G.Config.Tracers.Color2 = p111
end
})
local v120 = ESP:AddRightGroupbox("Chams", "ghost")

v120:AddToggle("ESPChamsEnable", {
	Text = "Chams",
	Default = false,
	Callback = function(p112)
    _G.Config.Chams.Enable = p112
end
})
v120:AddSlider("ESPChamsTransparency", {
	Text = "Transparency",
	Default = 0,
	Min = 0,
	Max = 1,
	Rounding = 2,
	Callback = function(p113)
    _G.Config.Chams.Transparency = p113
end
})
v120:AddLabel("Fill Color"):AddColorPicker("ESPChamsColor", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Chams Fill Color",
	Callback = function(p114)
    _G.Config.Chams.Color = p114
end
})
v120:AddLabel("Outline Color"):AddColorPicker("ESPChamsColor2", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Chams Outline Color",
	Callback = function(p115)
    _G.Config.Chams.Color2 = p115
end
})
local World = t34.World
local v122 = World:AddLeftGroupbox("Skybox Changer", "sun")

v122:AddToggle("SkyboxEnabled", {
	Text = "Enabled",
	Default = false,
	Callback = function(p116)
    if p116 then
        getgenv().SkyChanger.Enable()

        return
    end

    getgenv().SkyChanger.Disable()
end
})
v122:AddDropdown("SkyboxSelect", {
	Values = (function()
    local v469 = getgenv().SkyChanger.GetSkyboxes()
    local t35 = {}

    for k, _ in pairs(v469) do
        table.insert(t35, k)
    end

    table.sort(t35)

    return t35
end)(),
	Default = "Default",
	Text = "Skybox",
	Callback = function(p117)
    getgenv().SkyChanger.SetSkybox(p117)
end
})
local v123 = World:AddRightGroupbox("Elements", "sun")

v123:AddToggle("SkySunEnabled", {
	Text = "Sun",
	Default = true,
	Callback = function(p118)
    local v475 = false
    local v476, v477, v478 = ipairs(getgenv().SkyChanger.Config.disabledElements)
    local g480
    repeat
        local v479

        v478, v479 = v476(v477, v478)

        if not v478 then
            g480 = true
        end

        if g480 then
            break
        end
    until v479 == "Sun"
    if not g480 then
        v475 = true
    end
    if p118 then
        if v475 then
            getgenv().SkyChanger.ToggleElement("Sun")

            return
        end
    elseif not v475 then
        getgenv().SkyChanger.ToggleElement("Sun")
    end
end
})
v123:AddToggle("SkyMoonEnabled", {
	Text = "Moon",
	Default = true,
	Callback = function(p119)
    local v482 = false
    local v483, v484, v485 = ipairs(getgenv().SkyChanger.Config.disabledElements)
    local g487
    repeat
        local v486

        v485, v486 = v483(v484, v485)

        if not v485 then
            g487 = true
        end

        if g487 then
            break
        end
    until v486 == "Moon"
    if not g487 then
        v482 = true
    end
    if p119 then
        if v482 then
            getgenv().SkyChanger.ToggleElement("Moon")

            return
        end
    elseif not v482 then
        getgenv().SkyChanger.ToggleElement("Moon")
    end
end
})
v123:AddToggle("SkyStarsEnabled", {
	Text = "Stars",
	Default = true,
	Callback = function(p120)
    local v489 = false
    local v490, v491, v492 = ipairs(getgenv().SkyChanger.Config.disabledElements)
    local g494
    repeat
        local v493

        v492, v493 = v490(v491, v492)

        if not v492 then
            g494 = true
        end

        if g494 then
            break
        end
    until v493 == "Stars"
    if not g494 then
        v489 = true
    end
    if p120 then
        if v489 then
            getgenv().SkyChanger.ToggleElement("Stars")

            return
        end
    elseif not v489 then
        getgenv().SkyChanger.ToggleElement("Stars")
    end
end
})
local v124 = World:AddLeftGroupbox("Character", "user")

v124:AddToggle("VMChamsEnabled", {
	Text = "Viewmodel Chams",
	Default = false,
	Callback = function(p121)
    t1.value46.chams = p121

    if p121 then
        if t1.value48.vm_model then
            v97()
            t1.value50(t1.value48.vm_model)

            return
        end
    else
        v97()
    end
end
})
v124:AddSlider("VMChamsTransparency", {
	Text = "Transparency",
	Default = 0,
	Min = 0,
	Max = 1,
	Rounding = 2,
	Callback = function(p122)
    t1.value46.transparency = p122
    t1.value51()
end
})
v124:AddDropdown("VMChamsMaterial", {
	Values = (function()
    local t36 = {}

    for k, _ in pairs(t1.value47) do
        table.insert(t36, k)
    end

    table.sort(t36)

    return t36
end)(),
	Default = "ForceField",
	Text = "Material",
	Callback = function(p123)
    t1.value46.material = p123
    t1.value51()
end
})
v124:AddInput("VMChamsTexture", {
	Default = "",
	Numeric = true,
	Finished = true,
	Text = "Texture ID",
	Placeholder = "Enter asset ID (optional)",
	Callback = function(p124)
    t1.value46.texture = p124
    t1.value51()
end
})
v124:AddLabel("Cham Color"):AddColorPicker("VMChamsColor", {
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Viewmodel Cham Color",
	Callback = function(p125)
    t1.value46.color = p125
    t1.value51()
end
})
v124:AddToggle("VMWireframe", {
	Text = "Wireframe",
	Default = false,
	Callback = function(p126)
    t1.value46.wireframe = p126
end
})
v124:AddToggle("VMOffset", {
	Text = "Position Offset",
	Default = false,
	Callback = function(p127)
    t1.value46.offset = p127
end
})
v124:AddSlider("VMOffsetX", {
	Text = "Offset X",
	Default = 0,
	Min = -5,
	Max = 5,
	Rounding = 2,
	Callback = function(p128)
    t1.value46.x_offset = p128
end
})
v124:AddSlider("VMOffsetY", {
	Text = "Offset Y",
	Default = 0,
	Min = -5,
	Max = 5,
	Rounding = 2,
	Callback = function(p129)
    t1.value46.y_offset = p129
end
})
v124:AddSlider("VMOffsetZ", {
	Text = "Offset Z",
	Default = 0,
	Min = -5,
	Max = 5,
	Rounding = 2,
	Callback = function(p130)
    t1.value46.z_offset = p130
end
})
v124:AddToggle("VMFPSOverride", {
	Text = "FPS Override",
	Default = false,
	Callback = function(p131)
    t1.value46.override_fps = p131
end
})
v124:AddSlider("VMFPSMulti", {
	Text = "FPS",
	Default = 60,
	Min = 1,
	Max = 240,
	Rounding = 0,
	Callback = function(p132)
    t1.value46.fps_multi = p132
end
})
v124:AddToggle("VMAppearance", {
	Text = "Appearance Override",
	Default = false,
	Callback = function(p133)
    t1.value46.appearance = p133
end
})
v124:AddSlider("VMAppearanceTransparency", {
	Text = "Appearance Transparency",
	Default = 0,
	Min = 0,
	Max = 1,
	Rounding = 2,
	Callback = function(p134)
    t1.value46.appearance_transparency = p134
end
})
v124:AddDropdown("VMAppearanceMaterial", {
	Values = (function()
    local t37 = {}

    for k, _ in pairs(t1.value47) do
        table.insert(t37, k)
    end

    table.sort(t37)

    return t37
end)(),
	Default = "Metal",
	Text = "Appearance Material",
	Callback = function(p135)
    t1.value46.appearance_material = p135
end
})
v124:AddToggle("VMNoTextures", {
	Text = "No Textures",
	Default = false,
	Callback = function(p136)
    t1.value46.no_textures = p136
end
})
v124:AddToggle("VMNoClothes", {
	Text = "No Clothes",
	Default = false,
	Callback = function(p137)
    t1.value46.no_clothes = p137
end
})
v124:AddDropdown("VMDisableAnimations", {
	Values = {
		"sway",
		"bobbing",
		"tilt",
		"equip animation",
		"slide animation",
		"sprint animation",
		"jump animation",
		"aiming animation",
		"shoot animation"
	},
	Default = {},
	Multi = true,
	Text = "Disable Animations",
	Callback = function(p138)
    local t38 = {}

    for k, v in pairs(p138) do
        if v then
            table.insert(t38, k)
        end
    end

    t1.value46.disable = t38
end
})
local v125 = t34["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

v125:AddToggle("KeybindMenuOpen", {
	Default = t1.value52.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(p139)
    t1.value52.KeybindFrame.Visible = p139
end
})
local ShowCustomCursor = t1.value52.ShowCustomCursor
v125:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = ShowCustomCursor,
	Callback = function(p140)
    t1.value52.ShowCustomCursor = p140
end
})
v125:AddDropdown("NotificationSide", {
	Values = {
		"Left",
		"Right"
	},
	Default = "Right",
	Text = "Notification Side",
	Callback = function(p141)
    t1.value52:SetNotifySide(p141)
end
})
v125:AddDropdown("DPIDropdown", {
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
	Callback = function(p142)
    local num = tonumber((p142:gsub("%%", "")))

    t1.value52:SetDPIScale(num)
end
})
local CornerRadius = t1.value52.CornerRadius
v125:AddSlider("UICornerSlider", {
	Text = "Corner Radius",
	Default = CornerRadius,
	Min = 0,
	Max = 20,
	Rounding = 0,
	Callback = function(p143)
    t1.value53:SetCornerRadius(p143)
end
})
v125:AddDivider()
v125:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
	Default = "RightShift",
	NoUI = true,
	Text = "Menu keybind"
})
v125:AddButton("Unload", function()
    t1.value52:Unload()
end)
t1.value52.ToggleKeybind = Options.MenuKeybind
v99:SetLibrary(t1.value52)
v100:SetLibrary(t1.value52)
v100:IgnoreThemeSettings()
v100:SetIgnoreIndexes({ "MenuKeybind" })
v99:SetFolder("MyScriptHub")
v100:SetFolder("MyScriptHub/specific-game")
v100:SetSubFolder("specific-place")
v100:BuildConfigSection(t34["UI Settings"])
v99:ApplyToTab(t34["UI Settings"])
v100:LoadAutoloadConfig()
