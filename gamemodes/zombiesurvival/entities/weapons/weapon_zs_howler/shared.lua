--Duby: Ported Howler for original ZS created by Deluvas

SWEP.Base = "weapon_zs_zombie"
SWEP.ZombieOnly = true
SWEP.IsMelee = true

if CLIENT then
	SWEP.ViewModelFOV = 10
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true
end

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.MeleeDelay = 0.74
SWEP.MeleeReach = 48
SWEP.MeleeSize = 1.5
SWEP.MeleeDamage = 30
SWEP.MeleeForceScale = 1
SWEP.MeleeDamageType = DMG_SLASH

SWEP.AlertDelay = 2.5

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Primary.Duration = 2
SWEP.Primary.Delay = 0.6
SWEP.Primary.Reach = 300
SWEP.Primary.Damage = 10

SWEP.Secondary.Reach = 300
SWEP.Secondary.Duration = 2
SWEP.Secondary.Delay = 0.6
SWEP.Secondary.Next = 5
SWEP.Secondary.Automatic = false
SWEP.Secondary.Damage = 10

function SWEP:StopMoaningSound()
	local owner = self.Owner
	owner:StopSound("NPC_BaseZombie.Moan1")
	owner:StopSound("NPC_BaseZombie.Moan2")
	owner:StopSound("NPC_BaseZombie.Moan3")
	owner:StopSound("NPC_BaseZombie.Moan4")
end

function SWEP:StartMoaningSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_bark1.wav")
end


function SWEP:PlayAttackSound()
	self.Owner:EmitSound(Sound("zombies/howler/howler_scream_01.mp3"),80)
end


function SWEP:Think()
	self.BaseClass.Think(self)
	if SERVER then
		if self:IsScreaming() == true and not self:SecondaryAttack() then
		self:Screaming(false)	
		end 
	end
end

function SWEP:PrimaryAttack()			
-- Get owner
	local mOwner = self.Owner
	if not IsValid(mOwner) then
		return
	end


	self.Owner:SetMoveType(MOVETYPE_NONE)	
		timer.Simple(2.5, function()
			self.Owner:SetMoveType(MOVETYPE_WALK)
		end)
		
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	

	self.Owner:SetLocalVelocity(Vector(0, 0, 0))

	-- Cannot scream in air
	if not mOwner:OnGround() then	
		return
	end
		
	--Thirdperson animation and sound
	mOwner:DoAnimationEvent(PLAYERANIMEVENT_ATTACK_GRENADE , 123)

	self.Owner:EmitSound(Sound("player/zombies/howler/howler_scream_01.mp3"), 100, math.random(95, 135))
	
	--Just server from here
	if CLIENT then
		return
	end

	--Screaming on and off!
	self:Screaming(true)
	
	--Find in sphere
	for k,v in ipairs(team.GetPlayers(TEAM_HUMAN)) do
		local fDistance = v:GetPos():Distance( self.Owner:GetPos() )

		--Check for conditions
		if not v:IsPlayer() or fDistance > self.Secondary.Reach then
			continue
		end

		local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * self.Secondary.Reach )
		local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = mOwner, mask = MASK_SOLID } )
			
		-- Exploit trace
		if not Trace.Hit or not IsValid(Trace.Entity) or Trace.Entity ~= v then
			continue
		end
		
		--Calculate percentage of being hit
		local fHitPercentage = math.Clamp(1 - (fDistance / self.Secondary.Reach), 0, 1)
															
		--Inflict damage
		local fDamage = math.Round(15 * fHitPercentage, 0, 10)
		if fDamage > 0 then
			v:TakeDamage(fDamage, self.Owner, self)
		end

		--Check if last Howler scream was recently (we don't want to stack attacks)
		if v.lastHowlerScream and v.lastHowlerScream >= (CurTime()-4) then
			continue
		end

		--Set last Howler scream
		v.lastHowlerScream = CurTime()

		--Shakey shakey
		local fFuckIntensity = fHitPercentage + 2.5 --Duby test.

		GAMEMODE:OnPlayerHowlered(v, fFuckIntensity)

		-- Calculate base velocity
		local Velocity = -1 * mOwner:GetForward() * 150
		if not bPull then
			Velocity = -1 * Velocity * 2
		end
		
		
		Velocity.x, Velocity.y, Velocity.z = Velocity.x * 0.5, Velocity.y * 0.5, math.random(190, 230)
		if not bPull then
			Velocity = Vector(Velocity.x * 0.45, Velocity.y * 0.45, Velocity.z)
		end

		--Apply velocity		
		v:SetVelocity(Velocity)
	end
end


function SWEP:SecondaryAttack()	
	-- Get owner
	local mOwner = self.Owner
	if not IsValid(mOwner) then
		return
	end

	self.Weapon:SetNextSecondaryFire(CurTime() + 5)

	self.Owner:SetMoveType(MOVETYPE_NONE)	
		timer.Simple(2.5, function()
			self.Owner:SetMoveType(MOVETYPE_WALK)
		end)

	self.Owner:SetLocalVelocity(Vector(0, 0, 0))

	-- Cannot scream in air
	if not mOwner:OnGround() then	
		return
	end
		
	--Thirdperson animation and sound
	mOwner:DoAnimationEvent(PLAYER_ATTACK1)

	self.Owner:EmitSound(Sound("player/zombies/howler/howler_scream_01.mp3"), 100, math.random(95, 135))

	--Just server from here
	if CLIENT then
		return
	end

	--Screaming on and off!
	self:Screaming(true)
	
	--Find in sphere
	for k,v in ipairs(team.GetPlayers(TEAM_HUMAN)) do
		local fDistance = v:GetPos():Distance( self.Owner:GetPos() )

		--Check for conditions
		if not v:IsPlayer() or fDistance > self.Secondary.Reach then
			continue
		end

		local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * self.Secondary.Reach )
		local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = mOwner, mask = MASK_SOLID } )
			
		-- Exploit trace
		if not Trace.Hit or not IsValid(Trace.Entity) or Trace.Entity ~= v then
			continue
		end
		
		--Calculate percentage of being hit
		local fHitPercentage = math.Clamp(1 - (fDistance / self.Secondary.Reach), 0, 1)
															
		--Inflict damage
		local fDamage = math.Round(15 * fHitPercentage, 0, 10)
		if fDamage > 0 then
			v:TakeDamage(fDamage, self.Owner, self)
		end

		--Check if last Howler scream was recently (we don't want to stack attacks)
		if v.lastHowlerScream and v.lastHowlerScream >= (CurTime()-4) then
			continue
		end

		--Set last Howler scream
		v.lastHowlerScream = CurTime()

		--Shakey shakey
		local fFuckIntensity = fHitPercentage + 2.5 --Duby test.

		GAMEMODE:OnPlayerHowlered(v, fFuckIntensity)

		-- Calculate base velocity
		local Velocity = -1 * mOwner:GetForward() * 200
		if not bPull then
			Velocity = -1 * Velocity * 2
		end
		
		
		Velocity.x, Velocity.y, Velocity.z = Velocity.x * 0.5, Velocity.y * 0.5, math.random(190, 230)
		if not bPull then
			Velocity = Vector(Velocity.x * 0.45, Velocity.y * 0.45, Velocity.z)
		end

		--Apply velocity		
		v:SetVelocity(Velocity)
				
		-- Play sound
		sound.Play("player/zombies/howler/howler_scream_01.mp3", v:GetPos() + Vector(0, 0, 20), 100, math.random(150, 160))

	end
	
	--Scream effect for myself
end

function SWEP:Screaming(bl)
	self:SetDTBool(0,bl)
	self:DrawShadow(bl)
end

function SWEP:IsScreaming()
	return self:GetDTBool(0)
end

function SWEP:Move(mv)
	if self:IsInPrimaryAttack() then
		self:SetMaxSpeed(0)
		self:SetSpeed(0)
		return true
	end
	if self:IsInSecondaryAttack() then
		self:SetMaxSpeed(0)
		self:SetSpeed(0)
		return true
	end
end


local matSheet = Material("models/weapons/v_zombiearms/ghoulsheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
