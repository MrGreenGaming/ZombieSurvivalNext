AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Five-SeveN"
	SWEP.Description = "Fast and percise, this is the pistol for the highly skilled!" --SWEP.Description = "This high-powered handgun has the ability to pierce through multiple zombies. The bullet's power decreases by half which each zombie it hits."
	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

--	SWEP.HUD3DBone = "v_weapon.Deagle_Slide"
--	SWEP.HUD3DPos = Vector(-1, 0, 1)
--	SWEP.HUD3DAng = Angle(0, 0, 0)
--	SWEP.HUD3DScale = 0.015

	--SWEP.IronSightsPos = Vector(-6.35, 5, 1.7)
	
	SWEP.IronSightsPos = Vector(-5.9,17,2.5)
	SWEP.IronSightsAng = Vector( 0, 0, 0 )
	
	--killicon.AddFont("weapon_zs_fiveseven", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	SWEP.IgnoreThumbs = true
	--SWEP.FlipYaw = true
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_pist_fiveseven.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_pist_fiveseven.mdl" )

SWEP.Primary.Sound = Sound("Weapon_FiveSeven.Single")
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.15
SWEP.Primary.KnockbackScale = 2

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 60

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"

SWEP.ConeMax = 0.1
SWEP.ConeMin = 0.04

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.018, 0.238, 1.363), angle = Angle(-90, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.51, 1.358, -6.229), angle = Angle(0, -3.432, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end