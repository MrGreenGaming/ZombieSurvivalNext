function FindStartingItem(id)
	if not id then return end

	local t

	local num = tonumber(id)
	if num then
		t = GAMEMODE.Items[num]
	else
		for i, tab in pairs(GAMEMODE.Items) do
			if tab.Signature == id then
				t = tab
				break
			end
		end
	end

	if t and t.WorthShop then return t end
end

function FindItem(id)
	if not id then return end

	local t

	local num = tonumber(id)
	if num then
		t = GAMEMODE.Items[num]
	else
		for i, tab in pairs(GAMEMODE.Items) do
			if tab.Signature == id then
				t = tab
				break
			end
		end
	end

	return t
end

function TrueVisible(posa, posb, filter)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, player.GetAll())
	if filter then
		filt[#filt + 1] = filter
	end

	return not util.TraceLine({start = posa, endpos = posb, filter = filt, mask = MASK_SHOT}).Hit
end

function TrueVisibleFilters(posa, posb, ...)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, player.GetAll())
	if ... ~= nil then
		for k, v in pairs({...}) do
			filt[#filt + 1] = v
		end
	end

	return not util.TraceLine({start = posa, endpos = posb, filter = filt, mask = MASK_SHOT}).Hit
end

function WorldVisible(posa, posb)
	return not util.TraceLine({start = posa, endpos = posb, mask = MASK_SOLID_BRUSHONLY}).Hit
end

function ValidFunction(ent, funcname, ...)
	if ent and ent:IsValid() and ent[funcname] then
		return ent[funcname](ent, ...)
	end
end

function CosineInterpolation(y1, y2, mu)
	local mu2 = (1 - math.cos(mu * math.pi)) / 2
	return y1 * (1 - mu2) + y2 * mu2
end

function string.AndSeparate(list)
	local length = #list
	if length <= 0 then return "" end
	if length == 1 then return list[1] end
	if length == 2 then return list[1].." and "..list[2] end

	return table.concat(list, ", ", 1, length - 1)..", and "..list[length]
end

function util.SkewedDistance(a, b, skew)
	if a.z > b.z then
		return math.sqrt((b.x - a.x) ^ 2 + (b.y - a.y) ^ 2 + ((a.z - b.z) * skew) ^ 2)
	end

	return a:Distance(b)
end

function util.Blood(pos, amount, dir, force, noprediction)
	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetMagnitude(amount)
		effectdata:SetNormal(dir)
		effectdata:SetScale(math.max(128, force))
	util.Effect("bloodstream", effectdata, nil, noprediction)
end

-- I had to make this since the default function checks visibility vs. the entitiy's center and not the nearest position.
function util.BlastDamageEx(inflictor, attacker, epicenter, radius, damage, damagetype)
	local filter = inflictor
	for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
		local nearest = ent:NearestPoint(epicenter)
		if TrueVisibleFilters(epicenter, nearest, inflictor, ent) then
			ent:TakeSpecialDamage(((radius - nearest:Distance(epicenter)) / radius) * damage, damagetype, attacker, inflictor, nearest)
		end
	end
end

function util.BlastDamage2(inflictor, attacker, epicenter, radius, damage)
	util.BlastDamageEx(inflictor, attacker, epicenter, radius, damage, DMG_BLAST)
end

function util.PoisonBlastDamage(inflictor, attacker, epicenter, radius, damage, noreduce)
	local filter = inflictor
	for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
		local nearest = ent:NearestPoint(epicenter)
		if TrueVisibleFilters(epicenter, nearest, inflictor, ent) then
			ent:PoisonDamage(((radius - nearest:Distance(epicenter)) / radius) * damage, attacker, inflictor, nil, noreduce)
		end
	end
end

function util.ToMinutesSeconds(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

    return string.format("%02d:%02d", minutes, math.floor(seconds))
end

function util.ToMinutesSecondsMilliseconds(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	local milliseconds = math.floor(seconds % 1 * 100)

    return string.format("%02d:%02d.%02d", minutes, math.floor(seconds), milliseconds)
end

function util.RemoveAll(class)
	for _, ent in pairs(ents.FindByClass(class)) do
		ent:Remove()
	end
end

local function TooNear(spawn, tab, dist)
	local spawnpos = spawn:GetPos()
	for _, ent in pairs(tab) do
		if ent:GetPos():Distance(spawnpos) <= dist then
			return true
		end
	end

	return false
end
function team.GetSpawnPointGrouped(teamid, dist)
	dist = dist or 200

	local tab = {}
	local spawns = team.GetSpawnPoint(teamid)

	for _, spawn in pairs(spawns) do
		if not TooNear(spawn, tab, dist) then
			table.insert(tab, spawn)
		end
	end

	return tab
end

function AccessorFuncDT(tab, membername, type, id)
	local emeta = FindMetaTable("Entity")
	local setter = emeta["SetDT"..type]
	local getter = emeta["GetDT"..type]

	tab["Set"..membername] = function(me, val)
		setter(me, id, val)
	end

	tab["Get"..membername] = function(me)
		return getter(me, id)
	end
end

function team.GetValidSpawnPoint(teamid)
	local t = {}

	local spawns = team.GetSpawnPoint(teamid)
	if spawns then
		for _, ent in pairs(spawns) do
			if ent:IsValid() then
				t[#t + 1] = ent
			end
		end
	end

	return t
end

function timer.SimpleEx(delay, action, ...)
	if ... == nil then
		timer.Simple(delay, action)
	else
		local a, b, c, d, e, f, g, h, i, j, k = ...
		timer.Simple(delay, function() action(a, b, c, d, e, f, g, h, i, j, k) end)
	end
end

function timer.CreateEx(timername, delay, repeats, action, ...)
	if ... == nil then
		timer.Create(timername, delay, repeats, action)
	else
		local a, b, c, d, e, f, g, h, i, j, k = ...
		timer.Create(timername, delay, repeats, function() action(a, b, c, d, e, f, g, h, i, j, k) end)
	end
end

function ents.CreateLimited(class, limit)
	if #ents.FindByClass(class) >= (limit or 200) then return NULL end

	return ents.Create(class)
end

function tonumbersafe(a)
	local n = tonumber(a)

	if n then
		if n == 0 or n < 0 or n > 0 then
			return n
		end

		-- NaN!
		return 0
	end

	return nil
end

function ents.FindHumansInSphere ( vPos, fRadius )
	if not vPos or not fRadius then return end
	
	-- Get ents in that radius
	local tbEnts = team.GetPlayers(TEAM_HUMAN)-- ents.FindInSphere ( vPos, fRadius )
	local tbHumans = {} 
	
	-- Leave only humans
	for k,v in pairs ( tbEnts ) do
		if v:IsPlayer() and v:GetPos():Distance(vPos) <= fRadius then
			table.insert ( tbHumans, v )
		end
	end
	
	return tbHumans	
end

function GetHowlers( vPos, iRadius )
	if vPos == nil or iRadius == nil then return end
	
	-- Our howler table
	local tbHowlers = {}
	
	for k,v in pairs ( team.GetPlayers(TEAM_UNDEAD) ) do-- ents.FindInSphere ( vPos, iRadius )
		if v:IsPlayer() and v:Alive() and v:Team() == TEAM_UNDEAD  and vPos:Distance(v:GetPos()) <= iRadius then
			if v:IsHowler() then
				table.insert ( tbHowlers, v )
			end
		end
	end
	
	return tbHowlers 
end

--[==[------------------------------------------------------------------------------
                Returns if an entity is visible by another entity
------------------------------------------------------------------------------]==]
function IsEntityVisible ( mTarget, vSource, mFilter, iMask )
	if vSource == nil or mTarget == nil then return end
	
	-- Mask
	if not iMask then iMask = MASK_SHOT end
	
	-- Bool
	local bIsVisible = false
	
	-- Use center
	local vEnd = mTarget:GetPos() + mTarget:OBBCenter() + Vector( 0,0,6 )
	
	-- Trace 
	local tr = util.TraceLine ( { start = vSource, endpos = vEnd, filter = mFilter, mask = iMask } )
	if tr.Entity == mTarget then bIsVisible = true end
	
	return bIsVisible
end

--[==[-----------------------------------------------------------------------
	    Returns if a world vector is visible to humans
-------------------------------------------------------------------------]==]
function VisibleToHumans ( vPos, mFilter )
	if vPos == nil or mFilter:Team() == TEAM_HUMAN then return end
	
	-- No humans
	if #team.GetPlayers ( TEAM_HUMAN ) <= 0 then return end
	
	-- Visiblity bool
	local bCanSeeMe = false
	
	-- Get closest human first
	local mClosest = GetClosestEntity ( vPos, team.GetPlayers ( TEAM_HUMAN ) )
	if IsEntityVisible ( mClosest, vPos + Vector ( 0,0,55 ), mFilter ) then return true end
	
	-- Cache cheked humans
	local tbChecked = {}
	
	for i = 1, 3 do
		if bCanSeeMe then break end
	
		-- Get closest humans
		local tbFound = ents.FindInSphere ( vPos, i * 150 )
		
		-- Parse through the found humans in sphere
		for k,v in pairs ( tbFound ) do
			if not table.HasValue ( tbChecked, v ) then if v:IsPlayer() and v:IsHuman() then table.insert ( tbChecked, v ) if IsEntityVisible ( v, vPos + Vector ( 0,0,55 ), mFilter ) then bCanSeeMe = true break end end end
		end
	end
	
	return bCanSeeMe
end

--[==[---------------------------------------------------------
        Returns the team name (string) of a player
---------------------------------------------------------]==]
function GetStringTeam ( pl )
	if not IsValid ( pl ) then return end
	if not pl:IsPlayer() then return end
	
	local Team, String = pl:Team(), "TEAM_HUMAN"
	if Team == TEAM_UNDEAD then String = "TEAM_UNDEAD" end
	
	return String
end

--[==[---------------------------------------------------------
    Get a player by its name or fraction of the name
---------------------------------------------------------]==]
function GetPlayerByName( name )
	if name == nil then return end
	if name == "" then return -1 end

	-- entity found, multiple found bool and string found
	local found, multiple, foundString = nil, false
	
	-- run through the players
	for k,v in pairs( player.GetAll() ) do
		foundString = string.find( string.lower( v:GetName() ), string.lower( name ) )
		if ( foundString ~= nil and multiple == false ) then
			if ( found == nil ) then found = v else	multiple = true end
		end	
	end

	-- Return -2 if found multiple or -1 if not found
	if ( multiple == true ) then return -2 end
	if ( found == nil or not found:IsValid() ) then return -1 end
	
	return found	
end
