util.AddNetworkString("achievements_updateply")
util.AddNetworkString("achievements_requestupdate")

net.Receive("achievements_requestupdate", function(len, ply)

	Achievements.UpdatePly(ply)

end)