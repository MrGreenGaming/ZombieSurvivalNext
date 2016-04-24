include("shared.lua")

SWEP.PrintName = "Mobile Supplies"
SWEP.Description = "Allows survivors to get ammunition for their current weapon. Each person can only use the box once every so often.\nPress PRIMARY ATTACK to deploy the box.\nPress SECONDARY ATTACK and RELOAD to rotate the box."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.ViewModelFOV = 60

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	--self:DrawCrosshairDot()
	
	local hudsplat3 = Material("hud/hud_bottom_right.png") --Items for the HUD.

	local w, h = ScrW(), ScrH()
	
	surface.SetMaterial(hudsplat3)
	surface.SetDrawColor(225, 225, 225, 200 )
	surface.DrawTexturedRect(w * 0.84, h * 0.89, w * 0.15, h * 0.1)
	
	
	surface.SetFont("ZSHUDFont2")
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleText("Mobile", "ZSHUDFont2", ScrW() - nTEXW * 0.4 - 24, ScrH() - nTEXH * 2.4, nails > 0 and COLOR_GREY or COLOR_GREY, TEXT_ALIGN_CENTER)
	draw.SimpleText("Supplies", "ZSHUDFont2", ScrW() - nTEXW * 0.4 - 24, ScrH() - nTEXH * 1.6, nails > 0 and COLOR_GREY or COLOR_GREY, TEXT_ALIGN_CENTER)

	
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
