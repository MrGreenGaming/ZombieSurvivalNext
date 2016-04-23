ITEM.Name = 'Borg Hat'
ITEM.Price = 350
ITEM.Model = 'models/Manhack.mdl'
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.8, 0)
	pos = pos + (ang:Right()) + (ang:Forward() * -3) + (ang:Up() * 3)
	
	return model, pos, ang
end
