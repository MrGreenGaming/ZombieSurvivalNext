-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.ViewModel = Model("models/weapons/v_zombine.mdl")
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

SWEP.PrintName = "Zombine"
if CLIENT then
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false
	--SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
end

SWEP.Primary.Delay = 2
SWEP.Primary.Duration = 2
SWEP.Primary.Reach = 54
SWEP.Primary.Damage = 30


SWEP.ChargeTime = 6


--[[
function SWEP:PlayHitSound()
	self.Owner:EmitSound(Sound("npc/zombine/zombine_alert"..math.random ( 1,3 )..".wav")) 
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound(Sound("npc/zombine/zombine_alert"..math.random ( 1,3 )..".wav")) 
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound(Sound("npc/zombine/zombine_alert"..math.random ( 1,3 )..".wav")) 
end]]--


function SWEP:PrimaryAttack()

	local mOwner, mWeapon = self.Owner, self.Weapon

	
	-- Cooldown
	timer.Simple(0.2, function()
		if not IsValid ( mWeapon ) or not IsValid ( mOwner ) then
			return
		end	
		-- Second part animation
		mWeapon:SendWeaponAnim(ACT_VM_THROW)
	end)
	

	
	if self:GetChargeStart() == 0 then
		self:SetChargeStart(CurTime())		

		self:EmitSound(Sound("npc/zombine/zombine_readygrenade"..math.random ( 1,2 )..".wav", 80, 60))
			timer.Simple(2, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(2.5, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(3, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav")
			end)
			timer.Simple(3.5, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(3.7, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(4, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(4.5, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(4.7, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(5, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
	end

	self:NextThink(CurTime())
	return true
end


local function DOMakeNade(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		pl:ResetSpeed()

		local startpos = pl:GetPos()
		startpos.z = pl:GetShootPos().z
		local heading = pl:GetAimVector()

		local ent = ents.Create("zombine_grenade")
		if ent:IsValid() then
			ent:SetPos(startpos + Vector ( 0,0,40 ))
			ent:SetOwner(pl)
			ent:Spawn()
			ent:SetParent(pl)
		end
end
		--pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.random(70, 80))

		pl:RawCapLegDamage(CurTime() + 2)
end

function SWEP:SecondaryAttack()

	local mOwner, mWeapon = self.Owner, self.Weapon
	
	--timer.Simple(0.75, function() DOMakeNade(mOwner, self) end)
	-- Cooldown
	timer.Simple(0.2, function()
		if not IsValid ( mWeapon ) or not IsValid ( mOwner ) then
			return
		end
		
		-- Player changed team/class
	--	if not mOwner:IsZombie() or not mOwner:Alive() or not mOwner:IsZombine() then
		--	return
		--end
		
		-- Second part animation
		mWeapon:SendWeaponAnim(ACT_VM_THROW)
	end)
	
	if self:GetChargeStart() == 0 then
		self:SetChargeStart(CurTime())
		--self.Owner:EmitSound("weapons/cguard/charging.wav", 80, 60)
		self:EmitSound(Sound("npc/zombine/zombine_readygrenade"..math.random ( 1,2 )..".wav", 80, 60))
			timer.Simple(2, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(2.5, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(3, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav")
			end)
			timer.Simple(3.5, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(3.7, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(4, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(4.5, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(4.7, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
			timer.Simple(5, function()	
				self:EmitSound ( "weapons/grenade/tick1.wav" )
			end)
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:SendAttackAnim()
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	else
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
end

function SWEP:StopAttackAnim()
	self:SetAttackAnimEndTime(0)
	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)	
end

function SWEP:Think()
	if self:GetCharge() >= 1 then
		self.Owner:Kill()
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:IsMoaning()
	return false
end


function SWEP:Move(mv, tr)
	local charge = self:GetCharge()
	
	if charge > 0 then		
			mv:SetMaxSpeed(200)
			mv:SetMaxClientSpeed(200)	
			
	end
end

function SWEP:SetChargeStart(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetChargeStart()
	return self:GetDTFloat(0)
end

function SWEP:GetCharge()
	if self:GetChargeStart() == 0 then return 0 end

	return math.Clamp((CurTime() - self:GetChargeStart()) / self.ChargeTime, 0, 1)
end
