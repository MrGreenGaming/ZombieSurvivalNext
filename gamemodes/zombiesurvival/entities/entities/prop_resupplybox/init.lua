AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local function RefreshCrateOwners(pl)
	for _, ent in pairs(ents.FindByClass("prop_resupplybox")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:SetObjectOwner(NULL)
		end
	end
end
hook.Add("PlayerDisconnected", "ResupplyBox.PlayerDisconnected", RefreshCrateOwners)
hook.Add("OnPlayerChangedTeam", "ResupplyBox.OnPlayerChangedTeam", RefreshCrateOwners)

function ENT:Initialize()
	self:SetModel("models/items/item_item_crate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetPlaybackRate(1)

	self:EmitSound("items/ammo_pickup.wav")
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	self:SetMaxObjectHealth(200)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "maxcratehealth" then
		value = tonumber(value)
		if not value then return end

		self:SetMaxObjectHealth(value)
	elseif key == "cratehealth" then
		value = tonumber(value)
		if not value then return end

		self:SetObjectHealth(value)
	end
end

function ENT:AcceptInput(name, activator, caller, args)
	if name == "setcratehealth" then
		self:KeyValue("cratehealth", args)
		return true
	elseif name == "setmaxcratehealth" then
		self:KeyValue("maxcratehealth", args)
		return true
	end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			ent:SetModel(self:GetModel())
			ent:SetMaterial(self:GetMaterial())
			ent:SetAngles(self:GetAngles())
			ent:SetPos(self:GetPos())
			ent:SetSkin(self:GetSkin() or 0)
			ent:SetColor(self:GetColor())
			ent:Spawn()
			ent:Fire("break", "", 0)
			ent:Fire("kill", "", 0.1)
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_resupplybox")
	pl:GiveAmmo(1, "helicoptergun")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
	elseif self.Close and CurTime() >= self.Close then
		self.Close = nil
		self:ResetSequence("open")
	end
end

local NextUse = {}
function ENT:Use(activator, caller)
	if activator:Team() ~= TEAM_HUMAN or not activator:Alive() or GAMEMODE:GetWave() <= 0 then return end

	if not self:GetObjectOwner():IsValid() then
		self:SetObjectOwner(activator)
	end

	local owner = self:GetObjectOwner()
	local owneruid = owner:IsValid() and owner:UniqueID() or "nobody"
	local myuid = activator:UniqueID()

	if CurTime() < (NextUse[myuid] or 0) then
		--activator:CenterNotify(COLOR_RED, translate.ClientGet(activator, "no_ammo_here"))
		return
	end

		
	if activator:Health() < activator:GetMaximumHealth() then
		local healthDifference = math.Clamp(activator:GetMaximumHealth() - activator:Health(), 0, 12)
		local actualHealAmount = math.random(10, healthDifference)
			actualHealAmount = math.min(activator:Health() + actualHealAmount, activator:GetMaximumHealth())
			activator:SetHealth(actualHealAmount)
	end

	local ammotype
	local ammotype2
	local ammotype3
	local ammotype4
	local ammotype5
	local ammotype6
	local ammotype7
	
	local wep = activator:GetActiveWeapon()
	if not wep:IsValid() then
		ammotype = "smg1"
		ammotype2 = "ar2"
		ammotype3 = "alyxgun"
		ammotype4 = "pistol"
		ammotype5 = "357"
		ammotype6 = "xbowbolt"
		ammotype7 = "buckshot"
	end

	if not ammotype then
		ammotype = wep:GetPrimaryAmmoTypeString()
		if not GAMEMODE.AmmoResupply[ammotype] then
		ammotype = "smg1"
		ammotype2 = "ar2"
		ammotype3 = "alyxgun"
		ammotype4 = "pistol"
		ammotype5 = "357"
		ammotype6 = "xbowbolt"
		ammotype7 = "buckshot"
		end
	end

	NextUse[myuid] = CurTime() + 120

	net.Start("zs_nextresupplyuse")
		net.WriteFloat(NextUse[myuid])
	net.Send(activator)

	activator:GiveAmmo(GAMEMODE.AmmoResupply[ammotype], ammotype)
	--activator:GiveAmmo(GAMEMODE.AmmoResupply[ammotype2], ammotype2)
	--activator:GiveAmmo(GAMEMODE.AmmoResupply[ammotype3], ammotype3)
	--activator:GiveAmmo(GAMEMODE.AmmoResupply[ammotype4], ammotype4)
	--activator:GiveAmmo(GAMEMODE.AmmoResupply[ammotype5], ammotype5)
	--activator:GiveAmmo(GAMEMODE.AmmoResupply[ammotype6], ammotype6)
	--activator:GiveAmmo(GAMEMODE.AmmoResupply[ammotype7], ammotype7)
--
	
	if activator ~= owner and owner:IsValid() and owner:IsPlayer() and owner:Team() == TEAM_HUMAN then
		owner.ResupplyBoxUsedByOthers = owner.ResupplyBoxUsedByOthers + 1

		if owner.ResupplyBoxUsedByOthers % 2 == 0 then
			owner:AddPoints(1)
		end

		net.Start("zs_commission")
			net.WriteEntity(self)
			net.WriteEntity(activator)
			net.WriteUInt(1, 16)
		net.Send(owner)
	end

	if not self.Close then
		self:ResetSequence("close")
		self:EmitSound("mrgreen/supplycrates/mobile_use.mp3")
	end
	
	self.Close = CurTime() + 3
end
