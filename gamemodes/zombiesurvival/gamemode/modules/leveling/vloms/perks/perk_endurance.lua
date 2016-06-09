VRegisterPerk( true, 'Endurance I', 5, 'You spawn with +10 HP', function( ply )

	ply:SetMaxHealth( ply:GetMaxHealth() + 10 )
	ply:SetHealth( ply:Health() + 10 )

end)