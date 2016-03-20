--Duby: Lets make a super cool games tag system for those special people!
if ( SERVER ) then

	local tags = {}
	tags["STEAM_0:0:59565612"] = { "[Head ZS Coder]  ", Color(255,0,0,255) }
	tags["STEAM_0:0:20139318"] = { "[Director Of Graphics]  ", Color(38,38,230,255) }
	tags["STEAM_0:0:11106290"] = { "[Lord Of the Servers]  ", Color(255,0,0,255) }
	tags["STEAM_0:0:41156486"] = { "[Alpha Tester]  ", Color(38,230,70,255) } --Patrick

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

if ( CLIENT ) then
local ply = LocalPlayer()
	local function OnPlayerChat( self, strText, bTeamOnly, bPlayerIsDead )
	 
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
			table.insert( tab, self:GetName() )
		else
			table.insert( tab, "Console" )
		end
	 
		table.insert( tab, Color( 255, 255, 255 ) )
		table.insert( tab, ": "..strText )
	 
		chat.AddText( unpack(tab) )
	 
		return true
	end

	hook.Add("OnPlayerChat", "OnPlayerChat", OnPlayerChat)
 

end


