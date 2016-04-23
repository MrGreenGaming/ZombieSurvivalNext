ITEM.Name = 'Sombrero'
ITEM.Price = 120
ITEM.Model = 'models/props_junk/sawblade001a.mdl'
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.5, 0)
	pos = pos + (ang:Right() * -0.01) + (ang:Forward() * -3) + (ang:Up() * 0.5)
	
	return model, pos, ang
end
