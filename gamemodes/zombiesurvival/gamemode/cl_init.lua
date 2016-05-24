-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Sometimes persistent ones don't get created.
-- Sometimes persistent ones don't get created.
local dummy = CreateClientConVar("_zs_dummyconvar", 1, false, false)
local oldCreateClientConVar = CreateClientConVar
function CreateClientConVar(...)
	return oldCreateClientConVar(...) or dummy
end

include("shared.lua")
include("cl_draw.lua")
include("cl_util.lua")
include("cl_options.lua")
include("obj_player_extend_cl.lua")
include("cl_scoreboard.lua")
include("cl_targetid.lua")
include("cl_postprocess.lua")
include("client/cl_legs.lua")
include("client/cl_chatsounds.lua")
include("client/cl_splitmessage.lua")
include("client/cl_chatbox.lua")


include("vgui/dgamestate.lua")
include("vgui/dteamcounter.lua")
include("vgui/dmodelpanelex.lua")
include("vgui/dammocounter.lua")
include("vgui/dteamheading.lua")


include("vgui/dexroundedpanel.lua")
include("vgui/dexroundedframe.lua")
include("vgui/dexrotatedimage.lua")
include("vgui/dexnotificationslist.lua")
include("vgui/dexchanginglabel.lua")


include("vgui/pmainmenu.lua")
include("vgui/poptions.lua")
include("vgui/phelp.lua")
include("vgui/pclassselect.lua")
include("vgui/pweapons.lua")
include("vgui/pendboard.lua")
include("vgui/pworth.lua")
include("vgui/ppointshop.lua")
include("vgui/dpingmeter.lua")
include("vgui/dsidemenu.lua")
include("vgui/zshealtharea.lua")

include("cl_dermaskin.lua")
include("cl_deathnotice.lua")
include("cl_floatingscore.lua")
include("cl_hint.lua")


--[[MODUELS]]--


--Christmas
if CHRISTMAS then
	include("modules/christmas/snow.lua")
end

--AFK Manager
include("modules/afk/cl_afk.lua")

--News
include("modules/news/cl_news.lua")

--Dynamic walk speed
include("modules/weightspeed/sh_weightspeed.lua")

--Bone Lib
include("modules/boneanimlib_v2/cl_boneanimlib.lua")


--Admin Mod
include("modules/admin_mod/cl_admin.lua")

--Map Manager
include("modules/admin_mod/sv_pmapmanager.lua")

--Map Vote
include("modules/map_vote/cl_votemap.lua")

--Vote Mute
include("modules/vote_outcomes/cl_director_vote.lua")

--Sub Gamemodes
include("modules/sub_gamemodes/zombie_escape/cl_zombieescape.lua")
include("modules/sub_gamemodes/arena/cl_arena.lua")
--[[
--Compass
include("modules/compass/cl_compass.lua")
]]--
w, h = ScrW(), ScrH() --Global vars 

MySelf = MySelf or NULL
hook.Add("InitPostEntity", "GetLocal", function()
	MySelf = LocalPlayer()

	GAMEMODE.HookGetLocal = GAMEMODE.HookGetLocal or (function(g) end)
	gamemode.Call("HookGetLocal", MySelf)
	RunConsoleCommand("initpostentity")
end)

-- Remove when model decal crash is fixed.
function util.Decal()
end

-- Save on global lookup time.
local render = render
local surface = surface
local draw = draw
local cam = cam
local player = player
local ents = ents
local util = util
local math = math
local string = string
local bit = bit
local gamemode = gamemode
local hook = hook
local Vector = Vector
local VectorRand = VectorRand
local Angle = Angle
local AngleRand = AngleRand
local Entity = Entity
local Color = Color
local FrameTime = FrameTime
local RealTime = RealTime
local CurTime = CurTime
local SysTime = SysTime
local EyePos = EyePos
local EyeAngles = EyeAngles
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local tonumber = tonumber
local type = type
local ScrW = ScrW
local ScrH = ScrH
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_RIGHT = TEXT_ALIGN_RIGHT
local TEXT_ALIGN_TOP = TEXT_ALIGN_TOP
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM

local TEAM_HUMAN = TEAM_HUMAN
local TEAM_UNDEAD = TEAM_UNDEAD
local translate = translate

local COLOR_PURPLE = COLOR_PURPLE
local COLOR_GRAY = COLOR_GRAY
local COLOR_RED = COLOR_RED
local COLOR_DARKRED = COLOR_DARKRED
local COLOR_DARKGREEN = COLOR_DARKGREEN
local COLOR_GREEN = COLOR_GREEN
local COLOR_WHITE = COLOR_WHITE

local surface_SetFont = surface.SetFont
local surface_SetTexture = surface.SetTexture
local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_DrawTexturedRectUV = surface.DrawTexturedRectUV
local surface_PlaySound = surface.PlaySound

local draw_SimpleText = draw.SimpleText
local draw_SimpleTextBlurry = draw.SimpleTextBlurry
local draw_SimpleTextBlur = draw.SimpleTextBlur
local draw_GetFontHeight = draw.GetFontHeight

local MedicalAuraDistance = 400

GM.LifeStatsBrainsEaten = 0
GM.LifeStatsHumanDamage = 0
GM.LifeStatsBarricadeDamage = 0
GM.InputMouseX = 0
GM.InputMouseY = 0
GM.LastTimeDead = 0
GM.LastTimeAlive = 0
GM.HeartBeatTime = 0
GM.FOVLerp = 1
GM.HurtEffect = 0
GM.PrevHealth = 0
GM.SuppressArsenalTime = 0
GM.ZombieThirdPerson = false
GM.Beats = {}

GM.DeathFog = 0
GM.FogStart = 0
GM.FogEnd = 8000
GM.FogRed = 30
GM.FogGreen = 30
GM.FogBlue = 30


function GM:ClickedPlayerButton(pl, button)
end

function GM:ClickedEndBoardPlayerButton(pl, button)
end

function GM:CenterNotify(...)
	if self.CenterNotificationHUD and self.CenterNotificationHUD:Valid() then
		return self.CenterNotificationHUD:AddNotification(...)
	end
end

function GM:TopNotify(...)
	if self.TopNotificationHUD and self.TopNotificationHUD:Valid() then
		return self.TopNotificationHUD:AddNotification(...)
	end
end

function GM:_InputMouseApply(cmd, x, y, ang)
	self.InputMouseX = x
	self.InputMouseY = y

	if MySelf:KeyDown(IN_WALK) and MySelf:IsHolding() then
		RunConsoleCommand("_zs_rotateang", self.InputMouseX, self.InputMouseY)
		return true
	end
end

function GM:_GUIMousePressed(mc)
	if self.HumanMenuPanel and self.HumanMenuPanel:Valid() and self.HumanMenuPanel:IsVisible() and MySelf:KeyDown(self.MenuKey) then
		local dir = gui.ScreenToVector(gui.MousePos())
		local ent = util.TraceLine({start = MySelf:EyePos(), endpos = MySelf:EyePos() + dir * self.CraftingRange, filter = MySelf, mask = MASK_SOLID}).Entity
		if ent:IsValid() and not ent:IsPlayer() and (ent:GetMoveType() == MOVETYPE_NONE or ent:GetMoveType() == MOVETYPE_VPHYSICS) and ent:GetSolid() == SOLID_VPHYSICS then
			if mc == MOUSE_LEFT then
				if ent == self.CraftingEntity then
					self.CraftingEntity = nil
				else
					self.CraftingEntity = ent
				end
			elseif mc == MOUSE_RIGHT and self.CraftingEntity and self.CraftingEntity:IsValid() then
				RunConsoleCommand("_zs_craftcombine", self.CraftingEntity:EntIndex(), ent:EntIndex())
				self.CraftingEntity = nil
			end
		end
	end
end

function GM:TryHumanPickup(pl, entity)
end

function GM:AddExtraOptions(list, window)
end

function GM:SpawnMenuEnabled()
	return false
end

function GM:SpawnMenuOpen()
	return false
end

function GM:ContextMenuOpen()
	return false
end

function GM:HUDWeaponPickedUp(wep)
end

function GM:_HUDWeaponPickedUp(wep)
	if MySelf:Team() == TEAM_HUMAN and not wep.NoPickupNotification then
		self:Rewarded(wep:GetClass())
	end
end

function GM:HUDItemPickedUp(itemname)
end

function GM:HUDAmmoPickedUp(itemname, amount)
end

function GM:InitPostEntity()
	if not self.HealthHUD then
		self.HealthHUD = vgui.Create("ZSHealthArea")
	end

	self:LocalPlayerFound()

	self:EvaluateFilmMode()

	timer.Simple(2, function() GAMEMODE:GetFogData() end)
end

function GM:SetupWorldFog()
	if self.DeathFog == 0 then return end

	local power = self.DeathFog
	local rpower = 1 - self.DeathFog

	local fogstart = self.FogStart * rpower
	local fogend = self.FogEnd * rpower + 150 * power
	local fogr = self.FogRed * rpower
	local fogg = self.FogGreen * rpower + 40 * power
	local fogb = self.FogBlue * rpower

	render.FogMode(1)

	render.FogStart(fogstart)
	render.FogEnd(fogend)
	render.FogColor(fogr, fogg, fogb)
	render.FogMaxDensity(1)

	return true
end

function GM:SetupSkyboxFog(skyboxscale)
	if self.DeathFog == 0 then return end

	local power = self.DeathFog
	local rpower = 1 - self.DeathFog

	local fogstart = self.FogStart * rpower
	local fogend = self.FogEnd * rpower + 150 * power
	local fogr = self.FogRed * rpower
	local fogg = self.FogGreen * rpower + 40 * power
	local fogb = self.FogBlue * rpower
	local fogdensity = 1 - power * 0.1

	render.FogMode(1)

	render.FogStart(fogstart * skyboxscale)
	render.FogEnd(fogend * skyboxscale)
	render.FogColor(fogr, fogg, fogb)
	render.FogMaxDensity(1)

	return true
end

function GM:PreDrawSkyBox()
	self.DrawingInSky = true
end

local matSky = CreateMaterial("SkyOverride", "UnlitGeneric", {["$basetexture"] = "color/white", ["$vertexcolor"] = 1, ["$vertexalpha"] = 1, ["$model"] = 1})
local colSky = Color(0, 30, 0)
function GM:PostDrawSkyBox()
	self.DrawingInSky = false

	if self.DeathFog == 0 then return end

	colSky.a = self.DeathFog * 230

	cam.Start3D(EyePos(), EyeAngles())
		render.SuppressEngineLighting(true)

		render.SetMaterial(matSky)

		render.DrawQuadEasy(Vector(0, 0, 10240), Vector(0, 0, -1), 20480, 20480, colSky, 0)
		render.DrawQuadEasy(Vector(0, 10240, 0), Vector(0, -1, 0), 20480, 20480, colSky, 0)
		render.DrawQuadEasy(Vector(0, -10240, 0), Vector(0, 1, 0), 20480, 20480, colSky, 0)
		render.DrawQuadEasy(Vector(10240, 0, 0), Vector(-1, 0, 0), 20480, 20480, colSky, 0)
		render.DrawQuadEasy(Vector(-10240, 0, 0), Vector(1, 0, 0), 20480, 20480, colSky, 0)

		render.SuppressEngineLighting(false)
	cam.End3D()
end

function GM:GetFogData()
	local fogstart, fogend = render.GetFogDistances()
	local fogr, fogg, fogb = render.GetFogColor()

	self.FogStart = fogstart
	self.FogEnd = fogend
	self.FogRed = fogr
	self.FogGreen = fogg
	self.FogBlue = fogb
end

local matAura = Material("models/--Debug/--Debugwhite")
local skip = false
function GM.PostPlayerDrawMedical(pl)
	if not skip and pl:Team() == TEAM_HUMAN and pl ~= LocalPlayer() then
		local eyepos = EyePos()
		local dist = pl:NearestPoint(eyepos):Distance(eyepos)
		if dist < MedicalAuraDistance then
			local green = pl:Health() / pl:GetMaxHealth()

			pl.SkipDrawHooks = true
			skip = true

			render.SuppressEngineLighting(true)
			render.ModelMaterialOverride(matAura)
			render.SetBlend((1 - (dist / MedicalAuraDistance)) * 0.1 * (1 + math.abs(math.sin((CurTime() + pl:EntIndex()) * 4)) * 0.05))
			render.SetColorModulation(1 - green, green, 0)
				pl:DrawModel()
			render.SetColorModulation(1, 1, 1)
			render.SetBlend(1)
			render.ModelMaterialOverride()
			render.SuppressEngineLighting(false)

			skip = false
			pl.SkipDrawHooks = false
		end
	end
end

function GM:OnReloaded()
	self.BaseClass.OnReloaded(self)

	self:LocalPlayerFound()
end

-- The whole point of this is so we don't need to check if the local player is valid 1000 times a second.
function GM:LocalPlayerFound()
	self.Think = self._Think
	self.HUDShouldDraw = self._HUDShouldDraw
	self.CachedFearPower = self._CachedFearPower
	self.CalcView = self._CalcView
	self.ShouldDrawLocalPlayer = self._ShouldDrawLocalPlayer
	self.PostDrawOpaqueRenderables = self._PostDrawOpaqueRenderables
	self.PostDrawTranslucentRenderables = self._PostDrawTranslucentRenderables
	self.HUDPaint = self._HUDPaint
	self.HUDPaintBackground = self._HUDPaintBackground
	self.CreateMove = self._CreateMove
	self.PrePlayerDraw = self._PrePlayerDraw --Re-Enabled this
	self.PostPlayerDraw = self._PostPlayerDraw
	self.InputMouseApply = self._InputMouseApply
	self.GUIMousePressed = self._GUIMousePressed
	self.HUDWeaponPickedUp = self._HUDWeaponPickedUp



	if render.GetDXLevel() >= 80 then
		self.RenderScreenspaceEffects = self._RenderScreenspaceEffects
	end
end

local currentpower = 0
local spawngreen = 0
local matFearMeter = Material("zombiesurvival/fearometer")
local matNeedle = Material("zombiesurvival/fearometerneedle")
local matEyeGlow = Material("Sprites/light_glow02_add_noz")

--Duby:Lets remake this with a bar or something more interesting!

--[[function GM:DrawFearMeter(power, screenscale) 
	if currentpower < power then
		currentpower = math.min(power, currentpower + FrameTime() * (math.tan(currentpower) * 2 + 0.05))
	elseif power < currentpower then
		currentpower = math.max(power, currentpower - FrameTime() * (math.tan(currentpower) * 2 + 0.05))
	end

	local w, h = ScrW(), ScrH()
	local wid, hei = 192 * screenscale, 192 * screenscale
	local mx, my = w * 0.5 - wid * 0.5, h - hei

	surface_SetMaterial(matFearMeter)
	surface_SetDrawColor(140, 140, 140, 240)
	surface_DrawTexturedRect(mx, my, wid, hei)
	if currentpower >= 0.75 then
		local pulse = CurTime() % 3 - 1
		if pulse > 0 then
			pulse = pulse ^ 2
			local pulsesize = pulse * screenscale * 28
			surface_SetDrawColor(140, 140, 140, 120 - pulse * 120)
			surface_DrawTexturedRect(mx - pulsesize, my - pulsesize, wid + pulsesize * 2, hei + pulsesize * 2)
		end
	end

	surface_SetMaterial(matNeedle)
	surface_SetDrawColor(160, 160, 160, 225)
	local rot = math.Clamp((0.5 - currentpower) + math.sin(RealTime() * 10) * 0.01, -0.5, 0.5) * 300
	surface_DrawTexturedRectRotated(w * 0.5 - math.max(0, rot * wid * -0.0001), h - hei * 0.5 - math.abs(rot) * hei * 0.00015, wid, hei, rot)

	if MySelf:Team() == TEAM_UNDEAD then
		if self:GetDynamicSpawning() and self:ShouldUseAlternateDynamicSpawn() then
			local obs = MySelf:GetObserverTarget()
			spawngreen = math.Approach(spawngreen, self:DynamicSpawnIsValid(obs and obs:IsValid() and obs:IsPlayer() and obs:Team() == TEAM_UNDEAD and obs or MySelf) and 1 or 0, FrameTime() * 4)

			local sy = my + hei * 0.6953
			local size = wid * 0.085

			surface_SetMaterial(matEyeGlow)
			surface_SetDrawColor(220 * (1 - spawngreen), 220 * spawngreen, 0, 240)
			surface_DrawTexturedRectRotated(mx + wid * 0.459, sy, size, size, 0)
			surface_DrawTexturedRectRotated(mx + wid * 0.525, sy, size, size, 0)
		end

		if currentpower > 0 and not self.ZombieEscape then
			draw_SimpleTextBlurry(translate.Format("resist_x", math.ceil(self:GetDamageResistance(currentpower) * 100)), "ZSDamageResistance", w * 0.5, my + hei * 0.75, Color(currentpower * 200, 200 - currentpower * 200, 0, 255), TEXT_ALIGN_CENTER)
		end
	end
end]]--




function GM:GetDynamicSpawning()
	return not GetGlobalBool("DynamicSpawningDisabled", false)
end

function GM:TrackLastDeath()
	if MySelf:Alive() then
		self.LastTimeAlive = CurTime()
	else
		self.LastTimeDead = CurTime()
	end
end

function GM:IsClassicMode()
	return GetGlobalBool("classicmode", false)
end

function GM:IsBabyMode()
	return GetGlobalBool("babymode", false)
end

function GM:PostRender()
	if self.m_ZombieVision and MySelf:IsValid() and MySelf:Team() == TEAM_UNDEAD then
		local eyepos = EyePos()
		local eyedir = EyeAngles():Forward()
		local tr = util.TraceLine({start = eyepos, endpos = eyepos + eyedir * 128, mask = MASK_SOLID_BRUSHONLY})

		local dlight = DynamicLight(MySelf:EntIndex())
		if dlight then

			dlight.Pos = tr.HitPos + tr.HitNormal * 2
			dlight.r = 10
			dlight.g = 255
			dlight.b = 80
			dlight.Brightness = 3
			dlight.Size = 300
			dlight.Decay = 900
			dlight.DieTime = CurTime() + 1
		end
	end
end

local lastwarntim = -1
local NextGas = 0
function GM:_Think()
	if self:GetEscapeStage() == ESCAPESTAGE_DEATH then
		self.DeathFog = math.min(self.DeathFog + FrameTime() / 5, 1)

		if CurTime() >= NextGas then
			NextGas = CurTime() + 0.01

			local eyepos = EyePos()

			local emitter = ParticleEmitter(eyepos)

			for i=1, 3 do
				local randdir = VectorRand()
				randdir.z = math.abs(randdir.z)
				randdir:Normalize()
				local emitpos = eyepos + randdir * math.Rand(0, 1200)

				local particle = emitter:Add("particles/smokey", emitpos)
				particle:SetVelocity(randdir * math.Rand(8, 256))
				particle:SetAirResistance(16)
				particle:SetDieTime(math.Rand(2.2, 3.5))
				particle:SetStartAlpha(math.Rand(70, 90))
				particle:SetEndAlpha(0)
				particle:SetStartSize(1)
				particle:SetEndSize(math.Rand(150, 325))
				particle:SetRoll(math.Rand(0, 360))
				particle:SetRollDelta(math.Rand(-1, 1))
				particle:SetColor(0, math.Rand(20, 45), 0)
			end

			emitter:Finish()
		end
	elseif self.DeathFog > 0 then
		self.DeathFog = math.max(self.DeathFog - FrameTime() / 5, 0)
	end

	local health = MySelf:Health()
	if self.PrevHealth and health < self.PrevHealth then
		self.HurtEffect = math.min(self.HurtEffect + (self.PrevHealth - health) * 0.02, 1.5)
	elseif self.HurtEffect > 0 then
		self.HurtEffect = math.max(0, self.HurtEffect - FrameTime() * 0.65)
	end
	self.PrevHealth = health

	self:TrackLastDeath()

	local endtime = self:GetWaveActive() and self:GetWaveEnd() or self:GetWaveStart()
	if endtime ~= -1 then
		local timleft = math.max(0, endtime - CurTime())
		if timleft <= 10 and lastwarntim ~= math.ceil(timleft) then
			lastwarntim = math.ceil(timleft)
			if 0 < lastwarntim then
				surface_PlaySound("buttons/lightswitch2.wav")
			end
		end
	end

	local myteam = MySelf:Team()

	self:PlayBeats(myteam, self:CachedFearPower())

	if myteam == TEAM_HUMAN then
		local wep = MySelf:GetActiveWeapon()
		if wep:IsValid() and wep.GetIronsights and wep:GetIronsights() then
			self.FOVLerp = math.Approach(self.FOVLerp, wep.IronsightsMultiplier or 0.6, FrameTime() * 4)
		elseif self.FOVLerp ~= 1 then
			self.FOVLerp = math.Approach(self.FOVLerp, 1, FrameTime() * 5)
		end

		if MySelf:GetBarricadeGhosting() then
			MySelf:BarricadeGhostingThink()
		end
	else
		self.HeartBeatTime = self.HeartBeatTime + (6 + self:CachedFearPower() * 5) * FrameTime()

		if not MySelf:Alive() then
			self:ToggleZombieVision(false)
		end
	end

	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD then
			local tab = pl:GetZombieClassTable()
			if tab.BuildBonePositions then
				pl.WasBuildingBonePositions = true
				pl:ResetBones()
				tab.BuildBonePositions(tab, pl)
			elseif pl.WasBuildingBonePositions then
				pl.WasBuildingBonePositions = nil
				pl:ResetBones()
			end
		elseif pl.WasBuildingBonePositions then
			pl.WasBuildingBonePositions = nil
			pl:ResetBones()
		end
	end
end

function GM:ShouldPlayBeats(teamid, fear)
	return not self.RoundEnded and not self.ZombieEscape and not GetGlobalBool("beatsdisabled", false)
end

local cv_ShouldPlayMusic = CreateClientConVar("zs_playmusic", 1, true, false)
local NextBeat = 0
local LastBeatLevel = 0
function GM:PlayBeats(teamid, fear)
	if RealTime() <= NextBeat or not gamemode.Call("ShouldPlayBeats", teamid, fear) then return end

	if LASTHUMAN and cv_ShouldPlayMusic:GetBool() then


		surface.PlaySound( "mrgreen/music/lasthuman.ogg" )
		NextBeat = RealTime() + 100000
		return
	end
	
	

	if fear <= 0 or not self.BeatsEnabled then return end

	local beats = self.Beats[teamid == TEAM_HUMAN and self.BeatSetHuman or self.BeatSetZombie]
	if not beats then return end

	LastBeatLevel = math.Approach(LastBeatLevel, math.ceil(fear * 10), 3)

	local snd = beats[LastBeatLevel]
	if snd then
		MySelf:EmitSound(snd, 0, 100, self.BeatsVolume)
		NextBeat = RealTime() + (self.SoundDuration[snd] or SoundDuration(snd)) - 0.025
	end
end

local colPackUp = Color(225, 225, 225, 220)
local colPackUpNotOwner = Color(255, 255, 255, 220)
function GM:DrawPackUpBar(x, y, fraction, notowner, screenscale)
	local col = notowner and colPackUpNotOwner or colPackUp

	local maxbarwidth = 270 * screenscale
	local barheight = 11 * screenscale
	local barwidth = maxbarwidth * math.Clamp(fraction, 0, 1)
	local startx = x - maxbarwidth * 0.5

	surface_SetDrawColor(0, 0, 0, 220)
	surface_DrawRect(startx, y, maxbarwidth, barheight)
	surface_SetDrawColor(col)
	surface_DrawRect(startx + 3, y + 3, barwidth - 6, barheight - 6)
	surface_DrawOutlinedRect(startx, y, maxbarwidth, barheight)

	draw_SimpleText(notowner and CurTime() % 2 < 1 and translate.Format("requires_x_people", 4) or notowner and translate.Get("packing_others_object") or translate.Get("packing"), "ZSHUDFontSmall", x, y - draw_GetFontHeight("ZSHUDFontSmall") - 2, col, TEXT_ALIGN_CENTER)
end


function GM:HumanHUD(screenscale)

	local curtime = CurTime()
	local w, h = ScrW(), ScrH()

	local packup = MySelf.PackUp
	if packup and packup:IsValid() then
		self:DrawPackUpBar(w * 0.5, h * 0.55, 1 - packup:GetTimeRemaining() / packup:GetMaxTime(), packup:GetNotOwner(), screenscale)
	end

	if not self.RoundEnded then
	--Duby: Temp Disabled until I find a proper place..
	
		if self:GetWave() == 0 and not self:GetWaveActive() then
			local txth = draw_GetFontHeight("ZSHUDFontSmall")



			local desiredzombies = self:GetDesiredStartingZombies()



			
			draw_SimpleText("Zombie volunteers", "ZSHUDFontSmall", w * 0.07, h * 0.15 + txth, COLOR_GRAY, TEXT_ALIGN_CENTER)
			
			local y = h * 0.75 + txth * 2

			txth = draw_GetFontHeight("ZSHUDFontTiny")
			for i, pl in ipairs(self.ZombieVolunteers) do
				if pl:IsValid() then
					draw_SimpleText(pl:Name(), "ZSHUDFontSmall", w * 0.07, y * 0.25, pl == MySelf and COLOR_RED or COLOR_GRAY, TEXT_ALIGN_CENTER) 
					y = y + txth * 4.4
					
				end
			end
		end

		local drown = MySelf.status_drown
		if drown and drown:IsValid() then
			surface_SetDrawColor(0, 0, 0, 60)
			surface_DrawRect(w * 0.4, h * 0.35, w * 0.2, 12)
			surface_SetDrawColor(30, 30, 230, 180)
			surface_DrawOutlinedRect(w * 0.4, h * 0.35, w * 0.2, 12)
			surface_DrawRect(w * 0.4, h * 0.35, w * 0.2 * (1 - drown:GetDrown()), 12)
			draw_SimpleText(translate.Get("breath").." ", "ZSHUDFontSmall", w * 0.4, h * 0.35 + 6, COLOR_BLUE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end
	
end

local healthIndication = { --Find someting to do with this..
	{
		Text = "Healthy",
		Percent = 1
	}, { Text = "Injured", Percent = 0.8 }, { Text = "Wounded", Percent = 0.6 }, { Text = "Doctor!", Percent = 0.45 }, { Text = "Legless", Percent = 0.4 }, { Text = "Lifeless", Percent = 0.25 } }
table.SortByMember(healthIndication, "Percent", false)
local healthPercentageDrawn, healthStatusText = 1, healthIndication[1].Text

function GM:HumanHUD2(screenscale)

	--Duby: I will place this into a module soon enough!
	local w, h = ScrW(), ScrH()
	
	draw.RoundedBox( 12, w * 0.01, h * 0.01, w * 0.12, h * 0.09, Color(1, 1, 1, 100) ) 	
	draw.RoundedBox( 12, w * 0.01, h * 0.89, w * 0.17, h * 0.09, Color(1, 1, 1, 100) )	
	draw.RoundedBox( 12, w * 0.01, h * 0.83, w * 0.06, h * 0.05, Color(1, 1, 1, 100) )
	
	local pl = LocalPlayer()
	local SCREEN_W = 1920; 
	local SCREEN_H = 1080;
	local X_MULTIPLIER = ScrW( ) / SCREEN_W;
	local Y_MULTIPLIER = ScrH( ) / SCREEN_H;
	local sp = "SP"
	local sp2 = " " .. MySelf:GetPoints() .. ""
	local gc = "GC: "
	local gc2 = "  N/A"
	local HP = pl:Health() --Set the variable for the local players health. 
	
	draw.SimpleText("+"..HP, "ZSHUDFont4",w * 0.04, h * 0.91 , COLOR_GRAY, TEXT_ALIGN_CENTER)
	
	draw.SimpleText(sp2, "ZSHUDFontSmall",50 * X_MULTIPLIER, 910 * Y_MULTIPLIER, COLOR_GRAY, TEXT_ALIGN_CENTER)
	draw.SimpleText(sp, "ZSHUDFontSmall",95 * X_MULTIPLIER, 910 * Y_MULTIPLIER, COLOR_GRAY, TEXT_ALIGN_CENTER)
	
	local healthPoints, maxHealthPoints = math.max(MySelf:Health(),0), 100
	local healthTextX , healthTextValueY, healthTextKeyY = ScaleW(40),ScaleH(975), ScaleH(1005)
	local barW, barH = ScaleW(127), ScaleH(38)
	local barX, barY = healthTextX + ScaleW(55), ScaleH(880)+ScaleH(62)
	
	local healthPercentage, healthChanged = math.Clamp(healthPoints / maxHealthPoints, 0, 1), false
	if healthPercentage ~= healthPercentageDrawn then
		healthChanged = true
	end

	healthPercentageDrawn = math.Clamp(math.Approach(healthPercentageDrawn, healthPercentage, FrameTime() * 1.8), 0, 1) --Smooth

	--Determine health bar foreground color
	local fHealth, fMaxHealth = math.max(MySelf:Health(),0), MySelf:GetMaximumHealth()
	local iPercentage = math.Clamp(fHealth / fMaxHealth, 0, 1)
	local healthBarColor = Color(137, 30, 30, 200)
	local healthBarBGColor = Color(1, 1, 1, 1)
	
	
	--Different colors
	if iPercentage > 0.75 then
		healthBarColor = Color(255, 255, 255, 200)
		healthBarBGColor = Color(1, 1, 1, 1)	
	elseif iPercentage > 0.5 then
		healthBarColor = Color(137, 116, 24, 200)
		healthBarBGColor = Color(1, 1, 1, 1)
	end

	--Flash under certain conditions
	if healthPercentageDrawn < 0.3 then
		healthBarColor = Color(healthBarColor.r, healthBarColor.g, healthBarColor.b, math.abs( math.sin( CurTime() * 4 ) ) * 255)
	end

	--Background
	if healthPercentageDrawn ~= 1 then
		surface.SetDrawColor(healthBarBGColor)
		surface.DrawRect(barX, barY, barW, barH)
	end

	--Foreground
	surface.SetDrawColor(healthBarColor)
	surface.DrawRect(barX, barY, barW * healthPercentageDrawn, barH)

	--Only update text if health changed
	if healthChanged then
		for k, v in ipairs(healthIndication) do
			if healthPercentage >= v.Percent then
				healthStatusText = v.Text
				break
			end
		end
	end
	
	--Draw health status text
	--draw.SimpleText(healthStatusText, "ZSHUDFont1.1", barX+(barW/2), barY+(barH/2), Color(250,250,250,170), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

function GM:ZombieHUD2(screenscale)

	--Duby: I will place this into a module soon enough!
	local hudsplat = Material("hud/z_hud_2.png") --Items for the HUD.
	local hudsplat2 = Material("hud/z_hud_2.png") --Items for the HUD.

	
	local SCREEN_W = 1920; --Remove this and add the other system soon..
	local SCREEN_H = 1080;
	local X_MULTIPLIER = ScrW( ) / SCREEN_W;
	local Y_MULTIPLIER = ScrH( ) / SCREEN_H;
	
	local pl = LocalPlayer()
	local w, h = ScrW(), ScrH()
	local HP = pl:Health() --Set the variable for the local players health. 	
	
	surface.SetMaterial(hudsplat)
	surface.SetDrawColor(225, 225, 225, 225 )
	surface.DrawTexturedRect(w * -0.02, h * -0.01, w * 0.21, h * 0.14)
	
	surface.SetMaterial(hudsplat2)
	surface.SetDrawColor(225, 225, 225, 225 )
	surface.DrawTexturedRect(w * -0.03, h * 0.86, w * 0.25, h * 0.2)
	
	draw.SimpleText("+"..HP, "ZSHUDFontLargeZombie",w * 0.04, h * 0.91 , COLOR_GRAY, TEXT_ALIGN_CENTER)
	
	if MySelf:IsValid() then
		if MySelf:Team() == TEAM_UNDEAD then
			local toredeem = GAMEMODE:GetRedeemBrains()
			if toredeem > 0 then
				draw.SimpleText(translate.Format("brains_eaten_x", MySelf:Frags().." / "..toredeem), "ZSHUDFontSmallZombie", 100 * X_MULTIPLIER, 1045 * Y_MULTIPLIER, COLOR_GRAY)
			else
				draw.SimpleText(translate.Format("brains_eaten_x", MySelf:Frags()), "ZSHUDFontSmallZombie",100 * X_MULTIPLIER, 1045 * Y_MULTIPLIER, COLOR_GRAY)
			end
		end
	end
end

function GM:HUDPaint()

end

function GM:_HUDPaint()
	if self.FilmMode then return end

	local screenscale = BetterScreenScale()

	local myteam = MySelf:Team()

	self:HUDDrawTargetID(myteam, screenscale)


	--if self:GetWave() > 0 then --Duby: Enable this if you want the fear meter back!
	--	self:DrawFearMeter(self:CachedFearPower(), screenscale)
	--end
	
	if myteam == TEAM_UNDEAD then
		self:ZombieHUD()
		self:ZombieHUD2()	
	elseif myteam == TEAM_HUMAN then
		self:HumanHUD(screenscale)	
		self:HumanHUD2(screenscale)	
	end

	
	if GetGlobalBool("classicmode") then
		draw_SimpleText(translate.Get("classic_mode"), "ZSHUDFontSmaller", 4, ScrH() - 4, COLOR_GRAY, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	
	
	
end


function GM:ZombieObserverHUD(obsmode)
	local w, h = ScrW(), ScrH()
	local texh = draw_GetFontHeight("ZSHUDFontSmallZombie")

	local dyn

	if obsmode == OBS_MODE_CHASE then
		local target = MySelf:GetObserverTarget()
		if target and target:IsValid() then
			if target:IsPlayer() and target:Team() == TEAM_UNDEAD then
				draw_SimpleText(translate.Format("observing_x", target:Name(), math.max(0, target:Health())), "ZSHUDFontSmallZombie", w * 0.5, h * 0.75 - texh - 32, COLOR_DARKRED, TEXT_ALIGN_CENTER)
			end

			dyn = self:GetDynamicSpawning() and self:DynamicSpawnIsValid(target)
		end
	end

	if self:GetWaveActive() then
		draw_SimpleText(dyn and translate.Get("press_lmb_to_spawn_on_them") or translate.Get("press_lmb_to_spawn"), "ZSHUDFontSmallZombie", w * 0.5, h * 0.75, dyn and COLOR_DARKGREEN or COLOR_DARKRED, TEXT_ALIGN_CENTER)
	end

	local space = texh + 8
	draw_SimpleText(translate.Get("press_rmb_to_cycle_targets"), "ZSHUDFontSmallZombie", w * 0.5, h * 0.75 + space, COLOR_DARKRED, TEXT_ALIGN_CENTER)
	draw_SimpleText(translate.Get("press_reload_to_spawn_at_normal_point"), "ZSHUDFontSmallZombie", w * 0.5, h * 0.75 + space * 2, COLOR_DARKRED, TEXT_ALIGN_CENTER)
	draw_SimpleText(translate.Get("press_jump_to_free_roam"), "ZSHUDFontSmallZombie", w * 0.5, h * 0.75 + space * 3, COLOR_DARKRED, TEXT_ALIGN_CENTER)

	for _, ent in pairs(ents.FindByClass("prop_thrownbaby")) do
		if ent:GetSettled() then
			draw_SimpleText(translate.Format("press_walk_to_spawn_as_x", self.ZombieClasses["Gore Child"].Name), "ZSHUDFontSmallZombie", w * 0.5, h * 0.75 + space * 3, COLOR_DARKRED, TEXT_ALIGN_CENTER)
			break
		end
	end
end



local colLifeStats = Color(255, 0, 0, 255)
function GM:ZombieHUD()
	if self.LifeStatsEndTime and CurTime() < self.LifeStatsEndTime and (self.LifeStatsBarricadeDamage > 0 or self.LifeStatsHumanDamage > 0 or self.LifeStatsBrainsEaten > 0) then
		colLifeStats.a = math.Clamp((self.LifeStatsEndTime - CurTime()) / (self.LifeStatsLifeTime * 0.33), 0, 1) * 255

		local th = draw_GetFontHeight("ZSHUDFontSmallZombie")
		local x = ScrW() * 0.75
		local y = ScrH() * 0.75

		draw_SimpleText(translate.Get("that_life"), "ZSHUDFontSmallZombie", x, y, colLifeStats, TEXT_ALIGN_LEFT)
		y = y + th

		if self.LifeStatsBarricadeDamage > 0 then
			draw_SimpleText(translate.Format("x_damage_to_barricades", self.LifeStatsBarricadeDamage), "ZSHUDFontSmallZombie", x, y, colLifeStats, TEXT_ALIGN_LEFT)
			y = y + th
		end
		if self.LifeStatsHumanDamage > 0 then
			draw_SimpleText(translate.Format("x_damage_to_humans", self.LifeStatsHumanDamage), "ZSHUDFontSmallZombie", x, y, colLifeStats, TEXT_ALIGN_LEFT)
			y = y + th
		end
		if self.LifeStatsBrainsEaten > 0 then
			draw_SimpleText(translate.Format("x_brains_eaten", self.LifeStatsBrainsEaten), "ZSHUDFontSmallZombie", x, y, colLifeStats, TEXT_ALIGN_LEFT)
			y = y + th
		end
	end

	local obsmode = MySelf:GetObserverMode()
	if obsmode ~= OBS_MODE_NONE then
		self:ZombieObserverHUD(obsmode)
	elseif not self:GetWaveActive() and not MySelf:Alive() then

		draw_SimpleText(translate.Get("waiting_for_next_wave"), "ZSHUDFont", ScrW() * 0.5, ScrH() * 0.3, COLOR_DARKRED, TEXT_ALIGN_CENTER)


		if MySelf:GetZombieClassTable().NeverAlive then
			for _, ent in pairs(ents.FindByClass("prop_thrownbaby")) do
				if ent:GetSettled() then
					draw_SimpleText(translate.Format("press_walk_to_spawn_as_x", self.ZombieClasses["Gore Child"].Name), "ZSHUDFontSmallZombie", w * 0.5, h * 0.75, COLOR_DARKRED, TEXT_ALIGN_CENTER)
					break
				end
			end
		end
	end
end

function GM:RequestedDefaultCart()
	local defaultcart = GetConVarString("zs_defaultcart")
	if #defaultcart > 0 then
		defaultcart = string.lower(defaultcart)

		for i, carttab in ipairs(self.SavedCarts) do
			if carttab[1] and string.lower(carttab[1]) == defaultcart then
				gamemode.Call("SuppressArsenalUpgrades", 1)
				RunConsoleCommand("worthcheckout", unpack(carttab[2]))

				return
			end
		end

		RunConsoleCommand("worthrandom")
	end
end

function GM:_PostDrawTranslucentRenderables()
	if not self.DrawingInSky then
		self:DrawPointWorldHints()
		self:DrawWorldHints()
	end
end

function GM:RestartRound()
	self.TheLastHuman = nil
	self.RoundEnded = nil
	LASTHUMAN = nil

	if pEndBoard and pEndBoard:Valid() then
		pEndBoard:Remove()
		pEndBoard = nil
	end

	self:InitPostEntity()

	self:RevertZombieClasses()
end

function GM:_HUDShouldDraw(name)


	if self.FilmMode and name ~= "CHudWeaponSelection" then return false end

	return name ~= "CHudHealth" and name ~= "CHudBattery"
	and name ~= "CHudAmmo" and name ~= "CHudSecondaryAmmo"
	and name ~= "CHudDamageIndicator"
	

end

local Current = 0
local NextCalculate = 0
function GM:_CachedFearPower()
	if CurTime() >= NextCalculate then
		NextCalculate = CurTime() + 0.15
		Current = self:GetFearMeterPower(EyePos(), TEAM_UNDEAD, MySelf)
	end

	return Current
end

function surface.CreateLegacyFont(font, size, weight, antialias, additive, name, shadow, outline, blursize)
	surface.CreateFont(name, {font = font, size = size, weight = weight, antialias = antialias, additive = additive, shadow = shadow, outline = outline, blursize = blursize})
end

function GM:CreateFonts()
	local fontfamily = "Typenoksidi"
	local fontfamily3d = "hidden"
	local new_zs_font = "zsnew"
	local fontweight = 0
	local fontweight3D = 0
	local fontaa = true
	local fontshadow = false
	local fontoutline = true

	surface.CreateLegacyFont("csd", 42, 500, true, false, "healthsign", false, true)
	surface.CreateLegacyFont("tahoma", 96, 1000, true, false, "zshintfont", false, true)


	surface.CreateLegacyFont(fontfamily3d, 48, fontweight3D, false, false,  "ZS3D2DFontSmall", false, true)
	surface.CreateLegacyFont(fontfamily3d, 72, fontweight3D, false, false, "ZS3D2DFont", false, true)
	surface.CreateLegacyFont(fontfamily3d, 128, fontweight3D, false, false, "ZS3D2DFontBig", false, true)
	surface.CreateLegacyFont(fontfamily3d, 48, fontweight3D, false, false,  "ZS3D2DFontSmallBlur", false, false, 16)
	surface.CreateLegacyFont(fontfamily3d, 72, fontweight3D, false, false, "ZS3D2DFontBlur", false, false, 16)
	surface.CreateLegacyFont(fontfamily3d, 128, fontweight3D, false, false, "ZS3D2DFontBigBlur", false, false, 16)
	surface.CreateLegacyFont(new_zs_font, 40, fontweight3D, false, false,  "ZS3D2DFont2Smaller", false, true)
	surface.CreateLegacyFont(new_zs_font, 48, fontweight3D, false, false,  "ZS3D2DFont2Small", false, true)
	surface.CreateLegacyFont(new_zs_font, 72, fontweight3D, false, false, "ZS3D2DFont2", false, true)
	surface.CreateLegacyFont(new_zs_font, 128, fontweight3D, false, false, "ZS3D2DFont2Big", false, true)
	surface.CreateLegacyFont(new_zs_font, 40, fontweight3D, false, false,  "ZS3D2DFont2SmallerBlur", false, false, 16)
	surface.CreateLegacyFont(new_zs_font, 48, fontweight3D, false, false,  "ZS3D2DFont2SmallBlur", false, false, 16)
	surface.CreateLegacyFont(new_zs_font, 72, fontweight3D, false, false, "ZS3D2DFont2Blur", false, false, 16)
	surface.CreateLegacyFont(new_zs_font, 128, fontweight3D, false, false, "ZS3D2DFont2BigBlur", false, false, 16)

	local screenscale = BetterScreenScale()

	surface.CreateLegacyFont("csd", screenscale * 36, 100, true, false, "zsdeathnoticecs", false, true)
	surface.CreateLegacyFont("HL2MP", screenscale * 36, 100, true, false, "zsdeathnotice", false, true)
	surface.CreateLegacyFont("ZS New",screenscale * 40, 110, true, false, "zsdeathnotice2", false, true)
	
	surface.CreateLegacyFont("FaceYourFears", screenscale * 28, fontweight, fontaa, false, "ZSHUDFontSmallZombie", fontshadow, fontoutline)
	surface.CreateLegacyFont("FaceYourFears", screenscale * 72, fontweight, fontaa, false, "ZSHUDFontLargeZombie", fontshadow, fontoutline)

	
	
	surface.CreateLegacyFont(new_zs_font, screenscale * 16, fontweight, fontaa, false, "ZSHUDFontTiny", fontshadow, fontoutline)
	surface.CreateLegacyFont(new_zs_font, screenscale * 20, fontweight, fontaa, false, "ZSHUDFontSmallest", fontshadow, fontoutline)
	surface.CreateLegacyFont(new_zs_font, screenscale * 22, fontweight, fontaa, false, "ZSHUDFontSmaller", fontshadow, fontoutline)
	surface.CreateLegacyFont(new_zs_font, screenscale * 28, fontweight, fontaa, false, "ZSHUDFontSmall", fontshadow, fontoutline)
	surface.CreateLegacyFont(new_zs_font, screenscale * 32, fontweight, fontaa, false, "ZSHUDFont", false, false)
	surface.CreateLegacyFont(new_zs_font, screenscale * 39, fontweight, fontaa, false, "ZSHUDFont1.1", false, false)
	surface.CreateLegacyFont(new_zs_font, screenscale * 42, fontweight, fontaa, false, "ZSHUDFont2", false, false)
	surface.CreateLegacyFont(new_zs_font, screenscale * 65, fontweight, fontaa, false, "ZSHUDFont3", false, false)
	surface.CreateLegacyFont(new_zs_font, screenscale * 55, fontweight, fontaa, false, "ZSHUDFont4", false, false, fontshadow, fontoutline)
	surface.CreateLegacyFont(new_zs_font, screenscale * 72, fontweight, fontaa, false, "ZSHUDFontBig", fontshadow, fontoutline)
	surface.CreateLegacyFont(new_zs_font, screenscale * 16, fontweight, fontaa, false, "ZSHUDFontTinyBlur", false, false, 8)
	surface.CreateLegacyFont(new_zs_font, screenscale * 22, fontweight, fontaa, false, "ZSHUDFontSmallerBlur", false, false, 8)
	surface.CreateLegacyFont(new_zs_font, screenscale * 28, fontweight, fontaa, false, "ZSHUDFontSmallBlur", false, false, 8)
	surface.CreateLegacyFont(new_zs_font, screenscale * 42, fontweight, fontaa, false, "ZSHUDFontBlur", false, false, 8)
	surface.CreateLegacyFont(new_zs_font, screenscale * 72, fontweight, fontaa, false, "ZSHUDFontBigBlur", false, false, 8)

	surface.CreateLegacyFont(new_zs_font, screenscale * 16, 0, fontaa, false, "ZSAmmoName", false, false)
	surface.CreateLegacyFont(new_zs_font, screenscale * 16, fontweight, fontaa, false, "ZSHUDFontTinyNS", false, false)
	surface.CreateLegacyFont(new_zs_font, screenscale * 20, fontweight, fontaa, false, "ZSHUDFontSmallestNS", false, false)
	surface.CreateLegacyFont(new_zs_font, screenscale * 22, fontweight, fontaa, false, "ZSHUDFontSmallerNS", false, false)
	surface.CreateLegacyFont(new_zs_font, screenscale * 28, fontweight, fontaa, false, "ZSHUDFontSmallNS", false, false)
	surface.CreateLegacyFont(new_zs_font, screenscale * 42, fontweight, fontaa, false, "ZSHUDFontNS", false, false)
	surface.CreateLegacyFont(new_zs_font, screenscale * 72, fontweight, fontaa, false, "ZSHUDFontBigNS", false, false)

	surface.CreateLegacyFont(new_zs_font, screenscale * 16, 0, true, false, "ZSDamageResistance", false, true)
	surface.CreateLegacyFont(new_zs_font, screenscale * 16, 0, true, false, "ZSDamageResistanceBlur", false, true)

	surface.CreateLegacyFont(new_zs_font, 32, fontweight, true, false, "ZSScoreBoardTitle", false, true)
	surface.CreateLegacyFont(new_zs_font, 22, fontweight, true, false, "ZSScoreBoardSubTitle", false, true)
	surface.CreateLegacyFont(new_zs_font, 16, fontweight, true, false, "ZSScoreBoardPlayer", false, true)
	surface.CreateLegacyFont(new_zs_font, 24, fontweight, true, false, "ZSScoreBoardHeading", false, false)
	surface.CreateLegacyFont("arial", 20, 0, true, false, "ZSScoreBoardPlayerSmall", false, true)

	-- Default, DefaultBold, DefaultSmall, etc. were changed when gmod13 hit. These are renamed fonts that have the old values.
	surface.CreateFont("DefaultFontVerySmall", {font = "tahoma", size = 10, weight = 0, antialias = false})
	surface.CreateFont("DefaultFontSmall", {font = "tahoma", size = 11, weight = 0, antialias = false})
	surface.CreateFont("DefaultFontSmallDropShadow", {font = "tahoma", size = 11, weight = 0, shadow = true, antialias = false})
	surface.CreateFont("DefaultFont", {font = "tahoma", size = 13, weight = 500, antialias = false})
	surface.CreateFont("DefaultFontBold", {font = "tahoma", size = 13, weight = 1000, antialias = false})
	surface.CreateFont("DefaultFontLarge", {font = "tahoma", size = 16, weight = 0, antialias = false})
	
	

	surface.CreateLegacyFont(CloseCaption_Normal, screenscale * 28, fontweight, false, false, "ZSHUDFontSmalldebug", false, false)


end

function GM:EvaluateFilmMode()
	local visible = not self.FilmMode

	if self.GameStatePanel and self.GameStatePanel:Valid() then
		self.GameStatePanel:SetVisible(visible)
	end

	if self.TopNotificationHUD and self.TopNotificationHUD:Valid() then
		self.TopNotificationHUD:SetVisible(visible)
	end

	if self.CenterNotificationHUD and self.CenterNotificationHUD:Valid() then
		self.CenterNotificationHUD:SetVisible(visible)
	end

	if self.HealthHUD and self.HealthHUD:Valid() then
		self.HealthHUD:SetVisible(visible)
	end
end


function GM:CreateVGUI()
	local screenscale = BetterScreenScale()
	self.GameStatePanel = vgui.Create("DGameState")
	self.GameStatePanel:SetTextFont("ZSHUDFontSmaller")
	self.GameStatePanel:SetAlpha(220)
	self.GameStatePanel:SetSize(screenscale * 420, screenscale * 90)
	self.GameStatePanel:ParentToHUD()

	self.TopNotificationHUD = vgui.Create("DEXNotificationsList")
	self.TopNotificationHUD:SetAlign(RIGHT)
	self.TopNotificationHUD.PerformLayout = function(pan)
		local screenscale = BetterScreenScale()
		pan:SetSize(ScrW() * 0.4, ScrH() * 0.6)
		pan:AlignTop(16 * screenscale)
		pan:AlignRight()
	end
	self.TopNotificationHUD:InvalidateLayout()
	self.TopNotificationHUD:ParentToHUD()

	self.CenterNotificationHUD = vgui.Create("DEXNotificationsList")
	self.CenterNotificationHUD:SetAlign(CENTER)
	self.CenterNotificationHUD:SetMessageHeight(39)
	self.CenterNotificationHUD.PerformLayout = function(pan)
		local screenscale = BetterScreenScale()
		pan:SetSize(ScrW() * 0.5, ScrH() * 0.35)
		pan:CenterHorizontal()
		pan:AlignBottom(16 * screenscale)
	end
	self.CenterNotificationHUD:InvalidateLayout()
	self.CenterNotificationHUD:ParentToHUD()
end

function GM:Initialize()
	self:CreateFonts()
	self:PrecacheResources()
	self:CreateVGUI()
	self:InitializeBeats()
	self:AddCustomAmmo()
end

local function FirstOfGoodType(a)
	for _, v in pairs(a) do
		local ext = string.sub(v, -4)
		if ext == ".ogg" or ext == ".wav" or ext == ".mp3" then
			return v
		end
	end
end

function GM:InitializeBeats()
	local _, dirs = file.Find("sound/zombiesurvival/beats/*", "GAME")
	for _, dirname in pairs(dirs) do
		if dirname == "none" or dirname == "default" then continue end

		self.Beats[dirname] = {}
		local highestexist
		for i=1, 10 do
			local a, __ = file.Find("sound/zombiesurvival/beats/"..dirname.."/"..i..".*", "GAME")
			local a1 = FirstOfGoodType(a)
			if a1 then
				local filename = "zombiesurvival/beats/"..dirname.."/"..a1
				if file.Exists("sound/"..filename, "GAME") then
					self.Beats[dirname][i] = Sound(filename)
					highestexist = filename

					continue
				end
			end

			if highestexist then
				self.Beats[dirname][i] = highestexist
			end
		end
	end
end

function GM:PlayerDeath(pl, attacker)
end

function GM:OnPlayerHitGround(pl, inwater, hitfloater, speed)
	if inwater then return true end

	if pl:Team() == TEAM_UNDEAD then
		if pl:GetZombieClassTable().NoFallDamage then return true end

		speed = math.max(0, speed - 200)
	end

	if pl:Team() ~= TEAM_UNDEAD or not pl:GetZombieClassTable().NoFallSlowdown then
		pl:RawCapLegDamage(CurTime() + math.min(2, speed * 0.0035))
	end

	return true
end

function GM:LastHuman(pl)
	if not IsValid(pl) then pl = nil end

	self.TheLastHuman = pl

	if not LASTHUMAN then
		LASTHUMAN = true
		timer.Simple(0.5, function() GAMEMODE:LastHumanMessage() end)
	end
end

function GM:LastHumanMessage()
	if self.RoundEnded or not MySelf:IsValid() then return end

	local icon = self.PantsMode and "weapon_zs_legs" or "default"
	if MySelf:Team() == TEAM_UNDEAD or not MySelf:Alive() then
		GAMEMODE:Add3DMessage(100, translate.Get(self.PantsMode and "kick_the_last_human" or "kill_the_last_human"), nil, "ZSHUDFont2")
	else
		GAMEMODE:Add3DMessage(100, translate.Get("you_are_the_last_human"), nil, "ZSHUDFont2")
		GAMEMODE:Add3DMessage(100, translate.Get(self.PantsMode and "x_pants_out_to_get_you" or "x_zombies_out_to_get_you", team.NumPlayers(TEAM_UNDEAD)), nil, "ZSHUDFont2")
	end
end

function GM:PlayerShouldTakeDamage(pl, attacker)
	return pl == attacker or not attacker:IsPlayer() or pl:Team() ~= attacker:Team() or pl.AllowTeamDamage or attacker.AllowTeamDamage
end

function GM:SetWave(wave)
	SetGlobalInt("wave", wave)
end

local matFilmGrain = Material("zombiesurvival/filmgrain/filmgrain")

function GM:_HUDPaintBackground()

	if self.FilmGrainEnabled and MySelf:Team() == TEAM_HUMAN then
		surface_SetMaterial(matFilmGrain)
		surface_SetDrawColor(0, 0, 0, (0.25 + 0.75 * self:CachedFearPower()) * self.FilmGrainOpacity)
		surface_DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 2, 2, 0, 0)
	end

	local wep = MySelf:GetActiveWeapon()
	if wep:IsValid() and wep.DrawHUDBackground then
		wep:DrawHUDBackground()
	end
end


local function GiveWeapon()
	RunConsoleCommand("zsgiveweapon")
end
local function GiveWeaponClip()
	RunConsoleCommand("zsgiveweaponclip")
end
local function DropWeapon()
	RunConsoleCommand("zsdropweapon")
end
local function EmptyClip()
	RunConsoleCommand("zsemptyclip")
end
function GM:HumanMenu()
	if self.ZombieEscape then return end

	local ent = MySelf:MeleeTrace(48, 2).Entity
	if self:ValidMenuLockOnTarget(MySelf, ent) then
		self.HumanMenuLockOn = ent
	else
		self.HumanMenuLockOn = nil
	end

	if self.HumanMenuPanel and self.HumanMenuPanel:Valid() then
		self.HumanMenuPanel:SetVisible(true)
		self.HumanMenuPanel:OpenMenu()
		return
	end

	local panel = vgui.Create("DSideMenu")
	self.HumanMenuPanel = panel

	local screenscale = BetterScreenScale()
	for k, v in pairs(self.AmmoNames) do
		local b = vgui.Create("DAmmoCounter", panel)
		b:SetAmmoType(k)
		b:SetTall(screenscale * 36)
		panel:AddItem(b)
	end

	local b = EasyButton(panel, "Give Weapon", 8, 4)
	b.DoClick = GiveWeapon
	panel:AddItem(b)
	b = EasyButton(panel, "Give Weapon and 5 clips", 8, 4)
	b.DoClick = GiveWeaponClip
	panel:AddItem(b)
	b = EasyButton(panel, "Drop weapon", 8, 4)
	b.DoClick = DropWeapon
	panel:AddItem(b)
	b = EasyButton(panel, "Empty clip", 8, 4)
	b.DoClick = EmptyClip
	panel:AddItem(b)

	panel:OpenMenu()
end

function GM:PlayerBindPress(pl, bind, wasin)
	if bind == "gmod_undo" or bind == "undo" then
		RunConsoleCommand("+zoom")
		timer.CreateEx("ReleaseZoom", 1, 1, RunConsoleCommand, "-zoom")
	elseif bind == "+menu_context" then
		self.ZombieThirdPerson = not self.ZombieThirdPerson
	end
end

function GM:_ShouldDrawLocalPlayer(pl)
	return pl:Team() == TEAM_UNDEAD and (self.ZombieThirdPerson or pl:CallZombieFunction("ShouldDrawLocalPlayer")) or pl:IsPlayingTaunt()
end

local roll = 0
function GM:_CalcView(pl, origin, angles, fov, znear, zfar)
	if pl.Confusion and pl.Confusion:IsValid() then
		pl.Confusion:CalcView(pl, origin, angles, fov, znear, zfar)
	end

	if pl.Revive and pl.Revive:IsValid() and pl.Revive.GetRagdollEyes then
		local rpos, rang = pl.Revive:GetRagdollEyes(pl)
		if rpos then
			origin = rpos
			angles = rang
		end
	elseif pl.KnockedDown and pl.KnockedDown:IsValid() then
		local rpos, rang = self:GetRagdollEyes(pl)
		if rpos then
			origin = rpos
			angles = rang
		end
	elseif pl:ShouldDrawLocalPlayer() and pl:OldAlive() then
		origin = pl:GetThirdPersonCameraPos(origin, angles)
	end

	local targetroll = 0
	if self.MovementViewRoll then
		local dir = pl:GetVelocity()
		local speed = dir:Length()
		dir:Normalize()

		targetroll = targetroll + dir:Dot(angles:Right()) * math.min(30, speed / 100)
	end

	if pl:WaterLevel() >= 3 then
		targetroll = targetroll + math.sin(CurTime()) * 7
	end

	roll = math.Approach(roll, targetroll, math.max(0.25, math.sqrt(math.abs(roll))) * 30 * FrameTime())
	angles.roll = angles.roll + roll

	if pl:IsPlayingTaunt() then
		self:CalcViewTaunt(pl, origin, angles, fov, zclose, zfar)
	end

	local target = pl:GetObserverTarget()
	if target and target:IsValid() then
		local lasttarget = self.LastObserverTarget
		if lasttarget and lasttarget:IsValid() and target ~= lasttarget then
			if self.LastObserverTargetLerp then
				if CurTime() >= self.LastObserverTargetLerp then
					self.LastObserverTarget = nil
					self.LastObserverTargetLerp = nil
				else
					local delta = math.Clamp((self.LastObserverTargetLerp - CurTime()) / 0.3333, 0, 1) ^ 0.5
					origin:Set(self.LastObserverTargetPos * delta + origin * (1 - delta))
				end
			else
				self.LastObserverTargetLerp = CurTime() + 0.3333
			end
		else
			self.LastObserverTarget = target
			self.LastObserverTargetPos = origin
		end
	end

	pl:CallZombieFunction("CalcView", origin, angles)

	return self.BaseClass.CalcView(self, pl, origin, angles, fov, znear, zfar)
end

function GM:CalcViewTaunt(pl, origin, angles, fov, zclose, zfar)
	local tr = util.TraceHull({start = origin, endpos = origin - angles:Forward() * 72, mins = Vector(-2, -2, -2), maxs = Vector(2, 2, 2), mask = MASK_OPAQUE, filter = pl})
	origin:Set(tr.HitPos + tr.HitNormal * 2)
end

local staggerdir = VectorRand():GetNormalized()
local BHopTime = 0
local WasPressingJump = false

local function PressingJump(cmd)
	return bit.band(cmd:GetButtons(), IN_JUMP) ~= 0
end

local function DontPressJump(cmd)
	cmd:SetButtons(cmd:GetButtons() - IN_JUMP)
end

function GM:_CreateMove(cmd)  --Note: Test this!


	if MySelf:IsPlayingTaunt() and MySelf:Alive() then
		self:CreateMoveTaunt(cmd)
		return
	end

	-- Disables bunny hopping to an extent.
	if MySelf:GetLegDamage() >= 0.5 then
		if PressingJump(cmd) then
			DontPressJump(cmd)
		end
	elseif MySelf:OnGround() then
		if CurTime() < BHopTime then
			if PressingJump(cmd) then
				DontPressJump(cmd)
				WasPressingJump = true
			end
		elseif WasPressingJump then
			if PressingJump(cmd) then
				DontPressJump(cmd)
			else
				WasPressingJump = false
			end
		end
	else
		BHopTime = CurTime() + 0.05
	end

	local myteam = MySelf:Team()
	if myteam == TEAM_HUMAN then
		if MySelf:Alive() then
			local lockon = self.HumanMenuLockOn
			if lockon then
				if self:ValidMenuLockOnTarget(MySelf, lockon) and self.HumanMenuPanel and self.HumanMenuPanel:Valid() and self.HumanMenuPanel:IsVisible() and MySelf:KeyDown(self.MenuKey) then
					local oldang = cmd:GetViewAngles()
					local newang = (lockon:EyePos() - EyePos()):Angle()
					--oldang.pitch = math.ApproachAngle(oldang.pitch, newang.pitch, FrameTime() * math.max(45, math.abs(math.AngleDifference(oldang.pitch, newang.pitch)) ^ 1.3))
					oldang.yaw = math.ApproachAngle(oldang.yaw, newang.yaw, FrameTime() * math.max(45, math.abs(math.AngleDifference(oldang.yaw, newang.yaw)) ^ 1.3))
					cmd:SetViewAngles(oldang)
				else
					self.HumanMenuLockOn = nil
				end
			else
				local maxhealth = MySelf:GetMaxHealth()
				local threshold = MySelf:GetPalsy() and maxhealth - 1 or maxhealth * 0.25
				local health = MySelf:Health()
				if health <= threshold then
					local ft = FrameTime()

					staggerdir = (staggerdir + ft * 8 * VectorRand()):GetNormalized()

					local ang = cmd:GetViewAngles()
					local rate = ft * ((threshold - health) / threshold) * 7
					ang.pitch = math.NormalizeAngle(ang.pitch + staggerdir.z * rate)
					ang.yaw = math.NormalizeAngle(ang.yaw + staggerdir.x * rate)
					cmd:SetViewAngles(ang)
				end
			end
		end
	elseif myteam == TEAM_UNDEAD then
		local buttons = cmd:GetButtons()
		if bit.band(buttons, IN_ZOOM) ~= 0 then
			cmd:SetButtons(buttons - IN_ZOOM)
		end

		MySelf:CallZombieFunction("CreateMove", cmd)
	end

end

function GM:CreateMoveTaunt(cmd)
	cmd:ClearButtons(0)
	cmd:ClearMovement()
end

function GM:PostProcessPermitted(str)
	return false
end

function GM:HUDPaintEndRound()
end

function GM:PreDrawViewModel(vm, pl, wep)
	if pl and pl:IsValid() and pl:IsHolding() then return true end

	if wep and wep:IsValid() and wep.PreDrawViewModel then
		return wep:PreDrawViewModel(vm)
	end
end

function GM:PostDrawViewModel(vm, pl, wep)
	if wep and wep:IsValid() then
		if wep.UseHands or not wep:IsScripted() then
			local hands = pl:GetHands()
			if hands and hands:IsValid() then
				hands:DrawModel()
			end
		end

		if wep.PostDrawViewModel then
			wep:PostDrawViewModel(vm)
		end
	end
end

local undomodelblend = false
local undozombievision = false
local matWhite = Material("models/Debug/Debugwhite")
function GM:_PrePlayerDraw(pl)
	if pl:CallZombieFunction("PrePlayerDraw") then return true end

	local shadowman = false

	if pl.status_overridemodel and pl.status_overridemodel:IsValid() and self:ShouldDrawLocalPlayer(MySelf) then -- We need to do this otherwise the player's real model shows up for some reason.
		undomodelblend = true
		render.SetBlend(0)

	end

	pl.ShadowMan = shadowman

	if self.m_ZombieVision and MySelf:Team() == TEAM_UNDEAD and pl:Team() == TEAM_HUMAN and pl:GetPos():Distance(EyePos()) <= pl:GetAuraRange() then
		undozombievision = true

		local green = math.Clamp(pl:Health() / pl:GetMaxHealth(), 0, 1)
		render.ModelMaterialOverride(matWhite)
		render.SetColorModulation(1 - green, green, 0)
		render.SuppressEngineLighting(true)
		cam.IgnoreZ(true)
	end
end

local colFriend = Color(10, 255, 10, 60)
local matFriendRing = Material("SGM/playercircle")
function GM:_PostPlayerDraw(pl)
	pl:CallZombieFunction("PostPlayerDraw")

	if undomodelblend then
		render.SetBlend(1)
		render.ModelMaterialOverride()
		render.SetColorModulation(1, 1, 1)

		undomodelblend = false
	end
	if undozombievision then
		render.ModelMaterialOverride()
		render.SetColorModulation(1, 1, 1)
		render.SuppressEngineLighting(false)
		cam.IgnoreZ(false)

		undozombievision = false
	end

	--if pl ~= MySelf and MySelf:Team() == pl:Team() and pl:IsFriend() then
		--local pos = pl:GetPos() + Vector(0, 0, 2)
		--render.SetMaterial(matFriendRing)
		--render.DrawQuadEasy(pos, Vector(0, 0, 1), 32, 32, colFriend)
		--render.DrawQuadEasy(pos, Vector(0, 0, -1), 32, 32, colFriend)
	--end
end

function GM:DrawCraftingEntity()
	local craftingentity = self.CraftingEntity
	if craftingentity and craftingentity:IsValid() then
		if self.HumanMenuPanel and self.HumanMenuPanel:Valid() and self.HumanMenuPanel:IsVisible() and MySelf:KeyDown(self.MenuKey) then
			local scale = craftingentity:GetModelScale()
			if not scale then return end

			render.ModelMaterialOverride(matWhite)
			render.SuppressEngineLighting(true)
			render.SetBlend(0.025)
			local extrascale = 1.05 + math.abs(math.sin(RealTime() * 7)) * 0.1
			craftingentity:SetModelScale(scale * extrascale, 0)

			local oldpos = craftingentity:GetPos()
			craftingentity:SetPos(oldpos - craftingentity:LocalToWorld(oldpos))
			craftingentity:DrawModel()
			craftingentity:SetPos(oldpos)

			craftingentity:SetModelScale(scale, 0)
			render.SetBlend(1)
			render.SuppressEngineLighting(false)
			render.ModelMaterialOverride(0)
		else
			self.CraftingEntity = nil
		end
	end
end

local function tophealth(pl)
				
local plys = player.GetAll()
local maxhp = 0

	for _, pl in pairs(plys) do
		maxhp = math.max( maxhp, pl:Health() )
	end

local winners = {}

	for _, pl in pairs(plys) do
		if pl:Health() == maxhp then table.insert(winners, pl) end
	end

	return winners
end

function GM:HUDPaintBackgroundEndRound(winner)
	local w, h = ScrW(), ScrH()
	local pl = LocalPlayer()
	local timleft = math.max(0, self.EndTime + self.EndGameTime - CurTime())

	if timleft <= 0 then
		draw_SimpleText(translate.Get("loading"), "ZSHUDFont", w * 0.5, h * 0.8, COLOR_WHITE, TEXT_ALIGN_CENTER)
	else
		draw_SimpleText(translate.Format("next_round_in_x", util.ToMinutesSeconds(timleft)), "ZSHUDFontSmall", w * 0.5, h * 0.8, COLOR_WHITE, TEXT_ALIGN_CENTER)
	end

end


local function EndRoundCalcView(pl, origin, angles, fov, znear, zfar)
	if GAMEMODE.EndTime and CurTime() < GAMEMODE.EndTime + 5 then
		local endposition = GAMEMODE.LastHumanPosition
		local override = GetGlobalVector("endcamerapos", 1)
		if type(override) ~= "number" then
			endposition = override
		end
		if endposition then
			local delta = math.Clamp((CurTime() - GAMEMODE.EndTime) * 2, 0, 1)
 
			local start = endposition * delta + origin * (1 - delta)
			local tr = util.TraceHull({start = start, endpos = start + delta * 64 * Angle(0, CurTime() * 30, 0):Forward(), mins = Vector(-2, -2, -2), maxs = Vector(2, 2, 2), filter = player.GetAll(), mask = MASK_SOLID})
			return {origin = tr.HitPos + tr.HitNormal, angles = (start - tr.HitPos):Angle()}
		end

		return
	end

	hook.Remove("CalcView", "EndRoundCalcView")
end

local function EndRoundShouldDrawLocalPlayer(pl)
	if GAMEMODE.EndTime and CurTime() < GAMEMODE.EndTime + 5 then
		return true
	end

	hook.Remove("ShouldDrawLocalPlayer", "EndRoundShouldDrawLocalPlayer")
end

local function EndRoundGetMeleeFilter(self) return {self} end
function GM:EndRound(winner, nextmap)
	if self.RoundEnded then return end
	self.RoundEnded = true

	ROUNDWINNER = winner

	self.EndTime = CurTime()

	RunConsoleCommand("stopsound")

	FindMetaTable("Player").GetMeleeFilter = EndRoundGetMeleeFilter


	self.HUDPaint = self.HUDPaintEndRound
	self.HUDPaintBackground = self.HUDPaintBackgroundEndRound

	if winner == TEAM_UNDEAD and GetGlobalBool("endcamera", true) then
		hook.Add("CalcView", "EndRoundCalcView", EndRoundCalcView)
		hook.Add("ShouldDrawLocalPlayer", "EndRoundShouldDrawLocalPlayer", EndRoundShouldDrawLocalPlayer)
	end

	local dvar = winner == TEAM_UNDEAD and self.AllLoseSound or self.HumanWinSound
	local snd = GetGlobalString(winner == TEAM_UNDEAD and "losemusic" or "winmusic", dvar)
	if snd == "default" then
		snd = dvar
	elseif snd == "none" then
		snd = nil
	end
	if snd then
		timer.Simple(0.5, function() surface_PlaySound(snd) end)
	end


	if not (pEndBoard and pEndBoard:IsValid()) then
		MakepEndBoard(winner)
	end
	
	timer.Simple(18, function () --Duby: Test this works so we can get it working with the Map Vote System!
		surface.PlaySound("weapons/physcannon/energy_disintegrate5.wav")
		pEndBoard:Remove()
		pEndBoard = nil
	end)
	
end

function GM:WeaponDeployed(pl, wep)
end

function GM:LocalPlayerDied(attackername)
	LASTDEATH = RealTime()

	surface_PlaySound(self.DeathSound)
	if attackername then
		self:CenterNotify(COLOR_RED, {font = "ZSHUDFont"}, translate.Get("you_have_died"))
		self:CenterNotify(COLOR_RED, translate.Format(self.PantsMode and "you_were_kicked_by_x" or "you_were_killed_by_x", tostring(attackername)))
	else
		self:CenterNotify(COLOR_RED, {font = "ZSHUDFont"}, translate.Get("you_have_died"))
	end
end

function GM:KeyPress(pl, key)
	if key == self.MenuKey then
		if pl:Team() == TEAM_HUMAN and pl:Alive() and not pl:IsHolding() then
			gamemode.Call("HumanMenu")
		end
	elseif key == IN_SPEED then
		if pl:Alive() then
			if pl:Team() == TEAM_HUMAN then
				pl:DispatchAltUse()
			elseif pl:Team() == TEAM_UNDEAD then
				pl:CallZombieFunction("AltUse")
			end
		end
	end
end

function GM:PlayerStepSoundTime(pl, iType, bWalking)
	local time = pl:CallZombieFunction("PlayerStepSoundTime", iType, bWalking)
	if time then
		return time
	end

	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		return 520 - pl:GetVelocity():Length()
	end

	if iType == STEPSOUNDTIME_ON_LADDER then
		return 500
	end

	if iType == STEPSOUNDTIME_WATER_KNEE then
		return 650
	end

	return 350
end

function GM:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume)
	return pl:CallZombieFunction("PlayerFootstep", vFootPos, iFoot, strSoundName, fVolume)
end

function GM:PlayerCanCheckout(pl)
	return pl:IsValid() and pl:Team() == TEAM_HUMAN and pl:Alive() and self:GetWave() <= 0
end

function GM:OpenWorth()
	if gamemode.Call("PlayerCanCheckout", MySelf) then
		MakepWorth()
	end
end

function GM:CloseWorth()
	if pWorth and pWorth:Valid() then
		pWorth:Remove()
		pWorth = nil
	end
end

function GM:SuppressArsenalUpgrades(suppresstime)
	self.SuppressArsenalTime = math.max(CurTime() + suppresstime, self.SuppressArsenalTime)
end

function GM:Rewarded(class, amount)
	if CurTime() < self.SuppressArsenalTime then return end

	class = class or "0"

	local toptext = translate.Get("arsenal_upgraded")

	local wep = weapons.GetStored(class)
	if wep and wep.PrintName then
		if killicon.Get(class) == killicon.Get("default") then
			self:CenterNotify(COLOR_RED, toptext..": ", color_white, wep.PrintName)
		else
			self:CenterNotify(" ", COLOR_RED, toptext..": ", color_white, wep.PrintName)
		end
	--elseif amount then
		--self:CenterNotify(COLOR_PURPLE, toptext..": ", color_white, amount.." "..class)
	--else
		--self:CenterNotify(COLOR_PURPLE, toptext)
	end
end

function PlayMenuOpenSound()
	LocalPlayer():EmitSound("buttons/lightswitch2.wav", 100, 30)
end

function PlayMenuCloseSound()
	LocalPlayer():EmitSound("buttons/lightswitch2.wav", 100, 20)
end

local DamageFloaters = CreateClientConVar("zs_damagefloaters", "1", true, false):GetBool()
cvars.AddChangeCallback("zs_damagefloaters", function(cvar, oldvalue, newvalue)
	DamageFloaters = newvalue ~= "0"
end)

net.Receive("zs_legdamage", function(length)
	LocalPlayer().LegDamage = net.ReadFloat()
end)






net.Receive("zs_zvols", function(length)
	local volunteers = {}
	local count = net.ReadUInt(8)
	for i=1, count do
		volunteers[i] = net.ReadEntity()
	end

	GAMEMODE.ZombieVolunteers = volunteers
end)

net.Receive("zs_dmg", function(length)
	local damage = net.ReadUInt(16)
	local pos = net.ReadVector()

	if DamageFloaters then
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetMagnitude(damage)
			effectdata:SetScale(0)
		util.Effect("damagenumber", effectdata)
	end
end)

net.Receive("zs_dmg_prop", function(length)
	local damage = net.ReadUInt(16)
	local pos = net.ReadVector()

	if DamageFloaters then
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetMagnitude(damage)
			effectdata:SetScale(1)
		util.Effect("damagenumber", effectdata)
	end
end)

net.Receive("zs_lifestats", function(length)
	local barricadedamage = net.ReadUInt(24)
	local humandamage = net.ReadUInt(24)
	local brainseaten = net.ReadUInt(16)

	GAMEMODE.LifeStatsEndTime = CurTime() + GAMEMODE.LifeStatsLifeTime
	GAMEMODE.LifeStatsBarricadeDamage = barricadedamage
	GAMEMODE.LifeStatsHumanDamage = humandamage
	GAMEMODE.LifeStatsBrainsEaten = brainseaten
end)

net.Receive("zs_lifestatsbd", function(length)
	local barricadedamage = net.ReadUInt(24)

	GAMEMODE.LifeStatsEndTime = CurTime() + GAMEMODE.LifeStatsLifeTime
	GAMEMODE.LifeStatsBarricadeDamage = barricadedamage
end)

net.Receive("zs_lifestatshd", function(length)
	local humandamage = net.ReadUInt(24)

	GAMEMODE.LifeStatsEndTime = CurTime() + GAMEMODE.LifeStatsLifeTime
	GAMEMODE.LifeStatsHumanDamage = humandamage
end)

net.Receive("zs_lifestatsbe", function(length)
	local brainseaten = net.ReadUInt(16)

	GAMEMODE.LifeStatsEndTime = CurTime() + GAMEMODE.LifeStatsLifeTime
	GAMEMODE.LifeStatsBrainsEaten = brainseaten
end)

net.Receive("zs_honmention", function(length)
	local pl = net.ReadEntity()
	local mentionid = net.ReadUInt(8)
	local etc = net.ReadInt(32)

	if pl:IsValid() then
		gamemode.Call("AddHonorableMention", pl, mentionid, etc)
	end
end)

net.Receive("zs_wavestart", function(length)
	local wave = net.ReadInt(16)
	local time = net.ReadFloat()

	gamemode.Call("SetWave", wave)
	gamemode.Call("SetWaveEnd", time)

	if GAMEMODE.ZombieEscape then
		GAMEMODE:Add3DMessage(100, translate.Get("escape_from_the_zombies"), nil, "ZSHUDFont")
	elseif wave == GAMEMODE:GetNumberOfWaves() then	

		GAMEMODE:Add3DMessage(100, translate.Get("final_wave"), nil, "ZSHUDFont2")
		GAMEMODE:Add3DMessage(100, translate.Get("final_wave_sub"), nil, "ZSHUDFont2")
	else
		GAMEMODE:Add3DMessage(100, translate.Format("wave_x_has_begun", wave), nil, "ZSHUDFont2")
	end

	local pl = LocalPlayer()
	
	surface_PlaySound("npc/zombie_poison/pz_call1.wav")
	
end)

net.Receive("zs_classunlock", function(length)
		GAMEMODE:CenterNotify(COLOR_DARKRED, net.ReadString() .. "  Unlocked")	
		surface_PlaySound("ambient/creatures/town_scared_sob1.wav")
		timer.Simple(1.1, function()
		surface_PlaySound("ambient/creatures/town_scared_sob2.wav")
		end)
end)

net.Receive("zs_waveend", function(length)
	local wave = net.ReadInt(16)
	local time = net.ReadFloat()

	gamemode.Call("SetWaveStart", time)

	if wave < GAMEMODE:GetNumberOfWaves() and wave > 0 then



		GAMEMODE:Add3DMessage(100, translate.Format("wave_x_is_over", wave), nil, "ZSHUDFont2")
		GAMEMODE:Add3DMessage(100, translate.Format("wave_x_is_over_sub", GAMEMODE.ArsenalCrateDiscountPercentage), nil, "ZSHUDFont2")
		
		translate.Get("escape_from_the_zombies")

		surface_PlaySound("npc/zombie_poison/pz_call1.wav")
	end
end)

net.Receive("zs_gamestate", function(length)
	local wave = net.ReadInt(16)
	local wavestart = net.ReadFloat()
	local waveend = net.ReadFloat()

	gamemode.Call("SetWave", wave)
	gamemode.Call("SetWaveStart", wavestart)
	gamemode.Call("SetWaveEnd", waveend)
end)

local matSkull = Material("zombiesurvival/horderally")
local bossspawnedend
local function BossSpawnedPaint()
	if CurTime() > bossspawnedend then
		hook.Remove("HUDPaint", "BossSpawnedPaint")
		return
	end

	local delta = math.Clamp(bossspawnedend - CurTime(), 0, 1)
	local size = (1 - delta) * math.max(ScrW(), ScrH())

	surface_SetMaterial(matSkull)
	surface_SetDrawColor(160, 0, 0, math.min(delta * 400, 180))
	surface_DrawTexturedRectRotated(ScrW() / 2, ScrH() / 2, size, size, delta * 25)
end
net.Receive("zs_boss_spawned", function(length)
	local ent = net.ReadEntity()
	local classindex = net.ReadUInt(8)

	if ent == MySelf and ent:IsValid() then
		GAMEMODE:Add3DMessage(100, translate.Format("you_are_x", translate.Get(GAMEMODE.ZombieClasses[classindex].TranslationName)), nil, "ZSHUDFont2")
	elseif ent:IsValid() then
		GAMEMODE:Add3DMessage(100, translate.Format("you_are_x", translate.Format("x_has_risen_as_y", ent:Name(), translate.Get(GAMEMODE.ZombieClasses[classindex].TranslationName))), nil, "ZSHUDFont2")
	else
		GAMEMODE:Add3DMessage(100, translate.Format("x_has_risen", translate.Get(GAMEMODE.ZombieClasses[classindex].TranslationName)), nil, "ZSHUDFont2")
	end

	if MySelf:IsValid() then
		MySelf:EmitSound("npc/zombie_poison/pz_alert1.wav", 0)
	end

	bossspawnedend = CurTime() + 1
	hook.Add("HUDPaint", "BossSpawnedPaint", BossSpawnedPaint)
end)

net.Receive("zs_centernotify", function(length)
	local tab = net.ReadTable()

	GAMEMODE:CenterNotify(unpack(tab))
end)

net.Receive("zs_topnotify", function(length)
	local tab = net.ReadTable()

	GAMEMODE:TopNotify(unpack(tab))
end)

net.Receive("zs_lasthuman", function(length)
	local pl = net.ReadEntity()

	gamemode.Call("LastHuman", pl)
end)

net.Receive("zs_gamemodecall", function(length)
	gamemode.Call(net.ReadString())
end)

net.Receive("zs_lasthumanpos", function(length)
	GAMEMODE.LastHumanPosition = net.ReadVector()
end)

net.Receive("zs_endround", function(length)
	local winner = net.ReadUInt(8)
	local nextmap = net.ReadString()

	gamemode.Call("EndRound", winner, nextmap)
end)

-- Temporary fix
function render.DrawQuadEasy(pos, dir, xsize, ysize, color, rotation)
	xsize = xsize / 2
	ysize = ysize / 2

	local ang = dir:Angle()

	if rotation then
		ang:RotateAroundAxis(ang:Forward(), rotation)
	end

	local upoffset = ang:Up() * ysize
	local rightoffset = ang:Right() * xsize

	render.DrawQuad(pos - upoffset - rightoffset, pos - upoffset + rightoffset, pos + upoffset + rightoffset, pos + upoffset - rightoffset, color)
end

net.Receive( "hentai", function( len, pl ) -- len is the net message length, which we don't care about, ply is the player who sent it.
	local pl = LocalPlayer()
	pl:EmitSound("mrgreen/9000.wav")
end )

net.Receive( "slowmo_debug", function( len, pl ) -- len is the net message length, which we don't care about, ply is the player who sent it.
	local pl = LocalPlayer()
	
		surface.PlaySound("mrgreen/slowmo/slowmo_up_6.wav")
	timer.Simple(0.7, function() 
		surface.PlaySound("mrgreen/slowmo/slowmo_down_8.wav")
	end)
end )



local GradientExample = surface.GetTextureID("gui/center_gradient")
function DrawBlackBox(x,y,w,h,overridealpha)

	local a = 1
	
	if overridealpha then
		a = overridealpha
	end
	
	surface.SetDrawColor( Color( 0, 0, 0, 240*a ) )
	surface.DrawRect( x, y, w, h )
		
	local Quad = {} 
	Quad.texture 	= GradientExample
	Quad.color		= Color(40,40,40,140*a)
 
	Quad.x = x
	Quad.y = y
	Quad.w = w
	Quad.h = h
	draw.TexturedQuad( Quad )
		
	surface.SetDrawColor( 30, 30, 30, 200*a )
	surface.DrawOutlinedRect( x, y, w, h )
	surface.SetDrawColor( 30, 30, 30, 255*a )
	surface.DrawOutlinedRect( x+1, y+1, w-2, h-2 )
end


--Better Messages for vote commands--------

local DrawVote = false
local distapproach = 0
local vwide, vtall = ScaleW(232), ScaleH(156)
local xpos = -vwide
local whiner, target,votetype, countyes, countno, timeleft = "", "", "", 0, 0, 0

-- Called when vote begins
local function OpenVoteWindow(um)
if not IsValid ( MySelf ) then return end

	target = um:ReadEntity():Name()
	votetype = um:ReadString()
	timeleft = CurTime() + 20
	DrawVote = true
	
	surface.PlaySound("buttons/button4.wav")
	
end
usermessage.Hook ( "OpenVoteWindow", OpenVoteWindow )

-- Called when someone votes yes or no
local function AddVote(um)
if not IsValid ( MySelf ) then return end

local vote = um:ReadString()

	if vote == "yes" then
		countyes = countyes + 1
	else
		countno = countno + 1
	end
	
	surface.PlaySound("UI/hint.wav")
	
end
usermessage.Hook ( "AddVote", AddVote )

-- Called at the end of vote
local function CloseVoteWindow()
if not IsValid ( MySelf ) then return end

	target,votetype,countyes,countno, timeleft = "", "", 0, 0, 0
	DrawVote = false
	
	surface.PlaySound("buttons/button14.wav")
end
usermessage.Hook ( "CloseVoteWindow", CloseVoteWindow )

-- Draw the vote message with results
function DrawVoteMessage()


	if not IsValid ( MySelf ) or ENDROUND then
		return
	end

	if DrawVote then distapproach = -1 else distapproach = -vwide end

	xpos = math.Clamp(math.Approach(xpos,distapproach, FrameTime()*300),-vwide,-1)

	local ypos = ScrH()/2-120

	if xpos == -vwide then return end
	
	DrawBlackBox(xpos, ypos, vwide, vtall)
	
	ypos = ypos+4
	
	draw.SimpleTextOutlined(""..string.upper(votetype).." player "..target.."?" , "ZSHUDFontSmallest", xpos + vwide/2 , ypos, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	ypos = ypos +26
	
	draw.SimpleTextOutlined("(Press F1 for YES or F2 for NO)" , "ZSHUDFontSmaller", xpos + vwide/2 , ypos, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	ypos = ypos +31
	
	draw.SimpleTextOutlined("YES" , "ZSHUDFontSmall", xpos + vwide/4 , ypos, Color (0,255,0,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	draw.SimpleTextOutlined("NO" , "ZSHUDFontSmall", xpos + 3*vwide/4 , ypos, Color (255,0,0,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	ypos = ypos +27
	
	draw.SimpleTextOutlined(countyes , "ZSHUDFontSmallest", xpos + vwide/4 , ypos, Color (0,255,0,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	draw.SimpleTextOutlined(countno , "ZSHUDFontSmallest", xpos + 3*vwide/4 , ypos, Color (255,0,0,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	ypos = ypos +27
	
	draw.SimpleTextOutlined("(Time left: "..math.Clamp(math.Round(timeleft - CurTime()),0,20)..")" , "ZSHUDFontSmallest", xpos + vwide/2 , ypos, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	
	
end
hook.Add( "HUDPaint", "DrawVoteMessage", DrawVoteMessage )

--Usermessage for custom messages by Overv------

net.Receive( "CustomChatAdd", function( len )
	
	local argc = net.ReadDouble( )
	local args = { }
	
	for i = 1, argc / 2, 1 do
		table.insert( args, Color( net.ReadDouble( ), net.ReadDouble( ), net.ReadDouble( ), net.ReadDouble( ) ) )
		table.insert( args, net.ReadString( ) )
	end
         
	chat.AddText( unpack( args ) )


end)

local function CustomChatAdd(um)

	local argc = um:ReadShort( )
	local args = { }
	
	for i = 1, argc / 2, 1 do
		table.insert( args, Color( um:ReadShort( ), um:ReadShort( ), um:ReadShort( ), um:ReadShort( ) ) )
		table.insert( args, um:ReadString( ) )
	end
         
	chat.AddText( unpack( args ) )

end
usermessage.Hook( "CustomChatAdd",CustomChatAdd)


