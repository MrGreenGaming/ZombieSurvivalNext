local PANEL = {}

PANEL.IdealPing = 50
PANEL.MaxPing = 400
PANEL.RefreshTime = 1
PANEL.PingBars = 4

PANEL.m_Player = NULL
PANEL.m_Ping = 0
PANEL.NextRefresh = 0

function PANEL:Init()
end

local colPing = Color(255, 255, 60, 255)
function PANEL:Paint()
	local ping = self:GetPing()
	local pingmul = 1 - math.Clamp((ping - self.IdealPing) / self.MaxPing, 0, 1)
	local wid, hei = self:GetWide(), self:GetTall()
	local pingbars = math.max(1, self.PingBars)
	local barwidth = wid / pingbars
	local baseheight = hei / pingbars

	colPing.r = (1 - pingmul) * 255
	colPing.g = pingmul * 255

	draw.SimpleText(ping, "ZSHUDFontSmaller", wid * 0.5, 13, COLOR_GRAY)
	--draw.SimpleText(ping, "ZSHUDFontSmaller", 25, 13, COLOR_GRAY)

	return true
end

function PANEL:Refresh()
	local pl = self:GetPlayer()
	if pl:IsValid() then
		self:SetPing(pl:Ping())
	else
		self:SetPing(0)
	end
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:Refresh()
	end
end

function PANEL:SetPlayer(pl)
	self.m_Player = pl or NULL
	self:Refresh()
end

function PANEL:GetPlayer()
	return self.m_Player
end

function PANEL:SetPing(ping)
	self.m_Ping = ping
end

function PANEL:GetPing()
	return self.m_Ping
end

vgui.Register("DPingMeter", PANEL, "Panel")
