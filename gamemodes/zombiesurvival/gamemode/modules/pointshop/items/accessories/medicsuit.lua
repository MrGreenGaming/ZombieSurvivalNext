ITEM.Name = 'Medic Suit'
ITEM.Price = 2000
ITEM.Model = 'models/items/healthkit.mdl'
ITEM.Bone = 'ValveBiped.Bip01_Spine2'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.5, 0)
	pos = pos + (ang:Right() * 5) + (ang:Up()) + (ang:Forward() * 2)
	
	ang:RotateAroundAxis(ang:Up(), 90)
	
	return model, pos, ang
end

function ITEM:Think(ply, modifications)
	--if ply:KeyDown(IN_JUMP) then
		--ply:SetVelocity(ply:GetUp() * 6)
	--end
end