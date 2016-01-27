-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--Duby: I need to re-make this properly tbh..
function RollTheDice ( pl,commandName,args )
	if ENDROUND then
		return
	end

	if not (pl:IsValid() and pl:Alive() and not ENDROUND) then
		return
	end
	
	if CurTime() < (WARMUPTIME+10) then
		pl:ChatPrint("Dice temporarily disabled at round start")
		return
	end
	
	if pl.LastRTD >= CurTime() then
		pl:PrintMessage(HUD_PRINTTALK, "You have to wait "..math.floor((pl.LastRTD-CurTime())).." more seconds before you can roll the dice!")
		return
	end
	
	
	
	local choise,message,name
	
--[[	--Let's roll
	choise = math.random(1,5)
	--Second roll when having ladyluck-item
	if pl:HasBought("ladyluck") and choise <= 2 then
		choise = math.random(1,5)
	end
	
	if pl:HasBought("ladyluck") and choise <= 1 then
		choise = math.random(1,5)
		
	end]]--
	
	choise = math.random(1,6)
	
	if pl:HasBought("ladyluck") and choise <= 2 then
		choise = math.random(3,6) -- second chance with bad outcome
	end
	
	message = pl:GetName()

	if choise == 1 then
		if pl:Team() == TEAM_HUMAN then	
	
			specialitems = { "weapon_zs_special_chembomb", "weapon_zs_special_vodka", "weapon_zs_special_bottleofwine"}
			message = "WIN: ".. message .." rolled the dice and got a special item!"
			pl:Give(table.Random(specialitems))		
		elseif pl:Team() == TEAM_UNDEAD then	
			pl:AddScore(1)
			message = "WIN: ".. message .." rolled the dice and has found a piece of brain!"
		end
	elseif choise == 2 then
		if pl:Team() == TEAM_HUMAN then
			message = "LOSE: ".. message .." rolled the dice and got raped in the ass."
			pl:SetHealth(1)
		elseif pl:Team() == TEAM_UNDEAD then
			local calchealth = math.Clamp ( 200 - pl:Health(),60,200 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth(pl:Health() + randhealth)
			message = "WIN: ".. message .." rolled the dice and gained ".. randhealth .."KG of flesh!!"
		end
	elseif choise == 3 then
		if pl:Team() == TEAM_HUMAN then
				if pl:HasBought("ladyluck") or math.random (1,2) == 1 then
		
			pl:GiveAmmo( 120, "pistol" )	
			pl:GiveAmmo( 80, "ar2" )
			pl:GiveAmmo( 120, "SMG1" )	
			pl:GiveAmmo( 80, "buckshot" )		
			pl:GiveAmmo( 8, "XBowBolt" )
			pl:GiveAmmo( 50, "357" )
			message = "WIN: ".. message .." rolled the dice and received extra ammo from lady luck!"		
		else
			pl:GiveAmmo( 90, "pistol" )	
			pl:GiveAmmo( 60, "ar2" )
			pl:GiveAmmo( 90, "SMG1" )	
			pl:GiveAmmo( 60, "buckshot" )		
			pl:GiveAmmo( 5, "XBowBolt" )
			pl:GiveAmmo( 30, "357" )
			message = "WIN: ".. message .." rolled the dice and received some ammo!"	
		end	
		elseif pl:Team() == TEAM_UNDEAD then
			local calchealth = math.Clamp ( 100 - pl:Health(),60,100 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth(math.max(pl:Health() - randhealth, 1))
			message = "LOSE: ".. message .." rolled the dice and lost ".. randhealth .."KG of flesh!!"
		end
	elseif choise == 4 and pl:Health() < pl:GetMaximumHealth() then
		if pl:Team() == TEAM_HUMAN then
			local calchealth = math.Clamp ( 100 - pl:Health(),25,100 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth( math.min( pl:Health() + randhealth, pl:GetMaximumHealth() ) )
			message = "WIN: ".. message .." rolled the dice and gained ".. randhealth .." health!"
		elseif pl:Team() == TEAM_UNDEAD then
			local calchealth = math.Clamp ( 200 - pl:Health(),60,200 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth( pl:Health() + randhealth)
			message = "WIN: ".. message .." rolled the dice and gained ".. randhealth .."KG of flesh!!"
		end
	elseif choise == 5 then
		if pl:Team() == TEAM_HUMAN then
			pl:Ignite( math.random(1,4), 0)
			message = "LOSE: "..message.." was put on fire by the dice."
		elseif pl:Team() == TEAM_UNDEAD then
			pl.BrainsEaten = pl.BrainsEaten - 1
			message = "LOSE: ".. message .." rolled the dice and has lost a piece of brain!"
		end
	elseif choise == 6 then
		if pl:Team() == TEAM_HUMAN then
			message = message .. ".. rolled the dice and got bugger all!"
		elseif pl:Team() == TEAM_UNDEAD then
			message = message .." rolled the dice and got bugger all!"
		end	
	else
		if pl:Team() == TEAM_HUMAN then
			if pl:HasBought("ladyluck") or math.random (1,2) == 1 then
				specialitems = { "weapon_zs_python","weapon_zs_pulsesmg"}
				message = "WIN: LadyLuck gave "..message.." A special weapon!"
				pl:Give(table.Random(specialitems))		
				else 
					pl:Ignite( math.random(1,5), 0)
					message = "LOSE: "..message.." was put on fire by the dice."
				end
		elseif pl:Team() == TEAM_UNDEAD then
			pl:AddScore(1)
			message = "WIN: ".. message .." rolled the dice and has found a piece of brain!"
		end
	end
		
	pl.LastRTD = CurTime() + RTD_TIME

	PrintMessageAll(HUD_PRINTTALK, message)
end
concommand.Add("zs_rollthedice",RollTheDice) 