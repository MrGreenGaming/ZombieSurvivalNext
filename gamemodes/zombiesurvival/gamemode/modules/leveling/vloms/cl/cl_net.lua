--// XP and Level

net.Receive( "VSendStats", function(length)

	local plystats = net.ReadTable()

	Vloms.XP = plystats['xp']
	Vloms.Level = plystats['lvl']

	Vloms.XPReq = VCalcXPReq(Vloms.Level)

end)

net.Receive( "VExperienceReceived", function(length)

	local xprec = net.ReadInt( 16 )
	Vloms.XP = Vloms.XP + xprec

	hook.Run( "VClPlayerGotXP", xprec )

end)

net.Receive( "VLevelUp", function(length)

	hook.Run( "VClPlayerLevelUp", net.ReadInt( 16 ) )

end)

--// Perks

net.Receive( "VPerks", function(length)

	Vloms.Perks = net.ReadTable()
	table.SortByMember( Vloms.Perks, 'lvl', function(a, b) return tonumber(a) > tonumber(b) end )

end)