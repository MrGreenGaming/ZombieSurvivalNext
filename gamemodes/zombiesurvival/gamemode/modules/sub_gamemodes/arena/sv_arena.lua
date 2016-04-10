AddCSLuaFile("cl_arena.lua")
AddCSLuaFile("sh_arena.lua")

include("sh_arena.lua")

if not GM.Arena then return end

table.insert(GM.CleanupFilter, "func_brush")
table.insert(GM.CleanupFilter, "env_global")

hook.Add("InitPostEntityMap", "arena", function(fromze)
	for _, ent in pairs(ents.FindByClass("filter_activator_team")) do
		if ent.ZEFix then
			ent:SetKeyValue("filterteam", ent.ZEFix)
		end
	end

	for _, ent in pairs(ents.GetAll()) do
		if ent.ZEDelete then
			ent:Remove()
		end
	end

	if not fromze then
		GAMEMODE:SetRedeemBrains(0)
		if GAMEMODE.CurrentRound <= 1 then
			GAMEMODE:SetWaveStart(CurTime() + GAMEMODE.WaveZeroLength + 30) -- 30 extra seconds for late joiners
		else
			GAMEMODE:SetWaveStart(CurTime()  + 5)
		end
	end
end)

hook.Add("PlayerSpawn", "arena", function(pl)

end)


local CheckTime
local NextDamage = 0
hook.Add("Think", "arena", function()

	if CurTime() >= GAMEMODE:GetWaveStart() + GAMEMODE.ZE_TimeLimit and CurTime() >= NextDamage then
		NextDamage = CurTime() + 1

		for _, pl in pairs(team.GetPlayers(TEAM_HUMAN)) do
			pl:TakeDamage(5)
		end
	end

	local undead = team.GetPlayers(TEAM_UNDEAD)
	if #undead == 0 then return end

	for _, pl in pairs(undead) do
		if not pl.KilledByTriggerHurt or CurTime() > pl.KilledByTriggerHurt + 12 then
			CheckTime = nil
			return
		end
	end

	CheckTime = CheckTime or (CurTime() + 2.5)

	if CheckTime and CurTime() >= CheckTime then
		gamemode.Call("EndRound", TEAM_HUMAN)
	end
end)

hook.Add("DoPlayerDeath", "arena", function(pl, attacker, dmginfo)
	pl.KilledPos = pl:GetPos()

	if pl:Team() == TEAM_UNDEAD then
		if attacker:IsValid() and attacker:GetClass() == "trigger_hurt" --[[and dmginfo:GetDamage() >= 1000]] then
			pl.KilledByTriggerHurt = CurTime()
			pl.NextSpawnTime = CurTime() + 10
		elseif GAMEMODE.RoundEnded then
			pl.NextSpawnTime = CurTime() + 9999
		else
			pl.NextSpawnTime = CurTime() + 5
		end
	end
end)
