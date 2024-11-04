local _, Addon = ...
local L = Addon:GetModule("Locale") ---@class Locale

setmetatable(L, {
  __index = function(t, k)
    return rawget(t, k) or k
  end
})

-- ============================================================================
-- English
-- ============================================================================

-------------------------- File : user-interface.lua ----------------------------------

  -- Global Option
L["GLOBAL_OPTIONS_TEXT"] = "General Options"
L["MINIMAP_ICON_TEXT"] = "Minimap Icon"
L["MINIMAP_ICON_TEXT_TOOLTIP"] = "Enable an icon on the minimap."
L["PROMOTE_ADDON_TEXT"] = "Promote the Addon"
L["PROMOTE_ADDON_TEXT_TOOLTIP"] = "If the option is activated, the name of the Addon (<Beg for Loot>) will be put at the beginning of each message sent by the addon."
L["GROUP_LOOT_TEXT"] = "Group Loot Rolls"
L["GROUP_LOOT_TEXT_TOOLTIP"] = "Experimental Function : Enable the option to whisper the winner of group loot rolls."
L["OPTION_PET_TEXT"] = "Pets"
L["OPTION_PET_TEXT_TOOLTIP"] = "Add the pets to the list of items we wish to trade or acquire.|nIf someone loots a pet you need it will appear in the loot frame and if you loot a pet you already have you can offer it."
L["OPTION_MOUNT_TEXT"] = "Mounts"
L["OPTION_MOUNT_TEXT_TOOLTIP"] = "Add the mounts to the list of items we wish to trade or acquire. |nIf someone loots a mount you need it will appear in the loot frame and if you loot a mount you already have you can offer it."
L["OPTION_RECIPE_TEXT"] = "Recipes"
L["OPTION_RECIPE_TEXT_TOOLTIP"] = "Add the all recipes to the list of items we wish to trade or acquire. No filter applicate yet"

  --Offering Loot
L["OFFERING_LOOT_OPTIONS_TEXT"] = "Offering Loot Options"
L["NO_TRADE_BIND_ON_EQUIP_TEXT"] = "Never trade Bind on Equip item"
L["NO_TRADE_BIND_ON_EQUIP_TEXT_TOOLTIP"] = "Never prompt me to trade Bind on Equip item"
L["SHOW_LIST_USER_TEXT"] = ""
L["SHOW_LIST_USER_TEXT_TOOLTIP"] = ""
L["NEVER_OFFERING_TEXT"] = "Never offering items"
L["NEVER_OFFERING_TEXT_TOOLTIP"] = "The items will not be added of the list of item tradeable."


  --Receiving Loot
L["RECEIVING_LOOT_OPTIONS_TEXT"] = "Receiving Loot Options"
L["ILVL_UPGRADE_TEXT"] = "Include all the item with an ilvl upgrade"
L["ILVL_UPGRADE_TOOLTIP"] = "Prompt me if the item is an upgrade or if the item is under (%s) ilvl of my equipped ilvl.|n|nThe value can be changed when enabling this option."
L["INCLUDE_BELOW_ITEM_LEVEL_POPUP_HELP"] = "Enter an item level:"
L["INCLUDE_ILVL_BELOW_TEXT"] = "Include the item if this ilvl is below of my equipped item:"

  --Transmog Frame
L["TRANSMOG_UNKNOWN_TITLE_TEXT"] = "Transmog unknown"
L["TRANSMOG_UNKNOWN_TEXT"] = "Unknown Transmog"
L["TRANSMOG_UNKNOWN_TOOLTIP"] = "Include the unknown transmog."
L["TRANSMOG_UNKNOWN_APPEARANCE_ONLY_TEXT"] = "Appearance Only"
L["TRANSMOG_UNKNOWN_APPEARANCE_ONLY_TOOLTIP"] = "Enable this option if you want to have only the appearance and you don't care of the percent on All The Thing addon. "
L["TRANSMOG_UNKNOWN_SHARED_APPEARANCE_TEXT"] = "All Appearance Sources "
L["TRANSMOG_UNKNOWN_SHARED_APPEARANCE_TOOLTIP"] = "Enable this option to collect every shared appearance of an item."
L["TRANSMOG_UNKNOWN_FOR_ALL_CLASS_TEXT"] = "All class"
L["TRANSMOG_UNKNOWN_FOR_ALL_CLASS_TOOLTIP"] = "Prompt me if I don't know the transmog on all class."
L["TRANSMOG_UNKNOWN_FOR_MY_CLASS_TEXT"] = "My class"
L["TRANSMOG_UNKNOWN_FOR_MY_CLASS_TOOLTIP"] = "Prompt me if I don't know the transmog for the item of my class."
L["TRANSMOG_UNKNOWN_FOR_MY_SPEC_TEXT"] = "My spec"
L["TRANSMOG_UNKNOWN_FOR_MY_SPEC_TOOLTIP"] = "Prompt me if I don't know the transmog for the item of my spec."

  --Whisper Frame
L["WHISPER_INTRODUCTION"] = "You have the possibility to send 3 different whispers. You write a succinct title (less than 10 characters). It will appear like \n   a button when the other players loot an item.\n   In the message to whisper, you can add the item you are requesting from another player by adding %item.\n     \"Hey, may I please have %item if you don't need it?\" will appear as :\n     \"Hey, may I please have |cffa335ee[Tusks of Mannoroth]|r if you don't need it?\" "
L["WHISPER_TEXT"] = "WHISPER "
L["TITLE_EDITBOX_1"] = "EN"
L["TITLE_EDITBOX_2"] = "FR"
L["TITLE_EDITBOX_3"] = "EN+"
L["WHISPER_EDITBOX_1"] = "Hey, may I please have %item if you don't need it?"
L["WHISPER_EDITBOX_2"] = "Est ce que je peux avoir %item si tu en as pas besoin?"
L["WHISPER_EDITBOX_3"] = "May I have also %item ?"
L["TITLE_WHISPER_INTRODUCTION"] = "Your title (less than 10 letters)"
L["TEXT_WHISPER_INTRODUCTION"] = "Message to Whisper"

--Text-Frame
L["SELECT_ALL"] = "Select All"
L["LEFT_CLICK"] = "Left-Click"
L["CLEAR"] = "Clear"
L["RIGHT_CLICK"] = "Right-Click"

--

-------------------------- File : Commands.lua ----------------------------------

L["COMMANDS"] = "Commands"
L["COMMAND_DESCRIPTION_HELP"] = "Display a list of commands."
L["COMMAND_DESCRIPTION_OPTIONS"] = "Toggle the options frame."
L["COMMAND_DESCRIPTION_LOOT_FRAME"] = "Toggle the loot frame."

-------------------------- File : Begging-interface.lua ----------------------------------

L["PASS"] = "PASS"
L["PASS_ALL"] = "Pass all"
L["MAY_TRADE"] = "may trade"
L["KEEP"] = "KEEP"
L["KEEP_ALL"] = "Keep all"
L["OFFER_ALL"] = "Offer all"
L["OFFER_ITEM"] = "Offer item"
L["CAN_OFFER_ITEM"] = "You can offer "
L["SOCKET"] = "Socket "
L["INDESTRUCTIBLE"] = "INDESTRUCTIBLE "
L["LEECH"] = "LEECH "
L["SPEED"] = "SPEED "
L["AVOIDANCE"] = "AVOIDANCE "
L["Whisper"] = "<BEG FOR LOOT> I don't need %item. Whisper me if you need it"
L["OFFER_ALL_ITEM"] = "<BEG FOR LOOT> Whisper me if you want :"

-- ============================================================================
-- Others
-- ============================================================================

if GetLocale() == "deDE" then
  
end

if GetLocale() == "esES" then
  
end

if GetLocale() == "esMX" then
  
end

if GetLocale() == "frFR" then
  
end

if GetLocale() == "itIT" then
  
end

if GetLocale() == "koKR" then
  
end

if GetLocale() == "ptBR" then
  
end

if GetLocale() == "ruRU" then
  L["ADD_ALL_TO_LIST"] = "Добавить все в %s"
L["ADD_TO_LIST"] = "Добавить в %s"
L["ALL_ITEMS_REMOVED_FROM_LIST"] = "Удалены все предметы из %s."
L["ALT_KEY"] = "Alt"
L["AUTO_JUNK_FRAME_TEXT"] = "Автоматическое окно для мусора"
L["AUTO_JUNK_FRAME_TOOLTIP"] = "Автоматически переключайте окно для мусора при взаимодействии с торговцем."
L["AUTO_REPAIR_TEXT"] = "Автоматический ремонт"
L["AUTO_REPAIR_TOOLTIP"] = "Автоматически ремонтировать при взаимодействии с торговцем."
L["AUTO_SELL_TEXT"] = "Автоматическая продажа"
L["AUTO_SELL_TOOLTIP"] = "Автоматически продавать товары при взаимодействии с торговцем."
L["BAG_ITEM_TOOLTIPS_TEXT"] = "Подсказки к предметам в сумке"
L["BAG_ITEM_TOOLTIPS_TOOLTIP"] = "Добавьте информацию о Dejunk во всплывающие подсказки к предметам в ваших сумках."
L["CANNOT_OPEN_LOOTABLE_ITEMS"] = "Не удается открыть полученные предметы прямо сейчас."
L["CANNOT_SELL_OR_DESTROY_ITEM"] = "Невозможно продать или удалить %s."
L["CANNOT_SELL_WITHOUT_MERCHANT"] = "Нельзя продавать предметы без торговца."
L["CHARACTER"] = "Персонаж"
L["CHARACTER_SPECIFIC_SETTINGS_TEXT"] = "Настройки персонажа"
L["CHARACTER_SPECIFIC_SETTINGS_TOOLTIP"] = "Включите настройки, специфичные для этого персонажа."
L["CHAT_MESSAGES_TEXT"] = "Сообщения чата"
L["CHAT_MESSAGES_TOOLTIP"] = "Включить сообщения чата."
L["CLEAR"] = "Очистить"
L["CLEAR_SEARCH"] = "Очистить поиск"
L["COMMAND_DESCRIPTION_DESTROY"] = "Удалить следующий мусор."
L["COMMAND_DESCRIPTION_HELP"] = "Показать список команд."
L["COMMAND_DESCRIPTION_JUNK"] = "Включите окно с мусором."
L["COMMAND_DESCRIPTION_KEYBINDS"] = "Откройте окно для привязки ключей."
L["COMMAND_DESCRIPTION_LOOT"] = "Открывать полученные предметы."
L["COMMAND_DESCRIPTION_OPTIONS"] = "Переключите окно параметров."
L["COMMAND_DESCRIPTION_SELL"] = "Начните продавать ненужные вещи."
L["COMMAND_DESCRIPTION_TRANSPORT"] = "Включить окно переноса."
L["COMMANDS"] = "Команды"
L["CONTROL_KEY"] = "Ctrl"
L["DESTROY"] = "Удалить"
L["DESTROY_NEXT_ITEM"] = "Удалить следующий предмет"
L["DESTROYED_ITEM"] = "Удалено: %s."
L["EXCLUDE_EQUIPMENT_SETS_TEXT"] = "Исключить сетовую экипировку"
L["EXCLUDE_EQUIPMENT_SETS_TOOLTIP"] = "Исключите экипировку, которая сохраняется в сетовом наборе."
L["EXCLUDE_UNBOUND_EQUIPMENT_TEXT"] = "Исключить не персональные предметы"
L["EXCLUDE_UNBOUND_EQUIPMENT_TOOLTIP"] = "Исключите предметы, которое не персональные."
L["EXCLUSIONS_DESCRIPTION_GLOBAL"] = "Предметы в этом списке не будут считаться мусором, если не включены в %s."
L["EXCLUSIONS_DESCRIPTION_PERCHAR"] = "Предметы в этом списке никогда не будут считаться мусором."
L["EXCLUSIONS_TEXT"] = "Исключение"
L["EXPORT"] = "Экспорт"
L["FAILED_TO_DESTROY_ITEM"] = "Не удалось удалить %s."
L["FAILED_TO_SELL_ITEM"] = "Не удалось продать %s."
L["GENERAL"] = "Общие"
L["GLOBAL"] = "Общие"
L["IMPORT"] = "Импорт"
L["INCLUDE_ARTIFACT_RELICS_TEXT"] = "Реликвии артефактов"
L["INCLUDE_ARTIFACT_RELICS_TOOLTIP"] = "Включите камни для реликвий."
L["INCLUDE_BELOW_ITEM_LEVEL_POPUP_HELP"] = "Введите уровень предмета:"
L["INCLUDE_BELOW_ITEM_LEVEL_TEXT"] = "Ниже определённого уровня"
L["INCLUDE_BELOW_ITEM_LEVEL_TOOLTIP"] = "Включить персональное снаряжение с уровнем предмета ниже заданного значения (%s).|n|nЗначение можно изменить при включении этой опции.|n|nНе распространяется на обычные предметы, косметические предметы и удочки."
L["INCLUDE_POOR_ITEMS_TEXT"] = "Предметы низкого качества"
L["INCLUDE_POOR_ITEMS_TOOLTIP"] = "Включить предметы низкого качества."
L["INCLUDE_UNSUITABLE_EQUIPMENT_TEXT"] = "Неподходящая экипировка"
L["INCLUDE_UNSUITABLE_EQUIPMENT_TOOLTIP"] = "Включить персональную экипировку с доспехами или типом оружия, которые не подходят для вашего класса.|n|nНе применяется к обычным предметам, косметическим предметам или удочкам."
L["INCLUSIONS_DESCRIPTION_GLOBAL"] = "Элементы в этом списке будут считаться мусором, если они не исключены в %s."
L["INCLUSIONS_DESCRIPTION_PERCHAR"] = "Предметы в этом списке всегда будут считаться мусором."
L["INCLUSIONS_TEXT"] = "Правило"
L["IS_BUSY_CONFIRMING_ITEMS"] = "Подтверждение предметов..."
L["IS_BUSY_SELLING_ITEMS"] = "Продажа предметов..."
L["IS_BUSY_UPDATING_LISTS"] = "Обновление списков..."
L["ITEM_ADDED_TO_LIST"] = "%s добавлено к %s."
L["ITEM_ALREADY_ON_LIST"] = "%s уже на %s."
L["ITEM_ID_DOES_NOT_EXIST"] = "Предмет с ID %s не существует."
L["ITEM_ID_FAILED_TO_PARSE"] = "Предмет с ID %s не удалось проанализировать, и он может не существовать."
L["ITEM_IDS"] = "ID предмета"
L["ITEM_IS_JUNK"] = "Этот предмет является мусором."
L["ITEM_IS_LOCKED"] = "Предмет заблокирован."
L["ITEM_IS_NOT_JUNK"] = "Этот предмет не мусор."
L["ITEM_IS_REFUNDABLE"] = "Товар подлежит возврату."
L["ITEM_NOT_ON_LIST"] = "%s не находится на %s."
L["ITEM_REMOVED_FROM_LIST"] = "%s удален из %s."
L["JUNK_FRAME_TOOLTIP"] = "Ненужные предметы, которыми вы владеете в данный момент, будут перечислены в этом окне.|n|nЧтобы добавить предмет в %s, перетащите его в окно ниже.|n|nЧтобы добавить предмет в %s, удерживайте %s и поместите его в окно ниже."
L["JUNK_ITEMS"] = "Мусор"
L["KEYBINDS"] = "Назначение клавиш"
L["LEFT_CLICK"] = "ЛКМ"
L["LIST_FRAME_TOOLTIP"] = "Чтобы добавить предмет, перетащите его в окно ниже."
L["LIST_FRAME_TRANSPORT_BUTTON_TOOLTIP"] = "Переключите окно переноса для этого списка."
L["LISTS"] = "Списки"
L["MAY_NOT_HAVE_DESTROYED_ITEM"] = "Возможно, не удалено %s."
L["MAY_NOT_HAVE_SOLD_ITEM"] = "Возможно, не продано %s."
L["MERCHANT_BUTTON_TEXT"] = "Кнопка торговца"
L["MERCHANT_BUTTON_TOOLTIP"] = "Включите кнопку в окне торговца."
L["MINIMAP_ICON_TEXT"] = "Значок миникарты"
L["MINIMAP_ICON_TOOLTIP"] = "Включить значок на миникарте."
L["NO_FILTERS_MATCHED"] = "Нет подходящих фильтров."
L["NO_ITEMS"] = "Нет предметов."
L["NO_JUNK_ITEMS_TO_DESTROY"] = "Нет ненужных предметов, которые можно удалить."
L["NO_JUNK_ITEMS_TO_SELL"] = "Нет ненужных предметов для продажи."
L["NO_LOOTABLE_ITEMS_TO_OPEN"] = "Нет предметов, которые можно открыть."
L["OPEN_LOOTABLE_ITEMS"] = "Открыть предметы из добычи"
L["OPTIONS_TEXT"] = "Настройки"
L["PROFIT"] = "Прибыль: %s"
L["REMOVE"] = "Удалить"
L["REMOVE_ALL_ITEMS"] = "Удалить все предметы"
L["REMOVE_FROM_LIST"] = "Удалить из %s"
L["REPAIRED_ALL_ITEMS"] = "Отремонтированы все предметы для %s."
L["RIGHT_CLICK"] = "ПКМ"
L["SAFE_MODE_TEXT"] = "Безопасный режим"
L["SAFE_MODE_TOOLTIP"] = "Продавайте не более 12 предметов за раз."
L["SEARCH_LISTS"] = "Списки поиска"
L["SELECT_ALL"] = "Выбрать все"
L["SELL"] = "Продавать"
L["SHIFT_KEY"] = "Shift"
L["SOLD_ITEM"] = "Продано: %s."
L["START_SELLING"] = "Начать продажу"
L["TOGGLE_JUNK_FRAME"] = "Открыть окно с мусором"
L["TOGGLE_OPTIONS_FRAME"] = "Открыть настройки"
L["TRANSPORT"] = "Перенос"
L["TRANSPORT_FRAME_TOOLTIP"] = "Используйте это окно для переноса ID предметов в список или из него.|n|nПри импорте ID предметов должны быть разделены нечисловым символом (например, 4983,58907,67410)."

end

if GetLocale() == "zhCN" then
  L["ADD_ALL_TO_LIST"] = "全部添加至%s"
L["ADD_TO_LIST"] = "添加到%s"
L["ALL_ITEMS_REMOVED_FROM_LIST"] = "已从%s中移除所有物品。"
L["ALT_KEY"] = "Alt键"
L["AUTO_JUNK_FRAME_TEXT"] = "自动显示垃圾物品框架"
L["AUTO_JUNK_FRAME_TOOLTIP"] = "与商贩交互时自动切换垃圾框架"
L["AUTO_REPAIR_TEXT"] = "自动修理"
L["AUTO_REPAIR_TOOLTIP"] = "和商贩交互时自动修理物品。"
L["AUTO_SELL_TEXT"] = "自动出售"
L["AUTO_SELL_TOOLTIP"] = "与商人交互时自动售卖物品。"
L["BAG_ITEM_TOOLTIPS_TEXT"] = "背包物品鼠标提示"
L["BAG_ITEM_TOOLTIPS_TOOLTIP"] = "给你背包里物品的鼠标提示中添加Dejunk信息。"
L["CANNOT_OPEN_LOOTABLE_ITEMS"] = "现在无法打开可开启的物品。"
L["CANNOT_SELL_OR_DESTROY_ITEM"] = "无法出售或摧毁%s。"
L["CANNOT_SELL_WITHOUT_MERCHANT"] = "没有商人，无法出售物品。"
L["CHARACTER"] = "角色"
L["CHARACTER_SPECIFIC_SETTINGS_TEXT"] = "角色专属设置"
L["CHARACTER_SPECIFIC_SETTINGS_TOOLTIP"] = "给此角色开启专属设置。"
L["CHAT_MESSAGES_TEXT"] = "聊天信息"
L["CHAT_MESSAGES_TOOLTIP"] = "开启聊天信息。"
L["CLEAR"] = "清除"
L["COMMAND_DESCRIPTION_DESTROY"] = "摧毁下一件物品。"
L["COMMAND_DESCRIPTION_HELP"] = "显示指令列表。"
L["COMMAND_DESCRIPTION_JUNK"] = "切换垃圾物品框架。"
L["COMMAND_DESCRIPTION_KEYBINDS"] = "打开按键绑定框架。"
L["COMMAND_DESCRIPTION_LOOT"] = "打开可开启的物品。"
L["COMMAND_DESCRIPTION_OPTIONS"] = "切换选项框架。"
L["COMMAND_DESCRIPTION_SELL"] = "开始出售垃圾物品。"
L["COMMAND_DESCRIPTION_TRANSPORT"] = "切换传输框架。"
L["COMMANDS"] = "指令"
L["CONTROL_KEY"] = "Ctrl键"
L["DESTROY"] = "摧毁"
L["DESTROY_NEXT_ITEM"] = "摧毁下一个物品"
L["DESTROYED_ITEM"] = "已摧毁：%s。"
L["EXCLUDE_EQUIPMENT_SETS_TEXT"] = "排除装备方案"
L["EXCLUDE_EQUIPMENT_SETS_TOOLTIP"] = "排除已经保存到某个方案的装备。"
L["EXCLUDE_UNBOUND_EQUIPMENT_TEXT"] = "排除未绑定装备"
L["EXCLUDE_UNBOUND_EQUIPMENT_TOOLTIP"] = "排除未绑定装备"
L["EXCLUSIONS_DESCRIPTION_GLOBAL"] = "本列表上的物品不会被当做垃圾，除非被%s包含。"
L["EXCLUSIONS_DESCRIPTION_PERCHAR"] = "此列表上的物品绝不会被当做垃圾。"
L["EXCLUSIONS_TEXT"] = "排除"
L["EXPORT"] = "导出"
L["FAILED_TO_DESTROY_ITEM"] = "摧毁%s失败。"
L["FAILED_TO_SELL_ITEM"] = "出售%s失败。"
L["GENERAL"] = "通用"
L["GLOBAL"] = "全局"
L["IMPORT"] = "导入"
L["INCLUDE_ARTIFACT_RELICS_TEXT"] = "包含神器圣物"
L["INCLUDE_ARTIFACT_RELICS_TOOLTIP"] = "包含神器圣物。"
L["INCLUDE_BELOW_ITEM_LEVEL_POPUP_HELP"] = "输入物品等级："
L["INCLUDE_BELOW_ITEM_LEVEL_TEXT"] = "包含低于物品等级"
L["INCLUDE_BELOW_ITEM_LEVEL_TOOLTIP"] = "包含物品等级低于设定值（%s）的灵魂绑定装备。|n|n开启此选项时可以修改设定值。|n|n对通用物品，装饰品和鱼竿不生效。"
L["INCLUDE_POOR_ITEMS_TEXT"] = "包括粗糙品质物品"
L["INCLUDE_POOR_ITEMS_TOOLTIP"] = "在出售或摧毁时包括粗糙品质的物品。"
L["INCLUDE_UNSUITABLE_EQUIPMENT_TEXT"] = "包含不可用装备"
L["INCLUDE_UNSUITABLE_EQUIPMENT_TOOLTIP"] = "包含护甲或武器类型对你的职业不适用的灵魂绑定物品。|n|n对通用物品，装饰品，或鱼竿不生效。"
L["INCLUSIONS_DESCRIPTION_GLOBAL"] = "此列表上的物品会被当做垃圾，除非被%s排除。"
L["INCLUSIONS_DESCRIPTION_PERCHAR"] = "此列表上的物品总是会被当做垃圾。"
L["INCLUSIONS_TEXT"] = "包含"
L["IS_BUSY_CONFIRMING_ITEMS"] = "确认物品中..."
L["IS_BUSY_SELLING_ITEMS"] = "出售物品中..."
L["IS_BUSY_UPDATING_LISTS"] = "更新列表中..."
L["ITEM_ADDED_TO_LIST"] = "已添加%s至%s。"
L["ITEM_ALREADY_ON_LIST"] = "\"%s已经存在于%s。"
L["ITEM_ID_DOES_NOT_EXIST"] = "ID为%s的物品不存在。"
L["ITEM_ID_FAILED_TO_PARSE"] = "ID为%s的物品无法解析，可能不存在。"
L["ITEM_IDS"] = "物品ID"
L["ITEM_IS_JUNK"] = "此物品是垃圾。"
L["ITEM_IS_LOCKED"] = "此物品被锁定。"
L["ITEM_IS_NOT_JUNK"] = "此物品不是垃圾。"
L["ITEM_IS_REFUNDABLE"] = "此物品可退款。"
L["ITEM_NOT_ON_LIST"] = "%s不存在于%s。"
L["ITEM_REMOVED_FROM_LIST"] = "%s已从%s上移除。"
L["JUNK_FRAME_TOOLTIP"] = "你当前拥有的垃圾物品会被列在这个框架中。|n|n 若想要添加一个物品到%s中，拖动它到下方框架中。|n|n 若想要添加一个物品到%s中，按住%s并且拖动物品到下方框架中。"
L["JUNK_ITEMS"] = "垃圾物品"
L["KEYBINDS"] = "按键绑定"
L["LEFT_CLICK"] = "点击左键"
L["LIST_FRAME_TOOLTIP"] = "若要添加物品，拖放其到下方框架。"
L["LIST_FRAME_TRANSPORT_BUTTON_TOOLTIP"] = "切换此列表的传输框架。"
L["LISTS"] = "列表"
L["MAY_NOT_HAVE_DESTROYED_ITEM"] = "可能没有摧毁%s。"
L["MAY_NOT_HAVE_SOLD_ITEM"] = "可能没有出售%s。"
L["MERCHANT_BUTTON_TEXT"] = "商人按钮"
L["MERCHANT_BUTTON_TOOLTIP"] = "在商人框架上启用按钮。"
L["MINIMAP_ICON_TEXT"] = "小地图图标"
L["MINIMAP_ICON_TOOLTIP"] = "开启小地图图标。"
L["NO_FILTERS_MATCHED"] = "无过滤器可匹配。"
L["NO_ITEMS"] = "没有物品。"
L["NO_JUNK_ITEMS_TO_DESTROY"] = "没有垃圾物品可摧毁。"
L["NO_JUNK_ITEMS_TO_SELL"] = "没有垃圾物品可出售。"
L["NO_LOOTABLE_ITEMS_TO_OPEN"] = "没有可开启的物品。"
L["OPEN_LOOTABLE_ITEMS"] = "打开可开启物品"
L["OPTIONS_TEXT"] = "选项"
L["PROFIT"] = "获利：%s"
L["REMOVE"] = "移除"
L["REMOVE_ALL_ITEMS"] = "移除所有物品"
L["REMOVE_FROM_LIST"] = "从%s移除"
L["REPAIRED_ALL_ITEMS"] = "已修理所有物品，共计%s。"
L["RIGHT_CLICK"] = "点击右键"
L["SAFE_MODE_TEXT"] = "安全模式"
L["SAFE_MODE_TOOLTIP"] = "一次最多出售12个物品。"
L["SELECT_ALL"] = "选择所有"
L["SELL"] = "出售"
L["SHIFT_KEY"] = "Shift键"
L["SOLD_ITEM"] = "已出售：%s。"
L["START_SELLING"] = "开始出售"
L["TOGGLE_JUNK_FRAME"] = "切换垃圾物品框架"
L["TOGGLE_OPTIONS_FRAME"] = "切换选项框架"
L["TRANSPORT"] = "传输"

end

if GetLocale() == "zhTW" then
  L["ALL_ITEMS_REMOVED_FROM_LIST"] = "清空 %s 內所有物品。"
L["AUTO_REPAIR_TEXT"] = "自動修裝"
L["AUTO_REPAIR_TOOLTIP"] = "開啟商人交易介面時自動修理裝備"
L["AUTO_SELL_TEXT"] = "自動出售"
L["BAG_ITEM_TOOLTIPS_TEXT"] = "增加Dejunk提示"
L["BAG_ITEM_TOOLTIPS_TOOLTIP"] = "在背包物品提示中增加Dejunk提示"
L["CANNOT_OPEN_LOOTABLE_ITEMS"] = "目前無法開啟拾取清單"
L["CANNOT_SELL_OR_DESTROY_ITEM"] = "無法出售或丟棄 %s"
L["CANNOT_SELL_WITHOUT_MERCHANT"] = "沒有可以售出物品的商人"
L["CHARACTER_SPECIFIC_SETTINGS_TEXT"] = "角色個人化設定"
L["CHARACTER_SPECIFIC_SETTINGS_TOOLTIP"] = "對此角色啟用個人化設定"
L["CHAT_MESSAGES_TEXT"] = "對話框訊息"
L["CHAT_MESSAGES_TOOLTIP"] = "啟用對話框訊息提示"
L["COMMAND_DESCRIPTION_DESTROY"] = "丟棄下一項垃圾物品"
L["COMMAND_DESCRIPTION_HELP"] = "顯示操作指令清單"
L["COMMAND_DESCRIPTION_JUNK"] = "切換垃圾物品邊框標示"
L["COMMAND_DESCRIPTION_OPTIONS"] = "開啟設定介面"
L["COMMAND_DESCRIPTION_SELL"] = "執行垃圾物品出售"
L["COMMANDS"] = "指令"
L["DESTROY_NEXT_ITEM"] = "丟棄下一項物品"
L["DESTROYED_ITEM"] = "已丟棄： %s"
L["EXCLUSIONS_TEXT"] = "排除"
L["EXPORT"] = "匯出"
L["FAILED_TO_DESTROY_ITEM"] = "無發丟棄 %s"
L["FAILED_TO_SELL_ITEM"] = "無發出售 %s"
L["GENERAL"] = "一般"
L["IMPORT"] = "匯入"
L["INCLUDE_POOR_ITEMS_TEXT"] = "包含低階物品"
L["INCLUDE_POOR_ITEMS_TOOLTIP"] = "售出或丟棄時同時處裡低階物品"
L["INCLUDE_UNSUITABLE_EQUIPMENT_TEXT"] = "包括不合適的設備"
L["INCLUDE_UNSUITABLE_EQUIPMENT_TOOLTIP"] = "包括帶有不適合你的職業的盔甲或武器類型的靈魂綁定裝備。|n|n不適用於普通物品、裝飾物品或釣魚竿。"
L["INCLUSIONS_TEXT"] = "包含"
L["IS_BUSY_CONFIRMING_ITEMS"] = "確認物品中..."
L["IS_BUSY_SELLING_ITEMS"] = "售出物品中"
L["IS_BUSY_UPDATING_LISTS"] = "更新清單"
L["ITEM_ADDED_TO_LIST"] = "將 %s 增加到 %s"
L["ITEM_ALREADY_ON_LIST"] = "%s 已存在於 %s 中"
L["ITEM_ID_DOES_NOT_EXIST"] = "此ID物品 %s 不存在"
L["ITEM_ID_FAILED_TO_PARSE"] = "此ID物品 %s 無法識別或是不存在"
L["ITEM_IDS"] = "物品ID"
L["ITEM_IS_JUNK"] = "這是件垃圾物品"
L["ITEM_IS_LOCKED"] = "物品已上鎖"
L["ITEM_IS_NOT_JUNK"] = "此非垃圾物品"
L["ITEM_IS_REFUNDABLE"] = "此為可退還物品"
L["ITEM_NOT_ON_LIST"] = "%s 未存在於 %s 中"
L["ITEM_REMOVED_FROM_LIST"] = "將 %s 從 %s 中移除"
L["JUNK_ITEMS"] = "垃圾物品"
L["KEYBINDS"] = "按鍵綁定"
L["LEFT_CLICK"] = "左鍵點擊"
L["LISTS"] = "清單"
L["MAY_NOT_HAVE_DESTROYED_ITEM"] = "未能丟棄 %s"
L["MAY_NOT_HAVE_SOLD_ITEM"] = "未能出售 %s"
L["MERCHANT_BUTTON_TEXT"] = "交易介面按鈕"
L["MERCHANT_BUTTON_TOOLTIP"] = "在交易介面按鈕增加按鈕"
L["MINIMAP_ICON_TEXT"] = "小地圖圖示"
L["MINIMAP_ICON_TOOLTIP"] = "在小地圖旁顯示圖示"
L["NO_FILTERS_MATCHED"] = "沒有可用的過濾清單"
L["NO_ITEMS"] = "沒有物品"
L["NO_JUNK_ITEMS_TO_DESTROY"] = "沒有需要丟棄的垃圾物品"
L["NO_JUNK_ITEMS_TO_SELL"] = "沒有需要出售的垃圾物品"
L["NO_LOOTABLE_ITEMS_TO_OPEN"] = "沒有可拾取物"
L["OPEN_LOOTABLE_ITEMS"] = "開啟可拾取物介面"
L["OPTIONS_TEXT"] = "選項"
L["PROFIT"] = "利潤：%s"
L["REMOVE_ALL_ITEMS"] = "移除所有物品"
L["REPAIRED_ALL_ITEMS"] = "已花費 %s 修復全物品"
L["RIGHT_CLICK"] = "右鍵點擊"
L["SAFE_MODE_TEXT"] = "安全模式"
L["SAFE_MODE_TOOLTIP"] = "單次交易只售出12項物品"
L["SELECT_ALL"] = "選擇全部"
L["SOLD_ITEM"] = "出售：%s"
L["START_SELLING"] = "開始出售"

end
