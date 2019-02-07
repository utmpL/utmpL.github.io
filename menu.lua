local imgui = require "imgui"
local ffi = require "ffi"
require "lib.moonloader"
local key = require "vkeys"
local inicfg = require "inicfg"
local sampev = require "lib.samp.events"
local encoding = require 'encoding'
local mem = require "memory"
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local font = renderCreateFont("Arial", 7, 4)
local nick_font = renderCreateFont('Verdana', 10, FCR_BOLD + FCR_BORDER)
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)

local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}
local tCarsTypeName = {"¿‚ÚÓÏÓ·ËÎ¸", "ÃÓÚÓËˆËÍÎ", "¬ÂÚÓÎ∏Ú", "—‡ÏÓÎ∏Ú", "œËˆÂÔ", "ÀÓ‰Í‡", "ƒÛ„ÓÂ", "œÓÂÁ‰", "¬ÂÎÓÒËÔÂ‰"}
local tCarsSpeed = {43, 40, 51, 30, 36, 45, 30, 41, 27, 43, 36, 61, 46, 30, 29, 53, 42, 30, 32, 41, 40, 42, 38, 27, 37,
54, 48, 45, 43, 55, 51, 36, 26, 30, 46, 0, 41, 43, 39, 46, 37, 21, 38, 35, 30, 45, 60, 35, 30, 52, 0, 53, 43, 16, 33, 43,
29, 26, 43, 37, 48, 43, 30, 29, 14, 13, 40, 39, 40, 34, 43, 30, 34, 29, 41, 48, 69, 51, 32, 38, 51, 20, 43, 34, 18, 27,
17, 47, 40, 38, 43, 41, 39, 49, 59, 49, 45, 48, 29, 34, 39, 8, 58, 59, 48, 38, 49, 46, 29, 21, 27, 40, 36, 45, 33, 39, 43,
43, 45, 75, 75, 43, 48, 41, 36, 44, 43, 41, 48, 41, 16, 19, 30, 46, 46, 43, 47, -1, -1, 27, 41, 56, 45, 41, 41, 40, 41,
39, 37, 42, 40, 43, 33, 64, 39, 43, 30, 30, 43, 49, 46, 42, 49, 39, 24, 45, 44, 49, 40, -1, -1, 25, 22, 30, 30, 43, 43, 75,
36, 43, 42, 42, 37, 23, 0, 42, 38, 45, 29, 45, 0, 0, 75, 52, 17, 32, 48, 48, 48, 44, 41, 30, 47, 47, 40, 41, 0, 0, 0, 29, 0, 0
}
local tCarsType = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
3, 1, 1, 1, 1, 6, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 6, 3, 2, 8, 5, 1, 6, 6, 6, 1,
1, 1, 1, 1, 4, 2, 2, 2, 7, 7, 1, 1, 2, 3, 1, 7, 6, 6, 1, 1, 4, 1, 1, 1, 1, 9, 1, 1, 6, 1,
1, 3, 3, 1, 1, 1, 1, 6, 1, 1, 1, 3, 1, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 9, 9, 4, 4, 4, 1, 1, 1,
1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1,
1, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 4,
1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 1, 7, 5, 4, 4, 7, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 5, 5
}



color_button = 0xAA000000
local color_button_active = 0xAA422E51
local color_text_enabled = '{B349FB}'
local color_text = '{FFFFFF}'
local color_text_active = '{E8C6FF}'
local color_line = 0xFF221F24
local color_line_size = 2
local font = renderCreateFont('Verdana', 12)
local nick_font = renderCreateFont('Verdana', 10, FCR_BOLD + FCR_BORDER)
local stat_font = renderCreateFont('Verdana', 8, FCR_BOLD + FCR_BORDER)


function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 0.0
    style.FramePadding = ImVec2(5, 4)
    style.FrameRounding = 0.0
    style.ItemSpacing = ImVec2(0, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 0.0
    style.GrabMinSize = 10.0
    style.GrabRounding = 0.0
		style.ChildWindowRounding = 0.0

		colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
		colors[clr.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00)
		colors[clr.WindowBg]               = ImVec4(0.07, 0.07, 0.07, 1.00)
		colors[clr.ChildWindowBg]          = ImVec4(0.10, 0.10, 0.10, 1.00)
		colors[clr.PopupBg]                = ImVec4(0.05, 0.05, 0.10, 0.90)
		colors[clr.Border]                 = ImVec4(0.45, 0.45, 0.45, 0.40)
		colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.FrameBg]                = ImVec4(0.80, 0.80, 0.80, 0.30)
		colors[clr.FrameBgHovered]         = ImVec4(0.45, 0.45, 0.45, 0.40)
		colors[clr.FrameBgActive]          = ImVec4(0.45, 0.45, 0.45, 0.40)
		colors[clr.TitleBg]                = ImVec4(0.27, 0.27, 0.54, 0.83)
		colors[clr.TitleBgActive]          = ImVec4(0.32, 0.32, 0.63, 0.87)
		colors[clr.TitleBgCollapsed]       = ImVec4(0.40, 0.40, 0.80, 0.20)
		colors[clr.MenuBarBg]              = ImVec4(0.40, 0.40, 0.55, 0.80)
		colors[clr.ScrollbarBg]            = ImVec4(0.05, 0.05, 0.05, 1.00)
		colors[clr.ScrollbarGrab]          = ImVec4(0.19, 0.19, 0.19, 0.60)
		colors[clr.ScrollbarGrabHovered]   = ImVec4(0.13, 0.13, 0.13, 0.60)
		colors[clr.ScrollbarGrabActive]    = ImVec4(0.19, 0.19, 0.19, 0.60)
		colors[clr.ComboBg]                = ImVec4(0.20, 0.20, 0.20, 0.99)
		colors[clr.CheckMark]              = ImVec4(0.90, 0.90, 0.90, 0.50)
		colors[clr.SliderGrab]             = ImVec4(0.55, 0.55, 0.55, 0.60)
		colors[clr.SliderGrabActive]       = ImVec4(0.13, 0.13, 0.13, 0.60)
		colors[clr.Button]                 = ImVec4(0.19, 0.19, 0.19, 0.60)
		colors[clr.ButtonHovered]          = ImVec4(0.13, 0.13, 0.13, 0.60)
		colors[clr.ButtonActive]           = ImVec4(0.19, 0.19, 0.19, 0.60)
		colors[clr.Header]                 = ImVec4(0.40, 0.40, 0.90, 0.45)
		colors[clr.HeaderHovered]          = ImVec4(0.13, 0.13, 0.13, 0.60)
		colors[clr.HeaderActive]           = ImVec4(0.11, 0.11, 0.11, 0.60)
		colors[clr.Separator]              = ImVec4(0.45, 0.45, 0.45, 0.40)
		colors[clr.SeparatorHovered]       = ImVec4(0.60, 0.60, 0.70, 1.00)
		colors[clr.SeparatorActive]        = ImVec4(0.70, 0.70, 0.90, 1.00)
		colors[clr.ResizeGrip]             = ImVec4(1.00, 1.00, 1.00, 0.30)
		colors[clr.ResizeGripHovered]      = ImVec4(1.00, 1.00, 1.00, 0.60)
		colors[clr.ResizeGripActive]       = ImVec4(1.00, 1.00, 1.00, 0.90)
		colors[clr.CloseButton]            = ImVec4(0.50, 0.50, 0.90, 0.50)
		colors[clr.CloseButtonHovered]     = ImVec4(0.70, 0.70, 0.90, 0.60)
		colors[clr.CloseButtonActive]      = ImVec4(0.70, 0.70, 0.70, 1.00)
		colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.PlotLinesHovered]       = ImVec4(0.90, 0.70, 0.00, 1.00)
		colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
		colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
		colors[clr.TextSelectedBg]         = ImVec4(0.00, 0.00, 1.00, 0.35)
		colors[clr.ModalWindowDarkening]   = ImVec4(0.20, 0.20, 0.20, 0.35)
end
apply_custom_style()

local gui = imgui.ImBool(false)
local menu = 1
local menu_visuals = 1
local nametag_samp = imgui.ImBool(false)
local nametag_render = imgui.ImBool(false)
local skeleton = imgui.ImBool(false)
local tracer = imgui.ImBool(false)
local tracer_type = imgui.ImInt(1)
local car_tracer = imgui.ImBool(false)
local car_tracer_type = imgui.ImInt(1)
local car_nametag = imgui.ImBool(false)
local car_nametag_id = imgui.ImBool(false)
local esp = imgui.ImBool(false)
local distance = imgui.ImBool(false)
local configuration = imgui.ImInt(0)
local rapid = imgui.ImBool(false)
local rapid_speed = imgui.ImFloat(1.0)
local car_esp = imgui.ImBool(false)
local gm = imgui.ImBool(false)
local gm_nop = imgui.ImBool(false)
local noreload = imgui.ImBool(false)

function patch()
	if mem.getuint8(0x748C2B) == 0xE8 then
		mem.fill(0x748C2B, 0x90, 5, true)
	elseif mem.getuint8(0x748C7B) == 0xE8 then
		mem.fill(0x748C7B, 0x90, 5, true)
	end
	if mem.getuint8(0x5909AA) == 0xBE then
		mem.write(0x5909AB, 1, 1, true)
	end
	if mem.getuint8(0x590A1D) == 0xBE then
		mem.write(0x590A1D, 0xE9, 1, true)
		mem.write(0x590A1E, 0x8D, 4, true)
	end
	if mem.getuint8(0x748C6B) == 0xC6 then
		mem.fill(0x748C6B, 0x90, 7, true)
	elseif mem.getuint8(0x748CBB) == 0xC6 then
		mem.fill(0x748CBB, 0x90, 7, true)
	end
	if mem.getuint8(0x590AF0) == 0xA1 then
		mem.write(0x590AF0, 0xE9, 1, true)
		mem.write(0x590AF1, 0x140, 4, true)
	end
end
patch()

function imgui.OnDrawFrame()
	if gui.v then
		imgui.SetNextWindowSize(imgui.ImVec2(500, 450), imgui.Cond.Always)
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.Once, imgui.ImVec2(0.5, 0.5))
		imgui.Begin('skeet', gui, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
		imgui.SameLine()
		imgui.BeginChild('menu_select', imgui.ImVec2(90, 425), true)
		if imgui.Selectable("Aimbot") then menu = 1 end
		if imgui.Selectable("Visuals") then menu = 2 end
		if imgui.Selectable("Movement") then menu = 3 end
		if imgui.Selectable("Misc") then menu = 4 end
		if imgui.Selectable("Car") then menu = 5 end
		if imgui.Selectable("Settings") then menu = 6 end
		imgui.EndChild()
		imgui.SameLine(120)
		if menu == 1 then
			imgui.BeginChild('menu_1', imgui.ImVec2(365, 425), true)
			imgui.CenterTextColoredRGB('Soon...')
			imgui.EndChild()


		elseif menu == 2 then
			imgui.BeginChild('menu_2', imgui.ImVec2(365, 425), true)
			if imgui.Button('Player',imgui.ImVec2(166.5,20)) then menu_visuals = 1 end
			imgui.SameLine(183.5)
			if imgui.Button('Car',imgui.ImVec2(166.5,20)) then menu_visuals = 2 end
			imgui.Separator()
			if menu_visuals == 1 then
			if imgui.Checkbox('NameTag (samp)', nametag_samp) then
				if nametag_samp.v then
					nameTagOn()
				else
					nameTagOff()
				end
			end
			if imgui.Checkbox('NameTag (render)', nametag_render) then
				if nametag_render.v then
					func_nametag_render()
				end
			end

			if imgui.Checkbox('Skeleton', skeleton) then
				if skeleton.v then
					func_render()
				end
			end
			if imgui.Checkbox('Tracer', tracer) then
				if tracer.v then
					func_tracer()
				end
			end
			if tracer.v then
				imgui.PushItemWidth(60)
				imgui.Combo("type", tracer_type,{"Up", "Skin", "Down"}, 3)
			end
			if imgui.Checkbox('Esp', esp) then
				if esp.v then
					func_esp()
				end
			end
			if imgui.Checkbox('Distance', distance) then
				if distance.v then
					func_distance()
				end
			end
		else
			if imgui.Checkbox('Car Tracer', car_tracer) then
				if car_tracer.v then
					func_car_tracer()
				end
			end
			if car_tracer.v then
				imgui.PushItemWidth(60)
				imgui.Combo("Type ", car_tracer_type,{"Up", "Skin", "Down"}, 3)
			end
			if imgui.Checkbox('Car Name', car_nametag) then
				if car_nametag.v then
					func_car_nametag()
				end
			end
			if car_nametag.v then
				imgui.Checkbox('Car ID', car_nametag_id)
			end
			if imgui.Checkbox('Car Esp', car_esp) then
				if car_esp.v then
					func_car_esp()
				end
			end

			end

			imgui.EndChild()


		elseif menu == 3 then
			imgui.BeginChild('menu_3', imgui.ImVec2(365, 425), true)
			if imgui.Checkbox('Rapid', rapid) then if rapid.v then func_rapid() end end
			if rapid.v then
 				imgui.PushItemWidth(70)
				imgui.Text('Rapid speed')
				imgui.SliderFloat('                        ', rapid_speed, 1.0, 50.0)
			end
			imgui.EndChild()


		elseif menu == 4 then
			imgui.BeginChild('menu_4', imgui.ImVec2(365, 425), true)
			if imgui.Button('Spawn', imgui.ImVec2(90,25)) then
				sampSpawnPlayer()
			end
			if imgui.Button('Spawn (send)', imgui.ImVec2(90,25)) then
				sampSendSpawn()
			end
			if imgui.Checkbox('gm', gm) then
				if gm.v then
					func_gm()
				end
			end
			imgui.Checkbox('gm (SetHP nop)', gm_nop)
			if imgui.Checkbox('NoReload', noreload) then
				if noreload.v then
					func_noreload()
				end
			end
			imgui.EndChild()


		elseif menu == 5 then
			imgui.BeginChild('menu_5', imgui.ImVec2(365, 425), true)
			if imgui.Button('Repair car', imgui.ImVec2(90,25)) then
				if isCharInAnyCar(playerPed) then
					local car = storeCarCharIsInNoSave(playerPed)
					setCarHealth(car, 1000)
				end
			end
			if imgui.Button('Flip car', imgui.ImVec2(90,25)) then
				if isCharInAnyCar(playerPed) then
					local car = storeCarCharIsInNoSave(playerPed)
					local x, y, z = getCarCoordinates(car)
					setCarCoordinates(car, x, y, z)
				end
			end

			imgui.EndChild()

		elseif menu == 6 then
			imgui.BeginChild('menu_6', imgui.ImVec2(365, 425), true)
			imgui.PushItemWidth(150)
			imgui.Text('          Configuration')
			imgui.Combo("                                                                Configuration", configuration,{"1", "2", "3", "4", "5"}, 5)
			imgui.Button('load', imgui.ImVec2(150,25))
			imgui.Button('save', imgui.ImVec2(150,25))
			imgui.NewLine()
			imgui.EndChild()
		end
		imgui.End()
	end
end

function main()
	repeat wait(0) until isSampAvailable()
	resX, resY = getScreenResolution()
	while true do wait(0)
		imgui.Process = gui.v
		if wasKeyPressed(key.VK_1) and isKeyDown(key.VK_MENU) then
			gui.v = not gui.v
		end
	end
end

function func_noreload()
	lua_thread.create(function()
	while noreload.v do wait(0)
		local weap = getCurrentCharWeapon(playerPed)
		giveWeaponToChar(playerPed, weap, 0)
		wait(150)
	end
	end)
end

function func_car_esp()
	lua_thread.create(function()
	while car_esp.v do wait(0)
		for i = 0, 10000 do
			local result, car = sampGetCarHandleBySampVehicleId(i)
			if result and doesVehicleExist(car) and isCarOnScreen(car) then
				local model = getCarModel(car)
					local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCarInWorldCoords(car, x1, -y1, z1) -- Õ»« œ≈–≈ƒ À≈¬Œ
           local scx1, scy1 = convert3DCoordsToScreen(lx, ly, lz)

           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCarInWorldCoords(car, -x1, -y1, z1) -- Õ»« œ≈–≈ƒ œ–¿¬Œ
           local scx2, scy2 = convert3DCoordsToScreen(lx, ly, lz)

           renderDrawLine(scx1, scy1, scx2, scy2, 2, -1)
           ---------------------------------------------------------------------
           local x1, y1, z1= getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCarInWorldCoords(car, -x1, -y1, z1) -- Õ»« œ≈–≈ƒ œ–¿¬Œ
           local scx1, scy1 = convert3DCoordsToScreen(lx, ly, lz)

           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCarInWorldCoords(car, -x1, y1, z1) -- Õ»« «¿ƒ œ–¿¬Œ
           local scx2, scy2 = convert3DCoordsToScreen(lx, ly, lz)

           renderDrawLine(scx1, scy1, scx2, scy2, 2, -1)
           ---------------------------------------------------------------------
           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCarInWorldCoords(car, -x1, y1, z1) -- Õ»« «¿ƒ œ–¿¬Œ
           local scx1, scy1 = convert3DCoordsToScreen(lx, ly, lz)

           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCarInWorldCoords(car, x1, y1, z1) -- Õ»« «¿ƒ À≈¬Œ
           local scx2, scy2 = convert3DCoordsToScreen(lx, ly, lz)

           renderDrawLine(scx1, scy1, scx2, scy2, 2, -1)
           ---------------------------------------------------------------------
           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCarInWorldCoords(car, x1, y1, z1) -- Õ»« «¿ƒ À≈¬Œ
           local scx1, scy1 = convert3DCoordsToScreen(lx, ly, lz)
           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCarInWorldCoords(car, x1, -y1, z1) -- Õ»« œ≈–≈ƒ À≈¬Œ
           local scx2, scy2 = convert3DCoordsToScreen(lx, ly, lz)

           renderDrawLine(scx1, scy1, scx2, scy2, 2, -1) -- EG GF FH HE
           renderDrawPolygon(x, y, 5, 5, 15, 0, -1)
			 end
		 end
	 end
 end)
end

function func_gm()
	lua_thread.create(function()
	while gm.v do wait(0)
		setCharProofs(playerPed, true, true, true, true, true)
	end
	end)
end

function sampev.onSetPlayerHealth()
	if gm_nop.v then
		return false
	end
end

function func_rapid()
	lua_thread.create(function()
	while rapid.v do wait(0)
		setCharAnimSpeed(playerPed, 'python_fire', rapid_speed.v)
		setCharAnimSpeed(playerPed, 'RIFLE_fire', rapid_speed.v)
		setCharAnimSpeed(playerPed, 'RIFLE_fire_poor', rapid_speed.v)
		setCharAnimSpeed(playerPed, 'RIFLE_crouchfire', rapid_speed.v)
	end
	end)
end

function func_distance()
	lua_thread.create(function()
	while distance.v do wait(0)
		for i = 0, sampGetMaxPlayerId() do
			if sampIsPlayerConnected(i) then
				local result, cped = sampGetCharHandleBySampPlayerId(i)
				local color = sampGetPlayerColor(i)
				if result and doesCharExist(cped) and isCharOnScreen(cped) then
					local x, y, z = getCharCoordinates(cped)
					local xx, yy, zz = getCharCoordinates(playerPed)
					local dist = getDistanceBetweenCoords3d(x, y, z, xx, yy, zz)
					local x1, y1 = convert3DCoordsToScreen(x, y, z)
					local dist = math.ceil(dist)
					renderFontDrawText(stat_font, dist, x1, y1, -1, false)
				end
			end
		end
	end
	end)
end

function func_esp()
	lua_thread.create(function()
	while esp.v do wait(0)
		for i = 0, sampGetMaxPlayerId() do
			if sampIsPlayerConnected(i) then
				local result, handle = sampGetCharHandleBySampPlayerId(i)
				local color = sampGetPlayerColor(i)
				if result and doesCharExist(handle) and isCharOnScreen(handle) then
					local model = getCharModel(handle)
					local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCharInWorldCoords(handle, x1, -y1, z1) -- Õ»« œ≈–≈ƒ À≈¬Œ
           local scx1, scy1 = convert3DCoordsToScreen(lx, ly, lz)

           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCharInWorldCoords(handle, -x1, -y1, z1) -- Õ»« œ≈–≈ƒ œ–¿¬Œ
           local scx2, scy2 = convert3DCoordsToScreen(lx, ly, lz)

           renderDrawLine(scx1, scy1, scx2, scy2, 2, color)
           ---------------------------------------------------------------------
           local x1, y1, z1= getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCharInWorldCoords(handle, -x1, -y1, z1) -- Õ»« œ≈–≈ƒ œ–¿¬Œ
           local scx1, scy1 = convert3DCoordsToScreen(lx, ly, lz)

           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCharInWorldCoords(handle, -x1, y1, z1) -- Õ»« «¿ƒ œ–¿¬Œ
           local scx2, scy2 = convert3DCoordsToScreen(lx, ly, lz)

           renderDrawLine(scx1, scy1, scx2, scy2, 2, color)
           ---------------------------------------------------------------------
           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCharInWorldCoords(handle, -x1, y1, z1) -- Õ»« «¿ƒ œ–¿¬Œ
           local scx1, scy1 = convert3DCoordsToScreen(lx, ly, lz)

           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCharInWorldCoords(handle, x1, y1, z1) -- Õ»« «¿ƒ À≈¬Œ
           local scx2, scy2 = convert3DCoordsToScreen(lx, ly, lz)

           renderDrawLine(scx1, scy1, scx2, scy2, 2, color)
           ---------------------------------------------------------------------
           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCharInWorldCoords(handle, x1, y1, z1) -- Õ»« «¿ƒ À≈¬Œ
           local scx1, scy1 = convert3DCoordsToScreen(lx, ly, lz)

           local x1, y1, z1 = getModelDimensions(model)
           local lx, ly, lz = getOffsetFromCharInWorldCoords(handle, x1, -y1, z1) -- Õ»« œ≈–≈ƒ À≈¬Œ
           local scx2, scy2 = convert3DCoordsToScreen(lx, ly, lz)

           renderDrawLine(scx1, scy1, scx2, scy2, 2, color) -- EG GF FH HE
           renderDrawPolygon(x, y, 5, 5, 15, 0, color)
				 end
			 end
		 end
	 end
 end)
end

function func_car_nametag()
	lua_thread.create(function()
	while car_nametag.v do wait(0)
		for i = 0, 10000 do
			local result, car = sampGetCarHandleBySampVehicleId(i)
			if result and doesVehicleExist(car) and isCarOnScreen(car) then
				local carid = getCarModel(car)
				local _, scarid = sampGetVehicleIdByCarHandle(car)
				local xx, yy, zz = getCarCoordinates(car)
				local x1, y1 = convert3DCoordsToScreen(xx, yy, zz)
				if car_nametag_id.v then
					renderFontDrawText(nick_font, tCarsName[carid - 399]..' ['..scarid..']', x1, y1, -1, false)
				else
					renderFontDrawText(nick_font, tCarsName[carid - 399], x1, y1, -1, false)
				end
			end
		end
	end
	end)
end

function func_car_tracer()
	lua_thread.create(function()
	while car_tracer.v do wait(0)
		for i = 0, 10000 do
			local result, car = sampGetCarHandleBySampVehicleId(i)
			if result and doesVehicleExist(car) and isCarOnScreen(car) then
				if car_tracer_type.v == 0 then
					local xx, yy, zz = getCarCoordinates(car)
					local resoX = resX / 2
					local rexoY = 0
					local x1, y1 = convert3DCoordsToScreen(xx, yy, zz)
					renderDrawLine(resoX, resoY, x1, y1, 1.0, -1)
				elseif car_tracer_type.v == 1 then
					local xx, yy, zz = getCarCoordinates(car)
					local xx1, yy1, zz1 = getCharCoordinates(playerPed)
					local x1, y1 = convert3DCoordsToScreen(xx, yy, zz)
					local x2, y2 = convert3DCoordsToScreen(xx1, yy1, zz1)
					renderDrawLine(x1, y1, x2, y2, 1.0, -1)
				elseif car_tracer_type.v == 2 then
					local xx, yy, zz = getCarCoordinates(car)
					local resoX = resX / 2
					local resoY = resY
					local x1, y1 = convert3DCoordsToScreen(xx, yy, zz)
					renderDrawLine(resoX, resoY, x1, y1, 1.0, -1)
				end
			end
		end
	end
	end)
end

function myid()
 local _, id = sampGetPlayerIdByCharHandle(playerPed)
 return id
end

function func_nametag_render()
	lua_thread.create(function()
	while nametag_render.v do wait(0)
		for i = 0, sampGetMaxPlayerId() do
			if sampIsPlayerConnected(i) then
				local result, cped = sampGetCharHandleBySampPlayerId(i)
				local color = sampGetPlayerColor(i)
				local aa, rr, gg, bb = explode_argb(color)
				local color = join_argb(255, rr, gg, bb)
				if result and doesCharExist(cped) and isCharOnScreen(cped) then
					local xx, yy, zz = getCharCoordinates(cped)
					local x1, y1 = convert3DCoordsToScreen(xx, yy, zz + 1.15)
					local color = sampGetPlayerColor(i)
					local aa, rr, gg, bb = explode_argb(color)
					local color = join_argb(255, rr, gg, bb)
					renderDrawBoxWithBorder(x1 - 10, y1 - 10, 100, 10, color_button, 1, color_line)
					renderDrawBox(x1 - 10, y1 - 9, sampGetPlayerArmor(i), 8, 0xFFCCCCCC)
					renderFontDrawText(stat_font, sampGetPlayerArmor(i), x1 + 95, y1 - 11, 0xFFCCCCCC, false)
					renderDrawBoxWithBorder(x1 - 10, y1, 100, 10, color_button, 1, color_line)
					renderDrawBox(x1 - 10, y1 + 1, sampGetPlayerHealth(i), 8, 0xFFFF5656)
					renderFontDrawText(stat_font, sampGetPlayerHealth(i), x1 + 95, y1 - 1, 0xFFFF5656, false)
					renderFontDrawText(nick_font, sampGetPlayerNickname(i)..' ['..i..']', x1 - 11, y1 - 30, color, false)
					if sampIsPlayerPaused(i) then
						renderFontDrawText(nick_font, 'AFK', x1 - 11, y1 + 10, 0xFFCCCCCC, false)
					end
				end
			end
		end
	end
	end)
end

function func_tracer()
	lua_thread.create(function()
	while tracer.v do wait(0)
		for i = 0, sampGetMaxPlayerId() do
			if sampIsPlayerConnected(i) then
				local result, cped = sampGetCharHandleBySampPlayerId(i)
				local color = sampGetPlayerColor(i)
				local aa, rr, gg, bb = explode_argb(color)
				local color = join_argb(255, rr, gg, bb)
				if result and doesCharExist(cped) and isCharOnScreen(cped) then
					if tracer_type.v == 0 then
						local resoX = resX / 2
						local rexoY = 0
						local xx, yy, zz = getCharCoordinates(cped)
						local x2, y2, z2 = convert3DCoordsToScreen(xx, yy, zz)
						renderDrawLine(resoX, resoY, x2, y2, 1.0, color)
					elseif tracer_type.v == 1 then
						local x, y, z = getCharCoordinates(playerPed)
						local xx, yy, zz = getCharCoordinates(cped)
						local x1, y1, z1 = convert3DCoordsToScreen(x, y, z)
						local x2, y2, z2 = convert3DCoordsToScreen(xx, yy, zz)
						renderDrawLine(x1, y1, x2, y2, 1.0, color)
					elseif tracer_type.v == 2 then
						local resoX = resX / 2
						local resoY = resY
						local xx, yy, zz = getCharCoordinates(cped)
						local x2, y2, z2 = convert3DCoordsToScreen(xx, yy, zz)
						renderDrawLine(resoX, resoY, x2, y2, 1.0, color)
					end
				end
			end
		end
	end
	end)
end

function func_render()
	lua_thread.create(function()
	while skeleton.v do wait(0)
		for i = 0, sampGetMaxPlayerId() do
						if sampIsPlayerConnected(i) then
							local result, cped = sampGetCharHandleBySampPlayerId(i)
							local color = sampGetPlayerColor(i)
							local aa, rr, gg, bb = explode_argb(color)
							local color = join_argb(255, rr, gg, bb)
							if result then
								if doesCharExist(cped) and isCharOnScreen(cped) then
									local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
									for v = 1, #t do
										pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
										pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
										pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
										pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
										renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
									end
									for v = 4, 5 do
										pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
										pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
										renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
									end
									local t = {53, 43, 24, 34, 6}
									for v = 1, #t do
										posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
										pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
									end
								end
							end
						end
					end
	end
	end)
end

function sampev.onSendVehicleSync(data)
end

function imgui.CenterTextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local textsize = w:gsub('{.-}', '')
            local text_width = imgui.CalcTextSize(u8(textsize))
            imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(u8(w))
            end
        end
    end
    render_text(text)
end

function getBodyPartCoordinates(id, handle)
  local pedptr = getCharPointer(handle)
  local vec = ffi.new("float[3]")
  getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
  return vec[0], vec[1], vec[2]
end

function nameTagOn()
	local pStSet = sampGetServerSettingsPtr();
	NTdist = mem.getfloat(pStSet + 39)
	NTwalls = mem.getint8(pStSet + 47)
	NTshow = mem.getint8(pStSet + 56)
	mem.setfloat(pStSet + 39, 1488.0)
	mem.setint8(pStSet + 47, 0)
	mem.setint8(pStSet + 56, 1)
	nameTag = true
end

function nameTagOff()
	local pStSet = sampGetServerSettingsPtr();
	mem.setfloat(pStSet + 39, NTdist)
	mem.setint8(pStSet + 47, NTwalls)
	mem.setint8(pStSet + 56, NTshow)
	nameTag = false
end

function join_argb(a, r, g, b)
  local argb = b  -- b
  argb = bit.bor(argb, bit.lshift(g, 8))  -- g
  argb = bit.bor(argb, bit.lshift(r, 16)) -- r
  argb = bit.bor(argb, bit.lshift(a, 24)) -- a
  return argb
end

function explode_argb(argb)
  local a = bit.band(bit.rshift(argb, 24), 0xFF)
  local r = bit.band(bit.rshift(argb, 16), 0xFF)
  local g = bit.band(bit.rshift(argb, 8), 0xFF)
  local b = bit.band(argb, 0xFF)
  return a, r, g, b
end
