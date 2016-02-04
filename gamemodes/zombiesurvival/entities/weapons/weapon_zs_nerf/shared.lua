SWEP.Base = "weapon_zs_zombie"


SWEP.PrintName = "Nerf"
if CLIENT then
	SWEP.ViewModelFOV = 80
	SWEP.ViewModelFlip = false
	
	
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 75.605, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 49.916, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 20.795, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.007, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(-0.923, 0, -0.608), angle = Angle(-16.098, -16.886, 3.661) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.409, 0), angle = Angle(-13.473, 4.796, -47.446) },
	["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 99.51, 0) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 18.854, 0) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 75.922, 0) },
	["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 40.652, 0) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.76, 0) },
	["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 73.269, 0) },
	["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 61.735, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.185, 1.73, 41.8) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 74.68, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 22.555, 0) },
	["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 48.576, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -6.368, 0) },
	["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 54.191, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 38.962, 0) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 44.536, 0) }
}		
	
end

SWEP.MeleeReach = 48
SWEP.MeleeDelay = 0.55
SWEP.MeleeSize = 1.5
SWEP.MeleeDamage = 30
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeAnimationDelay = 0.05
SWEP.FrozenWhileSwinging = true

SWEP.Primary.Delay = 1.5

SWEP.ViewModel = Model("models/Weapons/v_fza.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

function SWEP:CheckMoaning()
end

function SWEP:StopMoaningSound()
end

function SWEP:StartMoaningSound()
end

function SWEP:PlayHitSound()
	self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav", 75, 80)
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("npc/antlion/attack_double1.wav", 75, 80)
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/antlion/attack_double1.wav")
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav", 75, 140)
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:SetSwingAnimTime(time)
	self:SetDTFloat(3, time)
end

function SWEP:GetSwingAnimTime()
	return self:GetDTFloat(3)
end

function SWEP:StartSwinging()
	self.BaseClass.StartSwinging(self)
	self:SetSwingAnimTime(CurTime() + 1)
end

function SWEP:PrimaryAttack()
	if self.Owner:IsOnGround() then self.BaseClass.PrimaryAttack(self) end
end
