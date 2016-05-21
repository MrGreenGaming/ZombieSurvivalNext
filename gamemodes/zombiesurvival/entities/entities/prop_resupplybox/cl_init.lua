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



function ENT:RenderInfo(pos, ang, owner)

	    self:DrawModel()

	    if not IsValid(MySelf) or MySelf:Team() ~= TEAM_HUMAN then
	        return
	    end

		if MySelf.MobileSupplyTimerActive == false then
	    	self.LineColor = Color(0, math.abs(200 * math.sin(CurTime() * 3)), 0, 100)
	    elseif self.LineColor ~= Color(210, 0, 0, 100) then
	    	self.LineColor = Color(210, 0, 0, 100)
	    end

	    --Draw some stuff
	    local pos = self:GetPos() + Vector(0,0,45)

	    --Check for distance with local player
	    if pos:Distance(MySelf:GetPos()) > 400 then
	        return
	    end
	          
	    local angle = (MySelf:GetPos() - pos):Angle()
	    angle.p = 0
	    angle.y = angle.y + 90
	    angle.r = angle.r + 90

	    cam.Start3D2D(pos,angle,0.26)

		local owner = self:GetObjectOwner()
		local validOwner = (IsValid(owner) and owner:Alive() and owner:Team() == TEAM_HUMAN)
		
				--Duby: Work on this soon!
		
		if GAMEMODE:GetWave() <= 0 then
				draw.SimpleTextOutlined( "Round Hasn't Started!", "ZSHUDFontSmalldebug", 0, 30, COLOR_DARKRED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			--end	
		elseif validOwner then
			if NextUse <= CurTime() then
				draw.SimpleTextOutlined( "Press E For Ammo", "ZSHUDFontSmalldebug", 0, 30, NextUse <= CurTime() and COLOR_GREEN or COLOR_DARKRED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			--end
		end
		
		end
	
		if validOwner then
			draw.SimpleTextOutlined( owner:Name() .."'s Mobile Supplies", "ZSHUDFontSmalldebug", 0, 0, NextUse <= CurTime() and COLOR_GREEN or COLOR_DARKRED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		else
			draw.SimpleTextOutlined( "Unclaimed Mobile Supplies", "ZSHUDFontSmalldebug", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		end
		
		if validOwner then
			if NextUse >= CurTime() then
				draw.SimpleTextOutlined(util.ToMinutesSeconds(math.max(0, NextUse - CurTime() )) , "ZSHUDFontSmalldebug", 0, 30, COLOR_DARKRED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			end
		end		

	    cam.End3D2D()

end

function ENT:Draw()
	self:DrawModel()

	if not MySelf:IsValid() then return end

	local owner = self:GetObjectOwner()
	local ang = self:LocalToWorldAngles(aOffset)

	self:RenderInfo(self:LocalToWorld(vOffset), ang, owner)
	self:RenderInfo(self:LocalToWorld(vOffset2), self:LocalToWorldAngles(aOffset2), owner)
end

net.Receive("zs_nextresupplyuse", function(length)
	NextUse = net.ReadFloat()
end)
