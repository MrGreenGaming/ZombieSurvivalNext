local pm = FindMetaTable( 'Player' )

function pm:VSaveXP()

	self:SetPData( 'vlomsxp', self.vlomsxp )
	self:SetPData( 'vlomslvl', self.vlomslvl )

end

function pm:VLoadXP()

	self.vlomsxp = self:GetPData( 'vlomsxp', 0 )
	self.vlomslvl = self:GetPData( 'vlomslvl', 1 )

	self:VNetStats() --Networking

end