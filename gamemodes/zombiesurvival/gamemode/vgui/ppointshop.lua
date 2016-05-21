local function pointslabelThink(self)
	local points = MySelf:GetPoints()
	if self.m_LastPoints ~= points then
		self.m_LastPoints = points

		--self:SetText("SP:  "..points)
		self:SetText("Current amount of skillPoints:  "..points)
		self:SizeToContents()
	end
end


hook.Add("Think", "PointsShopThink", function()
	local pan = GAMEMODE.m_PointsShop
	if pan and pan:Valid() and pan:IsVisible() then
		local newstate = not GAMEMODE:GetWaveActive()
		if newstate ~= pan.m_LastNearArsenalCrate then
		
			pan.m_LastNearArsenalCrate = newstate
			pan.m_DiscountLabel:SizeToContents()
			pan.m_DiscountLabel:AlignRight(8)
			
		end

		local mx, my = gui.MousePos()
		local x, y = pan:GetPos()
		if mx < x - 16 or my < y - 16 or mx > x + pan:GetWide() + 16 or my > y + pan:GetTall() + 16 then
			pan:SetVisible(false)
			surface.PlaySound("items/ammocrate_close.wav")
		end
	end
end)

local function PointsShopCenterMouse(self)
	local x, y = self:GetPos()
	local w, h = self:GetSize()
	gui.SetMousePos(x + w * 0.5, y + h * 0.5)
end

local ammonames = {
	["pistol"] = "pistolammo",
	["buckshot"] = "shotgunammo",
	["smg1"] = "smgammo",
	["ar2"] = "assaultrifleammo",
	["357"] = "rifleammo",
	["XBowBolt"] = "crossbowammo"
}

local warnedaboutammo = CreateClientConVar("_zs_warnedaboutammo", "0", true, false)
local function PurchaseDoClick(self)
	if not warnedaboutammo:GetBool() then
		local itemtab = FindItem(self.ID)
		if itemtab and itemtab.SWEP then
			local weptab = weapons.GetStored(itemtab.SWEP)
			if weptab and weptab.Primary and weptab.Primary.Ammo and ammonames[weptab.Primary.Ammo] then
				RunConsoleCommand("_zs_warnedaboutammo", "1")
				Derma_Message("Be sure to buy extra ammo. Weapons purchased do not contain any extra ammo!", "Warning")
			end
		end
	end

	RunConsoleCommand("zs_pointsshopbuy", self.ID)
end

local function BuyAmmoDoClick(self)
	RunConsoleCommand("zs_pointsshopbuy", "ps_"..self.AmmoType)
end

local function worthmenuDoClick()
	MakepWorth()
	GAMEMODE.m_PointsShop:Close()
end

local function ItemPanelThink(self)
	local itemtab = FindItem(self.ID)
	if itemtab then
		local newstate = MySelf:GetPoints() >= math.ceil(itemtab.Worth * (GAMEMODE.m_PointsShop.m_LastNearArsenalCrate and GAMEMODE.ArsenalCrateMultiplier or 1)) and not (itemtab.NoClassicMode and GAMEMODE:IsClassicMode())
		if newstate ~= self.m_LastAbleToBuy then
			self.m_LastAbleToBuy = newstate
			if newstate then
				self:AlphaTo(255, 0.75, 0)
				self.m_NameLabel:SetTextColor(COLOR_WHITE)
				self.m_BuyButton:SetText("BUY!")
			else
				self:AlphaTo(90, 0.75, 0)
				self.m_NameLabel:SetTextColor(COLOR_WHITE)
				self.m_BuyButton:SetText("BUY!")
			end

			self.m_BuyButton:SizeToContents()
		end
	end
end

local function PointsShopThink(self)
	if GAMEMODE:GetWave() ~= self.m_LastWaveWarning and not GAMEMODE:GetWaveActive() and CurTime() >= GAMEMODE:GetWaveStart() - 10 and CurTime() > (self.m_LastWaveWarningTime or 0) + 11 then
		self.m_LastWaveWarning = GAMEMODE:GetWave()
		self.m_LastWaveWarningTime = CurTime()

		surface.PlaySound("ambient/alarms/klaxon1.wav")
		timer.Simple(0.6, function() surface.PlaySound("ambient/alarms/klaxon1.wav") end)
		timer.Simple(1.2, function() surface.PlaySound("ambient/alarms/klaxon1.wav") end)
		timer.Simple(2, function() surface.PlaySound("vo/npc/male01/zombies02.wav") end)
	end
end

function GM:OpenPointsShop()
	if self.m_PointsShop and self.m_PointsShop:Valid() then
		self.m_PointsShop:SetVisible(true)
		self.m_PointsShop:CenterMouse()
		surface.PlaySound("items/ammocrate_open.wav")
		return
	end

	local wid, hei = 650, math.max(ScrH() * 0.5, 500)
	
	local SCREEN_W = 1280; --For the screen resolution scale. This means that it can be fit exactly on the screen without any issues.
	local SCREEN_H = 720;
	local X_MULTIPLIER = ScrW( ) / SCREEN_W;
	local Y_MULTIPLIER = ScrH( ) / SCREEN_H;

	local frame = vgui.Create("DFrame")
	frame:SetSize(wid, hei)
	frame:Center()
	frame:SetBackgroundBlur( true ) 
	frame:SetDeleteOnClose(false)
	frame:SetTitle(" ")
	frame:SetDraggable(false)
		if frame.btnClose and frame.btnClose:Valid() then frame.btnClose:SetVisible(false) end
		if frame.btnMinim and frame.btnMinim:Valid() then frame.btnMinim:SetVisible(false) end
		if frame.btnMaxim and frame.btnMaxim:Valid() then frame.btnMaxim:SetVisible(false) end
	frame.CenterMouse = PointsShopCenterMouse
	frame.Think = PointsShopThink
	self.m_PointsShop = frame

	local topspace = vgui.Create("DPanel", frame)
	topspace:SetWide(wid - 16)
	topspace.Paint = function( self, w, h ) 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 1, 0, 0, 300 ) ) 
	end

	local title = EasyLabel(topspace, "SkillPoint Shop", "ZSHUDFontSmall", COLOR_WHITE)
	title:CenterHorizontal()
	title.Paint = function( self, w, h ) 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 1, 0, 0, 150 ) )
	end
	
	local subtitle2 = EasyLabel(topspace, translate.Format("x_discount_for_buying_between_waves", self.ArsenalCrateDiscountPercentage), "ZSHUDFontTiny", COLOR_WHITE)
	subtitle2:CenterHorizontal()
	subtitle2:MoveBelow(title, 8)
	subtitle2.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 1, 0, 0, 150 ) ) 
	end
	
	local _, y = subtitle2:GetPos()
	topspace:SetTall(y + subtitle2:GetTall() + 4)
	topspace:AlignTop(8)
	topspace:CenterHorizontal()

	local bottomspace = vgui.Create("DPanel", frame)
	bottomspace:SetWide(topspace:GetWide())
	bottomspace.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h * 1.2, Color( 1, 0, 0, 300 ) ) 
	end


	local pointslabel = EasyLabel(bottomspace, "Current amount of SkillPoints: 0", "ZSHUDFontSmall", COLOR_WHITE)
	pointslabel:AlignTop(4)
	pointslabel:AlignLeft(8)
	pointslabel.Think = pointslabelThink
	
	local Button = vgui.Create( "DButton", bottomspace )
	Button:SetText( "Close" )
	Button:SetFont( "ZSHUDFontSmall" )
	Button:SetTextColor( Color( 255, 255, 255 ) )
	Button:AlignTop(4)
	Button:AlignRight(60)
	--Button:SetPos( 100, 100 )
	Button:SetSize( 100, 40 )
	Button.DoClick = function(Button)
		GAMEMODE.m_PointsShop:Close()
	end
--	Button.Paint = function( self, w, h )
	--	draw.RoundedBox( 0, 0, 0, w, h, COLOR_DARKRED ) -- Draw a blue button
--	end

	
	local lab = EasyLabel(bottomspace, " ", "ZSHUDFontTiny")
	lab:AlignTop(4)
	lab:AlignRight(4)
	frame.m_DiscountLabel = lab

	local _, y = lab:GetPos()
	bottomspace:SetTall(y + lab:GetTall() + 25)
	bottomspace:AlignBottom(10)
	bottomspace:CenterHorizontal()

	local topx, topy = topspace:GetPos()
	local botx, boty = bottomspace:GetPos()

	local propertysheet = vgui.Create("DPropertySheet", frame)
	propertysheet:SetSize(wid - 8, boty - topy - 8 - topspace:GetTall())
	propertysheet:MoveBelow(topspace, 4)
	propertysheet:CenterHorizontal()
	propertysheet.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 1, 0, 0, 300 ) ) 
	end

	local isclassic = GAMEMODE:IsClassicMode()

	for catid, catname in ipairs(GAMEMODE.ItemCategories) do

		local hasitems = false
		for i, tab in ipairs(GAMEMODE.Items) do
			if tab.Category == catid and tab.PointShop then
				hasitems = true
				break
			end
		end

		if hasitems then
			local list = vgui.Create("DPanelList", propertysheet)
			list:SetPaintBackground(false)
			propertysheet:AddSheet(catname, list, GAMEMODE.ItemCategoryIcons[catid], false, false)
			list:EnableVerticalScrollbar(true)
			list:SetWide(propertysheet:GetWide() - 16)
			list:SetSpacing(2)
			list:SetPadding(2)

			for i, tab in ipairs(GAMEMODE.Items) do
				if tab.Category == catid and tab.PointShop then
					local itempan = vgui.Create("DPanel")
					itempan:SetSize(list:GetWide(), 60)
					itempan.ID = tab.Signature or i
					itempan.Think = ItemPanelThink
					list:AddItem(itempan)

					if tab.SWEP or tab.Countables then
						local counter = vgui.Create("ItemAmountCounter", itempan)
						counter:SetItemID(i)
					end

					local name = tab.Name or ""
					local namelab = EasyLabel(itempan, name, "ZSHUDFont", COLOR_WHITE)
					namelab:SetPos(10, itempan:GetTall() * 0.5 - namelab:GetTall() * 0.5)
					itempan.m_NameLabel = namelab


					
					local mdlframe = vgui.Create("DPanel", itempan)
					mdlframe:SetSize(60, 40)
					mdlframe:SetPos(itempan:GetWide() - 40 - mdlframe:GetWide(), itempan:GetTall() -53 )
					mdlframe.Paint = function( self, w, h ) 
						draw.RoundedBox( 0, 0, 0, w, h, Color( 1, 0, 0, 150 ) )
					end
					
					local button = vgui.Create("DButton", itempan)
					button:SetPos(itempan:GetWide() - 20 - button:GetWide(), itempan:GetTall() - 40)
					button:SetSize( 200, 150 )
					button.ID = itempan.ID
					button.DoClick = PurchaseDoClick
					itempan.m_BuyButton = button
					
					local weptab = weapons.GetStored(tab.SWEP) or tab

					
					if weptab and weptab.Primary then
						local ammotype = weptab.Primary.Ammo
						if ammonames[ammotype] then
						
							local ammobutton = vgui.Create("DButton", itempan)
							ammobutton:SetText("AMMO!")
							ammobutton:SizeToContents()
							ammobutton:CopyPos(button)
							ammobutton:MoveLeftOf(button, 42)
							ammobutton:SetTooltip("Purchase ammunition")
							ammobutton.AmmoType = ammonames[ammotype]
							ammobutton.DoClick = BuyAmmoDoClick
							
						end
					end			

					local pricelab = EasyLabel(itempan, tostring(tab.Worth).." SP", "ZSHUDFont", COLOR_RED)
					pricelab:SetPos(itempan:GetWide() - 190 - pricelab:GetWide(), 11)
					itempan.m_PriceLabel = pricelab

					if tab.Description then
						itempan:SetTooltip(tab.Description)
					end

					if tab.NoClassicMode and isclassic or tab.NoZombieEscape and GAMEMODE.ZombieEscape then
						itempan:SetAlpha(120)
					end
				end
			end
		end
	end

	frame:MakePopup()
	frame:CenterMouse()
end
GM.OpenPointShop = GM.OpenPointsShop
