include("shared.lua")

SWEP.PrintName = "Grenade"
SWEP.Description = "A simple fragmentation grenade.\nWhen used in the right conditions, it can obliterate groups of zombies."

SWEP.ViewModelFOV = 60

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:DrawHUD()

	local w, h = ScrW(), ScrH()
	local hudsplat3 = Material("hud/hud_bottom_right.png") --Items for the HUD.
	
	surface.SetMaterial(hudsplat3)
	surface.SetDrawColor(225, 225, 225, 200 )
	surface.DrawTexturedRect(w * 0.84, h * 0.89, w * 0.15, h * 0.1)
	
	local screenscale = BetterScreenScale()
	local wid, hei = 256, 0
	local x, y = ScrW() - wid - 32, ScrH() - hei - 30
	local texty = y - 4 - draw.GetFontHeight("ZSHUDFont2")
	local nails = self:GetPrimaryAmmoCount()
	
	draw.SimpleText("Grenade", "ZSHUDFont2", x, texty - 7, COLOR_GREY, TEXT_ALIGN_LEFT)
	draw.SimpleText(nails, "ZSHUDFont2", x * 1.13, texty - 7, COLOR_GREY, TEXT_ALIGN_LEFT)

	
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
