local frames, commands, messages = {}, {}, {}
local now, party = 1, 2
function GetTime() return now end
function GetNumRaidMembers() return 0 end
function GetNumPartyMembers() return party end
function UnitName(unit) if unit=="player" then return "Alin" end return "Alon" end
function UnitIsUnit() return false end
function UnitIsConnected() return true end
function SendAddonMessage() error("UI must not start a resource request") end
function SendChatMessage(text, channel) table.insert(commands,{text,channel}) end
UIParent={}
DEFAULT_CHAT_FRAME={AddMessage=function(self,text)table.insert(messages,text)end}
SlashCmdList={}
function CreateFrame(kind,name,parent,template)
 local f={scripts={},shown=true}
 if name then frames[name]=f end
 function f:SetScript(k,fn) self.scripts[k]=fn end
 function f:SetText(text) self.text=text end
 function f:SetWidth(x) self.width=x end
 function f:SetHeight(y) self.height=y end
 function f:SetPoint(...) self.point=arg end
 function f:GetPoint() return "CENTER",UIParent,"CENTER",123,456 end
 function f:ClearAllPoints() self.point=nil end
 function f:IsShown() return self.shown end
 function f:Show()self.shown=true;if self.scripts.OnShow then self.scripts.OnShow() end end
 function f:Hide()self.shown=false;if self.scripts.OnHide then self.scripts.OnHide() end end
 function f:CreateFontString() return CreateFrame() end
 function f:RegisterEvent()end
 function f:SetFrameStrata()end
 function f:SetMovable()end
 function f:EnableMouse()end
 function f:RegisterForDrag()end
 function f:SetClampedToScreen()end
 function f:SetBackdrop()end
 function f:SetBackdropColor()end
 return f
end
GameTooltip={SetOwner=function()end,SetText=function()end,AddLine=function()end,Show=function()end,Hide=function()end}
WarbandQuestHelperDB={point="TOP",relativePoint="TOP",x=123,y=456,hidden=false,resourceMarkers="herbs"}
dofile(arg[1] or "WarbandQuestHelper/ResourceMarkers.lua")
dofile(arg[2] or "WarbandQuestHelper/WarbandQuestHelper.lua")
local M=WarbandQuestHelperResources
local panel=frames.WarbandQuestHelperFrame
local button=frames.WarbandQuestHelperResourcesButton
event="VARIABLES_LOADED"
frames.WarbandQuestHelperEventFrame.scripts.OnEvent()
assert(panel.height==123 and panel.width==246)
assert(panel.point[4]==123 and panel.point[5]==456 and panel.shown)
assert(button.text=="Resources: On")
for _,expected in ipairs({"off","on"}) do
 button.scripts.OnClick(); assert(M.Mode()==expected)
end
assert(table.getn(commands)==0,"resource control must not issue gameplay commands")
SlashCmdList.WARBANDQUESTHELPER("resources on")
assert(button.text=="Resources: On" and M.Mode()=="on")
SlashCmdList.WARBANDQUESTHELPER("resources invalid")
assert(M.Mode()=="on" and panel.shown)
local expected={Accept="do accept all quests",TurnIn="do talk to quest giver",Equip="do equip upgrades",UseObject="u go",SellJunk="s gray"}
for name,text in pairs(expected) do
 frames["WarbandQuestHelper"..name.."Button"].scripts.OnClick()
 assert(commands[table.getn(commands)][1]==text and commands[table.getn(commands)][2]=="PARTY")
end
SlashCmdList.WARBANDQUESTHELPER("");assert(not panel.shown and M.Mode()=="on","panel hiding preserves icon mode")
SlashCmdList.WARBANDQUESTHELPER("reset");assert(panel.shown and M.Mode()=="on" and not WarbandQuestHelperDB.hidden)
print("PASS: helper resource cycle/slash, saved position/visibility, independent icons and all existing command buttons")
