include("shared.lua")

SWEP.PrintName = "'Aegis' Barricade Kit"
SWEP.Description = "A ready-to-go, all-in-one board deployer.\nIt automatically deploys the board and then firmly attaches it to almost any surface.\nUse PRIMARY FIRE to deploy boards.\nUse SECONADRY FIRE and RELOAD to rotate the board.\nA ghost of the board shows you if placement is valid or not."
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false

SWEP.Slot = 4
SWEP.SlotPos = 0


function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
	
	local hudsplat3 = Material("hud/hud_bottom_right.png") --Items for the HUD.
	
	local w, h = ScrW(), ScrH()
	
	surface.SetMaterial(hudsplat3)
	surface.SetDrawColor(225, 225, 225, 200 )
	surface.DrawTexturedRect(w * 0.84, h * 0.89, w * 0.15, h * 0.1)
	
	
	surface.SetFont("ZSHUDFont")
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleText("Aegis", "ZSHUDFont2", ScrW() - nTEXW * 0.2 - 150, ScrH() - nTEXH * 3.1, COLOR_GREY, TEXT_ALIGN_CENTER)
	draw.SimpleText("Kit", "ZSHUDFont2", ScrW() - nTEXW * 0.4 - 70, ScrH() - nTEXH * 2,  COLOR_GREY, TEXT_ALIGN_CENTER)
	
	draw.SimpleText(nails, "ZSHUDFontBig", ScrW() - nTEXW * 0.16, ScrH() - nTEXH * 3.1, COLOR_GREY, TEXT_ALIGN_RIGHT)
	
end

function SWEP:Deploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:GetViewModelPosition(pos, ang)
	return pos, ang
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:PrimaryAttack()
end

function SWEP:Think()
	if self.Owner:KeyDown(IN_ATTACK2) then
		self:RotateGhost(FrameTime() * 60)
	end
	if self.Owner:KeyDown(IN_RELOAD) then
		self:RotateGhost(FrameTime() * -60)
	end
end

local nextclick = 0
local kityaw = CreateClientConVar("zs_barricadekityaw", 90, false, true)
function SWEP:RotateGhost(amount)
	if nextclick <= RealTime() then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = RealTime() + 0.3
	end
	RunConsoleCommand("zs_barricadekityaw", math.NormalizeAngle(kityaw:GetFloat() + amount))
end
