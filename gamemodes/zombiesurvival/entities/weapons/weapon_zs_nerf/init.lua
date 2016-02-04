AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

SWEP.Secondary.Damage = 4
SWEP.NextLeap = 0
function SWEP:SecondaryAttack()

	local Owner = self.Owner
	local ent = Owner
	local phys = ent:GetPhysicsObject()
	
	-- See where the player is ( on ground or flying )
	local bOnGround, bCrouching = Owner:OnGround(), Owner:Crouching()
	
	-- Trace filtering climb factors
	--local vStart, vAimVector = Owner:GetShootPos() - Vector ( 0,0,20 ), Owner:GetAimVector()
	local vStart, vAimVector = Owner:GetShootPos() - Vector ( 0,0,90 ), Owner:GetAimVector()
--	local trClimb = util.TraceLine( { start = vStart, endpos = vStart + ( vAimVector * 35 ), filter = Owner } )
	local trClimb = util.TraceLine( { start = vStart, endpos = vStart + ( vAimVector * 10 ), filter = Owner } )
		
	if trClimb.HitWorld then
		return
	end
	
	--Leap cooldown / player flying
	if CurTime() < self.NextLeap or not bOnGround or self.Leaping then
		return
	end
	
	--Set flying velocity
	local Velocity = self.Owner:GetAngles():Forward() * 1200, self.Owner:GetAngles():Up() * 200
	if Velocity.z < 200 then
		Velocity.z = 300
	end
	
	local Velocity2 = self.Owner:GetAngles():Up() * 30
	if Velocity2.z < 30 then
		Velocity2.z = 30
	end
	
	--Apply velocity and set leap status to true
	Owner:SetGroundEntity(NULL)
	Owner:SetLocalVelocity(Velocity)

	
	phys:ApplyForceCenter(Velocity)

	--ent:TakeDamage(self.Secondary.Damage, self.Owner, self)
	
	--Start leap
	--self.Leaping = true
	
	--Leap cooldown
	self.NextLeap = CurTime() + 2
	
	--Fast zombie scream
	if SERVER then
		--Owner:EmitSound(Sound("mrgreen/undead/fastzombie/leap".. math.random(1,5) ..".wav"))
		Owner:EmitSound(Sound("npc/antlion_guard/angry".. math.random(1,3) ..".wav"))
	end
end