include("shared.lua")

SWEP.PrintName = "Message Beacon"
SWEP.Description = "This beacon allows you to display messages to all other humans in range.\nPress SECONDARY ATTACK to select different messages.\nPress PRIMARY ATTACK to deploy.\nPress SPRINT on a deployed message beacon that you own to pick it up."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0



function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

function SWEP:DrawHUD()

	
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()

end

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:Think()
end

local function okclick(self)
	RunConsoleCommand("setmessagebeaconmessage", self:GetParent().Choice)
	self:GetParent():Close()
end

local function onselect(self, index, value, data)
	self:GetParent().Choice = data
end

local Menu
function SWEP:SecondaryAttack()
	if Menu and Menu:Valid() then
		Menu:SetVisible(true)
		return
	end

	Menu = vgui.Create("DFrame")
	Menu:SetDeleteOnClose(false)
	Menu:SetSize(200, 100)
	Menu:SetTitle("Select a message")
	Menu:Center()
	Menu.Choice = 1

	local choice = vgui.Create("DComboBox", Menu)
	for k, v in ipairs(GAMEMODE.ValidBeaconMessages) do
		choice:AddChoice(translate.Get(v), k)
	end
	choice:ChooseOption(GAMEMODE.ValidBeaconMessages[1], 1)
	choice:SizeToContents()
	choice:SetWide(Menu:GetWide() - 16)
	choice:Center()
	choice.OnSelect = onselect

	local ok = EasyButton(Menu, "OK", 8, 4)
	ok:AlignBottom(8)
	ok:CenterHorizontal()
	ok.DoClick = okclick

	Menu:MakePopup()
end

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
	
	local hudsplat3 = Material("hud/hud_bottom_right.png") --Items for the HUD.
	
	local Hud_Image_3 = {
		color 		= Color( 225, 225, 225, 400 ); -- Color overlay of image; white = original color of image
		material 	= Material("hud/hud_bottom_right.png"); -- Material to be used
		x 			= 1600; -- x coordinate for the material to be rendered ( mat is drawn from top left to bottom right )
		y 			= 980; -- y coordinate for the material to be rendered ( mat is drawn from top left to bottom right )
		w 			= 320; -- width of the material to span
		h 			= 100; -- height of the material to span
	};
	
	surface.SetMaterial(hudsplat3)
	surface.SetDrawColor(225, 225, 225, 200 )
	surface.DrawTexturedRect(Hud_Image_3.x, Hud_Image_3.y, Hud_Image_3.w, Hud_Image_3.h)
	
	
	surface.SetFont("ZSHUDFont")
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleText("Message", "ZSHUDFont", ScrW() - nTEXW * 0.4 - 24, ScrH() - nTEXH * 2, nails > 0 and COLOR_GREY or COLOR_GREY, TEXT_ALIGN_CENTER)
	draw.SimpleText("Becon", "ZSHUDFont", ScrW() - nTEXW * 0.4 - 24, ScrH() - nTEXH * 1.2, nails > 0 and COLOR_GREY or COLOR_GREY, TEXT_ALIGN_CENTER)

end
