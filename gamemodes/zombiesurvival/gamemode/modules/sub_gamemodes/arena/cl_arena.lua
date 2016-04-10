include("sh_arena.lua")

if not GM.Arena then return end

hook.Add("HUDPaint", "arena", function()
	if not MySelf:IsValid() then return end
	
end)
	
net.Receive( "arena", function()
	local pl = LocalPlayer()
		--pl:ChatPrint("Arena mode Activated!" )
	timer.Simple(2, function()
		--pl:ChatPrint("Fucking go for it and shoot shit!" )
	end)
		--pl:ChatPrint("You will spawn as random zombie classes, put those weapons to good use!" )
end)	