include("shared.lua")

SWEP.PrintName = "Gun Turret"
SWEP.Description = "This automated turret requires constant upkeep to be useful.\nPress PRIMARY ATTACK to deploy the turret.\nPress SECONDARY ATTACK and RELOAD to rotate the turret.\nPress USE on a deployed turret to give it some of your SMG ammunition.\nPress USE on a deployed turret with no owner (blue light) to reclaim it."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

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
	

	surface.SetFont("ZSHUDFont2")
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleText("Turret", "ZSHUDFont2", ScrW() - nTEXW * 0.4 - 24, ScrH() - nTEXH * 1.5, nails > 0 and COLOR_GREY or COLOR_GREY, TEXT_ALIGN_CENTER)


	
end

function SWEP:Deploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:DrawWorldModel()
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel

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

local nextclick = 0
function SWEP:RotateGhost(amount)
	if nextclick <= RealTime() then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = RealTime() + 0.3
	end
	RunConsoleCommand("_zs_ghostrotation", math.NormalizeAngle(GetConVarNumber("_zs_ghostrotation") + amount))
end
