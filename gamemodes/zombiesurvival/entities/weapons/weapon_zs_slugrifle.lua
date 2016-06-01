AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "M1014 Shotgun"
	SWEP.Description = ""
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.xm1014_Bolt"
	SWEP.HUD3DPos = Vector(-1, 0, 0)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02

	--SWEP.VElements = {
	--	["base"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360x2.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(0, -6, -9), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.094), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--	["base+"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "v_weapon.xm1014_Parent", rel = "base", pos = Vector(0, 0, 8.5), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 45), surpresslightning = false, material = "models/screenspace", skin = 0, bodygroup = {} },
		--["base++"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "v_weapon.xm1014_Parent", rel = "base", pos = Vector(0, 0, 2), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 45), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	--}

	--SWEP.WElements = {
	--	["base"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13, 1, -7), angle = Angle(80, 0, 0), size = Vector(0.014, 0.014, 0.094), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--	["base+"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 8.5), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 45), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--	["base++"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 2), angle = Angle(0, 0, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 45), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(0, -1.282, 2.513), angle = Angle(-90, 90, 0), size = Vector(0.5, 0.5, 1.126), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"
SWEP.UseHands = true


SWEP.Primary.Recoil	= 4
SWEP.Primary.Automatic = true
SWEP.Primary.Sound = Sound("Weapon_XM1014.Single")
SWEP.Primary.Damage = 50
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.25
SWEP.ReloadDelay = 0.5

SWEP.Primary.ClipSize = 6
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.055
SWEP.ConeMin = 0.0275

SWEP.IronSightsPos = Vector(-7.3, 9, 2.3) --Vector(-7.3, 9, 2.3)
SWEP.IronSightsAng = Vector(0, -1, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.NextReload = 0
SWEP.nextreloadfinish = 0

function SWEP:Reload()
	if self.reloading then
		return
	end
	if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		--self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_SHOTGUN)
	end

	self:SetIronsights(false)
end

function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
			self.nextreloadfinish = CurTime() + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		self.nextreloadfinish = 0
	end

	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
end

