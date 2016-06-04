AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "USP"
	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DPos = Vector(-0.95, 0, 1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DBone = "v_weapon.USP_Slide"
	killicon.AddFont( "weapon_zs_usp", "CSKillIcons", "a", Color(255, 255, 255, 255 ) )
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_USP.Single")
SWEP.Primary.Damage = 17.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.2

--SWEP.SDPS ()= 1,020
--(SWEP.Damage x Clipsize / Delay)

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.IronSightsPos = Vector(-9.5, 12, 4.3)

SWEP.ConeMax = 0.07
SWEP.ConeMin = 0.025
