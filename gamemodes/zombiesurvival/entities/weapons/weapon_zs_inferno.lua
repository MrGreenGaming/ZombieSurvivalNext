AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Inferno' AUG"
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = true
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.aug_Parent"
	SWEP.HUD3DPos = Vector(-1, -2.5, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_aug.mdl"
SWEP.WorldModel = "models/weapons/w_rif_aug.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_AUG.Single")
SWEP.Primary.Damage = 23
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.095

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 0.08
SWEP.ConeMin = 0.02

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsAng = Vector(-1, -1, 0)
SWEP.IronSightsPos = Vector(-3, 4, 3)

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.aug_Parent", rel = "", pos = Vector(0.731, -0.322, 21.634), angle = Angle(-86.223, 90, 0), size = Vector(0.5, 0.5, 1.34), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.575, 1.294, -3.518), angle = Angle(91.344, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end