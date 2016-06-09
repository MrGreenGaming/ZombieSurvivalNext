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