Vloms = {}
Vloms.Version = '1.2'

Vloms.DataType = 'pdata' --How to save / load data

Vloms.Logging = false --Log events like players leaving etc
Vloms.LoggingExtensive = false --More detailed logging

Vloms.AutoXP = true --Automatically give XP every interval
Vloms.AutoXPInterval = 1 --Interval in seconds
Vloms.AutoXPAmount = 10 --XP to give every interval

Vloms.GroupAutoXP = true --Enable bonus XP rate ONLY from the auto-XP timer (see above)
Vloms.GroupAllXP = false --Determines if XP bonuses are always given (including autoxp)
Vloms.GroupXPRates = {
	{'owner', 2.5},
	{'superadmin', 2},
	{'admin', 1.5},
	{'moderator', 1.4},
	{'operator', 1.3},
	{'vip', 1.5},
	{'trusted', 1.1}
}

Vloms.PerksEnabled = true --Enable or disable perks