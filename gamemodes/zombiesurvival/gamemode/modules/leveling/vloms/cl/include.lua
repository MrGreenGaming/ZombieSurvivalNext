local function VAddLuaFile( file ) 

	print( file )
	AddCSLuaFile( file )

end

VAddLuaFile('modules/leveling/vloms/cl/cl_init.lua')
VAddLuaFile('modules/leveling/vloms/cl/cl_net.lua')
VAddLuaFile('modules/leveling/vloms/cl/cl_perks.lua')
VAddLuaFile('modules/leveling/vloms/cl/ui/fonts.lua')
VAddLuaFile('modules/leveling/vloms/cl/ui/cl_hud.lua')
VAddLuaFile('modules/leveling/vloms/cl/ui/cl_perksmenu.lua')

--// Resources

resource.AddFile('sound/vloms/yay.wav')
resource.AddFile('materials/vloms/perklocked.png')
resource.AddFile('materials/vloms/perkunlocked.png')