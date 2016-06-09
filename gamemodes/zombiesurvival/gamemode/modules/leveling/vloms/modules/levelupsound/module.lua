if SERVER then

	hook.Add("VPlayerLevelUp", "VPlaySoundLevelUp", function(ply)

		if ply:Alive() then ply:EmitSound("vloms/levelup.wav", 500, 120) end

	end)

end