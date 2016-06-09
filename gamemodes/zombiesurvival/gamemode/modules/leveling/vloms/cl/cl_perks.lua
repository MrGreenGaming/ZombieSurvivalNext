function VRegisterPerk( pname, pcat, plvl, pdesc, pfunc )

	Vloms.Perks[#Vloms.Perks+1] = {}

	Vloms.Perks[#Vloms.Perks]['name'] = pname
	Vloms.Perks[#Vloms.Perks]['lvl'] = plvl
	Vloms.Perks[#Vloms.Perks]['desc'] = pdesc

end