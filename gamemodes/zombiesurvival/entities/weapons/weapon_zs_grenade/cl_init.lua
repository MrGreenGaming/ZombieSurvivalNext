include("shared.lua")

SWEP.PrintName = "Grenade"
SWEP.Description = "A simple fragmentation grenade.\nWhen used in the right conditions, it can obliterate groups of zombies."

SWEP.ViewModelFOV = 60

SWEP.Slot = 4
SWEP.SlotPos = 0

--[[function SWEP:GetViewModelPosition(pos, ang)
	if self:GetPrimaryAmmoCount() <= 0 then
		return pos + ang:Forward() * -256, ang
	end

	return pos, ang
end]]


function SWEP:DrawHUD()

	
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
	
	
	local screenscale = BetterScreenScale()
	local wid, hei = 256, 0
	local x, y = ScrW() - wid - 32, ScrH() - hei - 30
	local texty = y - 4 - draw.GetFontHeight("ZSHUDFont2")
	local nails = self:GetPrimaryAmmoCount()
	
	draw.SimpleText("Grenade", "ZSHUDFont2", x, texty, COLOR_GREY, TEXT_ALIGN_LEFT)
	draw.SimpleText(nails, "ZSHUDFont2", x * 1.13, texty, COLOR_GREY, TEXT_ALIGN_LEFT)

	
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
