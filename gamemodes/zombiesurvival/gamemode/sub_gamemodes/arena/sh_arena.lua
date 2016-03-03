if string.sub(string.lower(game.GetMap()), 1, 3) ~= "za_" then return end

ARENA = true
GM.Arena = true
GM.WaveZeroLength = 90
GM.EndGameTime = 35
GM.ZE_TimeLimit = 60 * 16

if SERVER then
	local AmmoAmount = 40
	timer.Create("GiveArenaAmmo", 40, 0, function()
		local Humans = team.GetPlayers(TEAM_HUMAN)

		for i=1, #Humans do
			local pl = Humans[i]
			if not IsValid(pl) or not pl:Alive() then
				continue
			end
			pl:GiveAmmo(AmmoAmount, "ar2", false)
			pl:GiveAmmo(AmmoAmount, "smg1", false)
			pl:GiveAmmo(AmmoAmount, "buckshot", false)
			pl:GiveAmmo(AmmoAmount, "pistol", false)
			pl:GiveAmmo(AmmoAmount, "357", false)
		end
			--chat.AddText( Color( 255, 0, 0 ), "Ammo Regenerated" )
		--Debug("[ARENA] Gave ".. #Humans .." extra ammo")
		
	end)
end

--GM.DefaultZombieClass = GM.ZombieClasses["Super Zombie"].Index
GM.DefaultZombieClass = GM.ZombieClasses[table.Random( {
	"Fresh Dead",
	"Howler",
	"Poison Zombie" } )].Index --Random zombies
	
--[[
function GM:GetZombieDamageScale(pos, ignore)
	return self.ZombieDamageMultiplier
end]]--
-- Creates some dummy entities so we don't get spammed in the console.

local ENT = {}

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_NONE

function ENT:Initialize()
	self:SetNoDraw(true)
end

if SERVER then
function ENT:Think()
	self:Remove()
end
end
--[[
hook.Add("Initialize", "RegisterDummyEntities", function()
	scripted_ents.Register(ENT, "weapon_elite")
	scripted_ents.Register(ENT, "weapon_knife")
	scripted_ents.Register(ENT, "weapon_deagle")
	scripted_ents.Register(ENT, "ammo_50ae")
	scripted_ents.Register(ENT, "ammo_556mm_box")
	scripted_ents.Register(ENT, "player_weaponstrip")
end)
]]--