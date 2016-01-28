AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Author = "Duby"
SWEP.Instructions = "Ported parts from Necrossins Crow"

function SWEP:Deploy()
	self.Owner.SkipCrow = true
	return true
end

function SWEP:Holster()
	local owner = self.Owner
	if owner:IsValid() then
		owner:StopSound("NPC_Crow.Flap")
		owner:SetAllowFullRotation(false)
	end
end
SWEP.OnRemove = SWEP.Holster

function SWEP:Think()
	local owner = self.Owner
	local push = false
	
	if owner:KeyDown(IN_WALK) then
		owner:TrySpawnAsGoreChild()
		return
	end

	local fullrot = not owner:OnGround()
	if owner:GetAllowFullRotation() ~= fullrot then
		owner:SetAllowFullRotation(fullrot)
	end

	if owner:IsOnGround() or not owner:KeyDown(IN_JUMP) or not owner:KeyDown(IN_FORWARD) then
		if self.PlayFlap then
			owner:StopSound("NPC_Crow.Flap")
			self.PlayFlap = nil
		end
	else
		if not self.PlayFlap then
			owner:EmitSound("NPC_Crow.Flap")
			self.PlayFlap = true
		end
	end
	
	if self.Owner:KeyDown(IN_FORWARD) then
		vel = self.Owner:GetAimVector()*250
		push = true
	end

	local peckend = self:GetPeckEndTime()
	if peckend == 0 or CurTime() < peckend then return end
	self:SetPeckEndTime(0)

	local trace = owner:TraceLine(14, MASK_SOLID)
	local ent = NULL
	if trace.Entity then
		ent = trace.Entity
	end

	--owner:ResetSpeed()

	if ent:IsValid() then
		local phys = ent:GetPhysicsObject()
		if ent:IsPlayer() and (ent:Team() ~= TEAM_UNDEAD or ent:GetZombieClassTable().Name ~= "Crow") then
			return
		end

		ent:TakeSpecialDamage(2, DMG_SLASH, owner, self)
	end
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or not self.Owner:IsOnGround() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end

	self.Owner:EmitSound("NPC_Crow.Squawk")
	self.Owner.EatAnim = CurTime() + 2

	self:SetPeckEndTime(CurTime() + 1)

	self.Owner:SetSpeed(1)
end

SWEP.NextSpit = 0
function SWEP:SecondaryAttack()
	if self.Owner:OnGround() then return end
	if self.NextSpit > CurTime() then return end
	if CurTime() < self:GetNextSecondaryFire() then return end
	
	self.NextSpit = CurTime() + 2.4
	--self:SetNextSecondaryFire(CurTime() + 1.6)

	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end

	self.Owner:EmitSound("NPC_Crow.Alert")
	
	if SERVER then
	local pl = self.Owner
		local ent = ents.Create("crow_spit")
		self.Owner:EmitSound ("npc/crow/alert"..math.random(2,3)..".wav")
		if ent:IsValid() then
			ent:SetOwner(pl)
			ent:SetPos(pl:GetPos())
			ent:Spawn()
		end
	end
end

function SWEP:Reload()
	self:SecondaryAttack()
	return false
end
