local ADDON_NAME, Addon = ...

-- ============================================================================
-- Consts
-- ============================================================================

Addon.VERSION = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")
Addon.IS_RETAIL = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

-- ============================================================================
-- Functions
-- ============================================================================

do -- Addon:GetModule()
  local modules = {}

  function Addon:GetModule(key)
    key = key:upper()
    if type(modules[key]) ~= "table" then modules[key] = {} end
    return modules[key]
  end
end

do -- Addon:GetLibrary()
  local libraries = {
    LDB = LibStub("LibDataBroker-1.1"),
    LDBIcon = LibStub("LibDBIcon-1.0")
  }

  function Addon:GetLibrary(key)
    return libraries[key] or error("Invalid library: " .. key)
  end
end

function Addon:GetAsset(fileName)
  return ("Interface\\AddOns\\%s\\assets\\%s"):format(ADDON_NAME, fileName)
end

-- Returns latency in seconds.
function Addon:GetLatency(minLatency)
  local _, _, home, world = GetNetStats()
  local latency = max(home, world) * 0.001
  return max(latency, minLatency or 0.2)
end

do -- Addon:Concat()
  local Colors = Addon:GetModule("Colors") ---@type Colors
  local cache = {}

  function Addon:Concat(sep, ...)
    for k in pairs(cache) do cache[k] = nil end
    for i = 1, select("#", ...) do cache[#cache + 1] = select(i, ...) end
    return table.concat(cache, Colors.Grey(sep))
  end
end

function Addon:IfNil(value, default)
  if value == nil then return default end
  return value
end

do -- Addon:ForcePrint(), Addon:Print(), Addon:Debug()
  local Colors = Addon:GetModule("Colors") ---@type Colors
  local StateManager = Addon:GetModule("StateManager") --- @type StateManager

  function Addon:ForcePrint(...)
    print(Colors.Blue("[" .. ADDON_NAME .. "]"), ...)
  end

  function Addon:Print(...)
    if StateManager:GetCurrentState().chatMessages then
      print(Colors.Blue("[" .. ADDON_NAME .. "]"), ...)
    end
  end

  function Addon:Debug(...)
    print(date("%H:%M:%S"), Colors.Red("[Debug]"), ...)
  end
end
