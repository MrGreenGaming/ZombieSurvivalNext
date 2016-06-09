if SERVER then

	CreateConVar( 'vloms_npckillxp', 5, FCVAR_NOTIFY, 'How much XP you get for killing an NPC' ) 

	hook.Add('OnNPCKilled', 'VXPFromNPCKill', function(attacker, inflictor)

		if (inflictor:IsPlayer() && IsValid(inflictor)) then
			
			inflictor:VGiveXP( GetConVarNumber( 'vloms_npckillxp' ) )

		end

	end)

end