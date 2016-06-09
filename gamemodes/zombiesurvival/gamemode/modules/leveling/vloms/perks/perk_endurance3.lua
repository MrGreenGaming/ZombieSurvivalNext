VRegisterPerk( true, 'Endurance III', 20, 'You spawn with +25 HP', function( ply )

	ply:SetMaxHealth( ply:GetMaxHealth() + 25 )
	ply:SetHealth( ply:Health() + 25 )

end)