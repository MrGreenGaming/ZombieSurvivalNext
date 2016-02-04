AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function SWEP:Deploy()	
	--self.Owner:StopAllLuaAnimations()
	--local owner = self.Owner
	--owner:StopAllLuaAnimations()
end	

function SWEP:Reload()
	
	if CurTime() < self:GetNextPrimaryFire() then return end

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
	
--	owner:StopAllLuaAnimations()


	if not ent or not gamemode.Call("CanRemoveNail", owner, ent) then return end

	local nailowner = ent:GetOwner()
	if nailowner:IsValid() and nailowner ~= owner and nailowner:Team() == TEAM_HUMAN and not gamemode.Call("PlayerIsAdmin", owner) and not gamemode.Call("CanRemoveOthersNail", owner, nailowner, ent) then return end

	self:SetNextPrimaryFire(CurTime() + 1)

	ent.m_PryingOut = true -- Prevents infinite loops

	--self:SendWeaponAnim(self.Alternate and ACT_INVALID or ACT_INVALID)
	--self.Alternate = not self.Alternate

	--owner:DoAnimationEvent(ACT_INVALID)

	owner:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav",math.random(86,110),math.random(86,110))

	ent:GetParent():RemoveNail(ent, nil, self.Owner)

	if nailowner and nailowner ~= owner and nailowner:Team() == TEAM_HUMAN then
		if not gamemode.Call("PlayerIsAdmin", owner) and (nailowner:Frags() >= 75 or owner:Frags() < 75) then
			owner:GivePenalty(30)
			owner:ReflectDamage(20)
		end

		if nailowner:NearestPoint(tr.HitPos):Distance(tr.HitPos) <= 768 and (nailowner:HasWeapon("weapon_zs_hammer") or nailowner:HasWeapon("weapon_zs_electrohammer")) then
			nailowner:GiveAmmo(1, self.Primary.Ammo)
		else
			owner:GiveAmmo(1, self.Primary.Ammo)
		end
	else
		owner:GiveAmmo(1, self.Primary.Ammo)
	end
end

-- make everything easy
local function ApproachAngle(ang,to,time)
	ang.p = math.Approach(ang.p, to.p, time)
	ang.y = math.Approach(ang.y, to.y, time)
	ang.r = math.Approach(ang.r, to.r, time)
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() then
		if hitent.HitByHammer and hitent:HitByHammer(self, self.Owner, tr) then
			return
		end

		if hitent:IsNailed() then
			if CLIENT then
				ApproachAngle(self.ViewModelBoneMods["ValveBiped.Bip01_R_Clavicle"].angle,self.AppTo,FrameTime()*33)
			end	
		
			local healstrength = GAMEMODE.NailHealthPerRepair * (self.Owner.HumanRepairMultiplier or 1) * self.HealStrength
			local oldhealth = hitent:GetBarricadeHealth()
			if oldhealth <= 0 or oldhealth >= hitent:GetMaxBarricadeHealth() or hitent:GetBarricadeRepairs() <= 0 then return end

			hitent:SetBarricadeHealth(math.min(hitent:GetMaxBarricadeHealth(), hitent:GetBarricadeHealth() + math.min(hitent:GetBarricadeRepairs(), healstrength)))
			local healed = hitent:GetBarricadeHealth() - oldhealth
			hitent:SetBarricadeRepairs(math.max(hitent:GetBarricadeRepairs() - healed, 0))
			self:PlayRepairSound(hitent)
			gamemode.Call("PlayerRepairedObject", self.Owner, hitent, healed, self)

			--local effectdata = EffectData()
			--	effectdata:SetOrigin(tr.HitPos)
			--	effectdata:SetNormal(tr.HitNormal)
			--	effectdata:SetMagnitude(1)
			--util.Effect("nailrepaired", effectdata, true, true)
			
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
end

function SWEP:SecondaryAttack()
end
