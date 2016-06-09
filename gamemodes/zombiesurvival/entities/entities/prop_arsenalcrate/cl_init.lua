include("shared.lua")

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))
	
	local entities = ents.FindByClass("prop_arsenalcrate")
	
		hook.Add("PreDrawHalos", "DrawHalo", function()
			halo.Add(entities, Color( 0, 255, 0 ), 0, 0, 0.5, true, true)
		end)

end

function ENT:OnRemove()
	hook.Remove("PreDrawHalos", "DrawHalo", function()
		halo.Add(ents.FindByClass("prop_arsenalcrate"), Color( 0, 255, 0 ), 0, 0, 1, true, true)
	end)
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

ENT.LineColor = Color(210, 0, 0, 100)
local colFlash = Color(30, 255, 30)
function ENT:Draw()
	

	if not MySelf:IsValid() then return end

	    self:DrawModel()

	    if not IsValid(MySelf) or MySelf:Team() ~= TEAM_HUMAN then
	        return
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

	    cam.Start3D2D(pos,angle,0.12)

		local owner = self:GetObjectOwner()
		local validOwner = (IsValid(owner) and owner:Alive() and owner:Team() == TEAM_HUMAN)
		
		if GAMEMODE:GetWave() <= 0 then
			self.LineColor = Color(0, math.abs(200 * math.sin(CurTime() * 3)), 0, 100)
			draw.SimpleTextOutlined( "Round Hasn't Started!", "ZSHUDFontTinySpecial", 0, 30, COLOR_DARKRED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		else
			self.LineColor = Color(210, 0, 0, 100)
			draw.SimpleTextOutlined( "Supplies Available", "ZSHUDFontTinySpecial", 0, 30, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))		
		end	
	
		if validOwner then
			draw.SimpleTextOutlined( owner:Name() .."'s Supplies", "ZSHUDFontTinySpecial", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		else
			draw.SimpleTextOutlined( "Supplies", "ZSHUDFontTinySpecial", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		end
	
	    cam.End3D2D()

		self:DrawModel()
end

