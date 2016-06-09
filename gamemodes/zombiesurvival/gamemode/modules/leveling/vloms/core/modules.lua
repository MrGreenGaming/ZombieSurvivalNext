function VLoadModules()

	local fs, dirs = file.Find( 'modules/leveling/vloms/modules/*', 'LUA' )

	for i=1,#dirs do

		print( 'modules/leveling/vloms/modules/' .. dirs[i] )
		AddCSLuaFile( 'modules/leveling/vloms/modules/' .. dirs[i] .. '/module.lua' )	
		include( 'modules/leveling/vloms/modules/' .. dirs[i] .. '/module.lua' )

	end

	if (#fs > 0) then print( 'Found unused files in modules' ) end --Log if there's any unused files
	if (Vloms.Logging && Vloms.LoggingExtensive && #fs > 0) then PrintTable( fs ) end --Extensive log

end