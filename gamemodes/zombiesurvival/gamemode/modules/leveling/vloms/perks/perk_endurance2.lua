VRegisterPerk( true, 'Endurance II', 10, 'You spawn with +15 HP', function( ply )

	ply:SetMaxHealth( ply:GetMaxHealth() + 15 )
	ply:SetHealth( ply:Health() + 15 )

end)