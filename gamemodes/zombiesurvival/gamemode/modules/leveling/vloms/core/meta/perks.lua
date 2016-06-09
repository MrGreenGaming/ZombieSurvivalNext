local pm = FindMetaTable( 'Player' )

function pm:VFetchPerks()

	if (self.vlomsperks == nil) then self.vlomsperks = {} end --Safety

	for i=1,#Vloms.Perks do
		
		if (!table.HasValue(self.vlomsperks, i) && (tonumber(Vloms.Perks[i]['lvl']) <= tonumber(self.vlomslvl))) then
			self.vlomsperks[#self.vlomsperks+1] = i
		end

	end

end