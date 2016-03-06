AddCSLuaFile()

SWEP.Base = "weapon_zs_hate"

SWEP.ZombieOnly = true

SWEP.Primary.Delay = 1.9

SWEP.MeleeDelay = 1.9
SWEP.MeleeRange = 65
SWEP.MeleeAnimationDelay = 0.35

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsPlayer() then
		self.MeleeDamage = 65	
	end
end


function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = 55
end

function SWEP:SendAttackAnim()
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
end

function SWEP:StartSwinging()
	if self.MeleeAnimationDelay then
		self.NextAttackAnim = CurTime() + self.MeleeAnimationDelay
	else
		self:SendAttackAnim()
	end

	local owner = self.Owner
	owner:DoAttackEvent()

	if SERVER then
		self:PlayAttackSound()
	end
	self:StopMoaning()

	if self.FrozenWhileSwinging then
		owner:SetSpeed(1)
	end

	if self.MeleeDelay > 0 then
		self:SetSwingEndTime(CurTime() + self.MeleeDelay)

		local trace = self.Owner:MeleeTrace(self.MeleeReach, self.MeleeSize, player.GetAll())
		if trace.HitNonWorld then
			trace.IsPreHit = true
			self.PreHit = trace
		end

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	else
		self:Swung()
	end
end

function SWEP:StopSwinging()
	self:SetSwingEndTime(0)
end


SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	local mOwner = self.Owner
	
	HateScreams = {"zombies/hate/sawrunner_alert10.wav","zombies/hate/sawrunner_alert20.wav","zombies/hate/sawrunner_alert30.wav"}
		self.Owner:EmitSound(HateScreams[math.random(#HateScreams)], 70)
	self.NextYell = CurTime() + math.random(8,13)
end

