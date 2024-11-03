local ADDON_NAME, Addon = ...
local FonctionButton = Addon:GetModule("FonctionButton")


--[[ FUNCTIONS FIRED WHEN USER CLICKS BUTTON ON THE SCREEN ]]


-------------------------------
---- Item looted by myself ----
-------------------------------

-- called when the player clicks 'offer to group' to put an item up for trade
-- function PLH_DoTradeItem(lootedItemIndex)
	-- local lootedItem = lootedItems[lootedItemIndex]
	-- lootedItem[STATUS] = STATUS_AVAILABLE
	-- if not PLH_PREFS[PLH_PREFS_SKIP_CONFIRMATION] then
		-- lootedItem[CONFIRMATION_MESSAGE] = "Thank you! Other PLH users are being told this item is\navailable. If anyone requests the item, PLH will notify you."
	-- end
	-- UpdateLootedItemsDisplay()
	-- PLH_STATS[PLH_ITEMS_OFFERED] = PLH_STATS[PLH_ITEMS_OFFERED] + 1

	-- local addonTextString = CreateAddonTextString("TRADE", lootedItem, lootedItem[FULL_ITEM_INFO][FII_ITEM])
	-- PLH_SendAddonMessage(addonTextString)
-- end

-- -- called when the player clicks 'keep' for an item
-- function PLH_DoKeepItem(lootedItemIndex)
	-- local lootedItem = lootedItems[lootedItemIndex]

	-- if lootedItem[STATUS] ~= STATUS_DEFAULT then
		-- local addonTextString = CreateAddonTextString("KEEP", lootedItem)
		-- PLH_SendAddonMessage(addonTextString)
	-- end

	-- lootedItem[STATUS] = STATUS_HIDDEN
	-- UpdateLootedItemsDisplay()
-- end


----------------------------------
----- Item looted by other -------
----------------------------------

-- called when the player clicks on a Whisper button

local function ReplaceItemInMessage(itemLink, message)
	if message == nil then
		message = "Bug error no message"
	end
	return message:gsub('%%item', itemLink)
end

function FonctionButton:SendWhisper(Whisper, playerName, itemlink)
  local PromoteAddon = SavedVariables:Get().PromoteAddon
  local message = ReplaceItemInMessage(itemlink, Whisper)
  if PromoteAddon then
    message = "<Beg For Loot> " .. ReplaceItemInMessage(itemlink, Whisper)
  end
  SendChatMessage(message, 'WHISPER', nil, Ambiguate(playerName, 'mail'))
end

function FonctionButton:SendMessage(Whisper, itemlink)
  local PromoteAddon = SavedVariables:Get().PromoteAddon
  local message = ReplaceItemInMessage(itemlink, Whisper)
  if PromoteAddon then
    message = "<Beg For Loot> " .. ReplaceItemInMessage(itemlink, Whisper)
  end
  
  if IsInRaid() then
    SendChatMessage(message, "RAID")
  elseif IsInGroup() then
    SendChatMessage(message, "PARTY")
  else
    SendChatMessage(message, "SAY")
  end

end

----------------------------------
----- Item offered by other -------
----------------------------------

-- called when the player clicks 'MS'

-- called when the player clicks 'OS'

-- called when the player clicks 'Xmog'

-- called when the player clicks

-- called when the player clicks 'ok' for an item
-- function PLH_DoHideItem(lootedItemIndex)
	-- local lootedItem = lootedItems[lootedItemIndex]
	-- lootedItem[STATUS] = STATUS_HIDDEN
	-- UpdateLootedItemsDisplay()
-- end



-- function PLH_DoClearConfirmationMessage(lootedItemIndex)
	-- local lootedItem = lootedItems[lootedItemIndex]
	-- lootedItem[CONFIRMATION_MESSAGE] = nil
	-- UpdateLootedItemsDisplay()
-- end



-- -- called when the player clicks 'offer' to give an item to a specific player
-- function PLH_DoOfferItem(lootedItemIndex)
	-- local lootedItem = lootedItems[lootedItemIndex]
	-- if lootedItem[SELECTED_REQUESTOR_INDEX] == '' then
		-- lootedItem[SELECTED_REQUESTOR_INDEX] = lootedItem[DEFAULT_REQUESTOR_INDEX]
	-- end
	-- local requestorIndex = lootedItem[SELECTED_REQUESTOR_INDEX]
	-- local requestor = lootedItem[REQUESTORS][requestorIndex]
	-- lootedItem[STATUS] = STATUS_OFFERED
	-- UpdateLootedItemsDisplay()
	-- PLH_STATS[PLH_ITEMS_GIVEN_AWAY] = PLH_STATS[PLH_ITEMS_GIVEN_AWAY] + 1

	-- local addonTextString = CreateAddonTextString("OFFER", lootedItem, requestor[REQUESTOR_NAME])
	-- PLH_SendAddonMessage(addonTextString)
-- end

-- -- called when the player clicks to request an item that has been looted by another player
-- function PLH_DoRequestItem(lootedItemIndex, requestType)
	-- local lootedItem = lootedItems[lootedItemIndex]
	-- lootedItem[STATUS] = STATUS_REQUESTED
	-- if not PLH_PREFS[PLH_PREFS_SKIP_CONFIRMATION] then
		-- lootedItem[CONFIRMATION_MESSAGE] = "Your request is being sent to " .. Ambiguate(lootedItem[LOOTER_NAME], 'all') .. ".\nPLH will notify you when they make their decision."
	-- end
	-- UpdateLootedItemsDisplay()
	-- PLH_STATS[PLH_ITEMS_REQUESTED] = PLH_STATS[PLH_ITEMS_REQUESTED] + 1

	-- local addonTextString = CreateAddonTextString("REQUEST", lootedItem, requestType)
	-- PLH_SendAddonMessage(addonTextString, lootedItem[LOOTER_NAME])
-- end

-- function PLH_DoWhisper(lootedItemIndex)
	-- local lootedItem = lootedItems[lootedItemIndex]
	-- lootedItem[STATUS] = STATUS_REQUESTED_VIA_WHISPER
	-- UpdateLootedItemsDisplay()

	-- SendChatMessage(PLH_GetWhisperMessage(lootedItem[FULL_ITEM_INFO][FII_ITEM]), 'WHISPER', nil, Ambiguate(lootedItem[LOOTER_NAME], 'mail'))
-- end
