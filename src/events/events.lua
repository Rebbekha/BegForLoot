local AddonName, Addon = ...
local E = Addon:GetModule("Events")

-- ============================================================================
-- Addon Events
-- ============================================================================

local events = {


  -- SavedVariables.
  "SavedVariablesReady",
  "NewObjectList",
  "NewReceivedItems",
  "UpdateText"
}

for _, event in pairs(events) do
  E[event] = ("%s_%s"):format(AddonName, event)
end

-- ============================================================================
-- WoW Events
-- ============================================================================

E.Wow = {
  EncounterLootReceived = "ENCOUNTER_LOOT_RECEIVED",
  PlayerLogin = "PLAYER_LOGIN",
  PlayerLogout = "PLAYER_LOGOUT",
  ChatMsgLoot = "CHAT_MSG_LOOT",
  LootHistoryUpdateDrop = "LOOT_HISTORY_UPDATE_DROP",
  Groupjoined = "GROUP_JOINED",
  GroupLeft = "GROUP_LEFT"
}
