--Duby: Mr.Greens classic Howler, originally created by Deluvas and ported to ZS 3.0 by Duby

CLASS.Name = "Howler"
CLASS.TranslationName = "class_howler_zombie"
CLASS.Description = "description_howler_zombie"
CLASS.Help = "controls_howler"

CLASS.Model = Model("models/mrgreen/howler.mdl")

CLASS.Wave = 1 / 3 
CLASS.Health = 140
CLASS.Speed = 160
CLASS.SWEP = "weapon_zs_howler"

CLASS.CanTaunt = false

CLASS.Mass = DEFAULT_MASS 

CLASS.Points = 6

function CLASS:PlayPainSound(pl)
	pl:EmitSound("player/zombies/howler/howler_mad_0"..math.random(4)..".mp3", 75, math.Rand(137, 143))

	return true
end

function CLASS:PlayDeathSound(pl)
	pl:EmitSound("player/zombies/howler/howler_death_01.mp3", 75, math.Rand(122, 128))

	return true
end

CLASS.VoicePitch = 0

local mathrandom = math.random
local StepSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
local ScuffSounds = {
	"npc/zombie/foot_slide1.wav",
	"npc/zombie/foot_slide2.wav",
	"npc/zombie/foot_slide3.wav"
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

function CLASS:Move(pl, mv)
	if pl:KeyDown(IN_SPEED) then
		move:SetMaxSpeed(150)
		move:SetMaxClientSpeed(150)
	end
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
	elseif pl:Crouching() then
		if velocity:Length2D() <= 0.5 then
			pl.CalcIdeal = ACT_IDLE_ON_FIRE
			--pl.CalcIdeal = ACT_IDLE_ON_FIRE
		else
		--	pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_ZOMBIE_02 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
			pl.CalcIdeal = ACT_WALK_ON_FIRE
		end
			elseif velocity:Length2D() <= 0.5 then
				--pl.CalcIdeal = ACT_WALK_ON_FIRE
			pl.CalcIdeal = ACT_IDLE_ON_FIRE
			else
		--	pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_ZOMBIE_02 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
				pl.CalcIdeal = ACT_WALK_ON_FIRE
			end
				--pl.CalcIdeal = ACT_WALK_ON_FIRE



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
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed, 3))
	else
		pl:SetPlaybackRate(1)
	end

	return true
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		--pl:AnimRestartGesture(ACT_WALK_ON_FIRE, ACT_WALK_ON_FIRE, true)
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
		--return ACT_WALK_ON_FIRE
		return ACT_INVALID
	end
end

function CLASS:DoesntGiveFear(pl)
	return pl.FeignDeath and pl.FeignDeath:IsValid()
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/classmenu/howler"
