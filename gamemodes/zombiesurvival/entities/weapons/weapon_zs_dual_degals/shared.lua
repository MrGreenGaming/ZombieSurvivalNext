--/*---------------------------------
--Created with buu342s Swep Creator
---------------------------------*/
--Duby: Created by Old Bill and payed for by Duby for Mr.Green ZS. 
--Duby: If you're going to take this weapon, then you need to give credit to myself and OldBill for our time and money. 
--Thanks, Duby 
 
SWEP.PrintName = "Dual Deagles"
   
SWEP.Author = "Old Bill"
SWEP.Contact = "oldbillandmedic@gmail.com"
SWEP.Purpose = "Kill m8s"
SWEP.Instructions = "Find out yourself"
 
SWEP.Category = "Dual Weapons"
 
SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false
SWEP.DrawCrosshair = false
  
SWEP.ViewModelFOV = 35
SWEP.ViewModel = "models/weapons/dual_deagles.mdl"
SWEP.WorldModel = "models/oldbill/w_dual_deagles.mdl"
SWEP.ViewModelFlip = false
 
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
 
SWEP.Slot = 2
SWEP.SlotPos = 1
 
SWEP.UseHands = true
 
SWEP.HoldType = "Pistol"
 
SWEP.FiresUnderwater = false

 
SWEP.DrawAmmo = true
 
SWEP.ReloadSound = "weapons/deagle/deagle_reload_1.wav"
 
 
if ( CLIENT ) then
    SWEP.Slot               = 3
    SWEP.SlotPos            = 1
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/dualdeagles")
    killicon.Add("Dual Deagles", "vgui/entities/dualdeagles", Color( 255, 0, 0, 255 ) )
end
 
 
SWEP.Base = "weapon_zs_base"
 
SWEP.HoldType = "duel"
 
 SWEP.Offset = {
Pos = {
Up = -1,
Right = -5.5,
Forward = 2,
},
Ang = {
Up = 0,
Right = 0,
Forward = 0,
}
}
 
function SWEP:DrawWorldModel( )
local hand, offset, rotate
 
if not IsValid( self.Owner ) then
self:SetRenderOrigin(self:GetNetworkOrigin())
self:SetRenderAngles(self:GetNetworkAngles())
self:DrawModel( )
return
end
 
if not self.Hand then
self.Hand = self.Owner:LookupAttachment( "anim_attachment_rh" )
end
 
hand = self.Owner:GetAttachment( self.Hand )
 
if not hand then
self:DrawModel( )
return
end
 
offset = hand.Ang:Right( ) * self.Offset.Pos.Right + hand.Ang:Forward( ) * self.Offset.Pos.Forward + hand.Ang:Up( ) * self.Offset.Pos.Up
 
hand.Ang:RotateAroundAxis( hand.Ang:Right( ), self.Offset.Ang.Right )
hand.Ang:RotateAroundAxis( hand.Ang:Forward( ), self.Offset.Ang.Forward )
hand.Ang:RotateAroundAxis( hand.Ang:Up( ), self.Offset.Ang.Up )
 
self:SetRenderOrigin( hand.Pos + offset )
self:SetRenderAngles( hand.Ang )
 
self:DrawModel( )
end
 
 
SWEP.Primary.Sound = Sound("weapons/deagle/deagle-1.wav")
SWEP.Primary.Damage = 70
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 14
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.6
SWEP.Primary.Delay = 0.3
SWEP.Primary.Force = 0
 
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
 
SWEP.ShootAnimation = 0
 
SWEP.CSMuzzleFlashes = true
 
SWEP.ConeMax = 0.09
SWEP.ConeMin = 0.05
 
function SWEP:Initialize()
util.PrecacheSound(self.Primary.Sound)
util.PrecacheSound(self.ReloadSound)
        self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
 
if ( !self:CanPrimaryAttack() ) then return end
 
local bullet = {}
bullet.Num = self.Primary.NumberofShots
bullet.Src = self.Owner:GetShootPos()
bullet.Dir = self.Owner:GetAimVector()
bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
bullet.Tracer = 0
bullet.Force = self.Primary.Force
bullet.Damage = self.Primary.Damage
bullet.AmmoType = self.Primary.Ammo
 
local rnda = self.Primary.Recoil * -1
local rndb = self.Primary.Recoil * math.random(-1, 1)
 
if self.ShootAnimation == 0 then
self.ShootAnimation = 1
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
else
self.ShootAnimation = 0
self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
end
self.Owner:MuzzleFlash()
self.Owner:SetAnimation( PLAYER_ATTACK1 )
 
self.Owner:FireBullets( bullet )
self:EmitSound(Sound(self.Primary.Sound))
self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
self:TakePrimaryAmmo(self.Primary.TakeAmmo)
 
self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
end
 
function SWEP:Reload()
self:EmitSound(Sound(self.ReloadSound))
        self.Weapon:DefaultReload( ACT_VM_RELOAD );
end