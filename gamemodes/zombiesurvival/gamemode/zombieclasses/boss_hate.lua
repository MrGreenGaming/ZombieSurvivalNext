CLASS.Name = "Hate"
CLASS.TranslationName = "class_hate"
CLASS.Description = "description_hate"
CLASS.Help = "controls_hate"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = true

CLASS.FearPerInstance = 1

CLASS.Health = 3500
CLASS.SWEP = "weapon_zs_hateez"

CLASS.Model = Model("models/player/zombie_classic.mdl")

CLASS.Speed = 190
CLASS.Points = 200

CLASS.PainSounds = {"zombies/hate/sawrunner_pain1.wav","zombies/hate/sawrunner_pain2.wav"}
CLASS.DeathSounds = {"npc/zombie_poison/pz_die1.wav","npc/zombie_poison/pz_die2.wav"}


CLASS.ModelScale = 1.4
CLASS.Mass = 200

CLASS.ViewOffset = Vector(0, 0, 84)
CLASS.ViewOffsetDucked = Vector(0,0,38)
CLASS.Hull = { Vector(-16,-16, 0), Vector(16,16,97) }
CLASS.HullDuck = { Vector(-16,-16, 0), Vector(16,16,69) }


CLASS.StepSize = 30

CLASS.JumpPower = 225


local STEPSOUNDTIME_NORMAL = STEPSOUNDTIME_NORMAL
local STEPSOUNDTIME_WATER_FOOT = STEPSOUNDTIME_WATER_FOOT
local STEPSOUNDTIME_ON_LADDER = STEPSOUNDTIME_ON_LADDER
local STEPSOUNDTIME_WATER_KNEE = STEPSOUNDTIME_WATER_KNEE

local mathrandom = math.random
local StepSounds = {
	"npc/zombie_poison/pz_left_foot1.wav"
}
local ScuffSounds = {
	"npc/zombie_poison/pz_right_foot1.wav"
}


function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 and mathrandom() < 0.333 then
		pl:EmitSound(ScuffSounds[mathrandom(#ScuffSounds)], 80, 90)
	else
		pl:EmitSound(StepSounds[mathrandom(#StepSounds)], 80, 90)
	end

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return (365 - pl:GetVelocity():Length()) * 1.5
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 450
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 600
	end

	return 200
end



function CLASS:CalcMainActivity(pl, velocity)

	if pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_HL2MP_SWIM_PISTOL
		return true
	end

	if velocity:Length2D() <= 0.5 then
		if pl:Crouching() then
			pl.CalcIdeal = ACT_WALK_ON_FIRE
		else
			pl.CalcIdeal = ACT_IDLE_ON_FIRE
		end
		
	elseif pl:Crouching() then
		pl.CalcIdeal = ACT_WALK_ON_FIRE 
	else
		pl.CalcIdeal = ACT_WALK_ON_FIRE 
	end

	return true
end


function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL, true)
		return ACT_INVALID
	end
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)
end

local matSkin = Material("Models/Charple/Charple1_sheet")
function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
end

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("hateambience")
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/classmenu/hate"
