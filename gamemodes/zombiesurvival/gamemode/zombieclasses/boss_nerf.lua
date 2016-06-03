CLASS.Name = "Nerf"
CLASS.TranslationName = "class_nerf"
CLASS.Description = "description_nerf"
CLASS.Help = "controls_nerf"

CLASS.Wave = 0
CLASS.Threshold = 0
CLASS.Unlocked = true
CLASS.Hidden = true
CLASS.Boss = true

CLASS.Health = 2500
CLASS.Speed = 220

CLASS.FearPerInstance = 1

CLASS.Points = 150

CLASS.SWEP = "weapon_zs_nerf"

CLASS.Model = Model("models/player/zombie_fast.mdl")

CLASS.VoicePitch = 0.8
	
ModelScale = 0.5

CLASS.JumpPower = 260

CLASS.ViewOffset = Vector( 0, 0, 50 )
CLASS.ViewOffsetDucked = Vector( 0, 0, 24 )
CLASS.Hull = { Vector(-16, -16, 0), Vector(16, 16, 58) }
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}

--CLASS.PainSounds = {"npc/antlion_guard/growl_high.wav"}
CLASS.PainSounds = {"npc/antlion/pain1.wav", "npc/antlion/pain2.wav"}
CLASS.DeathSounds = {"npc/antlion_guard/antlion_guard_die1.wav"},{"npc/antlion_guard/antlion_guard_die2.wav"}

local STEPSOUNDTIME_NORMAL = STEPSOUNDTIME_NORMAL
local STEPSOUNDTIME_WATER_FOOT = STEPSOUNDTIME_WATER_FOOT
local STEPSOUNDTIME_ON_LADDER = STEPSOUNDTIME_ON_LADDER
local STEPSOUNDTIME_WATER_KNEE = STEPSOUNDTIME_WATER_KNEE
local ACT_ZOMBIE_LEAPING = ACT_ZOMBIE_LEAPING
local ACT_HL2MP_RUN_ZOMBIE_FAST = ACT_HL2MP_RUN_ZOMBIE_FAST

function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	if iFoot == 0 then
		pl:EmitSound("npc/antlion_guard/foot_light1.wav", 70, math.random(115, 120))
	else
		pl:EmitSound("npc/antlion_guard/foot_light2.wav", 70, math.random(115, 120))
	end

	return true
end

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 450 - pl:GetVelocity():Length()
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		return 400
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		return 550
	end

	return 250
end


function CLASS:CalcMainActivity(pl, velocity)
	local wep = pl:GetActiveWeapon()
	if not wep:IsValid() or not wep.GetClimbing then return end

	if wep:GetClimbing() then
		pl.CalcIdeal = ACT_ZOMBIE_CLIMB_UP
		return true
	elseif wep:GetPounceTime() > 0 then
		pl.CalcIdeal = ACT_ZOMBIE_LEAP_START
		return true
	end

	local speed = velocity:Length2D()
	if not pl:OnGround() or pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_ZOMBIE_LEAPING
	elseif speed <= 0.5 and wep:IsRoaring() then
		pl.CalcSeqOverride = pl:LookupSequence("menu_zombie_01")
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE_FAST
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local wep = pl:GetActiveWeapon()
	if not wep:IsValid() or not wep.GetClimbing then return end

	if wep:GetSwinging() then
		if not pl.PlayingFZSwing then
			pl.PlayingFZSwing = true
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY)
		end
	elseif pl.PlayingFZSwing then
		pl.PlayingFZSwing = false
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD) --pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY, true)
	end

	if wep:GetClimbing() then
		local vel = pl:GetVelocity()
		local speed = vel:Length()
		if speed > 8 then
			pl:SetPlaybackRate(math.Clamp(speed / 160, 0, 1) * (vel.z < 0 and -1 or 1))
		else
			pl:SetPlaybackRate(0)
		end

		return true
	end

	if wep:GetPounceTime() > 0 then
		pl:SetPlaybackRate(0.25)

		if not pl.m_PrevFrameCycle then
			pl.m_PrevFrameCycle = true
			pl:SetCycle(0)
		end

		return true
	elseif pl.m_PrevFrameCycle then
		pl.m_PrevFrameCycle = nil
	end

	local speed = velocity:Length2D()
	if not pl:OnGround() or pl:WaterLevel() >= 3 then
		pl:SetPlaybackRate(1)

		if pl:GetCycle() >= 1 then
			pl:SetCycle(pl:GetCycle() - 1)
		end

		return true
	end
	if speed <= 0.5 and wep:IsRoaring() then
		pl:SetPlaybackRate(0)
		pl:SetCycle(math.Clamp(1 - (wep:GetRoarEndTime() - CurTime()) / wep.RoarTime, 0, 1) * 0.9)

		return true
	end
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		return ACT_INVALID
	end
end

--[[function CLASS:CalcMainActivity(pl, velocity)
	if not pl:OnGround() or pl:WaterLevel() >= 3 then
		pl.CalcIdeal = ACT_ZOMBIE_LEAPING
	else
		pl.CalcIdeal = ACT_HL2MP_RUN_ZOMBIE_FAST
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	if not pl:OnGround() or pl:WaterLevel() >= 3 then
		pl:SetPlaybackRate(1)

		if pl:GetCycle() >= 1 then
			pl:SetCycle(pl:GetCycle() - 1)
		end

		return true
	end
end

function CLASS:Move(pl, mv)
	if mv:GetForwardSpeed() <= 0 then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.33)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.33)
	end
end

function CLASS:DoAnimationEvent(pl, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL, true)
		return ACT_INVALID
	end
end]]--

function CLASS:BuildBonePositions(pl)

	local bonemods ={
		["ValveBiped.Bip01_Head1"] = { scale = Vector(1.236, 1.236, 1.236), pos = Vector(-3.175, 6.052, -1.283), angle = Angle(-19.167, -64.113, 175.925) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1.381, 1.381, 1.381), pos = Vector(1.141, 5.885, 0), angle = Angle(17.159, 0, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(0.663, 0.663, 0.663), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_Pelvis"] = { scale = Vector(0.476, 0.476, 0.476), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.855, 1.855, 1.855), pos = Vector(1.363, 5.541, 4.993), angle = Angle(-33.896, 23.006, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.519, 0.519, 0.519), pos = Vector(-6.999, 0, 0), angle = Angle(42.909, 24.655, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.625, 0.625, 0.625), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-33.003, -33.201, 32.219) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.48, 1.48, 1.48), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	
		for k, v in pairs( bonemods ) do
			local bone = pl:LookupBone(k)
			if (not bone) then continue end
			pl:ManipulateBoneScale( bone, v.scale  )
			pl:ManipulateBoneAngles( bone, v.angle  )
			pl:ManipulateBonePosition( bone, v.pos  )
		end
	
end


if SERVER then
	function CLASS:OnSpawned(pl)
		pl:CreateAmbience("nightmareambience")
	end
end

if not CLIENT then return end

CLASS.Icon = "zombiesurvival/classmenu/nerf_2"
