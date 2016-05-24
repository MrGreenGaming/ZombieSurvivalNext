CLASS.Name = "Behemoth"
CLASS.TranslationName = "class_behemoth"
CLASS.Description = "description_behemoth"
CLASS.Help = "controls_behemoth"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = false

CLASS.NoShadow = true

CLASS.Health = 2900
CLASS.Speed = 130

CLASS.CanTaunt = false

CLASS.FearPerInstance = 1

CLASS.ModelScale = 1.1
CLASS.Mass = 200

CLASS.Points = 200

CLASS.SWEP = "weapon_zs_behemothez"

CLASS.Model = Model("models/zombie/zombie_soldier.mdl")

CLASS.StepSize = 25

CLASS.VoicePitch = 0.65

CLASS.JumpPower = 225

CLASS.PainSounds = {
		Sound( "npc/strider/striderx_pain2.wav" ),
		Sound( "npc/strider/striderx_pain5.wav" ),
		Sound( "npc/strider/striderx_pain7.wav" ),
		Sound( "npc/strider/striderx_pain8.wav" )
}
	
CLASS.DeathSounds = {
		Sound("npc/strider/striderx_die1.wav")
}
	

local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

local mathrandom = math.random
local StepSounds = { 
	"npc/strider/strider_step1.wav",
	"npc/strider/strider_step2.wav",
	"npc/strider/strider_step3.wav",
	"npc/strider/strider_step4.wav",
	"npc/strider/strider_step5.wav",
	"npc/strider/strider_step6.wav"
}

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	pl:EmitSound(StepSounds[mathrandom(#StepSounds)], 70)

	return true
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

if SERVER then
	function CLASS:OnSpawned(pl)
		--pl:CreateAmbience("nightmareambience")
	end
end

if not CLIENT then return end

local vecSpineOffset = Vector(10, 0, 0)

function CLASS:BuildBonePositions(pl)

end

CLASS.Icon = "zombiesurvival/classmenu/behemouth"