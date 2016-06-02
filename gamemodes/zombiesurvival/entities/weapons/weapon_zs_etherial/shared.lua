

if CLIENT then

	SWEP.PrintName = "Etherial"
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -72.75, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -69.2, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -68.004, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -58.772, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.871, -71.754, -22.512) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.777, 11.446, -35.982) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.693, 2.532, 25.214) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 16.1, -47.251) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 46.051) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(9.029, -52.984, -12.752) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -55.211, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.035, -8.169, -6.045) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(20.917, -14.115, -34.5) }
	}
		
	SWEP.VElements = {
		["hookright"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(23.111, 0.048, 1.35), angle = Angle(0, 90, -85.6), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hookleft"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(23.305, 0.048, -1.05), angle = Angle(180, 90, -85.6), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
	}
	
	
end

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDelay = 0.5
SWEP.MeleeReach = 54
SWEP.MeleeSize = 1.5
SWEP.MeleeDamage = 20
SWEP.MeleeDamageType = DMG_SLASH

SWEP.AlertDelay = 6

SWEP.Primary.Delay = 2

SWEP.ViewModel = Model("models/weapons/v_wraith.mdl")
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Secondary.Next = 3
SWEP.Secondary.Duration = 1


function SWEP:Initialize()
	self:HideWorldModel()
end

function SWEP:Precache()
	util.PrecacheSound("npc/antlion/distract1.wav")
	util.PrecacheSound("ambient/machines/slicer1.wav")
	util.PrecacheSound("ambient/machines/slicer2.wav")
	util.PrecacheSound("ambient/machines/slicer3.wav")
	util.PrecacheSound("ambient/machines/slicer4.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
end

function SWEP:StopMoaningSound()
end

function SWEP:StartMoaningSound()
	self.Owner:EmitSound("zombiesurvival/wraithdeath"..math.random(4)..".ogg")
end

function SWEP:PlayHitSound()
local pl = self.Owner
	self.Owner:EmitSound("ambient/machines/slicer"..math.random(4)..".wav", 90, 80)
end

function SWEP:PlayMissSound()
local pl = self.Owner
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 90, 80)
	pl:SetRenderMode(RENDERMODE_GLOW) pl:SetColor(Color(225,225,225,100))
end

function SWEP:PlayAttackSound()
local pl = self.Owner
	self.Owner:EmitSound("npc/antlion/distract1.wav")
end

function SWEP:Swung()
	self.Owner:SetMoveType(MOVETYPE_WALK)

	self.BaseClass.Swung(self)
end

function SWEP:StartSwinging()
	self.Owner:SetMoveType(MOVETYPE_NONE)

	self.BaseClass.StartSwinging(self)
end

local function viewpunch(ent, power)
	if ent:IsValid() and ent:Alive() then
		ent:ViewPunch(Angle(math.Rand(0.75, 1) * (math.random(0, 1) == 0 and 1 or -1), math.Rand(0.75, 1) * (math.random(0, 1) == 0 and 1 or -1), math.Rand(0.75, 1) * (math.random(0, 1) == 0 and 1 or -1)) * power)
	end
end

function SWEP:DoAlert()
	local owner = self.Owner

	owner:EmitSound("npc/stalker/go_alert2a.wav")
	owner:ViewPunch(Angle(-20, 0, math.Rand(-10, 10)))

	owner:LagCompensation(true)

	--[[local mouthpos = owner:EyePos() + owner:GetUp() * -3
	local screampos = mouthpos + owner:GetAimVector() * 16
	for _, ent in pairs(ents.FindInSphere(screampos, 92)) do
		if ent:IsPlayer() and ent:Team() ~= owner:Team() then
			local entearpos = ent:EyePos()
			local dist = screampos:Distance(entearpos)
			if dist <= 92 and TrueVisible(entearpos, screampos) then
				local power = (92 / dist - 1) * 2
				viewpunch(ent, power)
				for i=1, 5 do
					timer.Simple(0.15 * i, function() viewpunch(ent, power - i * 0.125) end)
				end
			end
		end
	end]]--

	owner:LagCompensation(false)
end

function SWEP:SecondaryAttack()

local mOwner = self.Owner
	if not IsValid(mOwner) then
		return
	end
	mOwner:SetRenderMode(RENDERMODE_GLOW) mOwner:SetColor(Color(225,225,225,100))
	--Delay next teleport
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
	self.Weapon:SetNextPrimaryFire(0.2)

	--Don't teleport in air
	if not mOwner:OnGround() then
		self:TeleportFail()
		return
	end

	--Trace from aim
	local aimTrace = util.TraceLine({
		start = mOwner:GetShootPos(),
		endpos = mOwner:GetShootPos() + (mOwner:GetAimVector() * 1000),
		filter = mOwner,
		mask = MASK_PLAYERSOLID_BRUSHONLY
	})
	if not aimTrace.Hit then -- or aimTrace.HitNormal ~= Vector(0, 0, 1) then
		self:TeleportFail()
		return
	end
	
	--Check distance
	if aimTrace.HitPos:Distance(aimTrace.StartPos) < 100 or aimTrace.HitPos:Distance(aimTrace.StartPos) > 1000 then
		self:TeleportFail()
		return
	end

	--Hulltrace that position
	--Keep trying with higher Z-axis value to allow teleporting on steep spots
	local safeHull, safeHullAttempts = false, 0
	local hullTrace
	while not safeHull and safeHullAttempts <= 26 do
		hullTrace = util.TraceHull({
			start = aimTrace.HitPos,
			endpos = aimTrace.HitPos,
			filter = mOwner,
			mins = Vector(-16, -16, 0),
			maxs = Vector(16, 16, 72)
		})

		if not hullTrace.Hit then
			safeHull = true
			break
		end

		--Raise Z-axis value with 1 unit for next loop
		aimTrace.HitPos.z = aimTrace.HitPos.z + 0.5

		safeHullAttempts = safeHullAttempts + 1
	end

	if not safeHull then
		self:TeleportFail()
		return
	end

	mOwner.IsWraithTeleporting = true
	
	-- Emit crazy sound
	if SERVER then
		mOwner:EmitSound(Sound("npc/stalker/stalker_scream"..math.random(1,4)..".wav"), 80, math.random(100, 115))
	end
	timer.Simple(0.2, function()
		if not SERVER or not IsValid( mOwner ) or not mOwner:IsZombie() then
			return
		end
		
		mOwner:EmitSound(Sound("npc/stalker/breathing3.wav"))
	end)
	
	--For effect
	timer.Simple(1.7, function()
		if not IsValid( mOwner ) then
			return
		end
		
		mOwner.IsWraithTeleporting = false
	end)
	
	--Take damage
	if SERVER then
		--mOwner:SetHealth(mOwner:Health() - (mOwner:GetMaximumHealth() * 0.1))
		
		--Pre-teleport smoke
		--TODO: Fix. This ain't working
		local eData = EffectData()
		eData:SetEntity( mOwner )
		eData:SetOrigin( mOwner:GetPos() )
		util.Effect("wraith_teleport_smoke", eData)

		-- Shake screen
		--mOwner:SendLua("WraithScream()")
	
		--Teleport
		mOwner:SetPos(hullTrace.HitPos)
	end

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Next)
	--Post teleport smoke
	timer.Simple(0.1, function()
		if not IsValid(mOwner) then
			return
		end

		local eData = EffectData()
		eData:SetEntity(mOwner)
		eData:SetOrigin(mOwner:GetPos())
		util.Effect("wraith_teleport_smoke", eData)
	end)
	
	if CLIENT then
		return
	end

end


-- Play teleport fail sound
function SWEP:TeleportFail()
	if not SERVER then
		return
	end
	
	if (self.TeleportWarnTime or 0) <= CurTime() then
		-- self.Owner:EmitSound( "npc/zombie_poison/pz_idle4.wav", 70, math.random( 92, 105 ) ) --Moo
		self.Owner:EmitSound(Sound("npc/stalker/stalker_ambient01.wav"), 70, 100)
		self.TeleportWarnTime = CurTime() + 0.97
	end
end

