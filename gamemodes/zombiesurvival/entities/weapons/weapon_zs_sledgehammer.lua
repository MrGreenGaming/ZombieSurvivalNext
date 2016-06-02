AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Sledgehammer"
	SWEP.ViewModelFOV = 75
	

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true

	SWEP.VElements = {
		["sledge"] = { type = "Model", model = "models/weapons/w_sledgehammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.144, 1.421, 8.611), angle = Angle(0, 0, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

--SWEP.ViewModel = "models/weapons/v_sledgehammer/v_sledgehammer.mdl"
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_sledgehammer.mdl"

SWEP.MeleeDamage = 95
SWEP.MeleeRange = 64
SWEP.MeleeSize = 1.75
--SWEP.MeleeKnockBack = SWEP.MeleeDamage * 1.2

SWEP.Primary.Delay = 1.3

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.SwingRotation = Angle(60, 0, -80)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingTime = 0.75
SWEP.SwingHoldType = "melee"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(35, 45))
end

function SWEP:PlayHitSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(86, 90))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.Rand(86, 90))
end
