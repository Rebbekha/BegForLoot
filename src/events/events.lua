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
  BagUpdate = "BAG_UPDATE",
  BagUpdateDelayed = "BAG_UPDATE_DELAYED",
  EncounterLootReceived = "ENCOUNTER_LOOT_RECEIVED",
  PlayerLogin = "PLAYER_LOGIN",
  PlayerLogout = "PLAYER_LOGOUT",
  UIErrorMessage = "UI_ERROR_MESSAGE",
  InspectReadyEvent = "INSPECT_READY",
  CombatStatusChangedEvent = "PLAYER_REGEN_DISABLED"
}
