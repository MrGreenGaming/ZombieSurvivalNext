--Duby: Tags... yea... Wooo....!
if ( SERVER ) then

	local tags = {}
	--Dev Team
	tags["STEAM_0:0:59565612"] = { "[Head ZS Coder] ", Color(800,0,0,255) }
	tags["STEAM_0:0:20139318"] = { "[Director Of Graphics] ", Color(38,38,230,255) }
	tags["STEAM_0:0:11106290"] = { "[Lord Of the Servers] ", Color(255,0,0,255) }
	tags["STEAM_0:0:20139318"] = { "[Cheese Cake Hax] ", Color(255,0,0,255) }
	
	--Our Humble Beta testers
	tags["STEAM_0:1:20607445"] = { "[β] ", Color(0,800,0,255) } --Rui
	tags["STEAM_0:0:35402477"] = { "[β] ", Color(0,800,0,255) } --Muppburg
	tags["STEAM_0:0:57410119"] = { "[β] ", Color(0,800,0,255) } --Pistol Mags
	tags["STEAM_0:1:16927564"] = { "[β] ", Color(0,800,0,255) } --The Real Freeman
	tags["STEAM_0:0:28757539"] = { "[β] ", Color(0,800,0,255) } --Green Cube
	tags["STEAM_0:0:8169277"] = { "[β] ", Color(0,800,0,255) } --AzoNa
	
	tags["STEAM_0:0:51930358"] = { "[OldFag] ", Color(0,800,0,255) } --Zoidburg
	tags["STEAM_0:1:50553529"] = { "[OldFag] ", Color(0,800,0,255) } --Rob	
	tags["STEAM_0:0:60372095"] = { "[OldFag] ", Color(0,800,0,255) } --Zarco
	tags["STEAM_0:0:30210736"] = { "[OldFag] ", Color(0,800,0,255) } --Antz	
	tags["STEAM_0:1:43653852"] = { "[OldFag] ", Color(0,800,0,255) } --Lejorah	
	tags["STEAM_0:1:6914195"] = { "[OldFag] ", Color(0,800,0,255) } --HodsHand
	tags["STEAM_0:0:23697677"] = { "[OldFag] ", Color(0,800,0,255) } --Stellathefella
	tags["STEAM_0:1:26630595"] = { "[OldFag] ", Color(0,800,0,255) } --LameShot
	tags["STEAM_0:1:14133131"] = { "[OldFag] ", Color(0,800,0,255) } --BrainDawg
	
	local Player = FindMetaTable("Player") 

	function Player:SetTag( tag, col )
		self:SetNetworkedString( "tag", tag )
		self:SetNetworkedInt("tag_r", col.r)
		self:SetNetworkedInt("tag_g", col.g)
		self:SetNetworkedInt("tag_b", col.b)
	end

	hook.Add("PlayerSpawn", "Player.SetTag", function( self )

		if tags[self:SteamID()] then
			self:SetTag( tags[self:SteamID()][1], tags[self:SteamID()][2] )
		end
		
	end)

end

--if ( CLIENT ) then

local function OnPlayerChat( self, strText, bTeamOnly, bPlayerIsDead )
	 local ply = LocalPlayer()
		-- I've made this all look more complicated than it is. Here's the easy version
		-- chat.AddText( ply:GetName(), Color( 255, 255, 255 ), ": ", strText )
	
	--chat.AddText( ply:GetName(), Color( 0, 100, 160, 255 ), ": ", strText )
		local tab = {}
	 
		if ( bPlayerIsDead ) then
			table.insert( tab, Color( 255, 30, 40 ) )
			table.insert( tab, "*DEAD* " )
		end

		if ( bTeamOnly ) then
			table.insert( tab, Color( 30, 160, 40 ) )
			table.insert( tab, "(TEAM) " )
		end

		if ( self.GetNetworkedString and self.GetNetworkedInt ) then

			local tag = self:GetNetworkedString("tag", "")

			if ( tag and tag != "" ) then
				local tagcolor = Color( self:GetNetworkedInt("tag_r", 0), self:GetNetworkedInt("tag_g", 0), self:GetNetworkedInt("tag_b", 0), 255 ) 
				table.insert( tab, tagcolor )
				table.insert( tab, tag )
			end

		end

		if ( IsValid( self ) ) then
			--table.insert( tab, self:GetName() )
			table.insert( tab, "" )
		else
			table.insert( tab, "Console" )
		end
	 
		--table.insert( tab, Color( 255, 255, 255 ) )
		--table.insert( tab, ""..self:GetName() .. ": "..strText )
		
		if ply:Team() == TEAM_ZOMBIE then
			table.insert( tab, Color( 198, 43, 43 ) )
			table.insert( tab, ""..self:GetName() .. ": " )
						table.insert( tab, Color( 255, 255, 255 ) )
			table.insert( tab, ""..strText )
		--end
		
		elseif ply:Team() == TEAM_SURVIVORS then
			table.insert( tab, Color( 43, 129, 198 ) )
			table.insert( tab, ""..self:GetName() .. ": ")
			table.insert( tab, Color( 255, 255, 255 ) )
			table.insert( tab, ""..strText )
		end
		
		chat.AddText( unpack(tab) )
	 
		return true
	end
	hook.Add("OnPlayerChat", "OnPlayerChat", OnPlayerChat)



