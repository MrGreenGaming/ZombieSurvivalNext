-- Server related news
local GeneralInfo = {
	"In need of GreenCoins? Visit MrGreenGaming.com for more info.",
	"Our forums can be found on MrGreenGaming.com",
	"We highly appreciate your feedback. Let us know what you think about our server.",
	"Want to make a contribution? Get on the forums and let us know!",
	"Don't hesitate to ask in the chat if you need something to be cleared up for you.",
	"Is there a dirty little troll on the server? Grab an admin via our Forums Shoutbox!",
	"Do you want to make maps for us? Get on the forums and let us know!"
}
GeneralInfo = table.Shuffle(GeneralInfo)


-- Human related hints
local HumanHints = {
	"Press E on Supply Crates to open the SkillPoint shop!",
	"SP stands for SkillPoints which you earn by killing Zombies.",
	"Press ALT to drop your current weapon.",
	"Every Human Class has a role in the Human team, try to do your role!",
	"Never let NECROSSIN touch you.....", --Duby: haha I know, I'm so dam funny!
}
HumanHints = table.Shuffle(HumanHints)

-- Undead related hints
local UndeadHints = {
	"Press F3 to open the Zombie Species menu. More classes will unlock as Humans die.",
	"Kill multiple Humans to become one of them again.",
	"Zombie Bosses spawn at the beginning of every wave if there are enough players!",
	"As more time goes on the more zombie classes unlock!",
	"The player with the most brains will be selected for the zombie boss!"
}
UndeadHints = table.Shuffle(UndeadHints)

-- Undead related hints
local News = {
	"A Leveling system with Leveling tree is currently being coded.",
	"Arena Mode is having more maps created for it.",
	"Minor tweaks to the server will be done over the next few weeks.",
	"Green Coins will soon be introduced.",
	"The Green shop with Hats and Suits will soon be added.",
	"Code optimization updates will happen fequently, report any bugs."
}
News = table.Shuffle(News)



--[==[---------------------------------------------------------
       Used to send server news/info to players
---------------------------------------------------------]==]
local sIndex = 1
local function DisplayNews()
	chat.AddText(Color(0, 160, 255), "[INFO] ", Color(213, 213, 213), GeneralInfo[sIndex])
	
	sIndex = sIndex + 1
	if sIndex > #GeneralInfo then
		sIndex = 1
	end
end
timer.Create("DisplayNews", 80, 0, DisplayNews)

local sIndex = 1
local function DisplayUpdates()
	chat.AddText(Color(0, 160, 255), "[NEWS] ", Color(213, 213, 213), GeneralInfo[sIndex])
	
	sIndex = sIndex + 1
	if sIndex > #GeneralInfo then
		sIndex = 1
	end
end
timer.Create("DisplayUpdates", 140, 0, DisplayUpdates)

--[==[---------------------------------------------------------
       Used to send human/undead hints to players
---------------------------------------------------------]==]
local HumanIndex, ZombieIndex = 1, 1
local function DisplayHints()
	local pl = LocalPlayer()
	if not IsValid(pl) then
		return
	end

	local Team = pl:Team()
	
	if Team == TEAM_HUMAN then
		chat.AddText(Color(0, 160, 255), "[HINT] ", Color(213, 213, 213), HumanHints[HumanIndex] )

		HumanIndex = HumanIndex + 1
		if HumanIndex > #HumanHints then
			HumanIndex = 1
		end
	elseif Team == TEAM_UNDEAD then
		chat.AddText(Color(0, 255, 0), "[HINT] ", Color(213, 213, 213), UndeadHints[ZombieIndex])

		ZombieIndex = ZombieIndex + 1
		if ZombieIndex > #UndeadHints then
			ZombieIndex = 1
		end
	end
end
timer.Create("DisplayHints", 140, 0, DisplayHints)