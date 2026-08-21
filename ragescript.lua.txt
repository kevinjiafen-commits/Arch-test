-- This file was generated at discord.gg/syncrypt

local t1 = {}
local v2 = unpack or table.unpack
t1.value1 = game:GetService("Players")
t1.value2 = game:GetService("UserInputService")
t1.value3 = game:GetService("RunService")
t1.value4 = game:GetService("ReplicatedStorage")
t1.value5 = game:GetService("TweenService")
t1.value6 = game:GetService("Workspace")
t1.value7 = game:GetService("HttpService")
t1.value8 = t1.value1.LocalPlayer
local PlayerGui = t1.value8:WaitForChild("PlayerGui")
t1.value9 = t1.value6.CurrentCamera
t1.value10 = t1.value2.TouchEnabled and not t1.value2.KeyboardEnabled
local v4 = not t1.value2.TouchEnabled
local color3 = Color3.fromRGB(0, 150, 255)
local color3_2 = Color3.fromRGB(5, 5, 5)
local color3_3 = Color3.fromRGB(15, 15, 15)
local color3_4 = Color3.fromRGB(25, 25, 25)
local color3_5 = Color3.fromRGB(200, 200, 200)
local color3_6 = Color3.fromRGB(100, 100, 100)
local color3_7 = Color3.fromRGB(0, 150, 255)
local color3_8 = Color3.fromRGB(40, 40, 40)
local color3_9 = Color3.fromRGB(0, 150, 255)
local color3_10 = Color3.fromRGB(30, 30, 30)
local color3_11 = Color3.fromRGB(0, 150, 255)
local GothamBold = Enum.Font.GothamBold
local GothamMedium = Enum.Font.GothamMedium
local color3_12 = Color3.fromRGB(30, 180, 255)
local color3_13 = Color3.fromRGB(40, 40, 40)
local color3_14 = Color3.fromRGB(0, 100, 200)
local color3_15 = Color3.fromRGB(35, 35, 35)
local color3_16 = Color3.fromRGB(40, 40, 40)
local color3_17 = Color3.fromRGB(0, 150, 255)
t1.value11 = {
	Accent = color3,
	Background = color3_2,
	Surface = color3_3,
	SurfaceLight = color3_4,
	Text = color3_5,
	TextSecondary = color3_6,
	ToggleOn = color3_7,
	ToggleOff = color3_8,
	TabActive = color3_9,
	TabInactive = color3_10,
	Border = color3_11,
	Font = GothamBold,
	FontMedium = GothamMedium,
	HoverAccent = color3_12,
	HoverSurface = color3_13,
	ClickAccent = color3_14,
	ClickSurface = color3_15,
	DropdownHover = color3_16,
	DropdownSelected = color3_17
}
t1.value12 = {
	Ragebot = false,
	AutoShoot = false,
	AutoShootShootAttempt = 0,
	RapidFire = false,
	Fly = false,
	FlySpeed = 80,
	InfiniteJump = false,
	Noclip = false,
	ThirdPerson = false,
	ThirdPersonMode = "Third Person",
	Esp = false,
	EspBoxes = true,
	EspNames = true,
	EspHealth = true,
	EspDistance = false,
	EspHealthNumber = false,
	EspChams = false,
	AnimationEnabled = false,
	AnimationPreset = "Underground Glitch",
	AnimationSpeed = 2,
	AutoCollect = false,
	AutoQueueEnabled = false,
	AutoQueueMode = "1v1"
}
local v24 = (function()
    local ok, result = pcall(function()
        if not isfolder or not makefolder then
            return nil
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        if isfile("oishi_hub/settings.json") then
            local value7 = t1.value7
            local t2 = { readfile("oishi_hub/settings.json") }

            return value7:JSONDecode(v2(t2))
        end

        return nil
    end)

    if ok and result then
        return result
    end

    return nil
end)()
if v24 then
    for k, _ in pairs(t1.value12) do
        local v27 = k

        if v24[v27] ~= nil then
            t1.value12[v27] = v24[v27]
        end
    end
end
local function v28(p1)
    if not p1 then
        return false
    end

    local Team = t1.value8.Team
    local v66 = Team and Team.TeamColor
    local TeamID = t1.value8:GetAttribute("TeamID")
    local Team2 = p1.Team
    local v69 = Team2 and Team2.TeamColor
    local TeamID2 = p1:GetAttribute("TeamID")

    if Team and (Team2 and Team == Team2) then
        return true
    end

    if v66 and (v69 and v66 == v69) then
        return true
    end

    if TeamID and (TeamID2 and TeamID == TeamID2) then
        return true
    end

    return false
end
if PlayerGui:FindFirstChild("OishiHub") then
    PlayerGui.OishiHub:Destroy()
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OishiHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t1.value13 = if not v4 then math.min(500, t1.value9.ViewportSize.X - 20) else 400
t1.value14 = if not v4 then math.min(350, t1.value9.ViewportSize.Y * 0.4) else 400
t1.value15 = Instance.new("Frame")
t1.value15.Size = UDim2.new(0, t1.value13, 0, t1.value14)
t1.value15.Position = UDim2.new(0.5, -t1.value13 / 2, 0.5, -t1.value14 / 2)
t1.value15.BackgroundColor3 = t1.value11.Background
t1.value15.BackgroundTransparency = 1
t1.value15.BorderSizePixel = 0
t1.value15.Active = true
t1.value15.Visible = false
t1.value15.ZIndex = 10
t1.value15.Parent = ScreenGui
t1.value16 = Instance.new("UIStroke")
t1.value16.Color = t1.value11.Border
t1.value16.Thickness = 2
t1.value16.Transparency = 0
t1.value16.Parent = t1.value15
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, 0, 0, 24)
Frame.BackgroundColor3 = t1.value11.Surface
Frame.BackgroundTransparency = 0
Frame.BorderSizePixel = 0
Frame.ZIndex = 11
Frame.Parent = t1.value15
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 140, 0, 14)
TextLabel.Position = UDim2.new(0, 10, 0, 5)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "OISHI HUB V1.02"
TextLabel.Font = t1.value11.Font
TextLabel.TextSize = 10
TextLabel.TextColor3 = t1.value11.Accent
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.ZIndex = 12
TextLabel.Parent = Frame
local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0, 16, 0, 16)
TextButton.Position = UDim2.new(1, -22, 0, 4)
TextButton.BackgroundTransparency = 1
TextButton.Text = "X"
TextButton.Font = t1.value11.Font
TextButton.TextSize = 9
TextButton.TextColor3 = t1.value11.TextSecondary
TextButton.ZIndex = 12
TextButton.Parent = Frame
function t1.value17()
    t1.value15.Visible = true
    t1.value15.BackgroundTransparency = 1
    t1.value15.Position = UDim2.new(0.5, -t1.value13 / 2, 0.5, -t1.value14 / 2 + 30)
    t1.value16.Transparency = 1

    local value5 = t1.value5
    local value15 = t1.value15
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local new = UDim2.new
    local Create = value5.Create
    local v76 = new(0.5, -t1.value13 / 2, 0.5, -t1.value14 / 2)

    Create(value5, value15, tweenInfo, {
		BackgroundTransparency = 0,
		Position = v76
	}):Play()
    t1.value5:Create(t1.value16, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = 0
	}):Play()
end
function t1.value18()
    local value5 = t1.value5
    local value15 = t1.value15
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local new = UDim2.new
    local Create = value5.Create
    local v82 = new(0.5, -t1.value13 / 2, 0.5, -t1.value14 / 2 + 30)

    Create(value5, value15, tweenInfo, {
		BackgroundTransparency = 1,
		Position = v82
	}):Play()
    t1.value5:Create(t1.value16, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Transparency = 1
	}):Play()
    task.wait(0.2)
    t1.value15.Visible = false
end
TextButton.MouseButton1Click:Connect(function()
    t1.value18()

    if t1.value10 and ToggleBtn then
        ToggleBtn.Text = ">"
    end
end)
local Frame2 = Instance.new("Frame")
Frame2.Size = UDim2.new(1, 0, 0, 22)
Frame2.Position = UDim2.new(0, 0, 0, 24)
Frame2.BackgroundColor3 = t1.value11.Surface
Frame2.BackgroundTransparency = 0
Frame2.BorderSizePixel = 0
Frame2.ZIndex = 11
Frame2.Parent = t1.value15
local t3 = {
	{
		name = "Ragebot"
	},
	{
		name = "ESP"
	},
	{
		name = "Auto"
	},
	{
		name = "Misc"
	},
	{
		name = "Settings"
	}
}
t1.value19 = "Ragebot"
t1.value20 = {}
t1.value21 = {}
local Frame3 = Instance.new("Frame")
Frame3.Size = UDim2.new(1, 0, 1, -46)
Frame3.Position = UDim2.new(0, 0, 0, 46)
Frame3.BackgroundTransparency = 1
Frame3.BorderSizePixel = 0
Frame3.ClipsDescendants = true
Frame3.ZIndex = 11
Frame3.Parent = t1.value15
for v38, v39 in ipairs(t3) do

    local v40 = v39
    local TextButton2 = Instance.new("TextButton")

    TextButton2.Size = UDim2.new(0.2, -1.2, 0, 18)
    TextButton2.Position = UDim2.new((v38 - 1) * 0.2, 0.6, 0, 2)
    TextButton2.BackgroundColor3 = v40.name == t1.value19 and t1.value11.TabActive or t1.value11.TabInactive
    TextButton2.BackgroundTransparency = v40.name ~= t1.value19 and 0.5 or 0.3
    TextButton2.BorderSizePixel = 0
    TextButton2.Text = v40.name
    TextButton2.Font = t1.value11.Font
    TextButton2.TextSize = 6
    TextButton2.TextColor3 = v40.name == t1.value19 and Color3.new(1, 1, 1) or t1.value11.Text
    TextButton2.ZIndex = 12
    TextButton2.AutoButtonColor = false
    TextButton2.Parent = Frame2
    t1.value20[v40.name] = TextButton2
    TextButton2.MouseEnter:Connect(function()
        local v83 = t1.value19 == v40.name
        local value5 = t1.value5
        local v85 = TextButton2
        local tweenInfo = TweenInfo.new(0.2)
        local v87 = v83 and t1.value11.HoverAccent or t1.value11.HoverSurface
        local Create = value5.Create
        local v89 = not v83 and 0.3 or 0.2

        Create(value5, v85, tweenInfo, {
			BackgroundColor3 = v87,
			BackgroundTransparency = v89
		}):Play()
    end)
    TextButton2.MouseLeave:Connect(function()
        local v90 = t1.value19 == v40.name
        local value5 = t1.value5
        local v92 = TextButton2
        local tweenInfo = TweenInfo.new(0.2)
        local v94 = v90 and t1.value11.TabActive or t1.value11.TabInactive
        local v95 = v90 and 0.3
        local Create = value5.Create
        local v97 = v95 or 0.5

        Create(value5, v92, tweenInfo, {
			BackgroundColor3 = v94,
			BackgroundTransparency = v97
		}):Play()
    end)
    TextButton2.MouseButton1Down:Connect(function()
        t1.value5:Create(TextButton2, TweenInfo.new(0.05), {
			BackgroundColor3 = t1.value11.ClickAccent,
			BackgroundTransparency = 0.1
		}):Play()
    end)
    TextButton2.MouseButton1Up:Connect(function()
        local v98 = t1.value19 == v40.name
        local value5 = t1.value5
        local v100 = TextButton2
        local tweenInfo = TweenInfo.new(0.1)
        local v102 = v98 and t1.value11.HoverAccent or t1.value11.HoverSurface
        local v103 = v98 and 0.2
        local Create = value5.Create
        local v105 = v103 or 0.3

        Create(value5, v100, tweenInfo, {
			BackgroundColor3 = v102,
			BackgroundTransparency = v105
		}):Play()
    end)

    local Frame4 = Instance.new("Frame")

    Frame4.Size = UDim2.new(1, 0, 1, 0)
    Frame4.Position = UDim2.new(0, 0, 0, 0)
    Frame4.BackgroundTransparency = 1
    Frame4.BorderSizePixel = 0
    Frame4.Visible = v40.name == t1.value19
    Frame4.ZIndex = 11
    Frame4.Parent = Frame3

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 2
    ScrollingFrame.ScrollBarImageColor3 = t1.value11.Accent
    ScrollingFrame.ScrollBarImageTransparency = 0.5
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
    ScrollingFrame.ZIndex = 12
    ScrollingFrame.Parent = Frame4

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.Parent = ScrollingFrame

    local UIGridLayout = Instance.new("UIGridLayout")

    UIGridLayout.CellPadding = UDim2.new(0, 4, 0, 3)
    UIGridLayout.CellSize = UDim2.new(0.5, -6, 0, 32)
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.Parent = ScrollingFrame
    t1.value21[v40.name] = {
		frame = Frame4,
		scroll = ScrollingFrame,
		layout = UIGridLayout
	}
end
for k, v in pairs(t1.value20) do
    v.MouseButton1Click:Connect(function()
        if t1.value19 == k then
            return
        end
        local value19 = t1.value19
        t1.value19 = k
        for v109, v110 in pairs(t1.value20) do

            if v109 == k then
                local value5 = t1.value5
                local tweenInfo = TweenInfo.new(0.2)
                local TabActive = t1.value11.TabActive
                local new = Color3.new
                local Create = value5.Create
                local v116 = new(1, 1, 1)

                Create(value5, v110, tweenInfo, {
					BackgroundColor3 = TabActive,
					BackgroundTransparency = 0.3,
					TextColor3 = v116
				}):Play()
            else
                local value5 = t1.value5
                local tweenInfo = TweenInfo.new(0.2)
                local TabInactive = t1.value11.TabInactive
                local value11Text = t1.value11.Text

                value5:Create(v110, tweenInfo, {
					BackgroundColor3 = TabInactive,
					BackgroundTransparency = 0.5,
					TextColor3 = value11Text
				}):Play()
            end
        end
        local v121 = t1.value21[value19]
        local v122 = k
        local v123 = t1.value21[v122]
        if v121 and v123 then
            v121.frame.Visible = true
            v123.frame.Visible = false
            v123.frame.Position = UDim2.new(1, 0, 0, 0)
            t1.value5:Create(v121.frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(-1, 0, 0, 0)
			}):Play()
            task.wait(0.2)
            v121.frame.Visible = false
            v121.frame.Position = UDim2.new(0, 0, 0, 0)
            v123.frame.Visible = true
            v123.frame.Position = UDim2.new(1, 0, 0, 0)
            t1.value5:Create(v123.frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, 0, 0, 0)
			}):Play()
        end
    end)
end
local function v48(p2, p3, p4, p5)
    local v128 = t1.value21[p2]

    if not v128 then
        return
    end

    local Frame5 = Instance.new("Frame")

    Frame5.Size = UDim2.new(1, 0, 1, 0)
    Frame5.BackgroundColor3 = t1.value11.Surface
    Frame5.BackgroundTransparency = 0
    Frame5.BorderSizePixel = 0
    Frame5.ZIndex = 12
    Frame5.Parent = v128.scroll

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Size = UDim2.new(0, 80, 0, 12)
    TextLabel2.Position = UDim2.new(0, 6, 0, 4)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = p3
    TextLabel2.Font = t1.value11.FontMedium
    TextLabel2.TextSize = 9
    TextLabel2.TextColor3 = t1.value11.Text
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.ZIndex = 13
    TextLabel2.Parent = Frame5

    local TextButton3 = Instance.new("TextButton")

    TextButton3.Size = UDim2.new(0, 28, 0, 16)
    TextButton3.Position = UDim2.new(1, -34, 0, 4)
    TextButton3.BackgroundColor3 = t1.value12[p4] and t1.value11.ToggleOn or t1.value11.ToggleOff
    TextButton3.BorderSizePixel = 0
    TextButton3.Text = ""
    TextButton3.AutoButtonColor = false
    TextButton3.ZIndex = 13
    TextButton3.Parent = Frame5

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = t1.value11.Border
    UIStroke.Thickness = 1
    UIStroke.Transparency = not t1.value12[p4] and 0.8 or 0.3
    UIStroke.Parent = TextButton3

    local Frame6 = Instance.new("Frame")

    Frame6.Size = UDim2.new(0, 12, 0, 12)
    Frame6.Position = t1.value12[p4] and UDim2.new(0, 15, 0, 2) or UDim2.new(0, 1, 0, 2)
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame6.BorderSizePixel = 0
    Frame6.ZIndex = 14
    Frame6.Parent = TextButton3
    TextButton3.MouseButton1Click:Connect(function()
        local v383 = t1.value12[p4]

        t1.value12[p4] = not v383
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
        end)
        t1.value5:Create(UIStroke, TweenInfo.new(0.2), {
			Transparency = not t1.value12[p4] and 0.8 or 0.3
		}):Play()

        if t1.value12[p4] then
            t1.value5:Create(TextButton3, TweenInfo.new(0.2), {
				BackgroundColor3 = t1.value11.ToggleOn
			}):Play()
            t1.value5:Create(Frame6, TweenInfo.new(0.2), {
				Position = UDim2.new(0, 15, 0, 2)
			}):Play()
        else
            t1.value5:Create(TextButton3, TweenInfo.new(0.2), {
				BackgroundColor3 = t1.value11.ToggleOff
			}):Play()
            t1.value5:Create(Frame6, TweenInfo.new(0.2), {
				Position = UDim2.new(0, 1, 0, 2)
			}):Play()
        end

        if p5 then
            p5(t1.value12[p4])
        end
    end)

    return Frame5
end
local function v49(p6, p7, p8, p9, p10, p11, p12, p13, p14)
    local v143 = t1.value21[p6]

    if not v143 then
        return
    end

    local Frame7 = Instance.new("Frame")

    Frame7.Size = UDim2.new(1, 0, 0, 48)
    Frame7.BackgroundColor3 = t1.value11.Surface
    Frame7.BackgroundTransparency = 0
    Frame7.BorderSizePixel = 0
    Frame7.ZIndex = 12
    Frame7.Parent = v143.scroll

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Size = UDim2.new(0, 80, 0, 10)
    TextLabel3.Position = UDim2.new(0, 6, 0, 3)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = p7
    TextLabel3.Font = t1.value11.FontMedium
    TextLabel3.TextSize = 8
    TextLabel3.TextColor3 = t1.value11.Text
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.ZIndex = 13
    TextLabel3.Parent = Frame7

    local TextButton4 = Instance.new("TextButton")

    TextButton4.Size = UDim2.new(0, 28, 0, 16)
    TextButton4.Position = UDim2.new(1, -34, 0, 2)
    TextButton4.BackgroundColor3 = t1.value12[p8] and t1.value11.ToggleOn or t1.value11.ToggleOff
    TextButton4.BorderSizePixel = 0
    TextButton4.Text = ""
    TextButton4.AutoButtonColor = false
    TextButton4.ZIndex = 13
    TextButton4.Parent = Frame7

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = t1.value11.Border
    UIStroke.Thickness = 1
    UIStroke.Transparency = t1.value12[p8] and 0.3 or 0.8
    UIStroke.Parent = TextButton4

    local Frame8 = Instance.new("Frame")

    Frame8.Size = UDim2.new(0, 12, 0, 12)
    Frame8.Position = t1.value12[p8] and UDim2.new(0, 15, 0, 2) or UDim2.new(0, 1, 0, 2)
    Frame8.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame8.BorderSizePixel = 0
    Frame8.ZIndex = 14
    Frame8.Parent = TextButton4

    local TextLabel4 = Instance.new("TextLabel")

    TextLabel4.Size = UDim2.new(0, 40, 0, 10)
    TextLabel4.Position = UDim2.new(1, -46, 0, 22)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = tostring(t1.value12[p11] or p9) .. (p12 or "")
    TextLabel4.Font = t1.value11.FontMedium
    TextLabel4.TextSize = 8
    TextLabel4.TextColor3 = t1.value11.Accent
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel4.ZIndex = 13
    TextLabel4.Parent = Frame7

    local Frame9 = Instance.new("Frame")

    Frame9.Size = UDim2.new(1, -12, 0, 2)
    Frame9.Position = UDim2.new(0, 6, 0, 36)
    Frame9.BackgroundColor3 = t1.value11.SurfaceLight
    Frame9.BorderSizePixel = 0
    Frame9.ZIndex = 13
    Frame9.Parent = Frame7

    local Frame10 = Instance.new("Frame")
    local v152 = (t1.value12[p11] or p9 - p9) / (p10 - p9)

    Frame10.Size = UDim2.new(v152, 0, 1, 0)
    Frame10.BackgroundColor3 = t1.value11.Accent
    Frame10.BorderSizePixel = 0
    Frame10.ZIndex = 14
    Frame10.Parent = Frame9

    local Frame11 = Instance.new("Frame")

    Frame11.Size = UDim2.new(0, 10, 0, 10)
    Frame11.Position = UDim2.new(1, -5, 0.5, -5)
    Frame11.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame11.BorderSizePixel = 0
    Frame11.ZIndex = 15
    Frame11.Parent = Frame10
    TextButton4.MouseButton1Click:Connect(function()
        local v384 = t1.value12[p8]

        t1.value12[p8] = not v384
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
        end)
        t1.value5:Create(UIStroke, TweenInfo.new(0.2), {
			Transparency = not t1.value12[p8] and 0.8 or 0.3
		}):Play()

        if t1.value12[p8] then
            t1.value5:Create(TextButton4, TweenInfo.new(0.2), {
				BackgroundColor3 = t1.value11.ToggleOn
			}):Play()
            t1.value5:Create(Frame8, TweenInfo.new(0.2), {
				Position = UDim2.new(0, 15, 0, 2)
			}):Play()
        else
            t1.value5:Create(TextButton4, TweenInfo.new(0.2), {
				BackgroundColor3 = t1.value11.ToggleOff
			}):Play()
            t1.value5:Create(Frame8, TweenInfo.new(0.2), {
				Position = UDim2.new(0, 1, 0, 2)
			}):Play()
        end

        if p13 then
            p13(t1.value12[p8])
        end
    end)

    local function v154(p15)
        local v386 = math.clamp((p15.Position.X - Frame9.AbsolutePosition.X) / Frame9.AbsoluteSize.X, 0, 1)
        local v387 = math.floor(p9 + (p10 - p9) * v386)

        t1.value12[p11] = v387
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
        end)
        TextLabel4.Text = tostring(v387) .. (p12 or "")
        t1.value5:Create(Frame10, TweenInfo.new(0.1), {
			Size = UDim2.new(v386, 0, 1, 0)
		}):Play()

        if p14 then
            p14(v387)
        end
    end

    Frame9.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            v154(input)
            local connection
            local connection2 = t1.value2.InputChanged:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch then
                    v154(input2)
                end
            end)
            connection = t1.value2.InputEnded:Connect(function(input3)
                if input3.UserInputType == Enum.UserInputType.MouseButton1 or input3.UserInputType == Enum.UserInputType.Touch then
                    if connection2 then
                        connection2:Disconnect()
                    end

                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end
    end)

    return Frame7
end
t1.value22 = nil
local function v50(p16, p17, p18, p19, p20)
    local v160 = t1.value21[p16]

    if not v160 then
        return
    end

    local Frame12 = Instance.new("Frame")

    Frame12.Size = UDim2.new(1, 0, 0, 48)
    Frame12.BackgroundColor3 = t1.value11.Surface
    Frame12.BackgroundTransparency = 0
    Frame12.BorderSizePixel = 0
    Frame12.ZIndex = 12
    Frame12.Parent = v160.scroll

    local TextLabel5 = Instance.new("TextLabel")

    TextLabel5.Size = UDim2.new(0, 80, 0, 10)
    TextLabel5.Position = UDim2.new(0, 6, 0, 3)
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = p17
    TextLabel5.Font = t1.value11.FontMedium
    TextLabel5.TextSize = 8
    TextLabel5.TextColor3 = t1.value11.Text
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel5.ZIndex = 13
    TextLabel5.Parent = Frame12

    local TextButton5 = Instance.new("TextButton")

    TextButton5.Size = UDim2.new(1, -12, 0, 20)
    TextButton5.Position = UDim2.new(0, 6, 0, 16)
    TextButton5.BackgroundColor3 = t1.value11.SurfaceLight
    TextButton5.BorderSizePixel = 0
    TextButton5.Text = t1.value12[p18] or p19[1]
    TextButton5.Font = t1.value11.FontMedium
    TextButton5.TextSize = 8
    TextButton5.TextColor3 = t1.value11.Text
    TextButton5.ZIndex = 13
    TextButton5.AutoButtonColor = false
    TextButton5.Parent = Frame12

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = t1.value11.Border
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.3
    UIStroke.Parent = TextButton5

    local TextLabel6 = Instance.new("TextLabel")

    TextLabel6.Size = UDim2.new(0, 14, 0, 14)
    TextLabel6.Position = UDim2.new(1, -18, 0, 3)
    TextLabel6.BackgroundTransparency = 1
    TextLabel6.Text = "▼"
    TextLabel6.Font = t1.value11.Font
    TextLabel6.TextSize = 8
    TextLabel6.TextColor3 = t1.value11.Accent
    TextLabel6.ZIndex = 14
    TextLabel6.Parent = TextButton5

    local Frame13 = Instance.new("Frame")

    Frame13.Size = UDim2.new(1, -12, 0, 0)
    Frame13.Position = UDim2.new(0, 6, 0, 38)
    Frame13.BackgroundColor3 = t1.value11.Surface
    Frame13.BackgroundTransparency = 0
    Frame13.BorderSizePixel = 0
    Frame13.ClipsDescendants = true
    Frame13.Visible = false
    Frame13.ZIndex = 100
    Frame13.Parent = Frame12

    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Color = t1.value11.Accent
    UIStroke2.Thickness = 1
    UIStroke2.Transparency = 0.3
    UIStroke2.Parent = Frame13

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 2
    ScrollingFrame.ScrollBarImageColor3 = t1.value11.Accent
    ScrollingFrame.ScrollBarImageTransparency = 0.3
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #p19 * 20)
    ScrollingFrame.ZIndex = 101
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.Parent = Frame13

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 1)
    UIListLayout.Parent = ScrollingFrame

    local u170 = false
    local t4 = {}

    local function v172()
        u170 = false
        t1.value5:Create(Frame13, TweenInfo.new(0.1), {
			Size = UDim2.new(1, -12, 0, 0)
		}):Play()
        task.wait(0.1)
        Frame13.Visible = false
        Frame12.Size = UDim2.new(1, 0, 0, 48)
        t1.value5:Create(TextLabel6, TweenInfo.new(0.1), {
			Rotation = 0
		}):Play()
    end
    local function v173()
        u170 = true
        Frame13.Visible = true

        local v391 = math.min(#p19 * 20 + 2, 100)

        t1.value5:Create(Frame13, TweenInfo.new(0.1), {
			Size = UDim2.new(1, -12, 0, v391)
		}):Play()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #p19 * 20)
        Frame12.Size = UDim2.new(1, 0, 0, 48)
        t1.value5:Create(TextLabel6, TweenInfo.new(0.1), {
			Rotation = 180
		}):Play()
    end

    for _, v in ipairs(p19) do
        local v176 = v
        local TextButton6 = Instance.new("TextButton")

        TextButton6.Size = UDim2.new(1, 0, 0, 18)
        TextButton6.BackgroundColor3 = v176 == t1.value12[p18] and t1.value11.DropdownSelected or t1.value11.SurfaceLight
        TextButton6.BackgroundTransparency = v176 ~= t1.value12[p18] and 0.1 or 0.3
        TextButton6.BorderSizePixel = 0
        TextButton6.Text = v176
        TextButton6.Font = t1.value11.FontMedium
        TextButton6.TextSize = 8
        TextButton6.TextColor3 = v176 == t1.value12[p18] and Color3.new(1, 1, 1) or t1.value11.Text
        TextButton6.ZIndex = 102
        TextButton6.AutoButtonColor = false
        TextButton6.Parent = ScrollingFrame
        TextButton6.MouseEnter:Connect(function()
            if v176 ~= t1.value12[p18] then
                t1.value5:Create(TextButton6, TweenInfo.new(0.1), {
					BackgroundColor3 = t1.value11.DropdownHover,
					BackgroundTransparency = 0.2
				}):Play()
            end
        end)
        TextButton6.MouseLeave:Connect(function()
            if v176 ~= t1.value12[p18] then
                t1.value5:Create(TextButton6, TweenInfo.new(0.1), {
					BackgroundColor3 = t1.value11.SurfaceLight,
					BackgroundTransparency = 0.1
				}):Play()
            end
        end)
        TextButton6.MouseButton1Click:Connect(function()
            t1.value12[p18] = v176
            pcall(function()
                if not isfolder or not makefolder then
                    return
                end

                if not isfolder("oishi_hub") then
                    makefolder("oishi_hub")
                end

                writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
            end)
            TextButton5.Text = v176

            for _, v3 in ipairs(t4) do
                if v3.Text == v176 then
                    local value5 = t1.value5
                    local tweenInfo = TweenInfo.new(0.1)
                    local DropdownSelected = t1.value11.DropdownSelected
                    local _Color3 = Color3
                    local Create = value5.Create
                    local v399 = _Color3.new(1, 1, 1)

                    Create(value5, v3, tweenInfo, {
						BackgroundColor3 = DropdownSelected,
						BackgroundTransparency = 0.3,
						TextColor3 = v399
					}):Play()
                else
                    local value5 = t1.value5
                    local tweenInfo = TweenInfo.new(0.1)
                    local SurfaceLight = t1.value11.SurfaceLight
                    local Create = value5.Create
                    local value11Text = t1.value11.Text

                    Create(value5, v3, tweenInfo, {
						BackgroundColor3 = SurfaceLight,
						BackgroundTransparency = 0.1,
						TextColor3 = value11Text
					}):Play()
                end
            end

            v172()

            if p20 then
                p20(v176)
            end
        end)
        table.insert(t4, TextButton6)
    end

    TextButton5.MouseButton1Click:Connect(function()
        if u170 then
            v172()

            return
        end

        v173()
    end)
    v160.scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if u170 then
            v172()
        end
    end)

    return Frame12
end
t1.value23 = false
t1.value24 = nil
t1.value25 = Vector3.new(0, -1000, 0)
function t1.value26()
    if t1.value22 then
        return
    end

    t1.value23 = true

    local value4 = t1.value4
    local value8 = t1.value8
    local Gun = require(value8.PlayerScripts.Modules.ItemTypes.Gun)
    local Utility = require(value4.Modules.Utility)
    local self = setmetatable({}, {
		__index = function(_, p22)
        local Character = value8.Character

        if not Character then
            return nil
        end

        if p22 == "root" then
            return Character:FindFirstChild("HumanoidRootPart")
        end

        if p22 == "head" then
            return Character:FindFirstChild("Head")
        end

        return nil
    end
	})

    t1.value22 = {
		Active = true
	}

    local value22 = t1.value22

    function value22.FindTarget(_)
        local Character = value8.Character
        if not Character then
            return nil
        end
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            return nil
        end
        local v411
        local huge = math.huge
        local _next = next
        local v414, v415 = t1.value1:GetPlayers()
        while true do
            local v416

            v415, v416 = _next(v414, v415)

            if not v415 then
                break
            end

            if v416 ~= value8 and not v28(v416) then
                local Character2 = v416.Character

                if Character2 then
                    local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")
                    local Head = Character2:FindFirstChild("Head")
                    local Humanoid = Character2:FindFirstChildWhichIsA("Humanoid")
                    local v421 = HumanoidRootPart2

                    if v421 then
                        v421 = Head

                        if v421 then
                            v421 = Humanoid and Humanoid.Health > 0
                        end
                    end

                    if v421 then
                        local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude

                        if Magnitude < huge then
                            v411 = v416
                            huge = Magnitude
                        end
                    end
                end
            end
        end

        return v411
    end

    value22.Connection = t1.value3.Heartbeat:Connect(function()
        if not value22.Active then
            return
        end

        value22.Target = value22:FindTarget()

        if value22.Target and value22.Target.Character then
            local Head = value22.Target.Character:FindFirstChild("Head")

            if Head then
                local root = self.root

                if root then
                    local rootCFrame = root.CFrame
                    local rootVelocity = root.Velocity
                    local RotVelocity = root.RotVelocity

                    root.CFrame = Head.CFrame
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    t1.value24 = Head.Position
                    t1.value3:BindToRenderStep("WallbangRestore", 101, function()
                        root.CFrame = rootCFrame
                        root.Velocity = rootVelocity
                        root.RotVelocity = RotVelocity
                        t1.value3:UnbindFromRenderStep("WallbangRestore")
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

                root.CFrame = CFrame.new(t1.value25)
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero
                t1.value24 = t1.value25
                t1.value3:BindToRenderStep("WallbangVoid", 101, function()
                    root.CFrame = rootCFrame
                    root.Velocity = rootVelocity
                    root.RotVelocity = RotVelocity
                    t1.value3:UnbindFromRenderStep("WallbangVoid")
                end)
            end
        end
    end)

    local StartShooting = Gun.StartShooting

    value22.OldShootFunc = StartShooting

    function Gun.StartShooting(p24, ...)
        local t5 = { StartShooting(p24, ...) }
        local t6 = { v2(t5) }

        if not p24.ClientFighter or not p24.ClientFighter.IsLocalPlayer then
            return unpack(t6)
        end

        local v435 = t6[3]

        if not v435 or typeof(v435) ~= "table" then
            return unpack(t6)
        end

        t6[4] = true

        local value22Target = value22.Target

        if not value22.Active or (not value22Target or not value22Target.Character) then
            return unpack(t6)
        end

        local Head = value22Target.Character:FindFirstChild("Head")

        if not Head then
            return unpack(t6)
        end

        local HeadPosition = Head.Position
        local v439 = Head.CFrame:ToObjectSpace(CFrame.new(HeadPosition + Vector3.new(math.random() * 0.1, math.random() * 0.1, math.random() * 0.1)))

        v435[utf8.char(0)] = Utility:EncodeCFrame(CFrame.new(HeadPosition, HeadPosition + Head.CFrame.LookVector))
        v435[utf8.char(1)] = Utility:EncodeCFrame(CFrame.new(HeadPosition))
        v435[utf8.char(2)] = Head
        v435[utf8.char(3)] = Utility:EncodeCFrame(v439)

        return unpack(t6)
    end
    function value22.Shutdown(p25)
        p25.Active = false
        t1.value24 = nil

        if p25.Connection then
            p25.Connection:Disconnect()
        end

        if p25.OldShootFunc then
            Gun.StartShooting = p25.OldShootFunc
        end

        t1.value3:UnbindFromRenderStep("WallbangRestore")
        t1.value3:UnbindFromRenderStep("WallbangVoid")
    end
end
function t1.value27()
    if t1.value22 then
        t1.value22:Shutdown()
        t1.value22 = nil
    end

    t1.value23 = false
    t1.value24 = nil
end
t1.value28 = false
t1.value29 = nil
t1.value30 = 0
t1.value31 = false
t1.value32 = 0
t1.value33 = require(t1.value4.Modules.Utility)
t1.value34 = require(t1.value4.Modules.EnumLibrary)
t1.value35 = {
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
function t1.value36(p26)
    if not p26 then
        return false
    end

    for _, v in ipairs(t1.value35) do
        if p26 == v then
            return true
        end
    end

    return false
end
function t1.value37()
    local Character = t1.value8.Character
    if not Character then
        return nil
    end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then
        return nil
    end
    local v191
    local n1 = 1e999
    for _, player in ipairs(t1.value1:GetPlayers()) do
        if player ~= t1.value8 and not v28(player) then
            local Character3 = player.Character

            if Character3 then
                local Humanoid = Character3:FindFirstChildOfClass("Humanoid")

                if Humanoid and (Humanoid.Health > 0 and not Character3:FindFirstChildOfClass("ForceField")) then
                    local HumanoidRootPart3 = Character3:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart3 then
                        local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart3.Position).Magnitude

                        if Magnitude < n1 then
                            v191 = Character3
                            n1 = Magnitude
                        end
                    end
                end
            end
        end
    end

    return v191
end
function t1.value38()
    local ViewModels = t1.value6:FindFirstChild("ViewModels")

    if not ViewModels then
        return nil
    end

    local FirstPerson = ViewModels:FindFirstChild("FirstPerson")

    if not FirstPerson then
        return nil
    end

    local GetChildren = FirstPerson.GetChildren

    for _, v in ipairs(GetChildren(FirstPerson)) do
        local v204 = v.Name:find("-")

        if v204 then
            return v.Name:sub(v204 + 1):match("^%s*(.-)%s*$")
        end
    end

    return nil
end
function t1.value39()
    local v205 = t1.value12.AutoShootShootAttempt or 0

    if v205 <= 0 then
        return true
    end

    if v205 >= 100 then
        return math.random(1, 100) <= 1
    end

    return 100 - v205 >= math.random(1, 100)
end
function t1.value40()
    local v206 = t1.value12.AutoShootShootAttempt or 0

    if v206 <= 0 then
        return 0
    end

    return v206 / 100 * 0.5
end
function t1.value41()
    local Character = t1.value8.Character

    if not Character then
        return false
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid or Humanoid.Health <= 0 then
        return false
    end

    return true
end
function t1.value42()
    t1.value31 = true
    t1.value32 = tick() + 6
    task.delay(6, function()
        t1.value31 = false
    end)
end
t1.value8.CharacterAdded:Connect(function(character)
    if t1.value28 then
        t1.value42()
    end

    local Humanoid = character:WaitForChild("Humanoid", 10)

    if Humanoid then
        Humanoid.Died:Connect(function()
            if t1.value28 then
                t1.value42()
            end
        end)
    end
end)
if t1.value8.Character then
    local Humanoid = t1.value8.Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.Died:Connect(function()
            if t1.value28 then
                t1.value42()
            end
        end)
    end
end
t1.value43 = nil
t1.value44 = nil
function t1.value43()
    if not t1.value28 then
        return
    end

    if t1.value31 and tick() < t1.value32 then
        return
    end

    if not t1.value41() then
        return
    end

    local v212 = t1.value38()

    if v212 and t1.value36(v212) then
        return
    end

    local timestamp = tick()

    if t1.value40() > timestamp - t1.value30 then
        return
    end

    if not t1.value39() then
        return
    end

    local v214 = t1.value37()

    if not v214 then
        return
    end

    local Head = v214:FindFirstChild("Head")

    if not Head then
        return
    end

    local player = t1.value1:GetPlayerFromCharacter(v214)

    if not player or v28(player) then
        return
    end

    pcall(function()
        local FighterController = require(t1.value8.PlayerScripts.Controllers.FighterController)
        local v445 = FighterController.LocalFighter and FighterController.LocalFighter.EquippedItem

        if not v445 then
            return
        end

        local v446 = v445:Get("ObjectID")

        if not v446 then
            return
        end

        local Character = t1.value8.Character
        local v448 = Character and Character:FindFirstChild("HumanoidRootPart")
        local v449 = v448 and v448.Position or Head.Position

        if t1.value23 and t1.value24 then
            v449 = t1.value24
        end

        local v450 = utf8.char(1)
        local v451 = utf8.char(0)
        local v452 = t1.value33:EncodeCFrame(CFrame.new(v449, Head.Position))
        local v453 = utf8.char(1)
        local v454 = t1.value33:EncodeCFrame(CFrame.new(v449, Head.Position))
        local v455 = utf8.char(2)
        local v456 = Head
        local v457 = utf8.char(3)
        local value33 = t1.value33
        local t7 = { CFrame.new(0.43, 0.25, 0.42) }
        local v460 = value33:EncodeCFrame(v2(t7))
        local t8 = {
			[v450] = {
				[v451] = v452,
				[v453] = v454,
				[v455] = v456,
				[v457] = v460
			}
		}

        t1.value4.Remotes.Replication.Fighter.UseItem:FireServer(v446, t1.value34:ToEnum("StartShooting"), t8, nil)
    end)
end
function t1.value45()
    if t1.value28 then
        return
    end

    t1.value28 = true
    t1.value31 = false
    t1.value29 = t1.value3.Heartbeat:Connect(function()
        if t1.value28 then
            t1.value43()
        end
    end)
end
t1.value46 = nil
function t1.value47()
    if t1.value29 then
        t1.value29:Disconnect()
    end
end
t1.value44 = false
function t1.value48()
    if t1.value44 then
        return
    end

    t1.value44 = true
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
function t1.value49()
    t1.value44 = false
end
t1.value50 = nil
t1.value51 = false
t1.value52 = nil
t1.value53 = nil
t1.value54 = nil
t1.value55 = nil
t1.value56 = nil
t1.value56 = nil
function t1.value57()
    local v219 = t1.value8.Character or t1.value8.CharacterAdded:Wait()

    t1.value55 = v219:WaitForChild("Humanoid")
    t1.value56 = v219:WaitForChild("HumanoidRootPart")

    if t1.value51 then
        if t1.value52 then
            t1.value52:Destroy()
        end

        t1.value55.PlatformStand = true
        t1.value52 = Instance.new("Attachment", t1.value56)
        t1.value53 = Instance.new("LinearVelocity", t1.value52)
        t1.value53.MaxForce = 9000000000
        t1.value53.VectorVelocity = Vector3.zero
        t1.value53.Attachment0 = t1.value52
        t1.value54 = Instance.new("AlignOrientation", t1.value52)
        t1.value54.MaxTorque = 9000000000
        t1.value54.Responsiveness = 200
        t1.value54.Mode = Enum.OrientationAlignmentMode.OneAttachment
        t1.value54.Attachment0 = t1.value52
    end
end
t1.value8.CharacterAdded:Connect(function()
    task.wait(0.1)
    t1.value57()
end)
t1.value57()
local _require = require
local PlayerScripts = t1.value8.PlayerScripts
t1.value58 = nil
t1.value59 = _require(PlayerScripts:WaitForChild("PlayerModule")):GetControls()
local RenderStepped = t1.value3.RenderStepped
t1.value60 = nil
RenderStepped:Connect(function()
    local value51 = t1.value51

    if value51 then
        value51 = t1.value56 and (t1.value9 and (t1.value53 and t1.value54))
    end

    if value51 then
        local value9 = t1.value9
        local MoveVector = t1.value59:GetMoveVector()
        local v227 = t1.value12.FlySpeed or 80

        if MoveVector.Magnitude > 0 then
            t1.value53.VectorVelocity = (value9.CFrame.LookVector * -MoveVector.Z + value9.CFrame.RightVector * MoveVector.X).Unit * v227
        else
            t1.value53.VectorVelocity = Vector3.zero
        end

        t1.value54.CFrame = value9.CFrame
    end
end)
t1.value61 = nil
function t1.value62()
    t1.value57()
end
function t1.value63()
    if t1.value55 then
        t1.value55.PlatformStand = false
    end

    if t1.value52 then
        t1.value52:Destroy()
    end
end
t1.value61 = false
t1.value60 = nil
function t1.value64()
    if t1.value61 then
        return
    end

    t1.value61 = true
    t1.value60 = t1.value2.JumpRequest:Connect(function()
        if not t1.value61 then
            return
        end

        local Character = t1.value8.Character

        if not Character then
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if Humanoid and Humanoid.Health > 0 then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end
function t1.value65()
    if t1.value60 then
        t1.value60:Disconnect()
    end
end
t1.value50 = false
t1.value46 = nil
function t1.value66()
    if t1.value50 then
        return
    end

    t1.value50 = true
    t1.value46 = t1.value3.Stepped:Connect(function()
        if not t1.value50 then
            return
        end

        local Character = t1.value8.Character

        if not Character then
            return
        end

        for _, descendant in pairs(Character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
            end
        end
    end)
end
function t1.value67()
    t1.value50 = false

    if t1.value46 then
        t1.value46:Disconnect()
        t1.value46 = nil
    end
end
t1.value68 = {
	Enabled = false,
	Mode = "Third Person",
	X = 3,
	Y = 2,
	Z = 6
}
t1.value69 = nil
function t1.value70()
    if not t1.value68.Enabled then
        return nil
    end

    local Character = t1.value8.Character

    if not Character then
        return nil
    end

    if not Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end

    if t1.value68.Mode == "Third Person" then
        return (Vector3.new(3, 2, 6))
    end

    if t1.value68.Mode == "Second Person" then
        return (Vector3.new(0, 2, -6))
    end

    if t1.value68.Mode == "Left Shoulder" then
        return (Vector3.new(-3, 2, 6))
    end

    if t1.value68.Mode == "Right Shoulder" then
        return (Vector3.new(3, 2, 6))
    end

    return (Vector3.new(3, 2, 6))
end
local function v55()
    if t1.value68.Enabled then
        return
    end

    t1.value68.Enabled = true
    t1.value68.Mode = t1.value12.ThirdPersonMode or "Third Person"
    t1.value3.RenderStepped:Connect(function()
        if not t1.value68.Enabled then
            return
        end

        local Character = t1.value8.Character

        if not Character then
            return
        end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            return
        end

        local v469 = t1.value70()

        if not v469 then
            return
        end

        local CurrentCamera = t1.value6.CurrentCamera

        if CurrentCamera and HumanoidRootPart == CurrentCamera.CameraSubject then
            CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(v469)
        end
    end)
end
function t1.value71()
    t1.value68.Enabled = false

    if t1.value69 then
        t1.value69:Disconnect()
    end
end
t1.value72 = false
t1.value73 = {}
t1.value74 = nil
function t1.value75(p27, p28)
    local drawing = Drawing.new(p27)

    for k, v in pairs(p28) do
        drawing[k] = v
    end

    return drawing
end
function t1.value76(_)
    local t9 = {}

    if t1.value12.EspBoxes then
        local value75 = t1.value75
        local color3_18 = Color3.new(0, 0, 0)

        t9.BoxOutline = value75("Square", {
			Visible = false,
			Thickness = 3,
			Filled = false,
			Color = color3_18
		})

        local value75_2 = t1.value75
        local color3_19 = Color3.fromRGB(0, 150, 255)

        t9.Box = value75_2("Square", {
			Visible = false,
			Thickness = 1.5,
			Filled = false,
			Color = color3_19
		})
    end

    if t1.value12.EspNames then
        local value75 = t1.value75
        local color3_20 = Color3.new(0, 0, 0)
        local color3_21 = Color3.new(1, 1, 1)

        t9.Name = value75("Text", {
			Visible = false,
			Center = true,
			Outline = true,
			OutlineColor = color3_20,
			Size = 13,
			Font = 2,
			Color = color3_21
		})
    end

    if t1.value12.EspHealth then
        local value75 = t1.value75
        local color3_22 = Color3.new(0, 0, 0)

        t9.HealthBarBG = value75("Line", {
			Visible = false,
			Thickness = 5,
			Color = color3_22
		})

        local value75_3 = t1.value75
        local color3_23 = Color3.new(0, 1, 0)

        t9.HealthBar = value75_3("Line", {
			Visible = false,
			Thickness = 3,
			Color = color3_23
		})
    end

    if t1.value12.EspDistance then
        local value75 = t1.value75
        local color3_24 = Color3.new(0, 0, 0)
        local color3_25 = Color3.new(1, 1, 1)

        t9.Distance = value75("Text", {
			Visible = false,
			Center = true,
			Outline = true,
			OutlineColor = color3_24,
			Size = 11,
			Font = 2,
			Color = color3_25
		})
    end

    if t1.value12.EspHealthNumber then
        local value75 = t1.value75
        local color3_26 = Color3.new(0, 0, 0)
        local color3_27 = Color3.new(1, 1, 1)

        t9.HealthNumber = value75("Text", {
			Visible = false,
			Center = true,
			Outline = true,
			OutlineColor = color3_26,
			Size = 11,
			Font = 2,
			Color = color3_27
		})
    end

    return t9
end
function t1.value77(p30, p31)
    local v251 = p31 / 2
    local t10 = {}
    local v253 = true

    for i = -1, 1, 2 do
        for j = -1, 1, 2 do
            for k = -1, 1, 2 do
                local v257 = p30 * Vector3.new(v251.X * i, v251.Y * j, v251.Z * k)
                local v258, v259 = t1.value9:WorldToViewportPoint(v257)

                if not v259 then
                    v253 = false
                end

                table.insert(t10, Vector2.new(v258.X, v258.Y))
            end
        end
    end

    return t10, v253
end
function t1.value78(p32)
    for _, v in pairs(p32) do
        if v and v.Visible then
            v.Visible = false
        end
    end
end
function t1.value79(p33)
    if not t1.value12.EspChams then
        return
    end

    if not p33 then
        return
    end

    for _, v in ipairs({
		"Head",
		"Torso",
		"Left Arm",
		"Right Arm",
		"Left Leg",
		"Right Leg",
		"UpperTorso",
		"LowerTorso",
		"LeftUpperArm",
		"RightUpperArm",
		"LeftLowerArm",
		"RightLowerArm",
		"LeftUpperLeg",
		"RightUpperLeg",
		"LeftLowerLeg",
		"RightLowerLeg",
		"HumanoidRootPart"
	}) do
        local v5 = p33:FindFirstChild(v)

        if v5 and v5:IsA("BasePart") then
            v5.Transparency = 0.3
            v5.Material = Enum.Material.ForceField
            v5.Color = Color3.fromRGB(0, 150, 255)
        end
    end
end
function t1.value80(p34)
    if not p34 then
        return
    end

    for _, v in ipairs({
		"Head",
		"Torso",
		"Left Arm",
		"Right Arm",
		"Left Leg",
		"Right Leg",
		"UpperTorso",
		"LowerTorso",
		"LeftUpperArm",
		"RightUpperArm",
		"LeftLowerArm",
		"RightLowerArm",
		"LeftUpperLeg",
		"RightUpperLeg",
		"LeftLowerLeg",
		"RightLowerLeg",
		"HumanoidRootPart"
	}) do
        local v6 = p34:FindFirstChild(v)

        if v6 and v6:IsA("BasePart") then
            v6.Transparency = 0
            v6.Material = Enum.Material.Plastic
        end
    end
end
t1.value81 = nil
function t1.value81()
    if not t1.value72 then

        for v289, v290 in pairs(t1.value73) do

            t1.value78(v290)
        end
        for _, player in ipairs(t1.value1:GetPlayers()) do
            if player ~= t1.value8 and player.Character then
                t1.value80(player.Character)
            end
        end

        return
    end

    for _, player in ipairs(t1.value1:GetPlayers()) do
        if player ~= t1.value8 then
            if v28(player) then
                if t1.value73[player] then
                    t1.value78(t1.value73[player])
                end

                if player.Character then
                    t1.value80(player.Character)
                end
            else
                local Character = player.Character
                local v296 = Character and Character:FindFirstChildOfClass("Humanoid")

                if Character and (v296 and v296.Health > 0) then
                    if t1.value12.EspChams then
                        t1.value79(Character)
                    else
                        t1.value80(Character)
                    end

                    local EspBoxes = t1.value12.EspBoxes

                    if not EspBoxes then
                        EspBoxes = t1.value12.EspNames

                        if not EspBoxes then
                            EspBoxes = t1.value12.EspHealth or (t1.value12.EspDistance or t1.value12.EspHealthNumber)
                        end
                    end

                    if EspBoxes then
                        local ok, result, v300 = pcall(Character.GetBoundingBox, Character)

                        if ok then
                            ok = result and v300
                        end

                        if ok then
                            local v301, v302 = t1.value77(result, v300)

                            if not v302 then
                                if t1.value73[player] then
                                    t1.value78(t1.value73[player])
                                end
                            else
                                local v303 = t1.value73[player] or t1.value76(player)

                                t1.value73[player] = v303

                                local n2 = 1e999
                                local n3 = -1e999
                                local n4 = -1e999
                                local n5 = 1e999

                                for _, v in ipairs(v301) do
                                    n5 = math.min(n5, v.X)
                                    n2 = math.min(n2, v.Y)
                                    n3 = math.max(n3, v.X)
                                    n4 = math.max(n4, v.Y)
                                end

                                local v310 = n4 - n2
                                local v311 = n3 - n5
                                local v312 = v311 * 0.7
                                local v313 = n5 + (v311 - v312) / 2
                                local v314 = math.clamp(v296.Health / v296.MaxHealth, 0, 1)
                                local Head = Character:FindFirstChild("Head")

                                if v303.BoxOutline and t1.value12.EspBoxes then
                                    v303.BoxOutline.Visible = true
                                    v303.BoxOutline.Position = Vector2.new(v313 - 1, n2 - 1)
                                    v303.BoxOutline.Size = Vector2.new(v312 + 2, v310 + 2)
                                end

                                if v303.Box and t1.value12.EspBoxes then
                                    v303.Box.Visible = true
                                    v303.Box.Position = Vector2.new(v313, n2)
                                    v303.Box.Size = Vector2.new(v312, v310)
                                end

                                if v303.Name and t1.value12.EspNames then
                                    v303.Name.Visible = true
                                    v303.Name.Text = player.Name
                                    v303.Name.Position = Vector2.new(v313 + v312 / 2, n2 - 16)
                                end

                                local v316 = v310 * v314

                                if v303.HealthBarBG and t1.value12.EspHealth then
                                    v303.HealthBarBG.Visible = true
                                    v303.HealthBarBG.From = Vector2.new(v313 - 6, n4)
                                    v303.HealthBarBG.To = Vector2.new(v313 - 6, n2)
                                end

                                if v303.HealthBar and t1.value12.EspHealth then
                                    v303.HealthBar.Visible = true

                                    if v314 > 0.7 then
                                        v303.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                                    elseif v314 > 0.3 then
                                        v303.HealthBar.Color = Color3.fromRGB(255, 165, 0)
                                    else
                                        v303.HealthBar.Color = Color3.fromRGB(255, 0, 0)
                                    end

                                    v303.HealthBar.From = Vector2.new(v313 - 6, n4)
                                    v303.HealthBar.To = Vector2.new(v313 - 6, n4 - v316)
                                end

                                if v303.Distance and (t1.value12.EspDistance and Head) then
                                    local v317 = t1.value8.Character and t1.value8.Character:FindFirstChild("HumanoidRootPart")

                                    if v317 then
                                        local v318 = math.floor((v317.Position - Head.Position).Magnitude)

                                        v303.Distance.Visible = true
                                        v303.Distance.Text = v318 .. "m"
                                        v303.Distance.Position = Vector2.new(v313 + v312 / 2, n4 + 4)
                                    end
                                end

                                if v303.HealthNumber and t1.value12.EspHealthNumber then
                                    v303.HealthNumber.Visible = true
                                    v303.HealthNumber.Text = math.floor(v296.Health) .. "/" .. math.floor(v296.MaxHealth)
                                    v303.HealthNumber.Position = Vector2.new(v313 + v312 / 2, n4 + 16)
                                end
                            end
                        end
                    end
                else
                    if t1.value73[player] then
                        t1.value78(t1.value73[player])
                    end

                    if Character then
                        t1.value80(Character)
                    end
                end
            end
        end
    end
end
function t1.value82()
    t1.value72 = true

    if t1.value74 then
        t1.value74:Disconnect()
    end

    t1.value3.RenderStepped:Connect(t1.value81)
end
t1.value83 = nil
function t1.value83()
    t1.value72 = false
    if t1.value74 then
        t1.value74:Disconnect()
        t1.value74 = nil
    end
    for v282, v283 in pairs(t1.value73) do

        local v284 = v283

        pcall(function()
            for _, v in pairs(v284) do
                if v and v.Remove then
                    v:Remove()
                end
            end
        end)
    end
    t1.value73 = {}
    for _, player in ipairs(t1.value1:GetPlayers()) do
        if player.Character then
            t1.value80(player.Character)
        end
    end
end
function t1.value58()
    if t1.value72 then
        t1.value83()
        t1.value82()
    end
end
t1.value1.PlayerRemoving:Connect(function(player)
    if t1.value73[player] then
        for _, v in pairs(t1.value73[player]) do
            local v326 = v

            pcall(function()
                if v326 and v326.Remove then
                    v326:Remove()
                end
            end)
        end

        t1.value73[player] = nil
    end

    if player.Character then
        t1.value80(player.Character)
    end
end)
t1.value84 = {
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
t1.value85 = {}
t1.value86 = {
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
	["Glitch Through"] = "85364072005108"
}
function t1.value87()
    for _, v in ipairs(t1.value85) do
        local v329 = v

        pcall(function()
            v329:Stop(0)
            v329:Destroy()
        end)
    end

    t1.value85 = {}
end
function t1.value88(p35)
    if not p35 then
        return nil
    end

    local Humanoid = p35:FindFirstChildOfClass("Humanoid")

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
function t1.value89(p36)
    local ok, result = pcall(function()
        return game:GetObjects("rbxassetid://" .. p36)
    end)
    local v336 = not ok

    if not v336 then
        v336 = not result or #result == 0
    end

    if v336 then
        return nil
    end

    local v337, v338, v339 = ipairs(result)
    local v340

    repeat
        v339, v340 = v337(v338, v339)

        if not v339 then
            for _, v in ipairs(result) do
                for _, descendant in ipairs(v:GetDescendants()) do
                    if descendant:IsA("Animation") and descendant.AnimationId ~= "" then
                        return descendant
                    end
                end
            end

            return nil
        end
    until v340:IsA("Animation") and v340.AnimationId ~= ""

    return v340
end
local function v56(p37, p38, p39, p40)
    if not p37 or p38 == "" then
        return nil
    end

    local v349 = t1.value88(p37)

    if not v349 then
        return nil
    end

    local u350 = t1.value89(p38)

    if not u350 then
        u350 = Instance.new("Animation")
        u350.AnimationId = "rbxassetid://" .. p38
    end

    local ok, result = pcall(function()
        return v349:LoadAnimation(u350)
    end)
    local v353 = not ok

    if not v353 then
        v353 = not result
    end

    if v353 then
        pcall(function()
            u350:Destroy()
        end)

        return nil
    end

    result.Looped = p40
    result.Priority = Enum.AnimationPriority.Action4
    result:Play(0.1, 1, p39)

    return result
end
function t1.value90()
    t1.value87()

    if not t1.value84.enabled or t1.value84.animationId == "" then
        return
    end

    local Character = t1.value8.Character

    if Character then
        local v355 = v56(Character, t1.value84.animationId, t1.value84.speed, t1.value84.loop)

        if v355 then
            table.insert(t1.value85, v355)
        end
    end

    local Live = t1.value6:FindFirstChild("Live")

    if Live then
        local t1value8Name = Live:FindFirstChild(t1.value8.Name)

        if t1value8Name then
            local v358 = v56(t1value8Name, t1.value84.animationId, t1.value84.speed, t1.value84.loop)

            if v358 then
                table.insert(t1.value85, v358)
            end
        end
    end
end
t1.value3.Heartbeat:Connect(function()
    if not t1.value84.enabled then
        return
    end

    if #t1.value85 == 0 and t1.value84.animationId ~= "" then
        t1.value90()
    end

    for _, v in ipairs(t1.value85) do
        local v361 = v

        pcall(function()
            v361:AdjustSpeed(t1.value84.speed)
        end)
    end
end)
t1.value8.CharacterAdded:Connect(function()
    task.wait(0.5)

    if t1.value84.enabled and t1.value84.spawnProof then
        t1.value90()
    end
end)
local function v57(p41)
    if p41 then
        t1.value84.enabled = true

        local v363 = t1.value86[t1.value12.AnimationPreset]

        if v363 then
            t1.value84.animationId = v363
        end

        t1.value84.speed = t1.value12.AnimationSpeed
        t1.value84.loop = true
        t1.value84.serverSide = true
        t1.value90()

        return
    end

    t1.value84.enabled = false
    t1.value87()
end
t1.value91 = nil
local function v58(p42)
    if p42 then
        t1.value91 = t1.value3.RenderStepped:Connect(function()
            local Character = t1.value8.Character

            if not Character then
                return
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                return
            end

            local Humanoid = Character:FindFirstChild("Humanoid")
            local v476 = Humanoid and Humanoid.Health < Humanoid.MaxHealth

            for _, child in pairs(t1.value6:GetChildren()) do
                if child.Name == "_drop" and child:IsA("BasePart") then
                    if child:FindFirstChild("Health") and v476 then
                        firetouchinterest(HumanoidRootPart, child, 0)
                        firetouchinterest(HumanoidRootPart, child, 1)
                    end

                    if child:FindFirstChild("Ammo") then
                        firetouchinterest(HumanoidRootPart, child, 0)
                        firetouchinterest(HumanoidRootPart, child, 1)
                    end
                end
            end
        end)

        return
    end

    if t1.value91 then
        t1.value91:Disconnect()
    end
end
t1.value92 = {
	enabled = false,
	mode = "1v1",
	ranked = false
}
task.spawn(function()
    while true do
        if t1.value92.enabled then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Matchmaking"):WaitForChild("JoinQueue"):InvokeServer(t1.value92.mode, t1.value92.ranked)
            end)
        end

        task.wait(1)
    end
end)
t1.value92.mode = t1.value12.AutoQueueMode or "1v1"
t1.value92.ranked = t1.value92.mode:find("ranked") ~= nil
v48("Ragebot", "Ragebot", "Ragebot", function(p43)
    if p43 then
        t1.value26()

        return
    end

    t1.value27()
end)
v49("Ragebot", "Auto Shoot", "AutoShoot", 0, 100, "AutoShootShootAttempt", "%", function(p44)
    if p44 then
        t1.value45()

        return
    end

    t1.value47()
end, function(p45)
    t1.value12.AutoShootShootAttempt = p45
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
end)
v48("Ragebot", "Rapid Fire", "RapidFire", function(p46)
    if p46 then
        t1.value48()

        return
    end

    t1.value49()
end)
v48("ESP", "Enable ESP", "Esp", function(p47)
    if p47 then
        t1.value82()

        return
    end

    t1.value83()
end)
v48("ESP", "Box ESP", "EspBoxes", function(p48)
    t1.value12.EspBoxes = p48
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
    t1.value58()
end)
v48("ESP", "Health Bar ESP", "EspHealth", function(p49)
    t1.value12.EspHealth = p49
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
    t1.value58()
end)
v48("ESP", "Name ESP", "EspNames", function(p50)
    t1.value12.EspNames = p50
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
    t1.value58()
end)
v48("ESP", "Distance ESP", "EspDistance", function(p51)
    t1.value12.EspDistance = p51
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
    t1.value58()
end)
v48("ESP", "Health Number", "EspHealthNumber", function(p52)
    t1.value12.EspHealthNumber = p52
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
    t1.value58()
end)
v48("ESP", "Cham", "EspChams", function(p53)
    t1.value12.EspChams = p53
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
    t1.value58()
end)
v48("Auto", "Auto Collect", "AutoCollect", v58)
v48("Auto", "Auto Queue", "AutoQueueEnabled", function(p54)
    t1.value92.enabled = p54
    t1.value12.AutoQueueEnabled = p54
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
end)
v50("Auto", "Queue Mode", "AutoQueueMode", {
	"1v1",
	"2v2",
	"3v3",
	"4v4",
	"5v5",
	"ranked 1v1",
	"ranked 2v2",
	"ranked 3v3"
}, function(p55)
    t1.value92.mode = p55
    t1.value92.ranked = p55:find("ranked") ~= nil
    t1.value12.AutoQueueMode = p55
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
end)
v49("Misc", "Fly Mode", "Fly", 20, 200, "FlySpeed", "", function(p56)
    if p56 then
        t1.value62()

        return
    end

    t1.value63()
end, function(p57)
    t1.value12.FlySpeed = p57
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
end)
v48("Misc", "Infinite Jump", "InfiniteJump", function(p58)
    if p58 then
        t1.value64()

        return
    end

    t1.value65()
end)
v48("Misc", "Noclip", "Noclip", function(p59)
    if p59 then
        t1.value66()

        return
    end

    t1.value67()
end)
v48("Misc", "Third Person", "ThirdPerson", function(p60)
    if p60 then
        v55()

        return
    end

    t1.value71()
end)
v50("Misc", "Camera Mode", "ThirdPersonMode", {
	"Third Person",
	"Second Person",
	"Left Shoulder",
	"Right Shoulder"
}, function(p61)
    t1.value68.Mode = p61
    t1.value12.ThirdPersonMode = p61
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)
end)
v48("Settings", "Enable Animation", "AnimationEnabled", v57)
v50("Settings", "Anim Preset", "AnimationPreset", {
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
	"Glitch Through"
}, function(p62)
    t1.value12.AnimationPreset = p62
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        writefile("oishi_hub/settings.json", t1.value7:JSONEncode(t1.value12))
    end)

    local v366 = t1.value86[p62]

    if v366 then
        t1.value84.animationId = v366

        if t1.value84.enabled then
            t1.value90()
        end
    end
end)
task.wait(0.1)
for _, v in pairs(t1.value21) do
    v.scroll.CanvasSize = UDim2.new(0, 0, 0, v.layout.AbsoluteContentSize.Y + 10)
end
t1.value93 = false
t1.value94 = nil
t1.value95 = nil
t1.value15.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        t1.value93 = true
        t1.value94 = input.Position
        t1.value95 = t1.value15.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                t1.value93 = false
            end
        end)
    end
end)
t1.value2.InputChanged:Connect(function(input)
    local value93 = t1.value93

    if value93 then
        value93 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
    end

    if value93 then
        local v372 = input.Position - t1.value94

        t1.value15.Position = UDim2.new(t1.value95.X.Scale, t1.value95.X.Offset + v372.X, t1.value95.Y.Scale, t1.value95.Y.Offset + v372.Y)
    end
end)
t1.value96 = nil
if t1.value10 then
    t1.value96 = Instance.new("TextButton")
    t1.value96.Size = UDim2.new(0, 24, 0, 24)
    t1.value96.Position = UDim2.new(0, 6, 0.5, -12)
    t1.value96.BackgroundColor3 = t1.value11.Surface
    t1.value96.BackgroundTransparency = 0
    t1.value96.BorderSizePixel = 0
    t1.value96.Text = ">"
    t1.value96.Font = t1.value11.Font
    t1.value96.TextSize = 12
    t1.value96.TextColor3 = t1.value11.Accent
    t1.value96.ZIndex = 999999
    t1.value96.AutoButtonColor = false
    t1.value96.Parent = ScreenGui

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = t1.value11.Border
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0
    UIStroke.Parent = t1.value96
    t1.value96.MouseButton1Click:Connect(function()
        if t1.value15.Visible then
            t1.value18()
            t1.value96.Text = ">"

            return
        end

        t1.value17()
        t1.value96.Text = "X"
    end)
end
if v4 then
    t1.value2.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if input.KeyCode == Enum.KeyCode.RightShift then
            if t1.value15.Visible then
                t1.value18()

                return
            end

            t1.value17()
        end
    end)
end
if t1.value12.Ragebot then
    t1.value26()
end
if t1.value12.AutoShoot then
    t1.value45()
end
if t1.value12.RapidFire then
    t1.value48()
end
if t1.value12.Fly then
    t1.value62()
end
if t1.value12.InfiniteJump then
    t1.value64()
end
if t1.value12.Noclip then
    t1.value66()
end
if t1.value12.ThirdPerson then
    v55()
end
if t1.value12.Esp then
    t1.value82()
end
if t1.value12.AnimationEnabled then
    v57(true)
end
if t1.value12.AutoCollect then
    v58(true)
end
if t1.value12.AutoQueueEnabled then
    t1.value92.enabled = true
end
pcall(function()
    if writefile and (isfolder and makefolder) then
        if not isfolder("autoexec") then
            makefolder("autoexec")
        end

        local source = debug.getinfo(1, "S").source

        if source and source:sub(1, 1) == "@" then
            local v376 = source:sub(2)

            if isfile(v376) then
                local v377 = readfile(v376)

                writefile("autoexec/oishi_hub.lua", v377)
            end
        end
    end
end)
t1.value17()
