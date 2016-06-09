if CLIENT then

	hook.Add('VClPlayerLevelUp', 'VNotifyPerkReceived', function( lvl )

		for i=1,#Vloms.Perks do
			
			if (Vloms.Perks[i]['lvl'] == lvl) then
				chat.AddText( Color(255, 255, 255, 255), 'Perk unlocked: ', Color(255, 165, 0, 255), Vloms.Perks[i]['name'] )
			end

		end

	end)

end