ITEM.Name = 'Scanner Hat'
ITEM.Price = 400
ITEM.Model = 'models/Gibs/Shield_Scanner_Gib3.mdl'
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.5, 0)
	pos = pos + (ang:Right() * 2) + (ang:Forward() * -3) + (ang:Up() * 1.9)
	
	return model, pos, ang
end
