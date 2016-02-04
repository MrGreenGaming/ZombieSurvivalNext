AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Medical Kit"
	SWEP.Description = "An advanced kit of medicine, bandages, and morphine.\nVery useful for keeping a group of survivors healthy.\nUse PRIMARY FIRE to heal other players.\nUse SECONDARY FIRE to heal yourself.\nHealing other players is not only faster but you get a nice point bonus!"
	SWEP.Slot = 4
	SWEP.SlotPos = 0

	SWEP.ViewModelFOV = 50
	SWEP.ViewModelFlip = false

	SWEP.BobScale = 2
	SWEP.SwayScale = 1.5

	
end

SWEP.Base = "weapon_zs_base"

SWEP.WorldModel = "models/weapons/w_medkit.mdl"
SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.UseHands = true

SWEP.Primary.Delay = 10
SWEP.Primary.Heal = 15

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Ammo = "Battery"

SWEP.Secondary.Delay = 20
SWEP.Secondary.Heal = 10

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.NoMagazine = true

SWEP.HoldType = "slam"

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetDeploySpeed(1.1)
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local owner = self.Owner

	owner:LagCompensation(true)
	local ent = owner:MeleeTrace(32, 2).Entity
	owner:LagCompensation(false)

	if ent and ent:IsValid() and ent:IsPlayer() and ent:Team() == owner:Team() and ent:Alive() and gamemode.Call("PlayerCanBeHealed", ent) then
		local health, maxhealth = ent:Health(), ent:GetMaxHealth()
		local multiplier = owner.HumanHealMultiplier or 1
		local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Primary.Heal * multiplier, maxhealth - health)))
		local totake = math.ceil(toheal / multiplier)
		if toheal > 0 then
			self:SetNextCharge(CurTime() + self.Primary.Delay * math.min(1, toheal / self.Primary.Heal))
			owner.NextMedKitUse = self:GetNextCharge()

			self:TakeCombinedPrimaryAmmo(totake)

			ent:SetHealth(health + toheal)
			self:EmitSound("items/medshot4.wav")
			self:EmitSound("items/smallmedkit1.wav")

			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

			owner:DoAttackEvent()
			self.IdleAnimation = CurTime() + self:SequenceDuration()

			gamemode.Call("PlayerHealedTeamMember", owner, ent, toheal, self)
		end
	end
end

function SWEP:SecondaryAttack()
	local owner = self.Owner
	if not self:CanPrimaryAttack() or not gamemode.Call("PlayerCanBeHealed", owner) then return end

	local health, maxhealth = owner:Health(), owner:GetMaxHealth()
	local multiplier = owner.HumanHealMultiplier or 1
	local toheal = math.min(self:GetPrimaryAmmoCount(), math.ceil(math.min(self.Secondary.Heal * multiplier, maxhealth - health)))
	local totake = math.ceil(toheal / multiplier)
	if toheal > 0 then
		self:SetNextCharge(CurTime() + self.Secondary.Delay * math.min(1, toheal / self.Secondary.Heal))
		owner.NextMedKitUse = self:GetNextCharge()

		self:TakeCombinedPrimaryAmmo(totake)

		owner:SetHealth(health + toheal)
		self:EmitSound("items/smallmedkit1.wav")
		self:EmitSound("items/smallmedkit1.wav")

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		owner:DoAttackEvent()
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

--[[function SWEP:Initialize()
	if CLIENT and self:GetOwner() == LocalPlayer() and LocalPlayer():GetActiveWeapon() == self then
		hook.Add("PostPlayerDraw", "PostPlayerDrawMedical", GAMEMODE.PostPlayerDrawMedical)
	end
end]]

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if CLIENT then
		hook.Add("PostPlayerDraw", "PostPlayerDrawMedical", GAMEMODE.PostPlayerDrawMedical)
	end

	return true
end

function SWEP:Holster()
	if CLIENT then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
	end

	return true
end

function SWEP:Reload()
end

function SWEP:SetNextCharge(tim)
	self:SetDTFloat(0, tim)
end

function SWEP:GetNextCharge()
	return self:GetDTFloat(0)
end

function SWEP:CanPrimaryAttack()
	local owner = self.Owner
	if owner:IsHolding() or owner:GetBarricadeGhosting() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:EmitSound("items/medshotno1.wav")

		self:SetNextCharge(CurTime() + 0.75)
		owner.NextMedKitUse = self:GetNextCharge()
		return false
	end

	return self:GetNextCharge() <= CurTime() and (owner.NextMedKitUse or 0) <= CurTime()
end

if not CLIENT then return end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end


function SWEP:SetNextCharge(tim)
	self:SetDTFloat(0, tim)
end

function SWEP:GetNextCharge()
	return self:GetDTFloat(0)
end

local texGradDown = surface.GetTextureID("VGUI/gradient_down")
function SWEP:DrawHUD()
	local screenscale = BetterScreenScale()
	local wid, hei = 256, 0
	local x, y = ScrW() - wid - 32, ScrH() - hei - 30
	local texty = y - 4 - draw.GetFontHeight("ZSHUDFont")

	
	local hudsplat3 = Material("hud/hud_bottom_right.png") --Items for the HUD.
	
	local Hud_Image_3 = {
		color 		= Color( 225, 225, 225, 400 ); -- Color overlay of image; white = original color of image
		material 	= Material("hud/hud_bottom_right.png"); -- Material to be used
		x 			= 1600; -- x coordinate for the material to be rendered ( mat is drawn from top left to bottom right )
		y 			= 980; -- y coordinate for the material to be rendered ( mat is drawn from top left to bottom right )
		w 			= 320; -- width of the material to span
		h 			= 100; -- height of the material to span
	};
	
	surface.SetMaterial(hudsplat3)
	surface.SetDrawColor(225, 225, 225, 200 )
	surface.DrawTexturedRect(Hud_Image_3.x, Hud_Image_3.y, Hud_Image_3.w, Hud_Image_3.h)
	

		surface.SetDrawColor(5, 5, 5, 180)
		surface.DrawRect(x, y, wid, hei)
		
	local ammo = self:GetPrimaryAmmoCount()	

	draw.SimpleText("MedKit", "ZSHUDFont2", x, texty, COLOR_GREY, TEXT_ALIGN_LEFT)
	
	draw.SimpleText(ammo, "ZSHUDFont2", x + 210, texty, COLOR_GREY, TEXT_ALIGN_LEFT)

	
	local SCREEN_W = 1920; --For the screen resolution scale. This means that it can be fit exactly on the screen without any issues.
	local SCREEN_H = 1080;
	local X_MULTIPLIER = ScrW( )  / 60 ;
	local Y_MULTIPLIER = ScrH( ) / 80 ;

--[[

	local cW, cH = ScrW() * 0.5, ScrH() * 0.5
	
	surface.SetDrawColor( Color ( 188,183,153,30 ) )
	surface.DrawLine(cW - X_MULTIPLIER, cH - 2, cW + X_MULTIPLIER, cH - 2)
	
	surface.SetDrawColor( Color ( 188,183,153,160 ) )
	surface.DrawLine(cW - X_MULTIPLIER, cH - 1, cW + X_MULTIPLIER, cH - 1)
	
	surface.SetDrawColor( Color ( 188,183,153,160 ) )
	surface.DrawLine(cW - X_MULTIPLIER, cH - 0, cW + X_MULTIPLIER, cH - 0)
	
	surface.SetDrawColor( Color ( 188,183,153,30 ) )
	surface.DrawLine(cW - X_MULTIPLIER, cH + 1, cW + X_MULTIPLIER, cH + 1)

	
	surface.SetDrawColor( Color ( 188,183,153,50 ) )
	surface.DrawLine(cW - 1, cH - Y_MULTIPLIER, cW - 1, cH + Y_MULTIPLIER)
	
	surface.SetDrawColor( Color ( 188,183,153,130 ) )
	surface.DrawLine(cW - 0, cH - Y_MULTIPLIER, cW - 0, cH + Y_MULTIPLIER)
	
	surface.SetDrawColor( Color ( 188,183,153,50 ) )
	surface.DrawLine(cW + 1, cH - Y_MULTIPLIER, cW + 1, cH + Y_MULTIPLIER)]]--
end
