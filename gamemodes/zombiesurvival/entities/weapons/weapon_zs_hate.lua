AddCSLuaFile()



SWEP.PrintName = "HATE"

SWEP.ViewModelFOV = 45
SWEP.Base = "weapon_zs_zombie"
SWEP.Author = "Duby 'based on NECROSSIN's original creation'"
SWEP.Instructions = "Slice up those Humans!"

if CLIENT then
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	
	
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.343, 1.343, 1.343), pos = Vector(0, 0, 0), angle = Angle(-16.043, 20.868, -15.419) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.462, 1.462, 1.462), pos = Vector(0, 0, 0), angle = Angle(0, 3.68, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 1.419, -10.006), angle = Angle(0, 14.248, 12.737) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.406, 1.406, 1.406), pos = Vector(0, 0, 0), angle = Angle(-2.5, -26.681, 9.494) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(4.4, -0.888, -3.712), angle = Angle(-4.75, 2.081, 0.675) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -3.675, 0), angle = Angle(-0.445, -3.039, 19.518) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1.263, 1.263, 1.263), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1.156, 1.156, 1.156), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.55, 1.069, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(0.518, 0.518, 0.518), pos = Vector(0, 0, 0), angle = Angle(0, -3.294, -5.969) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1.179, 1.179, 1.179), pos = Vector(0, 0, 0), angle = Angle(19.468, 16.761, -3.776) }
}
	
SWEP.VElements = {
	["chainsaw"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.368, -2.464, 1.712), angle = Angle(4.574, 93.4, 0), size = Vector(1.088, 1.088, 1.088), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
	
SWEP.WElements = {}

	
end

SWEP.MeleeReach = 48
SWEP.MeleeDelay = 0.9
SWEP.MeleeSize = 1.5
SWEP.MeleeDamage = 80
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeAnimationDelay = 0.35

SWEP.Primary.Delay = 1.4

SWEP.ViewModel = "models/weapons/v_pza.mdl"
SWEP.WorldModel = "models/weapons/w_chainsaw.mdl"





function SWEP:Initialize()
	--self:HideViewAndWorldModel()
	

	--self.BaseClass.Initialize(self)
	--self.Owner:EmitSound("weapons/melee/chainsaw_idle.wav")
	
	--timer.Simple(2, function()
		--self.Owner:EmitSound("weapons/melee/chainsaw_start_0"..math.random(1,2)..".wav")
	--end)
	
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end


function SWEP:PlayHitSound()
	self.Owner:EmitSound("player/zombies/hate/chainsaw_attack_hit.wav", 75, 80)
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("player/zombies/hate/chainsaw_attack_miss.wav", 75, 80)
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("weapons/melee/chainsaw_gore_0"..math.random(1,4)..".wav", 75, 80)
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("ambient/machines/slicer1.wav", 100, math.random( 90, 110 ) )
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound


function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end
