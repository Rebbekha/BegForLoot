local ADDON_NAME, Addon = ...
-- local Actions = Addon:GetModule("Actions") --- @type Actions
local Colors = Addon:GetModule("Colors") ---@type Colors
local L = Addon:GetModule("Locale") ---@type Locale
local MinimapIcon = Addon:GetModule("MinimapIcon")
local Popup = Addon:GetModule("Popup")
local SavedVariables = Addon:GetModule("SavedVariables")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local Commands = Addon:GetModule("Commands")
local UserInterface = Addon:GetModule("UserInterface")
local Widgets = Addon:GetModule("Widgets") ---@type Widgets

 
-- ============================================================================
-- UserInterface
-- ============================================================================

function UserInterface:Show()
  self.frame:Show()
end

function UserInterface:Hide()
  self.frame:Hide()
end

function UserInterface:Toggle()
  if self.frame:IsShown() then
    self.frame:Hide()
  else
    self.frame:Show()
  end
end

-- ============================================================================
-- Initialize
-- ============================================================================

UserInterface.frame = (function()
  local NUM_LIST_FRAME_BUTTONS = 7
  local OPTIONS_FRAME_WIDTH = 250
  local TRANSMOG_OPTIONS_FRAME_WIDTH = 280
  local TOTAL_FRAME_WIDTH = (
    Widgets:Padding() +
    OPTIONS_FRAME_WIDTH +
    Widgets:Padding(0.5) +
    OPTIONS_FRAME_WIDTH +
    Widgets:Padding(0.5) +
    TRANSMOG_OPTIONS_FRAME_WIDTH +
    Widgets:Padding() 
  )

  -- Base frame. (titre)
  local frame = Widgets:Window({
    name = ADDON_NAME .. "_ParentFrame",
    width = TOTAL_FRAME_WIDTH,
    height = 550,
    titleText = Colors.Blue(ADDON_NAME),
  })
  frame:SetFrameStrata("LOW")
  -- Version text.
  frame.versionText = frame.titleButton:CreateFontString("$parent_VersionText", "ARTWORK", "GameFontNormalSmall")
  frame.versionText:SetPoint("CENTER")
  frame.versionText:SetText(Colors.White(Addon.VERSION))
  frame.versionText:SetAlpha(0.5)
  


  -- 1er Frame global Options
  frame.optionsFrame =  Widgets:OptionsFrame({							--~ Global Option
    name = "$parent_OptionsFrame",
    parent = frame,
    points = {
      { "TOPLEFT", frame.titleButton, "BOTTOMLEFT", Widgets:Padding(), 5 }, 
      { "BOTTOMLEFT", frame, "LEFT", Widgets:Padding(), 45 }
    },
    width = OPTIONS_FRAME_WIDTH,
    titleText = L.GLOBAL_OPTIONS_TEXT
  })
  frame.optionsFrame:AddOption({  										--- Minimap button 
    labelText = L.MINIMAP_ICON_TEXT,
    tooltipText = L.MINIMAP_ICON_TOOLTIP,
    get = function() return MinimapIcon:IsEnabled() end,
    set = function(value) MinimapIcon:SetEnabled(value) end
  })

  
  --2e Frame Offering Loot Option
  frame.OfferingOptionFrame =  Widgets:OptionsFrame({						--~ Offering Loot Option
    name = "$parent_OfferingOptionFrame",
    parent = frame,
    points = {
      { "TOPLEFT",    frame.optionsFrame, "TOPRIGHT", Widgets:Padding(0.5), 0 },
      { "BOTTOMLEFT", frame.optionsFrame, "BOTTOMLEFT", Widgets:Padding(0.5), 0 }
    },
    width = OPTIONS_FRAME_WIDTH,
    titleText = L.OFFERING_LOOT_OPTIONS_TEXT
  })

  frame.OfferingOptionFrame:AddOption({									--- no Trade Bind On Equip
    labelText = L.NO_TRADE_BIND_ON_EQUIP_TEXT,
    tooltipText = L.NO_TRADE_BIND_ON_EQUIP_TEXT_TOOLTIP,
    get = function() return SavedVariables:Get().noTradeBindOnEquip end,
    set = function(value) SavedVariables:Get().noTradeBindOnEquip = value end
  })
  frame.OfferingOptionFrame:AddOption({
    labelText = L.NEVER_OFFERING_TEXT,											--- Show List User
    tooltipText = L.NEVER_OFFERING_TEXT_TOOLTIP,
    get = function() return SavedVariables:Get().neverOffering end,
    set = function(value) SavedVariables:Get().neverOffering = value end
  })  
  
  --3e Frame Receiving Loot Option
    frame.ReceivingOptionFrame =  Widgets:OptionsFrame({					--~ Receiving Loot Option
    name = "$parent_ReceivingOptionFrame",
    parent = frame,
    points = {
      { "TOPLEFT",    frame.OfferingOptionFrame, "TOPRIGHT", Widgets:Padding(0.5), 0 },
      { "BOTTOMLEFT", frame.OfferingOptionFrame, "TOPRIGHT", Widgets:Padding(0.5), -75 }
    },
    width = TRANSMOG_OPTIONS_FRAME_WIDTH,
    titleText = L.RECEIVING_LOOT_OPTIONS_TEXT
  })
    frame.ReceivingOptionFrame:AddOption({									--- Ilvl upgrade and below upgrade
    labelText = L.ILVL_UPGRADE_TEXT,
    onUpdateTooltip = function(self, tooltip)
      local itemLevel = Colors.White(SavedVariables:Get().ilvlUpgrade.value)
      tooltip:SetText(L.ILVL_UPGRADE_TEXT)
      tooltip:AddLine(L.ILVL_UPGRADE_TOOLTIP:format(itemLevel))
    end,
    get = function() return SavedVariables:Get().ilvlUpgrade.enabled end,
    set = function(value)
      if value then
        local sv = SavedVariables:Get()
        Popup:GetInteger({
          text = Colors.Gold(L.INCLUDE_ILVL_BELOW_TEXT) .. "|n|n" .. L.INCLUDE_BELOW_ITEM_LEVEL_POPUP_HELP,
          initialValue = sv.ilvlUpgrade.value,
          onAccept = function(self, value)
            sv.ilvlUpgrade.enabled = true
            sv.ilvlUpgrade.value = value
          end
        })
      else
        SavedVariables:Get().ilvlUpgrade.enabled = value
      end
    end
  }) 
    --4e Frame Receiving Loot Option / Transmog
    frame.TransmogOptionFrame =  Widgets:TransmogOptionsFrame({					--~ Frame Transmog unknown
    name = "$parent_TransmogOptionFrame",
    parent = frame,
    points = {
      { "TOPLEFT",    frame.ReceivingOptionFrame,"BOTTOMLEFT", 0, -130},
      { "BOTTOMLEFT", frame.ReceivingOptionFrame,"BOTTOMLEFT", 0, 0 }
    },
    width = TRANSMOG_OPTIONS_FRAME_WIDTH,
    titleText = L.TRANSMOG_UNKNOWN_TITLE_TEXT,
  })
  frame.TransmogOptionFrame:TransmogAddOption({  									--- Transmog unknown 
    labelText = L.TRANSMOG_UNKNOWN_TEXT,
    tooltipText = L.TRANSMOG_UNKNOWN_TOOLTIP,
    get = function() return SavedVariables:Get().transmogUnknown end,
    set = function(value) SavedVariables:Get().transmogUnknown = value end  
  })
  frame.TransmogOptionFrame:TransmogAddOption({  									--- Transmog unknown Appearance Only
    labelText = L.TRANSMOG_UNKNOWN_APPEARANCE_ONLY_TEXT,
    tooltipText = L.TRANSMOG_UNKNOWN_APPEARANCE_ONLY_TOOLTIP,
    get = function() return SavedVariables:Get().transmogUnknownAppearanceOnly end,
    set = function(value) 
	  SavedVariables:Get().transmogUnknownAppearanceOnly = value  -- If one is true the other two are false
	  SavedVariables:Get().transmogUnknownSharedAppearance = false
	end
  })
  frame.TransmogOptionFrame:TransmogAddOption({  									--- Transmog unknown Shared Appearance
    labelText = L.TRANSMOG_UNKNOWN_SHARED_APPEARANCE_TEXT,
    tooltipText = L.TRANSMOG_UNKNOWN_SHARED_APPEARANCE_TOOLTIP,
    get = function() return SavedVariables:Get().transmogUnknownSharedAppearance end,
    set = function(value) 
	  SavedVariables:Get().transmogUnknownSharedAppearance = value  -- If one is true the other are false
	  SavedVariables:Get().transmogUnknownAppearanceOnly = false
	end
  })  
  frame.TransmogOptionFrame:TransmogAddOption({  									--- Transmog unknown All class
    labelText = L.TRANSMOG_UNKNOWN_FOR_ALL_CLASS_TEXT,
    tooltipText = L.TRANSMOG_UNKNOWN_FOR_ALL_CLASS_TOOLTIP,
    get = function() return SavedVariables:Get().transmogUnknownForAllClass end,
    set = function(value) 
	  SavedVariables:Get().transmogUnknownForAllClass = value  -- If one is true the other two are false
	  SavedVariables:Get().transmogUnknownForMyClass = false
      SavedVariables:Get().transmogUnknownForMySpec = false
	end
  })
  frame.TransmogOptionFrame:TransmogAddOption({  									--- Transmog unknown My class
    labelText = L.TRANSMOG_UNKNOWN_FOR_MY_CLASS_TEXT,
    tooltipText = L.TRANSMOG_UNKNOWN_FOR_MY_CLASS_TOOLTIP,
    get = function() return SavedVariables:Get().transmogUnknownForMyClass end,
    set = function(value) SavedVariables:Get().transmogUnknownForMyClass = value
	  SavedVariables:Get().transmogUnknownForMyClass = value  -- If one is true the other two are false
	  SavedVariables:Get().transmogUnknownForAllClass = false
      SavedVariables:Get().transmogUnknownForMySpec = false

	end
  }) 
  frame.TransmogOptionFrame:TransmogAddOption({  									--- Transmog unknown My spec
    labelText = L.TRANSMOG_UNKNOWN_FOR_MY_SPEC_TEXT,
    tooltipText = L.TRANSMOG_UNKNOWN_FOR_MY_SPEC_TOOLTIP,
    get = function() return SavedVariables:Get().transmogUnknownForMySpec end,
    set = function(value) SavedVariables:Get().transmogUnknownForMySpec = value 
	  SavedVariables:Get().transmogUnknownForMySpec = value  -- If one is true the other two are false
	  SavedVariables:Get().transmogUnknownForMyClass = false
      SavedVariables:Get().transmogUnknownForAllClass = false
	end
  })  
  
  
  EventManager:On(E.SavedVariablesReady,function()
  TitleWhisper1 = SavedVariables:Get().TitleWhisper1
  TitleWhisper2 = SavedVariables:Get().TitleWhisper2
  TitleWhisper3 = SavedVariables:Get().TitleWhisper3

  TextWhisper1 = SavedVariables:Get().TextWhisper1
  TextWhisper2 = SavedVariables:Get().TextWhisper2
  TextWhisper3 = SavedVariables:Get().TextWhisper3
   
  -- Whisper Frame
  frame.GlobalWhisperFrame =  Widgets:OptionsFrame({ -- Création de la frame globale pour les options de Whisper
    name = "$parent_GlobalWhisperFrame",
    parent = frame,
    points = {
      { "TOPLEFT", frame.optionsFrame, "BOTTOMLEFT", 0, 0}, -- Positionnement de la frame
      { "BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10}
    },
    width = TOTAL_FRAME_WIDTH - 20, -- Largeur de la frame
    titleText = L.WHISPER_TEXT, -- Texte du titre
  })
  frame.GlobalWhisperFrame:SetFrameStrata("MEDIUM") -- Définir la strata de la frame

  -- Définir les informations de backdrop nécessaires dans toutes les frames Whisper
  local backdropInfo = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false,
    tileSize = 0,
    edgeSize = 16,
    insets = {left = 4, right = 4, top = 4, bottom = 4},
  }

  -- Ajouter le texte de ligne jaune
  frame.GlobalWhisperFrame.text = frame.GlobalWhisperFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  frame.GlobalWhisperFrame.text:SetPoint("TOPLEFT", 0, -35) -- Déplacer le texte juste en dessous du titre
  frame.GlobalWhisperFrame.text:SetText("   " .. L.WHISPER_INTRODUCTION) -- Ajouter un décalage pour que le texte ne soit pas accolé à la frame
  frame.GlobalWhisperFrame.text:SetJustifyH("LEFT") -- Justification horizontale à gauche
  frame.GlobalWhisperFrame.text:SetJustifyV("TOP") -- Justification verticale en haut

  -- Création de la frame pour Whisper 1
  frame.Whisper1 =  Widgets:OptionsFrame({
    name = "$parent_Whisper1",
    parent = frame,
    points = {
      { "TOPLEFT", frame.GlobalWhisperFrame.text, "BOTTOMLEFT", 5, -10},
      { "BOTTOMLEFT", frame.GlobalWhisperFrame, "BOTTOMLEFT", 0, 10}
    },
    width = TOTAL_FRAME_WIDTH / 3 - 10, -- Largeur de la frame
    titleText = L.WHISPER_TEXT .. "1", -- Texte du titre avec le numéro 1
  })

  frame.Whisper1:SetFrameStrata("HIGH") -- Définir la strata de la frame

  -- Create and position the title text for Whisper 1
  frame.Whisper1.Titletext = frame.Whisper1:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  frame.Whisper1.Titletext:SetPoint("TOPLEFT", -5, -35) -- Offset to place the text just below the title
  frame.Whisper1.Titletext:SetText("   " .. L.TITLE_WHISPER_INTRODUCTION) -- Add a small offset so the text is not attached to the frame

  -- Create the title edit box for Whisper 1
  frame.Whisper1.editboxTitle1 = CreateFrame("EditBox", nil, frame.Whisper1, "InputBoxTemplate")
  frame.Whisper1.editboxTitle1:SetWidth(65)
  frame.Whisper1.editboxTitle1:SetHeight(40)
  frame.Whisper1.editboxTitle1:SetAutoFocus(false)
  frame.Whisper1.editboxTitle1:SetPoint("TOPLEFT", frame.Whisper1.Titletext, 20, -5) -- Position relative to the title text
  frame.Whisper1.editboxTitle1:SetText(TitleWhisper1)
  frame.Whisper1.editboxTitle1:SetMaxLetters(10)

  -- Save the title text to SavedVariables
  frame.Whisper1.editboxTitle1:SetScript("OnTextChanged", function(self)
    SavedVariables:Get().TitleWhisper1 = self:GetText()
	EventManager:Fire(E.UpdateText)
  end)
  
  -- Create and position the whisper text label for Whisper 1
  frame.Whisper1.Whispertext1 = frame.Whisper1:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  frame.Whisper1.Whispertext1:SetPoint("TOPLEFT", frame.Whisper1.editboxTitle1, -20, -30)
  frame.Whisper1.Whispertext1:SetText("   " .. L.TEXT_WHISPER_INTRODUCTION)

  -- Create the whisper edit box for Whisper 1
  frame.Whisper1.editboxWhisper1 = CreateFrame("EditBox", nil, frame.Whisper1)
  if (BackdropTemplateMixin) then
      Mixin(frame.Whisper1.editboxWhisper1, BackdropTemplateMixin)
  end

  -- Set the font and position for the edit box
  frame.Whisper1.editboxWhisper1:SetFontObject(GameFontNormal)
  frame.Whisper1.editboxWhisper1:SetPoint("TOPLEFT", frame.Whisper1, "BOTTOMLEFT", 10, 5)
  frame.Whisper1.editboxWhisper1:SetPoint("BOTTOMLEFT", frame.Whisper1.Whispertext1, "TOPLEFT", 10, -15)
  frame.Whisper1.editboxWhisper1:SetWidth(TOTAL_FRAME_WIDTH / 3 - 60)
  frame.Whisper1.editboxWhisper1:SetText(TextWhisper1)
  frame.Whisper1.editboxWhisper1:SetTextColor(1, 1, 1, 1)
  frame.Whisper1.editboxWhisper1:SetJustifyH("CENTER")
  frame.Whisper1.editboxWhisper1:SetJustifyV("MIDDLE")
  frame.Whisper1.editboxWhisper1:SetMaxLetters(255)
  frame.Whisper1.editboxWhisper1:SetMultiLine(true)
  frame.Whisper1.editboxWhisper1:SetAutoFocus(false)

  -- Apply the backdrop to the edit box
  frame.Whisper1.editboxWhisper1:SetBackdrop(backdropInfo)
  frame.Whisper1.editboxWhisper1:SetBackdropColor(0, 0, 0, 0)
  frame.Whisper1.editboxWhisper1:SetBackdropBorderColor(1, 1, 1, 1)

  -- Add insets to create space between the text and the border
  frame.Whisper1.editboxWhisper1:SetTextInsets(5, 5, 5, 5) -- Adjust values to create more space

  -- Save the whisper text to SavedVariables
  frame.Whisper1.editboxWhisper1:SetScript("OnTextChanged", function(self)
    SavedVariables:Get().TextWhisper1 = self:GetText()
	EventManager:Fire(E.UpdateText)
  end)

    
  -- Create the Whisper 2 section

  frame.Whisper2 =  Widgets:OptionsFrame({					--~ Transmog unknown
    name = "$parent_Whisper2",
    parent = frame,
    points = {
      { "TOPLEFT",    frame.Whisper1,"TOPRIGHT", 5, 0},
      { "BOTTOMLEFT", frame.GlobalWhisperFrame,"BOTTOMLEFT", 0, 10}
    },
    width = TOTAL_FRAME_WIDTH/3-10,
    titleText = L.WHISPER_TEXT .. "2",
  })  
  frame.Whisper2:SetFrameStrata("HIGH")
  
  -- Create and position the title text for Whisper 2
  frame.Whisper2.Titletext = frame.Whisper2:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  frame.Whisper2.Titletext:SetPoint("TOPLEFT", -5, -35) -- Offset to place the text just below the title
  frame.Whisper2.Titletext:SetText("   " .. L.TITLE_WHISPER_INTRODUCTION) -- Add a small offset so the text is not attached to the frame

  -- Create the title edit box for Whisper 2
  frame.Whisper2.editboxTitle2 = CreateFrame("EditBox", nil, frame.Whisper2, "InputBoxTemplate")
  frame.Whisper2.editboxTitle2:SetWidth(65)
  frame.Whisper2.editboxTitle2:SetHeight(40)
  frame.Whisper2.editboxTitle2:SetAutoFocus(false)
  frame.Whisper2.editboxTitle2:SetPoint("TOPLEFT", frame.Whisper2.Titletext, 20, -5) -- Position relative to the title text
  frame.Whisper2.editboxTitle2:SetText(TitleWhisper2)
  frame.Whisper2.editboxTitle2:SetMaxLetters(10)

  -- Save the title text to SavedVariables
  frame.Whisper2.editboxTitle2:SetScript("OnTextChanged", function(self)
    SavedVariables:Get().TitleWhisper2 = self:GetText()
	EventManager:Fire(E.UpdateText)
  end)

  -- Create and position the whisper text label for Whisper 2
  frame.Whisper2.Whispertext2 = frame.Whisper2:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  frame.Whisper2.Whispertext2:SetPoint("TOPLEFT", frame.Whisper2.editboxTitle2, -20, -30)
  frame.Whisper2.Whispertext2:SetText("   " .. L.TEXT_WHISPER_INTRODUCTION)

  -- Create the whisper edit box for Whisper 2
  frame.Whisper2.editboxWhisper2 = CreateFrame("EditBox", nil, frame.Whisper2)
  if (BackdropTemplateMixin) then
      Mixin(frame.Whisper2.editboxWhisper2, BackdropTemplateMixin)
  end

  -- Set the font and position for the edit box
  frame.Whisper2.editboxWhisper2:SetFontObject(GameFontNormal)
  frame.Whisper2.editboxWhisper2:SetPoint("TOPLEFT", frame.Whisper2, "BOTTOMLEFT", 10, 5)
  frame.Whisper2.editboxWhisper2:SetPoint("BOTTOMLEFT", frame.Whisper2.Whispertext2, "TOPLEFT", 10, -15)
  frame.Whisper2.editboxWhisper2:SetWidth(TOTAL_FRAME_WIDTH / 3 - 60)
  frame.Whisper2.editboxWhisper2:SetText(TextWhisper2)
  frame.Whisper2.editboxWhisper2:SetTextColor(1, 1, 1, 1)
  frame.Whisper2.editboxWhisper2:SetJustifyH("CENTER")
  frame.Whisper2.editboxWhisper2:SetJustifyV("MIDDLE")
  frame.Whisper2.editboxWhisper2:SetMaxLetters(255)
  frame.Whisper2.editboxWhisper2:SetMultiLine(true)
  frame.Whisper2.editboxWhisper2:SetAutoFocus(false)
  

  -- Apply the backdrop to the edit box
  frame.Whisper2.editboxWhisper2:SetBackdrop(backdropInfo)
  frame.Whisper2.editboxWhisper2:SetBackdropColor(0, 0, 0, 0)
  frame.Whisper2.editboxWhisper2:SetBackdropBorderColor(1, 1, 1, 1)

  -- Add insets to create space between the text and the border
  frame.Whisper2.editboxWhisper2:SetTextInsets(5, 5, 5, 5) -- Adjust values to create more space

  -- Save the whisper text to SavedVariables
  frame.Whisper2.editboxWhisper2:SetScript("OnTextChanged", function(self)
    SavedVariables:Get().TextWhisper2 = self:GetText()
	EventManager:Fire(E.UpdateText)
  end)

  -- Create the Whisper 3 section

    frame.Whisper3 =  Widgets:OptionsFrame({          --~ Transmog unknown
      name = "$parent_Whisper3",
      parent = frame,
      points = {
        { "TOPLEFT",    frame.Whisper2,"TOPRIGHT", 5, 0},
        { "BOTTOMLEFT", frame.GlobalWhisperFrame,"BOTTOMLEFT", -5, 10}
      },
      width = TOTAL_FRAME_WIDTH/3-10,
      titleText = L.WHISPER_TEXT .. "3",
    })  
	frame.Whisper3:SetFrameStrata("HIGH")

  -- Create and position the title text for Whisper 3
  frame.Whisper3.Titletext = frame.Whisper3:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  frame.Whisper3.Titletext:SetPoint("TOPLEFT", -5, -35) -- Offset to place the text just below the title
  frame.Whisper3.Titletext:SetText("   " .. L.TITLE_WHISPER_INTRODUCTION) -- Add a small offset so the text is not attached to the frame

  -- Create the title edit box for Whisper 3
  frame.Whisper3.editboxTitle3 = CreateFrame("EditBox", nil, frame.Whisper3, "InputBoxTemplate")
  frame.Whisper3.editboxTitle3:SetWidth(65)
  frame.Whisper3.editboxTitle3:SetHeight(40)
  frame.Whisper3.editboxTitle3:SetAutoFocus(false)
  frame.Whisper3.editboxTitle3:SetPoint("TOPLEFT", frame.Whisper3.Titletext, 20, -5) -- Position relative to the title text
  frame.Whisper3.editboxTitle3:SetText(TitleWhisper3)
  frame.Whisper3.editboxTitle3:SetMaxLetters(10)

  -- Save the title text to SavedVariables
  frame.Whisper3.editboxTitle3:SetScript("OnTextChanged", function(self)
    SavedVariables:Get().TitleWhisper3 = self:GetText()
	EventManager:Fire(E.UpdateText)
  end)

  -- Create and position the whisper text label for Whisper 3
  frame.Whisper3.Whispertext3 = frame.Whisper3:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  frame.Whisper3.Whispertext3:SetPoint("TOPLEFT", frame.Whisper3.editboxTitle3, -20, -30)
  frame.Whisper3.Whispertext3:SetText("   " .. L.TEXT_WHISPER_INTRODUCTION)

  -- Create the whisper edit box for Whisper 3
  frame.Whisper3.editboxWhisper3 = CreateFrame("EditBox", nil, frame.Whisper3)
  if (BackdropTemplateMixin) then
      Mixin(frame.Whisper3.editboxWhisper3, BackdropTemplateMixin)
  end

  -- Set the font and position for the edit box
  frame.Whisper3.editboxWhisper3:SetFontObject(GameFontNormal)
  frame.Whisper3.editboxWhisper3:SetPoint("TOPLEFT", frame.Whisper3, "BOTTOMLEFT", 10, 5)
  frame.Whisper3.editboxWhisper3:SetPoint("BOTTOMLEFT", frame.Whisper3.Whispertext3, "TOPLEFT", 10, -15)
  frame.Whisper3.editboxWhisper3:SetWidth(TOTAL_FRAME_WIDTH / 3 - 60)
  frame.Whisper3.editboxWhisper3:SetText(TextWhisper3)
  frame.Whisper3.editboxWhisper3:SetTextColor(1, 1, 1, 1)
  frame.Whisper3.editboxWhisper3:SetJustifyH("CENTER")
  frame.Whisper3.editboxWhisper3:SetJustifyV("MIDDLE")
  frame.Whisper3.editboxWhisper3:SetMaxLetters(255)
  frame.Whisper3.editboxWhisper3:SetMultiLine(true)
  frame.Whisper3.editboxWhisper3:SetAutoFocus(false)

  -- Apply the backdrop to the edit box
  frame.Whisper3.editboxWhisper3:SetBackdrop(backdropInfo)
  frame.Whisper3.editboxWhisper3:SetBackdropColor(0, 0, 0, 0)
  frame.Whisper3.editboxWhisper3:SetBackdropBorderColor(1, 1, 1, 1)

  -- Add insets to create space between the text and the border
  frame.Whisper3.editboxWhisper3:SetTextInsets(5, 5, 5, 5) -- Adjust values to create more space

  -- Save the whisper text to SavedVariables
  frame.Whisper3.editboxWhisper3:SetScript("OnTextChanged", function(self)
    SavedVariables:Get().TextWhisper3 = self:GetText()
	EventManager:Fire(E.UpdateText)
  end)
end)
 
   
  
  return frame
end)()  

------------------------
-- EVENT
------------------------






  --[[
  
  
  -- Search button.
  frame.searchButton = Widgets:TitleFrameIconButton({
    name = "$parent_SearchButton",
    parent = frame.titleButton,
    points = {
      { "TOPRIGHT",    frame.keybindsButton, "TOPLEFT",    0, 0 },
      { "BOTTOMRIGHT", frame.keybindsButton, "BOTTOMLEFT", 0, 0 }
    },
    texture = Addon:GetAsset("search-icon"),
    textureSize = frame.title:GetStringHeight(),
    highlightColor = Colors.Yellow,
    onClick = toggleSearching,
    onUpdateTooltip = function(self, tooltip)
      tooltip:SetText(listSearchState.isSearching and L.CLEAR_SEARCH or L.SEARCH_LISTS)
    end
  })

  -- Search box.
  frame.searchBox = CreateFrame("EditBox", "$parent_SearchBox", frame.titleButton)
  frame.searchBox:SetFontObject("GameFontNormalLarge")
  frame.searchBox:SetTextColor(1, 1, 1)
  frame.searchBox:SetAutoFocus(false)
  frame.searchBox:SetMultiLine(false)
  frame.searchBox:SetCountInvisibleLetters(true)
  frame.searchBox:SetPoint("TOPLEFT", Widgets:Padding(), 0)
  frame.searchBox:SetPoint("BOTTOMLEFT", Widgets:Padding(), 0)
  frame.searchBox:SetPoint("TOPRIGHT", frame.searchButton, "TOPLEFT", 0, 0)
  frame.searchBox:SetPoint("BOTTOMRIGHT", frame.searchButton, "BOTTOMLEFT", 0, 0)
  frame.searchBox:Hide()

  -- Search box placeholder text.
  frame.searchBox.placeholderText = frame.searchBox:CreateFontString("$parent_PlaceholderText", "ARTWORK",
    "GameFontNormalLarge")
  frame.searchBox.placeholderText:SetText(Colors.White(L.SEARCH_LISTS))
  frame.searchBox.placeholderText:SetPoint("LEFT")
  frame.searchBox.placeholderText:SetPoint("RIGHT")
  frame.searchBox.placeholderText:SetJustifyH("LEFT")
  frame.searchBox.placeholderText:SetAlpha(0.5)

  frame.searchBox:SetScript("OnEscapePressed", stopSearching)
  frame.searchBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
  frame.searchBox:SetScript("OnTextChanged", function(self)
    listSearchState.searchText = self:GetText()
    if listSearchState.searchText == "" then
      self.placeholderText:Show()
    else
      self.placeholderText:Hide()
    end
  end)


  -- Options frame.
  frame.optionsFrame = Widgets:OptionsFrame({
    name = "$parent_OptionsFrame",
    parent = frame,
    points = {
      { "TOPLEFT",    frame.titleButton, "BOTTOMLEFT", Widgets:Padding(), 0 },
      { "BOTTOMLEFT", frame,             "BOTTOMLEFT", Widgets:Padding(), Widgets:Padding() }
    },
    width = OPTIONS_FRAME_WIDTH,
    titleText = L.OPTIONS_TEXT
  })
  frame.optionsFrame:AddOption({
    labelText = L.CHARACTER_SPECIFIC_SETTINGS_TEXT,
    tooltipText = L.CHARACTER_SPECIFIC_SETTINGS_TOOLTIP,
    get = function() return StateManager:GetPercharState().characterSpecificSettings end,
    set = function() StateManager:GetStore():Dispatch(Actions:ToggleCharacterSpecificSettings()) end
  })
  frame.optionsFrame:AddOption({
    labelText = L.CHAT_MESSAGES_TEXT,
    tooltipText = L.CHAT_MESSAGES_TOOLTIP,
    get = function() return StateManager:GetCurrentState().chatMessages end,
    set = function(value) StateManager:GetStore():Dispatch(Actions:SetChatMessages(value)) end
  })
  frame.optionsFrame:AddOption({
    labelText = L.BAG_ITEM_TOOLTIPS_TEXT,
    tooltipText = L.BAG_ITEM_TOOLTIPS_TOOLTIP,
    get = function() return StateManager:GetCurrentState().itemTooltips end,
    set = function(value) StateManager:GetStore():Dispatch(Actions:SetItemTooltips(value)) end
  })
  frame.optionsFrame:AddOption({
    labelText = L.MERCHANT_BUTTON_TEXT,
    tooltipText = L.MERCHANT_BUTTON_TOOLTIP,
    get = function() return StateManager:GetCurrentState().merchantButton end,
    set = function(value) StateManager:GetStore():Dispatch(Actions:SetMerchantButton(value)) end
  })
  frame.optionsFrame:AddOption({
    labelText = L.MINIMAP_ICON_TEXT,
    tooltipText = L.MINIMAP_ICON_TOOLTIP,
    get = function() return MinimapIcon:IsEnabled() end,
    set = function(value) MinimapIcon:SetEnabled(value) end
  })
  frame.optionsFrame:AddOption({
    labelText = L.AUTO_JUNK_FRAME_TEXT,
    tooltipText = L.AUTO_JUNK_FRAME_TOOLTIP,
    get = function() return StateManager:GetCurrentState().autoJunkFrame end,
    set = function(value) StateManager:GetStore():Dispatch(Actions:SetAutoJunkFrame(value)) end
  })
  frame.optionsFrame:AddOption({
    labelText = L.AUTO_REPAIR_TEXT,
    tooltipText = L.AUTO_REPAIR_TOOLTIP,
    get = function() return StateManager:GetCurrentState().autoRepair end,
    set = function(value) StateManager:GetStore():Dispatch(Actions:SetAutoRepair(value)) end
  })
  frame.optionsFrame:AddOption({
    labelText = L.AUTO_SELL_TEXT,
    tooltipText = L.AUTO_SELL_TOOLTIP,
    get = function() return StateManager:GetCurrentState().autoSell end,
    set = function(value) StateManager:GetStore():Dispatch(Actions:SetAutoSell(value)) end
  })
  frame.optionsFrame:AddOption({
    labelText = L.SAFE_MODE_TEXT,
    tooltipText = L.SAFE_MODE_TOOLTIP,
    get = function() return StateManager:GetCurrentState().safeMode end,
    set = function(value) StateManager:GetStore():Dispatch(Actions:SetSafeMode(value)) end
  })
  if not Addon.IS_VANILLA then
    frame.optionsFrame:AddOption({
      labelText = L.EXCLUDE_EQUIPMENT_SETS_TEXT,
      tooltipText = L.EXCLUDE_EQUIPMENT_SETS_TOOLTIP,
      get = function() return StateManager:GetCurrentState().excludeEquipmentSets end,
      set = function(value) StateManager:GetStore():Dispatch(Actions:SetExcludeEquipmentSets(value)) end
    })
  end
  frame.optionsFrame:AddOption({
    labelText = L.EXCLUDE_UNBOUND_EQUIPMENT_TEXT,
    tooltipText = L.EXCLUDE_UNBOUND_EQUIPMENT_TOOLTIP,
    get = function() return StateManager:GetCurrentState().excludeUnboundEquipment end,
    set = function(value) StateManager:GetStore():Dispatch(Actions:SetExcludeUnboundEquipment(value)) end
  })
  frame.optionsFrame:AddOption({
    labelText = L.INCLUDE_POOR_ITEMS_TEXT,
    tooltipText = L.INCLUDE_POOR_ITEMS_TOOLTIP,
    get = function() return StateManager:GetCurrentState().includePoorItems end,
    set = function(value) StateManager:GetStore():Dispatch(Actions:SetIncludePoorItems(value)) end
  })
  frame.optionsFrame:AddOption({
    labelText = L.INCLUDE_BELOW_ITEM_LEVEL_TEXT,
    onUpdateTooltip = function(self, tooltip)
      local itemLevel = Colors.White(StateManager:GetCurrentState().includeBelowItemLevel.value)
      tooltip:SetText(L.INCLUDE_BELOW_ITEM_LEVEL_TEXT)
      tooltip:AddLine(L.INCLUDE_BELOW_ITEM_LEVEL_TOOLTIP:format(itemLevel))
    end,
    get = function() return StateManager:GetCurrentState().includeBelowItemLevel.enabled end,
    set = function(value)
      if value then
        local currentState = StateManager:GetCurrentState()
        Popup:GetInteger({
          text = Colors.Gold(L.INCLUDE_BELOW_ITEM_LEVEL_TEXT) .. "|n|n" .. L.INCLUDE_BELOW_ITEM_LEVEL_POPUP_HELP,
          initialValue = currentState.includeBelowItemLevel.value,
          onAccept = function(self, value)
            StateManager:GetStore():Dispatch(Actions:PatchIncludeBelowItemLevel({ enabled = true, value = value }))
          end
        })
      else
        StateManager:GetStore():Dispatch(Actions:PatchIncludeBelowItemLevel({ enabled = value }))
      end
    end
  })
  frame.optionsFrame:AddOption({
    labelText = L.INCLUDE_UNSUITABLE_EQUIPMENT_TEXT,
    tooltipText = L.INCLUDE_UNSUITABLE_EQUIPMENT_TOOLTIP,
    get = function() return StateManager:GetCurrentState().includeUnsuitableEquipment end,
    set = function(value) StateManager:GetStore():Dispatch(Actions:SetIncludeUnsuitableEquipment(value)) end
  })

  frame.optionsFrame:AddOption({
    labelText = L.INCLUDE_TRANSMOG_KNOWN_TEXT,
	    onUpdateTooltip = function(self, tooltip)
      local itemLevel = Colors.White(StateManager:GetCurrentState().includeTransmogKnown.value)
      tooltip:SetText(L.INCLUDE_TRANSMOG_KNOWN_TEXT)
      tooltip:AddLine(L.INCLUDE_TRANSMOG_KNOWN_TOOLTIP:format(itemLevel))
    end,
    get = function() return StateManager:GetCurrentState().includeTransmogKnown.enabled end,
    set = function(value)
      if value then
        local currentState = StateManager:GetCurrentState()
        Popup:GetInteger({
          text = Colors.Gold(L.INCLUDE_TRANSMOG_KNOWN_TEXT) .. "|n|n" .. L.INCLUDE_TRANSMOG_KNOWN_POPUP_HELP,
          initialValue = currentState.includeTransmogKnown.value,
          onAccept = function(self, value)
            StateManager:GetStore():Dispatch(Actions:PatchIncludeTransmogKnown({ enabled = true, value = value }))
          end
        })
      else
        StateManager:GetStore():Dispatch(Actions:PatchIncludeTransmogKnown({ enabled = value }))
      end
    end
  })
  if Addon.IS_RETAIL then
    frame.optionsFrame:AddOption({
      labelText = L.INCLUDE_ARTIFACT_RELICS_TEXT,
      tooltipText = L.INCLUDE_ARTIFACT_RELICS_TOOLTIP,
      get = function() return StateManager:GetCurrentState().includeArtifactRelics end,
      set = function(value) StateManager:GetStore():Dispatch(Actions:SetIncludeArtifactRelics(value)) end
    })
  end



  return frame
end)()
]]--