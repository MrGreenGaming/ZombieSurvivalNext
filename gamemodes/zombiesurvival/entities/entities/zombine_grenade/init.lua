-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")

ENT.PoisonExplodeSound = Sound( "ambient/levels/labs/electric_explosion1.wav" )
local table1 = { 1,2 }
function ENT:Initialize()

	-- Initialize physics and model
	self:SetModel( "models/weapons/w_grenade.mdl" )
	
	self:InitPhys()
	
	self:DrawShadow ( false )
	self.ZombieOwner = self:GetOwner()
	
	-- Set position on hand
	self:SetPos ( self.ZombieOwner:GetPos() + Vector ( 0,0,40 ) ) --Need to resolve this asap!
end

function ENT:InitPhys()

	-- Init phys stuff
	self:PhysicsInit ( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER ) 
	
	-- Wake up
	local Phys = self:GetPhysicsObject()
	timer.Simple ( 0.02, function( ) if not IsValid (  ) then return end if Phys:IsValid() then Phys:Wake() end if self.OwnerDied then Phys:ApplyForceCenter( VectorRand() * math.Rand( 50, 50 ) ) end end)
end

function ENT:Think()

	if self:GetType() then self:Explode() end

end




-- Kinetic explosion
function ENT:Explode()
	if not IsEntityValid ( self.ZombieOwner ) then return end
	
	-- Not human anymore
	if not self.ZombieOwner:IsZombie() then return end
	
	-- Get players near
	local tbHumans = ents.FindHumansInSphere ( self:GetPos(), self.MaximumDist )
	
	-- Local stuff
	local vPos = self:GetPos()
	
	--  Shaken, not stirred
	local shake = ents.Create( "env_shake" )
	shake:SetPos( vPos )
	shake:SetKeyValue( "amplitude", "820" ) -- Power of the shake effect
	shake:SetKeyValue( "radius", "290" )	-- Radius of the shake effect
	shake:SetKeyValue( "duration", "3" )	-- Duration of shake
	shake:SetKeyValue( "frequency", "128" )	-- Screenshake frequency
	shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
	shake:Spawn()
	shake:SetOwner( self.ZombieOwner )
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )
	
	-- Kill owner
	if not self.OwnerDied then self.ZombieOwner:SetHealth ( 0 ) self.ZombieOwner:Kill() end
	
	-- Filter
	local Filter = { self, self.ZombieOwner }
	table.Add( Filter, team.GetPlayers( TEAM_UNDEAD ) )
	
	-- Get owner active weapon
	local mOwnerWeapon = self.ZombieOwner:GetActiveWeapon()
	
	local Ent = ents.Create("env_explosion")
	Ent:EmitSound( "explode_4" )		
	Ent:SetPos( self.Entity:GetPos() )
	Ent:Spawn()
	Ent.Team = function() -- Correctly applies the whole 'no team damage' thing
		return TEAM_UNDEAD
	end
	Ent:SetOwner( self:GetOwner() )
	Ent:Activate()
	Ent:SetKeyValue( "iMagnitude", math.Clamp ( math.Rand ( 50,80), 30, 110 ) )
	Ent:Fire("explode", "", 0)
	
	-- Damage humans nearby
	--[[for k,v in pairs ( tbHumans ) do
		if IsEntityVisible ( v, vPos + Vector ( 0,0,3 ), Filter ) then
			table.insert( Filter, v )
			local fDistance = self:GetPos():Distance( v:GetPos() )
			v:TakeDamage ( math.Clamp ( ( ( self.MaximumDist - fDistance ) / self.MaximumDist ) * 37,0, 47 ), self.ZombieOwner, mOwnerWeapon )
			v:TakeDamageOverTime( math.Rand(2,3), 1.5, math.Clamp( ( ( ( self.MaximumDist - fDistance ) / self.MaximumDist ) * 44 ) / 2, 0, 22 ), self.ZombieOwner, mOwnerWeapon )
		end
	end]]--
	
	-- Effect
	local eData = EffectData()
		eData:SetOrigin( vPos )
		eData:SetScale( 1.2 )
	--util.Effect( "Explosion", eData )
	
	-- Remove grenade
	self:Remove()
end