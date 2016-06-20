local ScoreBoard
function GM:ScoreboardShow()
	gui.EnableScreenClicker(true)
	--PlayMenuOpenSound()

	if not ScoreBoard then
		ScoreBoard = vgui.Create("ZSScoreBoard")
	end

	ScoreBoard:SetSize(math.min(ScrW(), ScrH()) * 0.9, ScrH() * 0.85)
	ScoreBoard:AlignTop(ScrH() * 0.05)
	ScoreBoard:CenterHorizontal()
	ScoreBoard:SetAlpha(0)
	ScoreBoard:AlphaTo(250, 0.5, 0)
	ScoreBoard:SetVisible(true)
end

function GM:ScoreboardHide()
	gui.EnableScreenClicker(false)

	if ScoreBoard then
		--PlayMenuCloseSound()
		ScoreBoard:SetVisible(false)
	end
end

local PANEL = {}

PANEL.RefreshTime = 0.8
PANEL.NextRefresh = 0
PANEL.m_MaximumScroll = 0

local function BlurPaint(self)
		draw.SimpleText(self:GetValue(), self.Font, 0, 0, self:GetTextColor())
	return true
end
local function emptypaint(self)
	return true
end

function PANEL:Init()
	self.NextRefresh = RealTime() + 0.1

	local w, h = ScrW(), ScrH()
	
	score_label	= vgui.Create("DLabel", self)
	score_label:SetFont("ZSHUDFont2")
	score_label:SetText("Scoreboard")
	score_label:SetTextColor(COLOR_GRAY)
	score_label:SetPos(w * 0.205,45)
	score_label:SizeToContents()
	
	Names = vgui.Create("DLabel", self)
	Names:SetFont("ZSHUDFontSmaller")
	Names:SetText("Survivors")
	Names:SetTextColor(COLOR_GRAY)
	Names:SetPos(w * 0.05,100)
	Names:SizeToContents()
	
	Names2 = vgui.Create("DLabel", self)
	Names2:SetFont("ZSHUDFontSmaller")
	Names2:SetText("SP")
	Names2:SetTextColor(COLOR_GRAY)
	Names2:SetPos(w * 0.155,100)
	Names2:SizeToContents()
	
	Names3 = vgui.Create("DLabel", self)
	Names3:SetFont("ZSHUDFontSmaller")
	Names3:SetText("Ping")
	Names3:SetTextColor(COLOR_GRAY)
	Names3:SetPos(w * 0.21,100)
	Names3:SizeToContents()
	
	Names4 = vgui.Create("DLabel", self)
	Names4:SetFont("ZSHUDFontSmaller")
	Names4:SetText("Zombies")
	Names4:SetTextColor(COLOR_GRAY)
	Names4:SetPos(w * 0.305,100)
	Names4:SizeToContents()
	
	Names5 = vgui.Create("DLabel", self)
	Names5:SetFont("ZSHUDFontSmaller")
	Names5:SetText("Brains")
	Names5:SetTextColor(COLOR_GRAY)
	Names5:SetPos(w * 0.405,100)
	Names5:SizeToContents()
	
	Names6 = vgui.Create("DLabel", self)
	Names6:SetFont("ZSHUDFontSmaller")
	Names6:SetText(" Ping")
	Names6:SetTextColor(COLOR_GRAY)
	Names6:SetPos(w * 0.46,100)
	Names6:SizeToContents()
	
if ARENA then
	Names7 = vgui.Create("DLabel", self)
	Names7:SetFont("ZSHUDFont3")
	Names7:SetText("ARNEA MODE")
	Names7:SetTextColor(COLOR_DARKRED)
	Names7:SetPos(w * 0.17,0)
	Names7:SizeToContents()
end

if GAMEMODE.ZombieEscape then
	Names8 = vgui.Create("DLabel", self)
	Names8:SetFont("ZSHUDFont3")
	Names8:SetText("OBJECTIVE MODE")
	Names8:SetTextColor(COLOR_DARKRED)
	Names8:SetPos(w * 0.17,0)
	Names8:SizeToContents()
end
	self.ZombieList = vgui.Create("DScrollPanel", self)
	self.ZombieList.Team = TEAM_UNDEAD

	self.HumanList = vgui.Create("DScrollPanel", self)
	self.HumanList.Team = TEAM_HUMAN

	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	local w, h = ScrW(), ScrH()
	
	self.HumanList:SetSize(self:GetWide() / 2.1, self:GetTall() - 150)
	self.HumanList:AlignBottom(16)
	self.HumanList:AlignLeft(8)

	self.ZombieList:SetSize(self:GetWide() / 2.1, self:GetTall() - 150)
	self.ZombieList:AlignBottom(16)
	self.ZombieList:AlignRight(8)
	
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:Refresh()
	end
end

local texRightEdge = surface.GetTextureID("gui/gradient")
local texCorner = surface.GetTextureID("zombiesurvival/circlegradient")
local texDownEdge = surface.GetTextureID("gui/gradient_down")
function PANEL:Paint()
	local wid, hei = self:GetSize()
	local barw = 64
end

function PANEL:GetPlayerPanel(pl)
	for _, panel in pairs(self.PlayerPanels) do
		if panel:Valid() and panel:GetPlayer() == pl then
			return panel
		end
	end
end

function PANEL:CreatePlayerPanel(pl)
	local curpan = self:GetPlayerPanel(pl)
	if curpan and curpan:Valid() then return curpan end

	local panel = vgui.Create("ZSPlayerPanel", pl:Team() == TEAM_UNDEAD and self.ZombieList or self.HumanList)
	panel:SetPlayer(pl)
	panel:Dock(TOP)
	panel:DockMargin(1, 2, 8, 1)

	self.PlayerPanels[pl] = panel

	return panel
end

function PANEL:Refresh()

	if self.PlayerPanels == nil then self.PlayerPanels = {} end

	for _, panel in pairs(self.PlayerPanels) do
		if not panel:Valid() then
			self:RemovePlayerPanel(panel)
		end
	end

	for _, pl in pairs(player.GetAll()) do
		self:CreatePlayerPanel(pl)
	end
end

function PANEL:RemovePlayerPanel(panel)
	if panel:Valid() then
		self.PlayerPanels[panel:GetPlayer()] = nil
		panel:Remove()
	end
end

vgui.Register("ZSScoreBoard", PANEL, "Panel")

local PANEL = {}

PANEL.RefreshTime = 1

PANEL.m_Player = NULL
PANEL.NextRefresh = 0

local function MuteDoClick(self)
	local pl = self:GetParent():GetPlayer()
	if pl:IsValid() then
		pl:SetMuted(not pl:IsMuted())
		self:GetParent().NextRefresh = RealTime()
	end
end

local function AvatarDoClick(self)
	local pl = self.PlayerPanel:GetPlayer()
	if pl:IsValid() and pl:IsPlayer() then
		pl:ShowProfile()
	end
end

local function empty() end

function PANEL:Init()
	self:SetTall(55)

	self.m_AvatarButton = self:Add("DButton", self)
	self.m_AvatarButton:SetText(" ")
	self.m_AvatarButton:SetSize(37, 37)
	self.m_AvatarButton:Center()
	self.m_AvatarButton.DoClick = AvatarDoClick
	self.m_AvatarButton.Paint = empty
	self.m_AvatarButton.PlayerPanel = self

	self.m_Avatar = vgui.Create("AvatarImage", self.m_AvatarButton)
	self.m_Avatar:SetSize(37, 37)
	self.m_Avatar:SetVisible(false)
	self.m_Avatar:SetMouseInputEnabled(false)

	self.m_SpecialImage = vgui.Create("DImage", self)
	self.m_SpecialImage:SetSize(16, 16)
	self.m_SpecialImage:SetMouseInputEnabled(true)
	self.m_SpecialImage:SetVisible(false)
	
	self.m_ClassImage = vgui.Create("DImage", self)
	self.m_ClassImage:SetSize(22, 22)
	self.m_ClassImage:SetMouseInputEnabled(false)
	self.m_ClassImage:SetVisible(false)

	self.m_PlayerLabel = EasyLabel(self, " ", "ZSHUDFontSmaller", COLOR_GREY)
	self.m_ScoreLabel = EasyLabel(self, " ", "ZSHUDFontSmaller", COLOR_GREY)

	self.m_PingMeter = vgui.Create("DPingMeter", self)
	self.m_PingMeter:SetSize(20, 20)
	self.m_PingMeter.PingBars = 5
	
	self.m_Mute = vgui.Create("DImageButton", self)
	self.m_Mute.DoClick = MuteDoClick
end

local colTemp = Color(255, 255, 255, 220)
function PANEL:Paint()
	local col = color_black_alpha220
	local mul = 0.5
	local pl = self:GetPlayer()
	if pl:IsValid() then
		col = team.GetColor(pl:Team())

		if pl:SteamID() == "STEAM_0:1:3307510" then
			mul = 0.6 + math.abs(math.sin(RealTime() * 6)) * 0.4
		elseif 	pl:SteamID() == "STEAM_0:0:59565612" then
			mul = 0.6 + math.abs(math.sin(RealTime() * 6)) * 0.4
		elseif pl == MySelf then
			mul = 0.8
		end
	end

	if self.Hovered then
		mul = math.min(1, mul * 1.5)
	end

	colTemp.r = col.r * mul
	colTemp.g = col.g * mul
	colTemp.b = col.b * mul
	draw.RoundedBox(1, 0, 0, self:GetWide(), self:GetTall(), colTemp)

if pl:Team() == TEAM_HUMAN then
	local wid, hei = self:GetWide(), self:GetTall()
	if ( pl:GetModel() == "models/player/group03/male_02.mdl") then 
		surface.SetDrawColor( 190, 190, 190, 255 ) 
		surface.SetMaterial( Material( "hud/classes/UI_PerkIcon_SWAT.png" ) )	
		surface.DrawTexturedRect(wid * 0.75, 9, 40, 40 ) 
		
	 elseif ( pl:GetModel() == "models/player/combine_soldier_prisonguard.mdl") then
	 	surface.SetDrawColor( 190, 190, 190, 255 ) 
		surface.SetMaterial( Material( "hud/classes/UI_PerkIcon_Gunslinger.png" ) )	
		surface.DrawTexturedRect(wid * 0.75, 9, 40, 40 )

	 elseif ( pl:GetModel() == "models/player/kleiner.mdl") then
	 	surface.SetDrawColor( 190, 190, 190, 255 ) 
		surface.SetMaterial( Material( "hud/classes/UI_PerkIcon_Demolition.png" ) )	
		surface.DrawTexturedRect(wid * 0.75, 9, 40, 40 )
		
	 elseif ( pl:GetModel() == "models/player/riot.mdl") then
		surface.SetDrawColor( 190, 190, 190, 255 ) 
		surface.SetMaterial( Material( "hud/classes/UI_PerkIcon_Berserker.png" ) )
		surface.DrawTexturedRect(wid * 0.75, 9, 40, 40 )
		
	 elseif ( pl:GetModel() == "models/player/guerilla.mdl") then
		surface.SetDrawColor( 190, 190, 190, 255 ) 
		surface.SetMaterial( Material( "hud/classes/UI_PerkIcon_Support.png" ) )
		surface.DrawTexturedRect(wid * 0.75, 9, 40, 40 ) 	 

	 elseif ( pl:GetModel() == "models/player/gordon_classic.mdl") then
		surface.SetDrawColor( 190, 190, 190, 255 ) 
		surface.SetMaterial( Material( "hud/classes/Boxing_gloves_icon.png" ) )
		surface.DrawTexturedRect(wid * 0.75, 9, 40, 40 )	 
	else 
		return
	 end
end
	return true
end

function PANEL:DoClick()
	local pl = self:GetPlayer()
	if pl:IsValid() then
		gamemode.Call("ClickedPlayerButton", pl, self)
	end
end

function PANEL:PerformLayout()
	self.m_AvatarButton:AlignLeft(30)
	self.m_AvatarButton:CenterVertical()

	self.m_PlayerLabel:SizeToContents()
	self.m_PlayerLabel:MoveRightOf(self.m_AvatarButton, 20)
	self.m_PlayerLabel:CenterVertical()

	self.m_ScoreLabel:SizeToContents()
	local pl = self:GetPlayer()
	if pl:Team() == TEAM_UNDEAD then
		self.m_ScoreLabel:SetPos(self:GetWide() * 0.666 - self.m_ScoreLabel:GetWide() / 1.3, 0)
	end
	
	if pl:Team() == TEAM_HUMAN then
		self.m_ScoreLabel:SetPos(self:GetWide() * 0.666 - self.m_ScoreLabel:GetWide() / 2, 0)
	end
	
	self.m_ScoreLabel:CenterVertical()

	self.m_SpecialImage:CenterVertical()

	--self.m_ClassImage:SetSize(self:GetTall(), self:GetTall())
	--self.m_ClassImage:SetPos(self:GetWide() * 0.5 - self.m_ClassImage:GetWide() * 0.5, 0)
	--self.m_ClassImage:CenterVertical()

	local pingsize = self:GetTall() - 4

	self.m_PingMeter:SetSize(pingsize * 1.7, pingsize)
	self.m_PingMeter:AlignRight(8)
	self.m_PingMeter:CenterVertical()

	self.m_Mute:SetSize(16, 16)
	--self.m_Mute:MoveLeftOf(self.m_PingMeter, 8)
	self.m_Mute:MoveRightOf(self.m_PlayerLabel, 8)
	self.m_Mute:CenterVertical()
end

function PANEL:Refresh()
	local pl = self:GetPlayer()
	if not pl:IsValid() then
		self:Remove()
		return
	end

	local name = pl:Name()
	if #name > 26 then
		name = string.sub(name, 1, 24)..".."
	end
	self.m_PlayerLabel:SetText(name)
	self.m_ScoreLabel:SetText(pl:Frags())

	if pl == LocalPlayer() then
		self.m_Mute:SetVisible(false)
	else
		if pl:IsMuted() then
			self.m_Mute:SetImage("icon16/sound_mute.png")
		else
			self.m_Mute:SetImage("icon16/sound.png")
		end
	end

	self:SetZPos(-pl:Frags())

	if pl:Team() ~= self._LastTeam then
		self._LastTeam = pl:Team()
		self:SetParent(self._LastTeam == TEAM_HUMAN and ScoreBoard.HumanList or ScoreBoard.ZombieList)
	end

	self:InvalidateLayout()
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:Refresh()
	end
end

function PANEL:SetPlayer(pl)
	self.m_Player = pl or NULL

	if pl:IsValid() and pl:IsPlayer() then
		self.m_Avatar:SetPlayer(pl)
		self.m_Avatar:SetVisible(true)

		if gamemode.Call("IsSpecialPerson", pl, self.m_SpecialImage) then
			self.m_SpecialImage:SetVisible(true)
		else
			self.m_SpecialImage:SetTooltip()
			self.m_SpecialImage:SetVisible(false)
		end
	else
		self.m_Avatar:SetVisible(false)
		self.m_SpecialImage:SetVisible(false)
	end

	self.m_PingMeter:SetPlayer(pl)

	self:Refresh()
end

function PANEL:GetPlayer()
	return self.m_Player
end

vgui.Register("ZSPlayerPanel", PANEL, "Button")
