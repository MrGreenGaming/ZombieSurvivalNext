include("shared.lua")

SWEP.PrintName = "Grenade"
SWEP.Description = "A simple fragmentation grenade.\nWhen used in the right conditions, it can obliterate groups of zombies."

SWEP.ViewModelFOV = 60

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:DrawHUD()

	local screenscale = BetterScreenScale()
	local wid, hei = 256, 0
	--local x, y = ScrW() - wid - 32, ScrH() - hei - 30
	local x, y = ScrW() - wid - 10, ScrH() - hei - 30
	local texty = y - 4 - draw.GetFontHeight("ZSHUDFont2")
	local nails = self:GetPrimaryAmmoCount()
	local w, h = ScrW(), ScrH()
	draw.RoundedBox( 12, w * 0.855, h * 0.9, w * 0.11, h * 0.09, Color(1, 1, 1, 100) )
	
	draw.SimpleText("Grenade", "ZSHUDFont2", x, texty - 7, COLOR_GREY, TEXT_ALIGN_LEFT)
	draw.SimpleText(nails, "ZSHUDFont2", x * 1.1, texty - 7, COLOR_GREY, TEXT_ALIGN_LEFT)

	
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
