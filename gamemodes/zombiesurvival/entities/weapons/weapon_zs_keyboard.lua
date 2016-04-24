AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Keyboard"

	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -45.715, 0) },
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -49.524, 0) }
	}
	SWEP.VElements = {
		["keyboard"] = { type = "Model", model = "models/props/cs_office/computer_keyboard.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.147, 1.246, -6.666), angle = Angle(0, -180, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	--SWEP.WElements = {
	--	["base"] = { type = "Model", model = "models/props/cs_office/computer_keyboard.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 4.091, -8.636), angle = Angle(180, -60.341, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	--}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_keyboard.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 35
SWEP.MeleeRange = 52
SWEP.MeleeSize = 1.25

SWEP.Primary.Delay = 0.75

SWEP.SwingTime = 0.3
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingHoldType = "grenade"

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/keyboard/keyboard_hit-0"..math.random(4)..".ogg")
end
