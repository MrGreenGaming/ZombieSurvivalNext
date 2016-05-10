include("shared.lua")

--Duby: Ported over some Green code..

ENT.Dinged = true


function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

local NextUse = 0
local vOffset = Vector(16, 0, 0)
local vOffset2 = Vector(-16, 0, 0)
local aOffset = Angle(0, 90, 90)
local aOffset2 = Angle(0, 270, 90)
local vOffsetEE = Vector(-15, 0, 8)


function ENT:Think()
	if MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN then
		if self.Dinged then
			if CurTime() < NextUse then
				self.Dinged = false
			end
		elseif CurTime() >= NextUse then
			self.Dinged = true

			self:EmitSound("zombiesurvival/ding.ogg")
		end
	end

	return true

end

function ENT:Draw()
	self:DrawModel()

	if not MySelf:IsValid() then return end

	local owner = self:GetObjectOwner()
	local ang = self:LocalToWorldAngles(aOffset)

	--self:RenderInfo(self:LocalToWorld(vOffset), ang, owner)
	--self:RenderInfo(self:LocalToWorld(vOffset2), self:LocalToWorldAngles(aOffset2), owner)
end

net.Receive("zs_nextresupplyuse", function(length)
	NextUse = net.ReadFloat()
end)
