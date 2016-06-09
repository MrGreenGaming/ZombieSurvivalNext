Vloms = {}
Vloms.Perks = {}

Vloms.XP = 0
Vloms.XPReq = VCalcXPReq(1)
Vloms.Level = 1

local function VAddLuaFile( file ) 

	print( file )
	AddCSLuaFile( file )

end

VAddLuaFile('modules/leveling/vloms/cl/cl_init.lua')
VAddLuaFile('modules/leveling/vloms/cl/cl_net.lua')
VAddLuaFile('modules/leveling/vloms/cl/cl_perks.lua')
VAddLuaFile('modules/leveling/vloms/cl/ui/fonts.lua')
VAddLuaFile('modules/leveling/vloms/cl/ui/cl_hud.lua')
VAddLuaFile('modules/leveling/vloms/cl/ui/cl_perksmenu.lua')

--// Resources

resource.AddFile('sound/vloms/yay.wav')
resource.AddFile('materials/vloms/perklocked.png')
resource.AddFile('materials/vloms/perkunlocked.png')

--// Includes

--include('modules/leveling/vloms/cl/cl_net.lua')
--include('modules/leveling/vloms/cl/cl_perks.lua')
--include('modules/leveling/vloms/cl/ui/fonts.lua')
--include('modules/leveling/vloms/cl/ui/cl_hud.lua')
--include('modules/leveling/vloms/cl/ui/cl_perksmenu.lua')

--// Include the modules, too

local fs,  dir = file.Find( 'modules/leveling/vloms/modules/*', 'LUA' )

for i=1,#dir do
	
	include( 'modules/leveling/vloms/modules/' .. dir[i] .. '/module.lua' )

end

--// Update required XP on levelup

hook.Add("VClPlayerLevelUp", "VLevelUpReqXP", function( lvl )

	Vloms.XPReq = VCalcXPReq( lvl )

end)







surface.CreateFont( "VlomsFontSmall", {
	font = "Trebuchet MS",
	size = 16,
	weight = 900,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "VlomsFont", {
	font = "Trebuchet MS",
	size = 20,
	weight = 900,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "VlomsFontBig", {
	font = "Trebuchet MS",
	size = 28,
	weight = 900,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

--// XP and Level

net.Receive( "VSendStats", function(length)

	local plystats = net.ReadTable()

	Vloms.XP = plystats['xp']
	Vloms.Level = plystats['lvl']

	Vloms.XPReq = VCalcXPReq(Vloms.Level)

end)

net.Receive( "VExperienceReceived", function(length)

	local xprec = net.ReadInt( 16 )
	Vloms.XP = Vloms.XP + xprec

	hook.Run( "VClPlayerGotXP", xprec )

end)

net.Receive( "VLevelUp", function(length)

	hook.Run( "VClPlayerLevelUp", net.ReadInt( 16 ) )

end)

--// Perks

net.Receive( "VPerks", function(length)

	Vloms.Perks = net.ReadTable()
	table.SortByMember( Vloms.Perks, 'lvl', function(a, b) return tonumber(a) > tonumber(b) end )

end)


function VRegisterPerk( pname, pcat, plvl, pdesc, pfunc )

	Vloms.Perks[#Vloms.Perks+1] = {}

	Vloms.Perks[#Vloms.Perks]['name'] = pname
	Vloms.Perks[#Vloms.Perks]['lvl'] = plvl
	Vloms.Perks[#Vloms.Perks]['desc'] = pdesc

end








CreateConVar( 'vloms_hudtype', 0, FCVAR_NONE, 'Base HUD variations' ) 

local ScreenW = ScrW()
local ScreenH = ScrH()

local function VBaseHUDOne()

	draw.RoundedBox( 12, 90, 8, 200, 24, Color(20, 120, 20, 255) )
	draw.RoundedBox( 12, ScreenW - 290, 8, 200, 24, Color(20, 120, 20, 255) )

	draw.RoundedBox( 10, ScreenW / 2 - 100, 2, 200, 20, Color(0, 80, 0, 255) )  --Background 
	draw.RoundedBox( 10, ScreenW / 2 - 60, 20, 120, 30, Color(0, 80, 0, 255) )  --Background 2

	draw.RoundedBox( 10, ScreenW / 2 - 98, 4, 196, 16, Color(0, 120, 0, 255) )  --Background 3
	draw.RoundedBox( 10, ScreenW / 2 - 58, 22, 116, 26, Color(0, 120, 0, 255) )  --Background 4

	draw.RoundedBox( 0, 100, 12, ScreenW - 200, 16, Color(0, 80, 0, 255) )  --Background 5
	draw.RoundedBox( 0, 102, 14, ScreenW - 204, 12, Color(190, 190, 190, 255) ) --Background 6

	// XP bar

	draw.RoundedBox( 0, 102, 14, math.Clamp((Vloms.XP / Vloms.XPReq * (ScreenW - 204)), 0, ScreenW - 204), 6, Color(20, 160, 20, 180) ) --Top, darker
	draw.RoundedBox( 0, 102, 20, math.Clamp((Vloms.XP / Vloms.XPReq * (ScreenW - 204)), 0, ScreenW - 204), 6, Color(20, 140, 20, 200) ) --Bot, lighter

	// Level text

	draw.DrawText('Lv. ' .. Vloms.Level, 'VlomsFont', ScreenW / 2, 28, Color(255, 255, 255, 160), TEXT_ALIGN_CENTER)

end

local function VBaseHUDTwo()

	draw.RoundedBox( 0, 400, ScreenH-18, ScreenW - 800, 12, Color(0, 80, 0, 255) )  --Background 5
	draw.RoundedBox( 0, 402, ScreenH-16, ScreenW - 804, 8, Color(190, 190, 190, 255) ) --Background 6

	// XP bar

	draw.RoundedBox( 0, 402, ScreenH - 16, math.Clamp((Vloms.XP / Vloms.XPReq * (ScreenW - 800)), 0, ScreenW - 804), 4, Color(20, 160, 20, 180) ) --Top, darker
	draw.RoundedBox( 0, 402, ScreenH - 12, math.Clamp((Vloms.XP / Vloms.XPReq * (ScreenW - 804)), 0, ScreenW - 804), 4, Color(20, 140, 20, 200) ) --Bot, lighter

	// Level text

	draw.DrawText('Lv. ' .. Vloms.Level, 'VlomsFont', ScreenW / 2, ScreenH - 36, Color(255, 255, 255, 160), TEXT_ALIGN_CENTER)

end

hook.Add("HUDPaint", "VBaseHUD", function()

	if (GetConVarNumber('vloms_hudtype') == 0) then
		VBaseHUDOne()
	elseif (GetConVarNumber('vloms_hudtype') == 1) then
		VBaseHUDTwo()
	end

end)








local ScreenW = ScrW()
local ScreenH = ScrH()

VlomsPerksPanel = {}

function VlomsPerksPanel:Init()

	self:SetSize( 425, 650 )
	self:Center()

end

function VlomsPerksPanel:Paint( w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color(150, 150, 200, 255) )
	draw.RoundedBox( 0, 10, 40, w-20, h-50, Color(200, 200, 255, 255) )

	draw.DrawText('Vloms - Perks Menu', 'VlomsFontBig', 210, 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

end

VlomsPerksPerk = {}

function VlomsPerksPerk:Init()

	self:SetSize( 360, 64 )
	self:Center()

end

function VlomsPerksPerk:Paint( w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color(160, 160, 230, 230) )

	draw.RoundedBox( 0, 5, 5, 54, 54, Color(170, 170, 230, 235) )
	draw.RoundedBox( 0, 64, 5, w-69, 54, Color(170, 170, 230, 235) )

end

VlomsPerkClose = {}

function VlomsPerkClose:Init()

	self:SetSize( 24, 24 )
	self:Center()

end

function VlomsPerkClose:Paint( w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color(160, 160, 230, 230) )

end

vgui.Register( 'VlomsPerks', VlomsPerksPanel, 'Panel' )
vgui.Register( 'VlomsPerksPerk', VlomsPerksPerk, 'Panel' )
vgui.Register( 'VlomsPerkClose', VlomsPerkClose, 'DButton' )

local function VShowPerks()

	PerksMain = vgui.Create( 'VlomsPerks' )

	local PerksClose = vgui.Create( 'VlomsPerkClose', PerksMain )
	PerksClose:SetSize( 24, 24 )
	PerksClose:SetPos( 391, 10 )
	PerksClose:SetText( 'X' )
	PerksClose.DoClick = function()
		PerksMain:Hide()	
	end

	local PerksScroll = vgui.Create( 'DScrollPanel', PerksMain )
	PerksScroll:SetSize( 400, 580 )
	PerksScroll:SetPos( 5, 50 )

	local PerksScrollBar = PerksScroll:GetVBar()

	function PerksScrollBar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(170, 170, 220, 100) )
	end

	function PerksScrollBar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(160, 160, 210, 255) )
	end

	function PerksScrollBar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(160, 160, 210, 255) )
	end

	function PerksScrollBar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(160, 160, 210, 120) )
	end

	for i=1,#Vloms.Perks do
		
		local Perk = vgui.Create( 'VlomsPerksPerk', PerksScroll )
		Perk:SetPos( 15, (i-1) * 74 )

		local PerkImage = vgui.Create( 'DImage', Perk )
		PerkImage:SetSize( 50, 50 )
		PerkImage:SetPos( 7, 7 )

		if (Vloms.Perks[i]['lvl'] <= tonumber(Vloms.Level)) then
			PerkImage:SetImage( 'vloms/perkunlocked.png' )
		else
			PerkImage:SetImage( 'vloms/perklocked.png' )
		end

		local PerkName = vgui.Create( 'DLabel', Perk )
		PerkName:SetSize( 286, 16 )
		PerkName:SetPos( 64, 7 )
		PerkName:SetText( Vloms.Perks[i]['name'] )		
		PerkName:SetFont( 'VlomsFont' )
		PerkName:SetTextColor( Color(240, 240, 255, 225) )
		PerkName:SetContentAlignment( 5 )

		local PerkDescription = vgui.Create( 'DLabel', Perk )
		PerkDescription:SetSize( 286, 28 )
		PerkDescription:SetPos( 64, 20 )
		PerkDescription:SetText( Vloms.Perks[i]['desc'] )
		PerkDescription:SetFont( 'VlomsFontSmall' )
		PerkDescription:SetTextColor( Color(240, 240, 255, 225) )
		PerkDescription:SetContentAlignment( 5 )

		local PerkLevel = vgui.Create( 'DLabel', Perk )
		PerkLevel:SetSize( 286, 28 )
		PerkLevel:SetPos( 64, 33 )
		PerkLevel:SetText( 'Lv. ' .. Vloms.Perks[i]['lvl'] )
		PerkLevel:SetFont( 'VlomsFontSmall' )
		PerkLevel:SetTextColor( Color(240, 240, 255, 225) )
		PerkLevel:SetContentAlignment( 5 )

	end

	PerksMain:MakePopup()

end
concommand.Add( 'vperks', VShowPerks )