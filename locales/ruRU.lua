local L = LibStub("AceLocale-3.0"):NewLocale("AutoSellerLocales", "ruRU") 
if not L then return end 

L["STRING_AHPRICE"] = "Цена аукциона"
L["STRING_AHPRICE_DESC"] = [=[Предметы с аукциона стоимостью |cFFFFFF00ниже этого|r будут проданы.

Правый щелчок, чтобы ввести значение.]=]
L["STRING_AHPRICEBUTTONTEXT"] = "Аук цены"
L["STRING_AHPRICEPANELTITLE"] = "Цены аукциона"
L["STRING_AUTOOPEN"] = "Авто открытие"
L["STRING_AUTOOPEN_DESC"] = "Авто открытие этого окна при открытии торгового окна."
L["STRING_AUTOREPAIR"] = "Авто ремонт"
L["STRING_AUTOREPAIR_BANK"] = "Использовать банк гильдии"
L["STRING_AUTOREPAIR_DESC"] = "Автоматический ремонт вашего снаряжения при открытии продавца способного на ремонт."
L["STRING_AUTOSELLBUTTONTEXT"] = "Авто продажа"
L["STRING_CANTSELL"] = "Торговый магазин не открыт. Поговорите с любым продавцом НИПом, чтобы открыть."
L["STRING_IGNORE_DESC1"] = [=[Добавить предметы в чёрный список

Уже проигнорировано:]=]
L["STRING_IGNORE_DESC2"] = "Ключевые слова:"
L["STRING_IGNORE_ENTERKEYWORD"] = "Введите ключевое слово"
L["STRING_IGNORE_ENTERKEYWORD_DESC"] = "Предметы, содержащие это слово на его названии, не будут продаваться."
L["STRING_IGNORE_ITEMADDED"] = "добавлен в список игнорирования."
L["STRING_IGNORE_ITEMREMOVED"] = "удален из списка игнорируемых."
L["STRING_IGNORE_KEYWORDADDED"] = "добавлен в список игнорирования ключевых слов."
L["STRING_IGNORE_KEYWORDREMOVED"] = "удален из списка ключевых слов."
L["STRING_IGNOREADDBUTTONTEXT"] = "Добавить"
L["STRING_IGNOREBUTTONTEXT"] = "Список игнорирования"
L["STRING_IGNOREENTRYTEXT"] = "Введите имя предмета"
L["STRING_IGNOREENTRYTEXT_DESC"] = "Вы можете связать предмет непосредственно из рюкзака с помощью |cFFFFFF00SHIFT|r кнопки"
L["STRING_IGNOREPANELTITLE"] = "Игнорировать предметы"
L["STRING_ITEMLEVEL"] = "Уровень предметов"
L["STRING_ITEMLEVEL_DESC1"] = "Предметы с уровнем предметов |cFFFFFF00выше чем|r, это будут продаваться."
L["STRING_ITEMLEVEL_DESC2"] = "Предметы с уровнем предметов |cFFFFFF00превосходящий|r к этому, не будут проданы."
L["STRING_ITEMLEVEL_INVERTBUTTONTEXT"] = "При инвертировании, продает предметы '|cFFFFFF00выше|r', вместо '|cFFFFFF00ниже|r'."
L["STRING_PANEL_NOITEMTOSHOW"] = "Нет предмета для показа."
L["STRING_SELLBLUE"] = "Продавать синие снаряжение"
L["STRING_SELLBLUE_DESC"] = "Продажа синего снаряжения, не персонального и не могу быть связаны с другими фильтрами."
L["STRING_SELLBUTTON_DESC1"] = "Добавление предметов в список авто продажи.\\n\\nУже в авто продаже:\\n"
L["STRING_SELLBUTTONTEXT"] = "Продажа предметов"
L["STRING_SELLEPIC"] = "Продавать превосходное снаряжение низкого уровня"
L["STRING_SELLGRAY"] = "Авто продажа серого"
L["STRING_SELLGRAY_DESC"] = "Авто продажа всех нежелательных (серых) предметов в рюкзаке, после открытия торгового окна."
L["STRING_SELLGREEN"] = "Продажа зелёного снаряжения"
L["STRING_SELLGREEN_DESC"] = "Продажа зеленого снаряжения, не персонального и не могу быть связаны с другими фильтрами."
--[[Translation missing --]]
--[[ L["STRING_SELLLOWEPIC_DESC"] = ""--]] 
L["STRING_SELLPANEL_ADDBUTTON"] = "Добавить"
L["STRING_SELLPANEL_ITEMADDED"] = "Предмет был добавлен в список авто продаж. Вы можете удалить его с помощью кнопки X в правой части текстового поля."
L["STRING_SELLPANEL_ITEMNAME"] = "Название предмета"
L["STRING_SELLPANEL_ITEMREMOVED"] = "удален из Вашего списка авто продаж."
L["STRING_SELLPANELTITLE"] = "Авто список продаж"
L["STRING_SELLSOULBOUND"] = "Продавать персональное снаряжение"
L["STRING_SELLSOULBOUND_DESC"] = [=[Продавать персональные снаряжения (соблюдая набор фильтров ниже).

|cFFFFFF00Важно:|r убедитесь, что убрали ВАЖНЫЕ предметы из вашего рюкзака, а также выполните тест на продажу, чтобы проверить, продаются ли какие-либо важные предметы.

|cFFFFFF00Важно:|r При выходе из игрового мира этот параметр возвращается к значению по умолчанию (в отключено).]=]
L["STRING_TOTALSOLD"] = "Всего продано"
L["STRING_TRANSMOGBUTTONTEXT"] = "Трансмогрификация"
L["STRING_TRANSMOGPANEL_CANTSELL"] = "Не удается продать превосходные предметы через эту панель."
L["STRING_TRANSMOGPANELTITLE"] = "Панель трансмогрификации"
L["STRING_VENDORGOLD"] = "Золото продавца"
L["STRING_VENDORGOLD_DESC"] = "Предметы со стоимостью продавца (в золоте) |cFFFFFF00больше, чем|r это, будет продаваться в любом случае игнорируя уровень предметов."

