AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.ViewModel = Model("models/weapons/v_fza.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")
SWEP.ShowWorldModel = false
if CLIENT then
	SWEP.ViewModelFOV = 70
	
	SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 75.605, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 49.916, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 20.795, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.007, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(-0.923, 0, -0.608), angle = Angle(-16.098, -16.886, 3.661) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.409, 0), angle = Angle(-13.473, 4.796, -47.446) },
	["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 99.51, 0) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 18.854, 0) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 75.922, 0) },
	["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 40.652, 0) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.76, 0) },
	["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 73.269, 0) },
	["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 61.735, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5.185, 1.73, 41.8) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 74.68, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 22.555, 0) },
	["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 48.576, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -6.368, 0) },
	["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 54.191, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 38.962, 0) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 44.536, 0) }
}	
end

SWEP.MeleeDelay = 0
SWEP.MeleeReach = 42
SWEP.MeleeDamage = 30
SWEP.MeleeForceScale = 0.1
SWEP.MeleeSize = 1.5
SWEP.MeleeDamageType = DMG_SLASH

SWEP.PounceDamage = 10
SWEP.PounceDamageType = DMG_IMPACT
SWEP.PounceReach = 32
SWEP.PounceSize = 16
SWEP.PounceStartDelay = 0.1
SWEP.PounceDelay = 0.1
SWEP.PounceVelocity = 1200

SWEP.Primary.Delay = 1.5

SWEP.RoarTime = 1.6

SWEP.Secondary.Automatic = false

SWEP.NextClimbSound = 0
SWEP.NextAllowPounce = 0
function SWEP:Think()
	self.BaseClass.Think(self)

	local curtime = CurTime()
	local owner = self.Owner

	if self.NextAllowJump and self.NextAllowJump <= curtime then
		self.NextAllowJump = nil

		owner:ResetJumpPower()
	end

	if self:GetClimbing() then
		if self:GetClimbSurface() and owner:KeyDown(IN_ATTACK2) then
			if SERVER and curtime >= self.NextClimbSound then
				local speed = owner:GetVelocity():Length()
				if speed >= 50 then
					if speed >= 100 then
						self.NextClimbSound = curtime + 0.25
					else
						self.NextClimbSound = curtime + 0.8
					end
					owner:EmitSound("player/footsteps/metalgrate"..math.random(4)..".wav")
				end
			end
		else
			self:StopClimbing()
		end
	end

	if self:GetSwinging() then
		if not owner:KeyDown(IN_ATTACK) and self.SwingStop and self.SwingStop <= curtime then
			self:SetSwinging(false)
			self.SwingStop = nil

			self.RoarCheck = curtime + 0.1

			self:StopSwingingSound()
		end
	elseif self.RoarCheck then
		if self.RoarCheck <= curtime then
			self.RoarCheck = nil

			if owner:GetVelocity():Length2D() <= 0.5 and owner:IsOnGround() then
				self:SetRoarEndTime(curtime + self.RoarTime)
				if SERVER then
					owner:EmitSound("npc/antlion_guard/antlion_guard_die1.wav")
				end
			end
		end
	elseif self:GetPouncing() then
		if owner:IsOnGround() or owner:WaterLevel() >= 2 then
			self:StopPounce()
		else
			owner:LagCompensation(true)

			local hit = false
			local traces = owner:PenetratingMeleeTrace(self.PounceReach, self.PounceSize, nil, owner:LocalToWorld(owner:OBBCenter()))
			local damage = self:GetDamage(self:GetTracesNumPlayers(traces), self.PounceDamage)

			for _, trace in ipairs(traces) do
				if not trace.Hit then continue end

				hit = true

				if trace.HitWorld then
					self:MeleeHitWorld(trace)
				else
					local ent = trace.Entity
					if ent and ent:IsValid() then
						self:MeleeHit(ent, trace, damage, 10)
					end
				end
			end

			if SERVER and hit then
				owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
				owner:EmitSound("npc/fast_zombie/wake1.wav")
			end

			owner:LagCompensation(false)

			if hit then
				self:StopPounce()
			end
		end
	elseif self:GetPounceTime() > 0 and curtime >= self:GetPounceTime() then
		self:StartPounce()
	end

	self:NextThink(curtime)
	return true
end

function SWEP:MeleeHitEntity(ent, trace, damage, forcescale)
	self.BaseClass.MeleeHitEntity(self, ent, trace, damage, forcescale ~= nil and forcescale * 0.25)
end

local climblerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	climblerp = math.Approach(climblerp, self:IsClimbing() and not self:IsSwinging() and 1 or 0, FrameTime() * ((climblerp + 1) ^ 3))
	ang:RotateAroundAxis(ang:Right(), 64 * climblerp)
	if climblerp > 0 then
		pos = pos + -8 * climblerp * ang:Up() + -12 * climblerp * ang:Forward()
	end

	return pos, ang
end

function SWEP:Swung()
	self.SwingStop = CurTime() + 0.5

	if not self:GetSwinging() then
		self:SetSwinging(true)

		self:StartSwingingSound()
	end

	self.BaseClass.Swung(self)
end

function SWEP:PrimaryAttack()
	if self:IsPouncing() or self:GetPounceTime() > 0 or not self.Owner:OnGround() and not self:IsClimbing() and self.Owner:WaterLevel() < 2 then return end

	self.BaseClass.PrimaryAttack(self)
end

local climbtrace = {mask = MASK_SOLID_BRUSHONLY, mins = Vector(-4, -4, -4), maxs = Vector(4, 4, 4)}
function SWEP:GetClimbSurface()
	local owner = self.Owner
	climbtrace.start = owner:GetPos() + owner:GetUp() * 8
	climbtrace.endpos = climbtrace.start + owner:SyncAngles():Forward() * 24
	local tr = util.TraceHull(climbtrace)
	if tr.Hit and not tr.HitSky then
		return tr
	end
end

function SWEP:SecondaryAttack()
	if self:IsPouncing() or self:IsClimbing() or self:GetPounceTime() > 0 then return end

	if self.Owner:IsOnGround() then
		if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() or CurTime() < self.NextAllowPounce then return end

		self:SetNextPrimaryFire(math.huge)
		self:SetPounceTime(CurTime() + 0.2)

		self.Owner:ResetJumpPower()
		if SERVER then
			self.Owner:EmitSound("npc/antlion_guard/angry".. math.random(1,3) ..".wav")
		end
	elseif self:GetClimbSurface() then
		self:StartClimbing()
	end
end

function SWEP:StartClimbing()
	if self:GetClimbing() then return end

	self:SetClimbing(true)

	self:SetNextSecondaryFire(CurTime() + 0.5)
end

function SWEP:StopClimbing()
	if not self:GetClimbing() then return end

	self:SetClimbing(false)

	self:SetNextSecondaryFire(CurTime())
end

function SWEP:StartPounce()
	if self:IsPouncing() then return end

	self:SetPounceTime(0)

	local owner = self.Owner
	if owner:IsOnGround() then
		self:SetPouncing(true)

		self.m_ViewAngles = owner:EyeAngles()

		if SERVER then
			owner:EmitSound("npc/antlion_guard/angry".. math.random(1,3) ..".wav")
		end

		local dir = owner:GetAimVector()
		dir.z = math.max(0.25, dir.z)
		dir:Normalize()

		owner:SetGroundEntity(NULL)
		owner:SetVelocity((1 - 0.5 * (owner:GetLegDamage() / GAMEMODE.MaxLegDamage)) * self.PounceVelocity * dir)
		owner:SetAnimation(PLAYER_JUMP)
	else
		self:SetNextSecondaryFire(CurTime())
		self.m_ViewAngles = nil
		self.NextAllowJump = CurTime()
		self.NextAllowPounce = CurTime() + self.PounceDelay
		self:SetNextPrimaryFire(CurTime() + 0.1)
		self.Owner:ResetJumpPower()
	end
end

function SWEP:StopPounce()
	if not self:IsPouncing() then return end

	self:SetPouncing(false)
	self:SetNextSecondaryFire(CurTime())
	self.m_ViewAngles = nil
	self.NextAllowJump = CurTime() 
	self.NextAllowPounce = CurTime() + self.PounceDelay
	self:SetNextPrimaryFire(CurTime() + 0.1)
	self.Owner:ResetJumpPower()
end

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:OnRemove()
	self.Removing = true

	local owner = self.Owner
	if owner and owner:IsValid() then
		self:StopSwingingSound()
		owner:ResetJumpPower()
	end

	self.BaseClass.OnRemove(self)
end

function SWEP:Holster()
	local owner = self.Owner
	if owner and owner:IsValid() then
		self:StopSwingingSound()
		owner:ResetJumpPower()
	end

	self.BaseClass.Holster(self)
end

function SWEP:ResetJumpPower(power)
	if self.Removing then return end

	if self.NextAllowJump and CurTime() < self.NextAllowJump or self:IsPouncing() or self:GetPounceTime() > 0 then
		return 1
	end
end

function SWEP:StartMoaning()
end

function SWEP:StopMoaning()
end

function SWEP:StartMoaningSound()
end

function SWEP:PlayHitSound()
	self.Owner:EmitSound("npc/antlion_guard/shove1.wav")
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("npc/antlion_guard/shove1.wav")
end

function SWEP:PlayAttackSound()
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("npc/antlion_guard/angry"..math.random(3)..".wav", 75, 140)
	self:SetRoarEndTime(CurTime() + self.RoarTime)
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("NPC_FastZombie.Frenzy")
	self:SetRoarEndTime(CurTime() + self.RoarTime)
end

function SWEP:StartSwingingSound()
	self.Owner:EmitSound("npc/antlion_guard/shove1.wav")
end

function SWEP:StopSwingingSound()
	self.Owner:StopSound("npc/antlion_guard/shove1.wav")
end

function SWEP:IsMoaning()
	return false
end

function SWEP:Move(mv)
	if self:IsPouncing() or self:GetPounceTime() > 0 then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)
	elseif self:GetClimbing() then
		mv:SetMaxSpeed(0)
		mv:SetMaxClientSpeed(0)

		local owner = self.Owner
		local tr = self:GetClimbSurface()
		local angs = self.Owner:SyncAngles()
		local dir = tr and tr.Hit and (tr.HitNormal.z <= -0.5 and (angs:Forward() * -1) or math.abs(tr.HitNormal.z) < 0.75 and tr.HitNormal:Angle():Up()) or Vector(0, 0, 1)
		local vel = Vector(0, 0, 4)

		if owner:KeyDown(IN_FORWARD) then
			vel = vel + dir * 160
		end
		if owner:KeyDown(IN_BACK) then
			vel = vel + dir * -160
		end

		if vel.z == 4 then
			if owner:KeyDown(IN_MOVERIGHT) then
				vel = vel + angs:Right() * 60
			end
			if owner:KeyDown(IN_MOVELEFT) then
				vel = vel + angs:Right() * -60
			end
		end

		mv:SetVelocity(vel)

		return true
	elseif self:GetSwinging() then
		mv:SetMaxSpeed(math.min(mv:GetMaxSpeed(), 60))
		mv:SetMaxClientSpeed(math.min(mv:GetMaxClientSpeed(), 60))
	end
end

function SWEP:SetRoarEndTime(time)
	self:SetDTFloat(1, time)
end

function SWEP:GetRoarEndTime()
	return self:GetDTFloat(1)
end

function SWEP:IsRoaring()
	return CurTime() < self:GetRoarEndTime()
end

function SWEP:SetPounceTime(time)
	self:SetDTFloat(2, time)
end

function SWEP:GetPounceTime()
	return self:GetDTFloat(2)
end

function SWEP:SetPounceTime(time)
	self:SetDTFloat(2, time)
end

function SWEP:GetPounceTime()
	return self:GetDTFloat(2)
end

function SWEP:SetClimbing(climbing)
	self:SetDTBool(1, climbing)
end

function SWEP:GetClimbing()
	return self:GetDTBool(1)
end
SWEP.IsClimbing = SWEP.GetClimbing

function SWEP:SetSwinging(swinging)
	self:SetDTBool(2, swinging)
end

function SWEP:GetSwinging()
	return self:GetDTBool(2)
end

function SWEP:SetPouncing(leaping)
	self:SetDTBool(3, leaping)
end

function SWEP:GetPouncing()
	return self:GetDTBool(3)
end
SWEP.IsPouncing = SWEP.GetPouncing

if CLIENT then return end

function SWEP:Deploy()
	self.Owner:CreateAmbience("fastzombieambience")

	return self.BaseClass.Deploy(self)
end
