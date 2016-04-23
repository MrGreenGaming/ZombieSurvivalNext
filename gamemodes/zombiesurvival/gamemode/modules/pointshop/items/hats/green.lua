ITEM.Name = 'Greenies Hat'
ITEM.Price = 900
ITEM.Model = 'models/greenshat/greenshat.mdl'
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.8, 0)
	pos = pos + (ang:Right() * -0.01) + (ang:Forward() * -3) + (ang:Up() * 0.5)
	ang:RotateAroundAxis(ang:Up(), -180)
	return model, pos, ang
end
