-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
GM.ArenaModeWeapons = { --Arena Mode weapons
	"weapon_zs_python",
	"weapon_zs_boomerstick",
	"weapon_zs_slugrifle",
	"weapon_zs_ender",
	"weapon_zs_sg552",
	"weapon_zs_bulletstorm",
	"weapon_zs_crackler",
	"weapon_zs_uzi",
	"weapon_zs_deagle",
	"weapon_zs_m249",
	"weapon_zs_python", 
	"weapon_zs_crackler",
	"weapon_zs_uzi",
	"weapon_zs_deagle"
}

GM.ZombieEscapeWeapons = {
	"weapon_zs_zedeagle",
	"weapon_zs_zeakbar",
	"weapon_zs_zesweeper",
	"weapon_zs_zesmg",
	"weapon_zs_zestubber",
	"weapon_zs_zebulletstorm"
}



-- Change this if you plan to alter the cost of items or you severely change how Worth works.
-- Having separate cart files allows people to have separate loadouts for different servers.
GM.CartFile = "zscarts.txt"


ITEMCAT_CLASS = 1 --Human classes
ITEMCAT_GUNS = 2
ITEMCAT_GUNS3 = 3
ITEMCAT_GUNS2 = 4
ITEMCAT_AMMO = 5
ITEMCAT_MELEE = 6
ITEMCAT_TOOLS = 7
ITEMCAT_OTHER = 8

GM.ItemCategories = {
	[ITEMCAT_GUNS] = "Automatic Weapons",
	[ITEMCAT_GUNS3] = "Shotguns",
	[ITEMCAT_GUNS2] = "Pistols",
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


--MEDIC

GM:CLASS("medic", "MEDIC", "Heals and keeps your team alive!", ITEMCAT_CLASS, 100, nil, 

function(pl) pl:SetModel( table.Random( {
	"models/player/group03/male_02.mdl",
	"models/player/group03/Male_04.mdl",
	"models/player/group03/male_06.mdl",
	"models/player/group03/male_07.mdl"
} ) ) 
	
	pl:Give("weapon_zs_fiveseven")
	pl:Give("weapon_zs_medicalkit")
	pl:Give("weapon_zs_plank")
	pl:ChatPrint("You're a Medic! Heal Your Teammates!")

end, "models/healthvial.mdl")


--COMMANDO

GM:CLASS("commando", "COMMANDO", "Slaughter zombies efficiently with the toughest firearms!", ITEMCAT_CLASS, 100, nil, 

function(pl) pl:SetModel( table.Random( {
	"models/player/combine_soldier.mdl",
	"models/player/combine_soldier_prisonguard.mdl",
} ) ) 
	pl:Give("weapon_zs_dualclassics")
	pl:Give("weapon_zs_swissarmyknife")
	pl:Give("weapon_zs_grenade")
	pl:ChatPrint("You're a Commando, kill and destroy!")

end, "models/healthvial.mdl")


--ENGINEER

GM:CLASS("engineer", "ENGINEER", "Technology is your best friend, use it to fuck shit up!", ITEMCAT_CLASS, 100, nil, 

function(pl) pl:SetModel( table.Random( {
	"models/player/mossman.mdl",
	"models/player/kleiner.mdl",
} ) )

	engweapon = {"weapon_zs_barricadekit","weapon_zs_gunturret","weapon_zs_mine"}
	pl:Give("weapon_zs_pulsepistol")
	pl:Give("weapon_zs_fryingpan")
	pl:Give(table.Random(engweapon))
	pl:AddPoints(20)
	pl:ChatPrint("You're an Engineer, Blow shit up!")

end, "models/healthvial.mdl")


--BERSERKER

GM:CLASS("berserker", "BERSERKER", "Hit smash and destroy!", ITEMCAT_CLASS, 100, nil, 

function(pl) 
pl:SetModel( table.Random( {
	"",
	"",
}))

if math.random(1,4) == 1  then --Gordan freeman!

	pl:SetModel("models/player/gordon_classic.mdl")
	pl:ChatPrint("You are Gordan Freeman!")
	pl:AddPoints(60)
	pl:Give("weapon_zs_crowbar_freeman")
	pl:SetHealth(150)
	pl:SetSpeed(220)
	
else --Normal Berserker
		
	berserkerweapon = {"weapon_zs_axe","weapon_zs_pot"}

	pl:SetModel("models/player/riot.mdl")
	pl:Give("weapon_zs_peashooter")
	pl:Give(table.Random(berserkerweapon))
	pl:Give("weapon_zs_vodka")  
	pl:Give("weapon_zs_resupplybox")  
	pl:AddPoints(20)	
	pl:ChatPrint("You're a Berserker, smack the shit out of everything!")

end

end, "models/healthvial.mdl")


--SUPPORT

GM:CLASS("support", "SUPPORT", "Create barricades and support your team mates!", ITEMCAT_CLASS, 100, nil, 

function(pl) pl:SetModel( table.Random( {
	"models/player/gasmask.mdl",
	"models/player/riot.mdl",
} ) ) 

	pl:Give("weapon_zs_hammer")
	pl:Give("weapon_zs_arsenalcrate")
	pl:Give("weapon_zs_battleaxe")
	pl:ChatPrint("You're a Support, Build barricades or fuck off!")

end, "models/healthvial.mdl")

------------
-- Points --
------------

--Duby: Re-arrenged this to make it cleaner to look at
--Duby: NOTE got up to glock with the Christmas Port!

GM:AddPointShopItem("usp", "USP", nil, ITEMCAT_GUNS2, 20, "weapon_zs_battleaxe")
GM:AddPointShopItem("p228", "P228", nil, ITEMCAT_GUNS2, 25, "weapon_zs_peashooter")
GM:AddPointShopItem("alyxgun", "Alyx Gun", nil, ITEMCAT_GUNS2, 25, "weapon_zs_z9000")
GM:AddPointShopItem("pulsepistol", "Pulse Pistol", nil, ITEMCAT_GUNS2, 27, "weapon_zs_pulsepistol")
GM:AddPointShopItem("fiveseven", "Five Seven", nil, ITEMCAT_GUNS2, 30, "weapon_zs_fiveseven")
GM:AddPointShopItem("Classic Pistol", "Classic Pistol", nil, ITEMCAT_GUNS2, 30, "weapon_zs_owens")
GM:AddPointShopItem("medic_gun", "Medical Gun", nil, ITEMCAT_GUNS2, 35, "weapon_zs_medicgun")
GM:AddPointShopItem("glock", "Glock", nil, ITEMCAT_GUNS2, 40, "weapon_zs_glock3")
GM:AddPointShopItem("dualclassics", "Dual Classic Pistols", nil, ITEMCAT_GUNS2, 55, "weapon_zs_dualclassics")
GM:AddPointShopItem("magnum", "Magnum", nil, ITEMCAT_GUNS2, 65, "weapon_zs_magnum")
GM:AddPointShopItem("Dual Berreta's 92fs", "Duel Berreta's 92fs", nil, ITEMCAT_GUNS2, 65, "weapon_zs_berreta")
GM:AddPointShopItem("deagle", "Desert Eagle", nil, ITEMCAT_GUNS2, 70, "weapon_zs_deagle")
GM:AddPointShopItem("python", "Python", nil, ITEMCAT_GUNS2, 150, "weapon_zs_python")


GM:AddPointShopItem("crklr", "Famas", nil, ITEMCAT_GUNS, 50, "weapon_zs_crackler")
GM:AddPointShopItem("tossr", "Classic SMG", nil, ITEMCAT_GUNS, 50, "weapon_zs_tosser") 
GM:AddPointShopItem("stbbr", "Scout Sniper", nil, ITEMCAT_GUNS, 55, "weapon_zs_stubber")
GM:AddPointShopItem("uzi", "Uzi 9mm", nil, ITEMCAT_GUNS, 70, "weapon_zs_uzi")
GM:AddPointShopItem("shredder", "MP5", nil, ITEMCAT_GUNS, 70, "weapon_zs_smg")
GM:AddPointShopItem("bulletstorm", "P90", nil, ITEMCAT_GUNS, 70, "weapon_zs_bulletstorm")
GM:AddPointShopItem("silencer", "TMP", nil, ITEMCAT_GUNS, 70, "weapon_zs_silencer")



GM:AddPointShopItem("reaper", "UMP", nil, ITEMCAT_GUNS, 80, "weapon_zs_reaper")
GM:AddPointShopItem("chipper", "Chipper Shotgun", nil, ITEMCAT_GUNS3, 40, "weapon_zs_chipper")
GM:AddPointShopItem("annabelle", "Annabelle Shotgun", nil, ITEMCAT_GUNS3, 100, "weapon_zs_annabelle")
GM:AddPointShopItem("pulsesmg", "Pulse SMG", nil, ITEMCAT_GUNS, 105, "weapon_zs_pulsesmg")
GM:AddPointShopItem("akbar", "AK47", nil, ITEMCAT_GUNS, 120, "weapon_zs_akbar")
GM:AddPointShopItem("SG552", "SG 552", nil, ITEMCAT_GUNS, 130, "weapon_zs_sg552")
GM:AddPointShopItem("ender", "Galil", nil, ITEMCAT_GUNS, 145, "weapon_zs_ender") --Testing
GM:AddPointShopItem("stalker", "M4A1", nil, ITEMCAT_GUNS, 160, "weapon_zs_m4")
GM:AddPointShopItem("inferno", "AUG", nil, ITEMCAT_GUNS, 170, "weapon_zs_inferno")
GM:AddPointShopItem("crossbow", "Crossbow", nil, ITEMCAT_GUNS, 175, "weapon_zs_crossbow")
GM:AddPointShopItem("m3", "M3 Shotgun", nil, ITEMCAT_GUNS3, 190, "weapon_zs_sweepershotgun")
GM:AddPointShopItem("M1014Shotgun", "M1014 Shotgun", nil, ITEMCAT_GUNS3, 220, "weapon_zs_slugrifle")
GM:AddPointShopItem("hunter", "AWP", nil, ITEMCAT_GUNS, 230, "weapon_zs_hunter")
GM:AddPointShopItem("SG550", "SG 550", nil, ITEMCAT_GUNS, 250, "weapon_zs_sg550")
GM:AddPointShopItem("pulserifle", "Pulse Rifle", nil, ITEMCAT_GUNS, 300, "weapon_zs_pulserifle")
GM:AddPointShopItem("m249", "M249 'SAW'", nil, ITEMCAT_GUNS, 400, "weapon_zs_m249")
GM:AddPointShopItem("boomstick", "Boom Stick", nil, ITEMCAT_GUNS3, 350, "weapon_zs_boomerstick") --Duby: We have the Mr.Green one! ^^


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

--[AMMO]--
GM:AddPointShopItem("pistolammo", "Pistol ammo", nil, ITEMCAT_AMMO, 4, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pistol"] or 12, "pistol", true) end, "models/Items/BoxSRounds.mdl")
GM:AddPointShopItem("crossbowammo", "Crossbow bolt", nil, ITEMCAT_AMMO, 5, nil, function(pl) pl:GiveAmmo(1, "XBowBolt", true) end, "models/Items/CrossbowRounds.mdl")
GM:AddPointShopItem("smgammo", "SMG ammo", nil, ITEMCAT_AMMO, 5, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["smg1"] or 30, "smg1", true) end, "models/Items/BoxMRounds.mdl")
GM:AddPointShopItem("shotgunammo", "Shotgun ammo", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["buckshot"] or 8, "buckshot", true) end, "models/Items/BoxBuckshot.mdl")
GM:AddPointShopItem("assaultrifleammo", "Assault rifle ammo", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["ar2"] or 30, "ar2", true) end, "models/Items/357ammobox.mdl")
GM:AddPointShopItem("rifleammo", "Rifle ammo ", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["357"] or 6, "357", true) end, "models/Items/BoxSniperRounds.mdl")
GM:AddPointShopItem("pulseammo", "Pulse ammo", nil, ITEMCAT_AMMO, 6, nil, function(pl) pl:GiveAmmo(GAMEMODE.AmmoCache["pulse"] or 30, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")


--[Other]

GM:AddPointShopItem("nail", "Nail", "It's just one nail.", ITEMCAT_OTHER, 5, nil, function(pl) pl:GiveAmmo(1, "GaussEnergy", true) end, "models/crossbow_bolt.mdl").NoClassicMode = true
GM:AddPointShopItem("50mkit", "50 Medical Kit power", "50 extra power for the Medical Kit.", ITEMCAT_OTHER, 20, nil, function(pl) pl:GiveAmmo(50, "Battery", true) end, "models/healthvial.mdl")
GM:AddPointShopItem("aegisboard", "Aegis Board", "Aegis Board", ITEMCAT_OTHER, 20, nil, function(pl) pl:GiveAmmo(1, "SniperRound", true) end, "")
GM:AddPointShopItem("c4", "C4", "C4", ITEMCAT_OTHER, 20, nil, function(pl) pl:GiveAmmo(1, "sniperpenetratedround", true) end, "")
GM:AddPointShopItem("grenade", "Grenade", nil, ITEMCAT_TOOLS, 22, "weapon_zs_grenade")
GM:AddPointShopItem("nail2", "Pack of Nail's", "It's just nails x5.", ITEMCAT_OTHER, 25, nil, function(pl) pl:GiveAmmo(5, "GaussEnergy", true) end, "models/crossbow_bolt.mdl").NoClassicMode = true
GM:AddPointShopItem("spotlamp", "Spot Lamp", nil, ITEMCAT_OTHER, 25, "weapon_zs_lamp")
GM:AddPointShopItem("vodka", "Bottle'ol Vodka", nil, ITEMCAT_OTHER, 60, "weapon_zs_vodka")
GM:AddPointShopItem("Stoned Potato", "Stoned Potato +[SP]+", nil, ITEMCAT_OTHER, 2000, "")

GM:AddPointShopItem("torch", "Blow Torch", nil, ITEMCAT_TOOLS, 35, "weapon_zs_torch")
GM:AddPointShopItem("turret", "Turret", nil, ITEMCAT_TOOLS, 30, "weapon_zs_gunturret")
GM:AddPointShopItem("junkpack", "Junk Pack", nil, ITEMCAT_TOOLS, 45, "weapon_zs_boardpack")
GM:AddPointShopItem("miniturret", "Mini Turret", nil, ITEMCAT_TOOLS, 50, nil, function(pl) pl:SpawnMiniTurret() end) --Un decided to if this should be kept in the shop..
GM:AddPointShopItem("supplycrate", "Supply Crate", nil, ITEMCAT_TOOLS, 50, "weapon_zs_arsenalcrate")

--GM:AddPointShopItem("detpck", "Detonation Pack", nil, ITEMCAT_OTHER, 70, "weapon_zs_detpack")
-- These are the honorable mentions that come at the end of the round.

local function genericcallback(pl, magnitude) return pl:Name(), magnitude end
GM.HonorableMentions = {}
GM.HonorableMentions[HM_MOSTZOMBIESKILLED] = {Name = "Most zombies killed", String = "by %s, with %d killed zombies.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTDAMAGETOUNDEAD] = {Name = "Most damage to undead", String = "goes to %s, with a total of %d damage dealt to the undead.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_PACIFIST] = {Name = "Pacifist", String = "goes to %s for not killing a single zombie and still surviving!", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTHELPFUL] = {Name = "Most helpful", String = "goes to %s for assisting in the disposal of %d zombies.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_LASTHUMAN] = {Name = "Last Human", String = "goes to %s for being the last person alive.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_OUTLANDER] = {Name = "Outlander", String = "goes to %s for getting killed %d feet away from a zombie spawn.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_GOODDOCTOR] = {Name = "Good Doctor", String = "goes to %s for healing their team for %d points of health.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_HANDYMAN] = {Name = "Handy Man", String = "goes to %s for getting %d barricade assistance points.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SCARECROW] = {Name = "Scarecrow", String = "goes to %s for killing %d poor crows.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTBRAINSEATEN] = {Name = "Most brains eaten", String = "by %s, with %d brains eaten.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_MOSTDAMAGETOHUMANS] = {Name = "Most damage to humans", String = "goes to %s, with a total of %d damage given to living players.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_LASTBITE] = {Name = "Last Bite", String = "goes to %s for ending the round.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_USEFULTOOPPOSITE] = {Name = "Most useful to opposite team", String = "goes to %s for giving up a whopping %d kills!", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_STUPID] = {Name = "Stupid", String = "is what %s is for getting killed %d feet away from a zombie spawn.", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_SALESMAN] = {Name = "Salesman", String = "is what %s is for having %d points worth of items taken from their arsenal crate.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_WAREHOUSE] = {Name = "Warehouse", String = "describes %s well since they had their resupply boxes used %d times.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SPAWNPOINT] = {Name = "Spawn Point", String = "goes to %s for having %d zombies spawn on them.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_CROWFIGHTER] = {Name = "Crow Fighter", String = "goes to %s for annihilating %d of his crow brethren.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_CROWBARRICADEDAMAGE] = {Name = "Minor Annoyance", String = "is what %s is for dealing %d damage to barricades while a crow.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_BARRICADEDESTROYER] = {Name = "Barricade Destroyer", String = "goes to %s for doing %d damage to barricades.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTDESTROYER] = {Name = "Nest Destroyer", String = "goes to %s for destroying %d nests.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTMASTER] = {Name = "Nest Master", String = "goes to %s for having %d zombies spawn through their nest.", Callback = genericcallback, Color = COLOR_LIMEGREEN}

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
--GM.WaveOneLength = 10

-- For Classic Mode
GM.WaveOneLengthClassic = 120

-- Add this many seconds for each additional wave.
GM.TimeAddedPerWave = 15
--GM.TimeAddedPerWave = 1

-- For Classic Mode
GM.TimeAddedPerWaveClassic = 10

-- New players are put on the zombie team if the current wave is this or higher. Do not put it lower than 1 or you'll break the game.
GM.NoNewHumansWave = 2

-- Humans can not commit suicide if the current wave is this or lower.
GM.NoSuicideWave = 1

-- How long 'wave 0' should last in seconds. This is the time you should give for new players to join and get ready.
GM.WaveZeroLength = 120
--GM.WaveZeroLength = 40

-- Time humans have between waves to do stuff without NEW zombies spawning. Any dead zombies will be in spectator (crow) view and any living ones will still be living.
--GM.WaveIntermissionLength = 5
GM.WaveIntermissionLength = 90

-- For Classic Mode
GM.WaveIntermissionLengthClassic = 20

-- Time in seconds between end round and next map.
--GM.EndGameTime = 60
GM.EndGameTime = 30

-- How many clips of ammo guns from the Worth menu start with. Some guns such as shotguns and sniper rifles have multipliers on this.
GM.SurvivalClips = 3

-- Put your unoriginal, 5MB Rob Zombie and Metallica music here.
GM.LastHumanSound = Sound("mrgreen/music/lasthuman.ogg")

GM.IntermissionSound = Sound("mrgreen/music/intermission"..math.random(2)..".mp3")

-- Sound played when humans all die.
GM.AllLoseSound = Sound("music/HL2_song7.mp3")

-- Sound played when humans survive.
GM.HumanWinSound = Sound("music/HL2_song7.mp3")

-- Sound played to a person when they die as a human.
GM.DeathSound = Sound("music/stingers/HL1_stinger_song28.mp3")

-- Rave sound; people will hate me for making this :')
RAVESOUND = "mrgreen/ravebreak_fix.mp3"

RTD_TIME = 10