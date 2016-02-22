AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Butcher Knife"

	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1.202, 1.202, 1.202), pos = Vector(-1.769, -1.145, 0.032), angle = Angle(18.652, -69.49, -13.641) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0.151, 0.326, 0), angle = Angle(-7.047, -33.475, 50.738) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-2.948, 0, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.038, -0.75), angle = Angle(0, -27.199, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(-2.964, -0.269, 0.695), angle = Angle(7.298, 0, 0) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.775, -25.341, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-0.06, -4.65, -2.939), angle = Angle(-13.061, 0.861, -20.26) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.325, 1.347, 1.348), pos = Vector(2.046, 0, 0), angle = Angle(8.331, 2.536, -22.885) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(-2.993, 0.177, -0.108), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-15.4, 1.141, -62.826) },
	["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -14.27) }
}
	
	SWEP.VElements = {
--	["Behemoth1"] = { type = "Model", model = "models/weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-8.29, -12.447, 1.335), angle = Angle(-4.758, 129.942, -25.379), size = Vector(1.917, 1.917, 1.917), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
		["Behemoth1"] = { type = "Model", model = "models/weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 2, 0), angle = Angle(90.758, 129.942, 0.379), size = Vector(1.917, 1.917, 1.917), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["bone1+"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(3.127, 5.98, 4.98), angle = Angle(78.624, 121.805, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["bone1"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(3.489, 6.668, -4.731), angle = Angle(109.05, 121.805, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["eye1"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "skull", pos = Vector(4.406, 2.168, 1.33), size = { x = 13, y = 13 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["skull"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(10.206, -0.014, 0.361), angle = Angle(-180, -93.051, -91.457), size = Vector(1.605, 1.605, 1.605), color = Color(211, 211, 211, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["crowbar"] = { type = "Model", model = "models/Weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.857, 0.418, 1.325), angle = Angle(0, -107.212, -97.001), size = Vector(1.5, 1.715, 1.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["eye1+"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "skull", pos = Vector(4.406, -2.438, 1.33), size = { x = 13, y = 13 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	} 
end

SWEP.Base = "weapon_zs_zombie_boss"

SWEP.DamageType = DMG_SLASH

SWEP.ViewModel = "models/weapons/v_zombine.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.NoDroppedWorldModel = true

SWEP.MeleeDamage = 90
SWEP.MeleeRange = 60
SWEP.MeleeSize = 0.875
SWEP.MeleeDelay = 0.9
SWEP.MeleeAnimationDelay = 0.35
SWEP.Primary.Delay = 1.5


SWEP.WalkSpeed = SPEED_FAST

SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HitDecal = "Manhackcut"
SWEP.HitAnim = ACT_VM_MISSCENTER

function SWEP:PlayHitSound()
	self:EmitSound("zombies/behemoth/hitflesh.wav", 72, math.Rand(85, 95))
			self.IdleAnimation = CurTime() + self:SequenceDuration()

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP:PlaySwingSound()
	self:EmitSound(Sound("zombies/behemoth/swing.wav"),math.random(150,160),math.random(95,100))
		self.IdleAnimation = CurTime() + self:SequenceDuration()

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("zombies/behemoth/hitflesh.wav")
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