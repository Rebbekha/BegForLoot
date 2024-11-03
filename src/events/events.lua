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
  "WinnerFound",
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
}
