
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
end

SWEP.Primary.Delay = 2
SWEP.Primary.Duration = 2
SWEP.Primary.Reach = 48
SWEP.Primary.Damage = 30



--Temp workaround
SWEP.IdleSounds = {
	"npc/zombine/zombine_idle1.wav",
	"npc/zombine/zombine_idle2.wav",
}

function SWEP:Deploy()
	self.BaseClass.Deploy(self)

	-- Hide world model
	if SERVER then
		self.Owner:DrawViewModel(true)
		self.Owner:DrawWorldModel(true)
	end
	
	-- Animation vars
	local mOwner = self.Owner
	mOwner.HoldingGrenade, mOwner.IsAttacking, mOwner.IsGettingNade = false, false, false
	
	-- Initialize sprint 
	mOwner.bCanSprint, mOwner.Sprint = false, 100
	
	-- Set speed
	--GAMEMODE:SetPlayerSpeed(150)
	
	--Idle animation
	--self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
end

function SWEP:Think()
	self.BaseClass.Think(self)

	if not IsValid(self.Owner) then
		return
	end
	local mOwner = self.Owner
	
	self:CheckAttackAnim()
	self:CheckGrenade()

	-- Think cooldown
	if ( self.ThinkTimer or 0 ) > CurTime() then
		return
	end
	
	local Speed = 150
	
	if mOwner.bCanSprint then
		if mOwner:GetMaxSpeed() < 150 then
			if not self:IsAttackingAnim() and not self:IsGettingNade() then
				GAMEMODE:SetPlayerSpeed( 200 )
			end
		end
	else
		if mOwner:GetMaxSpeed() > Speed then
			if not self:IsAttackingAnim() and not self:IsGettingNade() then
				GAMEMODE:SetPlayerSpeed( mOwner, Speed, Speed )
				end
			end	
	end

	self.ThinkTimer = CurTime() + 0.25
end

function SWEP:CheckAttackAnim()
	local swingend = self:GetAttackAnimEndTime()
	if swingend == 0 or CurTime() < swingend then
		return
	end
	self:StopAttackAnim()

	local pl = self.Owner
	
	if not IsValid(pl) then return end
	
	if pl.bCanSprint then
		GAMEMODE:SetPlayerSpeed( 150 )
	else
		GAMEMODE:SetPlayerSpeed( 200 ) 
	end
end

SWEP.NextSwing = 0
SWEP.ZombineAttacks = { "attackD", "attackE", "attackF", "attackB" }
function SWEP:StartPrimaryAttack()	
	--Make things easier
	local pl = self.Owner
	
	
	self.Owner:SetMoveType(MOVETYPE_NONE)	
		timer.Simple(2.5, function()
			self.Owner:SetMoveType(MOVETYPE_WALK)
	end)
	
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	--Owner
	local mOwner, mWeapon = self.Owner, self.Weapon
	
	--Set the thirdperson animation and emit zombie attack sound
	if SERVER then 
		self.Owner:EmitSound(Sound("npc/zombine/zombine_alert"..math.random ( 1,3 )..".wav")) 
		
		-- Stop when we get grenade

		--GAMEMODE:SetPlayerSpeed ( mOwner, 0,0)
		--mOwner:SetLocalVelocity ( Vector ( 0,0,0 ) )
	end

	--Sequence to play
	--local iSequence = table.Random(self.ZombineAttacks) 	
	--self:SetAttackSeq(iSequence)	
	--self:SetAttackAnimEndTime(CurTime() + 0.00)
	--self:SetAttackAnimEndTime(CurTime() + 1.5)

	--Hacky way for the animations
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	--mOwner:DoAnimationEvent(CUSTOM_PRIMARY)

	-- Idle animation
	--timer.Simple(1.5, function()
	--timer.Simple(10000, function() --work around for zombines walking and attacking
	--	if not IsValid(self) then
		--	return
	--end


	--end)
end

function SWEP:StopAttackAnim()
	self:SetAttackAnimEndTime(0)
	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)	
end

function SWEP:SetAttackAnimEndTime(time)
	self:SetDTFloat(2, time)
end

function SWEP:GetAttackAnimEndTime()
	return self:GetDTFloat(2)
end

function SWEP:IsAttackingAnim()
	return self:GetAttackAnimEndTime() > 0
end

function SWEP:StopSwinging()
	self:SetSwingEndTime(0)
end

function SWEP:SetAttackSeq(str)
	self:SetDTString(0,str)
end

function SWEP:GetAttackSeq()
	return self:GetDTString(0)
end

function SWEP:IsGettingNade()
	return self:GetGettingNadeEndTime() > 0
end

function SWEP:SetGettingNadeEndTime(time)
	self:SetDTFloat(3, time)
end

function SWEP:GetGettingNadeEndTime()
	return self:GetDTFloat(3)
end

function SWEP:StopGettingNade()
	self:SetGettingNadeEndTime(0)
end

function SWEP:HoldGrenade(bl)
	self:SetDTBool(0,bl)
end

function SWEP:IsHoldingGrenade()
	return self:GetDTBool(0)
end

function SWEP:CheckGrenade()
	local swingend = self:GetGettingNadeEndTime()
	if swingend == 0 or CurTime() < swingend then
		return
	end
	self:StopGettingNade()

	local pl = self.Owner
	
	if not IsValid(pl) then
		return
	end
	
	self:HoldGrenade(true)
		
	--if pl.bCanSprint then
		--GAMEMODE:SetPlayerSpeed(150)
	--else
	--	GAMEMODE:SetPlayerSpeed(200) 
	--end
end

SWEP.GrenadeUsed = false
function SWEP:SecondaryAttack()
	--if not self.Owner.bCanSprint then return end
	-- Disable primary attack
	self.Weapon:SetNextPrimaryFire(CurTime() + 5) 
	
	-- Cooldown
	if self.GrenadeUsed or not self.Owner:OnGround() then
		return
	end
	
	-- Owner
	local mOwner, mWeapon = self.Owner, self.Weapon
	
	-- Stop when we get grenade
	if SERVER then		
		--GAMEMODE:SetPlayerSpeed(mOwner, 0)
		mOwner:SetLocalVelocity(Vector(0, 0, 0))
	end

	--Allow sprinting
	mOwner.bCanSprint = true

	-- Emit both claw attack sound and weird funny sound
	if SERVER then
		mOwner:EmitSound(Sound("npc/zombine/zombine_readygrenade"..math.random ( 1,2 )..".wav"))
	end
	
	-- Alert VOX
	if SERVER then
		timer.Simple(1, function()
			if IsValid(self) and self.AlertVOX then
				self:AlertVOX()
			end
		end)
	end
	
	-- Used grenade
	self.GrenadeUsed = true
	
	-- Create grenade
	if SERVER then
		--local mGrenade = ents.Create ( "zombine_grenade" )
		--mGrenade:SetOwner ( mOwner )
		--mGrenade:Spawn()
		--mGrenade:Activate()
		
		-- Parent the shit
		--mGrenade:SetParent ( mOwner )
	end
	
	local button = ents.Create( "zombine_grenade" )
	button:SetOwner ( mOwner )
	button:SetParent ( mOwner )
	button:Activate()
	button:Spawn()
	
	--self.Owner
	
	-- Animation status
	-- mOwner.IsGettingNade = true
	mOwner:DoAnimationEvent(CUSTOM_SECONDARY)
	
	-- Set the first person animaiton and restart the third one
	mWeapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	
	local pl = self.Owner
	
	self:SetGettingNadeEndTime(CurTime() + 1)
	
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
end

function SWEP:AlertVOX()
	if not IsValid ( self.Owner ) then return end
	
	-- Owner
	local mOwner, mWeapon = self.Owner, self.Weapon
	
	-- Not alive
	if not mOwner:Alive() then return end
	
	-- Emit idle sounds
	--local mSound = table.Random ( ZombieClasses[8].AlertSounds )
	ZombieClassesAlertSounds = {
	"npc/zombine/zombine_alert1.wav",
	"npc/zombine/zombine_alert2.wav",
	"npc/zombine/zombine_alert3.wav",
	"npc/zombine/zombine_alert4.wav",
	"npc/zombine/zombine_alert5.wav",
	"npc/zombine/zombine_alert6.wav",
	"npc/zombine/zombine_alert7.wav"
	}
	
	local mSound = table.Random ( ZombieClassesAlertSounds )

	-- Sound duration
	local fDuration = math.Rand( 5, 10) + 1
	if fDuration == 0 then fDuration = 1.5 end
	
	-- Emit sound
	mOwner:EmitSound ( mSound )

	-- Cooldown
	timer.Simple( fDuration,function() if IsValid(self) then self:AlertVOX() end end )
end

function SWEP:Precache()
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/zombine/zombine_readygrenade1.wav")
	util.PrecacheSound("npc/zombine/zombine_readygrenade2.wav")
	util.PrecacheSound("npc/zombine/zombine_charge1.wav")
	util.PrecacheSound("npc/zombine/zombine_charge2.wav")
	
	util.PrecacheModel(self.ViewModel)
	

	-- Quick way to precache all sounds
	--for _, snd in pairs(ZombieClasses[8].PainSounds) do
	for _, snd in pairs(ZombieClasses[8].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	--for _, snd in pairs(ZombieClasses[8].DeathSounds) do
	for _, snd in pairs(ZombieClasses[8].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	--for _, snd in pairs(ZombieClasses[8].IdleSounds) do
	for _, snd in pairs(ZombieClasses[8].IdleSounds) do
		util.PrecacheSound(snd)
	end
	
	--for _, snd in pairs(ZombieClasses[8].AlertSounds) do
	for _, snd in pairs(ZombieClasses[8].AlertSounds) do
		util.PrecacheSound(snd)
	end
end