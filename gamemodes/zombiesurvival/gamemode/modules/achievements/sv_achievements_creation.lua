if SERVER then

Achievements = Achievements or {}

Achievements.List = Achievements.List or {}

timer.Simple(0, function()

-- Achievements.Add("achievement_codename", "Display name", "Description", completed_function(ply))
Achievements.Add("first_kill", "First Kill!", "Get your first kill.", function(ply)

	if Achievements.CheckAchievement(ply, "first_kill") == 0 then
		Achievements.SetAchievement(ply, "first_kill", 1)
		Achievements.MessageLocal(ply, "Achievement unlocked: First Kill!")
		Achievements.MessageGlobal(ply, ply:Name() .. " unlocked: First Kill!")
	end

end)

Achievements.Add("50_deaths", "50 Attempts, 50 Failures.", "Die 50 times.", function(ply)

	local deaths = ply:GetPData("deaths") or 0
	local check = Achievements.CheckAchievement(ply, "50_deaths")

	if tonumber(check) == 0 and tonumber(deaths) >= 50 then
		Achievements.SetAchievement(ply, "50_deaths", 1)
		Achievements.MessageLocal(ply, "Achievement unlocked: 50 Attempts, 50 Failures.")
		Achievements.MessageGlobal(ply, ply:Name() .. " unlocked: 50 Attempts, 50 Failures.")
	end

end)

Achievements.Add("100_deaths", "You're getting good at this dying thing.", "Die 100 times.", function(ply)

	local deaths = ply:GetPData("deaths") or 0
	local check = Achievements.CheckAchievement(ply, "100_deaths")

	if tonumber(check) == 0 and tonumber(deaths) >= 100 then
		Achievements.SetAchievement(ply, "100_deaths", 1)
		Achievements.MessageLocal(ply, "Achievement unlocked: You're getting good at this dying thing.")
		Achievements.MessageGlobal(ply, ply:Name() .. " unlocked: You're getting good at this dying thing.")
	end

end)

Achievements.Add("1000_deaths", "Holy crap. You're shit.", "Die 1000 times.", function(ply)

	local deaths = ply:GetPData("deaths") or 0
	local check = Achievements.CheckAchievement(ply, "1000_deaths")

	if tonumber(check) == 0 and tonumber(deaths) >= 1000 then
		Achievements.SetAchievement(ply, "1000_deaths", 1)
		Achievements.MessageLocal(ply, "Achievement unlocked: Holy crap. You're shit.")
		Achievements.MessageGlobal(ply, ply:Name() .. " unlocked: Holy crap. You're shit.")
	end

end)

Achievements.Add("50_kills", "Sargent", "Get 50 kills.", function(ply)

	local kills = ply:GetPData("kills") or 0
	local check = Achievements.CheckAchievement(ply, "50_kills")

	if tonumber(check) == 0 and tonumber(kills) >= 50 then
		Achievements.SetAchievement(ply, "50_kills", 1)
		Achievements.MessageLocal(ply, "Achievement unlocked: Rank Sargent")
		Achievements.MessageGlobal(ply, ply:Name() .. " unlocked: Rank Sargent")
	end

end)

Achievements.Add("100_kills", "Captain", "Get 100 kills.", function(ply)

	local kills = ply:GetPData("kills") or 0
	local check = Achievements.CheckAchievement(ply, "100_kills")

	if tonumber(check) == 0 and tonumber(kills) >= 100 then
		Achievements.SetAchievement(ply, "100_kills", 1)
		Achievements.MessageLocal(ply, "Achievement unlocked: Rank Captain")
		Achievements.MessageGlobal(ply, ply:Name() .. " unlocked: Rank Captain")
	end

end)

Achievements.Add("1000_kills", "Cononel", "Get 1000 kills.", function(ply)

	local kills = ply:GetPData("kills") or 0
	local check = Achievements.CheckAchievement(ply, "1000_kills")

	if tonumber(check) == 0 and tonumber(kills) >= 1000 then
		Achievements.SetAchievement(ply, "1000_kills", 1)
		Achievements.MessageLocal(ply, "Achievement unlocked: Rank Cononel")
		Achievements.MessageGlobal(ply, ply:Name() .. " unlocked: Rank Cononel")
	end

end)

hook.Add("DoPlayerDeath", "Achievement_PlayerDeath", function(victim, attacker, dmg)

	if victim != attacker then
		local victimDeaths = victim:GetPData("deaths") or 0
		local attackerKills = attacker:GetPData("kills") or 0
		victim:SetPData("deaths", victimDeaths + 1)
		attacker:SetPData("kills", attackerKills + 1)
		for _,achievement in pairs(Achievements.List) do
			-- Achievement: First Kill!
			if achievement.name == "first_kill" then
				achievement.callback(attacker)
			end			
			-- Achievement: 50 Attempts, 50 Failures.
			if achievement.name == "50_deaths" then
				achievement.callback(victim)
			end
			-- Achievement: You're getting good at this dying thing.
			if achievement.name == "100_deaths" then
				achievement.callback(victim)
			end
			-- Achievement: Holy crap. You're shit.
			if achievement.name == "1000_deaths" then
				achievement.callback(victim)
			end
			-- Achievement: I bet they were all no-scopes.
			if achievement.name == "50_kills" then
				achievement.callback(attacker)
			end
			-- Achievement: Sorry KennyS, don't hurt me
			if achievement.name == "100_kills" then
				achievement.callback(attacker)
			end
			-- Achievement: I bet you feel cool.
			if achievement.name == "1000_kills" then
				achievement.callback(attacker)
			end
		end
	end
	
end)

Achievements.Add("become_staff", "Become Staff!", "Get a staff rank on the server.", function(ply)

	if Achievements.CheckAchievement(ply, "become_staff") == 0 then
		Achievements.SetAchievement(ply, "become_staff", 1)
		Achievements.MessageLocal(ply, "Achievement unlocked: Become Staff!")
		Achievements.MessageGlobal(ply, ply:Name() .. " unlocked: Become Staff!")
	end

end)

Achievements.Add("full_server", "Helping Out!", "Play on a full server.", function(ply)

	if Achievements.CheckAchievement(ply, "full_server") == 0 then
		Achievements.SetAchievement(ply, "full_server", 1)
		Achievements.MessageLocal(ply, "Achievement unlocked: Helping Out!")
		Achievements.MessageGlobal(ply, ply:Name() .. " unlocked: Helping Out!")
	end

end)


hook.Add("PlayerSpawn", "Achievement_PlayerSpawn", function(ply) -- Makes it possible to actually get the achievement now
	
	local playerCount = 0
	for _,plyr in pairs(player.GetAll()) do
		playerCount = playerCount + 1
	end
	-- Achievement: Helping Out!
	if playerCount == tonumber(game.MaxPlayers) then -- What is the max players is not 32? huh
		for _,achievement in pairs(Achievements.List) do
			if achievement.name == "full_server" then
				for _,playr in pairs(player.GetAll()) do
					achievement.callback(playr)
				end
			end
		end
	end
	
	-- Achievement: Become Staff!
	if ply:GetUserGroup() == "trialmoderator" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "moderatorpremium" or ply:IsAdmin() or ply:IsSuperAdmin() or ply:GetUserGroup() == "headstaff" or ply:GetUserGroup() == "co-owner" or ply:GetUserGroup() == "owner" then
		for _,achievement in pairs(Achievements.List) do
			if achievement.name == "become_staff" then
				achievement.callback(playr)
			end
		end
	end

end)

end)

end
