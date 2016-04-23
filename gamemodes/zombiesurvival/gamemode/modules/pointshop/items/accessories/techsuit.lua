ITEM.Name = 'Tech Suit'
ITEM.Price = 11000
ITEM.Model = 'models/Weapons/w_annabelle.mdl'
ITEM.Bone = 'ValveBiped.Bip01_Spine2'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(1, 0)

	pos = pos + (ang:Right() * 5) + (ang:Up() / 12) + (ang:Forward() * 2)
	
	ang:RotateAroundAxis(ang:Right(), 180)
	
	return model, pos, ang
end

function ITEM:Think(ply, modifications)
	--if ply:KeyDown(IN_JUMP) then
		--ply:SetVelocity(ply:GetUp() * 6)
	--end
end