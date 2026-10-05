-- Ragebot + Flickbot extraction from message.txt
-- Source-derived slice. It intentionally keeps the original internal module names.
-- NOTE: this is an extraction slice, not a guaranteed standalone executor script;
-- the original code depends on Kicia/tbl17 modules defined elsewhere in the source.

-- ===== Combat configuration (source-derived) =====

if not jc then
local jc2 = { c = fn35() }
tbl17.cache.jc = jc2
jc = jc2
end

return jc.c
end
end
do -- jd
local function fn35() tbl17 .aE(); tbl17 .hN();local I,W,N,P= tbl17 .i9(), tbl17 .ja(), tbl17 .jb(), tbl17 .jc();return function(l,a,e)local c,E,p,T=a:AddSection({Title="Skybox",Side="left"}),a:AddSection({Title="Ambient Sound",Side="left"}),a:AddSection({Title="Weather",Side="right"}),a:AddSection({Title="Lightning",Side="right"});N(c,l.Skyboxes,e);I(E);P(p);W(T);end;end

tbl17.jd = function()
local jd = tbl17.cache.jd

if not jd then
local jd2 = { c = fn35() }
tbl17.cache.jd = jd2

-- ===== Ragebot/Flickbot implementation modules: source blocks ja through jW =====
do -- ja
local function fn35() tbl17 .aE();local function l(...)local I={"Weather","Lightning"};for W=1,select("#",...),1 do table.insert(I,(select(W,...)));end;return I;end;return function(I)I:AddColor({Row=I:AddToggle({Label="Enable Lightning",Tooltip="Strike lightning during rain and blizzards.",Config=l("Enabled")}).Row,Gradient="editable",Tooltip="Colour or gradient of the lightning bolts.",Config=l("Color")});I:AddDivider({Label="Bolt"});I:AddSlider({Label="Interval",Tooltip="Average seconds between strikes.",Min=0.2,Max=10,Step=0.1,Suffix="s",Config=l("Interval")});I:AddSlider({Label="Distance",Tooltip="Farthest a strike can land from the camera.",Min=10,Max=200,Config=l("Distance")});I:AddSlider({Label="Height",Tooltip="Length of each bolt from cloud to ground.",Min=50,Max=400,Config=l("Height")});I:AddSlider({Label="Thickness",Tooltip="Core thickness of the bolts.",Min=0.5,Max=12,Step=0.1,Config=l("Thickness")});I:AddSlider({Label="Jaggedness",Tooltip="How jagged and erratic the bolts look.",Min=0,Max=20,Step=0.1,Config=l("Jaggedness")});I:AddSlider({Label="Branches",Tooltip="Maximum forks that split off each bolt.",Min=0,Max=24,Step=1,Config=l("Branches")});I:AddSlider({Label="Flash",Tooltip="Brightness of the light flash at the impact.",Min=0,Max=20,Step=0.1,Config=l("Flash")});I:AddDivider({Label="Sparks"});local W=I:AddToggle({Label="Sparks",Tooltip="Sparks that crackle off the bolt as it strikes.",Config=l("Sparks","Enabled")});I:AddColor({Row=W.Row,Gradient="editable",Tooltip="Colour or gradient of the sparks.",Config=l("Sparks","Color")});local N=I:AddGroup({Source=W});N:AddSlider({Label="Count",Tooltip="How many sparks each strike throws off.",Min=0,Max=40,Step=1,Config=l("Sparks","Count")});N:AddSlider({Label="Thickness",Tooltip="Thickness of the sparks.",Min=0.2,Max=8,Step=0.1,Config=l("Sparks","Thickness")});N:AddSlider({Label="Distance",Tooltip="How far sparks fly from the bolt.",Min=2,Max=50,Step=0.5,Config=l("Sparks","Distance")});N:AddSlider({Label="Speed",Tooltip="How fast sparks shoot out and fade.",Min=2,Max=40,Step=0.5,Config=l("Sparks","Speed")});N:AddSlider({Label="Jaggedness",Tooltip="How jagged the sparks look.",Min=0,Max=12,Step=0.1,Config=l("Sparks","Jaggedness")});I:AddDivider({Label="Explosion"});N=I:AddToggle({Label="Explosion",Tooltip="Burst of arcs that erupts where the bolt lands.",Config=l("Explosion","Enabled")});I:AddColor({Row=N.Row,Gradient="editable",Tooltip="Colour or gradient of the explosion.",Config=l("Explosion","Color")});W=I:AddGroup({Source=N});W:AddSlider({Label="Size",Tooltip="Size of the impact burst.",Min=0,Max=1,Step=0.01,Config=l("Explosion","Size")});W:AddSlider({Label="Bolts",Tooltip="How many arcs radiate from the impact.",Min=0,Max=30,Step=1,Config=l("Explosion","Bolts")});I:AddDivider({Label="Sound"});N=I:AddGroup({Source=I:AddToggle({Label="Sound",Tooltip="Play a thunder crack with each strike, delayed and quietened by distance.",Config=l("Sound","Enabled")})});N:AddSlider({Label="Volume",Tooltip="Loudness of a strike landing right beside you.",Min=0,Max=3,Step=0.05,Config=l("Sound","Volume")});N:AddToggle({Label="Delay",Tooltip="Lag the crack by the strike's distance, like real thunder. Off plays it instantly.",Config=l("Sound","Delay")});N:AddTextBox({Label="Sound ID",Tooltip="Roblox sound id or local file path for the crack. Leave empty for the default thunder.",FocusLostOnly=true,Config=l("Sound","SoundId")});end;end

tbl17.ja = function()
local ja = tbl17.cache.ja

if not ja then
local ja2 = { c = fn35() }
tbl17.cache.ja = ja2
ja = ja2
end

return ja.c
end
end
do -- jb
local function fn35()local I= tbl17 .aB(); tbl17 .gY(); tbl17 .aE();local l={{Label="Up Face",Key="SkyboxUp"},{Label="Down Face",Key="SkyboxDn"},{Label="Front Face",Key="SkyboxFt"},{Label="Back Face",Key="SkyboxBk"},{Label="Left Face",Key="SkyboxLf"},{Label="Right Face",Key="SkyboxRt"}};return function(W,N,P)local function a()P:Dialog({Title="Manage Skyboxes",Description="Add or remove custom skyboxes."},function(P)local e;local c={};P:AddPage({Title="Add a Skybox",Description="Enter a name and six face textures.",Glyph="+",ActionText="Add Skybox",OnAction=function()local E,p=e,{};for T,t in c,nil,nil do p[T]=t.Value;end;local T=N:Add(E.Value,p);if not T.Ok then I.get():Notify(T.Error.Detail);return false;end;E:Set("",true);for E,E_178 in c,nil,nil do E_178:Set("",true);end;return true;end},function(E)e=E:AddTextBox({Label="Name"});for e,e_179 in l,nil,nil do c[e_179.Key]=E:AddTextBox({Label=e_179.Label,Placeholder="Id / Url"});end;end);local l,e_180;e_180=P:AddPage({Title="Remove a Skybox",Description="Select a skybox to remove.",Glyph="\226\136\146",ActionText="Remove Skybox",Variant="danger",ActionEnabled=false,Confirmation={Title="Remove selected skybox?",Description=function()local P=l.Value;if P==nil then return"The selected skybox will be permanently removed.";end;return string.format("\"%s\" will be permanently removed.",tostring(P));end,ActionText="Confirm"},OnOpen=function()local P=l;P:SetOptions(N:GetNames());e_180:SetActionEnabled(P.Value~=nil);end,OnAction=function()local P=l.Value;if P==nil then return false;end;local c=N:Remove(P);if not c.Ok then I.get():Notify(c.Error.Detail);return false;end;return true;end},function(I)local P=I:AddList({Label="Skybox",Options=N:GetNames(),Height=150,Search=true,SelectFirst=false});l=P;P:Connect(P.ValueChanged,function(l)e_180:SetActionEnabled(l~=nil);end);P:Connect(N.Changed,function(l)P:SetOptions(l);end);end);end);end;local l=W:AddGroup({Source=W:AddToggle({Label="Enable Skybox",Config={"Skybox","Enabled"}})}):AddDropdown({Label="Preset",Options=N:GetNames(),Config={"Skybox","Preset"}});W:AddButton({Label="Manage Skyboxes",OnClick=a});l:Connect(N.Changed,function(I)l:SetOptions(I);end);end;end

tbl17.jb = function()
local jb = tbl17.cache.jb

if not jb then
local jb2 = { c = fn35() }
tbl17.cache.jb = jb2
jb = jb2
end

return jb.c
end
end
do -- jc
local function fn35() tbl17 .aE();return function(l)local I=l:AddToggle({Label="Enable Weather",Config={"Weather","Enabled"}});l:AddColor({Row=I.Row,Config={"Weather","Color"},Animatable=true});local W=l:AddGroup({Source=I});W:AddDropdown({Label="Preset",Options={"Snow","Rain","Blizzard"},Config={"Weather","Preset"}});W:AddSlider({Label="Intensity",Min=0,Max=2,Step=0.01,Config={"Weather","Intensity"}});W:AddSlider({Label="Rate",Min=0,Max=3,Step=0.01,Config={"Weather","Rate"}});W:AddSlider({Label="Height",Min=10,Max=100,Config={"Weather","Height"}});W:AddSlider({Label="Speed",Min=0.5,Max=3,Step=0.01,Config={"Weather","Speed"}});W:AddSlider({Label="Glow",Min=0,Max=1,Step=0.01,Config={"Weather","Glow"}});W:AddSlider({Label="Size",Min=0.5,Max=2,Step=0.01,Config={"Weather","Size"}});W:AddSlider({Label="Spread",Min=0,Max=3,Step=0.01,Config={"Weather","Spread"}});W:AddSlider({Label="Wind Strength",Min=0,Max=20,Step=0.1,Config={"Weather","Wind","Strength"}});W:AddSlider({Label="Wind Angle",Min=0,Max=360,Config={"Weather","Wind","Angle"}});end;end

tbl17.jc = function()
local jc = tbl17.cache.jc

if not jc then
local jc2 = { c = fn35() }
tbl17.cache.jc = jc2
jc = jc2
end

return jc.c
end
end
do -- jd
local function fn35() tbl17 .aE(); tbl17 .hN();local I,W,N,P= tbl17 .i9(), tbl17 .ja(), tbl17 .jb(), tbl17 .jc();return function(l,a,e)local c,E,p,T=a:AddSection({Title="Skybox",Side="left"}),a:AddSection({Title="Ambient Sound",Side="left"}),a:AddSection({Title="Weather",Side="right"}),a:AddSection({Title="Lightning",Side="right"});N(c,l.Skyboxes,e);I(E);P(p);W(T);end;end

tbl17.jd = function()
local jd = tbl17.cache.jd

if not jd then
local jd2 = { c = fn35() }
tbl17.cache.jd = jd2
jd = jd2
end

return jd.c
end
end
do -- je
local function fn35() tbl17 .aE(); tbl17 .hN();local I,W,N,P= tbl17 .i1(), tbl17 .i8(), tbl17 .jd(),{World="rbxassetid://125685532120024",Lighting="rbxassetid://139232691165198",PostProcessing="rbxassetid://139684165362622",SkyWeather="rbxassetid://140109651313859"};return function(l,a)local e=a:AddTab({Label="World",Icon=P.World,Description="Lighting, post-processing, sky, and ambient sound."});I((e:AddTab({Label="Lighting",Icon=P.Lighting,Description="Override time, exposure, shadows, ambient light, fog, and atmosphere."}):Grid({Columns=2})));W((e:AddTab({Label="Post Processing",Icon=P.PostProcessing,Description="Tune tone, focus, motion, and light effects."}):Grid({Columns=2})));N(l,e:AddTab({Label="Sky & Weather",Icon=P.SkyWeather,Description="Choose a skybox, ambient sound, weather, and lightning."}):Grid({Columns=2}),a);end;end

tbl17.je = function()
local je = tbl17.cache.je

if not je then
local je2 = { c = fn35() }
tbl17.cache.je = je2
je = je2
end

return je.c
end
end
do -- jf
local function fn35()local I,W= tbl17 .bG(), tbl17 .aE(); tbl17 .hN();local N,P,a,e,c,E,p,T= tbl17 .h_(), tbl17 .ij(), tbl17 .ip(), tbl17 .n(), tbl17 .iw(), tbl17 .i_(), tbl17 .je(),cloneref(game:GetService("Players")).LocalPlayer;return function(l)if getgenv().KhForceMobileUi==true then W.ForceMobileLayout();end;local t=W.Menu.new({Icon=K.LithiumLogo,Title=string.format("KiciaHook | Rivals | %s",tostring("Premium Build")),Directory="kiciarebuild/rivals",Config=l.ReactiveStoreAdapter,ColorAnimation=l.ColorAnimation,Persistence=I,State=l.GeneralState,StateData=l.GeneralStateData,OnUnload=function()e:Destroy();end});e:Add(t);local I=l.PlayerIdentities;t:SetWatermarkUsername(I:GetPresented(T));e:Connect(I.IdentityChanged,function(W)if W==T then t:SetWatermarkUsername(I:GetPresented(T));end;end);P(l,t);E(l,t);c(l,t);N(l,t);p(l,t);a(l,t);t:AddSettingsTab();t:SetVisible(not(l.GeneralStateData.SilentLoad==true),true);end;end

tbl17.jf = function()
local jf = tbl17.cache.jf

if not jf then
jf = { c = fn35() }
tbl17.cache.jf = jf
end

return jf.c
end
end
do -- jg
local function fn35()
return function()
for _, v115 in getconnections(game:GetService("Players").LocalPlayer.Idled) do
if v115.Function == nil then
if v115.Disable then
v115:Disable()
elseif v115.Disconnect then
v115:Disconnect()
end
end
end
end
end

tbl17.jg = function()
local jg = tbl17.cache.jg

if not jg then
jg = { c = fn35() }
tbl17.cache.jg = jg
end

return jg.c
end
end
do -- jh
local function fn35()
local v115 = tbl17.a()
local v116 = tbl17.b3()
local leaderboardController = tbl17.aS().LeaderboardController
local seasonLibrary = tbl17.aS().SeasonLibrary
local v117 = tbl17.ad()
local v118 = tbl17.dQ()
local localPlayer = cloneref(game:GetService("Players")).LocalPlayer
local index2 = {}
index2.__index = index2

local function fn36(arg)
local v119 = getmetatable(leaderboardController)
if v119 == nil then
return nil
end
local v120 = v102(v119, "__index")
if type(v120) ~= "table" then
return nil
end
local v121 = v102(v120, arg)
return (type(v121) == "function" and { v121 } or { nil })[1]
end

local function fn37(arg, arg2)
local players = v102(arg, "Players")
if type(players) ~= "table" then
return arg
end
local str7 = tostring(localPlayer.UserId)
local v119 = table.clone(players)

for i = #v119, v86[63], -v86[63] do
local v120 = v119[i]

if type(v120) == "table" and v102(v120, "key") == str7 then
table.remove(v119, i)
end
end

local tbl18 = { key = str7, value = arg2.Value }
table.insert(v119, math.clamp(arg2.Rank, 1, #v119 + 1), tbl18)
local v120 = table.clone(arg)
v120.Players = v119
return v120
end

index2.new = function()
return setmetatable({
_errorReporter = v117.new(),
_resolver = nil,
_boardEntryProvider = nil,
_restore = nil,
_serialsRestore = nil,
}, index2)
end

index2._Install = function(arg)
if arg._restore ~= nil then
return
end
local GetRankingByUserID = fn36("GetRankingByUserID")
if GetRankingByUserID == nil then
arg._errorReporter:Report(v115.err("LeaderboardRankHook", "function_lookup", "GetRankingByUserID unavailable").Error)
return
end
local getHighestELOLeaderboardRanking = v102(seasonLibrary, "GetHighestELOLeaderboardRanking")
if getHighestELOLeaderboardRanking == nil then
arg._errorReporter:Report(v115.err("LeaderboardRankHook", "function_lookup", "GetHighestELOLeaderboardRanking unavailable").Error)
return
end

for k, v119 in debug.getconstants(getHighestELOLeaderboardRanking) do
if v119 == "GetRankingByUserID" then
arg._restore = { ConstantIndex = k, Original = v119 }
debug.setconstant(getHighestELOLeaderboardRanking, k, "GetRankingByUserID\0kicia")
break
end
end

if arg._restore == nil then
arg._errorReporter:Report(v115.err("LeaderboardRankHook", "constant_scan", "GetRankingByUserID constant not found").Error)
return
end

v103(leaderboardController, "GetRankingByUserID\0kicia", function(arg2, arg3, arg4)
local resolver = arg._resolver

if resolver ~= nil and arg3 == "Highest ELO" and arg4 ~= nil then
local v119 = resolver(arg4)
if v119 ~= nil then
return v119
end
end

return v116(GetRankingByUserID, arg2, arg3, arg4)
end)
end

index2._InstallSerials = function(arg)
if arg._serialsRestore ~= nil then
return
end
local leaderboardSerials = v102(leaderboardController, "LeaderboardSerials")
if type(leaderboardSerials) ~= "table" then
arg._errorReporter:Report(v115.err("LeaderboardRankHook", "table_lookup", "LeaderboardSerials unavailable").Error)
return
end
local v119 = leaderboardSerials

local obj = setmetatable({}, {
__index = function(arg2, arg3)
local v120 = v102(v119, arg3)
local boardEntryProvider = arg._boardEntryProvider
if boardEntryProvider ~= nil and arg3 == "Highest ELO" and type(v120) == "table" then
return fn37(v120, boardEntryProvider())
end
return v120
end,
__newindex = function(arg2, arg3, arg4)
v103(v119, arg3, arg4)
end,
})

v103(leaderboardController, "LeaderboardSerials", obj)
arg._serialsRestore = { Inner = leaderboardSerials }
end

index2._RevertSerials = function(arg)
local serialsRestore = arg._serialsRestore
if serialsRestore == nil then
return
end
arg._serialsRestore = nil
v103(leaderboardController, "LeaderboardSerials", serialsRestore.Inner)
end

index2.Set = function(arg, resolver)
arg._resolver = resolver
arg:_Install()
end

index2.Unset = function(arg)
arg._resolver = nil
end

index2.SetBoardEntry = function(arg, boardEntryProvider)
arg._boardEntryProvider = boardEntryProvider
arg:_InstallSerials()
end

index2.UnsetBoardEntry = function(arg)
arg._boardEntryProvider = nil
end

index2.TriggerRefresh = function(arg)
local GetLeaderboardRefreshedSignal = fn36("GetLeaderboardRefreshedSignal")
if GetLeaderboardRefreshedSignal == nil then
arg._errorReporter:Report(v115.err("LeaderboardRankHook", "function_lookup", "GetLeaderboardRefreshedSignal unavailable").Error)
return
end
local highestElo = v116(GetLeaderboardRefreshedSignal, leaderboardController, "Highest ELO")
if highestElo == nil then
return
end
v118(highestElo)
end

index2._Revert = function(arg)
local restore = arg._restore
if restore == nil then
return
end
local getHighestELOLeaderboardRanking = v102(seasonLibrary, "GetHighestELOLeaderboardRanking")

if getHighestELOLeaderboardRanking ~= nil then
debug.setconstant(getHighestELOLeaderboardRanking, restore.ConstantIndex, restore.Original)
end

v103(leaderboardController, "GetRankingByUserID\0kicia", nil)
arg._restore = nil
end

index2.Destroy = function(arg)
arg._resolver = nil
arg._boardEntryProvider = nil
arg:_Revert()
arg:_RevertSerials()
arg._errorReporter:Destroy()
end

return index2
end

tbl17.jh = function()
local jh = tbl17.cache.jh

if not jh then
jh = { c = fn35() }
tbl17.cache.jh = jh
end

return jh.c
end
end
do -- ji
local function fn35()
local index2 = {}
index2.__index = index2

index2.new = function(arg, arg2)
local tbl18 = {
_instance = arg,
_attribute = arg2,
_original = arg:GetAttribute(arg2),
_isWriting = v86[153],
_connection = nil,
}

setmetatable(tbl18, index2)
tbl18:_Initialize()
return tbl18
end

index2._Initialize = function(arg)
local instance = arg._instance
local attribute = arg._attribute

arg._connection = instance:GetAttributeChangedSignal(attribute):Connect(function()
if arg._isWriting then
return
end
arg._original = instance:GetAttribute(attribute)
arg._isWriting = v86[34]
local spoofed = arg._spoofed

if spoofed ~= nil then
instance:SetAttribute(attribute, spoofed.Value)
end

arg._isWriting = v86[153]
end)
end

index2.Set = function(arg, spoofed)
arg._spoofed = spoofed
arg._isWriting = true

if spoofed ~= nil then
arg._instance:SetAttribute(arg._attribute, spoofed.Value)
else
arg._instance:SetAttribute(arg._attribute, arg._original)
end

arg._isWriting = false
end

index2.Destroy = function(arg)
arg._connection:Disconnect()
arg._instance:SetAttribute(arg._attribute, arg._original)
end

return index2
end

tbl17.ji = function()
local ji = tbl17.cache.ji

if not ji then
ji = { c = fn35() }
tbl17.cache.ji = ji
end

return ji.c
end
end
do -- jj
local function fn35()
local v115 = tbl17.ji()
tbl17.bK()
local v116 = tbl17.k()
local v117 = tbl17.bW()
local v118 = tbl17.bX()
local index2 = {}
index2.__index = index2

index2.new = function(arg)
local tbl18 = {
_trove = v116.new("player_spoofer.AttributeSink"),
_playerRegistry = arg,
_guardedAttributeByNameByPlayer = {},
}

setmetatable(tbl18, index2)
tbl18:_Initialize()
return tbl18
end

index2._Initialize = function(arg)
arg._trove:Add(arg._playerRegistry:ObservePlayers(function(arg2)
arg:_Apply(arg2)
end, function(arg2)
arg:_Cleanup(arg2)
end))
end

index2.RefreshScope = function(arg, arg2)
v117(arg2, function(arg3)
arg:_Apply(arg3)
end)
end

index2._Apply = function(arg, arg2)
local v119 = v118(arg2)
arg:_SetValue(arg2, "StatisticDuelsWinStreak", v119.Winstreak)
arg:_SetValue(arg2, "Level", v119.Level)
arg:_SetValue(arg2, "DisplayELO", v119.RankedElo)
arg:_SetValue(arg2, "PlayerStatus", v119.NametagStatus)
arg:_SetConst(arg2, "IsInfluencer", v119.Influencer.Enabled, true)
arg:_SetConst(arg2, "IsRobloxEmployee", v119.RobloxEmployee.Enabled, v86[34])
arg:_SetConst(arg2, "GroupRank", v119.NosniyTeam.Enabled, 255)
end

index2._SetValue = function(arg, arg2, arg3, arg4)
if arg4.Enabled then
arg:_Bind(arg2, arg3):Set({ Value = arg4.Value })
else
arg:_Unbind(arg2, arg3)
end
end

index2._SetConst = function(arg, arg2, arg3, arg4, arg5)
if arg4 then
arg:_Bind(arg2, arg3):Set({ Value = arg5 })
else
arg:_Unbind(arg2, arg3)
end
end

index2._Bind = function(arg, arg2, arg3)
local tbl18 = arg._guardedAttributeByNameByPlayer[arg2]

if tbl18 == nil then
tbl18 = {}
arg._guardedAttributeByNameByPlayer[arg2] = tbl18
end

local v119 = tbl18[arg3]

if v119 == nil then
local v120 = v115.new(arg2, arg3)
tbl18[arg3] = v120
v119 = v120
end

return v119
end

index2._Unbind = function(arg, arg2, arg3)
local v119 = arg._guardedAttributeByNameByPlayer[arg2]
if v119 == nil then
return
end
local v120 = v119[arg3]

if v120 ~= nil then
v120:Destroy()
v119[arg3] = nil
end
end

index2._Cleanup = function(arg, arg2)
local v119 = arg._guardedAttributeByNameByPlayer[arg2]
if v119 == nil then
return
end

for _, v120 in v119, nil, nil do
v120:Destroy()
end

arg._guardedAttributeByNameByPlayer[arg2] = nil
end

index2.Destroy = function(arg)
for _, v119 in arg._guardedAttributeByNameByPlayer, nil, nil do
for _, v120 in v119, nil, nil do
v120:Destroy()
end
end

arg._trove:Destroy()
end

return index2
end

tbl17.jj = function()
local jj = tbl17.cache.jj

if not jj then
jj = { c = fn35() }
tbl17.cache.jj = jj
end

return jj.c
end
end
do -- jk
local function fn35()
local v115 = tbl17.bG()
tbl17.jh()
local v116 = tbl17.bX()
local localPlayer = cloneref(game:GetService("Players")).LocalPlayer

local function fn36(arg)
local v117 = v116(arg)
return v117.LeaderboardRank.Enabled and v117.LeaderboardRank.Value or nil
end

local function fn37()
local localPlayer2 = v115.Data.PlayerSpoofer.LocalPlayer
local value

if localPlayer2.RankedElo.Enabled then
value = localPlayer2.RankedElo.Value
else
value = localPlayer:GetAttribute("DisplayELO")
local n = 0

if type(value) ~= "number" then
value = n
end
end

return { Rank = localPlayer2.LeaderboardRank.Value, Value = value }
end

return {
recompute = function(arg)
local playerSpoofer = v115.Data.PlayerSpoofer

if playerSpoofer.LocalPlayer.LeaderboardRank.Enabled or playerSpoofer.OtherPlayers.LeaderboardRank.Enabled then
arg:Set(fn36)
else
arg:Unset()
end

if playerSpoofer.LocalPlayer.LeaderboardRank.Enabled then
arg:SetBoardEntry(fn37)
else
arg:UnsetBoardEntry()
end

arg:TriggerRefresh()
end,
destroy = function(arg)
arg:Unset()
arg:UnsetBoardEntry()
arg:TriggerRefresh()
end,
}
end

tbl17.jk = function()
local jk = tbl17.cache.jk

if not jk then
local jk2 = { c = fn35() }
tbl17.cache.jk = jk2
jk = jk2
end

return jk.c
end
end
do -- jl
local function fn35()
local index2 = {}
index2.__index = index2

local function fn36(arg)
return arg.Value
end

local function fn37(arg, value)
arg.Value = value
end

index2.new = function(arg)
local tbl18 = { _instance = arg, _original = fn36(arg), _isWriting = false, _connection = nil }
setmetatable(tbl18, index2)
tbl18:_Initialize()
return tbl18
end

index2._Initialize = function(arg)
local instance = arg._instance

arg._connection = instance:GetPropertyChangedSignal("Value"):Connect(function()
if arg._isWriting then
return
end
arg._original = fn36(instance)
arg._isWriting = true
local spoofed = arg._spoofed

if spoofed ~= nil then
fn37(instance, spoofed.Value)
end

arg._isWriting = v86[153]
end)
end

index2.Set = function(arg, spoofed)
arg._spoofed = spoofed
arg._isWriting = true

if spoofed ~= nil then
fn37(arg._instance, spoofed.Value)
else
fn37(arg._instance, arg._original)
end

arg._isWriting = v86[153]
end

index2.Destroy = function(arg)
arg._connection:Disconnect()
fn37(arg._instance, arg._original)
end

return index2
end

tbl17.jl = function()
local jl = tbl17.cache.jl

if not jl then
jl = { c = fn35() }
tbl17.cache.jl = jl
end

return jl.c
end
end
do -- jm
local function fn35()
local v115 = tbl17.jl()
tbl17.bK()
local v116 = tbl17.k()
local v117 = tbl17.bW()
local v118 = tbl17.bX()
local v119 = tbl17.aR()
local index2 = {}
index2.__index = index2

index2.new = function(arg)
local tbl18 = { _trove = v116.new(), _playerRegistry = arg, _entryByPlayer = {} }
setmetatable(tbl18, index2)
tbl18:_Initialize()
return tbl18
end

index2._Initialize = function(arg)
arg._trove:Add(arg._playerRegistry:ObservePlayers(function(arg2)
arg:_Watch(arg2)
end, function(arg2)
arg:_Cleanup(arg2)
end))
end

index2.RefreshScope = function(arg, arg2)
v117(arg2, function(arg3)
arg:_Apply(arg3)
end)
end

index2._Watch = function(arg, arg2)
if arg._entryByPlayer[arg2] ~= nil then
return
end
local tbl18 = { Trove = v116.new(), Guarded = nil }
arg._entryByPlayer[arg2] = tbl18

tbl18.Trove:Add(task.spawn(function()
local v120 = v119(arg2, { "CustomLeaderstats", "Current ELO" })
tbl18.Guarded = tbl18.Trove:Add(v115.new(v120))
arg:_Apply(arg2)
end))
end

index2._Apply = function(arg, arg2)
local v120 = arg._entryByPlayer[arg2]
if v120 == nil or v120.Guarded == nil then
return
end
local rankedElo = v118(arg2).RankedElo

if rankedElo.Enabled then
v120.Guarded:Set({ Value = rankedElo.Value })
else
v120.Guarded:Set(nil)
end
end

index2._Cleanup = function(arg, arg2)
local v120 = arg._entryByPlayer[arg2]
if v120 == nil then
return
end
arg._entryByPlayer[arg2] = nil
v120.Trove:Destroy()
end

index2.Destroy = function(arg)
for _, v120 in arg._entryByPlayer, nil, nil do
v120.Trove:Destroy()
end

arg._entryByPlayer = {}
arg._trove:Destroy()
end

return index2
end

tbl17.jm = function()
local jm = tbl17.cache.jm

if not jm then
jm = { c = fn35() }
tbl17.cache.jm = jm
end

return jm.c
end
end
do -- jn
local function fn35()
local v115 = tbl17.bG()
tbl17.d9()
local v116 = tbl17.bX()

local function fn36(arg)
local v117 = v116(arg.Player)

if v117.Level.Enabled then
arg.Data.Level = v117.Level.Value
end

if v117.CasualWins.Enabled then
arg.Data.CasualWins = v117.CasualWins.Value
end

if v117.RankedWins.Enabled then
arg.Data.RankedWins = v117.RankedWins.Value
end

if v117.CasualWinPercent.Enabled then
arg.Data.CasualWinPercent = v117.CasualWinPercent.Value / 100
end

if v117.RankedWinPercent.Enabled then
arg.Data.RankedWinPercent = v117.RankedWinPercent.Value / v86[91]
end

if v117.RankedElo.Enabled then
arg.Data.RankedCurrentELO = v117.RankedElo.Value
end

if v117.FavoriteMap.Enabled then
arg.Data.FavoriteMap = v117.FavoriteMap.Value
end
end

local function fn37(arg)
return arg.Level.Enabled or arg.CasualWins.Enabled or arg.RankedWins.Enabled or arg.CasualWinPercent.Enabled or arg.RankedWinPercent.Enabled or arg.RankedElo.Enabled or arg.FavoriteMap.Enabled
end

return {
bind = function(arg)
arg:SetHandler(fn36)
end,
recompute = function(arg)
local playerSpoofer = v115.Data.PlayerSpoofer
arg:SetEnabled(fn37(playerSpoofer.LocalPlayer) or fn37(playerSpoofer.OtherPlayers))
end,
}
end

tbl17.jn = function()
local jn = tbl17.cache.jn

if not jn then
local jn2 = { c = fn35() }
tbl17.cache.jn = jn2
jn = jn2
end

return jn.c
end
end
do -- jo
local function fn35()
local v115 = tbl17.bG()
tbl17.dR()
local seasonLibrary = tbl17.aS().SeasonLibrary

local function fn36(arg)
local original = arg:GetOriginal("Seasons")
local currentSeason = v102(seasonLibrary, "CurrentSeason")
if type(original) ~= "table" or currentSeason == nil then
return original
end
local name = v102(currentSeason, "Name")
local universalEloName = v102(seasonLibrary, "UNIVERSAL_ELO_NAME")
local currentELO = v115.Data.PlayerSpoofer.LocalPlayer.RankedElo.Value
local v116 = table.clone(original)
local v117 = v102(v116, name)
local v118 = (v117 ~= nil and { (table.clone(v117)) } or { {} })[v86[63]]
local rankedPerformances = v102(v118, "RankedPerformances")
local v119 = (rankedPerformances ~= nil and { (table.clone(rankedPerformances)) } or { {} })[1]
local v120 = v102(v119, universalEloName)
local v121 = (v120 ~= nil and { (table.clone(v120)) } or { {} })[1]
v121.CurrentELO = currentELO
v119[universalEloName] = v121
v118.RankedPerformances = v119
v116[name] = v118
return v116
end

return {
recompute = function(arg)
if v115.Data.PlayerSpoofer.LocalPlayer.RankedElo.Enabled then
arg:Set("Seasons", function()
return fn36(arg)
end)
else
arg:Unset("Seasons")
end

arg:TriggerDataChangedSignal("Seasons")
end,
destroy = function(arg)
arg:Unset("Seasons")
arg:TriggerDataChangedSignal("Seasons")
end,
}
end

tbl17.jo = function()
local jo = tbl17.cache.jo

if not jo then
local jo2 = { c = fn35() }
tbl17.cache.jo = jo2
jo = jo2
end

return jo.c
end
end
do -- jp
local function fn35()
tbl17.dR()
tbl17.jh()
tbl17.bK()
tbl17.d9()
local v115 = tbl17.k()
local v116 = tbl17.bY()
local v117 = tbl17.jj()
local v118 = tbl17.jk()
local v119 = tbl17.jm()
local v120 = tbl17.jn()
local v121 = tbl17.jo()
local index2 = {}
index2.__index = index2

local tbl18 = {
"Winstreak",
"Level",
"CasualWins",
"RankedWins",
"CasualWinPercent",
"RankedWinPercent",
"RankedElo",
"FavoriteMap",
}

local tbl19 = { "NametagStatus", "Influencer", "RobloxEmployee", "NosniyTeam" }

index2.new = function(arg, arg2, arg3, arg4)
local statSpoofer = v115.new("player_spoofer.stat_spoofer")

local tbl20 = {
_trove = statSpoofer,
_attributeSink = statSpoofer:Add(v117.new(arg)),
_leaderstatSink = statSpoofer:Add(v119.new(arg)),
_leaderboardRankHook = arg4,
_requestBinding = arg2,
_dataHook = arg3,
}

setmetatable(tbl20, index2)
v120.bind(arg2)
statSpoofer:Add(arg2)

statSpoofer:Add(function()
v121.destroy(arg3)
end)

statSpoofer:Add(function()
v118.destroy(arg4)
end)

tbl20:_Initialize()
return tbl20
end

index2._Initialize = function(arg)
for _, v122 in tbl18, nil, nil do
v116(arg._trove, v122, function(arg2)
v120.recompute(arg._requestBinding)
arg._attributeSink:RefreshScope(arg2)
end)
end

v116(arg._trove, "RankedElo", function(arg2)
arg._leaderstatSink:RefreshScope(arg2)

if arg2 == "LocalPlayer" then
v121.recompute(arg._dataHook)
v118.recompute(arg._leaderboardRankHook)
end
end)

v116(arg._trove, "LeaderboardRank", function()
v118.recompute(arg._leaderboardRankHook)
end)

for _, v122 in tbl19, nil, nil do
v116(arg._trove, v122, function(arg2)
arg._attributeSink:RefreshScope(arg2)
end)
end

v120.recompute(arg._requestBinding)
v121.recompute(arg._dataHook)
v118.recompute(arg._leaderboardRankHook)
end

index2.Destroy = function(arg)
arg._trove:Destroy()
end

return index2
end

tbl17.jp = function()
local jp = tbl17.cache.jp

if not jp then
local jp2 = { c = fn35() }
tbl17.cache.jp = jp2
jp = jp2
end

return jp.c
end
end
do -- jq
local function fn35()
local v115 = tbl17.a()
local v116 = tbl17.b2()
local v117 = tbl17.ad()
local utility = tbl17.aS().Utility
local localPlayer = cloneref(game:GetService("Players")).LocalPlayer
local tbl18 = { Low = { 150, 160 }, Medium = { 60, 75 }, High = { 17, 25 } }

local function fn36(arg)
return {
LocalPlayer = { GetNetworkPing = function()
return arg:_RandomPing()
end },
}
end

local index2 = {}
index2.__index = index2

index2.new = function()
return setmetatable({ _pingType = nil, _errorReporter = v117.new(), _loadFailure = nil, _restore = nil }, index2)
end

index2.Destroy = function(arg)
arg:Revert()
arg._errorReporter:Destroy()
end

index2._Load = function(arg)
if arg._restore ~= nil then
return v115.VoidOk
end
local v118 = getmetatable(utility)
if v118 == nil then
return v115.err("LocalPingHook", "metatable_lookup", "Utility metatable unavailable")
end
local v119 = v102(v118, "__index")
if type(v119) ~= "table" then
return v115.err("LocalPingHook", "index_lookup", "Utility __index unavailable")
end
local getLocalConnectionPing = v102(v119, "GetLocalConnectionPing")
if type(getLocalConnectionPing) ~= "function" then
return v115.err("LocalPingHook", "function_lookup", "GetLocalConnectionPing not found")
end
local v120 = nil
local v121 = nil

for k, v122 in debug.getupvalues(getLocalConnectionPing) do
if not (typeof(v122) ~= "Instance" or not v116(v122, game:GetService("Players"))) then
v120 = k
v121 = v122
end
end

if v120 == nil or v121 == nil then
return v115.err("LocalPingHook", "upvalue_lookup", "Players not found in GetLocalConnectionPing")
end
debug.setupvalue(getLocalConnectionPing, v120, fn36(arg))
arg._restore = { Fn = getLocalConnectionPing, Index = v120, Original = v121 }
return v115.VoidOk
end

index2.Revert = function(arg)
local restore = arg._restore
if restore == nil then
return
end
arg._restore = nil
debug.setupvalue(restore.Fn, restore.Index, restore.Original)
end

index2.EnsureLoaded = function(arg)
if arg._restore ~= nil then
return v115.VoidOk
end
local loadFailure = arg._loadFailure
if loadFailure ~= nil then
return loadFailure
end
local v118 = arg._errorReporter:ReportResult(arg:_Load())

if not v118.Ok then
arg._loadFailure = v118
end

return v118
end

index2.Set = function(arg, pingType)
arg._pingType = pingType
end

index2._RandomPing = function(arg)
local pingType = arg._pingType
if pingType == nil then
return localPlayer:GetNetworkPing()
end
local v118 = tbl18[pingType]
return math.random(v118[v86[63]], v118[2]) / 1000
end

return index2
end

tbl17.jq = function()
local jq = tbl17.cache.jq

if not jq then
local jq2 = { c = fn35() }
tbl17.cache.jq = jq2
jq = jq2
end

return jq.c
end
end
do -- jr
local function fn35()
local v115 = tbl17.bG()
local v116 = tbl17.jq()
tbl17.a()
local v117 = tbl17.k()
local v118 = tbl17.bY()
local index2 = {}
index2.__index = index2

index2.new = function()
local v119 = v117.new()
local tbl18 = { _trove = v119, _pingHook = v119:Add(v116.new()) }
setmetatable(tbl18, index2)
tbl18:_Initialize()
return tbl18
end

index2._Initialize = function(arg)
local function fn36()
local ping = v115.Data.PlayerSpoofer.LocalPlayer.Ping
arg._pingHook:Set(ping.Value)
if not ping.Enabled then
arg:_Revert()
return
end

if not arg:_Load().Ok then
return
end
end

v118(arg._trove, "Ping", fn36, { "LocalPlayer" })
fn36()
end

index2._Load = function(arg)
return arg._pingHook:EnsureLoaded()
end

index2._Revert = function(arg)
arg._pingHook:Revert()
end

index2.Destroy = function(arg)
arg._trove:Destroy()
end

return index2
end

tbl17.jr = function()
local jr = tbl17.cache.jr

if not jr then
jr = { c = fn35() }
tbl17.cache.jr = jr
end

return jr.c
end
end
do -- js
local function fn35()
local v115 = tbl17.bG()
tbl17.dR()
local v116 = tbl17.k()
local data = v115.Data
local index2 = {}
index2.__index = index2

index2.new = function(arg)
local v117 = v116.new()

if not (n25 > 3887) then
local keys = data.PlayerSpoofer.LocalPlayer.Keys
local tbl18 = { _trove = v117, _dataHook = arg, _enabled = false, _keys = keys.Value }
setmetatable(tbl18, index2)

v117:Connect(v115:GetPropertyChangedSignal({ "PlayerSpoofer", "LocalPlayer", "Keys", v86[44] }), function(arg2)
tbl18:_SetEnabled(arg2)
end)

v117:Connect(v115:GetPropertyChangedSignal({ "PlayerSpoofer", "LocalPlayer", "Keys", "Value" }), function(arg2)
tbl18:_SetKeys(arg2)
end)

tbl18:_SetEnabled(keys.Enabled)
return tbl18
end
return nil

-- (anti-tamper freeze trap removed)
end

index2._SetEnabled = function(arg, enabled)
if enabled == arg._enabled then
return
end
arg._enabled = enabled

if enabled then
arg._dataHook:Set("WeaponKeys", function()
return arg._keys
end)
else
arg._dataHook:Unset("WeaponKeys")
end

arg._dataHook:TriggerDataChangedSignal("WeaponKeys")
end

index2._SetKeys = function(arg, keys)
arg._keys = keys
end

index2.Destroy = function(arg)
arg:_SetEnabled(false)
arg._trove:Destroy()
end

return index2
end

tbl17.js = function()
local js = tbl17.cache.js

if not js then
local js2 = { c = fn35() }
tbl17.cache.js = js2
js = js2
end

return js.c
end
end
do -- jt
local function fn35()
local v115 = tbl17.bG()
tbl17.dR()
local v116 = tbl17.k()
local data = v115.Data
local index2 = {}
index2.__index = index2

index2.new = function(arg)
local v117 = v116.new()
local eventCurrency = data.PlayerSpoofer.LocalPlayer.EventCurrency
local tbl18 = { _trove = v117, _dataHook = arg, _enabled = false, _eventCurrency = eventCurrency.Value }
setmetatable(tbl18, index2)

v117:Connect(v115:GetPropertyChangedSignal({ "PlayerSpoofer", "LocalPlayer", "EventCurrency", v86[44] }), function(arg2)
tbl18:_SetEnabled(arg2)
end)

v117:Connect(v115:GetPropertyChangedSignal({ "PlayerSpoofer", "LocalPlayer", "EventCurrency", "Value" }), function(arg2)
tbl18:_SetEventCurrency(arg2)
end)

tbl18:_SetEnabled(eventCurrency.Enabled)
return tbl18
end

index2._SetEnabled = function(arg, enabled)
if enabled == arg._enabled then
return
end
arg._enabled = enabled

if enabled then
arg._dataHook:Set("EventCurrency", function()
return arg._eventCurrency
end)
else
arg._dataHook:Unset("EventCurrency")
end

arg._dataHook:TriggerDataChangedSignal("EventCurrency")
end

index2._SetEventCurrency = function(arg, eventCurrency)
arg._eventCurrency = eventCurrency
end

index2.Destroy = function(arg)
arg:_SetEnabled(false)
arg._trove:Destroy()
end

return index2
end

tbl17.jt = function()
local jt = tbl17.cache.jt

if not jt then
jt = { c = fn35() }
tbl17.cache.jt = jt
end

return jt.c
end
end
do -- ju
local function fn35()
local v115 = tbl17.bG()
tbl17.cX()
local v116 = tbl17.k()
local v117 = tbl17.b3()
local v118 = cloneref(game:GetService("Workspace"))
local tbl18 = { "Movement", "LongJump", "Keybind", "State" }
local index2 = {}
index2.__index = index2

index2.new = function(arg)
local v119 = v116.new()
local tbl19 = { _trove = v119, _playerContext = arg }
setmetatable(tbl19, index2)

v119:Connect(v115:GetPropertyChangedSignal(tbl18), function(arg2)
tbl19:_OnStateChanged(arg2)
end)

return tbl19
end

index2._OnStateChanged = function(arg, arg2)
if not arg2 then
return
end

task.defer(function()
v115:Set(tbl18, false)
end)

if not v115.Data.Movement.LongJump.Enabled then
return
end
arg:_Launch()
end

index2._Launch = function(arg)
local inner = arg._playerContext.Inner
if inner == nil then
return
end
local fighterState = inner.FighterState
local state = fighterState.Character.State
if not state.Alive then
return
end
local entity = fighterState:GetEntity()
if entity == nil then
return
end
local longJump = v115.Data.Movement.LongJump
local lookVector = v118.CurrentCamera.CFrame.LookVector
local vector = Vector3.new(lookVector.X, v86[186], lookVector.Z)

if vector.Magnitude < 0.001 then
local lookVector2 = state.RootPart.CFrame.LookVector
vector = Vector3.new(lookVector2.X, 0, lookVector2.Z)
end

local unit = vector.Unit

if longJump.Mode == "Under Feet" then
unit = (unit * longJump.Behind + Vector3.new(0, 4, 0)).Unit
end

local n = unit * longJump.Force + Vector3.new(v86[186], longJump.UpwardVelocity, 0)
v117(entity.AirborneCancel, entity)
v117(entity.AirborneTrigger, entity, n, 4)
end

index2.Destroy = function(arg)
arg._trove:Destroy()
end

return index2
end

tbl17.ju = function()
local ju = tbl17.cache.ju

if not ju then
local ju2 = { c = fn35() }
tbl17.cache.ju = ju2
ju = ju2
end

return ju.c
end
end
do -- jv
local function fn35()
local tbl18

tbl18 = {
DirectionToOrientation = function(l)local I,W=CFrame.lookAt(Vector3.zero,l):ToOrientation();return I,W;end,
OrientationLookingAt = function(I,W)return  tbl18 .DirectionToOrientation(W-I);end,
}

return tbl18
end

tbl17.jv = function()
local jv = tbl17.cache.jv

if not jv then
local jv2 = { c = fn35() }
tbl17.cache.jv = jv2
jv = jv2
end

return jv.c
end
end
do -- jw
local function fn35()
local v115 = tbl17.cn()
local v116 = tbl17.co()
local v117 = tbl17.jv()
local set = tbl17.cp().set
local v118 = tbl17.bG()
tbl17.c_()
tbl17.cF()
local v119 = tbl17.c4()
tbl17.cX()
tbl17.cE()
local v120 = tbl17.cd()
local v121 = tbl17.dc()
local v122 = tbl17.ci()
local v123 = tbl17.k()
local v124 = tbl17.aH()
local v125 = tbl17.de()
local v126 = tbl17.df()
local v127 = tbl17.dg()
local v128 = cloneref(game:GetService("Workspace"))
local data = v118.Data
local index2 = {}
index2.__index = index2

local function fn36(arg)
local v129 = v128.CurrentCamera:WorldToViewportPoint(arg.Position)
return v129.Z > 0 and Vector2.new(v129.X, v129.Y) or nil
end

index2.new = function(arg, arg2, arg3)
local flickbot = v123.new("flickbot")
local aimbot = data.Aimbot
local v129 = v121.new(arg2, arg, aimbot.TargetConditions, aimbot.TargetHitboxes[v124.DefaultProfile.Class], function(I,W)return( arg3 :Check(I,W,W.Parent));end)

local tbl18 = {
_trove = flickbot,
_playerContext = arg2,
_targetSelection = v122.new(v129, v115.buildMeasure(aimbot.Fov.Radius, aimbot.TargetConditions.WithinFov), v126),
_state = "Idle",
_selected = nil,
_trajectory = nil,
_trajectoryIndex = v86[63],
_elapsedMs = 0,
_totalMs = 0,
_bakedEndDirection = Vector3.zAxis,
_timer = 0,
_isEnabledHeld = v86[153],
}

setmetatable(tbl18, index2)

flickbot:Add(v119:ObserveEnabledKeybind({ "Flickbot" }, function(arg4)
tbl18:_OnKeybindChanged(arg4)
end))

local v130 = v125(arg2, flickbot, "features.Aimbot", v129, function() return data.Aimbot.TargetHitboxes end)
local function fn37(selection) tbl18._targetSelection:SetHitboxSelectionMode(v115.buildHitboxSelectionMode(selection)) end
flickbot:Connect(v118:GetPropertyChangedSignal({ "Aimbot", "Fov" }), function(f) tbl18._targetSelection:SetMeasure(v115.buildMeasure(f.Radius, data.Aimbot.TargetConditions.WithinFov)) end)
flickbot:Connect(v118:GetPropertyChangedSignal({ "Aimbot", "TargetConditions" }), function(c)
v129:SetConditions(c)
tbl18._targetSelection:SetMeasure(v115.buildMeasure(data.Aimbot.Fov.Radius, c.WithinFov))
end)
flickbot:Connect(v118:GetPropertyChangedSignal({ "Aimbot", "TargetHitboxes" }), v130)
flickbot:Connect(v118:GetPropertyChangedSignal({ "Aimbot", "HitboxSelection" }), fn37)
fn37(aimbot.HitboxSelection)
v130()
return tbl18
end

index2._OnKeybindChanged = function(arg, arg2)
if not arg2 then
arg._isEnabledHeld = false
return
end

if arg._isEnabledHeld then
return
end
arg._isEnabledHeld = true
if arg._state ~= "Idle" then
return
end
arg:_StartFlick()
end

index2._StartFlick = function(arg)
local currentCamera = v128.CurrentCamera
local v129, v130 = arg._targetSelection:SelectBest(nil)
if v129 == nil or v130 == nil then
return
end
local selected = { Target = v129, Part = v130 }
local v131 = fn36(v130)
if v131 == nil then
return
end
local v132 = v127()
local v133 = v120.new()
local flickbot = v118.Data.Flickbot
v133:ApplyFlickProfile({ DurationMs = flickbot.FlickDuration, Curvature = flickbot.Curvature, Humanness = flickbot.Humanness })
local trajectory = {}

for k, v134 in v133:Generate(v132.X, v132.Y, v131.X, v131.Y), nil, nil do
trajectory[k] = { Direction = currentCamera:ViewportPointToRay(v134.X, v134.Y).Direction, T = v134.T }
end

arg._trajectory = trajectory
arg._trajectoryIndex = 1
arg._elapsedMs = v86[186]
arg._totalMs = trajectory[#trajectory].T
arg._bakedEndDirection = trajectory[#trajectory].Direction
arg._selected = selected
arg._state = "Flicking"
v116.claim("Flickbot", 10)
end

index2._FinishToCooldown = function(arg)
arg._selected = nil
arg._trajectory = nil
v116.release("Flickbot")
local cooldown = v118.Data.Flickbot.Cooldown

if cooldown > 0 then
arg._state = "Cooldown"
arg._timer = cooldown / 1000
else
arg._state = "Idle"
end
end

index2._SampleTrajectory = function(arg, arg2, arg3)
arg._elapsedMs = arg._elapsedMs + arg3 * 1000
local trajectoryIndex = arg._trajectoryIndex

while trajectoryIndex < #arg2 and arg2[trajectoryIndex + 1].T <= arg._elapsedMs do
trajectoryIndex += 1
end

arg._trajectoryIndex = trajectoryIndex
local v129 = arg2[trajectoryIndex]
local v130 = arg2[trajectoryIndex + 1]
if v130 == nil then
return arg2[#arg2].Direction, true
end
local n = v130.T - v129.T
local n33 = 1

if n > 0 then
n33 = math.clamp((arg._elapsedMs - v129.T) / n, 0, 1)
end

return v129.Direction:Lerp(v130.Direction, n33), false
end

index2.Update = function(arg, arg2)
local state = arg._state

if state == "Flicking" then
local selected = arg._selected
local trajectory = arg._trajectory

if selected == nil or trajectory == nil then
arg:_FinishToCooldown()
if not flag2 then
return
end
return
end

if selected.Part.Parent == nil then
arg:_FinishToCooldown()
return
end
local unit, v129 = arg:_SampleTrajectory(trajectory, arg2)

if v86[186] < arg._totalMs then
unit = (unit + ((selected.Part.Position - v128.CurrentCamera.CFrame.Position).Unit - arg._bakedEndDirection) * math.clamp(arg._elapsedMs / arg._totalMs, 0, 1)).Unit
end

local v130, v131 = v117.DirectionToOrientation(unit)
set(Vector2.new(v130, v131))

if v129 then
local flickbot = v118.Data.Flickbot

if flickbot.Shoot then
arg._state = "PostShot"
arg._timer = flickbot.ShotDelay / 1000
else
arg:_FinishToCooldown()
end
end
elseif state == "PostShot" then
arg._timer = arg._timer - arg2

if arg._timer <= 0 then
arg:_FireShot()
arg:_FinishToCooldown()
end
elseif state == "Cooldown" then
arg._timer = arg._timer - arg2

if arg._timer <= 0 then
arg._state = "Idle"
end
end
end

index2._FireShot = function(arg)
local inner = arg._playerContext.Inner
if inner == nil then
return
end
inner.FighterState:Input("StartShooting")
end

index2.Destroy = function(arg)
v116.release("Flickbot")
arg._trove:Destroy()
end

return index2
end

tbl17.jw = function()
local jw = tbl17.cache.jw

if not jw then
jw = { c = fn35() }
tbl17.cache.jw = jw
end

return jw.c
end
end
do -- jy
local function fn35()
tbl17.cF()
tbl17.jx()

local function fn36(arg)
local itemObserver = arg.ItemObserver
local equippedItem = itemObserver:GetEquippedItem()

if equippedItem ~= nil and equippedItem.Name == "Riot Shield" then
local v115 = math.deg(arg:GetCameraRotation().X)
if v115 > 22 and v115 < 91 then
return "Below"
end
return "Above"
end

for _, v115 in itemObserver:GetItems() do
if v115.Name == "Riot Shield" then
local v116 = math.deg(arg:GetCameraRotation().X)
if v116 > 315 and v116 < 360 or v116 > 0 and v116 < 91 then
return "Above"
end
return "Below"
end
end

return v86[75]
end

if not flag2 then
return
end
return fn36
end

tbl17.jy = function()
local jy = tbl17.cache.jy

if not jy then
local jy2 = { c = fn35() }
tbl17.cache.jy = jy2
jy = jy2
end

return jy.c
end
end
do -- jz
local function fn35()
tbl17.cE()
tbl17.jx()
tbl17.cI()
local v115 = tbl17.jy()
local v116 = Random.new()

return {
getDefensiveCFrame = function(arg, arg2, arg3, arg4)
if arg2 == "Equipped" then
return CFrame.new(arg.Position, arg4.Position)
end

if arg2 == "Unequipped" then
return CFrame.new(arg.Position, arg.Position + arg.Position - arg4.Position)
end
local v117 = arg3.ItemObserver:EquippedItemAsMelee()

if v117 ~= nil and v117.Name == "Knife" then
local cframe = CFrame.fromOrientation
local nextNumber = v116.NextNumber
local tau = math.tau
return CFrame.new(arg.Position) * cframe(v116:NextNumber(0, math.tau), v116:NextNumber(0, math.tau), nextNumber(v116, 0, tau))
end

return arg
end,
getDefensiveViewAngles = function(arg, arg2)
if arg == "None" then
return nil
end

return {
Kind = "Normalized",
Pitch = (arg == "Equipped") ~= (v115(arg2) ~= "Below") and v86[45] or -90,
Yaw = v116:NextNumber(0, 360),
}
end,
}
end

tbl17.jz = function()
local jz = tbl17.cache.jz

if not jz then
jz = { c = fn35() }
tbl17.cache.jz = jz
end

return jz.c
end
end
do -- jA
local function fn35()
local index2 = {}
index2.__index = index2

index2.new = function()
return setmetatable({}, index2)
end

index2.ShouldFire = function(arg, arg2, arg3)
local now2 = os.clock()
local lockedUntil = arg._lockedUntil
local flag19 = lockedUntil ~= nil and now2 < lockedUntil

if arg2 then
arg._lockedUntil = now2 + arg3
end

return flag19 or arg2
end

index2.Reset = function(arg)
arg._lockedUntil = nil
end

return index2
end

tbl17.jA = function()
local ja = tbl17.cache.jA

if not ja then
local ja2 = { c = fn35() }
tbl17.cache.jA = ja2
ja = ja2
end

return ja.c
end
end
do -- jB
local function fn35()
tbl17.cr()
local v115 = tbl17.bG()
tbl17.cF()
tbl17.bM()

local function fn36(arg)
if not arg.IsEnemy or arg:IsInvincible() then
return false
end

if not arg.Character.State.Alive then
return false
end
local v116 = arg.ItemObserver:EquippedItemAsMelee()
if v116 ~= nil and v116:IsDeflecting() then
return false
end
return true
end

local function fn37(arg)
return { FighterState = arg, AliveState = arg.Character.State }
end

local index2 = {}
index2.__index = index2

index2.new = function(arg, arg2)
return setmetatable({ _fighters = arg, _playerTags = arg2 }, index2)
end

index2.GetTarget = function(arg)
local prioritizeHackers = v115.Data.Ragebot.PrioritizeHackers

if prioritizeHackers then
for _, v116 in arg._playerTags:GetPlayersWith("Hacker") do
local v117 = arg._fighters.StateByPlayer[v116]
if v117 ~= nil and fn36(v117) then
return fn37(v117)
end
end
end

for k, v116 in arg._fighters.EnemyByPlayer, nil, nil do
if prioritizeHackers and arg._playerTags:Has(k, "Hacker") then
continue
end

if fn36(v116) then
return fn37(v116)
end
end

return nil
end

index2.HasTargets = function(arg)
for _, v116 in arg._fighters.EnemyByPlayer, nil, nil do
if fn36(v116) then
return true
end
end

return v86[153]
end

index2.IsSameTarget = function(arg, arg2)
return arg.FighterState == arg2.FighterState and arg.AliveState == arg2.AliveState
end

return index2
end

tbl17.jB = function()
local jb = tbl17.cache.jB

if not jb then
jb = { c = fn35() }
tbl17.cache.jB = jb
end

return jb.c
end
end
do -- jC
local function fn35()
local vector = Vector3.new(0, -v86[63], 0)
local vector2 = Vector3.new(0, 0, -v86[63])

return function(arg, arg2)
local n = arg2 - arg
local vector3 = Vector3.new(n.X, v86[186], n.Z)

if vector3.Magnitude < 0.001 then
vector3 = vector2
end

return CFrame.lookAt(arg, arg + vector3, vector)
end
end

tbl17.jC = function()
local jc = tbl17.cache.jC

if not jc then
jc = { c = fn35() }
tbl17.cache.jC = jc
end

return jc.c
end
end
do -- jD
local function fn35()
local v115 = tbl17.bG()
tbl17.cR()
tbl17.gA()
local v116 = tbl17.jA()
tbl17.jB()
local v117 = tbl17.jy()
local v118 = tbl17.jC()
local vector = Vector3.new(0, -0.7, 0.05)
local vector2 = Vector3.new(0, -3.85, 0.05)

local tbl18 = {
["\0"] = -9e37,
["\1"] = 0,
["\2"] = v86[186],
["\3"] = -1.5707963267948966,
["\4"] = 3.1415926535897931,
["\5"] = 3.1415926535897931,
}

local tbl19 = {
["\0"] = v86[186],
["\1"] = -90000000,
["\2"] = 0,
["\3"] = -1.5707963267948966,
["\4"] = 3.1415926535897931,
["\5"] = 3.1415926535897931,
}

local tbl20 = {
["\0"] = -9e37,
["\1"] = v86[186],
["\2"] = 0,
["\3"] = 1.5707963267948966,
["\4"] = 3.1415926535897931,
["\5"] = 3.1415926535897931,
}

local tbl21 = {
["\0"] = 0,
["\1"] = 90000000,
["\2"] = 0,
["\3"] = 1.5707963267948966,
["\4"] = 3.1415926535897931,
["\5"] = 3.1415926535897931,
}

local tbl22 = { ["\0"] = 0, ["\1"] = 1, ["\2"] = v86[186], ["\3"] = v86[186], ["\4"] = 0, ["\5"] = 0 }
local index2 = {}
index2.__index = index2

index2.new = function(arg)
return setmetatable({ _partGlue = arg, _shootLock = v116.new() }, index2)
end

index2.Plan = function(arg, arg2, arg3, arg4, arg5, arg6)
local hitboxHead = arg3.AliveState.HitboxHead
local flag19 = v117(arg3.FighterState) ~= "Below"
local ragebot = v115.Data.Ragebot
local v119 = flag19 and vector or vector2
local v120 = arg._partGlue:Acquire(arg5, hitboxHead)
local n

if flag19 then
n = v120 + v119
else
n = v118(v120.Position + v119, hitboxHead.Position)
end

if not arg._shootLock:ShouldFire(arg6, arg2 * ragebot.ShootFrames) then
local random2 = math.random
return CFrame.new(math.random(-1000000, 1000000), math.random(5000, 10000), random2(-1000000, 1000000)), nil
end
local v121 = (flag19 and { tbl18 } or { tbl20 })[1]
local v122 = (flag19 and { tbl19 } or { tbl21 })[v86[63]]

return n, function()
arg4:ShootEncoded(v121, v122, hitboxHead, tbl22)
end
end

return index2
end

tbl17.jD = function()
local jd = tbl17.cache.jD

if not jd then
local jd2 = { c = fn35() }
tbl17.cache.jD = jd2
jd = jd2
end

return jd.c
end
end
do -- jE
local function fn35()
tbl17.cJ()
local v115 = tbl17.bG()
tbl17.cS()
tbl17.gA()
local v116 = tbl17.jA()
tbl17.jB()
local v117 = tbl17.jy()
local v118 = tbl17.jC()
local vector = Vector3.new(0, -v86[195], 0.05)
local vector2 = Vector3.new(v86[186], -3.85, 0.05)

local tbl18 = {
["\0"] = -9e37,
["\1"] = 0,
["\2"] = 0,
["\3"] = -1.5707963267948966,
["\4"] = 3.1415926535897931,
["\5"] = 3.1415926535897931,
}

local tbl19 = {
["\0"] = 0,
["\1"] = -90000000,
["\2"] = v86[186],
["\3"] = -1.5707963267948966,
["\4"] = 3.1415926535897931,
["\5"] = 3.1415926535897931,
}

local tbl20 = {
["\0"] = -9e37,
["\1"] = 0,
["\2"] = v86[186],
["\3"] = 1.5707963267948966,
["\4"] = 3.1415926535897931,
["\5"] = 3.1415926535897931,
}

local tbl21 = {
["\0"] = 0,
["\1"] = 90000000,
["\2"] = v86[186],
["\3"] = 1.5707963267948966,
["\4"] = 3.1415926535897931,
["\5"] = 3.1415926535897931,
}

local tbl22 = { ["\0"] = 0, ["\1"] = 1, ["\2"] = v86[186], ["\3"] = 0, ["\4"] = 0, ["\5"] = 0 }

local function fn36()
local random2 = math.random
return CFrame.new(math.random(-10000000, -100000), math.random(5000, 10000), random2(-10000000, -100000))
end

local function fn37(arg, arg2)
return { Kind = "Normalized", Pitch = math.deg(arg), Yaw = math.deg(arg2) }
end

local function fn38(arg, arg2, arg3, arg4)
return {
["\0"] = arg["\0"],
["\1"] = arg["\1"],
["\2"] = arg["\2"],
["\3"] = arg2,
["\4"] = arg3,
["\5"] = arg4,
}
end

local index2 = {}
index2.__index = index2

index2.new = function(arg)
return setmetatable({ _partGlue = arg, _shootLock = v116.new(), _hitboxWindowUntil = -1, _attackCooldown = -1 }, index2)
end

index2.Plan = function(arg, arg2, arg3, arg4, gluedOurPart, arg5)
local aliveState = arg3.AliveState
local hitboxHead = aliveState.HitboxHead
local flag19 = v117(arg3.FighterState) ~= "Below"
local ragebot = v115.Data.Ragebot
local v119 = flag19 and vector or vector2
local v120 = arg._partGlue:Acquire(gluedOurPart, hitboxHead)
arg._gluedOurPart = gluedOurPart
local n

if flag19 then
n = v120 + v119
else
n = v118(v120.Position + v119, hitboxHead.Position)
end

local v121, v122, v123 = aliveState.RootPart.CFrame:ToOrientation()
local n33 = flag19 and -1.5707963267948966 or 1.5707963267948966
local v124 = (flag19 and { tbl18 } or { tbl20 })[1]
local v125 = (flag19 and { tbl19 } or { tbl21 })[1]
local v126 = fn38(v124, n33, v122, v123)
local v127 = fn38(v125, n33, v122, v123)
local now2 = os.clock()
if now2 < arg._hitboxWindowUntil then
return n, fn37(v121, v122), function()
arg4:HeavyAttackEncoded(v126, v127, hitboxHead, tbl22)
end
end

if not arg._shootLock:ShouldFire(arg5, arg2 * ragebot.ShootFrames) then
return fn36(), nil, nil
end

if now2 < arg._attackCooldown then
return fn36(), nil, nil
end

if arg4.Name == "Knife" then
arg:_RecordBackstab()

return n, fn37(v121, v122), function()
arg4:HeavyAttackEncoded(v126, v127, hitboxHead, tbl22)
end
end

return n, nil, function()
arg4:AttackEncoded(v126, v127, hitboxHead, tbl22)
end
end

index2._RecordBackstab = function(arg)
local now2 = os.clock()
arg._hitboxWindowUntil = now2 + 0.625
arg._attackCooldown = now2 + 1.25
end

index2.ResetState = function(arg)
arg._hitboxWindowUntil = -1
arg._attackCooldown = -1
arg._shootLock:Reset()
local gluedOurPart = arg._gluedOurPart

if gluedOurPart ~= nil then
arg._partGlue:Free(gluedOurPart)
arg._gluedOurPart = nil
end
end

return index2
end

tbl17.jE = function()
local je = tbl17.cache.jE

if not je then
local je2 = { c = fn35() }
tbl17.cache.jE = je2
je = je2
end

return je.c
end
end
do -- jF
local function fn35()
local v115 = Random.new()

return function(arg, arg2, arg3)
local v116 = v115:NextNumber(0, 6.2831853071795862)
local v117 = v115:NextNumber(arg2, arg3)
local cframe = CFrame.new(arg + Vector3.new(math.cos(v116) * v117, 0, math.sin(v116) * v117))
local nextNumber = v115.NextNumber
return cframe * CFrame.fromOrientation(v115:NextNumber(0, 6.2831853071795862), v115:NextNumber(0, 6.2831853071795862), nextNumber(v115, 0, 6.2831853071795862))
end
end

tbl17.jF = function()
local jf = tbl17.cache.jF

if not jf then
jf = { c = fn35() }
tbl17.cache.jF = jf
end

return jf.c
end
end
do -- jG
local function fn35()
return function(arg, arg2)
local closestPointOnSurface = arg:GetClosestPointOnSurface(arg2)
local n = arg2 - closestPointOnSurface
if n.Magnitude < 1e-06 then
return closestPointOnSurface, nil
end
local n33 = arg:GetClosestPointOnSurface(arg2 + Vector3.xAxis * 0.05) - closestPointOnSurface
local n34 = arg:GetClosestPointOnSurface(arg2 + Vector3.yAxis * 0.05) - closestPointOnSurface
local n35 = arg:GetClosestPointOnSurface(arg2 + Vector3.zAxis * 0.05) - closestPointOnSurface
local n36 = n34:Cross(n33)

if n36.Magnitude < 1e-06 then
n36 = n34:Cross(n35)
end

if n36.Magnitude < 1e-06 then
n36 = n33:Cross(n35)
end

if n36.Magnitude < 1e-06 then
return closestPointOnSurface, nil
end

if n36:Dot(n) < 0 then
n36 = -n36
end

return closestPointOnSurface, n36.Unit
end
end

tbl17.jG = function()
local jg = tbl17.cache.jG

if not jg then
local jg2 = { c = fn35() }
tbl17.cache.jG = jg2
jg = jg2
end

return jg.c
end
end
do -- jH
local function fn35()
local v115 = tbl17.bG()
tbl17.cF()
tbl17.cX()
local v116 = tbl17.k()
local v117 = tbl17.jF()
local v118 = tbl17.jG()
local v119 = cloneref(game:GetService("CollectionService"))
local v120 = Random.new()
local vector = Vector3.new(5, 5, 5)
local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Exclude
overlapParams.FilterDescendantsInstances = {}
overlapParams.BruteForceAllSlow = v86[34]

local function fn36(arg, arg2, arg3)
local unit = arg2.Unit
local n = arg3.Position - arg
local n33 = n - unit * n:Dot(unit)

if n33.Magnitude < 0.0001 then
local lookVector = arg3.CFrame.LookVector
n33 = lookVector - unit * lookVector:Dot(unit)

if n33.Magnitude < 0.0001 then
n33 = Vector3.xAxis - unit * unit:Dot(Vector3.xAxis)
end
end

local unit2 = n33.Unit:Cross(unit).Unit
return { SurfacePosition = arg, Right = unit2, Up = unit, Forward = unit:Cross(unit2).Unit }
end

local function fn37(arg, arg2)
local n = 6.2831853071795862 * arg2
return arg.Min + (arg.Max - arg.Min) * (math.sin(os.clock() * n) + 1) * v86[101]
end

local function fn38()
local projectileBreaker = v115.Data.Ragebot.Evasion.ProjectileBreaker
return fn37(projectileBreaker.DepthUp, projectileBreaker.DepthUpFrequency)
end

local function fn39()
local projectileBreaker = v115.Data.Ragebot.Evasion.ProjectileBreaker
return fn37(projectileBreaker.DepthForward, projectileBreaker.DepthForwardFrequency)
end

local function fn40(arg, arg2, arg3)
return CFrame.fromMatrix(arg.SurfacePosition - arg.Up * 0.01 - arg.Up * arg2 + arg.Forward * arg3, arg.Right, arg.Up, -arg.Forward)
end

local function fn41(arg)
return arg.Name == "Barriers" or arg:HasTag("OutOfBoundsPart") or arg:HasTag("KillBrick")
end

local function fn42(arg)
for _, v121 in workspace:GetPartBoundsInBox(CFrame.new(arg), vector, overlapParams), nil, nil do
if fn41(v121) then
return true
end
end

return false
end

local function fn43(arg)
if arg.Transparency == 1 then
return nil
end
local size = arg.Size
if size.X * size.Y * size.Z < 64 then
return nil
end
local n = size.Magnitude + 1000

for i = 1, v86[175] do
local v121, v122 = v118(arg, arg.Position + v120:NextUnitVector() * n)
if v122 == nil or v122.Y < 0.98 then
continue
end
return fn36(v121, v122, arg)
end

local v121, v122 = v118(arg, arg.Position + Vector3.yAxis * n)
if v122 ~= nil and v122.Y >= 0.98 then
return fn36(v121, v122, arg)
end
return nil
end

local function fn44(arg)
local projectileBreaker = v115.Data.Ragebot.Evasion.ProjectileBreaker
local fallbackBaseRadius = projectileBreaker.FallbackBaseRadius
local n = fallbackBaseRadius + fallbackBaseRadius * projectileBreaker.FallbackRadiusRandomFactor
local position = arg.Position
local v121 = v117(projectileBreaker.FallbackAnchorFromCharacter and position or Vector3.new(v86[186], position.Y, v86[186]), fallbackBaseRadius, n)
local v122 = v120:NextInteger(v86[63], 3)
local position2 = v121.Position
local x = position2.X
local y = position2.Y
local z = position2.Z

if v122 == 1 then
x = 1073741824
elseif v122 == v86[56] then
y = 1073741824
else
z = 1073741824
end

return v121 - position2 + Vector3.new(x, y, z)
end

local index2 = {}
index2.__index = index2

index2.new = function(arg, arg2)
local ProjectileBreakerTeleport = v116.new("ragebot.ProjectileBreakerTeleport")

local tbl18 = {
_trove = ProjectileBreakerTeleport,
_fighters = arg,
_nextPositionCooldown = -v86[63],
_poolEnvironmentId = nil,
_pool = {},
_processedPartSet = {},
}

setmetatable(tbl18, index2)

ProjectileBreakerTeleport:Add(arg2:ObserveContext("ragebot.ProjectileBreakerTeleport", function(arg3, arg4)
tbl18:_BindEnvironment(arg3.FighterState.EnvironmentId)

arg4:Connect(arg3.FighterState.EnvironmentIdChanged, function(arg5)
tbl18:_BindEnvironment(arg5)
end)
end))

ProjectileBreakerTeleport:Connect(arg2.ContextRemoved, function()
tbl18:_BindEnvironment(nil)
end)

return tbl18
end

index2.Destroy = function(arg)
arg._trove:Destroy()
end

index2._BindEnvironment = function(arg, poolEnvironmentId)
arg._poolEnvironmentId = poolEnvironmentId
arg._pool = {}
arg._processedPartSet = {}
end

index2.Compute = function(arg, arg2)
local nextPositionCooldown = arg._nextPositionCooldown

if os.clock() < nextPositionCooldown then
local lastBreakSurface = arg._lastBreakSurface
if lastBreakSurface ~= nil then
return fn40(lastBreakSurface, fn38(), fn39())
end
end

if not arg:_HasProjectileThreat() then
arg._lastBreakSurface = nil
return fn44(arg2)
end
local v121 = arg:_BreakLine()
if v121 ~= nil then
arg._lastBreakSurface = v121
return fn40(v121, fn38(), fn39())
end
return fn44(arg2)
end

index2._HasProjectileThreat = function(arg)
for _, v121 in arg._fighters.EnemyByPlayer, nil, nil do
local v122 = v121.ItemObserver:EquippedItemAsGun()
if v122 ~= nil and not v122.IsRaycast and v122.Name == "Slingshot" then
return true
end
end

return false
end

index2._ScanBatch = function(arg, arg2)
local projectileBreaker = v115.Data.Ragebot.Evasion.ProjectileBreaker
local n = (projectileBreaker.DepthUp.Min + projectileBreaker.DepthUp.Max) * v86[101]
local n33 = (projectileBreaker.DepthForward.Min + projectileBreaker.DepthForward.Max) * 0.5
local v121 = v86[186]

local function fn45(arg3)
if not arg3:IsA("BasePart") or arg._processedPartSet[arg3] then
return
end
arg._processedPartSet[arg3] = true
v121 += 1
local v122 = fn43(arg3)
if v122 == nil then
return
end

if fn42(fn40(v122, n, n33).Position) then
return
end
table.insert(arg._pool, v122)
end

for _, v122 in v119:GetTagged("RaycastWhitelist" .. arg2) do
if fn41(v122) then
continue
end
fn45(v122)
if v121 >= v86[83] or #arg._pool >= 30 then
return
end

for _, v123 in v122:GetDescendants() do
if fn41(v123) then
continue
end
fn45(v123)
if v121 >= 64 or #arg._pool >= v86[192] then
return
end
end
end
end

index2._BreakLine = function(arg)
local poolEnvironmentId = arg._poolEnvironmentId
if poolEnvironmentId == nil then
return nil
end

if #arg._pool < 30 then
arg:_ScanBatch(poolEnvironmentId)
end

if #arg._pool < 30 then
return nil
end
local repositionInterval = v115.Data.Ragebot.Evasion.ProjectileBreaker.RepositionInterval
arg._nextPositionCooldown = os.clock() + repositionInterval
return arg._pool[v120:NextInteger(1, #arg._pool)]
end

index2.ResetState = function(arg)
arg._nextPositionCooldown = -1
arg._lastBreakSurface = nil
end

return index2
end

tbl17.jH = function()
local jh = tbl17.cache.jH

if not jh then
jh = { c = fn35() }
tbl17.cache.jH = jh
end

return jh.c
end
end
do -- jI
local function fn35()
local v115 = tbl17.bG()
local v116 = tbl17.jF()
local v117 = Random.new()

return { compute = function(arg)
local random2 = v115.Data.Ragebot.Evasion.Random
local baseRadius = random2.BaseRadius
local n = baseRadius + baseRadius * random2.RadiusRandomFactor
local position = arg.Position
local v118 = v116(random2.AnchorFromCharacter and position or Vector3.new(0, position.Y, 0), baseRadius, n)
local v119 = v117:NextInteger(v86[63], 3)
local position2 = v118.Position
local x = position2.X
local y = position2.Y
local z = position2.Z

if v119 == 1 then
x = 1073741824
elseif v119 == 2 then
y = 1073741824
else
z = 1073741824
end

return v118 - position2 + Vector3.new(x, y, z)
end }
end

tbl17.jI = function()
local ji = tbl17.cache.jI

if not ji then
ji = { c = fn35() }
tbl17.cache.jI = ji
end

return ji.c
end
end
do -- jJ
local function fn35()
local v115 = tbl17.bG()
tbl17.cF()
tbl17.jB()
local v116 = tbl17.k()

local function fn36(arg)
return math.abs(arg.X) >= 4194304 or math.abs(arg.Y) >= 4194304 or math.abs(arg.Z) >= 4194304
end

local index2 = {}
index2.__index = index2

index2.new = function(arg)
local tbl18 = { _trove = v116.new("ragebot.SpatialLimitGate"), _measurementByFighterState = {} }
setmetatable(tbl18, index2)
tbl18:_Initialize(arg)
return tbl18
end

index2._Initialize = function(arg, arg2)
arg._trove:Add(arg2:ObserveRemoteStates(function(arg3)
arg._measurementByFighterState[arg3] = { ExpectedDuration = 1 }
end, function(arg3)
arg._measurementByFighterState[arg3] = nil
end))
end

index2.Tick = function(arg, arg2)
local now2 = os.clock()
local fighterState = arg2.FighterState
local v117 = arg._measurementByFighterState[fighterState]
local limitEntryTime = v117.LimitEntryTime
local flag19 = fighterState.ItemObserver:GetEquippedAmmoState() ~= false

if not fn36(arg2.AliveState.RootPart.Position) then
if limitEntryTime ~= nil then
if flag19 then
v117.ExpectedDuration = now2 - limitEntryTime
end

v117.LimitEntryTime = nil
end

return false
end

if limitEntryTime == nil then
v117.LimitEntryTime = now2
limitEntryTime = now2
end

if flag19 then
if v117.ExpectedDuration - v115.Data.Ragebot.Stability <= now2 - limitEntryTime then
return false
end
end

return v86[34]
end

index2.Destroy = function(arg)
arg._trove:Destroy()
end

return index2
end

tbl17.jJ = function()
local jj = tbl17.cache.jJ

if not jj then
jj = { c = fn35() }
tbl17.cache.jJ = jj
end

return jj.c
end
end
do -- jK
local function fn35()
local v115 = tbl17.bG()
local v116 = tbl17.jF()
local v117 = cloneref(game:GetService("CollectionService"))

return { compute = function(arg, arg2)
if not arg2 then
return v116(arg.Position, 10000, 1e9)
end
local v118 = nil

for _, v119 in v117:GetTagged("OutOfBoundsPart") do
if v119:GetAttribute("KillDelay") == 0 then
v118 = v119
break
else
v118 = nil
end
end

if v118 == nil then
return v116(arg.Position, 10000, 1e9)
end
return v118.CFrame * CFrame.new(0, -v118.Size.Y / 2 + v115.Data.Ragebot.Evasion.Translocate.Offset, 0)
end }
end

tbl17.jK = function()
local jk = tbl17.cache.jK

if not jk then
jk = { c = fn35() }
tbl17.cache.jK = jk
end

return jk.c
end
end
do -- jL
local function fn35()
local n = 1121
local v115 = Random.new()

local function fn36()
return v115:NextInteger(0, 65535) * 65536 + v115:NextInteger(v86[186], 65535)
end

local v116 = fn36()
local v117 = fn36()
local v118 = fn36()
local v119 = fn36()

local function fn37(arg, arg2)
local n33 = (bit32.bxor(arg, arg2, v116) + v117) % 4294967296
local n34 = (bit32.bxor(n33, bit32.lrotate(n33, 7)) + v118) % 4294967296
local n35 = (bit32.bxor(n34, bit32.rrotate(n34, 11)) + v119) % 4294967296
return (bit32.bxor(n35, bit32.lrotate(n35, 17)))
end

local function fn38(arg, arg2)
local n33 = arg + 400 + v86[83]

return {
Min = arg,
Max = arg2,
Cells = (arg2 - arg) / 2048,
YMin = n33,
YSpan = arg2 - 400 - 64 - n33 + 1,
Salt = fn36(),
}
end

local v120 = fn38(65536, 524288)
local v121 = fn38(134217728, 1073741824)

local function fn39(arg, arg2, arg3, arg4)
local bxor = bit32.bxor
local salt = arg.Salt
return fn37(bit32.bxor(arg2, bit32.lshift(arg3, v86[118])), bxor(arg4, salt))
end

local function fn40(arg, arg2, arg3, arg4)
return fn39(arg, arg2, arg3, arg4) % n - 560
end

local function fn41(arg, arg2, arg3)
local n33 = arg.Min + 1024
local ySpan = arg.YSpan
return Vector3.new(n33 + arg2 * 2048 + fn40(arg, arg2, arg3, 324508639), arg.YMin + fn39(arg, arg2, arg3, 826366246) % ySpan, n33 + arg3 * 2048 + fn40(arg, arg2, arg3, 610839776))
end

local function fn42(arg)
local n33 = arg.Cells - 1
local nextInteger = v115.NextInteger
local v122 = v86[186]
local v123 = fn41(arg, v115:NextInteger(0, n33), nextInteger(v115, v122, n33))
local n34 = 200 * v115:NextNumber() ^ 0.33333333333333331
local v124 = v115:NextNumber(-1, 1)
local v125 = math.sqrt(1 - v124 * v124)
local v126 = v115:NextNumber(0, 6.2831853071795862)
return v123 + Vector3.new(n34 * v125 * math.cos(v126), n34 * v124, n34 * v125 * math.sin(v126))
end

local function fn43(arg, arg2)
local min = arg.Min
local max = arg.Max
local x = arg2.X
local y = arg2.Y
local z = arg2.Z
if x <= min or x >= max or y <= min or y >= max or z <= min or z >= max then
return false
end
local n33 = math.floor((x - min) / 2048)
local n34 = math.floor((z - min) / 2048)
return (arg2 - fn41(arg, n33, n34)).Magnitude < 400
end

local function fn44(arg)
local cframe = CFrame.fromOrientation
local nextNumber = v115.NextNumber
return CFrame.new(arg) * cframe(v115:NextNumber(-3.1415926535897931, 3.1415926535897931), v115:NextNumber(-3.1415926535897931, 3.1415926535897931), nextNumber(v115, -3.1415926535897931, 3.1415926535897931))
end

return {
SphereRadius = 400,
isInAnyRing = function(arg)
return fn43(v120, arg) or fn43(v121, arg)
end,
isInNormalRing = function(arg)
return fn43(v120, arg)
end,
isInImmuneRing = function(arg)
if not flag3 then
return
end
return fn43(v121, arg)
end,
getNormal = function()
return fn44(fn42(v120))
end,
getImmune = function()
return fn44(fn42(v121))
end,
}
end

tbl17.jL = function()
local jl = tbl17.cache.jL

if not jl then
jl = { c = fn35() }
tbl17.cache.jL = jl
end

return jl.c
end
end
do -- jM
local function fn35()
local v115 = tbl17.bG()
tbl17.cU()
tbl17.cX()

local function fn36(arg)
local index2 = arg.Index
return index2 == v86[63] and "Primary" or index2 == 2 and "Secondary" or index2 == 3 and "Melee" or nil
end

local function fn37(arg)
return v115.Data.Ragebot.Weapons.Enabled[arg]
end

return { getAction = function(arg)
local weapons = v115.Data.Ragebot.Weapons
local onEmpty = weapons.OnEmpty
local huge = math.huge
local huge2 = math.huge
local flag19 = false
local v116 = nil
local v117 = nil

for _, v118 in arg.ItemBehaviors:GetItems(), nil, nil do
local v119 = fn36(v118)

if not (v119 == nil or not fn37(v119)) then
flag19 = v86[34]
local huge3 = table.find(weapons.Priority, v119) or math.huge

if v118.__type == "Gun" and v118:GetAmmo() == 0 then
if not (v118:GetAmmoReserve() <= 0) then
if huge3 < huge2 then
if onEmpty == "Reload" then
v116 = v118
huge = huge3
else
huge2 = huge3
v117 = v118
end
end
end
elseif v116 == nil or huge3 < huge then
v116 = v118
huge = huge3
end
end
end

if not flag19 then
return nil
end

if v116 ~= nil then
local flag20 = v116.__type == "Gun"

if flag20 then
local v118 = v86[186]
flag20 = v116:GetAmmo() == v118
end

if v116:IsEquipped() then
if flag20 then
return { Type = "Reload", Item = v116 }
end
return { Type = "Attack", Item = v116 }
end

return { Type = "Swap", Item = v116 }
end

if onEmpty == "Swap" then
return nil
end

if v117 ~= nil then
if v117:IsEquipped() then
return { Type = "Reload", Item = v117 }
end
return { Type = "Swap", Item = v117 }
end

return nil
end }
end

tbl17.jM = function()
local jm = tbl17.cache.jM

if not jm then
jm = { c = fn35() }
tbl17.cache.jM = jm
end

return jm.c
end
end
do -- jN
local function fn35()
tbl17.cU()
tbl17.jx()

return function(arg)
local v115 = arg:FindMeleeByName("Riot Shield")
if v115 == nil then
return "None"
end
return v115:IsEquipped() and "Equipped" or "Unequipped"
end
end

tbl17.jN = function()
local jn = tbl17.cache.jN

if not jn then
jn = { c = fn35() }
tbl17.cache.jN = jn
end

return jn.c
end
end
do -- jO
local function fn35()
tbl17.cJ()
local v115 = tbl17.bG()
local v116 = tbl17.jz()
tbl17.cF()
local v117 = tbl17.jD()
tbl17.cU()
local v118 = tbl17.c4()
local v119 = tbl17.jE()
tbl17.gA()
tbl17.cX()
tbl17.bM()
local v120 = tbl17.jH()
local v121 = tbl17.jI()
local v122 = tbl17.cG()
local v123 = tbl17.jJ()
tbl17.g_()
local v124 = tbl17.jB()
local v125 = tbl17.jK()
local v126 = tbl17.k()
local v127 = tbl17.jL()
local v128 = tbl17.jM()
local v129 = tbl17.jN()
local fallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight

local function fn36()
return { CFrame = v127.getImmune(), ShouldSkipDefense = true }
end

local index2 = {}
index2.__index = index2

index2.new = function(arg, arg2, arg3, arg4, arg5)
local ragebot = v126.new("ragebot")
local v130 = ragebot:Add(v123.new(arg))

local tbl18 = {
_trove = ragebot,
_enabled = false,
_lastTargetWorld = nil,
_lastDefensiveViewAngles = nil,
_playerContext = arg3,
_targetSelection = v124.new(arg, arg2),
_spatialLimitGate = v130,
_hitscanStrategy = v117.new(arg5),
_meleeStrategy = v119.new(arg5),
_projectileBreakerTeleport = ragebot:Add(v120.new(arg, arg3)),
_stateHook = arg4,
_reloadGun = nil,
_reloadReadyAt = nil,
_reloadAcknowledgementDeadline = nil,
_pendingDepletionAmmo = nil,
}

setmetatable(tbl18, index2)
tbl18:_Initialize()
return tbl18
end

index2._Initialize = function(arg)
arg._trove:Add(arg._playerContext:ObserveContext("ragebot", function(innerContext)
if not flag2 then
return
end
arg._innerContext = innerContext
arg:_ClearReloadTransport()
end))

arg._trove:Connect(arg._playerContext.ContextRemoved, function()
arg:_Reset()
arg._innerContext = nil
end)

arg._trove:Add(v118:ObserveEnabledKeybind({ "Ragebot" }, function(arg2)
arg:SetEnabled(arg2)
arg:_Reset()
end))
end

index2.SetEnabled = function(arg, enabled)
if arg._enabled == enabled then
return
end
arg._enabled = enabled
v112(workspace, "FallenPartsDestroyHeight", enabled and (0/0) or fallenPartsDestroyHeight)
v107(v108, "DFIntS2PhysicsSenderRate", enabled and "120" or "15")
v107(v108, "DFIntAssemblyHistoryBufferSize", enabled and "2147483648" or "15")
v107(v108, "DFIntAssemblyHistorySkipSize", enabled and v86[18] or "8")

if not enabled then
arg:_ClearReloadTransport()
end
end

index2.Update = function(arg, arg2)
local innerContext = arg._innerContext
if innerContext == nil then
arg:_Reset()
return
end
local fighterState = innerContext.FighterState
if fighterState.EnvironmentId == nil or not arg._enabled then
arg:_Reset()
return
end
local state = fighterState.Character.State
if not state.Alive then
arg:_Reset()
return
end
local characterController = innerContext.CharacterController
local clientCFrame = characterController:GetClientCFrame()
local mode = v115.Data.Ragebot.Evasion.Mode
local v130 = v128.getAction(innerContext)

if mode == "Translocate" and arg._reloadGun == nil and (v130 == nil or v130.Type ~= "Reload") then
arg:_ApplyForcedCrouch(v86[153])
characterController:SetServerCFrame(v125.compute(clientCFrame, arg._targetSelection:HasTargets()))
return
end

local target = arg._targetSelection:GetTarget()

if target ~= nil then
arg._lastTargetWorld = target.AliveState.RootPart.Position
else
arg._lastTargetWorld = nil
end

local v131 = arg:_Plan(arg2, v130, target, state.RootPart, clientCFrame, mode)
arg:_ApplyPlan(v131, target, innerContext)
local reloadGun = arg._reloadGun

if reloadGun ~= nil and arg._reloadReadyAt == nil and arg._pendingDepletionAmmo == nil and not reloadGun:IsReloading() then
arg._reloadReadyAt = os.clock() + v122.getEstimatedReplicationDelay()
end

arg:_ApplyForcedCrouch(v131.ShouldForceCrouch == true)
local v132 = innerContext.ItemBehaviors:EquippedItemAsGun()
local ammo = v132 ~= nil and v132:GetAmmo() or 0
local shotRequestCount = v132 ~= nil and v132.ShotRequestCount or 0
local weaponAction = v131.WeaponAction

if weaponAction ~= nil then
weaponAction()

if v132 ~= nil and (v132 ~= nil and v132.ShotRequestCount - shotRequestCount or 0) > 0 and v132:GetExpectedAmmoAfterPendingShots() <= 0 then
innerContext.CharacterController:SetServerCFrame(v127.getImmune())
local now2 = os.clock()
arg._reloadGun = v132
arg._reloadReadyAt = now2 + v122.getEstimatedReplicationDelay()
arg._pendingDepletionAmmo = ammo
arg._reloadAcknowledgementDeadline = now2 + v122.getEstimatedRemoteDelay() + v122.getEstimatedReplicationDelay()
end
end
end

index2._Plan = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
local flag19 = arg4 ~= nil and not arg._spatialLimitGate:Tick(arg4)
local v130 = arg:_PlanReloadTransport(arg3)
if v130 ~= nil then
return v130
end

if arg3 == nil then
return arg:_EvadePlan(arg6, arg7)
end

if arg3.Type == "Swap" then
local item = arg3.Item
local v131 = arg:_EvadePlan(arg6, arg7)

v131.WeaponAction = function()
item:Equip()
end

return v131
end

if arg3.Type == "Reload" then
return fn36()
end

if arg4 == nil then
return arg:_EvadePlan(arg6, arg7)
end
local item = arg3.Item

if item.__type == "Gun" then
if item:IsReloading() then
return fn36()
end
local v131, v132 = arg._hitscanStrategy:Plan(arg2, arg4, item, arg5, flag19)
return { CFrame = v131, WeaponAction = v132, ShouldForceCrouch = true, IsAimPose = v132 ~= nil }
end

if item.__type == "Melee" then
local v131, v132, v133 = arg._meleeStrategy:Plan(arg2, arg4, item, arg5, flag19)

return {
CFrame = v131,
ViewAngles = v132,
WeaponAction = v133,
ShouldSkipDefense = v86[34],
ShouldForceCrouch = true,
}
end

return {}
end

index2._ClearReloadTransport = function(arg)
arg._reloadGun = nil
arg._reloadReadyAt = nil
arg._reloadAcknowledgementDeadline = nil
arg._pendingDepletionAmmo = nil
end

index2._PlanReloadTransport = function(arg, arg2)
local reloadGun = arg._reloadGun
local now2 = os.clock()

if reloadGun ~= nil then
if (arg._innerContext ~= nil and arg._innerContext.ItemBehaviors:EquippedItemAsGun() or nil) ~= reloadGun or arg2 ~= nil and (arg2.Type == "Swap" or arg2.Type == "Attack") and arg2.Item ~= reloadGun then
arg:_ClearReloadTransport()
return nil
end

if reloadGun:IsReloading() then
arg._reloadReadyAt = nil
arg._pendingDepletionAmmo = nil
arg._reloadAcknowledgementDeadline = nil
return fn36()
end

local ammo = reloadGun:GetAmmo()

if arg._pendingDepletionAmmo ~= nil then
local reloadAcknowledgementDeadline = arg._reloadAcknowledgementDeadline

if not (ammo <= 0 and reloadGun:GetAmmoReserve() > 0) then
local flag19 = reloadAcknowledgementDeadline == nil or now2 >= reloadAcknowledgementDeadline

if not flag19 then
local v130 = v86[186]
flag19 = reloadGun:GetExpectedAmmoAfterPendingShots() > v130
end

if flag19 then
arg:_ClearReloadTransport()
return nil
end
return fn36()
end

arg._pendingDepletionAmmo = nil
arg._reloadAcknowledgementDeadline = nil
end

if ammo > 0 or reloadGun:GetAmmoReserve() <= 0 then
arg:_ClearReloadTransport()
return nil
end
local reloadReadyAt = arg._reloadReadyAt

if reloadReadyAt == nil then
reloadReadyAt = now2 + v122.getEstimatedReplicationDelay()
arg._reloadReadyAt = reloadReadyAt
end

local v130 = fn36()
local reloadAcknowledgementDeadline = arg._reloadAcknowledgementDeadline

if now2 >= reloadReadyAt and (reloadAcknowledgementDeadline == nil or now2 >= reloadAcknowledgementDeadline) then
v130.WeaponAction = function()
if reloadGun:Reload() then
arg._reloadAcknowledgementDeadline = os.clock() + v122.getEstimatedRemoteDelay() + v122.getEstimatedReplicationDelay()
end
end
end

return v130
end

if arg2 == nil or arg2.Type ~= "Reload" then
return nil
end
arg._reloadGun = arg2.Item
arg._reloadReadyAt = nil
arg._reloadAcknowledgementDeadline = nil
arg._pendingDepletionAmmo = nil
return fn36()
end

index2._EvadePlan = function(arg, arg2, arg3)
if arg3 == "Off" then
return {}
end

if arg3 == "ProjectileBreaker" then
return { CFrame = arg._projectileBreakerTeleport:Compute(arg2), ShouldSkipDefense = v86[34] }
end
return { CFrame = v121.compute(arg2) }
end

index2._ApplyPlan = function(arg, arg2, arg3, arg4)
local characterController = arg4.CharacterController
local cFrame = arg2.CFrame

if cFrame == nil or arg3 == nil or arg2.ShouldSkipDefense then
characterController:SetServerCFrame(cFrame)
characterController:SendViewAngles(20, arg2.ViewAngles)
return
end

local aliveState = arg3.AliveState
local v130 = v129(arg4.ItemBehaviors)
local v131 = v116.getDefensiveCFrame(cFrame, v130, arg3.FighterState, aliveState.RootPart)
characterController:SetServerCFrame(v131)

if arg2.IsAimPose or arg2.ShouldDefendInPlace then
arg._lastDefensiveViewAngles = v116.getDefensiveViewAngles(v130, arg3.FighterState)
end

characterController:SendViewAngles(v86[9], arg2.ViewAngles or arg._lastDefensiveViewAngles)
end

index2.GetLastTargetWorld = function(arg)
return arg._lastTargetWorld
end

index2._ApplyForcedCrouch = function(arg, arg2)
if arg2 then
arg._stateHook:SetForced("IsCrouching", true)
else
arg._stateHook:ClearForced("IsCrouching")
end
end

index2._Reset = function(arg)
arg:_ClearReloadTransport()
arg._lastTargetWorld = nil
arg._lastDefensiveViewAngles = nil
arg:_ApplyForcedCrouch(false)
arg._meleeStrategy:ResetState()
arg._projectileBreakerTeleport:ResetState()
local innerContext = arg._innerContext
if innerContext == nil then
return
end
innerContext.CharacterController:SetServerCFrame(nil)
innerContext.CharacterController:SendViewAngles(20, nil)
end

index2.Destroy = function(arg)
arg._trove:Destroy()
end

return index2
end

tbl17.jO = function()
local jo = tbl17.cache.jO

if not jo then
jo = { c = fn35() }
tbl17.cache.jO = jo
end

return jo.c
end
end
do -- jP
local function fn35()
local v115 = tbl17.f()
tbl17.a()
local index2 = {}
index2.__index = index2

index2.new = function(arg)
return setmetatable({
_manager = v115.new({
DefaultConfig = nil,
CurrentVersion = arg.CurrentVersion,
LegacyVersion = arg.LegacyVersion,
SavePath = arg.SavePath,
Migrations = arg.Migrations,
Serialize = arg.Serialize,
Deserialize = arg.Deserialize,
}),
}, index2)
end

index2.Save = function(arg, arg2, arg3, arg4)
arg._manager:SetData(arg3)
return arg._manager:SaveToFile(arg2, arg4)
end

index2.Load = function(arg, arg2)
return arg._manager:LoadFromFile(arg2)
end

index2.Delete = function(arg, arg2)
return arg._manager:Delete(arg2)
end

index2.List = function(arg)
return arg._manager:AllConfigs()
end

index2.Has = function(arg, arg2)
return table.find(arg:List(), arg2) ~= nil
end

return index2
end

tbl17.jP = function()
local jp = tbl17.cache.jP

if not jp then
local jp2 = { c = fn35() }
tbl17.cache.jP = jp2
jp = jp2
end

return jp.c
end
end
do -- jQ
local function fn35()
local tbl18 = {}
local v115 = buffer.create(v86[83])
local v116 = buffer.create(256)

for i = v86[186], 63 do
local v117 = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):byte(i + 1)
buffer.writeu8(v115, i, v117)
buffer.writeu8(v116, v117, i)
end

local v117 = buffer.create(8192)
local v118 = buffer.create(131072)

for i = v86[186], 63 do
local v119 = buffer.readu8(v115, i)

for i2 = 0, 63 do
local v120 = buffer.readu8(v115, i2)
buffer.writeu16(v117, (i * 64 + i2) * 2, v119 + v120 * 256)
buffer.writeu16(v118, (v119 + v120 * 256) * v86[56], i * v86[83] + i2)
end
end

tbl18.encode = function(I)local W=#I;if W==0 then return"";end;local N,P=buffer.fromstring(I),math.floor((W+2)/3);I=P*4;local a=buffer.create(I);for e=0,P-2,1 do local c=bit32.rshift(bit32.byteswap(buffer.readu32(N,e*3)),8);buffer.writeu16(a,e*4,buffer.readu16( v117 ,bit32.rshift(c,12)*2));buffer.writeu16(a,e*4+2,buffer.readu16( v117 ,bit32.band(c,4095)*2));end;local e,c=W%3,I-4;if e==1 then P=buffer.readu8(N,W-1);buffer.writeu16(a,c,buffer.readu16( v117 ,bit32.lshift(P,4)*2));buffer.writeu16(a,c+2,15677);elseif e==2 then local P_181,e_182=buffer.readu8(N,W-2),buffer.readu8(N,W-1);I=bit32.bor(bit32.lshift(P_181,4),bit32.rshift(e_182,4));buffer.writeu16(a,c,buffer.readu16( v117 ,I*2));buffer.writeu8(a,c+2,buffer.readu8( v115 ,bit32.band(bit32.lshift(e_182,2),63)));buffer.writeu8(a,c+3,61);else local I_183=bit32.bor(bit32.lshift(buffer.readu8(N,W-3),16),bit32.lshift(buffer.readu8(N,W-2),8),buffer.readu8(N,W-1));buffer.writeu16(a,c,buffer.readu16( v117 ,bit32.rshift(I_183,12)*2));buffer.writeu16(a,c+2,buffer.readu16( v117 ,bit32.band(I_183,4095)*2));end;return buffer.tostring(a);end
tbl18.decode = function(I)local W=#I;if W==0 then return"";end;local N,P=buffer.fromstring(I),math.floor(W/4);I=if buffer.readu8(N,W-1)==61 then 1 else 0;I=if buffer.readu8(N,W-2)==61 then I+1 else I;W=P*3-I;local a=buffer.create(W);for e=0,P-2,1 do local c=e*4;local E,p=buffer.readu16( v118 ,buffer.readu16(N,c)*2),buffer.readu16( v118 ,buffer.readu16(N,c+2)*2);W=bit32.lshift(E,12)+p;buffer.writeu8(a,e*3,bit32.rshift(W,16));buffer.writeu8(a,e*3+1,bit32.band(bit32.rshift(W,8),255));buffer.writeu8(a,e*3+2,bit32.band(W,255));end;local W_184=(P-1)*4;local e=(P-1)*3;P=bit32.bor(bit32.lshift(buffer.readu8( v116 ,buffer.readu8(N,W_184)),18),bit32.lshift(buffer.readu8( v116 ,buffer.readu8(N,W_184+1)),12),bit32.lshift(buffer.readu8( v116 ,buffer.readu8(N,W_184+2)),6),buffer.readu8( v116 ,buffer.readu8(N,W_184+3)));buffer.writeu8(a,e,bit32.rshift(P,16));if I<=1 then buffer.writeu8(a,e+1,bit32.band(bit32.rshift(P,8),255));if I==0 then buffer.writeu8(a,e+2,bit32.band(P,255));end;end;return buffer.tostring(a);end
return tbl18
end

tbl17.jQ = function()
local jq = tbl17.cache.jQ

if not jq then
local jq2 = { c = fn35() }
tbl17.cache.jQ = jq2
jq = jq2
end

return jq.c
end
end
do -- jR
local function fn35()
local v115 = tbl17.jQ()
tbl17.hM()
local tbl18 = {}

local tbl19 = {
Move = 1,
Jump = 2,
Crouch = 3,
Slide = 4,
Look = 5,
ItemInput = 6,
QuickAttack = v86[122],
Equip = 8,
}

local tbl20 = {}

for k, v116 in tbl19, nil, nil do
tbl20[v116] = k
end

local function fn36(arg, arg2)
local v116 = buffer.len(arg.Buf)
local n = arg.Len + arg2
if n <= v116 then
return
end

while v116 < n do
v116 *= 2
end

local v117 = buffer.create(v116)
buffer.copy(v117, v86[186], arg.Buf, v86[186], arg.Len)
arg.Buf = v117
end

local function fn37(arg, arg2)
fn36(arg, 1)
buffer.writeu8(arg.Buf, arg.Len, arg2)
arg.Len = arg.Len + 1
end

local function fn38(arg, arg2)
fn36(arg, v86[56])
buffer.writeu16(arg.Buf, arg.Len, arg2)
arg.Len = arg.Len + 2
end

local function fn39(arg, arg2)
fn36(arg, 4)
buffer.writeu32(arg.Buf, arg.Len, arg2)
arg.Len = arg.Len + v86[26]
end

local function fn40(arg, arg2)
fn36(arg, 4)
buffer.writef32(arg.Buf, arg.Len, arg2)
arg.Len = arg.Len + 4
end

local function fn41(arg, arg2)
local n = #arg2
fn38(arg, n)
fn36(arg, n)
buffer.writestring(arg.Buf, arg.Len, arg2)
arg.Len = arg.Len + n
end

local function fn42(arg, arg2)
fn40(arg, arg2.X)
fn40(arg, arg2.Y)
fn40(arg, arg2.Z)
end

local function fn43(arg, arg2)
local tbl21 = { arg2:GetComponents() }

for i = v86[63], v86[12] do
fn40(arg, tbl21[i])
end
end

local function fn44(arg, arg2)
fn37(arg, tbl19[arg2.Kind])

if arg2.Kind == "Move" then
fn42(arg, arg2.Direction)
elseif arg2.Kind == "Crouch" then
fn37(arg, arg2.Crouching and v86[63] or 0)
elseif arg2.Kind == "Look" then
fn43(arg, arg2.CFrame)
elseif arg2.Kind == "ItemInput" then
fn41(arg, arg2.InputType)
elseif arg2.Kind == "QuickAttack" then
fn41(arg, arg2.AttackType)
elseif arg2.Kind == "Equip" then
fn39(arg, arg2.Index)
end
end

local function fn45(arg)
local v116 = buffer.readu8(arg.Buf, arg.Off)
arg.Off = arg.Off + v86[63]
return v116
end

local function fn46(arg)
local v116 = buffer.readu16(arg.Buf, arg.Off)
arg.Off = arg.Off + 2
return v116
end

local function fn47(arg)
local v116 = buffer.readu32(arg.Buf, arg.Off)
arg.Off = arg.Off + 4
return v116
end

local function fn48(arg)
local v116 = buffer.readf32(arg.Buf, arg.Off)
arg.Off = arg.Off + 4
return v116
end

local function fn49(arg)
local v116 = fn46(arg)
local v117 = buffer.readstring(arg.Buf, arg.Off, v116)
arg.Off = arg.Off + v116
return v117
end

local function fn50(arg)
return Vector3.new(fn48(arg), fn48(arg), fn48(arg))
end

local function fn51(arg)
local v116 = table.create(12)

for i = 1, 12 do
v116[i] = fn48(arg)
end

return CFrame.new(table.unpack(v116))
end

local function fn52(arg)
local v116 = tbl20[fn45(arg)]
if v116 == "Move" then
return { Kind = "Move", Direction = fn50(arg) }
end

if v116 == "Crouch" then
return { Kind = "Crouch", Crouching = fn45(arg) == 1 }
end

if v116 == "Look" then
return { Kind = "Look", CFrame = fn51(arg) }
end

if v116 == "ItemInput" then
return { Kind = "ItemInput", InputType = fn49(arg) }
end

if v116 == "QuickAttack" then
return { Kind = "QuickAttack", AttackType = fn49(arg) }
end

if v116 == "Equip" then
return { Kind = "Equip", Index = fn47(arg) }
end

if v116 == "Jump" then
return { Kind = "Jump" }
end
return { Kind = "Slide" }
end

tbl18.encode = function(arg)
local tbl21 = { Buf = buffer.create(1024), Len = 0 }
fn37(tbl21, 1)
fn41(tbl21, arg.MapName)
fn43(tbl21, arg.StartCFrame)
fn42(tbl21, arg.DisplayPosition)
local startEquippedIndex = arg.StartEquippedIndex

if startEquippedIndex ~= nil then
fn37(tbl21, v86[63])
fn39(tbl21, startEquippedIndex)
else
fn37(tbl21, 0)
end

local startEquipCooldown = arg.StartEquipCooldown

if startEquipCooldown ~= nil then
fn37(tbl21, 1)
fn40(tbl21, startEquipCooldown)
else
fn37(tbl21, 0)
end

local n = 0

for k in arg.LoadoutRequirementSet, nil, nil do
n += 1
end

fn39(tbl21, n)

for k in arg.LoadoutRequirementSet, nil, nil do
fn41(tbl21, k)
end

local keypoints = arg.Keypoints
fn39(tbl21, #keypoints)

for _, v116 in keypoints, nil, nil do
fn40(tbl21, v116.Offset)
fn44(tbl21, v116.Action)
end

local positions = arg.Positions
fn39(tbl21, #positions)

for _, v116 in positions, nil, nil do
fn40(tbl21, v116.Offset)
fn42(tbl21, v116.Position)
end

local v116 = buffer.create(tbl21.Len)
buffer.copy(v116, v86[186], tbl21.Buf, v86[186], tbl21.Len)
return v115.encode(buffer.tostring(v116))
end

tbl18.decode = function(arg)
local tbl21 = { Buf = buffer.fromstring(v115.decode(arg)), Off = 0 }
local v116 = fn45(tbl21)
assert(v116 == 1, string.format("unsupported recording format version %s", tostring(v116)))
local v117 = fn49(tbl21)
local v118 = fn51(tbl21)
local v119 = fn50(tbl21)
local v120 = nil

if fn45(tbl21) == 1 then
v120 = fn47(tbl21)
end

local v121 = nil

if fn45(tbl21) == 1 then
v121 = fn48(tbl21)
end

local tbl22 = {}

for i = 1, fn47(tbl21) do
local v122 = v86[34]
tbl22[fn49(tbl21)] = v122
end

local v122 = fn47(tbl21)
local v123 = table.create(v122)

for i = 1, v122 do
v123[i] = { Offset = fn48(tbl21), Action = fn52(tbl21) }
end

local v124 = fn47(tbl21)
local v125 = table.create(v124)

for i = 1, v124 do
v125[i] = { Offset = fn48(tbl21), Position = fn50(tbl21) }
end

return {
MapName = v117,
StartCFrame = v118,
DisplayPosition = v119,
StartEquippedIndex = v120,
StartEquipCooldown = v121,
LoadoutRequirementSet = tbl22,
Keypoints = v123,
Positions = v125,
}
end

return tbl18
end

tbl17.jR = function()
local jr = tbl17.cache.jR

if not jr then
jr = { c = fn35() }
tbl17.cache.jR = jr
end

return jr.c
end
end
do -- jS
local function fn35()
local v115 = tbl17.jP()
local v116 = tbl17.jR()
local v117 = tbl17.a()
local v118 = tbl17.g()
tbl17.hM()
local v119 = tbl17.k()
local index2 = {}
index2.__index = index2

index2.new = function()
local v120 = v119.new()

local tbl18 = {
_trove = v120,
_store = v115.new({
SavePath = "kiciarebuild/rivals/movement_recorder",
CurrentVersion = 1,
Serialize = v116.encode,
Deserialize = v116.decode,
}),
_recordingNamesByMap = {},
_recordingByName = {},
Reloaded = v120:Add(v118.new()),
}

setmetatable(tbl18, index2)
tbl18:Reload()
return tbl18
end

index2.Reload = function(arg)
local recordingByName = arg._recordingByName
table.clear(recordingByName)
table.clear(arg._recordingNamesByMap)

for _, v120 in arg._store:List(), nil, nil do
local v121 = arg._store:Load(v120)

if v121.Ok then
local value = v121.Value
value.Name = v120
recordingByName[v120] = value
table.insert(arg:_GetOrCreateNamesForMap(value.MapName), v120)
end
end

arg.Reloaded:Fire()
end

index2._GetOrCreateNamesForMap = function(arg, arg2)
local tbl18 = arg._recordingNamesByMap[arg2]

if tbl18 == nil then
tbl18 = {}
arg._recordingNamesByMap[arg2] = tbl18
end

return tbl18
end

index2.Save = function(arg, name, arg2)
local v120 = arg._store:Save(name, arg2)
if not v120.Ok then
return v117.err("RecordedMovements", "Save", v120.Error.Detail)
end
local v121 = arg._recordingByName[name]

if v121 == nil or v121.MapName ~= arg2.MapName then
if v121 ~= nil then
local v122 = arg._recordingNamesByMap[v121.MapName]
table.remove(v122, table.find(v122, name))

if #v122 == 0 then
arg._recordingNamesByMap[v121.MapName] = nil
end
end

table.insert(arg:_GetOrCreateNamesForMap(arg2.MapName), name)
end

arg2.Name = name
arg._recordingByName[name] = arg2
arg.Reloaded:Fire()
return v117.VoidOk
end

index2.FindByName = function(arg, arg2)
return arg._recordingByName[arg2]
end

index2.GetMaps = function(arg)
local tbl18 = {}

for k in arg._recordingNamesByMap, nil, nil do
table.insert(tbl18, k)
end

table.sort(tbl18)
return tbl18
end

index2.GetNamesForMap = function(arg, arg2)
local v120 = arg._recordingNamesByMap[arg2]
if v120 == nil then
return {}
end
local v121 = table.clone(v120)
table.sort(v121)
return v121
end

index2.FindByMap = function(arg, arg2)
local v120 = arg._recordingNamesByMap[arg2]
if v120 == nil then
return nil
end
local v121 = table.create(#v120)

for _, v122 in v120, nil, nil do
table.insert(v121, arg._recordingByName[v122])
end

return v121
end

index2.Delete = function(arg, arg2)
local v120 = arg._store:Delete(arg2)
if not v120.Ok then
return v117.err("RecordedMovements", "Delete", v120.Error.Detail)
end
local v121 = arg._recordingByName[arg2]

if v121 ~= nil then
arg._recordingByName[arg2] = nil
local v122 = arg:_GetOrCreateNamesForMap(v121.MapName)
table.remove(v122, table.find(v122, arg2))

if #v122 == 0 then
arg._recordingNamesByMap[v121.MapName] = nil
end

arg.Reloaded:Fire()
end

return v117.VoidOk
end

index2.Destroy = function(arg)
arg._trove:Destroy()
end

return index2
end

tbl17.jS = function()
local js = tbl17.cache.jS

if not js then
js = { c = fn35() }
tbl17.cache.jS = js
end

return js.c
end
end
do -- jT
local function fn35()
local v115 = tbl17.ad()
tbl17.aM()
tbl17.aO()
local v116 = tbl17.a()
local v117 = tbl17.b2()
local quickAttackFunction = tbl17.aS().QuickAttackFunction
local v118 = cloneref(game:GetService("ReplicatedStorage"))
local index2 = {}
index2.__index = index2

local function fn36(arg)
return {
Remotes = {
Replication = {
Fighter = {
RegisterQuickAttack = { InvokeServer = function(arg2, arg3, ...)
arg(arg3)
local v119 = quickAttackFunction
local invokeServer = v119.InvokeServer
local v120 = table.pack(...)
v120.n = 3 + v120.n - 1
table.move(v120, 1, v120.n, 3, v120)
v120[1] = v119
v120[2] = arg3
return invokeServer(table.unpack(v120, 1, v120.n))
end },
},
},
},
}
end

index2.new = function(arg, arg2)
local tbl18 = { _errorReporter = v115.new(), _restore = nil }
setmetatable(tbl18, index2)
tbl18._errorReporter:ReportResult(tbl18:_Install(arg, arg2))
return tbl18
end

index2._Install = function(arg, arg2, arg3)
for _, v119 in debug.getupvalues(arg2.QuickAttack) do
if type(v119) ~= "table" then
continue
end

for k, v120 in v119, nil, nil do
if typeof(v120) ~= "Instance" or not v117(v120, v118) then
continue
end
arg._restore = { Bundle = v119, Key = k, Original = v120 }
v119[k] = fn36(arg3)
return v116.VoidOk
end
end

return v116.err("QuickAttackHook", "upvalue_scan", "Failed to find ReplicatedStorage upvalue")
end

index2.Destroy = function(arg)
local restore = arg._restore

if restore ~= nil then
arg._restore = nil
restore.Bundle[restore.Key] = restore.Original
end

arg._errorReporter:Destroy()
end

return index2
end

tbl17.jT = function()
local jt = tbl17.cache.jT

if not jt then
local jt2 = { c = fn35() }
tbl17.cache.jT = jt2
jt = jt2
end

return jt.c
end
end
do -- jU
local function fn35()
local v115 = tbl17.cp()
tbl17.cr()
tbl17.aM()
tbl17.dm()
tbl17.cU()
tbl17.aO()
local v116 = tbl17.jT()
tbl17.hM()
local v117 = tbl17.b3()
local inputLibrary = tbl17.aS().InputLibrary
local mechanicsController = tbl17.aS().MechanicsController
local playerModule = tbl17.aS().PlayerModule
local v118 = cloneref(game:GetService("UserInputService"))

local function fn36()
local v119 = v117(playerModule.GetControls, playerModule)
return v117(v119.GetMoveVector, v119)
end

local function fn37()
local currentCamera = workspace.CurrentCamera
local n = currentCamera.ViewportSize / v86[56]
local v119 = currentCamera:ViewportPointToRay(n.X, n.Y)
return v119.Origin + v119.Direction * 100
end

local function fn38(arg, arg2)
return arg * CFrame.fromOrientation(arg2.X, arg2.Y, 0)
end

local index2 = {}
index2.__index = index2

index2.new = function(arg, arg2, arg3, arg4, arg5, arg6)
local v119 = arg2:Inverse()
local v120 = v115.get()
local equipped = arg5:GetEquipped()
local index3 = equipped and equipped.Index
local n = nil

if equipped ~= nil then
local v121 = v102(equipped.Inner, "_equip_cooldown")
n = nil

if type(v121) == "number" then
n = math.max(v86[186], v121 - tick())
end
end

local tbl18 = {
_anchorInverse = v119,
_rootPart = arg3.RootPart,
_itemBehaviors = arg5,
_inputBinding = arg6,
_quickAttackHook = nil,
_jumpConnection = nil,
_lastMoveVector = Vector3.zero,
_lastCameraRotation = v120,
_lastEquippedIndex = index3,
_startItemIndex = index3,
_startItemUsed = false,
_lastCrouching = false,
_lastSliding = false,
_lastPositionSampleTime = 0,
_recording = {
MapName = arg,
DisplayPosition = v119 * fn37(),
StartCFrame = v119 * arg3.RootPart.CFrame,
Keypoints = { { Offset = 0, Action = { Kind = "Look", CFrame = fn38(v119, v120) } } },
LoadoutRequirementSet = {},
StartEquippedIndex = index3,
StartEquipCooldown = n,
Positions = {},
},
}

setmetatable(tbl18, index2)

tbl18._quickAttackHook = v116.new(arg4, function(arg7)
tbl18:_Record({ Kind = "QuickAttack", AttackType = arg7 })
end)

tbl18._jumpConnection = v118.InputBegan:Connect(function(input, gameProcessed)
if not gameProcessed and v117(inputLibrary.InputIs, inputLibrary, input, "Jump") then
tbl18:_Record({ Kind = "Jump" })
end
end)

arg6:SetHandler(function(arg7)
tbl18:_RecordItemInput(arg7)
end)

arg6:SetEnabled(true)
return tbl18
end

index2.Update = function(arg)
arg:_SampleMoveVector()
arg:_SampleCamera()
arg:_SampleEquipped()
arg:_SampleCrouch()
arg:_SampleSlide()
arg:_SamplePosition()
end

index2._SamplePosition = function(arg)
if arg._startTime == nil then
return
end
local now2 = os.clock()
if now2 - arg._lastPositionSampleTime < 0.1 then
return
end
arg._lastPositionSampleTime = now2
table.insert(arg._recording.Positions, { Offset = arg:_GetOffset(), Position = arg._anchorInverse * arg._rootPart.Position })
end

index2._SampleMoveVector = function(arg)
local v119 = fn36()
if v119 == arg._lastMoveVector then
return
end
arg._lastMoveVector = v119
arg:_Record({ Kind = "Move", Direction = v119 })
end

index2._SampleCrouch = function(arg)
local lastCrouching = v102(mechanicsController, "IsCrouching") == true
if lastCrouching == arg._lastCrouching then
return
end
arg._lastCrouching = lastCrouching
arg:_Record({ Kind = "Crouch", Crouching = lastCrouching })
end

index2._SampleSlide = function(arg)
local lastSliding = v102(mechanicsController, "IsSliding") == true
if lastSliding == arg._lastSliding then
return
end
arg._lastSliding = lastSliding

if lastSliding then
arg:_Record({ Kind = "Slide" })
end
end

index2._DiscardUnusedStartItem = function(arg)
if not (arg._startItemUsed or arg._recording.StartEquippedIndex == nil) then
arg._recording.StartEquippedIndex = nil
arg._recording.StartEquipCooldown = nil
return
end

if true then
return
end

-- (anti-tamper freeze trap removed)
end

index2._SampleEquipped = function(arg)
local equipped = arg._itemBehaviors:GetEquipped()
equipped = equipped and equipped.Index
if equipped == arg._lastEquippedIndex then
return
end
arg._lastEquippedIndex = equipped
arg:_DiscardUnusedStartItem()

if equipped ~= nil then
arg:_Record({ Kind = "Equip", Index = equipped })
end
end

index2._RecordItemInput = function(arg, arg2)
local v119 = arg._itemBehaviors:FindByObjectId(arg2.ObjectId)

if v119 ~= nil then
arg._recording.LoadoutRequirementSet[v119.Name] = true

if v119.Index == arg._startItemIndex then
arg._startItemUsed = v86[34]
end
end

arg:_Record({ Kind = "ItemInput", InputType = arg2.Type })
end

index2._SampleCamera = function(arg)
local v119 = v115.get()
if arg._lastCameraRotation:FuzzyEq(v119) then
return
end
arg._lastCameraRotation = v119
arg:_Record({ Kind = "Look", CFrame = fn38(arg._anchorInverse, v119) })
end

index2._GetOffset = function(arg)
local now2 = os.clock()
local startTime = arg._startTime or now2
arg._startTime = startTime
return now2 - startTime
end

index2._Record = function(arg, arg2)
table.insert(arg._recording.Keypoints, { Offset = arg:_GetOffset(), Action = arg2 })
end

index2.GetRecording = function(arg)
arg:_DiscardUnusedStartItem()
return arg._recording
end

index2.Destroy = function(arg)
arg._inputBinding:Destroy()
arg._quickAttackHook:Destroy()
arg._jumpConnection:Disconnect()
end

return index2
end

tbl17.jU = function()
local ju = tbl17.cache.jU

if not ju then
local ju2 = { c = fn35() }
tbl17.cache.jU = ju2
ju = ju2
end

return ju.c
end
end
do -- jV
local function fn35()
local v115 = tbl17.b3()
local playerModule = tbl17.aS().PlayerModule
local index2 = {}
index2.__index = index2

index2.new = function()
local v116 = v102(v115(playerModule.GetControls, playerModule), "activeController")
assert(v116 ~= nil, "no active controller to hook")
local tbl18 = { _controller = v116, _moveVector = Vector3.zero }
setmetatable(tbl18, index2)
tbl18:_Initialize()
return tbl18
end

index2._Initialize = function(arg)
v103(arg._controller, "GetMoveVector", function()
return arg._moveVector
end)
end

index2.SetMoveVector = function(arg, moveVector)
arg._moveVector = moveVector
end

index2.Destroy = function(arg)
v103(arg._controller, "GetMoveVector", nil)
end

return index2
end

tbl17.jV = function()
local jv = tbl17.cache.jV

if not jv then
local jv2 = { c = fn35() }
tbl17.cache.jV = jv2
jv = jv2
end

return jv.c
end
end
do -- jW
local function fn35()
local v115 = tbl17.co()
local v116 = tbl17.cp()
tbl17.cr()
local v117 = tbl17.bG()
tbl17.aM()
tbl17.cU()
tbl17.aO()
local v118 = tbl17.jV()
tbl17.hM()
local v119 = tbl17.b3()
local mechanicsController = tbl17.aS().MechanicsController
local index2 = {}
index2.__index = index2

local function fn36(arg)
local cFrame = workspace.CurrentCamera.CFrame
local vector = Vector3.new(cFrame.LookVector.X, 0, cFrame.LookVector.Z)
if vector.Magnitude < 0.0001 then
return Vector3.zero
end
local unit = vector.Unit
local v120 = v86[186]
return Vector3.new(arg:Dot(Vector3.new(cFrame.RightVector.X, 0, cFrame.RightVector.Z).Unit), v120, -arg:Dot(unit))
end

local function fn37(arg, arg2, arg3)
return Vector2.new(arg.X + (arg2.X - arg.X) * arg3, arg.Y + ((arg2.Y - arg.Y + 3.1415926535897931) % math.tau - 3.1415926535897931) * arg3)
end

local function fn38(arg, arg2, arg3, arg4)
local vector2 = Vector2.new(arg2.X - arg.X, (arg2.Y - arg.Y + 3.1415926535897931) % math.tau - 3.1415926535897931)
local magnitude = vector2.Magnitude
if magnitude <= 0.0017453292519943296 then
return arg2, true
end
return arg + vector2.Unit * math.min(magnitude * arg3, arg4), false
end

local function fn39(arg, arg2)
return 1 - math.exp(-arg / arg2)
end

local function fn40(arg)
return fn39(arg, v117.Data.Movement.MovementRecorder.LookSmoothing / 100 * 0.3)
end

local function fn41(arg, arg2)
for _, v120 in arg2, nil, nil do
local action = v120.Action
if action.Kind == "Look" then
local v121, v122 = (arg * action.CFrame):ToOrientation()
return Vector2.new(v121, v122)
end
end

return nil
end

index2.new = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
v115.claim("MovementRecorder.Replay", v86[91])
local startEquippedIndex = arg5.StartEquippedIndex

if startEquippedIndex ~= nil then
task.spawn(v119, arg2.EquipItem, arg2, startEquippedIndex)
end

return setmetatable({
_aliveState = arg,
_clientFighter = arg2,
_itemBehaviors = arg3,
_startEquippedIndex = startEquippedIndex,
_mapAnchor = arg4,
_startCFrame = arg5.StartCFrame,
_keypoints = arg5.Keypoints,
_positions = arg5.Positions,
_positionIndex = v86[63],
_finishedCallback = arg7,
_moveHook = v118.new(),
_isRoundActive = arg6,
_startLookRotation = fn41(arg4, arg5.Keypoints),
_lookRotation = nil,
_state = { Kind = "Aligning", Elapsed = 0, StuckTime = 0, BestDistance = math.huge },
_finished = false,
}, index2)
end

index2._StepAlign = function(arg, arg2, arg3)
local startLookRotation = arg._startLookRotation
local flag19 = true

if startLookRotation ~= nil then
local v120 = v116.get()
local n = math.rad(v117.Data.Movement.MovementRecorder.LookAlignSpeed) * arg3
local v121
v121, flag19 = fn38(v120, startLookRotation, fn40(arg3), n)
v116.set(v121)
end

if not arg._isRoundActive() then
arg._moveHook:SetMoveVector(Vector3.zero)
return false
end
arg2.Elapsed = arg2.Elapsed + arg3
local n = (arg._mapAnchor * arg._startCFrame).Position - arg._aliveState.RootPart.Position
local vector = Vector3.new(n.X, 0, n.Z)
local magnitude = vector.Magnitude
local flag20 = magnitude <= v117.Data.Movement.MovementRecorder.AlignSnapDistance

if flag20 then
arg._moveHook:SetMoveVector(Vector3.zero)
else
arg._moveHook:SetMoveVector(fn36(vector.Unit))
end

if magnitude < arg2.BestDistance - v86[62] then
arg2.BestDistance = magnitude
arg2.StuckTime = v86[186]
else
arg2.StuckTime = arg2.StuckTime + arg3
end

if not (flag20 and flag19 or arg2.StuckTime >= v86[63]) then
return false
end
arg._moveHook:SetMoveVector(Vector3.zero)
return arg:_IsStartItemReady() or arg2.Elapsed >= 3
end

index2._IsStartItemReady = function(arg)
if arg._startEquippedIndex == nil then
return v86[34]
end
local equipped = arg._itemBehaviors:GetEquipped()
if equipped == nil or equipped.Index ~= arg._startEquippedIndex then
return v86[153]
end
local v120 = v102(equipped.Inner, "_equip_cooldown")
return type(v120) ~= "number" or tick() >= v120
end

index2.Update = function(arg, arg2)
local state = arg._state

if state.Kind == "Aligning" then
if not arg:_StepAlign(state, arg2) then
return
end
arg._state = { Kind = "Playing", Offset = v86[186], KeypointIndex = 1 }
end

local state2 = arg._state
if state2.Kind ~= "Playing" then
return
end
state2.Offset = state2.Offset + arg2

if arg:_HasDiverged(state2.Offset) then
arg._finished = v86[34]
arg._finishedCallback("Diverged")
return
end

local keypoints = arg._keypoints

while state2.KeypointIndex <= #keypoints do
local v120 = keypoints[state2.KeypointIndex]

if not (state2.Offset < v120.Offset) then
local action = v120.Action

if action.Kind == "Move" then
arg._moveHook:SetMoveVector(action.Direction)
elseif action.Kind == "Look" then
local v121, v122 = (arg._mapAnchor * action.CFrame):ToOrientation()
arg._lookRotation = Vector2.new(v121, v122)
elseif action.Kind == "Equip" then
task.spawn(v119, arg._clientFighter.EquipItem, arg._clientFighter, action.Index)
elseif action.Kind == "ItemInput" then
task.spawn(v119, arg._clientFighter.Input, arg._clientFighter, action.InputType)
elseif action.Kind == "QuickAttack" then
task.spawn(v119, arg._clientFighter.QuickAttack, arg._clientFighter, action.AttackType)
elseif action.Kind == "Jump" then
if v102(mechanicsController, "IsSliding") == true then
v119(mechanicsController.HighJump, mechanicsController)
else
v119(mechanicsController.DoubleJumpRequest, mechanicsController)
v119(mechanicsController.JumpRequest, mechanicsController)
end
elseif action.Kind == "Crouch" then
v119(mechanicsController.SetCrouching, mechanicsController, action.Crouching)
elseif action.Kind == "Slide" then
task.spawn(v119, mechanicsController.Slide, mechanicsController)
end

state2.KeypointIndex = state2.KeypointIndex + 1
continue
end

break
end

if arg._lookRotation ~= nil then
local lookRotation = arg._lookRotation
v116.set(fn37(v116.get(), lookRotation, fn40(arg2)))
end

if not arg._finished and state2.KeypointIndex > #keypoints then
arg._finished = true
arg._finishedCallback("Completed")
end
end

index2._HasDiverged = function(arg, arg2)
local positions = arg._positions
if #positions == 0 then
return false
end

while arg._positionIndex < #positions and positions[arg._positionIndex + v86[63]].Offset <= arg2 do
arg._positionIndex = arg._positionIndex + v86[63]
end

local v120 = positions[arg._positionIndex]
local v121 = positions[arg._positionIndex + 1]
local position

if v121 == nil then
position = v120.Position
else
local n = v121.Offset - v120.Offset
position = v120.Position:Lerp(v121.Position, n > 0 and math.clamp((arg2 - v120.Offset) / n, v86[186], 1) or 0)
end

return (arg._mapAnchor:PointToWorldSpace(position) - arg._aliveState.RootPart.Position).Magnitude > 15
end

index2.Destroy = function(arg)
v115.release("MovementRecorder.Replay")
arg._moveHook:Destroy()
v119(mechanicsController.SetCrouching, mechanicsController, false)
end

return index2
end

tbl17.jW = function()
local jw = tbl17.cache.jW

if not jw then
local jw2 = { c = fn35() }
tbl17.cache.jW = jw2
jw = jw2
end

return jw.c
end
end
