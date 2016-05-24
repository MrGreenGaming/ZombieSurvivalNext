AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "HATE"

	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.075, 1.075, 1.075), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.488, 1.488, 1.488), pos = Vector(0, 0, 0), angle = Angle(-4.139, -1.862, 1.238) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.343, 1.343, 1.343), pos = Vector(0, 0, 0), angle = Angle(-3.389, 0.075, 1.312) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(-3.701, 0.425, -0.288), angle = Angle(0, 0, 0) },
	-- ["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.58, 5.205, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.213, 1.213, 1.213), pos = Vector(0, 0, 0), angle = Angle(-0.151, -20.414, -7.045) }
}
SWEP.VElements = {
	["chainsaw1"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.486, -0.45, 1.5), angle = Angle(19.399, 88.293, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["chainsaw2"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(105.176, 75.518, 4.875), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
	
SWEP.WElements = {
	["chainsaw2"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.638, 0.55, 0.737), angle = Angle(23.18, 94.875, -8.094), size = Vector(1.519, 1.519, 1.519), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["chainsaw"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.711, 3.444, -0.389), angle = Angle(-179.851, 118.38, -10.521), size = Vector(1.519, 1.519, 1.519), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	}

end


SWEP.Base = "weapon_zs_zombie_boss"


SWEP.DamageType = DMG_SLASH

SWEP.ViewModel = "models/weapons/v_pza.mdl"
SWEP.WorldModel = "models/weapons/w_chainsaw.mdl"

--SWEP.NoDroppedWorldModel = true

SWEP.MeleeDamage = 90
SWEP.MeleeRange = 60
SWEP.MeleeSize = 0.875
SWEP.MeleeDelay = 1.5
SWEP.MeleeAnimationDelay = 0.35
SWEP.Primary.Delay = 1.5
SWEP.FrozenWhileSwinging = true

SWEP.WalkSpeed = SPEED_FAST

--SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HitDecal = "Manhackcut"
SWEP.HitAnim = ACT_VM_MISSCENTER

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/chainsaw_gore_0"..math.random(1,4)..".wav", 72, math.Rand(85, 95))
			self.IdleAnimation = CurTime() + self:SequenceDuration()

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP:PlaySwingSound()
	self:EmitSound(Sound("zombies/hate/chainsaw_attack_miss.wav"),math.random(150,160),math.random(95,100))
		self.IdleAnimation = CurTime() + self:SequenceDuration()

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/melee/chainsaw_gore_0"..math.random(1,4)..".wav")
			self.IdleAnimation = CurTime() + self:SequenceDuration()

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent:Health() <= 0 then
		-- Dismember closest limb to tr.HitPos
	end
			self.IdleAnimation = CurTime() + self:SequenceDuration()

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end