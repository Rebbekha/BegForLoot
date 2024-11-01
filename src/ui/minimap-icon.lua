local ADDON_NAME, Addon = ...
local Colors = Addon:GetModule("Colors")
local Commands = Addon:GetModule("Commands")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale")
local LDB = Addon:GetLibrary("LDB")
local LDBIcon = Addon:GetLibrary("LDBIcon")
local MinimapIcon = Addon:GetModule("MinimapIcon")
local SavedVariables = Addon:GetModule("SavedVariables")

local function addDoubleLine(tooltip, leftLine, rightLine)
  tooltip:AddDoubleLine(Colors.Yellow(leftLine), Colors.White(rightLine))
end

EventManager:Once(E.SavedVariablesReady, function()
  local object = LDB:NewDataObject(ADDON_NAME, {
    type = "data source",
    text = ADDON_NAME,
    icon = Addon:GetAsset("Begforloot-icon"),

    OnClick = function(_, button)
      if button == "LeftButton" then
        Commands.options()
      end

      if button == "RightButton" then
        Commands.loot()
      end
    end,

    OnTooltipShow = function(tooltip)
      tooltip:AddDoubleLine(Colors.Blue(ADDON_NAME), Colors.Gold(Addon.VERSION))
      tooltip:AddLine(" ")
      addDoubleLine(tooltip, L.LEFT_CLICK, L.COMMAND_DESCRIPTION_OPTIONS)
      addDoubleLine(tooltip, L.RIGHT_CLICK, L.COMMAND_DESCRIPTION_LOOT)
      
    end
  })
  LDBIcon:Register(ADDON_NAME, object, SavedVariables:GetGlobal().minimapIcon)

  function MinimapIcon:IsEnabled()
    return not SavedVariables:GetGlobal().minimapIcon.hide
  end

  function MinimapIcon:SetEnabled(enabled)
    SavedVariables:GetGlobal().minimapIcon.hide = not enabled
    LDBIcon:Refresh(ADDON_NAME)
  end
end)
