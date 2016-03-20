include("shared.lua")

SWEP.PrintName = "Wraith"
SWEP.ViewModelFOV = 90

--[[function SWEP:Holster()
	if self.Owner:IsValid() and self.Owner == MySelf then
		self.Owner:SetBarricadeGhosting(false)
	end

	return self.BaseClass.Holster(self)
end]]

function SWEP:PreDrawViewModel(vm)
	self.Owner:CallZombieFunction("PrePlayerDraw")
end

function SWEP:PostDrawViewModel(vm)
	self.Owner:CallZombieFunction("PostPlayerDraw")
end

function SWEP:Think()
local pl = self.Owner
	--self.BaseClass.Think(self)

	--if self.Owner:IsValid() and MySelf == self.Owner then
		--self:BarricadeGhostingThink()
	--end
		pl:SetRenderMode(RENDERMODE_GLOW) pl:SetColor(Color(225,225,225,100))
end
