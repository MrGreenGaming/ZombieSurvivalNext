include('shared.lua')

if CLIENT then
SWEP.PrintName			= "Dual Classic Pistols"			
SWEP.Slot				= 1							
SWEP.SlotPos			= 1							

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {}


SWEP.WElements = {
	["akimbo"] = { type = "Model", model = "models/weapons/w_pistol.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(5.754, 0.828, 2.726), angle = Angle(5.708, 180, 0), size = Vector(0.94, 0.94, 0.94), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["akimbo2"] = { type = "Model", model = "models/weapons/w_pistol.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.754, 0.828, -3.726), angle = Angle(5.708, 180, 180), size = Vector(0.94, 0.94, 0.94), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

end