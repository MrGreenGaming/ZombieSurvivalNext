include('modules/leveling/vloms/config.lua')

function Vinclude(file)

	--Fancy way of including so it prints to console
	print(file)
	include(file)

end

function VLog(msg)

	if !(Vloms.Logging) then return end

	print('VLOMS LOG: ' .. msg)

end

print('\n\n----------------------------------------')
print('---------Vloms v' .. Vloms.Version .. ' by Lumucro----------')
print('----------------------------------------\n')

/*
	CORE
*/

print('*Loading Core\n')

Vinclude('modules/leveling/vloms/core/data/' .. Vloms.DataType .. '.lua')
Vinclude('modules/leveling/vloms/core/meta/level.lua')

if (Vloms.PerksEnabled) then
	Vinclude('modules/leveling/vloms/core/meta/perks.lua')
	Vinclude('modules/leveling/vloms/core/perks.lua')
end

Vinclude('modules/leveling/vloms/core/timers.lua')
Vinclude('modules/leveling/vloms/core/hooks.lua')
Vinclude('modules/leveling/vloms/core/modules.lua')
Vinclude('modules/leveling/vloms/core/net.lua')

/*
	UI
*/

print('\n*Loading Clientside\n')

include('modules/leveling/vloms/cl/include.lua')

/*
	PERKS
*/

print('\n*Loading Perks\n')

if (Vloms.PerksEnabled) then
	VLoadPerks()
else
	print('Perks disabled')
end

/*
	MODULES
*/

print('\n*Loading Modules\n')

VLoadModules()

print('\n----------------------------------------')
print('----------------------------------------\n')