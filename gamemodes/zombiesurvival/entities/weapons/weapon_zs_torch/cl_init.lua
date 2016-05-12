include("shared.lua")

SWEP.PrintName = "Blow Torch"
SWEP.Description = "Heals Nails and metal based items!"

SWEP.DrawAmmo = false

function SWEP:DrawHUD()
	if GetGlobalBool("classicmode") then return end

	local w, h = ScrW(), ScrH()	
	draw.RoundedBox( 12, w * 0.85, h * 0.9, w * 0.11, h * 0.09, Color(1, 1, 1, 100) )
	
	surface.SetFont("ZSHUDFont") --Sort this shit out
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)
	
	draw.SimpleText(" Blow Torch", "ZSHUDFont2", ScrW() - nTEXW * 0.15 - 150, ScrH() - nTEXH * 2.5, COLOR_GREY, TEXT_ALIGN_CENTER)

	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
