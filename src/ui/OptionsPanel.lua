local ADDON_NAME, Addon = ...
local L = Addon:GetModule("Locale") ---@class Locale
local UserInterface = Addon:GetModule("UserInterface")

-- Locally define a function removed from Blizzard's API in 11.0
local InterfaceOptions_AddCategory = InterfaceOptions_AddCategory
if not InterfaceOptions_AddCategory then
    InterfaceOptions_AddCategory = function(frame, addOn, position)
        frame.OnCommit = frame.okay;
        frame.OnDefault = frame.default;
        frame.OnRefresh = frame.refresh;

        if frame.parent then
            local category = Settings.GetCategory(frame.parent);
            local subcategory, layout = Settings.RegisterCanvasLayoutSubcategory(category, frame, frame.name, frame.name);
            subcategory.ID = frame.name;
            return subcategory, category;
        else
            local category, layout = Settings.RegisterCanvasLayoutCategory(frame, frame.name, frame.name);
            category.ID = frame.name;
            Settings.RegisterAddOnCategory(category);
            return category;
        end
    end
end

-- Patch Notes Data Structure
local patchNotes = {
    {
        version = "1.0.2",
        improvements = {
            "Added new features.",
        },
        bugs = {
            "Fixed several minor bugs.",
        },
        features = {}
    },
    {
        version = "1.0.1",
        improvements = {
            "Added new features.",
            "Improved UI responsiveness."
        },
        bugs = {
            "Fixed several minor bugs.",
            "Resolved issue with incorrect loot display."
        },
        features = {
            "Introduced new loot tracking system."
        }
    },
    {
        version = "1.0.0",
        improvements = {},
        bugs = {},
        features = {
            "Initial release with basic functionalities."
        }
    }
}

local function CreateOptionsPanel()
    local panel = CreateFrame("Frame", ADDON_NAME .. "OptionsPanel", UIParent)
    panel.name = "Beg For Loot"
    if (BackdropTemplateMixin) then
        Mixin(panel, BackdropTemplateMixin)
    end
    panel:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    panel:SetBackdropColor(0, 0, 0, 1)
    panel:SetBackdropBorderColor(1, 1, 1, 1)

    -- Title
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Beg For Loot Options")

    -- Description
    local description = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -18)
    description:SetText("Click on the button below to adjust your options.")
    description:SetTextColor(1, 1, 1)

    -- Button
    local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -5)
    button:SetText("Beg For Loot Options")
    button:SetSize(200, 24)
    button:SetScript("OnClick", function()
		HideUIPanel(SettingsPanel)  
		UserInterface:Toggle()
    end)

    -- Patch Notes Title
    local PatchNoteTitle = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    PatchNoteTitle:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -50)
    PatchNoteTitle:SetText("Patch Notes")
    PatchNoteTitle:SetTextColor(1, 1, 1)

    -- Create ScrollFrame
    local scrollFrame = CreateFrame("ScrollFrame", ADDON_NAME .. "_ScrollFrame", panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", PatchNoteTitle, "BOTTOMLEFT", 0, -5)
    scrollFrame:SetSize(620, 450)

    -- Create Content Frame
    local content = CreateFrame("Frame", ADDON_NAME .. "_ContentFrame", scrollFrame)
    content:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(content)

    -- Function to add patch note item
    local function AddPatchNoteItem(content, text, yOffset, font, color, position)
        local textFrame = CreateFrame("Frame", nil, content)
        textFrame:SetSize(content:GetWidth() - 40, 1)
        textFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)

        local fontString = textFrame:CreateFontString(nil, "OVERLAY", font or "GameFontNormal")
        fontString:SetPoint("TOPLEFT", textFrame, "TOPLEFT", 0, 0)
        fontString:SetWidth(textFrame:GetWidth())
        fontString:SetText(text)
        fontString:SetJustifyH(position or "LEFT")  -- Use provided position or default to LEFT
        if color then
            fontString:SetTextColor(color[1], color[2], color[3])
        end

        textFrame:SetHeight(fontString:GetStringHeight())

        return textFrame:GetHeight(), fontString
    end

    -- Function to add lines next to centered text
    local function AddLinesForText(frame, textWidth, yOffset)
        local centerX = frame:GetWidth() / 2

        -- Add line to the left of the text
        local leftLine = frame:CreateLine()
        leftLine:SetColorTexture(1, 1, 1, 0.5)
        leftLine:SetThickness(1)
        leftLine:SetStartPoint("TOPLEFT", 10, yOffset + 5)
        leftLine:SetEndPoint("TOPLEFT", centerX - textWidth / 2 - 30, yOffset + 5)

        -- Add line to the right of the text
        local rightLine = frame:CreateLine()
        rightLine:SetColorTexture(1, 1, 1, 0.5)
        rightLine:SetThickness(1)
        rightLine:SetStartPoint("TOPLEFT", centerX + textWidth / 2 + 10, yOffset + 5)
        rightLine:SetEndPoint("TOPLEFT", 610, yOffset + 5)
    end

    -- Add patch notes to content
    local yOffset = 0
    for i, patch in ipairs(patchNotes) do
        local versionText = "Version: " .. patch.version
		
        -- Add version text (centered)
        local versionHeight, fontString = AddPatchNoteItem(content, versionText, yOffset, "GameFontNormalLarge", {1, 1, 0.7}, "CENTER")
        yOffset = yOffset - versionHeight

        -- Add lines next to the version text
        AddLinesForText(content, fontString:GetStringWidth(), yOffset)

        -- Adjust yOffset for space after lines
        yOffset = yOffset - 10

        if #patch.improvements > 0 then
            yOffset = yOffset - AddPatchNoteItem(content, "Improvements:", yOffset, "GameFontNormalLarge", {1, 1, 1})
            for _, improvement in ipairs(patch.improvements) do
                yOffset = yOffset - AddPatchNoteItem(content, "    - " .. improvement, yOffset, "GameFontNormal", {0.8, 0.8, 0.8})
            end
        end

        if #patch.bugs > 0 then
            yOffset = yOffset - AddPatchNoteItem(content, "Bugs Fixed:", yOffset, "GameFontNormalLarge", {1, 1, 1})
            for _, bug in ipairs(patch.bugs) do
                yOffset = yOffset - AddPatchNoteItem(content, "    - " .. bug, yOffset, "GameFontNormal", {0.8, 0.8, 0.8})
            end
        end

        if #patch.features > 0 then
            yOffset = yOffset - AddPatchNoteItem(content, "Features:", yOffset, "GameFontNormalLarge", {1, 1, 1})
            for _, feature in ipairs(patch.features) do
                yOffset = yOffset - AddPatchNoteItem(content, "    - " .. feature, yOffset, "GameFontNormal", {0.8, 0.8, 0.8})
            end
        end

        yOffset = yOffset - 10 -- Adding space between versions
    end

    -- Update content height
    content:SetHeight(-yOffset)

    -- Add the panel to Interface Options
    InterfaceOptions_AddCategory(panel)
end

CreateOptionsPanel()

