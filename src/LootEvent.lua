local _, Addon = ...
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local SavedVariables = Addon:GetModule("SavedVariables")
local BeggingInterface = Addon:GetModule("Begging-interface")
local LootedItemFrame = Addon:GetModule("LootedItemFrame")

--Fonction à créer   définir l'event pour peupler le group cache, 

--------------------------------------------------------------------------------
--------------------------- LOCAL FUNCTION -------------------------------------
--------------------------------------------------------------------------------

     -----------------------------------------------------------------------
     ------------------ DEFINE CONSTANT AND MAPPINGS -----------------------
	 -----------------------------------------------------------------------
	 
-- Keys for the array returned by GetFullItemInfo()
local FII_ITEM						= 'ITEM'						-- item link
--local FII_NAME					= 'NAME'						-- return value 1 of Blizzard API call GetItemInfo()
--local FII_LINK					= 'LINK'						-- return value 2 of Blizzard API call GetItemInfo()
local FII_QUALITY					= 'QUALITY'						-- return value 3 of Blizzard API call GetItemInfo()
local FII_BASE_ILVL					= 'BASE_ILVL'					-- return value 4 of Blizzard API call GetItemInfo()
local FII_REQUIRED_LEVEL			= 'REQUIRED_LEVEL'				-- return value 5 of Blizzard API call GetItemInfo()
local FII_TYPE					= 'TYPE'						-- return value 6 of Blizzard API call GetItemInfo()
local FII_SUB_TYPE				= 'SUB_TYPE'					-- return value 7 of Blizzard API call GetItemInfo()
--local FII_MAX_STACK				= 'MAX_STACK'					-- return value 8 of Blizzard API call GetItemInfo()
local FII_ITEM_EQUIP_LOC			= 'ITEM_EQUIP_LOC'				-- return value 9 of Blizzard API call GetItemInfo()
--local FII_TEXTURE					= 'TEXTURE'						-- return value 10 of Blizzard API call GetItemInfo()
--local FII_VENDOR_PRICE			= 'VENDOR_PRICE'				-- return value 11 of Blizzard API call GetItemInfo()
local FII_CLASS						= 'CLASS'						-- return value 12 of Blizzard API call GetItemInfo()
local FII_SUB_CLASS					= 'SUB_CLASS'					-- return value 13 of Blizzard API call GetItemInfo()
local FII_BIND_TYPE					= 'BIND_TYPE'					-- return value 14 of Blizzard API call GetItemInfo()
--local FII_EXPAC_ID				= 'EXPAC_ID'					-- return value 15 of Blizzard API call GetItemInfo()
--local FII_ITEM_SET_ID				= 'ITEM_SET_ID'					-- return value 16 of Blizzard API call GetItemInfo()
--local FII_IS_CRAFTING_REAGENT		= 'IS_CRAFTING_REAGENT'			-- return value 17 of Blizzard API call GetItemInfo()
local FII_IS_EQUIPPABLE				= 'IS_EQUIPPABLE'				-- true if the item is equippable, false otherwise
local FII_REAL_ILVL					= 'REAL_ILVL'					-- real ilvl, derived from tooltip
local FII_CLASSES					= 'CLASSES'						-- uppercase string of classes that can use the item (ex: tier); nil if item is not class-restricted
local FII_TRADE_TIME_WARNING_SHOWN  = 'TRADE_TIME_WARNING_SHOWN'	-- true if the 'You may trade this item...' text is in the tooltip
local FII_HAS_SOCKET				= 'HAS_SOCKET'					-- true if the item has a socket
local FII_HAS_AVOIDANCE				= 'HAS_AVOIDANCE'				-- true if the item has avoidance
local FII_HAS_INDESTRUCTIBLE		= 'HAS_INDESTRUCTIBLE'			-- true if the item has indestructible
local FII_HAS_LEECH					= 'HAS_LEECH'					-- true if the item has leech
local FII_HAS_SPEED					= 'HAS_SPEED'					-- true if the item has speed
local FII_XMOGGABLE					= 'XMOGGABLE'					-- true if the player needs this item for xmog
local FII_IS_BOUND_TO_ACCOUNT		= "IS_BOUND_TO_ACCOUNT"			-- true if the item is bound at account/warband

-- Localization-independent class names

local DEATH_KNIGHT					= select(2, GetClassInfo(6))
local DEMON_HUNTER					= select(2, GetClassInfo(12))
local DRUID							= select(2, GetClassInfo(11))
local EVOKER						= select(2, GetClassInfo(13))
local HUNTER						= select(2, GetClassInfo(3))
local MAGE							= select(2, GetClassInfo(8))
local MONK							= select(2, GetClassInfo(10))
local PALADIN						= select(2, GetClassInfo(2))
local PRIEST						= select(2, GetClassInfo(5))
local ROGUE							= select(2, GetClassInfo(4))
local SHAMAN						= select(2, GetClassInfo(7))
local WARLOCK						= select(2, GetClassInfo(9))
local WARRIOR						= select(2, GetClassInfo(1))

local SPECS = {
	DK_BLOOD						= 250,
	DK_FROST						= 251,
	DK_UNHOLY						= 252,
	DH_HAVOC						= 577,
	DH_VENGEANCE					= 581,
	DRUID_BALANCE					= 102,
	DRUID_FERAL						= 103,
	DRUID_GUARDIAN					= 104,
	DRUID_RESTO						= 105,
	EVOKER_DEVA						= 1467,
	EVOKER_PRES						= 1468,
	EVOKER_AUG						= 1473,
	HUNTER_BM						= 253,
	HUNTER_MARKS					= 254,
	HUNTER_SURVIVAL					= 255,
	MAGE_ARCANE						= 62,
	MAGE_FIRE						= 63,
	MAGE_FROST						= 64,
	MONK_BM							= 268,
	MONK_MW							= 270,
	MONK_WW							= 269,
	PALADIN_HOLY					= 65,
	PALADIN_PROT					= 66,
	PALADIN_RET						= 70,
	PRIEST_DISC						= 256,
	PRIEST_HOLY						= 257,
	PRIEST_SHADOW					= 258,
	ROGUE_ASS						= 259,
	ROGUE_OUTLAW					= 260,
	ROGUE_SUB						= 261,
	SHAMAN_ELE						= 262,
	SHAMAN_ENH						= 263,
	SHAMAN_RESTO					= 264,
	WARLOCK_AFF						= 256,
	WARLOCK_DEMO					= 266,
	WARLOCK_DESTRO					= 267,
	WARRIOR_ARMS					= 71,
	WARRIOR_FURY					= 72,
	WARRIOR_PROT					= 73
}

local SPEC_BY_CLASS = {
	[DEATH_KNIGHT]					= { SPECS.DK_BLOOD, SPECS.DK_FROST, SPECS.DK_UNHOLY },
	[DEMON_HUNTER]					= { SPECS.DH_HAVOC, SPECS.DH_VENGEANCE },
	[DRUID]							= { SPECS.DRUID_BALANCE, SPECS.DRUID_FERAL, SPECS.DRUID_GUARDIAN, SPECS.DRUID_RESTO },
	[EVOKER]						= { SPECS.EVOKER_DEVA, SPECS.EVOKER_PRES, SPECS.EVOKER_AUG },
	[HUNTER]						= { SPECS.HUNTER_BM, SPECS.HUNTER_MARKS, SPECS.HUNTER_SURVIVAL },
	[MAGE]							= { SPECS.MAGE_ARCANE, SPECS.MAGE_FIRE, SPECS.MAGE_FROST },
	[MONK]							= { SPECS.MONK_BM, SPECS.MONK_MW, SPECS.MONK_WW },
	[PALADIN]						= { SPECS.PALADIN_HOLY, SPECS.PALADIN_PROT, SPECS.PALADIN_RET },
	[PRIEST]						= { SPECS.PRIEST_DISC, SPECS.PRIEST_HOLY, SPECS.PRIEST_SHADOW },
	[ROGUE]							= { SPECS.ROGUE_ASS, SPECS.ROGUE_OUTLAW, SPECS.ROGUE_SUB },
	[SHAMAN]						= { SPECS.SHAMAN_ELE, SPECS.SHAMAN_ENH, SPECS.SHAMAN_RESTO },
	[WARLOCK]						= { SPECS.WARLOCK_AFF, SPECS.WARLOCK_DEMO, SPECS.WARLOCK_DESTRO },
	[WARRIOR]						= { SPECS.WARRIOR_ARMS, SPECS.WARRIOR_FURY, SPECS.WARRIOR_PROT }
}

-- Mapping of specs to roles
-- Roles
PLH_ROLE_AGILITY_DPS				= 'AGILITY_DPS'
PLH_ROLE_INTELLECT_DPS				= 'INTELLECT_DPS'
PLH_ROLE_STRENGTH_DPS				= 'STRENGTH_DPS'
PLH_ROLE_HEALER						= 'HEALER'
PLH_ROLE_TANK						= 'TANK'
PLH_ROLE_UNKNOWN					= 'UNKNOWN'

local ROLE_BY_SPEC = {
	[SPECS.DK_BLOOD]				= PLH_ROLE_TANK,
	[SPECS.DK_FROST]				= PLH_ROLE_STRENGTH_DPS,
	[SPECS.DK_UNHOLY]				= PLH_ROLE_STRENGTH_DPS,
	[SPECS.DH_HAVOC]				= PLH_ROLE_AGILITY_DPS,
	[SPECS.DH_VENGEANCE]			= PLH_ROLE_TANK,
	[SPECS.DRUID_BALANCE]			= PLH_ROLE_INTELLECT_DPS,
	[SPECS.DRUID_FERAL]				= PLH_ROLE_AGILITY_DPS,
	[SPECS.DRUID_GUARDIAN]			= PLH_ROLE_TANK,
	[SPECS.DRUID_RESTO]				= PLH_ROLE_HEALER,
	[SPECS.EVOKER_DEVA]				= PLH_ROLE_INTELLECT_DPS,
	[SPECS.EVOKER_PRES]				= PLH_ROLE_HEALER,
	[SPECS.EVOKER_AUG]				= PLH_ROLE_INTELLECT_DPS,
	[SPECS.HUNTER_BM]				= PLH_ROLE_AGILITY_DPS,
	[SPECS.HUNTER_MARKS]			= PLH_ROLE_AGILITY_DPS,
	[SPECS.HUNTER_SURVIVAL]			= PLH_ROLE_AGILITY_DPS,
	[SPECS.MAGE_ARCANE]				= PLH_ROLE_INTELLECT_DPS,
	[SPECS.MAGE_FIRE]				= PLH_ROLE_INTELLECT_DPS,
	[SPECS.MAGE_FROST]				= PLH_ROLE_INTELLECT_DPS,
	[SPECS.MONK_BM]					= PLH_ROLE_TANK,
	[SPECS.MONK_MW]					= PLH_ROLE_HEALER,
	[SPECS.MONK_WW]					= PLH_ROLE_AGILITY_DPS,
	[SPECS.PALADIN_HOLY]			= PLH_ROLE_HEALER,
	[SPECS.PALADIN_PROT]			= PLH_ROLE_TANK,
	[SPECS.PALADIN_RET]				= PLH_ROLE_STRENGTH_DPS,
	[SPECS.PRIEST_DISC]				= PLH_ROLE_HEALER,
	[SPECS.PRIEST_HOLY]				= PLH_ROLE_HEALER,
	[SPECS.PRIEST_SHADOW]			= PLH_ROLE_INTELLECT_DPS,
	[SPECS.ROGUE_ASS]				= PLH_ROLE_AGILITY_DPS,
	[SPECS.ROGUE_OUTLAW]			= PLH_ROLE_AGILITY_DPS,
	[SPECS.ROGUE_SUB]				= PLH_ROLE_AGILITY_DPS,
	[SPECS.SHAMAN_ELE]				= PLH_ROLE_INTELLECT_DPS,
	[SPECS.SHAMAN_ENH]				= PLH_ROLE_AGILITY_DPS,
	[SPECS.SHAMAN_RESTO]			= PLH_ROLE_HEALER,
	[SPECS.WARLOCK_AFF]				= PLH_ROLE_INTELLECT_DPS,
	[SPECS.WARLOCK_DEMO]			= PLH_ROLE_INTELLECT_DPS,
	[SPECS.WARLOCK_DESTRO]			= PLH_ROLE_INTELLECT_DPS,
	[SPECS.WARRIOR_ARMS]			= PLH_ROLE_STRENGTH_DPS,
	[SPECS.WARRIOR_FURY]			= PLH_ROLE_STRENGTH_DPS,
	[SPECS.WARRIOR_PROT]			= PLH_ROLE_TANK
}

local PRIMARY_ATTRIBUTE_BY_SPEC = {
	[SPECS.DK_BLOOD]				= ITEM_MOD_STRENGTH_SHORT,
	[SPECS.DK_FROST]				= ITEM_MOD_STRENGTH_SHORT,
	[SPECS.DK_UNHOLY]				= ITEM_MOD_STRENGTH_SHORT,
	[SPECS.DH_HAVOC]				= ITEM_MOD_AGILITY_SHORT,
	[SPECS.DH_VENGEANCE]			= ITEM_MOD_AGILITY_SHORT,
	[SPECS.DRUID_BALANCE]			= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.DRUID_FERAL]				= ITEM_MOD_AGILITY_SHORT,
	[SPECS.DRUID_GUARDIAN]			= ITEM_MOD_AGILITY_SHORT,
	[SPECS.DRUID_RESTO]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.EVOKER_DEVA]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.EVOKER_PRES]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.EVOKER_AUG]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.HUNTER_BM]				= ITEM_MOD_AGILITY_SHORT,
	[SPECS.HUNTER_MARKS]			= ITEM_MOD_AGILITY_SHORT,
	[SPECS.HUNTER_SURVIVAL]			= ITEM_MOD_AGILITY_SHORT,
	[SPECS.MAGE_ARCANE]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.MAGE_FIRE]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.MAGE_FROST]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.MONK_BM]					= ITEM_MOD_AGILITY_SHORT,
	[SPECS.MONK_MW]					= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.MONK_WW]					= ITEM_MOD_AGILITY_SHORT,
	[SPECS.PALADIN_HOLY]			= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.PALADIN_PROT]			= ITEM_MOD_STRENGTH_SHORT,
	[SPECS.PALADIN_RET]				= ITEM_MOD_STRENGTH_SHORT,
	[SPECS.PRIEST_DISC]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.PRIEST_HOLY]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.PRIEST_SHADOW]			= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.ROGUE_ASS]				= ITEM_MOD_AGILITY_SHORT,
	[SPECS.ROGUE_OUTLAW]			= ITEM_MOD_AGILITY_SHORT,
	[SPECS.ROGUE_SUB]				= ITEM_MOD_AGILITY_SHORT,
	[SPECS.SHAMAN_ELE]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.SHAMAN_ENH]				= ITEM_MOD_AGILITY_SHORT,
	[SPECS.SHAMAN_RESTO]			= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.WARLOCK_AFF]				= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.WARLOCK_DEMO]			= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.WARLOCK_DESTRO]			= ITEM_MOD_INTELLECT_SHORT,
	[SPECS.WARRIOR_ARMS]			= ITEM_MOD_STRENGTH_SHORT,
	[SPECS.WARRIOR_FURY]			= ITEM_MOD_STRENGTH_SHORT,
	[SPECS.WARRIOR_PROT]			= ITEM_MOD_STRENGTH_SHORT
}

function PrintTable(tbl, indent)
    indent = indent or 0
    local indentStr = string.rep(" ", indent)

    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(indentStr .. tostring(k) .. ":")
            PrintTable(v, indent + 4)
        else
            print(indentStr .. tostring(k) .. ": " .. tostring(v))
        end
    end
end

local ItemClass = Enum.ItemClass
local ItemArmorSubclass = Enum.ItemArmorSubclass
local ItemWeaponSubclass = Enum.ItemWeaponSubclass


local EQUIPPABLE_ARMOR_BY_SPEC = {
	[SPECS.DK_BLOOD]				= { ItemArmorSubclass.Plate },
	[SPECS.DK_FROST]				= { ItemArmorSubclass.Plate },
	[SPECS.DK_UNHOLY]				= { ItemArmorSubclass.Plate },
	[SPECS.DH_HAVOC]				= { ItemArmorSubclass.Leather },
	[SPECS.DH_VENGEANCE]			= { ItemArmorSubclass.Leather },
	[SPECS.DRUID_BALANCE]			= { ItemArmorSubclass.Leather, ItemArmorSubclass.Generic },
	[SPECS.DRUID_FERAL]				= { ItemArmorSubclass.Leather },
	[SPECS.DRUID_GUARDIAN]			= { ItemArmorSubclass.Leather },
	[SPECS.DRUID_RESTO]				= { ItemArmorSubclass.Leather, ItemArmorSubclass.Generic },
	[SPECS.EVOKER_DEVA]				= { ItemArmorSubclass.Mail, ItemArmorSubclass.Generic },
	[SPECS.EVOKER_PRES]				= { ItemArmorSubclass.Mail, ItemArmorSubclass.Generic },
	[SPECS.EVOKER_AUG]				= { ItemArmorSubclass.Mail, ItemArmorSubclass.Generic },
	[SPECS.HUNTER_BM]				= { ItemArmorSubclass.Mail },
	[SPECS.HUNTER_MARKS]			= { ItemArmorSubclass.Mail },
	[SPECS.HUNTER_SURVIVAL]			= { ItemArmorSubclass.Mail },
	[SPECS.MAGE_ARCANE]				= { ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic },
	[SPECS.MAGE_FIRE]				= { ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic },
	[SPECS.MAGE_FROST]				= { ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic },
	[SPECS.MONK_BM]					= { ItemArmorSubclass.Leather },
	[SPECS.MONK_MW]					= { ItemArmorSubclass.Leather, ItemArmorSubclass.Generic },
	[SPECS.MONK_WW]					= { ItemArmorSubclass.Leather },
	[SPECS.PALADIN_HOLY]			= { ItemArmorSubclass.Plate, ItemArmorSubclass.Generic, ItemArmorSubclass.Shield },
	[SPECS.PALADIN_PROT]			= { ItemArmorSubclass.Plate, ItemArmorSubclass.Shield },
	[SPECS.PALADIN_RET]				= { ItemArmorSubclass.Plate },
	[SPECS.PRIEST_DISC]				= { ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic },
	[SPECS.PRIEST_HOLY]				= { ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic },
	[SPECS.PRIEST_SHADOW]			= { ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic },
	[SPECS.ROGUE_ASS]				= { ItemArmorSubclass.Leather },
	[SPECS.ROGUE_OUTLAW]			= { ItemArmorSubclass.Leather },
	[SPECS.ROGUE_SUB]				= { ItemArmorSubclass.Leather },
	[SPECS.SHAMAN_ELE]				= { ItemArmorSubclass.Mail, ItemArmorSubclass.Generic, ItemArmorSubclass.Shield },
	[SPECS.SHAMAN_ENH]				= { ItemArmorSubclass.Mail },
	[SPECS.SHAMAN_RESTO]			= { ItemArmorSubclass.Mail, ItemArmorSubclass.Generic, ItemArmorSubclass.Shield },
	[SPECS.WARLOCK_AFF]				= { ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic },
	[SPECS.WARLOCK_DEMO]			= { ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic },
	[SPECS.WARLOCK_DESTRO]			= { ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic },
	[SPECS.WARRIOR_ARMS]			= { ItemArmorSubclass.Plate },
	[SPECS.WARRIOR_FURY]			= { ItemArmorSubclass.Plate },
	[SPECS.WARRIOR_PROT]			= { ItemArmorSubclass.Plate, ItemArmorSubclass.Shield }
}

local EQUIPPABLE_WEAPON_BY_SPEC = {
	[SPECS.DK_BLOOD]				= { ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Sword2H },
	[SPECS.DK_FROST]				= { ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Sword1H },
	[SPECS.DK_UNHOLY]				= { ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Sword2H },
	[SPECS.DH_HAVOC]				= { ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Unarmed, ItemWeaponSubclass.Warglaive },
	[SPECS.DH_VENGEANCE]			= { ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Unarmed, ItemWeaponSubclass.Warglaive },
	[SPECS.DRUID_BALANCE]			= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Unarmed },
	[SPECS.DRUID_FERAL]				= { ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Staff },
	[SPECS.DRUID_GUARDIAN]			= { ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Staff },
	[SPECS.DRUID_RESTO]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Unarmed },
	[SPECS.EVOKER_DEVA]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Sword2H, ItemWeaponSubclass.Unarmed },
	[SPECS.EVOKER_PRES]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Sword2H, ItemWeaponSubclass.Unarmed },
	[SPECS.EVOKER_AUG]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Sword2H, ItemWeaponSubclass.Unarmed },
	[SPECS.HUNTER_BM]				= { ItemWeaponSubclass.Bows, ItemWeaponSubclass.Crossbow, ItemWeaponSubclass.Guns },
	[SPECS.HUNTER_MARKS]			= { ItemWeaponSubclass.Bows, ItemWeaponSubclass.Crossbow, ItemWeaponSubclass.Guns },
	[SPECS.HUNTER_SURVIVAL]			= { ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Staff },
	[SPECS.MAGE_ARCANE]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Wand },
	[SPECS.MAGE_FIRE]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Wand },
	[SPECS.MAGE_FROST]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Wand },
	[SPECS.MONK_BM]					= { ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Staff },
	[SPECS.MONK_MW]					= { ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Unarmed },
	[SPECS.MONK_WW]					= { ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Unarmed },
	[SPECS.PALADIN_HOLY]			= { ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Sword2H },
	[SPECS.PALADIN_PROT]			= { ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Sword1H },
	[SPECS.PALADIN_RET]				= { ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Sword2H },
	[SPECS.PRIEST_DISC]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Wand },
	[SPECS.PRIEST_HOLY]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Wand },
	[SPECS.PRIEST_SHADOW]			= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Wand },
	[SPECS.ROGUE_ASS]				= { ItemWeaponSubclass.Dagger },
	[SPECS.ROGUE_OUTLAW]			= { ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Unarmed },
	[SPECS.ROGUE_SUB]				= { ItemWeaponSubclass.Dagger },
	[SPECS.SHAMAN_ELE]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Unarmed },
	[SPECS.SHAMAN_ENH]				= { ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Unarmed },
	[SPECS.SHAMAN_RESTO]			= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Unarmed },
	[SPECS.WARLOCK_AFF]				= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Wand },
	[SPECS.WARLOCK_DEMO]			= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Wand },
	[SPECS.WARLOCK_DESTRO]			= { ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Wand },
	[SPECS.WARRIOR_ARMS]			= { ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Sword2H },
	[SPECS.WARRIOR_FURY]			= { ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Sword2H },
	[SPECS.WARRIOR_PROT]			= { ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Sword1H }
}

local SPECS_EXPECTED_TO_HAVE_OFFHAND = {
	[SPECS.DK_FROST] 				= true,
	[SPECS.DH_VENGEANCE]			= true,
	[SPECS.DH_HAVOC] 				= true,
	[SPECS.MONK_WW] 				= true,
	[SPECS.PALADIN_PROT] 			= true,
	[SPECS.ROGUE_ASS] 				= true,
	[SPECS.ROGUE_OUTLAW] 			= true,
	[SPECS.ROGUE_SUB] 				= true,
	[SPECS.SHAMAN_ENH] 				= true,
	[SPECS.WARRIOR_PROT] 			= true
}

local XMOG_BY_CLASS = {

	[DEATH_KNIGHT] = { 
		Armor = {ItemArmorSubclass.Plate, ItemArmorSubclass.Generic}, 
		Weapons = {ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Sword2H}
	},
	[DEMON_HUNTER] = { 
		Armor = {ItemArmorSubclass.Leather, ItemArmorSubclass.Generic},
		Weapons = {ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Unarmed, ItemWeaponSubclass.Warglaive, ItemWeaponSubclass.Dagger}
	},
	[DRUID] = { 
		Armor = {ItemArmorSubclass.Leather, ItemArmorSubclass.Generic},
		Weapons = {ItemWeaponSubclass.Unarmed, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Polearm}
	},
	[EVOKER] = { 
		Armor = {ItemArmorSubclass.Mail, ItemArmorSubclass.Generic},
		Weapons = {ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Sword2H, ItemWeaponSubclass.Unarmed}
	},
	[HUNTER] = { 
		Armor = {ItemArmorSubclass.Mail, ItemArmorSubclass.Generic},
		Weapons = {ItemWeaponSubclass.Unarmed, ItemWeaponSubclass.Sword2H, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Guns, ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Crossbow, ItemWeaponSubclass.Bows, ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Axe1H }
	},
	[MAGE] = { 
		Armor = {ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic},
		Weapons = {ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Wand}
	},
	[MONK] = { 
		Armor = {ItemArmorSubclass.Leather, ItemArmorSubclass.Generic},
		Weapons = {ItemWeaponSubclass.Unarmed, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Axe2H}
	},
	[PALADIN] = { 
		Armor = {ItemArmorSubclass.Plate, ItemArmorSubclass.Generic, ItemArmorSubclass.Shield},
		Weapons = {ItemWeaponSubclass.Sword2H, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Axe1H}
	},
	[PRIEST] = { 
		Armor = {ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic},
		Weapons = {ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Wand}
	},
	[ROGUE] = { 
		Armor = {ItemArmorSubclass.Leather, ItemArmorSubclass.Generic},
		Weapons = {ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Unarmed, ItemWeaponSubclass.Bows, ItemWeaponSubclass.Crossbow, ItemWeaponSubclass.Guns, ItemWeaponSubclass.Thrown, ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.FistWeapon}
	},
	[SHAMAN] = { 
		Armor = {ItemArmorSubclass.Mail, ItemArmorSubclass.Generic, ItemArmorSubclass.Shield},
		Weapons = {ItemWeaponSubclass.Unarmed, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.FistWeapon}
	},
	[WARLOCK] = { 
		Armor = {ItemArmorSubclass.Cloth, ItemArmorSubclass.Generic},
		Weapons = {ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Wand}
	},
	[WARRIOR] = { 
		Armor = {ItemArmorSubclass.Plate, ItemArmorSubclass.Generic, ItemArmorSubclass.Shield},
		Weapons = {ItemWeaponSubclass.Guns, ItemWeaponSubclass.Crossbow, ItemWeaponSubclass.Bows, ItemWeaponSubclass.Unarmed, ItemWeaponSubclass.Sword2H, ItemWeaponSubclass.Sword1H, ItemWeaponSubclass.Staff, ItemWeaponSubclass.Polearm, ItemWeaponSubclass.Mace2H, ItemWeaponSubclass.Mace1H, ItemWeaponSubclass.Dagger, ItemWeaponSubclass.Axe2H, ItemWeaponSubclass.Axe1H, ItemWeaponSubclass.Warglaive}
	}

}

local MOUNT_SUBTYPE = 15
local PET_SUBTYPE = 17
local TOY_SUBTYPE = 3
local RECIPE_SUBTYPE = 9

ObjectList = ObjectList or {}
local receivedItems = {}

local lootListening = false
local LootRollWinners = {}

debugLootEvent = false

     -----------------------------------------------------------------------
     ------------------ FONCTION USEFULL FOR THE EVENT ---------------------
	 -----------------------------------------------------------------------

  --Fonction pour chercher l'info dans le tooltip créé artificiellement
  local function GetILVLFromTooltip(tooltip)
    local ITEM_LEVEL_PATTERN        = _G.ITEM_LEVEL:gsub('%%d', '(%%d+)')          -- Item Level (%d+)
    local ilvl = nil
    local text = tooltip.leftside[2]:GetText()
    if text ~= nil then
      ilvl = text:match(ITEM_LEVEL_PATTERN)
    end
    if ilvl == nil then  -- ilvl can be in the 2nd or 3rd line dependng on the tooltip; if we didn't find it in 2nd, try 3rd
      text = tooltip.leftside[3]:GetText()
      if text ~= nil then
        ilvl = text:match(ITEM_LEVEL_PATTERN)
      end
    end
    return ilvl
  end

local function GetFullItemInfo(item)
  local ITEM_CLASSES_ALLOWED_PATTERN = _G.ITEM_CLASSES_ALLOWED:gsub('%%s', '(.+)')
  local BIND_TRADE_TIME_REMAINING_PATTERN = _G.BIND_TRADE_TIME_REMAINING:gsub('%%s', '(.+)')
  local TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN_PATTERN = _G.TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN:gsub('%%s', '(.+)')

  -- Modèles pour les objets liés au compte et au bataillon
  local ITEM_BIND_TO_ACCOUNT_PATTERN = _G.ITEM_BIND_TO_ACCOUNT:gsub('%%s', '(.+)')
  local ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP_PATTERN = _G.ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP:gsub('%%s', '(.+)')
  local ITEM_BIND_TO_BNETACCOUNT_PATTERN = _G.ITEM_BIND_TO_BNETACCOUNT:gsub('%%s', '(.+)')
  local ITEM_BNETACCOUNTBOUND_PATTERN = _G.ITEM_BNETACCOUNTBOUND:gsub('%%s', '(.+)')

  local fullItemInfo = {}

  if item ~= nil then
    fullItemInfo[FII_ITEM] = item

    -- Récupération des informations de base
    _, _, fullItemInfo[FII_QUALITY], fullItemInfo[FII_BASE_ILVL], fullItemInfo[FII_REQUIRED_LEVEL], fullItemInfo[FII_TYPE], fullItemInfo[FII_SUB_TYPE], _, fullItemInfo[FII_ITEM_EQUIP_LOC], _, _, fullItemInfo[FII_CLASS], fullItemInfo[FII_SUB_CLASS], fullItemInfo[FII_BIND_TYPE], _, _, _ = GetItemInfo(item)
  
  -- Cas particuliers des Montures/Mascottes/Jouets/Recettes
  local itemSubType = fullItemInfo[FII_SUB_TYPE]
  if itemSubType == MOUNT_SUBTYPE or itemSubType == PET_SUBTYPE or itemSubType == TOY_SUBTYPE or itemSubType == RECIPE_SUBTYPE then
    return fullItemInfo -- Retourner ici car aucune autre information n'est nécessaire pour ces sous-types
  end

  -- Détection si l'objet est équipable
  fullItemInfo[FII_IS_EQUIPPABLE] = IsEquippableItem(item)

  if fullItemInfo[FII_IS_EQUIPPABLE] then
    -- Configurer le tooltip pour détecter les valeurs supplémentaires
    tooltipLong = tooltipLong or CreateFrame("GameTooltip", "BFLScanTooltip", nil, "GameTooltipTemplate")
    tooltipLong:SetOwner(WorldFrame, "ANCHOR_NONE")
    tooltipLong:ClearLines()
    tooltipLong:SetHyperlink(item)
    tooltipLong.leftside = {}
    local i = 1
    while _G["BFLScanTooltipTextLeft" .. i] do
      tooltipLong.leftside[i] = _G["BFLScanTooltipTextLeft" .. i]
      i = i + 1
    end

    local realILVL = GetILVLFromTooltip(tooltipLong) or fullItemInfo[FII_BASE_ILVL] fullItemInfo[FII_REAL_ILVL] = tonumber(realILVL)

    local classes, hasBindTradeTimeWarning, hasSocket, hasAvoidance, hasIndestructible, hasLeech, hasSpeed, xmoggable, isBoundToAccount = nil, nil, false, false, false, false, false, false, false

    local text
    local index = 4
    while tooltipLong.leftside[index] do
      text = tooltipLong.leftside[index]:GetText()
                
      if text ~= nil then
        -- Recherche des mots-clés pour les liaisons au compte
        if text:find(ITEM_BIND_TO_ACCOUNT_PATTERN) or text:find(ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP_PATTERN) or text:find(ITEM_BIND_TO_BNETACCOUNT_PATTERN) or text:find(ITEM_BNETACCOUNTBOUND_PATTERN) then
          isBoundToAccount = true
        end

        hasBindTradeTimeWarning = hasBindTradeTimeWarning or text:match(BIND_TRADE_TIME_REMAINING_PATTERN)
        classes = classes or text:match(ITEM_CLASSES_ALLOWED_PATTERN)
        hasSocket = hasSocket or text:find(_G.EMPTY_SOCKET_PRISMATIC) == 1
        hasAvoidance = hasAvoidance or text:find(_G.STAT_AVOIDANCE) ~= nil
        hasIndestructible = hasIndestructible or text:find(_G.STAT_STURDINESS) == 1
        hasLeech = hasLeech or text:find(_G.STAT_LIFESTEAL) ~= nil
        hasSpeed = hasSpeed or text:find(_G.STAT_SPEED) ~= nil
        xmoggable = xmoggable or text:find(TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN_PATTERN) ~= nil
      end
      index = index + 1
    end

    if classes ~= nil then
      classes = string.upper(classes)
      classes = string.gsub(classes, ' ', '')
    end

    -- Ajout des informations de liaison et des caractéristiques
    fullItemInfo[FII_CLASSES] = classes
    fullItemInfo[FII_TRADE_TIME_WARNING_SHOWN] = hasBindTradeTimeWarning
    fullItemInfo[FII_HAS_SOCKET] = hasSocket
    fullItemInfo[FII_HAS_AVOIDANCE] = hasAvoidance
    fullItemInfo[FII_HAS_INDESTRUCTIBLE] = hasIndestructible
    fullItemInfo[FII_HAS_LEECH] = hasLeech
    fullItemInfo[FII_HAS_SPEED] = hasSpeed
    fullItemInfo[FII_XMOGGABLE] = xmoggable
    fullItemInfo[FII_IS_BOUND_TO_ACCOUNT] = isBoundToAccount  -- Détection de l'objet lié au compte
    end
  end

  return fullItemInfo
end

local function IsTradeable(fullItemInfo)
  local noTradeBindOnEquip = SavedVariables:Get().noTradeBindOnEquip
  
  -- Vérification de l'objet lié au compte/bataillon
  if fullItemInfo[FII_IS_BOUND_TO_ACCOUNT] then
    return false
  end

  -- Logique existante pour les objets échangeables
  if (fullItemInfo[FII_QUALITY] == Enum.ItemQuality.Rare or fullItemInfo[FII_QUALITY] == Enum.ItemQuality.Epic) and fullItemInfo[FII_BIND_TYPE] == 1 then
    return true
  elseif fullItemInfo[FII_BIND_TYPE] == 2 and not noTradeBindOnEquip then
    return true
  else
    return false
  end
end

local function GetItemPrimaryAttribute(item)
  local stats = GetItemStats(item)
  if stats ~= nil then
    for stat, value in pairs(stats) do
      if _G[stat] == ITEM_MOD_STRENGTH_SHORT or _G[stat] == ITEM_MOD_INTELLECT_SHORT or _G[stat] == ITEM_MOD_AGILITY_SHORT then
        return _G[stat]
      end
    end
  end
  return nil
end

local function GetSlotIdFromItemId(itemId, callback)
    local itemInfo = {GetItemInfo(itemId)}

    if itemInfo[1] then
        -- L'objet est en cache, on peut continuer
        local itemEquipLoc = itemInfo[9]

        local equipSlotMappings = {
            ["INVTYPE_HEAD"] = 1,
            ["INVTYPE_NECK"] = 2,
            ["INVTYPE_SHOULDER"] = 3,
            ["INVTYPE_BODY"] = 4,
            ["INVTYPE_CHEST"] = 5,
            ["INVTYPE_ROBE"] = 5,
            ["INVTYPE_WAIST"] = 6,
            ["INVTYPE_LEGS"] = 7,
            ["INVTYPE_FEET"] = 8,
            ["INVTYPE_WRIST"] = 9,
            ["INVTYPE_HAND"] = 10,
            ["INVTYPE_FINGER"] = 11, -- Peut être 11 ou 12
            ["INVTYPE_TRINKET"] = 13, -- Peut être 13 ou 14
            ["INVTYPE_CLOAK"] = 15,
            ["INVTYPE_WEAPON"] = 16, -- Peut être 16 ou 17 pour main gauche
            ["INVTYPE_SHIELD"] = 17,
            ["INVTYPE_2HWEAPON"] = 16, -- Peut être 16 ou 17
            ["INVTYPE_WEAPONMAINHAND"] = 16,
            ["INVTYPE_WEAPONOFFHAND"] = 17,
            ["INVTYPE_HOLDABLE"] = 17,
            ["INVTYPE_RANGED"] = 18,
            ["INVTYPE_THROWN"] = 18,
            ["INVTYPE_RANGEDRIGHT"] = 18,
            ["INVTYPE_RELIC"] = 18,
            ["INVTYPE_TABARD"] = 19,
            ["INVTYPE_BAG"] = 20 -- Les sacs ne sont pas des emplacements d'équipement classiques
        }

        callback(equipSlotMappings[itemEquipLoc])
    else
        -- L'objet n'est pas en cache, on demande à le charger
        local function OnEvent(self, event, arg1)
            if arg1 == itemId then
                -- Les informations de l'objet sont maintenant disponibles
                local itemEquipLoc = select(9, GetItemInfo(itemId))

                local equipSlotMappings = {
                    ["INVTYPE_HEAD"] = 1,
                    ["INVTYPE_NECK"] = 2,
                    ["INVTYPE_SHOULDER"] = 3,
                    ["INVTYPE_BODY"] = 4,
                    ["INVTYPE_CHEST"] = 5,
                    ["INVTYPE_ROBE"] = 5,
                    ["INVTYPE_WAIST"] = 6,
                    ["INVTYPE_LEGS"] = 7,
                    ["INVTYPE_FEET"] = 8,
                    ["INVTYPE_WRIST"] = 9,
                    ["INVTYPE_HAND"] = 10,
                    ["INVTYPE_FINGER"] = 11, -- Peut être 11 ou 12
                    ["INVTYPE_TRINKET"] = 13, -- Peut être 13 ou 14
                    ["INVTYPE_CLOAK"] = 15,
                    ["INVTYPE_WEAPON"] = 16, -- Peut être 16 ou 17 pour main gauche
                    ["INVTYPE_SHIELD"] = 17,
                    ["INVTYPE_2HWEAPON"] = 16, -- Peut être 16 ou 17
                    ["INVTYPE_WEAPONMAINHAND"] = 16,
                    ["INVTYPE_WEAPONOFFHAND"] = 17,
                    ["INVTYPE_HOLDABLE"] = 17,
                    ["INVTYPE_RANGED"] = 18,
                    ["INVTYPE_THROWN"] = 18,
                    ["INVTYPE_RANGEDRIGHT"] = 18,
                    ["INVTYPE_RELIC"] = 18,
                    ["INVTYPE_TABARD"] = 19,
                    ["INVTYPE_BAG"] = 20 -- Les sacs ne sont pas des emplacements d'équipement classiques
                }

                callback(equipSlotMappings[itemEquipLoc])

                -- On désenregistre l'événement pour éviter les appels multiples
                self:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
                self:SetScript("OnEvent", nil)
            end
        end

        local frame = CreateFrame("Frame")
        frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
        frame:SetScript("OnEvent", OnEvent)

        C_Item.RequestLoadItemDataByID(itemId)
    end
end

local function IsItemUsefulForthePlayerSpec(fullItemInfo, characterName, IsPlayer)
  print("IsItemUsefulForthePlayerSpec characterName" .. characterName)
  local MyCharacterClass
  local MyCharacterSpec
  local characterLevel
  if fullItemInfo ~= nil and characterName ~= nil and fullItemInfo[FII_IS_EQUIPPABLE] then
    if IsPlayer then
      _, MyCharacterClass = UnitClass('player')
      MyCharacterSpec = GetSpecializationInfo(GetSpecialization())
      characterLevel = UnitLevel('player')
    elseif (not IsPlayer and groupInfoCache[characterName] ~= nil) then
      MyCharacterClass = groupInfoCache[characterName][CLASS_NAME]
      MyCharacterSpec = groupInfoCache[characterName][SPEC]
      characterLevel = groupInfoCache[characterName][LEVEL]
    else
      print('Unable to determine class and spec in InEquippableItemForCharacter()!!!! for ' .. characterName)
      return true  -- should never reach here, but if we do it means we're not looking up the player or anyone in cache
    end

    if fullItemInfo[FII_REQUIRED_LEVEL] > characterLevel and not IsPlayer then
      return false
    end
      
    if fullItemInfo[FII_CLASSES] ~= nil then  -- check whether to item is a class restricted item (ex: tier)
      if not string.find(MyCharacterClass, fullItemInfo[FII_CLASSES]) then
        return false
      end
    end
      
    if fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_CLOAK' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_FINGER' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_NECK' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_TRINKET' then
      return true
    end

      local itemPrimaryAttribute = GetItemPrimaryAttribute(fullItemInfo[FII_ITEM])
      if itemPrimaryAttribute ~= nil then
        local isValidPrimaryAttribute = false
        for _, spec in pairs(SPEC_BY_CLASS[MyCharacterClass]) do
          if MyCharacterSpec == spec then
            if PRIMARY_ATTRIBUTE_BY_SPEC[spec] == itemPrimaryAttribute then
              isValidPrimaryAttribute = true
              break;
            end
          end
        end
        if not isValidPrimaryAttribute then
          return false
        end
      end

  if fullItemInfo[FII_CLASS] == 4 then
  local ArmorSubtypeItem = fullItemInfo[FII_SUB_CLASS]
    for _,subtype in ipairs(EQUIPPABLE_ARMOR_BY_SPEC[MyCharacterSpec]) do
	  if subtype == ArmorSubtypeItem then
	    return true
      end
	end
  end
  
  if fullItemInfo[FII_CLASS] == 2 then
  local WeaponSubtypeItem = fullItemInfo[FII_SUB_CLASS]
    for _,subtype in ipairs(EQUIPPABLE_WEAPON_BY_SPEC[MyCharacterSpec]) do
	  if subtype == WeaponSubtypeItem then
	      return true
	  end
    end
  end

  return false
end
end


local function CanClassUseItem(fullItemInfo, playerClass)
  -- Vérifie si l'objet est équipé par une des classes éligibles
  
  --If it's an offhand everyclass can learn it
  if (fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_HAND' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_CLOAK' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_FINGER' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_NECK' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_TRINKET') then
    return true
  end
	
  local index = nil
  --On regarde quelle classe correspond
  for className, _ in pairs(XMOG_BY_CLASS) do
    if className == playerClass then
        index = className
        break
    end
  end
  
  if fullItemInfo[FII_CLASS] == 4 then
  local ArmorSubtypeItem = fullItemInfo[FII_SUB_CLASS]
 -- print(ArmorSubtypeItem)
    for _,subtype in ipairs(XMOG_BY_CLASS[index].Armor) do
	  --print(subtype)
	  if subtype == ArmorSubtypeItem then
	    return true
      end
	end
  end
  
  if fullItemInfo[FII_CLASS] == 2 then
  local WeaponSubtypeItem = fullItemInfo[FII_SUB_CLASS]
  --print(WeaponSubtypeItem)
    for _,subtype in ipairs(XMOG_BY_CLASS[index].Weapons) do
	  --print(subtype)
	  if subtype == WeaponSubtypeItem then
	    return true
	  end
    end
  end
  

  return false
end


local function CanSpecUseItem(fullItemInfo, playerClass, playerSpec)
  -- Vérifie si l'objet est équipé par une des classes éligibles
  if fullItemInfo[FII_CLASSES] and fullItemInfo[FII_CLASSES]:find(playerClass) then
    -- Vérifie si l'objet peut être équipé par la spécialisation actuelle
    local equippableWeapons = EQUIPPABLE_WEAPON_BY_SPEC[playerSpec]
	local equippableArmor = EQUIPPABLE_ARMOR_BY_SPEC[playerSpec]
    if equippableWeapons then
      for _, weaponSubclass in ipairs(equippableWeapons) do
        if weaponSubclass == fullItemInfo[FII_SUB_CLASS] then
          return true
        end
      end
    end
		
    if fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_WEAPONOFFHAND' then
      return true
    end
	
    --Test the armure
    if equippableArmor then
      for _, armorType in ipairs(equippableArmor) do
        if armorType == fullItemInfo[FII_ITEM_EQUIP_LOC] then
          return true
        end
      end
    end	
		
		
		
    end
    return false
end

local function AddObjectlist(fullItemInfo, playerName, Reason)
  local objectInfo = {
    playerName = playerName,
    item = fullItemInfo[FII_ITEM],
    realItemLevel = fullItemInfo[FII_REAL_ILVL],
    reason = Reason,
    hasSocket = fullItemInfo[FII_HAS_SOCKET],
    hasAvoidance = fullItemInfo[FII_HAS_AVOIDANCE],
    hasIndestructible = fullItemInfo[FII_HAS_INDESTRUCTIBLE],
    hasLeech = fullItemInfo[FII_HAS_LEECH],
    hasSpeed = fullItemInfo[FII_HAS_SPEED]
  }
    
  -- Ajoute l'entrée à la table globale ObjectList
  table.insert(ObjectList, objectInfo)
  
  EventManager:Fire(E.NewObjectList)
end

---------------------------------------
-- Fonction de debug pour simuler le loot d'un item

local Booleendebug = false
if Booleendebug then

local function SimulateNewItemAddition()
    local playerName = "JohnDoe"  -- Nom du joueur (simulé)
    local itemLink = "|cffa335ee|Hitem:12345:::::::::::::|h[Item Name]|h|r"  -- Lien de l'item (simulé)
    local realItemLevel = 200  -- Niveau réel de l'item (simulé)
    local reason = "Raid drop"  -- Raison de l'ajout de l'item (simulé)
    local hasSocket = true  -- Exemple: l'item a un socket (simulé)
    local hasAvoidance = false  -- Exemple: l'item n'a pas d'avoidance (simulé)
    local hasIndestructible = true  -- Exemple: l'item est indestructible (simulé)
    local hasLeech = false  -- Exemple: l'item n'a pas le trait leech (simulé)
    local hasSpeed = true  -- Exemple: l'item a le trait speed (simulé)

    -- Création du tableau contenant les informations de l'item
    local fullItemInfo = {
        [FII_ITEM] = itemLink,
        [FII_REAL_ILVL] = realItemLevel,
        [FII_HAS_SOCKET] = hasSocket,
        [FII_HAS_AVOIDANCE] = hasAvoidance,
        [FII_HAS_INDESTRUCTIBLE] = hasIndestructible,
        [FII_HAS_LEECH] = hasLeech,
        [FII_HAS_SPEED] = hasSpeed
    }

    -- Ajout de l'item à ObjectList en appelant la fonction AddObjectlist
    AddObjectlist(fullItemInfo, playerName, reason)
end

-- Fonction utilitaire pour imprimer les informations complètes de l'item
local function PrintFullItemInfo(fullItemInfo)
    if fullItemInfo == nil then
        print("FullItemInfo is nil.")
        return
    end

    print("Item:", fullItemInfo[FII_ITEM])
    print("Quality:", fullItemInfo[FII_QUALITY])
    print("Base iLvl:", fullItemInfo[FII_BASE_ILVL])
    print("Required Level:", fullItemInfo[FII_REQUIRED_LEVEL])
    print("Item Equip Loc:", fullItemInfo[FII_ITEM_EQUIP_LOC])
    print("Class:", fullItemInfo[FII_CLASS])
    print("Sub Class:", fullItemInfo[FII_SUB_CLASS])
    print("Bind Type:", fullItemInfo[FII_BIND_TYPE])
    print("Is Equippable:", fullItemInfo[FII_IS_EQUIPPABLE])
    -- print("Real iLvl:", fullItemInfo[FII_REAL_ILVL])
    -- print("Classes Allowed:", fullItemInfo[FII_CLASSES])
    -- print("Trade Time Warning Shown:", fullItemInfo[FII_TRADE_TIME_WARNING_SHOWN])
    -- print("Has Socket:", fullItemInfo[FII_HAS_SOCKET])
    -- print("Has Avoidance:", fullItemInfo[FII_HAS_AVOIDANCE])
    -- print("Has Indestructible:", fullItemInfo[FII_HAS_INDESTRUCTIBLE])
    -- print("Has Leech:", fullItemInfo[FII_HAS_LEECH])
    -- print("Has Speed:", fullItemInfo[FII_HAS_SPEED])
    print("Xmoggable:", fullItemInfo[FII_XMOGGABLE])
    
end


local function DebugTestGetFullItemInfo()
	local itemID1 = 6510
	local itemID2 = 1843
	local itemID3 = 9765
    local itemName1, itemLink1 = GetItemInfo(itemID1)
	local itemName2, itemLink2 = GetItemInfo(itemID2)
	local itemName3, itemLink3 = GetItemInfo(itemID3)
	
    print("Testing GetFullItemInfo for itemID:", itemID1)
    local fullItemInfo1 = GetFullItemInfo(itemLink1)
    PrintFullItemInfo(fullItemInfo1)
	print(C_TransmogCollection.PlayerHasTransmog(itemID1))

    print("\nTesting GetFullItemInfo for itemID:", itemID2)
    local fullItemInfo2 = GetFullItemInfo(itemLink2)
    PrintFullItemInfo(fullItemInfo2)
	print(C_TransmogCollection.PlayerHasTransmog(itemID2))
	
	print("\nTesting GetFullItemInfo for itemID:", itemID3)
    local fullItemInfo3 = GetFullItemInfo(itemLink3)
    PrintFullItemInfo(fullItemInfo3)
	print(C_TransmogCollection.PlayerHasTransmog(itemID3))
end


  EventManager:Once(E.SavedVariablesReady, function()
    DebugTestGetFullItemInfo()
  end)


end
--------------------------------------


--------------------------------------------------------------------------------
--------------------------- ENCOUNTER LOOT RECEIVED ----------------------------
--------------------------------------------------------------------------------

 playerReady = false


-- Set up an event listener for when the player enters the world : usefull if the player have a low config
EventManager:On(E.SavedVariablesReady, function()
  playerReady = true

end)

EventManager:On("ENCOUNTER_LOOT_RECEIVED", function(encounterID, itemID, itemLink, quantity, playerName, classFileName)

  -- Check if the player is fully loaded : uselful for player with low config
  if not playerReady then
    return -- Exit if the player is not fully loaded
  end
  
  
  -- Get full item information using the GetFullItemInfo functionZ
  local fullItemInfo = GetFullItemInfo(itemLink)
  
  
  --Check if the item have an ilvl and is tradeable
  if fullItemInfo == nil then return print("fulliteminfo is nil") end 

    -- If the item is not tradeable, exit
  if not IsTradeable(fullItemInfo)then 
  --print("Item not Tradeable")  
  return
  end

  -- Check if the item is equippable and tradeable and not in particuliar option
  local itemSubType = fullItemInfo[FII_SUB_TYPE]
  local CasParticulier = itemSubType == MOUNT_SUBTYPE or itemSubType == PET_SUBTYPE or itemSubType == TOY_SUBTYPE or itemSubType == RECIPE_SUBTYPE
  if CasParticulier then
  else
    if fullItemInfo[FII_REAL_ILVL] == nil then
    --print("pas d'ilvl non equipable")
      return
    end
  end
		
  --Code 
  local myName = UnitName("player") -- Get the name of the current player
  local _, myClass = UnitClass('player')
  
  -- The loot is from other
  if playerName ~= myName then
    -- Retrieve user-selected options from saved variables
	local ilvlUpgrade = SavedVariables:Get().ilvlUpgrade.enabled
    local ilvlBelow = SavedVariables:Get().ilvlUpgrade.value
    local TransmogUnknown = SavedVariables:Get().transmogUnknown
    local transmogUnknownAppearanceOnly = SavedVariables:Get().transmogUnknownAppearanceOnly
    local transmogUnknownAllSharedAppearance = SavedVariables:Get().transmogUnknownSharedAppearance
    local transmogUnknownForAllClass = SavedVariables:Get().transmogUnknownForAllClass
    local transmogUnknownForMyClass = SavedVariables:Get().transmogUnknownForMyClass
    local transmogUnknownForMySpec = SavedVariables:Get().transmogUnknownForMySpec
    local optionMount = SavedVariables:Get().optionMount
    local optionPet = SavedVariables:Get().optionPet
    local optionRecipe = SavedVariables:Get().optionRecipe
    local optionToy = SavedVariables:Get().optionToy
	
    --Option Pet
    if optionPet then
	  local speciesID = C_PetJournal.FindPetIDByID(itemID)
      local numCollected = speciesID and C_PetJournal.GetNumCollectedInfo(speciesID) or 0
      if numCollected == 0 then
        AddObjectlist(fullItemInfo, playerName, 'Pet')
        return
      end
    end
	
    --Option Mount
    --Add the mount only if you don't have it
    if optionMount then
	  local mountID = C_MountJournal.GetMountFromItem(itemID)
      if mountID and not select(11, C_MountJournal.GetMountInfoByID(mountID)) then
        AddObjectlist(fullItemInfo, playerName, 'Mount')
        return
      end
    end	
	
    --Option Toy
    --Add the toy only if you don't have it
    if optionToy then
	  if not PlayerHasToy(itemID) then
        AddObjectlist(fullItemInfo, playerName, 'Toy')
        return
      end
    end
	
    --Option Recipe
    --Add the all recipe. No filter applicate yet
    if optionRecipe then
	  AddObjectlist(fullItemInfo, playerName, 'Recipe')
    end	

	
	--Option Ilvl Upgrade
    if ilvlUpgrade then
      GetSlotIdFromItemId(itemID, function(slotID)
        if not slotID then
          print("ERROR: Unable to determine slot ID for item ID:", itemID)
          return
        end

        local equippedItemLink = GetInventoryItemLink("player", slotID) -- Get the item equipped in the specified slot
        if IsItemUsefulForthePlayerSpec(fullItemInfo, myName, true) then -- Check if the item is useful for the player's spec
          if equippedItemLink then
            local equippedItemName, equippedItemLink, equippedItemQuality, equippedItemLevel = GetItemInfo(equippedItemLink) -- Get info of the equipped item
            if equippedItemLevel then
              local IlvlSeuil = equippedItemLevel - ilvlBelow -- Calculate the ilvl threshold
              if fullItemInfo[FII_REAL_ILVL] >= IlvlSeuil then
                AddObjectlist(fullItemInfo, playerName, 'ILVL UPGRADE') -- Add the item to the list if it exceeds the threshold
                return
              end
            else
              print("ERROR: Failed to retrieve the level of the equipped item:", equippedItemLink)
            end
          else
            AddObjectlist(fullItemInfo, playerName, 'ILVL UPGRADE') -- If no item is equipped, consider it an upgrade
            return
          end
        end
      end)
    end
	
	--Option Transmog
    if TransmogUnknown then 
	-- Check if the item is ring/necklace/trinket
	if fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_FINGER' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_NECK' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_TRINKET' then
	  return
    end
	
      local HasTransmogItem = C_TransmogCollection.PlayerHasTransmog(itemID)
      --Option 1 : For all class
      if transmogUnknownForAllClass then 
        --Option 1.1: Collect only the appearance
        if transmogUnknownAppearanceOnly then 
		  if fullItemInfo[FII_XMOGGABLE] then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
	    --Option 1.2: Collect all the sources of the appearances
	    elseif transmogUnknownAllSharedAppearance then
		  if not HasTransmogItem then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
        end
	  
	  --Option 2 : For my class  
      elseif transmogUnknownForMyClass then
	    --Option 2.1: Collect only the appearance
        if transmogUnknownAppearanceOnly then 
		  if fullItemInfo[FII_XMOGGABLE] then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
	    --Option 2.2: Collect all the sources of the appearances
	    elseif transmogUnknownAllSharedAppearance then
		  if not HasTransmogItem then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
        end
	  
	  --Option 3 : For my spec
	  elseif transmogUnknownForMySpec then
	    --Option 3.1: Collect only the appearance
        if transmogUnknownAppearanceOnly then 
		  if fullItemInfo[FII_XMOGGABLE] then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
	    --Option 3.2: Collect all the sources of the appearances
	    elseif transmogUnknownAllSharedAppearance then
		  if not HasTransmogItem then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
        end
      end
--End of the boucle TransmogUnknown
    end

  -- You received a loot
  elseif playerName == myName then 
  
    -- Retrieve user-selected options from saved variables
    local neverOffering = SavedVariables:Get().neverOffering
	
	--Checking the options :
	if neverOffering then return end
	
	-- Check if the player is in a raid, party, if the player is alone we don't need to offer items
    if not IsInRaid() and not IsInGroup() then return end
	
	-- Check if the item is ring/necklace/trinket
	if fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_FINGER' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_NECK' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_TRINKET' then
      AddObjectlist(fullItemInfo, playerName, 'Offer Item')
	  return
    end
	
	--Checking if the player has the transmog
    local HasTransmogItem = C_TransmogCollection.PlayerHasTransmog(itemID)
	print(fullItemInfo[FII_CLASSES])
    if HasTransmogItem then
      AddObjectlist(fullItemInfo, playerName, 'Offer Item')
	  return
	elseif fullItemInfo[FII_CLASSES] ~= myClass and fullItemInfo[FII_CLASSES] ~= nil then
	  AddObjectlist(fullItemInfo, playerName, 'Offer Item')
	  return
	else 
	  return
    end
	
  else
    print('ERROR: there are no valid names.')
  end
end)
--------------------------------------------------------------
--------- Function and Event for Group loot Roll -------------
--------------------------------------------------------------

-- On évite de checker chaque message. Donc on commence à appliquer la logique après que cette évènement survient
EventManager:On("LOOT_HISTORY_UPDATE_DROP", function()
  lootListening = true
end)

-- Quand on a quitter le group on ne peux plus savoir qui a fait les rolls donc on nettoie tous et on arrete de traiter chaque message
EventManager:On("GROUP_LEFT", function()
  lootListening = false
  LootRollWinners = {} -- Clear the LootRollWinners table when leaving the group
end)

-- Registering the CHAT_MSG_LOOT event
EventManager:On("CHAT_MSG_LOOT", function(message, playerfullname)
  -- Check if lootListening is active
  if not lootListening then return end
  
  -- Check if playerfullname is nil or empty
  if playerfullname == nil or playerfullname == "" then
    -- Check if the message starts with "[" and contains "] : ", and if the end of the message is an item link
    if message:sub(1, 1) == "[" and message:find("] : ") and message:match("|c%x+|H(.+)|h%[(.+)%]|h|r$") then
      -- Extract the player name without the server name
      local playerwithoutservername = message:match("] : (.+)%s*%(") -- Retrieve the player name
      -- Extract the item link
      local itemlink = message:match("|c%x+|H(.+)|h%[(.+)%]|h|r$") -- Extracts the item link

      -- Store both variables in the LootRollWinners table
      if not LootRollWinners[playerwithoutservername] then
        LootRollWinners[playerwithoutservername] = {}
      end
      
      table.insert(LootRollWinners[playerwithoutservername], itemlink)

    else
      return -- Exit if conditions are not met
    end

  else
    -- Check if playerfullname can find a matching name in LootRollWinners
    for playerName, items in pairs(LootRollWinners) do
      if playerfullname:find(playerName) then -- Check if the full name matches a player
        for index, item in ipairs(items) do
          if item then
            -- Trigger the WinnerFound event for each matching item
            EventManager:Fire(E.WinnerFound(playerfullname, item))
            -- Remove the item from the list after processing it
            table.remove(items, index)
            break -- Exit the loop once the item is processed to avoid index issues
          end
        end
        return -- Exit once a match is found
      end
    end

    return -- Exit if no match was found
  end
end)

EventManager:On(E.WinnerFound, function(playername, itemLink)
  -- Check if the player is fully loaded : uselful for player with low config
  if not playerReady then
    return -- Exit if the player is not fully loaded
  end

  local GroupLoot = SavedVariables:Get().GroupLoot
  if not GroupLoot then
    return -- Exit we don't want to whisper the winner of the group loot
  end
		
 -- Get full item information using the GetFullItemInfo functionZ
  local fullItemInfo = GetFullItemInfo(itemLink)
  
  
  --Check if the item have an ilvl and is tradeable
  if fullItemInfo == nil then return print("fulliteminfo is nil") end 

    -- If the item is not tradeable, exit
  if not IsTradeable(fullItemInfo)then 
  --print("Item not Tradeable")  
  return
  end

  -- Check if the item is equippable and tradeable and not in particuliar option
  local itemSubType = fullItemInfo[FII_SUB_TYPE]
  local CasParticulier = itemSubType == MOUNT_SUBTYPE or itemSubType == PET_SUBTYPE or itemSubType == TOY_SUBTYPE or itemSubType == RECIPE_SUBTYPE
  if CasParticulier then
  else
    if fullItemInfo[FII_REAL_ILVL] == nil then
    --print("pas d'ilvl non equipable")
      return
    end
  end
		
  --Code 
  local myName = UnitName("player") -- Get the name of the current player
  local _, myClass = UnitClass('player')
  
  -- The loot is from other
  if playerName ~= myName then
    -- Retrieve user-selected options from saved variables
    local ilvlUpgrade = SavedVariables:Get().ilvlUpgrade.enabled
    local ilvlBelow = SavedVariables:Get().ilvlUpgrade.value
    local TransmogUnknown = SavedVariables:Get().transmogUnknown
    local transmogUnknownAppearanceOnly = SavedVariables:Get().transmogUnknownAppearanceOnly
    local transmogUnknownAllSharedAppearance = SavedVariables:Get().transmogUnknownSharedAppearance
    local transmogUnknownForAllClass = SavedVariables:Get().transmogUnknownForAllClass
    local transmogUnknownForMyClass = SavedVariables:Get().transmogUnknownForMyClass
    local transmogUnknownForMySpec = SavedVariables:Get().transmogUnknownForMySpec
    local optionMount = SavedVariables:Get().optionMount
    local optionPet = SavedVariables:Get().optionPet
    local optionRecipe = SavedVariables:Get().optionRecipe
    local optionToy = SavedVariables:Get().optionToy
	
    --Option Pet
    if optionPet then
	  local speciesID = C_PetJournal.FindPetIDByID(itemID)
      local numCollected = speciesID and C_PetJournal.GetNumCollectedInfo(speciesID) or 0
      if numCollected == 0 then
        AddObjectlist(fullItemInfo, playerName, 'Pet')
        return
      end
    end
	
    --Option Mount
    --Add the mount only if you don't have it
    if optionMount then
	  local mountID = C_MountJournal.GetMountFromItem(itemID)
      if mountID and not select(11, C_MountJournal.GetMountInfoByID(mountID)) then
        AddObjectlist(fullItemInfo, playerName, 'Mount')
        return
      end
    end	
	
    --Option Toy
    --Add the toy only if you don't have it
    if optionToy then
	  if not PlayerHasToy(itemID) then
        AddObjectlist(fullItemInfo, playerName, 'Toy')
        return
      end
    end
	
    --Option Recipe
    --Add the all recipe. No filter applicate yet
    if optionRecipe then
	  AddObjectlist(fullItemInfo, playerName, 'Recipe')
    end	

	
	--Option Ilvl Upgrade
    if ilvlUpgrade then
      GetSlotIdFromItemId(itemID, function(slotID)
        if not slotID then
          print("ERROR: Unable to determine slot ID for item ID:", itemID)
          return
        end

        local equippedItemLink = GetInventoryItemLink("player", slotID) -- Get the item equipped in the specified slot
        if IsItemUsefulForthePlayerSpec(fullItemInfo, myName, true) then -- Check if the item is useful for the player's spec
          if equippedItemLink then
            local equippedItemName, equippedItemLink, equippedItemQuality, equippedItemLevel = GetItemInfo(equippedItemLink) -- Get info of the equipped item
            if equippedItemLevel then
              local IlvlSeuil = equippedItemLevel - ilvlBelow -- Calculate the ilvl threshold
              if fullItemInfo[FII_REAL_ILVL] >= IlvlSeuil then
                AddObjectlist(fullItemInfo, playerName, 'ILVL UPGRADE') -- Add the item to the list if it exceeds the threshold
                return
              end
            else
              print("ERROR: Failed to retrieve the level of the equipped item:", equippedItemLink)
            end
          else
            AddObjectlist(fullItemInfo, playerName, 'ILVL UPGRADE') -- If no item is equipped, consider it an upgrade
            return
          end
        end
      end)
    end
	
	--Option Transmog
    if TransmogUnknown then 
	-- Check if the item is ring/necklace/trinket
	if fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_FINGER' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_NECK' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_TRINKET' then
	  return
    end
	
      local HasTransmogItem = C_TransmogCollection.PlayerHasTransmog(itemID)
      --Option 1 : For all class
      if transmogUnknownForAllClass then 
        --Option 1.1: Collect only the appearance
        if transmogUnknownAppearanceOnly then 
		  if fullItemInfo[FII_XMOGGABLE] then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
	    --Option 1.2: Collect all the sources of the appearances
	    elseif transmogUnknownAllSharedAppearance then
		  if not HasTransmogItem then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
        end
	  
	  --Option 2 : For my class  
      elseif transmogUnknownForMyClass then
	    --Option 2.1: Collect only the appearance
        if transmogUnknownAppearanceOnly then 
		  if fullItemInfo[FII_XMOGGABLE] then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
	    --Option 2.2: Collect all the sources of the appearances
	    elseif transmogUnknownAllSharedAppearance then
		  if not HasTransmogItem then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
        end
	  
	  --Option 3 : For my spec
	  elseif transmogUnknownForMySpec then
	    --Option 3.1: Collect only the appearance
        if transmogUnknownAppearanceOnly then 
		  if fullItemInfo[FII_XMOGGABLE] then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
	    --Option 3.2: Collect all the sources of the appearances
	    elseif transmogUnknownAllSharedAppearance then
		  if not HasTransmogItem then 
            AddObjectlist(fullItemInfo, playerName, 'XMog')
		    return 
		  end
        end
      end
--End of the boucle TransmogUnknown
    end

  -- You received a loot
  elseif playerName == myName then 
  
    -- Retrieve user-selected options from saved variables
    local neverOffering = SavedVariables:Get().neverOffering
	
	--Checking the options :
	if neverOffering then return end
	
	-- Check if the player is in a raid, party, if the player is alone we don't need to offer items
    if not IsInRaid() and not IsInGroup() then return end
	
	-- Check if the item is ring/necklace/trinket
	if fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_FINGER' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_NECK' or fullItemInfo[FII_ITEM_EQUIP_LOC] == 'INVTYPE_TRINKET' then
      AddObjectlist(fullItemInfo, playerName, 'Offer Item')
	  return
    end
	
	--Checking if the player has the transmog
    local HasTransmogItem = C_TransmogCollection.PlayerHasTransmog(itemID)
	print(fullItemInfo[FII_CLASSES])
    if HasTransmogItem then
      AddObjectlist(fullItemInfo, playerName, 'Offer Item')
	  return
	elseif fullItemInfo[FII_CLASSES] ~= myClass and fullItemInfo[FII_CLASSES] ~= nil then
	  AddObjectlist(fullItemInfo, playerName, 'Offer Item')
	  return
	else 
	  return
    end
	
  else
    print('ERROR: there are no valid names.')
  end
end)

------------------------------------------------------------------------------------
------------------------- NEWOBJECTLIST EVENT --------------------------------------
------------------------------------------------------------------------------------


