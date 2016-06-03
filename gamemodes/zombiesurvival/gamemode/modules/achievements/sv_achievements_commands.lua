Achievements = Achievements or {}

Achievements.List = Achievements.List or {}

Achievements.TagColor = "<c=0,200,0>" -- RGB - Only works with Atlas Chat because I am lazy asf. Sure you guys can fix it anyways :)

function Achievements.Add(name_recieved, displayname_recieved, description_recieved, callback_recieved)

	Achievements.List[name_recieved] = {
		name = name_recieved,
		displayname = displayname_recieved,
		description = description_recieved,
		callback = callback_recieved
	}

end

function Achievements.CheckAchievement(ply, str)
	
	if !IsValid(ply) then return end
	local achieved = ply:GetPData("achievement_" .. str) or 0
	return achieved

end

function Achievements.SetAchievement(ply, str, truefalse)
	
	if !IsValid(ply) then return end
	ply:SetPData("achievement_" .. str, truefalse)

end

function Achievements.ResetPlayer(ply)
	
	if !IsValid(ply) then return end
	
	for _,achievement in pairs(Achievements.List) do
		ply:SetPData("achievement_" .. achievement.name, 0)
	end

end

function Achievements.MessageLocal(ply, str)

	ply:PrintMessage(HUD_PRINTCENTER,str)
	ply:ChatPrint("[Achievements]" .. str)
	 
end

function Achievements.MessageGlobal(plyToSkip, str)

	for _,ply in pairs(player.GetAll()) do
		if ply != plyToSkip then
			ply:PrintMessage(HUD_PRINTCENTER,str)
			ply:ChatPrint("[Achievements]" .. str)
		end
	end

end

function Achievements.UpdatePly(ply)

	local completed = {}
	local listToSend = {}
	
	for _,achievement in pairs(Achievements.List) do
		table.insert(listToSend, {name = achievement.name, displayname = achievement.displayname, description = achievement.description})
		local check = Achievements.CheckAchievement(ply, achievement.name)
		if check != 0 then
			table.insert(completed, achievement.name)
		end
	end
	
	net.Start("achievements_updateply")
		net.WriteTable(listToSend)
		net.WriteTable(completed)
	net.Send(ply)

end