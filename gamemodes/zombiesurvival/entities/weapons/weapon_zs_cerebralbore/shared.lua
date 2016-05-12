if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "pistol"

if CLIENT then
	SWEP.PrintName = "Cerebral Bore"			
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.ViewModelFlip = false
	
	SWEP.HUDFont 	= "HL2HUDIcons"
	SWEP.IconLetter = "."
	--killicon.AddFont("gr_weapon_lightgun", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
	--killicon.AddMaterial( "gr_weapon_cerebralbore", "killicon/gunrun/cerebralbore", Color(255, 80, 0, 255 ))
	--killicon.AddFont("gr_bore", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
	--killicon.AddMaterial( "gr_bore", "killicon/gunrun/cerebralbore", Color(255, 80, 0, 255 ))
	
	SWEP.VElements = {
		["gib1"] = { type = "Model", model = "models//Gibs/Shield_Scanner_Gib5.mdl", bone = "Python", pos = Vector(0.349, -0.888, 1.006), angle = Angle(120, -180, 0), size = Vector(0.368, 0.368, 0.368), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""},
		["flechette"] = { type = "Model", model = "models/weapons/hunter_flechette.mdl", bone = "Python", pos = Vector(0.811, -0.671, 12.8), angle = Angle(98.719, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""},
		["pickup"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "Python", pos = Vector(0, -0.575, 1.18), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(66, 70, 50, 255), surpresslightning = false, material = ""},
		["light"] = { type = "Sprite", sprite = "sprites/glow02", bone = "Python", pos = Vector(0, -0.838, 8.512), size = { x = 4.237, y = 4.237 }, color = Color(0, 255, 255, 10), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["gib3"] = { type = "Model", model = "models//Gibs/Shield_Scanner_Gib4.mdl", bone = "Python", pos = Vector(0.05, 0.2, -3.3), angle = Angle(-127.982, -81.088, -165.995), size = Vector(0.305, 0.305, 0.305), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""},
		["gib2"] = { type = "Model", model = "models//Gibs/Shield_Scanner_Gib6.mdl", bone = "Python", pos = Vector(-1.145, -0.313, 0.68), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""}
	}
	SWEP.WElements = {
		["gib1"] = { type = "Model", model = "models//Gibs/Shield_Scanner_Gib5.mdl", pos = Vector(7.031, 1.417, -4.52), angle = Angle(-5.52, -17.695, 80), size = Vector(0.368, 0.368, 0.368), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""},
		["flechette"] = { type = "Model", model = "models/weapons/hunter_flechette.mdl", pos = Vector(20, 0, -4.325), angle = Angle(0, -8.938, 90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""},
		["pickup"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", pos = Vector(8.331, 0.768, -4.369), angle = Angle(-92.07, 0.063, 0), size = Vector(0.5, 0.5, 0.5), color = Color(66, 70, 50, 255), surpresslightning = false, material = ""},
		["gib2"] = { type = "Model", model = "models//Gibs/Shield_Scanner_Gib6.mdl", pos = Vector(7.313, 0.342, -4.045), angle = Angle(-173.075, 73.606, 83.617), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""},
		["gib3"] = { type = "Model", model = "models//Gibs/Shield_Scanner_Gib4.mdl", pos = Vector(4.05, 1.12, -3.531), angle = Angle(-140.538, -9.388, -5.42), size = Vector(0.305, 0.305, 0.305), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""},
		["light"] = { type = "Sprite", sprite = "sprites/glow02", pos = Vector(16.412, 1.381, -4.757), size = { x = 4.237, y = 4.237 }, color = Color(0, 255, 255, 10), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.ViewModel			= "models/weapons/v_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"

SWEP.ViewModelFOV 		= 50

SWEP.Primary.Sound			= Sound( "weapons/ar2/fire1.wav" )
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 2

SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Automatic		= false

SWEP.Primary.Cone			= 0.025
SWEP.Primary.ConeMoving		= 0.055
SWEP.Primary.ConeCrouching	= 0.014

SWEP.MuzzleAttachment		= "muzzle"

SWEP.WeaponType				= "primary"

SWEP.IronSightsPos = Vector(-5.64, 0, 1.799)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:GetWeaponSoundLevelPitch()
	return 45, math.random( 140, 160 )
end

function SWEP:CanLaunch()

	local target = self:GetBoreTarget()
	if IsValid(target) then
		self.Weapon:EmitSound("Weapon_Pistol.Empty")
		return false 
	end
	
	return true
	
end

function SWEP:LaunchEntity()
	
	local target = self:GetBoreTarget()
	local launchdir = self.Owner:GetAimVector()
	local lookang = launchdir:Angle()
	local spawnpos = self.Owner:GetShootPos() + self.Owner:GetForward() * 6 + self.Owner:GetRight() * 9 + self.Owner:GetUp() * -1
	
	local bore = ents.Create("gr_bore")
	bore:SetPos( spawnpos )
	bore:Spawn()
	bore:SetAngles( lookang + Angle(-8,0,0) )
	bore:SetOwner( self.Owner )
	bore:Launch( launchdir )
	bore:SetBoreTarget( target )
	
	self:SetNWFloat("lastfired", CurTime())
	
end

SWEP.Target = nil
SWEP.TargetSet = 0

function SWEP:Think()

	if !IsValid(self.Owner) or CLIENT then return end

	local target = self:GetBoreTarget()
	local targetdot, targetdis, targetheadpos
	
	if (!IsValid(target) or target.HeadDrilled) then

		self:SetBoreTarget( NULL )
		target = nil
		
	else
		targetheadpos = target:GetPos()+Vector(0,0,60)
		targetdot = self.Owner:GetAimVector():Dot( (targetheadpos - self.Owner:EyePos()):GetNormal() )
		targetdis = target:GetPos():Distance(self.Owner:GetPos())
		
		if (!target:Alive() or  targetdis > 900 or targetdot < 0.7) then
			self:SetBoreTarget( NULL )
			target = nil
		end
	end

	for k, v in pairs(player.GetAll()) do
	
		if (v == target) then continue end
		--if (!IsValid(v) or !v:Alive() or v.HeadDrilled or (missionStatus.IsTeamMission() and self.Owner:GetContract() == v:GetContract()) ) then continue end
		
		local headpos = v:GetPos()+Vector(0,0,60)
		local pldot = self.Owner:GetAimVector():Dot( (headpos - self.Owner:EyePos()):GetNormal() )
		local pldis = v:GetPos():Distance(self.Owner:GetPos())
		if (pldot > 0.9 and pldis <= 900) then
		
			if IsValid(target) then
				// override target
				if (pldis < targetdis * 0.7 or pldot > targetdot) then
					target = v
					targetdis = pldis
					targetdot = pldot
				end
			else
				target = v
				targetdis = pldis
				targetdot = pldot
			end
		
		end	
	
	end
	
	if (target and target != self:GetBoreTarget()) then
		self:SetBoreTarget(target)
	end

end

function SWEP:SetBoreTarget( pl )
	self:SetNWEntity("target", pl)
end

function SWEP:GetBoreTarget()
	return self:GetNWEntity("target")
end

function SWEP:GetLastFired()
	return self:GetNWFloat("lastfired",0)
end

if CLIENT then
	
	function SWEP:OnInitialize()
	
		self.FlechettePos = self.VElements["flechette"].pos

	end
	
	function SWEP:Think()
	
		if (self.VElements["flechette"]) then
		
			local lastfired = self:GetLastFired()
			local diff = CurTime() - lastfired
			
			if (diff < 2) then
				
				self.VElements["flechette"].pos = self.FlechettePos + Vector(0,0,-10+diff*5)
				
			end
		
			if (self:Clip1() == 0) then
				self.VElements["flechette"].modelEnt:Remove()
				self.VElements["flechette"] = nil
				self.VElements["light"] = nil
				self.WElements["flechette"].modelEnt:Remove()
				self.WElements["flechette"] = nil
				self.WElements["light"] = nil
			end
		end
	
	end
	
	function SWEP:OnDrawHUD()

		local target = self:GetBoreTarget()
	
		if IsValid(target) then
			local bone = target:LookupBone("ValveBiped.Bip01_Head1")
			if !bone then return end
			
			local drawpos = target:GetBonePosition(bone):ToScreen()

			for i = 1, 4 do
			
				local angle = math.Rad2Deg(math.pi*0.5 * i + CurTime())
				local center = Vector( drawpos.x, drawpos.y, 0 )
				local vec1 = center + Angle(0, angle, 0):Forward() * (unit*13)
				local vec2 = center + Angle(0, angle+4, 0):Forward() * (unit*18)
				local vec3 = center + Angle(0, angle-4, 0):Forward() * (unit*18)

				draw.Triangle( vec1.x, vec1.y, vec2.x, vec2.y, vec3.x, vec3.y, COLOR_RED )
				
			end
			
			draw.HollowCircle( drawpos.x, drawpos.y, unit*10, unit*12, 16, COLOR_RED )

		end
		
	end

end

