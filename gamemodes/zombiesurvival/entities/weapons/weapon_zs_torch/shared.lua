AddCSLuaFile("shared.lua")

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_CLUB


if CLIENT then
    SWEP.NailTextDrawDistance = 170

	SWEP.ViewModelFOV = 40
	
    SWEP.ShowViewModel = false
    SWEP.ShowWorldModel = false
    SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false 
	 
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.694, 0, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.382, 0, 0) },
		["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0.118, 0.861, 1.106), angle = Angle(7.105, -8.9, 1.98) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.788, 9.413, 7.656) }
	}
	

	SWEP.VElements = {
		["valve"] = { type = "Model", model = "models/props_pipes/valvewheel002.mdl", bone = "ValveBiped.Bip01", rel = "att", pos = Vector(-0.125, 0.187, -3.281), angle = Angle(-95.838, -159.644, 1.031), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["att"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01", rel = "body", pos = Vector(-0.125, -0.064, 1.406), angle = Angle(0, -67.95, -180), size = Vector(0.375, 0.375, 0.375), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.224, 2.581, -1.195), angle = Angle(3.413, -94.12, 180), size = Vector(0.331, 0.331, 0.28), color = Color(125, 125, 125, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["valve"] = { type = "Model", model = "models/props_pipes/valvewheel002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "att", pos = Vector(-0.125, 0.187, -3.281), angle = Angle(-95.838, -159.644, 1.031), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["att"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body", pos = Vector(-0.125, -0.064, 1.406), angle = Angle(0, -67.95, -180), size = Vector(0.375, 0.375, 0.375), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.017, 2.075, -1.231), angle = Angle(-10.108, -98.139, -152.969), size = Vector(0.331, 0.331, 0.28), color = Color(125, 125, 125, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.ViewModel = "models/Weapons/c_grenade.mdl"
SWEP.WorldModel = "models/Weapons/w_grenade.mdl"
SWEP.UseHands = true
SWEP.DrawAmmo = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "GaussEnergy"
SWEP.Primary.Delay = 0.04
SWEP.Primary.DefaultClip = -1

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.MeleeDamage = 35

SWEP.NoPropThrowing = true

--SWEP.HitGesture = ACT_INVALID
SWEP.HitGesture = false
SWEP.MissGesture = false
--SWEP.MissGesture = SWEP.HitGesture


SWEP.HealStrength = 0.06

SWEP.NoHolsterOnCarry = true

function SWEP:PlaySwingSound()
	self:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav",math.random(0,0),math.random(0,0))
end

function SWEP:PlayHitSound()
	self:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav",math.random(86,110),math.random(86,110))
end

function SWEP:PlayRepairSound(hitent)
	hitent:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav",math.random(86,110),math.random(86,110))
end
