--Duby: W.I.P

CLASS.Name = "Lilith"
CLASS.TranslationName = ""
CLASS.Description = ""
CLASS.Help = ""

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = false

CLASS.NoShadow = true

CLASS.Health = 2400
CLASS.Speed = 180

CLASS.CanTaunt = false

CLASS.FearPerInstance = 1

CLASS.Points = 200

CLASS.SWEP = "weapon_zs_lilithez"

CLASS.Model = Model("models/player/corpse1.mdl")

CLASS.VoicePitch = 0.65

CLASS.PainSounds = {"zombies/seeker/pain1.wav","zombies/seeker/pain2.wav"}
CLASS.DeathSounds = {"npc/stalker/go_alert2a.wav"}


local ACT_HL2MP_SWIM_PISTOL = ACT_HL2MP_SWIM_PISTOL
local ACT_HL2MP_IDLE_CROUCH_ZOMBIE = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
local ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
local ACT_HL2MP_RUN_ZOMBIE = ACT_HL2MP_RUN_ZOMBIE

local mathrandom = math.random
local StepSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
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
			pl.CalcIdeal = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
		else
			pl.CalcIdeal = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01 - 1 + math.ceil((CurTime() / 4 + pl:EntIndex()) % 3)
		end
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE
	end

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
		return ACT_INVALID
	end
end

if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("nightmareambience")
	end
end

if not CLIENT then return end

local vecSpineOffset = Vector(10, 0, 0)
local SpineBones = {"ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Spine3"}

function CLASS:BuildBonePositions(pl)

	for _, bone in pairs(SpineBones) do
	end	
	
	local Bone = pl:LookupBone("ValveBiped.Bip01_Spine1")
		if Bone then
		 	pl:ManipulateBoneAngles(Bone, Angle(0,40,0))
		end	

		
		for i = 0, pl:GetBoneCount() - 1 do
			pl:ManipulateBoneScale( Bone, Vector(1.2,1.2,1.2)  )
		end
end

CLASS.Icon = "zombiesurvival/classmenu/seeker"