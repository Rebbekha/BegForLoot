local ADDON_NAME, Addon = ...
local Colors = Addon:GetModule("Colors") ---@type Colors
local Commands = Addon:GetModule("Commands")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale") ---@type Locale
local Widgets = Addon:GetModule("Widgets") ---@type Widgets
local LootedItemFrame = Addon:GetModule("LootedItemFrame")

-- ============================================================================
-- Events
-- ============================================================================
--[[ 						A CREER
-- Auto Junk Frame.
EventManager:Once(E.StoreCreated, function()
  EventManager:On(E.Wow.MerchantShow, function()
    if StateManager:GetCurrentState().autoJunkFrame then LootedItemFrame:Show() end
  end)
  EventManager:On(E.Wow.MerchantClosed, function()
    if StateManager:GetCurrentState().autoJunkFrame then LootedItemFrame:Hide() end
  end)
end)
]]
-- ============================================================================
-- LootedItemFrame
-- ============================================================================

function LootedItemFrame:Show()
  self.frame:Show()
end

function LootedItemFrame:Hide()
  self.frame:Hide()
end

function LootedItemFrame:Toggle()
  if self.frame:IsShown() then
    self.frame:Hide()
  else
    self.frame:Show()
  end
end

-- ============================================================================
-- Initialize
-- ============================================================================

-- Hides buttons and itemFrames outside the visibile area of contentFrame so they don't steal focus when moused over
local function HideOffScreenWidgets()
	if contentFrame ~= nil then
		for i = 1, buttonIndex do
			if IsWidgetVisible(buttons[i], 0) then
				buttons[i]:Show()
			else
				buttons[i]:Hide()
			end
		end	

		for i = 1, itemFrameIndex do
			if IsWidgetVisible(itemFrames[i], 0) then
				itemFrames[i]:Show()
			else
				itemFrames[i]:Hide()
			end
		end	
		
		for lootedItemIndex, requestors in pairs(radioButtons) do
			for requestorIndex, radioButton in pairs(requestors) do
				if IsWidgetVisible(radioButton, 0) and lootedItems[lootedItemIndex][STATUS] == STATUS_REQUESTED then
					radioButton:Show()
				else
					radioButton:Hide()
				end
			end
		end
	end
end


LootedItemFrame.frame = (function()
  local frame = Widgets:Window({
    name = ADDON_NAME .. "_LootedItemFrame",
    width = 325,
    height = 375,
    titleText = Colors.Yellow(L.LOOTED_ITEM_FRAME),
  })
  frame.items = {}
  
  lootedItemsFrame:SetScript('OnMouseWheel', function(self, delta)
	local cur_val = scrollbar:GetValue()
	local min_val, max_val = scrollbar:GetMinMaxValues()

	if delta < 0 and cur_val < max_val then
		cur_val = math.min(max_val, cur_val + 10)
		scrollbar:SetValue(cur_val)
	elseif delta > 0 and cur_val > min_val then
		cur_val = math.max(min_val, cur_val - 10)
		scrollbar:SetValue(cur_val)
	end
  end)
  
--scrollFrame 
  scrollFrame = CreateFrame('ScrollFrame', nil, lootedItemsFrame) 
  scrollFrame:SetPoint('TOPLEFT', 10, -5) 
  scrollFrame:SetPoint('BOTTOMRIGHT', -10, 5)
  scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
    HideOffScreenWidgets()
  end)
  scrollFrame:SetScript("OnShow", function(self)
    HideOffScreenWidgets()
  end)
  lootedItemsFrame.scrollframe = scrollFrame 

  --scrollbar 
  scrollbar = CreateFrame('Slider', nil, scrollFrame, 'UIPanelScrollBarTemplate')
  scrollbar:SetPoint('TOPLEFT', lootedItemsFrame, 'TOPRIGHT', -19, -38) 
  scrollbar:SetPoint('BOTTOMLEFT', lootedItemsFrame, 'BOTTOMRIGHT', -19, 34)
  scrollbar:SetMinMaxValues(1, 300) 
  scrollbar:SetValueStep(1) 
  scrollbar.scrollStep = 10 
  scrollbar:SetValue(0) 
  scrollbar:SetWidth(16) 
  scrollbar:SetScript('OnValueChanged', function (self, value) 
    self:GetParent():SetVerticalScroll(value) 
  end) 
  lootedItemsFrame.scrollbar = scrollbar 
  scrollbar:Hide()
  
  
  return frame
end)()
