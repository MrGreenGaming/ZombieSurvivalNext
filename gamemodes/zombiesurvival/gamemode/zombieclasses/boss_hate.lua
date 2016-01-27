CLASS.Name = "Hate"
CLASS.TranslationName = "class_hate"
CLASS.Description = "description_hate"
CLASS.Help = "controls_hate"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = false
CLASS.Boss = false

CLASS.FearPerInstance = 1

CLASS.Health = 4000
CLASS.SWEP = "weapon_zs_hate"

CLASS.Model = Model("models/Zombie/Poison.mdl")

CLASS.Speed = 185
CLASS.Points = 100

CLASS.PainSounds = {"player/zombies/hate/sawrunner_pain1.wav","player/zombies/hate/sawrunner_pain2.wav"}
CLASS.DeathSounds = {"npc/zombie_poison/pz_die1.wav","npc/zombie_poison/pz_die2.wav"}

--CLASS.VoicePitch = 0.5

CLASS.ModelScale = 1.6
CLASS.Mass = 200
CLASS.ViewOffset = Vector(0, 0, 75)
CLASS.ViewOffsetDucked = Vector(0, 0, 48)
--CLASS.StepSize = 20
--[[CLASS.Hull = {Vector(-22, -22, 0), Vector(22, 22, 96)}
CLASS.HullDuck = {Vector(-22, -22, 0), Vector(22, 22, 58)}]]

CLASS.JumpPower = 225

local ACT_IDLE = ACT_IDLE
local ACT_WALK = ACT_WALK
local STEPSOUNDTIME_NORMAL = STEPSOUNDTIME_NORMAL
local STEPSOUNDTIME_WATER_FOOT = STEPSOUNDTIME_WATER_FOOT
local STEPSOUNDTIME_ON_LADDER = STEPSOUNDTIME_ON_LADDER
local STEPSOUNDTIME_WATER_KNEE = STEPSOUNDTIME_WATER_KNEE


function CLASS:CalcMainActivity(pl, velocity)
	if velocity:Length2D() <= 0.5 then
		pl.CalcIdeal = ACT_IDLE
	else
		pl.CalcIdeal = ACT_WALK
	end

	return true
end

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

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	pl:FixModelAngles(velocity)

	local len2d = velocity:Length2D()
	if len2d > 0.5 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.5, 3))
	else
		pl:SetPlaybackRate(0.5)
	end

	return true
end

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("pukepusambience")
	end
end

local vecSpineOffset = Vector(10, 0, 0)
local SpineBones = {"ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Spine3"}

function CLASS:BuildBonePositions(pl)

	for _, bone in pairs(SpineBones) do
		--local spineid = pl:LookupBone(bone)
		--if spineid and spineid > 0 then
			--pl:ManipulateBonePosition(spineid, vecSpineOffset)
		--end
	end
	
	
		local Bone = pl:LookupBone("ValveBiped.Bip01_Spine4")
		if Bone then
			--pl:ManipulateBoneAngles( Bone, Angle(0,0,40)  )
			--pl:ManipulateBoneScale( Bone, Vector(1.9,1.9,1.9)  )
		end	
		
		--local Bone = pl:LookupBone("ValveBiped.Bip01_L_UpperArm")
		--if Bone then
		--	pl:ManipulateBoneAngles( Bone, Angle(270,0,0)  )
		--end
		
		--local Bone = pl:LookupBone("ValveBiped.Bip01_R_UpperArm")
		--if Bone then
			--pl:ManipulateBoneAngles( Bone, Angle(80,0,0)  )
		--end
		
		local Bone = pl:LookupBone("ValveBiped.Bip01_Spine")
		if Bone then
			pl:ManipulateBoneAngles( Bone, Angle(0,0,90)  )
			pl:ManipulateBoneScale( Bone, Vector(1.2,1.2,1.2)  )
		end
		
		local Bone = pl:LookupBone("ValveBiped.Bip01_Spine2")
		if Bone then
			pl:ManipulateBoneAngles( Bone, Angle(0,0, 270)  )
			pl:ManipulateBoneScale( Bone, Vector(1.2,1.2,1.2)  )
		end
		
		local Bone = pl:LookupBone("ValveBiped.Bip01_Spine4")
		if Bone then
			pl:ManipulateBoneAngles( Bone, Angle(0,0,0)  )
			--pl:ManipulateBoneScale( Bone, Vector(1.9,1.9,1.9)  )
		end	
		
		for i = 0, pl:GetBoneCount() - 1 do
			pl:ManipulateBoneScale( Bone, Vector(1.2,1.2,1.2)  )
		end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/killicons/pukepus"

--local matSkin = Material("Models/Barnacle/barnacle_sheet")
function CLASS:PrePlayerDraw(pl)
	--render.ModelMaterialOverride(matSkin)
end

function CLASS:PostPlayerDraw(pl)
	--render.ModelMaterialOverride()
end
