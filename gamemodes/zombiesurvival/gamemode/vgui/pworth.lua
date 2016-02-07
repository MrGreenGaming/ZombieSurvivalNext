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

local function RandDoClick(self)
	gamemode.Call("SuppressArsenalUpgrades", 1)

	RunConsoleCommand("worthrandom")

	if pWorth and pWorth:Valid() then
		pWorth:Close()
	end
end

--GM.SavedCarts = {}
--hook.Add("Initialize", "LoadCarts", function()
	--if file.Exists(GAMEMODE.CartFile, "DATA") then
		--GAMEMODE.SavedCarts = Deserialize(file.Read(GAMEMODE.CartFile)) or {}
	--end
--end)

local function ClearCartDoClick()
	for _, btn in ipairs(WorthButtons) do
		if btn.On then
			btn:DoClick(true, true)
		end
	end

	surface.PlaySound("buttons/button11.wav")
end

--local function LoadCart(cartid, silent)
	--[[if GAMEMODE.SavedCarts[cartid] then
		MakepWorth()
		for _, id in pairs(GAMEMODE.SavedCarts[cartid][2]) do
			for __, btn in pairs(WorthButtons) do
				if btn and (btn.ID == id or GAMEMODE.Items[id] and GAMEMODE.Items[id].Signature == btn.ID) then
					btn:DoClick(true, true)
				end
			end
		end
		if not silent then
			surface.PlaySound("buttons/combine_button1.wav")
		end
	end]]--
--end

local function LoadDoClick(self)
	LoadCart(self.ID)
end

local function SaveCurrentCart(name)
	local tobuy = {}
	for _, btn in pairs(WorthButtons) do
		if btn and btn.On and btn.ID then
			table.insert(tobuy, btn.ID)
		end
	end
	--[[for i, cart in ipairs(GAMEMODE.SavedCarts) do
		if string.lower(cart[1]) == string.lower(name) then
			cart[1] = name
			cart[2] = tobuy

			file.Write(GAMEMODE.CartFile, Serialize(GAMEMODE.SavedCarts))
			print("Saved cart "..tostring(name))

			LoadCart(i, true)
			return
		end
	end]]--

	--GAMEMODE.SavedCarts[#GAMEMODE.SavedCarts + 1] = {name, tobuy}

	--file.Write(GAMEMODE.CartFile, Serialize(GAMEMODE.SavedCarts))
	--print("Saved cart "..tostring(name))

	--LoadCart(#GAMEMODE.SavedCarts, true)
end

local function SaveDoClick(self)
	Derma_StringRequest("Save cart", "Enter a name for this cart.", "Name", 
	function(strTextOut) SaveCurrentCart(strTextOut) end,
	function(strTextOut) end,
	"OK", "Cancel")
end

local function DeleteDoClick(self)
	--[[if GAMEMODE.SavedCarts[self.ID] then
		table.remove(GAMEMODE.SavedCarts, self.ID)
		file.Write(GAMEMODE.CartFile, Serialize(GAMEMODE.SavedCarts))
		surface.PlaySound("buttons/button19.wav")
		MakepWorth()
	end]]--
end

local function QuickCheckDoClick(self)
	--[[if GAMEMODE.SavedCarts[self.ID] then
		Checkout(GAMEMODE.SavedCarts[self.ID][2])
	end]]--
end

function MakepWorth()
	if pWorth and pWorth:Valid() then
		pWorth:Remove()
		pWorth = nil
	end

	
	local maxworth = GAMEMODE.StartingWorth
	WorthRemaining = maxworth

	
	local SCREEN_W = 1280;
	local SCREEN_H = 720;
	local X_MULTIPLIER = ScrW( ) / SCREEN_W;
	local Y_MULTIPLIER = ScrH( ) / SCREEN_H;

	local wid, hei = 250 * X_MULTIPLIER, 800 * Y_MULTIPLIER
	local wid2, hei2 = math.min(ScrW(), 240), math.min(ScrH())
	
	local frame = vgui.Create("DFrame")
	pWorth = frame

	frame:SetPos(wid2, hei2)
	frame:SetSize(wid, hei)
	
	frame:SetDeleteOnClose(true)
	frame:SetKeyboardInputEnabled(false)
	frame:SetDraggable( false ) 
	frame:ShowCloseButton( false ) 
	frame:SetTitle("")
	frame.Paint = function()
	end

	local propertysheet = vgui.Create("DPropertySheet", frame)
	propertysheet:StretchToParent(4, 24, 4, 50)
	propertysheet.Paint = function()
	end

	local panfont = "ZSHUDFontSmall"
	local panhei = 40

	local defaultcart = cvarDefaultCart:GetString()

	--[[--for i, savetab in ipairs(GAMEMODE.SavedCarts) do
		local cartpan = vgui.Create("DEXRoundedPanel")
		cartpan:SetCursor("pointer")
		cartpan:SetSize(list:GetWide(), panhei)

		local cartname = savetab[1]

		local x = 8

		list:AddItem(cartpan)
	end]]--
	
	for catid, catname in ipairs(GAMEMODE.ItemCategoryIcons2) do

		local list = vgui.Create("DPanelList", propertysheet)
		
		list:SetPaintBackground(false)
		propertysheet:AddSheet(catname, list, GAMEMODE.ItemCategoryIcons[catid], false, false)
		list:EnableVerticalScrollbar(false)
		list:SetSpacing(50)
		list:SetPadding(1)
		list:SizeToContents()
		list.Paint = function( self, w, h ) 
			draw.RoundedBox( 0, 0, 0, w, h, Color( 1, 0, 0, 1 ) )
		end



		for i, tab in ipairs(GAMEMODE.Items) do
			if tab.Category == catid and tab.WorthShop then
				local button = vgui.Create("ZSWorthButton")
				button:SetWorthID(i)
				list:AddItem(button)
				
				button.OnCursorEntered = function()
					surface.PlaySound( "mrgreen/ui/menu_accept.wav" )
				end

				
				WorthButtons[i] = button
			end
		end
	end


	frame:Center()
	frame:AlphaTo(225, 0.5, 0)
	frame:MakePopup()
	frame:SizeToContents()
	
	
	local checkout = vgui.Create("DButton",frame)
	checkout:SetFont("ZSHUDFont2")
	checkout:SetText("SPAWN")
	checkout:SetSize(130, 30)
	checkout:SetPos(80 * X_MULTIPLIER, 370 * Y_MULTIPLIER)
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
	return frame 
	
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


	self:SetTooltip(tab.Description)

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
		outline = self.On and COLOR_GREEN or Color(100, 0, 0, 255)
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
