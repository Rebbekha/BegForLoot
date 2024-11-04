local _, Addon = ...
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local SavedVariables = Addon:GetModule("SavedVariables")
local L = Addon:GetModule("Locale") ---@type Locale

local GLOBAL_SV = "__BEGFORLOOT_ADDON_GLOBAL_SAVED_VARIABLES__"
local PERCHAR_SV = "__BEGFORLOOT_ADDON_PERCHAR_SAVED_VARIABLES__"

-- ============================================================================
-- Local Functions
-- ============================================================================

local function globalDefaults()
  return {
  -- Global Option.
  PromoteAddon = true,
  minimapIcon = { hide = false },
  GroupLoot = true,
  optionMount = true,
  optionPet = true,
  optionRecipe = true,
    
  -- Offering Loot Option.
  ilvlUpgradeOffering = false,
  noTradeBindOnEquip = false,
  neverOffering = false,

  -- Receiving Loot Option
  transmogUnknown = true,
  transmogUnknownAppearanceOnly = true,
  transmogUnknownSharedAppearance = false,
  transmogUnknownForAllClass = false,
  transmogUnknownForMyClass = true,
  transmogUnknownForMySpec = false,

  ilvlUpgrade = { enabled = false, value = 0 },

  -- Whisper /Title
  TitleWhisper1 = L.TITLE_EDITBOX_1,
  TitleWhisper2 = L.TITLE_EDITBOX_2,
  TitleWhisper3 = L.TITLE_EDITBOX_3,

  TextWhisper1 = L.WHISPER_EDITBOX_1,
  TextWhisper2 = L.WHISPER_EDITBOX_2,
  TextWhisper3 = L.WHISPER_EDITBOX_3
  }
end

local function populate(t, defaults)
  for k, v in pairs(defaults) do
    if type(v) == "table" then
      if type(t[k]) ~= "table" then t[k] = {} end
      populate(t[k], v)
    else
      if type(t[k]) ~= type(v) then t[k] = v end
    end
  end
end

local function depopulate(t, defaults)
  for k, v in pairs(t) do
    if type(v) == "table" and type(defaults[k]) == "table" then
      depopulate(v, defaults[k])
      if next(v) == nil then t[k] = nil end
    elseif defaults[k] == v then
      t[k] = nil
    end
  end
end

-- ============================================================================
-- Events
-- ============================================================================

-- Initialize.
EventManager:Once(E.Wow.PlayerLogin, function()
  if type(_G[GLOBAL_SV]) ~= "table" then _G[GLOBAL_SV] = {} end
  populate(_G[GLOBAL_SV], globalDefaults())
  local global = _G[GLOBAL_SV]

  function SavedVariables:Get()
    return global
  end

  function SavedVariables:GetGlobal()
    return global
  end


  EventManager:Fire(E.SavedVariablesReady)

end)

-- Deinitialize.
EventManager:On(E.Wow.PlayerLogout, function()
  depopulate(_G[GLOBAL_SV], globalDefaults())
end)
