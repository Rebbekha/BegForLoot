local _, Addon = ...
local Colors = Addon:GetModule("Colors") ---@type Colors
local Commands = Addon:GetModule("Commands")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale") ---@type Locale
local UserInterface = Addon:GetModule("UserInterface")
local BeggingInterface = Addon:GetModule("Begging-interface")

-- ============================================================================
-- Events
-- ============================================================================

EventManager:Once("PLAYER_LOGIN", function()
  SLASH_BEGFORLOOT1 = "/begforloot"
  SlashCmdList["BEGFORLOOT"] = function(msg)
    msg = strlower(msg or "")

    -- Split message into args.
    local args = {}
    for arg in msg:gmatch("%S+") do args[#args + 1] = strlower(arg) end

    -- First arg is command name.
    local key = table.remove(args, 1)
    key = type(Commands[key]) == "function" and key or "help"
    Commands[key](unpack(args))
  end
end)

-- ============================================================================
-- Commands
-- ============================================================================

function Commands.help()
  Addon:ForcePrint(L.COMMANDS .. ":")
  Addon:ForcePrint(Colors.Gold("  /begforloot"), "-", L.COMMAND_DESCRIPTION_HELP)
  Addon:ForcePrint(Colors.Gold("  /begforloot options"), "-", L.COMMAND_DESCRIPTION_OPTIONS)
  Addon:ForcePrint(Colors.Gold("  /begforloot loot"), "-", L.COMMAND_DESCRIPTION_LOOT_FRAME)
end

function Commands.options()
  UserInterface:Toggle()
end

function Commands.loot()
  BeggingInterface:Toggle()
end