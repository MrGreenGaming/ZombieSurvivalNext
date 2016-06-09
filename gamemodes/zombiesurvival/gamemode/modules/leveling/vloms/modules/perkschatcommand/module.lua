if SERVER then

	hook.Add( "PlayerSay", "VOpenPerkMenuSay", function( ply, text, public )

		text = string.lower( text )

		if ( string.sub( text, 1 ) == "!perks" ) then
			ply:ConCommand( 'vperks' ) 
			return false
		end

	end )

end