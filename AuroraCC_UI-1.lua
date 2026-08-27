-- Aurora.cc - discord.gg/dMuenjFP5v

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Settings = {
	Effects = true,
	Animations = true,
	Notifications = true,
	Snow = true,
	BlurEnabled = true,
	BlurAmount = 14,
	Ambience = false,
	ShowWatermark = true,
	ShowKeybindList = true,
}

local function playSound(id, volume, playbackSpeed)
	if not Settings.Effects then return end
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. tostring(id)
	s.Volume = volume or 0.45
	s.PlaybackSpeed = playbackSpeed or 1
	s.Parent = SoundService
	s:Play()
	s.Ended:Connect(function()
		s:Destroy()
	end)
	task.delay(3, function()
		if s and s.Parent then s:Destroy() end
	end)
end

local SFX = {
	TabTap      = 6895079853,
	ToggleClick = 4522679180,
	SliderTick  = 9113089061,
	ColourKnock = 9114227055,
	LoadDone    = 6026986093,
	Dropdown    = 4522679180,
}

local lastSliderSound = 0

local function isMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function getDeviceType()
	if isMobile() then
		return "Mobile"
	elseif UserInputService.KeyboardEnabled then
		return "PC"
	else
		return UserInputService.TouchEnabled and "Mobile" or "PC"
	end
end

local ON_MOBILE = getDeviceType() == "Mobile"

local Theme = {
	Accent = Color3.fromRGB(90, 100, 120),
	AccentDark = Color3.fromRGB(70, 78, 95),
	Bg = Color3.fromRGB(12, 12, 14),
	Header = Color3.fromRGB(16, 16, 20),
	Row = Color3.fromRGB(26, 26, 32),
	RowHover = Color3.fromRGB(34, 34, 42),
	Track = Color3.fromRGB(36, 36, 44),
	Stroke = Color3.fromRGB(48, 48, 58),
	Text = Color3.fromRGB(210, 210, 220),
	TextDim = Color3.fromRGB(130, 132, 145),
	CheckOff = Color3.fromRGB(48, 48, 56),
	Dropdown = Color3.fromRGB(22, 22, 28),
	DropdownItem = Color3.fromRGB(28, 28, 34),
	Section = Color3.fromRGB(18, 18, 22),
}

local ThemeListeners = {}

local function registerTheme(fn)
	table.insert(ThemeListeners, fn)
end

local function applyTheme()
	for _, fn in ipairs(ThemeListeners) do
		pcall(fn)
	end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AuroraCC"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Blur = Instance.new("BlurEffect")
Blur.Name = "AuroraBlur"
Blur.Size = 0
Blur.Enabled = true
Blur.Parent = Lighting

local function setBlur(on)
	local target = (on and Settings.BlurEnabled) and Settings.BlurAmount or 0
	if Settings.Animations then
		TweenService:Create(Blur, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
			Size = target
		}):Play()
	else
		Blur.Size = target
	end
end

local SnowContainer = Instance.new("Frame")
SnowContainer.Name = "SnowContainer"
SnowContainer.Size = UDim2.new(1, 0, 1, 0)
SnowContainer.BackgroundTransparency = 1
SnowContainer.ClipsDescendants = true
SnowContainer.Visible = false
SnowContainer.ZIndex = 50
SnowContainer.Parent = ScreenGui

local snowflakes = {}
local snowRunning = false
local snowConn

for i = 1, 55 do
	local flake = Instance.new("TextLabel")
	flake.BackgroundTransparency = 1
	flake.Text = "❄"
	flake.TextColor3 = Color3.fromRGB(255, 255, 255)
	flake.TextTransparency = math.random(15, 55) / 100
	flake.TextSize = math.random(10, 22)
	flake.Font = Enum.Font.SourceSans
	flake.Size = UDim2.new(0, 24, 0, 24)
	flake.AnchorPoint = Vector2.new(0.5, 0.5)
	flake.ZIndex = 51
	flake.Parent = SnowContainer
	table.insert(snowflakes, {
		label = flake,
		x = math.random(),
		y = math.random() * -0.2,
		speed = 0.04 + math.random() * 0.09,
		drift = (math.random() - 0.5) * 0.03,
		rot = math.random() * 360,
		rotSpeed = (math.random() - 0.5) * 40
	})
end

local function startSnow()
	if snowRunning or not Settings.Effects or not Settings.Snow then return end
	snowRunning = true
	SnowContainer.Visible = true
	snowConn = RunService.RenderStepped:Connect(function(dt)
		for _, s in ipairs(snowflakes) do
			s.y += s.speed * dt
			s.x += s.drift * dt
			s.rot += s.rotSpeed * dt
			if s.x < -0.05 then s.x = 1.05 end
			if s.x > 1.05 then s.x = -0.05 end
			if s.y > 1.1 then
				s.y = -0.05 - math.random() * 0.15
				s.x = math.random()
				s.speed = 0.04 + math.random() * 0.09
				s.drift = (math.random() - 0.5) * 0.03
			end
			s.label.Position = UDim2.new(s.x, 0, s.y, 0)
			s.label.Rotation = s.rot
		end
	end)
end

local function stopSnow()
	snowRunning = false
	if snowConn then snowConn:Disconnect() snowConn = nil end
	SnowContainer.Visible = false
end

local function spawnSliderGlitter(parent, localX, localY)
	if not Settings.Effects then return end
	for i = 1, math.random(2, 3) do
		local p = Instance.new("TextLabel")
		p.BackgroundTransparency = 1
		p.Text = ({"·", "⋆", "✧"})[math.random(1, 3)]
		p.TextColor3 = Color3.fromRGB(200, 205, 230)
		p.TextTransparency = 0.25
		p.TextSize = math.random(7, 11)
		p.Font = Enum.Font.SourceSans
		p.Size = UDim2.new(0, 12, 0, 12)
		p.AnchorPoint = Vector2.new(0.5, 0.5)
		p.Position = UDim2.new(0, localX + math.random(-4, 4), 0, localY + math.random(-3, 3))
		p.ZIndex = 90
		p.Parent = parent

		local angle = math.rad(math.random(0, 360))
		local dist = math.random(8, 18)
		local endPos = UDim2.new(0,
			localX + math.cos(angle) * dist,
			0,
			localY + math.sin(angle) * dist - math.random(4, 10)
		)

		local tw = TweenService:Create(p, TweenInfo.new(0.22 + math.random() * 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = endPos,
			TextTransparency = 1,
			Rotation = math.random(-40, 40)
		})
		tw:Play()
		tw.Completed:Connect(function()
			p:Destroy()
		end)
	end
end

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingScreen"
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 100
LoadingFrame.Parent = ScreenGui

local CenterBox = Instance.new("Frame")
CenterBox.Size = UDim2.new(0, 420, 0, 150)
CenterBox.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterBox.AnchorPoint = Vector2.new(0.5, 0.5)
CenterBox.BackgroundTransparency = 1
CenterBox.ZIndex = 102
CenterBox.Parent = LoadingFrame

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 40)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.TextSize = 22
LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadTitle.Text = "Aurora.cc - discord.gg/dMuenjFP5v"
LoadTitle.TextTransparency = 1
LoadTitle.TextXAlignment = Enum.TextXAlignment.Center
LoadTitle.ZIndex = 103
LoadTitle.Parent = CenterBox

local LoadSub = Instance.new("TextLabel")
LoadSub.Size = UDim2.new(1, 0, 0, 22)
LoadSub.Position = UDim2.new(0, 0, 0, 44)
LoadSub.BackgroundTransparency = 1
LoadSub.Font = Enum.Font.Gotham
LoadSub.TextSize = 14
LoadSub.TextColor3 = Color3.fromRGB(150, 155, 170)
LoadSub.Text = "Initializing..."
LoadSub.TextTransparency = 1
LoadSub.TextXAlignment = Enum.TextXAlignment.Center
LoadSub.ZIndex = 103
LoadSub.Parent = CenterBox

local BarTrack = Instance.new("Frame")
BarTrack.Size = UDim2.new(1, 0, 0, 3)
BarTrack.Position = UDim2.new(0, 0, 0, 86)
BarTrack.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
BarTrack.BorderSizePixel = 0
BarTrack.ClipsDescendants = true
BarTrack.ZIndex = 103
BarTrack.Parent = CenterBox
Instance.new("UICorner", BarTrack).CornerRadius = UDim.new(1, 0)

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressBar.BorderSizePixel = 0
ProgressBar.ZIndex = 104
ProgressBar.Parent = BarTrack
Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(1, 0)

local GlowBar = Instance.new("Frame")
GlowBar.Size = UDim2.new(0, 0, 1, 0)
GlowBar.BackgroundColor3 = Color3.fromRGB(200, 210, 255)
GlowBar.BackgroundTransparency = 0.6
GlowBar.BorderSizePixel = 0
GlowBar.ZIndex = 103
GlowBar.Parent = BarTrack
Instance.new("UICorner", GlowBar).CornerRadius = UDim.new(1, 0)

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Size = UDim2.new(1, 0, 0, 24)
PercentLabel.Position = UDim2.new(0, 0, 0, 102)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Font = Enum.Font.GothamMedium
PercentLabel.TextSize = 16
PercentLabel.TextColor3 = Color3.fromRGB(210, 215, 225)
PercentLabel.Text = "0%"
PercentLabel.TextTransparency = 1
PercentLabel.TextXAlignment = Enum.TextXAlignment.Center
PercentLabel.ZIndex = 103
PercentLabel.Parent = CenterBox

local DotsFrame = Instance.new("Frame")
DotsFrame.Size = UDim2.new(0, 60, 0, 8)
DotsFrame.Position = UDim2.new(0.5, 0, 1, 10)
DotsFrame.AnchorPoint = Vector2.new(0.5, 0)
DotsFrame.BackgroundTransparency = 1
DotsFrame.ZIndex = 103
DotsFrame.Parent = CenterBox
local dotsLayout = Instance.new("UIListLayout")
dotsLayout.FillDirection = Enum.FillDirection.Horizontal
dotsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
dotsLayout.Padding = UDim.new(0, 8)
dotsLayout.Parent = DotsFrame

local dots = {}
for i = 1, 3 do
	local d = Instance.new("Frame")
	d.Size = UDim2.new(0, 6, 0, 6)
	d.BackgroundColor3 = Color3.fromRGB(70, 75, 90)
	d.BorderSizePixel = 0
	d.ZIndex = 104
	d.Parent = DotsFrame
	Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
	table.insert(dots, d)
end

local function playLoading()
	TweenService:Create(LoadTitle, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
	task.wait(0.15)
	TweenService:Create(LoadSub, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
	TweenService:Create(PercentLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()

	local dotsRunning = true
	task.spawn(function()
		local idx = 1
		while dotsRunning do
			for i, d in ipairs(dots) do
				TweenService:Create(d, TweenInfo.new(0.25), {
					BackgroundColor3 = (i == idx) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 75, 90)
				}):Play()
			end
			idx = idx % 3 + 1
			task.wait(0.35)
		end
	end)

	local duration, startTime, lastPercent = 5, tick(), 0
	local connection
	connection = RunService.RenderStepped:Connect(function()
		local alpha = math.clamp((tick() - startTime) / duration, 0, 1)
		local eased = 1 - (1 - alpha) ^ 4
		local percent = math.floor(eased * 100)
		if percent ~= lastPercent then
			lastPercent = percent
			PercentLabel.Text = percent .. "%"
			if percent < 25 then LoadSub.Text = "Loading assets..."
			elseif percent < 50 then LoadSub.Text = "Preparing interface..."
			elseif percent < 80 then LoadSub.Text = "Almost ready..."
			else LoadSub.Text = "Finishing up..." end
		end
		ProgressBar.Size = UDim2.new(eased, 0, 1, 0)
		GlowBar.Size = UDim2.new(math.min(eased + 0.08, 1), 0, 1, 0)

		if alpha >= 1 then
			connection:Disconnect()
			dotsRunning = false
			playSound(SFX.LoadDone, 0.55, 1)
			TweenService:Create(ProgressBar, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 230, 255)}):Play()
			task.wait(0.25)
			local fade = TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
			for _, obj in ipairs({LoadTitle, LoadSub, PercentLabel}) do
				TweenService:Create(obj, fade, {TextTransparency = 1}):Play()
			end
			TweenService:Create(BarTrack, fade, {BackgroundTransparency = 1}):Play()
			TweenService:Create(ProgressBar, fade, {BackgroundTransparency = 1}):Play()
			TweenService:Create(GlowBar, fade, {BackgroundTransparency = 1}):Play()
			for _, d in ipairs(dots) do TweenService:Create(d, fade, {BackgroundTransparency = 1}):Play() end
			TweenService:Create(LoadingFrame, TweenInfo.new(0.65, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
			task.wait(0.7)
			LoadingFrame:Destroy()
			startMainUI()
		end
	end)
end

local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, ON_MOBILE and 280 or 300, 1, 0)
NotifContainer.Position = UDim2.new(1, ON_MOBILE and -292 or -312, 0, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.ZIndex = 80
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifLayout.Parent = NotifContainer

local NotifPad = Instance.new("UIPadding")
NotifPad.PaddingBottom = UDim.new(0, ON_MOBILE and 16 or 20)
NotifPad.PaddingRight = UDim.new(0, 8)
NotifPad.Parent = NotifContainer

local function Notify(title, message, duration)
	if not Settings.Notifications then return end
	duration = duration or 3

	local notifW = ON_MOBILE and 268 or 288
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, notifW, 0, 0)
	notif.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
	notif.BorderSizePixel = 0
	notif.ClipsDescendants = true
	notif.LayoutOrder = -tick()
	notif.ZIndex = 81
	notif.BackgroundTransparency = 0
	notif.Parent = NotifContainer
	Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Accent
	stroke.Thickness = 1
	stroke.Transparency = 0.55
	stroke.Parent = notif
	registerTheme(function()
		if stroke and stroke.Parent then stroke.Color = Theme.Accent end
	end)

	local accentLine = Instance.new("Frame")
	accentLine.Size = UDim2.new(0, 3, 1, 0)
	accentLine.BackgroundColor3 = Theme.Accent
	accentLine.BorderSizePixel = 0
	accentLine.ZIndex = 82
	accentLine.Parent = notif
	Instance.new("UICorner", accentLine).CornerRadius = UDim.new(0, 8)
	registerTheme(function()
		if accentLine and accentLine.Parent then accentLine.BackgroundColor3 = Theme.Accent end
	end)

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -20, 0, 18)
	t.Position = UDim2.new(0, 14, 0, 8)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.GothamBold
	t.TextSize = 13
	t.TextColor3 = Color3.fromRGB(235, 235, 242)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Text = title or "Notification"
	t.ZIndex = 82
	t.Parent = notif

	local m = Instance.new("TextLabel")
	m.Size = UDim2.new(1, -20, 0, 28)
	m.Position = UDim2.new(0, 14, 0, 26)
	m.BackgroundTransparency = 1
	m.Font = Enum.Font.Gotham
	m.TextSize = 12
	m.TextColor3 = Color3.fromRGB(150, 152, 165)
	m.TextXAlignment = Enum.TextXAlignment.Left
	m.TextYAlignment = Enum.TextYAlignment.Top
	m.TextWrapped = true
	m.Text = message or ""
	m.ZIndex = 82
	m.Parent = notif

	local timerBg = Instance.new("Frame")
	timerBg.Size = UDim2.new(1, 0, 0, 2)
	timerBg.Position = UDim2.new(0, 0, 1, -2)
	timerBg.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	timerBg.BorderSizePixel = 0
	timerBg.ZIndex = 82
	timerBg.Parent = notif

	local timerBar = Instance.new("Frame")
	timerBar.Size = UDim2.new(1, 0, 1, 0)
	timerBar.BackgroundColor3 = Theme.Accent
	timerBar.BorderSizePixel = 0
	timerBar.ZIndex = 83
	timerBar.Parent = timerBg
	registerTheme(function()
		if timerBar and timerBar.Parent then timerBar.BackgroundColor3 = Theme.Accent end
	end)

	if Settings.Animations then
		TweenService:Create(notif, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, notifW, 0, 62)
		}):Play()
	else
		notif.Size = UDim2.new(0, notifW, 0, 62)
	end

	TweenService:Create(timerBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 1, 0)
	}):Play()

	task.delay(duration, function()
		if notif and notif.Parent then
			if Settings.Animations then
				local c = TweenService:Create(notif, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
					Size = UDim2.new(0, notifW, 0, 0),
					BackgroundTransparency = 1
				})
				c:Play()
				c.Completed:Wait()
			end
			notif:Destroy()
		end
	end)
end

local MainFrame, isOpen, animating, MobileToggleBtn
local AmbienceStroke

function startMainUI()
	local UI_W = ON_MOBILE and 320 or 420
	local UI_H = ON_MOBILE and 540 or 620

	MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, UI_W, 0, UI_H)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Theme.Bg
	MainFrame.BorderSizePixel = 0
	MainFrame.Visible = false
	MainFrame.ClipsDescendants = true
	MainFrame.ZIndex = 60
	MainFrame.Parent = ScreenGui
	MainFrame.Active = false
	registerTheme(function() MainFrame.BackgroundColor3 = Theme.Bg end)

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 14)
	mainCorner.Parent = MainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Theme.Stroke
	mainStroke.Thickness = 1.5
	mainStroke.Transparency = 0.2
	mainStroke.Parent = MainFrame
	registerTheme(function() mainStroke.Color = Theme.Stroke end)

	AmbienceStroke = Instance.new("UIStroke")
	AmbienceStroke.Name = "AmbienceGlow"
	AmbienceStroke.Color = Theme.Accent
	AmbienceStroke.Thickness = 2.5
	AmbienceStroke.Transparency = 1
	AmbienceStroke.Parent = MainFrame
	registerTheme(function()
		AmbienceStroke.Color = Theme.Accent
	end)

	local function updateAmbience()
		local target = Settings.Ambience and 0.35 or 1
		if Settings.Animations then
			TweenService:Create(AmbienceStroke, TweenInfo.new(0.3), {Transparency = target}):Play()
		else
			AmbienceStroke.Transparency = target
		end
	end

	local Header = Instance.new("Frame")
	Header.Size = UDim2.new(1, 0, 0, 44)
	Header.BackgroundColor3 = Theme.Header
	Header.BorderSizePixel = 0
	Header.ZIndex = 61
	Header.Parent = MainFrame
	Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)
	registerTheme(function() Header.BackgroundColor3 = Theme.Header end)

	local headerFix = Instance.new("Frame")
	headerFix.Size = UDim2.new(1, 0, 0, 14)
	headerFix.Position = UDim2.new(0, 0, 1, -14)
	headerFix.BackgroundColor3 = Theme.Header
	headerFix.BorderSizePixel = 0
	headerFix.ZIndex = 61
	headerFix.Parent = Header
	registerTheme(function() headerFix.BackgroundColor3 = Theme.Header end)

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -16, 1, 0)
	Title.Position = UDim2.new(0.5, 0, 0.5, 0)
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = ON_MOBILE and 11 or 13
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Text = "Aurora.cc - discord.gg/dMuenjFP5v"
	Title.TextXAlignment = Enum.TextXAlignment.Center
	Title.TextYAlignment = Enum.TextYAlignment.Center
	Title.ZIndex = 62
	Title.Parent = Header

	do
		local dragging = false
		local dragStart, startPos
		local dragInput

		Header.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = MainFrame.Position
				dragInput = input
			end
		end)

		Header.InputEnded:Connect(function(input)
			if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
				dragInput = nil
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
				dragInput = nil
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if not dragging then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local delta = input.Position - dragStart
				MainFrame.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end)
	end

	local TabBar = Instance.new("Frame")
	TabBar.Name = "TabBar"
	TabBar.Size = UDim2.new(1, -12, 0, 32)
	TabBar.Position = UDim2.new(0, 6, 0, 48)
	TabBar.BackgroundTransparency = 1
	TabBar.ZIndex = 61
	TabBar.Parent = MainFrame

	local tabNames = {"Combat", "Visuals", "Character", "Misc", "Settings"}
	local tabButtons = {}
	local tabPages = {}
	local currentTab = 1

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabLayout.Padding = UDim.new(0, 6)
	tabLayout.Parent = TabBar

	local Indicator = Instance.new("Frame")
	Indicator.Name = "Indicator"
	Indicator.Size = UDim2.new(0, 48, 0, 2)
	Indicator.Position = UDim2.new(0, 0, 1, -1)
	Indicator.BackgroundColor3 = Theme.Accent
	Indicator.BorderSizePixel = 0
	Indicator.ZIndex = 63
	Indicator.Parent = TabBar
	Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
	registerTheme(function() Indicator.BackgroundColor3 = Theme.Accent end)

	local ContentHolder = Instance.new("Frame")
	ContentHolder.Name = "ContentHolder"
	ContentHolder.Size = UDim2.new(1, -12, 1, -88)
	ContentHolder.Position = UDim2.new(0, 6, 0, 84)
	ContentHolder.BackgroundTransparency = 1
	ContentHolder.ClipsDescendants = true
	ContentHolder.ZIndex = 61
	ContentHolder.Parent = MainFrame

	for i, name in ipairs(tabNames) do
		local page = Instance.new("Frame")
		page.Name = name .. "Page"
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.Visible = (i == 1)
		page.ZIndex = 62
		page.Parent = ContentHolder
		tabPages[i] = page

		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = UDim2.new(0, ON_MOBILE and 52 or 68, 1, 0)
		btn.BackgroundTransparency = 1
		btn.Font = Enum.Font.GothamMedium
		btn.TextSize = ON_MOBILE and 11 or 12
		btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Theme.TextDim
		btn.Text = name
		btn.ZIndex = 62
		btn.Parent = TabBar
		tabButtons[i] = btn
	end

	task.defer(function()
		local first = tabButtons[1]
		if first then
			Indicator.Size = UDim2.new(0, first.AbsoluteSize.X - 6, 0, 2)
			Indicator.Position = UDim2.new(0, first.AbsolutePosition.X - TabBar.AbsolutePosition.X + 3, 1, -1)
		end
	end)

	local switching = false
	local function switchTab(index)
		if index == currentTab or switching then return end
		switching = true
		playSound(SFX.TabTap, 0.4, 1.05)

		local oldPage = tabPages[currentTab]
		local newPage = tabPages[index]
		local oldBtn = tabButtons[currentTab]
		local newBtn = tabButtons[index]

		oldPage.Visible = false
		newPage.Visible = true

		local targetX = newBtn.AbsolutePosition.X - TabBar.AbsolutePosition.X + 3
		local targetW = newBtn.AbsoluteSize.X - 6

		if Settings.Animations then
			TweenService:Create(Indicator, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, targetX, 1, -1),
				Size = UDim2.new(0, targetW, 0, 2)
			}):Play()
			TweenService:Create(oldBtn, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim}):Play()
			TweenService:Create(newBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		else
			Indicator.Position = UDim2.new(0, targetX, 1, -1)
			Indicator.Size = UDim2.new(0, targetW, 0, 2)
			oldBtn.TextColor3 = Theme.TextDim
			newBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		end

		currentTab = index
		task.delay(0.15, function() switching = false end)
	end

	for i, btn in ipairs(tabButtons) do
		btn.MouseButton1Click:Connect(function()
			switchTab(i)
		end)
	end

	local function createGrid(parent)
		local gap = 6
		local halfW = 0.5
		local halfH = 0.5

		local sections = {}
		local positions = {
			{0, 0},
			{0.5, 0},
			{0, 0.5},
			{0.5, 0.5}
		}

		for i = 1, 4 do
			local sec = Instance.new("Frame")
			sec.Name = "Section" .. i
			sec.Size = UDim2.new(halfW, -gap / 2 - 1, halfH, -gap / 2 - 1)
			sec.Position = UDim2.new(positions[i][1], positions[i][1] == 0 and 0 or gap / 2 + 1, positions[i][2], positions[i][2] == 0 and 0 or gap / 2 + 1)
			sec.BackgroundColor3 = Theme.Section
			sec.BorderSizePixel = 0
			sec.ClipsDescendants = true
			sec.ZIndex = 63
			sec.Parent = parent
			Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 10)
			registerTheme(function() sec.BackgroundColor3 = Theme.Section end)

			local secStroke = Instance.new("UIStroke")
			secStroke.Color = Theme.Stroke
			secStroke.Thickness = 1
			secStroke.Transparency = 0.4
			secStroke.Parent = sec
			registerTheme(function() secStroke.Color = Theme.Stroke end)

			local titleBar = Instance.new("Frame")
			titleBar.Size = UDim2.new(1, 0, 0, 26)
			titleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
			titleBar.BorderSizePixel = 0
			titleBar.ZIndex = 64
			titleBar.Parent = sec
			Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

			local titleFix = Instance.new("Frame")
			titleFix.Size = UDim2.new(1, 0, 0, 10)
			titleFix.Position = UDim2.new(0, 0, 1, -10)
			titleFix.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
			titleFix.BorderSizePixel = 0
			titleFix.ZIndex = 64
			titleFix.Parent = titleBar

			local titleLabel = Instance.new("TextLabel")
			titleLabel.Name = "SectionTitle"
			titleLabel.Size = UDim2.new(1, -12, 1, 0)
			titleLabel.Position = UDim2.new(0, 10, 0, 0)
			titleLabel.BackgroundTransparency = 1
			titleLabel.Font = Enum.Font.GothamBold
			titleLabel.TextSize = 11
			titleLabel.TextColor3 = Color3.fromRGB(130, 138, 160)
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			titleLabel.Text = "SECTION"
			titleLabel.ZIndex = 65
			titleLabel.Parent = titleBar

			local content = Instance.new("ScrollingFrame")
			content.Name = "Content"
			content.Size = UDim2.new(1, -8, 1, -30)
			content.Position = UDim2.new(0, 4, 0, 28)
			content.BackgroundTransparency = 1
			content.BorderSizePixel = 0
			content.ScrollBarThickness = 2
			content.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 68)
			content.AutomaticCanvasSize = Enum.AutomaticSize.Y
			content.CanvasSize = UDim2.new(0, 0, 0, 0)
			content.ZIndex = 64
			content.Parent = sec

			local layout = Instance.new("UIListLayout")
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Padding = UDim.new(0, 4)
			layout.Parent = content

			local pad = Instance.new("UIPadding")
			pad.PaddingTop = UDim.new(0, 2)
			pad.PaddingBottom = UDim.new(0, 6)
			pad.PaddingLeft = UDim.new(0, 2)
			pad.PaddingRight = UDim.new(0, 2)
			pad.Parent = content

			sections[i] = {
				frame = sec,
				content = content,
				setTitle = function(txt)
					titleLabel.Text = string.upper(txt)
				end
			}
		end
		return sections
	end

	local function createToggle(parent, text, default, callback)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 28)
		row.BackgroundColor3 = Theme.Row
		row.BorderSizePixel = 0
		row.ZIndex = 65
		row.Parent = parent
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
		registerTheme(function() if not row:GetAttribute("Hover") then row.BackgroundColor3 = Theme.Row end end)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -36, 1, 0)
		label.Position = UDim2.new(0, 8, 0, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 11
		label.TextColor3 = Theme.Text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = text
		label.ZIndex = 66
		label.Parent = row

		local box = Instance.new("Frame")
		box.Size = UDim2.new(0, 16, 0, 16)
		box.Position = UDim2.new(1, -22, 0.5, 0)
		box.AnchorPoint = Vector2.new(0, 0.5)
		box.BackgroundColor3 = default and Theme.AccentDark or Theme.CheckOff
		box.BorderSizePixel = 0
		box.ZIndex = 66
		box.Parent = row
		Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

		local tick = Instance.new("TextLabel")
		tick.Size = UDim2.new(1, 0, 1, 0)
		tick.BackgroundTransparency = 1
		tick.Font = Enum.Font.GothamBold
		tick.TextSize = 11
		tick.TextColor3 = Color3.fromRGB(255, 255, 255)
		tick.Text = "✓"
		tick.TextTransparency = default and 0 or 1
		tick.ZIndex = 67
		tick.Parent = box

		local enabled = default or false

		registerTheme(function()
			box.BackgroundColor3 = enabled and Theme.AccentDark or Theme.CheckOff
		end)

		local hit = Instance.new("TextButton")
		hit.Size = UDim2.new(1, 0, 1, 0)
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.ZIndex = 68
		hit.Parent = row

		hit.MouseButton1Click:Connect(function()
			enabled = not enabled
			playSound(SFX.ToggleClick, 0.4, enabled and 1.1 or 0.95)

			if Settings.Animations then
				if enabled then
					TweenService:Create(box, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {BackgroundColor3 = Theme.AccentDark}):Play()
					TweenService:Create(tick, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
				else
					TweenService:Create(box, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {BackgroundColor3 = Theme.CheckOff}):Play()
					TweenService:Create(tick, TweenInfo.new(0.12), {TextTransparency = 1}):Play()
				end
			else
				box.BackgroundColor3 = enabled and Theme.AccentDark or Theme.CheckOff
				tick.TextTransparency = enabled and 0 or 1
			end

			Notify(enabled and "Enabled" or "Disabled", text .. " " .. (enabled and "on" or "off"), 3)
			if callback then callback(enabled) end
		end)

		hit.MouseEnter:Connect(function()
			row:SetAttribute("Hover", true)
			if Settings.Animations then
				TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Theme.RowHover}):Play()
			else
				row.BackgroundColor3 = Theme.RowHover
			end
		end)
		hit.MouseLeave:Connect(function()
			row:SetAttribute("Hover", false)
			if Settings.Animations then
				TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Row}):Play()
			else
				row.BackgroundColor3 = Theme.Row
			end
		end)

		return {
			Get = function() return enabled end,
			Set = function(v)
				enabled = v
				box.BackgroundColor3 = enabled and Theme.AccentDark or Theme.CheckOff
				tick.TextTransparency = enabled and 0 or 1
			end
		}
	end

	local function createSlider(parent, text, min, max, default, callback)
		min, max, default = min or 0, max or 100, default or 50
		local value = default

		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 42)
		row.BackgroundColor3 = Theme.Row
		row.BorderSizePixel = 0
		row.ClipsDescendants = false
		row.ZIndex = 65
		row.Parent = parent
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
		registerTheme(function() row.BackgroundColor3 = Theme.Row end)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -12, 0, 14)
		label.Position = UDim2.new(0, 8, 0, 4)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 11
		label.TextColor3 = Theme.Text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = text
		label.ZIndex = 66
		label.Parent = row

		local particleLayer = Instance.new("Frame")
		particleLayer.Size = UDim2.new(1, 0, 1, 0)
		particleLayer.BackgroundTransparency = 1
		particleLayer.ZIndex = 70
		particleLayer.ClipsDescendants = false
		particleLayer.Parent = row

		local track = Instance.new("Frame")
		track.Name = "Track"
		track.Size = UDim2.new(1, -16, 0, 16)
		track.Position = UDim2.new(0, 8, 0, 20)
		track.BackgroundColor3 = Theme.Track
		track.BorderSizePixel = 0
		track.ClipsDescendants = true
		track.ZIndex = 66
		track.Parent = row
		Instance.new("UICorner", track).CornerRadius = UDim.new(0, 5)
		registerTheme(function() track.BackgroundColor3 = Theme.Track end)

		local fill = Instance.new("Frame")
		fill.Name = "Fill"
		fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
		fill.BackgroundColor3 = Theme.AccentDark
		fill.BorderSizePixel = 0
		fill.ZIndex = 67
		fill.Parent = track
		Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 5)
		registerTheme(function() fill.BackgroundColor3 = Theme.AccentDark end)

		local num = Instance.new("TextLabel")
		num.Name = "Value"
		num.Size = UDim2.new(1, 0, 1, 0)
		num.BackgroundTransparency = 1
		num.Font = Enum.Font.GothamBold
		num.TextSize = 10
		num.TextColor3 = Color3.fromRGB(255, 255, 255)
		num.Text = tostring(math.floor(value))
		num.ZIndex = 68
		num.Parent = track

		local dragging = false
		local lastGlitter = 0

		local function setValue(v, silent)
			value = math.clamp(v, min, max)
			local alpha = (value - min) / (max - min)
			if Settings.Animations then
				TweenService:Create(fill, TweenInfo.new(0.06, Enum.EasingStyle.Quad), {
					Size = UDim2.new(alpha, 0, 1, 0)
				}):Play()
			else
				fill.Size = UDim2.new(alpha, 0, 1, 0)
			end
			num.Text = tostring(math.floor(value + 0.5))
			if not silent and callback then callback(value) end
		end

		local function updateFromInput(input)
			local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
			rel = math.clamp(rel, 0, 1)
			setValue(min + rel * (max - min))

			local now = tick()
			if Settings.Effects and now - lastGlitter > 0.06 then
				lastGlitter = now
				local lx = input.Position.X - row.AbsolutePosition.X
				local ly = track.AbsolutePosition.Y - row.AbsolutePosition.Y + track.AbsoluteSize.Y * 0.5
				spawnSliderGlitter(particleLayer, lx, ly)

				if now - lastSliderSound > 0.08 then
					lastSliderSound = now
					playSound(SFX.SliderTick, 0.18, 0.95 + math.random() * 0.2)
				end
			end
		end

		local hit = Instance.new("TextButton")
		hit.Size = UDim2.new(1, 0, 1, 0)
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.ZIndex = 69
		hit.Parent = track

		hit.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				updateFromInput(input)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				updateFromInput(input)
			end
		end)

		return { Get = function() return value end, Set = setValue }
	end

	local function createButton(parent, text, callback)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 26)
		row.BackgroundColor3 = Theme.Row
		row.BorderSizePixel = 0
		row.ZIndex = 65
		row.Parent = parent
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

		local stroke = Instance.new("UIStroke")
		stroke.Color = Theme.Stroke
		stroke.Thickness = 1
		stroke.Transparency = 0.4
		stroke.Parent = row
		registerTheme(function() stroke.Color = Theme.Stroke end)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 11
		label.TextColor3 = Color3.fromRGB(220, 220, 230)
		label.Text = text
		label.ZIndex = 66
		label.Parent = row

		local hit = Instance.new("TextButton")
		hit.Size = UDim2.new(1, 0, 1, 0)
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.ZIndex = 67
		hit.Parent = row

		hit.MouseButton1Click:Connect(function()
			playSound(SFX.ToggleClick, 0.35, 1)
			if callback then callback() end
			Notify("Action", text .. " clicked", 3)
		end)
		hit.MouseEnter:Connect(function()
			if Settings.Animations then
				TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Theme.RowHover}):Play()
				TweenService:Create(stroke, TweenInfo.new(0.1), {Color = Theme.Accent}):Play()
			else
				row.BackgroundColor3 = Theme.RowHover
				stroke.Color = Theme.Accent
			end
		end)
		hit.MouseLeave:Connect(function()
			if Settings.Animations then
				TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Row}):Play()
				TweenService:Create(stroke, TweenInfo.new(0.1), {Color = Theme.Stroke}):Play()
			else
				row.BackgroundColor3 = Theme.Row
				stroke.Color = Theme.Stroke
			end
		end)
	end

	local function createDropdown(parent, text, options, defaultIndex, callback)
		options = options or {"Option 1", "Option 2", "Option 3"}
		defaultIndex = defaultIndex or 1
		local selected = options[defaultIndex] or options[1]
		local open = false
		local itemH = 26
		local closedH = 28
		local openH = closedH + (#options * itemH) + 4

		local container = Instance.new("Frame")
		container.Size = UDim2.new(1, 0, 0, closedH)
		container.BackgroundColor3 = Theme.Dropdown
		container.BorderSizePixel = 0
		container.ClipsDescendants = true
		container.ZIndex = 65
		container.Parent = parent
		Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
		registerTheme(function() container.BackgroundColor3 = Theme.Dropdown end)

		local stroke = Instance.new("UIStroke")
		stroke.Color = Theme.Stroke
		stroke.Thickness = 1
		stroke.Transparency = 0.35
		stroke.Parent = container
		registerTheme(function() stroke.Color = Theme.Stroke end)

		local headerBtn = Instance.new("TextButton")
		headerBtn.Size = UDim2.new(1, 0, 0, closedH)
		headerBtn.BackgroundTransparency = 1
		headerBtn.Text = ""
		headerBtn.ZIndex = 66
		headerBtn.Parent = container

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -28, 1, 0)
		label.Position = UDim2.new(0, 8, 0, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 11
		label.TextColor3 = Theme.Text
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = text .. ": " .. selected
		label.ZIndex = 67
		label.Parent = headerBtn

		local arrow = Instance.new("TextLabel")
		arrow.Size = UDim2.new(0, 18, 1, 0)
		arrow.Position = UDim2.new(1, -22, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Font = Enum.Font.GothamBold
		arrow.TextSize = 10
		arrow.TextColor3 = Theme.TextDim
		arrow.Text = "▼"
		arrow.ZIndex = 67
		arrow.Parent = headerBtn

		local listFrame = Instance.new("Frame")
		listFrame.Size = UDim2.new(1, -6, 0, #options * itemH)
		listFrame.Position = UDim2.new(0, 3, 0, closedH)
		listFrame.BackgroundTransparency = 1
		listFrame.ZIndex = 66
		listFrame.Parent = container

		local listLayout = Instance.new("UIListLayout")
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Parent = listFrame

		for i, opt in ipairs(options) do
			local item = Instance.new("TextButton")
			item.Size = UDim2.new(1, 0, 0, itemH)
			item.BackgroundColor3 = Theme.DropdownItem
			item.BorderSizePixel = 0
			item.Text = ""
			item.AutoButtonColor = false
			item.ZIndex = 67
			item.Parent = listFrame
			Instance.new("UICorner", item).CornerRadius = UDim.new(0, 4)

			local itemLabel = Instance.new("TextLabel")
			itemLabel.Size = UDim2.new(1, -12, 1, 0)
			itemLabel.Position = UDim2.new(0, 8, 0, 0)
			itemLabel.BackgroundTransparency = 1
			itemLabel.Font = Enum.Font.Gotham
			itemLabel.TextSize = 11
			itemLabel.TextColor3 = Theme.Text
			itemLabel.TextXAlignment = Enum.TextXAlignment.Left
			itemLabel.Text = opt
			itemLabel.ZIndex = 68
			itemLabel.Parent = item

			item.MouseEnter:Connect(function()
				if Settings.Animations then
					TweenService:Create(item, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(38, 38, 48)}):Play()
				else
					item.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
				end
			end)
			item.MouseLeave:Connect(function()
				if Settings.Animations then
					TweenService:Create(item, TweenInfo.new(0.08), {BackgroundColor3 = Theme.DropdownItem}):Play()
				else
					item.BackgroundColor3 = Theme.DropdownItem
				end
			end)

			item.MouseButton1Click:Connect(function()
				playSound(SFX.Dropdown, 0.4, 1.05)
				selected = opt
				label.Text = text .. ": " .. selected
				open = false
				if Settings.Animations then
					TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
						Size = UDim2.new(1, 0, 0, closedH)
					}):Play()
					TweenService:Create(arrow, TweenInfo.new(0.18), {Rotation = 0}):Play()
				else
					container.Size = UDim2.new(1, 0, 0, closedH)
					arrow.Rotation = 0
				end
				Notify("Dropdown", text .. " → " .. selected, 3)
				if callback then callback(selected, i) end
			end)
		end

		headerBtn.MouseButton1Click:Connect(function()
			playSound(SFX.Dropdown, 0.38, open and 0.9 or 1.1)
			open = not open
			local targetH = open and openH or closedH
			if Settings.Animations then
				TweenService:Create(container, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
					Size = UDim2.new(1, 0, 0, targetH)
				}):Play()
				TweenService:Create(arrow, TweenInfo.new(0.2), {
					Rotation = open and 180 or 0
				}):Play()
			else
				container.Size = UDim2.new(1, 0, 0, targetH)
				arrow.Rotation = open and 180 or 0
			end
		end)

		return {
			Get = function() return selected end,
			Set = function(v)
				selected = v
				label.Text = text .. ": " .. selected
			end
		}
	end

	local function setAccentFromColor(c, notifyName)
		local r = math.clamp(c.R * 0.55 + 0.12, 0.08, 0.72)
		local g = math.clamp(c.G * 0.55 + 0.12, 0.08, 0.72)
		local b = math.clamp(c.B * 0.55 + 0.12, 0.08, 0.72)
		Theme.Accent = Color3.new(r, g, b)
		Theme.AccentDark = Color3.new(
			math.clamp(r * 0.78, 0, 1),
			math.clamp(g * 0.78, 0, 1),
			math.clamp(b * 0.78, 0, 1)
		)
		applyTheme()
		playSound(SFX.ColourKnock, 0.45, 1)
		if notifyName then
			Notify("Theme", "Accent tint → " .. notifyName, 3)
		end
	end

	local function createColourButton(parent, name, accentColor)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 26)
		row.BackgroundColor3 = Theme.Row
		row.BorderSizePixel = 0
		row.ZIndex = 65
		row.Parent = parent
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

		local swatch = Instance.new("Frame")
		swatch.Size = UDim2.new(0, 12, 0, 12)
		swatch.Position = UDim2.new(0, 8, 0.5, 0)
		swatch.AnchorPoint = Vector2.new(0, 0.5)
		swatch.BackgroundColor3 = accentColor
		swatch.BorderSizePixel = 0
		swatch.ZIndex = 66
		swatch.Parent = row
		Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 3)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -28, 1, 0)
		label.Position = UDim2.new(0, 26, 0, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 11
		label.TextColor3 = Color3.fromRGB(220, 220, 230)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = name
		label.ZIndex = 66
		label.Parent = row

		local hit = Instance.new("TextButton")
		hit.Size = UDim2.new(1, 0, 1, 0)
		hit.BackgroundTransparency = 1
		hit.Text = ""
		hit.ZIndex = 67
		hit.Parent = row

		hit.MouseButton1Click:Connect(function()
			setAccentFromColor(accentColor, name)
		end)
		hit.MouseEnter:Connect(function()
			if Settings.Animations then
				TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Theme.RowHover}):Play()
			else
				row.BackgroundColor3 = Theme.RowHover
			end
		end)
		hit.MouseLeave:Connect(function()
			if Settings.Animations then
				TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Row}):Play()
			else
				row.BackgroundColor3 = Theme.Row
			end
		end)
	end

	local function createColorPicker(parent)
		local box = Instance.new("Frame")
		box.Size = UDim2.new(1, 0, 0, 148)
		box.BackgroundColor3 = Theme.Row
		box.BorderSizePixel = 0
		box.ZIndex = 65
		box.Parent = parent
		Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -12, 0, 16)
		title.Position = UDim2.new(0, 8, 0, 4)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.GothamBold
		title.TextSize = 10
		title.TextColor3 = Theme.Text
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Text = "Custom RGB (accent tint)"
		title.ZIndex = 66
		title.Parent = box

		local preview = Instance.new("Frame")
		preview.Size = UDim2.new(0, 28, 0, 28)
		preview.Position = UDim2.new(1, -36, 0, 4)
		preview.BackgroundColor3 = Theme.Accent
		preview.BorderSizePixel = 0
		preview.ZIndex = 66
		preview.Parent = box
		Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)
		registerTheme(function() preview.BackgroundColor3 = Theme.Accent end)

		local rVal, gVal, bVal = 90, 100, 120

		local function makeChannel(y, name, initial, onChange)
			local lab = Instance.new("TextLabel")
			lab.Size = UDim2.new(0, 16, 0, 14)
			lab.Position = UDim2.new(0, 8, 0, y)
			lab.BackgroundTransparency = 1
			lab.Font = Enum.Font.GothamMedium
			lab.TextSize = 10
			lab.TextColor3 = Theme.TextDim
			lab.Text = name
			lab.ZIndex = 66
			lab.Parent = box

			local track = Instance.new("Frame")
			track.Size = UDim2.new(1, -70, 0, 12)
			track.Position = UDim2.new(0, 26, 0, y + 1)
			track.BackgroundColor3 = Theme.Track
			track.BorderSizePixel = 0
			track.ZIndex = 66
			track.Parent = box
			Instance.new("UICorner", track).CornerRadius = UDim.new(0, 4)

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(initial / 255, 0, 1, 0)
			fill.BackgroundColor3 = Theme.AccentDark
			fill.BorderSizePixel = 0
			fill.ZIndex = 67
			fill.Parent = track
			Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)
			registerTheme(function() fill.BackgroundColor3 = Theme.AccentDark end)

			local num = Instance.new("TextLabel")
			num.Size = UDim2.new(0, 28, 0, 14)
			num.Position = UDim2.new(1, -34, 0, y)
			num.BackgroundTransparency = 1
			num.Font = Enum.Font.GothamBold
			num.TextSize = 10
			num.TextColor3 = Theme.Text
			num.Text = tostring(initial)
			num.ZIndex = 66
			num.Parent = box

			local dragging = false
			local function setFromX(x)
				local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
				local v = math.floor(rel * 255 + 0.5)
				fill.Size = UDim2.new(rel, 0, 1, 0)
				num.Text = tostring(v)
				onChange(v)
			end

			local hit = Instance.new("TextButton")
			hit.Size = UDim2.new(1, 0, 1, 0)
			hit.BackgroundTransparency = 1
			hit.Text = ""
			hit.ZIndex = 68
			hit.Parent = track

			hit.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					setFromX(input.Position.X)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					setFromX(input.Position.X)
				end
			end)
		end

		makeChannel(28, "R", rVal, function(v) rVal = v end)
		makeChannel(46, "G", gVal, function(v) gVal = v end)
		makeChannel(64, "B", bVal, function(v) bVal = v end)

		local strip = Instance.new("Frame")
		strip.Size = UDim2.new(1, -16, 0, 18)
		strip.Position = UDim2.new(0, 8, 0, 88)
		strip.BackgroundTransparency = 1
		strip.ZIndex = 66
		strip.Parent = box

		local stripLayout = Instance.new("UIListLayout")
		stripLayout.FillDirection = Enum.FillDirection.Horizontal
		stripLayout.Padding = UDim.new(0, 3)
		stripLayout.Parent = strip

		local quick = {
			Color3.fromRGB(220, 70, 70),
			Color3.fromRGB(230, 140, 50),
			Color3.fromRGB(230, 210, 60),
			Color3.fromRGB(70, 200, 100),
			Color3.fromRGB(50, 180, 200),
			Color3.fromRGB(70, 120, 230),
			Color3.fromRGB(160, 80, 220),
			Color3.fromRGB(220, 90, 180),
			Color3.fromRGB(200, 200, 210),
		}
		for _, c in ipairs(quick) do
			local q = Instance.new("TextButton")
			q.Size = UDim2.new(0, 18, 0, 18)
			q.BackgroundColor3 = c
			q.Text = ""
			q.AutoButtonColor = false
			q.ZIndex = 67
			q.Parent = strip
			Instance.new("UICorner", q).CornerRadius = UDim.new(0, 4)
			q.MouseButton1Click:Connect(function()
				rVal = math.floor(c.R * 255 + 0.5)
				gVal = math.floor(c.G * 255 + 0.5)
				bVal = math.floor(c.B * 255 + 0.5)
				setAccentFromColor(c, "Custom")
				preview.BackgroundColor3 = Theme.Accent
			end)
		end

		local applyBtn = Instance.new("TextButton")
		applyBtn.Size = UDim2.new(1, -16, 0, 24)
		applyBtn.Position = UDim2.new(0, 8, 0, 114)
		applyBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 42)
		applyBtn.BorderSizePixel = 0
		applyBtn.Font = Enum.Font.GothamBold
		applyBtn.TextSize = 11
		applyBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
		applyBtn.Text = "Apply custom RGB"
		applyBtn.AutoButtonColor = false
		applyBtn.ZIndex = 66
		applyBtn.Parent = box
		Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6)

		applyBtn.MouseButton1Click:Connect(function()
			local c = Color3.fromRGB(rVal, gVal, bVal)
			setAccentFromColor(c, string.format("RGB %d,%d,%d", rVal, gVal, bVal))
			preview.BackgroundColor3 = Theme.Accent
		end)
		applyBtn.MouseEnter:Connect(function()
			if Settings.Animations then
				TweenService:Create(applyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(42, 46, 58)}):Play()
			else
				applyBtn.BackgroundColor3 = Color3.fromRGB(42, 46, 58)
			end
		end)
		applyBtn.MouseLeave:Connect(function()
			if Settings.Animations then
				TweenService:Create(applyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(32, 34, 42)}):Play()
			else
				applyBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 42)
			end
		end)
	end

	do
		local secs = createGrid(tabPages[1])
		secs[1].setTitle("Ragebot")
		createToggle(secs[1].content, "Enable Ragebot", false)
		createToggle(secs[1].content, "Auto Shoot", false)
		createToggle(secs[1].content, "Auto Scope", false)
		createToggle(secs[1].content, "Force Headshot", false)
		createToggle(secs[1].content, "Ignore Walls", false)
		createSlider(secs[1].content, "Min Damage", 1, 100, 40)
		createSlider(secs[1].content, "Hitchance %", 0, 100, 75)

		secs[2].setTitle("Silent Aim")
		createToggle(secs[2].content, "Enable Silent Aim", false)
		createToggle(secs[2].content, "Silent Head Only", false)
		createToggle(secs[2].content, "Prediction", true)
		createToggle(secs[2].content, "Visible Check", true)
		createSlider(secs[2].content, "Silent FOV", 10, 360, 90)
		createSlider(secs[2].content, "Smoothness", 1, 25, 8)
		createDropdown(secs[2].content, "Hit Part", {"Head", "Torso", "Closest", "Random"}, 1)

		secs[3].setTitle("Legit Bot")
		createToggle(secs[3].content, "Enable Legit Bot", false)
		createToggle(secs[3].content, "Aim Assist", false)
		createToggle(secs[3].content, "Triggerbot", false)
		createToggle(secs[3].content, "Recoil Control", false)
		createSlider(secs[3].content, "Assist Strength", 1, 100, 35)
		createSlider(secs[3].content, "Reaction (ms)", 0, 300, 80)
		createDropdown(secs[3].content, "Style", {"Smooth", "Linear", "Humanized"}, 3)

		secs[4].setTitle("Extras")
		createToggle(secs[4].content, "Resolver", false)
		createToggle(secs[4].content, "Double Tap", false)
		createToggle(secs[4].content, "Closest Point", false)
		createToggle(secs[4].content, "Target Priority", false)
		createToggle(secs[4].content, "Humanize", true)
		createToggle(secs[4].content, "Only When ADS", false)
		createDropdown(secs[4].content, "Target Mode", {"Closest", "Lowest HP", "Highest Threat", "FOV"}, 1)
	end

	do
		local secs = createGrid(tabPages[2])
		secs[1].setTitle("ESP")
		createToggle(secs[1].content, "Enable ESP", true)
		createToggle(secs[1].content, "Box ESP", true)
		createToggle(secs[1].content, "Name ESP", true)
		createToggle(secs[1].content, "Health Bar", true)
		createToggle(secs[1].content, "Distance ESP", false)
		createToggle(secs[1].content, "Skeleton ESP", false)

		secs[2].setTitle("ESP Extra")
		createToggle(secs[2].content, "Weapon ESP", false)
		createToggle(secs[2].content, "Tracer Lines", false)
		createSlider(secs[2].content, "Max Distance", 50, 2500, 1000)
		createDropdown(secs[2].content, "Box Style", {"2D", "3D", "Corner", "Filled"}, 1)
		createToggle(secs[2].content, "Team Check", true)

		secs[3].setTitle("World")
		createToggle(secs[3].content, "Fullbright", false)
		createToggle(secs[3].content, "No Fog", false)
		createToggle(secs[3].content, "Ambient Override", false)
		createToggle(secs[3].content, "Remove Shadows", false)
		createSlider(secs[3].content, "Brightness", 0, 10, 2)

		secs[4].setTitle("World Extra")
		createToggle(secs[4].content, "Map Colour Tint", false)
		createToggle(secs[4].content, "Hide Grass", false)
		createToggle(secs[4].content, "Optimize World", false)
	end

	do
		local secs = createGrid(tabPages[3])
		secs[1].setTitle("Movement")
		createToggle(secs[1].content, "Fly", false)
		createSlider(secs[1].content, "Fly Speed", 16, 200, 50)
		createToggle(secs[1].content, "Speed Boost", false)
		createSlider(secs[1].content, "Walk Speed", 16, 150, 28)

		secs[2].setTitle("Jump / Clip")
		createToggle(secs[2].content, "Infinite Jump", false)
		createSlider(secs[2].content, "Jump Power", 50, 250, 50)
		createToggle(secs[2].content, "No Clip", false)
		createToggle(secs[2].content, "Bunny Hop", false)
		createToggle(secs[2].content, "Air Strafe", false)

		secs[3].setTitle("Actions")
		createButton(secs[3].content, "Reset Character")
		createButton(secs[3].content, "Force Respawn")
		createButton(secs[3].content, "Unlock Camera")

		secs[4].setTitle("Protection")
		createToggle(secs[4].content, "God Mode (UI Example)", false)
		createToggle(secs[4].content, "Anti Fling", false)
	end

	do
		local secs = createGrid(tabPages[4])
		secs[1].setTitle("Projectile")
		createToggle(secs[1].content, "Projectile TP", false)
		createToggle(secs[1].content, "Redirect Projectiles", false)
		createSlider(secs[1].content, "TP Range", 10, 500, 120)
		createToggle(secs[1].content, "Auto Projectile", false)

		secs[2].setTitle("Anti Aim")
		createToggle(secs[2].content, "Enable Anti Aim", false)
		createToggle(secs[2].content, "Upside Down", false)
		createToggle(secs[2].content, "Anti Headshot", false)
		createToggle(secs[2].content, "Spinning", false)
		createSlider(secs[2].content, "Spin Speed", 1, 50, 12)

		secs[3].setTitle("AA Modes")
		createDropdown(secs[3].content, "AA Mode", {"Spin", "Jitter", "Static", "Desync"}, 1)
		createToggle(secs[3].content, "Jitter", false)
		createToggle(secs[3].content, "Desync", false)
		createToggle(secs[3].content, "Fake Pitch", false)

		secs[4].setTitle("Extras")
		createToggle(secs[4].content, "Anti AFK", true)
		createButton(secs[4].content, "Copy Job ID")
		createButton(secs[4].content, "Rejoin Server")
	end

	do
		local secs = createGrid(tabPages[5])

		secs[1].setTitle("Accent Colour")
		createColorPicker(secs[1].content)
		createColourButton(secs[1].content, "Default Dark", Color3.fromRGB(90, 100, 120))
		createColourButton(secs[1].content, "Slate Blue", Color3.fromRGB(85, 110, 150))
		createColourButton(secs[1].content, "Muted Purple", Color3.fromRGB(120, 95, 150))
		createColourButton(secs[1].content, "Dim Crimson", Color3.fromRGB(140, 70, 80))

		secs[2].setTitle("Extra Effects")
		createToggle(secs[2].content, "Snow Effect", true, function(on)
			Settings.Snow = on
			if isOpen then
				if on and Settings.Effects then startSnow() else stopSnow() end
			end
		end)
		createToggle(secs[2].content, "Background Blur", true, function(on)
			Settings.BlurEnabled = on
			if isOpen then setBlur(on) end
		end)
		createSlider(secs[2].content, "Blur Amount", 0, 56, 14, function(v)
			Settings.BlurAmount = v
			if isOpen and Settings.BlurEnabled then
				if Settings.Animations then
					TweenService:Create(Blur, TweenInfo.new(0.2), {Size = v}):Play()
				else
					Blur.Size = v
				end
			end
		end)
		createToggle(secs[2].content, "Ambience Glow", false, function(on)
			Settings.Ambience = on
			updateAmbience()
		end)

		secs[3].setTitle("UI Controls")
		createToggle(secs[3].content, "Effects", true, function(on)
			Settings.Effects = on
			if not on then
				stopSnow()
			elseif isOpen and Settings.Snow then
				startSnow()
			end
			Notify("Effects", on and "Visual effects enabled" or "Visual effects disabled", 3)
		end)
		createToggle(secs[3].content, "Animations", true, function(on)
			Settings.Animations = on
			Notify("Animations", on and "Animations enabled" or "Animations disabled", 3)
		end)
		createToggle(secs[3].content, "Notifications", true, function(on)
			Settings.Notifications = on
			if on then
				Notify("Notifications", "Notifications enabled", 3)
			end
		end)
		createToggle(secs[3].content, "Show Watermark", true, function(on)
			Settings.ShowWatermark = on
		end)
		createToggle(secs[3].content, "Show Keybind List", true, function(on)
			Settings.ShowKeybindList = on
		end)

		secs[4].setTitle("Presets & Info")
		createColourButton(secs[4].content, "Forest", Color3.fromRGB(70, 120, 90))
		createColourButton(secs[4].content, "Amber", Color3.fromRGB(150, 110, 60))
		createColourButton(secs[4].content, "Teal", Color3.fromRGB(60, 120, 130))
		createColourButton(secs[4].content, "Silver", Color3.fromRGB(140, 145, 155))

		local info = Instance.new("TextLabel")
		info.Size = UDim2.new(1, 0, 0, 70)
		info.BackgroundTransparency = 1
		info.Font = Enum.Font.Gotham
		info.TextSize = 10
		info.TextColor3 = Color3.fromRGB(110, 115, 130)
		info.TextXAlignment = Enum.TextXAlignment.Left
		info.TextYAlignment = Enum.TextYAlignment.Top
		info.TextWrapped = true
		info.Text = "Device: " .. getDeviceType() .. "\nPC: RightShift + drag header\nMobile: Open/Close (mid-left)\nUI Example — features non-functional\nSettings above are live."
		info.ZIndex = 66
		info.Parent = secs[4].content
	end

	isOpen = false
	animating = false

	local function updateMobileBtn()
		if MobileToggleBtn then
			MobileToggleBtn.Text = isOpen and "Close" or "Open"
		end
	end

	local function openUI()
		if isOpen or animating then return end
		animating = true
		isOpen = true
		updateMobileBtn()
		setBlur(true)
		if Settings.Effects and Settings.Snow then startSnow() end
		updateAmbience()

		MainFrame.Visible = true
		MainFrame.Size = UDim2.new(0, 20, 0, 20)
		MainFrame.BackgroundTransparency = 1
		mainStroke.Transparency = 1

		if Settings.Animations then
			local tw = TweenService:Create(MainFrame, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, UI_W, 0, UI_H),
				BackgroundTransparency = 0
			})
			TweenService:Create(mainStroke, TweenInfo.new(0.32), {Transparency = 0.2}):Play()
			tw:Play()
			tw.Completed:Connect(function() animating = false end)
		else
			MainFrame.Size = UDim2.new(0, UI_W, 0, UI_H)
			MainFrame.BackgroundTransparency = 0
			mainStroke.Transparency = 0.2
			animating = false
		end
	end

	local function closeUI()
		if not isOpen or animating then return end
		animating = true
		isOpen = false
		updateMobileBtn()
		setBlur(false)
		stopSnow()

		if Settings.Animations then
			local tw = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 16, 0, 16),
				BackgroundTransparency = 1
			})
			TweenService:Create(mainStroke, TweenInfo.new(0.22), {Transparency = 1}):Play()
			tw:Play()
			tw.Completed:Connect(function()
				MainFrame.Visible = false
				animating = false
			end)
		else
			MainFrame.Visible = false
			MainFrame.BackgroundTransparency = 1
			mainStroke.Transparency = 1
			animating = false
		end
	end

	local function toggleUI()
		if isOpen then closeUI() else openUI() end
	end

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.RightShift then
			toggleUI()
		end
	end)

	if ON_MOBILE then
		MobileToggleBtn = Instance.new("TextButton")
		MobileToggleBtn.Name = "MobileOpenClose"
		MobileToggleBtn.Size = UDim2.new(0, 52, 0, 36)
		MobileToggleBtn.Position = UDim2.new(0, 12, 0.5, 0)
		MobileToggleBtn.AnchorPoint = Vector2.new(0, 0.5)
		MobileToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
		MobileToggleBtn.BorderSizePixel = 0
		MobileToggleBtn.Font = Enum.Font.GothamBold
		MobileToggleBtn.TextSize = 12
		MobileToggleBtn.TextColor3 = Color3.fromRGB(220, 225, 235)
		MobileToggleBtn.Text = "Open"
		MobileToggleBtn.AutoButtonColor = false
		MobileToggleBtn.ZIndex = 70
		MobileToggleBtn.Parent = ScreenGui
		Instance.new("UICorner", MobileToggleBtn).CornerRadius = UDim.new(0, 8)

		local mbStroke = Instance.new("UIStroke")
		mbStroke.Color = Theme.Accent
		mbStroke.Thickness = 1.5
		mbStroke.Transparency = 0.25
		mbStroke.Parent = MobileToggleBtn
		registerTheme(function() mbStroke.Color = Theme.Accent end)

		MobileToggleBtn.MouseButton1Click:Connect(function()
			playSound(SFX.ToggleClick, 0.35, 1)
			toggleUI()
			if Settings.Animations then
				TweenService:Create(MobileToggleBtn, TweenInfo.new(0.08), {Size = UDim2.new(0, 48, 0, 32)}):Play()
				task.wait(0.08)
				TweenService:Create(MobileToggleBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Size = UDim2.new(0, 52, 0, 36)}):Play()
			end
		end)
	end

	task.wait(0.12)
	openUI()
	Notify("Welcome", "Aurora.cc loaded • Organised grid UI", 3)
end

playLoading()
