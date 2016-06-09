Vloms.ResistancePerkOwners = {}

hook.Add('EntityTakeDamage', 'VDamageResistancePerk', function(target, dmginfo)

	if (table.HasValue(Vloms.ResistancePerkOwners, target)) then
		
		dmginfo:SetDamage( math.ceil( dmginfo:GetDamage() * 0.75 ) )

	end

end)

VRegisterPerk( true, 'Resistance', 30, 'You take 25% less damage', function( ply )

	if table.HasValue(Vloms.ResistancePerkOwners, ply) then return end --Don't add if already in the table
	Vloms.ResistancePerkOwners[#Vloms.ResistancePerkOwners+1] = ply

end)