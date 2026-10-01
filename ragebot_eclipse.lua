-- ╔════════════════════════════════════════════════════════════╗
-- ║  Ragebot + Priority  ·  Eclipse UI                        ║
-- ╚════════════════════════════════════════════════════════════╝

-- ── Services ─────────────────────────────────────────────────
local cloneref = cloneref or function(obj) return obj end

local Players        = cloneref(game:GetService("Players"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService   = cloneref(game:GetService("TweenService"))
local RunService     = cloneref(game:GetService("RunService"))
local CoreGui        = cloneref(game:GetService("CoreGui"))
local Lighting       = cloneref(game:GetService("Lighting"))

local Player  = Players.LocalPlayer
local Mouse   = Player:GetMouse()

-- ── Shooting Range Detection ──────────────────────────────────
local shootingRangeCache   = false
local shootingRangeChecked = 0

local function isShootingRange()
    local now = os.clock()
    if now - shootingRangeChecked < 0.5 then return shootingRangeCache end
    shootingRangeChecked = now

    local function matches(value)
        if value == nil then return false end
        local text = tostring(value):lower():gsub("[%s_%-]", "")
        return text:find("shootingrange", 1, true) ~= nil
            or text:find("firingrange",   1, true) ~= nil
    end

    for _, object in ipairs({workspace, Player}) do
        for _, attr in ipairs({"Map","MapName","Mode","GameMode","Arena","Environment","EnvironmentName","ShootingRange"}) do
            local value = object:GetAttribute(attr)
            if (value == true and attr == "ShootingRange") or matches(value) then
                shootingRangeCache = true; return true
            end
        end
    end

    local char = Player.Character
    local current = char
    while current and current ~= workspace do
        if matches(current.Name) then shootingRangeCache = true; return true end
        current = current.Parent
    end

    local root = char and char:FindFirstChild("HumanoidRootPart")
    local function nearMatch(obj)
        if not matches(obj.Name) or not root then return false end
        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
        return part and (part.Position - root.Position).Magnitude < 2000
    end
    for _, child in ipairs(workspace:GetChildren()) do
        if nearMatch(child) then shootingRangeCache = true; return true end
        for _, gc in ipairs(child:GetChildren()) do
            if nearMatch(gc) then shootingRangeCache = true; return true end
        end
    end

    shootingRangeCache = false
    return false
end

-- ╔════════════════════════════════════════════════════════════╗
-- ║  ECLIPSE UI LIBRARY                                        ║
-- ╚════════════════════════════════════════════════════════════╝

local ViewportSize = workspace.CurrentCamera.ViewportSize

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

local Library = {
    Flags       = {},
    Connections = {},
    Unloaded    = false
}

local function Create(class, props, children)
    local inst = Instance.new(class)
    for i, v in pairs(props or {}) do inst[i] = v end
    for _, child in pairs(children or {}) do child.Parent = inst end
    return inst
end

local function Tween(obj, props, time, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function GetTextSize(text, size, font)
    return game:GetService("TextService"):GetTextSize(text, size, font, Vector2.new(10000, 10000))
end

local ScreenGui = Create("ScreenGui", {
    Name             = "EclipseUI",
    Parent           = CoreGui,
    ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn     = false,
    IgnoreGuiInset   = true
})

local UIScale = Create("UIScale", {Parent = ScreenGui})

local function UpdateScale()
    local vp          = workspace.CurrentCamera.ViewportSize
    local widthRatio  = (vp.X - 40) / CFG.BaseSize.X
    local heightRatio = (vp.Y - 40) / CFG.BaseSize.Y
    local scale       = math.min(widthRatio, heightRatio, 1)
    UIScale.Scale     = math.max(scale, 0.6)
end
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
UpdateScale()

-- Notifications
local NotificationContainer = Create("Frame", {
    Parent              = ScreenGui,
    Position            = UDim2.new(1, -20, 0, 20),
    AnchorPoint         = Vector2.new(1, 0),
    Size                = UDim2.new(0, 300, 1, 0),
    BackgroundTransparency = 1,
    ZIndex              = 100
})
Create("UIListLayout", {
    Parent              = NotificationContainer,
    Padding             = UDim.new(0, 5),
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment   = Enum.VerticalAlignment.Top
})

function Library:Notify(msg, type)
    local color = (type == "success" and Color3.fromRGB(100, 255, 100))
               or (type == "warning" and Color3.fromRGB(255, 100, 100))
               or CFG.AccentColor
    local Frame = Create("Frame", {
        Parent              = NotificationContainer,
        Size                = UDim2.new(0, 0, 0, 30),
        BackgroundColor3    = CFG.MainColor,
        BorderSizePixel     = 0,
        ClipsDescendants    = true
    }, {
        Create("UIStroke",   {Color = CFG.AccentColor, Thickness = 1, Transparency = 0.5}),
        Create("Frame",      {Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = color}),
        Create("TextLabel",  {
            Text               = msg,
            TextColor3         = CFG.TextColor,
            Font               = CFG.Font,
            TextSize           = 12,
            Size               = UDim2.new(1, -10, 1, 0),
            Position           = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment     = Enum.TextXAlignment.Left
        })
    })
    Tween(Frame, {Size = UDim2.new(0, 250, 0, 35)}, 0.5, Enum.EasingStyle.Back)
    task.delay(3, function()
        Tween(Frame, {Size = UDim2.new(0, 250, 0, 0), BackgroundTransparency = 1}, 0.5)
        task.wait(0.5)
        Frame:Destroy()
    end)
end

-- Tooltip
local TooltipLabel = Create("TextLabel", {
    Parent              = ScreenGui,
    Size                = UDim2.new(0, 0, 0, 20),
    BackgroundColor3    = CFG.SecondaryColor,
    TextColor3          = CFG.TextColor,
    TextSize            = 11,
    Font                = CFG.Font,
    BorderSizePixel     = 0,
    Visible             = false,
    ZIndex              = 200
}, {
    Create("UIPadding",  {PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)}),
    Create("UIStroke",   {Color = CFG.StrokeColor})
})

local function AddTooltip(obj, text)
    obj.MouseEnter:Connect(function()
        TooltipLabel.Text = text
        TooltipLabel.Size = UDim2.fromOffset(GetTextSize(text, 11, CFG.Font).X + 12, 20)
        TooltipLabel.Visible = true
    end)
    obj.MouseLeave:Connect(function() TooltipLabel.Visible = false end)
end

RunService.RenderStepped:Connect(function()
    if TooltipLabel.Visible then
        local m = UserInputService:GetMouseLocation()
        TooltipLabel.Position = UDim2.fromOffset(m.X + 15, m.Y + 15)
    end
end)

-- Main Frame
local MainFrame = Create("Frame", {
    Name             = "MainFrame",
    Parent           = ScreenGui,
    Size             = UDim2.fromOffset(CFG.BaseSize.X, CFG.BaseSize.Y),
    Position         = UDim2.new(0.5, -300, 0.5, -225),
    BackgroundColor3 = CFG.MainColor,
    BorderSizePixel  = 0
}, {
    Create("UIStroke", {Color = CFG.StrokeColor}),
    Create("UICorner", {CornerRadius = UDim.new(0, 3)})
})

-- Drag
local Dragging, DragInput, DragStart, StartPos = false, nil, nil, nil
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos  = MainFrame.Position
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
        local delta = input.Position - DragStart
        Tween(MainFrame, {Position = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + delta.X,
            StartPos.Y.Scale, StartPos.Y.Offset + delta.Y
        )}, 0.05)
    end
end)

-- TopBar
local TopBar = Create("Frame", {
    Parent           = MainFrame,
    Size             = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = CFG.MainColor,
    BorderSizePixel  = 0
}, {
    Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = CFG.StrokeColor
    })
})

local TitleLabel = Create("TextLabel", {
    Parent             = TopBar,
    Text               = "eclipse.wtf | ragebot",
    TextColor3         = CFG.TextDark,
    TextSize           = 13,
    Font               = CFG.Font,
    BackgroundTransparency = 1,
    Size               = UDim2.new(0, 220, 1, 0),
    Position           = UDim2.new(0, 10, 0, 0),
    TextXAlignment     = Enum.TextXAlignment.Left,
    RichText           = true
})

task.spawn(function()
    local textList = {
        '', 'e', 'ec', 'ecl', 'ecli', 'eclip', 'eclipse', 'eclipse.', 'eclipse.w',
        'eclipse.wt', 'eclipse.wtf', 'eclipse.wtf |', 'eclipse.wtf | r',
        'eclipse.wtf | ra', 'eclipse.wtf | rag', 'eclipse.wtf | rage', 'eclipse.wtf | rageb',
        'eclipse.wtf | ragebot', 'eclipse.wtf | ragebo', 'eclipse.wtf | rageb',
        'eclipse.wtf | rage', 'eclipse.wtf | rag', 'eclipse.wtf | ra', 'eclipse.wtf | r',
        'eclipse.wtf |', 'eclipse.wtf', 'eclipse.wt', 'eclipse.w',
        'eclipse.', 'eclipse', 'eclips', 'eclip', 'ecli', 'ecl', 'ec', 'e'
    }
    while not Library.Unloaded do
        for _, text in ipairs(textList) do
            if Library.Unloaded then break end
            local display = text
            if text:find("ragebot") then
                display = text:gsub("ragebot", '<font color="#bdacff">ragebot</font>')
            elseif text:find("wtf") then
                display = text:gsub("wtf", '<font color="#bdacff">wtf</font>')
            end
            TitleLabel.Text = display
            task.wait(0.2)
        end
    end
end)

-- Layout
local ContentContainer = Create("Frame", {
    Parent               = MainFrame,
    Size                 = UDim2.new(1, 0, 1, -30),
    Position             = UDim2.new(0, 0, 0, 30),
    BackgroundTransparency = 1
})

local Sidebar = Create("Frame", {
    Parent           = ContentContainer,
    Size             = UDim2.new(0, 60, 1, 0),
    BackgroundColor3 = Color3.fromRGB(17, 17, 17),
    BorderSizePixel  = 0
}, {
    Create("Frame", {Size = UDim2.new(0, 1, 0, 0), Position = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = CFG.StrokeColor}),
    Create("UIListLayout", {Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top}),
    Create("UIPadding", {PaddingTop = UDim.new(0, 15)})
})

local PagesContainer = Create("Frame", {
    Parent               = ContentContainer,
    Size                 = UDim2.new(1, -60, 1, 0),
    Position             = UDim2.new(0, 60, 0, 0),
    BackgroundTransparency = 1
})

local Tabs      = {}
local CurrentTab = nil

function Library:Tab(name, icon)
    local TabButton = Create("TextButton", {
        Parent           = Sidebar,
        Size             = UDim2.new(0, 40, 0, 40),
        BackgroundColor3 = CFG.MainColor,
        Text             = "",
        TextSize         = 20,
        TextColor3       = CFG.TextDark,
        Font             = CFG.Font,
        AutoButtonColor  = false
    }, {
        Create("ImageLabel", {
            Name                 = "Icon",
            Size                 = UDim2.new(0.6, 0, 0.6, 0),
            Position             = UDim2.new(0.2, 0, 0.2, 0),
            BackgroundTransparency = 1,
            Image                = "rbxassetid://" .. icon,
            ImageColor3          = CFG.TextDark
        }),
        Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    })

    local PageFrame = Create("ScrollingFrame", {
        Parent                = PagesContainer,
        Size                  = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible               = false,
        ScrollBarThickness    = 2,
        ScrollBarImageColor3  = CFG.AccentColor,
        CanvasSize            = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize   = Enum.AutomaticSize.Y
    })

    PageFrame:ClearAllChildren()
    Create("UIPadding", {
        Parent       = PageFrame,
        PaddingTop   = UDim.new(0, 15), PaddingLeft  = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15)
    })

    local LeftCol = Create("Frame", {
        Parent               = PageFrame,
        Size                 = UDim2.new(0.48, 0, 1, 0),
        BackgroundTransparency = 1
    }, {
        Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})
    })
    local RightCol = Create("Frame", {
        Parent               = PageFrame,
        Size                 = UDim2.new(0.48, 0, 1, 0),
        Position             = UDim2.new(0.52, 0, 0, 0),
        BackgroundTransparency = 1
    }, {
        Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})
    })

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            Tween(t.Btn, {TextColor3 = CFG.TextDark, BackgroundColor3 = CFG.MainColor}, 0.2)
            t.Page.Visible = false
        end
        Tween(TabButton, {TextColor3 = CFG.AccentColor, BackgroundColor3 = CFG.SecondaryColor}, 0.2)
        PageFrame.Visible = true
        CurrentTab = PageFrame
    end)

    table.insert(Tabs, {Btn = TabButton, Page = PageFrame})

    if #Tabs == 1 then
        Tween(TabButton, {TextColor3 = CFG.AccentColor, BackgroundColor3 = CFG.SecondaryColor}, 0.2)
        PageFrame.Visible = true
    end

    local GroupFunctions = {}
    local LeftSide = true

    function GroupFunctions:Group(title)
        local ParentCol = LeftSide and LeftCol or RightCol
        LeftSide = not LeftSide

        local GroupFrame = Create("Frame", {
            Parent           = ParentCol,
            Size             = UDim2.new(1, 0, 0, 0),
            AutomaticSize    = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(17, 17, 17),
            BorderSizePixel  = 0
        }, {
            Create("UIStroke", {Color = CFG.StrokeColor}),
            Create("UICorner", {CornerRadius = UDim.new(0, 2)})
        })

        Create("Frame", {
            Parent           = GroupFrame,
            Size             = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = CFG.SecondaryColor,
            BorderSizePixel  = 0
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 2)}),
            Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 5),
                Position         = UDim2.new(0, 0, 1, -5),
                BackgroundColor3 = CFG.SecondaryColor,
                BorderSizePixel  = 0
            }),
            Create("TextLabel", {
                Text           = title,
                Size           = UDim2.new(1, -20, 1, 0),
                Position       = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                TextColor3     = CFG.TextColor,
                Font           = Enum.Font.GothamBold,
                TextSize       = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Create("Frame", {
                Size             = UDim2.new(0, 4, 0, 4),
                Position         = UDim2.new(1, -10, 0.5, -2),
                BackgroundColor3 = CFG.AccentColor,
                BorderSizePixel  = 0
            }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
        })

        local Content = Create("Frame", {
            Parent               = GroupFrame,
            Size                 = UDim2.new(1, 0, 0, 0),
            Position             = UDim2.new(0, 0, 0, 25),
            AutomaticSize        = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1
        }, {
            Create("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}),
            Create("UIPadding", {
                PaddingTop    = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
                PaddingLeft   = UDim.new(0, 8), PaddingRight  = UDim.new(0, 8)
            })
        })

        local ItemFuncs = {}

        function ItemFuncs:Toggle(cfg)
            local Enabled = cfg.Default or false
            local Frame   = Create("TextButton", {
                Parent             = Content,
                Size               = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text               = ""
            })
            local Box = Create("Frame", {
                Parent           = Frame,
                Size             = UDim2.new(0, 12, 0, 12),
                Position         = UDim2.new(0, 0, 0.5, -6),
                BackgroundColor3 = CFG.SecondaryColor,
                BorderSizePixel  = 0
            }, {Create("UIStroke", {Color = CFG.StrokeColor})})
            local Check = Create("Frame", {
                Parent             = Box,
                Size               = UDim2.new(1, -4, 1, -4),
                Position           = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint        = Vector2.new(0.5, 0.5),
                BackgroundColor3   = CFG.AccentColor,
                BackgroundTransparency = Enabled and 0 or 1
            })
            local Label = Create("TextLabel", {
                Parent             = Frame,
                Text               = cfg.Name,
                TextColor3         = Enabled and CFG.TextColor or (cfg.Risky and Color3.fromRGB(200, 80, 80) or CFG.TextDark),
                TextSize           = 11,
                Font               = CFG.Font,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, 18, 0, 0),
                Size               = UDim2.new(1, -18, 1, 0),
                TextXAlignment     = Enum.TextXAlignment.Left
            })
            if cfg.Risky then Label.TextColor3 = Color3.fromRGB(200, 80, 80) end
            if cfg.Tooltip then AddTooltip(Frame, cfg.Tooltip) end
            local function Update()
                Enabled = not Enabled
                Tween(Check, {BackgroundTransparency = Enabled and 0 or 1}, 0.1)
                Tween(Label, {TextColor3 = Enabled and CFG.TextColor or (cfg.Risky and Color3.fromRGB(200, 80, 80) or CFG.TextDark)}, 0.1)
                if cfg.Callback then cfg.Callback(Enabled) end
            end
            if Enabled and cfg.Callback then cfg.Callback(true) end
            Frame.MouseButton1Click:Connect(Update)
            return {
                Set = function(v) if v ~= Enabled then Update() end end,
                Get = function() return Enabled end
            }
        end

        function ItemFuncs:Slider(cfg)
            local Value         = cfg.Default or cfg.Min
            local DraggingSlider = false
            local Frame = Create("Frame", {
                Parent             = Content,
                Size               = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1
            })
            local Label = Create("TextLabel", {
                Parent             = Frame,
                Text               = cfg.Name,
                TextColor3         = CFG.TextDark,
                TextSize           = 11,
                Font               = CFG.Font,
                BackgroundTransparency = 1,
                Size               = UDim2.new(1, 0, 0, 15),
                TextXAlignment     = Enum.TextXAlignment.Left
            })
            local ValueLabel = Create("TextLabel", {
                Parent             = Frame,
                Text               = Value .. (cfg.Unit or ""),
                TextColor3         = CFG.TextDark,
                TextSize           = 11,
                Font               = CFG.Font,
                BackgroundTransparency = 1,
                Size               = UDim2.new(1, 0, 0, 15),
                TextXAlignment     = Enum.TextXAlignment.Right
            })
            local SliderBG = Create("Frame", {
                Parent           = Frame,
                Size             = UDim2.new(1, 0, 0, 6),
                Position         = UDim2.new(0, 0, 0, 20),
                BackgroundColor3 = CFG.SecondaryColor,
                BorderSizePixel  = 0
            }, {
                Create("UIStroke", {Color = CFG.StrokeColor}),
                Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            local Fill = Create("Frame", {
                Parent           = SliderBG,
                Size             = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = CFG.AccentColor
            }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            local decimal = cfg.Decimal or 1
            local function UpdateSlider(input)
                local SizeX  = SliderBG.AbsoluteSize.X
                local PosX   = SliderBG.AbsolutePosition.X
                local Percent = math.clamp((input.Position.X - PosX) / SizeX, 0, 1)
                Value = math.floor((cfg.Min + (cfg.Max - cfg.Min) * Percent) * decimal + 0.5) / decimal
                Fill.Size       = UDim2.new(Percent, 0, 1, 0)
                ValueLabel.Text = Value .. (cfg.Unit or "")
                if cfg.Callback then cfg.Callback(Value) end
            end
            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    DraggingSlider = true
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if DraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    DraggingSlider = false
                end
            end)
            local initPct = (Value - cfg.Min) / (cfg.Max - cfg.Min)
            Fill.Size = UDim2.new(initPct, 0, 1, 0)
            if cfg.Tooltip then AddTooltip(Frame, cfg.Tooltip) end
            return {
                Set = function(v)
                    Value = math.clamp(v, cfg.Min, cfg.Max)
                    local pct = (Value - cfg.Min) / (cfg.Max - cfg.Min)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    ValueLabel.Text = Value .. (cfg.Unit or "")
                end,
                Get = function() return Value end
            }
        end

        function ItemFuncs:Dropdown(cfg)
            local Expanded = false
            local Current  = cfg.Default or cfg.Options[1]
            local Frame = Create("Frame", {
                Parent             = Content,
                Size               = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                ZIndex             = 20
            })
            Create("TextLabel", {
                Parent             = Frame,
                Text               = cfg.Name,
                TextColor3         = CFG.TextDark,
                TextSize           = 11,
                Font               = CFG.Font,
                BackgroundTransparency = 1,
                Size               = UDim2.new(1, 0, 0, 15),
                TextXAlignment     = Enum.TextXAlignment.Left
            })
            local MainBox = Create("TextButton", {
                Parent           = Frame,
                Size             = UDim2.new(1, 0, 0, 20),
                Position         = UDim2.new(0, 0, 0, 16),
                BackgroundColor3 = CFG.SecondaryColor,
                BorderSizePixel  = 0,
                Text             = "",
                AutoButtonColor  = false
            }, {
                Create("UIStroke", {Color = CFG.StrokeColor}),
                Create("UICorner", {CornerRadius = UDim.new(0, 3)}),
                Create("TextLabel", {
                    Name               = "Val",
                    Text               = Current or "none",
                    Size               = UDim2.new(1, -20, 1, 0),
                    Position           = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3         = CFG.TextColor,
                    TextSize           = 11,
                    Font               = CFG.Font,
                    TextXAlignment     = Enum.TextXAlignment.Left
                }),
                Create("TextLabel", {
                    Text               = "▼",
                    Size               = UDim2.new(0, 20, 1, 0),
                    Position           = UDim2.new(1, -20, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3         = CFG.TextDark,
                    TextSize           = 10
                })
            })
            local ListFrame = Create("ScrollingFrame", {
                Parent                = MainBox,
                Size                  = UDim2.new(1, 0, 0, 0),
                Position              = UDim2.new(0, 0, 1, 2),
                BackgroundColor3      = CFG.SecondaryColor,
                BorderSizePixel       = 0,
                Visible               = false,
                ZIndex                = 50,
                CanvasSize            = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize   = Enum.AutomaticSize.Y,
                ScrollBarThickness    = 2
            }, {
                Create("UIStroke", {Color = CFG.StrokeColor}),
                Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}),
                Create("UICorner",  {CornerRadius = UDim.new(0, 3)})
            })
            local Buttons = {}
            local function buildList()
                for _, b in pairs(Buttons) do b:Destroy() end
                Buttons = {}
                for _, opt in pairs(cfg.Options or {}) do
                    local Btn = Create("TextButton", {
                        Parent             = ListFrame,
                        Size               = UDim2.new(1, 0, 0, 20),
                        BackgroundTransparency = 1,
                        Text               = opt ~= "" and opt or "none",
                        TextColor3         = (opt == Current) and CFG.AccentColor or CFG.TextDark,
                        TextSize           = 11,
                        Font               = CFG.Font
                    })
                    Btn.MouseButton1Click:Connect(function()
                        for _, b in pairs(Buttons) do
                            Tween(b, {TextColor3 = CFG.TextDark}, 0.1)
                        end
                        Tween(Btn, {TextColor3 = CFG.AccentColor}, 0.1)
                        Current = opt
                        MainBox.Val.Text = opt ~= "" and opt or "none"
                        if cfg.Callback then cfg.Callback(opt) end
                        Expanded = false
                        Tween(ListFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.1)
                        task.wait(0.1)
                        ListFrame.Visible = false
                    end)
                    table.insert(Buttons, Btn)
                end
            end
            buildList()
            MainBox.MouseButton1Click:Connect(function()
                Expanded = not Expanded
                if Expanded then
                    ListFrame.Visible = true
                    Tween(ListFrame, {Size = UDim2.new(1, 0, 0, math.min(#(cfg.Options or {}) * 20, 100))}, 0.1)
                else
                    Tween(ListFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.1)
                    task.wait(0.1)
                    ListFrame.Visible = false
                end
            end)
            if cfg.Tooltip then AddTooltip(Frame, cfg.Tooltip) end
            return {
                Set = function(v)
                    Current = v
                    MainBox.Val.Text = v ~= "" and v or "none"
                    if cfg.Callback then cfg.Callback(v) end
                end,
                SetOptions = function(opts)
                    cfg.Options = opts
                    -- Reset current if not in new list
                    local found = false
                    for _, o in ipairs(opts) do if o == Current then found = true end end
                    if not found then
                        Current = opts[1] or ""
                        MainBox.Val.Text = Current ~= "" and Current or "none"
                    end
                    buildList()
                end,
                Get = function() return Current end
            }
        end

        function ItemFuncs:Keybind(cfg)
            local Key     = cfg.Default or Enum.KeyCode.Unknown
            local Waiting = false
            local Frame   = Create("Frame", {
                Parent             = Content,
                Size               = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1
            })
            Create("TextLabel", {
                Parent             = Frame,
                Text               = cfg.Name,
                TextColor3         = CFG.TextDark,
                TextSize           = 11,
                Font               = CFG.Font,
                BackgroundTransparency = 1,
                Size               = UDim2.new(0.6, 0, 1, 0),
                TextXAlignment     = Enum.TextXAlignment.Left
            })
            local Btn = Create("TextButton", {
                Parent           = Frame,
                Size             = UDim2.new(0, 60, 1, 0),
                AnchorPoint      = Vector2.new(1, 0),
                Position         = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = CFG.SecondaryColor,
                Text             = Key ~= Enum.KeyCode.Unknown and Key.Name or "...",
                TextColor3       = CFG.TextDark,
                TextSize         = 10,
                Font             = CFG.Font
            }, {
                Create("UIStroke", {Color = CFG.StrokeColor}),
                Create("UICorner", {CornerRadius = UDim.new(0, 3)})
            })
            Btn.MouseButton1Click:Connect(function()
                Waiting       = true
                Btn.Text      = "..."
                Btn.TextColor3 = CFG.AccentColor
            end)
            UserInputService.InputBegan:Connect(function(inp)
                if Waiting and inp.UserInputType == Enum.UserInputType.Keyboard then
                    Waiting        = false
                    Key            = inp.KeyCode
                    Btn.Text       = Key.Name
                    Btn.TextColor3 = CFG.TextDark
                    if cfg.Callback then cfg.Callback(Key) end
                end
            end)
            if cfg.Tooltip then AddTooltip(Frame, cfg.Tooltip) end
        end

        function ItemFuncs:Button(cfg)
            local Btn = Create("TextButton", {
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 22),
                BackgroundColor3 = CFG.SecondaryColor,
                Text             = cfg.Name,
                TextColor3       = CFG.TextDark,
                Font             = Enum.Font.GothamBold,
                TextSize         = 10
            }, {
                Create("UIStroke", {Color = CFG.StrokeColor}),
                Create("UICorner", {CornerRadius = UDim.new(0, 3)})
            })
            if cfg.Variant == "Primary" then
                Btn.BackgroundColor3 = CFG.AccentColor
                Btn.TextColor3       = Color3.new(0, 0, 0)
            elseif cfg.Variant == "Danger" then
                Btn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
                Btn.TextColor3       = Color3.new(0, 0, 0)
            end
            Btn.MouseButton1Click:Connect(function()
                if cfg.Callback then cfg.Callback() end
            end)
            if cfg.Tooltip then AddTooltip(Btn, cfg.Tooltip) end
        end

        return ItemFuncs
    end
    return GroupFunctions
end

-- ╔════════════════════════════════════════════════════════════╗
-- ║  RAGEBOT STATUS HUD                                        ║
-- ╚════════════════════════════════════════════════════════════╝

local RagebotStatusMain = Create("Frame", {
    Parent               = ScreenGui,
    Name                 = "RagebotStatus",
    AnchorPoint          = Vector2.new(0, 0),
    Position             = UDim2.new(0.5, -80, 0.08, 0),
    Size                 = UDim2.new(0, 160, 0, 22),
    BackgroundTransparency = 1,
    Visible              = false,
    ZIndex               = 10
})
getgenv().RagebotStatusMain = RagebotStatusMain

local RagebotStatusFrame = Create("Frame", {
    Parent               = RagebotStatusMain,
    Size                 = UDim2.fromScale(1, 1),
    BackgroundColor3     = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0.12,
    BorderSizePixel      = 0
}, {
    Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
    Create("UIStroke",  {Color = CFG.StrokeColor})
})

local RagebotStatusAccent = Create("Frame", {
    Parent           = RagebotStatusFrame,
    AnchorPoint      = Vector2.new(0, 0.5),
    Position         = UDim2.fromScale(0.035, 0.5),
    Size             = UDim2.new(0, 3, 0, 12),
    BackgroundColor3 = CFG.AccentColor,
    BorderSizePixel  = 0
}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})

local RagebotStatusText = Create("TextLabel", {
    Parent             = RagebotStatusFrame,
    BackgroundTransparency = 1,
    Position           = UDim2.fromScale(0.1, 0),
    Size               = UDim2.fromScale(0.88, 1),
    Font               = Enum.Font.Code,
    Text               = "ragebot : void",
    TextColor3         = Color3.fromRGB(200, 200, 200),
    TextScaled         = false,
    TextSize           = 12,
    TextXAlignment     = Enum.TextXAlignment.Left,
    TextYAlignment     = Enum.TextYAlignment.Center
})

local RagebotStatusScale = Create("UIScale", {
    Parent = RagebotStatusFrame,
    Scale  = 0
})

-- Make status HUD draggable
do
    local drag, dragStart, dragStartPos = false, nil, nil
    RagebotStatusMain.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            drag         = true
            dragStart    = inp.Position
            dragStartPos = RagebotStatusMain.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if drag and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            RagebotStatusMain.Position = UDim2.new(
                dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
            )
        end
    end)
end

local RagebotStatusLastText    = ""
local RagebotStatusVisible     = false

local function setRagebotStatus(enabled, target, voiding)
    shared.RagebotActive = enabled
    if not RagebotStatusMain then return end
    local text = "ragebot : void"
    if enabled and target and not voiding then
        text = "ragebot : " .. (target.Name or "target")
    end
    if RagebotStatusLastText ~= text then
        RagebotStatusLastText   = text
        RagebotStatusText.Text  = text
        -- Colour accent based on state
        RagebotStatusAccent.BackgroundColor3 = voiding
            and Color3.fromRGB(255, 120, 80)
            or  CFG.AccentColor
    end
    if enabled ~= RagebotStatusVisible then
        RagebotStatusVisible       = enabled
        RagebotStatusMain.Visible  = true
        TweenService:Create(RagebotStatusScale,
            TweenInfo.new(0.18, Enum.EasingStyle.Exponential),
            {Scale = enabled and 1 or 0}
        ):Play()
        if not enabled then
            task.delay(0.25, function()
                if not RagebotStatusVisible then
                    RagebotStatusMain.Visible = false
                end
            end)
        end
    end
end

-- ╔════════════════════════════════════════════════════════════╗
-- ║  RAGEBOT CORE LOGIC                                        ║
-- ╚════════════════════════════════════════════════════════════╝

local RagebotSettings = {
    on                     = false,
    targetMode             = "Closest",   -- "Closest" | "Lowest Health"
    autoSwitch             = true,
    autoSwapSecondary      = true,
    autoReloadPrimary      = true,
    attackMode             = "gun",
    preferredWeapon        = "primary",
    meleeSlot              = 3,
    weaponSpecialize       = true,
    autoEquipPreferred     = true,
    preferProjectile       = false,
    autoPriority           = false,
    priorityAttackers      = true,
    priorityVoided         = true,
    sendNotification       = false,
    prioritizedPlayer      = nil,
    primarySlot            = 1,
    secondarySlot          = 2,
    acSpd                  = 0.05,
    shootDelay             = 0,
    teleportDelay          = 0.04,
    orbitDist              = 3,
    orbitHeight            = 2,
    randomMovement         = false,
    randomRefresh          = 0.08,
    mode                   = "Orbit",     -- "Orbit" | "Void" | "Teleport" | "Underground"
    strafeSpeed            = 5,
    undergroundDepth       = 6,
    behindDist             = 4,
    antiAim                = false,
    hyper                  = false,
    useManipulation        = true,
    voidSpam               = true,
    voidHideTime           = 0.25,
    voidShootTime          = 0.03,
    shootAttempts          = 1,
    otherMatchAvoidDistance = 1000,
    settleUntil            = 0,
    dirBack                = true,
    dirFront               = false,
    dirLeft                = true,
    dirRight               = true,
    dirUp                  = true,
    dirDown                = false,
}

local function markRagebotSettingsDirty()
    RagebotSettings.settleUntil = 0
end

local rbGen                   = 0
local rbDuelMod, rbInMatchT, rbInMatch = nil, 0, false
local slotKey = {
    [1] = Enum.KeyCode.One,
    [2] = Enum.KeyCode.Two,
    [3] = Enum.KeyCode.Three,
    [4] = Enum.KeyCode.Four
}

-- Active connections list (replaces Ragebot:Clean)
local rbConnections = {}
local function rbClean(conn)
    if conn then table.insert(rbConnections, conn) end
end
local function rbCleanAll()
    for _, c in ipairs(rbConnections) do
        if typeof(c) == "RBXScriptConnection" then pcall(c.Disconnect, c) end
    end
    rbConnections = {}
end

-- ── Ragebot module body ───────────────────────────────────────
local function startRagebot()
    local cfg  = RagebotSettings
    cfg.on     = true
    cfg.settleUntil = 0

    local players   = cloneref(game:GetService("Players"))
    local runservice = cloneref(game:GetService("RunService"))
    local vim       = cloneref(game:GetService("VirtualInputManager"))
    local ws        = cloneref(game:GetService("Workspace"))
    local rs        = cloneref(game:GetService("ReplicatedStorage"))
    local lplr      = players.LocalPlayer

    local util, enums, useItemRemote, fighterCtrl
    pcall(function()
        util           = require(rs.Modules.Utility)
        enums          = require(rs.Modules.EnumLibrary)
        useItemRemote  = rs.Remotes.Replication.Fighter.UseItem
        fighterCtrl    = require(lplr.PlayerScripts.Controllers.FighterController)
    end)

    local state = {
        active           = true,
        target           = nil,
        conn             = nil,
        ammoThread       = nil,
        voidThread       = nil,
        voidHbConn       = nil,
        csyncHbConn      = nil,
        voidExposed      = false,
        voidTargetCF     = nil,
        nextTeleportAt   = 0,
        ammoActionAt     = 0,
        hideOrbitUntil   = 0,
        randPos          = nil,
        randT            = 0,
        lastFakePos      = nil,
        csyncCF          = nil,
        csyncLV          = nil,
        csyncAV          = nil,
        csyncLocalCF     = nil,
        csyncLocalLV     = nil,
        csyncLocalAV     = nil,
        csyncWroteFake   = false,
        noclipConn       = nil,
        suspended        = isShootingRange(),
        weaponKind       = "primary",
        orbitClientCF    = nil,
        orbitRenderRunning = false,
    }

    -- Helpers
    local function getRoot(char)
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function getFighter()
        if fighterCtrl and fighterCtrl.LocalFighter  then return fighterCtrl.LocalFighter end
        if fighterCtrl and fighterCtrl.GetFighter then
            local ok, f = pcall(fighterCtrl.GetFighter, fighterCtrl, lplr)
            if ok then return f end
        end
    end

    local function pressKey(kc)
        vim:SendKeyEvent(true,  kc, false, game)
        task.wait(0.03)
        vim:SendKeyEvent(false, kc, false, game)
    end

    local function scanWeapon(plr)
        local vms = ws:FindFirstChild("ViewModels")
        if not vms then return "" end
        for _, model in vms:GetChildren() do
            if model:IsA("Model") then
                local sp = model.Name:find(" - ", 1, true)
                if sp and model.Name:sub(1, sp - 1) == plr.Name then
                    return model.Name:sub(sp + 3):lower()
                end
            end
        end
        return ""
    end

    local function playerIsDead(plr)
        local char = plr and plr.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        return not char or not hum or hum.Health <= 0 or not getRoot(char)
    end

    local function isInvincible(plr)
        local char = plr and plr.Character
        if not char then return true end
        local root = getRoot(char)
        if not root then return true end
        for _, obj in root:GetChildren() do
            if obj:IsA("Attachment") and obj.Name == "Attachment" then return true end
        end
        return char:FindFirstChild("InvincibilityParticles", true) ~= nil
    end

    local function isKatana(plr)
        return scanWeapon(plr):find("katana", 1, true) ~= nil
    end

    local function isRiotShield(plr)
        local w = scanWeapon(plr)
        return w:find("riot", 1, true) ~= nil or w:find("shield", 1, true) ~= nil
    end

    local function IsValidMatch(player)
        return player:GetAttribute("EnvironmentID") == lplr:GetAttribute("EnvironmentID")
    end

    local function isNearOtherMatch(pos, ignorePlayer)
        local avoidDistance = cfg.otherMatchAvoidDistance or 1000
        if typeof(pos) ~= "Vector3" or avoidDistance <= 0 then return false end
        for _, plr in players:GetPlayers() do
            if plr ~= lplr and plr ~= ignorePlayer and not IsValidMatch(plr) then
                local otherRoot = getRoot(plr.Character)
                if otherRoot and (otherRoot.Position - pos).Magnitude <= avoidDistance then
                    return true
                end
            end
        end
        return false
    end

    local function isSafeRagebotPos(pos, targetPlayer)
        return not isNearOtherMatch(pos, targetPlayer)
    end

    local function shouldSkip(plr)
        if plr == lplr or playerIsDead(plr)      then return true end
        if not IsValidMatch(plr)                  then return true end
        if isInvincible(plr)                      then return true end
        local root = getRoot(plr.Character)
        if root and isNearOtherMatch(root.Position, plr) then return true end
        return root and root:FindFirstChild("TeammateLabel") ~= nil
    end

    -- ── Priority-aware target selection ─────────────────────
    local function getBestTarget()
        local root = getRoot(lplr.Character)
        if not root then return nil end

        -- Pinned player takes absolute precedence
        if cfg.prioritizedPlayer then
            local pp = players:FindFirstChild(cfg.prioritizedPlayer)
            if pp and not shouldSkip(pp) then
                return pp
            end
        end

        local best, bestV = nil, math.huge
        local useHP       = cfg.targetMode == "Lowest Health"

        for _, plr in players:GetPlayers() do
            if not shouldSkip(plr) then
                local char = plr.Character
                local tr   = getRoot(char)
                local hum  = char and char:FindFirstChildOfClass("Humanoid")
                if tr and hum then
                    local value = useHP
                        and hum.Health
                        or  (tr.Position - root.Position).Magnitude

                    if cfg.autoPriority then
                        -- Voided players  → huge negative bonus (pick first)
                        if cfg.priorityVoided and tr.Position.Magnitude > 1000000 then
                            value = value - 2000000000
                        end
                        -- Attackers (have weapon drawn) → strong bonus
                        if cfg.priorityAttackers and scanWeapon(plr) ~= "" then
                            value = value - 1000000000
                        end
                    end

                    if value < bestV then
                        bestV = value
                        best  = plr
                    end
                end
            end
        end

        return best
    end

    local function hasValidTarget()
        return state.target
            and not playerIsDead(state.target)
            and not isInvincible(state.target)
    end

    local function updateRagebotStatus()
        local target  = hasValidTarget() and state.target or nil
        local voiding = not target or ((cfg.mode == "Void" or cfg.mode == "Orbit") and not state.voidExposed)
        setRagebotStatus(state.active and cfg.on, target, voiding)
    end

    local function shouldShoot()
        if not hasValidTarget()                              then return false end
        if isKatana(state.target)                           then return false end
        if cfg.mode == "Void" and not state.voidExposed     then return false end
        return true
    end

    -- Weapon slot helpers
    local function getEquippedSlot()
        local fighter = getFighter()
        local item    = fighter and fighter.EquippedItem
        if not item then return nil end
        return tonumber(item:Get("Slot"))
    end

    local function equipSlot(slot)
        slot = tonumber(slot) or 1
        pcall(function() pressKey(slotKey[slot] or Enum.KeyCode.One) end)
    end

    -- Weapon-specific rage profiles
    local function applyWeaponRageProfile()
        if cfg.weaponSpecialize == false then return "default" end
        local slot = getEquippedSlot()
        local pref = cfg.preferredWeapon or "primary"

        if cfg.autoEquipPreferred ~= false then
            local want = (pref == "secondary" and (cfg.secondarySlot or 2))
                      or (pref == "melee"     and (cfg.meleeSlot     or 3))
                      or (cfg.primarySlot or 1)
            if slot ~= want then
                equipSlot(want)
                slot = want
            end
        end

        local kind
        if    slot == (cfg.meleeSlot     or 3) or pref == "melee"     then kind = "melee"
        elseif slot == (cfg.secondarySlot or 2) or pref == "secondary" then kind = "secondary"
        else kind = "primary" end

        if kind == "primary" then
            cfg.mode = "Orbit"; cfg.hyper = true
            cfg.orbitDist = 3.2; cfg.orbitHeight = 2.2; cfg.strafeSpeed = 6
            cfg.teleportDelay = 0.035; cfg.predictLead = 0.14; cfg.behindDist = 3.5
            cfg.randomMovement = false
            cfg.dirBack = true; cfg.dirFront = false; cfg.dirLeft = true; cfg.dirRight = true
        elseif kind == "secondary" then
            cfg.mode = "Teleport"; cfg.hyper = false
            cfg.orbitDist = 2.6; cfg.orbitHeight = 1.6; cfg.strafeSpeed = 4
            cfg.teleportDelay = 0.028; cfg.predictLead = 0.11; cfg.behindDist = 3.0
            cfg.randomMovement = true; cfg.randomRefresh = 0.07
            cfg.dirBack = true; cfg.dirFront = true; cfg.dirLeft = true; cfg.dirRight = true
        else
            cfg.mode = "Underground"; cfg.hyper = true
            cfg.orbitDist = 1.6; cfg.orbitHeight = 0.6; cfg.strafeSpeed = 8
            cfg.teleportDelay = 0.02; cfg.predictLead = 0.08; cfg.behindDist = 2.2
            cfg.undergroundDepth = 4; cfg.randomMovement = false
            cfg.dirBack = true; cfg.dirFront = false; cfg.dirLeft = true; cfg.dirRight = true; cfg.dirDown = true
        end

        state.weaponKind = kind
        return kind
    end

    -- Ammo management
    local function handleAmmo()
        local fighter = getFighter()
        local item    = fighter and fighter.EquippedItem
        if not fighter or not item then return false end
        local ammo = item:Get("Ammo") or 0
        local slot = item:Get("Slot") or 1
        local now  = tick()
        if fighter:Get("Reloading") then
            state.hideOrbitUntil = math.max(state.hideOrbitUntil or 0, now + 0.25)
            state.ammoActionAt   = math.max(state.ammoActionAt   or 0, now + 0.1)
            return true
        end
        if ammo > 0 then return false end
        if now < (state.ammoActionAt or 0) then return true end

        local primary   = cfg.primarySlot   or 1
        local secondary = cfg.secondarySlot or 2

        if slot == primary and cfg.autoSwapSecondary then
            state.ammoActionAt   = now + 0.45
            state.hideOrbitUntil = math.max(state.hideOrbitUntil or 0, now + 0.45)
            pressKey(slotKey[secondary] or Enum.KeyCode.Two)
            return true
        end
        if slot == secondary and cfg.autoReloadPrimary then
            state.ammoActionAt   = now + 0.6
            state.hideOrbitUntil = math.max(state.hideOrbitUntil or 0, now + 0.75)
            pressKey(slotKey[primary] or Enum.KeyCode.One)
            task.delay(0.18, function()
                if not state.active then return end
                local f2 = getFighter()
                local i2 = f2 and f2.EquippedItem
                if f2 and i2 and (i2:Get("Slot") or 1) == primary and (i2:Get("Ammo") or 0) <= 0 and not f2:Get("Reloading") then
                    pressKey(Enum.KeyCode.R)
                end
            end)
            return true
        end
        if slot == primary and cfg.autoReloadPrimary then
            state.ammoActionAt   = now + 0.5
            state.hideOrbitUntil = math.max(state.hideOrbitUntil or 0, now + 0.75)
            pressKey(Enum.KeyCode.R)
            return true
        end
        return true
    end

    -- Camera data builder (for manipulation)
    local function buildCameraData(fromPos, part)
        if not util or not part then return nil end
        local look = CFrame.new(fromPos, part.Position)
        local data = {}
        data[utf8.char(1)] = {
            [utf8.char(0)] = util:EncodeCFrame(look),
            [utf8.char(1)] = util:EncodeCFrame(look),
            [utf8.char(2)] = part,
            [utf8.char(3)] = util:EncodeCFrame(part.CFrame:ToObjectSpace(CFrame.new(part.Position)))
        }
        return data
    end

    -- Fire handler
    local function doFire(part)
        local fighter = getFighter()
        local item    = fighter and fighter.EquippedItem
        if not item or not part then return false end

        local cam     = ws.CurrentCamera
        local fromPos = (state.csyncCF and state.csyncCF.Position) or (cam and cam.CFrame.Position) or part.Position
        local anyFired = false
        local attempts = math.max(1, math.floor(cfg.shootAttempts or 1))

        for _ = 1, attempts do
            local fired = false
            if cfg.useManipulation and useItemRemote and enums and util then
                local ammo = item.Get and (item:Get("Ammo") or 0) or 0
                if ammo > 0 then
                    local oid       = item:Get("ObjectID")
                    local shootEnum = enums:ToEnum("StartShooting")
                    local data      = buildCameraData(fromPos, part)
                    if oid and shootEnum and data then
                        fired = pcall(function() useItemRemote:FireServer(oid, shootEnum, data, nil) end)
                    end
                end
            end
            if not fired and item.UseItem   then fired = pcall(function() item:UseItem() end) end
            if not fired and fighter and fighter.UseItem then
                fired = pcall(function() fighter:UseItem() end)
            end
            anyFired = anyFired or fired
        end
        return anyFired
    end

    -- Lobby / match checks
    local function isLobby()
        local playerGui = lplr:FindFirstChild("PlayerGui")
        local mainGui   = playerGui and playerGui:FindFirstChild("MainGui")
        local mainFrame = mainGui   and mainGui:FindFirstChild("MainFrame")
        local lobby     = mainFrame and mainFrame:FindFirstChild("Lobby")
        local currency  = lobby     and lobby:FindFirstChild("Currency")
        return currency and currency.Visible == true
    end

    local function getDuel()
        if not rbDuelMod then
            local ps = lplr:FindFirstChild("PlayerScripts")
            local ct = ps and ps:FindFirstChild("Controllers")
            local dc = ct and ct:FindFirstChild("DuelController")
            if dc then
                local ok, mod = pcall(require, dc)
                if ok and mod then rbDuelMod = mod end
            end
        end
        if rbDuelMod and rbDuelMod.GetDuel then
            local ok, duel = pcall(rbDuelMod.GetDuel, rbDuelMod, lplr)
            if ok then return duel end
        end
    end

    local function isValidMatch()
        if isLobby() or isShootingRange() then return false end
        local char = lplr.Character
        local root = getRoot(char)
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not root or not hum or hum.Health <= 0 then return false end
        if getDuel() ~= nil then return true end
        return getFighter() ~= nil
    end

    local function inMatch()
        local now = tick()
        if now - rbInMatchT < 0.25 then return rbInMatch end
        rbInMatchT = now
        rbInMatch  = isValidMatch()
        return rbInMatch
    end

    -- Movement position helpers
    local function undergroundPos(head, targetRoot)
        local depth  = math.clamp(cfg.undergroundDepth or 6, 3, 8)
        local radius = math.clamp(cfg.orbitDist or 3, 1.25, 4)
        return head.Position - targetRoot.CFrame.LookVector * radius + Vector3.new(0, -depth, 0)
    end

    -- ── Csync (server-side position spoofing) ────────────────
    local function restoreLocalRoot(root)
        if not root or not state.csyncLocalCF then return false end
        local lv = root.AssemblyLinearVelocity
        root.CFrame = state.csyncLocalCF
        if state.csyncLocalLV then
            root.AssemblyLinearVelocity = Vector3.new(state.csyncLocalLV.X, lv.Y, state.csyncLocalLV.Z)
        end
        if state.csyncLocalAV then root.AssemblyAngularVelocity = state.csyncLocalAV end
        return true
    end

    local function clearCsyncTarget()
        state.csyncCF       = nil
        state.csyncLV       = nil
        state.csyncAV       = nil
        state.lastFakePos   = nil
    end

    local function isRagebotSettling()
        return os.clock() < (cfg.settleUntil or 0)
    end

    local function applyExternalMovementVelocity()
        local fn = getgenv and getgenv().__LionApplyMovementVelocity
        if type(fn) == "function" then pcall(fn) end
    end

    local function startCsync()
        if state.csyncHbConn then return end
        state.csyncHbConn = runservice.Heartbeat:Connect(function()
            local root = getRoot(lplr.Character)
            if not root then return end
            if state.csyncWroteFake and state.csyncLocalCF then restoreLocalRoot(root) end
            if isRagebotSettling() then
                state.csyncLocalCF  = root.CFrame
                state.csyncLocalLV  = root.AssemblyLinearVelocity
                state.csyncLocalAV  = root.AssemblyAngularVelocity
                state.csyncWroteFake = false
                return
            end
            state.csyncLocalCF  = root.CFrame
            state.csyncLocalLV  = root.AssemblyLinearVelocity
            state.csyncLocalAV  = root.AssemblyAngularVelocity
            if state.csyncCF then
                root.CFrame = state.csyncCF
                local fakeVelocity  = state.csyncLV or state.csyncLocalLV or root.AssemblyLinearVelocity
                local localVelocity = state.csyncLocalLV or root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity  = Vector3.new(fakeVelocity.X, localVelocity.Y, fakeVelocity.Z)
                root.AssemblyAngularVelocity = state.csyncAV or state.csyncLocalAV or root.AssemblyAngularVelocity
                state.csyncWroteFake = true
            else
                state.csyncWroteFake = false
            end
        end)
        runservice:BindToRenderStep("IDK_RagebotCsync", Enum.RenderPriority.Camera.Value - 1, function()
            local root = getRoot(lplr.Character)
            if not root or not state.csyncLocalCF then return end
            local restored = false
            if state.csyncWroteFake and restoreLocalRoot(root) then
                state.csyncWroteFake = false
                restored = true
            end
            if restored then applyExternalMovementVelocity() end
        end)
    end

    local function stopCsync()
        if state.csyncHbConn then state.csyncHbConn:Disconnect(); state.csyncHbConn = nil end
        runservice:UnbindFromRenderStep("IDK_RagebotCsync")
        restoreLocalRoot(getRoot(lplr.Character))
        clearCsyncTarget()
        state.csyncLocalCF   = nil
        state.csyncLocalLV   = nil
        state.csyncLocalAV   = nil
        state.csyncWroteFake = false
    end

    -- ── Void mode helpers ─────────────────────────────────────
    local function voidRand()
        local n = math.random(-2147483646, 2147483646)
        repeat n = math.random(-2147483646, 2147483646) until n < -1147483646 or n > 1147483646
        return n
    end

    local function voidRandCF()
        return CFrame.new(voidRand(), voidRand(), voidRand()) * CFrame.Angles(math.pi, math.pi, math.pi)
    end

    local enterVoidState
    local setVoidCsync = function(cf, lv, av)
        state.csyncCF     = cf
        state.csyncLV     = lv or Vector3.zero
        state.csyncAV     = av or Vector3.zero
        state.lastFakePos = cf and cf.Position or nil
    end

    enterVoidState = function()
        state.voidTargetCF  = nil
        state.voidExposed   = false
        state.orbitClientCF = nil
        if not state.active or not cfg.on then
            clearCsyncTarget()
            updateRagebotStatus()
            return
        end
        if cfg.voidSpam then setVoidCsync(voidRandCF())
        else clearCsyncTarget() end
        updateRagebotStatus()
    end

    local function enableVoidCsync()
        if state.voidHbConn then return end
        startCsync()
        state.voidHbConn = runservice.Heartbeat:Connect(function()
            if isRagebotSettling() then
                state.voidTargetCF  = nil
                state.voidExposed   = false
                clearCsyncTarget()
                return
            end
            if state.voidTargetCF then
                setVoidCsync(state.voidTargetCF, Vector3.zero, Vector3.zero)
            elseif cfg.voidSpam then
                setVoidCsync(voidRandCF())
            else
                clearCsyncTarget()
            end
        end)
    end

    local function disableVoidCsync()
        if state.voidHbConn then state.voidHbConn:Disconnect(); state.voidHbConn = nil end
        runservice:UnbindFromRenderStep("IDK_RagebotVoid")
        state.voidTargetCF = nil
        state.voidThread   = nil
        state.voidExposed  = false
    end

    -- ── Orbit render fix ──────────────────────────────────────
    local function StartOrbitRenderFix()
        if state.orbitRenderRunning then return end
        state.orbitRenderRunning = true
        runservice:BindToRenderStep("IDK_RagebotOrbit", Enum.RenderPriority.First.Value, function()
            if not state.orbitClientCF then return end
            local root = getRoot(lplr.Character)
            if not root then return end
            root.CFrame = state.orbitClientCF
            applyExternalMovementVelocity()
        end)
    end

    local function StopOrbitRenderFix()
        if not state.orbitRenderRunning then return end
        runservice:UnbindFromRenderStep("IDK_RagebotOrbit")
        state.orbitRenderRunning = false
        state.orbitClientCF      = nil
    end

    -- ── Void attack loop ──────────────────────────────────────
    local function startVoidLoop(myGen)
        if state.voidThread then return end
        enableVoidCsync()
        local voidThread
        voidThread = task.spawn(function()
            while state.active and cfg.on and rbGen == myGen and not state.suspended do
                if isRagebotSettling() then
                    state.voidTargetCF = nil
                    state.voidExposed  = false
                    clearCsyncTarget()
                    task.wait(0.03)
                    continue
                end
                if not inMatch() or not hasValidTarget() or isKatana(state.target) then
                    enterVoidState()
                    task.wait(0.1)
                    continue
                end

                enterVoidState()
                if cfg.voidHideTime > 0 then task.wait(cfg.voidHideTime) end
                if not state.active or not cfg.on or rbGen ~= myGen or state.suspended or not inMatch() then break end

                local target = state.target
                if hasValidTarget() and not isKatana(target) then
                    local tc   = target.Character
                    local tr   = getRoot(tc)
                    local head = tc and (tc:FindFirstChild("Head") or tr)
                    if tr and head then
                        local shootPos = isRiotShield(target)
                            and (tr.Position - tr.CFrame.LookVector * (cfg.behindDist or 4))
                            or  (tr.Position - tr.CFrame.LookVector * 2.5 + Vector3.new(0, 1.5, 0))
                        if not isSafeRagebotPos(shootPos, target) then
                            enterVoidState(); task.wait(0.1); continue
                        end
                        local shootCF = CFrame.new(shootPos, head.Position)
                        state.voidExposed   = true
                        state.voidTargetCF  = shootCF
                        setVoidCsync(shootCF, Vector3.zero, Vector3.zero)
                        updateRagebotStatus()
                        if cfg.voidShootTime > 0 then task.wait(cfg.voidShootTime) end
                        if hasValidTarget() and not isKatana(target) then doFire(head) end
                        task.wait(0.05)
                        enterVoidState()
                    end
                end
            end

            if state.voidThread == voidThread then state.voidThread = nil end
            if rbGen == myGen and not state.suspended and state.voidThread == nil then
                disableVoidCsync()
            end
        end)
        state.voidThread = voidThread
    end

    -- ── Void fire-hook (manipulation) ────────────────────────
    local oldFireServerRagebot
    local rbHookInstalled = false

    local function installRagebotHook()
        if rbHookInstalled or not useItemRemote then return end
        rbHookInstalled = true
        pcall(function()
            oldFireServerRagebot = hookfunction(useItemRemote.FireServer, newcclosure(function(self, oid, action, cameradata, ...)
                if state.active and cfg.on and cfg.mode == "Void" and cfg.useManipulation
                   and action == enums:ToEnum("StartShooting") then
                    if isLobby() or not inMatch() then
                        return oldFireServerRagebot(self, oid, action, cameradata, ...)
                    end
                    local target = state.target
                    if hasValidTarget() and not isKatana(target) then
                        local tc   = target.Character
                        local tr   = getRoot(tc)
                        local head = tc and (tc:FindFirstChild("Head") or tr)
                        if tr and head then
                            local shootPos = isRiotShield(target)
                                and (tr.Position - tr.CFrame.LookVector * (cfg.behindDist or 4))
                                or  (tr.Position - tr.CFrame.LookVector * 2.5 + Vector3.new(0, 1.5, 0))
                            if not isSafeRagebotPos(shootPos, target) then
                                enterVoidState()
                                return oldFireServerRagebot(self, oid, action, cameradata, ...)
                            end
                            local shootCF = CFrame.new(shootPos, head.Position)
                            state.voidExposed   = true
                            state.voidTargetCF  = shootCF
                            setVoidCsync(shootCF, Vector3.zero, Vector3.zero)
                            updateRagebotStatus()
                            task.wait(0.02)
                            local newData = buildCameraData(shootPos, head) or cameradata
                            task.spawn(function()
                                task.wait(0.05)
                                enterVoidState()
                            end)
                            return oldFireServerRagebot(self, oid, action, newData, ...)
                        end
                    end
                end
                return oldFireServerRagebot(self, oid, action, cameradata, ...)
            end))
        end)
    end

    -- ── Noclip ───────────────────────────────────────────────
    local function enableNoclip()
        if state.noclipConn then return end
        state.noclipConn = runservice.Stepped:Connect(function()
            local char = lplr.Character
            if not char then return end
            for _, part in char:GetDescendants() do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end

    -- ── Ammo management loop ──────────────────────────────────
    local function startAmmoLoop()
        if state.ammoThread then return end
        state.ammoThread = task.spawn(function()
            while state.active do
                if isShootingRange() then task.wait(0.1); continue end
                if not handleAmmo() and shouldShoot() and not cfg.hyper then
                    local tc   = state.target and state.target.Character
                    local head = tc and (tc:FindFirstChild("Head") or getRoot(tc))
                    if head then
                        if cfg.shootDelay > 0 then task.wait(cfg.shootDelay) end
                        doFire(head)
                    end
                end
                task.wait(math.max(0.01, cfg.acSpd))
            end
            state.ammoThread = nil
        end)
    end

    -- ── Stop everything ───────────────────────────────────────
    local function stopRagebot()
        rbGen        = rbGen + 1
        state.active = false
        cfg.on       = false
        setRagebotStatus(false)
        if state.conn       then state.conn:Disconnect();       state.conn       = nil end
        if state.noclipConn then state.noclipConn:Disconnect(); state.noclipConn = nil end
        state.target          = nil
        state.voidExposed     = false
        state.nextTeleportAt  = 0
        state.ammoActionAt    = 0
        state.hideOrbitUntil  = 0
        state.randPos         = nil
        state.randT           = 0
        state.lastFakePos     = nil
        rbInMatchT            = 0
        rbInMatch             = false
        stopCsync()
        disableVoidCsync()
        StopOrbitRenderFix()
        local char = lplr.Character
        if char then
            for _, part in char:GetDescendants() do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
    getgenv().__IDKRagebotStop = stopRagebot

    -- ── Main heartbeat loop ───────────────────────────────────
    rbGen = rbGen + 1
    local myGen = rbGen
    setRagebotStatus(true, nil, true)
    startAmmoLoop()
    installRagebotHook()

    if not state.suspended then
        enableNoclip()
        if cfg.mode == "Void" then
            startVoidLoop(myGen)
        elseif cfg.mode == "Orbit" then
            enableVoidCsync()
        else
            startCsync()
        end
    end

    local orbitAngle = math.random() * math.pi * 2

    state.conn = runservice.Stepped:Connect(function(_, dt)
        if not state.active or not cfg.on then
            if state.conn then state.conn:Disconnect(); state.conn = nil end
            return
        end

        if isShootingRange() then
            if not state.suspended then
                state.suspended     = true
                state.target        = nil
                state.randPos       = nil
                state.voidTargetCF  = nil
                state.voidExposed   = false
                clearCsyncTarget()
                stopCsync()
                disableVoidCsync()
                StopOrbitRenderFix()
                updateRagebotStatus()
            end
            return
        else
            if state.suspended then
                state.suspended = false
                if cfg.mode == "Void" then startVoidLoop(myGen)
                elseif cfg.mode == "Orbit" then enableVoidCsync(); StartOrbitRenderFix()
                else startCsync() end
            end
        end

        if not inMatch() then
            state.target = nil
            updateRagebotStatus()
            return
        end

        -- Target acquisition
        local newTarget = getBestTarget()
        if newTarget ~= state.target then
            state.target = newTarget
            if cfg.sendNotification and newTarget then
                Library:Notify("targeting: " .. newTarget.Name, "success")
            end
            updateRagebotStatus()
        end

        if not hasValidTarget() then
            updateRagebotStatus()
            return
        end

        -- Weapon profile
        if cfg.weaponSpecialize then
            applyWeaponRageProfile()
        end

        local target = state.target
        local tc     = target and target.Character
        local tr     = getRoot(tc)
        local head   = tc and (tc:FindFirstChild("Head") or tr)

        if not tr or not head then
            updateRagebotStatus()
            return
        end

        if cfg.mode == "Orbit" or cfg.mode == "Teleport" then
            -- Orbit/Teleport movement
            orbitAngle = orbitAngle + (cfg.strafeSpeed or 5) * dt
            local radius = math.clamp(cfg.orbitDist or 3, 1.25, 5)
            local height = math.clamp(cfg.orbitHeight or 2, -2, 6)
            local orbitX = math.cos(orbitAngle) * radius
            local orbitZ = math.sin(orbitAngle) * radius
            local orbitPos = head.Position + Vector3.new(orbitX, height, orbitZ)

            if cfg.mode == "Teleport" then
                local now = tick()
                if now >= (state.nextTeleportAt or 0) and isSafeRagebotPos(orbitPos, target) then
                    state.nextTeleportAt = now + (cfg.teleportDelay or 0.04)
                    local shootCF = CFrame.new(orbitPos, head.Position)
                    setVoidCsync(shootCF, Vector3.zero, Vector3.zero)
                    state.voidExposed    = true
                    state.voidTargetCF   = shootCF
                    state.orbitClientCF  = shootCF
                    updateRagebotStatus()
                end
            else
                -- Orbit: expose clientside only
                if now >= (state.hideOrbitUntil or 0) then
                    local shootCF = CFrame.new(orbitPos, head.Position)
                    state.orbitClientCF = shootCF
                    StartOrbitRenderFix()
                    if isSafeRagebotPos(orbitPos, target) then
                        state.voidExposed   = true
                        state.voidTargetCF  = shootCF
                        setVoidCsync(shootCF, Vector3.zero, Vector3.zero)
                    end
                    updateRagebotStatus()
                end
            end

            if cfg.hyper and shouldShoot() then
                doFire(head)
            end

        elseif cfg.mode == "Underground" then
            local uPos  = undergroundPos(head, tr)
            if isSafeRagebotPos(uPos, target) then
                local shootCF = CFrame.new(uPos, head.Position)
                setCsync and setCsync(shootCF, uPos, dt) -- no-op if not defined outside
                state.csyncCF = shootCF
                state.csyncLV = Vector3.zero
                state.csyncAV = Vector3.zero
                if cfg.hyper and shouldShoot() then doFire(head) end
            end
        end

        updateRagebotStatus()
    end)

    -- Respawn handler
    rbClean(lplr.CharacterAdded:Connect(function()
        stopCsync()
        disableVoidCsync()
        StopOrbitRenderFix()
        state.target        = nil
        state.csyncLocalCF  = nil
        state.csyncLocalLV  = nil
        state.csyncLocalAV  = nil
        state.csyncWroteFake = false
        state.voidExposed   = false
        state.hideOrbitUntil = 0
        clearCsyncTarget()
        if state.active then
            task.wait(0.5)
            if state.active then
                if cfg.mode == "Void" then startVoidLoop(myGen)
                elseif cfg.mode == "Orbit" then enableVoidCsync(); StartOrbitRenderFix()
                else startCsync() end
            end
        end
    end))

    return stopRagebot
end

-- ╔════════════════════════════════════════════════════════════╗
-- ║  ECLIPSE UI — RAGEBOT & PRIORITY TABS                     ║
-- ╚════════════════════════════════════════════════════════════╝

local RageTab = Library:Tab("Rage", 10455604811)

-- ──────────────────────────────────────────────────────────────
-- LEFT COLUMN  →  Ragebot Group
-- ──────────────────────────────────────────────────────────────
local RageGroup = RageTab:Group("Ragebot")

-- Enable toggle (main on/off)
local stopRagebotFn = nil
RageGroup:Toggle({
    Name    = "Enabled",
    Tooltip = "Activate ragebot targeting & void movement",
    Callback = function(v)
        if v then
            if getgenv().__IDKRagebotStop then
                pcall(getgenv().__IDKRagebotStop)
                getgenv().__IDKRagebotStop = nil
            end
            rbCleanAll()
            stopRagebotFn = startRagebot()
        else
            rbCleanAll()
            if stopRagebotFn then pcall(stopRagebotFn); stopRagebotFn = nil end
            if getgenv().__IDKRagebotStop then
                pcall(getgenv().__IDKRagebotStop)
                getgenv().__IDKRagebotStop = nil
            end
        end
    end
})

-- Void Spam
RageGroup:Toggle({
    Name    = "Void Spam",
    Default = true,
    Tooltip = "Continuously teleport server-position to void coordinates",
    Callback = function(v)
        RagebotSettings.voidSpam = v
        markRagebotSettingsDirty()
    end
})

-- Weapon Specialize
RageGroup:Toggle({
    Name    = "Weapon Specialize",
    Default = true,
    Tooltip = "Auto-tune orbit radius / mode per weapon type",
    Callback = function(v)
        RagebotSettings.weaponSpecialize = v
        markRagebotSettingsDirty()
    end
})

-- Swap When Empty
RageGroup:Toggle({
    Name    = "Swap When Empty",
    Default = true,
    Tooltip = "Auto-swap to secondary when primary ammo runs out",
    Callback = function(v)
        RagebotSettings.autoSwapSecondary = v
        RagebotSettings.autoReloadPrimary = v
        markRagebotSettingsDirty()
    end
})

-- Prefer Projectile
RageGroup:Toggle({
    Name    = "Prefer Projectile",
    Default = false,
    Tooltip = "Prefer projectile weapons during weapon selection",
    Callback = function(v)
        RagebotSettings.preferProjectile = v
        markRagebotSettingsDirty()
    end
})

-- Hide Time slider
RageGroup:Slider({
    Name    = "Hide Time",
    Min     = 0,
    Max     = 100,
    Default = 25,
    Unit    = "ms",
    Tooltip = "Time to stay voided before exposing to shoot",
    Callback = function(v)
        RagebotSettings.voidHideTime = v / 100
        markRagebotSettingsDirty()
    end
})

-- Attack Time slider
RageGroup:Slider({
    Name    = "Attack Time",
    Min     = 0,
    Max     = 100,
    Default = 3,
    Unit    = "ms",
    Tooltip = "Time exposed before pulling trigger",
    Callback = function(v)
        RagebotSettings.voidShootTime = v / 100
        markRagebotSettingsDirty()
    end
})

-- Shoot Attempts slider
RageGroup:Slider({
    Name    = "Shoot Attempts",
    Min     = 1,
    Max     = 10,
    Default = 1,
    Unit    = "x",
    Tooltip = "Number of fire calls per attack window",
    Callback = function(v)
        RagebotSettings.shootAttempts = math.floor(v)
        markRagebotSettingsDirty()
    end
})

-- Attack Mode dropdown
RageGroup:Dropdown({
    Name    = "Attack Mode",
    Options = {"gun", "knife", "melee"},
    Default = "gun",
    Tooltip = "Primary attack method",
    Callback = function(v)
        RagebotSettings.attackMode = v
        markRagebotSettingsDirty()
    end
})

-- Preferred Weapon dropdown
RageGroup:Dropdown({
    Name    = "Preferred Weapon",
    Options = {"primary", "secondary", "melee"},
    Default = "primary",
    Tooltip = "Slot to equip on startup and after ammo swap",
    Callback = function(v)
        RagebotSettings.preferredWeapon = v
        if v == "primary" then
            RagebotSettings.primarySlot   = 1
            RagebotSettings.secondarySlot = 2
        elseif v == "secondary" then
            RagebotSettings.primarySlot   = 2
            RagebotSettings.secondarySlot = 1
        else
            RagebotSettings.primarySlot   = 1
            RagebotSettings.secondarySlot = 2
        end
        markRagebotSettingsDirty()
        pcall(function()
            local keys = {[1]=Enum.KeyCode.One,[2]=Enum.KeyCode.Two,[3]=Enum.KeyCode.Three}
            local slot  = (v=="primary" and 1) or (v=="secondary" and 2) or 3
            local vim   = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true,  keys[slot], false, game)
            task.wait()
            vim:SendKeyEvent(false, keys[slot], false, game)
        end)
    end
})

-- ──────────────────────────────────────────────────────────────
-- RIGHT COLUMN  →  Priority Group
-- ──────────────────────────────────────────────────────────────
local PrioGroup = RageTab:Group("Priority")

-- Auto Prioritize
PrioGroup:Toggle({
    Name    = "Auto Prioritize",
    Default = false,
    Tooltip = "Use weighted scoring to pick the best target automatically",
    Callback = function(v)
        RagebotSettings.autoPriority = v
        RagebotSettings.autoSwitch   = v
        markRagebotSettingsDirty()
    end
})

-- Send Notification
PrioGroup:Toggle({
    Name    = "Send Notification",
    Default = false,
    Tooltip = "Notify when a new priority target is locked",
    Callback = function(v)
        RagebotSettings.sendNotification = v
        markRagebotSettingsDirty()
    end
})

-- Prioritize Attackers
PrioGroup:Toggle({
    Name    = "Prioritize Attackers",
    Default = true,
    Tooltip = "Players with an equipped weapon score +1B in priority",
    Callback = function(v)
        RagebotSettings.priorityAttackers = v
        markRagebotSettingsDirty()
    end
})

-- Prioritize Voided Players
PrioGroup:Toggle({
    Name    = "Prioritize Voided",
    Default = true,
    Tooltip = "Players currently voided score +2B in priority",
    Callback = function(v)
        RagebotSettings.priorityVoided = v
        markRagebotSettingsDirty()
    end
})

-- Target Mode dropdown
PrioGroup:Dropdown({
    Name    = "Target Mode",
    Options = {"Closest", "Lowest Health"},
    Default = "Closest",
    Tooltip = "Base metric before priority bonuses are applied",
    Callback = function(v)
        RagebotSettings.targetMode = v
        markRagebotSettingsDirty()
    end
})

-- Prioritized Player dropdown (dynamic — refresh button below)
local function getOtherPlayerNames()
    local names = {}
    for _, plr in Players:GetPlayers() do
        if plr ~= Player then table.insert(names, plr.Name) end
    end
    table.sort(names)
    table.insert(names, 1, "none")
    return names
end

local PrioritizedDropdown = PrioGroup:Dropdown({
    Name    = "Pinned Player",
    Options = getOtherPlayerNames(),
    Default = "none",
    Tooltip = "This player is always targeted first, ignoring priority weights",
    Callback = function(v)
        RagebotSettings.prioritizedPlayer = (v == "none" or v == "") and nil or v
        markRagebotSettingsDirty()
    end
})

PrioGroup:Button({
    Name    = "Refresh Players",
    Variant = "Primary",
    Tooltip = "Update the Pinned Player list with current lobby",
    Callback = function()
        PrioritizedDropdown.SetOptions(getOtherPlayerNames())
        Library:Notify("player list refreshed", "success")
    end
})

-- Auto-refresh when someone joins/leaves
Players.PlayerAdded:Connect(function()
    PrioritizedDropdown.SetOptions(getOtherPlayerNames())
end)
Players.PlayerRemoving:Connect(function(plr)
    if plr.Name == RagebotSettings.prioritizedPlayer then
        RagebotSettings.prioritizedPlayer = nil
        markRagebotSettingsDirty()
    end
    PrioritizedDropdown.SetOptions(getOtherPlayerNames())
end)

-- ╔════════════════════════════════════════════════════════════╗
-- ║  MENU KEYBIND + MOBILE TOGGLE                             ║
-- ╚════════════════════════════════════════════════════════════╝

Library.MenuKey = Enum.KeyCode.RightShift
local Visible   = true

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Library.MenuKey then
        Visible = not Visible
        MainFrame.Visible = Visible
    end
end)

local MobileToggle = Create("ImageButton", {
    Parent           = ScreenGui,
    Size             = UDim2.new(0, 40, 0, 40),
    Position         = UDim2.new(0.5, 0, 0, 10),
    AnchorPoint      = Vector2.new(0.5, 0),
    BackgroundColor3 = CFG.MainColor,
    Image            = "rbxassetid://3926305904",
    ImageColor3      = CFG.AccentColor,
    AutoButtonColor  = false
}, {
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
    Create("UIStroke",  {Color = CFG.AccentColor, Thickness = 2})
})
MobileToggle.MouseButton1Click:Connect(function()
    Visible = not Visible
    MainFrame.Visible = Visible
end)

Library:Notify("ragebot loaded", "success")
