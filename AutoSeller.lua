
-- localization

--todo: make the CONSTS below to be inside the profile and configurable by the user

local _
local version = "unknown version"
local debugmode = false

local L = LibStub ("AceLocale-3.0"):GetLocale ("AutoSellerLocales", true)
if (not L) then
	SYH:ShowPanicWarning ("AutoSeller Locale failed to load, restart your game client to finish addon updates.")
	return
end

--> item level range to sell epic items from the current content (special button above the sell button)
local CONST_ITEMLEVEL_SELLEPICCURRENT_THRESHOLD_START = 183
local CONST_ITEMLEVEL_SELLEPICCURRENT_THRESHOLD_END = 197

local ignore_list = {
	[44731] = true, --  Bouquet of Ebon Roses
	[38506] = true, -- Don Carlos' Famous Hat
	[86579] = true, --  Bottled Tornado
	[25653] = true, --   Riding Crop
	[19970] = true, --  Arcanite Fishing Pole
	[118372] = true, -- Orgrimmar Tabard
	[63207] = true, -- Wrap of Unity
	[63353] = true, --Shroud of Cooperation
	[116913] = true, --Peon's Mining Pick
	[116916] = true, --Gorepetal's Gentle Grasp
	[33820] = true, --Weather-Beaten Fishing Hat
	[84661] = true, --Dragon Fishing Pole
	[63206] = true, --Wrap of Unity
	[103678] = true, --Time-Lost Artifact
	[65274] = true, --Cloak of Coordination
	[2901] = true, --Mining Pick
	[86566] = true, --Forager's Gloves
}

local can_transmog = {
	["INVTYPE_HEAD"] = true,
	["INVTYPE_SHOULDER"] = true,
	["INVTYPE_BODY"] = true,
	["INVTYPE_CHEST"] = true,
	["INVTYPE_ROBE"] = true,
	["INVTYPE_WAIST"] = true,
	["INVTYPE_LEGS"] = true,
	["INVTYPE_FEET"] = true,
	["INVTYPE_WRIST"] = true,
	["INVTYPE_HAND"] = true,
	["INVTYPE_CLOAK"] = true,
	["INVTYPE_WEAPON"] = true,
	["INVTYPE_SHIELD"] = true,
	["INVTYPE_2HWEAPON"] = true,
	["INVTYPE_WEAPONMAINHAND"] = true,
	["INVTYPE_WEAPONOFFHAND"] = true,
	["INVTYPE_HOLDABLE"] = true,
	["INVTYPE_RANGED"] = true,
	["INVTYPE_THROWN"] = true,
	["INVTYPE_RANGEDRIGHT"] = true,
	["INVTYPE_RELIC"] = true,
}

local is_weapon_model = {
	["INVTYPE_WEAPON"] = true,
	["INVTYPE_2HWEAPON"] = true,
	["INVTYPE_WEAPONMAINHAND"] = true,
	["INVTYPE_WEAPONOFFHAND"] = true,
}

local config_table = {
	profile = {
		SellGreen = false,
		SellGreenMaxLevel = 110,
		SellBlue = false,
		SellEpic = false,
		SellEpicGearThreshold = 120,
		SellVendorThreshold = 500,
		AHPriceThreshold = 1000,
		ReverseSell = false,
		AutoOpenForMerchants = true,
		AutoSellGray = true,
		AutoRepair = false,
		AutoRepair_UseGuildBank = false,
		AllowToSell = {
			["INVTYPE_HEAD"] = true,
			["INVTYPE_NECK"] = true,
			["INVTYPE_SHOULDER"] = true,
			["INVTYPE_BODY"] = true,
			["INVTYPE_CHEST"] = true,
			["INVTYPE_ROBE"] = true,
			["INVTYPE_WAIST"] = true,
			["INVTYPE_LEGS"] = true,
			["INVTYPE_FEET"] = true,
			["INVTYPE_WRIST"] = true,
			["INVTYPE_HAND"] = true,
			["INVTYPE_FINGER"] = true,
			["INVTYPE_TRINKET"] = true,
			["INVTYPE_CLOAK"] = true,
			["INVTYPE_WEAPON"] = true,
			["INVTYPE_SHIELD"] = true,
			["INVTYPE_2HWEAPON"] = true,
			["INVTYPE_WEAPONMAINHAND"] = true,
			["INVTYPE_WEAPONOFFHAND"] = true,
			["INVTYPE_HOLDABLE"] = true,
			["INVTYPE_RANGED"] = true,
			["INVTYPE_THROWN"] = true,
			["INVTYPE_RANGEDRIGHT"] = true,
			["INVTYPE_RELIC"] = true,
		},
	},
}
local options_table = {
	type = "group",
	args = {},
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local broker
local SYH = LibStub ("DetailsFramework-1.0"):CreateAddOn ("AutoSeller", "SalvageYardHDB", config_table, options_table, broker)

local tooltip_scanner = CreateFrame ("gametooltip", "AutoSellerGTScanner", nil, "GameTooltipTemplate")
tooltip_scanner:Hide()

do --> install framework templates

	SYH:InstallTemplate ("button", "AUTOSELLER_MAINWINDOW_BUTTON_TEMPLATE", {
		backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
		backdropcolor = {.2, .2, .2, 1},
		backdropbordercolor = {0, 0, 0, 1},
		--width = 20,
		--height = 20,
		enabled_backdropcolor = {.2, .2, .2, 1},
		disabled_backdropcolor = {.2, .2, .2, 1},
		onenterbordercolor = {0, 0, 0, 1},
		textcolor = "silver",
		textsize = 10,
	})	
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function SYH:GetAuctionPrice (itemLink)
	--> has auction addons installed?
	local Auctioneer = AucAdvanced
	local Auctionator = Atr_GetAuctionBuyout
	local TSM = TSMAPI
	local TheUndermineJournal = GetAuctionBuyout

	--> default value
	local average_price = 0

	--> Auctioneer
	if (Auctioneer) then
		local price = Auctioneer.API.GetMarketValue (itemLink)
		average_price = price or 0
	end
	
	--> Auctionator
	if (Auctionator) then
		local price = Atr_GetAuctionBuyout (itemLink)
		average_price = max (average_price, (price or 0))
	end
	
	--> Trade Skill Master
	if (TSM) then
		local price = TSM:GetItemValue (itemLink, "DBMarket")
		average_price = max (average_price, (price or 0))
	end
	
	--> The Undermine Journal
	if (TheUndermineJournal) then
		local price = GetAuctionBuyout (itemLink)
		average_price = max (average_price, (price or 0))
	end
	
	return average_price
end

function SYH:ShowPanel (only_load)
	
	if (not SYH.SellPanel) then
	
		local options_text_template = SYH:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
		local options_text_template = SYH:GetTemplate ("font", "ORANGE_FONT_TEMPLATE")
		local options_dropdown_template = SYH:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
		local options_switch_template = SYH:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
		local options_slider_template = SYH:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
		local options_button_template = SYH:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
		local options_checkbox_template = SYH:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE")
	
		SalvageYardHDB.UserAutoSellList = SalvageYardHDB.UserAutoSellList or {}
		SalvageYardHDB.UserBlackList = SalvageYardHDB.UserBlackList or {}
		SalvageYardHDB.UserBlackListKeyWord = SalvageYardHDB.UserBlackListKeyWord or {}
	
		local sell = function (self)
			if (MerchantFrame and MerchantFrame:IsShown()) then
				return SYH:Sell()
			else
				return SYH:Msg (L["STRING_CANTSELL"])
			end
		end
		
		local open_ignore = function (self)
			if (not SYH.IgnorePanel) then
			
				SYH.db.profile.IgnorePanel = SYH.db.profile.IgnorePanel or {}
				SYH.IgnorePanel = SYH:Create1PxPanel (_, 255, 120, L["STRING_IGNOREPANELTITLE"], "SalvageYardIgnoreFrame", SYH.db.profile.IgnorePanel)
				SYH.IgnorePanel:SetPoint ("topleft", AutoSellerFrame, "topright", 5, 0)
				
				SYH.IgnorePanel:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				SYH.IgnorePanel:SetBackdropColor (0, 0, 0, 0.5)
				SYH.IgnorePanel:SetBackdropBorderColor (0, 0, 0, 1)
				
				local text = SYH:CreateLabel (SYH.IgnorePanel, L["STRING_IGNOREENTRYTEXT"] .. ":")
				local editbox = SYH:CreateTextEntry (SYH.IgnorePanel, _, 160, 20, "EditBox")
				editbox.tooltip = L["STRING_IGNOREENTRYTEXT_DESC"]
				editbox.latest_item = {}
				
				-- Hook the container buttons
				local hook_backpack = function (button)
					if (editbox.widget:HasFocus()) then
						if (IsShiftKeyDown()) then
							local link = GetContainerItemLink (button:GetParent():GetID(), button:GetID())
							local name = GetItemInfo (link)
							editbox.text = name or ""
							editbox.latest_item [1] = name
							editbox.latest_item [2] = link
						end
					end
				end
				hooksecurefunc ("ContainerFrameItemButton_OnModifiedClick", hook_backpack)
				
				local add_to_ignore = function()
					local text = editbox.text
					text = SYH:trim (text)
					if (text ~= "") then
					
						local itemname, itemlink
						
						if (editbox.text == editbox.latest_item [1]) then
							itemname = editbox.latest_item [1]
							itemlink = editbox.latest_item [2]
						else
							text = text:gsub ("%[", "")
							text = text:gsub ("%]", "")
							itemname = text
						end
						
						if (itemname and itemlink) then
							SalvageYardHDB.UserBlackList [itemname] = itemlink or true
							SYH:Msg (itemname .. " " .. L["STRING_IGNORE_ITEMADDED"])
						else
							SalvageYardHDB.UserBlackList [text] = true
							SYH:Msg (text .. " " .. L["STRING_IGNORE_ITEMADDED"])
						end
						
						editbox.text = ""
						editbox:ClearFocus()
					end
				end
				local add_button = SYH:CreateButton (SYH.IgnorePanel, add_to_ignore, 45, 20, L["STRING_IGNOREADDBUTTONTEXT"], _, _, _, "AddButton", _, _)
			
				text:SetPoint ("topleft", SYH.IgnorePanel, "topleft", 7, -30)
				editbox:SetPoint ("topleft", SYH.IgnorePanel, "topleft", 7, -42)
				add_button:SetPoint ("left", editbox, "right", 4, 0)

				local remove_ignore = SYH:CreateButton (SYH.IgnorePanel, function()end, 6, 20, "X", _, _, _, "RemoveButton", _, _)
				remove_ignore:SetPoint ("left", add_button, "right", 2)
				local remove_func = function (_, _, itemname)
					SalvageYardHDB.UserBlackList [itemname] = nil
					GameCooltip2:Hide()
					SYH:Msg (itemname .. " " .. L["STRING_IGNORE_ITEMREMOVED"])
				end
				remove_ignore:SetHook ("OnEnter", function()
					GameCooltip2:Preset (2)
					
					for itemname, _ in pairs (SalvageYardHDB.UserBlackList) do
						GameCooltip2:AddLine (itemname)
						GameCooltip2:AddMenu (1, remove_func, itemname)
					end

					GameCooltip2:SetType ("menu")
					GameCooltip2:SetHost (remove_ignore.widget, "left", "right", -7, 0)
					GameCooltip2:Show()
				end)
				
				-----
				
				local text2 = SYH:CreateLabel (SYH.IgnorePanel, L["STRING_IGNORE_ENTERKEYWORD"] .. ":")
				local editbox2 = SYH:CreateTextEntry (SYH.IgnorePanel, _, 160, 20, "EditBoxKeyWord")
				editbox2.tooltip = L["STRING_IGNORE_ENTERKEYWORD_DESC"]

				local add_keyword_to_ignore = function()
					local text = editbox2.text
					text = SYH:trim (text)
					text = text:gsub ("%[", "")
					text = text:gsub ("%]", "")
					
					if (text ~= "") then
						text = string.lower (text)
						SalvageYardHDB.UserBlackListKeyWord [text] = true
						SYH:Msg (text .. " " .. L["STRING_IGNORE_KEYWORDADDED"])
						editbox2.text = ""
						editbox2:ClearFocus()
					end
				end
				
				local add_button2 = SYH:CreateButton (SYH.IgnorePanel, add_keyword_to_ignore, 45, 20, L["STRING_IGNOREADDBUTTONTEXT"], _, _, _, "AddButtonKeyWord", _, _)
			
				text2:SetPoint ("topleft", SYH.IgnorePanel, "topleft", 7, -70)
				editbox2:SetPoint ("topleft", SYH.IgnorePanel, "topleft", 7, -82)
				add_button2:SetPoint ("left", editbox2, "right", 4, 0)
				
				local remove = SYH:CreateButton (SYH.IgnorePanel, function()end, 6, 20, "X", _, _, _, "RemoveButtonKeyWord", _, _)
				remove:SetPoint ("left", add_button2, "right", 2)
				local remove_keyword_func = function (_, _, keyword)
					SalvageYardHDB.UserBlackListKeyWord [keyword] = nil
					GameCooltip2:Hide()
					SYH:Msg (keyword .. " " .. L["STRING_IGNORE_KEYWORDREMOVED"])
				end
				remove:SetHook ("OnEnter", function()
					GameCooltip2:Preset (2)
					
					for keyword, _ in pairs (SalvageYardHDB.UserBlackListKeyWord) do
						GameCooltip2:AddLine (keyword)
						GameCooltip2:AddMenu (1, remove_keyword_func, keyword)
					end

					GameCooltip2:SetType ("menu")
					GameCooltip2:SetHost (remove.widget, "left", "right", -7, 0)
					GameCooltip2:Show()
				end)
			end
			
			SYH:HideAllSubPanels ("ignore")
			if (SYH.AdvancedPanel and SYH.AdvancedPanel:IsShown())then
				SYH.AdvancedPanel:Hide()
			end
			
			SYH.IgnorePanel:Show()
		end
		
		--start------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		local open_selllist = function (self)
			if (not SYH.SellListPanel) then
			
				SYH.db.profile.SellListPanel = SYH.db.profile.SellListPanel or {}
				SYH.SellListPanel = SYH:Create1PxPanel (_, 255, 120, L["STRING_SELLPANELTITLE"], "SalvageYardSellListFrame", SYH.db.profile.SellListPanel)
				SYH.SellListPanel:SetPoint ("topleft", AutoSellerFrame, "topright", 5, 0)
				
				SYH.SellListPanel:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				SYH.SellListPanel:SetBackdropColor (0, 0, 0, 0.5)
				SYH.SellListPanel:SetBackdropBorderColor (0, 0, 0, 1)
				
				local text = SYH:CreateLabel (SYH.SellListPanel, L["STRING_SELLPANEL_ITEMNAME"] .. ":")
				local editbox = SYH:CreateTextEntry (SYH.SellListPanel, _, 160, 20, "EditBox")
				editbox.tooltip = L["STRING_IGNOREENTRYTEXT_DESC"]
				editbox.latest_item = {}
				
				-- Hook the container buttons
				local hook_backpack = function (button)
					if (editbox.widget:HasFocus()) then
						if (IsShiftKeyDown()) then
							local link = GetContainerItemLink (button:GetParent():GetID(), button:GetID())
							local name = GetItemInfo (link)
							editbox.text = name or ""
							editbox.latest_item [1] = name
							editbox.latest_item [2] = link
						end
					end
				end
				hooksecurefunc ("ContainerFrameItemButton_OnModifiedClick", hook_backpack)
				
				local add_to_selllist = function()
					local text = editbox.text
					text = SYH:trim (text)
					if (text ~= "") then
						local itemname, itemlink
						
						if (editbox.text == editbox.latest_item [1]) then
							itemname = editbox.latest_item [1]
							itemlink = editbox.latest_item [2]
						else
							text = text:gsub ("%[", "")
							text = text:gsub ("%]", "")
							itemname = text
						end
						
						if (itemname and itemlink) then
							SalvageYardHDB.UserAutoSellList [itemname] = itemlink or true
							SYH:Msg (itemname .. " " .. L["STRING_SELLPANEL_ITEMADDED"])
						else
							SalvageYardHDB.UserAutoSellList [text] = true
							SYH:Msg (text .. " " .. L["STRING_SELLPANEL_ITEMADDED"])
						end
						
						editbox.text = ""
						editbox:ClearFocus()
					end
				end
				local add_button = SYH:CreateButton (SYH.SellListPanel, add_to_selllist, 45, 20, L["STRING_SELLPANEL_ADDBUTTON"], _, _, _, "AddButton", _, _)
			
				text:SetPoint ("topleft", SYH.SellListPanel, "topleft", 7, -30)
				editbox:SetPoint ("topleft", SYH.SellListPanel, "topleft", 7, -42)
				add_button:SetPoint ("left", editbox, "right", 4, 0)

				local remove_autosell = SYH:CreateButton (SYH.SellListPanel, function()end, 6, 20, "X", _, _, _, "RemoveButton", _, _)
				remove_autosell:SetPoint ("left", add_button, "right", 2)
				local remove_func = function (_, _, itemname)
					SalvageYardHDB.UserAutoSellList [itemname] = nil
					GameCooltip2:Hide()
					SYH:Msg (itemname .. " " .. L["STRING_SELLPANEL_ITEMREMOVED"])
				end
				remove_autosell:SetHook ("OnEnter", function()
					GameCooltip2:Preset (2)
					GameCooltip2:SetOption ("TextSize", 10)
					
					for itemname, _ in pairs (SalvageYardHDB.UserAutoSellList) do
						local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo (itemname)
						if (itemName) then
							GameCooltip2:AddLine (itemName)
							GameCooltip2:AddIcon (itemTexture)
						else
							GameCooltip2:AddLine (itemname)
						end
						
						GameCooltip2:AddMenu (1, remove_func, itemname)
					end

					GameCooltip2:SetType ("menu")
					GameCooltip2:SetHost (remove_autosell.widget, "left", "right", -7, 0)
					GameCooltip2:Show()
				end)

			end
			
			SYH:HideAllSubPanels ("autoselllist")
			if (SYH.AdvancedPanel and SYH.AdvancedPanel:IsShown())then
				SYH.AdvancedPanel:Hide()
			end
			
			SYH.SellListPanel:Show()
		end		
		
		--end------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		local containers = {}
		local backpack_flash_ticker
		local backpack_flash_last_texture
		
		local backpack_flash = function (item_texture)

			if (type (item_texture) == "table") then
				item_texture = backpack_flash_last_texture
			elseif (type (item_texture) == "string") then
				backpack_flash_last_texture = item_texture
			elseif (type (item_texture) == "number") then
			else
				return
			end
		
			if (not containers[1]) then
				for c = 1, 5 do
					for i = 1, 50 do
						local containerSlot = _G ["ContainerFrame" .. c .. "Item" .. i]
						if (containerSlot) then
							tinsert (containers, containerSlot)
						end
					end
				end
			end

			item_texture = item_texture or ""
			
			if (type (item_texture) == "string") then
				item_texture = item_texture:gsub ("%.BLP", "")
				item_texture = item_texture:gsub ("%.blp", "")
			end
			
			for i = 1, #containers do
				local containerSlot = containers [i]
				local texture = _G [containerSlot:GetName() .. "IconTexture"]
				
				if (texture:GetTexture() == item_texture) then
					local anim = containerSlot.flashAnim
					if (anim) then
						anim:Play()
					end
				end
			end

		end
		
		local open_transmog = function()
			if (not SYH.TransmogPanel) then
				SYH.db.profile.TransmogPanel = SYH.db.profile.TransmogPanel or {}
				SYH.TransmogPanel = SYH:Create1PxPanel (_, 420, 200, L["STRING_TRANSMOGPANELTITLE"], "SalvageYardTransmogFrame", SYH.db.profile.TransmogPanel)
				SYH.TransmogPanel:SetPoint ("bottomleft", AutoSellerFrame, "bottomright", 5, 0)
				
				SYH.TransmogPanel:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				SYH.TransmogPanel:SetBackdropColor (0, 0, 0, 0.5)
				SYH.TransmogPanel:SetBackdropBorderColor (0, 0, 0, 1)
				
				SYH.TransmogPanel.NoItemLabel = SYH:CreateLabel (SYH.TransmogPanel, L["STRING_PANEL_NOITEMTOSHOW"])
				SYH.TransmogPanel.NoItemLabel:SetPoint ("center", SYH.TransmogPanel, "center")
				SYH:SetFontSize (SYH.TransmogPanel.NoItemLabel, 12)
				SYH:SetFontColor (SYH.TransmogPanel.NoItemLabel, "yellow")
				
				SYH.TransmogPanel:SetScript ("OnShow", function()
					SYH.TransmogPanel:RegisterEvent ("BAG_UPDATE")
					SYH.TransmogPanel:UpdateFrames()
				end)
				SYH.TransmogPanel:SetScript ("OnHide", function()
					SYH.TransmogPanel:UnregisterEvent ("BAG_UPDATE")
				end)
				SYH.TransmogPanel:SetScript ("OnEvent", function (self, event, ...)
					if (event == "BAG_UPDATE") then
						SYH.TransmogPanel:UpdateFrames()
					end
				end)
				
				local frame3D = CreateFrame ("DressUpModel", "SalvageYard3DTransmogFrame", 	SYH.TransmogPanel, "ModelWithControlsTemplate, BackdropTemplate")
				frame3D:SetSize (260, 300)
				frame3D:SetFrameStrata ("TOOLTIP")
				frame3D:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				frame3D:SetBackdropColor (0, 0, 0, 1)
				frame3D.defaultRotation = MODELFRAME_DEFAULT_ROTATION
				frame3D.cloakRotation = MODELFRAME_DEFAULT_ROTATION + math.pi
				frame3D.weaponRotation = MODELFRAME_DEFAULT_ROTATION + (math.pi/5)
				frame3D.bowRotation = math.pi*2*0.75
				frame3D.minZoom = 0
				frame3D.maxZoom = 1
	
				local on_enter = function (self)
					frame3D:Show()
					frame3D:SetPoint ("bottom", self, "top", 0, 5)
					
					Model_Reset (frame3D)
					frame3D:SetUnit ("player")
					frame3D:Undress()
					frame3D:TryOn (self.itemLink)
					
					if (self.isCloak) then
						frame3D:SetRotation (frame3D.cloakRotation)
					elseif (self.isWeapon) then
						frame3D:SetRotation (frame3D.weaponRotation)
					elseif (self.isBow) then
						frame3D:SetRotation (frame3D.bowRotation)
					end
					
					self.texture:SetBlendMode ("ADD")
					
					GameTooltip:SetOwner (self)
					GameTooltip:SetHyperlink (self.itemLink)
					GameTooltip:Show()
					GameTooltip:ClearAllPoints()
					GameTooltip:SetPoint ("topleft", frame3D, "topright", 2, 0)

					backpack_flash (self.itemTexture)
					backpack_flash_ticker = C_Timer.NewTicker (1.2, backpack_flash)
					
				end
				local on_leave = function (self)
					frame3D:Hide()
					GameTooltip:Hide()
					self.texture:SetBlendMode ("BLEND")
					if (backpack_flash_ticker and not backpack_flash_ticker._cancelled) then
						backpack_flash_ticker:Cancel()
					end
				end
				
				local on_mouse_up = function (self, button)
					if (button == "LeftButton") then
						if (MerchantFrame and MerchantFrame:IsShown()) then
							if (self.itemQuality >= 4) then
								SYH:Msg (L["STRING_TRANSMOGPANEL_CANTSELL"])
							else
								UseContainerItem (self.backPackNumber, self.backPackSlot)
								SYH:Msg (L["STRING_TOTALSOLD"] .. ": " .. GetCoinText (self.sellPrice) .. ".")
							end
						end
					end
				end

				SYH.TransmogPanel.blocks = {}
				local x, y = 5, -25
				local backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 20, tile = true}
				
				function SYH.TransmogPanel:ClearBlocks()
					for _, block in ipairs (SYH.TransmogPanel.blocks) do --dos
						block:Hide()
					end
				end
				
				function SYH.TransmogPanel:GetBlock (i)
					if (not SYH.TransmogPanel.blocks [i]) then
						local f = CreateFrame ("frame", nil, SYH.TransmogPanel, "BackdropTemplate")
						f:SetPoint ("topleft", SYH.TransmogPanel, "topleft", x, y)
						f:SetSize (30, 30)
						f.texture = f:CreateTexture (nil, overlay)
						f.texture:SetPoint ("topleft", f, "topleft", 1, -1)
						f.texture:SetPoint ("bottomright", f, "bottomright", -1, 1)
						f:SetBackdrop (backdrop)
						f:SetScript ("OnEnter", on_enter)
						f:SetScript ("OnLeave", on_leave)
						f:SetScript ("OnMouseUp", on_mouse_up)
						
						if (x > 370) then
							x = 5
							y = y - 31
						else
							x = x + 31
						end
						
						SYH.TransmogPanel.blocks [i] = f
					end
					return SYH.TransmogPanel.blocks [i]
				end
				
				function SYH.TransmogPanel:UpdateFrames()
				
					local i = 1
					SYH.TransmogPanel:ClearBlocks()
					local shown_amount = 0
				
					for backpack = 0, 4 do
						for slot = 1, GetContainerNumSlots (backpack) do 
							local itemId = GetContainerItemID (backpack, slot)
							if (itemId and not ignore_list [itemId] and not SYH:IsSoulbound (backpack, slot)) then
								local _, _, _, quality, _, _, itemLink = GetContainerItemInfo (backpack, slot)
								local itemName, itemLink, _, itemLevel, _, itemType, itemSubType, _, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo (itemLink)
								if (itemName and quality ~= 0 and quality <= 3 and SYH.db.profile.AllowToSell [itemEquipLoc] and can_transmog [itemEquipLoc] and not SalvageYardHDB.UserBlackList [itemName]) then
									local block = SYH.TransmogPanel:GetBlock (i)
									block.texture:SetTexture (itemTexture)
									block.texture:SetTexCoord (5/64, 59/64, 5/64, 59/64)
									local color = BAG_ITEM_QUALITY_COLORS [quality]
									if (color) then
										block:SetBackdropBorderColor (color.r, color.g, color.b)
									else
										block:SetBackdropBorderColor (.5, .5, .5)
									end
									block.itemLink = itemLink
									block.isCloak = itemEquipLoc == "INVTYPE_CLOAK"
									block.isWeapon = is_weapon_model [itemEquipLoc]
									block.isBow = itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_SHIELD"
									block.backPackNumber = backpack
									block.backPackSlot = slot
									block.itemTexture = itemTexture
									block.sellPrice = itemSellPrice
									block.itemQuality = quality
									block:Show()
									
									shown_amount = shown_amount + 1
									i = i + 1
								end
							end
						end
					end
					
					if (shown_amount > 0) then
						SYH.TransmogPanel.NoItemLabel:Hide()
					else
						SYH.TransmogPanel.NoItemLabel:Show()
					end
				end
				
				SYH:HideAllSubPanels ("transmog")
				SYH.TransmogPanel:Hide()
				SYH.TransmogPanel:Show()
				
			else
				SYH:HideAllSubPanels ("transmog")
				if (SYH.TransmogPanel and SYH.TransmogPanel:IsShown())then
					SYH.TransmogPanel:Hide()
				else
					SYH.TransmogPanel:Show()
				end
			end

		end
		
		local open_ah_prices = function()
			if (not SYH.PricePanel) then
				SYH.db.profile.PricePanel = SYH.db.profile.PricePanel or {}
				SYH.PricePanel = SYH:Create1PxPanel (_, 420, 320, L["STRING_AHPRICEPANELTITLE"], "SalvageYardPriceFrame", SYH.db.profile.PricePanel)
				SYH.PricePanel:SetPoint ("topleft", AutoSellerFrame, "topright", 5, 0)
				
				SYH.PricePanel:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				SYH.PricePanel:SetBackdropColor (0, 0, 0, 0.5)
				SYH.PricePanel:SetBackdropBorderColor (0, 0, 0, 1)
				
				SYH.PricePanel.NoItemLabel = SYH:CreateLabel (SYH.PricePanel, L["STRING_PANEL_NOITEMTOSHOW"])
				SYH.PricePanel.NoItemLabel:SetPoint ("center", SYH.PricePanel, "center")
				SYH:SetFontSize (SYH.PricePanel.NoItemLabel, 12)
				SYH:SetFontColor (SYH.PricePanel.NoItemLabel, "yellow")
				
				SYH.PricePanel:SetScript ("OnShow", function()
					SYH.PricePanel:RegisterEvent ("BAG_UPDATE")
					SYH.PricePanel:UpdateFrames()
				end)
				SYH.PricePanel:SetScript ("OnHide", function()
					SYH.PricePanel:UnregisterEvent ("BAG_UPDATE")
				end)
				SYH.PricePanel:SetScript ("OnEvent", function (self, event, ...)
					if (event == "BAG_UPDATE") then
						SYH.PricePanel:UpdateFrames()
					end
				end)

				local on_enter = function (self)
					self.texture:SetBlendMode ("ADD")
					
					GameTooltip:SetOwner (self)
					GameTooltip:SetHyperlink (self.itemLink)
					GameTooltip:Show()
					GameTooltip:ClearAllPoints()
					GameTooltip:SetPoint ("topleft", self, "topright", 2, 0)
					
					backpack_flash (self.itemTexture)
					backpack_flash_ticker = C_Timer.NewTicker (1.2, backpack_flash)
					--> show where the item is in the backpack
				end
				local on_leave = function (self)
					GameTooltip:Hide()
					self.texture:SetBlendMode ("BLEND")
					if (backpack_flash_ticker and not backpack_flash_ticker._cancelled) then
						backpack_flash_ticker:Cancel()
					end
				end
				
				local on_mouse_up = function (self, button)
					if (button == "LeftButton") then
						if (MerchantFrame and MerchantFrame:IsShown()) then
							if (self.itemQuality >= 4) then
								--SYH:Msg ("Cannot sell epic items through this panel.")
							else
								--UseContainerItem (self.backPackNumber, self.backPackSlot)
								--SYH:Msg ("Total Sold: " .. GetCoinText (self.sellPrice) .. ".")
							end
						end
					end
				end
				
				local sort_price_higher = function (a, b) return a[2] > b[2] end
			
				SYH.PricePanel.blocks = {}
				local x, y = 5, -25
				local backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 20, tile = true}
				
				function SYH.PricePanel:ClearBlocks()
					for _, block in ipairs (SYH.PricePanel.blocks) do --dos
						block:Hide()
					end
				end
				
				function SYH.PricePanel:GetBlock (i)
					if (not SYH.PricePanel.blocks [i]) then
						local f = CreateFrame ("frame", nil, SYH.PricePanel, "BackdropTemplate")
						f:SetPoint ("topleft", SYH.PricePanel, "topleft", x, y)
						f:SetSize (45, 45)
						
						f.texture = f:CreateTexture (nil, "artwork")
						f.texture:SetDrawLayer ("artwork", 1)
						f.texture:SetPoint ("topleft", f, "topleft", 1, -1)
						f.texture:SetPoint ("bottomright", f, "bottomright", -1, 1)
						
						f.texture2 = f:CreateTexture (nil, "artwork")
						f.texture2:SetDrawLayer ("artwork", 2)
						f.texture2:SetPoint ("topleft", f, "topleft", 1, -15)
						f.texture2:SetPoint ("bottomright", f, "bottomright", -1, 15)
						f.texture2:SetColorTexture (0, 0, 0, 0.7)
						
						f.text = f:CreateFontString (nil, "overlay", "GameFontNormal")
						f.text:SetPoint ("center", f, "center")
						
						f:SetBackdrop (backdrop)
						f:SetScript ("OnEnter", on_enter)
						f:SetScript ("OnLeave", on_leave)
						f:SetScript ("OnMouseUp", on_mouse_up)
						
						if (x > 370) then
							x = 5
							y = y - 46
						else
							x = x + 46
						end
						
						SYH.PricePanel.blocks [i] = f
					end
					return SYH.PricePanel.blocks [i]
				end
				
				function SYH.PricePanel:UpdateFrames()
				
					local i = 1
					SYH.PricePanel:ClearBlocks()
					
					--> store data on these tables
					local items = {}
					local already_added = {}
				
					--> get items which can be sell on auction house
					for backpack = 0, 4 do
						for slot = 1, GetContainerNumSlots (backpack) do 
						
							local itemId = GetContainerItemID (backpack, slot)
							
							if (itemId and not ignore_list [itemId] and not SYH:IsSoulbound (backpack, slot)) then
							
								local _, _, _, quality, _, _, itemLink = GetContainerItemInfo (backpack, slot)
								local itemName, itemLink, _, itemLevel, _, itemType, itemSubType, _, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo (itemLink)
								
								if (itemName and quality ~= 0 and not SalvageYardHDB.UserBlackList [itemName] and not already_added [itemLink]) then
									local average_price = SYH:GetAuctionPrice (itemLink)

									--> if the item has a market value bigger then 1 gold.
									if (average_price > 10000) then
										tinsert (items, {itemLink, average_price, backpack, slot})
										already_added [itemLink] = true
									end
								end
								
							end
						end
					end
					
					table.sort (items, sort_price_higher)
					
					--> show items
					for i, item in ipairs (items) do
						
						local itemLink, average_price, backpack, slot = unpack (item)
						
						local itemName, itemLink, itemRarity, itemLevel, _, itemType, itemSubType, _, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo (itemLink)
					
						local block = SYH.PricePanel:GetBlock (i)
						block.texture:SetTexture (itemTexture)
						block.texture:SetTexCoord (5/64, 59/64, 5/64, 59/64)
						block.text:SetText (floor (average_price / 10000))
						local color = BAG_ITEM_QUALITY_COLORS [itemRarity]
						
						if (color) then
							block:SetBackdropBorderColor (color.r, color.g, color.b)
						else
							block:SetBackdropBorderColor (.5, .5, .5)
						end
						
						block.itemLink = itemLink
						--block.isCloak = itemEquipLoc == "INVTYPE_CLOAK"
						--block.isWeapon = is_weapon_model [itemEquipLoc]
						--block.isBow = itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_SHIELD"
						
						block.backPackNumber = backpack
						block.backPackSlot = slot
						
						block.sellPrice = itemSellPrice
						block.aucPrice = average_price
						block.itemQuality = itemRarity
						block.itemTexture = itemTexture
						block:Show()
					end
					
					if (#items > 0) then
						SYH.PricePanel.NoItemLabel:Hide()
					else
						SYH.PricePanel.NoItemLabel:Show()
					end
				end
				
				SYH:HideAllSubPanels ("ahprice")
				SYH.PricePanel:Hide()
				SYH.PricePanel:Show()
			else
				SYH:HideAllSubPanels ("ahprice")
				if (SYH.PricePanel and SYH.PricePanel:IsShown())then
					SYH.PricePanel:Hide()
				else
					SYH.PricePanel:Show()
				end
			end
		end		
		
		SYH.db.profile.MainPanel = SYH.db.profile.MainPanel or {}
		SYH.SellPanel = SYH:Create1PxPanel (_, 250, 400, "", "AutoSellerFrame", SYH.db.profile.MainPanel)
		DetailsFramework:ApplyStandardBackdrop(SYH.SellPanel)
		local titleBar = DetailsFramework:CreateTitleBar(SYH.SellPanel, "Auto Seller")
		titleBar.CloseButton:Hide()

		SYH.SellPanel.Close:ClearAllPoints()
		SYH.SellPanel.Lock:ClearAllPoints()
		SYH.SellPanel.Close:SetPoint("right", titleBar, "right", -5, 0)
		SYH.SellPanel.Lock:SetPoint("right", SYH.SellPanel.Close, "left", -2, 0)
		SYH.SellPanel.Lock:SetScale(.95)

		SYH.SellPanel.Close:SetAlpha(.5)
		SYH.SellPanel.Lock:SetAlpha(.5)

		
		SYH.SellPanel:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		SYH.SellPanel:SetBackdropColor (0, 0, 0, 0.5)
		SYH.SellPanel:SetBackdropBorderColor (0, 0, 0, 1)
		
		SYH.SellPanel.ForceSellSoulbound = false
		SYH.SellPanel.SellLowLevelEpic = false
		
		if (debugmode) then
			feedback_func()
		end

		--build the options panel
		local optionsTable = {
			--auto sell gray
			{
				type = "toggle",
				get = function() return SYH.db.profile.AutoSellGray end,
				set = function (self, fixedparam, value) 
					SYH.db.profile.AutoSellGray = value
				end,
				name = L["STRING_SELLGRAY"],
				desc = L["STRING_SELLGRAY_DESC"],
			},

			--sell green
			{
				type = "toggle",
				get = function() return SYH.db.profile.SellGreen end,
				set = function (self, fixedparam, value) 
					SYH.db.profile.SellGreen = value
				end,
				name = L["STRING_SELLGREEN"],
				desc = L["STRING_SELLGREEN_DESC"],
			},

			--sell blue
			{
				type = "toggle",
				get = function() return SYH.db.profile.SellBlue end,
				set = function (self, fixedparam, value) 
					SYH.db.profile.SellBlue = value
				end,
				name = L["STRING_SELLBLUE"],
				desc = L["STRING_SELLBLUE_DESC"],
			},

			--sell purple
			{
				type = "toggle",
				get = function() return SYH.db.profile.SellEpic end,
				set = function (self, fixedparam, value) 
					SYH.db.profile.SellEpic = value
				end,
				name = L["STRING_SELLEPIC"],
				desc = L["STRING_SELLLOWEPIC_DESC"],
			},

			--auto open
			{
				type = "toggle",
				get = function() return SYH.db.profile.AutoOpenForMerchants end,
				set = function (self, fixedparam, value) 
					SYH.db.profile.AutoOpenForMerchants = value
				end,
				name = L["STRING_AUTOOPEN"],
				desc = L["STRING_AUTOOPEN_DESC"],
			},

			--auto repair
			{
				type = "toggle",
				get = function() return SYH.db.profile.AutoRepair end,
				set = function (self, fixedparam, value) 
					SYH.db.profile.AutoRepair = value
				end,
				name = L["STRING_AUTOREPAIR"],
				desc = L["STRING_AUTOREPAIR_DESC"],
			},

			--use guild money on repair
			{
				type = "toggle",
				get = function() return SYH.db.profile.AutoRepair_UseGuildBank end,
				set = function (self, fixedparam, value) 
					SYH.db.profile.AutoRepair_UseGuildBank = value
				end,
				name = L["STRING_AUTOREPAIR_BANK"],
				desc = L["STRING_AUTOREPAIR_BANK_DESC"],
			},

			--sell soulbound equipment
			{
				type = "toggle",
				get = function() return SYH.SellPanel.ForceSellSoulbound end,
				set = function (self, fixedparam, value) 
					SYH.SellPanel.ForceSellSoulbound = value
				end,
				name = L["STRING_SELLSOULBOUND"],
				desc = L["STRING_SELLSOULBOUND_DESC"],
			},

			--blank space
			{type = "blank"},

			--item level slider (green blue)
			{
				type = "range",
				get = function() return SYH.db.profile.SellGreenMaxLevel end,
				set = function (self, fixedparam, value) 
					SYH.db.profile.SellGreenMaxLevel = value
				end,
				min = 6,
				max = 300,
				step = 1,
				name = L["STRING_ITEMLEVEL"],
				desc = L["STRING_ITEMLEVEL_DESC2"],
			},

			--item level slider (purple)
			{
				type = "range",
				get = function() return AutoSeller.db.profile.SellEpicGearThreshold end,
				set = function (self, fixedparam, value) 
					AutoSeller.db.profile.SellEpicGearThreshold = value
				end,
				min = 6,
				max = 300,
				step = 1,
				name = L["STRING_EPICRANGE"],
				desc = L["STRING_EPICRANGE_DESC"],
			},

			--vendor gold slider
			{
				type = "range",
				get = function() return SYH.db.profile.SellVendorThreshold end,
				set = function (self, fixedparam, value) 
					SYH.db.profile.SellVendorThreshold = value
				end,
				min = 1,
				max = 500,
				step = 1,
				name = L["STRING_VENDORGOLD"],
				desc = L["STRING_VENDORGOLD_DESC"],
			},

			--auction price slider
			{
				type = "range",
				get = function() return SYH.db.profile.AHPriceThreshold end,
				set = function (self, fixedparam, value) 
					SYH.db.profile.AHPriceThreshold = value
				end,
				min = 1,
				max = 500,
				step = 1,
				name = L["STRING_AHPRICE"],
				desc = L["STRING_AHPRICE_DESC"],
			},
		}

		DetailsFramework:BuildMenu (SYH.SellPanel, optionsTable, 5, -35, 400, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template, globalCallback)
		
---BUTTONS

		local sell_items = SYH:CreateButton (SYH.SellPanel, sell, 120, 20, L["STRING_SELLBUTTONTEXT"], _, _, _, "SellButton", "AutoSellerSellButton", _, options_dropdown_template)

		--> ~ignore
			local ignore_button = SYH:CreateButton (SYH.SellPanel, open_ignore, 120, 20, L["STRING_IGNOREBUTTONTEXT"], _, _, _, "IgnoreButton", _, _, SYH:GetTemplate ("button", "AUTOSELLER_MAINWINDOW_BUTTON_TEMPLATE"))
			ignore_button.tooltip = function()
				local s = L["STRING_IGNORE_DESC1"]
				for itemname, itemlink in pairs (SalvageYardHDB.UserBlackList) do
					if (type (itemlink) == "boolean") then
						s = s .. " -" .. itemname .. "\n"
					else
					
						local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo (itemlink)
						if (itemTexture) then
							s = s .. " |T" .. (itemTexture or "") .. ":12:12:0:-7:64:64:5:59:5:59|t " .. itemLink .. "\n"
						else
							s = s .. " -" .. itemlink .. "\n"
						end				
					
						--s = s .. " -" .. itemlink .. "\n"
					end
				end
				s = s .. L["STRING_IGNORE_DESC2"]
				for keyword, _ in pairs (SalvageYardHDB.UserBlackListKeyWord) do
					s = s .. " \"|cFFFFFFFF" .. keyword .. "|r\" "
				end
				return s
			end

		--> ~transmog
		local transmog_button = SYH:CreateButton (SYH.SellPanel, open_transmog, 120, 20, L["STRING_TRANSMOGBUTTONTEXT"], _, _, _, "TransogButton", _, _, SYH:GetTemplate ("button", "AUTOSELLER_MAINWINDOW_BUTTON_TEMPLATE"))
		transmog_button.tooltip = "Show a list of not soulbound equipment on your backpack."
		
		--> ~ahprice
		local ahprices_button = SYH:CreateButton (SYH.SellPanel, open_ah_prices, 120, 20, L["STRING_AHPRICEBUTTONTEXT"], _, _, _, "AhPricesButton", _, _, SYH:GetTemplate ("button", "AUTOSELLER_MAINWINDOW_BUTTON_TEMPLATE"))
		ahprices_button.tooltip = "Show items in your backpack with known auction house value."
		
		--> sellepic
		local sell_epic_gear = SYH:CreateButton (SYH.SellPanel, function() SYH.CanSellHighLevelEpicGear = true; sell() end, 120, 20, "Sell 183-197 Gear", _, _, _, "SellEpicHearButton", _, _, SYH:GetTemplate ("button", "AUTOSELLER_MAINWINDOW_BUTTON_TEMPLATE"))
		sell_epic_gear.tooltip = "Sells all epic soulbound gear items from 183 to 197 item level."
		
		--> ~autosell epic gear of a certain item level
		local autosell_button = SYH:CreateButton (SYH.SellPanel, open_selllist, 120, 20, L["STRING_AUTOSELLBUTTONTEXT"], _, _, _, "AutoSellButton", _, _, SYH:GetTemplate ("button", "AUTOSELLER_MAINWINDOW_BUTTON_TEMPLATE"))
		autosell_button.tooltip = function()
			local s = L["STRING_SELLBUTTON_DESC1"]
			for itemname, itemlink in pairs (SalvageYardHDB.UserAutoSellList) do
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo (itemname)
				if (itemName) then
					s = s .. " |T" .. (itemTexture or "") .. ":12:12:0:-7:64:64:5:59:5:59|t " .. itemLink .. "\n"
				elseif (type (itemlink) == "boolean") then
					s = s .. " -" .. itemname .. "\n"
				else
					local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo (itemlink)
					if (itemTexture) then
						s = s .. " |T" .. (itemTexture or "") .. ":12:12:0:-7:64:64:5:59:5:59|t " .. itemLink .. "\n"
					else
						s = s .. " -" .. itemlink .. "\n"
					end
				end
			end
			
			GameCooltip2:SetOption ("FixedWidth", 350)
			return s
		end

		--row 1
		ignore_button:SetPoint ("topleft", SYH.SellPanel, "topleft", 4, -300)
		transmog_button:SetPoint ("left", ignore_button, "right", 2, 0)

		--row 2
		autosell_button:SetPoint ("topleft", SYH.SellPanel, "topleft", 4, -320)
		ahprices_button:SetPoint ("left", autosell_button, "right", 2, 0)

		--row 3
		sell_epic_gear:SetPoint ("top", SYH.SellPanel, "top", 0, -347)

		--row 4
		sell_items:SetPoint ("center", SYH.SellPanel, "center", 0, 0)
		sell_items:SetPoint ("top", SYH.SellPanel, "top", 0, -375)

		--> progress bar
			local progress_bar = SYH:CreateBar (SYH.SellPanel, _, 210, 10, 0, "ProgressBar")
			progress_bar.shown = false
			progress_bar:SetPoint ("center", SYH.SellPanel, "center", 0, 0)
			progress_bar:SetPoint ("top", SYH.SellPanel, "top", 0, -323)
		
		function SYH:IsSoulbound (bag, slot)
			tooltip_scanner:SetOwner (UIParent, "ANCHOR_NONE")
			tooltip_scanner:ClearLines()
			tooltip_scanner:SetBagItem (bag, slot)
			for i = 1, 8 do
				local text = _G ["AutoSellerGTScannerTextLeft" .. i] and _G ["AutoSellerGTScannerTextLeft" .. i]:GetText()
				if (text and (text == ITEM_SOULBOUND or text == ITEM_BIND_ON_PICKUP)) then
					return true
				end
			end
			tooltip_scanner:Hide()
		end
		
		function SYH:HideAllSubPanels (except)
			if (SalvageYardIgnoreFrame and except ~= "ignore") then
				SalvageYardIgnoreFrame:Hide()
			end
			if (SalvageYardSellListFrame and except ~= "autoselllist") then
				SalvageYardSellListFrame:Hide()
			end
			if (SalvageYardTransmogFrame and except ~= "transmog") then
				SalvageYardTransmogFrame:Hide()
			end
			if (SalvageYardPriceFrame and except ~= "ahprice") then
				SalvageYardPriceFrame:Hide()
			end
		end
		
		SYH.SellPanel:SetScript ("OnHide", function()
			SYH:HideAllSubPanels()
		end)

	end
	
	SYH.SellPanel:Show()
	
	if (GetAverageItemLevel() >= 890) then
		SYH.SellPanel.SellEpicHearButton:Enable()
	end

	if (only_load) then
		SYH.SellPanel:Hide()
	end
	
end

local USE_GUILD_BANK = true

local auto_repair = function()
	
	local repairAllCost, canRepair = GetRepairAllCost()
	local hasGuild, canGuildRepair = IsInGuild(), CanGuildBankRepair()
	
	--> the repair button from guild bank is enabled
	if (hasGuild and canGuildRepair and SYH.db.profile.AutoRepair_UseGuildBank) then

		local bankMoney = GetGuildBankWithdrawMoney()
		local guildBankMoney = GetGuildBankMoney()
		
		if (bankMoney > 100000) then --> probably is the guild master, since it has no limits
			bankMoney = guildBankMoney
		else
			bankMoney = min (bankMoney, guildBankMoney)
		end
		
		if (bankMoney >= repairAllCost) then
			--> full repair from guild bank
			RepairAllItems (USE_GUILD_BANK)
		else
			local RepairSlots = {
				CharacterHeadSlot,
				CharacterShoulderSlot,
				CharacterChestSlot,
				CharacterWristSlot,
				CharacterHandsSlot,
				CharacterWaistSlot,
				CharacterLegsSlot,
				CharacterFeetSlot,
				CharacterMainHandSlot,
				CharacterSecondaryHandSlot,
			}
			
			MerchantRepairItemButton:Click()

			for i, f in ipairs (RepairSlots) do
				local hasItem, hasCooldown, repairCost = tooltip_scanner:SetInventoryItem ("player", f:GetID())
				
				if (hasItem and repairCost <= GetMoney()) then
					repairAllCost = repairAllCost - repairCost
					f:Click()
					
					if (repairAllCost <= bankMoney) then
						RepairAllItems (USE_GUILD_BANK)
						break
					end
				end
			end
			MerchantRepairItemButton:Click()
		end
	
	else
		if (repairAllCost <= GetMoney()) then
			RepairAllItems()
		else
			local RepairSlots = {
				CharacterHeadSlot,
				CharacterShoulderSlot,
				CharacterChestSlot,
				CharacterWristSlot,
				CharacterHandsSlot,
				CharacterWaistSlot,
				CharacterLegsSlot,
				CharacterFeetSlot,
				CharacterMainHandSlot,
				CharacterSecondaryHandSlot,
			}
			MerchantRepairItemButton:Click()
			for i, f in ipairs (RepairSlots) do
				f:Click()
			end
			MerchantRepairItemButton:Click()
		end
	end
	
end

MerchantFrame:HookScript ("OnShow", function (self)
	SYH.MerchantWindowIsOpen = true

	if (SYH.db.profile.AutoOpenForMerchants) then
		SYH:ShowPanel()
	end
	if (SYH.db.profile.AutoSellGray) then
		SYH:Sell (true)
	end
	if (not self.OpenSYHButton) then
		self.OpenSYHButton = CreateFrame ("button", "AutoSellerOpenButton", self, "OptionsButtonTemplate")
		self.OpenSYHButton:SetSize (40, 19)
		self.OpenSYHButton:SetText ("A.S.")
		self.OpenSYHButton:SetPoint ("topright", self, "topright", -26, -1)
		self.OpenSYHButton:SetScript ("OnClick", function (self)
			SYH:ShowPanel()
		end)
		
		self.OpenSYHButton:SetScript ("OnEnter", function(self)
			GameCooltip2:Preset (2)
			GameCooltip2:SetOwner (self)
			GameCooltip2:AddLine ("Open Auto Seller Window")
			GameCooltip2:Show()
		end)
		self.OpenSYHButton:SetScript ("OnLeave", function(self)
			GameCooltip2:Hide()
		end)
		
	end
	
	--auto repait stuff
	if (SYH.db.profile.AutoRepair) then
		if (CanMerchantRepair()) then
			auto_repair()
		end
	end
end)
MerchantFrame:HookScript ("OnHide", function (self)
	if (SYH.SellPanel) then
		SYH.SellPanel:Hide()
		SYH.MerchantWindowIsOpen = nil
	end
end)



-- ~sell
function SYH:Sell (only_gray)

	if (not SYH.SellPanel) then
		SYH:ShowPanel (true)
	end

	local gray_item = 0
	local green_item = 2
	local blue_item = 3
	local epic_item = 4
	
	local sell_green = SYH.db.profile.SellGreen
	local sell_blue = SYH.db.profile.SellBlue
	local sell_epic = SYH.db.profile.SellEpic
	
	local auction_limit = SYH.db.profile.AHPriceThreshold * 10000

	local greenBlueIlevelThreshold = SYH.db.profile.SellGreenMaxLevel
	local epicItemIlevelThreshold = SYH.db.profile.SellEpicGearThreshold
	
	if (only_gray) then
		sell_green = false
		sell_blue = false
		sell_epic = false
	end
	--
	local to_sell = {}
	--
	local GetContainerNumSlots, GetContainerItemInfo, GetItemInfo, UseContainerItem = GetContainerNumSlots, GetContainerItemInfo, GetItemInfo, UseContainerItem
	--
	for backpack = 0, 4 do
		for slot = 1, GetContainerNumSlots (backpack) do 
		
			local itemId = GetContainerItemID (backpack, slot)
			if (itemId and not ignore_list [itemId]) then
				local _, amountOfItems, _, quality, _, _, itemLink = GetContainerItemInfo (backpack, slot)
				local itemName, _, _, itemLevel, _, itemType, itemSubType, _, itemEquipLoc, _, itemSellPrice = GetItemInfo(itemLink)
				local effectiveILvl, isPreview, baseILvl = GetDetailedItemLevelInfo(itemLink)
				itemLevel = effectiveILvl
				
				--> gray
				if (quality == gray_item) then
					if (not SalvageYardHDB.UserBlackList [itemName]) then
						local valor = itemSellPrice or 0
						to_sell [#to_sell+1] = {backpack, slot, valor, false, amountOfItems}
					end
				else
				
				--> any item at the sell list
					if (SalvageYardHDB.UserAutoSellList [itemName] or SalvageYardHDB.UserAutoSellList [itemLink]) then
						local valor = itemSellPrice or 0
						to_sell [#to_sell+1] = {backpack, slot, valor, true, amountOfItems}

				--> green, blue, epic
					elseif (itemName and SYH.db.profile.AllowToSell [itemEquipLoc] and not SalvageYardHDB.UserBlackList [itemName]) then
						local keyword_free = true
						local low_itemName = string.lower (itemName)
						for keyword, _ in pairs (SalvageYardHDB.UserBlackListKeyWord) do
							if (low_itemName:find (keyword)) then
								keyword_free = false
								break
							end
						end

						if (keyword_free) then
							--> green blue epic
							if ((quality == green_item and sell_green) or (quality == blue_item and sell_blue)) then
								if (SYH.SellPanel.ForceSellSoulbound or not SYH:IsSoulbound(backpack, slot)) then
									if (itemLevel > 5) then
										local auction_value = SYH:GetAuctionPrice (itemLink)
										if (auction_value < auction_limit) then
											local valor = itemSellPrice
											local case1 = (itemLevel < greenBlueIlevelThreshold) --white, green and blue
											local case2 = (valor > (SYH.db.profile.SellVendorThreshold * 10000))
											if (case1 or case2) then
												to_sell [#to_sell+1] = {backpack, slot, valor, false, amountOfItems}
											end
										else
											--print ("Can't sell ", itemName, "AH Threshold.", auction_value, " > ", auction_limit)
										end
									end
								end

							elseif (quality == epic_item and sell_epic) then
								if (itemLevel <= epicItemIlevelThreshold and itemLevel > 5 and SYH:IsSoulbound(backpack, slot)) then
									to_sell [#to_sell+1] = {backpack, slot, itemSellPrice, false, amountOfItems}
									
								--from the "shortcut" button to sell epic gear 183-197
								elseif (SYH.CanSellHighLevelEpicGear and itemLevel <= CONST_ITEMLEVEL_SELLEPICCURRENT_THRESHOLD_END and itemLevel >= CONST_ITEMLEVEL_SELLEPICCURRENT_THRESHOLD_START and SYH:IsSoulbound(backpack, slot)) then
									to_sell [#to_sell+1] = {backpack, slot, itemSellPrice, false, amountOfItems}
								end
							end
						end
					end
				end
			end
		end
	end
	
	SYH.CanSellHighLevelEpicGear = false
	
	SYH.SellGoldAmount = 0
	SYH.SellPanel.ProgressBar.value = 0
	SYH.TotalItems = #to_sell
	SYH.SellPanel.ProgressBar.shown = true
	
	if (SYH.SellThreadExec) then
		SYH:CancelTimer (SYH.SellThreadExec)
	end
	
	SYH.SellThreadExec = SYH:ScheduleRepeatingTimer ("SellThread", 0.2, to_sell)
end

function SYH:SellThread (item_list)

	--make sure the vendor window is opened, or the addon will equip the gear instead of sell
	if (not SYH.MerchantWindowIsOpen) then
		SYH:SellingFinished()
		return
	end

	local item = tremove (item_list)
	
	if (not item) then
		return SYH:SellingFinished()
	end

	UseContainerItem (item[1], item[2])
	
	local total_value = item[3] * (item[5] or 1)
	SYH.SellGoldAmount = SYH.SellGoldAmount + total_value
	
	if (item [4]) then
		--auto sell list message
	end
	
	SYH.SellPanel.ProgressBar.value = abs (#item_list-SYH.TotalItems) / SYH.TotalItems * 100
	
	if (#item_list == 0) then
		SYH:SellingFinished()
	end
end

function SYH:SellingFinished()
	if (type (SYH.SellGoldAmount) == "number" and SYH.SellGoldAmount > 0) then
		SYH:Msg (L["STRING_TOTALSOLD"] .. ": " .. GetCoinText (SYH.SellGoldAmount) .. ".")
	end
	SYH.SellPanel.ProgressBar.shown = false
	SYH:CancelTimer (SYH.SellThreadExec)
	SYH.SellThreadExec = nil
end

SLASH_SYH1 = "/syh"
SLASH_SYH2 = "/autoseller"
SLASH_SYH3 = "/as"

function SlashCmdList.SYH (msg, editbox)
	local command, rest = msg:match ("^(%S*)%s*(.-)$")

	SYH:Msg ("|cFF00FF00" ..version .. "|r")

	SYH:ShowPanel()
end
