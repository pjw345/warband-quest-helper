-- Warband Quest Helper
-- A deliberately small Turtle WoW / Vanilla addon which sends the five
-- PlayerBots party commands used alongside the Warband addon.

local ADDON_NAME = "Warband Quest Helper"
local VERSION = "1.0.0"
local PANEL_WIDTH = 246
local PANEL_HEIGHT = 96

local function PrintMessage(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99" .. ADDON_NAME .. ":|r " .. message)
end

local function GetGroupChannel()
    if GetNumRaidMembers and GetNumRaidMembers() > 0 then
        return "RAID"
    end

    if GetNumPartyMembers and GetNumPartyMembers() > 0 then
        return "PARTY"
    end

    return nil
end

local function SendPartyBotCommand(command)
    local channel = GetGroupChannel()
    if not channel then
        PrintMessage("You are not in a party or raid.")
        return
    end

    -- These must be ordinary group-chat messages. Sending them through the
    -- addon-message channel causes cross-talk and malformed #a replies in this
    -- PlayerBots build.
    SendChatMessage(command, channel)
end

local frame = CreateFrame("Frame", "WarbandQuestHelperFrame", UIParent)
frame:SetWidth(PANEL_WIDTH)
frame:SetHeight(PANEL_HEIGHT)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, -160)
frame:SetFrameStrata("DIALOG")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frame:SetBackdropColor(0, 0, 0, 0.92)

frame:SetScript("OnDragStart", function()
    this:StartMoving()
end)

frame:SetScript("OnDragStop", function()
    this:StopMovingOrSizing()

    if not WarbandQuestHelperDB then
        WarbandQuestHelperDB = {}
    end

    local point, _, relativePoint, x, y = this:GetPoint()
    WarbandQuestHelperDB.point = point
    WarbandQuestHelperDB.relativePoint = relativePoint
    WarbandQuestHelperDB.x = x
    WarbandQuestHelperDB.y = y
end)

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOPLEFT", frame, "TOPLEFT", 13, -11)
title:SetText("Warband Quest Helper")

local close = CreateFrame("Button", "WarbandQuestHelperCloseButton", frame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)

local function CreateCommandButton(name, label, command, tooltip, x, y, width)
    local button = CreateFrame("Button", "WarbandQuestHelper" .. name .. "Button", frame, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)
    button:SetWidth(width)
    button:SetHeight(22)
    button:SetText(label)

    button:SetScript("OnClick", function()
        SendPartyBotCommand(command)
    end)

    button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_TOP")
        GameTooltip:SetText(tooltip)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    return button
end

CreateCommandButton(
    "Accept",
    "Accept",
    "do accept all quests",
    "Accept available quests from your targeted NPC (/p do accept all quests)",
    12,
    -34,
    70
)

CreateCommandButton(
    "TurnIn",
    "Turn In",
    "do talk to quest giver",
    "Turn in completed quests to your targeted NPC (/p do talk to quest giver)",
    88,
    -34,
    70
)

CreateCommandButton(
    "Equip",
    "Equip",
    "do equip upgrades",
    "Equip the best upgrades currently available in each bot's bags (/p do equip upgrades)",
    164,
    -34,
    70
)

CreateCommandButton(
    "UseObject",
    "Use Object",
    "u go",
    "Use the nearest suitable game object (/p u go)",
    12,
    -61,
    108
)

CreateCommandButton(
    "SellJunk",
    "Sell Junk",
    "s gray",
    "Sell grey-quality junk only; keeps equipment, supplies and crafting materials (/p s gray)",
    126,
    -61,
    108
)

local eventFrame = CreateFrame("Frame", "WarbandQuestHelperEventFrame")
eventFrame:RegisterEvent("VARIABLES_LOADED")
eventFrame:SetScript("OnEvent", function()
    if event ~= "VARIABLES_LOADED" then
        return
    end

    if not WarbandQuestHelperDB then
        WarbandQuestHelperDB = {}
    end

    if WarbandQuestHelperDB.point then
        frame:ClearAllPoints()
        frame:SetPoint(
            WarbandQuestHelperDB.point,
            UIParent,
            WarbandQuestHelperDB.relativePoint or WarbandQuestHelperDB.point,
            WarbandQuestHelperDB.x or 0,
            WarbandQuestHelperDB.y or 0
        )
    end

    if WarbandQuestHelperDB.hidden then
        frame:Hide()
    else
        frame:Show()
    end
end)

frame:SetScript("OnHide", function()
    if WarbandQuestHelperDB then
        WarbandQuestHelperDB.hidden = true
    end
end)

frame:SetScript("OnShow", function()
    if WarbandQuestHelperDB then
        WarbandQuestHelperDB.hidden = false
    end
end)

SLASH_WARBANDQUESTHELPER1 = "/wqh"
SLASH_WARBANDQUESTHELPER2 = "/warbandquesthelper"
SlashCmdList["WARBANDQUESTHELPER"] = function(message)
    message = string.lower(message or "")

    if message == "reset" then
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, -160)

        if not WarbandQuestHelperDB then
            WarbandQuestHelperDB = {}
        end

        WarbandQuestHelperDB.point = nil
        WarbandQuestHelperDB.relativePoint = nil
        WarbandQuestHelperDB.x = nil
        WarbandQuestHelperDB.y = nil
        WarbandQuestHelperDB.hidden = false
        frame:Show()
        PrintMessage("Position reset.")
        return
    end

    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

PrintMessage("v" .. VERSION .. " loaded. Use /wqh to show or hide the buttons.")
