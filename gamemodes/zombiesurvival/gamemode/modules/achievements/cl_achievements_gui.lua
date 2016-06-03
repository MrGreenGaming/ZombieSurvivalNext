if CLIENT then
	surface.CreateFont("bold", {font = "LemonMilk" , size = 19, weight = 500, color = Color(0,0,0,255)}) --http://www.dafont.com/marsneveneksk.d4012 - font creator
	surface.CreateFont("bold_x", {font = "Trebuchet18" , size = 18, weight = 600, color = Color(0,0,0,255)})
	surface.CreateFont("normal", {font = "Trebuchet18", color = Color(0,0,0,255)})
	
	local main
	
	function OpenAchievementGUI()

		if IsValid( main ) then return end
				
		main = vgui.Create( "DFrame" )
		main:SetSize( 1024, 400 )
		main:SetTitle( "" )
		main:MakePopup()
		main:Center()
		main:SetSizable( true )
		main:ShowCloseButton( false )
		main:SetDeleteOnClose( true )
		main:DockPadding( 8, 24+5, 8, 8 )
		main.Paint = function( self, w, h )
			surface.SetDrawColor( 50, 50, 50, 135 )
			surface.DrawOutlinedRect( 0, 0, w, h )
			surface.SetDrawColor( 2, 134, 242, 240 )
			surface.DrawRect( 1, 1, w - 2, h - 2 )
			surface.SetFont( "bold" )
			surface.SetTextPos( w / 2 - surface.GetTextSize( "Achievements" ) / 2, 6 ) 
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.DrawText( "Achievements" )
		end
		
		local close = vgui.Create( "DButton", main )
		close:SetText( "" )
				
		local colorv = Color( 150, 150, 150, 250 )
		
		close.Paint = function( self, w, h )
			surface.SetDrawColor( colorv )
			surface.DrawRect( 1, 1, w - 2, h - 2 )	
			surface.SetFont( "bold_x" )
			local tw, th = surface.GetTextSize( "x" ) -- the text height is wrong but the width is usable
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( (w/2)-(tw/2), 0.5 )
			surface.DrawText( "x" )
			return true
		end
		
		close.OnCursorEntered = function() colorv = Color( 195, 75, 0, 250 ) end
		close.OnCursorExited = function() colorv = Color( 150, 150, 150, 250 ) end
		close.OnMousePressed = function() colorv = Color( 170, 0, 0, 250 ) end
		close.OnMouseReleased = function()
			if not LocalPlayer().InProgress then
				main:Close()
			end
		end
		
		local inside = vgui.Create( "DPanel", main )
		inside:Dock( FILL )
		inside:DockPadding( 5, 5, 5, 5 )
		inside:InvalidateParent( true )
		inside.Paint = function( self, w, h )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawOutlinedRect( 0, 0, w, h )
			surface.SetDrawColor( 255, 255, 255, 250 )
			surface.DrawRect( 1, 1, w - 2, h - 2 )
		end
		
		local panel_left = vgui.Create("DPanel", inside)
		panel_left:Dock( LEFT )
		panel_left:SetBackgroundColor(Color(255,255,255))
		panel_left:DockPadding( 5, 32 + 5, 5, 5 )
		panel_left:SetWide( inside:GetWide()/3*2 - 8 )
		panel_left.PaintOver = function( self, w, h )
			surface.SetFont( "bold" )
			surface.SetTextColor( 0, 0, 0, 255 )
			local tw, th = surface.GetTextSize( "Locked" )
			surface.SetTextPos( (w/4)-(tw/2), th/2 )
			surface.DrawText( 'Locked' )
			local tw2, th2 = surface.GetTextSize( "Unlocked" )
			surface.SetTextPos( ((w/4)*3)-(tw2/2), th2/2 )
			surface.DrawText( 'Unlocked' )
		end
		
		local panel_right = vgui.Create("DPanel", inside)
		panel_right:Dock( RIGHT )
		panel_right:DockPadding( 8, 8, 8, 8 )
		panel_right:SetBackgroundColor(Color(255,255,255))
		
		local scroll = vgui.Create("DScrollPanel", panel_right)
		scroll:Dock( FILL )
		
		local achievement_name = vgui.Create("DLabel", scroll)
		achievement_name:Dock( TOP )
		achievement_name:SetWrap( true )
		achievement_name:SetFont( "bold" )
		achievement_name:SetText("")
		achievement_name:SetTextColor(Color(0,0,0))
		
		local achievement_desc = vgui.Create("DLabel", scroll)
		achievement_desc:Dock( TOP )
		achievement_desc:SetWrap( true )
		achievement_desc:SetFont( "normal" )
		achievement_desc:SetText("")
		achievement_desc:SetTextColor(Color(0,0,0))
		
		local achievement_lock_list = vgui.Create("DListView", panel_left)
		achievement_lock_list:SetMultiSelect(false)
		achievement_lock_list:AddColumn("Achievement Name")
		achievement_lock_list:Dock( LEFT )
		
		achievement_lock_list.OnRowSelected = function(self, line)
			for _, achievement in pairs(Achievements.List) do
				if self:GetLine(line):GetValue(1) == achievement.displayname then
					achievement_name:SetText(achievement.displayname)
					achievement_name:SizeToContents()
					achievement_desc:SetText(achievement.description)
					achievement_desc:SizeToContents()
				end
			end
		end
		
		local achievement_unlock_list = vgui.Create("DListView", panel_left)
		achievement_unlock_list:SetMultiSelect(false)
		achievement_unlock_list:AddColumn("Achievement Name")
		achievement_unlock_list:Dock( RIGHT )
		
		achievement_unlock_list.OnRowSelected = achievement_lock_list.OnRowSelected
		
		main.PerformLayout = function( self ) -- needed to set stuff to the correct size
		
			close:SetPos( self:GetWide() - 50, 0 )
			close:SetSize( 44, 22 )
			
			panel_right:SetWide( inside:GetWide()/3 - 8 )
			panel_left:SetWide( inside:GetWide()/3*2 - 8 )
			
			achievement_name:SizeToContents()
			achievement_desc:SizeToContents()
			
			achievement_lock_list:SetWide( ( panel_left:GetWide()/2 )-8 )
			achievement_unlock_list:SetWide( ( panel_left:GetWide()/2 )-8 )
			
		end
		
		for _, achievement in pairs(Achievements.List) do
			if table.HasValue(Achievements.Completed, achievement.name) then
				achievement_unlock_list:AddLine(achievement.displayname)
			else
				achievement_lock_list:AddLine(achievement.displayname)
			end
		end
		
	end

	net.Receive("achievements_updateply", function()

		Achievements.List = net.ReadTable()
		Achievements.Completed = net.ReadTable()
		OpenAchievementGUI()

	end)

	concommand.Add("achievements_gui", function()

		net.Start("achievements_requestupdate")
		net.SendToServer()

	end)
end
