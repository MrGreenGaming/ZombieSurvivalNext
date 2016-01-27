local PANEL = {}

function PANEL:SetModel(strModelName)
	--Duby: Removed as we are creating the HUD for this. Clean it up at a later date
end

function PANEL:AutoCam()

end

vgui.Register("DModelPanelEx", PANEL, "DModelPanel")
