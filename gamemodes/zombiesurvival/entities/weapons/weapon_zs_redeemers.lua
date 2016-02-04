AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Duel Elites"
	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.slide_right"
	SWEP.HUD3DPos = Vector(1, 0.1, -1)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "duel"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_ELITE.Single")
SWEP.Primary.Damage = 7
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 150

SWEP.ConeMax = 0.055
SWEP.ConeMin = 0.05

SWEP.IronSightsPos = Vector(-0, 1.213, 1.019)
SWEP.IronSightsAng = Vector(0, 0, 0)


function SWEP:SecondaryAttack()
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:Clip1() % 2 == 0 and ACT_VM_PRIMARYATTACK or ACT_VM_SECONDARYATTACK)
end


-- KF style Ironsights :D
if CLIENT then
local vec = 1
function SWEP:Think()
	if self:GetIronsights() == true then 
		--[[vec = math.Approach(vec, 1.631, FrameTime())
		self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"].scale = Vector(vec,vec,vec)
		self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].scale = Vector(vec,vec,vec)]]
		self.ViewModelBoneMods = {
["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-4.817, 2.815, 4.35), angle = Angle(0, 0, 0) },
["v_weapon.elite_right"] = { scale = Vector(1, 1, 1), pos = Vector(-4.224, 3.921, 4.008), angle = Angle(0, 0, 0) },
["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-5.11, 2.927, -3.945), angle = Angle(0, 0, 0) },
["v_weapon.elite_left"] = { scale = Vector(1, 1, 1), pos = Vector(-3.757, -4, 3.895), angle = Angle(0, 0, 0) }
}
	elseif self:GetIronsights() == false or self.Weapon:Clip1() <= 1 then
		--[[vec = math.Approach(vec,1, FrameTime())
		self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"].scale = Vector(vec,vec,vec)
		self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].scale = Vector(vec,vec,vec)]]
		self.ViewModelBoneMods = {}
	end
end
end
--[==[
function SWEP:OnDeploy()
	
	self.Owner:StopAllLuaAnimations()
	self.Owner:SetLuaAnimation("ElitesHoldtype")

	if CLIENT then
		MakeNewArms(self)
	end
	
end

function SWEP:Holster()
	self:SetIronsights( false ) 
	self.Owner:StopLuaAnimation("ElitesHoldtype") 
	
	
	return true
end

function SWEP:OnRemove()

    self.Owner:StopLuaAnimation("ElitesHoldtype")     

    if CLIENT then
        self:RemoveModels()
		
		RemoveNewArms(self)
    end
end
]==]
--Register the animation------------
--[[
RegisterLuaAnimation('ElitesHoldtype', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 39,
					RR = 360,
					RF = 55
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 5
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RF = 5
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -10,
					RR = -31,
					RF = 10
				}
			},
			FrameRate = 1
		}
	},
	Type = TYPE_POSTURE
})]]--
