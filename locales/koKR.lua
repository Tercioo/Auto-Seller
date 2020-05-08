local L = LibStub("AceLocale-3.0"):NewLocale("AutoSellerLocales", "koKR") 
if not L then return end 

L["STRING_AHPRICE"] = "경매 가격"
L["STRING_AHPRICE_DESC"] = [=[이 값보다 경매가가 |cFFFFFF00더 낮은|r 아이템을 판매합니다.

값을 입력하려면 오른쪽 클릭하세요.]=]
L["STRING_AHPRICEBUTTONTEXT"] = "AH 가격"
L["STRING_AHPRICEPANELTITLE"] = "경매장 가격"
L["STRING_AUTOOPEN"] = "자동 열기"
L["STRING_AUTOOPEN_DESC"] = "상인 창이 열리면 이 창을 자동으로 엽니다."
L["STRING_AUTOREPAIR"] = "자동 수리"
L["STRING_AUTOREPAIR_BANK"] = "길드 은행 사용"
L["STRING_AUTOREPAIR_DESC"] = "수리 가능한 상인 창이 열리면 장비를 자동으로 수리합니다."
L["STRING_AUTOSELLBUTTONTEXT"] = "자동 판매"
L["STRING_CANTSELL"] = "상점이 열려 있지 않습니다. 상인 Npc와 대화하세요."
L["STRING_IGNORE_DESC1"] = [=[차단 목록에 아이템을 추가합니다.

이미 차단됨:
]=]
L["STRING_IGNORE_DESC2"] = [=[

키워드:
]=]
L["STRING_IGNORE_ENTERKEYWORD"] = "키워드 입력"
L["STRING_IGNORE_ENTERKEYWORD_DESC"] = "아이템 이름에 이 단어가 포함되어 있으면 판매하지 않습니다."
L["STRING_IGNORE_ITEMADDED"] = "아이템이 무시 목록에 추가되었습니다."
L["STRING_IGNORE_ITEMREMOVED"] = "아이템이 무시 목록에서 제거되었습니다."
L["STRING_IGNORE_KEYWORDADDED"] = "|1이;가; 키워드 무시 목록에 추가되었습니다."
L["STRING_IGNORE_KEYWORDREMOVED"] = "|1이;가; 키워드 목록에서 제거되었습니다."
L["STRING_IGNOREADDBUTTONTEXT"] = "추가"
L["STRING_IGNOREBUTTONTEXT"] = "무시 목록"
L["STRING_IGNOREENTRYTEXT"] = "아이템 이름 입력"
L["STRING_IGNOREENTRYTEXT_DESC"] = "|cFFFFFF00SHIFT|r 키를 사용해 소지품에 있는 아이템을 직접 링크해야 합니다."
L["STRING_IGNOREPANELTITLE"] = "아이템 무시"
L["STRING_ITEMLEVEL"] = "아이템 레벨"
L["STRING_ITEMLEVEL_DESC1"] = "이 값보다 |cFFFFFF00더 높은|r 아이템 레벨의 아이템을 판매합니다."
L["STRING_ITEMLEVEL_DESC2"] = "이 값보다 |cFFFFFF00더 낮은|r 아이템 레벨의 아이템을 판매합니다."
L["STRING_ITEMLEVEL_INVERTBUTTONTEXT"] = "전환하면 '|cFFFFFF00더 낮은|r' 장비 대신 '|cFFFFFF00더 높은|r' 장비를 판매합니다."
L["STRING_PANEL_NOITEMTOSHOW"] = "표시할 아이템이 없습니다."
L["STRING_SELLBLUE"] = "파템 장비 판매"
L["STRING_SELLBLUE_DESC"] = "귀속되지 않고 다른 필터에 속하지 않는 파템 장비를 판매합니다."
L["STRING_SELLBUTTON_DESC1"] = [=[아이템을 자동 판매 목록에 추가합니다.


이미 자동 판매 중:

]=]
L["STRING_SELLBUTTONTEXT"] = "아이템 판매"
L["STRING_SELLEPIC"] = "저레벨 에픽 장비 판매"
L["STRING_SELLGRAY"] = "회색템 자동 판매"
L["STRING_SELLGRAY_DESC"] = "상점 창이 열려 있는 동안 소지하고 있는 모든 잡템(회색)을 자동 판매합니다."
L["STRING_SELLGREEN"] = "녹템 장비 판매"
L["STRING_SELLGREEN_DESC"] = "귀속되지 않고 다른 필터에 속하지 않는 녹템 장비를 판매합니다."
L["STRING_SELLLOWEPIC_DESC"] = [=[아이템 레벨이 %d보다 낮은 귀속 에픽 장비를 판매합니다.

|cFFFFFF00중요:|r 접속 종료 시, 이 옵션을 기본값(사용 안 함)으로 되돌립니다.

|cFFFFFF00중요:|r 실제 사용 전에 판매 테스트를 하고 중요 아이템이 판매되는지 확인하세요.]=]
L["STRING_SELLPANEL_ADDBUTTON"] = "추가"
L["STRING_SELLPANEL_ITEMADDED"] = "아이템이 자동 판매 목록에 추가되었습니다. 문자 우측에 있는 X 버튼으로 제거 할 수 있습니다."
L["STRING_SELLPANEL_ITEMNAME"] = "아이템 이름"
L["STRING_SELLPANEL_ITEMREMOVED"] = "아이템이 자동 판매 목록에서 제거되었습니다."
L["STRING_SELLPANELTITLE"] = "자동 판매 목록"
L["STRING_SELLSOULBOUND"] = "귀속 아이템 판매"
L["STRING_SELLSOULBOUND_DESC"] = [=[귀속 아이템을 판매합니다 (아래 필터 설정에 따라).

|cFFFFFF00중요:|r 중요한 아이템을 소지품에서 제거하고 또한 중요한 아이템이 판매되는지 확인하기 위해 판매 테스트를 수행하세요.

|cFFFFFF00중요:|r 접속을 종료하면 이 옵션은 기본값으로 되돌려집니다 (비활성).]=]
L["STRING_TOTALSOLD"] = "총 판매"
L["STRING_TRANSMOGBUTTONTEXT"] = "형상변환"
L["STRING_TRANSMOGPANEL_CANTSELL"] = "이 창에 있는 에픽 아이템은 판매하지 않습니다."
L["STRING_TRANSMOGPANELTITLE"] = "형상변환 창"
L["STRING_VENDORGOLD"] = "상인 골드"
L["STRING_VENDORGOLD_DESC"] = "이 값보다 |cFFFFFF00더 높은|r 상점 가격의(골드 단위) 아이템은 아이템 레벨에 상관없이 판매합니다."

