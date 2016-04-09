include("shared.lua")
include("animations.lua")

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60

SWEP.ViewbobIntensity = 1
SWEP.ViewbobEnabled = true

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.BlendPos = Vector(0, 0, 0)
SWEP.BlendAng = Vector(0, 0, 0)
SWEP.OldDelta = Angle(0, 0, 0)
SWEP.AngleDelta = Angle(0, 0, 0)

function SWEP:TranslateFOV(fov)
	return GAMEMODE.FOVLerp * fov
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:DrawHUD()
if ENDROUND then
	return
else	
	local SCREEN_W = 1920; --For the screen resolution scale. This means that it can be fit exactly on the screen without any issues.
	local SCREEN_H = 1080;
	local X_MULTIPLIER = ScrW( )  / 60 ;
	local Y_MULTIPLIER = ScrH( ) / 80 ;



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
	surface.DrawLine(cW + 1, cH - Y_MULTIPLIER, cW + 1, cH + Y_MULTIPLIER)
end

end

function SWEP:OnRemove()
	self:Anim_OnRemove()
end

function SWEP:ViewModelDrawn()
	self:Anim_ViewModelDrawn()
end

local reg = debug.getregistry()
local Right = reg.Angle.Right
local Up = reg.Angle.Up
local Forward = reg.Angle.Forward
local RotateAroundAxis = reg.Angle.RotateAroundAxis
local GetVelocity = reg.Entity.GetVelocity
local Length = reg.Vector.Length

local Vec0 = Vector(0, 0, 0)
local TargetPos, TargetAng, cos1, sin1, tan, ws, rs, mod, vel, FT, sin2, delta
	
local SP = game.SinglePlayer() 
local PosMod, AngMod = Vector(0, 0, 0), Vector(0, 0, 0)
local CurPosMod, CurAngMod = Vector(0, 0, 0), Vector(0, 0, 0)

function SWEP:PreDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(0)
	end
	
	CT = UnPredictedCurTime()
	vm = self.Owner:GetViewModel()
		
	EA = EyeAngles()
	FT = FrameTime()
		
	delta = Angle(EA.p, EA.y, 0) - self.OldDelta
	delta.p = math.Clamp(delta.p, -10, 10)
			
	self.OldDelta = Angle(EA.p, EA.y, 0)
	self.AngleDelta = LerpAngle(math.Clamp(FT * 10, 0, 1), self.AngleDelta, delta)
	self.AngleDelta.y = math.Clamp(self.AngleDelta.y, -10, 10)

	vel = Length(GetVelocity(self.Owner))
	ws = self.Owner:GetWalkSpeed()
		
	PosMod, AngMod = Vec0 * 1, Vec0 * 1
		
	if vel < 10 or not self.Owner:OnGround() then
		cos1, sin1 = math.cos(CT), math.sin(CT)
		tan = math.atan(cos1 * sin1, cos1 * sin1)
			
		AngMod.x = AngMod.x + tan * 1.15
		AngMod.y = AngMod.y + cos1 * 0.4
		AngMod.z = AngMod.z + tan
			
		PosMod.y = PosMod.y + tan * 0.2
	elseif vel > 10 and vel < ws * 1.2 then
		mod = 6 + ws / 130
		mul = math.Clamp(vel / ws, 0, 1)
		sin1 = math.sin(CT * mod) * mul
		cos1 = math.cos(CT * mod) * mul
		tan1 = math.tan(sin1 * cos1) * mul
			
		AngMod.x = AngMod.x + tan1
		AngMod.y = AngMod.y - cos1
		AngMod.z = AngMod.z + cos1
		PosMod.x = PosMod.x - sin1 * 0.4
		PosMod.y = PosMod.y + tan1 * 1
		PosMod.z = PosMod.z + tan1 * 0.5
	elseif (vel > ws * 1.2 and self.Owner:KeyDown(IN_SPEED)) or vel > ws * 3 then
		rs = self.Owner:GetRunSpeed()
		mod = 7 + math.Clamp(rs / 100, 0, 6)
		mul = math.Clamp(vel / rs, 0, 1)
		sin1 = math.sin(CT * mod) * mul
		cos1 = math.cos(CT * mod) * mul
		tan1 = math.tan(sin1 * cos1) * mul
		
		AngMod.x = AngMod.x + tan1 * 0.2
		AngMod.y = AngMod.y - cos1 * 1.5
		AngMod.z = AngMod.z + cos1 * 3
		PosMod.x = PosMod.x - sin1 * 1.2
		PosMod.y = PosMod.y + tan1 * 1.5
		PosMod.z = PosMod.z + tan1
	end
		
	FT = FrameTime()
		
	CurPosMod = LerpVector(FT * 10, CurPosMod, PosMod)
	CurAngMod = LerpVector(FT * 10, CurAngMod, AngMod)
end

function SWEP:PostDrawViewModel(vm)
	if self.ShowViewModel == false then
		render.SetBlend(1)
	end
end

local wm, pos, ang
local GetBonePosition = debug.getregistry().Entity.GetBonePosition
function SWEP:DrawWorldModel()
	local owner = self:GetOwner()
	if owner:IsValid() and owner.ShadowMan then return end
	
	if (self.ShowWorldModel == nil or self.ShowWorldModel) then
		if self.DrawTraditionalWorldModel then
			self:DrawModel()
		else
			wm = self.WMEnt
			
			if IsValid(wm) then
				if IsValid(owner) then
					pos, ang = GetBonePosition(owner, owner:LookupBone("ValveBiped.Bip01_R_Hand"))
					
					if pos and ang then
						RotateAroundAxis(ang, Right(ang), self.WMAng[1])
						RotateAroundAxis(ang, Up(ang), self.WMAng[2])
						RotateAroundAxis(ang, Forward(ang), self.WMAng[3])

						pos = pos + self.WMPos[1] * Right(ang) 
						pos = pos + self.WMPos[2] * Forward(ang)
						pos = pos + self.WMPos[3] * Up(ang)
						
						wm:SetRenderOrigin(pos)
						wm:SetRenderAngles(ang)
						wm:DrawModel()
					end
				else
					wm:SetRenderOrigin(self:GetPos())
					wm:SetRenderAngles(self:GetAngles())
					wm:DrawModel()
					wm:DrawShadow()
				end
			else
				self:DrawModel()
			end
		end
	end

	self:Anim_DrawWorldModel()
end

local Ang0, curang, curviewbob = Angle(0, 0, 0), Angle(0, 0, 0), Angle(0, 0, 0)	
function SWEP:CalcView(ply, pos, ang, fov)
	FT, CT = FrameTime(), CurTime()
		
	if self.ViewbobEnabled then
		ws = self.Owner:GetWalkSpeed()
		vel = Length(GetVelocity(self.Owner))
			
		if self.Owner:OnGround() and vel > ws * 0.3 then
			if vel < ws * 1.2 then
				cos1 = math.cos(CT * 15)
				cos2 = math.cos(CT * 12)
				curviewbob.p = cos1 * 0.15
				curviewbob.y = cos2 * 0.1
			else
				cos1 = math.cos(CT * 20)
				cos2 = math.cos(CT * 15)
				curviewbob.p = cos1 * 0.25
				curviewbob.y = cos2 * 0.15
			end
		else
			curviewbob = LerpAngle(FT * 10, curviewbob, Ang0)
		end
	end
		
	return pos, ang + curviewbob * self.ViewbobIntensity, fov
end

local ghostlerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	if self:IsSwinging() then
		local rot = self.SwingRotation
		local offset = self.SwingOffset

		ang = Angle(ang.pitch, ang.yaw, ang.roll) -- Copy

		local swingend = self:GetSwingEnd()
		local delta = self.SwingTime - math.Clamp(swingend - CurTime(), 0, self.SwingTime)
		local power = CosineInterpolation(0, 1, delta / self.SwingTime)

		if power >= 0.9 then
			power = (1 - power) ^ 0.4 * 2
		end

		pos = pos + offset.x * power * ang:Right() + offset.y * power * ang:Forward() + offset.z * power * ang:Up()

		ang:RotateAroundAxis(ang:Right(), rot.pitch * power)
		ang:RotateAroundAxis(ang:Up(), rot.yaw * power)
		ang:RotateAroundAxis(ang:Forward(), rot.roll * power)
	end

	if self.Owner:GetBarricadeGhosting() then
		ghostlerp = math.min(1, ghostlerp + FrameTime() * 4)
	elseif ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 5)
	end

	if ghostlerp > 0 then
		pos = pos + 3.5 * ghostlerp * ang:Up()
		ang:RotateAroundAxis(ang:Right(), -30 * ghostlerp)
	end

	RotateAroundAxis(ang, Right(ang), CurAngMod.x + self.AngleDelta.p)
	RotateAroundAxis(ang, Up(ang), CurAngMod.y + self.AngleDelta.y * 0.3)
	RotateAroundAxis(ang, Forward(ang), CurAngMod.z + self.AngleDelta.y * 0.3)

	pos = pos + (CurPosMod.x + self.AngleDelta.y * 0.1) * Right(ang)
	pos = pos + (CurPosMod.y + self.BlendPos.y) * Forward(ang)
	pos = pos + (CurPosMod.z + self.BlendPos.z - self.AngleDelta.p * 0.1) * Up(ang)
		
	return pos, ang
end
