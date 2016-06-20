--Duby: Note, in order to balance this tool I will need to port some code from the Pulse SMG to add a ammo regen system, this tool is currently far too OP 

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")


function SWEP:Think()  --Test this function as it should stop the world attack animation.
    if self.IdleAnimation and self.IdleAnimation <= CurTime() then
        self.IdleAnimation = nil
        self:SendWeaponAnim(ACT_VM_IDLE)
    end
end

util.PrecacheSound( "ambient/energy/spark1.wav" ) 
util.PrecacheSound( "ambient/energy/spark2.wav" ) 
util.PrecacheSound( "ambient/energy/spark3.wav" ) 
util.PrecacheSound( "ambient/energy/spark4.wav" ) 
util.PrecacheSound( "ambient/energy/spark5.wav" ) 
util.PrecacheSound( "ambient/energy/spark6.wav" ) 

function SWEP:Reload()
	self.Owner:LagCompensation(true)
	self:SendWeaponAnim(ACT_VM_IDLE)
	if CurTime() < self:GetNextPrimaryFire() then return end

    self.IdleAnimation = nil --Test these here if the 'think' function doesnt work.


	local owner = self.Owner
	if owner:GetBarricadeGhosting() then return end

	local tr = owner:MeleeTrace(self.MeleeRange, self.MeleeSize, owner:GetMeleeFilter())
	local trent = tr.Entity
	if not trent:IsValid() or not trent:IsNailed() then return end

	local ent
	local dist

	for _, e in pairs(ents.FindByClass("prop_nail")) do
		if not e.m_PryingOut and e:GetParent() == trent then
			local edist = e:GetActualPos():Distance(tr.HitPos)
			if not dist or edist < dist then
				ent = e
				dist = edist
			end
		end
	end

	if not ent or not gamemode.Call("CanRemoveNail", owner, ent) then return end

	local nailowner = ent:GetOwner()
	if nailowner:IsValid() and nailowner ~= owner and nailowner:Team() == TEAM_HUMAN and not gamemode.Call("PlayerIsAdmin", owner) and not gamemode.Call("CanRemoveOthersNail", owner, nailowner, ent) then return end

	self:SetNextPrimaryFire(CurTime() + 1)

	ent.m_PryingOut = false -- Prevents infinite loops


	self.Owner:SetAnimation(ACT_INVALID)

	owner:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav",math.random(86,110),math.random(86,110))

	ent:GetParent():RemoveNail(ent, nil, self.Owner)

	if nailowner and nailowner ~= owner and nailowner:Team() == TEAM_HUMAN then
		if not gamemode.Call("PlayerIsAdmin", owner) and (nailowner:Frags() >= 75 or owner:Frags() < 75) then
			owner:GivePenalty(30)
			owner:ReflectDamage(20)
		end

		owner:GiveAmmo(1, self.Primary.Ammo)
	end
		self.Owner:LagCompensation(false)
end

-- make everything easy --Duby: work on this later!
--[[local function ApproachAngle(ang,to,time)
	ang.p = math.Approach(ang.p, to.p, time)
	ang.y = math.Approach(ang.y, to.y, time)
	ang.r = math.Approach(ang.r, to.r, time)
end]]--

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	self.Owner:LagCompensation(true)
	self:SendWeaponAnim(ACT_VM_IDLE)
	if hitent:IsValid() then
		if hitent.HitByHammer and hitent:HitByHammer(self, self.Owner, tr) then
			return
		end

		if hitent:IsNailed() then
			--[[if CLIENT then
				ApproachAngle(self.ViewModelBoneMods["ValveBiped.Bip01_R_Clavicle"].angle,self.AppTo,FrameTime()*33)
			end	]]--
			
			local healstrength = GAMEMODE.NailHealthPerRepair * (self.Owner.HumanRepairMultiplier or 1) * self.HealStrength
			local oldhealth = hitent:GetBarricadeHealth()
			if oldhealth <= 0 or oldhealth >= hitent:GetMaxBarricadeHealth() or hitent:GetBarricadeRepairs() <= 0 then return end

			hitent:SetBarricadeHealth(math.min(hitent:GetMaxBarricadeHealth(), hitent:GetBarricadeHealth() + math.min(hitent:GetBarricadeRepairs(), healstrength)))
			local healed = hitent:GetBarricadeHealth() - oldhealth
			hitent:SetBarricadeRepairs(math.max(hitent:GetBarricadeRepairs() - healed, 0))
			self:PlayRepairSound(hitent)
			gamemode.Call("PlayerRepairedObject", self.Owner, hitent, healed, self)

			local eff = EffectData()
					eff:SetOrigin(tr.HitPos)
					eff:SetNormal(tr.HitNormal)
					eff:SetScale(math.Rand(0.9,1.2))
					eff:SetMagnitude(math.random(10,40))
					util.Effect("StunstickImpact", eff, true, true)

			local eff2 = EffectData()
					eff2:SetOrigin(tr.HitPos)
					eff2:SetNormal(tr.HitNormal)
					eff2:SetScale(math.Rand(0.9,1.2))
					eff2:SetMagnitude(math.random(10,40))
					util.Effect("StunstickImpact", eff2, true, true)
		
					
			return true
		end
	end
		self.Owner:LagCompensation(false)
end

function SWEP:SecondaryAttack()
end
