local L = LibStub("AceLocale-3.0"):NewLocale("AutoSellerLocales", "zhTW") 
if not L then return end 

L["STRING_AHPRICE"] = "拍賣價格"
L["STRING_AHPRICE_DESC"] = "拍賣價格|cFFFFFF00低於|r此的物品，將被出售。"
L["STRING_AHPRICEBUTTONTEXT"] = "拍賣場價格"
L["STRING_AHPRICEPANELTITLE"] = "拍賣場價格"
L["STRING_AUTOOPEN"] = "自動開啟"
L["STRING_AUTOOPEN_DESC"] = "當開啟商店視窗時自動開啟插件視窗。"
L["STRING_AUTOREPAIR"] = "自動修理"
L["STRING_AUTOREPAIR_BANK"] = "使用公會資金"
L["STRING_AUTOREPAIR_DESC"] = "當開啟可修理的商店時自動修理你的裝備。"
L["STRING_AUTOSELLBUTTONTEXT"] = "自動出售"
L["STRING_CANTSELL"] = "商店未開啟，與任何商店NPC交談來開啟。"
L["STRING_IGNORE_DESC1"] = [=[增加物品到黑名單。

已經忽略：]=]
L["STRING_IGNORE_DESC2"] = [=[

關鍵字：]=]
L["STRING_IGNORE_ENTERKEYWORD"] = "輸入一個關鍵字"
L["STRING_IGNORE_ENTERKEYWORD_DESC"] = "物品名稱包含此字眼不會被出售。"
L["STRING_IGNORE_ITEMADDED"] = "增加到忽略清單。"
L["STRING_IGNORE_ITEMREMOVED"] = "從忽略清單移除。"
L["STRING_IGNORE_KEYWORDADDED"] = "增加到關鍵字忽略清單。"
L["STRING_IGNORE_KEYWORDREMOVED"] = "從關鍵字清單移除。"
L["STRING_IGNOREADDBUTTONTEXT"] = "增加"
L["STRING_IGNOREBUTTONTEXT"] = "忽略清單"
L["STRING_IGNOREENTRYTEXT"] = "輸入物品名稱"
L["STRING_IGNOREENTRYTEXT_DESC"] = "你也可以使用|cFFFFFF00SHIFT|r鍵直接從背包中連結物品。"
L["STRING_IGNOREPANELTITLE"] = "忽略物品"
L["STRING_ITEMLEVEL"] = "物品等級"
L["STRING_ITEMLEVEL_DESC1"] = "物品的等級|cFFFFFF00高過|r此，將會出售。"
L["STRING_ITEMLEVEL_DESC2"] = "物品的等級|cFFFFFF00勝過|r此，將不會出售。"
L["STRING_ITEMLEVEL_INVERTBUTTONTEXT"] = "當反轉後，出售物品的條件由|cFFFFFF00高過|r取代|cFFFFFF00低於|r。"
L["STRING_PANEL_NOITEMTOSHOW"] = "沒有物品可顯示。"
L["STRING_SELLBLUE"] = "出售藍色裝備"
L["STRING_SELLBLUE_DESC"] = "出售藍色裝備，非靈魂綁定且不屬於其他過濾條件。"
L["STRING_SELLBUTTON_DESC1"] = "增加物品到自動出售清單。\\n\\n已經自動出售：\\n"
L["STRING_SELLBUTTONTEXT"] = "出售物品"
L["STRING_SELLEPIC"] = "出售低等級史詩裝備"
L["STRING_SELLGRAY"] = "自動出售灰色物品"
L["STRING_SELLGRAY_DESC"] = "自動出售背包中所有垃圾(灰色)物品在開啟商店視窗時。"
L["STRING_SELLGREEN"] = "出售綠色裝備"
L["STRING_SELLGREEN_DESC"] = "出售綠色裝備，非靈魂綁定並且不符合其他過濾條件。"
--[[Translation missing --]]
--[[ L["STRING_SELLLOWEPIC_DESC"] = ""--]] 
L["STRING_SELLPANEL_ADDBUTTON"] = "增加"
L["STRING_SELLPANEL_ITEMADDED"] = "物品已經加入自動出售清單。你可以藉由此文字右側的X按鈕來移除。"
L["STRING_SELLPANEL_ITEMNAME"] = "物品名稱"
L["STRING_SELLPANEL_ITEMREMOVED"] = "從你的自動出售清單移除。"
L["STRING_SELLPANELTITLE"] = "自動出售清單"
L["STRING_SELLSOULBOUND"] = "出售靈魂綁定裝備"
L["STRING_SELLSOULBOUND_DESC"] = [=[出售靈魂綁定裝備(遵從以下過濾原則)。

|cFFFFFF00重要：|r確保先從背包中移除重要物品並且執行出售測試，看看是否有任何重要物品被誤賣。

|cFFFFFF00重要：|r當你登出後，此選項將回復預設值(關閉)。]=]
L["STRING_TOTALSOLD"] = "總共售出"
L["STRING_TRANSMOGBUTTONTEXT"] = "塑形"
L["STRING_TRANSMOGPANEL_CANTSELL"] = "無法經由此面板出售史詩物品。"
L["STRING_TRANSMOGPANELTITLE"] = "塑形面板"
L["STRING_VENDORGOLD"] = "商店價格"
L["STRING_VENDORGOLD_DESC"] = "物品的商店價格(以金計)|cFFFFFF00優於|r此，無論如何將被出售並且忽略物品等級。"

