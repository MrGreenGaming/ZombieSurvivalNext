CLASS.Name = "Zombine"
CLASS.TranslationName = "class_zombine"
CLASS.Description = "description_zombine"
CLASS.Help = "controls_zombine"

CLASS.Wave = 6 / 6

CLASS.Health = 460
CLASS.Speed = 140

CLASS.Points = 3

CLASS.CanTaunt = true

CLASS.SWEP = "weapon_zs_zombine"

CLASS.Model = Model("models/player/zombie_soldier.mdl")

CLASS.VoicePitch = 0.7


local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

function CLASS:PlayPainSound(pl)
	pl:EmitSound("npc/zombie_poison/pz_warn"..math.random(2)..".wav", 75, math.Rand(137, 143))

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("npc/zombie_poison/pz_die2.wav", 75, math.Rand(122, 128))

	return true
end

local mathrandom = math.random
local StepSounds = {
	"npc/zombine/gear1.wav",
	"npc/zombine/gear2.wav",
	"npc/zombine/gear3.wav",
}
local ScuffSounds = {
	"npc/zombine/gear1.wav",
	"npc/zombine/gear2.wav",
	"npc/zombine/gear3.wav",
}

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if mathrandom() < 0.15 then
		pl:EmitSound(ScuffSounds[mathrandom(#ScuffSounds)], 70)
	else
		pl:EmitSound(StepSounds[mathrandom(#StepSounds)], 70)
	end

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 625 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 600
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 750
	end

	return 450
end

function CLASS:CalcMainActivity(pl, velocity)
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetDirection() == DIR_BACK then
			pl.CalcSeqOverride = pl:LookupSequence("zombie_slump_rise_02_fast")
		else
			pl.CalcIdeal = ACT_HL2MP_ZOMBIE_SLUMP_RISE
		end
		return true
	end

	if pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_HL2MP_SWIM_PISTOL
		return true
	end

	if velocity:Length2D() <= 0.5 then
		if pl:Crouching() then
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
		else
			pl.CalcIdeal = ACT_HL2MP_IDLE_ZOMBIE
		end
	elseif pl:Crouching() then
		pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_ZOMBIE_02 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
	else
		pl.CalcIdeal = ACT_HL2MP_WALK_ZOMBIE_02 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
	end
		
	local wep = pl:GetActiveWeapon() --Grenade Run!
	if wep:IsValid() and wep.GetCharge then
		local charge = wep:GetCharge()
		local vec2 = pl:GetShootPos() 
		if charge > 0 then
			pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE 
			return true
		end
	end
	
	return true
	
	

end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetState() == 1 then
			pl:SetCycle(1 - math.max(feign:GetStateEndTime() - CurTime(), 0) * 0.666)
		else
			pl:SetCycle(math.max(feign:GetStateEndTime() - CurTime(), 0) * 0.666)
		end
		pl:SetPlaybackRate(0)
		return true
	end

	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.666, 3))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
		return ACT_INVALID
	end
end

function CLASS:DoesntGiveFear(pl)
	return pl.FeignDeath and pl.FeignDeath:IsValid()
end


function CLASS:Move(pl, mv)
	local wep = pl:GetActiveWeapon()
	if wep.Move and wep:Move(mv) then
		return true
	end
end


if SERVER then
	function CLASS:CanPlayerSuicide(pl)
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() and wep.GetCharge and wep:GetCharge() > 0 then return false end
	end

	local function DoExplode(pl, pos, magnitude)
		local inflictor = pl:GetActiveWeapon()
		if not inflictor:IsValid() then inflictor = pl end
		
		local tbHumans = ents.FindHumansInSphere ( pl:GetPos(), pl.MaximumDist )
		local vPos = pl:GetPos()
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetMagnitude(magnitude)
		util.Effect("Explosion", effectdata, true)
		
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetMagnitude(magnitude)
		util.Effect("gib_player", effectdata, true)
		
		
		
		
		util.PoisonBlastDamage(inflictor, pl, pos, magnitude * 230, magnitude * 230, true)

		pl:CheckRedeem()
	end

	function CLASS:OnKilled(pl, attacker, inflictor, suicide, headshot, dmginfo, assister)
		local magnitude = 1
		local wep = pl:GetActiveWeapon()
		if wep:IsValid() and wep.GetCharge then magnitude = wep:GetCharge() end

		if magnitude == 0 then return end

		local pos = pl:WorldSpaceCenter()

		pl:Gib(dmginfo)
		timer.Simple(0, function() DoExplode(pl, pos, magnitude) end)

		return true
	end

end

function CLASS:BuildBonePositions(pl)
	
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/classmenu/zombine"

