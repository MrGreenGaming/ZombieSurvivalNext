--/*---------------------------------
--Created with buu342s Swep Creator
---------------------------------*/

--Duby: Created by Old Bill and payed for by Duby for Mr.Green ZS. 
--Duby: If you're going to take this weapon, then you need to give credit to myself and OldBill for our time and money. 
--Thanks, Duby 

SWEP.PrintName = "Dual P228"
    
SWEP.Author = "Old Bill"
SWEP.Contact = "oldbillandmedic@gmail.com"
SWEP.Purpose = ""
SWEP.Instructions = "Left mouse button shoots, Right mouse button does nothing so don't use it."

SWEP.Category = "Dual P228"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 40
SWEP.ViewModel = "models/weapons/dual_p228.mdl" 
SWEP.WorldModel = "models/oldbill/w_dualp228.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
SWEP.SlotPos = 1
 
SWEP.UseHands = true

SWEP.HoldType = "Duel" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = true

SWEP.DrawAmmo = true

SWEP.ReloadSound = "weapon/p228/p228_clipin.wav"

SWEP.Base = "weapon_zs_base"
if ( CLIENT ) then

    SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/p228")
    killicon.Add("p228", "vgui/entities/p228", Color( 255, 0, 0, 255 ) )
end

 SWEP.Offset = {
Pos = {
Up = -0.5,
Right = -4,
Forward = -2.5,
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


SWEP.Primary.Sound = Sound("weapons/p228/p228-1.wav") 
SWEP.Primary.Recoil		= 1.5
SWEP.Primary.Damage		= 16
SWEP.Primary.NumShots		= 1
--SWEP.Primary.Cone			= 0.016
--SWEP.Primary.Delay 		= 0.25

SWEP.ConeMax = 0.055
SWEP.ConeMin = 0.05

SWEP.Primary.ClipSize		= 36					
SWEP.Primary.DefaultClip	= 108					
SWEP.Primary.Automatic		= false				
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1					
SWEP.Secondary.DefaultClip	= -1					
SWEP.Secondary.Automatic	= false				
SWEP.Secondary.Ammo		= "none"

SWEP.CSMuzzleFlashes = true
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
