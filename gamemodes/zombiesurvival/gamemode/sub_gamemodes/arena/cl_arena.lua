include("sh_arena.lua")

if not GM.Arena then return end

hook.Add("HUDPaint", "arena", function()
	if not MySelf:IsValid() then return end
	
end)
	
net.Receive( "arena", function()
	local pl = LocalPlayer()
		chat.AddText( Color( 255, 0, 0 ), "Arena mode Activated!" )
	timer.Simple(2, function()
		chat.AddText( Color( 255, 0, 0 ), "Fucking go for it and shoot shit!" )
	end)
		chat.AddText( Color( 255, 0, 0 ), "You will spawn as random zombie classes, put those weapons to good use!" )
end)	