CLASS.Name = "Behemoth"
CLASS.TranslationName = "class_behemoth"
CLASS.Description = "description_behemoth"
CLASS.Help = "controls_behemoth"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = true

CLASS.NoShadow = true

CLASS.Health = 2900
CLASS.Speed = 130

CLASS.CanTaunt = false

CLASS.FearPerInstance = 1

CLASS.ModelScale = 1.1
CLASS.Mass = 200

CLASS.Points = 200

CLASS.SWEP = "weapon_zs_behemothez"

CLASS.Model = Model("models/player/zombie_soldier.mdl")

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
	if pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_HL2MP_SWIM_PISTOL
	elseif pl:Crouching() then
		if velocity:Length2D() <= 0.5 then
			pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
		else
			pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
		end
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
	end
	
	local wep = pl:GetActiveWeapon()

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
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
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
	--	pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL, true)
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
