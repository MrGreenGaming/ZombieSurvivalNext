include("shared.lua")

SWEP.PrintName = "Nailing Hammer"
SWEP.Description = "A simple but extremely useful tool. Allows you to hammer in nails to make barricades.\nPress SECONDARY FIRE to hammer in nail. It will be attached to whatever is behind it.\nPress RELOAD to take a nail out.\nUse PRIMARY FIRE to bash zombie brains or to repair damaged nails.\nYou get a point bonus for repairing damaged nails but a point penalty for removing another player's nails."

SWEP.DrawAmmo = false

function SWEP:DrawHUD()
	if GetGlobalBool("classicmode") then return end

	local hudsplat3 = Material("hud/hud_bottom_right.png") --Items for the HUD.
	
	local w, h = ScrW(), ScrH()
	
	surface.SetMaterial(hudsplat3)
	surface.SetDrawColor(225, 225, 225, 200 )
	surface.DrawTexturedRect(w * 0.84, h * 0.89, w * 0.15, h * 0.1)
	
	
	surface.SetFont("ZSHUDFont")
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleText(translate.Format("nails_x",nails), "ZSHUDFont2", ScrW() - nTEXW * 0.4 - 80, ScrH() - nTEXH * 2.5, nails > 0 and COLOR_GREY or COLOR_GREY, TEXT_ALIGN_CENTER)
	
	
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

	
	
	--if GetConVarNumber("crosshair") ~= 1 then return end
	--self:DrawCrosshairDot()
end
