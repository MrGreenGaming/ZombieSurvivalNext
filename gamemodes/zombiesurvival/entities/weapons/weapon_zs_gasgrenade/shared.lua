-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "Chem Grenade"
	SWEP.Description = "A toxic Grenade which repels and hurts zombies!"
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true


	SWEP.ViewModelBoneMods = {
		["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0.27, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VElements = {
		["gasnade2"] = { type = "Model", model = "models/props_interiors/Radiator01a.mdl", bone = "ValveBiped.Grenade_body", rel = "gasnade", pos = Vector(1.08, 0.377, -0.21), angle = Angle(0, 0, 0), size = Vector(0.078, 0.032, 0.144), color = Color(168, 255, 0, 255), surpresslightning = false, material = "models/props_combine/tpballglow", skin = 0, bodygroup = {} },
		["gasnade"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(0, -0.227, -2.366), angle = Angle(-180, -4.374, 0), size = Vector(0.168, 0.168, 0.168), color = Color(26, 255, 255, 255), surpresslightning = false, material = "models/XQM/LightLinesRed_TOOL", skin = 0, bodygroup = {} },
		["gasnade3"] = { type = "Model", model = "models/props/de_train/hr_t/smoke_a/smoke_a.mdl", bone = "ValveBiped.Bip01_L_Finger4", rel = "gasnade", pos = Vector(18.145, 0.13, 12.486), angle = Angle(32.153, 75.459, 5.278), size = Vector(0.009, 0.009, 0.009), color = Color(214, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["gasnade2"] = { type = "Model", model = "models/props_interiors/Radiator01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.297, 2.263, 0.109), angle = Angle(0, 0, 0), size = Vector(0.078, 0.032, 0.144), color = Color(0, 102, 0, 255), surpresslightning = false, material = "models/props_combine/tpballglow", skin = 0, bodygroup = {} },
		["gasnade"] = { type = "Model", model = "models/props_c17/TrapPropeller_Engine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.288, 1.7, 0.349), angle = Angle(-180, 0, 0), size = Vector(0.168, 0.168, 0.168), color = Color(26, 255, 255, 255), surpresslightning = false, material = "models/XQM/LightLinesRed_TOOL", skin = 0, bodygroup = {} }
	} 
end


SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.UseHands = true


SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "grenade"
SWEP.Primary.Delay = 1.25
SWEP.Primary.DefaultClip = 2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.WalkSpeed = SPEED_FAST

function SWEP:Initialize()
	self:SetWeaponHoldType("grenade")
	self:SetDeploySpeed(1.1)
end

function SWEP:Precache()
	util.PrecacheSound("WeaponFrag.Throw")
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local owner = self.Owner
	self:SendWeaponAnim(ACT_VM_THROW)
	owner:DoAttackEvent()

	self:TakePrimaryAmmo(1)
	self.NextDeploy = CurTime() + 1

	if SERVER then
		local ent = ents.Create("projectile_zschemgrenade")
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos())
			ent:SetOwner(owner)
			ent:Spawn()
			ent.GrenadeDamage = self.GrenadeDamage
			ent.GrenadeRadius = self.GrenadeRadius
			ent:EmitSound("WeaponFrag.Throw")
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
				phys:AddAngleVelocity(VectorRand() * 5)
				phys:SetVelocityInstantaneous(self.Owner:GetAimVector() * 800)
			end
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:Deploy()
	GAMEMODE:WeaponDeployed(self.Owner, self)

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end

	return true
end

function SWEP:Holster()
	self.NextDeploy = nil
	return true
end

function SWEP:Think()
	if self.NextDeploy and self.NextDeploy <= CurTime() then
		self.NextDeploy = nil

		if 0 < self:GetPrimaryAmmoCount() then
			self:SendWeaponAnim(ACT_VM_DRAW)
		else
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

			if SERVER then
				self:Remove()
			end
		end
	elseif SERVER and self:GetPrimaryAmmoCount() <= 0 then
		self:Remove()
	end
end
