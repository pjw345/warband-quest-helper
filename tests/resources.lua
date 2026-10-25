local now, roster, sent = 10, { "Alon", "Mercy" }, {}
function GetTime() return now end
function GetNumRaidMembers() return 0 end
function GetNumPartyMembers() return table.getn(roster) end
function UnitName(unit) if unit == "player" then return "Alin" end return roster[tonumber(string.sub(unit, 6))] end
function UnitIsUnit() return false end
function UnitIsConnected() return true end
function SendAddonMessage(...) table.insert(sent, arg) end
function CreateFrame()
  local f = { shown = false }
  function f:RegisterEvent() end
  function f:SetScript(name, fn) self.scripts = self.scripts or {}; self.scripts[name] = fn end
  function f:EnableMouse(value) self.mouseEnabled = value end
  function f:Hide()
    self.shown = false
    if self.scripts and self.scripts.OnHide then
      local previous=this;this=self;self.scripts.OnHide();this=previous
    end
  end
  function f:Show() self.shown = true end
  function f:SetWidth() end
  function f:SetHeight() end
  function f:SetFrameLevel() end
  function f:CreateTexture()
    return { SetAllPoints = function() end, SetTexture = function(self, value) self.value = value end,
      SetVertexColor = function(self,r,g,b,a) self.vertex={r,g,b,a} end }
  end
  function f:ClearAllPoints() end
  function f:SetPoint(a,b,c,x,y) self.x, self.y = x,y end
  return f
end
local selectedZone, playerX, playerY = 38, 0.5, 0.5
function GetPlayerMapPosition() return playerX, playerY end
function GetRealZoneText() return "Loch Modan" end
Minimap = { GetZoom = function() return 0 end, GetWidth = function() return 140 end,
  GetHeight = function() return 140 end, GetFrameLevel = function() return 1 end }
function Minimap:GetScript(name) return self[name] end
GameTooltip = { hides = 0 }
function GameTooltip:SetOwner(owner) self.owner = owner end
function GameTooltip:GetOwner() return self.owner end
function GameTooltip:SetText(text) self.text = text end
function GameTooltip:Show() self.shown = true end
function GameTooltip:Hide() self.shown = false; self.hides = self.hides + 1 end
pfDB = { objects = { loc = { [1731] = "Copper Vein", [1617] = "Silverleaf" } } }
pfQuestCompat = {}
pfMap = { minimap_sizes = { [38] = {1000,1000} }, minimap_zoom = {[1]={[0]=300}},
  minimap_indoor = function() return 1 end, GetMapIDByName = function() return 38 end,
  GetMapID = function() return selectedZone end }
WarbandQuestHelperDB, SlashCmdList = {}, {}
DEFAULT_CHAT_FRAME = { AddMessage = function() end }
dofile(arg[1] or "ResourceMarkers.lua")
local M = WarbandQuestHelperResources
local function wanted(name, token) M.wanted[name] = token end
local function receive(body, sender, prefix) M.Receive(prefix or "RESBOT",body,"GUILD",sender or "Alin") end
local row = "17370383791809394007,1731,O,51.000,50.000"
local herb = "17370383791809394008,1617,H,50.000,51.000"
M.Poll(); assert(table.getn(sent)==2 and sent[1][1]=="RESSELF" and sent[1][3]=="GUILD" and sent[2][1]=="RESBOT" and sent[2][3]=="PARTY")
wanted("Alon","1")
receive("S:1:1:Alon:38:1:2:"..row)
assert(not M.snapshots.Alon, "partial snapshot must not appear")
receive("S:1:1:Alon:38:2:2:"..herb)
assert(table.getn(M.VisibleNodes(38))==2)
wanted("Mercy","1"); receive("S:1:1:Mercy:38:1:1:"..row)
assert(table.getn(M.VisibleNodes(38))==2, "deduplicate the same GUID across bots")
M.Draw(); assert(M.pins[1].shown and M.pins[2].shown)
local foundEast = false
for _, pin in ipairs(M.pins) do if pin.x > 0 and pin.y == 0 then foundEast=true end end
assert(foundEast, "ore east of player must draw to the right")
-- Yellow dot artwork and localized hover names, without repeated hover flicker.
for _, pin in ipairs(M.pins) do
  assert(pin.mouseEnabled and string.find(pin.texture.value, "pfQuest", 1, true))
  assert(pin.texture.vertex[1]==1 and pin.texture.vertex[2]==1 and pin.texture.vertex[3]==0)
end
local hovered=M.pins[1];this=hovered;hovered.scripts.OnEnter()
assert(GameTooltip.shown and GameTooltip.text==M.ResourceName(hovered.row))
assert(M.ResourceName({entry=1731,kind="O"})=="Copper Vein")
assert(M.ResourceName({entry=1617,kind="H"})=="Silverleaf")
assert(M.ResourceName({entry=999999,kind="O"})=="Ore (object 999999)")
local hides=GameTooltip.hides
M.Draw();M.Draw();assert(GameTooltip.hides==hides and M.hovered==hovered, "redraw must retain hovered marker")
local stored=M.snapshots
M.snapshots={Alon={zone=38,expires=now+12,rows={{guid="9",entry=1731,kind="O",x=51,y=50}}}}
M.Draw();assert(GameTooltip.text=="Copper Vein", "recycled hovered pin updates its tooltip")
local manualClicks=0
Minimap.OnMouseUp=function(self,button) assert(self==Minimap and this==Minimap and button=="LeftButton");manualClicks=manualClicks+1 end
this=hovered;arg1="LeftButton";hovered.scripts.OnMouseUp()
assert(manualClicks==1 and this==hovered,"map click is forwarded with original context restored")
M.Clear();assert(not GameTooltip.shown and M.hovered==nil,"clear removes owned tooltip")
M.snapshots=stored;M.Draw();hovered=M.pins[1];this=hovered;hovered.scripts.OnEnter()
local other={};GameTooltip.owner=other;GameTooltip:Show();M.HideTooltip(hovered)
assert(GameTooltip.shown,"resource cleanup must preserve another UI tooltip")
this=hovered;hovered.scripts.OnEnter()

selectedZone=12; M.Draw(); assert(not M.pins[1].shown and not GameTooltip.shown and not M.hovered, "other world-map selection must hide pins and tooltip")
selectedZone=38; playerX=0; playerY=0; M.Draw()
assert(not M.pins[1].shown, "unsupported instance coordinates must hide pins")
playerX=0.5; playerY=0.5
M.pending={}; wanted("Alon","3")
receive("S:1:3:Alon:38:2:2:"..herb)
assert(M.snapshots.Alon.rows[1].guid=="17370383791809394007", "partial replacement preserves previous snapshot")
receive("S:1:3:Alon:38:1:2:"..row)
assert(table.getn(M.snapshots.Alon.rows)==2, "out of order pages assembled atomically")
WarbandQuestHelperDB.resourceMarkers="ore"; assert(M.Mode()=="on" and table.getn(M.VisibleNodes(38))==2)
WarbandQuestHelperDB.resourceMarkers="herbs"; assert(M.Mode()=="on" and table.getn(M.VisibleNodes(38))==2)
WarbandQuestHelperDB.resourceMarkers="both"
local original = M.snapshots.Alon
for _, body in ipairs({ "S:1:2:Alon:38:1:1:"..row,
  "S:1:1:Stranger:38:1:1:"..row, "S:1:1:Alon:38:17:17:"..row,
  "S:1:1:Alon:38:1:1:1,1731,O,nan,50.000", "S:1:1:Alon:38:1:1:1,1731,O,101.000,50.000",
  "S:1:1:Alon:38:1:1:"..row..";"..row }) do
  wanted("Alon","1"); M.pending={}; receive(body); assert(M.snapshots.Alon==original, body)
end
wanted("Alon","1"); receive("S:1:1:Alon:38:1:1:","Stranger"); assert(M.snapshots.Alon==original)
receive("S:1:1:Alon:38:1:1:","Alin","BOT"); assert(M.snapshots.Alon==original)
M.pending={}; receive("S:1:1:Alon:38:1:1:")
assert(table.getn(M.snapshots.Alon.rows)==0, "empty snapshot clears depleted nodes")
roster={"Alon"}; assert(table.getn(M.VisibleNodes(38))==0, "departed bot loses its markers")
roster={"Alon","Mercy"}; now=23; assert(table.getn(M.VisibleNodes(38))==0, "stale data expires")
WarbandQuestHelperDB.resourceMarkers="off"; M.Poll(); assert(not next(M.snapshots) and not next(M.wanted))
WarbandQuestHelperDB.resourceMarkers="both"; pfMap=nil; M.Poll(); assert(not next(M.wanted), "no requests without rendering support")
WarbandQuestHelperDB.resourceMarkers = {}; assert(M.Mode()=="on", "invalid saved setting uses safe default")
print("PASS: Lua 5.0 resources, yellow dots, hover names/stability/cleanup, native clicks and map isolation")

WarbandQuestHelperDB = { x = 123, hidden = true }
assert(M.SetMode("on") and M.Mode()=="on")
assert(WarbandQuestHelperDB.x==123 and WarbandQuestHelperDB.hidden, "resource modes preserve panel settings")
assert(not M.SetMode("invalid") and M.Mode()=="on")

-- A new session with only the human still requests and displays its own skills.
pfMap = { minimap_sizes = {}, minimap_zoom = {}, minimap_indoor = function()end,
  GetMapIDByName = function() return 38 end }
WarbandQuestHelperDB.resourceMarkers="on";roster={};sent={};M.Clear();M.Poll()
assert(table.getn(sent)==1 and sent[1][1]=="RESSELF" and M.wanted.Alin)
local selfToken=M.wanted.Alin
receive("S:1:"..selfToken..":Alin:38:1:1:"..herb)
assert(table.getn(M.VisibleNodes(38))==1,"human's herb is visible without a bot or group")
roster={"Alon"};M.Poll();wanted("Alon","20");wanted("Alin","20")
receive("S:1:20:Alon:38:1:1:"..row)
receive("S:1:20:Alin:38:1:1:"..herb)
assert(table.getn(M.VisibleNodes(38))==2,"one switch shows human herbs plus bot ore")
roster={};assert(table.getn(M.VisibleNodes(38))==1,"human icons survive last bot leaving")
M.SetMode("off");sent={};M.Poll();assert(table.getn(sent)==0 and not next(M.snapshots),"Off stops both feeds")
print("PASS: own/party profession union, solo polling and unified On/Off")
