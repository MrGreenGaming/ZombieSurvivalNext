include("shared.lua")

SWEP.PrintName = "Spot Lamp"
SWEP.Description = "This lamp is a watchful eye which illuminates an area.\nPress PRIMARY ATTACK to deploy.\nPress SECONDARY ATTACK and RELOAD to rotate."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:DrawHUD()

	local w, h = ScrW(), ScrH()
	draw.RoundedBox( 12, w * 0.85, h * 0.9, w * 0.11, h * 0.09, Color(1, 1, 1, 100) )
	
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
	
	surface.SetFont("ZSHUDFont")
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleText("Spot", "ZSHUDFont", ScrW() - nTEXW * 0.4 - 24, ScrH() - nTEXH * 2, nails > 0 and COLOR_GREY or COLOR_GREY, TEXT_ALIGN_CENTER)
	draw.SimpleText("Lamp", "ZSHUDFont", ScrW() - nTEXW * 0.4 - 24, ScrH() - nTEXH * 1.2, nails > 0 and COLOR_GREY or COLOR_GREY, TEXT_ALIGN_CENTER)

end

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:Think()
	if self.Owner:KeyDown(IN_ATTACK2) then
		self:RotateGhost(FrameTime() * 60)
	end
	if self.Owner:KeyDown(IN_RELOAD) then
		self:RotateGhost(FrameTime() * -60)
	end
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

local nextclick = 0
function SWEP:RotateGhost(amount)
	if nextclick <= RealTime() then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = RealTime() + 0.3
	end
	RunConsoleCommand("_zs_ghostrotation", math.NormalizeAngle(GetConVarNumber("_zs_ghostrotation") + amount))
end
