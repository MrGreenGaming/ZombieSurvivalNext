include("shared.lua")

SWEP.PrintName = "Blow Torch"
SWEP.Description = "Heals Nails and metal based items!"

SWEP.DrawAmmo = false

function SWEP:DrawHUD()
	if GetGlobalBool("classicmode") then return end

	local hudsplat3 = Material("hud/hud_bottom_right.png") --Items for the HUD.
	local w, h = ScrW(), ScrH()

	surface.SetMaterial(hudsplat3)
	surface.SetDrawColor(225, 225, 225, 200 )
	surface.DrawTexturedRect(w * 0.84, h * 0.89, w * 0.15, h * 0.1)
	
		surface.SetFont("ZSHUDFont") --Sort this shit out
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)
	
	draw.SimpleText("Torch", "ZSHUDFont2", ScrW() - nTEXW * 0.2 - 150, ScrH() - nTEXH * 2.7, COLOR_GREY, TEXT_ALIGN_CENTER)

	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
