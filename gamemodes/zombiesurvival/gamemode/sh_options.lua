-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
GM.ArenaModeWeapons = { --Arena Mode weapons
	"weapon_zs_ender",
	"weapon_zs_sg552",
	"weapon_zs_bulletstorm",
	"weapon_zs_crackler",
	"weapon_zs_uzi",
	"weapon_zs_dual_degals",
	"weapon_zs_m249",
	"weapon_zs_python", 
	"weapon_zs_uzi",
	"weapon_zs_dual_degals"
}

GM.ZombieEscapeWeapons = {
	"weapon_zs_zedeagle",
	"weapon_zs_zeakbar",
	"weapon_zs_zesweeper",
	"weapon_zs_zesmg",
	"weapon_zs_zestubber",
	"weapon_zs_zebulletstorm"
}

OldFags = {

"STEAM_0:0:57410119", --Pistol Mags
"STEAM_0:1:20607445", --Rui
"STEAM_0:0:30210736", --Antz
"STEAM_0:0:60372095", --Zarco
"STEAM_0:0:59565612", --Duby
"STEAM_0:0:51930358", --Zoidburg
"STEAM_0:1:50553529", --Rob
"STEAM_0:1:19523408", --Pufulet
"STEAM_0:1:43653852", --Lejorah
"STEAM_0:1:6914195",  --GodsHands
"STEAM_0:0:23697677", --Stellathefella
"STEAM_0:1:26630595", --Lameshot
"STEAM_0:1:14133131", --BrainDawg
"STEAM_0:1:16927564", --The Real Freeman
"STEAM_0:0:20139318", --Damien
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
""



}

Commando = {
"models/player/combine_soldier.mdl",
"models/player/combine_soldier_prisonguard.mdl"
}


-- Change this if you plan to alter the cost of items or you severely change how Worth works.
-- Having separate cart files allows people to have separate loadouts for different servers.
GM.CartFile = "zscarts.txt"


ITEMCAT_CLASS = 1 --Human classes
ITEMCAT_GUNS = 2
ITEMCAT_GUNS5 = 3
ITEMCAT_GUNS3 = 4
ITEMCAT_GUNS2 = 5
ITEMCAT_GUNS4 = 6
ITEMCAT_AMMO = 7
ITEMCAT_MELEE = 8
ITEMCAT_TOOLS = 9
ITEMCAT_OTHER = 10

GM.ItemCategories = {
	[ITEMCAT_GUNS] = "Automatic Weapons",
	[ITEMCAT_GUNS3] = "Shotguns",
	[ITEMCAT_GUNS4] = "Sniper rifles",
	[ITEMCAT_GUNS2] = "Pistols",
	[ITEMCAT_GUNS5] = "Dual Pistols",
	[ITEMCAT_MELEE] = "Melee Weapons",
	[ITEMCAT_AMMO] = "Ammunition",
	[ITEMCAT_TOOLS] = "Tools",
	[ITEMCAT_OTHER] = "Other",
	[ITEMCAT_CLASS] = "Class",
}

GM.ItemCategories2 = {
	[ITEMCAT_CLASS] = "",
}

--[[
Humans select what weapons (or other things) they want to start with and can even save favorites. Each object has a number of 'Worth' points.
Signature is a unique signature to give in case the item is renamed or reordered. Don't use a number or a string number!
A human can only use 100 points (default) when they join. Redeeming or joining late starts you out with a random loadout from above.
SWEP is a swep given when the player spawns with that perk chosen.
Callback is a function called. Model is a display model. If model isn't defined then the SWEP model will try to be used.
swep, callback, and model can all be nil or empty
]]
GM.Items = {}
function GM:AddItem(signature, name, desc, category, worth, swep, callback, model, worthshop, pointshop)
	local tab = {Signature = signature, Name = name, Description = desc, Category = category, Worth = worth or 0, SWEP = swep, Callback = callback, Model = model, WorthShop = worthshop, PointShop = pointshop}
	self.Items[#self.Items + 1] = tab

	return tab
end

function GM:AddStartingItem(signature, name, desc, category, points, worth, callback, model)
	return self:AddItem(signature, name, desc, category, points, worth, callback, model, true, false)
end

function GM:CLASS(signature, name, desc, category, points, worth, callback, model) --Duby: Setup the classes function
	return self:AddItem(signature, name, desc, category, points, worth, callback, model, true, false)
end

function GM:AddPointShopItem(signature, name, desc, category, points, worth, callback, model)
	return self:AddItem("ps_"..signature, name, desc, category, points, worth, callback, model, false, true)
end

-- Weapons are registered after the gamemode.
timer.Simple(0, function()
	for _, tab in pairs(GAMEMODE.Items) do
		if not tab.Description and tab.SWEP then
			local sweptab = weapons.GetStored(tab.SWEP)
			if sweptab then
				tab.Description = sweptab.Description
			end
		end
	end
end)

-- How much ammo is considered one 'clip' of ammo? For use with setting up weapon defaults. Works directly with zs_survivalclips
GM.AmmoCache = {}
GM.AmmoCache["ar2"] = 30 -- Assault rifles.
GM.AmmoCache["alyxgun"] = 24 -- Not used.
GM.AmmoCache["pistol"] = 12 -- Pistols.
GM.AmmoCache["smg1"] = 30 -- SMG's and some rifles.
GM.AmmoCache["357"] = 6 -- Rifles, especially of the sniper variety.
GM.AmmoCache["xbowbolt"] = 4 -- Crossbows
GM.AmmoCache["buckshot"] = 8 -- Shotguns
GM.AmmoCache["ar2altfire"] = 1 -- Not used.
GM.AmmoCache["slam"] = 1 -- Force Field Emitters.
GM.AmmoCache["rpg_round"] = 1 -- Not used. Rockets?
GM.AmmoCache["smg1_grenade"] = 1 -- Not used.
GM.AmmoCache["sniperround"] = 1 -- Barricade Kit
GM.AmmoCache["sniperpenetratedround"] = 1 -- Remote Det pack.
GM.AmmoCache["grenade"] = 1 -- Grenades.
GM.AmmoCache["thumper"] = 1 -- Gun turret.
GM.AmmoCache["gravity"] = 1 -- Unused.
GM.AmmoCache["battery"] = 30 -- Used with the Medical Kit.
GM.AmmoCache["gaussenergy"] = 1 -- Nails used with the Carpenter's Hammer.
GM.AmmoCache["combinecannon"] = 1 -- Not used.
GM.AmmoCache["airboatgun"] = 1 -- Arsenal crates.
GM.AmmoCache["striderminigun"] = 1 -- Message beacons.
GM.AmmoCache["helicoptergun"] = 1 --Resupply boxes.
GM.AmmoCache["spotlamp"] = 1
GM.AmmoCache["manhack"] = 1
GM.AmmoCache["pulse"] = 30

-- These ammo types are available at ammunition boxes.
-- The amount is the ammo to give them.
-- If the player isn't holding a weapon that uses one of these then they will get smg1 ammo.
GM.AmmoResupply = {}
GM.AmmoResupply["ar2"] = 20
GM.AmmoResupply["alyxgun"] = GM.AmmoCache["alyxgun"]
GM.AmmoResupply["pistol"] = GM.AmmoCache["pistol"]
GM.AmmoResupply["smg1"] = 20
GM.AmmoResupply["357"] = GM.AmmoCache["357"]
GM.AmmoResupply["xbowbolt"] = GM.AmmoCache["xbowbolt"]
GM.AmmoResupply["buckshot"] = GM.AmmoCache["buckshot"]
GM.AmmoResupply["battery"] = 20
GM.AmmoResupply["pulse"] = GM.AmmoCache["pulse"]

--[CLASSES]

allowedSteamIDs = OldFags

--MEDIC

GM:CLASS("medic", "MEDIC", " Loadout items: \n\n Medkical Kit \n Plank \n Five Seven \n\n\n\n Class Stats: \n\n 5% less maximum HP \n 10% more damage with pistols \n 10% more heal on teammates \n 5% increased speed", ITEMCAT_CLASS, 100, nil, 

function(pl) pl:SetModel( table.Random( {
	"models/player/group03/male_02.mdl",
	"models/player/group03/Male_04.mdl",
	"models/player/group03/male_06.mdl",
	"models/player/group03/male_07.mdl"
} ) ) 


if table.HasValue(allowedSteamIDs, pl:SteamID()) then
	pl:Give("weapon_zs_fiveseven")
	pl:ChatPrint("You're an OldFag, welcome back!")
else
	pl:Give("weapon_zs_fiveseven")
end	

	pl:Give("weapon_zs_medicalkit")
	pl:Give("weapon_zs_plank")
	pl:ChatPrint("You're a Medic! Heal Your Teammates!")	
	pl.HumanHealMultiplier = (pl.HumanHealMultiplier or 1) + 0.3
	
	pl:SetSpeed(205)	
	pl:SetHealth(95)
	pl:SetMaximumHealth(95)
	

end, "models/healthvial.mdl")


--COMMANDO

GM:CLASS("commando", "COMMANDO", " Loadout items: \n\n Dual P228 Pistols \n Swiss Knife \n Grenades \n\n\n\n Class Stats: \n\n 10% speed reduction \n 2 extra grenades \n 30% chance to spawn with rifle \n 5% increased crouching accuracy \n Poison resistance", ITEMCAT_CLASS, 100, nil, 

function(pl) pl:SetModel( table.Random( {
	"models/player/combine_soldier.mdl",
	"models/player/combine_soldier_prisonguard.mdl",
} ) ) 



if table.HasValue(allowedSteamIDs, pl:SteamID()) then
	pl:Give("weapon_zs_dual_p228")
	pl:ChatPrint("You're an OldFag, welcome back!")
else
	pl:Give("weapon_zs_dual_p228")
end
	pl.BuffResistant = true
	pl:Give("weapon_zs_swissarmyknife")
	pl:Give("weapon_zs_grenade")
	pl:ChatPrint("You're a Commando, kill and destroy!")
	pl:SetSpeed(190)

if math.random(1,3) == 3 then
	pl:Give("weapon_zs_crackler")
end
	
end, "models/healthvial.mdl")


--ENGINEER

GM:CLASS("engineer", "ENGINEER", " Loadout items: \n\n Pulse Pistol \n Frying Pan \n Mines \n\n\n\n Class Stats: \n\n 30% chance to spawn with Turret \n 30% chance to spawn with AegisKit \n 20% speed reduction", ITEMCAT_CLASS, 100, nil, 

function(pl) pl:SetModel( table.Random( {
	"models/player/mossman.mdl",
	"models/player/kleiner.mdl",
} ) )
--Aegis Kit, Turret,
if table.HasValue(allowedSteamIDs, pl:SteamID()) then
	pl:Give("weapon_zs_pulsepistol")
	pl:ChatPrint("You're an OldFag, welcome back!")
else
	pl:Give("weapon_zs_pulsepistol")
end

	EngWeapon = {"weapon_zs_barricadekit","weapon_zs_gunturret"}

	pl:Give("weapon_zs_mine")
	pl:Give("weapon_zs_fryingpan")
	pl:Give(table.Random(EngWeapon))
	pl:ChatPrint("You're an Engineer, Blow shit up!")	
	pl:SetSpeed(180)

end, "models/healthvial.mdl")


--BERSERKER

GM:CLASS("berserker", "BERSERKER", " Loadout items: \n\n P228 \n Mobile Supplies \n Pot  \n\n\n\n Class Stats: \n\n 10% HP reduction \n 10% speed increase \n 25% chance of spawning as Gordan \n 20% Extra Melee Damage", ITEMCAT_CLASS, 100, nil, 

function(pl) 
pl:SetModel( table.Random( {
	"",
	"",
}))

if math.random(1,4) == 1  then --Gordan freeman!

	pl:SetModel("models/player/gordon_classic.mdl")
	pl:ChatPrint("You are Gordan Freeman!")
	pl:Give("weapon_zs_peashooter")
	pl:Give("weapon_zs_vodka")  
	pl:Give("weapon_zs_resupplybox")  
	pl:Give("weapon_zs_crowbar")  
	
else --Normal Berserker
		
if table.HasValue(allowedSteamIDs, pl:SteamID()) then
	pl:Give("weapon_zs_axe")
	pl:ChatPrint("You're an OldFag, welcome back!")
else
	pl:Give("weapon_zs_pot")
end
	
	pl:SetModel("models/player/riot.mdl")
	pl:Give("weapon_zs_peashooter")
	pl:Give("weapon_zs_vodka")  
	pl:Give("weapon_zs_resupplybox")  
	pl:ChatPrint("You're a Berserker, smack the shit out of everything!")
	pl:DoMuscularBones()
	
	pl:SetSpeed(210)
	pl:SetHealth(90)
	pl:SetMaximumHealth(90)

end

end, "models/healthvial.mdl")


--SUPPORT

GM:CLASS("support", "SUPPORT", " Loadout items: \n\n Hammer \n Supply Crate \n USP  \n\n\n\n Class Stats: \n\n 10% speed reduction \n 10% HP reduction \n 30% chance extra Ammo \n Can Lift Heavy Items", ITEMCAT_CLASS, 100, nil, 

function(pl) pl:SetModel( table.Random( {
	"models/player/gasmask.mdl",
	"models/player/riot.mdl",
} ) ) 


if table.HasValue(allowedSteamIDs, pl:SteamID()) then
	pl:Give("weapon_zs_ammo")
	pl:Give("weapon_zs_hammer")
	pl:ChatPrint("You're an OldFag, welcome back!")
else
	pl:Give("weapon_zs_hammer")
end	
	
if math.random(1,3) == 1  then --Ammo
	pl:Give("weapon_zs_ammo")
end	

	pl.BuffMuscular = true 
	pl:Give("weapon_zs_hammer")
	pl:Give("weapon_zs_arsenalcrate")
	pl:Give("weapon_zs_battleaxe")
	pl:ChatPrint("You're a Support, Build barricades or fuck off!")
	
	pl:SetSpeed(170)
	pl:SetHealth(90)
	pl:SetMaximumHealth(90)

end, "models/healthvial.mdl")

------------
-- Points --
------------

--Duby: Re-arrenged this to make it cleaner to look at
--Duby: NOTE got up to glock with the Christmas Port!

--// PISTOLS \\--
GM:AddPointShopItem("usp", "USP", nil, ITEMCAT_GUNS2, 20, "weapon_zs_battleaxe")
GM:AddPointShopItem("p228", "P228", nil, ITEMCAT_GUNS2, 25, "weapon_zs_peashooter")
GM:AddPointShopItem("pulsepistol", "Pulse Pistol", nil, ITEMCAT_GUNS2, 27, "weapon_zs_pulsepistol")
GM:AddPointShopItem("fiveseven", "Five Seven", nil, ITEMCAT_GUNS2, 30, "weapon_zs_fiveseven")
GM:AddPointShopItem("Classic Pistol", "Classic Pistol", nil, ITEMCAT_GUNS2, 30, "weapon_zs_owens")
GM:AddPointShopItem("medic_gun", "Medical Pistol", nil, ITEMCAT_GUNS2, 35, "weapon_zs_medicgun")
GM:AddPointShopItem("glock", "Glock", nil, ITEMCAT_GUNS2, 40, "weapon_zs_glock3")
GM:AddPointShopItem("dualp228", "Dual P228 Pistols", nil, ITEMCAT_GUNS5, 40, "weapon_zs_dual_p228")
GM:AddPointShopItem("magnum", "Magnum", nil, ITEMCAT_GUNS2, 65, "weapon_zs_magnum")
GM:AddPointShopItem("dualclassics", "Dual Classic Pistols", nil, ITEMCAT_GUNS5, 60, "weapon_zs_dualclassics")
GM:AddPointShopItem("deagle", "Desert Eagle", nil, ITEMCAT_GUNS2, 70, "weapon_zs_deagle")
GM:AddPointShopItem("Dual Berreta's 92fs", "Duel Berreta's 92fs", nil, ITEMCAT_GUNS5, 75, "weapon_zs_berreta")
GM:AddPointShopItem("alyxgun", "Alyx Gun", nil, ITEMCAT_GUNS2, 78, "weapon_zs_z9000")
GM:AddPointShopItem("dualdegals", "Dual Degals", nil, ITEMCAT_GUNS5, 130, "weapon_zs_dual_degals")
GM:AddPointShopItem("python", "Python", nil, ITEMCAT_GUNS2, 170, "weapon_zs_python")


--// AUTOMATIC WEAPONS \\--
GM:AddPointShopItem("crklr", "Famas", nil, ITEMCAT_GUNS, 35, "weapon_zs_crackler")
GM:AddPointShopItem("tossr", "Classic SMG", nil, ITEMCAT_GUNS, 50, "weapon_zs_tosser") 
GM:AddPointShopItem("uzi", "Uzi 9mm", nil, ITEMCAT_GUNS, 70, "weapon_zs_uzi")
GM:AddPointShopItem("shredder", "MP5", nil, ITEMCAT_GUNS, 70, "weapon_zs_smg")
GM:AddPointShopItem("bulletstorm", "P90", nil, ITEMCAT_GUNS, 70, "weapon_zs_bulletstorm")
GM:AddPointShopItem("silencer", "TMP", nil, ITEMCAT_GUNS, 70, "weapon_zs_silencer")
GM:AddPointShopItem("reaper", "UMP", nil, ITEMCAT_GUNS, 80, "weapon_zs_reaper")

GM:AddPointShopItem("pulsesmg", "Pulse SMG", nil, ITEMCAT_GUNS, 105, "weapon_zs_pulsesmg")
GM:AddPointShopItem("akbar", "AK47", nil, ITEMCAT_GUNS, 120, "weapon_zs_akbar")
GM:AddPointShopItem("SG552", "SG 552", nil, ITEMCAT_GUNS, 130, "weapon_zs_sg552")
GM:AddPointShopItem("ender", "Galil", nil, ITEMCAT_GUNS, 145, "weapon_zs_ender") --Testing
GM:AddPointShopItem("stalker", "M4A1", nil, ITEMCAT_GUNS, 160, "weapon_zs_m4")
GM:AddPointShopItem("inferno", "AUG", nil, ITEMCAT_GUNS, 170, "weapon_zs_inferno")
GM:AddPointShopItem("crossbow", "Crossbow", nil, ITEMCAT_GUNS, 175, "weapon_zs_crossbow")
GM:AddPointShopItem("pulserifle", "Pulse Rifle", nil, ITEMCAT_GUNS, 300, "weapon_zs_pulserifle")
GM:AddPointShopItem("m249", "M249 'SAW'", nil, ITEMCAT_GUNS, 400, "weapon_zs_m249")

--// SHOTGUNS \\--
GM:AddPointShopItem("chipper", "Chipper Shotgun", nil, ITEMCAT_GUNS3, 40, "weapon_zs_chipper")
GM:AddPointShopItem("annabelle", "Annabelle Shotgun", nil, ITEMCAT_GUNS3, 100, "weapon_zs_annabelle")
GM:AddPointShopItem("m3", "M3 Shotgun", nil, ITEMCAT_GUNS3, 190, "weapon_zs_sweepershotgun")
GM:AddPointShopItem("M1014Shotgun", "M1014 Shotgun", nil, ITEMCAT_GUNS3, 220, "weapon_zs_slugrifle")
GM:AddPointShopItem("prototype", "The Prototype", nil, ITEMCAT_GUNS3, 330, "weapon_zs_prototype")
GM:AddPointShopItem("boomstick", "Boom Stick", nil, ITEMCAT_GUNS3, 350, "weapon_zs_boomerstick") --Duby: We have the Mr.Green one! ^^

--// RIFLES \\--
GM:AddPointShopItem("stbbr", "Scout Sniper", nil, ITEMCAT_GUNS4, 55, "weapon_zs_stubber")
GM:AddPointShopItem("g3sg1", "G3 SG1", nil, ITEMCAT_GUNS4, 130, "weapon_zs_g3sg1")
GM:AddPointShopItem("SG550", "SG 550", nil, ITEMCAT_GUNS4, 150, "weapon_zs_sg550")
GM:AddPointShopItem("hunter", "AWP", nil, ITEMCAT_GUNS4, 210, "weapon_zs_hunter")

--// MELEE WEAPONS \\--
GM:AddPointShopItem("knife", "Knife", nil, ITEMCAT_MELEE, 5, "weapon_zs_swissarmyknife")
GM:AddPointShopItem("plank", "Plank", nil, ITEMCAT_MELEE, 10, "weapon_zs_plank")
GM:AddPointShopItem("Keyboard", "Keyboard", nil, ITEMCAT_MELEE, 12, "weapon_zs_keyboard")
GM:AddPointShopItem("hook", "Meat Hook", nil, ITEMCAT_MELEE, 25, "weapon_zs_hook")
GM:AddPointShopItem("zpfryp", "Frying Pan", nil, ITEMCAT_MELEE, 35, "weapon_zs_fryingpan")
GM:AddPointShopItem("zpcpot", "Pot", nil, ITEMCAT_MELEE, 45, "weapon_zs_pot")
GM:AddPointShopItem("pipe", "Lead Pipe", nil, ITEMCAT_MELEE, 45, "weapon_zs_pipe")
GM:AddPointShopItem("axe", "Axe", nil, ITEMCAT_MELEE, 55, "weapon_zs_axe")
GM:AddPointShopItem("crowbar", "Crowbar", nil, ITEMCAT_MELEE, 60, "weapon_zs_crowbar")
GM:AddPointShopItem("shovel", "Shovel", nil, ITEMCAT_MELEE, 70, "weapon_zs_shovel") 
GM:AddPointShopItem("sledgehammer", "Sledge Hammer", nil, ITEMCAT_MELEE, 80, "weapon_zs_sledgehammer") 
GM:AddPointShopItem("katana", "Katana", nil, ITEMCAT_MELEE, 120, "weapon_zs_katana")

--// AMMO \\--
GM:AddPointShopItem("pistolammo", "Pistol ammo", nil, ITEMCAT_AMMO, 4, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pistol"] or 12, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddPointShopItem("crossbowammo", "Crossbow bolt", nil, ITEMCAT_AMMO, 5, nil, function(pl) pl:GiveAmmo(1, "XBowBolt", true) end, "models/Items/CrossbowRounds.mdl")
GM:AddPointShopItem("smgammo", "SMG ammo", nil, ITEMCAT_AMMO, 5, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["smg1"] or 30, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddPointShopItem("shotgunammo", "Shotgun ammo", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["buckshot"] or 8, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddPointShopItem("assaultrifleammo", "Assault rifle ammo", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["ar2"] or 30, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddPointShopItem("rifleammo", "Rifle ammo ", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["357"] or 6, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddPointShopItem("pulseammo", "Pulse ammo", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pulse"] or 30, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")


--// OTHER \\--

GM:AddPointShopItem("nail", "Nail", "It's just one nail.", ITEMCAT_OTHER, 5, nil, function(pl) pl:GiveAmmo(1, "GaussEnergy", true) end, "models/crossbow_bolt.mdl").NoClassicMode = true
GM:AddPointShopItem("50mkit", "50 Medical Kit power", "50 extra power for the Medical Kit.", ITEMCAT_OTHER, 30, nil, function(pl) pl:GiveAmmo(50, "Battery", true) end, "models/healthvial.mdl")
GM:AddPointShopItem("aegisboard", "Aegis Board", "Aegis Board", ITEMCAT_OTHER, 20, nil, function(pl) pl:GiveAmmo(1, "SniperRound", true) end, "")
GM:AddPointShopItem("c4", "C4 Mines", "Ground Mines", ITEMCAT_OTHER, 25, nil, function(pl) pl:GiveAmmo(1, "sniperpenetratedround", true) end, "")
GM:AddPointShopItem("grenade", "Grenade", nil, ITEMCAT_TOOLS, 22, "weapon_zs_grenade")
GM:AddPointShopItem("nail2", "Pack of Nail's", "It's just nails x5.", ITEMCAT_OTHER, 25, nil, function(pl) pl:GiveAmmo(5, "GaussEnergy", true) end, "models/crossbow_bolt.mdl").NoClassicMode = true
GM:AddPointShopItem("spotlamp", "Spot Lamp", nil, ITEMCAT_OTHER, 25, "weapon_zs_lamp")
GM:AddPointShopItem("vodka", "Bottle'ol Vodka", nil, ITEMCAT_OTHER, 60, "weapon_zs_vodka")
GM:AddPointShopItem("Stoned Potato", "Stoned Potato +[SP]+", nil, ITEMCAT_OTHER, 2000, "")

--// TOOLS \\--
GM:AddPointShopItem("torch", "Blow Torch", nil, ITEMCAT_TOOLS, 35, "weapon_zs_torch")
--GM:AddPointShopItem("turret", "Turret", nil, ITEMCAT_TOOLS, 30, "weapon_zs_gunturret")
GM:AddPointShopItem("junkpack", "Junk Pack", nil, ITEMCAT_TOOLS, 45, "weapon_zs_boardpack")
GM:AddPointShopItem("miniturret", "Mini Turret", nil, ITEMCAT_TOOLS, 110, nil, function(pl) pl:SpawnMiniTurret() end) --Un decided to if this should be kept in the shop..
--GM:AddPointShopItem("supplycrate", "Supply Crate", nil, ITEMCAT_TOOLS, 50, "weapon_zs_arsenalcrate")

-- These are the honorable mentions that come at the end of the round.

local function genericcallback(pl, magnitude) return pl:Name(), magnitude end
GM.HonorableMentions = {}
GM.HonorableMentions[HM_MOSTZOMBIESKILLED] = {Name = "", String = " %s killed %d zombies.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTDAMAGETOUNDEAD] = {Name = "", String = " %s dealt %d damage dealt to the undead.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_PACIFIST] = {Name = "", String = "%s Survived without killing a single zombie!", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTHELPFUL] = {Name = "", String = " %s assisted the disposal of %d zombies.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_LASTHUMAN] = {Name = "", String = " %s was the last human alive!", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_OUTLANDER] = {Name = "", String = " %s was killed %d feet away from a zombie spawn.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_GOODDOCTOR] = {Name = "", String = " %s healed the team with %d HP.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_HANDYMAN] = {Name = "", String = " %s got %d barricade assistance points.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_SCARECROW] = {Name = "", String = " %s killed %d poor crows.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTBRAINSEATEN] = {Name = "", String = " %s ate %d brains Yummm", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTDAMAGETOHUMANS] = {Name = "", String = " %s did %d damage to humans", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_LASTBITE] = {Name = "", String = " %s ended the round with the last bite!", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_USEFULTOOPPOSITE] = {Name = "", String = " %s killed a whopping %d Humans!", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_STUPID] = {Name = "", String = " %s is stupid for getting killed %d feet away from a zombie spawn.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_SALESMAN] = {Name = "", String = " %s had %d SP spent on his arsenal crate.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_WAREHOUSE] = {Name = "", String = " %s had his resupply boxes used %d times.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_SPAWNPOINT] = {Name = "", String = " %s had %d zombies spawn on them.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_CROWFIGHTER] = {Name = "", String = " %s annihilated %d of his crow brethren.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_CROWBARRICADEDAMAGE] = {Name = "", String = " %s dealt %d damage to barricades whilst a crow.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_BARRICADEDESTROYER] = {Name = "", String = "%s did %d damage to barricades.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_NESTDESTROYER] = {Name = "", String = " %s destroyed %d nests.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_NESTMASTER] = {Name = "", String = " %s had %d zombies spawn through their nest.", Callback = genericcallback, Color = COLOR_WHITE}

-- Don't let humans use these models because they look like undead models. Must be lower case.
GM.RestrictedModels = {
	"models/player/zombie_classic.mdl",
	"models/player/zombine.mdl",
	"models/player/zombie_soldier.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/corpse1.mdl",
	"models/player/charple.mdl",
	"models/player/skeleton.mdl"
}

-- If a person has no player model then use one of these (auto-generated).
GM.RandomPlayerModels = {}
for name, mdl in pairs(player_manager.AllValidModels()) do
	if not table.HasValue(GM.RestrictedModels, string.lower(mdl)) then
		table.insert(GM.RandomPlayerModels, name)
	end
end

-- Utility function to setup a weapon's DefaultClip.
function GM:SetupDefaultClip(tab)
	tab.DefaultClip = math.ceil(tab.ClipSize * self.SurvivalClips * (tab.ClipMultiplier or 1))
end

GM.MaxSigils = CreateConVar("zs_maxsigils", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY, "How many sigils to spawn. 0 for none."):GetInt()
cvars.AddChangeCallback("zs_maxsigils", function(cvar, oldvalue, newvalue)
	GAMEMODE.MaxSigils = math.Clamp(tonumber(newvalue) or 0, 0, 10)
end)

GM.DefaultRedeem = CreateConVar("zs_redeem", "4", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "The amount of kills a zombie needs to do in order to redeem. Set to 0 to disable."):GetInt()
cvars.AddChangeCallback("zs_redeem", function(cvar, oldvalue, newvalue)
	GAMEMODE.DefaultRedeem = math.max(0, tonumber(newvalue) or 0)
end)

GM.WaveOneZombies = math.ceil(100 * CreateConVar("zs_waveonezombies", "0.1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "The percentage of players that will start as zombies when the game begins."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_waveonezombies", function(cvar, oldvalue, newvalue)
	GAMEMODE.WaveOneZombies = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

GM.NumberOfWaves = CreateConVar("zs_numberofwaves", "6", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Number of waves in a game."):GetInt()
cvars.AddChangeCallback("zs_numberofwaves", function(cvar, oldvalue, newvalue)
	GAMEMODE.NumberOfWaves = tonumber(newvalue) or 1
end)

-- Game feeling too easy? Just change these values!
GM.ZombieSpeedMultiplier = math.ceil(100 * CreateConVar("zs_zombiespeedmultiplier", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Zombie running speed will be scaled by this value."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_zombiespeedmultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieSpeedMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

-- This is a resistance, not for claw damage. 0.5 will make zombies take half damage, 0.25 makes them take 1/4, etc.
GM.ZombieDamageMultiplier = math.ceil(100 * CreateConVar("zs_zombiedamagemultiplier", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Scales the amount of damage that zombies take. Use higher values for easy zombies, lower for harder."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_zombiedamagemultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieDamageMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

GM.TimeLimit = CreateConVar("zs_timelimit", "15", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Time in minutes before the game will change maps. It will not change maps if a round is currently in progress but after the current round ends. -1 means never switch maps. 0 means always switch maps."):GetInt() * 60
cvars.AddChangeCallback("zs_timelimit", function(cvar, oldvalue, newvalue)
	GAMEMODE.TimeLimit = tonumber(newvalue) or 15
	if GAMEMODE.TimeLimit ~= -1 then
		GAMEMODE.TimeLimit = GAMEMODE.TimeLimit * 60
	end
end)

GM.RoundLimit = CreateConVar("zs_roundlimit", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY, "How many times the game can be played on the same map. -1 means infinite or only use time limit. 0 means once."):GetInt()
cvars.AddChangeCallback("zs_roundlimit", function(cvar, oldvalue, newvalue)
	GAMEMODE.RoundLimit = tonumber(newvalue) or 3
end)

-- Static values that don't need convars...

-- Initial length for wave 1.
GM.WaveOneLength = 220

-- For Classic Mode
GM.WaveOneLengthClassic = 120

-- Add this many seconds for each additional wave.
GM.TimeAddedPerWave = 15

-- For Classic Mode
GM.TimeAddedPerWaveClassic = 10

-- New players are put on the zombie team if the current wave is this or higher. Do not put it lower than 1 or you'll break the game.
GM.NoNewHumansWave = 2

-- Humans can not commit suicide if the current wave is this or lower.
GM.NoSuicideWave = 1

-- How long 'wave 0' should last in seconds. This is the time you should give for new players to join and get ready.
GM.WaveZeroLength = 120
--GM.WaveZeroLength = 30

-- Time humans have between waves to do stuff without NEW zombies spawning. Any dead zombies will be in spectator (crow) view and any living ones will still be living.
GM.WaveIntermissionLength = 90

-- For Classic Mode
GM.WaveIntermissionLengthClassic = 20

-- Time in seconds between end round and next map.
GM.EndGameTime = 55

-- How many clips of ammo guns from the Worth menu start with. Some guns such as shotguns and sniper rifles have multipliers on this.
GM.SurvivalClips = 3

-- Put your unoriginal, 5MB Rob Zombie and Metallica music here.
GM.LastHumanSound = Sound("mrgreen/music/lasthuman.ogg")

-- Sound played when humans all die.
GM.AllLoseSound = Sound("mrgreen/music/intermission_undead.mp3")

-- Sound played when humans survive.
GM.HumanWinSound = Sound("mrgreen/music/intermission.mp3")

-- Sound played to a person when they die as a human.
GM.DeathSound = Sound("music/stingers/HL1_stinger_song28.mp3")

-- Rave sound; people will hate me for making this :')
RAVESOUND = "mrgreen/ravebreak_fix.mp3"
