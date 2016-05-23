CLASS.Name = "Hate"
CLASS.TranslationName = "class_hate"
CLASS.Description = "description_hate"
CLASS.Help = "controls_hate"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = false

CLASS.FearPerInstance = 1

CLASS.Health = 4000
CLASS.SWEP = "weapon_zs_hateez"

--CLASS.Model = Model("models/zombie/flassic.mdl")
--CLASS.Model = Model("models/player/zombie_classic.mdl")
CLASS.Model = Model("models/Zombie/Poison.mdl")


CLASS.Speed = 170
CLASS.Points = 200

CLASS.PainSounds = {"zombies/hate/sawrunner_pain1.wav","zombies/hate/sawrunner_pain2.wav"}
CLASS.DeathSounds = {"npc/zombie_poison/pz_die1.wav","npc/zombie_poison/pz_die2.wav"}


CLASS.ModelScale = 1.5
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

function CLASS:CalcMainActivity(pl, velocity)

	if velocity:Length2D() <= 0.5 then
		pl.CalcIdeal = ACT_IDLE
	else
		pl.CalcIdeal = ACT_WALK
	end

	return true
end

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

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1, true)
		return ACT_INVALID
	end
end

local vecSpineOffset = Vector(5, 0, 0)
local SpineBones = {"ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Spine3"}
function CLASS:BuildBonePositions(pl)
	for _, bone in pairs(SpineBones) do
		local spineid = pl:LookupBone(bone)
		if spineid and spineid > 0 then
			pl:ManipulateBonePosition(spineid, vecSpineOffset)
		end
	end
--[[pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 5, 5), math.Rand( 11, 5)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 8, 5), math.Rand( -10, -10), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 8, 5), math.Rand( 0, 0), math.Rand( -10, -10)) )	--hand left
	

	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 8, 5), math.Rand( 0, 0), math.Rand( -10, -10)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 5, 5), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 8, 5), math.Rand( 5, 5), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 8, 5), math.Rand( 0, 0), math.Rand( -10, -10)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 8, 5), math.Rand( 0, 0), math.Rand( -10, -10)) )	--hand right
]]--
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)
end

local matSkin = Material("Models/Charple/Charple1_sheet")
--local matSkin = Material("models/flesh")
function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
end



if not CLIENT then return end

CLASS.Icon = "zombiesurvival/classmenu/hate"
