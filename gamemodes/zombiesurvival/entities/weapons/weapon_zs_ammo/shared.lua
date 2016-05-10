-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.HoldType = "melee"

if CLIENT then
	SWEP.PrintName = "Support Ammo"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false


	SWEP.VElements = {
		["Ammo"] = { type = "Model", model = "models/items/boxmrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 0.522, 0), angle = Angle(167.143, 5.843, 94.675), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	
	
	SWEP.WElements = {
		["Ammo"] = { type = "Model", model = "models/items/boxmrounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 3.635, 0), angle = Angle(-155.456, 10.519, 0), size = Vector(0.301, 0.301, 0.301), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Ammo2"] = { type = "Model", model = "models/items/boxsrounds.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.675, 0.518, 1.557), angle = Angle(-3.507, -12.858, 57.272), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.Base				= "weapon_zs_basemelee" 

SWEP.Author			= "Duby"
SWEP.ViewModelFOV	= 60

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel      = Model ( "models/weapons/c_grenade.mdl")
SWEP.WorldModel   = Model ( "models/Weapons/v_crowbar.mdl" )
SWEP.UseHands = true

SWEP.Primary.Delay			= 0.01 	
SWEP.Primary.Recoil			= 0		
SWEP.Primary.Damage			= 0	
SWEP.Primary.NumShots		= 1		
SWEP.Primary.Cone			= 0 	
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 3
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"

SWEP.NextPlant = 0

function SWEP:PrimaryAttack()
if not self:CanPrimaryAttack() then return end

	local owner = self.Owner

	local status = owner.status_ghost_resupplybox
	
	self:SetNextPrimaryAttack(CurTime() + self.Primary.Delay)
	
if SERVER then
	local ent = ents.Create("prop_ammo_drop")
	if ent:IsValid() then
		ent:SetPos(owner:GetShootPos())
		ent:SetAngles(self.Owner:EyeAngles())
		ent:Spawn()

		ent:SetObjectOwner(owner)

		ent:GhostAllPlayersInMe(5)

		self:TakePrimaryAmmo(2)

		local stored = owner:PopPackedItem(ent:GetClass())
		if stored then
			ent:SetObjectHealth(stored[1])
		end

		if self:GetPrimaryAmmoCount() <= 0 then
			owner:StripWeapon(self:GetClass())
		end
	end
end

end



