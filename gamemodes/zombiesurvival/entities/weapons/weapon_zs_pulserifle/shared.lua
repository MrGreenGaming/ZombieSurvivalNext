-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Pulse Rifle"
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55
	SWEP.IconLetter = "2"
	SWEP.SelectFont = "HL2MPTypeDeath"
	killicon.AddFont("weapon_zs_pulserifle", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	
	SWEP.ViewModelBoneMods = {
	["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["Pulse Rifle"] = { type = "Model", model = "models/props_combine/bunker_gun01.mdl", bone = "Base", rel = "", pos = Vector(2.28, 13.729, 8.642), angle = Angle(83.805, -79.391, -2.488), size = Vector(0.898, 0.898, 0.898), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Pulse Rifle2"] = { type = "Model", model = "models/weapons/c_arms_refugee.mdl", bone = "Base", rel = "", pos = Vector(22.896, -22.743, -0.116), angle = Angle(67.13, 86.931, -3.781), size = Vector(0.799, 0.799, 0.799), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
	
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/c_IRifle.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_IRifle.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Airboat.FireGunHeavy")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 16.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 45
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 45
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"


SWEP.ConeMax = 0.08
SWEP.ConeMin = 0.015



SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.MaxBulletDistance 		= 2900 -- Uses pulse power, FTW!
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.WalkSpeed = SPEED_SMG
SWEP.fired = false
SWEP.lastfire = 0
SWEP.rechargetimer = 0
SWEP.rechargerate = 0.40
SWEP.startcharge = 1
SWEP.MaxClip = 50

SWEP.IronSightsPos = Vector(-3, 16, 3)

function SWEP:Think()
	if SERVER then
		local ply = self.Owner
		
		if ply:KeyDown(IN_ATTACK) then
			if not self.fired then
				self.fired = true
			end

			self.lastfire = CurTime()
		else
			if (CurTime() - self.startcharge) > self.lastfire and CurTime() > self.rechargetimer then
				self.Weapon:SetClip1(math.min(self.MaxClip, self.Weapon:Clip1() + 1))
				self.rechargerate = 0.1
				self.rechargetimer = CurTime() + self.rechargerate 
			end
			if self.fired then 
				self.fired = false
			end
		end
	end

	return self.BaseClass.Think(self)
end

function SWEP:Reload()
	return false
end