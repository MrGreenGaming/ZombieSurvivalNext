if SERVER then

	hook.Add("VPlayerLevelUp", "VNotifyOthersLevelUp", function(ply, lvl)

		for k,v in pairs(player.GetAll()) do

			if (v == ply) then return end --Not to self, we have something fancier for that

			v:ChatPrint(ply:Nick() .. ' has reached level ' .. lvl .. '!')

		end

	end)

end

if CLIENT then
	
	hook.Add('VClPlayerLevelUp', 'VNotifySelfLevelUp', function( lvl )

		chat.AddText( Color(255, 165, 0, 255), 'Congratulations! ', Color(255, 255, 255, 255), 'You reached level ', Color(255, 165, 0, 255), tostring(lvl), Color(255, 255, 255, 255), '!' )

	end)

end