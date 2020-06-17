script_name("Larek")
script_author("Vlaek")
script_version('17/06/2020')
script_version_number(1)
script_url("https://vlaek.github.io/Larek/")
script.update = false

local sampev, inicfg, imgui, encoding = require 'lib.samp.events', require 'inicfg', require 'imgui', require 'encoding'
require "reload_all"
require "lib.sampfuncs"
require "lib.moonloader"
encoding.default = 'CP1251'
local u8 = encoding.UTF8

require "reload_all"
require "lib.sampfuncs"
require "lib.moonloader"

local directIni = "\\Larek\\Larek.ini"
local directIni2 = "\\Larek\\LarekMoney.ini"
local directIni3 = "\\Larek\\LarekTime.ini"
local ini = {}
local ini2 = {}
local ini3 = {}

local main_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)

local resX, resY = getScreenResolution()
--local checked_radio = imgui.ImInt(1)
local main_color = 0xFF0000

local Magaz1  = false
local Magaz2  = false
local Magaz3  = false
local Magaz4  = false
local Magaz5  = false
local Magaz6  = false
local Magaz7  = false
local Magaz8  = false
local Magaz9  = false
local Magaz10 = false
local Magaz11 = false
local Magaz12 = false
local Magaz13 = false
local Magaz14 = false
local Magaz15 = false
local Magaz16 = false

local timerMagaz = {u8:decode"Неизвестно", u8:decode"Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", "Неизвестно", }

local oneHour = 3600
local ServerHour = 0
local hour = 0
local hour2 = 0
local minute = 0
local second = 0
local totalSeconds = 0
local InterfacePosition = true

local timerM = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local hourM = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local minuteM = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local secondM = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local totalSecondsM = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local color = {"{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}", "{808080}"}
local MagazTime = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}

local timer = false
local CalibrationA = false
local interface = false

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	repeat wait(0) until sampGetCurrentServerName() ~= 'SA-MP'
	repeat 
		wait(0)
		for id = 0, 2303 do
			if sampTextdrawIsExists(id) and sampTextdrawGetString(id):find('Samp%-Rp.Ru') then
				samp_rp = true
			end
		end
	until samp_rp ~= nil
	_, my_id = sampGetPlayerIdByCharHandle(PLAYER_PED) 
	my_name = sampGetPlayerNickname(my_id)
	server = sampGetCurrentServerName():gsub('|', '')
	server = (server:find('02') and 'Two' or (server:find('Revolution') and 'Revolution' or (server:find('Legacy') and 'Legacy' or (server:find('Classic') and 'Classic' or ''))))
	if server == '' then thisScript():unload() end
	
	sampRegisterChatCommand("lhud", cmd_hud)
	sampRegisterChatCommand('larek', function()
		ShowDialog(1)
	end)
	Wait = lua_thread.create_suspended(Waiting)
	
	AdressConfig = string.format("%s\\moonloader\\config", getGameDirectory())
	AdressLarek = string.format("%s\\moonloader\\config\\Larek", getGameDirectory())
	if not doesDirectoryExist(AdressConfig) then createDirectory(AdressConfig) end
	if not doesDirectoryExist(AdressLarek) then createDirectory(AdressLarek) end
	
	LarekName = string.format('LarekName')
	if ini[LarekName] == nil then
		ini = inicfg.load({
			[LarekName] = {
				Name1  = "Деревня 1",
				Name2  = "Деревня 2",
				Name3  = "Вайнвуд",
				Name4  = "Гетто",
				Name5  = "Чиллиад",
				Name6  = "Квартиры СФ",
				Name7  = "СФ Топ",
				Name8  = "Около фермы",
				Name9  = "СФа",
				Name10 = "СФ Бот",
				Name11 = "Форт Карсон",
				Name12 = "СТО ЛВ",
				Name13 = "ЛВПД",
				Name14 = "МО ЛВ",
				Name15 = "ЛВ Ньюс",
				Name16 = "АММО ЛВ"
			}
		}, directIni)
		inicfg.save(ini, directIni)
	end
	
	LarekConfig = string.format('LarekConfig')
	if ini[LarekConfig] == nil then
		sampAddChatMessage(" [Larek] Откалибруйте время в /larek", main_color)
		ini = inicfg.load({
			[LarekConfig] = {
				time = tonumber(0),
				X = tonumber(0),
				Y = tonumber(0)
			}
		}, directIni)
		inicfg.save(ini, directIni)
	end
	
	LarekMoney = string.format('LarekMoney-%s', my_name)
	if ini2[LarekMoney] == nil then
		ini2 = inicfg.load({
			[LarekMoney] = {
				money  = tonumber(0),
				count  = tonumber(0),
				count1 = tonumber(0),
				count2 = tonumber(0),
				count3 = tonumber(0),
				count4 = tonumber(0)
			}
		}, directIni2)
		inicfg.save(ini2, directIni2)
	end
	
	LarekTime = string.format('LarekTime-Server-%s', server)
	if ini3[LarekTime] == nil then
		ini3 = inicfg.load({
			[LarekTime] = {
				time1 =  "Неизвестно",
				time2 =  "Неизвестно",
				time3 =  "Неизвестно",
				time4 =  "Неизвестно",
				time5 =  "Неизвестно",
				time6 =  "Неизвестно",
				time7 =  "Неизвестно",
				time8 =  "Неизвестно",
				time9 =  "Неизвестно",
				time10 = "Неизвестно",
				time11 = "Неизвестно",
				time12 = "Неизвестно",
				time13 = "Неизвестно",
				time14 = "Неизвестно",
				time15 = "Неизвестно",
				time16 = "Неизвестно"
			}
		}, directIni3)
		inicfg.save(ini3, directIni3)
	end
	
	LarekSeconds = string.format('LarekSeconds-Server-%s', server)
	if ini3[LarekSeconds] == nil then
		ini3 = inicfg.load({
			[LarekSeconds] = {
				time1  = tonumber(0),
				time2  = tonumber(0),
				time3  = tonumber(0),
				time4  = tonumber(0),
				time5  = tonumber(0),
				time6  = tonumber(0),
				time7  = tonumber(0),
				time8  = tonumber(0),
				time9  = tonumber(0),
				time10 = tonumber(0),
				time11 = tonumber(0),
				time12 = tonumber(0),
				time13 = tonumber(0),
				time14 = tonumber(0),
				time15 = tonumber(0),
				time16 = tonumber(0)
			}
		}, directIni3)
		inicfg.save(ini3, directIni3)
	end
	
	ini = inicfg.load(LarekConfig, directIni)
	ini = inicfg.load(LarekName, directIni)
	ini2 = inicfg.load(LarekMoney, directIni2)
	ini3 = inicfg.load(LarekTime, directIni3)
	
	sampAddChatMessage(" [Larek] Успешно загрузился!", main_color)
	
	imgui.ApplyCustomStyle()
	imgui.Process = true
	
	while true do
		wait(0)
		
		imgui.ShowCursor = false
		
		if main_window_state.v == false then
			imgui.Process = false
		end
		
		if interface == true then
			main_window_state.v = true
			imgui.Process = main_window_state.v
		else
			main_window_state.v = false
		end
		
		LarekConfig = string.format('LarekConfig')
		ini = inicfg.load(LarekConfig, directIni)
		hour = os.date("%H") + ini[LarekConfig].time
		hour2 = os.date("%H")
		if hour == -1 then
			hour = 23
		end
		if hour == -2 then
			hour = 22
		end
		if hour == -3 then
			hour = 21
		end
		if hour == -4 then
			hour = 20
		end
		if hour == -5 then
			hour = 23
		end
		if hour == -6 then
			hour = 19
		end
		minute = os.date("%M")
		second = os.date("%S")
		totalSeconds = hour * 3600 + minute * 60 + second
		
		Timer()
		TimerM()
		Refresh()
		
		local caption = sampGetDialogCaption()
		local result, button, list, input = sampHasDialogRespond(1488)
		if caption == 'Larek: Список' then
			if result and button == 1 then
				if dialogLine[list + 1]     ==  '  1. ' .. ini[LarekName].Name1  .. '\t' .. color[1]  .. ini3[LarekTime].time1 then
					ShowDialog(3, dialogTextToList[list + 1], input, false, 'config', 'MagazName1')
				elseif dialogLine[list + 1] ==  '  2. ' .. ini[LarekName].Name2  .. '\t' .. color[2]  .. ini3[LarekTime].time2 then
					ShowDialog(4, dialogTextToList[list + 1], input, false, 'config', 'MagazName2')
				elseif dialogLine[list + 1] ==  '  3. ' .. ini[LarekName].Name3  .. '\t' .. color[3]  .. ini3[LarekTime].time3 then
					ShowDialog(5, dialogTextToList[list + 1], input, false, 'config', 'MagazName3')
				elseif dialogLine[list + 1] ==  '  4. ' .. ini[LarekName].Name4  .. '\t' .. color[4]  .. ini3[LarekTime].time4 then
					ShowDialog(6, dialogTextToList[list + 1], input, false, 'config', 'MagazName4')
				elseif dialogLine[list + 1] ==  '  5. ' .. ini[LarekName].Name5  .. '\t' .. color[5]  .. ini3[LarekTime].time5 then
					ShowDialog(7, dialogTextToList[list + 1], input, false, 'config', 'MagazName5')
				elseif dialogLine[list + 1] ==  '  6. ' .. ini[LarekName].Name6  .. '\t' .. color[6]  .. ini3[LarekTime].time6 then
					ShowDialog(8, dialogTextToList[list + 1], input, false, 'config', 'MagazName6')
				elseif dialogLine[list + 1] ==  '  7. ' .. ini[LarekName].Name7  .. '\t' .. color[7]  .. ini3[LarekTime].time7 then
					ShowDialog(9, dialogTextToList[list + 1], input, false, 'config', 'MagazName7')
				elseif dialogLine[list + 1] ==  '  8. ' .. ini[LarekName].Name8  .. '\t' .. color[8]  .. ini3[LarekTime].time8 then
					ShowDialog(10, dialogTextToList[list + 1], input, false, 'config', 'MagazName8')
				elseif dialogLine[list + 1] ==  '  9. ' .. ini[LarekName].Name9  .. '\t' .. color[9]  .. ini3[LarekTime].time9 then
					ShowDialog(11, dialogTextToList[list + 1], input, false, 'config', 'MagazName9')
				elseif dialogLine[list + 1] ==  ' 10. ' .. ini[LarekName].Name10 .. '\t' .. color[10] .. ini3[LarekTime].time10 then
					ShowDialog(12, dialogTextToList[list + 1], input, false, 'config', 'MagazName10')
				elseif dialogLine[list + 1] ==  ' 11. ' .. ini[LarekName].Name11 .. '\t' .. color[11] .. ini3[LarekTime].time11 then
					ShowDialog(13, dialogTextToList[list + 1], input, false, 'config', 'MagazName11')
				elseif dialogLine[list + 1] ==  ' 12. ' .. ini[LarekName].Name12 .. '\t' .. color[12] .. ini3[LarekTime].time12 then
					ShowDialog(14, dialogTextToList[list + 1], input, false, 'config', 'MagazName12')
				elseif dialogLine[list + 1] ==  ' 13. ' .. ini[LarekName].Name13 .. '\t' .. color[13] .. ini3[LarekTime].time13 then
					ShowDialog(15, dialogTextToList[list + 1], input, false, 'config', 'MagazName13')
				elseif dialogLine[list + 1] ==  ' 14. ' .. ini[LarekName].Name14 .. '\t' .. color[14] .. ini3[LarekTime].time14 then
					ShowDialog(16, dialogTextToList[list + 1], input, false, 'config', 'MagazName14')
				elseif dialogLine[list + 1] ==  ' 15. ' .. ini[LarekName].Name15 .. '\t' .. color[15] .. ini3[LarekTime].time15 then
					ShowDialog(17, dialogTextToList[list + 1], input, false, 'config', 'MagazName15')
				elseif dialogLine[list + 1] ==  ' 16. ' .. ini[LarekName].Name16 .. '\t' .. color[16] .. ini3[LarekTime].time16 then
					ShowDialog(18, dialogTextToList[list + 1], input, false, 'config', 'MagazName16')
				elseif dialogLine[list + 1] == '> Larek HUD\t' .. (interface and '{06940f}ON' or '{d10000}OFF') then
					interface = not interface
					ShowDialog(1)
				elseif dialogLine[list + 1] == '> Фиксация HUDa\t' .. (InterfacePosition and '{06940f}ON' or '{d10000}OFF') then
					InterfacePosition = not InterfacePosition
					inicfg.save(ini, directIni)
					ShowDialog(1)
				elseif dialogLine[list + 1] == '> Разница во времени с Samp-RP\t'  then
					Calibration()
					ShowDialog(1)
					sampAddChatMessage(" [Larek] Время успешно откалибровано", main_color)
				elseif dialogLine[list + 1] == '> Статистика\t'  then
					ShowDialog(19)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1490)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name1 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1491)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name2 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1492)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name3 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1493)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name4 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1494)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name5 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1495)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name6 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1496)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name7 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1497)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name8 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1498)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name9 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1499)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name10 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1500)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name11 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1501)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name12 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1502)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name13 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1503)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name14 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1504)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name15 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1505)
		if caption == "Изменение названия" then
			if result then
				if button == 1 then
					ini[LarekName].Name16 = input
					inicfg.save(ini, directIni)
					sampAddChatMessage(" [Larek] Новое название: {FFFFFF}" .. input, main_color)
					ShowDialog(1)
				else
					ShowDialog(1)
				end
			end
		end
		local result, button, list, input = sampHasDialogRespond(1506)
		if caption == "Статистика" then
			if result then
				if button == 1 then
					ShowDialog(19)
				else
					ShowDialog(1)
				end
			end
		end
	end
end

function cmd_hud(arg)
	interface = not interface
end 

function imgui.ApplyCustomStyle()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
    colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function imgui.TextColoredRGB(text)
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
            else imgui.Text(u8(w)) end
        end
    end

    render_text(text)
end
function imgui.OnDrawFrame()
	if InterfacePosition == true then 
		imgui.SetNextWindowPos(imgui.ImVec2(ini[LarekConfig].X, ini[LarekConfig].Y))
		inicfg.save(ini, directIni)
	end
	--imgui.SetNextWindowPos(imgui.ImVec2(resX/3*2*1.265, (resY/2) - 1/10 * resY))
	imgui.SetNextWindowSize(imgui.ImVec2(resX/8.5, resY/20*6.6))
	
	imgui.Begin("Larek HUD", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
	local pos = imgui.GetWindowPos()
	ini[LarekConfig].X = pos.x
	ini[LarekConfig].Y = pos.y
	inicfg.save(ini, directIni)
	
if ini3[LarekTime].time1 == "Неизвестно" then
		color[1] = "{808080}"
	else
		if timerM[1] == 1 then
			color[1] = "{d10000}"
		else
			color[1] = "{06940f}"
		end
	end
	if ini3[LarekTime].time2 == "Неизвестно" then
		color[2] = "{808080}"
	else
		if timerM[2] == 1 then
			color[2] = "{d10000}"
		else
			color[2] = "{06940f}"
		end
	end
	if ini3[LarekTime].time3 == "Неизвестно" then
		color[3] = "{808080}"
	else
		if timerM[3] == 1 then
			color[3] = "{d10000}"
		else
			color[3] = "{06940f}"
		end
	end
	if ini3[LarekTime].time4 == "Неизвестно" then
		color[4] = "{808080}"
	else
		if timerM[4] == 1 then
			color[4] = "{d10000}"
		else
			color[4] = "{06940f}"
		end
	end
	if ini3[LarekTime].time5 == "Неизвестно" then
		color[5] = "{808080}"
	else
		if timerM[5] == 1 then
			color[5] = "{d10000}"
		else
			color[5] = "{06940f}"
		end
	end
	if ini3[LarekTime].time6 == "Неизвестно" then
		color[6] = "{808080}"
	else
		if timerM[6] == 1 then
			color[6] = "{d10000}"
		else
			color[6] = "{06940f}"
		end
	end
	if ini3[LarekTime].time7 == "Неизвестно" then
		color[7] = "{808080}"
	else
		if timerM[7] == 1 then
			color[7] = "{d10000}"
		else
			color[7] = "{06940f}"
		end
	end
	if ini3[LarekTime].time8 == "Неизвестно" then
		color[8] = "{808080}"
	else
		if timerM[8] == 1 then
			color[8] = "{d10000}"
		else
			color[8] = "{06940f}"
		end
	end
	if ini3[LarekTime].time9 == "Неизвестно" then
		color[9] = "{808080}"
	else
		if timerM[9] == 1 then
			color[9] = "{d10000}"
		else
			color[9] = "{06940f}"
		end
	end
	if ini3[LarekTime].time10 == "Неизвестно" then
		color[10] = "{808080}"
	else
		if timerM[10] == 1 then
			color[10] = "{d10000}"
		else
			color[10] = "{06940f}"
		end
	end
	if ini3[LarekTime].time11 == "Неизвестно" then
		color[11] = "{808080}"
	else
		if timerM[11] == 1 then
			color[11] = "{d10000}"
		else
			color[11] = "{06940f}"
		end
	end
	if ini3[LarekTime].time12 == "Неизвестно" then
		color[12] = "{808080}"
	else
		if timerM[12] == 1 then
			color[12] = "{d10000}"
		else
			color[12] = "{06940f}"
		end
	end
	if ini3[LarekTime].time13 == "Неизвестно" then
		color[13] = "{808080}"
	else
		if timerM[13] == 1 then
			color[13] = "{d10000}"
		else
			color[13] = "{06940f}"
		end
	end
	if ini3[LarekTime].time14 == "Неизвестно" then
		color[14] = "{808080}"
	else
		if timerM[14] == 1 then
			color[14] = "{d10000}"
		else
			color[14] = "{06940f}"
		end
	end
	if ini3[LarekTime].time15 == "Неизвестно" then
		color[15] = "{808080}"
	else
		if timerM[15] == 1 then
			color[15] = "{d10000}"
		else
			color[15] = "{06940f}"
		end
	end
	if ini3[LarekTime].time16 == "Неизвестно" then
		color[16] = "{808080}"
	else
		if timerM[16] == 1 then
			color[16] = "{d10000}"
		else
			color[16] = "{06940f}"
		end
	end	
	
	imgui.TextColoredRGB(u8"1.  " .. ini[LarekName].Name1)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[1] .. ini3[LarekTime].time1)
	imgui.TextColoredRGB(u8"2.  " .. ini[LarekName].Name2)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8""  .. color[2] .. ini3[LarekTime].time2)	
	imgui.TextColoredRGB(u8"3.  " .. ini[LarekName].Name3)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[3] .. ini3[LarekTime].time3)
	imgui.TextColoredRGB(u8"4.  " .. ini[LarekName].Name4)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[4] .. ini3[LarekTime].time4)
	imgui.TextColoredRGB(u8"5.  " .. ini[LarekName].Name5)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[5] .. ini3[LarekTime].time5)
	imgui.TextColoredRGB(u8"6.  " .. ini[LarekName].Name6)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[6] .. ini3[LarekTime].time6)	
	imgui.TextColoredRGB(u8"7.  " .. ini[LarekName].Name7)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[7] .. ini3[LarekTime].time7)	
	imgui.TextColoredRGB(u8"8.  " .. ini[LarekName].Name8)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[8] .. ini3[LarekTime].time8)
	imgui.TextColoredRGB(u8"9.  " .. ini[LarekName].Name9)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[9] .. ini3[LarekTime].time9)
	imgui.TextColoredRGB(u8"10. " .. ini[LarekName].Name10)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[10] .. ini3[LarekTime].time10)
	imgui.TextColoredRGB(u8"11. " .. ini[LarekName].Name11)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[11] .. ini3[LarekTime].time11)
	imgui.TextColoredRGB(u8"12. " .. ini[LarekName].Name12)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[12] .. ini3[LarekTime].time12)	
	imgui.TextColoredRGB(u8"13. " .. ini[LarekName].Name13)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[13] .. ini3[LarekTime].time13)
	imgui.TextColoredRGB(u8"14. " .. ini[LarekName].Name14)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[14] .. ini3[LarekTime].time14)
	imgui.TextColoredRGB(u8"15. " .. ini[LarekName].Name15)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[15] .. ini3[LarekTime].time15)
	imgui.TextColoredRGB(u8"16. " .. ini[LarekName].Name16)
		imgui.SameLine((resX/5) / 3)
	imgui.TextColoredRGB(u8"" .. color[16] .. ini3[LarekTime].time16)	
	imgui.Separator()
	--LarekMoney = string.format('LarekMoney-%s', my_name)
	--ini = inicfg.load(LarekMoney, directIni2)
	imgui.TextColoredRGB("Денег награблено: " .. ini2[LarekMoney].money)
	imgui.TextColoredRGB("Магазинов ограблено: " .. ini2[LarekMoney].count)

	imgui.End()
end

function Waiting()        --1000 = 1 сек
	if timer == true then
		wait(10000)
		timer = false
	end
end
function Timer()
	if timer == false then
		if totalSeconds == ini3[LarekSeconds].time1 then
			MagazTime[1] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time2 then
			MagazTime[2] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time3 then
			MagazTime[3] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time4 then
			MagazTime[4] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time5 then
			MagazTime[5] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time6 then
			MagazTime[6] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time7 then
			MagazTime[7] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time8 then
			MagazTime[8] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time9 then
			MagazTime[9] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time10 then
			MagazTime[10] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time11 then
			MagazTime[11] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time12 then
			MagazTime[12] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time13 then
			MagazTime[13] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time14 then
			MagazTime[14] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time15 then
			MagazTime[15] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
		if totalSeconds == ini3[LarekSeconds].time16 then
			MagazTime[16] = true
			MagazTimeFunction()
			timer = true
			Wait:run()
		end
	end
end

function TimerM()
	if totalSeconds <= ini3[LarekSeconds].time1 then
		timerM[1] = 1
	else
		timerM[1] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time2 then
		timerM[2] = 1
	else
		timerM[2] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time3 then
		timerM[3] = 1
	else
		timerM[3] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time4 then
		timerM[4] = 1
	else
		timerM[4] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time5 then
		timerM[5] = 1
	else
		timerM[5] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time6 then
		timerM[6] = 1
	else
		timerM[6] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time7 then
		timerM[7] = 1
	else
		timerM[7] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time8 then
		timerM[8] = 1
	else
		timerM[8] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time9 then
		timerM[9] = 1
	else
		timerM[9] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time10 then
		timerM[10] = 1
	else
		timerM[10] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time11 then
		timerM[11] = 1
	else
		timerM[11] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time12 then
		timerM[12] = 1
	else
		timerM[12] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time13 then
		timerM[13] = 1
	else
		timerM[13] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time14 then
		timerM[14] = 1
	else
		timerM[14] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time15 then
		timerM[15] = 1
	else
		timerM[15] = 2
	end
	if totalSeconds <= ini3[LarekSeconds].time16 then
		timerM[16] = 1
	else
		timerM[16] = 2
	end
end

function Refresh()
	if math.abs(totalSeconds - ini3[LarekSeconds].time1) > oneHour then
		ini3[LarekSeconds].time1 = 0
		ini3[LarekTime].time1 = "Неизвестно"
		color[1] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time2) > oneHour then
		ini3[LarekSeconds].time2 = 0
		ini3[LarekTime].time2 = "Неизвестно"
		color[2] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time3) > oneHour then
		ini3[LarekSeconds].time3 = 0
		ini3[LarekTime].time3 = "Неизвестно"
		color[3] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time4) > oneHour then
		ini3[LarekSeconds].time4 = 0
		ini3[LarekTime].time4 = "Неизвестно"
		color[4] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time5) > oneHour then
		ini3[LarekSeconds].time5 = 0
		ini3[LarekTime].time5 = "Неизвестно"
		color[5] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time6) > oneHour then
		ini3[LarekSeconds].time6 = 0
		ini3[LarekTime].time6 = "Неизвестно"
		color[6] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time7) > oneHour then
		ini3[LarekSeconds].time7 = 0
		ini3[LarekTime].time7 = "Неизвестно"
		color[7] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time8) > oneHour then
		ini3[LarekSeconds].time8 = 0
		ini3[LarekTime].time8 = "Неизвестно"
		color[8] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time9) > oneHour then
		ini3[LarekSeconds].time9 = 0
		ini3[LarekTime].time9 = "Неизвестно"
		color[9] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time10) > oneHour then
		ini3[LarekSeconds].time10 = 0
		ini3[LarekTime].time10 = "Неизвестно"
		color[10] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time11) > oneHour then
		ini3[LarekSeconds].time11 = 0
		ini3[LarekTime].time11 = "Неизвестно"
		color[11] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time12) > oneHour then
		ini3[LarekSeconds].time12 = 0
		ini3[LarekTime].time12 = "Неизвестно"
		color[12] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time13) > oneHour then
		ini3[LarekSeconds].time13 = 0
		ini3[LarekTime].time13 = "Неизвестно"
		color[13] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time14) > oneHour then
		ini3[LarekSeconds].time14 = 0
		ini3[LarekTime].time14 = "Неизвестно"
		color[14] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time15) > oneHour then
		ini3[LarekSeconds].time15 = 0
		ini3[LarekTime].time15 = "Неизвестно"
		color[15] = "{808080}"
	end
	if math.abs(totalSeconds - ini3[LarekSeconds].time16) > oneHour then
		ini3[LarekSeconds].time16 = 0
		ini3[LarekTime].time16 = "Неизвестно"
		color[16] = "{808080}"
	end
end

function ShowDialog(int, dtext, dinput, string_or_number, ini1, ini2)
	d = {}
	d[1], d[2], d[3], d[4], d[5], d[6] = int, dtext, dinput, string_or_number, ini1, ini2
	
	if ini3[LarekTime].time1 == "Неизвестно" then
		color[1] = "{808080}"
	else
		if timerM[1] == 1 then
			color[1] = "{d10000}"
		else
			color[1] = "{06940f}"
		end
	end
	if ini3[LarekTime].time2 == "Неизвестно" then
		color[2] = "{808080}"
	else
		if timerM[2] == 1 then
			color[2] = "{d10000}"
		else
			color[2] = "{06940f}"
		end
	end
	if ini3[LarekTime].time3 == "Неизвестно" then
		color[3] = "{808080}"
	else
		if timerM[3] == 1 then
			color[3] = "{d10000}"
		else
			color[3] = "{06940f}"
		end
	end
	if ini3[LarekTime].time4 == "Неизвестно" then
		color[4] = "{808080}"
	else
		if timerM[4] == 1 then
			color[4] = "{d10000}"
		else
			color[4] = "{06940f}"
		end
	end
	if ini3[LarekTime].time5 == "Неизвестно" then
		color[5] = "{808080}"
	else
		if timerM[5] == 1 then
			color[5] = "{d10000}"
		else
			color[5] = "{06940f}"
		end
	end
	if ini3[LarekTime].time6 == "Неизвестно" then
		color[6] = "{808080}"
	else
		if timerM[6] == 1 then
			color[6] = "{d10000}"
		else
			color[6] = "{06940f}"
		end
	end
	if ini3[LarekTime].time7 == "Неизвестно" then
		color[7] = "{808080}"
	else
		if timerM[7] == 1 then
			color[7] = "{d10000}"
		else
			color[7] = "{06940f}"
		end
	end
	if ini3[LarekTime].time8 == "Неизвестно" then
		color[8] = "{808080}"
	else
		if timerM[8] == 1 then
			color[8] = "{d10000}"
		else
			color[8] = "{06940f}"
		end
	end
	if ini3[LarekTime].time9 == "Неизвестно" then
		color[9] = "{808080}"
	else
		if timerM[9] == 1 then
			color[9] = "{d10000}"
		else
			color[9] = "{06940f}"
		end
	end
	if ini3[LarekTime].time10 == "Неизвестно" then
		color[10] = "{808080}"
	else
		if timerM[10] == 1 then
			color[10] = "{d10000}"
		else
			color[10] = "{06940f}"
		end
	end
	if ini3[LarekTime].time11 == "Неизвестно" then
		color[11] = "{808080}"
	else
		if timerM[11] == 1 then
			color[11] = "{d10000}"
		else
			color[11] = "{06940f}"
		end
	end
	if ini3[LarekTime].time12 == "Неизвестно" then
		color[12] = "{808080}"
	else
		if timerM[12] == 1 then
			color[12] = "{d10000}"
		else
			color[12] = "{06940f}"
		end
	end
	if ini3[LarekTime].time13 == "Неизвестно" then
		color[13] = "{808080}"
	else
		if timerM[13] == 1 then
			color[13] = "{d10000}"
		else
			color[13] = "{06940f}"
		end
	end
	if ini3[LarekTime].time14 == "Неизвестно" then
		color[14] = "{808080}"
	else
		if timerM[14] == 1 then
			color[14] = "{d10000}"
		else
			color[14] = "{06940f}"
		end
	end
	if ini3[LarekTime].time15 == "Неизвестно" then
		color[15] = "{808080}"
	else
		if timerM[15] == 1 then
			color[15] = "{d10000}"
		else
			color[15] = "{06940f}"
		end
	end
	if ini3[LarekTime].time16 == "Неизвестно" then
		color[16] = "{808080}"
	else
		if timerM[16] == 1 then
			color[16] = "{d10000}"
		else
			color[16] = "{06940f}"
		end
	end
	if int == 1 then
		dialogLine, dialogTextToList = {}, {}
		dialogLine[#dialogLine + 1] = '  1. ' .. ini[LarekName].Name1  .. '\t' .. color[1]  .. ini3[LarekTime].time1
		dialogLine[#dialogLine + 1] = '  2. ' .. ini[LarekName].Name2  .. '\t' .. color[2]  .. ini3[LarekTime].time2
		dialogLine[#dialogLine + 1] = '  3. ' .. ini[LarekName].Name3  .. '\t' .. color[3]  .. ini3[LarekTime].time3
		dialogLine[#dialogLine + 1] = '  4. ' .. ini[LarekName].Name4  .. '\t' .. color[4]  .. ini3[LarekTime].time4
		dialogLine[#dialogLine + 1] = '  5. ' .. ini[LarekName].Name5  .. '\t' .. color[5]  .. ini3[LarekTime].time5
		dialogLine[#dialogLine + 1] = '  6. ' .. ini[LarekName].Name6  .. '\t' .. color[6]  .. ini3[LarekTime].time6
		dialogLine[#dialogLine + 1] = '  7. ' .. ini[LarekName].Name7  .. '\t' .. color[7]  .. ini3[LarekTime].time7
		dialogLine[#dialogLine + 1] = '  8. ' .. ini[LarekName].Name8  .. '\t' .. color[8]  .. ini3[LarekTime].time8
		dialogLine[#dialogLine + 1] = '  9. ' .. ini[LarekName].Name9  .. '\t' .. color[9]  .. ini3[LarekTime].time9
		dialogLine[#dialogLine + 1] = ' 10. ' .. ini[LarekName].Name10 .. '\t' .. color[10] .. ini3[LarekTime].time10
		dialogLine[#dialogLine + 1] = ' 11. ' .. ini[LarekName].Name11 .. '\t' .. color[11] .. ini3[LarekTime].time11
		dialogLine[#dialogLine + 1] = ' 12. ' .. ini[LarekName].Name12 .. '\t' .. color[12] .. ini3[LarekTime].time12
		dialogLine[#dialogLine + 1] = ' 13. ' .. ini[LarekName].Name13 .. '\t' .. color[13] .. ini3[LarekTime].time13
		dialogLine[#dialogLine + 1] = ' 14. ' .. ini[LarekName].Name14 .. '\t' .. color[14] .. ini3[LarekTime].time14
		dialogLine[#dialogLine + 1] = ' 15. ' .. ini[LarekName].Name15 .. '\t' .. color[15] .. ini3[LarekTime].time15
		dialogLine[#dialogLine + 1] = ' 16. ' .. ini[LarekName].Name16 .. '\t' .. color[16] .. ini3[LarekTime].time16
		dialogLine[#dialogLine + 1] = '> Larek HUD\t' .. (interface and '{06940f}ON' or '{d10000}OFF')
		dialogLine[#dialogLine + 1] = '> Фиксация HUDa\t' .. (InterfacePosition and '{06940f}ON' or '{d10000}OFF')
		dialogLine[#dialogLine + 1] = '> Разница во времени с Samp-RP\t'
		dialogLine[#dialogLine + 1] = '> Статистика\t'
		
		local text = ""
		for k,v in pairs(dialogLine) do
			text = text..v.."\n"
		end
		sampShowDialog(1488, 'Larek: Список', text, "Выбрать", "Выход", 4)
	end
	if int == 3 then
		sampShowDialog(1490, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 4 then
		sampShowDialog(1491, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 5 then
		sampShowDialog(1492, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 6 then
		sampShowDialog(1493, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 7 then
		sampShowDialog(1494, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 8 then
		sampShowDialog(1495, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 9 then
		sampShowDialog(1496, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 10 then
		sampShowDialog(1497, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 11 then
		sampShowDialog(1498, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 12 then
		sampShowDialog(1499, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 13 then
		sampShowDialog(1500, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 14 then
		sampShowDialog(1501, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 15 then
		sampShowDialog(1502, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 16 then
		sampShowDialog(1503, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 17 then
		sampShowDialog(1504, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 18 then
		sampShowDialog(1505, "Изменение названия", dtext, "Выбрать", "Назад", 1)
	end
	if int == 19 then
		LarekMoney = string.format('LarekMoney-%s', my_name)
		ini2 = inicfg.load(LarekMoney, directIni2)
		sampShowDialog(1506, 'Статистика', "Денег награблено: \t" .. ini2[LarekMoney].money .. "\nМагазинов ограблено: \t" .. ini2[LarekMoney].count
		.. "\nОграблений в 2: \t" .. ini2[LarekMoney].count2 .. "\nОграблений в 3: \t" .. ini2[LarekMoney].count3 .. "\nОграблений в 4: \t" .. ini2[LarekMoney].count4 .. "\nОграблений в 1: \t" .. ini2[LarekMoney].count1, "Выбрать", "Выход", 4)
	end
end

function MagazTimeFunction()
	if MagazTime[1] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name1 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[1] = false
	end
	if MagazTime[2] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name2 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[2] = false
	end
	if MagazTime[3] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name3 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[3] = false
	end
	if MagazTime[4] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name4 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[4] = false
	end
	if MagazTime[5] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name5 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[5] = false
	end
	if MagazTime[6] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name6 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[6] = false
	end
	if MagazTime[7] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name7 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[7] = false
	end
	if MagazTime[8] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name8 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[8] = false
	end
	if MagazTime[9] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name9 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[9] = false
	end
	if MagazTime[10] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name10 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[10] = false
	end
	if MagazTime[11] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name11 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[11] = false
	end
	if MagazTime[12] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name12 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[12] = false
	end
	if MagazTime[13] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name13 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[13] = false
	end
	if MagazTime[14] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name14 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[14] = false
	end
	if MagazTime[15] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name15 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[15] = false
	end
	if MagazTime[16] == true then
		sampAddChatMessage(" [Larek] Ларёк {FFFFFF}" .. ini[LarekName].Name16 .. " {FF0000}снова доступен для ограбления!", main_color)
		MagazTime[16] = false
	end
end

function sampev.onSendPickedUpPickup(pickupId)
	if pickupId == 1039 then  -- вошел
		Magaz1 = true
	end
	if pickupId == 1040 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then  -- вышел
		Magaz1 = false
	end
	if pickupId == 1037 then  
		Magaz2 = true
	end
	if pickupId == 1038 or pickupId == 1039 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then  
		Magaz2 = false
	end
	if pickupId == 979 then   
		Magaz3 = true
	end
	if pickupId == 980 or pickupId == 1039 or pickupId == 1037 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then
		Magaz3 = false
	end
	if pickupId == 977 then   
		Magaz4 = true
	end
	if pickupId == 978 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then 
		Magaz4 = false
	end
	if pickupId == 983 then   
		Magaz5 = true
	end
	if pickupId == 984 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then 
		Magaz5 = false
	end
	if pickupId == 1035 then   
		Magaz6 = true
	end
	if pickupId == 1036 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then 
		Magaz6 = false
	end
	if pickupId == 987 then  
		Magaz7 = true
	end
	if pickupId == 988 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then 
		Magaz7 = false
	end
	if pickupId == 981 then   
		Magaz8 = true
	end
	if pickupId == 982 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then 
		Magaz8 = false
	end
	if pickupId == 985 then   
		Magaz9 = true
	end
	if pickupId == 986 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then 
		Magaz9 = false
	end
	if pickupId == 1033 then  
		Magaz10 = true
	end
	if pickupId == 1034 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then 
		Magaz10 = false
	end
	if pickupId == 1031 then  
		Magaz11 = true
	end
	if pickupId == 1032 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then 
		Magaz11 = false
	end
	if pickupId == 1019 then  
		Magaz12 = true
	end
	if pickupId == 1020 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then 
		Magaz12 = false
	end
	if pickupId == 1025 then  
		Magaz13 = true
	end
	if pickupId == 1026 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1021 or pickupId == 1023 or pickupId == 1029 then 
		Magaz13 = false
	end
	if pickupId == 1021 then  
		Magaz14 = true
	end
	if pickupId == 1022 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1023 or pickupId == 1029 then 
		Magaz14 = false
	end
	if pickupId == 1023 then  
		Magaz15 = true
	end
	if pickupId == 1024 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1029 then 
		Magaz15 = false
	end
	if pickupId == 1029 then   
		Magaz16 = true
	end
	if pickupId == 1030 or pickupId == 1039 or pickupId == 1037 or pickupId == 979 or pickupId == 977 or pickupId == 983 or pickupId == 1035 or pickupId == 987 or pickupId == 981 or pickupId == 985 or pickupId == 1033 or pickupId == 1031 or pickupId == 1019 or pickupId == 1025 or pickupId == 1021 or pickupId == 1023 then 
		Magaz16 = false
	end
end

function sampev.onServerMessage(color, text)
	if Magaz1 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[1] =  string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time1 = timerMagaz[1]
				inicfg.save(ini3, directIni3)
			hourM[1], minuteM[1], secondM[1] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time1 = hourM[1] * 3600 + minuteM[1] * 60 + secondM[1]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz2 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[2] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time2 = timerMagaz[2]
				inicfg.save(ini3, directIni3)
			hourM[2], minuteM[2], secondM[2] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time2 = hourM[2] * 3600 + minuteM[2] * 60 + secondM[2]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz3 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[3] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time3 = timerMagaz[3]
				inicfg.save(ini3, directIni3)
			hourM[3], minuteM[3], secondM[3] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time3 = hourM[3] * 3600 + minuteM[3] * 60 + secondM[3]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz4 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[4] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time4 = timerMagaz[4]
				inicfg.save(ini3, directIni3)
			hourM[4], minuteM[4], secondM[4] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time4 = hourM[4] * 3600 + minuteM[4] * 60 + secondM[4]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz5 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[5] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time5 = timerMagaz[5]
				inicfg.save(ini3, directIni3)
			hourM[5], minuteM[5], secondM[5] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time5 = hourM[5] * 3600 + minuteM[5] * 60 + secondM[5]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz6 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[6] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time6 = timerMagaz[6]
				inicfg.save(ini3, directIni3)
			hourM[6], minuteM[6], secondM[6] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time6 = hourM[6] * 3600 + minuteM[6] * 60 + secondM[6]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz7 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[7] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time7 = timerMagaz[7]
				inicfg.save(ini3, directIni3)
			hourM[7], minuteM[7], secondM[7] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time7 = hourM[7] * 3600 + minuteM[7] * 60 + secondM[7]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz8 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[8] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time8 = timerMagaz[8]
				inicfg.save(ini3, directIni3)
			hourM[8], minuteM[8], secondM[8] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time8 = hourM[8] * 3600 + minuteM[8] * 60 + secondM[8]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz9 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[9] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time9 = timerMagaz[9]
				inicfg.save(ini3, directIni3)
			hourM[9], minuteM[9], secondM[9] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time9 = hourM[9] * 3600 + minuteM[9] * 60 + secondM[9]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz10 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[10] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time10 = timerMagaz[10]
				inicfg.save(ini3, directIni3)
			hourM[10], minuteM[10], secondM[10] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time10 = hourM[10] * 3600 + minuteM[10] * 60 + secondM[10]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz11 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[11] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time11 = timerMagaz[11]
				inicfg.save(ini3, directIni3)
			hourM[11], minuteM[11], secondM[11] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time11 = hourM[11] * 3600 + minuteM[11] * 60 + secondM[11]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz12 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[12] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time12 = timerMagaz[12]
				inicfg.save(ini3, directIni3)
			hourM[12], minuteM[12], secondM[12] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time12 = hourM[12] * 3600 + minuteM[12] * 60 + secondM[12]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz13 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[13] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time13 = timerMagaz[13]
				inicfg.save(ini3, directIni3)
			hourM[13], minuteM[13], secondM[13] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time13 = hourM[13] * 3600 + minuteM[13] * 60 + secondM[13]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz14 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[14] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time14 = timerMagaz[14]
				inicfg.save(ini3, directIni3)
			hourM[14], minuteM[14], secondM[14] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time14 = hourM[14] * 3600 + minuteM[14] * 60 + secondM[14]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz15 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[15] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time15 = timerMagaz[15]
				inicfg.save(ini3, directIni3)
			hourM[15], minuteM[15], secondM[15] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time15 = hourM[15] * 3600 + minuteM[15] * 60 + secondM[15]
			inicfg.save(ini3, directIni3)
		end
	end
	if Magaz16 == true then
		if string.find(text, " Следующее ограбление будет доступно в .+") then
			timerMagaz[16] = string.match(text, " Следующее ограбление будет доступно в (.+)")
				ini3[LarekTime].time16 = timerMagaz[16]
				inicfg.save(ini3, directIni3)
			hourM[16], minuteM[16], secondM[16] =  string.match(text, " Следующее ограбление будет доступно в (%d+)[^%d]+(%d+)[^%d]+(%d+)")
			ini3[LarekSeconds].time16 = hourM[16] * 3600 + minuteM[16] * 60 + secondM[16]
			inicfg.save(ini3, directIni3)
		end
	end
end

function sampev.onDisplayGameText(style, time, text)
	if string.find(text, "$5000") then
		ini2[LarekMoney].money  = ini2[LarekMoney].money + 5000
		ini2[LarekMoney].count  = ini2[LarekMoney].count + 1
		ini2[LarekMoney].count2 = ini2[LarekMoney].count2 + 1
		inicfg.save(ini2, directIni2)
	end
	if string.find(text, "$3333") then
		ini2[LarekMoney].money  = ini2[LarekMoney].money + 3333
		ini2[LarekMoney].count  = ini2[LarekMoney].count + 1
		ini2[LarekMoney].count3 = ini2[LarekMoney].count3 + 1
		inicfg.save(ini2, directIni2)
	end
	if string.find(text, "$2500") then
		ini2[LarekMoney].money  = ini2[LarekMoney].money + 2500
		ini2[LarekMoney].count  = ini2[LarekMoney].count + 1
		ini2[LarekMoney].count4 = ini2[LarekMoney].count4 + 1
		inicfg.save(ini2, directIni2)
	end
	if string.find(text, "$10000") then
		ini2[LarekMoney].money  = ini2[LarekMoney].money + 10000
		ini2[LarekMoney].count  = ini2[LarekMoney].count + 1
		ini2[LarekMoney].count1 = ini2[LarekMoney].count1 + 1
		iinicfg.save(ini2, directIni2)
	end
	if CalibrationA == true then
		if string.find(text, "%d:%d") then
			ServerHour = string.match(text, "(%d+):")
			ini[LarekConfig].time = ServerHour - hour2
			inicfg.save(ini, directIni)
		end
		CalibrationA = false
	end
end

function Calibration()
	CalibrationA = true
	sampSendChat("/time")
end

function update()
  downloadUrlToFile("https://raw.githubusercontent.com/21se/Taximate/master/taximate.lua", thisScript().path, function(_, status, _, _)
    if status == 6 then
			sampAddChatMessage(' [Larek] {FFFFFF}Скрипт обновлён', main_color)
      thisScript():reload()
    end
  end)
end