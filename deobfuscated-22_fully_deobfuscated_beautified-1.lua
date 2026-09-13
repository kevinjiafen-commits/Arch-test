-- This file was generated at discord.gg/syncrypt

local t1 = {}
local v2 = unpack or table.unpack
RunService = game:GetService("Players")
t1.value2 = game:GetService("UserInputService")
t1.value3 = game:GetService("RunService")
t1.value4 = game:GetService("ReplicatedStorage")
t1.value5 = game:GetService("TweenService")
t1.value6 = game:GetService("Workspace")
HttpService = game:GetService("HttpService")
t1.value8 = RunService.LocalPlayer
local PlayerGui = t1.value8:WaitForChild("PlayerGui")

t1.value9 = t1.value6.CurrentCamera
local v4 = t1.value2.TouchEnabled and not t1.value2.KeyboardEnabled
local v5 = not t1.value2.TouchEnabled
local color3 = Color3.fromRGB(0, 150, 255)
local color3_2 = Color3.fromRGB(5, 5, 8)
local color3_3 = Color3.fromRGB(12, 12, 16)
local color3_4 = Color3.fromRGB(20, 20, 26)
local color3_5 = Color3.fromRGB(180, 180, 195)
local color3_6 = Color3.fromRGB(100, 100, 115)
local color3_7 = Color3.fromRGB(0, 150, 255)
local color3_8 = Color3.fromRGB(40, 40, 50)
local color3_9 = Color3.fromRGB(0, 150, 255)
local color3_10 = Color3.fromRGB(25, 25, 32)
local color3_11 = Color3.fromRGB(0, 120, 220)
local color3_12 = Color3.fromRGB(35, 35, 45)
local Michroma = Enum.Font.Michroma
local Michroma2 = Enum.Font.Michroma
RunService0 = {
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
    HoverSurface = color3_12,
    Font = Michroma,
    FontMedium = Michroma2
}
local Quint = Enum.EasingStyle.Quint
local Out = Enum.EasingDirection.Out
RunService1 = {
    OpenTime = 0.28,
    CloseTime = 0.2,
    TabTime = 0.2,
    DropdownTime = 0.2,
    CollapseTime = 0.25,
    HoverTime = 0.12,
    EasingStyle = Quint,
    EasingDirection = Out
}
function RunService2(p1, p2, p3)
    local tweenInfo = TweenInfo.new(p2, RunService1.EasingStyle, RunService1.EasingDirection)

    return t1.value5:Create(p1, tweenInfo, p3)
end
local color3_13 = Color3.fromRGB(0, 150, 255)
local color3_14 = Color3.fromRGB(255, 255, 255)
local color3_15 = Color3.fromRGB(0, 255, 0)
local color3_16 = Color3.fromRGB(255, 255, 255)
local color3_17 = Color3.fromRGB(255, 255, 255)
local color3_18 = Color3.fromRGB(0, 150, 255)

RunService3 = {
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
    EspBoxColor = color3_13,
    EspNameColor = color3_14,
    EspHealthColor = color3_15,
    EspDistanceColor = color3_16,
    EspHealthNumberColor = color3_17,
    EspTracerColor = color3_18,
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
    WallTextureType = "None",
    DeviceSpoofEnabled = false,
    DeviceSpoofType = "None"
}
local v28 = (function()
    local ok, result = pcall(function()
        if not isfolder or not makefolder then
            return nil
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        if isfile("oishi_hub/settings.json") then
            local value7 = HttpService
            local t2 = { readfile("oishi_hub/settings.json") }
            local data = value7:JSONDecode(v2(t2))

            for k, v in pairs(data) do
                if type(v) == "table" and (v.r and (v.g and v.b)) then
                    data[k] = Color3.new(v.r, v.g, v.b)
                end
            end

            return data
        end

        return nil
    end)

    if ok and result then
        return result
    end

    return nil
end)()
if v28 then
    for k, _ in pairs(RunService3) do
        local v31 = k

        if v28[v31] ~= nil then
            RunService3[v31] = v28[v31]
        end
    end
end
function RunService4(p4)
    if not p4 then
        return false
    end

    local Team = t1.value8.Team
    local v91 = Team and Team.TeamColor
    local TeamID = t1.value8:GetAttribute("TeamID")
    local Team2 = p4.Team
    local v94 = Team2 and Team2.TeamColor
    local TeamID2 = p4:GetAttribute("TeamID")

    if Team then
        Team = Team2 and Team == Team2
    end

    if Team then
        return true
    end

    if v91 and (v94 and v91 == v94) then
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
RunService5 = Instance.new("ScreenGui")
RunService5.Name = "OishiHub"
RunService5.ResetOnSpawn = false
RunService5.IgnoreGuiInset = true
RunService5.DisplayOrder = 999999
RunService5.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
RunService5.Parent = PlayerGui
local v32 = if not v5 then math.min(650, t1.value9.ViewportSize.X - 20) else 600
local v33 = if not v5 then math.min(400, t1.value9.ViewportSize.Y * 0.5) else 450
RunService6 = Instance.new("Frame")
RunService6.Size = UDim2.new(0, v32, 0, v33)
RunService6.Position = UDim2.new(0.5, -v32 / 2, 0.5, -v33 / 2)
RunService6.BackgroundColor3 = RunService0.Background
RunService6.BorderSizePixel = 0
RunService6.Active = true
RunService6.Visible = false
RunService6.ZIndex = 10
RunService6.Parent = RunService5
local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = RunService6
local UIStroke = Instance.new("UIStroke")

UIStroke.Color = RunService0.Border
UIStroke.Thickness = 1
UIStroke.Parent = RunService6
RunService7 = Instance.new("UIScale")
RunService7.Scale = 0.88
RunService7.Parent = RunService6
function RunService8()
    RunService6.Visible = true
    RunService7.Scale = 0.88
    RunService2(RunService7, RunService1.OpenTime, {
        Scale = 1
    }):Play()
end
function RunService9()
    local v96 = RunService2(RunService7, RunService1.CloseTime, {
        Scale = 0.88
    })

    v96:Play()
    v96.Completed:Connect(function()
        if RunService6 then
            RunService6.Visible = false
        end
    end)
end
local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(1, 0, 0, 30)
Frame.BackgroundColor3 = RunService0.Surface
Frame.BorderSizePixel = 0
Frame.ZIndex = 11
Frame.Parent = RunService6
local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 4)
UICorner2.Parent = Frame
local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(0, 250, 0, 20)
TextLabel.Position = UDim2.new(0, 10, 0, 5)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "OISHI HUB V1.02"
TextLabel.Font = RunService0.Font
TextLabel.TextSize = 12
TextLabel.TextColor3 = RunService0.Accent
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.ZIndex = 12
TextLabel.Parent = Frame
local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(0, 20, 0, 20)
TextButton.Position = UDim2.new(1, -25, 0, 5)
TextButton.BackgroundColor3 = RunService0.SurfaceLight
TextButton.BorderSizePixel = 1
TextButton.BorderColor3 = RunService0.Border
TextButton.Text = "X"
TextButton.Font = RunService0.Font
TextButton.TextSize = 10
TextButton.TextColor3 = RunService0.Text
TextButton.ZIndex = 12
TextButton.AutoButtonColor = false
TextButton.Parent = Frame
local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 3)
UICorner3.Parent = TextButton
TextButton.MouseButton1Click:Connect(function()
    RunService9()
end)

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.new(1, 0, 0, 26)
Frame2.Position = UDim2.new(0, 0, 0, 30)
Frame2.BackgroundColor3 = RunService0.Surface
Frame2.BorderSizePixel = 0
Frame2.ZIndex = 11
Frame2.Parent = RunService6
local t3 = {
    {
        name = "Main"
    },
    {
        name = "Ragebot"
    },
    {
        name = "ESP"
    },
    {
        name = "Visual"
    },
    {
        name = "Misc"
    },
    {
        name = "Animation"
    },
    {
        name = "Config"
    }
}
t1.value20 = "Main"
t1.value21 = {}
t1.value22 = {}
local Frame3 = Instance.new("Frame")

Frame3.Size = UDim2.new(1, 0, 1, -56)
Frame3.Position = UDim2.new(0, 0, 0, 56)
Frame3.BackgroundTransparency = 1
Frame3.BorderSizePixel = 0
Frame3.ClipsDescendants = true
Frame3.ZIndex = 11
Frame3.Parent = RunService6
local Frame4 = Instance.new("Frame")

Frame4.Size = UDim2.new(0.5, -1, 1, 0)
Frame4.Position = UDim2.new(0, 0, 0, 0)
Frame4.BackgroundColor3 = RunService0.Background
Frame4.BorderSizePixel = 0
Frame4.ZIndex = 11
Frame4.Parent = Frame3
local Frame5 = Instance.new("Frame")

Frame5.Size = UDim2.new(0.5, -1, 1, 0)
Frame5.Position = UDim2.new(0.5, 1, 0, 0)
Frame5.BackgroundColor3 = RunService0.Surface
Frame5.BorderSizePixel = 0
Frame5.ZIndex = 11
Frame5.Parent = Frame3
for i, v in ipairs(t3) do
    local v48 = v
    local TextButton2 = Instance.new("TextButton")

    TextButton2.Size = UDim2.new(0.14285714285714, -1, 0, 22)
    TextButton2.Position = UDim2.new((i - 1) * 0.14285714285714, 0.5, 0, 2)
    TextButton2.BackgroundColor3 = v48.name == t1.value20 and RunService0.TabActive or RunService0.TabInactive
    TextButton2.BackgroundTransparency = v48.name ~= t1.value20 and 0.5 or 0.3
    TextButton2.BorderSizePixel = 1
    TextButton2.BorderColor3 = RunService0.Border
    TextButton2.Text = v48.name
    TextButton2.Font = RunService0.Font
    TextButton2.TextSize = 7
    TextButton2.TextColor3 = v48.name == t1.value20 and Color3.new(1, 1, 1) or RunService0.Text
    TextButton2.ZIndex = 12
    TextButton2.AutoButtonColor = false
    TextButton2.Parent = Frame2
    t1.value21[v48.name] = TextButton2

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 2
    ScrollingFrame.ScrollBarImageColor3 = RunService0.Accent
    ScrollingFrame.ScrollBarImageTransparency = 0.3
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    ScrollingFrame.ZIndex = 12
    ScrollingFrame.Visible = v48.name == t1.value20
    ScrollingFrame.Parent = Frame4

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.Parent = ScrollingFrame

    local ScrollingFrame2 = Instance.new("ScrollingFrame")

    ScrollingFrame2.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame2.BackgroundTransparency = 1
    ScrollingFrame2.BorderSizePixel = 0
    ScrollingFrame2.ScrollBarThickness = 2
    ScrollingFrame2.ScrollBarImageColor3 = RunService0.Accent
    ScrollingFrame2.ScrollBarImageTransparency = 0.3
    ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 400)
    ScrollingFrame2.ZIndex = 12
    ScrollingFrame2.Visible = v48.name == t1.value20
    ScrollingFrame2.Parent = Frame5

    local UIListLayout2 = Instance.new("UIListLayout")

    UIListLayout2.Padding = UDim.new(0, 6)
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Parent = ScrollingFrame2

    local UIPadding2 = Instance.new("UIPadding")

    UIPadding2.PaddingTop = UDim.new(0, 10)
    UIPadding2.PaddingLeft = UDim.new(0, 10)
    UIPadding2.PaddingRight = UDim.new(0, 10)
    UIPadding2.PaddingBottom = UDim.new(0, 10)
    UIPadding2.Parent = ScrollingFrame2
    t1.value22[v48.name] = {
        leftScroll = ScrollingFrame,
        rightScroll = ScrollingFrame2,
        leftLayout = UIListLayout,
        rightLayout = UIListLayout2
    }
    TextButton2.MouseButton1Click:Connect(function()
        if t1.value20 == v48.name then
            return
        end

        local value20 = t1.value20

        t1.value20 = v48.name

        for k, v3 in pairs(t1.value21) do
            if k == v48.name then
                local value12 = RunService2
                local TabTime = RunService1.TabTime
                local TabActive = RunService0.TabActive
                local color3_19 = Color3.new(1, 1, 1)

                value12(v3, TabTime, {
                    BackgroundColor3 = TabActive,
                    BackgroundTransparency = 0.3,
                    TextColor3 = color3_19
                }):Play()
            else
                local value12 = RunService2
                local TabTime = RunService1.TabTime
                local TabInactive = RunService0.TabInactive
                local value10Text = RunService0.Text

                value12(v3, TabTime, {
                    BackgroundColor3 = TabInactive,
                    BackgroundTransparency = 0.5,
                    TextColor3 = value10Text
                }):Play()
            end
        end

        t1.value22[value20].leftScroll.Visible = false
        t1.value22[value20].rightScroll.Visible = false
        t1.value22[v48.name].leftScroll.Visible = true
        t1.value22[v48.name].rightScroll.Visible = true
    end)
end
local function v56(p5, p6, p7, p8, p9, p10)
    local Frame6 = Instance.new("Frame")

    Frame6.Size = UDim2.new(1, 0, 0, 44)
    Frame6.BackgroundColor3 = RunService0.SurfaceLight
    Frame6.BorderSizePixel = 1
    Frame6.BorderColor3 = RunService0.Border
    Frame6.Active = true
    Frame6.ZIndex = 16
    Frame6.Parent = p5.container

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Size = UDim2.new(0.55, 0, 0, 14)
    TextLabel2.Position = UDim2.new(0, 8, 0, 5)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = p6
    TextLabel2.Font = RunService0.FontMedium
    TextLabel2.TextSize = 8
    TextLabel2.TextColor3 = RunService0.Text
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.ZIndex = 17
    TextLabel2.Parent = Frame6

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Size = UDim2.new(0.3, 0, 0, 14)
    TextLabel3.Position = UDim2.new(0.65, -5, 0, 5)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = tostring(p9)
    TextLabel3.Font = RunService0.FontMedium
    TextLabel3.TextSize = 8
    TextLabel3.TextColor3 = RunService0.Accent
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel3.ZIndex = 17
    TextLabel3.Parent = Frame6

    local Frame7 = Instance.new("Frame")

    Frame7.Size = UDim2.new(1, -24, 0, 4)
    Frame7.Position = UDim2.new(0, 12, 0, 28)
    Frame7.BackgroundColor3 = RunService0.Surface
    Frame7.BorderSizePixel = 1
    Frame7.BorderColor3 = RunService0.Border
    Frame7.Active = true
    Frame7.ZIndex = 17
    Frame7.Parent = Frame6

    local UICorner4 = Instance.new("UICorner")

    UICorner4.CornerRadius = UDim.new(0, 2)
    UICorner4.Parent = Frame7

    local v119 = math.clamp((p9 - p7) / (p8 - p7), 0, 1)
    local Frame8 = Instance.new("Frame")

    Frame8.Size = UDim2.new(v119, 0, 1, 0)
    Frame8.BackgroundColor3 = RunService0.Accent
    Frame8.BorderSizePixel = 0
    Frame8.ZIndex = 18
    Frame8.Parent = Frame7

    local UICorner5 = Instance.new("UICorner")

    UICorner5.CornerRadius = UDim.new(0, 2)
    UICorner5.Parent = Frame8

    local TextButton3 = Instance.new("TextButton")

    TextButton3.Size = UDim2.new(0, 14, 0, 14)
    TextButton3.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton3.Position = UDim2.new(v119, 0, 0.5, 0)
    TextButton3.BackgroundColor3 = Color3.new(1, 1, 1)
    TextButton3.BorderSizePixel = 1
    TextButton3.BorderColor3 = RunService0.Border
    TextButton3.Text = ""
    TextButton3.AutoButtonColor = false
    TextButton3.Active = true
    TextButton3.ZIndex = 20
    TextButton3.Parent = Frame7

    local UICorner6 = Instance.new("UICorner")

    UICorner6.CornerRadius = UDim.new(0, 2)
    UICorner6.Parent = TextButton3

    local u124 = false

    local function v125(p11)
        local v519 = math.clamp((p11.Position.X - Frame7.AbsolutePosition.X) / Frame7.AbsoluteSize.X, 0, 1)
        local v520 = (p8 - p7) * v519
        local v521 = p7 + v520
        local v522 = if not (p8 - p7 <= 1) then math.floor(v521) else math.floor(v521 * 1000) / 1000
        local v523 = math.clamp((v522 - p7) / (p8 - p7), 0, 1)

        Frame8.Size = UDim2.new(v523, 0, 1, 0)
        TextButton3.Position = UDim2.new(v523, 0, 0.5, 0)
        TextLabel3.Text = tostring(v522)

        if p10 then
            p10(v522)
        end
    end
    local function v126(p12)
        if p12.UserInputType == Enum.UserInputType.MouseButton1 or p12.UserInputType == Enum.UserInputType.Touch then
            u124 = true
            v125(p12)
        end
    end

    Frame7.InputBegan:Connect(v126)
    TextButton3.InputBegan:Connect(v126)

    local connection = t1.value2.InputChanged:Connect(function(input)
        if not u124 then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            v125(input)
        end
    end)
    local connection2 = t1.value2.InputEnded:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        end
    end)

    Frame6.Destroying:Connect(function()
        connection:Disconnect()
        connection2:Disconnect()
    end)

    return Frame6
end
function t1.value23(p13, p14)
    local Frame9 = Instance.new("Frame")

    Frame9.Size = UDim2.new(1, 0, 0, 0)
    Frame9.BackgroundTransparency = 1
    Frame9.BorderSizePixel = 0
    Frame9.ClipsDescendants = true
    Frame9.ZIndex = 15
    Frame9.Visible = p14 or false
    Frame9.Parent = p13

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame9

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 2)
    UIPadding.Parent = Frame9

    local u134 = p14 or false

    local function v135()
        local AbsoluteContentSizeY = UIListLayout.AbsoluteContentSize.Y

        if u134 and AbsoluteContentSizeY > 0 then
            Frame9.Visible = true
            RunService2(Frame9, RunService1.CollapseTime, {
                Size = UDim2.new(1, 0, 0, AbsoluteContentSizeY + 4)
            }):Play()
        else
            RunService2(Frame9, RunService1.CollapseTime, {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            task.delay(RunService1.CollapseTime, function()
                if not u134 then
                    Frame9.Visible = false
                end
            end)
        end

        task.spawn(function()
            local Frame9Parent = Frame9.Parent

            while Frame9Parent do
                if Frame9Parent:IsA("ScrollingFrame") then
                    local UIListLayout3 = Frame9Parent:FindFirstChildOfClass("UIListLayout")

                    if not UIListLayout3 then
                        return
                    end

                    Frame9Parent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout3.AbsoluteContentSize.Y + 20)

                    return
                end

                Frame9Parent = Frame9Parent.Parent
            end
        end)
    end

    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if u134 then
            v135()
        end
    end)
    task.spawn(function()
        task.wait(0.1)
        v135()
    end)

    return {
        container = Frame9,
        layout = UIListLayout,
        setOpen = function(p15)
        u134 = p15
        v135()
    end,
        isOpen = function()
        return u134
    end
    }
end
local function v57(p16, p17, p18, p19, p20, p21)
    local v142 = t1.value22[p16]
    if not v142 then
        return
    end
    local v143 = p20 == "right" and v142.rightScroll or v142.leftScroll
    local v144 = p20 == "right" and v142.rightLayout or v142.leftLayout
    local Frame10 = Instance.new("Frame")
    Frame10.Size = UDim2.new(1, 0, 0, 34)
    Frame10.BackgroundTransparency = 1
    Frame10.BorderSizePixel = 0
    Frame10.ZIndex = 12
    Frame10.Parent = v143
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame10
    local Frame11 = Instance.new("Frame")
    Frame11.Size = UDim2.new(1, 0, 0, 34)
    Frame11.BackgroundColor3 = RunService0.Surface
    Frame11.BorderSizePixel = 1
    Frame11.BorderColor3 = RunService0.Border
    Frame11.ZIndex = 12
    Frame11.Parent = Frame10
    local TextLabel4 = Instance.new("TextLabel")
    TextLabel4.Size = UDim2.new(0.65, 0, 0, 14)
    TextLabel4.Position = UDim2.new(0, 8, 0, 10)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = p17
    TextLabel4.Font = RunService0.FontMedium
    TextLabel4.TextSize = 8
    TextLabel4.TextColor3 = RunService0.Text
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel4.ZIndex = 13
    TextLabel4.Parent = Frame11
    local TextButton4 = Instance.new("TextButton")
    TextButton4.Size = UDim2.new(0, 32, 0, 18)
    TextButton4.Position = UDim2.new(1, -40, 0, 8)
    local v150 = p18
    if p18 then
        v150 = RunService0.ToggleOn
    end
    TextButton4.BackgroundColor3 = v150 or RunService0.ToggleOff
    TextButton4.BorderSizePixel = 1
    TextButton4.BorderColor3 = RunService0.Border
    TextButton4.Text = ""
    TextButton4.AutoButtonColor = false
    TextButton4.ZIndex = 13
    TextButton4.Parent = Frame11
    local UICorner7 = Instance.new("UICorner")
    UICorner7.CornerRadius = UDim.new(0, 3)
    UICorner7.Parent = TextButton4
    local Frame12 = Instance.new("Frame")
    Frame12.Size = UDim2.new(0, 12, 0, 12)
    Frame12.Position = p18 and UDim2.new(0, 17, 0, 3) or UDim2.new(0, 3, 0, 3)
    Frame12.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame12.BorderSizePixel = 0
    Frame12.ZIndex = 14
    Frame12.Parent = TextButton4
    local UICorner8 = Instance.new("UICorner")
    UICorner8.CornerRadius = UDim.new(0, 3)
    UICorner8.Parent = Frame12
    local u154 = p18 or false
    local u155
    if p21 then
        u155 = t1.value23(Frame10, u154)
    end
    local function v156()
        if u154 then
            TextButton4.BackgroundColor3 = RunService0.ToggleOn
            Frame12.Position = UDim2.new(0, 17, 0, 3)

            return
        end

        TextButton4.BackgroundColor3 = RunService0.ToggleOff
        Frame12.Position = UDim2.new(0, 3, 0, 3)
    end
    v156()
    TextButton4.MouseButton1Click:Connect(function()
        u154 = not u154
        v156()

        if u155 then
            u155.setOpen(u154)
        end

        task.spawn(function()
            task.wait(RunService1.CollapseTime)
            Frame10.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y)
            v143.CanvasSize = UDim2.new(0, 0, 0, v144.AbsoluteContentSize.Y + 20)
        end)

        if p19 then
            p19(u154)
        end
    end)
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Frame10.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y)
        v143.CanvasSize = UDim2.new(0, 0, 0, v144.AbsoluteContentSize.Y + 20)
    end)
    task.spawn(function()
        task.wait(0.1)
        Frame10.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y)
        v143.CanvasSize = UDim2.new(0, 0, 0, v144.AbsoluteContentSize.Y + 20)
    end)
    if p21 then
        local v157 = u155

        return {
            toggle = Frame11,
            collapsible = v157,
            mainContainer = Frame10,
            setState = function(p22)
            u154 = p22
            v156()

            if u155 then
                u155.setOpen(p22)
            end
        end
        }
    end

    return {
        setState = function(p23)
        u154 = p23
        v156()
    end
    }
end
local function v58(p24, p25, p26)
    local v161 = t1.value22[p24]

    if not v161 then
        return
    end

    local leftScroll = v161.leftScroll
    local Frame13 = Instance.new("Frame")

    Frame13.Size = UDim2.new(1, 0, 0, 45)
    Frame13.BackgroundColor3 = RunService0.Surface
    Frame13.BorderSizePixel = 1
    Frame13.BorderColor3 = RunService0.Border
    Frame13.ZIndex = 12
    Frame13.Parent = leftScroll

    local UICorner9 = Instance.new("UICorner")

    UICorner9.CornerRadius = UDim.new(0, 4)
    UICorner9.Parent = Frame13

    local TextButton5 = Instance.new("TextButton")

    TextButton5.Size = UDim2.new(1, -20, 0, 35)
    TextButton5.Position = UDim2.new(0, 10, 0, 5)
    TextButton5.BackgroundColor3 = RunService0.SurfaceLight
    TextButton5.BorderSizePixel = 1
    TextButton5.BorderColor3 = RunService0.Border
    TextButton5.Text = p25
    TextButton5.Font = RunService0.Font
    TextButton5.TextSize = 10
    TextButton5.TextColor3 = RunService0.Text
    TextButton5.AutoButtonColor = false
    TextButton5.ZIndex = 13
    TextButton5.Parent = Frame13

    local UICorner10 = Instance.new("UICorner")

    UICorner10.CornerRadius = UDim.new(0, 3)
    UICorner10.Parent = TextButton5

    local u167 = false

    local function v168()
        if u167 then
            TextButton5.BackgroundColor3 = RunService0.ToggleOn
            TextButton5.TextColor3 = Color3.new(1, 1, 1)

            return
        end

        TextButton5.BackgroundColor3 = RunService0.SurfaceLight
        TextButton5.TextColor3 = RunService0.Text
    end

    v168()
    TextButton5.MouseButton1Click:Connect(function()
        u167 = not u167
        v168()

        if p26 then
            p26(u167)
        end
    end)
    TextButton5.MouseEnter:Connect(function()
        if not u167 then
            RunService2(TextButton5, RunService1.HoverTime, {
                BackgroundColor3 = RunService0.HoverSurface
            }):Play()
        end
    end)
    TextButton5.MouseLeave:Connect(function()
        if not u167 then
            RunService2(TextButton5, RunService1.HoverTime, {
                BackgroundColor3 = RunService0.SurfaceLight
            }):Play()
        end
    end)

    return {
        setState = function(p27)
        u167 = p27
        v168()
    end
    }
end
local function v59(p28, p29, p30, p31)
    local t4 = {
        value1 = p29,
        value2 = p30,
        value3 = p31
    }
    local Frame14 = Instance.new("Frame")

    Frame14.Size = UDim2.new(1, 0, 0, 34)
    Frame14.BackgroundColor3 = RunService0.SurfaceLight
    Frame14.BorderSizePixel = 1
    Frame14.BorderColor3 = RunService0.Border
    Frame14.ZIndex = 16
    Frame14.Parent = p28.container

    local TextLabel5 = Instance.new("TextLabel")

    TextLabel5.Size = UDim2.new(0.5, 0, 0, 24)
    TextLabel5.Position = UDim2.new(0, 8, 0, 5)
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = t4.value1
    TextLabel5.Font = RunService0.FontMedium
    TextLabel5.TextSize = 8
    TextLabel5.TextColor3 = RunService0.Text
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel5.ZIndex = 17
    TextLabel5.Parent = Frame14
    t4.value4 = Instance.new("TextButton")
    t4.value4.Size = UDim2.new(0, 24, 0, 24)
    t4.value4.Position = UDim2.new(1, -32, 0, 5)
    t4.value4.BackgroundColor3 = t4.value2 or Color3.fromRGB(255, 0, 0)
    t4.value4.BorderSizePixel = 1
    t4.value4.BorderColor3 = RunService0.Border
    t4.value4.Text = ""
    t4.value4.AutoButtonColor = false
    t4.value4.ZIndex = 17
    t4.value4.Parent = Frame14

    local UICorner11 = Instance.new("UICorner")

    UICorner11.CornerRadius = UDim.new(0, 3)
    UICorner11.Parent = t4.value4
    t4.value5 = nil
    t4.value4.MouseButton1Click:Connect(function()
        if t4.value5 then
            t4.value5:Destroy()
            t4.value5 = nil

            return
        end

        local Frame15 = Instance.new("Frame")

        t4.value5 = Frame15

        local ViewportSize = t1.value9.ViewportSize
        local v534 = t4.value4.AbsolutePosition.X - 180
        local v535 = t4.value4.AbsolutePosition.Y - 255 - 5
        local v536 = math.clamp(v534, 5, ViewportSize.X - 210 - 5)
        local v537 = math.clamp(v535, 5, ViewportSize.Y - 255 - 5)

        Frame15.Size = UDim2.new(0, 210, 0, 255)
        Frame15.Position = UDim2.new(0, v536, 0, v537)
        Frame15.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        Frame15.BorderSizePixel = 1
        Frame15.BorderColor3 = RunService0.Border
        Frame15.ZIndex = 9999
        Frame15.Parent = RunService5

        local UICorner12 = Instance.new("UICorner")

        UICorner12.CornerRadius = UDim.new(0, 4)
        UICorner12.Parent = Frame15

        local TextLabel6 = Instance.new("TextLabel")

        TextLabel6.Size = UDim2.new(1, -50, 0, 25)
        TextLabel6.Position = UDim2.new(0, 10, 0, 3)
        TextLabel6.BackgroundTransparency = 1
        TextLabel6.Text = t4.value1
        TextLabel6.Font = RunService0.Font
        TextLabel6.TextSize = 10
        TextLabel6.TextColor3 = RunService0.Text
        TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel6.ZIndex = 10001
        TextLabel6.Parent = Frame15

        local TextButton6 = Instance.new("TextButton")

        TextButton6.Size = UDim2.new(0, 20, 0, 20)
        TextButton6.Position = UDim2.new(1, -25, 0, 5)
        TextButton6.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        TextButton6.BorderSizePixel = 1
        TextButton6.BorderColor3 = RunService0.Border
        TextButton6.Text = "×"
        TextButton6.Font = RunService0.Font
        TextButton6.TextSize = 12
        TextButton6.TextColor3 = RunService0.Text
        TextButton6.ZIndex = 10002
        TextButton6.AutoButtonColor = false
        TextButton6.Parent = Frame15
        TextButton6.MouseButton1Click:Connect(function()
            Frame15:Destroy()
        end)

        local ImageButton = Instance.new("ImageButton")

        ImageButton.Size = UDim2.new(0, 160, 0, 160)
        ImageButton.Position = UDim2.new(0.5, -80, 0, 30)
        ImageButton.BackgroundTransparency = 1
        ImageButton.BorderSizePixel = 0
        ImageButton.AutoButtonColor = false
        ImageButton.ZIndex = 10000
        ImageButton.Image = "rbxassetid://6020299385"
        ImageButton.ScaleType = Enum.ScaleType.Fit
        ImageButton.Parent = Frame15

        local Frame16 = Instance.new("Frame")

        Frame16.Size = UDim2.new(0, 38, 0, 38)
        Frame16.Position = UDim2.new(0.5, -19, 0.5, -19)
        Frame16.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame16.BorderSizePixel = 0
        Frame16.ZIndex = 10001
        Frame16.Parent = ImageButton

        local UICorner13 = Instance.new("UICorner")

        UICorner13.CornerRadius = UDim.new(1, 0)
        UICorner13.Parent = Frame16

        local Frame17 = Instance.new("Frame")

        Frame17.Size = UDim2.new(0, 12, 0, 12)
        Frame17.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame17.Position = UDim2.new(0.5, 0, 0.5, 0)
        Frame17.BackgroundColor3 = Color3.new(1, 1, 1)
        Frame17.BorderSizePixel = 1
        Frame17.BorderColor3 = RunService0.Border
        Frame17.ZIndex = 10005
        Frame17.Parent = ImageButton

        local UICorner14 = Instance.new("UICorner")

        UICorner14.CornerRadius = UDim.new(1, 0)
        UICorner14.Parent = Frame17

        local TextLabel7 = Instance.new("TextLabel")

        TextLabel7.Size = UDim2.new(1, -20, 0, 20)
        TextLabel7.Position = UDim2.new(0, 10, 0, 193)
        TextLabel7.BackgroundTransparency = 1
        TextLabel7.Text = string.format("RGB: %d, %d, %d", math.floor(t4.value2.R * 255), math.floor(t4.value2.G * 255), (math.floor(t4.value2.B * 255)))
        TextLabel7.Font = RunService0.FontMedium
        TextLabel7.TextSize = 8
        TextLabel7.TextColor3 = RunService0.Text
        TextLabel7.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel7.ZIndex = 10001
        TextLabel7.Parent = Frame15

        local color3_20 = Color3.fromRGB(255, 0, 0)
        local color3_21 = Color3.fromRGB(255, 128, 0)
        local color3_22 = Color3.fromRGB(255, 255, 0)
        local color3_23 = Color3.fromRGB(0, 255, 0)
        local color3_24 = Color3.fromRGB(0, 255, 255)
        local color3_25 = Color3.fromRGB(0, 128, 255)
        local color3_26 = Color3.fromRGB(0, 0, 255)
        local color3_27 = Color3.fromRGB(128, 0, 255)
        local color3_28 = Color3.fromRGB(255, 0, 255)
        local color3_29 = Color3.fromRGB(255, 255, 255)
        local t5 = { Color3.fromRGB(0, 0, 0) }
        local t6 = {
            color3_20,
            color3_21,
            color3_22,
            color3_23,
            color3_24,
            color3_25,
            color3_26,
            color3_27,
            color3_28,
            color3_29,
            v2(t5)
        }

        local function v559(p32)
            t4.value4.BackgroundColor3 = p32
            TextLabel7.Text = string.format("RGB: %d, %d, %d", math.floor(p32.R * 255), math.floor(p32.G * 255), (math.floor(p32.B * 255)))

            local v917, v918 = p32:ToHSV()
            local v919 = 80 * v918
            local v920 = v917 * 3.141592653589793 * 2

            Frame17.Position = UDim2.new(0.5, math.cos(v920) * v919, 0.5, math.sin(v920) * v919)

            if t4.value3 then
                t4.value3(p32)
            end
        end

        for i, v in ipairs(t6) do
            local v562 = v
            local TextButton7 = Instance.new("TextButton")

            TextButton7.Size = UDim2.new(0, 14, 0, 14)
            TextButton7.Position = UDim2.new(0, 8 + (i - 1) * 18, 0, 218)
            TextButton7.BackgroundColor3 = v562
            TextButton7.BorderSizePixel = 1
            TextButton7.BorderColor3 = RunService0.Border
            TextButton7.Text = ""
            TextButton7.AutoButtonColor = false
            TextButton7.ZIndex = 10002
            TextButton7.Parent = Frame15

            local UICorner15 = Instance.new("UICorner")

            UICorner15.CornerRadius = UDim.new(1, 0)
            UICorner15.Parent = TextButton7
            TextButton7.MouseButton1Click:Connect(function()
                v559(v562)
            end)
        end

        local u565 = false

        local function v566(p33)
            local AbsolutePosition = ImageButton.AbsolutePosition
            local AbsoluteSize = ImageButton.AbsoluteSize
            local v924 = AbsolutePosition.X + AbsoluteSize.X / 2
            local v925 = AbsolutePosition.Y + AbsoluteSize.Y / 2
            local v926 = p33.Position.X - v924
            local v927 = p33.Position.Y - v925
            local v928 = math.sqrt(v926 * v926 + v927 * v927)
            local v929 = AbsoluteSize.X / 2

            if v929 < v928 then
                local v930 = v929 / v928

                v928 = v929
                v926 *= v930
                v927 *= v930
            end

            local v931 = math.atan2(v927, v926) / 6.283185307179586

            if v931 < 0 then
                v931 += 1
            end

            local v932 = math.clamp(v928 / v929, 0, 1)
            local color3_30 = Color3.fromHSV(v931, v932, 1)

            t4.value4.BackgroundColor3 = color3_30
            TextLabel7.Text = string.format("RGB: %d, %d, %d", math.floor(color3_30.R * 255), math.floor(color3_30.G * 255), (math.floor(color3_30.B * 255)))
            Frame17.Position = UDim2.new(0.5, v926, 0.5, v927)

            if t4.value3 then
                t4.value3(color3_30)
            end
        end

        ImageButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                u565 = true
                v566(input)
            end
        end)

        local connection = t1.value2.InputChanged:Connect(function(input)
            if not u565 then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                v566(input)
            end
        end)
        local connection3 = t1.value2.InputEnded:Connect(function(input)
            if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            end
        end)

        Frame15.Destroying:Connect(function()
            connection:Disconnect()
            connection3:Disconnect()

            if t4.value5 ~= Frame15 then
            end
        end)
    end)

    return Frame14
end
local function v60(p34, p35, p36, p37, p38)
    local Frame18 = Instance.new("Frame")
    Frame18.Size = UDim2.new(1, 0, 0, 34)
    Frame18.BackgroundColor3 = RunService0.SurfaceLight
    Frame18.BorderSizePixel = 1
    Frame18.BorderColor3 = RunService0.Border
    Frame18.ZIndex = 30
    Frame18.Parent = p34.container
    local TextLabel8 = Instance.new("TextLabel")
    TextLabel8.Size = UDim2.new(0.45, 0, 1, 0)
    TextLabel8.Position = UDim2.new(0, 8, 0, 0)
    TextLabel8.BackgroundTransparency = 1
    TextLabel8.Text = p35
    TextLabel8.Font = RunService0.FontMedium
    TextLabel8.TextSize = 8
    TextLabel8.TextColor3 = RunService0.Text
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel8.ZIndex = 31
    TextLabel8.Parent = Frame18
    if not p37 then
        p37 = p36[1]
    end
    local u184 = p37
    local TextButton8 = Instance.new("TextButton")
    TextButton8.Size = UDim2.new(0, 105, 0, 24)
    TextButton8.Position = UDim2.new(1, -113, 0, 5)
    TextButton8.BackgroundColor3 = RunService0.SurfaceLight
    TextButton8.BorderSizePixel = 1
    TextButton8.BorderColor3 = RunService0.Border
    TextButton8.Text = tostring(u184)
    TextButton8.Font = RunService0.FontMedium
    TextButton8.TextSize = 8
    TextButton8.TextColor3 = RunService0.Text
    TextButton8.AutoButtonColor = false
    TextButton8.ZIndex = 32
    TextButton8.Parent = Frame18
    local UICorner16 = Instance.new("UICorner")
    UICorner16.CornerRadius = UDim.new(0, 3)
    UICorner16.Parent = TextButton8
    local TextLabel9 = Instance.new("TextLabel")
    TextLabel9.Size = UDim2.new(0, 20, 1, 0)
    TextLabel9.Position = UDim2.new(1, -22, 0, 0)
    TextLabel9.BackgroundTransparency = 1
    TextLabel9.Text = "▼"
    TextLabel9.Font = RunService0.Font
    TextLabel9.TextSize = 7
    TextLabel9.TextColor3 = RunService0.Text
    TextLabel9.ZIndex = 33
    TextLabel9.Parent = TextButton8
    local u188 = false
    local u189
    local function v190()
        if u189 then
            u189:Destroy()
            u189 = nil
        end

        u188 = false
        RunService2(TextLabel9, RunService1.DropdownTime, {
            Rotation = 0
        }):Play()
    end
    TextButton8.MouseButton1Click:Connect(function()
        if u188 then
            v190()

            return
        end

        u188 = true
        RunService2(TextLabel9, RunService1.DropdownTime, {
            Rotation = 180
        }):Play()
        u189 = Instance.new("Frame")
        u189.Size = UDim2.new(0, 200, 0, 0)
        u189.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        u189.BorderSizePixel = 1
        u189.BorderColor3 = RunService0.Border
        u189.ClipsDescendants = true
        u189.ZIndex = 9999
        u189.Parent = RunService5

        local UICorner17 = Instance.new("UICorner")

        UICorner17.CornerRadius = UDim.new(0, 4)
        UICorner17.Parent = u189

        local AbsolutePosition = TextButton8.AbsolutePosition
        local AbsoluteSize = TextButton8.AbsoluteSize
        local ViewportSize = t1.value9.ViewportSize
        local _math = math
        local v574 = #p36 * 30
        local v575 = _math.min(v574, 250)
        local AbsolutePositionX = AbsolutePosition.X
        local v577 = AbsolutePosition.Y + AbsoluteSize.Y + 5

        if v577 + v575 > ViewportSize.Y - 10 then
            v577 = AbsolutePosition.Y - v575 - 5
        end

        if AbsolutePositionX + 200 > ViewportSize.X - 10 then
            AbsolutePositionX = ViewportSize.X - 210
        end

        if AbsolutePositionX < 10 then
            AbsolutePositionX = 10
        end

        if v577 < 10 then
            v577 = 10
        end

        u189.Position = UDim2.new(0, AbsolutePositionX, 0, v577)
        RunService2(u189, RunService1.DropdownTime, {
            Size = UDim2.new(0, 200, 0, v575)
        }):Play()

        local ScrollingFrame = Instance.new("ScrollingFrame")

        ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
        ScrollingFrame.BackgroundTransparency = 1
        ScrollingFrame.BorderSizePixel = 0
        ScrollingFrame.ScrollBarThickness = 2
        ScrollingFrame.ScrollBarImageColor3 = RunService0.Accent
        ScrollingFrame.ScrollBarImageTransparency = 0.3
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, v574)
        ScrollingFrame.ZIndex = 10000
        ScrollingFrame.Parent = u189

        local UIListLayout = Instance.new("UIListLayout")

        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = ScrollingFrame

        for _, v in ipairs(p36) do
            local v582 = v
            local TextButton9 = Instance.new("TextButton")

            TextButton9.Size = UDim2.new(1, -8, 0, 30 - 4)
            TextButton9.Position = UDim2.new(0, 4, 0, 0)
            TextButton9.BackgroundColor3 = v582 == u184 and RunService0.Accent or Color3.fromRGB(25, 25, 32)
            TextButton9.BackgroundTransparency = v582 ~= u184 and 0 or 0.3
            TextButton9.BorderSizePixel = 1
            TextButton9.BorderColor3 = RunService0.Border
            TextButton9.Text = tostring(v582)
            TextButton9.Font = RunService0.FontMedium
            TextButton9.TextSize = 8
            TextButton9.TextColor3 = v582 == u184 and Color3.new(1, 1, 1) or RunService0.Text
            TextButton9.AutoButtonColor = false
            TextButton9.ZIndex = 10001
            TextButton9.Parent = ScrollingFrame

            local UICorner18 = Instance.new("UICorner")

            UICorner18.CornerRadius = UDim.new(0, 3)
            UICorner18.Parent = TextButton9
            TextButton9.MouseEnter:Connect(function()
                if v582 ~= u184 then
                    RunService2(TextButton9, 0.1, {
                        BackgroundColor3 = RunService0.HoverSurface,
                        BackgroundTransparency = 0.2
                    }):Play()
                end
            end)
            TextButton9.MouseLeave:Connect(function()
                if v582 ~= u184 then
                    RunService2(TextButton9, 0.1, {
                        BackgroundColor3 = Color3.fromRGB(25, 25, 32),
                        BackgroundTransparency = 0
                    }):Play()
                end
            end)
            TextButton9.MouseButton1Click:Connect(function()
                u184 = v582
                TextButton8.Text = tostring(v582)

                if p38 then
                    p38(v582)
                end

                v190()
            end)
        end
    end)
    t1.value2.InputBegan:Connect(function(input)
        if u188 and u189 and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            local inputPosition = input.Position
            local AbsolutePosition = u189.AbsolutePosition
            local AbsoluteSize = u189.AbsoluteSize
            local AbsolutePosition2 = TextButton8.AbsolutePosition
            local AbsoluteSize2 = TextButton8.AbsoluteSize
            local v591 = inputPosition.X >= AbsolutePosition.X

            if v591 then
                v591 = inputPosition.X <= AbsolutePosition.X + AbsoluteSize.X and (inputPosition.Y >= AbsolutePosition.Y and inputPosition.Y <= AbsolutePosition.Y + AbsoluteSize.Y)
            end

            local v592 = inputPosition.X >= AbsolutePosition2.X

            if v592 then
                v592 = inputPosition.X <= AbsolutePosition2.X + AbsoluteSize2.X and (inputPosition.Y >= AbsolutePosition2.Y and inputPosition.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y)
            end

            if not v591 and not v592 then
                v190()
            end
        end
    end)
    Frame18.Destroying:Connect(function()
        v190()
    end)

    return Frame18
end
t1.value24 = false
t1.value25 = nil
t1.value26 = nil
t1.value27 = {
    "PC",
    "Mobile",
    "Controller",
    "VR"
}
function t1.value28(p39)
    local v192 = ({
        PC = "MouseKeyboard",
        Computer = "MouseKeyboard",
        Mobile = "Touch",
        Controller = "Gamepad",
        Console = "Gamepad",
        VR = "VR"
    })[p39]

    if not v192 then
        return
    end

    pcall(function()
        if t1.value4:FindFirstChild("Remotes") and t1.value4.Remotes:FindFirstChild("Replication") then
            t1.value4.Remotes.Replication.Fighter.SetControls:FireServer(v192)
        end
    end)
end
t1.value29 = nil
function t1.value30()
    if t1.value25 then
        t1.value25:Disconnect()
    end
end
t1.value31 = nil
t1.value32 = false
t1.value29 = 70
t1.value31 = nil
function t1.value33()
    if t1.value32 then
        return
    end

    t1.value32 = true
    t1.value31 = t1.value3.RenderStepped:Connect(function()
        if t1.value32 and t1.value9 then
            t1.value9.FieldOfView = t1.value29
        end
    end)
end
function t1.value34()
    t1.value32 = false

    if t1.value31 then
        t1.value31:Disconnect()
        t1.value31 = nil
    end

    if t1.value9 then
        t1.value9.FieldOfView = 70
    end
end
function t1.value35(p40)
    for _, descendant in pairs(t1.value6:GetDescendants()) do
        local v199 = descendant

        if v199:IsA("BasePart") and v199.Parent ~= t1.value8.Character then
            pcall(function()
                if p40 == "Dark Texture" then
                    v199.Material = Enum.Material.Plastic
                    v199.Color = Color3.new(0.1, 0.1, 0.1)

                    return
                end

                if p40 == "Glass Texture" then
                    v199.Material = Enum.Material.Glass
                    v199.Transparency = 0.3

                    return
                end

                if p40 == "Metal Texture" then
                    v199.Material = Enum.Material.Metal
                    v199.Color = Color3.new(0.5, 0.5, 0.5)

                    return
                end

                v199.Material = Enum.Material.Plastic
                v199.Transparency = 0
            end)
        end
    end
end
local value6 = t1.value6
t1.value36 = nil
value6.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("BasePart") and RunService3.WallTextureType ~= "None" then
        task.wait(0.1)
        pcall(function()
            if RunService3.WallTextureType == "Dark Texture" then
                descendant.Material = Enum.Material.Plastic
                descendant.Color = Color3.new(0.1, 0.1, 0.1)

                return
            end

            if RunService3.WallTextureType == "Glass Texture" then
                descendant.Material = Enum.Material.Glass
                descendant.Transparency = 0.3

                return
            end

            if RunService3.WallTextureType == "Metal Texture" then
                descendant.Material = Enum.Material.Metal
                descendant.Color = Color3.new(0.5, 0.5, 0.5)
            end
        end)
    end
end)
t1.value37 = nil
t1.value37 = false
function t1.value38()
    if t1.value37 then
        return
    end

    t1.value37 = true
    pcall(function()
        local Controllers = t1.value8.PlayerScripts.Controllers
        local EnumLibrary = require(t1.value4.Modules:WaitForChild("EnumLibrary", 10))

        if EnumLibrary then
            EnumLibrary:WaitForEnumBuilder()
        end

        local _require = require
        local t7 = { t1.value4.Modules:WaitForChild("CosmeticLibrary", 10) }
        local v628 = _require(v2(t7))
        local _require2 = require
        local t8 = { Controllers:WaitForChild("PlayerDataController", 10) }
        local v631 = _require2(v2(t8))

        local function v632(p41, p42)
            local v939 = p42 or v628.Cosmetics[p41]

            if not v939 then
                return false
            end

            local v940 = v939.Type or ""
            local v941 = v940 == "Skin"

            if not v941 then
                v941 = v940 == "SkinType"

                if not v941 then
                    v941 = v940 == "WeaponSkin"

                    if not v941 then
                        v941 = v940 == "GunSkin"

                        if not v941 then
                            v941 = v940 == "Charm"

                            if not v941 then
                                v941 = v940 == "WeaponCharm"

                                if not v941 then
                                    v941 = v940 == "GunCharm"

                                    if not v941 then
                                        v941 = v940 == "Wrap"

                                        if not v941 then
                                            v941 = v940 == "Wrapping"

                                            if not v941 then
                                                v941 = v940 == "WeaponWrap"

                                                if not v941 then
                                                v941 = v940 == "GunWrap"

                                                if not v941 then
                                                v941 = v940 == "SkinWrap"

                                                if not v941 then
                                                v941 = v940 == "Dance"

                                                if not v941 then
                                                v941 = v940 == "Emote"

                                                if not v941 then
                                                v941 = v940 == "DanceEmote"

                                                if not v941 then
                                                v941 = v940 == "Taunt"

                                                if not v941 then
                                                v941 = v940 == "Finisher"

                                                if not v941 then
                                                v941 = v940 == "KillEffect"

                                                if not v941 then
                                                v941 = v940 == "DeathEffect"

                                                if not v941 then
                                                v941 = v940 == "Execution"

                                                if not v941 then
                                                v941 = v940 == "FinisherMove"

                                                if not v941 then
                                                v941 = v940 == "Special"

                                                if not v941 then
                                                v941 = v940 == "GunFinisher"

                                                if not v941 then
                                                v941 = v940 == "WeaponFinisher"

                                                if not v941 then
                                                v941 = string.lower(p41):find("skin") ~= nil

                                                if not v941 then
                                                v941 = string.lower(p41):find("charm") ~= nil

                                                if not v941 then
                                                v941 = string.lower(p41):find("wrap") ~= nil

                                                if not v941 then
                                                v941 = string.lower(p41):find("wrapping") ~= nil

                                                if not v941 then
                                                v941 = string.lower(p41):find("dance") ~= nil

                                                if not v941 then
                                                v941 = string.lower(p41):find("emote") ~= nil

                                                if not v941 then
                                                v941 = string.lower(p41):find("taunt") ~= nil

                                                if not v941 then
                                                v941 = string.lower(p41):find("finish") ~= nil

                                                if not v941 then
                                                v941 = string.lower(p41):find("kill") ~= nil or (string.lower(p41):find("execution") ~= nil or string.lower(p41):find("special") ~= nil)
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

            return v941
        end

        local OwnsCosmetic = v628.OwnsCosmetic

        function v628.OwnsCosmetic(p43, p44, p45, p46)
            if p45:find("MISSING_") then
                return OwnsCosmetic(p43, p44, p45, p46)
            end

            if v632(p45) then
                return true
            end

            return OwnsCosmetic(p43, p44, p45, p46)
        end

        local Get = v631.Get

        function v631.Get(p47, p48)
            local v948 = Get(p47, p48)

            if p48 == "CosmeticInventory" then
                local t9 = {}

                if v948 then
                    for k, v in pairs(v948) do
                        t9[k] = v
                    end
                end

                return setmetatable(t9, {
                    __index = function(_, p50)
                    if v632(p50) then
                        return true
                    end

                    return nil
                end
                })
            end

            return v948
        end
    end)
end
function t1.value39()
end
t1.value40 = nil
t1.value41 = false
t1.value42 = nil
t1.value43 = Vector3.new(0, -1000, 0)

function t1.value44()
    if t1.value40 then
        return
    end

    t1.value41 = true

    local value4 = t1.value4
    local value8 = t1.value8
    local Gun = require(value8.PlayerScripts.Modules.ItemTypes.Gun)
    local Utility = require(value4.Modules.Utility)
    local self = setmetatable({}, {
        __index = function(_, p52)
        local Character = value8.Character

        if not Character then
            return nil
        end

        if p52 == "root" then
            return Character:FindFirstChild("HumanoidRootPart")
        end

        if p52 == "head" then
            return Character:FindFirstChild("Head")
        end

        return nil
    end
    })

    t1.value40 = {
        Active = true
    }

    local value40 = t1.value40

    function value40.FindTarget(_)
        local Character = value8.Character
        if not Character then
            return nil
        end
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            return nil
        end
        local v641
        local huge = math.huge
        local _next = next
        local v644, v645 = RunService:GetPlayers()
        while true do
            local v646

            v645, v646 = _next(v644, v645)

            if not v645 then
                break
            end

            if v646 ~= value8 and not RunService4(v646) then
                local Character2 = v646.Character

                if Character2 then
                    local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")
                    local Head = Character2:FindFirstChild("Head")
                    local Humanoid = Character2:FindFirstChildWhichIsA("Humanoid")
                    local v651 = HumanoidRootPart2

                    if v651 then
                        v651 = Head

                        if v651 then
                            v651 = Humanoid and Humanoid.Health > 0
                        end
                    end

                    if v651 then
                        local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude

                        if Magnitude < huge then
                            huge = Magnitude
                            v641 = v646
                        end
                    end
                end
            end
        end

        return v641
    end

    value40.Connection = t1.value3.Heartbeat:Connect(function()
        if not value40.Active then
            return
        end

        value40.Target = value40:FindTarget()

        if value40.Target and value40.Target.Character then
            local Head = value40.Target.Character:FindFirstChild("Head")

            if Head then
                local root = self.root

                if root then
                    local rootCFrame = root.CFrame
                    local rootVelocity = root.Velocity
                    local RotVelocity = root.RotVelocity

                    root.CFrame = Head.CFrame
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    t1.value42 = Head.Position
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

                root.CFrame = CFrame.new(t1.value43)
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero
                t1.value42 = t1.value43
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

    value40.OldShootFunc = StartShooting

    function Gun.StartShooting(p54, ...)
        local t10 = { StartShooting(p54, ...) }

        if not p54.ClientFighter or not p54.ClientFighter.IsLocalPlayer then
            return unpack(t10)
        end

        local v664 = t10[3]

        if not v664 or typeof(v664) ~= "table" then
            return unpack(t10)
        end

        t10[4] = true

        local value40Target = value40.Target

        if not value40.Active or (not value40Target or not value40Target.Character) then
            return unpack(t10)
        end

        local Head = value40Target.Character:FindFirstChild("Head")

        if not Head then
            return unpack(t10)
        end

        local HeadPosition = Head.Position
        local v668 = Head.CFrame:ToObjectSpace(CFrame.new(HeadPosition + Vector3.new(math.random() * 0.1, math.random() * 0.1, math.random() * 0.1)))

        v664[utf8.char(0)] = Utility:EncodeCFrame(CFrame.new(HeadPosition, HeadPosition + Head.CFrame.LookVector))
        v664[utf8.char(1)] = Utility:EncodeCFrame(CFrame.new(HeadPosition))
        v664[utf8.char(2)] = Head
        v664[utf8.char(3)] = Utility:EncodeCFrame(v668)

        return unpack(t10)
    end
    function value40.Shutdown(p55)
        p55.Active = false
        t1.value42 = nil

        if p55.Connection then
            p55.Connection:Disconnect()
        end

        if p55.OldShootFunc then
            Gun.StartShooting = p55.OldShootFunc
        end

        t1.value3:UnbindFromRenderStep("WallbangRestore")
        t1.value3:UnbindFromRenderStep("WallbangVoid")
    end
end
function t1.value45()
    if t1.value40 then
        t1.value40:Shutdown()
    end

    t1.value41 = false
    t1.value42 = nil
end
t1.value46 = nil
t1.value47 = false
t1.value48 = nil
t1.value49 = 0
t1.value50 = 0
t1.value51 = require(t1.value4.Modules.Utility)
t1.value52 = require(t1.value4.Modules.EnumLibrary)
t1.value53 = nil
t1.value54 = {
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
t1.value55 = nil
function t1.value56(p56)
    if not p56 then
        return false
    end

    for _, v in ipairs(t1.value54) do
        if p56 == v then
            return true
        end
    end

    return false
end
function t1.value57()
    local Character = t1.value8.Character
    if not Character then
        return nil
    end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then
        return nil
    end
    local v233
    local huge = math.huge
    for _, player in ipairs(RunService:GetPlayers()) do
        if player ~= t1.value8 and not RunService4(player) then
            local Character3 = player.Character

            if Character3 then
                local Humanoid = Character3:FindFirstChildOfClass("Humanoid")

                if Humanoid and (Humanoid.Health > 0 and not Character3:FindFirstChildOfClass("ForceField")) then
                    local HumanoidRootPart3 = Character3:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart3 then
                        local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart3.Position).Magnitude

                        if Magnitude < huge then
                            huge = Magnitude
                            v233 = Character3
                        end
                    end
                end
            end
        end
    end

    return v233
end
function t1.value58()
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
        local v227 = v.Name:find("-")

        if v227 then
            return v.Name:sub(v227 + 1):match("^%s*(.-)%s*$")
        end
    end

    return nil
end
function t1.value59()
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
t1.value8.CharacterAdded:Connect(function()
    t1.value50 = tick()
    t1.value49 = 0
end)
t1.value60 = nil
function t1.value61()
    if not t1.value47 then
        return
    end

    if not t1.value59() then
        return
    end

    if tick() - t1.value50 < 5.2 then
        return
    end

    local v241 = t1.value58()

    if v241 and t1.value56(v241) then
        return
    end

    local timestamp = tick()
    local value13 = RunService3

    if timestamp - t1.value49 < (value13.AutoShootDelay or 0.1) then
        return
    end

    local v244 = t1.value57()

    if not v244 then
        return
    end

    local Head = v244:FindFirstChild("Head")

    if not Head then
        return
    end

    local player = RunService:GetPlayerFromCharacter(v244)

    if not player or RunService4(player) then
        return
    end

    pcall(function()
        local FighterController = require(t1.value8.PlayerScripts.Controllers.FighterController)
        local v671 = FighterController.LocalFighter and FighterController.LocalFighter.EquippedItem

        if not v671 then
            return
        end

        local v672 = v671:Get("ObjectID")

        if not v672 then
            return
        end

        local Character = t1.value8.Character
        local v674 = Character and Character:FindFirstChild("HumanoidRootPart")
        local v675 = v674 and v674.Position or Head.Position

        if t1.value41 and t1.value42 then
            v675 = t1.value42
        end

        local v676 = utf8.char(1)
        local v677 = utf8.char(0)
        local v678 = t1.value51:EncodeCFrame(CFrame.new(v675, Head.Position))
        local v679 = utf8.char(1)
        local v680 = t1.value51:EncodeCFrame(CFrame.new(v675, Head.Position))
        local v681 = utf8.char(2)
        local v682 = Head
        local v683 = utf8.char(3)
        local v684 = t1.value51:EncodeCFrame(CFrame.new(0.43, 0.25, 0.42))
        local t11 = {
            [v676] = {
                [v677] = v678,
                [v679] = v680,
                [v681] = v682,
                [v683] = v684
            }
        }

        t1.value4.Remotes.Replication.Fighter.UseItem:FireServer(v672, t1.value52:ToEnum("StartShooting"), t11, nil)
    end)
end
function t1.value62()
    if t1.value47 then
        return
    end

    t1.value47 = true
    t1.value50 = tick()
    t1.value3.Heartbeat:Connect(function()
        if t1.value47 then
            t1.value61()
        end
    end)
end
function t1.value63()
    t1.value47 = false

    if t1.value48 then
        t1.value48:Disconnect()
    end
end
t1.value60 = false
function t1.value64()
    if t1.value60 then
        return
    end

    t1.value60 = true
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
function t1.value65()
end
t1.value66 = false
t1.value67 = nil
t1.value68 = nil
t1.value69 = nil
HttpService0 = nil
HttpService1 = nil
HttpService2 = nil
function HttpService3()
    local v253 = t1.value8.Character or t1.value8.CharacterAdded:Wait()

    HttpService0 = v253:WaitForChild("Humanoid")
    HttpService1 = v253:WaitForChild("HumanoidRootPart")

    if t1.value66 then
        if t1.value67 then
            t1.value67:Destroy()
        end

        HttpService0.PlatformStand = true
        t1.value67 = Instance.new("Attachment", HttpService1)
        t1.value68 = Instance.new("LinearVelocity", t1.value67)
        t1.value68.MaxForce = 9000000000
        t1.value68.VectorVelocity = Vector3.zero
        t1.value68.Attachment0 = t1.value67
        t1.value69 = Instance.new("AlignOrientation", t1.value67)
        t1.value69.MaxTorque = 9000000000
        t1.value69.Responsiveness = 200
        t1.value69.Mode = Enum.OrientationAlignmentMode.OneAttachment
        t1.value69.Attachment0 = t1.value67
    end
end
t1.value8.CharacterAdded:Connect(function()
    task.wait(0.1)
    HttpService3()
end)
HttpService3()
HttpService4 = require(v2({ t1.value8.PlayerScripts:WaitForChild("PlayerModule") })):GetControls()
t1.value3.RenderStepped:Connect(function()
    local value66 = t1.value66

    if value66 then
        value66 = HttpService1 and (t1.value9 and (t1.value68 and t1.value69))
    end

    if value66 then
        local value9 = t1.value9
        local MoveVector = HttpService4:GetMoveVector()
        local v262 = RunService3.FlySpeed or 80

        if MoveVector.Magnitude > 0 then
            t1.value68.VectorVelocity = (value9.CFrame.LookVector * -MoveVector.Z + value9.CFrame.RightVector * MoveVector.X).Unit * v262
        else
            t1.value68.VectorVelocity = Vector3.zero
        end

        t1.value69.CFrame = value9.CFrame
    end
end)

function HttpService5()
    HttpService3()
end
HttpService6 = false
HttpService7 = nil
HttpService7 = nil
function HttpService8()
    if HttpService6 then
        return
    end

    HttpService6 = true
    t1.value2.JumpRequest:Connect(function()
        if not HttpService6 then
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
function HttpService9()
    HttpService6 = false

    if HttpService7 then
        HttpService7:Disconnect()
        HttpService7 = nil
    end
end
t1.value36 = false
t1.value26 = nil
function t1.value80()
    if t1.value36 then
        return
    end

    t1.value36 = true
    t1.value26 = t1.value3.Stepped:Connect(function()
        if not t1.value36 then
            return
        end

        local Character = t1.value8.Character

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
function t1.value81()
    t1.value36 = false

    if t1.value26 then
        t1.value26:Disconnect()
        t1.value26 = nil
    end
end
t1.value46 = false
t1.value55 = {}
t1.value53 = nil
function t1.value82(p57, p58)
    local drawing = Drawing.new(p57)

    for k, v in pairs(p58) do
        drawing[k] = v
    end

    return drawing
end
function t1.value83(_)
    local t12 = {}

    if RunService3.EspBoxes then
        if RunService3.EspBoxOutline then
            local value82 = t1.value82
            local color3_31 = Color3.new(0, 0, 0)

            t12.BoxOutline = value82("Square", {
                Visible = false,
                Thickness = 3,
                Filled = false,
                Color = color3_31
            })
        end

        local value82 = t1.value82
        local v289 = RunService3.EspBoxColor or Color3.fromRGB(0, 150, 255)

        t12.Box = value82("Square", {
            Visible = false,
            Thickness = 1.5,
            Filled = false,
            Color = v289
        })
    end

    if RunService3.EspNames then
        local value82 = t1.value82
        local color3_32 = Color3.new(0, 0, 0)
        local v292 = RunService3.EspNameColor or Color3.new(1, 1, 1)

        t12.Name = value82("Text", {
            Visible = false,
            Center = true,
            Outline = true,
            OutlineColor = color3_32,
            Size = 13,
            Font = 2,
            Color = v292
        })
    end

    if RunService3.EspHealth then
        local value82 = t1.value82
        local color3_33 = Color3.new(0, 0, 0)

        t12.HealthBarBG = value82("Line", {
            Visible = false,
            Thickness = 5,
            Color = color3_33
        })

        local value82_2 = t1.value82
        local v296 = RunService3.EspHealthColor or Color3.new(0, 1, 0)

        t12.HealthBar = value82_2("Line", {
            Visible = false,
            Thickness = 3,
            Color = v296
        })
    end

    if RunService3.EspDistance then
        local value82 = t1.value82
        local color3_34 = Color3.new(0, 0, 0)
        local v299 = RunService3.EspDistanceColor or Color3.new(1, 1, 1)

        t12.Distance = value82("Text", {
            Visible = false,
            Center = true,
            Outline = true,
            OutlineColor = color3_34,
            Size = 11,
            Font = 2,
            Color = v299
        })
    end

    if RunService3.EspHealthNumber then
        local value82 = t1.value82
        local color3_35 = Color3.new(0, 0, 0)
        local v302 = RunService3.EspHealthNumberColor or Color3.new(1, 1, 1)

        t12.HealthNumber = value82("Text", {
            Visible = false,
            Center = true,
            Outline = true,
            OutlineColor = color3_35,
            Size = 11,
            Font = 2,
            Color = v302
        })
    end

    if RunService3.EspTracers then
        local value82 = t1.value82
        local v304 = RunService3.EspTracerColor or Color3.fromRGB(0, 150, 255)

        t12.Tracer = value82("Line", {
            Visible = false,
            Thickness = 1,
            Color = v304
        })
    end

    return t12
end
function t1.value84(p60, p61)
    local v271 = p61 / 2
    local t13 = {}
    local v273 = true

    for i = -1, 1, 2 do
        for j = -1, 1, 2 do
            for k = -1, 1, 2 do
                local v277 = p60 * Vector3.new(v271.X * i, v271.Y * j, v271.Z * k)
                local v278, v279 = t1.value9:WorldToViewportPoint(v277)

                if not v279 then
                    v273 = false
                end

                table.insert(t13, Vector2.new(v278.X, v278.Y))
            end
        end
    end

    return t13, v273
end
function t1.value85(p62)
    for _, v in pairs(p62) do
        if v and v.Visible then
            v.Visible = false
        end
    end
end
function t1.value86()
    if not t1.value46 then
        for _, v in pairs(t1.value55) do
            t1.value85(v)
        end

        return
    end

    for _, player in ipairs(RunService:GetPlayers()) do
        if player ~= t1.value8 then
            if RunService4(player) then
                if t1.value55[player] then
                    t1.value85(t1.value55[player])
                end
            else
                local Character = player.Character
                local v311 = Character and Character:FindFirstChildOfClass("Humanoid")

                if Character and (v311 and v311.Health > 0) then
                    local EspBoxes = RunService3.EspBoxes

                    if not EspBoxes then
                        EspBoxes = RunService3.EspNames

                        if not EspBoxes then
                            EspBoxes = RunService3.EspHealth

                            if not EspBoxes then
                                EspBoxes = RunService3.EspDistance or (RunService3.EspHealthNumber or RunService3.EspTracers)
                            end
                        end
                    end

                    if EspBoxes then
                        local ok, result, v315 = pcall(Character.GetBoundingBox, Character)

                        if ok then
                            ok = result and v315
                        end

                        if ok then
                            local v316, v317 = t1.value84(result, v315)

                            if not v317 then
                                if t1.value55[player] then
                                    t1.value85(t1.value55[player])
                                end
                            else
                                local v318 = t1.value55[player] or t1.value83(player)

                                t1.value55[player] = v318

                                local n1 = 1e999
                                local n2 = -1e999
                                local n3 = -1e999
                                local n4 = 1e999

                                for _, v in ipairs(v316) do
                                    n4 = math.min(n4, v.X)
                                    n1 = math.min(n1, v.Y)
                                    n2 = math.max(n2, v.X)
                                    n3 = math.max(n3, v.Y)
                                end

                                local v325 = n2 - n4
                                local v326 = n3 - n1
                                local v327 = v325 * 0.7
                                local _math = math
                                local v329 = n4 + (v325 - v327) / 2
                                local v330 = _math.clamp(v311.Health / v311.MaxHealth, 0, 1)
                                local Head = Character:FindFirstChild("Head")

                                if v318.BoxOutline and (RunService3.EspBoxes and RunService3.EspBoxOutline) then
                                    v318.BoxOutline.Visible = true
                                    v318.BoxOutline.Position = Vector2.new(v329 - 1, n1 - 1)
                                    v318.BoxOutline.Size = Vector2.new(v327 + 2, v326 + 2)
                                end

                                if v318.Box and RunService3.EspBoxes then
                                    v318.Box.Visible = true
                                    v318.Box.Position = Vector2.new(v329, n1)
                                    v318.Box.Size = Vector2.new(v327, v326)
                                end

                                if v318.Name and RunService3.EspNames then
                                    v318.Name.Visible = true
                                    v318.Name.Text = player.Name
                                    v318.Name.Position = Vector2.new(v329 + v327 / 2, n1 - 16)
                                end

                                local v332 = v326 * v330

                                if v318.HealthBarBG and RunService3.EspHealth then
                                    v318.HealthBarBG.Visible = true
                                    v318.HealthBarBG.From = Vector2.new(v329 - 6, n3)
                                    v318.HealthBarBG.To = Vector2.new(v329 - 6, n1)
                                end

                                if v318.HealthBar and RunService3.EspHealth then
                                    v318.HealthBar.Visible = true

                                    if v330 > 0.7 then
                                        v318.HealthBar.Color = RunService3.EspHealthColor or Color3.fromRGB(0, 255, 0)
                                    elseif v330 > 0.3 then
                                        v318.HealthBar.Color = Color3.fromRGB(255, 165, 0)
                                    else
                                        v318.HealthBar.Color = Color3.fromRGB(255, 0, 0)
                                    end

                                    v318.HealthBar.From = Vector2.new(v329 - 6, n3)
                                    v318.HealthBar.To = Vector2.new(v329 - 6, n3 - v332)
                                end

                                if v318.Distance and (RunService3.EspDistance and Head) then
                                    local v333 = t1.value8.Character and t1.value8.Character:FindFirstChild("HumanoidRootPart")

                                    if v333 then
                                        local v334 = math.floor((v333.Position - Head.Position).Magnitude)

                                        v318.Distance.Visible = true
                                        v318.Distance.Text = v334 .. "m"
                                        v318.Distance.Position = Vector2.new(v329 + v327 / 2, n3 + 4)
                                    end
                                end

                                if v318.HealthNumber and RunService3.EspHealthNumber then
                                    v318.HealthNumber.Visible = true
                                    v318.HealthNumber.Text = math.floor(v311.Health) .. "/" .. math.floor(v311.MaxHealth)
                                    v318.HealthNumber.Position = Vector2.new(v329 + v327 / 2, n3 + 16)
                                end

                                if v318.Tracer and RunService3.EspTracers then
                                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                                    if HumanoidRootPart then
                                        local v336 = t1.value9:WorldToViewportPoint(HumanoidRootPart.Position)
                                        local ViewportSize = t1.value9.ViewportSize

                                        v318.Tracer.Visible = true
                                        v318.Tracer.From = Vector2.new(ViewportSize.X / 2, ViewportSize.Y)
                                        v318.Tracer.To = Vector2.new(v336.X, v336.Y)
                                    end
                                end
                            end
                        end
                    end
                elseif t1.value55[player] then
                    t1.value85(t1.value55[player])
                end
            end
        end
    end
end
t1.value87 = nil
function t1.value87()
    t1.value46 = false

    if t1.value53 then
        t1.value53:Disconnect()
        t1.value53 = nil
    end

    for _, v in pairs(t1.value55) do
        local v252 = v

        pcall(function()
            for _, v6 in pairs(v252) do
                if v6 and v6.Remove then
                    v6:Remove()
                end
            end
        end)
    end

    t1.value55 = {}
end
function HttpService2()
    if t1.value46 then
        t1.value87()
        t1.value46 = true

        if t1.value53 then
            t1.value53:Disconnect()
        end

        t1.value3.RenderStepped:Connect(t1.value86)
    end
end
RunService.PlayerRemoving:Connect(function(player)
    if t1.value55[player] then
        for _, v in pairs(t1.value55[player]) do
            local v343 = v

            pcall(function()
                if v343 and v343.Remove then
                    v343:Remove()
                end
            end)
        end

        t1.value55[player] = nil
    end
end)
t1.value88 = {
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
t1.value89 = {}
t1.value90 = {
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
function t1.value91()
    for _, v in ipairs(t1.value89) do
        local v346 = v

        pcall(function()
            v346:Stop(0)
            v346:Destroy()
        end)
    end

    t1.value89 = {}
end
local function v62(p63)
    if not p63 then
        return nil
    end

    local Humanoid = p63:FindFirstChildOfClass("Humanoid")

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
local function v63(p64)
    local u351 = p64
    local ok, result = pcall(function()
        return game:GetObjects("rbxassetid://" .. u351)
    end)
    local v354 = not ok
    if not v354 then
        v354 = not result or #result == 0
    end
    if v354 then
        return nil
    end
    local v355, v356, v357 = ipairs(result)
    local v358
    repeat
        v357, v358 = v355(v356, v357)

        if not v357 then
            for _, v in ipairs(result) do
                local GetDescendants = v.GetDescendants

                for _, v7 in ipairs(GetDescendants(v)) do
                    if v7:IsA("Animation") and v7.AnimationId ~= "" then
                        return v7
                    end
                end
            end

            return nil
        end
    until v358:IsA("Animation") and v358.AnimationId ~= ""

    return v358
end
function t1.value92(p65, p66, p67, p68)
    if not p65 or p66 == "" then
        return nil
    end

    local v368 = v62(p65)

    if not v368 then
        return nil
    end

    local u369 = v63(p66)

    if not u369 then
        u369 = Instance.new("Animation")
        u369.AnimationId = "rbxassetid://" .. p66
    end

    local ok, result = pcall(function()
        return v368:LoadAnimation(u369)
    end)
    local v372 = not ok

    if not v372 then
        v372 = not result
    end

    if v372 then
        pcall(function()
            u369:Destroy()
        end)

        return nil
    end

    result.Looped = p68
    result.Priority = Enum.AnimationPriority.Action4
    result:Play(0.1, 1, p67)

    return result
end
local function v64()
    t1.value91()

    if not t1.value88.enabled or t1.value88.animationId == "" then
        return
    end

    local Character = t1.value8.Character

    if Character then
        local v374 = t1.value92(Character, t1.value88.animationId, t1.value88.speed, t1.value88.loop)

        if v374 then
            table.insert(t1.value89, v374)
        end
    end

    local Live = t1.value6:FindFirstChild("Live")

    if Live then
        local t1value8Name = Live:FindFirstChild(t1.value8.Name)

        if t1value8Name then
            local v377 = t1.value92(t1value8Name, t1.value88.animationId, t1.value88.speed, t1.value88.loop)

            if v377 then
                table.insert(t1.value89, v377)
            end
        end
    end
end
t1.value3.Heartbeat:Connect(function()
    if not t1.value88.enabled then
        return
    end

    if #t1.value89 == 0 and t1.value88.animationId ~= "" then
        v64()
    end

    for _, v in ipairs(t1.value89) do
        local v380 = v

        pcall(function()
            v380:AdjustSpeed(t1.value88.speed)
        end)
    end
end)
t1.value8.CharacterAdded:Connect(function()
    task.wait(0.5)

    if t1.value88.enabled and t1.value88.spawnProof then
        v64()
    end
end)
t1.value93 = Instance.new("ScreenGui")
t1.value93.Name = "AimbotFOV"
t1.value93.ResetOnSpawn = false
t1.value93.IgnoreGuiInset = true
t1.value93.DisplayOrder = 999998
t1.value93.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t1.value93.Parent = PlayerGui
AimbotState = {
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
local color3_36 = Color3.fromRGB(255, 255, 255)
local color3_37 = Color3.fromRGB(255, 255, 255)
local color3_38 = Color3.fromRGB(255, 255, 255)
local color3_39 = Color3.fromRGB(0, 0, 0)

t1.value95 = {
    OutlineColor1 = color3_36,
    OutlineColor2 = color3_37,
    OutlineRotation = 0,
    OutlineThickness = 1.5,
    OutlineTransparency = 0,
    FilledEnabled = false,
    FilledColor1 = color3_38,
    FilledColor2 = color3_39,
    FilledRotation = 0,
    FilledTransparency = 0.7,
    FilledAnimated = false,
    FilledSpeed = 1,
    SpinOn = false,
    SpinSpd = 1
}
local v69 = (function(p69, p70)
    local Frame19 = Instance.new("Frame")

    Frame19.Name = p69
    Frame19.BackgroundTransparency = 1
    Frame19.BorderSizePixel = 0
    Frame19.Visible = false
    Frame19.Parent = t1.value93

    local Frame20 = Instance.new("Frame")

    Frame20.Size = UDim2.new(1, 0, 1, 0)
    Frame20.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame20.BackgroundTransparency = p70.FilledTransparency
    Frame20.BorderSizePixel = 0
    Frame20.Visible = false
    Frame20.ZIndex = 1
    Frame20.Parent = Frame19

    local UICorner19 = Instance.new("UICorner")

    UICorner19.CornerRadius = UDim.new(1, 0)
    UICorner19.Parent = Frame20

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, p70.FilledColor1),
        ColorSequenceKeypoint.new(1, p70.FilledColor2)
    })
    UIGradient.Rotation = p70.FilledRotation
    UIGradient.Parent = Frame20

    local Frame21 = Instance.new("Frame")

    Frame21.Size = UDim2.new(1, 0, 1, 0)
    Frame21.BackgroundTransparency = 1
    Frame21.BorderSizePixel = 0
    Frame21.ZIndex = 2
    Frame21.Parent = Frame19

    local UICorner20 = Instance.new("UICorner")

    UICorner20.CornerRadius = UDim.new(1, 0)
    UICorner20.Parent = Frame21

    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Color = Color3.new(1, 1, 1)
    UIStroke2.Thickness = p70.OutlineThickness
    UIStroke2.Transparency = p70.OutlineTransparency
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke2.Parent = Frame21

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, p70.OutlineColor1),
        ColorSequenceKeypoint.new(1, p70.OutlineColor2)
    })
    UIGradient2.Rotation = p70.OutlineRotation
    UIGradient2.Parent = UIStroke2

    return {
        container = Frame19,
        fill = Frame20,
        fillgrad = UIGradient,
        stroke = UIStroke2,
        strokegrad = UIGradient2
    }
end)("AimbotFOV", t1.value95)

t1.value96 = v69.container
local _ = v69.fill
t1.value97 = v69.fillgrad
local _ = v69.stroke
t1.value98 = nil
t1.value99 = v69.strokegrad
function RunService00(p71, p72)
    if not p72 then
        p72 = t1.value9
    end

    if not p72 or not p71 then
        return nil, false
    end

    local v414, v415 = p72:WorldToViewportPoint(p71)
    local v416 = not v415

    if not v416 then
        v416 = v414.Z <= 0
    end

    if v416 then
        return v414, false
    end

    return v414, true
end
function RunService01(p73)
    if not p73 then
        p73 = t1.value9
    end

    if not p73 then
        return Vector2.zero
    end

    local ViewportSize = p73.ViewportSize

    return Vector2.new(ViewportSize.X * 0.5, ViewportSize.Y * 0.5)
end
function RunService02(p74)
    if not p74 then
        return nil
    end

    local v441, v442 = RunService00(p74, t1.value9)

    if not v442 then
        return nil
    end

    return Vector2.new(v441.X, v441.Y)
end
function RunService03()
    local Character = t1.value8.Character

    if not Character then
        local CurrentCamera = workspace.CurrentCamera

        return CurrentCamera and CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 4 or Vector3.zero
    end

    local ViewModels = t1.value6:FindFirstChild("ViewModels")

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

                    local v430 = child2.Name:lower()

                    if v430:find("tip") or (v430:find("barrel") or v430:find("muzzle")) then
                        return child2.Position
                    end
                end

                local v431 = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")

                if v431 then
                    return v431.Position
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
function RunService04()
    if AimbotState.followMuzzle then
        local v452 = RunService02(RunService03())

        if v452 then
            return v452
        end
    end

    return RunService01(t1.value9)
end
function RunService05()
    if AimbotState.followMuzzle then
        return RunService04()
    end

    local MouseLocation = t1.value2:GetMouseLocation()

    return Vector2.new(MouseLocation.X, MouseLocation.Y)
end
function RunService06(p75)
    if not AimbotState.teamCheck then
        return false
    end

    if not p75 then
        return false
    end

    local TeamID = t1.value8:GetAttribute("TeamID")
    local TeamID3 = p75:GetAttribute("TeamID")

    if TeamID and (TeamID3 and TeamID == TeamID3) then
        return true
    end

    if t1.value8.Team and (p75.Team and t1.value8.Team == p75.Team) then
        return true
    end

    return false
end
function RunService07(p76)
    if not AimbotState.aliveCheck then
        return true
    end

    if not p76 then
        return false
    end

    local Character = p76.Character

    if not Character then
        return false
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid or Humanoid.Health <= 0 then
        return false
    end

    return true
end
function RunService08(p77)
    if not AimbotState.wallCheck then
        return true
    end

    if not p77 or not p77.Character then
        return false
    end

    local v403 = p77.Character:FindFirstChild(AimbotState.targetPart) or p77.Character:FindFirstChild("Head")

    if not v403 then
        return false
    end

    local CFramePosition = t1.value9.CFrame.Position
    local Position = v403.Position
    local Unit = (Position - CFramePosition).Unit
    local Magnitude = (Position - CFramePosition).Magnitude
    local raycastParams = RaycastParams.new()

    raycastParams.FilterDescendantsInstances = { t1.value8.Character }
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true

    local raycastResult = workspace:Raycast(CFramePosition, Unit * Magnitude, raycastParams)

    if not raycastResult then
        return true
    end

    if raycastResult.Instance:FindFirstAncestorOfClass("Model") == p77.Character then
        return true
    end

    return raycastResult.Instance:IsDescendantOf(p77.Character)
end
local function v72(p78)
    if not p78 then
        return false
    end

    if p78 == t1.value8 then
        return false
    end

    if RunService06(p78) then
        return false
    end

    if not RunService07(p78) then
        return false
    end

    if not RunService08(p78) then
        return false
    end

    local Character = p78.Character

    if not Character then
        return false
    end

    if Character:FindFirstChildOfClass("ForceField") then
        return false
    end

    return true
end
function RunService09()
    local v456
    local fovRadius = AimbotState.fovRadius
    local v458 = RunService05()
    if not v458 then
        return nil
    end
    local value9 = t1.value9
    for _, player in ipairs(RunService:GetPlayers()) do
        if player ~= t1.value8 and (player.Character and v72(player)) then
            local t1value94targetPart = player.Character:FindFirstChild(AimbotState.targetPart)
            local v463 = t1value94targetPart

            if t1value94targetPart then
                v463 = t1value94targetPart:IsDescendantOf(workspace)
            end

            if v463 then
                local v465, t14Result = RunService00(t1value94targetPart.Position, value9)
                if t14Result then
                    local v466 = v465.X - v458.X
                    local v467 = v465.Y - v458.Y
                    local v468 = math.sqrt(v466 * v466 + v467 * v467)

                    if v468 < fovRadius then
                        v456 = t1value94targetPart
                        fovRadius = v468
                    end
                end
            end
        end
    end

    return v456
end
function RunService10(p79)
    local smoothness = AimbotState.smoothness

    if smoothness <= 0 then
        return 1
    end

    local v445 = math.clamp(tonumber(smoothness) or 2, 0.1, 10)
    local v446 = AimbotState.aimCurve or "Linear"
    local v447 = 6 / v445

    if v446 == "Instant" then
        return 1
    end

    if v446 == "Expo" then
        return 1 - math.exp(-(4 / v445) * p79)
    end

    if v446 == "EaseIn" then
        local v448 = math.clamp(v447 * p79, 0, 1)

        return v448 * v448
    end

    if v446 == "EaseOut" then
        local v449 = math.clamp(v447 * p79, 0, 1)

        return 1 - (1 - v449) * (1 - v449)
    end

    if v446 == "EaseInOut" then
        local v450 = math.clamp(v447 * p79, 0, 1)

        if v450 < 0.5 then
            return 2 * v450 * v450
        end

        return 1 - (-2 * v450 + 2) ^ 2 / 2
    end

    if v446 == "Cubic" then
        local v451 = math.clamp(v447 * p79, 0, 1)

        return v451 * v451 * v451
    end

    return math.clamp(v447 * p79, 0, 1)
end
function RunService11()
    AimbotState.lockedTarget = nil
    AimbotState.smoothCF = nil
end
function RunService12(p80)
    if not p80 then
        p80 = t1.value9
    end

    if not p80 then
        return nil
    end

    local p80CFrame = p80.CFrame
    local p80CFramePosition = p80CFrame.Position
    local LookVector = p80CFrame.LookVector
    local RightVector = p80CFrame.RightVector
    local Unit = RightVector:Cross(LookVector).Unit

    return CFrame.fromMatrix(p80CFramePosition, RightVector, Unit, -LookVector)
end
t1.value98 = nil
pcall(function()
    local CameraController = t1.value8.PlayerScripts:WaitForChild("Controllers", 10):FindFirstChild("CameraController")

    if CameraController and CameraController:IsA("ModuleScript") then
        t1.value98 = require(CameraController)
    end
end)
t1.value3:BindToRenderStep("InstanceAimbotUpdate", Enum.RenderPriority.Camera.Value + 1, function(p81)
    local value94 = AimbotState
    local v472 = p81 or 0.0041666666666667

    if not value94.enabled then
        RunService11()

        return
    end

    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    if not AimbotState.lockedTarget then
        AimbotState.lockedTarget = RunService09()
        AimbotState.smoothCF = RunService12(CurrentCamera)

        if not AimbotState.lockedTarget then
            return
        end
    end

    local v474 = not AimbotState.lockedTarget.Parent

    if not v474 then
        v474 = not AimbotState.lockedTarget:IsDescendantOf(workspace)
    end

    if v474 then
        RunService11()

        return
    end

    local player = RunService:GetPlayerFromCharacter(AimbotState.lockedTarget.Parent)

    if player and not v72(player) then
        RunService11()

        return
    end

    local Character = t1.value8.Character

    if not Character then
        return
    end

    if not Character:FindFirstChild("Head") then
        RunService11()

        return
    end

    if not t1.value98 then
        return
    end

    if not AimbotState.smoothCF then
        AimbotState.smoothCF = RunService12(CurrentCamera)
    end

    local cFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, AimbotState.lockedTarget.Position)
    local v478 = RunService10(v472)

    AimbotState.smoothCF = AimbotState.smoothCF:Lerp(cFrame, v478)

    if t1.value98 and t1.value98.MimicRotation then
        pcall(function()
            t1.value98:MimicRotation(AimbotState.smoothCF)
        end)
    end
end)
t1.value3.RenderStepped:Connect(function()
    if t1.value96.Visible then
        local v479 = RunService04()
        local fovRadius = AimbotState.fovRadius

        t1.value96.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
        t1.value96.Position = UDim2.fromOffset(v479.X - fovRadius, v479.Y - fovRadius)

        if t1.value95.FilledAnimated then
            t1.value97.Rotation = math.sin(tick() * t1.value95.FilledSpeed) * 180 + t1.value95.FilledRotation
        elseif t1.value95.SpinOn then
            t1.value97.Rotation = t1.value95.FilledRotation + tick() * t1.value95.SpinSpd * 90 % 360
        end

        if t1.value95.SpinOn then
            t1.value99.Rotation = t1.value95.OutlineRotation + tick() * t1.value95.SpinSpd * 90 % 360
        end
    end
end);
(function()
    t1.value96.Visible = AimbotState.showFov

    if not AimbotState.enabled then
        RunService11()

        return
    end
end)()
function RunService13(p82)
    AimbotState.enabled = p82
    RunService3.AimbotEnabled = p82
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t15 = {}

        for k, v in pairs(RunService3) do
            local v840 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                t15[v840] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                t15[v840] = v
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(t15))
    end)

    if not p82 then
        RunService11()
    end
end
function RunService14(p83)
    AimbotState.showFov = p83
    RunService3.AimbotShowFOV = p83
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t16 = {}

        for k, v in pairs(RunService3) do
            local v847 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                t16[v847] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                t16[v847] = v
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(t16))
    end)
    t1.value96.Visible = p83
end
function RunService15(p84)
    AimbotState.followMuzzle = p84
    RunService3.AimbotFollowMuzzle = p84
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t17 = {}

        for k, v in pairs(RunService3) do
            local v854 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                savedSettings[settingKey] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                savedSettings[settingKey] = value
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(t17))
    end)
end
function RunService16(p85)
    AimbotState.teamCheck = p85
    RunService3.AimbotTeamCheck = p85
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t18 = {}

        for k, v in pairs(RunService3) do
            local v868 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                savedSettings[settingKey] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                savedSettings[settingKey] = value
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(savedSettings))
    end)
end
function RunService17(p86)
    AimbotState.aliveCheck = p86
    RunService3.AimbotAliveCheck = p86
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t19 = {}

        for k, v in pairs(RunService3) do
            local v833 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                savedSettings[settingKey] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                savedSettings[settingKey] = value
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(savedSettings))
    end)
end
function RunService18(p87)
    AimbotState.wallCheck = p87
    RunService3.AimbotWallCheck = p87
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t20 = {}

        for k, v in pairs(RunService3) do
            local v882 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                savedSettings[settingKey] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                savedSettings[settingKey] = value
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(savedSettings))
    end)
end
RunService19 = {}
RunService19.AimbotToggle = v57("Main", "Enable Aimbot", RunService3.AimbotEnabled, RunService13, "left", true)

if RunService19.AimbotToggle.collapsible then
    v57("Main", "Show FOV Circle", RunService3.AimbotShowFOV, RunService14, "left")
    v60(RunService19.AimbotToggle.collapsible, "Target Part", {
        "Head",
        "HumanoidRootPart",
        "Torso",
        "UpperTorso",
        "LowerTorso"
    }, RunService3.AimbotTargetPart, function(p88)
        AimbotState.targetPart = p88
        RunService3.AimbotTargetPart = p88
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t21 = {}

            for k, v in pairs(RunService3) do
                local v875 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t21[v875] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t21[v875] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t21))
        end)
        RunService11()
    end)
    v56(RunService19.AimbotToggle.collapsible, "FOV Radius", 50, 1000, RunService3.AimbotFOVRadius, function(p89)
        AimbotState.fovRadius = p89
        RunService3.AimbotFOVRadius = p89
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t22 = {}

            for k, v in pairs(RunService3) do
                local v819 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t22[v819] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t22[v819] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t22))
        end)
    end)
    v56(RunService19.AimbotToggle.collapsible, "Smoothness", 0, 10, RunService3.AimbotSmoothness, function(p90)
        AimbotState.smoothness = p90
        RunService3.AimbotSmoothness = p90
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t23 = {}

            for k, v in pairs(RunService3) do
                local v826 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t23[v826] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t23[v826] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t23))
        end)
    end)
    v60(RunService19.AimbotToggle.collapsible, "Aim Curve", {
        "Linear",
        "Instant",
        "Expo",
        "EaseIn",
        "EaseOut",
        "EaseInOut",
        "Cubic"
    }, RunService3.AimbotCurve, function(p91)
        AimbotState.aimCurve = p91
        RunService3.AimbotCurve = p91
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t24 = {}

            for k, v in pairs(RunService3) do
                local v861 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t24[v861] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t24[v861] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t24))
        end)
    end)
    v57("Main", "Follow Muzzle", RunService3.AimbotFollowMuzzle, RunService15, "left")
    v57("Main", "Team Check", RunService3.AimbotTeamCheck, RunService16, "left")
    v57("Main", "Alive Check", RunService3.AimbotAliveCheck, RunService17, "left")
    v57("Main", "Wall Check", RunService3.AimbotWallCheck, RunService18, "left")
end
RunService19.RagebotToggle = v57("Ragebot", "Ragebot", RunService3.Ragebot, function(p92)
    if p92 then
        t1.value44()

        return
    end

    t1.value45()
end, "left")
RunService19.AutoShootToggle = v57("Ragebot", "Auto Shoot", RunService3.AutoShoot, function(p93)
    if p93 then
        t1.value62()

        return
    end

    t1.value63()
end, "left", true)

if RunService19.AutoShootToggle.collapsible then
    v56(RunService19.AutoShootToggle.collapsible, "Shoot Delay", 0.1, 10, RunService3.AutoShootDelay, function(p94)
        RunService3.AutoShootDelay = p94
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t25 = {}

            for k, v in pairs(RunService3) do
                local v689 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t25[v689] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t25[v689] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t25))
        end)
    end)
end
RunService19.RapidFireToggle = v57("Ragebot", "Rapid Fire", RunService3.RapidFire, function(p95)
    if p95 then
        t1.value64()

        return
    end

    t1.value65()
end, "left")
RunService19.EspToggle = v57("ESP", "Enable ESP", RunService3.Esp, function(p96)
    if p96 then
        t1.value46 = true

        if t1.value53 then
            t1.value53:Disconnect()
        end

        t1.value3.RenderStepped:Connect(t1.value86)

        return
    end

    t1.value87()
end, "left", true)

if RunService19.EspToggle.collapsible then
    local v73 = v57("ESP", "Box ESP", RunService3.EspBoxes, function(p97)
        RunService3.EspBoxes = p97
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t26 = {}

            for k, v in pairs(RunService3) do
                local v798 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t26[v798] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t26[v798] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t26))
        end)
        HttpService2()
    end, "left", true)

    if v73.collapsible then
        v73.collapsible.container.Parent = RunService19.EspToggle.collapsible.container
        v59(v73.collapsible, "Box Color", RunService3.EspBoxColor, function(p98)
            RunService3.EspBoxColor = p98
            pcall(function()
                if not isfolder or not makefolder then
                    return
                end

                if not isfolder("oishi_hub") then
                    makefolder("oishi_hub")
                end

                local t27 = {}

                for k, v in pairs(RunService3) do
                    local v754 = k

                    if typeof(value) == "Color3" then
                        local R = value.R
                        local G = value.G
                        local B = value.B

                        t27[v754] = {
                            r = R,
                            g = G,
                            b = B
                        }
                    else
                        t27[v754] = v
                    end
                end

                writefile("oishi_hub/settings.json", HttpService:JSONEncode(t27))
            end)
            HttpService2()
        end)
        v57("ESP", "Box Outline", RunService3.EspBoxOutline, function(p99)
            RunService3.EspBoxOutline = p99
            pcall(function()
                if not isfolder or not makefolder then
                    return
                end

                if not isfolder("oishi_hub") then
                    makefolder("oishi_hub")
                end

                local t28 = {}

                for k, v in pairs(RunService3) do
                    local v705 = k

                    if typeof(value) == "Color3" then
                        local R = value.R
                        local G = value.G
                        local B = value.B

                        t28[v705] = {
                            r = R,
                            g = G,
                            b = B
                        }
                    else
                        t28[v705] = v
                    end
                end

                writefile("oishi_hub/settings.json", HttpService:JSONEncode(t28))
            end)
            HttpService2()
        end, "left")
    end

    local v74 = v57("ESP", "Health Bar ESP", RunService3.EspHealth, function(p100)
        RunService3.EspHealth = p100
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t29 = {}

            for k, v in pairs(RunService3) do
                local v719 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t29[v719] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t29[v719] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t29))
        end)
        HttpService2()
    end, "left", true)

    if v74.collapsible then
        v74.collapsible.container.Parent = RunService19.EspToggle.collapsible.container
        v59(v74.collapsible, "Health Color", RunService3.EspHealthColor, function(p101)
            RunService3.EspHealthColor = p101
            pcall(function()
                if not isfolder or not makefolder then
                    return
                end

                if not isfolder("oishi_hub") then
                    makefolder("oishi_hub")
                end

                local t30 = {}

                for k, v in pairs(RunService3) do
                    local v726 = k

                    if typeof(value) == "Color3" then
                        local R = value.R
                        local G = value.G
                        local B = value.B

                        t30[v726] = {
                            r = R,
                            g = G,
                            b = B
                        }
                    else
                        t30[v726] = v
                    end
                end

                writefile("oishi_hub/settings.json", HttpService:JSONEncode(t30))
            end)
            HttpService2()
        end)
    end

    local v75 = v57("ESP", "Name ESP", RunService3.EspNames, function(p102)
        RunService3.EspNames = p102
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t31 = {}

            for k, v in pairs(RunService3) do
                local v768 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t31[v768] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t31[v768] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t31))
        end)
        HttpService2()
    end, "left", true)

    if v75.collapsible then
        v75.collapsible.container.Parent = RunService19.EspToggle.collapsible.container
        v59(v75.collapsible, "Name Color", RunService3.EspNameColor, function(p103)
            RunService3.EspNameColor = p103
            pcall(function()
                if not isfolder or not makefolder then
                    return
                end

                if not isfolder("oishi_hub") then
                    makefolder("oishi_hub")
                end

                local t32 = {}

                for k, v in pairs(RunService3) do
                    local v791 = k

                    if typeof(value) == "Color3" then
                        local R = value.R
                        local G = value.G
                        local B = value.B

                        t32[v791] = {
                            r = R,
                            g = G,
                            b = B
                        }
                    else
                        t32[v791] = v
                    end
                end

                writefile("oishi_hub/settings.json", HttpService:JSONEncode(t32))
            end)
            HttpService2()
        end)
    end

    local v76 = v57("ESP", "Health Number", RunService3.EspHealthNumber, function(p104)
        RunService3.EspHealthNumber = p104
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t33 = {}

            for k, v in pairs(RunService3) do
                local v733 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t33[v733] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t33[v733] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t33))
        end)
        HttpService2()
    end, "left", true)

    if v76.collapsible then
        v76.collapsible.container.Parent = RunService19.EspToggle.collapsible.container
        v59(v76.collapsible, "Health Number Color", RunService3.EspHealthNumberColor, function(p105)
            RunService3.EspHealthNumberColor = p105
            pcall(function()
                if not isfolder or not makefolder then
                    return
                end

                if not isfolder("oishi_hub") then
                    makefolder("oishi_hub")
                end

                local t34 = {}

                for k, v in pairs(RunService3) do
                    local v784 = k

                    if typeof(value) == "Color3" then
                        local R = value.R
                        local G = value.G
                        local B = value.B

                        t34[v784] = {
                            r = R,
                            g = G,
                            b = B
                        }
                    else
                        t34[v784] = v
                    end
                end

                writefile("oishi_hub/settings.json", HttpService:JSONEncode(t34))
            end)
            HttpService2()
        end)
    end

    local v77 = v57("ESP", "Distance ESP", RunService3.EspDistance, function(p106)
        RunService3.EspDistance = p106
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t35 = {}

            for k, v in pairs(RunService3) do
                local v747 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t35[v747] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t35[v747] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t35))
        end)
        HttpService2()
    end, "left", true)

    if v77.collapsible then
        v77.collapsible.container.Parent = RunService19.EspToggle.collapsible.container
        v59(v77.collapsible, "Distance Color", RunService3.EspDistanceColor, function(p107)
            RunService3.EspDistanceColor = p107
            pcall(function()
                if not isfolder or not makefolder then
                    return
                end

                if not isfolder("oishi_hub") then
                    makefolder("oishi_hub")
                end

                local t36 = {}

                for k, v in pairs(RunService3) do
                    local v777 = k

                    if typeof(value) == "Color3" then
                        local R = value.R
                        local G = value.G
                        local B = value.B

                        t36[v777] = {
                            r = R,
                            g = G,
                            b = B
                        }
                    else
                        t36[v777] = v
                    end
                end

                writefile("oishi_hub/settings.json", HttpService:JSONEncode(t36))
            end)
            HttpService2()
        end)
    end

    local v78 = v57("ESP", "Tracer ESP", RunService3.EspTracers, function(p108)
        RunService3.EspTracers = p108
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t37 = {}

            for k, v in pairs(RunService3) do
                local v712 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t37[v712] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t37[v712] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t37))
        end)
        HttpService2()
    end, "left", true)

    if v78.collapsible then
        v78.collapsible.container.Parent = RunService19.EspToggle.collapsible.container
        v59(v78.collapsible, "Tracer Color", RunService3.EspTracerColor, function(p109)
            RunService3.EspTracerColor = p109
            pcall(function()
                if not isfolder or not makefolder then
                    return
                end

                if not isfolder("oishi_hub") then
                    makefolder("oishi_hub")
                end

                local t38 = {}

                for k, v in pairs(RunService3) do
                    local v761 = k

                    if typeof(value) == "Color3" then
                        local R = value.R
                        local G = value.G
                        local B = value.B

                        t38[v761] = {
                            r = R,
                            g = G,
                            b = B
                        }
                    else
                        t38[v761] = v
                    end
                end

                writefile("oishi_hub/settings.json", HttpService:JSONEncode(t38))
            end)
            HttpService2()
        end)
    end
end
RunService19.UnlockAllToggle = v57("Visual", "Unlock All", RunService3.UnlockAllEnabled, function(p110)
    if p110 then
        t1.value38()

        return
    end

    t1.value39()
end, "left")
RunService19.CustomFOVToggle = v57("Visual", "Custom FOV", RunService3.CustomFOVEnabled, function(p111)
    if p111 then
        t1.value33()

        return
    end

    t1.value34()
end, "left", true)

if RunService19.CustomFOVToggle.collapsible then
    v56(RunService19.CustomFOVToggle.collapsible, "FOV Value", 30, 120, RunService3.CustomFOVValue, function(p112)
        t1.value29 = p112
        RunService3.CustomFOVValue = p112
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t39 = {}

            for k, v in pairs(RunService3) do
                local v613 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t39[v613] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t39[v613] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t39))
        end)

        if t1.value32 and t1.value9 then
            t1.value9.FieldOfView = p112
        end
    end)
    v60(RunService19.CustomFOVToggle.collapsible, "Wall Texture", {
        "None",
        "Dark Texture",
        "Glass Texture",
        "Metal Texture"
    }, RunService3.WallTextureType, function(p113)
        RunService3.WallTextureType = p113
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t40 = {}

            for k, v in pairs(RunService3) do
                local v620 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t40[v620] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t40[v620] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t40))
        end)
        t1.value35(p113)
    end)
end
RunService19.DeviceSpoofToggle = v57("Visual", "Device Spoof", RunService3.DeviceSpoofEnabled, function(p114)
    t1.value24 = p114
    RunService3.DeviceSpoofEnabled = p114
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t41 = {}

        for k, v in pairs(RunService3) do
            local v597 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                t41[v597] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                t41[v597] = v
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(t41))
    end)

    if p114 then
        if RunService3.DeviceSpoofType == "Random" then
            t1.value30()
            t1.value3.Heartbeat:Connect(function()
                local v601 = t1.value27[math.random(1, #t1.value27)]

                t1.value28(v601)
                task.wait(1)
            end)

            return
        end

        if RunService3.DeviceSpoofType ~= "None" then
            t1.value30()
            t1.value28(RunService3.DeviceSpoofType)

            return
        end
    else
        t1.value30()
    end
end, "right", true)

if RunService19.DeviceSpoofToggle.collapsible then
    v60(RunService19.DeviceSpoofToggle.collapsible, "Device", {
        "None",
        "Random",
        "PC",
        "Mobile",
        "Controller",
        "VR"
    }, RunService3.DeviceSpoofType, function(p115)
        RunService3.DeviceSpoofType = p115
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t42 = {}

            for k, v in pairs(RunService3) do
                local v605 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t42[v605] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t42[v605] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t42))
        end)

        if t1.value24 then
            if p115 == "Random" then
                t1.value30()
                t1.value3.Heartbeat:Connect(function()
                    local v609 = t1.value27[math.random(1, #t1.value27)]

                    t1.value28(v609)
                    task.wait(1)
                end)

                return
            end

            if p115 ~= "None" then
                t1.value30()
                t1.value28(p115)

                return
            end

            t1.value30()
        end
    end)
end
RunService19.FlyToggle = v57("Misc", "Fly", RunService3.Fly, function(p116)
    if p116 then
        HttpService5()

        return
    end

    if HttpService0 then
        HttpService0.PlatformStand = false
    end

    if t1.value67 then
        t1.value67:Destroy()
    end
end, "left", true)

if RunService19.FlyToggle.collapsible then
    v56(RunService19.FlyToggle.collapsible, "Fly Speed", 1, 500, RunService3.FlySpeed, function(p117)
        RunService3.FlySpeed = p117
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t43 = {}

            for k, v in pairs(RunService3) do
                local v740 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t43[v740] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t43[v740] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t43))
        end)
    end)
end
RunService19.InfiniteJumpToggle = v57("Misc", "Infinite Jump", RunService3.InfiniteJump, function(p118)
    if p118 then
        HttpService8()

        return
    end

    HttpService9()
end, "right")
RunService19.NoclipToggle = v57("Misc", "Noclip", RunService3.Noclip, function(p119)
    if p119 then
        t1.value80()

        return
    end

    t1.value81()
end, "right")
RunService19.AnimationToggle = v57("Animation", "Enable Animation", RunService3.AnimationEnabled, function(p120)
    if p120 then
        t1.value88.enabled = true

        local v382 = t1.value90[RunService3.AnimationPreset]

        if v382 then
            t1.value88.animationId = v382
        end

        t1.value88.speed = RunService3.AnimationSpeed
        t1.value88.loop = true
        t1.value88.serverSide = true
        v64()

        return
    end

    t1.value88.enabled = false
    t1.value91()
end, "left", true)

if RunService19.AnimationToggle.collapsible then
    v56(RunService19.AnimationToggle.collapsible, "Animation Speed", 1, 500, RunService3.AnimationSpeed, function(p121)
        RunService3.AnimationSpeed = p121
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t44 = {}

            for k, v in pairs(RunService3) do
                local v812 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t44[v812] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t44[v812] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t44))
        end)
        t1.value88.speed = p121
    end)
    v60(RunService19.AnimationToggle.collapsible, "Anim Preset", {
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
    }, RunService3.AnimationPreset, function(p122)
        RunService3.AnimationPreset = p122
        pcall(function()
            if not isfolder or not makefolder then
                return
            end

            if not isfolder("oishi_hub") then
                makefolder("oishi_hub")
            end

            local t45 = {}

            for k, v in pairs(RunService3) do
                local v805 = k

                if typeof(value) == "Color3" then
                    local R = value.R
                    local G = value.G
                    local B = value.B

                    t45[v805] = {
                        r = R,
                        g = G,
                        b = B
                    }
                else
                    t45[v805] = v
                end
            end

            writefile("oishi_hub/settings.json", HttpService:JSONEncode(t45))
        end)

        local v384 = t1.value90[p122]

        if v384 then
            t1.value88.animationId = v384

            if t1.value88.enabled then
                v64()
            end
        end
    end)
end
RunService20 = nil
function RunService20()
    if RunService3.Ragebot then
        RunService3.Ragebot = false
        t1.value45()
        RunService19.RagebotToggle.setState(false)
    end

    if RunService3.AutoShoot then
        RunService3.AutoShoot = false
        t1.value63()
        RunService19.AutoShootToggle.setState(false)
    end

    if RunService3.RapidFire then
        RunService3.RapidFire = false
        t1.value65()
        RunService19.RapidFireToggle.setState(false)
    end

    if RunService3.Fly then
        RunService3.Fly = false

        if HttpService0 then
            HttpService0.PlatformStand = false
        end

        if t1.value67 then
            t1.value67:Destroy()
        end

        RunService19.FlyToggle.setState(false)
    end

    if RunService3.InfiniteJump then
        RunService3.InfiniteJump = false
        HttpService9()
        RunService19.InfiniteJumpToggle.setState(false)
    end

    if RunService3.Noclip then
        RunService3.Noclip = false
        t1.value81()
        RunService19.NoclipToggle.setState(false)
    end

    if RunService3.AnimationEnabled then
        RunService3.AnimationEnabled = false
        t1.value88.enabled = false
        t1.value91()
        RunService19.AnimationToggle.setState(false)
    end

    if RunService3.AimbotEnabled then
        RunService3.AimbotEnabled = false
        RunService13(false)
        RunService19.AimbotToggle.setState(false)
    end

    if RunService3.Esp then
        RunService3.Esp = false
        t1.value87()
        RunService19.EspToggle.setState(false)
    end
end
function RunService21()
    RunService20()
    RunService3.AimbotEnabled = true
    RunService3.AimbotShowFOV = true
    RunService3.AimbotSmoothness = 0
    RunService3.AimbotCurve = "Instant"
    RunService3.AimbotWallCheck = true
    RunService3.AimbotAliveCheck = true
    RunService3.AimbotTeamCheck = true
    RunService3.AimbotFollowMuzzle = true
    RunService13(true)
    RunService14(true)
    RunService15(true)
    RunService16(true)
    RunService17(true)
    RunService18(true)
    RunService19.AimbotToggle.setState(true)
    RunService3.Esp = true
    RunService3.EspBoxes = true
    RunService3.EspHealth = true
    RunService3.EspNames = true
    RunService3.EspDistance = true
    RunService3.EspTracers = true
    t1.value46 = true

    if t1.value53 then
        t1.value53:Disconnect()
    end

    t1.value3.RenderStepped:Connect(t1.value86)
    RunService19.EspToggle.setState(true)
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t46 = {}

        for k, v in pairs(RunService3) do
            local v896 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                t46[v896] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                t46[v896] = v
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(t46))
    end)
end
function RunService22()
    RunService20()
    RunService3.Ragebot = true
    RunService3.AutoShoot = true
    RunService3.RapidFire = true
    t1.value44()
    t1.value62()
    t1.value64()
    RunService19.RagebotToggle.setState(true)
    RunService19.AutoShootToggle.setState(true)
    RunService19.RapidFireToggle.setState(true)
    RunService3.Esp = true
    RunService3.EspBoxes = true
    RunService3.EspHealth = true
    RunService3.EspNames = true
    RunService3.EspDistance = true
    RunService3.EspTracers = true
    t1.value46 = true

    if t1.value53 then
        t1.value53:Disconnect()
    end

    t1.value3.RenderStepped:Connect(t1.value86)
    RunService19.EspToggle.setState(true)
    RunService3.Fly = true
    RunService3.InfiniteJump = true
    RunService3.Noclip = true
    HttpService5()
    HttpService8()
    t1.value80()
    RunService19.FlyToggle.setState(true)
    RunService19.InfiniteJumpToggle.setState(true)
    RunService19.NoclipToggle.setState(true)
    RunService3.AnimationEnabled = true
    RunService3.AnimationPreset = "Spin"
    RunService3.AnimationSpeed = 500
    t1.value88.enabled = true

    local v491 = t1.value90[RunService3.AnimationPreset]

    if v491 then
        t1.value88.animationId = v491
    end

    t1.value88.speed = RunService3.AnimationSpeed
    t1.value88.loop = true
    t1.value88.serverSide = true
    v64()
    RunService19.AnimationToggle.setState(true)
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t47 = {}

        for k, v in pairs(RunService3) do
            local v889 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                t47[v889] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                t47[v889] = v
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(t47))
    end)
end
RunService19.LegitConfigButton = v58("Config", "Enable Legit Config", function(p123)
    if p123 then
        RunService3.LegitConfigEnabled = true
        RunService3.RagebotConfigEnabled = false
        RunService19.RagebotConfigButton.setState(false)
        RunService21()

        return
    end

    RunService3.LegitConfigEnabled = false
    RunService20()
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t48 = {}

        for k, v in pairs(RunService3) do
            local v903 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                t48[v903] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                t48[v903] = v
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(t48))
    end)
end)
RunService19.RagebotConfigButton = v58("Config", "Enable Ragebot Config", function(p124)
    if p124 then
        RunService3.RagebotConfigEnabled = true
        RunService3.LegitConfigEnabled = false
        RunService19.LegitConfigButton.setState(false)
        RunService22()

        return
    end

    RunService3.RagebotConfigEnabled = false
    RunService20()
    pcall(function()
        if not isfolder or not makefolder then
            return
        end

        if not isfolder("oishi_hub") then
            makefolder("oishi_hub")
        end

        local t49 = {}

        for k, v in pairs(RunService3) do
            local v910 = k

            if typeof(value) == "Color3" then
                local R = value.R
                local G = value.G
                local B = value.B

                t49[v910] = {
                    r = R,
                    g = G,
                    b = B
                }
            else
                t49[v910] = v
            end
        end

        writefile("oishi_hub/settings.json", HttpService:JSONEncode(t49))
    end)
end)
task.wait(0.1)

for _, v in pairs(t1.value22) do
    v.leftScroll.CanvasSize = UDim2.new(0, 0, 0, v.leftLayout.AbsoluteContentSize.Y + 20)
    v.rightScroll.CanvasSize = UDim2.new(0, 0, 0, v.rightLayout.AbsoluteContentSize.Y + 20)
end
RunService23 = false
RunService24 = nil
RunService25 = nil
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        RunService23 = true
        RunService24 = input.Position
        RunService25 = RunService6.Position
    end
end)
t1.value2.InputChanged:Connect(function(input)
    if not RunService23 then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local v496 = input.Position - RunService24

        RunService6.Position = UDim2.new(RunService25.X.Scale, RunService25.X.Offset + v496.X, RunService25.Y.Scale, RunService25.Y.Offset + v496.Y)
    end
end)
t1.value2.InputEnded:Connect(function(input)
    if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
    end
end)

if v4 then
    local TextButton10 = Instance.new("TextButton")

    TextButton10.Size = UDim2.new(0, 88, 0, 30)
    TextButton10.Position = UDim2.new(0, 10, 0, 150)
    TextButton10.BackgroundColor3 = RunService0.Accent
    TextButton10.BorderSizePixel = 1
    TextButton10.BorderColor3 = RunService0.Border
    TextButton10.Text = "Toggle UI"
    TextButton10.Font = RunService0.Font
    TextButton10.TextSize = 10
    TextButton10.TextColor3 = Color3.new(1, 1, 1)
    TextButton10.ZIndex = 999999
    TextButton10.AutoButtonColor = false
    TextButton10.Parent = RunService5

    local UICorner21 = Instance.new("UICorner")

    UICorner21.CornerRadius = UDim.new(0, 3)
    UICorner21.Parent = TextButton10
    TextButton10.MouseButton1Click:Connect(function()
        if RunService6.Visible then
            RunService9()

            return
        end

        RunService8()
    end)
end
if v5 then
    t1.value2.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if input.KeyCode == Enum.KeyCode.RightShift then
            if RunService6.Visible then
                RunService9()

                return
            end

            RunService8()
        end
    end)
end
pcall(function()
    if writefile and (isfolder and makefolder) then
        if not isfolder("autoexec") then
            makefolder("autoexec")
        end

        local source = debug.getinfo(1, "S").source

        if source and source:sub(1, 1) == "@" then
            local v501 = source:sub(2)

            if isfile(v501) then
                local v502 = readfile(v501)

                writefile("autoexec/oishi_hub.lua", v502)
            end
        end
    end
end)
RunService8()
