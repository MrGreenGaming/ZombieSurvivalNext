util.AddNetworkString("VSendStats")
util.AddNetworkString("VExperienceReceived")
util.AddNetworkString("VLevelUp")
util.AddNetworkString("VPerks")

local pm = FindMetaTable("Player")

// XP and Level

function pm:VNetStats()

	local plystats = {}
	plystats['lvl'] = self.vlomslvl
	plystats['xp'] = self.vlomsxp

	net.Start( "VSendStats" )
		net.WriteTable( plystats )
	net.Send( self )

end

function pm:VNetXPReceived( amount )

	net.Start( "VExperienceReceived" )
		net.WriteInt( amount, 16 )
	net.Send( self )

end

function pm:VNetLevelUp( level )

	net.Start( "VLevelUp" )
		net.WriteInt( level, 16 )
	net.Send( self )

end

// PERKS

function pm:VNetPerks()

	net.Start( "VPerks" )
		net.WriteTable( Vloms.Perks )
	net.Send( self )

end