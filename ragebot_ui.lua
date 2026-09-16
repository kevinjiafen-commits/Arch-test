-- ============================================================
--  RIVALS Ragebot  +  Eclipse UI
--  Controls all ragebot settings via the UI.
--  Toggle menu: Insert key (or mobile button top-center).
-- ============================================================

-- ── 1. SERVICES ─────────────────────────────────────────────
local Players         = game:GetService("Players")
local UserInputService= game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local CoreGui         = game:GetService("CoreGui")
local HttpService     = game:GetService("HttpService")

local Player     = Players.LocalPlayer
local Mouse      = Player:GetMouse()

-- ── 2. RAGEBOT SETUP (shared state that the kernel reads) ───
local _cloneref = cloneref
if type(_cloneref) ~= "function" then _cloneref = function(x) return x end end
local _clonefunction = clonefunction
if type(_clonefunction) ~= "function" then _clonefunction = function(x) return x end end
cloneref     = _cloneref
clonefunction= _clonefunction

local Char, Root
local function refreshCharacter()
    Char = Player.Character
    Root = Char and Char:FindFirstChild("HumanoidRootPart") or nil
    return Char
end
refreshCharacter()
Player.CharacterAdded:Connect(function(character)
    Char = character
    Root = character:WaitForChild("HumanoidRootPart", 10)
end)

local Bridge           = {}
function Bridge.IsReadyToFight() return true end
local Options          = {}
local Toggles          = {}
local FighterDataCache = { LocalDuel = { Seeded = false, IsInShootingRange = false } }
local Genv = (type(getgenv) == "function" and getgenv()) or _G
Genv.KiciaHookCaps = Genv.KiciaHookCaps or {}
Genv.KiciaHookCaps.gate = Genv.KiciaHookCaps.gate or function()
    return type(getgc) == "function" and type(sethiddenproperty) == "function"
end

-- Helper: create an Options entry that togValue / optValue can read
local function mkToggle(id, default)
    Toggles[id] = { Value = default }
    return Toggles[id]
end
local function mkOption(id, default)
    Options[id] = { Value = default }
    return Options[id]
end

-- Pre-create all entries with ragebot defaults so the kernel has them
-- immediately even before the UI is touched.
mkToggle('P8S4T4', true)   -- PrioritizeHackers
mkToggle('P8S4T5', true)   -- WeaponPrimary
mkToggle('P8S4T6', true)   -- WeaponSecondary
mkToggle('P8S4T7', true)   -- WeaponMelee
mkToggle('P8S4T8', false)  -- RandomAnchorFromCharacter
mkOption('P8S4S1', 1.5)    -- Stability
mkOption('P8S4S2', 1)      -- ShootFrames
mkOption('P8S4S3', -5)     -- TranslocateOffset
mkOption('P8S4S4', 100000000) -- RandomBaseRadius
mkOption('P8S4S5', 1)      -- RandomRadiusFactor
mkOption('P8S4D1', 'SwapOrReload') -- OnEmpty
mkOption('P8S4D2', 'Random')       -- EvasionMode

local function GetChar()
    if not Char or not Char.Parent then refreshCharacter() end
    return Char
end
local function GetRoot()
    local character = GetChar()
    Root = character and character:FindFirstChild("HumanoidRootPart") or Root
    return Root
end

-- ── 3. ECLIPSE UI LIBRARY ───────────────────────────────────

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
    TweenService:Create(obj,
        TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function GetTextSize(text, size, font)
    return game:GetService("TextService"):GetTextSize(text, size, font, Vector2.new(10000, 10000))
end

local ScreenGui = Create("ScreenGui", {
    Name           = "EclipseUI",
    Parent         = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn   = false,
    IgnoreGuiInset = true
})

local UIScale = Create("UIScale", { Parent = ScreenGui })

local function UpdateScale()
    local vp = workspace.CurrentCamera.ViewportSize
    UIScale.Scale = math.max(math.min((vp.X - 40) / CFG.BaseSize.X, (vp.Y - 40) / CFG.BaseSize.Y, 1), 0.6)
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
    Parent             = NotificationContainer,
    Padding            = UDim.new(0, 5),
    HorizontalAlignment= Enum.HorizontalAlignment.Right,
    VerticalAlignment  = Enum.VerticalAlignment.Top
})

function Library:Notify(msg, ntype)
    local color = (ntype == "success" and Color3.fromRGB(100,255,100))
               or (ntype == "warning" and Color3.fromRGB(255,100,100))
               or CFG.AccentColor
    local Frame = Create("Frame", {
        Parent              = NotificationContainer,
        Size                = UDim2.new(0, 0, 0, 30),
        BackgroundColor3    = CFG.MainColor,
        BorderSizePixel     = 0,
        ClipsDescendants    = true
    }, {
        Create("UIStroke", { Color = CFG.AccentColor, Thickness = 1, Transparency = 0.5 }),
        Create("Frame",    { Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = color }),
        Create("TextLabel", {
            Text                = msg,
            TextColor3          = CFG.TextColor,
            Font                = CFG.Font,
            TextSize            = 12,
            Size                = UDim2.new(1, -10, 1, 0),
            Position            = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment      = Enum.TextXAlignment.Left
        })
    })
    Tween(Frame, { Size = UDim2.new(0, 250, 0, 35) }, 0.5, Enum.EasingStyle.Back)
    task.delay(3, function()
        Tween(Frame, { Size = UDim2.new(0, 250, 0, 0), BackgroundTransparency = 1 }, 0.5)
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
    Create("UIPadding", { PaddingLeft = UDim.new(0,5), PaddingRight = UDim.new(0,5) }),
    Create("UIStroke",  { Color = CFG.StrokeColor })
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

-- Main window
local MainFrame = Create("Frame", {
    Name             = "MainFrame",
    Parent           = ScreenGui,
    Size             = UDim2.fromOffset(CFG.BaseSize.X, CFG.BaseSize.Y),
    Position         = UDim2.new(0.5, -300, 0.5, -225),
    BackgroundColor3 = CFG.MainColor,
    BorderSizePixel  = 0
}, {
    Create("UIStroke", { Color = CFG.StrokeColor }),
    Create("UICorner", { CornerRadius = UDim.new(0, 3) })
})

-- Drag
local Dragging, DragInput, DragStart, StartPos = false, nil, nil, nil
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos  = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local d = input.Position - DragStart
        Tween(MainFrame, {
            Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + d.X,
                                 StartPos.Y.Scale, StartPos.Y.Offset + d.Y)
        }, 0.05)
    end
end)

-- Top bar
local TopBar = Create("Frame", {
    Parent           = MainFrame,
    Size             = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = CFG.MainColor,
    BorderSizePixel  = 0
}, {
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
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
    Size               = UDim2.new(0, 200, 1, 0),
    Position           = UDim2.new(0, 10, 0, 0),
    TextXAlignment     = Enum.TextXAlignment.Left,
    RichText           = true
})

task.spawn(function()
    local textList = {
        '', 'e', 'ec', 'ecl', 'ecli', 'eclip', 'eclipse', 'eclipse.',
        'eclipse.w', 'eclipse.wt', 'eclipse.wtf', 'eclipse.wtf |',
        'eclipse.wtf | r', 'eclipse.wtf | ra', 'eclipse.wtf | rag',
        'eclipse.wtf | rage', 'eclipse.wtf | rageb', 'eclipse.wtf | ragebot',
        'eclipse.wtf | ragebo', 'eclipse.wtf | rageb', 'eclipse.wtf | rage',
        'eclipse.wtf | rag', 'eclipse.wtf | ra', 'eclipse.wtf | r',
        'eclipse.wtf |', 'eclipse.wtf', 'eclipse.wt', 'eclipse.w',
        'eclipse.', 'eclipse', 'eclips', 'eclip', 'ecli', 'ecl', 'ec', 'e'
    }
    while not Library.Unloaded do
        for _, text in ipairs(textList) do
            if Library.Unloaded then break end
            local display = text
            if string.find(text, "ragebot") then
                display = string.gsub(text, "ragebot", '<font color="#bdacff">ragebot</font>')
            elseif string.find(text, "wtf") then
                display = string.gsub(text, "wtf", '<font color="#bdacff">wtf</font>')
            end
            TitleLabel.Text = display
            task.wait(0.2)
        end
    end
end)

-- Content layout
local ContentContainer = Create("Frame", {
    Parent             = MainFrame,
    Size               = UDim2.new(1, 0, 1, -30),
    Position           = UDim2.new(0, 0, 0, 30),
    BackgroundTransparency = 1
})

local Sidebar = Create("Frame", {
    Parent           = ContentContainer,
    Size             = UDim2.new(0, 60, 1, 0),
    BackgroundColor3 = Color3.fromRGB(17, 17, 17),
    BorderSizePixel  = 0,
    Position         = UDim2.new(0, 0, 0, 0)
}, {
    Create("UIListLayout", {
        Padding            = UDim.new(0, 10),
        HorizontalAlignment= Enum.HorizontalAlignment.Center,
        VerticalAlignment  = Enum.VerticalAlignment.Top
    }),
    Create("UIPadding", { PaddingTop = UDim.new(0, 15) })
})

local PagesContainer = Create("Frame", {
    Parent             = ContentContainer,
    Size               = UDim2.new(1, -60, 1, 0),
    Position           = UDim2.new(0, 60, 0, 0),
    BackgroundTransparency = 1
})

local Tabs       = {}
local CurrentTab = nil

function Library:Tab(name, icon)
    local TabButton = Create("TextButton", {
        Parent           = Sidebar,
        Size             = UDim2.new(0, 40, 0, 40),
        BackgroundColor3 = CFG.MainColor,
        Text             = "",
        AutoButtonColor  = false
    }, {
        Create("ImageLabel", {
            Name               = "Icon",
            Size               = UDim2.new(0.6, 0, 0.6, 0),
            Position           = UDim2.new(0.2, 0, 0.2, 0),
            BackgroundTransparency = 1,
            Image              = "rbxassetid://" .. icon,
            ImageColor3        = CFG.TextDark
        }),
        Create("UICorner", { CornerRadius = UDim.new(0, 6) })
    })

    local PageFrame = Create("ScrollingFrame", {
        Parent              = PagesContainer,
        Size                = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible             = false,
        ScrollBarThickness  = 2,
        ScrollBarImageColor3= CFG.AccentColor,
        CanvasSize          = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })

    PageFrame:ClearAllChildren()
    Create("UIPadding", {
        Parent       = PageFrame,
        PaddingTop   = UDim.new(0, 15),
        PaddingLeft  = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        PaddingBottom= UDim.new(0, 15)
    })

    local LeftCol = Create("Frame", {
        Parent             = PageFrame,
        Size               = UDim2.new(0.48, 0, 1, 0),
        BackgroundTransparency = 1
    }, { Create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }) })

    local RightCol = Create("Frame", {
        Parent             = PageFrame,
        Size               = UDim2.new(0.48, 0, 1, 0),
        Position           = UDim2.new(0.52, 0, 0, 0),
        BackgroundTransparency = 1
    }, { Create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }) })

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            Tween(t.Btn, { TextColor3 = CFG.TextDark, BackgroundColor3 = CFG.MainColor }, 0.2)
            t.Btn.Icon.ImageColor3 = CFG.TextDark
            t.Page.Visible = false
        end
        Tween(TabButton, { BackgroundColor3 = CFG.SecondaryColor }, 0.2)
        TabButton.Icon.ImageColor3 = CFG.AccentColor
        PageFrame.Visible = true
        CurrentTab = PageFrame
    end)

    table.insert(Tabs, { Btn = TabButton, Page = PageFrame })
    if #Tabs == 1 then
        Tween(TabButton, { BackgroundColor3 = CFG.SecondaryColor }, 0.2)
        TabButton.Icon.ImageColor3 = CFG.AccentColor
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
            Create("UIStroke", { Color = CFG.StrokeColor }),
            Create("UICorner", { CornerRadius = UDim.new(0, 2) })
        })

        Create("Frame", {
            Parent           = GroupFrame,
            Size             = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = CFG.SecondaryColor,
            BorderSizePixel  = 0
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0, 2) }),
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
                Size            = UDim2.new(0, 4, 0, 4),
                Position        = UDim2.new(1, -10, 0.5, -2),
                BackgroundColor3= CFG.AccentColor,
                BorderSizePixel = 0
            }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        })

        local Content = Create("Frame", {
            Parent           = GroupFrame,
            Size             = UDim2.new(1, 0, 0, 0),
            Position         = UDim2.new(0, 0, 0, 25),
            AutomaticSize    = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1
        }, {
            Create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }),
            Create("UIPadding", {
                PaddingTop    = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft   = UDim.new(0, 8),
                PaddingRight  = UDim.new(0, 8)
            })
        })

        local ItemFuncs = {}

        -- Toggle
        function ItemFuncs:Toggle(cfg)
            local Enabled = cfg.Default or false
            local Frame = Create("TextButton", {
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
            }, { Create("UIStroke", { Color = CFG.StrokeColor }) })
            local Check = Create("Frame", {
                Parent           = Box,
                Size             = UDim2.new(1, -4, 1, -4),
                Position         = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                BackgroundColor3 = CFG.AccentColor,
                BackgroundTransparency = Enabled and 0 or 1
            })
            local Label = Create("TextLabel", {
                Parent             = Frame,
                Text               = cfg.Name,
                TextColor3         = Enabled and CFG.TextColor or (cfg.Risky and Color3.fromRGB(200,80,80) or CFG.TextDark),
                TextSize           = 11,
                Font               = CFG.Font,
                BackgroundTransparency = 1,
                Position           = UDim2.new(0, 18, 0, 0),
                Size               = UDim2.new(1, -18, 1, 0),
                TextXAlignment     = Enum.TextXAlignment.Left
            })
            if cfg.Risky then Label.TextColor3 = Color3.fromRGB(200,80,80) end
            if cfg.Tooltip then AddTooltip(Frame, cfg.Tooltip) end
            local function Update()
                Enabled = not Enabled
                Tween(Check, { BackgroundTransparency = Enabled and 0 or 1 }, 0.1)
                Tween(Label, { TextColor3 = Enabled and CFG.TextColor or (cfg.Risky and Color3.fromRGB(200,80,80) or CFG.TextDark) }, 0.1)
                if cfg.Callback then cfg.Callback(Enabled) end
            end
            Frame.MouseButton1Click:Connect(Update)
            -- fire once to apply the Default
            if Enabled and cfg.Callback then cfg.Callback(Enabled) end
            return { Set = function(v) if v ~= Enabled then Update() end end }
        end

        -- Slider
        function ItemFuncs:Slider(cfg)
            local Value = cfg.Default or cfg.Min
            local DraggingSlider = false
            local Frame = Create("Frame", {
                Parent             = Content,
                Size               = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1
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
                Create("UIStroke", { Color = CFG.StrokeColor }),
                Create("UICorner", { CornerRadius = UDim.new(1, 0) })
            })
            local Fill = Create("Frame", {
                Parent           = SliderBG,
                Size             = UDim2.new((Value - cfg.Min) / (cfg.Max - cfg.Min), 0, 1, 0),
                BackgroundColor3 = CFG.AccentColor,
                BorderSizePixel  = 0
            }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
            local function SetValue(v)
                v = math.clamp(math.floor(v * (1/( cfg.Step or 0.1)) + 0.5) * (cfg.Step or 0.1), cfg.Min, cfg.Max)
                Value = v
                local pct = (v - cfg.Min) / (cfg.Max - cfg.Min)
                Tween(Fill, { Size = UDim2.new(pct, 0, 1, 0) }, 0.05)
                ValueLabel.Text = v .. (cfg.Unit or "")
                if cfg.Callback then cfg.Callback(v) end
            end
            if cfg.Callback then cfg.Callback(Value) end
            SliderBG.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    DraggingSlider = true
                    local s = SliderBG.AbsoluteSize
                    local p = SliderBG.AbsolutePosition
                    SetValue(cfg.Min + (inp.Position.X - p.X) / s.X * (cfg.Max - cfg.Min))
                end
            end)
            SliderBG.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    DraggingSlider = false
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if DraggingSlider and
                   (inp.UserInputType == Enum.UserInputType.MouseMovement
                 or inp.UserInputType == Enum.UserInputType.Touch) then
                    local s = SliderBG.AbsoluteSize
                    local p = SliderBG.AbsolutePosition
                    SetValue(cfg.Min + (inp.Position.X - p.X) / s.X * (cfg.Max - cfg.Min))
                end
            end)
            if cfg.Tooltip then AddTooltip(Frame, cfg.Tooltip) end
        end

        -- Dropdown
        function ItemFuncs:Dropdown(cfg)
            local Selected = cfg.Default or cfg.Options[1]
            local Opened   = false
            local Frame = Create("Frame", {
                Parent           = Content,
                Size             = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                ClipsDescendants = false,
                ZIndex           = 10
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
            local Btn = Create("TextButton", {
                Parent           = Frame,
                Size             = UDim2.new(1, 0, 0, 20),
                Position         = UDim2.new(0, 0, 0, 15),
                BackgroundColor3 = CFG.SecondaryColor,
                Text             = Selected,
                TextColor3       = CFG.TextColor,
                Font             = CFG.Font,
                TextSize         = 11,
                BorderSizePixel  = 0
            }, {
                Create("UIStroke", { Color = CFG.StrokeColor }),
                Create("UICorner", { CornerRadius = UDim.new(0, 3) }),
                Create("UIPadding", { PaddingLeft = UDim.new(0, 5) })
            })
            local DropFrame = Create("Frame", {
                Parent           = Frame,
                Size             = UDim2.new(1, 0, 0, 0),
                Position         = UDim2.new(0, 0, 1, 2),
                BackgroundColor3 = CFG.SecondaryColor,
                BorderSizePixel  = 0,
                ClipsDescendants = true,
                ZIndex           = 20
            }, {
                Create("UIStroke", { Color = CFG.StrokeColor }),
                Create("UICorner", { CornerRadius = UDim.new(0, 3) }),
                Create("UIListLayout", { Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder })
            })
            for _, opt in ipairs(cfg.Options) do
                local OptBtn = Create("TextButton", {
                    Parent           = DropFrame,
                    Size             = UDim2.new(1, 0, 0, 20),
                    BackgroundColor3 = CFG.SecondaryColor,
                    Text             = opt,
                    TextColor3       = opt == Selected and CFG.AccentColor or CFG.TextDark,
                    Font             = CFG.Font,
                    TextSize         = 11,
                    BorderSizePixel  = 0,
                    ZIndex           = 21
                }, { Create("UIPadding", { PaddingLeft = UDim.new(0, 5) }) })
                OptBtn.MouseButton1Click:Connect(function()
                    Selected = opt
                    Btn.Text = opt
                    for _, c in ipairs(DropFrame:GetChildren()) do
                        if c:IsA("TextButton") then
                            c.TextColor3 = c.Text == opt and CFG.AccentColor or CFG.TextDark
                        end
                    end
                    Opened = false
                    Tween(DropFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
                    if cfg.Callback then cfg.Callback(opt) end
                end)
            end
            Btn.MouseButton1Click:Connect(function()
                Opened = not Opened
                local h = Opened and (#cfg.Options * 20) or 0
                Tween(DropFrame, { Size = UDim2.new(1, 0, 0, h) }, 0.15)
            end)
            if cfg.Callback then cfg.Callback(Selected) end
            if cfg.Tooltip then AddTooltip(Btn, cfg.Tooltip) end
        end

        -- Button
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
                Create("UIStroke", { Color = CFG.StrokeColor }),
                Create("UICorner", { CornerRadius = UDim.new(0, 3) })
            })
            if cfg.Variant == "Primary" then
                Btn.BackgroundColor3 = CFG.AccentColor
                Btn.TextColor3       = Color3.new(0,0,0)
            elseif cfg.Variant == "Danger" then
                Btn.BackgroundColor3 = Color3.fromRGB(200,60,60)
                Btn.TextColor3       = Color3.new(0,0,0)
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

-- ── 4. RAGEBOT TABS ─────────────────────────────────────────

local RageTab = Library:Tab("Rage", 10455604811)
local MiscTab = Library:Tab("Misc", 11888734334)

-- ── Rage > Combat ────────────────────────────────────────────
local Combat = RageTab:Group("Combat")

Combat:Toggle({
    Name    = "Prioritize Hackers",
    Default = true,
    Tooltip = "Target players with abnormal stats first",
    Callback= function(v) Toggles['P8S4T4'].Value = v end
})

Combat:Toggle({
    Name    = "Use Primary",
    Default = true,
    Tooltip = "Ragebot may use your primary weapon",
    Callback= function(v) Toggles['P8S4T5'].Value = v end
})

Combat:Toggle({
    Name    = "Use Secondary",
    Default = true,
    Tooltip = "Ragebot may use your secondary weapon",
    Callback= function(v) Toggles['P8S4T6'].Value = v end
})

Combat:Toggle({
    Name    = "Use Melee",
    Default = true,
    Tooltip = "Ragebot may switch to melee when in range",
    Callback= function(v) Toggles['P8S4T7'].Value = v end
})

Combat:Slider({
    Name    = "Stability",
    Min     = 0.5,
    Max     = 5,
    Default = 1.5,
    Step    = 0.1,
    Tooltip = "Higher = more stable aim calculations",
    Callback= function(v) Options['P8S4S1'].Value = v end
})

Combat:Slider({
    Name    = "Shoot Frames",
    Min     = 1,
    Max     = 10,
    Default = 1,
    Step    = 1,
    Tooltip = "Frames between each shot attempt",
    Callback= function(v) Options['P8S4S2'].Value = v end
})

Combat:Dropdown({
    Name    = "On Empty",
    Options = { "SwapOrReload", "Reload", "Swap", "None" },
    Default = "SwapOrReload",
    Tooltip = "Action taken when current weapon runs out of ammo",
    Callback= function(v) Options['P8S4D1'].Value = v end
})

-- ── Rage > Evasion ───────────────────────────────────────────
local Evasion = RageTab:Group("Evasion")

Evasion:Dropdown({
    Name    = "Evasion Mode",
    Options = { "Random", "Off", "Translocate", "ProjectileBreaker" },
    Default = "Random",
    Tooltip = "How the ragebot moves to dodge incoming hits",
    Callback= function(v) Options['P8S4D2'].Value = v end
})

Evasion:Slider({
    Name    = "Translocate Offset",
    Min     = -30,
    Max     = 30,
    Default = -5,
    Step    = 1,
    Tooltip = "Vertical offset applied during Translocate evasion",
    Callback= function(v) Options['P8S4S3'].Value = v end
})

-- ── Rage > Random Position ───────────────────────────────────
local RandPos = RageTab:Group("Random Position")

RandPos:Slider({
    Name    = "Base Radius",
    Min     = 100,
    Max     = 999,
    Default = 999,
    Step    = 1,
    Tooltip = "Max radius for random evasion repositioning (×100000)",
    Callback= function(v) Options['P8S4S4'].Value = v * 100000 end
})

RandPos:Slider({
    Name    = "Radius Factor",
    Min     = 0.1,
    Max     = 5,
    Default = 1,
    Step    = 0.1,
    Tooltip = "Multiplier on the random reposition radius",
    Callback= function(v) Options['P8S4S5'].Value = v end
})

RandPos:Toggle({
    Name    = "Anchor from Character",
    Default = false,
    Tooltip = "Use character position as origin for random evade",
    Callback= function(v) Toggles['P8S4T8'].Value = v end
})

-- ── Misc > Control ───────────────────────────────────────────
local Control = MiscTab:Group("Control")

Control:Button({
    Name     = "Reset Ragebot",
    Tooltip  = "Force-reset ragebot internal state",
    Callback = function()
        if Bridge.KiciaRagebot then
            Bridge.KiciaRagebot.Reset()
            Library:Notify("Ragebot reset", "success")
        end
    end
})

Control:Button({
    Name     = "Destroy Ragebot",
    Variant  = "Danger",
    Tooltip  = "Permanently destroy the ragebot kernel",
    Callback = function()
        if Bridge.KiciaRagebot then
            Bridge.KiciaRagebot.Destroy()
            Library:Notify("Ragebot destroyed", "warning")
        end
    end
})

-- ── 5. MENU KEY + MOBILE TOGGLE ─────────────────────────────
Library.MenuKey = Enum.KeyCode.Insert
local Visible = true

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
    Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
    Create("UIStroke", { Color = CFG.AccentColor, Thickness = 2 })
})
MobileToggle.MouseButton1Click:Connect(function()
    Visible = not Visible
    MainFrame.Visible = Visible
end)

-- ── 6. RAGEBOT KERNEL (unmodified) ──────────────────────────
local function init(ctx)
    local RivalsRuntimeBridge = ctx.RivalsRuntimeBridge
    local Options = ctx.Options
    local Toggles = ctx.Toggles
    local FighterDataCache = ctx.FighterDataCache
    local GetChar = ctx.GetChar
    local GetRoot = ctx.GetRoot
    local __kicia_hook_genv = ctx.Genv
    -- __KICIA_RAGEBOT_BEGIN__
        local KiciaRagebot = {}
        RivalsRuntimeBridge.KiciaRagebot = KiciaRagebot

        local RunService = game:GetService('RunService')
        local HttpServiceRB = cloneref(game:GetService('HttpService'))
        local CollectionServiceRB = cloneref(game:GetService('CollectionService'))
        local PlayersRB = cloneref(game:GetService('Players'))
        local ReplicatedStorageRB = cloneref(game:GetService('ReplicatedStorage'))
        local WorkspaceRB = workspace
        local LPRB = PlayersRB.LocalPlayer
        local rbRandom = Random.new()

        local rbSetHidden = sethiddenproperty
        local rbSetFFlag = (type(setfflag) == 'function') and setfflag or sfflag
        local rbSetThreadIdentity = setthreadidentity
        local rbGetThreadIdentity = getthreadidentity

        local rbCleanFireEvent = Instance.new('RemoteEvent')
        local rbFireServerNative = clonefunction(rbCleanFireEvent.FireServer)

        local function rbRawWrite(obj, key, value)
            if typeof(obj) == 'Instance' then
                if not pcall(rbSetHidden, obj, key, value) then
                    pcall(function() obj[key] = value end)
                end
            else
                pcall(rawset, obj, key, value)
            end
        end

        local function optValue(id, default)
            local o = Options and Options[id]
            if o and o.Value ~= nil then return o.Value end
            return default
        end
        local function togValue(id, default)
            local t = Toggles and Toggles[id]
            if t and t.Value ~= nil then return t.Value == true end
            return default
        end
        local Setting = {
            Stability                = function() return optValue('P8S4S1', 1.5) end,
            ShootFrames              = function() return optValue('P8S4S2', 1) end,
            PrioritizeHackers        = function() return togValue('P8S4T4', true) end,
            WeaponPrimary            = function() return togValue('P8S4T5', true) end,
            WeaponSecondary          = function() return togValue('P8S4T6', true) end,
            WeaponMelee              = function() return togValue('P8S4T7', true) end,
            OnEmpty                  = function() return optValue('P8S4D1', 'SwapOrReload') end,
            EvasionMode              = function() return optValue('P8S4D2', 'Random') end,
            TranslocateOffset        = function() return optValue('P8S4S3', -5) end,
            RandomBaseRadius         = function() return optValue('P8S4S4', 100000000) end,
            RandomRadiusFactor       = function() return optValue('P8S4S5', 1) end,
            RandomAnchorFromCharacter= function() return togValue('P8S4T8', false) end,
            RepositionInterval       = function() return 0.3 end,
        }
        local PB_DEPTH_FORWARD             = { Min = 0, Max = 4 }
        local PB_DEPTH_FORWARD_FREQ        = 5
        local PB_DEPTH_UP                  = { Min = 0, Max = 5.5 }
        local PB_DEPTH_UP_FREQ             = 5
        local PB_FALLBACK_BASE_RADIUS      = 100
        local PB_FALLBACK_RADIUS_FACTOR    = 0.5
        local PB_FALLBACK_ANCHOR_FROM_CHARACTER = false

        local function findChild(root, ...)
            local node = root
            for _, name in ipairs({ ... }) do
                if not node then return nil end
                node = node:FindFirstChild(name)
            end
            return node
        end

        local cachedEnumLibrary = nil
        local function resolveEnumLibrary()
            if cachedEnumLibrary then return cachedEnumLibrary end
            local mod = findChild(ReplicatedStorageRB, 'Modules', 'EnumLibrary')
            if not mod then return nil end
            local ok, lib = pcall(require, mod)
            if ok and type(lib) == 'table' then
                cachedEnumLibrary = lib
                return lib
            end
            return nil
        end
        local function enc(name)
            local lib = resolveEnumLibrary()
            if not lib then return nil end
            local ok, token = pcall(lib.ToEnum, lib, name)
            if ok then return token end
            return nil
        end

        local cachedUseItemRemote = nil
        local function resolveUseItemRemote()
            if cachedUseItemRemote and cachedUseItemRemote.Parent then return cachedUseItemRemote end
            local remote = findChild(ReplicatedStorageRB, 'Remotes', 'Replication', 'Fighter', 'UseItem')
            if remote and remote:IsA('RemoteEvent') then
                cachedUseItemRemote = cloneref(remote)
                return cachedUseItemRemote
            end
            return nil
        end
        local cachedUpdateStateRemote = nil
        local function resolveUpdateStateRemote()
            if cachedUpdateStateRemote and cachedUpdateStateRemote.Parent then return cachedUpdateStateRemote end
            local remote = findChild(ReplicatedStorageRB, 'Remotes', 'Replication', 'Fighter', 'UpdateState')
            if remote and remote:IsA('RemoteEvent') then
                cachedUpdateStateRemote = cloneref(remote)
                return cachedUpdateStateRemote
            end
            return nil
        end
        local cachedCameraRotationRemote = nil
        local function resolveCameraRotationRemote()
            if cachedCameraRotationRemote and cachedCameraRotationRemote.Parent then return cachedCameraRotationRemote end
            local remote = findChild(ReplicatedStorageRB, 'Remotes', 'Replication', 'Fighter', 'UpdateCameraRotation')
            if remote and remote:IsA('RemoteEvent') then
                cachedCameraRotationRemote = cloneref(remote)
                return cachedCameraRotationRemote
            end
            return nil
        end
        local function requireModuleRB(name)
            local mod = findChild(ReplicatedStorageRB, 'Modules', name)
            if not mod then return nil end
            local ok, result = pcall(require, mod)
            if ok then return result end
            return nil
        end

        local cachedFighterController = nil
        local function resolveFighterController()
            local cc = cachedFighterController
            if type(cc) == 'table' and rawget(cc, 'LocalFighter') ~= nil then return cc end
            for _, m in ipairs(getgc(true)) do
                if type(m) == 'table' and rawget(m, 'LocalFighter') ~= nil and rawget(m, 'Objects') ~= nil then
                    cachedFighterController = m
                    return m
                end
            end
            return nil
        end
        local function resolveLocalFighter()
            local controller = resolveFighterController()
            return controller and rawget(controller, 'LocalFighter') or nil
        end
        local cachedFCPrototype = nil
        local function resolveFighterControllerPrototype()
            if type(cachedFCPrototype) == 'table' and rawget(cachedFCPrototype, '_CameraReplicationLoop') ~= nil then
                return cachedFCPrototype
            end
            local controller = resolveFighterController()
            if controller then
                local mt = getmetatable(controller)
                local proto = mt and rawget(mt, '__index') or nil
                if type(proto) == 'table' and rawget(proto, '_CameraReplicationLoop') ~= nil then
                    cachedFCPrototype = proto
                    return proto
                end
            end
            for _, m in ipairs(getgc(true)) do
                if type(m) == 'table' then
                    local idx = rawget(m, '__index')
                    if type(idx) == 'table' and rawget(idx, '_CameraReplicationLoop') ~= nil then
                        cachedFCPrototype = idx
                        return idx
                    end
                end
            end
            return nil
        end

        local function fireGun(objectId, isRaycast, aim1, aim2, hitboxHead, extra)
            local remote = resolveUseItemRemote()
            local token = enc('StartShooting')
            if not remote or not token or not objectId then return end
            local inner = { ['\0'] = aim1, ['\1'] = aim2, ['\2'] = hitboxHead, ['\3'] = extra }
            local payload
            if isRaycast then
                payload = { ['\1'] = inner, ['\2'] = true }
            else
                payload = { ['\1'] = inner }
            end
            rbFireServerNative(remote, objectId, token, payload, nil)
        end
        local function fireMeleeAttack(objectId, a, b, c, d)
            local remote = resolveUseItemRemote()
            local token = enc('StartShooting')
            local anim  = enc('AttackAnimation1')
            if not remote or not token or not anim or not objectId then return end
            rbFireServerNative(remote, objectId, token, { ['\1'] = { ['\0'] = a, ['\1'] = b, ['\2'] = c, ['\3'] = d }, ['\2'] = anim }, nil)
        end
        local function fireMeleeHeavy(objectId, a, b, c, d)
            local remote = resolveUseItemRemote()
            local token = enc('StartAiming')
            local anim  = enc('HeavyAttackAnimation1')
            if not remote or not token or not anim or not objectId then return end
            rbFireServerNative(remote, objectId, token, { ['\1'] = { ['\0'] = a, ['\1'] = b, ['\2'] = c, ['\3'] = d }, ['\2'] = anim }, nil)
        end
        local function fireReload(objectId)
            local remote = resolveUseItemRemote()
            local start  = enc('StartReloading')
            local reload = enc('Reload')
            if not remote or not start or not reload or not objectId then return end
            rbFireServerNative(remote, objectId, start, { ['\1'] = reload, ['\2'] = reload }, nil)
        end

        local function itemObjectId(item)
            local data = rawget(item, 'Data')
            return data and rawget(data, 'ObjectID') or nil
        end
        local function itemInfo(item) return rawget(item, 'Info') end
        local function itemType(item)
            local info = itemInfo(item)
            return info and rawget(info, 'Type') or nil
        end
        local function itemIsRaycast(item)
            local info = itemInfo(item)
            return info and rawget(info, 'IsRaycast') == true
        end
        local function itemName(item) return rawget(item, 'Name') or rawget(item, 'ItemName') end
        local function itemAmmo(item)
            local data = rawget(item, 'Data')
            local ammo = data and rawget(data, 'Ammo')
            return type(ammo) == 'number' and ammo or 0
        end
        local function itemAmmoReserve(item)
            local data    = rawget(item, 'Data')
            local reserve = data and rawget(data, 'AmmoReserve')
            if type(reserve) ~= 'number' then return math.huge end
            return reserve
        end
        local function itemIsReloading(item)
            local now = tick()
            local cooldown = rawget(item, '_reload_cooldown')
            if type(cooldown) == 'number' and now < cooldown then return true end
            local noAmmoCooldown = rawget(item, '_shoot_cooldown_no_ammo')
            return type(noAmmoCooldown) == 'number' and now < noAmmoCooldown
        end
        local function itemIsMagFull(item)
            local info    = itemInfo(item)
            local maxAmmo = info and rawget(info, 'MaxAmmo')
            return type(maxAmmo) == 'number' and maxAmmo <= itemAmmo(item)
        end
        local function itemIsEquipped(item) return rawget(item, 'IsEquipped') end
        local function equipItem(item, index)
            if itemIsEquipped(item) then return end
            local cf = rawget(item, 'ClientFighter')
            if cf and cf.EquipItem then
                pcall(cf.EquipItem, cf, index)
            end
        end
        local function reloadItem(item)
            local objectId = itemObjectId(item)
            if objectId then fireReload(objectId) end
        end

        local function resolveFighterItems(fighter)
            return rawget(fighter, 'Items') or {}
        end
        local function getItemsOfType(fighter, t)
            local result = {}
            for idx, item in pairs(resolveFighterItems(fighter)) do
                if itemType(item) == t then
                    result[#result + 1] = { item = item, index = idx }
                end
            end
            return result
        end
        local function getEquippedItem(fighter)
            for _, item in pairs(resolveFighterItems(fighter)) do
                if itemIsEquipped(item) then return item end
            end
            return nil
        end

        local function getAction(fighter)
            local equipped = getEquippedItem(fighter)
            if equipped then
                local t = itemType(equipped)
                if (t == 'Gun'   and Setting.WeaponPrimary())
                or (t == 'Melee' and Setting.WeaponMelee()) then
                    if itemAmmo(equipped) > 0 or t == 'Melee' then
                        return { type = 'Fire', item = equipped, itemType = t }
                    end
                    local onEmpty = Setting.OnEmpty()
                    if onEmpty == 'Reload' or onEmpty == 'SwapOrReload' then
                        if itemAmmoReserve(equipped) > 0 then
                            return { type = 'Reload', item = equipped }
                        end
                    end
                    if onEmpty == 'Swap' or onEmpty == 'SwapOrReload' then
                        local guns = getItemsOfType(fighter, 'Gun')
                        for _, g in ipairs(guns) do
                            if g.item ~= equipped and itemAmmo(g.item) > 0 and Setting.WeaponSecondary() then
                                return { type = 'Swap', item = g.item, index = g.index }
                            end
                        end
                    end
                end
            end
            if Setting.WeaponPrimary() or Setting.WeaponSecondary() then
                local guns = getItemsOfType(fighter, 'Gun')
                for _, g in ipairs(guns) do
                    if itemAmmo(g.item) > 0 then
                        return { type = 'Swap', item = g.item, index = g.index }
                    end
                end
            end
            return nil
        end

        local function getOtherPlayers()
            local result = {}
            for _, p in ipairs(PlayersRB:GetPlayers()) do
                if p ~= LPRB then
                    result[#result + 1] = p
                end
            end
            return result
        end

        local function getPlayerRootPart(player)
            local char = player.Character
            if not char then return nil end
            return char:FindFirstChild('HumanoidRootPart')
        end

        local function isHacker(player)
            return false -- detection hook placeholder
        end

        local function selectTarget()
            local ourRoot = GetRoot()
            if not ourRoot then return nil end
            local best, bestDist = nil, math.huge
            for _, p in ipairs(getOtherPlayers()) do
                local root = getPlayerRootPart(p)
                if root then
                    local dist = (root.Position - ourRoot.Position).Magnitude
                    local priority = Setting.PrioritizeHackers() and isHacker(p) and 0 or dist
                    if priority < bestDist then
                        best     = { player = p, rootPart = root }
                        bestDist = priority
                    end
                end
            end
            return best
        end

        local function hasTargets()
            return selectTarget() ~= nil
        end

        -- ---- Spatial limit gate (anti-detection) ----
        local SpatialLimitGate = {}
        SpatialLimitGate.__index = SpatialLimitGate
        function SpatialLimitGate.new()
            return setmetatable({ _lastPositions = {}, _lastTick = {} }, SpatialLimitGate)
        end
        function SpatialLimitGate:Tick(target)
            local id = tostring(target.player.UserId)
            local root = target.rootPart
            if not root then return false end
            local pos = root.Position
            local now = tick()
            local lastPos  = self._lastPositions[id]
            local lastTick = self._lastTick[id] or 0
            self._lastPositions[id] = pos
            self._lastTick[id]      = now
            if lastPos and (now - lastTick) < 0.1 then
                local speed = (pos - lastPos).Magnitude / (now - lastTick)
                if speed > 500 then return true end
            end
            return false
        end

        -- ---- Random evasion helpers ----
        local function randomEvade(clientCF)
            local baseRadius  = Setting.RandomBaseRadius()
            local factor      = Setting.RandomRadiusFactor()
            local anchorChar  = Setting.RandomAnchorFromCharacter()
            local anchor      = anchorChar and (GetRoot() and GetRoot().Position or clientCF.Position) or clientCF.Position
            local r = baseRadius * factor
            local x = rbRandom:NextNumber(-r, r)
            local z = rbRandom:NextNumber(-r, r)
            return CFrame.new(anchor + Vector3.new(x, 0, z))
        end

        local function translocateEvade(clientCF, hasAnyTarget)
            local offset = Setting.TranslocateOffset()
            return CFrame.new(clientCF.Position + Vector3.new(0, offset, 0))
        end

        -- ---- ProjectileBreaker ----
        local ProjectileBreaker = {}
        ProjectileBreaker.__index = ProjectileBreaker
        function ProjectileBreaker.new()
            return setmetatable({ _phase = 0 }, ProjectileBreaker)
        end
        function ProjectileBreaker:Compute(clientCF)
            self._phase = (self._phase + 1) % (PB_DEPTH_FORWARD_FREQ + PB_DEPTH_UP_FREQ)
            local fwd = PB_DEPTH_FORWARD.Min + rbRandom:NextNumber() * (PB_DEPTH_FORWARD.Max - PB_DEPTH_FORWARD.Min)
            local up  = PB_DEPTH_UP.Min     + rbRandom:NextNumber() * (PB_DEPTH_UP.Max     - PB_DEPTH_UP.Min)
            local dir = clientCF.LookVector
            return CFrame.new(clientCF.Position + dir * fwd + Vector3.new(0, up, 0))
        end
        function ProjectileBreaker:ResetState() self._phase = 0 end

        -- ---- Melee strategy ----
        local MeleeStrategy = {}
        MeleeStrategy.__index = MeleeStrategy
        function MeleeStrategy.new() return setmetatable({ _swingCooldown = 0 }, MeleeStrategy) end
        function MeleeStrategy:Plan(dt, target, item, ourRootPart, canFire)
            local cframe = CFrame.lookAt(ourRootPart.Position, target.rootPart.Position)
            local weaponAction = nil
            local now = tick()
            if canFire and now > self._swingCooldown then
                local objectId = itemObjectId(item)
                if objectId then
                    local a = target.rootPart.Position
                    weaponAction = function()
                        fireMeleeAttack(objectId, a, a, a, a)
                    end
                    self._swingCooldown = now + 0.3
                end
            end
            return cframe, nil, weaponAction
        end
        function MeleeStrategy:ResetState() self._swingCooldown = 0 end

        -- ---- Hitscan strategy ----
        local HitscanStrategy = {}
        HitscanStrategy.__index = HitscanStrategy
        function HitscanStrategy.new()
            return setmetatable({ _shootTimer = 0, _frameCount = 0 }, HitscanStrategy)
        end
        function HitscanStrategy:Plan(dt, target, item, ourRootPart, canFire)
            local aimPos = target.rootPart.Position
            local cframe = CFrame.lookAt(ourRootPart.Position, aimPos)
            local weaponAction = nil
            self._frameCount = self._frameCount + 1
            if canFire and self._frameCount >= Setting.ShootFrames() then
                self._frameCount = 0
                local objectId   = itemObjectId(item)
                local isRaycast  = itemIsRaycast(item)
                if objectId then
                    weaponAction = function()
                        fireGun(objectId, isRaycast, aimPos, aimPos, aimPos, nil)
                    end
                end
            end
            return cframe, weaponAction
        end
        function HitscanStrategy:ResetState()
            self._shootTimer = 0
            self._frameCount = 0
        end

        -- ---- CharacterController (server CFrame + view angles replication) ----
        local CharacterController = {}
        CharacterController.__index = CharacterController
        function CharacterController.new(rootPart)
            local self = setmetatable({
                _rootPart         = rootPart,
                _serverCFrame     = nil,
                _viewAngles       = nil,
                _repositionTimer  = 0,
            }, CharacterController)
            return self
        end
        function CharacterController:GetClientCFrame()
            return self._rootPart.CFrame
        end
        function CharacterController:SetServerCFrame(cf)
            self._serverCFrame = cf
        end
        function CharacterController:SendViewAngles(speed, angles)
            self._viewAngles = angles
        end
        function CharacterController:HeartbeatUpdate()
            local remote = resolveUpdateStateRemote()
            if not remote then return end
            if self._serverCFrame then
                local cf = self._serverCFrame
                pcall(rbFireServerNative, remote, {
                    CFrame = cf,
                    Velocity = Vector3.zero
                })
            end
            local camRemote = resolveCameraRotationRemote()
            if camRemote and self._viewAngles then
                pcall(rbFireServerNative, camRemote, self._viewAngles)
            end
        end
        function CharacterController:Destroy() end

        -- ---- Defensive helpers (shield stance) ----
        local function localShieldStance(fighter)
            local equipped = getEquippedItem(fighter)
            if not equipped then return nil end
            local info = itemInfo(equipped)
            return info and rawget(info, 'ShieldStance') or nil
        end
        local function getDefensiveCFrame(cframe, stance, targetRoot)
            if not stance or not targetRoot then return cframe end
            return CFrame.lookAt(cframe.Position, targetRoot.Position)
        end
        local function getDefensiveViewAngles(stance)
            return nil
        end

        -- ---- apply forced-crouch ----
        local function applyEnabledFFlags(enabled)
            if type(rbSetFFlag) == 'function' then
                pcall(rbSetFFlag, 'UserCrouchEnabled', tostring(enabled))
            end
        end

        -- ── Controller (main controller object) ──────────────────────────
        local Controller = {}
        Controller.__index = Controller
        function Controller.new()
            local self = setmetatable({
                _enabled                 = false,
                _characterController     = nil,
                _boundRootPart           = nil,
                _lastTargetWorld         = nil,
                _lastDefensiveViewAngles = nil,
                _spatialLimitGate        = SpatialLimitGate.new(),
                _meleeStrategy           = MeleeStrategy.new(),
                _hitscanStrategy         = HitscanStrategy.new(),
                _projectileBreaker       = ProjectileBreaker.new(),
                _partGlue                = { Destroy = function() end },
                _forcedCrouchEnabled     = false,
            }, Controller)
            return self
        end
        function Controller:SetEnabled(v)
            self._enabled = v
            applyEnabledFFlags(v)
        end
        function Controller:_ApplyForcedCrouch(v)
            if self._forcedCrouchEnabled == v then return end
            self._forcedCrouchEnabled = v
        end
        function Controller:_EnsureCharacterController()
            local root = GetRoot()
            if not root then return nil end
            if self._characterController == nil or self._boundRootPart ~= root then
                if self._characterController then
                    self._characterController:Destroy()
                end
                self._characterController = CharacterController.new(root)
                self._boundRootPart       = root
            end
            return self._characterController
        end
        function Controller:_EvadePlan(clientCF, mode)
            if mode == 'Off' then return {} end
            if mode ~= 'ProjectileBreaker' then
                return { cframe = randomEvade(clientCF) }
            end
            return { cframe = self._projectileBreaker:Compute(clientCF), shouldSkipDefense = true }
        end
        function Controller:_Plan(dt, action, target, ourRootPart, clientCF, mode)
            local canFire = true
            if target ~= nil then canFire = not self._spatialLimitGate:Tick(target) end
            if action == nil then return self:_EvadePlan(clientCF, mode) end
            if action.type == 'Swap' then
                local plan = self:_EvadePlan(clientCF, mode)
                local item  = action.item
                local index = action.index
                plan.weaponAction = function() equipItem(item, index) end
                return plan
            end
            if action.type == 'Reload' then
                local plan = self:_EvadePlan(clientCF, mode)
                local item  = action.item
                plan.weaponAction = function() reloadItem(item) end
                return plan
            end
            if target == nil then return self:_EvadePlan(clientCF, mode) end
            if action.itemType == 'Melee' then
                local cframe, viewAngles, weaponAction = self._meleeStrategy:Plan(dt, target, action.item, ourRootPart, canFire)
                return { cframe = cframe, viewAngles = viewAngles, weaponAction = weaponAction, shouldSkipDefense = true, shouldForceCrouch = true }
            end
            if action.itemType ~= 'Gun' then return {} end
            if itemIsReloading(action.item) then return self:_EvadePlan(clientCF, mode) end
            local cframe, weaponAction = self._hitscanStrategy:Plan(dt, target, action.item, ourRootPart, canFire)
            return { cframe = cframe, weaponAction = weaponAction, shouldForceCrouch = true, isAimPose = weaponAction ~= nil }
        end
        function Controller:_ApplyPlan(plan, target, characterController, fighter)
            local cframe = plan.cframe
            if cframe == nil or target == nil or plan.shouldSkipDefense then
                characterController:SetServerCFrame(cframe)
                characterController:SendViewAngles(20, plan.viewAngles)
                return
            end
            local stance = localShieldStance(fighter)
            characterController:SetServerCFrame(getDefensiveCFrame(cframe, stance, target.rootPart))
            if plan.isAimPose or plan.shouldDefendInPlace then
                self._lastDefensiveViewAngles = getDefensiveViewAngles(stance)
            end
            characterController:SendViewAngles(20, plan.viewAngles or self._lastDefensiveViewAngles)
        end
        function Controller:Update(dt)
            local fighter             = resolveLocalFighter()
            local characterController = self:_EnsureCharacterController()
            if fighter == nil or characterController == nil or not self._enabled then
                self:_Reset()
                return
            end
            if RivalsRuntimeBridge.IsReadyToFight and not RivalsRuntimeBridge.IsReadyToFight() then
                self:_Reset()
                return
            end
            local ourRootPart = self._boundRootPart
            local clientCF    = characterController:GetClientCFrame()
            local mode        = Setting.EvasionMode()
            if mode == 'Translocate' then
                self:_ApplyForcedCrouch(false)
                characterController:SetServerCFrame(translocateEvade(clientCF, hasTargets()))
                characterController:HeartbeatUpdate()
                return
            end
            local target = selectTarget()
            local action = getAction(fighter)
            self._lastTargetWorld = target ~= nil and target.rootPart.Position or nil
            local plan = self:_Plan(dt, action, target, ourRootPart, clientCF, mode)
            self:_ApplyPlan(plan, target, characterController, fighter)
            self:_ApplyForcedCrouch(plan.shouldForceCrouch == true)
            if plan.weaponAction ~= nil then plan.weaponAction() end
            characterController:HeartbeatUpdate()
        end
        function Controller:GetLastTargetWorld()
            return self._lastTargetWorld
        end
        function Controller:_Reset()
            self._lastTargetWorld         = nil
            self._lastDefensiveViewAngles = nil
            self:_ApplyForcedCrouch(false)
            self._meleeStrategy:ResetState()
            self._hitscanStrategy:ResetState()
            self._projectileBreaker:ResetState()
            if self._characterController then
                self._characterController:SetServerCFrame(nil)
                self._characterController:SendViewAngles(20, nil)
                self._characterController:HeartbeatUpdate()
            end
        end
        function Controller:Destroy()
            self:SetEnabled(false)
            self:_Reset()
            if self._characterController then
                self._characterController:Destroy()
                self._characterController = nil
                self._boundRootPart       = nil
            end
            self._partGlue:Destroy()
            applyEnabledFFlags(false)
        end

        -- ── Lifecycle / bridge ────────────────────────────────────────────
        local controllerInstance = nil
        local function ensureController()
            if controllerInstance == nil then
                controllerInstance = Controller.new()
            end
            return controllerInstance
        end
        function KiciaRagebot.IsEnabled()
            if KiciaRagebot.CapsOk == nil then
                KiciaRagebot.CapsOk = __kicia_hook_genv.KiciaHookCaps.gate('Ragebot', 'getgc', 'sethiddenproperty')
            end
            return KiciaRagebot.CapsOk == true
        end
        function KiciaRagebot.Update(dt)
            local controller = ensureController()
            local enabled    = KiciaRagebot.IsEnabled()
            if controller._enabled ~= enabled then
                controller:SetEnabled(enabled)
            end
            controller:Update(dt or 0)
        end
        function KiciaRagebot.Reset()
            if controllerInstance then controllerInstance:_Reset() end
        end
        function KiciaRagebot.Destroy()
            if controllerInstance then
                controllerInstance:Destroy()
                controllerInstance = nil
            end
        end
        RivalsRuntimeBridge.UpdateKiciaRagebot = KiciaRagebot.Update
        RivalsRuntimeBridge.ResetKiciaRagebot  = KiciaRagebot.Reset
        RivalsRuntimeBridge.DestroyKiciaRagebot= KiciaRagebot.Destroy
end

-- ── 7. BOOT ──────────────────────────────────────────────────
init({
    RivalsRuntimeBridge = Bridge,
    Options             = Options,
    Toggles             = Toggles,
    FighterDataCache    = FighterDataCache,
    GetChar             = GetChar,
    GetRoot             = GetRoot,
    Genv                = Genv,
})

assert(Bridge.KiciaRagebot, "Ragebot kernel failed to initialize")

RunService.Heartbeat:Connect(function(dt)
    local ok, err = pcall(function()
        Bridge.KiciaRagebot.Update(dt)
    end)
    if not ok then warn("[Ragebot] " .. tostring(err)) end
end)

Library:Notify("Ragebot loaded", "success")
Library:Notify("Insert = toggle menu")
