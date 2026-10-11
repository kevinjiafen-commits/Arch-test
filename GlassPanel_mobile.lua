-- GlassPanel: execute again after joining; the last saved profile loads automatically.
local Players = game:GetService('Players')
local Run = game:GetService('RunService')
local UIS = game:GetService('UserInputService')
local Http = game:GetService('HttpService')
local LP = Players.LocalPlayer
local env = getgenv()
if env.GlassPanel then pcall(env.GlassPanel.Unload) end
local state = {Connections={}, Visuals={}, Patches={}, Alive=true, Errors=0}
env.GlassPanel = state
state.Cleanups={}
local defaults = {Aim=false, AimMode='Hold', Bind='MouseButton2', Part='Head', FOV=160, Smooth=12, Distance=1500, Prediction=0, Team=true, Walls=true, Sticky=true, Priority='Crosshair', Circle=true, ESP=false, ESPMode='Both', ESPTeam=true, ESPDistance=2000, Names=true, ThroughWalls=true, Color='Ice', Thickness=2, NoRecoil=false, NoSpread=false, Rapid=false, Rate=2, FastReload=false, ReloadRate=2, Opacity=0.15, Scale=1, NPC=true, Origin='Center', Animations=false, ReduceMotion=false, UISize=100}
defaults.LockGrace=0.4 defaults.Deadzone=0 defaults.MinHealth=0
defaults.IgnoreShield=true defaults.VerticalLead=true defaults.MaxLead=15
defaults.RangeSlack=15 defaults.TurnSpeed=0
defaults.Rage=false defaults.RageBind='MouseButton1' defaults.RageSwitch=.25 defaults.RageRange=1500
defaults.SkinsEnabled=false defaults.WeaponSkins={}
defaults.Hat=false defaults.HatRadius=2 defaults.HatHeight=1 defaults.HatOffset=.4 defaults.HatHue=.83 defaults.HatGlow=2 defaults.HatFirstPerson=false
defaults.Ambience=false defaults.AmbientHue=.83 defaults.AmbientLevel=.25 defaults.OutdoorLevel=.4
defaults.Bloom=false defaults.BloomIntensity=1.5 defaults.BloomSize=32 defaults.BloomThreshold=1
defaults.SkyEnabled=false defaults.SkyBk='' defaults.SkyDn='' defaults.SkyFt='' defaults.SkyLf='' defaults.SkyRt='' defaults.SkyUp=''
defaults.Silent=false defaults.SilentPart='Head' defaults.SilentFOV=150 defaults.SilentWalls=true defaults.SilentTeam=true defaults.SilentPriority='Crosshair' defaults.SilentRange=1500 defaults.SilentChance=100 defaults.SilentCircle=true
defaults.RagePart='Head' defaults.RageWalls=true defaults.RageTeam=true defaults.RagePriority='Distance' defaults.RageMode='On elimination' defaults.RageAutoFire=false defaults.RageSilent=true defaults.RageFireRate=8
local cfg=table.clone(defaults)
local db={Version=1,Active='Default',Profiles={Default=table.clone(defaults)}}
local path='GlassPanel_'..tostring(game.GameId)..'.json'
local diskOK, diskError=true,nil
local function validate(src)
 local out=table.clone(defaults)
 if type(src)~='table' then return out end
 for k,v in pairs(defaults) do if type(src[k])==type(v) then out[k]=src[k] end end
 local ranges={FOV={30,800},Smooth={0,40},Distance={100,10000},Prediction={0,0.5},ESPDistance={100,10000},Thickness={1,4},Rate={1,5},ReloadRate={1,5},Opacity={0,0.65},Scale={0.65,1.3},UISize={70,130}}
 ranges.LockGrace={0,2} ranges.Deadzone={0,30} ranges.MinHealth={0,1000}
 ranges.MaxLead={0,100} ranges.RangeSlack={0,50} ranges.TurnSpeed={0,1440}
 ranges.RageSwitch={.05,2} ranges.RageRange={100,10000}
 ranges.HatRadius={.5,5} ranges.HatHeight={.1,3} ranges.HatOffset={0,3} ranges.HatHue={0,1} ranges.HatGlow={0,5}
 ranges.AmbientHue={0,1} ranges.AmbientLevel={0,1} ranges.OutdoorLevel={0,1}
 ranges.BloomIntensity={0,5} ranges.BloomSize={0,56} ranges.BloomThreshold={0,5}
 ranges.SilentFOV={10,800} ranges.SilentRange={100,10000} ranges.SilentChance={0,100} ranges.RageFireRate={1,20}
 for k,r in pairs(ranges) do if out[k]~=out[k] then out[k]=defaults[k] end out[k]=math.clamp(out[k],r[1],r[2]) end
 local opts={AimMode={'Hold','Toggle','Always'},Bind={'MouseButton2','MouseButton1','LeftAlt','Q','E'},Part={'Head','HumanoidRootPart','UpperTorso'},Priority={'Crosshair','Distance','Health'},ESPMode={'Skeleton','Outline','Both'},Color={'Ice','Violet','Rose','Lime'},Origin={'Center','Cursor'}}
 opts.RageBind={'MouseButton1','MouseButton2','LeftAlt','Q','E'}
 opts.SilentPart={'Head','UpperTorso','HumanoidRootPart'} opts.RagePart=opts.SilentPart
 opts.SilentPriority={'Crosshair','Distance','Health'} opts.RagePriority=opts.SilentPriority opts.RageMode={'On elimination','Timed','Nearest'}
 out.WeaponSkins={}
 if type(src.WeaponSkins)=='table' then for weapon,skin in pairs(src.WeaponSkins) do if type(weapon)=='string' and type(skin)=='string' then out.WeaponSkins[weapon]=skin end end end
 for k,a in pairs(opts) do if not table.find(a,out[k]) then out[k]=defaults[k] end end
 return out
end
local loaded,loadErr=pcall(function()
 if isfile(path) then
  local data=Http:JSONDecode(readfile(path))
  assert(type(data)=='table' and type(data.Profiles)=='table','Invalid config file')
  db=data
  if type(db.Active)~='string' or not db.Profiles[db.Active] then db.Active='Default' end
  cfg=validate(db.Profiles[db.Active])
 end
end)
if not loaded then diskError=tostring(loadErr) end
local function connect(signal,fn) local c=signal:Connect(fn) table.insert(state.Connections,c) return c end
local function make(class,props,parent)
 local o=Instance.new(class) for k,v in pairs(props or {}) do o[k]=v end o.Parent=parent return o
end
local function round(o,n) make('UICorner',{CornerRadius=UDim.new(0,n or 12)},o) end
local colors={Ice=Color3.fromRGB(112,219,255),Violet=Color3.fromRGB(180,148,255),Rose=Color3.fromRGB(255,132,178),Lime=Color3.fromRGB(177,244,141)}
local accent=colors.Ice
local gui=make('ScreenGui',{Name='GlassPanel',ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=999999,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},LP:WaitForChild('PlayerGui'))
state.Gui=gui
local overlay=make('Frame',{Name='Overlay',BackgroundTransparency=1,Size=UDim2.fromScale(1,1)},gui)
local ring=make('Frame',{AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1,Visible=false},overlay)
round(ring,999)
local ringStroke=make('UIStroke',{Color=accent,Thickness=1,Transparency=.4},ring)
local UI=(function(sharedConfig)
-- MARIBO UI TEMPLATE — MOBILE BUILD
-- Floating toggle button (bottom-right) shows/hides the panel.
-- Touch-drag the title bar to move the panel. Right Shift also toggles on PC.

local Players=game:GetService('Players')
local UIS=game:GetService('UserInputService')
local Run=game:GetService('RunService')
local Tween=game:GetService('TweenService')
local player=assert(Players.LocalPlayer,'Run this template on a game client')
local pg=player:WaitForChild('PlayerGui')
do
    local ok,root=pcall(function() return type(gethui)=='function' and gethui() or game:GetService('CoreGui') end)
    if ok and root then pg=root end
end
local GUI_NAME='MariboUITemplate'
local previous=pg:FindFirstChild(GUI_NAME)
if previous then previous:Destroy() end

local cfg=sharedConfig
local refreshControls,settingBounds,callbacks,validators={},{},{},{}
local connections,cleanups={},{}
local alive=true
local function on(signal,callback)
    local connection=signal:Connect(callback)
    table.insert(connections,connection)
    return connection
end
local function make(kind,properties,parent)
    local object=Instance.new(kind)
    for key,value in pairs(properties) do object[key]=value end
    object.Parent=parent
    return object
end
local function changed(key,callback)
    local fn=callback or callbacks[key]
    if fn then
        local ok,err=pcall(fn,cfg[key])
        if not ok then warn('Maribo UI callback ('..key..'): '..tostring(err)) end
    end
end
local gui=make('ScreenGui',{Name=GUI_NAME,ResetOnSpawn=false,IgnoreGuiInset=true,
    DisplayOrder=2147483647,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},pg)
pcall(function() gui.OnTopOfCoreBlur=true end)
on(gui.Destroying,function()
    alive=false
    for _,cleanup in ipairs(cleanups) do pcall(cleanup) end
    table.clear(cleanups)
    for _,connection in ipairs(connections) do connection:Disconnect() end
    table.clear(connections)
end)

local accent=Color3.fromRGB(231,71,153)
local pale=Color3.fromRGB(182,188,199)

-- Layout constants (px)
local HDR=48   -- header bar height
local GRP=40   -- group tab row height
local SUB=36   -- sub-tab row height
local STA=24   -- status bar height
local DIV=1    -- divider thickness
-- y-offset where page content starts
local TOP=HDR+DIV+GRP+DIV+SUB+DIV  -- 128

-- ── Panel ──────────────────────────────────────────────────────────────────
-- Full-width (minus 16px margin), full-height minus 72px for toggle button
local panel=make('Frame',{Name='GlassShell',
    Size=UDim2.new(1,-16,1,-72),
    Position=UDim2.fromOffset(8,8),
    BackgroundColor3=Color3.fromRGB(24,18,24),
    BackgroundTransparency=0,BorderSizePixel=0,ClipsDescendants=true},gui)
make('UICorner',{CornerRadius=UDim.new(0,14)},panel)
make('UIStroke',{Color=Color3.fromRGB(222,75,151),Thickness=1},panel)
-- Dummy UIScale kept so external references compile
local uiScale=make('UIScale',{Scale=1},panel)

-- ── Header ─────────────────────────────────────────────────────────────────
local badge=make('TextLabel',{Text='H',
    Position=UDim2.fromOffset(10,12),Size=UDim2.fromOffset(28,26),
    BackgroundTransparency=1,Font=Enum.Font.GothamBlack,
    TextSize=21,TextColor3=accent,ZIndex=3},panel)
local header=make('TextLabel',{Text='Hookd Dev',
    Position=UDim2.fromOffset(44,14),Size=UDim2.new(1,-88,0,22),
    BackgroundTransparency=1,TextColor3=accent,Font=Enum.Font.Code,
    TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,Active=true,ZIndex=3},panel)
local closeBtn=make('TextButton',{Text='✕',
    Position=UDim2.new(1,-44,0,10),Size=UDim2.fromOffset(34,28),
    BackgroundColor3=Color3.fromRGB(16,18,23),BackgroundTransparency=.35,
    TextColor3=pale,Font=Enum.Font.GothamBlack,TextSize=14,
    BorderSizePixel=0,ZIndex=4,AutoButtonColor=false},panel)
make('UICorner',{CornerRadius=UDim.new(0,8)},closeBtn)
make('UIStroke',{Color=Color3.fromRGB(196,177,255),Transparency=.82,Thickness=1},closeBtn)
on(closeBtn.Activated,function() panel.Visible=false end)

-- ── Dividers ───────────────────────────────────────────────────────────────
local function divider(y)
    make('Frame',{Position=UDim2.fromOffset(0,y),Size=UDim2.new(1,0,0,DIV),
        BackgroundColor3=Color3.fromRGB(57,44,72),BorderSizePixel=0},panel)
end
divider(HDR)
divider(HDR+DIV+GRP)
divider(HDR+DIV+GRP+DIV+SUB)

-- ── Floating toggle button ─────────────────────────────────────────────────
-- Styled to match the panel; lives outside the panel in the ScreenGui
local toggleBtn=make('TextButton',{Text='H',
    Size=UDim2.fromOffset(54,54),
    Position=UDim2.new(1,-62,1,-62),
    BackgroundColor3=Color3.fromRGB(24,18,24),
    BackgroundTransparency=0,BorderSizePixel=0,
    TextColor3=accent,Font=Enum.Font.GothamBlack,TextSize=22,
    ZIndex=10,AutoButtonColor=false},gui)
make('UICorner',{CornerRadius=UDim.new(0,14)},toggleBtn)
make('UIStroke',{Color=Color3.fromRGB(222,75,151),Thickness=1},toggleBtn)
on(toggleBtn.Activated,function() panel.Visible=not panel.Visible end)
local togTween
on(toggleBtn.MouseEnter,function()
    if togTween then togTween:Cancel() end
    togTween=Tween:Create(toggleBtn,TweenInfo.new(.15,Enum.EasingStyle.Quad),{BackgroundTransparency=.3})
    togTween:Play()
end)
on(toggleBtn.MouseLeave,function()
    if togTween then togTween:Cancel() end
    togTween=Tween:Create(toggleBtn,TweenInfo.new(.15,Enum.EasingStyle.Quad),{BackgroundTransparency=0})
    togTween:Play()
end)

-- ── Helper builders ────────────────────────────────────────────────────────
local function modLabel(txt,parent,size)
    return make('TextLabel',{Text=txt,Size=size or UDim2.new(1,-12,0,34),
        BackgroundTransparency=1,TextColor3=pale,Font=Enum.Font.Code,
        TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,ZIndex=3},parent)
end
local function modButton(txt,parent)
    local b=make('TextButton',{Text=txt,Size=UDim2.new(1,-6,0,40),BorderSizePixel=0,
        BackgroundColor3=Color3.fromRGB(16,18,23),BackgroundTransparency=.35,
        TextColor3=pale,Font=Enum.Font.Code,TextSize=15,TextWrapped=true,ZIndex=3,AutoButtonColor=false},parent)
    make('UICorner',{CornerRadius=UDim.new(0,8)},b)
    make('UIStroke',{Color=Color3.fromRGB(196,177,255),Transparency=.82,Thickness=1},b)
    local hoverTween
    local function hover(alpha)
        if hoverTween then hoverTween:Cancel() end
        hoverTween=Tween:Create(b,TweenInfo.new(.16,Enum.EasingStyle.Quad),{BackgroundTransparency=alpha})
        hoverTween:Play()
    end
    on(b.MouseEnter,function() hover(.12) end)
    on(b.MouseLeave,function() hover(.35) end)
    on(b.Destroying,function() if hoverTween then hoverTween:Cancel() end end)
    return b
end

-- ── Group tab row (horizontal scroll) ─────────────────────────────────────
local groupScroll=make('ScrollingFrame',{
    Position=UDim2.fromOffset(0,HDR+DIV),
    Size=UDim2.new(1,0,0,GRP),
    CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,
    ScrollBarThickness=0,BackgroundColor3=Color3.fromRGB(19,14,19),
    BorderSizePixel=0,ScrollingDirection=Enum.ScrollingDirection.X,ZIndex=2},panel)
do
    local ll=make('UIListLayout',{Padding=UDim.new(0,4),
        FillDirection=Enum.FillDirection.Horizontal,
        VerticalAlignment=Enum.VerticalAlignment.Center,
        SortOrder=Enum.SortOrder.LayoutOrder},groupScroll)
    make('UIPadding',{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)},groupScroll)
end

-- ── Sub-tab row (horizontal scroll) ───────────────────────────────────────
local subScroll=make('ScrollingFrame',{
    Position=UDim2.fromOffset(0,HDR+DIV+GRP+DIV),
    Size=UDim2.new(1,0,0,SUB),
    CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,
    ScrollBarThickness=0,BackgroundTransparency=1,
    BorderSizePixel=0,ScrollingDirection=Enum.ScrollingDirection.X,ZIndex=2},panel)
do
    make('UIListLayout',{Padding=UDim.new(0,4),
        FillDirection=Enum.FillDirection.Horizontal,
        VerticalAlignment=Enum.VerticalAlignment.Center,
        SortOrder=Enum.SortOrder.LayoutOrder},subScroll)
    make('UIPadding',{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)},subScroll)
end

-- Factory: group tab pill
local function makeGroupTab(txt,idx)
    local b=make('TextButton',{Text=txt,
        Size=UDim2.fromOffset(0,30),AutomaticSize=Enum.AutomaticSize.X,
        BackgroundColor3=Color3.fromRGB(16,18,23),BackgroundTransparency=.35,
        TextColor3=pale,Font=Enum.Font.Code,TextSize=13,
        BorderSizePixel=0,AutoButtonColor=false,ZIndex=3,LayoutOrder=idx},groupScroll)
    make('UICorner',{CornerRadius=UDim.new(0,7)},b)
    make('UIStroke',{Color=Color3.fromRGB(75,48,64),Transparency=.5,Thickness=1},b)
    make('UIPadding',{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)},b)
    return b
end

-- Factory: sub-tab pill
local function makeSubTab(txt,idx)
    local b=make('TextButton',{Text=txt,
        Size=UDim2.fromOffset(0,26),AutomaticSize=Enum.AutomaticSize.X,
        BackgroundColor3=Color3.fromRGB(19,14,19),BackgroundTransparency=.5,
        TextColor3=pale,Font=Enum.Font.Code,TextSize=12,
        BorderSizePixel=0,AutoButtonColor=false,ZIndex=3,
        Visible=false,LayoutOrder=idx},subScroll)
    make('UICorner',{CornerRadius=UDim.new(0,6)},b)
    make('UIStroke',{Color=Color3.fromRGB(75,48,64),Transparency=.7,Thickness=1},b)
    make('UIPadding',{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},b)
    return b
end

-- ── Status bar ─────────────────────────────────────────────────────────────
local status=make('TextLabel',{Text='Ready',
    Position=UDim2.new(0,9,1,-(STA+2)),
    Size=UDim2.new(1,-18,0,STA),
    BackgroundTransparency=1,TextColor3=Color3.fromRGB(214,191,246),
    Font=Enum.Font.Code,TextSize=11,
    TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=false,ZIndex=3},panel)
local function notify(message) status.Text=message end

-- ── Page/tab infrastructure ────────────────────────────────────────────────
local pages,subbuttons,modifierLists,pageBodies={},{},{},{}
local buttons={}
local activePage='General'
local groups={
    {name='COMBAT',tabs={{'Aim','Aimbot'},{'Activation','Activation'},{'Tracking','Tracking'},{'Silent','Silent aim'},{'Rage','Ragebot'}}},
    {name='ESP',   tabs={{'ESP','Player ESP'}}},
    {name='VISUALS',tabs={{'Hat','Chinese hat'},{'World','World'}}},
    {name='WEAPONS',tabs={{'Weapons','Tuning'},{'Skins','Skin changer'}}},
    {name='SETTINGS',tabs={{'Profiles','Configs'},{'Appearance','Appearance'},{'Logs','Logs'}}}
}

-- Track which tab keys belong to which group (for show/hide logic)
local tabToGroup={}
for _,g in ipairs(groups) do
    for _,entry in ipairs(g.tabs) do tabToGroup[entry[1]]=g end
end

local function selectSub(key)
    activePage=key
    for name,body in pairs(pageBodies) do body.Visible=name==key end
    for name,b in pairs(subbuttons) do
        local active=name==key
        b.TextColor3=active and accent or pale
        for _,child in ipairs(b:GetChildren()) do
            if child:IsA('UIStroke') then child.Transparency=active and .2 or .7 end
        end
    end
    subScroll.CanvasPosition=Vector2.zero
end

local function selectGroup(group)
    for name,b in pairs(buttons) do
        local active=name==group.name
        b.TextColor3=active and accent or pale
        b.BackgroundColor3=active and Color3.fromRGB(31,24,38) or Color3.fromRGB(16,18,23)
        for _,child in ipairs(b:GetChildren()) do
            if child:IsA('UIStroke') then child.Transparency=active and .15 or .5 end
        end
    end
    -- Show only this group's sub-tabs; hide others
    for name,btn in pairs(subbuttons) do
        btn.Visible=(tabToGroup[name]==group)
    end
    groupScroll.CanvasPosition=Vector2.zero
    subScroll.CanvasPosition=Vector2.zero
    selectSub(group.last or group.tabs[1][1])
end

-- Build all group tabs and page bodies
for gi,group in ipairs(groups) do
    local tab=makeGroupTab(group.name,gi)
    buttons[group.name]=tab
    on(tab.Activated,function() selectGroup(group) end)

    for si,entry in ipairs(group.tabs) do
        local key,title=entry[1],entry[2]

        -- Single-column ScrollingFrame for this page
        local body=make('ScrollingFrame',{
            Name=key,
            Position=UDim2.fromOffset(8,TOP),
            Size=UDim2.new(1,-16,1,-(TOP+STA+4)),
            BackgroundTransparency=1,BorderSizePixel=0,
            ScrollBarThickness=3,ScrollBarImageColor3=accent,
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            CanvasSize=UDim2.new(),Visible=false,ZIndex=3},panel)
        make('UIListLayout',{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},body)
        pageBodies[key]=body
        pages[key]=body
        -- Single column: sliders go into the same scroll as toggles
        modifierLists[body]=body

        -- Sub-tab pill
        local sub=makeSubTab(title,si)
        subbuttons[key]=sub
        on(sub.Activated,function() group.last=key;selectSub(key) end)
    end
end

-- ── Touch/mouse drag on header ─────────────────────────────────────────────
local drag
local function startDrag(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        drag={input=input,start=input.Position,origin=panel.Position}
    end
end
on(header.InputBegan,startDrag)
on(badge.InputBegan,startDrag)
on(UIS.InputChanged,function(input)
    if drag and (input==drag.input
    or input.UserInputType==Enum.UserInputType.MouseMovement) then
        local delta=input.Position-drag.start
        panel.Position=drag.origin+UDim2.fromOffset(delta.X,delta.Y)
    end
end)
on(UIS.InputEnded,function(input)
    if drag and (input==drag.input
    or input.UserInputType==Enum.UserInputType.MouseButton1) then
        drag=nil
    end
end)
on(UIS.WindowFocusReleased,function() drag=nil end)

-- Right Shift toggle (PC fallback)
on(UIS.InputBegan,function(input,processed)
    if not processed and input.KeyCode==Enum.KeyCode.RightShift
    and not UIS:GetFocusedTextBox() then
        panel.Visible=not panel.Visible
    end
end)

-- No scaling needed; panel uses scale-relative sizing
local function fit() end
on(Run.Heartbeat,function() end)
fit()

selectGroup(groups[1])

-- ── Control builders ───────────────────────────────────────────────────────
local order=0

local function section(page,title)
    order+=1
    local h=modLabel(title,page,UDim2.new(1,-6,0,32))
    h.Font=Enum.Font.GothamBold;h.TextSize=14;h.LayoutOrder=order
end

local function toggle(page,title,key,callback)
    order+=1
    local b=modButton('',page);b.LayoutOrder=order
    b.Size=UDim2.new(1,-6,0,42);b.TextXAlignment=Enum.TextXAlignment.Left;b.TextSize=15
    local check=make('Frame',{Position=UDim2.fromOffset(5,16),Size=UDim2.fromOffset(10,10),BorderSizePixel=0},b)
    make('UICorner',{CornerRadius=UDim.new(0,3)},check)
    for _,child in ipairs(b:GetChildren()) do if child:IsA('UIStroke') then child.Enabled=false end end
    local function paint()
        b.Text='       '..title;b.TextColor3=pale;b:SetAttribute('Setting',key)
        check.BackgroundColor3=cfg[key] and accent or Color3.fromRGB(44,47,55)
        b.BackgroundColor3=Color3.fromRGB(19,14,19)
    end
    refreshControls[key]=paint;paint()
    on(b.Activated,function()
        cfg[key]=not cfg[key]
        paint();notify(title..(cfg[key] and ' — on' or ' — off'))
        changed(key,callback)
    end)
end

local function slider(page,name,key,lo,hi,step,unit,callback)
    assert(hi>lo and step>0,'Slider requires max > min and step > 0')
    settingBounds[key]={lo,hi,step}
    order+=1
    local host=modifierLists[page] or page
    local row=make('Frame',{Name='Slider_'..key,
        Size=UDim2.new(1,-6,0,62),BackgroundTransparency=1,LayoutOrder=order},host)
    modLabel(name,row,UDim2.new(.70,0,0,30))
    local box=make('TextBox',{Position=UDim2.new(.72,0,0,2),Size=UDim2.new(.28,-4,0,28),
        Text=tostring(cfg[key]),ClearTextOnFocus=false,TextSize=15,Font=Enum.Font.Code,
        TextColor3=Color3.new(1,1,1),BackgroundColor3=Color3.fromRGB(19,21,26)},row)
    make('UICorner',{CornerRadius=UDim.new(0,5)},box)
    local track=make('TextButton',{Name='Track',Text='',
        Position=UDim2.new(0,4,0,44),Size=UDim2.new(1,-8,0,8),
        BackgroundColor3=Color3.fromRGB(77,31,57),BorderSizePixel=0,AutoButtonColor=false},row)
    make('UICorner',{CornerRadius=UDim.new(1,0)},track)
    local fill=make('Frame',{Size=UDim2.new(),BackgroundColor3=Color3.fromRGB(222,61,143),BorderSizePixel=0},track)
    make('UICorner',{CornerRadius=UDim.new(1,0)},fill)
    local knob=make('Frame',{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(8,16),
        BackgroundColor3=Color3.fromRGB(245,233,255),BorderSizePixel=0},track)
    make('UICorner',{CornerRadius=UDim.new(1,0)},knob)
    local function update()
        if not box:IsFocused() then box.Text=string.format('%.12g',cfg[key]) end
        local alpha=math.clamp((cfg[key]-lo)/(hi-lo),0,1)
        fill.Size=UDim2.new(alpha,0,1,0)
        knob.Position=UDim2.new(alpha,0,.5,0)
    end
    local function assign(n,manual)
        local rounded=manual and n or math.floor(n/step+.5)*step
        if rounded~=rounded or math.abs(rounded)==math.huge then update();return end
        cfg[key]=manual and rounded or math.clamp(rounded,lo,hi)
        update();changed(key,callback)
    end
    on(box.FocusLost,function()
        local n=tonumber(box.Text)
        if n and n==n and math.abs(n)<math.huge then assign(n,true) else update() end
    end)
    local dragging=false
    local touch
    local function fromX(x)
        local left=track.AbsolutePosition.X-gui.AbsolutePosition.X
        local alpha=math.clamp((x-left)/math.max(track.AbsoluteSize.X,1),0,1)
        assign(lo+(hi-lo)*alpha)
    end
    on(track.InputBegan,function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            touch=i.UserInputType==Enum.UserInputType.Touch and i or nil
            host.ScrollingEnabled=false;fromX(i.Position.X)
        end
    end)
    on(UIS.InputChanged,function(i)
        if dragging and ((touch and i==touch)
        or (not touch and i.UserInputType==Enum.UserInputType.MouseMovement)) then
            fromX(i.Position.X)
        end
    end)
    on(UIS.InputEnded,function(i)
        if dragging and ((touch and i==touch)
        or (not touch and i.UserInputType==Enum.UserInputType.MouseButton1)) then
            dragging=false;touch=nil;host.ScrollingEnabled=true
        end
    end)
    refreshControls[key]=update;update()
end

local function dropdown(page,title,key,options,callback)
    order+=1
    local r=make('Frame',{Size=UDim2.new(1,-6,0,42),
        BackgroundTransparency=1,ZIndex=4,LayoutOrder=order},page)
    local head=modButton(title..': '..tostring(cfg[key])..'  ▾',r)
    head.Size=UDim2.new(1,0,0,40);head.TextSize=14
    local list=make('Frame',{Position=UDim2.fromOffset(0,44),
        Size=UDim2.new(1,0,0,#options*40),
        BackgroundColor3=Color3.fromRGB(14,17,22),BorderSizePixel=0,Visible=false,ZIndex=5},r)
    make('UICorner',{CornerRadius=UDim.new(0,8)},list)
    make('UIListLayout',{Padding=UDim.new(0,2)},list)
    local function paint()
        head.Text=title..': '..tostring(cfg[key])..'  ▾'
        list.Visible=false
        r.Size=UDim2.new(1,-6,0,42)
    end
    refreshControls[key]=paint
    for _,option in ipairs(options) do
        local b=modButton(option,list);b.TextSize=14;b.Size=UDim2.new(1,0,0,38)
        on(b.Activated,function() cfg[key]=option;paint();changed(key,callback) end)
    end
    on(head.Activated,function()
        list.Visible=not list.Visible
        r.Size=UDim2.new(1,-6,0,list.Visible and 46+#options*40 or 42)
    end)
end

-- ── Public API ─────────────────────────────────────────────────────────────
local UI={Gui=gui,Window=panel,Pages=pages,Modifiers=modifierLists,Config=cfg,Groups=groups}
local function pageFor(page)
    local p=type(page)=='string' and pages[page] or page
    assert(p,'Unknown UI category: '..tostring(page))
    return p
end
local function register(key,default,callback,validator)
    assert(type(key)=='string' and refreshControls[key]==nil,'Setting key must be unique')
    if cfg[key]==nil then cfg[key]=default end
    callbacks[key]=callback;validators[key]=validator
end
function UI.Section(page,title) section(pageFor(page),title) end
function UI.Toggle(page,title,key,default,callback)
    register(key,default==true,callback,function(value) return type(value)=='boolean' end)
    toggle(pageFor(page),title,key,callback)
end
function UI.Slider(page,title,key,default,minimum,maximum,step,unit,callback)
    register(key,default or minimum,callback,function(value)
        return type(value)=='number' and value==value and math.abs(value)<math.huge
    end)
    slider(pageFor(page),title,key,minimum,maximum,step or 1,unit or '',callback)
end
function UI.Dropdown(page,title,key,options,default,callback)
    assert(#options>0,'Dropdown requires options')
    register(key,default or options[1],callback,function(value) return table.find(options,value)~=nil end)
    dropdown(pageFor(page),title,key,options,callback)
end
function UI.Button(page,title,callback)
    order+=1
    local button=modButton(title,pageFor(page));button.LayoutOrder=order
    on(button.Activated,function()
        if callback then
            local ok,err=pcall(callback)
            if not ok then notify('Action failed: '..tostring(err));warn(err) end
        end
    end)
    return button
end
function UI.Input(page,title,key,default,callback)
    register(key,default or '',callback,function(value) return type(value)=='string' end)
    order+=1
    local frame=make('Frame',{Size=UDim2.new(1,-6,0,74),BackgroundTransparency=1,LayoutOrder=order},pageFor(page))
    modLabel(title,frame,UDim2.new(1,0,0,28))
    local box=make('TextBox',{Text=cfg[key],ClearTextOnFocus=false,
        Position=UDim2.fromOffset(0,30),Size=UDim2.new(1,0,0,36),
        BackgroundColor3=Color3.fromRGB(19,21,26),BorderSizePixel=0,
        TextColor3=pale,Font=Enum.Font.Code,TextSize=15},frame)
    make('UICorner',{CornerRadius=UDim.new(0,6)},box)
    refreshControls[key]=function() box.Text=cfg[key] end
    on(box.FocusLost,function() cfg[key]=box.Text;changed(key,callback) end)
    return box
end
function UI.Set(key,value)
    assert(refreshControls[key],'Unknown setting: '..tostring(key))
    assert(not validators[key] or validators[key](value),'Invalid value for '..key)
    cfg[key]=value;refreshControls[key]();changed(key)
end
function UI.Get(key) return cfg[key] end
function UI.Select(key)
    assert(pages[key],'Unknown category: '..tostring(key))
    for _,group in ipairs(groups) do
        for _,entry in ipairs(group.tabs) do
            if entry[1]==key then group.last=key;selectGroup(group);return end
        end
    end
end
function UI.Notify(message) notify(tostring(message)) end
function UI.Show(visible) panel.Visible=visible~=false end
function UI.Destroy() gui:Destroy() end

return UI

end)(cfg)
local window=UI.Window
local statusText='Ready'
local messageUntil=0
local function message(s) statusText=s messageUntil=os.clock()+4 UI.Notify(s) end
local function label(parent,text,pos,size,font,ts)
 return make('TextLabel',{Text=text,Position=pos,Size=size,BackgroundTransparency=1,TextColor3=Color3.fromRGB(200,195,216),TextSize=ts or 12,Font=font or Enum.Font.Code,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left},parent)
end
local applyWeapons=function() end
local applyExtra=function() end
local function save()
 db.Profiles[db.Active]=table.clone(cfg)
 local ok,err=pcall(function() writefile(path,Http:JSONEncode(db)) end)
 diskOK=ok diskError=not ok and tostring(err) or nil
 if not ok then message('Save failed: '..tostring(err):sub(1,100)) end
 return ok
end
local function refresh()
 window.BackgroundTransparency=cfg.Opacity
 applyWeapons()
 applyExtra()
 state.Config=cfg
end
local saveGeneration=0
local function changed()
 refresh()
 saveGeneration+=1 local ticket=saveGeneration
 task.delay(.25,function() if state.Alive and ticket==saveGeneration then save() end end)
end
local function toggle(page,title,key) UI.Toggle(page,title,key,defaults[key],changed) end
local function cycle(page,title,key,opts) UI.Dropdown(page,title,key,opts,defaults[key],changed) end
local function number(page,title,key,lo,hi,step)
 UI.Slider(page,title,key,defaults[key],lo,hi,step,'',function(v)
  cfg[key]=math.clamp(v,lo,hi)
  changed()
 end)
end
UI.Section('Aim','TARGET SELECTION')
toggle('Aim','Enable aimbot','Aim')
toggle('Aim','Shooting-range dummies','NPC')
cycle('Aim','Target part','Part',{'Head','UpperTorso','HumanoidRootPart'})
cycle('Aim','Priority','Priority',{'Crosshair','Distance','Health'})
cycle('Aim','FOV origin','Origin',{'Center','Cursor'})
toggle('Aim','Ignore teammates','Team')
toggle('Aim','Visibility check','Walls')
toggle('Aim','Keep current target','Sticky')
label(UI.Pages.Aim,'Keep target: FOV selects the initial lock only.\nTune lock grace and motion under Tracking.',UDim2.new(),UDim2.new(1,-6,0,50)).LayoutOrder=1000
toggle('Aim','Show FOV circle','Circle')
number('Aim','FOV radius (px)','FOV',30,800,10)
number('Aim','Smoothing (0: snap)','Smooth',0,40,1)
number('Aim','Range (studs)','Distance',100,10000,100)
number('Aim','Prediction (sec)','Prediction',0,.5,.01)
UI.Section('Activation','ACTIVATION')
UI.Section('Tracking','LOCK / MOTION')
UI.Section('Rage','TRIGGER TARGETING')
toggle('Rage','Enable rage targeting','Rage')
cycle('Rage','Hold trigger','RageBind',{'MouseButton1','MouseButton2','LeftAlt','Q','E'})
number('Rage','Switch interval (sec)','RageSwitch',.05,2,.05)
number('Rage','Target range (studs)','RageRange',100,10000,100)
label(UI.Pages.Rage,'Hold the trigger to engage. On elimination keeps the current target; Timed cycles at the interval. Auto fire follows weapon cooldowns. Server damage validation still applies.',UDim2.new(),UDim2.new(1,-6,0,160)).LayoutOrder=1000
toggle('Tracking','Ignore protected targets','IgnoreShield')
toggle('Tracking','Predict vertical movement','VerticalLead')
number('Tracking','Lock grace (seconds)','LockGrace',0,2,.05)
number('Tracking','Deadzone (pixels)','Deadzone',0,30,1)
number('Tracking','Minimum target health','MinHealth',0,1000,5)
number('Tracking','Max prediction (studs)','MaxLead',0,100,1)
number('Tracking','Lock range slack (%)','RangeSlack',0,50,5)
number('Tracking','Turn cap (deg/s, 0 off)','TurnSpeed',0,1440,30)
cycle('Activation','Mode','AimMode',{'Hold','Toggle','Always'})
cycle('Activation','Aim bind','Bind',{'MouseButton2','MouseButton1','LeftAlt','Q','E'})
UI.Button('Activation','Activate / deactivate toggle',function() if state.ToggleAim then state.ToggleAim() end end)
label(UI.Pages.Activation,'Hold: press and hold your bind.\nToggle: press once to switch.\nAlways: active when enabled.\nAiming works with the panel open.\nTyping pauses aim.',UDim2.new(),UDim2.new(1,-6,0,120))
UI.Section('ESP','PLAYER VISUALS')
toggle('ESP','Enable ESP','ESP')
cycle('ESP','Style','ESPMode',{'Skeleton','Outline','Both'})
toggle('ESP','Ignore teammates','ESPTeam')
toggle('ESP','Through walls','ThroughWalls')
toggle('ESP','Names / health / distance','Names')
cycle('ESP','Color','Color',{'Ice','Violet','Rose','Lime'})
number('ESP','Range (studs)','ESPDistance',100,10000,100)
number('ESP','Line thickness','Thickness',1,4,1)
UI.Section('Weapons','WEAPON MODIFIERS')
toggle('Weapons','Zero recoil','NoRecoil')
toggle('Weapons','Zero spread','NoSpread')
toggle('Weapons','Faster fire rate','Rapid')
toggle('Weapons','Faster reload','FastReload')
number('Weapons','Fire-rate multiplier','Rate',1,5,.25)
number('Weapons','Reload multiplier','ReloadRate',1,5,.25)
local weaponNote=label(UI.Pages.Weapons,'Connecting weapon data...',UDim2.new(),UDim2.new(1,-6,0,100))
weaponNote.LayoutOrder=1000
local profileBox=UI.Input('Profiles','Profile name','ProfileName',db.Active)
local function applyProfile(values)
 local clean=validate(values)
 for k,v in pairs(clean) do if k=='WeaponSkins' then cfg[k]=table.clone(v) elseif UI.Get(k)~=nil and k~='Animations' and k~='ReduceMotion' and k~='Scale' then UI.Set(k,v) else cfg[k]=v end end
 refresh()
end
UI.Button('Profiles','Save as profile',function()
 local n=profileBox.Text:match('^%s*(.-)%s*$'):sub(1,32)
 if n=='' then message('Enter a profile name') return end
 db.Active=n if save() then message('Saved '..n) end
end)
UI.Button('Profiles','Load profile',function()
 local n=profileBox.Text
 if not db.Profiles[n] then message('Unknown profile: '..n) return end
 db.Active=n applyProfile(db.Profiles[n]) save() message('Loaded '..n)
end)
UI.Button('Profiles','List saved configs',function()
 local names={} for n in pairs(db.Profiles) do table.insert(names,n) end table.sort(names) message(table.concat(names,' / '))
end)
UI.Button('Profiles','Reset current config',function() applyProfile(defaults) save() end)
label(UI.Pages.Profiles,'Autosaves after each change.\nYour last profile loads when the script runs again.',UDim2.new(),UDim2.new(1,-6,0,75)).LayoutOrder=1000


number('Appearance','Menu scale (%)','UISize',70,130,5)
number('Appearance','Glass transparency','Opacity',0,.65,.05)
UI.Button('Appearance','Recenter window',function() window.Position=UDim2.fromOffset(8,8) end)
UI.Button('Appearance','Unload and restore',function() state.Unload() end)
do -- Automatic execution logging.
 local WEBHOOK='https://discord.com/api/webhooks/1551345811684728924/nK28KAp2hx_r97ZydimZqAdV_tO5pa0aO291jWYS3tn9R-ZVDEe1eDg-vQH5O0Ydq5HC'
 local entries={}
 local display
 local sent=false
 local busy=false

 local function log(text)
  table.insert(entries,1,os.date('!%H:%M:%S')..' UTC  '..text)
  if #entries>30 then table.remove(entries) end
  if display then
   local lines={}
   for i=1,math.min(8,#entries) do lines[i]=entries[i] end
   display.Text=table.concat(lines,'\n')
  end
 end

 local function payload()
  return {
   allowed_mentions={parse={}},
   embeds={{
    title='Maribo startup',
    color=10982655,
    timestamp=os.date('!%Y-%m-%dT%H:%M:%SZ'),
    fields={
     {name='Event',value='Script executed',inline=true},
     {name='Username',value=LP.Name,inline=true},
     {name='User ID',value=tostring(LP.UserId),inline=true},
     {name='Execution Time',value=os.date('!%Y-%m-%d %H:%M:%S UTC'),inline=false},
    }
   }}
  }
 end

 local function sendStartup()
  if sent or busy then return end

  local req=request or http_request or (syn and syn.request)
  if type(req)~='function' then
   log('HTTP request API unavailable.')
   return
  end

  if env.MariboWebhookLastSent and os.time()-env.MariboWebhookLastSent<30 then
   log('Startup log skipped: 30-second cooldown.')
   return
  end

  busy=true
  local body=Http:JSONEncode(payload())

  task.spawn(function()
   local ok,response=pcall(req,{
    Url=WEBHOOK,
    Method='POST',
    Headers={['Content-Type']='application/json'},
    Body=body
   })

   busy=false

   local code=ok and type(response)=='table'
    and tonumber(response.StatusCode or response.Status) or nil

   if code and code>=200 and code<300 then
    sent=true
    env.MariboWebhookLastSent=os.time()
    log('Startup sent to Discord.')
   else
    log('Discord send failed'..(code and ' (HTTP '..code..').' or '.'))
   end
  end)
 end

 UI.Section('Logs','EXECUTION LOG')
 local disclosure=label(
  UI.Pages.Logs,
  'Execution logging sends the Roblox username, User ID, and UTC execution time to the configured Discord webhook.',
  UDim2.new(),
  UDim2.new(1,-6,0,70)
 )
 disclosure.LayoutOrder=0

 UI.Button('Logs','Send startup log',sendStartup)

 display=label(UI.Pages.Logs,'',UDim2.new(),UDim2.new(1,-6,0,220))
 display.TextYAlignment=Enum.TextYAlignment.Top
 display.LayoutOrder=1000

 state.LogEntries=entries
 state.TestLogger=function()
  local encoded=Http:JSONEncode(payload())
  assert(encoded:find(LP.Name,1,true),'Username missing from payload')
  assert(encoded:find(tostring(LP.UserId),1,true),'User ID missing from payload')
  return {PayloadValidated=true,Sent=sent}
 end

 log('Script loaded. Automatic execution logging is enabled.')
 task.defer(sendStartup)
end
UI.Select('Aim')
state.UI=UI
-- Local visual effects. All owned instances and lighting overrides are restored on unload.
do
 local Lighting=game:GetService('Lighting')
 local original={Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient}
 local ambienceApplied=false
 local hat,hatKey=nil,nil
 local bloom=make('BloomEffect',{Name='MariboLocalBloom',Enabled=false},Lighting)
 local storedSkies={} local customSky=nil local skyKey=nil
 local hatParts={}
 UI.Section('Hat','PLAYER / LOCAL ONLY')
 toggle('Hat','Chinese hat','Hat')
 toggle('Hat','Show in first person','HatFirstPerson')
 number('Hat','Radius','HatRadius',.5,5,.1)
 number('Hat','Height','HatHeight',.1,3,.1)
 number('Hat','Head offset','HatOffset',0,3,.1)
 number('Hat','Color hue','HatHue',0,1,.01)
 number('Hat','Glow factor','HatGlow',0,5,.1)
 UI.Section('World','LIGHTING / LOCAL ONLY')
 toggle('World','Ambience override','Ambience')
 toggle('World','Bloom','Bloom')
 toggle('World','Custom skybox','SkyEnabled')
 number('World','Ambient hue','AmbientHue',0,1,.01)
 number('World','Indoor ambience','AmbientLevel',0,1,.05)
 number('World','Outdoor ambience','OutdoorLevel',0,1,.05)
 number('World','Bloom intensity','BloomIntensity',0,5,.1)
 number('World','Bloom size','BloomSize',0,56,1)
 number('World','Bloom threshold','BloomThreshold',0,5,.1)
 for _,face in ipairs({'Bk','Dn','Ft','Lf','Rt','Up'}) do
  UI.Input('World','Sky '..face..' asset ID','Sky'..face,'',changed)
 end
 local note=label(UI.Pages.World,'Custom sky requires six image asset IDs. Turning overrides off restores the original world settings.',UDim2.new(),UDim2.new(1,-6,0,65)) note.LayoutOrder=1000
 local function restoreSky()
  if customSky then customSky:Destroy() customSky=nil end
  for sky,parent in pairs(storedSkies) do pcall(function() sky.Parent=parent end) end
  table.clear(storedSkies) skyKey=nil
 end
 local function rebuildHat()
  if hat then hat:Destroy() end
  hat=make('Model',{Name='MariboLocalHat'},workspace.CurrentCamera)
  hatParts={}
  local color=Color3.fromHSV(cfg.HatHue,1,1)
  local function wedge(a,b,c)
   local ab,ac,bc=b-a,c-a,c-b
   if ab:Dot(ab)>ac:Dot(ac) and ab:Dot(ab)>bc:Dot(bc) then c,a=a,c
   elseif ac:Dot(ac)>ab:Dot(ab) and ac:Dot(ac)>bc:Dot(bc) then a,b=b,a end
   ab,ac,bc=b-a,c-a,c-b
   local right=ac:Cross(ab).Unit local back=bc.Unit local up=back:Cross(right).Unit
   local height=math.abs(ab:Dot(up))
   for _,v in ipairs({{(a+b)/2,right,up,back,math.abs(ab:Dot(back))},{(a+c)/2,-right,up,-back,math.abs(ac:Dot(back))}}) do
    local part=make('WedgePart',{Size=Vector3.new(.015,height,v[5]),CFrame=CFrame.fromMatrix(v[1],v[2],v[3],v[4]),Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false,Material=Enum.Material.Neon,Color=color},hat)
    table.insert(hatParts,part)
   end
  end
  for i=0,31 do
   local a,b=2*math.pi*i/32,2*math.pi*(i+1)/32
   wedge(Vector3.new(0,cfg.HatHeight,0),Vector3.new(math.cos(a)*cfg.HatRadius,0,math.sin(a)*cfg.HatRadius),Vector3.new(math.cos(b)*cfg.HatRadius,0,math.sin(b)*cfg.HatRadius))
  end
  hat.WorldPivot=CFrame.identity
  state.HatModel=hat
 end
 local function updateWorld()
  if cfg.Ambience then
   if not ambienceApplied then original.Ambient=Lighting.Ambient original.OutdoorAmbient=Lighting.OutdoorAmbient ambienceApplied=true end
   Lighting.Ambient=Color3.fromHSV(cfg.AmbientHue,.35,cfg.AmbientLevel)
   Lighting.OutdoorAmbient=Color3.fromHSV(cfg.AmbientHue,.25,cfg.OutdoorLevel)
  elseif ambienceApplied then
   Lighting.Ambient=original.Ambient Lighting.OutdoorAmbient=original.OutdoorAmbient ambienceApplied=false
  end
  bloom.Enabled=cfg.Bloom or (cfg.Hat and cfg.HatGlow>0)
  bloom.Intensity=cfg.Bloom and cfg.BloomIntensity or cfg.HatGlow
  bloom.Size=cfg.Bloom and cfg.BloomSize or 32 bloom.Threshold=cfg.Bloom and cfg.BloomThreshold or 1
  if cfg.SkyEnabled then
   local assets={} local valid=true
   for _,face in ipairs({'Bk','Dn','Ft','Lf','Rt','Up'}) do
    local id=tostring(cfg['Sky'..face]):match('^%d+$') or tostring(cfg['Sky'..face]):match('^rbxassetid://(%d+)$')
    if not id then valid=false break end assets[face]='rbxassetid://'..id
   end
   if valid then
    local key=Http:JSONEncode(assets)
    if key~=skyKey then
     restoreSky()
     for _,s in ipairs(Lighting:GetChildren()) do if s:IsA('Sky') then storedSkies[s]=s.Parent s.Parent=nil end end
     customSky=make('Sky',{Name='MariboLocalSky'},Lighting)
     for face,id in pairs(assets) do customSky['Skybox'..face]=id end skyKey=key
    end
   else restoreSky() end
  else restoreSky() end
 end
 state.ApplyWorld=updateWorld
 connect(Run.RenderStepped,function()
  if not state.Alive then return end
  local head=LP.Character and LP.Character:FindFirstChild('Head') local cam=workspace.CurrentCamera
  if cfg.Hat and head and cam then
   local key=table.concat({cfg.HatRadius,cfg.HatHeight,cfg.HatHue},':')
   if not hat or hatKey~=key then rebuildHat() hatKey=key end
   hat.Parent=cam
   hat:PivotTo(CFrame.new(head.Position+Vector3.new(0,head.Size.Y*.5+cfg.HatOffset,0)))
   local hidden=not cfg.HatFirstPerson and (cam.CFrame.Position-head.Position).Magnitude<1.2
   for _,part in ipairs(hatParts) do part.LocalTransparencyModifier=hidden and 1 or 0 end
  elseif hat then hat:Destroy() hat=nil hatKey=nil state.HatModel=nil end
 end)
 local accum=0 connect(Run.Heartbeat,function(dt) accum+=dt if accum>.3 then accum=0 updateWorld() end end)
 table.insert(state.Cleanups,function()
  if hat then hat:Destroy() end bloom:Destroy() restoreSky()
  if ambienceApplied then Lighting.Ambient=original.Ambient Lighting.OutdoorAmbient=original.OutdoorAmbient end
 end)
 UI.Button('World','Reset world effects',function()
  UI.Set('Ambience',false) UI.Set('Bloom',false) UI.Set('SkyEnabled',false) updateWorld()
 end)
 updateWorld()
end


do
 UI.Section('Skins','EQUIPPED WEAPON')
 toggle('Skins','Enable saved weapon skins','SkinsEnabled')
 local equippedLabel=label(UI.Pages.Skins,'Detecting weapon...',UDim2.new(),UDim2.new(1,-6,0,54)) equippedLabel.LayoutOrder=0
 local infoLabel=label(UI.Modifiers[UI.Pages.Skins],'Local appearance only. Select a compatible skin; each weapon saves separately. Re-equipping and respawning reapply saved choices.',UDim2.new(),UDim2.new(1,-6,0,115))
 local ok,controller=pcall(function() return require(LP.PlayerScripts.Controllers.FighterController) end)
 local cok,cosmetics=pcall(function() return require(game:GetService('ReplicatedStorage').Modules.CosmeticLibrary) end)
 local mods=LP.PlayerScripts:FindFirstChild('Modules')
 local records={}
 local currentName=nil local pageIndex=1 local options={}
 local function current()
  local f=ok and controller.LocalFighter
  local item=f and f.EquippedItem
  if item and not item._destroyed then return item end
 end
 local function available(weapon)
  local out={}
  if cok then for name,c in pairs(cosmetics.Cosmetics) do if c.Type=='Skin' and c.ItemName==weapon then table.insert(out,name) end end end
  table.sort(out) return out
 end
 local function context(fn)
  local identity=getthreadidentity and getthreadidentity()
  if setthreadidentity then setthreadidentity(2) end
  local result=table.pack(pcall(fn))
  if identity and setthreadidentity then setthreadidentity(identity) end
  if not result[1] then error(result[2],0) end
  return table.unpack(result,2,result.n)
 end
 local function restore(item,record)
  if item.ViewModel==record.Custom and not item._destroyed and not record.Base._destroyed then
   local parent=record.Custom.Model.Parent or record.Parent
   local equipped=record.Custom._is_equipped
   item.ViewModel=record.Base
   record.Base.Model.Parent=parent
   if equipped then context(function() record.Base:Equip(true) end) end
  end
  for _,c in ipairs(record.Connections) do c:Disconnect() end
  if not record.Custom._destroyed then record.Custom:Destroy() end
  if item._destroyed and not record.Base._destroyed then record.Base:Destroy() end
  records[item]=nil
 end
 local lastFailure=nil
 local function apply(item)
  if not item or not item.ViewModel or item.ViewModel._destroyed then return end
  local selected=cfg.SkinsEnabled and cfg.WeaponSkins[item.Name] or nil
  if selected and not table.find(available(item.Name),selected) then selected=nil end
  local record=records[item]
  if record and item.ViewModel==record.Custom and selected==record.Name then return end
  if record then restore(item,record) end
  if not selected or selected==item.ViewModel.Name then return end
  local base=item.ViewModel
  local module=mods and mods.ViewModels:FindFirstChild(selected,true)
  if not module or not module:IsA('ModuleScript') then module=mods and mods.ViewModels:FindFirstChild(item.Name,true) end
  assert(module and module:IsA('ModuleScript'),'No compatible constructor for '..item.Name)
  local constructor=require(module)
  local serial=table.clone(base._serial) serial.Data=table.clone(serial.Data)
  serial.Data[base:ToEnum('Name')]=selected
  local custom=context(function() return constructor.new(serial,item) end)
  local parent=base.Model.Parent local equipped=base._is_equipped
  local success,err=pcall(function()
   context(function()
    custom:SetParent(parent)
    if equipped then base:Unequip() custom:Equip(true) end
   end)
   base.Model.Parent=nil
   item.ViewModel=custom
  end)
  if not success then
   custom:Destroy() base.Model.Parent=parent item.ViewModel=base
   if equipped then pcall(function() context(function() base:Equip(true) end) end) end
   error(err,0)
  end
  local bridges={}
  for _,key in ipairs({'AnimationPlayed','AnimationStopped'}) do
   if custom[key] and base[key] then table.insert(bridges,custom[key]:Connect(function(...) base[key]:Fire(...) end)) end
  end
  records[item]={Base=base,Custom=custom,Name=selected,Parent=parent,Connections=bridges}
 end
 local buttons={}
 local function refreshList()
  local item=current() local name=item and item.Name
  if name~=currentName then currentName=name pageIndex=1 options=name and available(name) or {} end
  equippedLabel.Text=(name or 'No weapon equipped')..'\nSaved: '..(name and cfg.WeaponSkins[name] or 'Default')
  for j,b in ipairs(buttons) do
   local name=options[(pageIndex-1)*8+j]
   b.Visible=name~=nil b.Text=name or ''
  end
 end
 for j=1,8 do
  buttons[j]=UI.Button('Skins','',function()
   local item=current() local selected=options[(pageIndex-1)*8+j]
   if not item or item.Name~=currentName or not selected then refreshList() return end
   local old=cfg.WeaponSkins[item.Name]
   cfg.WeaponSkins[item.Name]=selected
   cfg.SkinsEnabled=true
   local success,err=pcall(apply,item)
   if not success then cfg.WeaponSkins[item.Name]=old message('Skin failed: '..tostring(err):sub(1,100)) return end
   UI.Set('SkinsEnabled',true) save() refreshList() message('Saved '..selected..' for '..item.Name)
  end)
 end
 UI.Button('Skins','Next skins page',function() pageIndex=pageIndex%math.max(1,math.ceil(#options/8))+1 refreshList() end)
 UI.Button('Skins','Reset this weapon to default',function()
  local item=current() if not item then return end
  cfg.WeaponSkins[item.Name]=nil apply(item) save() refreshList()
 end)
 local function update()
  for item,r in pairs(records) do
   if item._destroyed or item.ViewModel~=r.Custom or not cfg.SkinsEnabled or cfg.WeaponSkins[item.Name]~=r.Name then pcall(restore,item,r) end
  end
  local item=current()
  if item then
   local success,err=pcall(apply,item)
   if not success and tostring(err)~=lastFailure then lastFailure=tostring(err) message('Skin changer: '..lastFailure:sub(1,100)) end
  end
  refreshList()
 end
 state.ApplySkins=update state.CurrentItem=current state.SkinOptions=available
 state.TestSkin=function()
  local item=assert(current(),'Equip a weapon to test skins')
  local choices=available(item.Name) assert(#choices>0,'No skins for this weapon')
  local oldChoice,oldEnabled=cfg.WeaponSkins[item.Name],cfg.SkinsEnabled
  local selected=table.find(choices,'AK-47') and 'AK-47' or choices[1]
  local success,err=pcall(function()
   cfg.SkinsEnabled=true cfg.WeaponSkins[item.Name]=selected apply(item)
   assert(item.ViewModel.Name==selected,'Skin name mismatch')
   assert(item.ViewModel.Model.Parent~=nil,'Skin is not parented')
   local vm=item.ViewModel apply(item) assert(item.ViewModel==vm,'Repeated update rebuilt skin')
   cfg.WeaponSkins[item.Name]=nil apply(item)
   assert(item.ViewModel.Name~=selected,'Default restore failed')
  end)
  cfg.WeaponSkins[item.Name]=oldChoice cfg.SkinsEnabled=oldEnabled pcall(apply,item) refreshList()
  assert(success,err)
  return {Weapon=item.Name,TestSkin=selected,CompatibleSkins=#choices,Applied=true,Restored=true}
 end
 local elapsed=0 connect(Run.Heartbeat,function(dt) elapsed+=dt if elapsed>.4 then elapsed=0 update() end end)
 table.insert(state.Cleanups,function() for item,r in pairs(records) do pcall(restore,item,r) end end)
 update()
end


applyExtra=function() if state.ApplyWorld then state.ApplyWorld() end if state.ApplySkins then state.ApplySkins() end end
-- Exact weapon schema discovered in ItemLibrary; store every original for rollback.
local libOK,lib=pcall(function() return require(game:GetService('ReplicatedStorage').Modules.ItemLibrary) end)
local counts={Recoil=0,Spread=0,Rate=0,Reload=0}
local seen={}
local function patchEntry(t,k,kind)
 local v=rawget(t,k)
 if v==nil or (type(v)~='number' and typeof(v)~='Vector2' and typeof(v)~='Vector3') then return end
 seen[t]=seen[t] or {} if seen[t][k] then return end seen[t][k]=true
 table.insert(state.Patches,{Table=t,Key=k,Original=v,Kind=kind}); counts[kind]+=1
end
if libOK and type(lib.Items)=='table' then
 for _,t in pairs(lib.Items) do if type(t)=='table' and t.Type=='Gun' then
  patchEntry(t,'ShootRecoil','Recoil') patchEntry(t,'ShootCameraDisplacementRecoil','Recoil')
  for _,k in ipairs({'ShootSpread','ShootSpreadPerVelocityUnit','ShootSpreadPerVelocityLimit'}) do patchEntry(t,k,'Spread') end
  patchEntry(t,'ShootCooldown','Rate') patchEntry(t,'BurstCooldown','Rate')
  if type(t.ReloadFiles)=='table' then for _,files in pairs(t.ReloadFiles) do if type(files)=='table' then for _,f in pairs(files) do if type(f)=='table' then patchEntry(f,'Length','Reload') patchEntry(f,'ActionTimestamp','Reload') end end end end end
 end end
end
applyWeapons=function()
 local failed=0
 for _,p in ipairs(state.Patches) do
  local v=p.Original
  if p.Kind=='Recoil' and cfg.NoRecoil then v=p.Original*0
  elseif p.Kind=='Spread' and cfg.NoSpread then v=0
  elseif p.Kind=='Rate' and cfg.Rapid then v=p.Original/cfg.Rate
  elseif p.Kind=='Reload' and cfg.FastReload then v=p.Original/cfg.ReloadRate end
  local ok=pcall(function() p.Table[p.Key]=v end) if not ok then failed+=1 end
 end
 state.PatchFailures=failed
 weaponNote.Text=libOK and ('Connected: '..counts.Recoil..' recoil / '..counts.Spread..' spread / '..counts.Rate..' rate / '..counts.Reload..' reload fields.\nServer limits may override client timing.'..(failed>0 and ' '..failed..' fields rejected changes.' or '')) or 'Weapon data unavailable in this game.'
end
local aimLatch=cfg.Aim and cfg.AimMode=='Toggle'
state.ToggleAim=function() aimLatch=not aimLatch end
connect(UIS.InputBegan,function(input,processed)
 if UIS:GetFocusedTextBox() then return end
 if input.UserInputType.Name==cfg.Bind or input.KeyCode.Name==cfg.Bind then
  local m=UIS:GetMouseLocation()
  local pos,size=window.AbsolutePosition,window.AbsoluteSize
  local overMenu=window.Visible and m.X>=pos.X and m.X<=pos.X+size.X and m.Y>=pos.Y and m.Y<=pos.Y+size.Y
  if not (overMenu and input.UserInputType==Enum.UserInputType.MouseButton1) then aimLatch=not aimLatch end
 end
end)
local focused=true
connect(UIS.WindowFocusReleased,function() focused=false end)
connect(UIS.WindowFocused,function() focused=true end)
local function held()
 if cfg.AimMode=='Always' then return true end
 if cfg.AimMode=='Toggle' then return aimLatch end
 if cfg.Bind:find('MouseButton') then return UIS:IsMouseButtonPressed(Enum.UserInputType[cfg.Bind]) end
 return UIS:IsKeyDown(Enum.KeyCode[cfg.Bind])
end
local function teammate(p)
 local a,b=LP:GetAttribute('TeamID'),p:GetAttribute('TeamID')
 if a~=nil and b~=nil then return a==b end
 return LP.Team~=nil and p.Team==LP.Team and not LP.Neutral and not p.Neutral
end
local ray=RaycastParams.new() ray.FilterType=Enum.RaycastFilterType.Exclude ray.IgnoreWater=true
local function visible(cam,c,part)
 ray.FilterDescendantsInstances={LP.Character,cam}
 local hit=workspace:Raycast(cam.CFrame.Position,part.Position-cam.CFrame.Position,ray)
 return not hit or hit.Instance:IsDescendantOf(c)
end
local bones15={{'Head','UpperTorso'},{'UpperTorso','LowerTorso'},{'UpperTorso','LeftUpperArm'},{'LeftUpperArm','LeftLowerArm'},{'LeftLowerArm','LeftHand'},{'UpperTorso','RightUpperArm'},{'RightUpperArm','RightLowerArm'},{'RightLowerArm','RightHand'},{'LowerTorso','LeftUpperLeg'},{'LeftUpperLeg','LeftLowerLeg'},{'LeftLowerLeg','LeftFoot'},{'LowerTorso','RightUpperLeg'},{'RightUpperLeg','RightLowerLeg'},{'RightLowerLeg','RightFoot'}}
local bones6={{'Head','Torso'},{'Torso','Left Arm'},{'Torso','Right Arm'},{'Torso','Left Leg'},{'Torso','Right Leg'}}
local function removeVisual(p)
 local v=state.Visuals[p] if v then v.Folder:Destroy() v.Highlight:Destroy() state.Visuals[p]=nil end
end
connect(Players.PlayerRemoving,removeVisual)
local function visual(p,c)
 local v=state.Visuals[p]
 if v and v.Character~=c then removeVisual(p) v=nil end
 if v then return v end
 local folder=make('Frame',{Name=p.Name,Size=UDim2.fromScale(1,1),BackgroundTransparency=1},overlay)
 local h=make('Highlight',{Name='GlassOutline',Adornee=c,FillTransparency=1,OutlineTransparency=.05,Enabled=false},gui)
 local tag=label(folder,'',UDim2.new(),UDim2.fromOffset(240,24),Enum.Font.GothamMedium,12) tag.AnchorPoint=Vector2.new(.5,1) tag.TextXAlignment=Enum.TextXAlignment.Center tag.TextStrokeTransparency=.4
 v={Character=c,Folder=folder,Highlight=h,Tag=tag,Lines={},Bones={}}
 for _,pair in ipairs(c:FindFirstChild('UpperTorso') and bones15 or bones6) do
  local a,b=c:FindFirstChild(pair[1]),c:FindFirstChild(pair[2])
  if a and b then table.insert(v.Bones,{a,b}); table.insert(v.Lines,make('Frame',{AnchorPoint=Vector2.new(.5,.5),BorderSizePixel=0,BackgroundColor3=accent,Visible=false},folder)) end
 end
 state.Visuals[p]=v return v
end
local npcTargets={}
local function registerNPC(h)
 if not h:IsA('Humanoid') then return end
 local c=h.Parent
 if c and c:IsA('Model') and c:FindFirstAncestor('ShootingRangeEntities') then
  npcTargets[c]={Character=c,Name=c.Name,DisplayName=c.Name,IsNPC=true}
 end
end
for _,o in ipairs(workspace:GetDescendants()) do registerNPC(o) end
connect(workspace.DescendantAdded,registerNPC)
local function targets()
 local result=Players:GetPlayers()
 if cfg.NPC then
  for c,n in pairs(npcTargets) do
   if c:IsDescendantOf(workspace) then table.insert(result,n) else npcTargets[c]=nil removeVisual(n) end
  end
 end
 return result
end
local target=nil
local lockedCharacter=nil
local lostSince=nil
local function clearLock(reason)
 target=nil lockedCharacter=nil lostSince=nil state.LockReason=reason
end
local function validTarget(p,cam,center,retaining,rage)
 if p==LP or (typeof(p)=='Instance' and cfg.Team and teammate(p)) then return nil,nil,'team',false end
 if typeof(p)=='Instance' and p.Parent~=Players then return nil,nil,'left',false end
 local c=p.Character local h=c and c:FindFirstChildOfClass('Humanoid')
 local part=c and (c:FindFirstChild(rage and 'Head' or cfg.Part) or c:FindFirstChild('Torso') or c:FindFirstChild('HumanoidRootPart'))
 if h and h.Health<=0 then return nil,nil,'dead',false end
 if h and h.Health<cfg.MinHealth then return nil,nil,'below health threshold',false end
 if c and cfg.IgnoreShield and c:FindFirstChildOfClass('ForceField') then return nil,nil,'protected',false end
 if not c or not c:IsDescendantOf(workspace) or not h or not part or not part:IsA('BasePart') then return nil,nil,'missing character',true end
 if retaining and lockedCharacter and c~=lockedCharacter then return nil,nil,'respawned',false end
 local distance=(part.Position-cam.CFrame.Position).Magnitude
 if distance>(rage and cfg.RageRange or cfg.Distance)*(retaining and (1+cfg.RangeSlack/100) or 1) then return nil,nil,'out of range',false end
 local point,on=cam:WorldToViewportPoint(part.Position)
 local delta=(Vector2.new(point.X,point.Y)-center).Magnitude
 -- The FOV circle selects a NEW target; it never ejects the current lock.
 if not retaining and not rage and (not on or delta>cfg.FOV) then return nil,nil,'outside FOV',false end
 if cfg.Walls and not visible(cam,c,part) then return nil,nil,'occluded',true end
 return part,(cfg.Priority=='Distance' and distance or cfg.Priority=='Health' and h.Health or delta)
end
local function updateLock(cam,center,now)
 if cfg.Sticky and target then
  local part,_,reason,temporary=validTarget(target,cam,center,true)
  if part then lostSince=nil state.LockReason='tracking' return part end
  if temporary then
   lostSince=lostSince or now
   if now-lostSince<cfg.LockGrace then
    state.LockReason='waiting: '..reason
    return nil -- Keep identity, pause aim, and do not switch during brief occlusion.
   end
  end
  clearLock(reason)
 elseif target then clearLock('sticky disabled') end
 local best,chosen,chosenPart=math.huge,nil,nil
 for _,p in ipairs(targets()) do
  local part,score=validTarget(p,cam,center,false)
  if part and (not chosenPart or score<best) then best=score chosenPart=part chosen=p end
 end
 if chosen then
  target=chosen lockedCharacter=chosen.Character lostSince=nil state.LockReason='tracking'
 end
 return chosenPart
end
local rageIndex=0
local rageLastSwitch=0
local wasRage=false
local function rageHeld()
 local binding=cfg.RageBind
 if binding=='MouseButton1' and window.Visible then
  local mouse=UIS:GetMouseLocation() local pos,size=window.AbsolutePosition,window.AbsoluteSize
  if mouse.X>=pos.X and mouse.X<=pos.X+size.X and mouse.Y>=pos.Y and mouse.Y<=pos.Y+size.Y then return false end
 end
 if binding:find('MouseButton') then return UIS:IsMouseButtonPressed(Enum.UserInputType[binding]) end
 return UIS:IsKeyDown(Enum.KeyCode[binding])
end
local function updateRage(cam,center,now)
 if target and now-rageLastSwitch<cfg.RageSwitch then
  local part=validTarget(target,cam,center,false,true)
  if part then return part end
 end
 local candidates={}
 for _,p in ipairs(targets()) do
  local part=validTarget(p,cam,center,false,true)
  if part then table.insert(candidates,{Player=p,Part=part}) end
 end
 if #candidates==0 then clearLock('no eligible rage targets') return nil end
 rageIndex=rageIndex%#candidates+1
 local chosen=candidates[rageIndex]
 target=chosen.Player lockedCharacter=target.Character lostSince=nil rageLastSwitch=now
 state.LockReason='rage tracking'
 return chosen.Part
end
do
 UI.Section('Silent','SHOT TARGETING')
 toggle('Silent','Enable silent aim','Silent')
 cycle('Silent','Target part','SilentPart',{'Head','UpperTorso','HumanoidRootPart'})
 cycle('Silent','Selection','SilentPriority',{'Crosshair','Distance','Health'})
 toggle('Silent','Visibility check','SilentWalls')
 toggle('Silent','Ignore teammates','SilentTeam')
 toggle('Silent','Show FOV','SilentCircle')
 number('Silent','FOV radius','SilentFOV',10,800,10)
 number('Silent','Maximum range','SilentRange',100,10000,100)
 number('Silent','Hit chance (%)','SilentChance',0,100,5)
 cycle('Rage','Target part','RagePart',{'Head','UpperTorso','HumanoidRootPart'})
 cycle('Rage','Switch strategy','RageMode',{'On elimination','Timed','Nearest'})
 cycle('Rage','Selection','RagePriority',{'Crosshair','Distance','Health'})
 toggle('Rage','Visibility check','RageWalls')
 toggle('Rage','Ignore teammates','RageTeam')
 toggle('Rage','Silent rage targeting','RageSilent')
 toggle('Rage','Auto fire while held','RageAutoFire')
 number('Rage','Auto-fire rate cap','RageFireRate',1,20,1)
 local silentRing=make('Frame',{AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1,Visible=false},overlay)
 round(silentRing,999) make('UIStroke',{Color=Color3.fromRGB(235,75,157),Thickness=1,Transparency=.25},silentRing)
 local function getOptions(rage)
  return {Part=rage and cfg.RagePart or cfg.SilentPart,Range=rage and cfg.RageRange or cfg.SilentRange,FOV=not rage and cfg.SilentFOV or nil,Walls=rage and cfg.RageWalls or (not rage and cfg.SilentWalls),Team=rage and cfg.RageTeam or (not rage and cfg.SilentTeam),Priority=rage and cfg.RagePriority or cfg.SilentPriority}
 end
 local function candidate(p,options)
  if p==LP or (typeof(p)=='Instance' and (p.Parent~=Players or (options.Team and teammate(p)))) then return end
  local c=p.Character local h=c and c:FindFirstChildOfClass('Humanoid')
  if not c or not c:IsDescendantOf(workspace) or not h or h.Health<=0 or h.Health<cfg.MinHealth then return end
  if cfg.IgnoreShield and c:FindFirstChildOfClass('ForceField') then return end
  local part=c:FindFirstChild(options.Part) or c:FindFirstChild('Torso') or c:FindFirstChild('HumanoidRootPart')
  if not part or not part:IsA('BasePart') then return end
  local cam=workspace.CurrentCamera if not cam then return end
  local distance=(part.Position-cam.CFrame.Position).Magnitude if distance>options.Range then return end
  local v,on=cam:WorldToViewportPoint(part.Position)
  local delta=(Vector2.new(v.X,v.Y)-cam.ViewportSize*.5).Magnitude
  if options.FOV and (not on or delta>options.FOV) then return end
  if options.Walls and not visible(cam,c,part) then return end
  local score=options.Priority=='Distance' and distance or options.Priority=='Health' and h.Health or delta
  return part,score
 end
 local function sorted(options)
  local out={}
  for _,p in ipairs(targets()) do local part,score=candidate(p,options) if part then table.insert(out,{Actor=p,Part=part,Score=score,Key=typeof(p)=='Instance' and tostring(p.UserId) or p.Name..tostring(p.Character)}) end end
  table.sort(out,function(a,b) if a.Score==b.Score then return a.Key<b.Key end return a.Score<b.Score end)
  return out
 end
 local function selectRage(now)
  local options=getOptions(true)
  local current=target and candidate(target,options)
  if current and (cfg.RageMode=='On elimination' or (cfg.RageMode=='Timed' and now-rageLastSwitch<cfg.RageSwitch)) then return current end
  local list=sorted(options)
  if #list==0 then clearLock('no eligible rage targets') return end
  local selected=list[1]
  if cfg.RageMode=='Timed' and target then
   for i,v in ipairs(list) do if v.Actor==target then selected=list[i%#list+1] break end end
  end
  target=selected.Actor lockedCharacter=target.Character lostSince=nil rageLastSwitch=now
  state.LockReason='rage tracking'
  return selected.Part
 end
 updateRage=function(cam,center,now) return selectRage(now) end
 local function selectSilent()
  if math.random()*100>=cfg.SilentChance then return end
  local list=sorted(getOptions(false)) return list[1] and list[1].Part
 end
 local function aimPoint(part)
  local velocity=part.AssemblyLinearVelocity
  if not cfg.VerticalLead then velocity=Vector3.new(velocity.X,0,velocity.Z) end
  local lead=velocity*cfg.Prediction
  if lead.Magnitude>cfg.MaxLead then lead=lead.Unit*cfg.MaxLead end
  return part.Position+lead
 end
 local function redirect(data,part)
  if type(data)~='table' or typeof(data[string.char(1)])~='CFrame' then return data end
  local changedData=table.clone(data)
  local point=aimPoint(part)
  local origin=data[string.char(1)].Position
  if (point-origin).Magnitude<.001 then return data end
  changedData[string.char(1)]=CFrame.lookAt(origin,point)
  changedData[string.char(2)]=part
  changedData[string.char(3)]=part.CFrame:ToObjectSpace(CFrame.new(point))
  return changedData
 end
 local ok,gun=pcall(function() return require(LP.PlayerScripts.Modules.ItemTypes.Gun) end)
 local original=ok and gun.StartShooting
 local hook
 if type(original)=='function' then
  hook=function(item,...)
   local fighter=item.ClientFighter
   if not state.Alive or not fighter or not fighter.IsLocalPlayer then return original(item,...) end
   local eligible=focused and not UIS:GetFocusedTextBox()
   local rage=cfg.Rage and eligible and rageHeld()
   local part=rage and selectRage(os.clock()) or (cfg.Silent and eligible and selectSilent())
   if not part then return original(item,...) end
   local shadow=rawget(fighter,'GetCameraData')
   local getCamera=fighter.GetCameraData
   fighter.GetCameraData=function(self,...)
    return redirect(getCamera(self,...),part)
   end
   local result=table.pack(pcall(original,item,...))
   fighter.GetCameraData=shadow
   if not result[1] then error(result[2],0) end
   if result[2]==true then state.LastShot={Time=os.clock(),Part=part.Name,Target=part.Parent and part.Parent.Name,Mode=rage and 'Rage' or 'Silent'} end
   return table.unpack(result,2,result.n)
  end
  gun.StartShooting=hook
  table.insert(state.Cleanups,function() if gun.StartShooting==hook then gun.StartShooting=original end end)
 end
 state.ShotHookReady=hook~=nil
 local statusLabel=label(UI.Pages.Silent,hook and 'Connected to the gun shot-camera path. The visible camera stays unchanged. Server hit validation still applies.' or 'Gun interface unavailable in this game.',UDim2.new(),UDim2.new(1,-6,0,85)) statusLabel.LayoutOrder=1000
 local nextFire=0
 connect(Run.Heartbeat,function()
  local cam=workspace.CurrentCamera
  silentRing.Visible=not not (cam and cfg.Silent and cfg.SilentCircle)
  if cam then silentRing.Position=UDim2.fromOffset(cam.ViewportSize.X*.5,cam.ViewportSize.Y*.5) silentRing.Size=UDim2.fromOffset(cfg.SilentFOV*2,cfg.SilentFOV*2) end
  if not cfg.Rage or not cfg.RageAutoFire or not focused or UIS:GetFocusedTextBox() or not rageHeld() then return end
  local now=os.clock() if now<nextFire then return end
  local part=selectRage(now) if not part then return end
  local item=state.CurrentItem and state.CurrentItem()
  if not item or not item.Info or item.Info.Type~='Gun' then return end
  if tick()<(item._shoot_cooldown or 0) then return end
  nextFire=now+1/cfg.RageFireRate
  local identity=getthreadidentity and getthreadidentity()
  if setthreadidentity then setthreadidentity(2) end
  local success,err=pcall(function() item.ClientFighter:Input('StartShooting') end)
  if identity and setthreadidentity then setthreadidentity(identity) end
  if not success then state.AutoFireError=tostring(err) nextFire=now+1 end
 end)
 state.TestShotData=function()
  local p=Instance.new('Part') p.Anchored=true p.Position=Vector3.new(10,20,-100)
  local input={[string.char(0)]=CFrame.new(0,0,0),[string.char(1)]=CFrame.new(0,0,0)}
  local camera=workspace.CurrentCamera.CFrame
  local output=redirect(input,p)
  assert(output~=input and input[string.char(2)]==nil,'Mutated source data')
  assert(output[string.char(2)]==p,'Missing shot target')
  assert(output[string.char(1)].LookVector:Dot(p.Position.Unit)>.999,'Wrong shot direction')
  assert(workspace.CurrentCamera.CFrame==camera,'Changed visible camera')
  p:Destroy() return {HookInstalled=hook~=nil,ShotDirection=true,CameraUnchanged=true}
 end
 state.TestRage=function()
  local old=cfg.RageMode local oldTarget,oldCharacter,oldLost=target,lockedCharacter,lostSince
  local oldGetOptions=getOptions
  getOptions=function() return {Part='Head',Range=10000,Team=false,Walls=false,Priority='Distance'} end
  local result
  local success,err=pcall(function()
   cfg.RageMode='On elimination' clearLock('test')
   local first=selectRage(1)
   if first then local who=target assert(selectRage(10)==first and target==who,'Unwanted timed switch') end
   result={HookInstalled=hook~=nil,EligibleTargets=#sorted(getOptions(true)),StableOnElimination=first~=nil}
  end)
  cfg.RageMode=old getOptions=oldGetOptions target=oldTarget lockedCharacter=oldCharacter lostSince=oldLost
  assert(success,err) return result
 end
end


local frames=0
local function render(dt)
 local cam=workspace.CurrentCamera if not cam then return end
 accent=colors[cfg.Color]
 local center=cfg.Origin=='Cursor' and UIS:GetMouseLocation() or cam.ViewportSize*.5
 ring.Visible=cfg.Aim and cfg.Circle ring.Position=UDim2.fromOffset(center.X,center.Y) ring.Size=UDim2.fromOffset(cfg.FOV*2,cfg.FOV*2) ringStroke.Color=accent
 frames+=1
 for _,p in ipairs(targets()) do if p~=LP then
  local c=p.Character local h=c and c:FindFirstChildOfClass('Humanoid') local root=c and c:FindFirstChild('HumanoidRootPart')
  local distance=root and (root.Position-cam.CFrame.Position).Magnitude or math.huge
  local show=cfg.ESP and h and h.Health>0 and root and distance<=cfg.ESPDistance and not (typeof(p)=='Instance' and cfg.ESPTeam and teammate(p))
  if show and not cfg.ThroughWalls then show=visible(cam,c,c:FindFirstChild('Head') or root) end
  local v=state.Visuals[p]
  if show then v=visual(p,c) end
  if v then
   v.Folder.Visible=not not show v.Highlight.Enabled=not not (show and cfg.ESPMode~='Skeleton')
   v.Highlight.OutlineColor=accent v.Highlight.DepthMode=cfg.ThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
   if show then
    local head=c:FindFirstChild('Head') or root local pos,on=cam:WorldToViewportPoint(head.Position+Vector3.new(0,1.4,0))
    v.Tag.Visible=cfg.Names and on v.Tag.Position=UDim2.fromOffset(pos.X,pos.Y) v.Tag.TextColor3=accent
    v.Tag.Text=p.DisplayName..'  ·  '..math.floor(h.Health)..' HP  ·  '..math.floor(distance)..' st'
    for i,line in ipairs(v.Lines) do
     local pair=v.Bones[i] local a,ao=cam:WorldToViewportPoint(pair[1].Position) local b,bo=cam:WorldToViewportPoint(pair[2].Position)
     line.Visible=cfg.ESPMode~='Outline' and ao and bo
     if line.Visible then local av,bv=Vector2.new(a.X,a.Y),Vector2.new(b.X,b.Y) local d=bv-av local mid=(av+bv)*.5 line.Position=UDim2.fromOffset(mid.X,mid.Y) line.Size=UDim2.fromOffset(d.Magnitude,cfg.Thickness) line.Rotation=math.deg(math.atan2(d.Y,d.X)) line.BackgroundColor3=accent end
    end
   end
  end
 end end
 local canAim=focused and not UIS:GetFocusedTextBox()
 local rageActive=cfg.Rage and canAim and rageHeld()
 if rageActive~=wasRage then clearLock('mode changed') rageIndex=0 rageLastSwitch=0 wasRage=rageActive end
 local normalActive=cfg.Aim and canAim and held()
 if rageActive or normalActive then
  local part
  if rageActive then part=updateRage(cam,center,os.clock()) else part=updateLock(cam,center,os.clock()) end
  if part and not (rageActive and cfg.RageSilent) then
   local velocity=part.AssemblyLinearVelocity
   if not cfg.VerticalLead then velocity=Vector3.new(velocity.X,0,velocity.Z) end
   local lead=velocity*cfg.Prediction
   if lead.Magnitude>cfg.MaxLead then lead=lead.Unit*cfg.MaxLead end
   local point=part.Position+lead
   local screen,onScreen=cam:WorldToViewportPoint(point)
   local aimCenter=cam.ViewportSize*.5
   local delta=(Vector2.new(screen.X,screen.Y)-aimCenter).Magnitude
   if rageActive or not onScreen or delta>cfg.Deadzone then
    local direction=point-cam.CFrame.Position
    if direction.Magnitude>.001 then
     local alpha=(rageActive or cfg.Smooth==0) and 1 or 1-math.exp(-dt*120/cfg.Smooth)
     if not rageActive and cfg.TurnSpeed>0 then
      local angle=math.acos(math.clamp(cam.CFrame.LookVector:Dot(direction.Unit),-1,1))
      if angle>.00001 then alpha=math.min(alpha,math.rad(cfg.TurnSpeed)*dt/angle) end
     end
     cam.CFrame=cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position,point),alpha)
    end
   end
  end
 else clearLock('activation released') end
 state.Frames=frames
 state.Target=target
 state.AimActive=not not (rageActive or normalActive)
 if frames%12==0 and os.clock()>=messageUntil then
  local reason=rageActive and (target and 'RAGE: '..target.Name or 'RAGE: no eligible target') or not cfg.Aim and 'OFF' or not focused and 'PAUSED: window unfocused' or UIS:GetFocusedTextBox() and 'PAUSED: typing' or not held() and ('WAITING: '..cfg.Bind) or target and ('LOCKED: '..target.Name) or 'ACTIVE: no target inside FOV'
  UI.Notify(reason..' | '..cfg.AimMode..' | '..db.Active..(diskOK and ' | Saved' or ' | SAVE ERROR'))
 end
end
state.Unload=function()
 if not state.Alive then return end state.Alive=false save()
 Run:UnbindFromRenderStep('GlassPanelRender')
 for _,cleanup in ipairs(state.Cleanups) do pcall(cleanup) end
 for _,c in ipairs(state.Connections) do c:Disconnect() end
 for _,p in ipairs(state.Patches) do pcall(function() p.Table[p.Key]=p.Original end) end
 for p in pairs(state.Visuals) do removeVisual(p) end
 UI.Destroy() gui:Destroy() if env.GlassPanel==state then env.GlassPanel=nil end
end
state.Save=save state.Refresh=refresh state.Counts=counts state.ConfigPath=path
refresh()
if loaded then if save() then message('Ready  /  '..db.Active..'  /  Autosave on  /  Maribo UI') end else message('Config read failed; defaults loaded. '..tostring(diskError):sub(1,65)) end
Run:BindToRenderStep('GlassPanelRender',Enum.RenderPriority.Last.Value+100,function(dt)
 local ok,err=pcall(render,dt) if not ok then state.Errors+=1 if state.Errors<=3 then warn('GlassPanel render:',err) end end
end)
state.TestAim=function()
 local snapshot=table.clone(cfg)
 local oldFocus=focused
 local cam=workspace.CurrentCamera local oldCamera=cam.CFrame
 local ok,result=pcall(function()
  cfg.AimMode='Always' cfg.Smooth=0 cfg.Aim=true cfg.NPC=true cfg.Walls=false cfg.Distance=10000 cfg.FOV=800 cfg.Origin='Center' cfg.TurnSpeed=0 cfg.Deadzone=0 cfg.Prediction=0 cfg.Rage=false cfg.MinHealth=0 cfg.IgnoreShield=false focused=true
  local sample
  for _,p in ipairs(targets()) do
   local c=p.Character local h=c and c:FindFirstChildOfClass('Humanoid')
   local part=c and c:FindFirstChild('Head')
   if type(p)=='table' and part and h and h.Health>0 and (part.Position-cam.CFrame.Position).Magnitude<10000 then sample=part break end
  end
  assert(sample,'No shooting-range target available for test')
  cam.CFrame=CFrame.lookAt(cam.CFrame.Position,sample.Position)*CFrame.Angles(0,math.rad(4),0)
  target=nil
  render(1/60)
  assert(target,'No target acquired')
  local part=validTarget(target,cam,cam.ViewportSize*.5)
  assert(part,'Lost target')
  local direction=(part.Position+part.AssemblyLinearVelocity*cfg.Prediction-cam.CFrame.Position).Unit
  local degrees=math.deg(math.acos(math.clamp(cam.CFrame.LookVector:Dot(direction),-1,1)))
  assert(degrees<.1,'Aim alignment error '..degrees)
  return {Target=target.Name,ErrorDegrees=degrees,Candidates=#targets()}
 end)
 for k,v in pairs(snapshot) do cfg[k]=v end
 focused=oldFocus cam.CFrame=oldCamera target=nil
 assert(ok,result)
 return result
end
state.GetTargets=targets
state.TestLegacyRage=function()
 local snapshot=table.clone(cfg)
 local oldTargets=targets
 local oldTarget,oldCharacter,oldLost=target,lockedCharacter,lostSince
 local oldIndex,oldSwitch=rageIndex,rageLastSwitch
 local models,candidates={},{}
 local cam=workspace.CurrentCamera local center=cam.ViewportSize*.5
 local ok,result=pcall(function()
  cfg.Team=false cfg.MinHealth=0 cfg.IgnoreShield=true cfg.Walls=false cfg.RageRange=1000 cfg.RageSwitch=.25
  for i=1,3 do
   local model=Instance.new('Model') model.Name='MariboRageTest'..i table.insert(models,model)
   local head=Instance.new('Part') head.Name='Head' head.Anchored=true head.CanCollide=false head.CanTouch=false head.CanQuery=false head.Transparency=1
   head.Position=(cam.CFrame*CFrame.new(i*10,0,i==3 and 100 or -100)).Position head.Parent=model
   local h=Instance.new('Humanoid') h.RequiresNeck=false h.Parent=model model.Parent=workspace
   table.insert(candidates,{Character=model,Name=model.Name})
  end
  targets=function() return candidates end
  clearLock('test') rageIndex=0 rageLastSwitch=0
  for i=1,3 do
   assert(updateRage(cam,center,i),'No rage target')
   assert(target==candidates[i],'Target cycle mismatch')
   assert(updateRage(cam,center,i+.1),'Lost target before interval')
   assert(target==candidates[i],'Switched before interval')
  end
  local shield=Instance.new('ForceField') shield.Parent=models[1]
  assert(not validTarget(candidates[1],cam,center,false,true),'Shield filter failed')
  shield:Destroy()
  models[2]:FindFirstChildOfClass('Humanoid').Health=0
  assert(not validTarget(candidates[2],cam,center,false,true),'Death filter failed')
  cfg.RageRange=1
  assert(not updateRage(cam,center,5) and target==nil,'Range filter failed')
  return {CycledTargets=3,IncludesBehindCamera=true,SwitchInterval=true,ShieldFilter=true,DeathFilter=true,RangeFilter=true}
 end)
 targets=oldTargets
 for k,v in pairs(snapshot) do cfg[k]=v end
 target=oldTarget lockedCharacter=oldCharacter lostSince=oldLost rageIndex=oldIndex rageLastSwitch=oldSwitch
 for _,model in ipairs(models) do model:Destroy() end
 assert(ok,result)
 return result
end
state.TestRetention=function()
 local snapshot=table.clone(cfg)
 local oldTarget,oldCharacter,oldLost=target,lockedCharacter,lostSince
 local oldVisible,oldTargets=visible,targets
 local cam=workspace.CurrentCamera
 local center=cam.ViewportSize*.5
 local model=Instance.new('Model') model.Name='MariboRetentionTest'
 local head=Instance.new('Part') head.Name='Head' head.Size=Vector3.one head.Anchored=true head.CanCollide=false head.CanTouch=false head.CanQuery=false head.Transparency=1 head.Parent=model
 local h=Instance.new('Humanoid') h.RequiresNeck=false h.Parent=model
 model.Parent=workspace
 local fake={Character=model,Name='RetentionTest',DisplayName='RetentionTest'}
 local base=cam.CFrame
 local ok,result=pcall(function()
  cfg.Team=false cfg.Sticky=true cfg.Walls=false cfg.Distance=10000 cfg.FOV=30 cfg.LockGrace=.4 cfg.MinHealth=0 cfg.IgnoreShield=false
  targets=function() return {fake} end
  head.Position=(base*CFrame.new(0,0,-100)).Position
  clearLock('test')
  assert(updateLock(cam,center,0)==head and target==fake,'Initial acquisition failed')
  local outside=0
  for i=1,360 do
   -- Simulate six seconds of strafing/jumping while the game camera still uses its old orientation.
   head.Position=(base*CFrame.new(80*math.sin(i*.07),40*math.abs(math.sin(i*.11)),-100)).Position
   if not validTarget(fake,cam,center,false) then outside+=1 end
   assert(updateLock(cam,center,i/60)==head and target==fake,'Dropped moving target at frame '..i)
  end
  assert(outside>0,'Test did not exercise crossing acquisition FOV')
  cfg.Walls=true visible=function() return false end
  assert(updateLock(cam,center,7)==nil and target==fake,'Occlusion should pause, not release')
  assert(updateLock(cam,center,7.2)==nil and target==fake,'Released within grace period')
  visible=function() return true end
  assert(updateLock(cam,center,7.3)==head and target==fake,'Failed to resume same target')
  visible=function() return false end
  updateLock(cam,center,8)
  updateLock(cam,center,8.5)
  assert(target==nil,'Persistent occlusion should release')
  cfg.Walls=false
  head.Position=(base*CFrame.new(0,0,-100)).Position
  assert(updateLock(cam,center,9)==head,'Reacquisition failed')
  h.Health=0
  updateLock(cam,center,9.1)
  assert(target==nil,'Dead target was retained')
  clearLock('activation released')
  assert(target==nil and lostSince==nil,'Release did not clear retention state')
  return {Frames=360,OutsideFOVFrames=outside,OcclusionGrace=true,DeathRelease=true,ReleaseClearsState=true}
 end)
 visible=oldVisible targets=oldTargets
 for k,v in pairs(snapshot) do cfg[k]=v end
 target=oldTarget lockedCharacter=oldCharacter lostSince=oldLost
 model:Destroy()
 assert(ok,result)
 return result
end
state.CheckTarget=function(p) local cam=workspace.CurrentCamera return validTarget(p,cam,cfg.Origin=='Cursor' and UIS:GetMouseLocation() or cam.ViewportSize*.5) end
connect(UI.Gui.Destroying,function() if state.Alive then state.Unload() end end)
