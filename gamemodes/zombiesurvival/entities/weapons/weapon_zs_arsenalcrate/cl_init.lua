include("shared.lua")

SWEP.PrintName = "Arsenal Crate"
SWEP.Description = "This crate is invaluable to survival. It allows people to purchase new weapons, tools, ammunition, etc.\nThe deployer gets a 7% commission on purchases not made by themselves.\nPress PRIMARY ATTACK to deploy the crate.\nPress SECONDARY ATTACK and RELOAD to rotate the crate."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.ViewModelFOV = 60

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
	
	local w, h = ScrW(), ScrH()	
	draw.RoundedBox( 12, w * 0.855, h * 0.9, w * 0.09, h * 0.09, Color(1, 1, 1, 100) )	
	
	surface.SetFont("ZSHUDFont")
	local text = translate.Get("supplies") --WTF, ok yea sort this out..
	local nTEXW, nTEXH = surface.GetTextSize(text)
	
	draw.SimpleText(translate.Get("supplies"), "ZSHUDFont2", ScrW() - nTEXW * 1.01 - 100, ScrH() - nTEXH * 2.5, COLOR_GREY, TEXT_ALIGN_CENTER)

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
