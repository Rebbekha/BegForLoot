local _, Addon = ...
local Colors = Addon:GetModule("Colors") ---@type Colors
local Widgets = Addon:GetModule("Widgets") ---@class Widgets

-- =============================================================================
-- LuaCATS Annotations
-- =============================================================================

--- @class OptionsFrameWidgetOptions : ScrollableTitleFrameWidgetOptions

--- @class OptionButtonWidgetOptions : FrameWidgetOptions
--- @field labelText string
--- @field tooltipText? string
--- @field get fun(): boolean
--- @field set fun(value: boolean)

-- =============================================================================
-- Widgets - Options Frame
-- =============================================================================

--- Creates a ScrollableTitleFrame with the ability to add boolean options.
--- @param options OptionsFrameWidgetOptions
--- @return OptionsFrameWidget frame
function Widgets:OptionsFrame(options)
  -- Defaults.
  options.onUpdateTooltip = nil
  options.titleTemplate = nil
  options.titleJustify = "CENTER"

  -- Base frame.
  local frame = self:ScrollableTitleFrame(options) ---@class OptionsFrameWidget : ScrollableTitleFrameWidget
  frame.titleButton:EnableMouse(false)
  frame.buttons = {}
  frame.buttonHeight = frame.title:GetStringHeight() + Widgets:Padding(2)

  -- Scroll child.
  frame.scrollChild = self:Frame({ name = "$parent_ScrollChild", parent = frame.scrollFrame })
  frame.scrollChild:SetBackdrop(nil)
  frame.scrollFrame:SetScrollChild(frame.scrollChild)

  --- Adds an option button to the frame.
  --- @param options OptionButtonWidgetOptions
  function frame:AddOption(options)
    -- Defaults.
    options.name = "$parent_CheckButton" .. #self.buttons + 1
    options.parent = self.scrollChild
    options.height = self.buttonHeight

    -- Add button.
    self.buttons[#self.buttons + 1] = Widgets:OptionButton(options)
  end

  frame:HookScript("OnUpdate", function(self)
    local scrollChildHeight = (#self.buttons * self.buttonHeight) + (Widgets:Padding() * (#self.buttons - 1))
    frame.scrollChild:SetHeight(scrollChildHeight)

    -- Update button points.
    for i, button in ipairs(self.buttons) do
      button:ClearAllPoints()
      if i == 1 then
        button:SetPoint("TOPLEFT", frame.scrollChild)
        button:SetPoint("TOPRIGHT", frame.scrollChild)
      else
        button:SetPoint("TOPLEFT", self.buttons[i - 1], "BOTTOMLEFT", 0, -Widgets:Padding())
        button:SetPoint("TOPRIGHT", self.buttons[i - 1], "BOTTOMRIGHT", 0, -Widgets:Padding())
      end
    end
  end)

  return frame
end

-- =============================================================================
-- Widgets - Transmog Options Frame
-- =============================================================================

--- Creates a ScrollableTitleFrame with the ability to add boolean options.
--- the boolean option is showed in row of 3 element
--- @param options OptionsFrameWidgetOptions
--- @return OptionsFrameWidget frame

function Widgets:TransmogOptionsFrame(options)
  local BUTTONS_PER_ROW = 3
  local SPACING = Widgets:Padding(0.5)

  -- Defaults.
  options.onUpdateTooltip = nil
  options.titleTemplate = nil
  options.titleJustify = "CENTER"

  -- Base frame.
  local frame = self:TitleFrame(options)
  frame.titleButton:EnableMouse(false)
  frame.buttons = {}

  --[[
    -- Adds an option button to the frame.

    options = {
      onUpdateTooltip? = function(self, tooltip) -> nil,
      labelText = string,
      tooltipText? = string,
      get = function() -> boolean,
      set = function(value: boolean) -> nil
    }
  ]]

function frame:TransmogAddOption(options)
  -- Defaults.
  options.name = "$parent_CheckButton" .. #self.buttons + 1
  options.parent = self

  -- Determine row and column placement based on #self.buttons and BUTTONS_PER_ROW.
  local row, col = math.floor((#self.buttons) / BUTTONS_PER_ROW), (#self.buttons) % BUTTONS_PER_ROW

  if #self.buttons == 0 then --Transmog unknown
    -- First button alone on its row.
    options.points = { { "TOPLEFT", self.titleButton, "BOTTOMLEFT", SPACING, -SPACING } }
  elseif #self.buttons == 1 then -- Appearance only
    -- Second button, should be on the different row as the first.
    options.points = { { "TOPLEFT", self.buttons[1], "BOTTOMLEFT", 0, -SPACING } }
  elseif #self.buttons == 2 then -- Shared appearance
    -- Third button, should on the same row than the last buttons.
    options.points = { { "TOPLEFT", self.buttons[2], "TOPRIGHT", SPACING, 0 } }
  elseif #self.buttons == 3 then  -- all class
    -- Third button, should start a new row with three buttons.
    options.points = { { "TOPLEFT", self.buttons[2], "BOTTOMLEFT", 0, -SPACING } }	
  elseif #self.buttons == 4 then --my class
    -- Third button, should on the same row than the last buttons.
    options.points = { { "TOPLEFT", self.buttons[4], "TOPRIGHT", SPACING, 0 } }
  elseif #self.buttons == 5 then -- my spec
    -- Third button, should on the same row than the last buttons.
    options.points = { { "TOPLEFT", self.buttons[5], "TOPRIGHT", SPACING, 0 } }	

  end

  -- Add button.
  self.buttons[#self.buttons + 1] = Widgets:TransmogOptionButton(options)
end

  frame:SetScript("OnUpdate", function(self)
    -- Resize buttons.
    local numColumns = 3
	local numRow = 3
    local buttonAreaWidth = self:GetWidth() - (SPACING * 2)
    local buttonAreaHeight = self:GetHeight() - self.titleButton:GetHeight() - (SPACING * 2)
    local buttonSpacingHorizontal = (BUTTONS_PER_ROW - 1) * SPACING
    local buttonSpacingVertical = (numColumns - 1) * SPACING

    local buttonHeight = (buttonAreaHeight - buttonSpacingVertical) / numColumns
	local buttonWidth
    
    for index, button in ipairs(self.buttons) do
	  if index == 1 then
	  buttonWidth =(buttonAreaWidth - buttonSpacingHorizontal + 2*SPACING)/ (BUTTONS_PER_ROW-2)
	  elseif index == 2 then
	  buttonWidth =(buttonAreaWidth - buttonSpacingHorizontal + SPACING)/ (BUTTONS_PER_ROW-1)
	  elseif index == 3 then
	  buttonWidth =(buttonAreaWidth - buttonSpacingHorizontal + SPACING)/ (BUTTONS_PER_ROW-1)
	  else
	  buttonWidth = (buttonAreaWidth - buttonSpacingHorizontal) / BUTTONS_PER_ROW
	  end
      button:SetSize(buttonWidth, buttonHeight)
	  
    end
  end)

  return frame
end

-- =============================================================================
-- Widgets - Option Button
-- =============================================================================

--- Creates a toggleable option button.
--- @param options OptionButtonWidgetOptions
--- @return OptionButtonWidget frame
function Widgets:OptionButton(options)
  local CHECKBOX_SIZE = options.height - Widgets:Padding(2)

  -- Defaults.
  options.frameType = "Button"

  if options.tooltipText then
    options.onUpdateTooltip = function(self, tooltip)
      tooltip:SetText(options.labelText)
      tooltip:AddLine(options.tooltipText)
    end
  end

  -- Base frame.
  local frame = self:Frame(options) ---@class OptionButtonWidget : FrameWidget
  frame:SetBackdropColor(Colors.DarkGrey:GetRGBA(0.25))
  frame:SetBackdropBorderColor(Colors.White:GetRGBA(0.25))

  -- Check box.
  frame.checkBox = frame:CreateTexture("$parent_CheckBox")
  frame.checkBox:SetSize(CHECKBOX_SIZE, CHECKBOX_SIZE)
  frame.checkBox:SetPoint("RIGHT", -Widgets:Padding(), 0)

  -- Label text.
  frame.label = frame:CreateFontString("$parent_Label", "ARTWORK", "GameFontNormal")
  frame.label:SetText(Colors.White(options.labelText))
  frame.label:SetPoint("LEFT", frame, Widgets:Padding(), 0)
  frame.label:SetPoint("RIGHT", frame.checkBox, "LEFT", -Widgets:Padding(0.5), 0)
  frame.label:SetWordWrap(false)
  frame.label:SetJustifyH("LEFT")

  frame:HookScript("OnEnter", function(self)
    self:SetBackdropColor(Colors.DarkGrey:GetRGBA(0.5))
    self:SetBackdropBorderColor(Colors.White:GetRGBA(0.5))
  end)

  frame:HookScript("OnLeave", function(self)
    self:SetBackdropColor(Colors.DarkGrey:GetRGBA(0.25))
    self:SetBackdropBorderColor(Colors.White:GetRGBA(0.25))
  end)

  frame:SetScript("OnClick", function(self)
    options.set(not options.get())
  end)

  frame:SetScript("OnUpdate", function(self)
    if options.get() then
      self:SetAlpha(1)
      self.checkBox:SetColorTexture(Colors.Blue:GetRGBA(0.75))
    else
      self:SetAlpha(0.5)
      self.checkBox:SetColorTexture(Colors.White:GetRGBA(0.25))
    end
  end)

  return frame
end

-- =============================================================================
-- Widgets - Transmog Option Button
-- =============================================================================
---Relica of another code
--- Creates a toggleable option button.
--- @param options OptionButtonWidgetOptions
--- @return OptionButtonWidget frame

function Widgets:TransmogOptionButton(options)
  -- Defaults.
  options.frameType = "Button"

  if options.tooltipText then
    options.onUpdateTooltip = function(self, tooltip)
      tooltip:SetText(options.labelText)
      tooltip:AddLine(options.tooltipText)
    end
  end

  -- Base frame.
  local frame = self:Frame(options)
  frame:SetBackdropColor(Colors.DarkGrey:GetRGBA(0.25))
  frame:SetBackdropBorderColor(Colors.White:GetRGBA(0.25))

  -- Check box.
  frame.checkBox = self:Frame({
    name = "$parent_CheckBox",
    parent = frame
  })

  -- Label text.
  frame.label = frame:CreateFontString("$parent_Label", "ARTWORK", "GameFontNormal")
  frame.label:SetText(Colors.White(options.labelText))
  frame.label:SetPoint("LEFT", frame.checkBox, "RIGHT", self:Padding(0.5), 0)
  frame.label:SetPoint("RIGHT", frame, -self:Padding(), 0)
  frame.label:SetWordWrap(false)
  frame.label:SetJustifyH("LEFT")

  frame:HookScript("OnEnter", function(self)
    self:SetBackdropColor(Colors.DarkGrey:GetRGBA(0.5))
    self:SetBackdropBorderColor(Colors.White:GetRGBA(0.5))
  end)

  frame:HookScript("OnLeave", function(self)
    self:SetBackdropColor(Colors.DarkGrey:GetRGBA(0.25))
    self:SetBackdropBorderColor(Colors.White:GetRGBA(0.25))
  end)

  frame:SetScript("OnClick", function(self)
    options.set(not options.get())
  end)

  frame:SetScript("OnUpdate", function(self)
    -- Check box.
    local size = self.label:GetStringHeight()
    self.checkBox:SetSize(size, size)
    self.checkBox:SetPoint("LEFT", Widgets:Padding(), 0)

    if options.get() then
      self.checkBox:SetBackdropColor(Colors.Blue:GetRGBA(0.5))
      self.checkBox:SetBackdropBorderColor(Colors.Blue:GetRGB())
    else
      self.checkBox:SetBackdropColor(0, 0, 0, 0)
      self.checkBox:SetBackdropBorderColor(Colors.White:GetRGBA(0.25))
    end
  end)

  return frame
end
