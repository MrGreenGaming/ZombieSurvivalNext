hook.Add("SetWave", "CloseWorthOnWave1", function(wave)
	if wave > 0 then
		if pWorth and pWorth:Valid() then
			pWorth:Close()	
		end

		hook.Remove("SetWave", "CloseWorthOnWave1")
	end
end)

local cvarDefaultCart = CreateClientConVar("zs_defaultcart", "", true, false)

local function DefaultDoClick(btn)
	if cvarDefaultCart:GetString() == btn.Name then
		RunConsoleCommand("zs_defaultcart", "")
		surface.PlaySound("buttons/button11.wav")
	else
		RunConsoleCommand("zs_defaultcart", btn.Name)
		surface.PlaySound("buttons/button14.wav")
	end

	timer.Simple(0.1, MakepWorth)
end

local WorthRemaining = 0
local WorthButtons = {}
local function CartDoClick(self, silent, force)
	local id = self.ID
	local tab = FindStartingItem(id)
	if not tab then return end

	if self.On then
		self.On = nil
		--self:SetImage("icon16/cart_add.png")
		if not silent then
			surface.PlaySound("buttons/button18.wav")
		end
		self:SetTooltip("Add to cart")
		WorthRemaining = WorthRemaining + tab.Worth
	else
		if WorthRemaining < tab.Worth and not force then
			surface.PlaySound("buttons/button8.wav")
			return
		end
		self.On = true
		self:SetImage("icon16/cart_delete.png")
		if not silent then
			surface.PlaySound("buttons/button17.wav")
		end
		self:SetTooltip("Remove from cart")
		WorthRemaining = WorthRemaining - tab.Worth
	end

	pWorth.WorthLab:SetText("Worth: ".. WorthRemaining)
	if WorthRemaining <= 0 then
		pWorth.WorthLab:SetTextColor(COLOR_RED)
	elseif WorthRemaining <= GAMEMODE.StartingWorth * 0.25 then
		pWorth.WorthLab:SetTextColor(COLOR_YELLOW)
	else
		pWorth.WorthLab:SetTextColor(COLOR_LIMEGREEN)
	end
	pWorth.WorthLab:SizeToContents()
end

local function Checkout(tobuy)
	if tobuy and #tobuy > 0 then
		gamemode.Call("SuppressArsenalUpgrades", 1)

		RunConsoleCommand("worthcheckout", unpack(tobuy))

		if pWorth and pWorth:Valid() then
			pWorth:Close()
		end
	else
		surface.PlaySound("buttons/combine_button_locked.wav")
	end
	
	
end

local function CheckoutDoClick(self)
	local tobuy = {}
	for _, btn in pairs(WorthButtons) do
		if btn and btn.On and btn.ID then
			table.insert(tobuy, btn.ID)
		end
	end


	Checkout(tobuy)
end

function MakepWorth(id)
	if pWorth and pWorth:Valid() then
		pWorth:Remove()
		pWorth = nil
	end
	
	if pWorth2 and pWorth2:Valid() then
		pWorth2:Remove()
		pWorth2 = nil
	end

	local maxworth = GAMEMODE.StartingWorth
	WorthRemaining = maxworth

	local SCREEN_W = 1920; --For the screen resolution scale. This means that it can be fit exactly on the screen without any issues.
	local SCREEN_H = 1080;
	local X_MULTIPLIER = ScrW( ) / SCREEN_W;
	local Y_MULTIPLIER = ScrH( ) / SCREEN_H;

	local wid, hei = 350 * X_MULTIPLIER, 900 * Y_MULTIPLIER
	local wid2, hei2 = math.min(ScrW(), 240), math.min(ScrH())
	local wid3, hei3 = math.min(ScrW(), 100), math.min(ScrH(), 520)
	local w, h = ScrW(), ScrH()
		
	
	local frame = vgui.Create("DFrame")
	pWorth = frame
	
	frame:SetPos(wid * 2, hei * 2)
	frame:SetSize(wid * 3, hei)
	
	frame:SetDeleteOnClose(true)
	frame:SetKeyboardInputEnabled(true)
	frame:SetDraggable( false ) 
	frame:ShowCloseButton( false ) 
	frame:SetTitle("")
	frame.Paint = function()
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 28, 28, 28, 300 ) ) --Debug
	end
	
	local Panel = vgui.Create("DPanel",frame)
	Panel:SetPos( w * 0.05, h * 0.13 )
	Panel:SetSize( w * 0.2, h * 0.52 )
	Panel.Paint = function( self, w, h ) 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 28, 28, 28, 300 ) )
	end
	
	local Panel2 = vgui.Create("DPanel",frame)
	Panel2:SetPos( w * 0.295, h * 0.13 )
	Panel2:SetSize( w * 0.2, h * 0.52 )
	Panel2.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 28, 28, 28, 300 ) ) 
	end

	
	local Panel3 = vgui.Create("DPanel",frame)
	Panel3:SetPos( w * 0.05, h * 0.01 )
	Panel3:SetSize( w * 0.445, h * 0.11 )
	Panel3.Paint = function( self, w, h ) 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 28, 28, 28, 300 ) ) 
	end

	
	local Panel4 = vgui.Create("DPanel",frame)
	Panel4:SetPos( w * 0.17, h * 0.66 )
	Panel4:SetSize( w * 0.2, h * 0.11 )
	Panel4.Paint = function( self, w, h ) 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 28, 28, 28, 300 ) ) 
	end
	

	
	local MrGreen = vgui.Create( "DLabel", Panel3 )
	MrGreen:SetPos( 0, 0 )
	MrGreen:SetSize( w * 0.22, h * 0.2 )
	MrGreen:SetFont("ZSHUDFont2")
	MrGreen:Center()
	MrGreen:SetText("Mr.Green Zombie Survival")	
		
	local MrGreen2 = vgui.Create( "DLabel", Panel3 )
	MrGreen2:SetPos(  w * 0.15, h * 0.001 )
	MrGreen2:SetSize( w * 0.22, h * 0.2 )
	MrGreen2:SetFont("ZSHUDFontSmallest")
	MrGreen2:SetText("https://mrgreengaming.com/forums/")	

	local ClassInfo = vgui.Create( "DLabel", Panel2 )
	--ClassInfo:SetPos(  w * 0.01, h * 0.001 )
	ClassInfo:SetPos(  wid * 0.01, - 80)
	ClassInfo:SetSize( w * 0.22, h * 0.2 )
	ClassInfo:SetFont("ZSHUDFont2")
	ClassInfo:SetText("Information:")
	
	local LoadOut = vgui.Create( "DLabel", Panel2 )
	LoadOut:SetPos(  w * 0.01, h * 0.006 )
	LoadOut:SetSize( w * 0.22, h * 0.2 )
	LoadOut:SetFont("ZSHUDFont")
	LoadOut:SetText("Loadout:")
	
	local Staff = vgui.Create( "DLabel", Panel2 )
	Staff:SetPos(  w * 0.01, h * 0.205 )
	Staff:SetSize( w * 0.22, h * 0.2 )
	Staff:SetFont("ZSHUDFont")
	Staff:SetText(" Staff:")
	
	local Staff2 = vgui.Create( "DLabel", Panel2 )
	Staff2:SetPos(  w * 0.01, h * 0.3 )
	Staff2:SetSize( w * 0.22, h * 0.2 )
	Staff2:SetFont("ZSHUDFontSmall")
	Staff2:SetText(" Owner: Ywa \n Coder: Duby \n Manager: Damien \n MapManager: Reiska \n Graphics Director: Gheii-Ben \n Model Maker: BrainDawg")

	local propertysheet = vgui.Create("DPropertySheet", Panel)
	propertysheet:StretchToParent(4, 24, 4, 50)
	propertysheet:SetKeyboardInputEnabled(true)
	propertysheet.Paint = function()
	end

	local panfont = "ZSHUDFontSmall"
	local panhei = 40



	local defaultcart = cvarDefaultCart:GetString()

	
	for catid, catname in ipairs(GAMEMODE.ItemCategoryIcons2) do

		local list = vgui.Create("DPanelList", propertysheet)
		
		list:SetPaintBackground(false)
		propertysheet:AddSheet(catname, list, GAMEMODE.ItemCategoryIcons[catid], false, false)
		list:EnableVerticalScrollbar(false)
		list:SetSpacing(50)
		list:SetPadding(1)
		list:SizeToContents()
	--	list:SetPos( w * 0.295, h * 0.13 )
	--	list:SetSize( w * 0.2, h * 0.52 )
		list.Paint = function( self, w, h ) 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 1, 0, 0, 1 ) )
		end

			--self.ID = id
			local tab = FindStartingItem(id)
			local self = LocalPlayer()

		for i, tab in ipairs(GAMEMODE.Items) do
			if tab.Category == catid and tab.WorthShop then
				local button = vgui.Create("ZSWorthButton")
				button:SetWorthID(i)
				list:AddItem(button)
				
				local DLabel = vgui.Create( "DLabel", Panel2 )
					  DLabel:SetPos(  w * 0.01, h * 0.02)
					  DLabel:SetSize( 400, 400 )
					  DLabel:SetFont("ZSHUDFontSmall")
					  DLabel:SetText("")
				button.OnCursorEntered = function()
					surface.PlaySound( "mrgreen/ui/menu_accept.wav" )
					DLabel:SetText(tab.Description)	
				end
				
				button.OnCursorExited = function()
					DLabel:SetText("")
				end

				
				WorthButtons[i] = button
			end
		end
	end
	
	local w, h = ScrW(), ScrH()

	
	frame:Center()
	frame:AlphaTo(225, 0.5, 0)
	frame:MakePopup()
	frame:SizeToContents()

	local checkout = vgui.Create("DButton",Panel4)
	checkout:SetFont("ZSHUDFont3")
	checkout:SetText("SPAWN")
	checkout:SetSize(w * 0.2, h * 0.2)
	checkout:SetPos(0,0)
	checkout:Center()
	checkout.DoClick = function()
		CheckoutDoClick()
	end
		
	if CHRISTMAS then
		timer.Simple(2, function()
			surface.PlaySound( "mrgreen/music/gamestart_new_christmas_1.wav" )
		end)
	else
		surface.PlaySound(Sound("mrgreen/music/gamestart_new"..math.random(1,2)..".mp3")) --Move this else where....
	end
	return frame, frame2, Panel
	
end

local PANEL = {}
PANEL.m_ItemID = 0
PANEL.RefreshTime = 1
PANEL.NextRefresh = 0

function PANEL:Init()
	self:SetFont("DefaultFontSmall")
end

function PANEL:Think()
	if CurTime() >= self.NextRefresh then
		self.NextRefresh = CurTime() + self.RefreshTime
		self:Refresh()
	end
end

function PANEL:Refresh()
	local count = GAMEMODE:GetCurrentEquipmentCount(self:GetItemID())
	if count == 0 then
		self:SetText(" ")
	else
		self:SetText(count)
	end

	self:SizeToContents()
end

function PANEL:SetItemID(id) self.m_ItemID = id end
function PANEL:GetItemID() return self.m_ItemID end

vgui.Register("ItemAmountCounter", PANEL, "DLabel")

PANEL = {}

function PANEL:Init()

	self:SetText("")

	self:DockPadding(4, 4, 4, 4)
	self:SetTall(48)

	self.NameLabel = EasyLabel(self, "", "ZSHUDFontSmall")
	self.NameLabel:SetContentAlignment(4)
	self.NameLabel:Dock(FILL)


	self.ItemCounter = vgui.Create("ItemAmountCounter", self)

	self:SetWorthID(nil)
end

function PANEL:SetWorthID(id)
	self.ID = id

	local tab = FindStartingItem(id)

	if not tab then
		self.ItemCounter:SetVisible(false)
		self.NameLabel:SetText("")
		return
	end

	local mdl = tab.Model or (weapons.GetStored(tab.SWEP) or tab).WorldModel

	if tab.SWEP or tab.Countables then
		self.ItemCounter:SetItemID(id)
		self.ItemCounter:SetVisible(false)
	else
		self.ItemCounter:SetVisible(false)
	end
	
	if tab.NoClassicMode and GAMEMODE:IsClassicMode() or tab.NoZombieEscape and GAMEMODE.ZombieEscape then
		self:SetAlpha(120)
	else
		self:SetAlpha(255)
	end

	self.NameLabel:SetText(tab.Name or "")
end

function PANEL:Paint(w, h)
	local outline	
	
	if self.Hovered then
		outline = self.On and COLOR_DARKGREEN or Color(0, 100, 0, 255)
	else
		outline = self.On and COLOR_DARKGREEN or Color(100, 0, 0, 255)
	end

	draw.RoundedBox(10, 0, 0, w, h, outline)

	
end

function PANEL:DoClick(silent, force)
	local id = self.ID
	local tab = FindStartingItem(id)
	if not tab then return end
	
	if self.On then
		self.On = nil
		if not silent then
			surface.PlaySound("mrgreen/ui/menu_click01.wav")
		end
		WorthRemaining = WorthRemaining + tab.Worth
	else
		if WorthRemaining < tab.Worth and not force then
			surface.PlaySound("mrgreen/ui/menu_click01.wav")
			return
		end
		self.On = true
		if not silent then
			surface.PlaySound("mrgreen/ui/menu_click01.wav")
		end
		WorthRemaining = WorthRemaining - tab.Worth
	end

end

vgui.Register("ZSWorthButton", PANEL, "DButton")
