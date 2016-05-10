CLASS.Name = "Spitter"
CLASS.TranslationName = "class_spitter"
CLASS.Description = "description_spitter"
CLASS.Help = "controls_spitter"

CLASS.Model = Model("models/Zombie/Poison.mdl")

CLASS.Wave = 0
--CLASS.Threshold = 0
CLASS.Unlocked = false
CLASS.Hidden = true
--CLASS.Boss = true

CLASS.FearPerInstance = 1

CLASS.Health = 370
CLASS.SWEP = "weapon_zs_spitter"

CLASS.Mass = DEFAULT_MASS * 1.5

CLASS.Speed = 150
CLASS.Points = 20

CLASS.PainSounds = {"NPC_PoisonZombie.Pain"}
CLASS.DeathSounds = {Sound("npc/zombie_poison/pz_call1.wav")}

CLASS.VoicePitch = 0.5

CLASS.ModelScale = 1.2

CLASS.ViewOffset = Vector(0, 0, 75)
CLASS.ViewOffsetDucked = Vector(0, 0, 48)
CLASS.StepSize = 25

CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 64)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 35)}


CLASS.JumpPower = 225

function CLASS:CalcMainActivity(pl, velocity)
	if velocity:Length2D() <= 0.5 then
		pl.CalcIdeal = ACT_IDLE
	else
		pl.CalcIdeal = ACT_WALK
	end

	return true
end

local mathrandom = math.random
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 and mathrandom(3) < 3 then
		pl:EmitSound("NPC_PoisonZombie.FootstepRight")
	else
		pl:EmitSound("NPC_PoisonZombie.FootstepLeft")
	end

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 365 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 300
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 450
	end

	return 150
end


function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1, true)
		return ACT_INVALID
	end
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)
end


if SERVER then
	function CLASS:OnSpawned(pl)
		--pl:CreateAmbience("pukepusambience")
	end
end
--[[
local matSkin = Material("Models/Barnacle/barnacle_sheet")
function CLASS:PrePlayerDraw(pl)
	render.ModelMaterialOverride(matSkin)
end

function CLASS:PostPlayerDraw(pl)
	render.ModelMaterialOverride()
end]]--


--[[
local BonesToZero = {
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Forearsm",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32"
}
function CLASS:BuildBonePositions(pl)
	for _, bone in pairs(BonesToZero) do
		local boneid = pl:LookupBone(bone)
		if boneid and boneid > 0 then
			pl:ManipulateBoneScale(boneid, vector_tiny)
		end
	end
end]]--

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/classmenu/pukepuss"

local vecSpineOffset = Vector(0, 0, -15)

local vecSpineOffset2 = Vector(0, -5, -5)

local vecSpineOffset3 = Vector(-5, -5, -7)

local SpineBones = {"ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Spine3"}
local SpineBones2 = {"ValveBiped.Bip01_R_Hand","ValveBiped.Bip01_L_Hand","ValveBiped.Bip01_L_UpperArm"}


function CLASS:BuildBonePositions(pl)

	for _, bone in pairs(SpineBones) do
		local spineid = pl:LookupBone(bone)
		if spineid and spineid > 0 then
			pl:ManipulateBonePosition(spineid, vecSpineOffset)
		end
	end
	
	for _, bone in pairs(SpineBones2) do
		local spineid = pl:LookupBone(bone)
		if spineid and spineid > 0 then
			pl:ManipulateBonePosition(spineid, vecSpineOffset2)
		end
	end
	
	for _, bone in pairs(SpineBones2) do
		local spineid = pl:LookupBone(bone)
		if spineid and spineid > 0 then
			pl:ManipulateBonePosition(spineid, vecSpineOffset3)
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