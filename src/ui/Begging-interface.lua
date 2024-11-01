local ADDON_NAME, Addon = ...
local L = Addon:GetModule("Locale") ---@class Locale
local Colors = Addon:GetModule("Colors") ---@type Colors
local Widgets = Addon:GetModule("Widgets") ---@class Widgets
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local SavedVariables = Addon:GetModule("SavedVariables")
local FonctionButton = Addon:GetModule("FonctionButton")
local BeggingInterface = Addon:GetModule("Begging-interface")

BEGGING_FRAME_X         = 'BEGGING_FRAME_X'
BEGGING_FRAME_Y         = 'BEGGING_FRAME_Y'
BEGGING_FRAME_WIDTH     = 'BEGGING_FRAME_WIDTH'
BEGGING_FRAME_HEIGHT    = 'BEGGING_FRAME_HEIGHT'

-- Variable to store the window
local beggingWindow = nil

-- ============================================================================
-- BeggingInterface
-- ============================================================================

local function SafeSetPoint(frame, point, relativeTo, relativePoint, xOffset, yOffset)
    if frame and relativeTo and frame ~= relativeTo then
        frame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
    else
        print("Warning: Attempted to anchor frame to itself or relativeTo is nil.")
    end
end

-- Restore the frame's position and size
local function RestoreMainWindowPosition()
    if not beggingWindow then return end  -- Ensure beggingWindow is not nil
    local x = WindowSettings[BEGGING_FRAME_X]
    local y = WindowSettings[BEGGING_FRAME_Y]
    local width = WindowSettings[BEGGING_FRAME_WIDTH]
    local height = WindowSettings[BEGGING_FRAME_HEIGHT]

    local s = beggingWindow:GetEffectiveScale()
    local uis = UIParent:GetScale()
    SafeSetPoint(beggingWindow, "CENTER", UIParent, "CENTER", x * uis / s, y * uis / s)
    beggingWindow:SetWidth(width)
    beggingWindow:SetHeight(height)
end

-- Function to show the window
function BeggingInterface:ShowWindow()
    if not beggingWindow then
        beggingWindow = self:CreateBeggingInterface()
		RestoreMainWindowPosition()  -- Restore position and size when showing the window
    end
    
    beggingWindow:Show()
end

function BeggingInterface:Hide()
  beggingWindow:Hide()
end

function BeggingInterface:Toggle()
  if not beggingWindow then
    beggingWindow = self:CreateBeggingInterface()
	RestoreMainWindowPosition()  -- Restore position and size when showing the window
  end
  if beggingWindow:IsShown() then
    beggingWindow:Hide()
  else
    beggingWindow:Show()
  end
end

-- ============================================================================
-- Initialisation
-- ============================================================================

-- Initialize WindowSettings if it does not exist
if not WindowSettings then
    WindowSettings = {
        [BEGGING_FRAME_X] = 0,
        [BEGGING_FRAME_Y] = 0,
        [BEGGING_FRAME_WIDTH] = 650,
        [BEGGING_FRAME_HEIGHT] = 200
    }
end


-- Save the frame's position and size
local function SaveMainWindowPosition()
    if not beggingWindow then return end  -- Ensure beggingWindow is not nil
    local xOfs, yOfs = beggingWindow:GetCenter()
    local s = beggingWindow:GetEffectiveScale()
    local uis = UIParent:GetScale()
    xOfs = xOfs * s - GetScreenWidth() * uis / 2
    yOfs = yOfs * s - GetScreenHeight() * uis / 2

    WindowSettings[BEGGING_FRAME_X] = xOfs / uis
    WindowSettings[BEGGING_FRAME_Y] = yOfs / uis
    WindowSettings[BEGGING_FRAME_WIDTH] = beggingWindow:GetWidth()
    WindowSettings[BEGGING_FRAME_HEIGHT] = beggingWindow:GetHeight()
end





-- ============================================================================
-- Frame
-- ============================================================================

-- Function to create the main window
function BeggingInterface:CreateBeggingInterface()
    local frame = Widgets:Window({
        name = ADDON_NAME .. "_ParentFrame",
        width = WindowSettings[BEGGING_FRAME_WIDTH],
        height = WindowSettings[BEGGING_FRAME_HEIGHT],
        titleText = Colors.Blue(ADDON_NAME),
    })

    frame:SetBackdropColor(0, 0, 0, 0.5)

    -- Enable dragging
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        SaveMainWindowPosition()
    end)

    -- Enable resizing
    frame:SetResizable(true)
    frame.minResizeWidth, frame.minResizeHeight = 620, 150
    frame.maxResizeWidth, frame.maxResizeHeight = 1600, 1600

    local resizeButton = CreateFrame("Button", nil, frame)
    resizeButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    resizeButton:SetSize(16, 16)
    resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

    resizeButton:SetScript("OnMouseDown", function(self, button)
        frame:StartSizing("BOTTOMRIGHT")
        self:GetHighlightTexture():Hide()
    end)
    resizeButton:SetScript("OnMouseUp", function(self, button)
        frame:StopMovingOrSizing()
        self:GetHighlightTexture():Show()

        -- Enforce minimum and maximum sizes
        local width, height = frame:GetSize()
        if width < frame.minResizeWidth then
            frame:SetWidth(frame.minResizeWidth)
        elseif width > frame.maxResizeWidth then
            frame:SetWidth(frame.maxResizeWidth)
        end

        if height < frame.minResizeHeight then
            frame:SetHeight(frame.minResizeHeight)
        elseif height > frame.maxResizeHeight then
            frame:SetHeight(frame.maxResizeHeight)
        end

        -- Save size
        SaveMainWindowPosition()
    end)
	
    -- Scroll Frame
    local scrollFrame = CreateFrame("ScrollFrame", ADDON_NAME .. "_ScrollFrame", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -30)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)
    frame.ScrollFrame = scrollFrame  -- Attach ScrollFrame to the frame

    -- Content Frame
    local content = CreateFrame("Frame", ADDON_NAME .. "_ContentFrame", scrollFrame)
    content:SetSize(scrollFrame:GetWidth(), scrollFrame:GetHeight())
    scrollFrame:SetScrollChild(content)
    frame.Content = content  -- Attach Content Frame to the frame

    -- Function to rearrange items and remove hidden ones
    function content:RearrangeItems()
        local yOffset = 0
        local newItems = {}
        for _, itemFrame in ipairs(content.items) do
            if itemFrame:IsShown() then
                itemFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -yOffset)
                yOffset = yOffset + 50
                table.insert(newItems, itemFrame)
            else
                itemFrame:Hide() -- Ensure it is hidden
            end
        end
        content.items = newItems
        content:SetHeight(yOffset)
		
	-- Check if there are no items displayed
		if #newItems == 0 and beggingWindow then
			beggingWindow:Hide()
		end
	end
	
	function content:PassAllItems()
    local playerName = UnitName("player")  -- Obtient le nom du joueur actuel
		for _, itemFrame in ipairs(content.items) do
			if itemFrame:IsShown() then
				-- Utilisez le champ playerName stocké
				if itemFrame.playerName ~= playerName then
					-- Clique sur le bouton Pass pour cet élément
					local passButton = itemFrame.buttonPass
					if passButton then
						passButton:Click()
					end
				end
			end
		end
	end

		--Pass All Button
	local passAllButton = CreateFrame("Button", nil, frame, "UIMenuButtonStretchTemplate")
	passAllButton:SetSize(80, 22)
	passAllButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -45, -5)  -- Ajustez la position selon vos besoins
	passAllButton:SetText(L.PASS_ALL)
	passAllButton:SetNormalFontObject("GameFontNormal")  -- Utilise GameFontNormal pour la police
	passAllButton:SetHighlightFontObject("GameFontHighlight")  -- Utilise GameFontHighlight pour le survol
	-- passAllButton:SetPushedFontObject("GameFontHighlight")  -- Utilise GameFontHighlight pour l'état enfoncé
	passAllButton:SetSize(passAllButton:GetTextWidth() + 10 , 25)
	passAllButton:SetScript("OnClick", function()
		-- Appel de la fonction pour passer tous les éléments
		content:PassAllItems()
	end)



		--Keep All Button
	local keepAllButton = CreateFrame("Button", nil, frame, "UIMenuButtonStretchTemplate")
	keepAllButton:SetSize(80, 22)
	keepAllButton:SetPoint("TOPRIGHT", passAllButton, "TOPLEFT", -5, 0)  -- Ajustez la position selon vos besoins
	keepAllButton:SetText(L.KEEP_ALL)
	keepAllButton:SetNormalFontObject("GameFontNormal")  -- Utilise GameFontNormal pour la police
	keepAllButton:SetHighlightFontObject("GameFontHighlight")  -- Utilise GameFontHighlight pour le survol
	keepAllButton:SetSize(keepAllButton:GetTextWidth() + 10 , 25)
	keepAllButton:SetScript("OnClick", function()
		-- Appel de la fonction pour passer tous les éléments
		content:KeepAllItems()
	end)

function content:KeepAllItems()
    local playerName = UnitName("player")  -- Obtient le nom du joueur actuel
    for _, itemFrame in ipairs(content.items) do
        if itemFrame:IsShown() then
            -- Utilisez le champ playerName stocké
            if itemFrame.playerName == playerName then
                -- Clique sur le bouton Pass pour cet élément
                local keepButton = itemFrame.buttonKeep
                if keepButton then
                    keepButton:Click()
                end
            end
        end
    end
end

		--Offer All Button
	local offerAllButton = CreateFrame("Button", nil, frame, "UIMenuButtonStretchTemplate")
	offerAllButton:SetSize(80, 22)
	offerAllButton:SetPoint("TOPRIGHT", keepAllButton, "TOPLEFT", -5, 0)  -- Ajustez la position selon vos besoins
	offerAllButton:SetText(L.OFFER_ALL)
	offerAllButton:SetNormalFontObject("GameFontNormal")  -- Utilise GameFontNormal pour la police
	offerAllButton:SetHighlightFontObject("GameFontHighlight")  -- Utilise GameFontHighlight pour le survol
	offerAllButton:SetSize(offerAllButton:GetTextWidth() + 10 , 25)
	offerAllButton:SetScript("OnClick", function()
		content:OfferAllItems()
	end)

function content:OfferAllItems()
  local playerName = UnitName("player")  -- Obtenir le nom du joueur actuel
  local itemLinks = {}  -- Table pour stocker les liens des objets

  -- Collecter tous les liens d'objets des cadres d'objets visibles appartenant au joueur
  for _, itemFrame in ipairs(content.items) do
    if itemFrame:IsShown() and itemFrame.playerName == playerName then
      table.insert(itemLinks, itemFrame.itemLink)
      itemFrame:Hide()
    end
  end
  content:RearrangeItems()

  -- Déterminer le canal de chat à utiliser en fonction du groupe actuel du joueur
  local chatChannel
  if IsInRaid() then
    chatChannel = "RAID"
  elseif IsInGroup() then
    local inInstance, instanceType = IsInInstance()
    if inInstance and instanceType == "party" then
      chatChannel = "INSTANCE_CHAT"
    else
      chatChannel = "PARTY"
    end
  else
    chatChannel = "SAY"
  end

  local messageInit = L.OFFER_ALL_ITEM
  local message
  local maxMessageLength = 255

  local i = 1
  while i <= #itemLinks do
    if i == 1 then 
	  message = messageInit
	else message = ""
	end
    local j = i
    while j <= #itemLinks do
      local testMessage = message .. " " .. itemLinks[j]
      if #testMessage > maxMessageLength then
        break
      else
        message = testMessage
      end
      j = j + 1
    end
    SendChatMessage(message, chatChannel)
    i = j  -- Passer à l'ensemble suivant d'objets
  end
end


    -- Function to add items to the frame
    function content:AddItem(playerName, itemLink, itemLevel, reason, hasSocket, hasIndestructible, hasLeech, hasSpeed, hasAvoidance)
    -- Ensure all parameters are properly defined
    playerName = playerName or "Unknown Player"
    itemLink = itemLink or "Unknown Item"
    itemLevel = itemLevel or 0
    reason = reason or "No Reason"
	local myName = UnitName("player") -- Get the name of the current player

    local itemFrame = CreateFrame("Frame", nil, content)
    itemFrame:SetSize(content:GetWidth() - 20, 50)
    itemFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -40 * #content.items)
	
	if playerName ~= myName then
	
    local itemText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    itemText:SetPoint("LEFT", itemFrame, "LEFT", 0, 0)
    itemText:SetText(playerName .. " " .. L.MAY_TRADE)
    itemFrame.itemText = itemText  -- Store the FontString

    local itemLinkButton = CreateFrame("Button", nil, itemFrame)
    itemLinkButton:SetPoint("LEFT", itemText, "RIGHT", 5, 0)
    itemLinkButton:SetNormalFontObject("GameFontHighlight")
    itemLinkButton:SetHighlightFontObject("GameFontHighlight")
    itemLinkButton:SetText(itemLink)
    itemLinkButton:SetSize(itemLinkButton:GetTextWidth(), itemText:GetHeight())
    itemLinkButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(itemLink)
        GameTooltip:Show()
    end)
    itemLinkButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

	local remainingText = string.format("|cff00ff00Ilvl %d|r |cffffd700%s|r |cffa335ee%s|r|cffffa500%s%s%s%s|r",
        itemLevel,
        reason,
        hasSocket and L.SOCKET or "",
        hasIndestructible and L.INDESTRUCTIBLE or "",
        hasLeech and L.LEECH or "",
        hasSpeed and L.SPEED or "",
        hasAvoidance and L.AVOIDANCE or "")

    local remainingTextLabel = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    remainingTextLabel:SetPoint("LEFT", itemLinkButton, "RIGHT", 5, 0)
    remainingTextLabel:SetText(remainingText)

    local buttonPass = CreateFrame("Button", nil, itemFrame, "UIMenuButtonStretchTemplate")
    buttonPass:SetSize(80, 22)
    buttonPass:SetPoint("TOPLEFT", itemText, "BOTTOMLEFT", 0, -2)
    buttonPass:SetText(L.PASS)
    itemFrame.buttonPass = buttonPass  -- Store the Pass button
	buttonPass:SetScript("OnClick", function()
		itemFrame:Hide() -- Hide the item frame
		content:RearrangeItems() -- Rearrange items
	end)	

    local buttonWhisper1 = CreateFrame("Button", nil, itemFrame, "UIPanelButtonTemplate")
    buttonWhisper1:SetSize(80, 22)
    buttonWhisper1:SetPoint("LEFT", buttonPass, "RIGHT", 45, 0)
    buttonWhisper1:SetText(TitleButton1 or "Whisper1")
    buttonWhisper1:SetSize(buttonWhisper1:GetTextWidth()+20, buttonPass:GetHeight())
    buttonWhisper1:SetScript("OnClick", function()
        FonctionButton:SendWhisper(Whisper1, playerName, itemLink)
		itemFrame:Hide() -- Hide the item frame
		content:RearrangeItems() -- Rearrange items
    end)

    local buttonWhisper2 = CreateFrame("Button", nil, itemFrame, "MagicButtonTemplate")
    buttonWhisper2:SetSize(80, 22)
    buttonWhisper2:SetPoint("LEFT", buttonWhisper1, "RIGHT", 5, 0)
    buttonWhisper2:SetText(TitleButton2 or "Whisper2")
    buttonWhisper2:SetSize(buttonWhisper2:GetTextWidth()+20, buttonPass:GetHeight())
    buttonWhisper2:SetScript("OnClick", function()
        FonctionButton:SendWhisper(Whisper2, playerName, itemLink)
		itemFrame:Hide() -- Hide the item frame
		content:RearrangeItems() -- Rearrange items
    end)        

    local buttonWhisper3 = CreateFrame("Button", nil, itemFrame, "UIPanelButtonTemplate")
    buttonWhisper3:SetSize(80, 22)
    buttonWhisper3:SetPoint("LEFT", buttonWhisper2, "RIGHT", 5, 0)
    buttonWhisper3:SetText(TitleButton3 or "Whisper3")
    buttonWhisper3:SetSize(buttonWhisper3:GetTextWidth()+20, buttonPass:GetHeight())
    buttonWhisper3:SetScript("OnClick", function()
        FonctionButton:SendWhisper(Whisper3, playerName, itemLink)
		itemFrame:Hide() -- Hide the item frame
		content:RearrangeItems() -- Rearrange items
    end)
	
	---You offer a loot
	elseif playerName == myName then
	
	local itemText = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    itemText:SetPoint("LEFT", itemFrame, "LEFT", 0, 0)
    itemText:SetText(L.CAN_OFFER_ITEM)
    itemFrame.itemText = itemText  -- Store the FontString

    local itemLinkButton = CreateFrame("Button", nil, itemFrame)
    itemLinkButton:SetPoint("LEFT", itemText, "RIGHT", 5, 0)
    itemLinkButton:SetNormalFontObject("GameFontHighlight")
    itemLinkButton:SetHighlightFontObject("GameFontHighlight")
    itemLinkButton:SetText(itemLink)
    itemLinkButton:SetSize(itemLinkButton:GetTextWidth(), itemText:GetHeight())
    itemLinkButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(itemLink)
        GameTooltip:Show()
    end)
    itemLinkButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    local remainingText = string.format("|cff00ff00Ilvl %d|r |cffa335ee%s|r|cffffa500%s%s%s%s|r",
        itemLevel,
        hasSocket and L.SOCKET or "",
        hasIndestructible and L.INDESTRUCTIBLE or "",
        hasLeech and L.LEECH or "",
        hasSpeed and L.SPEED or "",
        hasAvoidance and L.AVOIDANCE or "")

    local remainingTextLabel = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    remainingTextLabel:SetPoint("LEFT", itemLinkButton, "RIGHT", 5, 0)
    remainingTextLabel:SetText(remainingText)

    local buttonKeep = CreateFrame("Button", nil, itemFrame, "UIMenuButtonStretchTemplate")
    buttonKeep:SetSize(80, 22)
    buttonKeep:SetPoint("TOPLEFT", itemText, "BOTTOMLEFT", 0, -2)
    buttonKeep:SetText(L.KEEP)
    itemFrame.buttonKeep = buttonKeep  -- Store the Keep button
	buttonKeep:SetScript("OnClick", function()
		itemFrame:Hide() -- Hide the item frame
		content:RearrangeItems() -- Rearrange items
	end)	

    local buttonOffer = CreateFrame("Button", nil, itemFrame, "UIPanelButtonTemplate")
    buttonOffer:SetSize(80, 22)
    buttonOffer:SetPoint("LEFT", buttonKeep, "RIGHT", 45, 0)
    buttonOffer:SetText(L.OFFER_ITEM)
    buttonOffer:SetSize(buttonOffer:GetTextWidth()+20, buttonKeep:GetHeight())
	itemFrame.buttonOffer = buttonOffer
    buttonOffer:SetScript("OnClick", function()
        FonctionButton:SendMessage(L.Whisper, itemLink)
		itemFrame:Hide() -- Hide the item frame
		content:RearrangeItems() -- Rearrange items
    end)
	
	end 
    -- Store playerName in the frame for easy access
    itemFrame.playerName = playerName
	itemFrame.itemLink = itemLink
    content.items[#content.items + 1] = itemFrame
    content:SetHeight(#content.items * 50)
end

    content.items = {}

    return frame
end

-- Function to add item to the BeggingInterface
function BeggingInterface:AddItemToInterface(playerName, item, realItemLevel, reason, hasSocket, hasIndestructible, hasLeech, hasSpeed, hasAvoidance)
    if not beggingWindow then
        self:ShowWindow()  -- Ensure the window is shown before adding items
    end
    local content = beggingWindow.ScrollFrame:GetScrollChild()
    content:AddItem(playerName, item, realItemLevel, reason, hasSocket, hasIndestructible, hasLeech, hasSpeed, hasAvoidance)
    content:RearrangeItems()
end

-- Event handler for NewObjectList
local function OnNewObjectList()
    local objectInfo = ObjectList[#ObjectList]
    if objectInfo then
        BeggingInterface:AddItemToInterface(objectInfo.playerName, objectInfo.item, objectInfo.realItemLevel, objectInfo.reason, objectInfo.hasSocket, objectInfo.hasIndestructible, objectInfo.hasLeech, objectInfo.hasSpeed, objectInfo.hasAvoidance)
    end
end


-- ============================================================================
-- Events
-- ============================================================================
EventManager:On(E.NewObjectList, function()
    BeggingInterface:ShowWindow()
    OnNewObjectList()
end)

EventManager:On(E.UpdateText, function()
	TitleButton1 = SavedVariables:Get().TitleWhisper1
	TitleButton2 = SavedVariables:Get().TitleWhisper2
	TitleButton3 = SavedVariables:Get().TitleWhisper3
	Whisper1 = SavedVariables:Get().TextWhisper1
	Whisper2 = SavedVariables:Get().TextWhisper2
	Whisper3 = SavedVariables:Get().TextWhisper3

end)

EventManager:On(E.SavedVariablesReady, function()
	TitleButton1 = SavedVariables:Get().TitleWhisper1
	TitleButton2 = SavedVariables:Get().TitleWhisper2
	TitleButton3 = SavedVariables:Get().TitleWhisper3
	Whisper1 = SavedVariables:Get().TextWhisper1
	Whisper2 = SavedVariables:Get().TextWhisper2
	Whisper3 = SavedVariables:Get().TextWhisper3
	if not WindowSettings[BEGGING_FRAME_X] then
        WindowSettings = {
            [BEGGING_FRAME_X] = 0,
            [BEGGING_FRAME_Y] = 0,
            [BEGGING_FRAME_WIDTH] = 650,
            [BEGGING_FRAME_HEIGHT] = 200
        }
    end
	-- Call RestoreMainWindowPosition here if needed
    RestoreMainWindowPosition()
	
end)

-- ============================================================================
-- Debug
-- ============================================================================
local Booleendebug = false
if Booleendebug then
EventManager:On("PLAYER_REGEN_DISABLED", function()
--debug
-- Simulate ObjectList with two items
local MyName = UnitName("player")
ObjectList = {
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:168857::::::::120:254::6:4:4800:1808:1507:4786:::|h[Azshara's Font of Power]|h|r",
        itemLevel = 475,
        reason = "OfferItem",
        hasSocket = true,
        hasIndestructible = false,
        hasLeech = true,
        hasSpeed = false,
        hasAvoidance = false
    },
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:174530::::::::120:254::5:3:4823:1502:4786:::|h[Devastation's Hour]|h|r",
        itemLevel = 400,
        reason = "OfferItem",
        hasSocket = true,
        hasIndestructible = false,
        hasLeech = true,
        hasSpeed = false,
        hasAvoidance = false
    },
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:173946::::::::120:254::6:4:4800:1808:1507:4786:::|h[Shimmering Jewel]|h|r",
        itemLevel = 460,
        reason = "OfferItem",
        hasSocket = true,
        hasIndestructible = true,
        hasLeech = false,
        hasSpeed = true,
        hasAvoidance = false
    },
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:175007::::::::120:254::5:3:4823:1502:4786:::|h[Twilight's Edge]|h|r",
        itemLevel = 450,
        reason = "OfferItem",
        hasSocket = false,
        hasIndestructible = false,
        hasLeech = true,
        hasSpeed = true,
        hasAvoidance = false
    },
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:174958::::::::120:254::6:4:4800:1808:1507:4786:::|h[Stormpike's Revenge]|h|r",
        itemLevel = 470,
        reason = "OfferItem",
        hasSocket = true,
        hasIndestructible = true,
        hasLeech = false,
        hasSpeed = false,
        hasAvoidance = true
    },
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:173943::::::::120:254::6:4:4800:1808:1507:4786:::|h[Hood of the Hidden Path]|h|r",
        itemLevel = 455,
        reason = "OfferItem",
        hasSocket = false,
        hasIndestructible = false,
        hasLeech = true,
        hasSpeed = false,
        hasAvoidance = true
    },
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:175004::::::::120:254::5:3:4823:1502:4786:::|h[Warden's Pride]|h|r",
        itemLevel = 440,
        reason = "OfferItem",
        hasSocket = true,
        hasIndestructible = false,
        hasLeech = false,
        hasSpeed = true,
        hasAvoidance = true
    },
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:173944::::::::120:254::6:4:4800:1808:1507:4786:::|h[Mantle of the Dark Sea]|h|r",
        itemLevel = 465,
        reason = "OfferItem",
        hasSocket = false,
        hasIndestructible = true,
        hasLeech = true,
        hasSpeed = false,
        hasAvoidance = false
    },
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:175008::::::::120:254::5:3:4823:1502:4786:::|h[Sword of the Forgotten Queen]|h|r",
        itemLevel = 430,
        reason = "OfferItem",
        hasSocket = true,
        hasIndestructible = false,
        hasLeech = true,
        hasSpeed = true,
        hasAvoidance = false
    },
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:174956::::::::120:254::6:4:4800:1808:1507:4786:::|h[Signet of the Lost Empire]|h|r",
        itemLevel = 445,
        reason = "OfferItem",
        hasSocket = true,
        hasIndestructible = true,
        hasLeech = false,
        hasSpeed = true,
        hasAvoidance = true
    },
    {
        playerName = MyName,
        itemLink = "|cffa335ee|Hitem:173945::::::::120:254::6:4:4800:1808:1507:4786:::|h[Gloves of the Searing Touch]|h|r",
        itemLevel = 460,
        reason = "OfferItem",
        hasSocket = false,
        hasIndestructible = false,
        hasLeech = true,
        hasSpeed = false,
        hasAvoidance = true
    },
    {
        playerName = "PlayerTwo",
        itemLink = "|cffa335ee|Hitem:174530::::::::120:254::5:3:4823:1502:4786:::|h[Devastation's Hour]|h|r",
        itemLevel = 470,
        reason = "OfferItem",
        hasSocket = false,
        hasIndestructible = true,
        hasLeech = false,
        hasSpeed = true,
        hasAvoidance = true
    }
}

-- Function to show the window and add items from ObjectList
function BeggingInterface:ShowWindowAndAddItems()
    self:ShowWindow()
    for _, item in ipairs(ObjectList) do
        self:AddItemToInterface(item.playerName, item.itemLink, item.itemLevel, item.reason, item.hasSocket, item.hasIndestructible, item.hasLeech, item.hasSpeed, item.hasAvoidance)
    end
end

-- Call the function to show window and add items

BeggingInterface:ShowWindowAndAddItems()
end)

end

