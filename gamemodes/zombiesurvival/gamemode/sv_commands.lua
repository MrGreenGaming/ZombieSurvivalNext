
 --Dice Command!
WaveZeroLength = 120
function Dice( pl, text, public )
    if (string.sub(text, 1, 4) == "!rtd" or string.sub(text, 1, 4) == "!Rtd"  or string.sub(text, 1, 4) == "!rTd"  or string.sub(text, 1, 4) == "!rtD"  or string.sub(text, 1, 4) == "/rtd") then --if the first 4 letters are !rtd

	
	if CurTime() < (WaveZeroLength+1) then --Check these Ghlobal variables..
		timer.Simple(0.3, function()
			pl:ChatPrint("Dice temporarily disabled at round start")
		end)	
		return
	end

	if pl.LastRTD >= CurTime() then
		timer.Simple(0.3, function()
			pl:PrintMessage(HUD_PRINTTALK, "You have to wait "..math.floor(pl.LastRTD-CurTime()).." more seconds before you can roll the dice!")
		end)
		return
	end

local choise,message,name

choise = math.random(1,4)	
message = pl:GetName()	
	
	if choise == 1 then
		if pl:Team() == TEAM_HUMAN then	
			specialitems = {"weapon_zs_vodka"}
		timer.Simple(0.3, function()  --LOOSING LOTS OF HEALTH
			PrintMessage( HUD_PRINTTALK, "WIN: ".. message .." rolled the dice and got a special item!" )
		end)
			pl:Give(table.Random(specialitems))		
		elseif pl:Team() == TEAM_UNDEAD then	
			pl:AddScore(1)
			message = "WIN: ".. message .." rolled the dice and has found a piece of brain!"
		end
	elseif choise == 2 then
		if pl:Team() == TEAM_HUMAN then
		timer.Simple(0.3, function()  --LOOSING LOTS OF HEALTH
			PrintMessage( HUD_PRINTTALK, "LOSE: ".. message .." rolled the dice and got raped in the ass." )
		end)
			pl:SetHealth(1)
		elseif pl:Team() == TEAM_UNDEAD then
			local calchealth = math.Clamp ( 200 - pl:Health(),60,200 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth(pl:Health() + randhealth)
			message = "WIN: ".. message .." rolled the dice and gained ".. randhealth .."KG of flesh!!"
		end
	elseif choise == 3 then
		if pl:Team() == TEAM_HUMAN then
			pl:GiveAmmo( 30, "pistol" )	
			pl:GiveAmmo( 30, "ar2" )
			pl:GiveAmmo( 90, "SMG1" )	
			pl:GiveAmmo( 20, "buckshot" )		
			pl:GiveAmmo( 5, "XBowBolt" )
			pl:GiveAmmo( 30, "357" )
		timer.Simple(0.3, function()  --LOOSING LOTS OF HEALTH
			PrintMessage( HUD_PRINTTALK, "WIN: ".. message .." rolled the dice and recieved some ammo!" )
		end)	
		elseif pl:Team() == TEAM_UNDEAD then
			local calchealth = math.Clamp ( 100 - pl:Health(),60,100 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth(math.max(pl:Health() - randhealth, 1))
				timer.Simple(0.3, function()  --LOOSING LOTS OF HEALTH
					PrintMessage( HUD_PRINTTALK, "LOSE: ".. message .." rolled the dice and lost ".. randhealth .."KG of flesh!!" )
				end)
		end
	elseif choise == 4 and pl:Health() < 100 then
		if pl:Team() == TEAM_HUMAN then
			local calchealth = math.Clamp ( 100 - pl:Health(),25,100 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth( math.min( pl:Health() + randhealth, 100 ) )
				timer.Simple(0.3, function()  --LOOSING LOTS OF HEALTH
					PrintMessage( HUD_PRINTTALK, "WIN: ".. message .." rolled the dice and gained ".. randhealth .." health!" )
				end)
		elseif pl:Team() == TEAM_UNDEAD then
			local calchealth = math.Clamp ( 200 - pl:Health(),60,200 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth( pl:Health() + randhealth)
			message = "WIN: ".. message .." rolled the dice and gained ".. randhealth .."KG of flesh!!"
		end
	elseif choise == 5 then
		if pl:Team() == TEAM_HUMAN then
			pl:Ignite( math.random(1,4), 0)
				timer.Simple(0.3, function()  --LOOSING LOTS OF HEALTH
					PrintMessage( HUD_PRINTTALK, "LOSE: "..message.." was put on fire by the dice." )
				end)
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
				pl:Ignite( math.random(1,5), 0)
				timer.Simple(0.3, function()  --LOOSING LOTS OF HEALTH
					PrintMessage( HUD_PRINTTALK, "LOSE: "..message.." was put on fire by the dice." )
				end)
		elseif pl:Team() == TEAM_UNDEAD then
			pl:AddScore(1)
			message = "WIN: ".. message .." rolled the dice and has found a piece of brain!"
		end
	end
	
	pl.LastRTD = CurTime() + RTD_TIME
	
	end
end
hook.Add( "PlayerSay", "Dice", Dice );









