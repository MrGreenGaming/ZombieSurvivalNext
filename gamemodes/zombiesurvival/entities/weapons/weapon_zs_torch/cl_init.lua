include("shared.lua")

SWEP.PrintName = "Blow Torch"
SWEP.Description = "Heals Nails and metal based items!"

SWEP.DrawAmmo = false

function SWEP:DrawHUD()
	if GetGlobalBool("classicmode") then return end

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
	
	
	--surface.SetFont("ZSHUDFont")
	--local text = translate.Get("right_click_to_hammer_nail")
	--local nails = self:GetPrimaryAmmoCount()
	--local nTEXW, nTEXH = surface.GetTextSize(text)

	--draw.SimpleText(translate.Format("nails_x", nails), "ZSHUDFont2", ScrW() - nTEXW * 0.4 - 80, ScrH() - nTEXH * 2, nails > 0 and COLOR_GREY or COLOR_GREY, TEXT_ALIGN_CENTER)
	
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
