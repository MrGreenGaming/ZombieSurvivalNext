if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "physgun"

if CLIENT then
	SWEP.PrintName = "Flak Cannon"			
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.ViewModelFlip = false
	
	SWEP.HUDFont 	= "HL2HUDIcons"
	SWEP.IconLetter = ","
	--killicon.AddFont("gr_weapon_flakcannon", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
	--killicon.AddMaterial( "gr_weapon_flakcannon", "killicon/gunrun/flakcannon", Color(255, 80, 0, 255 ))
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	SWEP.ViewModelBonescales = {["Doodad_1"] = Vector(0.009, 0.009, 0.009), ["Doodad_2"] = Vector(0.009, 0.009, 0.009), ["Doodad_3"] = Vector(0.009, 0.009, 0.009), ["Doodad_4"] = Vector(0.009, 0.009, 0.009)}
	
	SWEP.VElements = {
		["train"] = { type = "Model", model = "models//props_combine/CombineTrain01a.mdl", bone = "Base", pos = Vector(-0.069, 5.063, -12.844), angle = Angle(90, -90, 0), size = Vector(0.028, 0.028, 0.028), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["labthing1"] = { type = "Model", model = "models//props_lab/rotato.mdl", bone = "Base", pos = Vector(2.312, -0.164, -2.5), angle = Angle(0, 0, -90), size = Vector(0.15, 3.029, 0.15), color = Color(220, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["gear"] = { type = "Model", model = "models/Mechanics/gears/gear12x12.mdl", bone = "Base", pos = Vector(0.206, 2.019, 1.713), angle = Angle(0, 12, 0), size = Vector(0.55, 0.55, 0.55), color = Color(75, 90, 90, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["engine"] = { type = "Model", model = "models//props_c17/TrapPropeller_Engine.mdl", bone = "Base", pos = Vector(1.2, -1.163, -3.363), angle = Angle(3.305, -90, 0), size = Vector(0.4, 0.4, 0.27), color = Color(140, 200, 200, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["afterburner"] = { type = "Model", model = "models/XQM/afterburner1.mdl", bone = "Base", pos = Vector(0, 2.963, 22.961), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(80, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["train"] = { type = "Model", model = "models//props_combine/CombineTrain01a.mdl", pos = Vector(1.792, -1.239, -10), angle = Angle(0, 9.649, 13.619), size = Vector(0.021, 0.021, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["afterburner"] = { type = "Model", model = "models/XQM/afterburner1.mdl", pos = Vector(25.013, -3.113, -5.669), angle = Angle(-90.97, 21, 7.781), size = Vector(0.4, 0.4, 0.349), color = Color(80, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["physgun"] = { type = "Model", model = "models/weapons/w_physics.mdl", pos = Vector(2.607, 1.455, -3.843), angle = Angle(-3.658, 12.137, -163.265), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} },
		["gear"] = { type = "Model", model = "models/Mechanics/gears/gear12x12.mdl", pos = Vector(14.543, -1.675, -5.224), angle = Angle(-0.306, -80.345, -95.1), size = Vector(0.444, 0.444, 0.444), color = Color(75, 90, 90, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["engine"] = { type = "Model", model = "models//props_c17/TrapPropeller_Engine.mdl", pos = Vector(10.593, -0.644, -8.77), angle = Angle(108.888, 88.574, 100.788), size = Vector(0.349, 0.349, 0.25), color = Color(140, 200, 200, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel			= "models/weapons/w_physics.mdl"

SWEP.ViewModelFOV = 52

SWEP.Primary.Sound			= Sound( "weapons/python/flak.wav" )
SWEP.Primary.ExplosionSound	= Sound( "weapons/explode3.wav" )
SWEP.Primary.Recoil			= 10
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 0.25

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Automatic		= true

SWEP.Primary.Cone			= 0.04
SWEP.Primary.ConeMoving		= 0.045
SWEP.Primary.ConeCrouching	= 0.035

SWEP.MuzzleAttachment		= "muzzle"
SWEP.MuzzleEffect			= "highcal"
SWEP.MuzzleEffectScale 		= 2
SWEP.ShellEffect			= "none" // has its own 

SWEP.WeaponType				= "primary"

SWEP.UseIronSights 			= false

PrecacheParticleSystem( "door_explosion_flash" )
PrecacheParticleSystem( "door_explosion_chunks" )
PrecacheParticleSystem( "warp_shield_impact" )
PrecacheParticleSystem( "grenade_explosion_01e" )
PrecacheParticleSystem( "door_explosion_smoke" )

function SWEP:OnBulletCallback( attacker, tr, dmginfo )

	if !(tr.Hit) then return end
	
	WorldSound( self.Primary.ExplosionSound, tr.HitPos, 85, 150+math.random(0,20) )

	util.ExplosionDamage( self.Weapon, self.Owner, tr.HitPos, self.Primary.Damage, 100 )
	
	ParticleEffect("door_explosion_flash",tr.HitPos,Angle(0,0,0),nil)
	ParticleEffect("door_explosion_chunks",tr.HitPos,Angle(0,0,0),nil)
	ParticleEffect("grenade_explosion_01e",tr.HitPos,Angle(0,0,0),nil)
	ParticleEffect("warp_shield_impact",tr.HitPos,Angle(0,0,0),nil)
	
	ParticleEffect("door_explosion_smoke",tr.HitPos,Angle(0,0,0),nil)
	ParticleEffect("door_explosion_smoke",tr.HitPos,Angle(0,0,0),nil)
	
end

if CLIENT then

	SWEP.DefaultPoleZ = SWEP.VElements["labthing1"].pos.z

	function SWEP:OnInitialize()
		
		self.TargetAngle = self.VElements["gear"].angle.y
		
	end
	
	function SWEP:OnThink()

		if (!self.VElements) then return end
		self.VElements["gear"].angle.y = math.Approach(self.VElements["gear"].angle.y, self.TargetAngle, FrameTime()*180)

		if (self.LastPrimaryAttack > CurTime()-0.1) then
			self.VElements["labthing1"].pos.z = math.Approach(self.VElements["labthing1"].pos.z, self.DefaultPoleZ-7.5, FrameTime()*150)
		else
			self.VElements["labthing1"].pos.z = math.Approach(self.VElements["labthing1"].pos.z, self.DefaultPoleZ, FrameTime()*20)
		end
		
	end

	function SWEP:OnFireBullet()

		self.TargetAngle = self.TargetAngle + 45

	end

end

