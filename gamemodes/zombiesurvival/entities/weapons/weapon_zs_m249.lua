-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "M249"			
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 2
	SWEP.SlotPos = 0
	SWEP.ViewModelFOV = 60
	SWEP.FlipYaw = true
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model("models/weapons/cstrike/c_mach_m249para.mdl")
SWEP.UseHands = true
SWEP.WorldModel			= Model("models/weapons/w_mach_m249para.mdl")

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_M249.Single")
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 22
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 100
SWEP.Primary.Delay			= 0.085
SWEP.Primary.DefaultClip	= 400
SWEP.MaxAmmo			    = 500
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.FirePower = (SWEP.Primary.Damage * SWEP.Primary.ClipSize)

SWEP.Cone = 0.049
SWEP.ConeMoving = SWEP.Cone * 1.1
SWEP.ConeCrouching = SWEP.Cone * 0.9
SWEP.ConeIron = SWEP.Cone *0.9
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.9
--SWEP.ConeIronMoving = SWEP.Moving *0.9


SWEP.WalkSpeed = SPEED_SLOW
SWEP.MaxBulletDistance = 2450

SWEP.IronSightsPos = Vector(-5.9, 19, 2)
SWEP.IronSightsAng = Vector(0, 0, 0)


SWEP.OverridePos = Vector(-1.601, -1.311, 1.6)
SWEP.OverrideAng = Vector( 0,0,0 )