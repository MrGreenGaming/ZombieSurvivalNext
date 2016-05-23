AddCSLuaFile()

SWEP.Base = "weapon_zs_hate"

SWEP.ZombieOnly = true
SWEP.MeleeDamage = 90
SWEP.MeleeDelay = 1.5
SWEP.MeleeAnimationDelay = 0.35
SWEP.Primary.Delay = 1.5

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsPlayer() then
		self.MeleeDamage = 90
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = 90
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then
		return
	end

	if SERVER then
		self.Owner:EmitSound("zombies/hate/sawrunner_alert30.wav", math.random(140, 160), math.random(90, 100))
	end

	self.NextYell = CurTime() + math.random(8,13)
end
