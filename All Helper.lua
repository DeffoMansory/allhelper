script_name('All Helper')
script_author('New Blood')
script_version('29.03.2025')
script_version = 4
script_description('for owner')

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Îáíàðóæåíî îáíîâëåíèå. Ïûòàþñü îáíîâèòüñÿ c '..thisScript().version..' íà '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Çàãðóæåíî %d èç %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Çàãðóçêà îáíîâëåíèÿ çàâåðøåíà.')sampAddChatMessage(b..'Îáíîâëåíèå çàâåðøåíî!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Îáíîâëåíèå ïðîøëî íåóäà÷íî. Çàïóñêàþ óñòàðåâøóþ âåðñèþ..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Îáíîâëåíèå íå òðåáóåòñÿ.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Íå ìîãó ïðîâåðèòü îáíîâëåíèå. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, âûõîäèì èç îæèäàíèÿ ïðîâåðêè îáíîâëåíèÿ. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/DeffoMansory/allhelper/refs/heads/main/version.json" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = ""
        end
    end
end

----------------- LIBS ----------------- 
require('lib.moonloader')
local imgui = require 'mimgui'
local event = require 'lib.samp.events'
local encoding = require 'encoding'
local ad = require 'ADDONS'
local ffi = require 'ffi'
local memory = require 'memory'
local faicons = require 'fAwesome6'
local inicfg = require 'inicfg'
local json = require('dkjson')

----------------- LIBS ----------------- 
-------------------- OTHER -----------------
local ass = require('moonloader').audiostream_state
local u8 = encoding.UTF8
local str, sizeof = ffi.string, ffi.sizeof
local new = imgui.new 
encoding.default = 'CP1251'

local search = imgui.new.char[256]()
----------------- OTHER -----------------
---
local directIni = 'AllHelperThemes.ini'
local ini = inicfg.load(inicfg.load({
	styleTheme ={
		theme = 0
    },
}, directIni))
inicfg.save(ini, directIni)
local colorListNumber = new.int(ini.styleTheme.theme)
local colorList = {u8'Êëàññè÷åñêèé', u8'Ñèíèé', u8'Ñèíèé v2', u8'Ò¸ìíûé', u8'SoftBlue', u8'SoftOrange', u8'SoftGrey', u8'SoftGreen', u8'SoftRed', u8'SoftBlack'}
local colorListBuffer = imgui.new['const char*'][#colorList](colorList)

function onScriptTerminate(s)
    if s == thisScript() then
		ini.styleTheme.theme = colorListNumber[0]
		inicfg.save(ini, directIni)
    end
end

---
local directConfig = getWorkingDirectory()..'/config/allhelper.json'
print(getWorkingDirectory())
local defaultTable =
{
	['settings'] =
	{	
		['password'] = '',
		['autologin'] = false,
		['apassword'] = '',
		['autoalogin'] = false,
		['ahi'] = false,
		['fastnicks'] = false,
		['chatID'] = false,
		['antiafk'] = false,
		['reloginblock'] = false,
		['getblock'] = false,
		['atp'] = false,
		['shortadm'] = false,
		['akv'] = false,
		['ftp'] = false,
		['autogm'] = false,
		['autoears'] = false,
		['autoleader'] = false,
		['autoconnect'] = false,
		['autoainfo'] = false,
		['leaderid'] = 1,
		['dellServerMessages'] = false,
		['msginfo'] = false,
		['dellacces'] = false,
		['pgetip'] = false
	}
}
local sconfig = {}

if not doesFileExist(directConfig) then
	conf = assert(io.open(directConfig, 'w'), 'No permission to create file')
	conf:write(encodeJson(defaultTable))
	conf:close()
end
conf = io.open(directConfig, 'r')
local config = decodeJson(conf:read("*a"))
conf:close()
if type(config) ~= 'table' then config = defaultTable 
else
	for i, v in pairs(defaultTable) do
		if type(config[i]) == 'table' then
			for i1, v1 in pairs(defaultTable[i]) do
				if type(config[i][i1]) ~= type(v1) then config[i][i1] = v1 end
			end
		elseif type(config[i]) ~= type(v) then config[i] = v end
	end
end
conf = io.open(directConfig, 'w')
conf:write(encodeJson(config))
conf:close()

local elements =
{
	buffer =
	{
		password = new.char[32](config['settings']['password']),
		apassword = new.char[16](config['settings']['apassword'])
	},
	value =
	{
		autologin = new.bool(config['settings']['autologin']),
		autoalogin = new.bool(config['settings']['autoalogin']),
		ahi = new.bool(config['settings']['ahi']),
		fastnicks = new.bool(config['settings']['fastnicks']),
		chatID = new.bool(config['settings']['chatID']),
		antiafk = new.bool(config['settings']['antiafk']),
		reloginblock = new.bool(config['settings']['reloginblock']),
		getblock = new.bool(config['settings']['getblock']),
		atp = new.bool(config['settings']['atp']),
		shortadm = new.bool(config['settings']['shortadm']),
		akv = new.bool(config['settings']['akv']),
		ftp = new.bool(config['settings']['ftp']),
		autogm = new.bool(config['settings']['autogm']),
		autoleader = new.bool(config['settings']['autoleader']),
		autoears = new.bool(config['settings']['autoears']),
		autoconnect = new.bool(config['settings']['autoconnect']),
		autoainfo = new.bool(config['settings']['autoainfo']),
		leaderid = new.int(config['settings']['leaderid']-1),
		dellServerMessages = new.bool(config['settings']['dellServerMessages']),
		msginfo = new.bool(config['settings']['msginfo']),
		dellacces = new.bool(config['settings']['dellacces']),
		pgetip = new.bool(config['settings']['pgetip'])
	}
}
----------------- WINDOW -----------------
local menu 			    = imgui.new.bool()
local setWindow 		= imgui.new.bool()
local punishMenu 		= imgui.new.bool()
----------------- WINDOW -----------------

----------------- INPUT -----------------
local input_nameawarn   = imgui.new.char[128]()
local input_namelwarn   = imgui.new.char[128]()
local input_nameswarn   = imgui.new.char[128]()
local input_setleader   = imgui.new.char[64](-1)
local input_setsupport  = imgui.new.char[64](-1) 
local input_name 	    = imgui.new.char[128]()
local input_id 		    = imgui.new.char[128]()
local set_namemp	    = imgui.new.char[128]()
local set_priz		    = imgui.new.char[128]()
----------------- INPUT -----------------
---
-------------------- COMBO -----------------
local present 		    = new.int()
----------------- COMBO -----------------
---
----------------- SLIDER -----------------
local SliderOne  	   = new.int(-1) 
----------------- SLIDER -----------------

----------------- COMBO ITEM -----------------
local presentlist = {u8'Real Money (/rdonate)', u8'Gold Coins (Çîëîòûå ìîåíòû)', 'F-Coins (/fcoins)', 'Donate Points (/donate)', u8'Color Ore (Öâåòíàÿ ðóäà)'}
local ImPresent = imgui.new['const char*'][#presentlist](presentlist)
----------------- COMBO ITEM -----------------

local WhiteAccessories = {}

local commandsList =
{
	{'/alh', 'îòêðûòü ãëàâíîå ìåíþ õåëïåðà'},
	{'/amp', 'çàìåíà /mp, åñëè îíà íå ðàáîòàåò'},
	{'/amsg', 'îòïðàâêà MSG ñîîáùåíèé (Íàñòðîéêè)'},
	{'/arec', 'ïåðåçàõîä íà ñåðâåð'},
	{'/recname', 'ïåðåçàõîä ñ óêàçàííûì íèêîì'},
	{'/punish', 'áîëüøàÿ ÷àñòü ïðàâèë â îäíîì îêíå'}
}

local amsg1 =
{
	{'/msg Óâàæàåìûå èãðîêè. Íàïîìèíàþ âàì, ÷òî..'},
	{'/msg Êàæäûé äåíü, â 17:00 ïî ÌÑÊ ïðîõîäèò ðàçäà÷à 50-òè äîíàò ðóáëåé (/donat).'},
	{'/msg Â 19:00 ïðîõîäèò ìåðîïðèÿòèå íà 50 ðåàëüíûõ ðóáëåé (/rdonate).'},
}

local amsg2 =
{
	{'/msg Óâàæàåìûå èãðîêè. Õî÷ó âàì íàïîìíèòü.. Åñëè âû óâèäåëè ÷èòåðà  îïîâåñòèòå àäìèíèñòðàöèþ (/rep).'},
	{'/msg Ïîêàçàëîñü, ÷òî êòî-òî âåä¸ò ñåáÿ ïîäîçðèòåëüíî è îí íå âëàäåëåö àêêàóíòà  îïîâåñòèòå àäìèíèñòðàöèþ (/rep).'},
	{'/msg Íàïîìèíàþ, ÷òî çà ëîæíóþ ïîäà÷ó èíôîðìàöèè âû ìîæåòå ïîëó÷èòü áëîêèðîâêó ðåïîðòà çà offtop (Îò 1 äî 30 ìèíóò).'}
}
		
local lastUpdate =
{
	{'{ffcc00}28.03.2025 {ffffff} ìèíè-îáíîâëåíèå. {ffcc00}Âåðñèÿ: 3.50'},
	{'{ffffff} Áûëî äîáàâëåíî àâòîìàòè÷åñêîå ïðîáèòèå pgetip ïî getip'},
	{'×òîáû àêòèâèðîâàòü âîçìîæíîñòü  ïåðåéäèòå â "Íàñòðîéêè" > "Àâòî-ïðîáèòèå pgetip ïî getip"'},
	{'{ffcc00}09.03.2025 {ffffff} îáíîâëåíèå. {ffcc00}Âåðñèÿ: 3.40'},
	{'{ffffff} Áûë èçìåí¸í äèçàéí ãëàâíîãî ìåíþ ñêðèïòà'},
	{' Áûë äîáàâëåí ñïèñîê þçåðîâ èìåþùèõ äîñòóï ê ñêðèïòó'},
	{' Äîáàâëåí íîâûé ðàçäåë "Äðóãîå"'},
	{' Áûëè ïåðåíåñåíû íåêîòîðûå ôóíêöèè èç ðàçäåëà "Íàñòðîéêè" â "Äðóãîå"'},
	{' Äîáàâëåíà âîçìîæíîñòü ìåíÿ öâåò òåìû ñêðèïòà'},
	{' Èñïðàâëåíà îøèáêà ñ âûäà÷åé ëèäåðêè ÷åðåç êíîïêó "Âûäà÷à äîëæíîñòè"'},
	{'{ffcc00}08.03.2025 {ffffff} ìèíè-îáíîâëåíèå. {ffcc00}Âåðñèÿ: 3.30'},
	{'{ffffff} Áûëè çàìåíåíû è äîáàâëåíû íåêîòîðûå èêîíêè â ñêðèïòå'},
	{' Èçìåíåíû ðàçìåðû êíîïîê â ðàçäåëå "Ïðîâåäåíèå îòáîðà"'},
	{' Èñïðàâëåí áàã îòêðûòèÿ ìåíþ âûäà÷è äîëæíîñòè'},
	{' Èñïðàâëåíû ðàçìåðû îêíà ìåíþ âûäà÷è äîëæíîñòè'}
}

local updateText = ""
for _, update in ipairs(lastUpdate) do
    updateText = updateText .. update[1] .. "\n"
end

local afracNames =
{
	{1, 'LSPD'},
	{2, 'ÔÁÐ'},
	{3, 'Àðìèÿ ËÑ'},
	{4, 'Áîëüíèöà'},
	{5, 'La Cosa Nostra'},
	{6, 'Yakuza'},
	{7, 'Ìýðèÿ'},
	{11, 'Warlocks MC'},
	{12, 'The Ballas'},
	{13, 'Los Santos Vagos'},
	{14, 'Russian Mafia'},
	{15, 'Grove Street'},
	{16, 'San News'},
	{17, 'Varios Los Aztecas'},
	{18, 'The Rifa'},
	{23, 'Hitmans Agency'},
	{25, 'S.W.A.T'},
	{26, 'Ïðàâèòåëüñòâî'}
}
local autoleaderCombo = (function()
    local names = {}
    for _, frac in ipairs(afracNames) do
        table.insert(names, u8(frac[2]))
    end
    return table.concat(names, '\0')
end)()

local fracNames = {
    {0, 'No selected'},
    {1, 'LSPD'},
    {2, 'FBI'},
    {3, 'Army LS'},
    {4, 'Hospital LS'},
    {5, 'La Cosa Nostra'},
    {6, 'Yakuza'},
    {7, 'Mayor'},
    {11, 'Warlocks MC'},
    {12, 'The Ballas'},
    {13, 'Los Santos Vagos'},
    {14, 'Russian Mafia'},
    {15, 'Grove Street'},
    {16, 'San News'},
    {17, 'Varios Los Aztecas'},
    {18, 'The Rifa'},
    {23, 'Hitmans Agency'},
    {25, 'S.W.A.T'},
    {26, 'Government'}
};

local comboStr = (function()
    local names = {};
    for _, frac in ipairs(fracNames) do
        table.insert(names, frac[2]);
    end
    return table.concat(names, '\0');
end)();

local selected = imgui.new.int(0);

local menuSwitch = 0
local punishSwitch = 0

local inputTexts = {
    imgui.new.char[256](),
    imgui.new.char[256](),
    imgui.new.char[256](),
    imgui.new.char[256](),
    imgui.new.char[256]()
}
local inputDelays = {
    imgui.new.char[6](),
    imgui.new.char[6](),
    imgui.new.char[6](),
    imgui.new.char[6](),
    imgui.new.char[6]()
}
local inputButtons = {
    new.bool(false),
    new.bool(false),
    new.bool(false),
    new.bool(false),
    new.bool(false)
}
local floodActive = { false, false, false, false }
local saveFilePath = getGameDirectory() .. '\\moonloader\\config\\flooder.json'

local function loadTextFromJson()
    local file = io.open(saveFilePath, 'r')
    if file then
        local content = file:read('*a')
        file:close()
        local data = json.decode(content)
        if data then
            for i = 1, 5 do
                if data["text" .. i] then
                    ffi.copy(inputTexts[i], u8:encode(data["text" .. i]))
                end
                if data["delay" .. i] then
                    ffi.copy(inputDelays[i], u8:encode(data["delay" .. i]))
                end
            end
        end
    end
end

local function saveTextToJson()
    local data = {}
    for i = 1, 5 do
        data["text" .. i] = u8:decode(str(inputTexts[i]))
        data["delay" .. i] = u8:decode(str(inputDelays[i]))
    end
    local file = io.open(saveFilePath, 'w')
    if file then
        file:write(json.encode(data, { indent = true }))
        file:close()
    else
        sampAddChatMessage('[AllHelper]: {FFFFFF}Îøèáêà ñîõðàíåíèÿ òåêñòà!', 0x696969)
    end
end

local function floodLogic(index)
    while floodActive[index] do
        local delay = tonumber(str(inputDelays[index]))
        if not delay or delay <= 0 then
            sampAddChatMessage(string.format('[AllHelper]: {FFFFFF}Óñòàíîâèòå çàäåðæêó äëÿ òåêñòà %d!', index), 0x696969)
            floodActive[index] = false
            inputButtons[index][0] = false
            break
        end
        local message = u8:decode(str(inputTexts[index]))
        if message ~= '' then
            sampSendChat(message)
        end
        wait(delay * 1000)
    end
end
----------------- INICFG -----------------
---
----------------- INICFG -----------------
local delltext = {'Ace_Will', 'attractive-rp.ru', 'SAN', 'SAN', 'ñàéòå', 'Ïîäñêàçêà', '/vacancy', '.* îòïðàâèë VIP ïîëüçîâàòåëü %w+_%w+%[%d+%]'}
----------------- NAVIGATION LIST -----------------
local navigation = {
    current = 1,
    list = {u8'Îñíîâíîå ìåíþ', u8'Ãîñ. ñòðóêòóðû', u8'Ñàïïîðòû', u8'Ãåòòî', u8'Ìàôèè'}
}
local gos_navigation = {
	current = 1,
	list = {u8'Ïîëèöèÿ | ÔÁÐ', u8'ÀÏ | Ìýðèÿ', u8' San-News', u8'Áîëüíèöà'}
}
local mafia_navigation = {
	current = 1,
	list = {u8'LCN | Yakuza | Russian Mafia | Warlocks MC', u8'Hitmans Agency'}
}
local mp_navigation = {
    current = 1,
    list = {u8"Ìåíþ íàñòðîåê îïîâåùåíèé", u8"Ñïèñîê è ïðàâèëà ìåðîïðèÿòèé"}
}
local warn_navigation = {
    current = 1,
    list = {u8"Àäìèíèñòðàöèÿ", u8"Ëèäåðû", u8"Ñàïïîðòû"}
}
local punish_navigation = {
    current = 1,
    list = {u8'Ïðàâèëà âûäà÷è íàêàçàíèé',u8'Ïðàâèëà äëÿ àäìèíèñòðàöèè',u8'Ïðàâèëà äëÿ ëèäåðîâ '}
}

local nickList = {}

----------------- NAVIGATION LIST -----------------
local AllWindows = imgui.OnFrame(function() return menu[0] end, function()
	if menuSwitch == 0 then
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 660, 389
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.PushFont(myFont)
		imgui.Begin(faicons(u8'SHIELD_CHECK')..u8' All Helper', menu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)--imgui.WindowFlags.NoDecoration)
		imgui.CenterText(faicons(u8'SHIELD_CHECK')..u8' All Helper')
		imgui.SameLine(0,259)
		ad.CloseButton('MainClose', menu, 25)
		imgui.BeginChild('##menu', imgui.ImVec2(325,168), 1)
		if imgui.Button(faicons(u8'CROWN')..u8' Ïðîâåäåíèå îòáîðà ', imgui.ImVec2(150, 35)) then
			menuSwitch = 1
		end
		imgui.SameLine()
		if imgui.Button(faicons(u8'GIFT')..u8' Ïðîâåäåíèå ÌÏ      ', imgui.ImVec2(150, 35)) then
			menuSwitch = 2
		end
		-- if imgui.Button(faicons(u8'USER')..u8' Âûäà÷à âûãîâîðîâ      ', imgui.ImVec2(150, 35)) then
		if imgui.Button(faicons(u8'LIGHT_EMERGENCY_ON')..u8' Âûäà÷à âûãîâîðîâ      ', imgui.ImVec2(150, 35)) then
			menuSwitch = 4
		end
		imgui.SameLine()
		if imgui.Button(faicons(u8'FOLDERS')..u8' Ôëóäåð                 ', imgui.ImVec2(150, 35)) then
			menuSwitch = 5
		end
		if imgui.Button(faicons(u8'GEAR')..u8' Íàñòðîéêè              ', imgui.ImVec2(150, 35)) then
			menuSwitch = 3
		end
		imgui.SameLine()
		if imgui.Button(faicons(u8'SPARKLES')..u8' Äðóãîå		              ', imgui.ImVec2(150, 35)) then
			menuSwitch = 6
		end
		if imgui.Button(faicons(u8'PAPER_PLANE')..u8' Îáðàòíàÿ ñâÿçü      ', imgui.ImVec2(150, 35)) then
			os.execute(('explorer.exe "%s"'):format("https://vk.com/number1241"))
		end
		imgui.SameLine()
		if imgui.Button(faicons(u8'CIRCLE_INFO')..u8' Ïîñëåä. îáíîâëåíèå      ', imgui.ImVec2(150, 35)) then
			menu[0] = false
			printStyledString(cyrillic("Ïîñëåäíåå îáíîâëåíèå âûøëî ~g~28.03.2025"), 1500, 5)
			sampShowDialog(1914, 'Ñïèñîê èçìåíåíèé', updateText, 'Çàêðûòü', '', 0)
		end
		imgui.EndChild()
		imgui.SameLine(335)
		imgui.BeginChild('##menuDes', imgui.ImVec2(317,168), 1)
		imgui.CenterText(faicons(u8'SQUARE_INFO')..u8' Èíôîðìàöèÿ î ñêðèïòå')
		imgui.Separator()
		imgui.CenterText(u8'Âåðñèÿ: 4.00')
		imgui.CenterText(u8'Òèï: X')
		imgui.CenterText(u8'Ðàçðàáîò÷èê: New_Blood')
		imgui.Separator()
		imgui.CenterText(faicons(u8'ADDRESS_CARD')..u8' Þçåðû ñêðèïòà')
		imgui.Separator()
		imgui.CenterText(u8'Orlando_BlackStar, Burger_Endless')
		-- if #nickList > 0 then
		-- 	for _, playerNick in ipairs(nickList) do
		-- 		imgui.CenterText(playerNick)  -- Âûâîäèì êàæäûé íèê
		-- 	end
		-- else
		-- 	imgui.CenterText(u8"Ñïèñîê íèêîâ ïóñò.")
		-- end
		imgui.EndChild()
		imgui.BeginChild('##menuDes2', imgui.ImVec2(640,150), 0)
		imgui.CenterText(faicons(u8'SEAL_QUESTION')..u8' Ïîìîùü')
		imgui.Separator()
		for i=1, #commandsList do
			imgui.CenterText(u8(commandsList[i][1] .. "  " .. commandsList[i][2]))
		end
		imgui.EndChild()
		imgui.PopFont()
		imgui.End()
	elseif menuSwitch == 1 then
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 925, 350
		imgui.PushFont(myFont)
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'Ïðîâåäåíèå îòáîðà', menu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.SetCursorPos(imgui.ImVec2(10, 30))
		if imgui.BeginChild('Name##1'..navigation.current, imgui.ImVec2(140,105), false) then
			for i, title in ipairs(navigation.list) do
				if HeaderButton(navigation.current == i, title) then
					navigation.current = i
				end
			end
		end
		imgui.EndChild()
		imgui.SetCursorPos(imgui.ImVec2(155, 30))
		if imgui.BeginChild('Name##2'..navigation.current, imgui.ImVec2(760, 310), true) then
				if navigation.current == 1 then
				imgui.BeginChild('##getleader', imgui.ImVec2(165, 60), 0)
				imgui.PushItemWidth(155)
				if (imgui.ComboStr('', selected, comboStr .. '\0', -1)) then
					print('Selected frac name', fracNames[selected[0] + 1][2]);
				end
				imgui.PopItemWidth()
				if imgui.Button(u8'Âûäà÷à äîëæíîñòè', imgui.ImVec2(155,25)) then
					setWindow[0] = not setWindow[0]
				end
				imgui.EndChild()
				imgui.BeginChild('##msgButtons', imgui.ImVec2(520, 175), 0)
				if imgui.Button(u8'Îïîâåñòèòü î îòáîðå (Ëèäåð)', imgui.ImVec2(250,45)) then
					if selected[0] == nil or selected[0] < 1 then
						sampAddChatMessage('[Îøèáêà]: {ffffff}Âûáåðèòå ëèäåðñêóþ äîëæíîñòü äëÿ äàëüíåéøåãî ïðîâåäåíèÿ îòáîðà!', 0xFF6600)
					else
						local selected_value = fracNames[selected[0] + 1][2]
						sampSendChat('/msg [Îòáîð]: Ñåé÷àñ ïðîéä¸ò îòáîð íà ïîñò ëèäåðñòâà "'..selected_value..'". Æåëàþùèå - /gotp (îò îäíîãî ÷àñà).')
					end
				end
				imgui.SameLine()
				if imgui.Button(u8'Îïîâåñòèòü î íåäîñòà÷è ó÷àñòíèêîâ', imgui.ImVec2(250,45)) then
					if selected[0] == nil or selected[0] < 1 then
						sampAddChatMessage('[Îøèáêà]: {ffffff}Âûáåðèòå ëèäåðñêóþ äîëæíîñòü íà êîòîðóþ ïðîâîäèòå îòáîð!', 0xFF6600)
					else
						local selected_value = fracNames[selected[0] + 1][2]
						sampSendChat('/msg [Îòáîð]: Îòáîð íà äîëæíîñòü ëèäåðñòâà "'..selected_value..'" áûë îòìåí¸í èç-çà íåäîñòà÷è ó÷àñòíèêîâ.')
					end
				end
				if imgui.Button(u8'Îïîâåñòèòü î îòáîðå (Ñàïïîðò)', imgui.ImVec2(250,45)) then
					sampSendChat('/msg [Îòáîð]: Ñåé÷àñ ïðîéä¸ò îòáîð íà äîëæíîñòü "Ñàïïîðò". Æåëàþùèå - /gotp (îò îäíîãî ÷àñà)')
				end
				imgui.SameLine()
				if imgui.Button(u8'Çà÷èòàòü ïðàâèëà', imgui.ImVec2(250,45)) then
					lua_thread.create(function()
						sampSendChat('/m Ïðèâåòñòâóþ! Âû ïîïàëè íà îòáîð. Ñåé÷àñ Âàì áóäóò çà÷èòàíû ïðàâèëà.')
						wait(1500)
						sampSendChat('/m [Ïðàâèëà]: Ïåðâîìó íà îòâåò 15 ñåêóíä, îñòàëüíûì ïî 10 ñåêóíä.')
						wait(1500)
						sampSendChat('/m [Ïðàâèëà]: Çàïðåùåíî èñïîëüçîâàòü ÷àò/êîìàíäû ñ ÷àòîì. Èñêëþ÷åíèå: sms/rep äëÿ îòâåòà ïðîâîäÿùåìó.')
						wait(1500)
						sampSendChat('/m [Ïðàâèëà]: Çàïðåùíî âûáåãàòü èç ñòðîÿ, ñòîÿòü AFK 4+ ñåêóíäû è îòâå÷àòü âíå î÷åðåäè.')
						wait(1500)
						sampSendChat('/m [Ïðàâèëà]: Çàïðåùåíî ìåøàòü ó÷àñòíèêàì/ïðîâîäÿùåìó îòáîðà èëè êàê-ëèáî íàðóøàòü ïðàâèëà ïðîåêòà.')
						wait(1500)
						sampSendChat('/m [Ïðèìå÷àíèå]: Åñëè êòî-òî îñòà¸òñÿ ïîñëåäíèì è ðåøàåò ïèñàòü îòâåò â ÷àò áåç ðàíåå ïîëó÷åíîãî ðàçðåøåíèÿ  ñïàâí.')
						wait(1500)
						sampSendChat('/m Íà÷í¸ì!')
					end)
				end
				imgui.EndChild()
			elseif navigation.current == 2 then
				if imgui.Button(u8'Áëàò êîãî-ëèáî') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ëèäåðó çà áëàò?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}Âûãîâîð', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'×òî áóäåò ëèäåðó çà ðåêëàìó') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ëèäåðó çà ðåêëàìó?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}ñíÿòèå + /ban', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Íåàäåêâàòíîå ïîâåäåíèå') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ëèäåðó çà íåàäåêâàòíîå ïîâåäåíèå?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}Äâà âûãîâîðà + mute', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Ïîëó÷åíèå äåâÿòêîé âàðí') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ëèäåðó, åñëè åãî çàìåñòèòåëü ïîëó÷èò âàðí')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}Íè÷åãî', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'DeathMatch') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ëèäåðó çà DM')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}Âûãîâîð + jail', -1)
					end)
				end
				if imgui.Button(u8'Íåîòûãðîâêà 1 ÷àñà') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ëèäåðó çà íåîòûãðîâêó íîðìû 1 ÷àñà?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}Ñíÿòèå', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'NonRP íàçâàíèå ðàíãîâ') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ëèäåðó çà NonRP íàçâàíèå ðàíãîâ?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}2 âûãîâîðà', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'5 ïðè÷èí ïî êîòîðûõ ìîãóò ñíÿòü ñ ëèäåðêè') then
						lua_thread.create(function()
						sampSendChat('/m Íàçîâèòå 5 ïðè÷èí, ïî êîòîðûì ìîãóò ñíÿòü ñ ïîñòà ëèäåðà')
						wait(110)
						sampAddChatMessage('Ïðèìåðíûå ïðè÷èíû: {ffcc00}Óïîì. ðîäíè, ÷èòû, ÷èòû ñ òâèíêîâ, ðåêëàìà, íîíÐÏ íèê, ðàñôîðì 5+, ñëèâ, íåàêòèâ, îòñóòñòâèå íîðìû îíëàéíà..', -1)
						sampAddChatMessage('Ïðèìåðíûå ïðè÷èíû: {ffcc00}3/3 îòñóòñòâèå îò÷¸òà, 3/3 ñòðîãèõ ïðåäóïðåæäåíèé, 4/4 óñòíûõ ïðåäóïðåæäåíèé.', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Óïîìèíàíèå ðîäíè') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ëèäåðó çà óïîìèíàíèå ðîäíè?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}Ñíÿòèå + mute', -1)
					end)
				end
				if imgui.Button(u8'3 ïðè÷èíû ïî êîòîðûì ìîæíî ïîëó÷èòü 2 âûãîâîðà') then
						lua_thread.create(function()
						sampSendChat('/m Íàçîâèòå 3 ïðè÷èíû, ïî êîòîðûì ìîæíî ïîëó÷èòü 2 âûãîâîðà (ãîñ)')
						wait(110)
						sampAddChatMessage('Ïðè÷èíû: {ffcc00}NonRP íàçâàíèÿ ðàíãîâ, îòñóòñòâèå îò÷¸òà, ðîçæèã ìåæíàöèîíàëüíîé ðîçíè..', -1)
						sampAddChatMessage('Ïðè÷èíû: {ffcc00}Îòêàç îò ÃÐÏ, íåóâàæèòåëüíî îòíîøåíèå ê {ff0000}êðàñíîé àäìèíèñòðàöèè', -1)
					end)
				end
				imgui.Separator()
				for i, title in ipairs(gos_navigation.list) do
					if HeaderButton(gos_navigation.current == i, title) then
						gos_navigation.current = i
					end
					if i ~= #gos_navigation.list then
						imgui.SameLine(nil, 30)
					end
				end
				imgui.Separator()
				if gos_navigation.current == 1 then
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê âûäàòü ðîçûñê') then
					lua_thread.create(function()
					sampSendChat('/m Êàê âûäàòü ðîçûñê? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}/su(spect)', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê ïèñàòü òåêñò â ìåãàôîí') then
					lua_thread.create(function()
					sampSendChat('/m Êàê ïèñàòü òåêñò â ìåãàôîí? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}(/m)egaphone', -1)
					end)
				end
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê ïîñìîòðåòü ñïèñîê ðàçûñêèâàåìûõ') then
					lua_thread.create(function()
					sampSendChat('/m Êàê ïîñìîòðåòü ñïèñîê ðàçûñêèâàåìûõ ëþäåé? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}/wanted', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê ïèñàòü òåêñò â äåïàðòàìåíò') then
					lua_thread.create(function()
					sampSendChat('/m Êàê ïèñàòü òåêñò â äåïàðòàìåíò? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}(/d)epartments /db (îäíî èç äâóõ)', -1)
					end)
				end
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê îáûñêàòü èãðîêà') then
					lua_thread.create(function()
					sampSendChat('/m Êàê îáûñêàòü èãðîêà? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}/frisk', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê ïèñàòü òåêñò â ãîñ. íîâîñòè') then
					lua_thread.create(function()
					sampSendChat('/m Êàê ïèñàòü òåêñò â ãîñ. íîâîñòè? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}(/gov)ernment', -1)
					end)
				end
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê âûñòàâèòü øèïû') then
					lua_thread.create(function()
					sampSendChat('/m Êàê ? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}/block', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê îäåòü ùèò') then
					lua_thread.create(function()
					sampSendChat('/m Êàê îäåòü ùèò? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}/shield', -1)
					end)
				end
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê âûäàòü êëþ÷ îò ó÷àñòêà') then
					lua_thread.create(function()
					sampSendChat('/m Êàê âûäàòü êëþ÷ îò ó÷àñòêà? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}/givecopkeys', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê ïîñòàâèòü îáúåêòû') then
					lua_thread.create(function()
					sampSendChat('/m Êàê ïîñòàâèòü îáúåêòû (áóäêà ÊÏÏ, çíàêè, îãðàæäåíèÿ, îòáîéíèêè è ò.ä)? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}/break', -1)
					end)
				end
				if imgui.Button(u8'[ÔÁÐ] Êàê ïîíèçèòü / óâîëèòü ÷åëîâåêà ñ äðóãîé îðãàíèçàöèè') then
				lua_thread.create(function()
					sampSendChat('/m Êàê ïîíèçèòü / óâîëèòü ÷åëîâåêà ñ äðóãîé îðãàíèçàöèè? (Êîìàíäà)')
					wait(110)
					sampAddChatMessage('{ffcc00}/demote',-1)
				end)
				end
				imgui.SameLine()
				if imgui.Button(u8'[ÔÁÐ] Êàê îãëóøèòü âñåõ ðÿäîì ñòîÿùèõ æèòåëåé') then
					lua_thread.create(function()
						sampSendChat('Êàê îãëóøèòü âñåõ ðÿäîì ñòîÿùèõ æèòåëåé? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/frazer',-1)
					end)
				end
				if imgui.Button(u8'[ÔÁÐ] Êàê îäåòü ìàñêèðîâêó') then
					lua_thread.create(function()
						sampSendChat('/m Êàê îäåòü ìàñêèðîâêó? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/spy (/hmask)',-1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'[ÔÁÐ] Êàê ïðîñëóøèâàòü ðàöèè äðóãèõ îðãàíèçàöèé') then
					lua_thread.create(function()
						sampSendChat('/m Êàê ïðîñëóøèâàòü ðàöèè äðóãèõ îðãàíèçàöèé? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/follow',-1)
					end)
				end
				if imgui.Button(u8'[Ïîëèöèÿ | ÔÁÐ] Êàê ïîñìîòðåòü ñïèñîê ëþäåé Âàøåé îðãàíèçàöèè îíëàéí') then
					lua_thread.create(function()
						sampSendChat('/m Êàê ïîñìîòðåòü ñïèñîê ëþäåé Âàøåé îðãàíèçàöèè îíëàéí? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/members',-1)
					end)
				end
				elseif gos_navigation.current == 2 then
				if imgui.Button(u8'[ÀÏ | Ìýðèÿ] Êàê âûäàòü ðîçûñê ãîñ. ñëóæàùåìó') then
					lua_thread.create(function()
						sampSendChat('/m Êàê âûäàòü ðîçûñê ãîñ. ñëóæàùåìó? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/govsu',-1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'[Ìýðèÿ] Êàê ñíÿòü äåíüãè ñ êàçíû øòàòà') then
					lua_thread.create(function()
						sampSendChat('/m Êàê ñíÿòü äåíüãè ñ êàçíû øòàòà? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/takekazna',-1)
					end)
				end
				if imgui.Button(u8'[ÀÏ] Êàê ïîíèçèòü / óâîëèòü ÷åëîâåêà ñ äðóãîé îðãàíèçàöèè') then
					lua_thread.create(function()
						sampSendChat('/m Êàê ïîíèçèòü / óâîëèòü ÷åëîâåêà ñ äðóãîé îðãàíèçàöèè? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/demote',-1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'[ÀÏ] Êàê îãëóøèòü âñåõ ðÿäîì ñòîÿùèõ æèòåëåé') then
					lua_thread.create(function()
						sampSendChat('/m Êàê îãëóøèòü âñåõ ðÿäîì ñòîÿùèõ æèòåëåé? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/ftazer',-1)
					end)
				end
				elseif gos_navigation.current == 3 then
				if imgui.Button(u8'Êàê ðåäàêòèðîâàòü îáúÿâëåíèÿ') then
					lua_thread.create(function()
						sampSendChat('/m Êàê ðåäàêòèðîâàòü îáúÿâëåíèÿ? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/edit',-1)
					end)
				end
				elseif gos_navigation.current == 4 then
				if imgui.Button(u8'Ëîìêà') then
					lua_thread.create(function()
						sampSendChat('/m Êàê ïîìî÷ü îñòàíîâèòü ëîìêó? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/lomka',-1)
					end)
				end imgui.SameLine()
				if imgui.Button(u8'Ìåä. êàðòà') then
					lua_thread.create(function()
						sampSendChat('/m Êàê âûäàòü ÷åëîâåêó ìåä. êàðòó? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/givemedcard',-1)
					end)
				end
				if imgui.Button(u8'Âûëå÷èòü') then
					lua_thread.create(function()
						sampSendChat('/m Êàê âûëå÷èòü ÷åëîâåêà? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/medhelp (/heal)',-1)
					end)
				end imgui.SameLine()
				if imgui.Button(u8'Âûãíàòü èç çäàíèÿ') then
					lua_thread.create(function()
						sampSendChat('/m Êàê âûãíàòü ÷åëîâåêà èç çäàíèÿ? (Êîìàíäà)')
						wait(110)
						sampAddChatMessage('{ffcc00}/mdpell',-1)
					end)
				end
			end
		elseif navigation.current == 3 then
				if imgui.Button(u8'Èãíîðèðîâàíèå ïðîñüá ÃÑ') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ñàïïîðòó çà èãíîðèðîâàíèå ïðîñüá ãëàâíîãî ñëåäÿùåãî?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}Âûãîâîð', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Îòñóòñâèå íîðìû îíëàéíà') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ñàïïîðòó çà îòñóòñòâèå íîðìû îíëàéíû?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}Ñíÿòèå', -1)
					end)
				end
				if imgui.Button(u8'Íåàêòèâ 24 ÷àñà') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ñàïïîðòó çà íåàêòèâ 24 ÷àñà?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}Ñíÿòèå', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Íåâåðíûé îòâåò') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ñàïïîðòó çà íåâåðíûé îòâåò?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}Âûãîâîð', -1)
					end)
				end
				if imgui.Button(u8'NonRP íèê') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ñàïïîðòó çà NonRP íèê?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}Ñíÿòèå', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Òðàíñëèò â îòâåòå') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ñàïïîðòó çà òðàíñèë â îòâåòå?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}Âûãîâîð', -1)
					end)
				end
				if imgui.Button(u8'Îøèáêè/íåãðàìîòíîñòü â îòâåòå') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ñàïïîðòó çà íàëè÷èå îøèáîê, ïðîÿâëåíèå íåãðàìîòíîñòè ïðè îòâåòå, íåïîëíîöåííûå îòâåòû?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}Âûãîâîð', -1)
					end)
				end
				if imgui.Button(u8'Èñïîëüçîâàíèå ÷èòîâ') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ñàïïîðòó çà èñïîëüçîâàíèå ÷èòîâ?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}Ñíÿòèå + jail/warn', -1)
					end)
				end
				if imgui.Button(u8'DeathMatch') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ñàïïîðòó çà DM?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}Âûãîâîð + jail', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'0 îòâåòîâ') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ñàïïîðòó çà íàëè÷èå 0 îòâåòîâ?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}2 âûãîâîðà', -1)
					end)
				end
		elseif navigation.current == 4 then
				if imgui.Button(u8'×òî áóäåò áàíäå çà ÒÊÄ') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò áàíäå çà òðóäíîäîñòóïíóþ êðûøó âî âðåìÿ êàïòà, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}2/3 áàíäå, èãðîêó jail/warn (ëèäåðó âûãîâîð åñëè îí â ñåòè)', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Áðîíÿ íà êàïòå') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò áèíäå çà èñïîëüçîâàíèå áðîíåæèëåòà âî âðåìÿ êàïòà, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}1/3 áàíäå, èãðîêó jail/warn (ëèäåðó âûãîâîð åñëè îí â ñåòè)', -1)
					end)
				end
				if imgui.Button(u8'Fly Hack') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò áàíäå èñïîëüçîâàíèå Fly Hack, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}2/3 áàíäå, èãðîêó jail/warn (ëèäåðó âûãîâîð åñëè îí â ñåòè)', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'CARSHOT') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò áàíäå èñïîëüçîâàíèå CARSHOT, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}3/3 áàíäå, èãðîêó /ban', -1)
					end)
				end
				if imgui.Button(u8'Íàìåðåííûé SK') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò áàíäå çà íàìåðåííûé SK, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}2/3 áàíäå, èãðîêó jail/warn (ëèäåðó âûãîâîð åñëè îí â ñåòè)', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Êàïò Êóñîêîì/îáðåçîì') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò áàíäå çà êàïò êóñêîì/îáðåçîì, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}3/3 áàíäå, èãðîêó jail/warn (ëèäåðó âûãîâîð åñëè îí â ñåòè)', -1)
					end)
				end
				if imgui.Button(u8'3/3 êàïò (ëèäåð â ñåòè)') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò ëèäåðó, åñëè åãî áàíäà ïîëó÷èëà 3/3, êîãäà îí áûë â ñåòè?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}Âûãîâîð', -1)
					end)
				end
				if imgui.Button(u8'Ñòðåëüáà èç ïàññàæèðñêîãî îêíà') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò áàíäå, åñëè êòî-òî èç íèõ áóäåò ñòåðëÿòü èç ïàññàæèðñêîãî îêíà, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}3/3 áàíäå, èãðîêó íè÷åãî (åñëè ëèäåð - âûãîâîð)', -1)
					end)
				end
				if imgui.Button(u8'Silent-AIM') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò áàíäå çà èñïîëüçîâàíèå AIM, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}3/3 áàíäå, èãðîêó jail/warn (ëèäåðó âûãîâîð åñëè îí â ñåòè)', -1)
					end)
				end
				imgui.SameLine()
				if imgui.Button(u8'Èñï. +C íà êàïòå àíòè+Ñ') then
					lua_thread.create(function()
					sampSendChat('/m ×òî áóäåò áàíäå çà +Ñ íà àíòè +Ñ êàïòå, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
					wait(110)
					sampAddChatMessage('Íàêàçàíèå: {ffcc00}3/3 áàíäå, èãðîêó jail/warn (ëèäåðó âûãîâîð åñëè îí â ñåòè)', -1)
					end)
				end
			elseif navigation.current == 5 then
				for i, title in ipairs(mafia_navigation.list) do
					if HeaderButton(mafia_navigation.current == i, title) then
						mafia_navigation.current = i
					end
					if i ~= #mafia_navigation.list then
						imgui.SameLine(nil, 30)
					end
				end
				imgui.Separator()
				if mafia_navigation.current == 1 then
					if imgui.Button(u8'Íåÿâêà') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ìàôèè çà íåïðèåçä íà ñòðåëå â òå÷åíèè 3-õ ìèíóò?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}3/3 ìàôèè, åñëè ëèäåð áûë â ñåòè - âûãîâîð', -1)
						end)
					end
					imgui.SameLine()
					if imgui.Button(u8'Ìàñêà') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ëèäåðó è ìàôèè çà èñïîëüçîâàíèå ìàñêè íà ñòðåëå?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}1/3 ìàôèè, èãðîêó jail/warn.', -1)
						end)
					end
					if imgui.Button(u8'+C') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ìàôèè, åñëè êòî-òî íà ñòðåëå èç íèõ áóäåò èñïîëüçîâàòü +Ñ, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}1/3 ìàôèè, èãðîêó jail/warn', -1)
						end)
					end
					imgui.SameLine()
					if imgui.Button(u8'3/3 ñòðåëà (ëèäåð â ñåòè)') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ëèäåðó, åñëè åãî ìàôèÿ ïîëó÷èëà 3/3, êîãäà îí áûë â ñåòè?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}Âûãîâîð', -1)
						end)
					end
					imgui.SameLine()
					if imgui.Button(u8'FLY') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ìàôèè, åñëè êòî-òî íà ñòðåëå èç íèõ áóäåò èñïîëüçîâàòü FLY, è èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}1/3 ìàôèè, èãðîêó jail/warn', -1)
						end)
					end
					if imgui.Button(u8'Çàïðåù¸ííûé ÒÑ') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ìàôèè, åñëè êòî-òî íà ñòðåëå ïðèëåòèò íà Hunter | Hydra, è ÷òî áóäåò èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}3/3 ìàôèè, èãðîêó jail/warn (ëèäåðó âûãîâîð åñëè îí â ñåòè)', -1)
						end)
					end
					if imgui.Button(u8'Àíòè-çàõâàò áèçíåñà') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ìàôèè çà àíòè-çàõâàò áèçíåñà?')
						wait(110)
						sampAddChatMessage('Ïðèìåð: {ffcc0}LCN åäåò çàáèâàòü ñòðåëó Yakuza, íî Yakuza óáèëè åãî, ÷òîáû òîò èì íå çàáèë ñòðåëó')
						sampAddChatMessage('Ïðèìåð: {ffcc00}ID 1 LCN, ID 2 - Yakuza. Åñëè ID 2 óáèë ID 1, òî ID 2 ïîëó÷àåò âàðí')
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}3/3 ìàôèè, èãðîêó jail/warn (ëèäåðó âûãîâîð åñëè îí â ñåòè)', -1)
						end)
					end
					if imgui.Button(u8'ÒÄÊ') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ìàôèè, åñëè êòî-òî íà ñòðåëå çàëåçåò íà òðóäíîäîñòóïíóþ êðûøó, è ÷òî áóäåò èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}2/3 ìàôèè, èãðîêó jail/warn', -1)
						end)
					end
					imgui.SameLine()
					if imgui.Button(u8'Àïòå÷êà/íàðêîòèêè â áîþ') then
						lua_thread.create(function()
						sampSendChat('/m ×òî áóäåò ìàôèè, åñëè êòî-òî íà ñòðåëå áóäåò èñïîëüçîâàòü àïòå÷êè/íàðêîòèêè â áîþ, è ÷òî áóäåò èãðîêó êîòîðûé íàðóøèë ïðàâèëî?')
						wait(110)
						sampAddChatMessage('Íàêàçàíèå: {ffcc00}1/3 ìàôèè, èãðîêó jail/warn', -1)
						end)
					end
				elseif mafia_navigation.current == 2 then
					if imgui.Button(u8'Êàêîå ìèíèìàëüíîå êîë-âî êîíòðàêòîâ äëÿ îò÷¸òà') then
						lua_thread.create(function()
							sampSendChat('/m Êàêîå ìèíèìàëüíîå êîë-âî êîíòðàêòîâ äëÿ îò÷¸òà?')
							wait(110)
							sampAddChatMessage('{ffcc00}3 êîíòðàêòà',-1)
						end)
					end imgui.SameLine()
					if imgui.Button(u8'Îò ñêîëüêèõ ìèíóò äîëæåí äëèòüñÿ íàáîð äëÿ îò÷¸òà') then
						lua_thread.create(function()
							sampSendChat('/m Îò ñêîëüêèõ ìèíóò äîëæåí äëèòüñÿ íàáîð äëÿ îò÷¸òà?')
							wait(110)
							sampAddChatMessage('{ffcc00}15 ìèíóò',-1)
						end)
					end
					if imgui.Button(u8'Îò ñêîëüêèõ ìèíóò äîëæåí äëèòüñÿ ïðîìåæóòîê ìåæäó ïåðâûì è âòîðûì íàáîðîì äëÿ îò÷¸òà') then
						lua_thread.create(function()
							sampSendChat('/m Îò ñêîëüêèõ ìèíóò äîëæåí äëèòüñÿ ïðîìåæóòîê ìåæäó ïåðâûì è âòîðûì íàáîðîì äëÿ îò÷¸òà?')
							wait(110)
							sampAddChatMessage('{ffcc00}10 ìèíóò',-1)
						end)
					end
					if imgui.Button(u8'Êàê îäåòü ìàñêèðîâêó') then
						lua_thread.create(function()
							sampSendChat('/m Êàê îäåòü ìàñêèðîâêó?')
							wait(110)
							sampAddChatMessage('{ffcc00}/spy (/hmask)',-1)
						end)
					end
			end
		end
	end
	imgui.EndChild()
	imgui.PopFont()
	elseif menuSwitch == 2 then
		local resX, resY = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(485, 255))
		imgui.PushFont(myFont)
		imgui.Begin(u8'Ïðîâåäåíèå ÌÏ', menu, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		if mp_navigation.current == 1 then -- Home
			if imgui.BeginChild('child##1', imgui.ImVec2(470,215), 0) then
				for i, title in ipairs(mp_navigation.list) do
					if HeaderButton(mp_navigation.current == i, title) then
						mp_navigation.current = i
					end
					if i ~= #mp_navigation.list then
						imgui.SameLine(nil, 110)
					end
				end
				imgui.Separator()
				imgui.Combo('', present, ImPresent, #presentlist)
				imgui.InputTextWithHint(u8'##4', u8'Íàçâàíèå ìåðîïðèÿòèÿ', set_namemp, sizeof(set_namemp))
				imgui.SameLine()
				if imgui.Button(faicons('trash')..u8'##5'..faicons('trash')) then 
					imgui.StrCopy(set_namemp,'')
				end
				imgui.TextQuestionMp(u8'Òèï: íàçâàíèå\nÈñïîëüçóåòñÿ äëÿ îáû÷íîãî îïîâåùåíèÿ â /msg')
				imgui.InputTextWithHint(u8'##5', u8'Ñóììà ïðèçà', set_priz, sizeof(set_priz), imgui.InputTextFlags.CharsDecimal)
				imgui.SameLine()
				if imgui.Button(faicons('trash')..u8'##6'..faicons('trash')) then 
					imgui.StrCopy(set_priz,'')
				end
				imgui.TextQuestionMp(u8'Òèï: ñóììà\nÈñïîëüçóåòñÿ äëÿ îáû÷íîãî îïîâåùåíèÿ â /msg')
				imgui.InputTextWithHint(u8'##1', u8'Nickname ïîáåäèòåëÿ ìåðîïðèÿòèÿ', input_name, sizeof(input_name))
				imgui.SameLine()
				if imgui.Button(faicons('trash')..u8'##7'..faicons('trash')) then 
					imgui.StrCopy(input_name,'')
				end
				imgui.TextQuestionMp(u8'Òèï: íèêíåéì\nÈñïîëüçóåòñÿ äëÿ îáû÷íîãî îïîâåùåíèÿ â /msg')
				imgui.InputTextWithHint(u8'##2', u8'ID ïîáåäèòåëÿ ìåðîïðèÿòèÿ', input_id, sizeof(input_id), imgui.InputTextFlags.CharsDecimal)
				imgui.SameLine()
				if imgui.Button(faicons('trash')..u8'##8'..faicons('trash')) then 
					imgui.StrCopy(input_id,'')
				end
				imgui.TextQuestionMp(u8'Äëÿ äîëæíîñòè "Îðãàíèçàòîð ìåðîïðèÿòèé"\nÈñêëþ÷èòåëüíî íà Real Money (/rdonate)')
				imgui.Separator()
				imgui.Text('')
				-- imgui.SameLine(100)
				if imgui.Button(faicons('play')..u8'  Íà÷àòü', imgui.ImVec2(145,0)) then
					local set_namemp = str(set_namemp)
					local set_priz = str(set_priz)
					local selected_prize = u8:decode(ffi.string(presentlist[present[0] + 1]))
					if u8:decode(ffi.string(set_namemp)) ~= '' and u8:decode(ffi.string(set_priz)) ~= '' and selected_prize ~= 0 then
						sampSendChat('/msg Ïðîõîäèò ìåðîïðèÿòèå "'..u8:decode(ffi.string(set_namemp))..'" íà '..u8:decode(ffi.string(set_priz))..' '..selected_prize..'. Æåëàþùèå - /gotp.')
					else
						sampAddChatMessage('[Îøèáêà] {ffffff}Çíà÷åíèÿ âûáðàíû íåâåðíî', 0x696969)
					end
				end  
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.Text(u8'Îïîâåùàåò î íà÷àëå ìåðîïðèÿòèÿ')
					imgui.EndTooltip()
				end
				imgui.SameLine()
				if imgui.Button(faicons('pause')..u8'  Çàêîí÷èòü', imgui.ImVec2(145,0)) then
					local input_name = str(input_name)
					local set_namemp = str(set_namemp)
					local set_priz = str(set_priz)
					local selected_prize = u8:decode(ffi.string(presentlist[present[0] + 1]))
					if u8:decode(ffi.string(set_namemp)) ~= '' and u8:decode(ffi.string(set_priz)) ~= '' and u8:decode(ffi.string(input_name)) ~= '' and selected_prize ~= 0 then
						sampSendChat('/msg Ïîáåäèòåëü ìåðîïðèÿòèÿ "'..u8:decode(ffi.string(set_namemp))..'" íà '..u8:decode(ffi.string(set_priz))..' '..selected_prize..'  '..u8:decode(ffi.string(input_name))..'. Ïîçäðàâëÿåì!')
					else
						sampAddChatMessage('[Îøèáêà] {ffffff}Çíà÷åíèÿ âûáðàíû íåâåðíî', 0x696969)
					end
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.Text(u8'Îïîâåùàåò î çàâåðøåíèè ìåðîïðèÿòèÿ')
					imgui.EndTooltip()
				end
				imgui.SameLine()
				if imgui.Button(faicons('star')..u8'  Âûäàòü', imgui.ImVec2(145,0)) then
					local set_namemp = str(set_namemp)
					local input_id = str(input_id)
					local selected_prize = u8:decode(ffi.string(presentlist[present[0] + 1]))
					if u8:decode(ffi.string(set_namemp)) ~= '' and u8:decode(ffi.string(input_id)) ~= '' and selected_prize ~= 1 then
						sampSendChat('/winner '..u8:decode(ffi.string(input_id))..' '..u8:decode(ffi.string(set_namemp))..'')
					else
						sampAddChatMessage('[Îøèáêà] {ffffff}Çíà÷åíèÿ âûáðàíû íåâåðíî', 0x696969)
					end
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.Text(u8'Äëÿ äîëæíîñòè "Îðãàíèçàòîð ìåðîïðèÿòèé"\nÈñêëþ÷èòåëüíî íà Real Money (/rdonate)')
					imgui.EndTooltip()
				end
				imgui.EndChild()
				end
		elseif mp_navigation.current == 2 then -- Regulations
			if imgui.BeginChild('child##2', imgui.ImVec2(470,205), 0) then
				for i, title in ipairs(mp_navigation.list) do
					if HeaderButton(mp_navigation.current == i, title) then
						mp_navigation.current = i
					end
					if i ~= #mp_navigation.list then
						imgui.SameLine(nil, 110)
					end
				end
				imgui.Separator()
				if imgui.Button(u8'Ðóëåòêà (Íà âûñòðåë)', imgui.ImVec2(151,30)) then
					lua_thread.create(function()
						sampSendChat('/m Ïðàâèëà ÌÏ:')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: èçìåíÿòü êëèñò/ñêèí, ïåðåáåãàòü ñ ìåñòà íà ìåñòî, èñïîëüçîâàòü /me, /do, /todo è /try è ò.ä')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: êàê ëèáî íàðóøàòü ïðàâèëà ïðîåêòà')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: âûáåãàòü èç ñòðîÿ è ìåøàòü äðóãèì')
						wait(1000)
						sampSendChat('/m Ïîìåõà = êèê. Äëÿ àäì. âûãîâîð + êèê. Çà ïîâòîðíóþ ïîìåõó + áàí.')
						wait(1000)
						sampSendChat('/m Íà÷í¸ì! Èãðà áóäåò íà âûñòðåë')
					end)
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.CenterText(u8'Äëÿ äîëæíîñòè îáû÷íîãî àäìèíèñòðàòîðà')
					imgui.Separator()
					imgui.CenterText(u8'Ðóññêàÿ ðóëåòêà (Íà âûñòðåë)')
					imgui.Separator()
					imgui.Text(u8'Ïðàâèëà ÌÏ:\nÇàïðåùåíî: èçìåíÿòü êëèñò/ñêèí, ïåðåáåãàòü ñ ìåñòà íà ìåñòî, èñïîëüçîâàòü /me, /do, /todo è /try è ò.ä\nÇàïðåùåíî: êàê ëèáî íàðóøàòü ïðàâèëà ïðîåêòà\nÇàïðåùåíî: âûáåãàòü èç ñòðîÿ è ìåøàòü äðóãèì\nÍà÷í¸ì! Èãðà áóäåò íà âûñòðåë')
					imgui.EndTooltip()
				end
					imgui.SameLine()
				if imgui.Button(u8'Ðóëåòêà (Íà ñìåðòü)', imgui.ImVec2(151,30)) then
					lua_thread.create(function()
						sampSendChat('/m Ïðàâèëà ÌÏ:')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: èçìåíÿòü êëèñò/ñêèí, ïåðåáåãàòü ñ ìåñòà íà ìåñòî, èñïîëüçîâàòü /me, /do, /todo è /try è ò.ä')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: êàê ëèáî íàðóøàòü ïðàâèëà ïðîåêòà')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: âûáåãàòü èç ñòðîÿ è ìåøàòü äðóãèì')
						wait(1000)
						sampSendChat('/m Ïîìåõà = êèê. Äëÿ àäì. âûãîâîð + êèê. Çà ïîâòîðíóþ ïîìåõó + áàí.')
						wait(1000)
						sampSendChat('/m Íà÷í¸ì! Èãðà áóäåò íà ñìåðòü')
					end)
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.CenterText(u8'Äëÿ äîëæíîñòè îáû÷íîãî àäìèíèñòðàòîðà')
					imgui.Separator()
					imgui.CenterText(u8'Ðóññêàÿ ðóëåòêà (Íà ñìåðòü/spawn)')
					imgui.Separator()
					imgui.Text(u8'Ïðàâèëà ÌÏ:\nÇàïðåùåíî: èçìåíÿòü êëèñò/ñêèí, ïåðåáåãàòü ñ ìåñòà íà ìåñòî, èñïîëüçîâàòü /me, /do, /todo è /try è ò.ä\nÇàïðåùåíî: êàê ëèáî íàðóøàòü ïðàâèëà ïðîåêòà\nÇàïðåùåíî: âûáåãàòü èç ñòðîÿ è ìåøàòü äðóãèì\nÍà÷í¸ì! Èãðà áóäåò íà ñìåðòü')
					imgui.EndTooltip()
				end
				imgui.SameLine()
				if imgui.Button(u8'Êðûøà ñìåðòè', imgui.ImVec2(151,30)) then 
					lua_thread.create(function()
						sampSendChat('/m Ïðàâèëà ÌÏ:')                        
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: èçìåíÿòü êëèñò/ñêèí è èñïîëüçîâàòü àíèìàöèè')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: AFK áîëåå ÷åì 10 ñåêóíä, ïîïîëíÿòü ëþáûìè ñïîñîáàìè ñåáå ÕÏ, àäìèíèñòðàòîðàì èñïîëüçîâàòü èõ âîçìîæíîñòè')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: êàê ëèáî íàðóøàòü ïðàâèëà ïðîåêòà')
						wait(1000)
						sampSendChat('/m Âíèìàíèå! Ïðîâîäÿùèå ÌÏ èìåþò ïðàâî ïî âàì ñòðåëÿòü.')
						wait(1000)
						sampSendChat('/m Ïîìåõà = êèê. Äëÿ àäì. âûãîâîð + êèê. Çà ïîâòîðíóþ ïîìåõó + áàí.')
						wait(1000)
						sampSendChat('/m Áåãèòå!')
					end)
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.CenterText(u8'Äëÿ äîëæíîñòè îáû÷íîãî àäìèíèñòðàòîðà')
					imgui.Separator()
					imgui.CenterText(u8'Êðûøà ñìåðòè')
					imgui.Separator()
					imgui.Text(u8'Ïðàâèëà ÌÏ:\nÇàïðåùåíî: èçìåíÿòü êëèñò/ñêèí è èñïîëüçîâàòü àíèìàöèè\nÇàïðåùåíî: AFK áîëåå ÷åì 10 ñåêóíä, ïîïîëíÿòü ëþáûìè ñïîñîáàìè ñåáå ÕÏ, àäìèíèñòðàòîðàì èñïîëüçîâàòü èõ âîçìîæíîñòè\nÇàïðåùåíî: êàê ëèáî íàðóøàòü ïðàâèëà ïðîåêòà\n/m Âíèìàíèå! Ïðîâîäÿùèé ÌÏ èìåþò ïðàâî ïî âàì ñòðåëÿòü\nÁåãèòå!')
					imgui.EndTooltip()
				end
				if imgui.Button(u8'Êîðîëü äèãëà', imgui.ImVec2(151,30)) then
					lua_thread.create(function()
						sampSendChat('/m Ïðàâèëà ÌÏ:')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: èçìåíÿòü êëèñò/ñêèí, ñòðåëÿòü â ó÷àñòíèêîâ/âîçäóõ/ïðîâîäÿùåãî ìåðîïðèÿòèÿ áåç ïðè÷èíû')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: êàê ëèáî íàðóøàòü ïðàâèëà ïðîåêòà')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: âûáåãàòü èç ñòðîÿ è ìåøàòü äðóãèì')
						wait(1000)
						sampSendChat('/m Ïîìåõà = êèê. Äëÿ àäì. âûãîâîð + êèê. Çà ïîâòîðíóþ ïîìåõó + áàí.')
						wait(1000)
						sampSendChat('/m Áóäó îïîâåùàòü Âàñ, êòî âñòàíåò â ñëåäóùèé ðàóíä')
					end)
				end 
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.CenterText(u8'Äëÿ äîëæíîñòè îáû÷íîãî àäìèíèñòðàòîðà')
					imgui.Separator()
					imgui.CenterText(u8'Êîðîëü äèãëà')
					imgui.Separator()
					imgui.Text(u8'Ïðàâèëà ÌÏ:\nÇàïðåùåíî: èçìåíÿòü êëèñò/ñêèí, ñòðåëÿòü â ó÷àñòíèêîâ/âîçäóõ/ïðîâîäÿùåãî ìåðîïðèÿòèÿ áåç ïðè÷èíû\nÇàïðåùåíî: êàê ëèáî íàðóøàòü ïðàâèëà ïðîåêòà\nÇàïðåùåíî: âûáåãàòü èç ñòðîÿ è ìåøàòü äðóãèì\nÁóäó îïîâåùàòü Âàñ, êòî âñòàíåò â ñëåäóùèé ðàóíä')
					imgui.EndTooltip()
				end
				imgui.SameLine()
				if imgui.Button(u8'Ïðÿòêè', imgui.ImVec2(151,30)) then
					lua_thread.create(function()
						sampSendChat('/m Ïðàâèëà ÌÏ:')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: èçìåíÿòü êëèñò/ñêèí, îäåâàòü ìàñêó è èñïîëüçîâàòü àíèìàöèè')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: êàê ëèáî íàðóøàòü ïðàâèëà ïðîåêòà')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî: èñïîëüçîâàòü àäìèí-âîçìîæíîñòè è áàãîþçåðñòâî')
						wait(1000)
						sampSendChat('/m Ïîìåõà = êèê. Äëÿ àäì. âûãîâîð + êèê. Çà ïîâòîðíóþ ïîìåõó + áàí.')
						wait(1000)
						sampSendChat('/m Ó Âàñ åñòü ìèíóòà, ïîñëå ÷åãî èä¸ì èñêàòü')
						wait(1000)
						sampSendChat('/m Áåãèòå!')
					end)
				end 
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.CenterText(u8'Äëÿ äîëæíîñòè îáû÷íîãî àäìèíèñòðàòîðà')
					imgui.Separator()
					imgui.CenterText(u8'Ïðÿòêè')
					imgui.Separator()
					imgui.Text(u8'Ïðàâèëà ÌÏ:\nÇàïðåùåíî: èçìåíÿòü êëèñò/ñêèí, îäåâàòü ìàñêó è èñïîëüçîâàòü àíèìàöèè\nÇàïðåùåíî: êàê ëèáî íàðóøàòü ïðàâèëà ïðîåêòà\nÇàïðåùåíî: èñïîëüçîâàòü àäìèí-âîçìîæíîñòè è áàãîþçåðñòâî\nÓ Âàñ åñòü ìèíóòà, ïîñëå ÷åãî èä¸ì èñêàòü\nÁåãèòå!')
					imgui.EndTooltip()
				end
				imgui.SameLine()
				if imgui.Button(u8'Àðåíà ñìåðòè', imgui.ImVec2(151,30)) then
					lua_thread.create(function()
						sampSendChat('/m Ïðàâèëà ÌÏ:')
						wait(1000)
						sampSendChat('/m Âàøà çàäà÷à îñòàòüñÿ ïîñëåäíèì â æèâûõ')
						wait(1000)
						sampSendChat('/m ß áóäó ïî âàì ñòðåëÿòü èç îðóæèÿ')
						wait(1000)
						sampSendChat('/m Çàïðåùåíî:')
						wait(1000)
						sampSendChat('/m Ñòîÿòü AFK áîëåå ÷åì 5 ñåêóíä')
						wait(1000)
						sampSendChat('/m Èñïîëüçîâàòü ëþáûå ÷èòû, ïîïîëåíèÿ ÕÏ, ìåíÿòü êëèñò/ñêèí')
						wait(1000)
						sampSendChat('/m êàê ëèáî íàðóøàòü ïðàâèëà ñåðâåðà, àäìèíèñòðàöèè èñïîëüçîâàòü èõ âîçìîæíîñòè')
						wait(1000)
						sampSendChat('/m Ïîìåõà = êèê. Äëÿ àäì. âûãîâîð + êèê. Çà ïîâòîðíóþ ïîìåõó + áàí.')
					end)
				end 
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.CenterText(u8'Äëÿ äîëæíîñòè îáû÷íîãî àäìèíèñòðàòîðà')
					imgui.Separator()
					imgui.CenterText(u8'Àðåíà ñìåðòè')
					imgui.Separator()
					imgui.Text(u8'Ïðàâèëà ÌÏ:\nÂàøà çàäà÷à îñòàòüñÿ ïîñëåäíèì â æèâûõ\nß áóäó ïî âàì ñòðåëÿòü èç îðóæèÿ\nÇàïðåùåíî:\nÑòîÿòü AFK áîëåå ÷åì 5 ñåêóíä\nÈñïîëüçîâàòü ëþáûå ÷èòû, ïîïîëåíèÿ ÕÏ, ìåíÿòü êëèñò/ñêèí\nêàê ëèáî íàðóøàòü ïðàâèëà ñåðâåðà, àäìèíèñòðàöèè èñïîëüçîâàòü èõ âîçìîæíîñòè')
					imgui.EndTooltip()
				end
				if imgui.Button(u8'Ìÿñîðóáêà', imgui.ImVec2(151,30)) then
					lua_thread.create(function()
						sampSendChat('/m Ïðàâèëà ÌÏ:')
						wait(1000)
						sampSendChat('/m Âû çàáåãàåòå â êîìíàòó è ÿ âûäàþ âñåì îðóæèå')
						wait(1000)
						sampSendChat('/m Âàøà çàäà÷à îñòàòüñÿ ïîñëåäíèì â æèâûõ')
						wait(1000)
						sampSendChat('/m Çàïðåùåíû ïîïîëíåíèÿ ÕÏ, àäì. âîçìîæíîñòè è íàðóøåíèÿ ëþáûõ ïðàâèë ñåðâåðà')
						wait(1000)
						sampSendChat('/m Ïîìåõà = êèê. Äëÿ àäì. âûãîâîð + êèê. Çà ïîâòîðíóþ ïîìåõó + áàí.')
						wait(1000)
						sampSendChat('/m Áåãèòå!') 
					end)
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.CenterText(u8'Äëÿ äîëæíîñòè îáû÷íîãî àäìèíèñòðàòîðà')
					imgui.Separator()
					imgui.CenterText(u8'Ìÿñîðóáêà')
					imgui.Separator()
					imgui.Text(u8'Ïðàâèëà ÌÏ:\nÂû çàáåãàåòå â êîìíàòó è ÿ âûäàþ âñåì îðóæèå\nÂàøà çàäà÷à îñòàòüñÿ ïîñëåäíèì â æèâûõ\nÇàïðåùåíû ïîïîëíåíèÿ ÕÏ, àäì. âîçìîæíîñòè è íàðóøåíèÿ ëþáûõ ïðàâèë ñåðâåðà\nÁåãèòå!')
					imgui.EndTooltip()
				end
				imgui.SameLine()
				if imgui.Button(u8'Ïîñëåäí. çàáåð¸ò âñ¸', imgui.ImVec2(151,30)) then
					lua_thread.create(function()
						sampSendChat('/m Ñóòü ÌÏ:')
						wait(1000)
						sampSendChat('/m ß âûçûâàþ ëþäåé è îíè âñòàþò âî âíóòðü ÷åòûð¸õ ñòåí.')
						wait(1000)
						sampSendChat('/m Âû äîëæíû òàì áåãàòü.')
						wait(1000)
						sampSendChat('/m ß áåðó ãðàíàòû è íà÷èíàþ èõ òóäà êèäàòü.')
						wait(1000)
						sampSendChat('/m Ïîñëåäíèé êòî óìð¸ò â ýòèõ ñòåíàõ èëè îñòàíåòñÿ æèâûì ïðîõîäèò â ñëåäóùèé ðàóíä.')
						wait(1000)
						sampSendChat('/m Ïðàâèëà ÌÏ:')
						wait(1000)
						sampSendChat('/m Çàïðåùåíû ïîïîëíåíèÿ ÕÏ, àäì. âîçìîæíîñòè è íàðóøåíèÿ ëþáûõ ïðàâèë ñåðâåðà.')
						wait(1000)
						sampSendChat('/m Ñìåíà ñêèíà/êëèñòà, ÂÛËÀÇÈÒÜ èç ñòåí.')
						wait(1000)
						sampSendChat('/m Ïîìåõà = êèê. Äëÿ àäì. âûãîâîð + êèê. Çà ïîâòîðíóþ ïîìåõó + áàí.')
						wait(1000)
						sampSendChat('/m Íà÷í¸ì!') 
					end)
				end
				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.CenterText(u8'Äëÿ äîëæíîñòè "Îðãàíèçàòîð ìåðîïðèÿòèé"')
					imgui.Separator()
					imgui.CenterText(u8'Ïîñëåäíèé çàáåð¸ò âñ¸')
					imgui.Separator()
					imgui.Text(u8'Ñóòü ÌÏ:\nß âûçûâàþ ëþäåé è îíè âñòàþò âî âíóòðü ÷åòûð¸õ ñòåí.\nÂû äîëæíû òàì áåãàòü.\nß áåðó ãðàíàòû è íà÷èíàþ èõ òóäà êèäàòü.\nÏîñëåäíèé êòî óìð¸ò â ýòèõ ñòåíàõ èëè îñòàíåòñÿ æèâûì ïðîõîäèò â ñëåäóùèé ðàóíä.\nÏðàâèëà ÌÏ:\nÇàïðåùåíû ïîïîëíåíèÿ ÕÏ, àäì. âîçìîæíîñòè è íàðóøåíèÿ ëþáûõ ïðàâèë ñåðâåðà.\nÑìåíà ñêèíà/êëèñòà, ÂÛËÀÇÈÒÜ èç ñòåí.\nÍà÷í¸ì!')
					imgui.EndTooltip()
				end
				imgui.SameLine()
				if imgui.Button(u8'Ïîèñê ïðåäìåòà', imgui.ImVec2(151,30)) then
					local myID = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
					lua_thread.create(function()
						sampSendChat('/m Ñóòü ÌÏ:')
						wait(1000)
						sampSendChat('/m Ãäå-òî â LS ðàñïîëîæåí ïðåäìåò, êîòîðûé âû äîëæíû íàéòè.')
						wait(1000)
						sampSendChat('/m Åñëè Âû íàøëè äàííûé ïðåäìåò - ïèøèòå ìíå â /sms [ID: '..myID..']')
						wait(1000)
						sampSendChat('/m Âû ìîæåòå áðàòü ëþáîé ÒÑ è èñêàòü äàííûé ïðåäìåò.')
						wait(1000)
						sampSendChat('/m Ïðàâèëà ÌÏ:')
						wait(1000)
						sampSendChat('/m Çàïðåùåíû ÷èòû, àäì. âîçìîæíîñòè è íàðóøåíèÿ ëþáûõ ïðàâèë ñåðâåðà.')
						wait(1000)
						sampSendChat('/m Ñìåíà ñêèíà/êëèñòà.')
						wait(1000)
						sampSendChat('/m Ïîìåõà = êèê. Äëÿ àäì. âûãîâîð + êèê. Çà ïîâòîðíóþ ïîìåõó + áàí.')
						wait(1000)
						sampSendChat('/m Ñåé÷àñ ÿ âàì ïîêàæó ýòîò ïðåäìåò.') 
					end)
				end
				if imgui.IsItemHovered() then
					local myID = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
					imgui.BeginTooltip()
					imgui.CenterText(u8'Äëÿ äîëæíîñòè "Îðãàíèçàòîð ìåðîïðèÿòèé"')
					imgui.Separator()
					imgui.CenterText(u8'Ïîèñê ïðåäìåòà')
					imgui.Separator()
					imgui.Text(u8'Ñóòü ÌÏ:\nÃäå-òî â LS ðàñïîëîæåí ïðåäìåò, êîòîðûé âû äîëæíû íàéòè.\nÅñëè Âû íàøëè äàííûé ïðåäìåò - ïèøèòå ìíå â /sms [ID: '..myID..']')
					imgui.Text(u8'Âû ìîæåòå áðàòü ëþáîé ÒÑ è èñêàòü äàííûé ïðåäìåò.\nÏðàâèëà ÌÏ:\nÇàïðåùåíû ÷èòû, àäì. âîçìîæíîñòè è íàðóøåíèÿ ëþáûõ ïðàâèë ñåðâåðà.\nÑìåíà ñêèíà/êëèñòà.\nÑåé÷àñ ÿ âàì ïîêàæó ýòîò ïðåäìåò.')
					imgui.EndTooltip()
				end
				imgui.EndChild()
			end
		end
		imgui.PopFont()
	elseif menuSwitch == 3 then
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 695, 235
		imgui.PushFont(myFont) 
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'Íàñòðîéêè', menu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.BeginChild('##settings1', imgui.ImVec2(300,195), 0)
		if ad.ToggleButton(u8'Login', elements.value.autologin) then
			config['settings']['autologin'] = elements.value.autologin[0]
			saveConfig()
		end imgui.TextQuestion(u8'Àâòîìàòè÷åñêèé âõîä ïîä àêêàóíò')
		if ad.ToggleButton(u8'Alogin', elements.value.autoalogin) then
			config['settings']['autoalogin'] = elements.value.autoalogin[0]
			saveConfig()
		end imgui.TextQuestion(u8'Àâòîìàòè÷åñêèé âõîä ïîä àäìèíêó')
		if ad.ToggleButton(u8'TEMPLEADER ïðè âõîäå', elements.value.autoleader) then
			config['settings']['autoleader'] = elements.value.autoleader[0]
			saveConfig()
		end imgui.TextQuestion(u8'Ïîñëå âõîäà ïîä àäìèíêó çàõîäèòå ïîä âðåìåííóþ ëèäåðêó')
		if ad.ToggleButton(u8'AGM ïðè âõîäå', elements.value.autogm) then
			config['settings']['autogm'] = elements.value.autogm[0]
			saveConfig()
		end imgui.TextQuestion(u8'Ïîñëå âõîäà ïîä àäìèíêó âêëþ÷àåòñÿ /agm')
		if ad.ToggleButton(u8'CONNECT ïðè âõîäå', elements.value.autoconnect) then
			config['settings']['autoconnect'] = elements.value.autoconnect[0]
			saveConfig()
		end imgui.TextQuestion(u8'Ïîñëå âõîäà ïîä àäìèíêó âêëþ÷àåòñÿ /connect')
		if ad.ToggleButton(u8'Ïðèâåòñòâèå ïðè âõîäå ïîä àäìèíêó', elements.value.ahi) then 
			config['settings']['ahi'] = elements.value.ahi[0]
			saveConfig()
		end imgui.TextQuestion(u8'Ïîñëå âõîäà ïîä àäìèíêó âîñïðîèçâîäèòüñÿ çâóê ïðèâåòñòâèÿ')
		if ad.ToggleButton(u8'Óêîðî÷åííûé ÷àò', elements.value.shortadm) then 
			config['settings']['shortadm'] = elements.value.shortadm[0]
			saveConfig()
		end imgui.TextQuestion(u8'Çàìåíÿåò "Àäìèíèñòðàòîð" íà "A:" è óêîðà÷èâàåò ïðåôèêñû')
		if ad.ToggleButton(u8'Àâòî-ïðîáèòèå pgetip ïî getip', elements.value.pgetip) then
			config['settings']['pgetip'] = elements.value.pgetip[0]
			saveConfig()
		end
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild('##settings2', imgui.ImVec2(350,195), 0)
		imgui.PushItemWidth(150)
		if imgui.InputText(u8'##pass', elements.buffer.password, 32, imgui.InputTextFlags.Password) then
			config['settings']['password'] = str(elements.buffer.password)
			saveConfig()
		end
		if imgui.InputText(u8'##apass', elements.buffer.apassword, 16, imgui.InputTextFlags.Password) then
			config['settings']['apassword'] = str(elements.buffer.apassword)
			saveConfig()
		end
		if imgui.ComboStr('##autoleader', elements.value.leaderid, autoleaderCombo .. '\0', -1) then
			config['settings']['leaderid'] = elements.value.leaderid[0]+1
	        saveConfig()
		end
		if ad.ToggleButton(u8'EARS ïðè âõîäå', elements.value.autoears) then
			config['settings']['autoears'] = elements.value.autoears[0]
			saveConfig()
		end imgui.TextQuestion(u8'Ïîñëå âõîä ïîä àäìèíêó âêëþ÷àåòñÿ /ears')
		if ad.ToggleButton(u8'AINFO ïðè âõîäå', elements.value.autoainfo) then
			config['settings']['autoainfo'] = elements.value.autoainfo[0]
			saveConfig()
		end imgui.TextQuestion(u8'Ïîñëå âõîäà ïîä àäìèíêó âûêëþ÷àåòñÿ /ainfo')
		if ad.ToggleButton(u8'Àâòîìàòè÷åñêèé ÒÏ â ìåñòî äëÿ AFK', elements.value.akv) then
			config['settings']['akv'] = elements.value.akv[0]
			saveConfig()
		end imgui.TextQuestion(u8'Ïîñëå âõîäà ïîä àäìèíêó òåëåïîðòèðóåòåñü â /inter 72') 
		if ad.ToggleButton(u8'MSG-ñîîáùåíèÿ', elements.value.msginfo) then
			config['settings']['msginfo'] = elements.value.msginfo[0]
			saveConfig()
		end imgui.TextQuestion(u8'Èñïîëüçóéòå: /amsg [1-2]')
		imgui.PopItemWidth()
		imgui.EndChild()
		imgui.PopFont()
	elseif menuSwitch == 4 then
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 695, 240
		imgui.PushFont(myFont)
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'Âûäà÷à âûãîâîðîâ', menu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.SetCursorPos(imgui.ImVec2(10, 30))
		imgui.BeginChild('Nakaz##1'..warn_navigation.current, imgui.ImVec2(140,105), false)
		for i, title in ipairs(warn_navigation.list) do
			if HeaderButton(warn_navigation.current == i, title) then
				warn_navigation.current = i
			end
		end
		imgui.EndChild()
		imgui.SameLine(145)
		imgui.BeginChild('Nakaz##2', imgui.ImVec2(540,200), 0)
		if warn_navigation.current == 1 then
			imgui.InputTextWithHint(u8'##333', u8'Ââåäèòå nickname', input_nameawarn, sizeof(input_nameawarn))
			imgui.TextQuestionMp(u8'Ââåäèòå íèê è âûáåðèòå íèæå ïðè÷èíó')
			if imgui.CollapsingHeader(u8'Ñïèñîê íàêàçàíèé') then
				if imgui.Button(u8'1. Íåíîðìàòèâíàÿ ëåêñèêà â ÷àò, â ñòîðîíó èãðîêîâ/àäìèíèñòðàòîðîâ  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 1')
				end
				if imgui.Button(u8'2. DM èãðîêîâ  2 âûãîâîðà') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 2')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 2')
					end)
				end
				if imgui.Button(u8'3. Âûäàâàòü íàêàçàíèå íå èìåÿ äîêàçàòåëüñòâ íàðóøåíèÿ  2 âûãîâîðà') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 3')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 3')
					end)
				end
				if imgui.Button(u8'4. Çàñîðåíèå ðåïîðòà  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 4')
				end
				if imgui.Button(u8'5. Îñêîðáëåíèå àäìèíèñòðàòîðîâ/èãðîêîâ  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 5')
				end
				if imgui.Button(u8'6. Ïîêóïêà/Ïðîäàæà ÷åãî-ëèáî â /a  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 6')
				end
				if imgui.Button(u8'7. Ïîìåõà äðóãèì àäìèíèñòðàòîðàì  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 7')
				end
				if imgui.Button(u8'8. Ðåêëàìà/Ðåêëàìà ñ òâèíêîâ  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 8')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 8')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 8')
					end)
				end
				if imgui.Button(u8'9. Îôôòîï â /msg  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 9')
				end
				if imgui.Button(u8'10. Áëàò êîãî-ëèáî èç èãðîêîâ/àäìèíèñòðàòîðîâ  2 âûãîâîðà') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 10')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 10')
					end)
				end
				if imgui.Button(u8'11. Ïîìåõà/Âëåçàíèå â ÐÏ ïðîöåññ  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 11')
				end
				if imgui.Button(u8'12. Ïðîâåðêà èãðîêîâ íà ÷èòû ÷åðåç ñêàéï èëè äèñêîðä  2 âûãîâîðà') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 12')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 12')
					end)
				end
				if imgui.Button(u8'13. Ïîïðîøàéíè÷åñòâî  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 13')
				end
				if imgui.Button(u8'14. Èñïîëüçîâàíèå ÷èòîâ ïðîòèâ èãðîêîâ  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 14')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 14')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 14')
					end)
				end
				if imgui.Button(u8'15. Âûäà÷à íàêàçàíèé ïî ïðîñüáå äðóãîãî àäìèíèñòðàòîðà  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 15')
				end
				if imgui.Button(u8'16. Íàëè÷èå áîëåå 1 àäìèí àêêàóíòà  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 16')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 16')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 16')
					end)
				end
				if imgui.Button(u8'17. Âûäà÷à íàêàçàíèé çà SMS àäìèíèñòðàöèè  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 17')
				end
				if imgui.Button(u8'18. Âûäà÷à íàêàçàíèé çà ÄÌ àäìèíèñòðàöèè  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 18')
				end
				if imgui.Button(u8'19. Íàêðóòêà ðåïóòàöèè  ñíÿòèå') then 
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 19')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 19')
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 19')
					end)
				end
				if imgui.Button(u8'20. Âûïðàøèâàíèå îöåíêè îòâåòà íà ðåïîðò  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 20', -1)
				end
				if imgui.Button(u8'21. Âûäà÷à âûãîâîðà â îòâåò  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 21', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 21', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 21', -1)
					end)
				end
				if imgui.Button(u8'22. Ïîäñòàâíûå äåéñòâèÿ íà ñíÿòèå  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 22', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 22', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 22', -1)
					end)
				end
				if imgui.Button(u8'23. Ðîçæèã êîíôëèêòà  2 âûãîâîðà') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 23', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 23', -1)
					end)
				end
				if imgui.Button(u8'24. Íàðóøåíèå ïðàâèë àäìèíèñòðàöèè 3+ ðàç  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 24', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 24', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 24', -1)
					end)
				end
				if imgui.Button(u8'25. Îñê. êðàñíîé àäìèíèñòðàöèè è óïîìèíàíèå/îñê. èõ ðîäíè  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 25', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 25', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 25', -1)
					end)
				end
				if imgui.Button(u8'26. Ñóììèðîâàíèå íàêàçàíèé  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 26', -1)
				end
				if imgui.Button(u8'27. Ðîçæèã ìåæíàöèîíàëüíîé ðîçíè  2 âûãîâîðà') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 27', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 27', -1)
					end)
				end
				if imgui.Button(u8'28. Ðàñïðîñòðàíåíèå ñòîðîííèõ ñêðèïòîâ  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 28', -1)
				end
				if imgui.Button(u8'29. Çëîóïîòðåáëåíèå êàïñîì â /a /v  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 29', -1)
				end
				if imgui.Button(u8'30. Ïîìîùü íà êàïòå/áèçâàðå  2 âûãîâîðà') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 30', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 30', -1)
					end)
				end
				if imgui.Button(u8'31. Ñëèâ òåððèòîðèé/áèçíåñîâ  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 31', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 31', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 32', -1)
					end)
				end
				if imgui.Button(u8'32. Ðàçãëàøåíèå öåí ïëàòíûõ êîìàíä  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 32', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 32', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 32', -1)
					end)
				end
				if imgui.Button(u8'33. Áàëîâñòâî êîìàíäàìè  2 âûãîâîðà') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 33', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 33', -1)
					end)
				end
				if imgui.Button(u8'34. Èñïîëüçîâàíèå áàãîâ ñåðâåðà äëÿ ïîëó÷åíèÿ ìàòåðèàëüíîé âûãîäû  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 34', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 34', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 34', -1)
					end)
				end
				if imgui.Button(u8'35. Íàðóøåíèå ïðàâèë ïðîâåðêè æàëîá  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 35', -1)
				end
				if imgui.Button(u8'36. Îñêîðáëåíèå ñåðâåðà  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 36', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 36', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 36', -1)
					end)
				end
				if imgui.Button(u8'37. Èñïîëüçîâàíèå /pm â ëè÷íûõ öåëÿõ  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 37', -1)
				end
				if imgui.Button(u8'38. Ôëóä àäìèí-êîìàíäàìè  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 38', -1)
				end
				if imgui.Button(u8'39. Èñï. âðåä.÷èòîâ/âðåä.÷èòû ñ òâèíêîâ ïðîòèâ èãðîêîâ/àäì  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 39', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 39', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 39', -1)
					end)
				end
				if imgui.Button(u8'40. Îñêîðáëåíèå/óïîìèíàíèå ðîäñòâåííèêîâ èëè îòâåò âçàèìíîñòüþ  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 40', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 40', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 40', -1)
					end)
				end
				if imgui.Button(u8'41. Êàïñ/ôëóä â ÷àò, â ñòîðîíó èãðîêîâ/àäìèíèñòðàòîðîâ  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 41', -1)
				end
				if imgui.Button(u8'42. Íåâåðíàÿ âûäà÷à íàêàçàíèÿ èãðîêó/àäìèíèñòðàòîðó  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 42', -1)
				end
				if imgui.Button(u8'43. Íåâåðíîå ðàññìîòðåíèå æàëîáû íà ôîðóìå  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 43', -1)
				end
				if imgui.Button(u8'44. Ïðîäàæà èìóùåñòâà çà ðåàëüíóþ âàëþòó  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 44', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 44', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 44', -1)
					end)
				end
				if imgui.Button(u8'45. Ñëèâ ïðîäóêòîâ áèçíåñà  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 45', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 45', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 45', -1)
					end)
				end
				if imgui.Button(u8'46. Ïðîäàæà/Ïåðåäà÷à/Âçëîì àêêàóíòà  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 46', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 46', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 46', -1)
					end)
				end
				if imgui.Button(u8'47. NonRP ðàçâîä | Ïîäêèä | Ðàçâîä /try  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 47', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 47', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 47', -1)
					end)
				end
				if imgui.Button(u8'48. NonRP NickName  2 âûãîâîðà') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 48', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 48', -1)
					end)
				end
				if imgui.Button(u8'49. Ñëèâ ïðàâ  ñíÿòèå') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 49', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 49', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 49', -1)
					end)
				end
				if imgui.Button(u8'50. Íåóâàæèòåëüíûé îòâåò èãðîêó  2 âûãîâîðà') then
					local aname = str(input_nameawarn)
					lua_thread.create(function()
						sampSendChat('/awarn '..aname..' /regulations > 50', -1)
						wait(1300)
						sampSendChat('/awarn '..aname..' /regulations > 50', -1)
					end)
				end
				if imgui.Button(u8'51. Âûäà÷à íàêàçàíèÿ ñ íåïîëíîé ïðè÷èíîé  1 âûãîâîð') then
					local aname = str(input_nameawarn)
					sampSendChat('/awarn '..aname..' /regulations > 51', -1)
				end				
			end
		elseif warn_navigation.current == 2 then
			imgui.InputTextWithHint(u8'##444', u8'Ââåäèòå nickname', input_namelwarn, sizeof(input_namelwarn))
			imgui.TextQuestionMp(u8'Ââåäèòå íèê è âûáåðèòå íèæå ïðè÷èíó')
			if imgui.CollapsingHeader(u8'×àñòûå ïðè÷èíû') then
				if imgui.Button(u8'Íåàêòèâ 24+ ÷àñîâ') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Íåàêòèâ 24+ ÷àñîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Íåàêòèâ 24+ ÷àñîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Íåàêòèâ 24+ ÷àñîâ', -1)
					end)
				end
				if imgui.Button(u8'Íîðìà îíëàéíà îòûãðîâêè çà äåíü 1 ÷àñ.') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Íåò íîðìû îíëàéíà 1 ÷àñ.', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Íåò íîðìû îíëàéíà 1 ÷àñ.', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Íåò íîðìû îíëàéíà 1 ÷àñ.', -1)
					end)
				end
				if imgui.Button(u8'Óïîìèíàíèå ðîäíûõ') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Óïîìèíàíèå ðîäíûõ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Óïîìèíàíèå ðîäíûõ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Óïîìèíàíèå ðîäíûõ', -1)
					end)
				end
				if imgui.Button(u8'Íåàäåêâàò') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' Íåàäåêâàò')
				end
			end
			if imgui.CollapsingHeader(u8'Äëÿ ÃÑ/ÇÃÑ') then
				if imgui.Button(u8'[Ãîñ. ñòðóêòóðû] Îòñóòñòâèå îò÷¸òà 1/3') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Îòñóòñòâèå îò÷¸òà 1/3', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Îòñóòñòâèå îò÷¸òà 1/3', -1)
						end)
					end
					imgui.SameLine()
					if imgui.Button(u8'[Ãîñ. ñòðóêòóðû] Íåâåðíûé îò÷¸ò 1/4') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Íåâåðíûé îò÷¸ò 1/4', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Íåâåðíûé îò÷¸ò 1/4', -1)
						end)
					end
					if imgui.Button(u8'[Ãîñ. ñòðóêòóðû] Îòñóòñòâèå îò÷¸òà 2/3') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Îòñóòñòâèå îò÷¸òà 2/3', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Îòñóòñòâèå îò÷¸òà 2/3', -1)
						end)
					end
					imgui.SameLine()
					if imgui.Button(u8'[Ãîñ. ñòðóêòóðû] Íåâåðíûé îò÷¸ò 2/4') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Íåâåðíûé îò÷¸ò 2/4', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Íåâåðíûé îò÷¸ò 2/4', -1)
						end)
					end
					if imgui.Button(u8'[Ãîñ. ñòðóêòóðû] Îòñóòñòâèå îò÷¸òà 3/3') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Îòñóòñòâèå îò÷¸òà 3/3', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Îòñóòñòâèå îò÷¸òà 3/3', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Îòñóòñòâèå îò÷¸òà 3/3', -1)
						end)
					end
					imgui.SameLine()
					if imgui.Button(u8'[Ãîñ. ñòðóêòóðû] Íåâåðíûé îò÷¸ò 3/4') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Íåâåðíûé îò÷¸ò 3/4', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Íåâåðíûé îò÷¸ò 3/4', -1)
						end)
					end
					if imgui.Button(u8'[Ãîñ. ñòðóêòóðû] Íåâåðíûé îò÷¸ò 4/4') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Íåâåðíûé îò÷¸ò 4/4', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Íåâåðíûé îò÷¸ò 4/4', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Íåâåðíûé îò÷¸ò 4/4', -1)
						end)
					end
					if imgui.Button(u8'[Ãîñ. ñòðóêòóðû] Îòêàç îò ïðèíÿòèÿ ó÷àñòèÿ â ãëîáàëüíûõ ìåðîïðèÿòèÿõ') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Îòêàç îò ïðèíÿòèÿ ó÷àñòèÿ â ãëîáàëüíûõ ìåðîïðèÿòèÿõ', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Îòêàç îò ïðèíÿòèÿ ó÷àñòèÿ â ãëîáàëüíûõ ìåðîïðèÿòèÿõ', -1)
						end)
					end
					if imgui.Button(u8'[Ãåòòî | Ìàôèè] Ìåíåå äâóõ çàõâàòîâ çà äåíü 1/3') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Ìåíåå äâóõ çàõâàòîâ çà äåíü 1/3', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Ìåíåå äâóõ çàõâàòîâ çà äåíü 1/3', -1)
						end)
					end
					if imgui.Button(u8'[Ãåòòî | Ìàôèè] Ìåíåå äâóõ çàõâàòîâ çà äåíü 2/3') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Ìåíåå äâóõ çàõâàòîâ çà äåíü 2/3', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Ìåíåå äâóõ çàõâàòîâ çà äåíü 2/3', -1)
						end)
					end
					if imgui.Button(u8'[Ãåòòî | Ìàôèè] Ìåíåå äâóõ çàõâàòîâ çà äåíü 3/3') then
					local lname = str(input_namelwarn)
						lua_thread.create(function()
							sampSendChat('/lwarn '..lname..' Ìåíåå äâóõ çàõâàòîâ çà äåíü 3/3', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Ìåíåå äâóõ çàõâàòîâ çà äåíü 3/3', -1)
							wait(1300)
							sampSendChat('/lwarn '..lname..' Ìåíåå äâóõ çàõâàòîâ çà äåíü 3/3', -1)
						end)
					end
				end
			if imgui.CollapsingHeader(u8'Ñïèñîê íàêàçàíèé') then
				if imgui.Button(u8'Íåàäåêâàò') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' Íåàäåêâàò')
				end
				if imgui.Button(u8'Íåàäåêâàòíîå ïîâåäåíèå íà ôîðóìå') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' Íåàäåêâàòíîå ïîâåäåíèå íà ôîðóìå')
				end
				if imgui.Button(u8'Óïîìèíàíèå ðîäíûõ') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Óïîìèíàíèå ðîäíûõ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Óïîìèíàíèå ðîäíûõ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Óïîìèíàíèå ðîäíûõ', -1)
					end)
				end
				if imgui.Button(u8'DeathMatch') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' DeathMatch')
				end
				if imgui.Button(u8'DriveBy') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' DriveBy')
				end
				if imgui.Button(u8'TeamKill') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' TeamKill')
				end
				if imgui.Button(u8'SpawnKill') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' SpawnKill')
				end
				if imgui.Button(u8'Óâîëüíåíèå áåç ïðè÷èí') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' Óâîëüíåíèå áåç ïðè÷èí')
				end
				if imgui.Button(u8'Ïðèíÿòèå èãðîêà ñ NonRP íèêîì â îðãàíèçàöèþ') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' Ïðèíÿòèå èãðîêà ñ NonRP íèêîì â îðãàíèçàöèþ')
				end
				if imgui.Button(u8'NonRP') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' NonRP')
				end
				if imgui.Button(u8'Ðåêëàìà') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Ðåêëàìà', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ðåêëàìà', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ðåêëàìà', -1)
					end)
				end
				if imgui.Button(u8'Ðàñôîðì (îò 5+ ÷åëîâåê)') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Ðàñôîðì', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ðàñôîðì', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ðàñôîðì', -1)
					end)
				end
				if imgui.Button(u8'×èòû') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' ×èòû', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' ×èòû', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' ×èòû', -1)
					end)
				end
				if imgui.Button(u8'×èòû ñ òâèíêîâ') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' ×èòû ñ òâèíêîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' ×èòû ñ òâèíêîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' ×èòû ñ òâèíêîâ', -1)
					end)
				end
				if imgui.Button(u8'Áëàò') then
				local lname = str(input_namelwarn)
				sampSendChat('/lwarn '..lname..' Áëàò')
				end
				if imgui.Button(u8'Íîðìà îíëàéíà îòûãðîâêè çà äåíü 1 ÷àñ.') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Íåò íîðìû îíëàéíà 1 ÷àñ.', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Íåò íîðìû îíëàéíà 1 ÷àñ.', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Íåò íîðìû îíëàéíà 1 ÷àñ.', -1)
					end)
				end
				if imgui.Button(u8'Íåàêòèâ 24+ ÷àñîâ') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Íåàêòèâ 24+ ÷àñîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Íåàêòèâ 24+ ÷àñîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Íåàêòèâ 24+ ÷àñîâ', -1)
					end)
				end
				if imgui.Button(u8'NonRP íàçâàíèÿ ðàíãîâ') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' NonRP íàçâàíèÿ ðàíãîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' NonRP íàçâàíèÿ ðàíãîâ', -1)
					end)
				end
				if imgui.Button(u8'Ñëèâ òåððèòîðèé/áèçíåñîâ') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Ñëèâ òåððèòîðèé/áèçíåñîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ñëèâ òåððèòîðèé/áèçíåñîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ñëèâ òåððèòîðèé/áèçíåñîâ', -1)
					end)
				end
				if imgui.Button(u8'Íàëè÷èå áîëåå îäíîé ëèäåðêè') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Íàëè÷èå áîëåå îäíîé ëèäåðêè', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Íàëè÷èå áîëåå îäíîé ëèäåðêè', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Íàëè÷èå áîëåå îäíîé ëèäåðêè', -1)
					end)
				end
				if imgui.Button(u8'Ïðîäàæà/ïîêóïêà ëèäåðêè') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Ïðîäàæà/ïîêóïêà ëèäåðêè', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ïðîäàæà/ïîêóïêà ëèäåðêè', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ïðîäàæà/ïîêóïêà ëèäåðêè', -1)
					end)
				end
				if imgui.Button(u8'Ïðîäàæà ðàíãà') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Ïðîäàæà ðàíãà', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ïðîäàæà ðàíãà', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ïðîäàæà ðàíãà', -1)
					end)
				end
				if imgui.Button(u8'Èãðà ñ òâèíêîâ çà ïðîòèâîïîëîæíóþ áàíäó/ìàôèþ') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Èãðà ñ òâèíêîâ çà ïðîòèâîïîëîæíóþ áàíäó/ìàôèþ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Èãðà ñ òâèíêîâ çà ïðîòèâîïîëîæíóþ áàíäó/ìàôèþ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Èãðà ñ òâèíêîâ çà ïðîòèâîïîëîæíóþ áàíäó/ìàôèþ', -1)
					end)
				end
				if imgui.Button(u8'Ïåðåäà÷à ëèäåðñêîãî ïîñòà íà òâèíê àêêàóíò') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Ïåðåäà÷à ëèäåðñêîãî ïîñòà íà òâèíê àêêàóíò', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ïåðåäà÷à ëèäåðñêîãî ïîñòà íà òâèíê àêêàóíò', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ïåðåäà÷à ëèäåðñêîãî ïîñòà íà òâèíê àêêàóíò', -1)
					end)
				end
				if imgui.Button(u8'Ðîçæèã ìåæíàöèîíàëüíîé ðîçíè, â òîì ÷èñëå íàçâàíèÿ ðàíãîâ') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Ðîçæèã', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ðîçæèã', -1)
					end)
				end
				if imgui.Button(u8'Ñëèâ ïîñòà/ëèäåðîâ') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Ñëèâ ïîñòà/ëèäåðîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ñëèâ ïîñòà/ëèäåðîâ', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Ñëèâ ïîñòà/ëèäåðîâ', -1)
					end)
				end
				if imgui.Button(u8'Îñêîðáëåíèå ïðîåêòà') then
				local lname = str(input_namelwarn)
					lua_thread.create(function()
						sampSendChat('/lwarn '..lname..' Îñêîðáëåíèå ïðîåêòà', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Îñêîðáëåíèå ïðîåêòà', -1)
						wait(1300)
						sampSendChat('/lwarn '..lname..' Îñêîðáëåíèå ïðîåêòà', -1)
					end)
				end
			end
		elseif warn_navigation.current == 3 then
			imgui.InputTextWithHint(u8'##555', u8'Ââåäèòå nickname', input_nameswarn, sizeof(input_nameswarn))
			if imgui.CollapsingHeader(u8'Äëÿ ÃÑ/ÇÃÑ') then
			if imgui.Button(u8'Íàëè÷èå 0 îòâåòîâ íà ïîñòó ñàïïîðòà') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Íàëè÷èå 0 îòâåòîâ íà ïîñòó ñàïïîðòà')
					wait(1300)
					sampSendChat('/swarn '..sname..' Íàëè÷èå 0 îòâåòîâ íà ïîñòó ñàïïîðòà')
				end)
				end
			end
			if imgui.CollapsingHeader(u8'Ñïèñîê íàêàçàíèé') then
				if imgui.Button(u8'Íåâåðíûé îòâåò èãðîêó') then
				local sname = str(input_nameswarn)
				sampSendChat('/swarn '..sname..' Íåâåðíûé îòâåò èãðîêó')
				end
				if imgui.Button(u8'Èñïîëüçîâàíèå êîìàíäû äëÿ îòâåòîâ â ëè÷íûõ öåëÿõ') then
				local sname = str(input_nameswarn)
				sampSendChat('/swarn '..sname..' Èñïîëüçîâàíèå êîìàíäû äëÿ îòâåòîâ â ëè÷íûõ öåëÿõ')
				end
				if imgui.Button(u8'Ëþáûå íàðóøåíèÿ ïðàâèë ñåðâåðà ñî ñòîðîíû èãðîâîãî ïðîöåññà (DM/Îñêîðáëåíèÿ/Íåàäåêâàò)') then
				local sname = str(input_nameswarn)
				sampSendChat('/swarn '..sname..' Íàðóøåíèå ïðàâèë ñåðâåðà ñî ñòîðîíû èãðîâîêî ïðîöåññà')
				end
				if imgui.Button(u8'Çàñîðåíèå ÷àòà ñàïïîðòîâ (Ïîêóïêà/Ïðîäàæà/Ôëóä)') then
				local sname = str(input_nameswarn)
				sampSendChat('/swarn '..sname..' Çàñîðåíèå ÷àòà ñàïïîðòîâ')
				end
				if imgui.Button(u8'Èãíîðèðîâàíèå ïðîñüáû ãëàâíîãî ñëåäÿùåãî çà ñàïïîðòàìè') then
				local sname = str(input_nameswarn)
				sampSendChat('/swarn '..sname..' Èãíîðèðîâàíèå ïðîñüáû ãëàâíîãî ñëåäÿùåãî çà ñàïïîðòàìè')
				end
				if imgui.Button(u8'Âûäà÷à áëîêèðîâêè ðåïîðòà, íå èìåÿ äîêàçàòåëüñòâ íàðóøåíèÿ') then
				local sname = str(input_nameswarn)
				sampSendChat('/swarn '..sname..' Âûäà÷à áëîêèðîâêè ðåïîðòà, íå èìåÿ äîêàçàòåëüñòâ íàðóøåíèÿ')
				end
				if imgui.Button(u8'Íàëè÷èå îøèáîê â îòâåòå') then
				local sname = str(input_nameswarn)
				sampSendChat('/swarn '..sname..' Íàëè÷èå îøèáîê â îòâåòå')
				end
				if imgui.Button(u8'Ïðîÿâëåíèå íåãðàìîòíîñòè ïðè îòâåòå') then
				local sname = str(input_nameswarn)
				sampSendChat('/swarn '..sname..' Ïðîÿâëåíèå íåãðàìîòíîñòè ïðè îòâåòå')
				end
				if imgui.Button(u8'Íåïîëíîöåííûå îòâåòû') then
				local sname = str(input_nameswarn)
				sampSendChat('/swarn '..sname..' Íåïîëíîöåííûå îòâåòû')
				end
				if imgui.Button(u8'Òðàíñëèò â îòâåòå èãðîêó â îòâåòå') then
				local sname = str(input_nameswarn)
				sampSendChat('/swarn '..sname..' Òðàíñëèò â îòâåòå èãðîêó â îòâåòå')
				end
				if imgui.Button(u8'Ïîïðîøàéíè÷åñòâî â ÷àòå ñàïïîðòîâó') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Ïîïðîøàéíè÷åñòâî â ÷àòå ñàïïîðòîâó')
					wait(1300)
					sampSendChat('/swarn '..sname..' Ïîïðîøàéíè÷åñòâî â ÷àòå ñàïïîðòîâó')
				end)
				end
				if imgui.Button(u8'Ïîïðîøàéíè÷åñòâî â îòâåòå èãðîêó') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Ïîïðîøàéíè÷åñòâî â îòâåòå èãðîêó')
					wait(1300)
					sampSendChat('/swarn '..sname..' Ïîïðîøàéíè÷åñòâî â îòâåòå èãðîêó')
				end)
				end
				if imgui.Button(u8'Íåóâàæèòåëüíûé îòâåò èãðîêó') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Íåóâàæèòåëüíûé îòâåò èãðîêó')
					wait(1300)
					sampSendChat('/swarn '..sname..' Íåóâàæèòåëüíûé îòâåò èãðîêó')
				end)
				end
				if imgui.Button(u8'Îòñóòñòâèå íîðìû îòûãðàííîãî âðåìåíè çà ñóòêè (1 ÷àñ)') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Îòñóòñòâèå íîðìû îòûãðàííîãî âðåìåíè çà ñóòêè (1 ÷àñ)')
					wait(1300)
					sampSendChat('/swarn '..sname..' Îòñóòñòâèå íîðìû îòûãðàííîãî âðåìåíè çà ñóòêè (1 ÷àñ)')
					wait(1300)
					sampSendChat('/swarn '..sname..' Îòñóòñòâèå íîðìû îòûãðàííîãî âðåìåíè çà ñóòêè (1 ÷àñ)')
				end)
				end
				if imgui.Button(u8'Íåàêòèâíîñòü â òå÷åíèå 24 ÷àñîâ') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Íåàêòèâíîñòü â òå÷åíèå 24 ÷àñîâ')
					wait(1300)
					sampSendChat('/swarn '..sname..' Íåàêòèâíîñòü â òå÷åíèå 24 ÷àñîâ')
					wait(1300)
					sampSendChat('/swarn '..sname..' Íåàêòèâíîñòü â òå÷åíèå 24 ÷àñîâ')
				end)
				end
				if imgui.Button(u8'Îñêîðáëåíèå ðîäíûõ â îòâåòå') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Îñêîðáëåíèå ðîäíûõ â îòâåòå')
					wait(1300)
					sampSendChat('/swarn '..sname..' Îñêîðáëåíèå ðîäíûõ â îòâåòå')
					wait(1300)
					sampSendChat('/swarn '..sname..' Îñêîðáëåíèå ðîäíûõ â îòâåòå')
				end)
				end
				if imgui.Button(u8'Îñêîðáëåíèå ðîäíûõ â ÷àòå ñàïïîðòîâ') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Îñêîðáëåíèå ðîäíûõ â ÷àòå ñàïïîðòîâ')
					wait(1300)
					sampSendChat('/swarn '..sname..' Îñêîðáëåíèå ðîäíûõ â ÷àòå ñàïïîðòîâ')
					wait(1300)
					sampSendChat('/swarn '..sname..' Îñêîðáëåíèå ðîäíûõ â ÷àòå ñàïïîðòîâ')
				end)
				end
				if imgui.Button(u8'Íàêðóòêà îòâåòîâ') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Íàêðóòêà îòâåòîâ')
					wait(1300)
					sampSendChat('/swarn '..sname..' Íàêðóòêà îòâåòîâ')
					wait(1300)
					sampSendChat('/swarn '..sname..' Íàêðóòêà îòâåòîâ')
				end)
				end
				if imgui.Button(u8'Ðàçãëàøåíèå êîìàíä è âîçìîæíîñòåé ñàïïîðòà') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Ðàçãëàøåíèå êîìàíä è âîçìîæíîñòåé ñàïïîðòà')
					wait(1300)
					sampSendChat('/swarn '..sname..' Ðàçãëàøåíèå êîìàíä è âîçìîæíîñòåé ñàïïîðòà')
					wait(1300)
					sampSendChat('/swarn '..sname..' Ðàçãëàøåíèå êîìàíä è âîçìîæíîñòåé ñàïïîðòà')
				end)
				end
				if imgui.Button(u8'Íåàäåêâàòíîå ïîâåäåíèå â îòâåòå (Îñêîðáëåíèÿ/Êàïñ/Ìàò)') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Íåàäåêâàòíîå ïîâåäåíèå â îòâåòå')
					wait(1300)
					sampSendChat('/swarn '..sname..' Íåàäåêâàòíîå ïîâåäåíèå â îòâåòå')
					wait(1300)
					sampSendChat('/swarn '..sname..' Íåàäåêâàòíîå ïîâåäåíèå â îòâåòå')
				end)
				end
				if imgui.Button(u8'Íåàäåêâàòíîå ïîâåäåíèå â ÷àòå ñàïïîðòîâ (Îñêîðáëåíèÿ/Êàïñ/Ìàò)') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Íåàäåêâàòíîå ïîâåäåíèå â ÷àòå ñàïïîðòîâ')
					wait(1300)
					sampSendChat('/swarn '..sname..' Íåàäåêâàòíîå ïîâåäåíèå â ÷àòå ñàïïîðòîâ')
					wait(1300)
					sampSendChat('/swarn '..sname..' Íåàäåêâàòíîå ïîâåäåíèå â ÷àòå ñàïïîðòîâ')
				end)
				end
				if imgui.Button(u8'Îñêîðáëåíèå ñëåäÿùèõ çà ñàïïîðòàìè') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Îñêîðáëåíèå ñëåäÿùèõ çà ñàïïîðòàìè')
					wait(1300)
					sampSendChat('/swarn '..sname..' Îñêîðáëåíèå ñëåäÿùèõ çà ñàïïîðòàìè')
					wait(1300)
					sampSendChat('/swarn '..sname..' Îñêîðáëåíèå ñëåäÿùèõ çà ñàïïîðòàìè')
				end)
				end
				if imgui.Button(u8'NonRP íèê') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' NonRP íèê')
					wait(1300)
					sampSendChat('/swarn '..sname..' NonRP íèê')
					wait(1300)
					sampSendChat('/swarn '..sname..' NonRP íèê')
				end)
				end
				if imgui.Button(u8'Èñïîëüçîâàíèå ÷èòîâ íà ïîñòó ñàïïîðòà') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Èñïîëüçîâàíèå ÷èòîâ íà ïîñòó ñàïïîðòà')
					wait(1300)
					sampSendChat('/swarn '..sname..' Èñïîëüçîâàíèå ÷èòîâ íà ïîñòó ñàïïîðòà')
					wait(1300)
					sampSendChat('/swarn '..sname..' Èñïîëüçîâàíèå ÷èòîâ íà ïîñòó ñàïïîðòà')
				end)
				end
				if imgui.Button(u8'Ïðîâîêàöèîííûå âîïðîñû (Êîìàíäû/Âîçìîæíîñòè ñàïïîðòà)') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Ïðîâîêàöèîííûå âîïðîñû (Êîìàíäû/Âîçìîæíîñòè ñàïïîðòà)')
					wait(1300)
					sampSendChat('/swarn '..sname..' Ïðîâîêàöèîííûå âîïðîñû (Êîìàíäû/Âîçìîæíîñòè ñàïïîðòà)')
					wait(1300)
					sampSendChat('/swarn '..sname..' Ïðîâîêàöèîííûå âîïðîñû (Êîìàíäû/Âîçìîæíîñòè ñàïïîðòà)')
				end)
				end
				if imgui.Button(u8'Ñëèâ ïîñòà ñàïïîðòà') then
				local sname = str(input_nameswarn)
				lua_thread.create(function()
					sampSendChat('/swarn '..sname..' Ñëèâ ïîñòà ñàïïîðòà')
					wait(1300)
					sampSendChat('/swarn '..sname..' Ñëèâ ïîñòà ñàïïîðòà')
					wait(1300)
					sampSendChat('/swarn '..sname..' Ñëèâ ïîñòà ñàïïîðòà')
				end)
				end
			end
		end
		imgui.EndChild()
		imgui.PopFont()
		elseif menuSwitch == 5 then
			local resX, resY = getScreenResolution()
			local sizeX, sizeY = 505, 200
			imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
			imgui.Begin(u8'Ôëóäåð', menu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
			for i = 1, 5 do
				imgui.BeginChild('##flooderChild1', imgui.ImVec2(350, 135), 0)
				imgui.PushItemWidth(350)
				if imgui.InputTextWithHint(u8('##Òåêñò'.. i), u8'Òåêñò', inputTexts[i], sizeof(inputTexts[i])) then end
				imgui.PopItemWidth()
				imgui.EndChild()
				imgui.SameLine()
				imgui.BeginChild('##flooderChild2', imgui.ImVec2(80, 135), 0)
				imgui.PushItemWidth(75)
				if imgui.InputTextWithHint(u8('##Çàäåðæêà'.. i), u8'Çàäåðæêà', inputDelays[i], sizeof(inputDelays[i]), imgui.InputTextFlags.CharsDecimal) then end
				imgui.PopItemWidth()
				imgui.EndChild()
				imgui.SameLine()
				imgui.BeginChild('##FlooderChild3', imgui.ImVec2(40, 135), 0)
				if ad.ToggleButton(u8('##×åêáîêñ'.. i), inputButtons[i]) then 
					floodActive[i] = inputButtons[i][0]
					if floodActive[i] then
						lua_thread.create(function() floodLogic(i) end)
					end
				end
				imgui.EndChild()
			end
			imgui.NewLine()
			if imgui.Button(u8'Ñîõðàíèòü òåêñò', imgui.ImVec2(470, 0)) then
				saveTextToJson()
			end
		elseif menuSwitch == 6 then
			local resX, resY = getScreenResolution()
			local sizeX, sizeY = 695, 235
			imgui.PushFont(myFont) 
			imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
			imgui.Begin(u8'Äðóãîå', menu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
			imgui.BeginChild('##otherSettings1', imgui.ImVec2(300,195), 0)
			if ad.ToggleButton(u8'ChatID', elements.value.chatID) then
				config['settings']['chatID'] = elements.value.chatID[0]
				saveConfig()
			end imgui.TextQuestion(u8'Îêîëî íèêíåéìà îòîáðàæàåòñÿ ID')
			if ad.ToggleButton(u8'Anti-AFK', elements.value.antiafk) then
			afk = not afk
			config['settings']['antiafk'] = elements.value.antiafk[0]
			saveConfig()
			end
			if ad.ToggleButton(u8'Áûñòðûé ââîä íèêîâ', elements.value.fastnicks) then
				config['settings']['fastnicks'] = elements.value.fastnicks[0]
				saveConfig()
			end imgui.TextQuestion(u8'@id = íèê')
			imgui.PushItemWidth(275)
			if imgui.Combo(u8'',colorListNumber,colorListBuffer, #colorList) then
				theme[colorListNumber[0]+1].change()
				ini.styleTheme.theme = colorListNumber[0]
				inicfg.save(ini, directIni)
			end
			imgui.PopItemWidth()
			imgui.EndChild()
			imgui.SameLine()
			imgui.BeginChild('##settings2', imgui.ImVec2(350,195), 0)
			if ad.ToggleButton(u8'Ìîìåíòàëüíûé òåëåïîðò', elements.value.ftp) then
				config['settings']['ftp'] = elements.value.ftp[0]
				saveConfig()
			end imgui.TextQuestion(u8'Ìîìåíòàëüíî òåëåïîðòèðóåò íà ìåòêó')
			if ad.ToggleButton(u8'Óäàëåíèå ñåðâåðíîãî ôëóäà', elements.value.dellServerMessages) then
				config['settings']['dellServerMessages'] = elements.value.dellServerMessages[0]
				saveConfig()
			end imgui.TextQuestion(u8'Óäàëåíèå Ace_Will, SAN è ò.ï')
			if ad.ToggleButton(u8'Âèçóàëüíîå óäàëåíèå àêñåññóàðîâ', elements.value.dellacces) then
				config['settings']['dellacces'] = elements.value.dellacces[0]
				saveConfig()
			end
			imgui.EndChild()
			imgui.PopFont()
		end
	imgui.End()
end)

local setFrame = imgui.OnFrame(function() return setWindow[0] and not isGamePaused() end, function()
	imgui.PushFont(myFont)
	local resX, resY = getScreenResolution()
	local sizeX, sizeY = 415, 275
	imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
    imgui.Begin(u8'Âûäà÷à/ñíÿòèå äîëæíîñòè', setWindow, imgui.WindowFlags.NoResize)
	imgui.BeginChild('lName##', imgui.ImVec2(399,235), true)
	imgui.PushItemWidth(155) 
	imgui.CenterText(u8'Ëèäåðñòâî')
	imgui.Separator()
	imgui.Text(u8'Ââåäèòå ID èãðîêà:')
	imgui.SameLine()
	imgui.InputTextWithHint(u8'Ïðèìåð: 0', u8'Ââåäèòå çíà÷åíèå', input_setleader, sizeof(input_setleader), imgui.InputTextFlags.CharsDecimal)
	if imgui.ComboStr(u8'', selected, comboStr .. '\0', -1) then
        print('Selected frac name', fracNames[selected[0] + 1][2]);
    end
    imgui.SliderInt(u8'Âûáåðèòå ñêèí', SliderOne, 1, 311)
    imgui.PopItemWidth()
    if imgui.Button(u8"Íàçíà÷èòü íà äîëæíîñòü ëèäåðà##1") then
        local lead = str(input_setleader)
        if selected[0] ~= 0 and lead ~= '' and tonumber(lead) > 0 then
            local fracID = fracNames[selected[0] + 1][1] 
            sampSendChat('/setleader '..lead..' '..fracID..' '..SliderOne[0])
        else
            sampAddChatMessage('[Îøèáêà]: {ffffff}Âûáåðèòå âñå äàííûå äëÿ âûäà÷è äîëæíîñòè', 0xFF6600)
        end
    end
	imgui.Separator()
	imgui.CenterText(u8'Ñàïïîðò')
	imgui.Separator()
	imgui.Text(u8'Ââåäèòå ID (+ | -)')
	imgui.SameLine()
	imgui.PushItemWidth(155)
	imgui.InputTextWithHint(u8'##2', u8'Ââåäèòå çíà÷åíèå', input_setsupport, sizeof(input_setsupport), imgui.InputTextFlags.CharsDecimal)
	imgui.PopItemWidth()
	imgui.SameLine()
	imgui.Text(u8'Ïðèìåð: 303 +')
	if imgui.Button(u8"Íàçíà÷èòü/èçìåíèòü äîëæíîñòü ñàïïîðòà##2") then
		sampSendChat('/setsupport '..u8:decode(str(input_setsupport)))
	end
	imgui.EndChild()
	imgui.End()
	imgui.PopFont()
end)


function event.onShowDialog(dialogId, style, title, button1, button2, text)
	if config['settings']['autologin'] and dialogId == 2 then
		sampSendDialogResponse(2, 1, -1, config['settings']['password'])
		return false
	end 
	if config['settings']['autoalogin'] and dialogId == 2934 then
		apopen = false
		sampSendDialogResponse(2934, 1, -1, config['settings']['apassword'])
		return false
	end
	if not apopen and dialogId == 8024 then
		apopen = true
		sampSendDialogResponse(8024, 0, -1, '')
		return false
	end
end
function saveConfig()
	conf = io.open(directConfig, 'w')
	conf:write(encodeJson(config))
	conf:close()
end

function event.onSendMapMarker(position)
	if elements.value.ftp[0] then
    setCharCoordinates(PLAYER_PED, position.x, position.y, position.z)
	end
end

----------------- ONSERVERMESSAGE -----------------

-- sampRegisterChatCommand('banipid', function(text)
--     -- Ðàçáèâàåì ââåäåííóþ ñòðîêó íà àðãóìåíòû (ID, äíè è ïðè÷èíà)
--     local id, days, reason = text:match("^(%d+)%s+(%d+)%s+(.+)$")
    
--     -- Ïðîâåðêà íà êîððåêòíîñòü àðãóìåíòîâ
--     if not id or not days or not reason then
--         sampAddChatMessage("Íåâåðíûé ôîðìàò êîìàíäû! Èñïîëüçîâàíèå: /banipid [ID èãðîêà] [Ñðîê] [Ïðè÷èíà]", -1)
--         return
--     end

--     -- Îòïðàâëÿåì êîìàíäó íà ïîëó÷åíèå IP èãðîêà
--     sampSendChat('/getip ' .. id)

--     -- Ñîçäàåì ïåðåìåííóþ äëÿ õðàíåíèÿ IP
--     local ip = nil

--     -- Ñîçäàåì ïîòîê äëÿ çàäåðæêè ïåðåä âûïîëíåíèåì áàí-îïåðàöèè
--     lua_thread.create(function()
--         local timeout = 5000  -- Ìàêñèìàëüíîå âðåìÿ îæèäàíèÿ â ìèëëèñåêóíäàõ (5 ñåêóíä)
--         local startTime = os.clock()

--         -- Îæèäàåì îòâåò íà êîìàíäó /getip
--         while os.clock() - startTime < timeout do
--             wait(100)  -- Ïàóçà ïåðåä ñëåäóþùèì öèêëîì ïðîâåðêè
--         end

--         -- Åñëè IP íàéäåí, âûïîëíÿåì êîìàíäó áàí
--         if ip then
--             sampAddChatMessage(string.format('/banip %s %s %s', ip, days, reason), -1)
--         else
--             sampAddChatMessage("Íå óäàëîñü ïîëó÷èòü IP äëÿ èãðîêà ñ ID " .. id, -1)
--         end
--     end)
-- end)



function event.onServerMessage(color, text)
	-- local ip = text:match("IP %[%d+.%d+.%d+.%d+%]")
    -- if ip then
    --     ip = ip
    -- end
	if elements.value.pgetip[0] then
		if text:find("R%-IP %[%d+.%d+.%d+.%d+%]  IP %[%d+.%d+.%d+.%d+%]") then
			local rip, ip = text:match("R%-IP %[(%d+%.%d+%.%d+%.%d+)%].-IP %[(%d+%.%d+%.%d+%.%d+)%]")
			if ip then
				lua_thread.create(function()
					wait(700)
					print(ip)
					sampSendChat('/pgetip '.. ip)
				end)
			end
		end
	end
	if elements.value.dellServerMessages[0] then
		for _, val in ipairs(delltext) do
			if string.find(text, val) then
			return false
			end
		end
	end
	if text:find('^Âû âîøëè êàê .*') and not text:find('áëîãåð') then
		lua_thread.create(function()
			wait(1100)

			if config['settings']['autogm'] then sampSendChat('/agm') end
			if config['settings']['autoleader'] then
			if config['settings']['autogm'] then wait(1100) end sampSendChat('/templeader '..fracNames[config['settings']['leaderid']][1]+1) end
			if config['settings']['autoears'] then
			if config['settings']['autoleader'] or config['settings']['autogm'] then wait(1100) end sampSendChat('/ears') end
			if config['settings']['autoconnect'] then
			if config['settings']['akv'] or config['settings']['autogm'] or config['settings']['autoleader'] or config['settings']['autoears'] then wait(1100) end sampSendChat('/connect') end
			if config['settings']['akv'] then
			if config['settings']['autoainfo'] or config['settings']['autogm'] or config['settings']['autoleader'] or config['settings']['autoears'] then wait(1100) end sampSendChat('/inter 72') end
			if config['settings']['autoainfo'] then
			if config['settings']['autoconnect'] or config['settings']['autogm'] or config['settings']['autoleader'] or config['settings']['autoears'] then wait(1100) end sampSendChat('/ainfo') end
		end)
	end
	if elements.value.shortadm[0] then
		if text:find("^Àäìèíèñòðàòîð (%w+_%w+) äëÿ") or text:find("^Àäìèíèñòðàòîð (%w+_%w+)%[(%d+)%] äëÿ") then
			local pmtext = text:gsub("Àäìèíèñòðàòîð", "A:")
			sampAddChatMessage(pmtext, 0xFF9945)
			return false
		end
		if text:find("^Àäìèíèñòðàòîð (%w+_%w+) ïîñàäèë") or text:find("^Àäìèíèñòðàòîð (%w+_%w+) çàáëîêèðîâàë ðåïîðò") or text:find("^Àäìèíèñòðàòîð (%w+_%w+) êèêíóë") or text:find("^Àäìèíèñòðàòîð (%w+_%w+) âûäàë ïðåäóïðåæäåíèå") or text:find("^Àäìèíèñòðàòîð (%w+_%w+) âûäàë âûãîâîð") or text:find("^Àäìèíèñòðàòîð (%w+_%w+) ïîñòàâèë") or text:find("^Àäìèíèñòðàòîð (%w+_%w+) ñíÿë") or text:find("^Àäìèíèñòðàòîð (%w+_%w+) çàáàíèë .*") or text:find("^Àäìèíèñòðàòîð (%w+_%w+)%[(%d+)%] ïîñàäèë") or text:find("^Àäìèíèñòðàòîð (%w+_%w+)%[(%d+)%] çàáëîêèðîâàë ðåïîðò") or text:find("^Àäìèíèñòðàòîð (%w+_%w+)%[(%d+)%] êèêíóë") or text:find("^Àäìèíèñòðàòîð (%w+_%w+)%[(%d+)%] âûäàë ïðåäóïðåæäåíèå") or text:find("^Àäìèíèñòðàòîð (%w+_%w+)%[(%d+)%] âûäàë âûãîâîð") or text:find("^Àäìèíèñòðàòîð (%w+_%w+)%[(%d+)%] ïîñòàâèë") or text:find("^Àäìèíèñòðàòîð (%w+_%w+)%[(%d+)%] ñíÿë") or text:find("^Àäìèíèñòðàòîð (%w+_%w+)%[(%d+)%] çàáàíèë .*") then
			local ttext = text:gsub("Àäìèíèñòðàòîð", "A:")
			sampAddChatMessage(ttext, 0xff5030)
			return false
		end
		if text:find("^Îðãàíèçàòîð ìåðîïðèÿòèé .*") then 
			local omptext = text:gsub("Îðãàíèçàòîð ìåðîïðèÿòèé", "ÎÌÏ")
			sampAddChatMessage(omptext, 0xffcc00)
			return false
		end
		if text:find("^Ãëàâíûé àäìèíèñòðàòîð .*") then 
			local gatext = text:gsub("Ãëàâíûé àäìèíèñòðàòîð", "ÃÀ")
			sampAddChatMessage(gatext, 0xffcc00)
			return false
		end
		if text:find("^Ïîìîùíèê Ã.À .*") then 
			local gatext = text:gsub("Ïîìîùíèê Ã.À", "ÏÃÀ")
			sampAddChatMessage(gatext, 0xffcc00)
			return false
		end
	end
	if elements.value.getblock[0] then 
		if text:find('^%Âàøè àäìèí äåéñòâèÿ âðåìåííî çàáëîêèðîâàíû') then
			lua_thread.create(function()
				wait(100)
				sampSendChat('/a [Îòáîð]: ß ïðîâîæó îòáîð. ÏÃÀ/ÇÃÀ/ÃÀ/îñíîâàòåëü, âûäàéòå ìíå ïîæàëóéñòà ðàçáëîê äåéñòâèé.')
			end)
		end
	end
	if elements.value.reloginblock[0] then
		if text:find('^%Âàøè àäìèí äåéñòâèÿ âðåìåííî çàáëîêèðîâàíû') then
			local ip, port = sampGetCurrentServerAddress()
			if ip and port then
				sampConnectToServer(ip, port)
			end
		end
	end
    if elements.value.atp[0] then
        if text:find('^Âû âîøëè êàê .*') and not text:find('^Âû âîøëè êàê áëîãåð') then
			local t = math.random(123456, 654321)
			lua_thread.create(function()
				wait(3500)
				sampSendChat('/setint 0')
				wait(1000)
				sampSendChat('/setvw '..t)
				setCharCoordinates(1, 1203.4425048828, -941.47076416016, 42.744152069092)
        	end) 
		end
    end
    if elements.value.ahi[0] then
        if text:find('^Âû âîøëè êàê .*') and not text:find('^Âû âîøëè êàê áëîãåð') then
			local audio = loadAudioStream('https://github.com/DeffoMansory/dungeon-master/raw/refs/heads/main/winDownload.mp3')
			setAudioStreamState(audio, 1)
        end    
    end
	if elements.value.chatID[0] then
	    for nickname in text:gmatch('(%w+_%w+)') do
	    	if not text:find(nickname..'%[%d+%]') and not text:find(nickname..')')  then
	    		local nid = 1000
		    	for i=0, 299 do
					if sampIsPlayerConnected(i) then
						if sampGetPlayerNickname(i) == nickname then
							nid = i
							break
						end
					end
				end
				if nid ~= 1000 then
					text = text:gsub(nickname, nickname..'['..tostring(nid)..']')
				end
	    	end
	    end 
	    for nickname in text:gmatch('(%w+)') do
	    	if not text:find(nickname..'%[%d+%]') and not text:find(nickname..')') then
	    		local nid = 1000
		    	for i=0, 299 do
					if sampIsPlayerConnected(i) then
						if sampGetPlayerNickname(i) == nickname then
							nid = i
							break
						end
					end
				end
				if nid ~= 1000 then
					text = text:gsub(nickname, nickname..'['..tostring(nid)..']')
				end
	    	end
	    end 
	    return {color, text}
  	end
end
----------------- ONSERVERMESSAGE -----------------

----------------- ONSENDCHAT -----------------
function event.onSendChat(message)
    if message:sub(1, 1) == '!' then
        local command = message:sub(2) -- Óáèðàåì ñèìâîë "!"
        if command == 'alh' then
            -- sampAddChatMessage('Êîìàíäà áûëà îòïðàâëåíà ÷åðåç !text')
			menu[0] = not menu[0]
            return false -- Îòìåíÿåì îòïðàâêó îðèãèíàëüíîãî òåêñòà â ÷àò
        end
    end
	if elements.value.fastnicks[0] then
		for i in message:gmatch('@(%d+)') do 
			if sampIsPlayerConnected(tonumber(i)) and message:match('(@%d+)') ~= nil then
				message = message:gsub(message:match('(@%d+)'), sampGetPlayerNickname(tonumber(i)))
			end
		end
		return {message}
	end
end
----------------- ONSENDCHAT -----------------
sampRegisterChatCommand('amsg', function(param)
	if elements.value.msginfo[0] then
		if param == '' then
			sampAddChatMessage('[All Helper]: {ffffff}Èñïîëüçóéòå /amsg [1-3]', 0x696969)
		end
		if param == '1' then
			lua_thread.create(function()
				for i, line in ipairs(amsg1) do
					sampSendChat(line[1])  -- Âûâîäèì ñîîáùåíèå
					wait(1200)  -- Çàäåðæêà â 1500 ìèëëèñåêóíä (1.5 ñåêóíäû)
				end
			end)
		end
		if param == '2' then
			lua_thread.create(function()
				for i, line in ipairs(amsg2) do
					sampSendChat(line[1])  -- Âûâîäèì ñîîáùåíèå
					wait(1200)  -- Çàäåðæêà â 1500 ìèëëèñåêóíä (1.5 ñåêóíäû)
				end
			end)
		end
	end
end)
----------------- ONSENDCOMMAND -----------------
function event.onSendCommand(command)
	if elements.value.fastnicks[0] then
		for i in command:gmatch('@(%d+)') do 
			if sampIsPlayerConnected(tonumber(i)) and command:match('(@%d+)') ~= nil then
				command = command:gsub(command:match('(@%d+)'), sampGetPlayerNickname(tonumber(i)))
			end
		end
	end
	return {command}
end
----------------- ONSENDCOMMAND -----------------

function event.onSetPlayerAttachedObject(playerId, index, create, object) 
	if elements.value.dellacces[0] then
		if (object.bone == 5) or (object.bone == 6) then 
			return {playerId, index, create, object}
		else
			if #WhiteAccessories > 0 then
				for _, val in ipairs(WhiteAccessories) do
					if (object.modelId == val) then 
						return {playerId, index, create, object}
					else
						if (create == true) then 
							return false;
						else
							return {playerId, index, create, object}
						end
					end 
				end
			else
				if (create == true) then 
					return false;
				else
					return {playerId, index, create, object}
				end
			end
		end
	end
end

--------- MAIN -----------------
function main()
    repeat wait(0) until isSampAvailable()
    
	if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
	
	local url = 'https://pastebin.com/raw/hRVDc6Ey'
    local request = require('requests').get(url)
    local nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    
    local function res()
        for n in request.text:gmatch('[^\r\n]+') do
            if nick:find(n) then return true end
        end
        return false
    end

	if request.text and request.text ~= "" then
        nickList = {}
        for n in request.text:gmatch('[^\r\n]+') do
            table.insert(nickList, n)
        end
    end

    -- if not res() then
    --     sampAddChatMessage('[All Helper]: {ffffff}Îøèáêà: Âàø íèê îòñóòñòâóåò â ñïèñêå! Ñêðèïò âûãðóæåí.', 0x696969)
    --     sampAddChatMessage('[All Helper]: {ffffff}Îøèáêà: ×òîáû èñïîëüçîâàòü ñêðèïò - ñòàíüòå êðàñíûì àäìèíèñòðàòîðîì èëè êóïèòå ïîëüçîâàòåëüñêóþ âåðñèþ.', 0x696969)
    --     sampAddChatMessage('[All Helper]: {ffffff}Îøèáêà: Êóïèòü ñêðèïò ìîæíî ó vk.com/number1241. Öåíà: äîãîâîðíàÿ.', 0x696969)
    --     thisScript():unload()
    --     return
    -- end
	
    local ip, port = sampGetCurrentServerAddress()
    local ipport = ip .. ':' .. port
    if ipport ~= '62.122.213.231:7777' then
        sampAddChatMessage('[All Helper]: {ffffff}Îøèáêà: Äàííûé ñêðèïò ðàáîòàåò òîëüêî íà Attractive RP è íå ðàáîòàåò íà äðóãèõ ñåðâåðàõ!', 0x696969)
        sampAddChatMessage('[All Helper]: {ffffff}Îøèáêà: IP Attractive RP: {00aaff}Èìåííîé - a.attractive-rp.ru:7777 || Öèôðîâîé - 62.122.213.231:7777', 0x696969)
        sampAddChatMessage('[All Helper]: {ffffff}Îøèáêà: Ñêðèïò âûãðóæåí.', 0x696969)
        thisScript():unload()
        return
    end

    sampAddChatMessage('[All Helper]: {ffffff}Ìèíè-ïîìîùíèê àäìèíèñòðàòîðà çàãðóæåí.', 0x696969)
	sampAddChatMessage(string.format('[All Helper]: {ffffff}Äëÿ åãî àêòèâàöèè èñïîëüçóéòå: /alh (âåðñèÿ: %.2f îò %s).', script_version, thisScript().version), 0x696969)
    sampRegisterChatCommand('amp', function() sampSendChat('/mp') end)
	sampRegisterChatCommand('alh', function() menu[0] = not menu[0] end)
	sampRegisterChatCommand('punish', function() punishMenu[0] = not punishMenu[0] end)
	sampRegisterChatCommand('recname', recname_command)
	sampRegisterChatCommand('arec', rec_command)
	sampRegisterChatCommand('pip', pip)
	sampRegisterChatCommand('map', function()
		sampSendChat('/newobj')
	end)
	sampRegisterChatCommand('nl', function()
		sampSendChat('/nolimits')
	end)
    while true do 
        wait(0)
		if not menu[0] and menuSwitch > 0 then
			menuSwitch = 0
			menu[0] = true
		end
        if menu[0] then
            imgui.ShowCursor = true
        else
            imgui.ShowCursor = false
        end
		if not punishMenu[0] and punishSwitch > 0 then
			punishSwitch = 0
			punishMenu[0] = true
		end
        if punishMenu[0] then
            imgui.ShowCursor = true
        else
            imgui.ShowCursor = false
        end
        if wasKeyPressed(VK_O) and not sampIsCursorActive() then
            menu[0] = not menu[0]
        end
        if afk then
            memory.setuint8(7634870, 1, false)
            memory.setuint8(7635034, 1, false)
            memory.fill(7623723, 144, 8, false)
            memory.fill(5499528, 144, 6, false)
        else
            memory.setuint8(7634870, 0, false)
            memory.setuint8(7635034, 0, false)
            memory.hex2bin('0F 84 7B 01 00 00', 7623723, 8)
            memory.hex2bin('50 51 FF 15 00 83 85 00', 5499528, 6)
        end
    end -- end while true do
end
----------------- MAIN -----------------
---
function rec_command(param)
    local ip, port = sampGetCurrentServerAddress()
    if ip and port then
        sampConnectToServer(ip, port)
    end
end
function recname_command(param)
    if param == '' then
        sampAddChatMessage('[AllHelper]: {ffffff}Èñïîëüçóéòå /recname [íèê]', 0x696969)
    else
        sampSetLocalPlayerName(param)
        printStringNow(param, 1000, 0x00FF00)
        local ip, port = sampGetCurrentServerAddress()
        if ip and port then
            sampConnectToServer(ip, port)
        end
    end
end
function rec_command(param)
    local ip, port = sampGetCurrentServerAddress()
    if ip and port then
        sampConnectToServer(ip, port)
    end
end
----------------- WINDOW STYLE -----------------

imgui.OnInitialize(function() 
    theme[colorListNumber[0]+1].change()
	imgui.GetIO().IniFilename = nil
	local config = imgui.ImFontConfig()
	config.MergeMode = true
	config.PixelSnapH = true
	iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
	local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
	myFont = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/EagleSans-Regular.ttf', 15, nil, iconRanges, glyph_ranges)
	imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 14, config, iconRanges)
end)
----------------- HEADER BUTTON -----------------
HeaderButton = function(bool, str_id)
    local DL = imgui.GetWindowDrawList()
    local ToU32 = imgui.ColorConvertFloat4ToU32
    local result = false
    local label = string.gsub(str_id, "##.*$", "")
    local duration = { 0.5, 0.3 }
    local cols = {
        idle = imgui.GetStyle().Colors[imgui.Col.TextDisabled],
        hovr = imgui.GetStyle().Colors[imgui.Col.Text],
		slct = imgui.GetStyle().Colors[imgui.Col.Text]
    }

    if not AI_HEADERBUT then AI_HEADERBUT = {} end
     if not AI_HEADERBUT[str_id] then
        AI_HEADERBUT[str_id] = {
            color = bool and cols.slct or cols.idle,
            clock = os.clock() + duration[1],
            h = {
                state = bool,
                alpha = bool and 1.00 or 0.00,
                clock = os.clock() + duration[2],
            }
        }
    end
    local pool = AI_HEADERBUT[str_id]

    local degrade = function(before, after, start_time, duration)
        local result = before
        local timer = os.clock() - start_time
        if timer >= 0.00 then
            local offs = {
                x = after.x - before.x,
                y = after.y - before.y,
                z = after.z - before.z,
                w = after.w - before.w
            }

            result.x = result.x + ( (offs.x / duration) * timer )
            result.y = result.y + ( (offs.y / duration) * timer )
            result.z = result.z + ( (offs.z / duration) * timer )
            result.w = result.w + ( (offs.w / duration) * timer )
        end
        return result
    end

    local pushFloatTo = function(p1, p2, clock, duration)
        local result = p1
        local timer = os.clock() - clock
        if timer >= 0.00 then
            local offs = p2 - p1
            result = result + ((offs / duration) * timer)
        end
        return result
    end

    local set_alpha = function(color, alpha)
        return imgui.ImVec4(color.x, color.y, color.z, alpha or 1.00)
    end

    imgui.BeginGroup()
        local pos = imgui.GetCursorPos()
        local p = imgui.GetCursorScreenPos()
      
        imgui.TextColored(pool.color, label)
        local s = imgui.GetItemRectSize()
        local hovered = imgui.IsItemHovered()
        local clicked = imgui.IsItemClicked()
      
        if pool.h.state ~= hovered and not bool then
            pool.h.state = hovered
            pool.h.clock = os.clock()
        end
      
        if clicked then
            pool.clock = os.clock()
            result = true
        end

        if os.clock() - pool.clock <= duration[1] then
            pool.color = degrade(
                imgui.ImVec4(pool.color),
                bool and cols.slct or (hovered and cols.hovr or cols.idle),
                pool.clock,
                duration[1]
            )
        else
            pool.color = bool and cols.slct or (hovered and cols.hovr or cols.idle)
        end

        if pool.h.clock ~= nil then
            if os.clock() - pool.h.clock <= duration[2] then
                pool.h.alpha = pushFloatTo(
                    pool.h.alpha,
                    pool.h.state and 1.00 or 0.00,
                    pool.h.clock,
                    duration[2]
                )
            else
                pool.h.alpha = pool.h.state and 1.00 or 0.00
                if not pool.h.state then
                    pool.h.clock = nil
                end
            end

            local max = s.x / 2
            local Y = p.y + s.y + 3
            local mid = p.x + max

            DL:AddLine(imgui.ImVec2(mid, Y), imgui.ImVec2(mid + (max * pool.h.alpha), Y), ToU32(set_alpha(pool.color, pool.h.alpha)), 3)
            DL:AddLine(imgui.ImVec2(mid, Y), imgui.ImVec2(mid - (max * pool.h.alpha), Y), ToU32(set_alpha(pool.color, pool.h.alpha)), 3)
        end

    imgui.EndGroup()
    return result
end
----------------- HEADER BUTTON -----------------

----------------- LINK -----------------
function imgui.Link(link, text)
    text = text or link
    local tSize = imgui.CalcTextSize(text)
    local p = imgui.GetCursorScreenPos()
    local DL = imgui.GetWindowDrawList()
    local col = { 0xFFFF7700, 0xFFFF9900 }
    if imgui.InvisibleButton("##" .. link, tSize) then os.execute("explorer " .. link) end
    local color = imgui.IsItemHovered() and col[1] or col[2]
    DL:AddText(p, color, text)
    DL:AddLine(imgui.ImVec2(p.x, p.y + tSize.y), imgui.ImVec2(p.x + tSize.x, p.y + tSize.y), color)
end
----------------- LINK -----------------

----------------- MPTEXTQUESTION -----------------
function imgui.TextQuestionMp(text)
	imgui.SameLine()
	imgui.TextDisabled(u8'  Îïèñàíèå')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end
----------------- MPTEXTQUESTION -----------------
---
----------------- TEXTQUESTION -----------------
function imgui.TextQuestion(text)
	imgui.SameLine()
	imgui.TextDisabled(u8'(?)')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end
----------------- TEXTQUESTION -----------------

----------------- CENTERTEXT -----------------
function imgui.CenterText(text)
	imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(text).x / 2)
	imgui.Text(text)
end
----------------- CENTERTEXT -----------------



-- function themeScript()
-- 	local style = imgui.GetStyle()
-- 	local colors = style.Colors

	-- style.Alpha = 1;
	-- style.WindowPadding = imgui.ImVec2(8.00, 8.00);
	-- style.WindowRounding = 0;
	-- style.WindowBorderSize = 1;
	-- style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
	-- style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
	-- style.ChildRounding = 0;
	-- style.ChildBorderSize = 1;
	-- style.PopupRounding = 0;
	-- style.PopupBorderSize = 1;
	-- style.FramePadding = imgui.ImVec2(4.00, 3.00);
	-- style.FrameRounding = 0;
	-- style.FrameBorderSize = 0;
	-- style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
	-- style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
	-- style.IndentSpacing = 21;
	-- style.ScrollbarSize = 14;
	-- style.ScrollbarRounding = 9;
	-- style.GrabMinSize = 10;
	-- style.GrabRounding = 0;
	-- style.TabRounding = 4;
	-- style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
	-- style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);


-- 	colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
-- 	colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
-- 	colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.00, 0.00, 0.00, 0.82)
-- 	colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
-- 	colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
-- 	colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
-- 	colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
-- 	colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.82)
-- 	colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.00, 0.00, 0.00, 0.82)
-- 	colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.00, 0.00, 0.00, 0.82)
-- 	colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
-- 	colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
-- 	colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
-- 	colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
-- 	colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
-- 	colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
-- 	colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
-- 	colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
-- 	colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
-- 	colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
-- 	colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
-- 	colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
-- 	colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
-- 	colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
-- 	colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
-- 	colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
-- 	colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
-- 	colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
-- 	colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
-- 	colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
-- 	colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
-- 	colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
-- 	colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
-- 	colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
-- 	colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
-- 	colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
-- 	colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
-- 	colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
-- end


local punish = {'Îáùèå ïðàâèëà',
'',
'- ×èòû - /warn /jail (Îò 1 äî 30 ìèíóò)',
'- Âðåä. ÷èòû - Ñíÿòèå ñ ïîñòîâ + /ban (1 äåíü) /banip (Äî 7 äíåé)',
'- DM/DB/SK/TK - /jail (Îò 1 äî 15 ìèíóò)',
'Èñêëþ÷åíèå: ðàçðåøåí DM íà òåððèòîðèè ãåòòî',
'- NonRP (Èëè NonRP cop) - /warn /jail (Îò 1 äî 15 ìèíóò)',
'- Ïîìåõà/AFK áåç Esc/ÏÃ - /kick /jail (Îò 1 äî 5 ìèíóò)',
'Ïðèìåð: ïîìåõà êàïòó íå íàõîäÿñü â áàíäå',
'- NRP NickName - /kick | Óâîëüíåíèå ñ îðãàíèçàöèè',
'- Ïîâòîðåíèå îäíîãî è òîãî æå íàðóøåíèÿ (5+ ðàç) - /ban (1 äåíü)',
'Ïðèìå÷àíèå: íàêàçàíèå âûäàåòñÿ â òîì ñëó÷àå, åñëè èíòåðâàë ìåæäó êàæäûì íàðóøåíèåì ìåíåå 15-òè ìèíóò.',
'- NonRP ðàçâîä/Ïîäêèä îáìåíà èëè ïîêóïêè/Ðàçâîä /try - /ban (Îò 14 äíåé)',
'Ïðèìå÷àíèå: Ñ êàæäîé áëîêèðîâêîé ïî ýòîìó ïðàâèëó, ñðîê ñëåäóþùåé áëîêèðîâêè óâåëè÷èâàåòñÿ íà 2 äíÿ (Âòîðîé áàí íà 16 äíåé, òðåòèé > íà 18 è òàê äàëåå)',
'- Ñëèâ ïðîäóêòîâ áèçíåñà - Ñíÿòèå ñ ïîñòîâ + /ban (Îò 1 äî 3 äíåé)',
'Ïðèìåð: íàìåðåííàÿ ñêóïêà òîâàðîâ ñ öåëüþ óìåíüøåíèÿ êîëè÷åñòâà ïðîäóêòîâ è ïîñëåäóþùèì ñë¸òîì áèçíåñà â ãîñ.',
'- Ïîïûòêà/Ïðîäàæà èìóùåñòâà çà ðåàëüíóþ âàëþòó - Óäàëåíèå âñåõ àêêàóíòîâ',
'- Ïðîäàæà/Ïåðåäà÷à/Âçëîì àêêàóíòà - /ban (30 äíåé)',
'- Èñïîëüçîâàíèå áîòà íà øàõòó - /ban (Îò 1 äî 3 äíåé)',
'- Èñïîëüçîâàíèå áàãîâ ñåðâåðà ñ öåëüþ ïîëó÷åíèÿ ìàòåðèàëüíîé âûãîäû - Ñíÿòèå ñ ïîñòîâ + /ban ñ îáíóëåíèåì èìóùåñòâà, âïëîòü äî óäàëåíèÿ àêêàóíòà',
'Ïðèìåð: áàãîþç/äþï çîëîòûõ ìîíåò, ðåäêèõ ñêèíîâ è ò.ä.',
'',
'Ïðàâèëà ÷àòà:',
'',
'- Îôôòîï â ðåïîðò - /rmute (Íà óñìîòðåíèå àäìèíèñòðàòîðà)',
'- Flood/MG/òðàíñëèò - /mute (Îò 1 äî 10 ìèíóò)',
'- Ðåêëàìà - /ban /banip /mute (Íà óñìîòðåíèå àäìèíèñòðàòîðà)',
'- Îñêîðáëåíèå èãðîêîâ/óãðîçû - /mute (Îò 1 äî 15 ìèíóò)',
'- Îñêîðáëåíèå àäìèíèñòðàòîðîâ - /mute (Íà óñìîòðåíèå àäìèíèñòðàòîðà)',
'- Óïîìèíàíèå ðîäíûõ - /mute (Íà óñìîòðåíèå àäìèíèñòðàòîðà)',
'Èñêëþ÷åíèå: óïîìèíàíèå ñâîèõ ðîäñòâåííèêîâ',
'- Îñêîðáëåíèå êðàñíîé àäìèíèñòðàöèè - /mute (30 ìèíóò)',
'- Óïîìèíàíèå ðîäíûõ êðàñíîé àäìèíèñòðàöèè - /mute (30 ìèíóò)',
'- Caps/Ìàò â /ad, /vad, /r, /d è ò.ä - /mute (Îò 1 äî 10 ìèíóò)',
'Èñêëþ÷åíèå: ìàò â ÐÏ ÷àò, /f /gc /mc /sms',
'- Ðîçæèã ìåæíàöèîíàëüíîé ðîçíè - /mute (Îò 1 äî 30 ìèíóò)',
'- Ðàñïðîñòðàíåíèå ñòîðîííèõ ôàéëîâ - /mute (Îò 1 äî 30 ìèíóò)',
'- Îñêîðáëåíèå ïðîåêòà - /mute (Îò 1 äî 30 ìèíóò)',
'- Èãðà àíòè-ðåêëàìîé - /mute (Îò 1 äî 15 ìèíóò)',
'',
'Ôîðóì:',
'',
'- Ôîðóìíûå àâàòàðû/ïóáëèêàöèè ðàçæèãàþùèå ìåæíàöèîíàëüíóþ ðîçíü (Ïðåäñòàâèòåëè ñòðàí, âîåííûå è ïîëèòè÷åñêèå äåÿòåëè, ëþáûå ãîñóäàðñòâåííûå ñèìâîëû è ïðî÷åå)',
'Íàêàçàíèå: áëîêèðîâêà èãðîâîãî àêêàóíòà (1 äåíü), áëîêèðîâêà ôîðóìíîãî àêêàóíòà (30 äíåé), ñíÿòèå ñ õåëïåðêè, ëèäåðñêîãî/àäìèí-ïîñòà.',
'- Ôîðóìíûå àâàòàðû/ïóáëèêàöèè ðàçæèãàþùèå êîíôëèêò, èìåþùèå ïîðíîãðàôè÷åñêèé ñìûñë. Íàêàçàíèå: áëîêèðîâêà ôîðóìíîãî àêêàóíòà (30 äíåé), ñíÿòèå ñ õåëïåðêè, ëèäåðñêîãî/àäìèí-ïîñòà.'}
local arules = {'1. Íåíîðìàòèâíàÿ ëåêñèêà â ÷àò, â ñòîðîíó èãðîêîâ/àäìèíèñòðàòîðîâ | Âûãîâîð',
'- Çàïðåùåíî íàïèñàíèå ìàòåðíûõ ñëîâ â ïðèñóòñòâèè èãðîêîâ ðÿäîì',
'- Ðàçðåøåíî èñïîëüçîâàòü ìàò ðÿäîì ñ àäìèíèñòðàòîðàìè ñ öåëüþ îïèñàòü ñèòóàöèþ, íå èñïîëüçóÿ åãî â ñòîðîíó ÷åëîâåêà',
'2. DM èãðîêîâ | Äâà âûãîâîðà',
'- Ðàçðåø¸í ñëó÷àéíûé åäèíè÷íûé óäàð ðóêîé/îðóæèåì áëèæíåãî áîÿ/òðàíñïîðòîì, åñëè òå íàíåñëè ìàëî óðîíà',
'3. Âûäàâàòü íàêàçàíèå, íå èìåÿ äîêàçàòåëüñòâ íàðóøåíèÿ | Äâà âûãîâîðà',
'4. Çàñîðåíèå ðåïîðòà | Âûãîâîð',
'- Çàïðåùåíî óñòðàèâàòü ìåðîïðèÿòèÿ/âèêòîðèíû, ÷üÿ ñóòü çàêëþ÷àåòñÿ â íàïèñàíèè îòâåòà â ðåïîðò',
'- Èãðîêàì, íàõîäÿùèìñÿ íà îòáîðå íà ëèäåðà/ñàïïîðòà, ðàçðåøåíî ïèñàòü îòâåòû â ðåïîðò',
'5. Îñêîðáëåíèå àäìèíèñòðàòîðîâ/èãðîêîâ/óãðîçû | Âûãîâîð',
'- Ïðàâèëî íå ðàñïðîñòðàíÿåòñÿ íà ñåìåéíûé ÷àò (/t)',
'6. Ïîêóïêà/ïðîäàæà ÷åãî-ëèáî â /a | Âûãîâîð',
'7. Ïîìåõà äðóãèì àäìèíèñòðàòîðàì | Âûãîâîð',
'8. Ðåêëàìà/Ðåêëàìà ñ òâèíêîâ | Ñíÿòèå',
'- Çàïðåùåíî óïîìèíàíèå íàçâàíèé ñòîðîííèõ SAMP/CRMP/GTA V ñåðâåðîâ, IP àäðåñîâ, ïðèãëàøåíèå èãðîêîâ ïîèãðàòü íà äðóãîì ñåðâåðå',
'9. Îôôòîï â /msg | Âûãîâîð',
'- Ðàçðåøåíî èñïîëüçîâàòü êîìàíäó äëÿ îïîâåùåíèÿ èãðîêîâ îá îòáîðàõ, ìåðîïðèÿòèÿõ, ñëåæêå çà êàïòàìè/áèçâàðàìè è ò.ä',
'10. Áëàò êîãî-ëèáî èç èãðîêîâ/àäìèíèñòðàòîðîâ | Äâà âûãîâîðà',
'- Çàïðåùåíî âûäàâàòü îðóæèå/áðîíþ/õï ïåðñîíàæà è õï òðàíñïîðòà ïî ïðîñüáå â ðåïîðò èëè íàïðÿìóþ àäìèíèñòðàòîðó',
'- Ðàçðåøåíà ïî÷èíêà òðàíñïîðòà âíå ÐÏ ïðîöåññà',
'- Çàïðåùåíî îñóùåñòâëÿòü ïîìåõó íà ñåìåéíîì îãðàáëåíèè ñ öåëüþ ïîìî÷ü îïðåäåë¸ííûì èãðîêàì',
'- Çàïðåùåíî áåç ïðè÷èíû âûäàâàòü äîíàò î÷êè',
'- Çàïðåùåíî èãíîðèðîâàíèå íàðóøåíèé èãðîêîâ/àäìèíèñòðàòîðîâ',
'- Çàïðåùåíî áåç ïðè÷èíû àííóëèðîâàòü íàêàçàíèÿ | Èñêëþ÷åíèå: ïîëó÷åíèå íåâåðíîãî íàêàçàíèÿ ïî âàøåé âèíå',
'- Çàïðåùåíî ôèêñèðîâàíèå íàðóøåíèÿ ñ èãðîêà (òâèíê-àêêàóíòà) è âûäà÷à íàêàçàíèÿ ñ àäìèí-àêêàóíòà | Òðåáóåòñÿ ïèñàòü æàëîáó íà ôîðóìå',
'- Çàïðåùåíî òåëåïîðòèðîâàòü èãðîêîâ íà ìåðîïðèÿòèå. Ïîñåùåíèå ìåðîïðèÿòèé äîëæíî áûòü ñòðîãî ÷åðåç /gotp | Èñêëþ÷åíèå: åñëè áûëà îøèáî÷íàÿ äèñêâàëèôèêàöèÿ ñ ìåðîïðèÿòèÿ',
'11. Ïîìåõà RP/Âëåçàíèå â RP ïðîöåññ | Âûãîâîð',
'12. Ïðîâåðêà èãðîêà íà ÷èòû ÷åðåç ñêàéï èëè äèñêîðä | Äâà âûãîâîðà',
'- Çàïðåùåíî ïðîñèòü èãðîêîâ ïðîéòè â ñêàéï/äèñêîðä äëÿ ïðîâåðêè ñáîðêè íà íàëè÷èå ÷èòîâ',
'13. Ïîïðîøàéíè÷åñòâî | Âûãîâîð',
'- Çàïðåùåíî ïðîñèòü âàëþòó/àêñåññóàðû è äðóãèå âåùè, ñíÿòü âûãîâîð, ïîâûñèòü óðîâåíü àäìèí-ïðàâ â /a, /v, à òàêæå â /sms, åñëè ñîáåñåäíèê ïðîòèâ ïîïðîøàéíè÷åñòâà',
'- Ïîïðîøàéíè÷åñòâî ðàçðåøåíî â /t è ó äðóçåé, åñëè ñòîèòå ðÿäîì äðóã ñ äðóãîì è îíè íå ïðîòèâ',
'14. Èñïîëüçîâàíèå ÷èòîâ ïðîòèâ èãðîêîâ | Ñíÿòèå',
'- Çàïðåùåíû ëþáûå ÷èòû, êîòîðûå ìîãóò ïîìåøàòü èãðå äðóãèõ èãðîêîâ',
'Ïðèìå÷àíèå: Èñïîëüçîâàíèå ÷èòîâ íà DM àðåíå ïðîòèâ èãðîêîâ, êîòîðûå íå âëèÿþò íà ñòðåëüáó | Äâà âûãîâîðà',
'15. Âûäà÷à íàêàçàíèé ïî ïðîñüáå äðóãîãî àäìèíèñòðàòîðà | Âûãîâîð',
'- Àäìèíèñòðàòîð, ÷üÿ ïðîñüáà áûëà âûïîëíåíà, íàêàçàíèÿ íå íåñ¸ò',
'16. Íàëè÷èå áîëåå 1 àäìèí àêêàóíòà | Ñíÿòèå âñåõ àêêàóíòîâ ñ àäìèíêè',
'- Ðàçðåøåíî â ñëó÷àå èãðû äâóõ ëþäåé íà îäíîì IP, åñëè íà ýòî åñòü äîêàçàòåëüñòâà',
'17. Âûäà÷à íàêàçàíèé çà SMS àäìèíèñòðàòîðàì | Âûãîâîð',
'- Ðàçðåø¸í ñàì ôàêò íàïèñàíèÿ SMS äëÿ ñâÿçè ñ àäìèíèñòðàòîðàìè, âñå ïðàâèëà ÷àòà ïðîäîëæàþò äåéñòâîâàòü',
'18. Âûäà÷à íàêàçàíèé çà DM àäìèíèñòðàòîðîâ | Âûãîâîð',
'- Àäìèíèñòðàòîðîâ ñåðâåðà ðàçðåøåíî ðàíèòü/óáèâàòü',
'19. Íàêðóòêà ðåïóòàöèè | Ñíÿòèå',
'- Çàïðåùåíà íàêðóòêà ðåïóòàöèè ñ ïîìîùüþ òâèíê-àêêàóíòîâ è äðóçåé, ÷òî ïèøóò â ðåïîðò, à âû îòâå÷àåòå è ïîëó÷àåòå ïîëîæèòåëüíûå îöåíêè',
'20. Âûïðàøèâàíèå îöåíêè îòâåòà íà ðåïîðò | Âûãîâîð',
'21. Âûäà÷à âûãîâîðà(-îâ) â îòâåò | Ñíÿòèå/Èçúÿòèå êîìàíäû',
'- Åñëè âàñ íàêàçàë àäìèíèñòðàòîð (íà îñíîâíîì àêêàóíòå èëè òâèíêå), çàïðåùåíî â îòâåò âûäàâàòü âûãîâîð(-û) çà íåâåðíóþ âûäà÷ó äàííîãî íàêàçàíèÿ',
'- Åñëè âàì âûäàëè âûãîâîð(-û) â îòâåò, çàïðåùåíî ñàìîëè÷íî íàêàçûâàòü òàêîãî àäìèíèñòðàòîðà',
'- Ïðè ïîëó÷åíèè âûãîâîðà(-îâ) îò àäìèíèñòðàòîðà âû âñ¸ òàê æå ìîæåòå âûäàâàòü åìó íàêàçàíèÿ çà íàðóøåíèå ïðàâèë, åñëè íà òî èìåþòñÿ äîêàçàòåëüñòâà',
'22. Ïîäñòàâíûå äåéñòâèÿ íà ñíÿòèå | Äâà âûãîâîðà/Ñíÿòèå',
'- Çàïðåùåíî ïðîñèòü äðóãîãî àäìèíèñòðàòîðà ñêàçàòü/ñäåëàòü òî, çà ÷òî îí ìîæåò ïîëó÷èòü ñíÿòèå',
'- Çàïðåùåíî ïûòàòüñÿ ïîäñòàâèòü èãðîêîâ/àäìèíèñòðàòîðîâ ñ ïîìîùüþ ïðîãðàìì/÷èòîâ',
'23. Ðîçæèã êîíôëèêòà | Äâà âûãîâîðà',
'- Çàïðåùåíî ñëîâàìè/äåéñòâèÿìè ïðîâîöèðîâàòü íà êîíôëèêò èãðîêîâ/àäìèíèñòðàòîðîâ',
'Ïðèìåð: ïîïûòêà çàòêíóòü ÷åëîâåêà, çàñòàâëÿòü åãî ìîë÷àòü, óíèæåíèå ÷åëîâåêà',
'24. Íàðóøåíèå ïðàâèë àäìèíèñòðàöèè 3+ ðàç | Ñíÿòèå',
'Ïðèìåð: ïîëó÷åíèå 3 âûãîâîðà çà îñêîðáëåíèå àäìèíèñòðàòîðà/èãðîêà',
'Ïðèìå÷àíèå: íàêàçàíèå âûäàåòñÿ â òîì ñëó÷àå, åñëè èíòåðâàë ìåæäó êàæäûì íàðóøåíèåì ìåíåå 15-òè ìèíóò',
'25. Îñêîðáëåíèå êðàñíûõ àäìèíèñòðàòîðîâ, à òàêæå óïîìèíàíèå/îñêîðáëåíèå èõ ðîäíè | Ñíÿòèå + mute íà 30 ìèíóò',
'- Ïðàâèëî ðàñïðîñòðàíÿåòñÿ íà ñîö.ñåòè, âèäåîõîñòèíãè, ôîðóì, èãðó, äèñêîðä (ìóò íå âûäà¸òñÿ, åñëè íàðóøåíèå áûëî íå â èãðå)',
'26. Ñóììèðîâàíèå íàêàçàíèé | Âûãîâîð',
'- Çàïðåùåíî ñóììèðîâàòü íàêàçàíèÿ äðóã ñ äðóãîì è ïîñëåäóþùàÿ âûäà÷à èõ ñ óâåëè÷åííûì âðåìåíåì/êîëè÷åñòâîì',
'Ïðèìåð ñ èãðîêîì: èãðîê 2 ðàçà íàðóøèë ïðàâèëî "Êàïñ â ÷àò - mute 10 ìèíóò" è âû âûäàëè åìó 20 ìèíóò ìóòà âìåñòî ïîëîæåííûõ ïî ïðàâèëó 10 ìèíóò',
'Ïðèìåð ñ àäìèíîì: àäìèíèñòðàòîð 2 ðàçà íàðóøèë ïðàâèëî "DM èãðîêîâ - âûãîâîð" è âû âûäàëè åìó ñðàçó 2 âûãîâîðà âìåñòî ïîëîæåííîãî ïî ïðàâèëó îäíîãî âûãîâîðà',
'- Ëþáîå íàêàçàíèå äîëæíî âûäàâàòüñÿ ñðàçó ïîñëå íàðóøåíèÿ. Åñëè âûäàòü íàêàçàíèå àäìèíèñòðàòîðó/èãðîêó è îí ïðîäîëæàåò íàðóøàòü, ðàçðåøåíî âûäàâàòü íàêàçàíèå çà ïîñëåäóþùåå íàðóøåíèå',
'27. Ðîçæèã ìåæíàöèîíàëüíîé ðîçíè | Äâà âûãîâîðà',
'28. Ðàñïðîñòðàíåíèå ñòîðîííèõ ñêðèïòîâ | Âûãîâîð',
'29. Çëîóïîòðåáëåíèå êàïñîì â /a /v | Âûãîâîð',
'- Ðàçðåøåí êàïñ äî 2-õ (âêëþ÷èòåëüíî) ñëîâ â 2 ìèíóòû',
'- Çàïðåùåíî îòïðàâëåíèå äëèííûõ ñëîâ, íàïèñàííûõ ïðåèìóùåñòâåííî êàïñîì',
'30. Ïîìîùü íà êàïòå/áèçâàðå | Äâà âûãîâîðà',
'- Çàïðåùåíî íàçíà÷àòü ñåáÿ âðåìåííûì ëèäåðîì è ïîìîãàòü â óâåëè÷åíèè ñ÷¸òà óáèòûõ/íàõîäÿùèõñÿ íà òåððèòîðèè òîé èëè èíîé áàíäå/ìàôèè, òåì ñàìûì ïîìîãàÿ âûèãðàòü',
'- Çàïðåùåíà ïîìîùü â ïåðåìåùåíèè íà êàïò/áèçâàð, à òàêæå ïî îñïàðèâàåìîé òåððèòîðèè',
'- Çàïðåù¸íî òåëåïîðòèðîâàòü ñîïåðíèêîâ äðóã ê äðóãó',
'- Çàïðåùåíà âûäà÷à îðóæèÿ/òðàíñïîðòà/õï/áðîíè/ìàñîê',
'31. Ñëèâ òåððèòîðèé/áèçíåñîâ | Ñíÿòèå',
'- Çàïðåùåíà âûäà÷à òåððèòîðèé/áèçíåñîâ áåç äîêàçàòåëüñòâ è ïðè÷èíû',
'32. Ðàçãëàøåíèå öåí ïëàòíûõ êîìàíä | Ñíÿòèå',
'Èñêëþ÷åíèå: Èíôîðìèðîâàíèå î ïëàòíûõ êîìàíäàõ àäìèíèñòðàòîðó 12 óðîâíÿ.',
'Àäìèíèñòðàòîðàì íå èìåþùèì äîñòóï â ðàçäåë "Ïëàòíûõ êîìàíä" - çàïðåùåíî ëþáîå èíôîðìèðîâàíèå.',
'33. Áàëîâñòâî êîìàíäàìè | Äâà âûãîâîðà',
'- Çàïðåùåíà íàìåðåííàÿ áåñïðè÷èííàÿ âûäà÷à è ïîñëåäóþùåå ñíÿòèå íàêàçàíèé èãðîêó',
'Ïðèìåð: âûäà÷à /ban ïî ïðè÷èíå "ðåëîã" èãðîêó, åñëè òîò íå íóæäàëñÿ â ýòîì â ñâÿçè ñ áàãîì è íåâîçìîæíîñòüþ âûéòè ñ ñåðâåðà ñàìîñòîÿòåëüíî',
'- Çàïðåùåíà íàìåðåííàÿ âûäà÷à ñïàâíà/ñëàïà, èçìåíåíèå çäîðîâüÿ/ñêèíà, òåëåïîðò ñ öåëüþ íàâðåäèòü/ïîìåøàòü/ïîñìåÿòüñÿ íàä èãðîêîì',
'Ïðèìåð: ñëàï èãðîêà â ãðóçîâèêå ñåìåéíîãî îãðàáëåíèÿ, ñïàâí ñ öåëüþ çàáðàòü ëàâêó íà öåíòðàëüíîì ðûíêå',
'Çà èñêëþ÷åíèåì åñëè àäìèíèñòðàòîð îøèáñÿ ID è ñìîæåò ýòî äîêàçàòü',
'- Çàïðåù¸í òåëåïîðò èãðîêîâ áåç èõ ðàçðåøåíèÿ',
'Ïðèìåð: òåëåïîðò ïî ïðîñüáå äðóãîãî èãðîêà â ðåïîðò | ×òîáû íå ïîëó÷èòü æàëîáó, íóæíî ñïðîñèòü ðàçðåøåíèÿ ó òîãî, êîãî/ê êîìó Âû òåëåïîðòèðóåòå',
'- Çàïðåùåíà âûäà÷à íàêàçàíèé ñàìîìó ñåáå',
'Åñëè âû äîëæíû ïîëó÷èòü êàêîå-ëèáî íàêàçàíèå è ðåøèëè âûäàòü åãî ñåáå ñàìè, ýòî íå îòìåíÿåò âûäà÷ó âûãîâîðîâ îò äðóãèõ àäìèíèñòðàòîðîâ',
'Ïðèìåð: óâèäåâ æàëîáó íà ôîðóìå, âû ðåøèëè íàêàçàòü ñàìè ñåáÿ; ïîëó÷èòå âûãîâîð çà áàëîâñòâî êîìàíäàìè è íàêàçàíèå ïî æàëîáå',
'34. Èñïîëüçîâàíèå áàãîâ ñåðâåðà äëÿ ïîëó÷åíèÿ ìàòåðèàëüíîé âûãîäû | Ñíÿòèå + áàí',
'Ïðèìåð: áàãîþç/äþï çîëîòûõ ìîíåò, ðåäêèõ ñêèíîâ è ò.ä.',
'35. Íàðóøåíèå ïðàâèë ïðîâåðêè æàëîá | Âûãîâîð',
'36. Îñêîðáëåíèå ñåðâåðà | Ñíÿòèå + áàí',
'37. /pm â ëè÷íûõ öåëÿõ | Âûãîâîð',
'- Çàïðåùåíà áåñïðè÷èííàÿ ñâÿçü ÷åðåç /pm ñ èãðîêîì, êîòîðûé íå ïèñàë â ðåïîðò',
'- Ðàçðåøåíî èñïîëüçîâàòü /pm "Âû òóò?" ñ öåëüþ óáåäèòüñÿ, íå àôê ëè èãðîê',
'38. Ôëóä àäìèí-êîìàíäàìè | Âûãîâîð',
'- Çàïðåùåíî çàñîðÿòü ÷àò àäìèí-äåéñòâèÿìè, íàïðèìåð âûäà÷à îðóæèÿ/õï/áðîíè, òåëåïîðò èãðîêîâ ê ñåáå è ò.ä',
'39. Èñïîëüçîâàíèå âðåä.÷èòîâ/èñïîëüçîâàíèå âðåä.÷èòîâ ñ òâèíêîâ ïðîòèâ èãðîêîâ/àäìèíèñòðàòîðîâ | Ñíÿòèå + áàí',
'40. Îñêîðáëåíèå/óïîìèíàíèå ðîäñòâåííèêîâ èëè îòâåò âçàèìíîñòüþ | Ñíÿòèå',
'- Ðàçðåøåíî óïîìèíàíèå ñâîèõ ðîäñòâåííèêîâ',
'41. Êàïñ/ôëóä â ÷àò, â ñòîðîíó èãðîêîâ/àäìèíèñòðàòîðîâ | Âûãîâîð',
'- Ðàçðåøåí êàïñ äî 2-õ (âêëþ÷èòåëüíî) ñëîâ â 2 ìèíóòû',
'- Çàïðåùåíî îòïðàâëåíèå äëèííûõ ñëîâ, íàïèñàííûõ ïðåèìóùåñòâåííî êàïñîì',
'42. Íåâåðíàÿ âûäà÷à íàêàçàíèÿ èãðîêó/àäìèíèñòðàòîðó | Âûãîâîð',
'43. Íåâåðíîå ðàññìîòðåíèå æàëîáû íà ôîðóìå | Âûãîâîð',
'44. Ïîïûòêà/Ïðîäàæà âíóòðèèãðîâîãî èìóùåñòâà çà ðåàëüíóþ âàëþòó | Áàí + óäàëåíèå àêêàóíòà',
'45. Ñëèâ ïðîäóêòîâ áèçíåñà | Ñíÿòèå + áàí äî 3 äíåé',
'- Çàïðåùåíà íàìåðåííàÿ ñêóïêà òîâàðîâ ñ öåëüþ óìåíüøåíèÿ êîëè÷åñòâà ïðîäóêòîâ è ïîñëåäóþùèì ñë¸òîì áèçíåñà â ãîñ.',
'46. Ïðîäàæà/Ïåðåäà÷à/Âçëîì àêêàóíòà | Ñíÿòèå + áàí äî 30 äíåé',
'47. NonRP ðàçâîä | Ïîäêèä | Ðàçâîä /try | Ñíÿòèå + áàí íà 14 äíåé',
'- Ðàçâîä ñ òâèíê-àêêàóíòîâ | Ñíÿòèå',
'48. NonRP NickName | Äâà âûãîâîðà',
'- Çàïðåùåíî èñïîëüçîâàòü nRP íèê/íèê íàïèñàííûé êàïñîì, ïðèìåð - EVGENY_CREATOR | iVan_pUPpKin | Evgeny_Creatorrr',
'- Íèê äîëæåí áûòü íàïèñàí â ôîðìàòå Èìÿ_Ôàìèëèÿ, ïðèìåð - Evgeny_Creator',
'- Çàïðåùåíî èñïîëüçîâàòü äâå è áîëåå çàãëàâíûå áóêâû â èìåíè, ïðèìåð - EvGeny_Creator',
'49. Ñëèâ àäìèíèñòðàòèâíûõ ïðàâ | Ñíÿòèå + áàí äî 30 äíåé | Ñíÿòèå òâèíêîâ (Ïðè íàëè÷èè)',
'50. Íåóâàæèòåëüíûé îòâåò èãðîêó | Äâà âûãîâîðà',
'51. Âûäà÷à íàêàçàíèÿ ñ íåïîëíîé ïðè÷èíîé | Âûãîâîð',
'- Çàïðåùåíî óêàçûâàòü ïðè÷èíó, íå ïîÿñíÿþùóþ çà ÷òî èìåííî áûëî âûäàíî íàêàçàíèå',
'Ïðèìåð: âûäà÷à íàêàçàíèé ïî ïðè÷èíàì: "Íàðóøåíèå ïðàâèë ÷àòà", "Íàðóøåíèå ïðàâèë ñåðâåðà" è òîìó ïîäîáíûì (íåîáõîäèìî óêàçûâàòü ÷¸òêóþ ïðè÷èíó, íàïðèìåð "Îñêîðáëåíèå èãðîêà")',
'- Çàïðåùåíû íåïîíÿòíûå ñîêðàùåíèÿ ïðè÷èí, ïðè÷èíà äîëæíà áûòü ïîíÿòíà àáñîëþòíî âñåì èãðîêàì'}
local lrules = {'- Íåàäåêâàò | Íàêàçàíèå - äâà âûãîâîðà ëèäåðó + mute',
'- Îñêîðáëåíèå êðàñíîé àäìèíèñòðàöèè | Íàêàçàíèå - Ñíÿòèå + mute',
'- Íåàäåêâàòíîå ïîâåäåíèå íà ôîðóìå | Íàêàçàíèå - âûãîâîð ëèäåðó',
'- Óïîìèíàíèå ðîäíûõ | Íàêàçàíèå - ñíÿòèå + mute',
'- DM, DB, TK, SK | Íàêàçàíèå - âûãîâîð ëèäåðó + jail',
'- Óâîëüíåíèå áåç ïðè÷èí | Èñêëþ÷åíèå - ãåòòî/ìàôèè | Íàêàçàíèå - âûãîâîð ëèäåðó',
'- Ïðèíÿòèå èãðîêà ñ NonRP íèêîì â îðãàíèçàöèþ | Íàêàçàíèå - âûãîâîð ëèäåðó',
'- NonRP | Íàêàçàíèå - âûãîâîð ëèäåðó + jail/warn',
'- Ðåêëàìà | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + ban',
'- Ðàñôîðì (îò 5+ ÷åëîâåê) | Èñêëþ÷åíèå - ãåòòî/ìàôèè/íåàêòèâ áîëåå 1 ìåñ. | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + warn',
'Ïðèìå÷àíèå: íàêàçàíèå âûäàåòñÿ â òîì ñëó÷àå, åñëè èíòåðâàë ìåæäó êàæäûì óâîëüíåíèåì ìåíåå 7-ìè ìèíóò.',
'- ×èòû | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + warn',
'- ×èòû ñ òâèíêîâ | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + warn',
'- Áëàò | Èñêëþ÷åíèå - ãåòòî/ìàôèè | Íàêàçàíèå - âûãîâîð ëèäåðó',
'- Íîðìà îíëàéíà îòûãðîâêè çà äåíü îò 1 ÷àñà | Èñêëþ÷åíèå - åñëè ëèäåð íàçíà÷åí çà ÷àñ äî ïðîâåðêè íîðìû | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè',
'- Íåàêòèâ 24+ ÷àñîâ | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè',
'- NonRP íàçâàíèÿ ðàíãîâ | Èñêëþ÷åíèå - ãåòòî (Êðîìå íåàäåêâàòíûõ è îñêîðáèòåëüíûõ) | Íàêàçàíèå - 2 âûãîâîðà ëèäåðó',
'- Ìåíåå äâóõ íàáîðîâ çà äåíü | Èñêëþ÷åíèå - íåëåãàëüíûå îðãàíèçàöèè | Íàêàçàíèå - 2 âûãîâîðà ëèäåðó',
'- Ìåíåå äâóõ çàõâàòîâ çà äåíü | Èñêëþ÷åíèå - ãîñ.ñòðóêòóðû | Íàêàçàíèå - 2 âûãîâîðà ëèäåðó',
'- Îòñóòñòâèå ñòðåë çà äåíü | Èñêëþ÷åíèå - ãîñ.ñòðóêòóðû, ãåòòî | Íàêàçàíèå - 2 âûãîâîðà ëèäåðó',
'- Ñëèâ òåððèòîðèé/áèçíåñîâ | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + warn',
'- Íàëè÷èå áîëåå îäíîé ëèäåðêè | Íàêàçàíèå - ñíÿòèå âñåõ ëèäåðîê',
'- Îòñóòñòâèå íîðìû çàõâàòîâ â òå÷åíèè 3-õ äíåé | Èñêëþ÷åíèå - ãîñ.ñòðóêòóðû/îòñóòñòâèå ëèäåðîâ ïðîòèâîïîëîæíûõ îðãàíèçàöèé | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè',
'- Ïðîäàæà/ïîêóïêà ëèäåðêè | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + warn (Ïðîäàæà çà ðåàëüíóþ âàëþòó - óäàëåíèå àêêàóíòà)',
'- Ïðîäàæà ðàíãà | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + warn (Ïðîäàæà çà ðåàëüíóþ âàëþòó - óäàëåíèå àêêàóíòà)',
'- Èãðà ñ òâèíêîâ çà ïðîòèâîïîëîæíóþ áàíäó/ìàôèþ | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + warn',
'- Ïåðåäà÷à ëèäåðñêîãî ïîñòà íà òâèíê àêêàóíò (Ïðèìåð: óõîä ñ ëèäåðêè è ïîêóïêà ñ òâèíêà) | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + warn',
'- Ðîçæèã ìåæíàöèîíàëüíîé ðîçíè, â òîì ÷èñëå íàçâàíèÿ ðàíãîâ | Íàêàçàíèå - 2 âûãîâîðà ëèäåðó',
'- Îòêàç îò ïðèíÿòèÿ ó÷àñòèÿ â ãëîáàëüíûõ ìåðîïðèÿòèÿõ | Èñêëþ÷åíèå - íåëåãàëüíûå îðãàíèçàöèè | Íàêàçàíèå - 2 âûãîâîðà ëèäåðó',
'- Ñëèâ ïîñòà/ëèäåðîâ | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + ban',
'- Îñêîðáëåíèå ïðîåêòà | Íàêàçàíèå - ñíÿòèå ñ ëèäåðêè + ban',
'- NonRP íèê | Íàêàçàíèå - 2 âûãîâîðà ëèäåðó',
'Ïðèìå÷àíèå: Åñëè ëèäåð íå èçìåíèë íèê íà äîïóñòèìûé â òå÷åíèå 10-òè ìèíóò ïîñëå íàêàçàíèÿ, îí ÑÍÈÌÀÅÒÑß ñ ïîñòà',
'Àäìèíèñòðàòîð îáÿçàí îïîâåñòèòü ëèäåðà â (/pm) î òîì ÷òî, ó íåãî èìååòñÿ 10 ìèíóò äëÿ ñìåíû íèêíåéìà',
'Âàæíî: Ïðåäóïðåæäåíèÿ âûíîñÿòñÿ òîëüêî òîãäà, êîãäà ëèäåð íàõîäèòñÿ â Ñåòè'}
local srules = {'- Îòñóòñòâèå íîðìû îòûãðàííîãî âðåìåíè çà ñóòêè (1 ÷àñ). | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà.',
'- Íåàêòèâíîñòü â òå÷åíèå 24 ÷àñîâ. | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà.',
'- Îñêîðáëåíèå ðîäíûõ â îòâåòå / ÷àòå ñàïïîðòîâ. | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà + çàòû÷êà íà 30 ìèíóò + ÷¸ðíûé ñïèñîê ñàïïîðòîâ ñðîêîì íà 10 äíåé.',
'- Íåâåðíûé îòâåò èãðîêó. | Íàêàçàíèå - âûãîâîð.',
'- Íàêðóòêà îòâåòîâ. | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà + ÷¸ðíûé ñïèñîê ñàïïîðòîâ ñðîêîì íà 5 äíåé.',
'- Ðàçãëàøåíèå êîìàíä è âîçìîæíîñòåé ñàïïîðòà. | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà + ÷¸ðíûé ñïèñîê ñàïïîðòîâ ñðîêîì íà 10 äíåé.',
'- Èñïîëüçîâàíèå êîìàíäû äëÿ îòâåòîâ â ëè÷íûõ öåëÿõ. | Íàêàçàíèå - 1 âûãîâîð.',
'- Íåàäåêâàòíîå ïîâåäåíèå â îòâåòå / ÷àòå ñàïïîðòîâ (Îñêîðáëåíèÿ/Êàïñ/Ìàò). | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà (ïðè ïîâòîðíîì íàðóøåíèè ÷¸ðíûé ñïèñîê ñàïïîðòîâ íà 5 äíåé).',
'- Ëþáûå íàðóøåíèÿ ïðàâèë ñåðâåðà ñî ñòîðîíû èãðîâîãî ïðîöåññà (DM/Îñêîðáëåíèÿ/Íåàäåêâàò). | Íàêàçàíèå - âûãîâîð + íàêàçàíèå ïî ïðàâèëàì ñåðâåðà.',
'- Íàëè÷èå 0 îòâåòîâ íà ïîñòó ñàïïîðòà. | Íàêàçàíèå - 2 âûãîâîðà.',
'- Îñêîðáëåíèå ñëåäÿùèõ çà ñàïïîðòàìè. | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà + ÷¸ðíûé ñïèñîê ñàïïîðòîâ ñðîêîì íà 5 äíåé.',
'- Çàñîðåíèå ÷àòà ñàïïîðòîâ (Ïîêóïêà/Ïðîäàæà/Ôëóä). | Íàêàçàíèå - âûãîâîð + çàòû÷êà íà 10 ìèíóò.',
'- NonRP íèê. | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà.',
'- Ïîïðîøàéíè÷åñòâî â ÷àòå ñàïïîðòîâ èëè â îòâåòå èãðîêó. | Íàêàçàíèå - 2 âûãîâîðà.',
'- Èñïîëüçîâàíèå ÷èòîâ íà ïîñòó ñàïïîðòà. | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà + jail/warn.',
'- Ïðîâîêàöèîííûå âîïðîñû (Êîìàíäû/Âîçìîæíîñòè ñàïïîðòà). | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà + ÷¸ðíûé ñïèñîê ñàïïîðòîâ ñðîêîì íà 5 äíåé.',
'- Èãíîðèðîâàíèå ïðîñüáû ãëàâíîãî ñëåäÿùåãî çà ñàïïîðòàìè. | Íàêàçàíèå - âûãîâîð.',
'- Âûäà÷à áëîêèðîâêè ðåïîðòà, íå èìåÿ äîêàçàòåëüñòâ íàðóøåíèÿ. | Íàêàçàíèå - âûãîâîð (ïî æàëîáå âûäà¸òñÿ 2 âûãîâîðà).',
'- Íàëè÷èå îøèáîê, ïðîÿâëåíèå íåãðàìîòíîñòè ïðè îòâåòå, íåïîëíîöåííûå îòâåòû. | Íàêàçàíèå - âûãîâîð.',
'- Òðàíñëèò â îòâåòå èãðîêó. | Íàêàçàíèå - âûãîâîð.',
'- Íåóâàæèòåëüíûé îòâåò èãðîêó. | Íàêàçàíèå - 2 âûãîâîðà.',
'- Ñëèâ ïîñòà ñàïïîðòà. | Íàêàçàíèå - ñíÿòèå ñ ïîñòà ñàïïîðòà + áëîêèðîâêà íà 30 äíåé + ÷¸ðíûé ñïèñîê ñàïïîðòîâ íàâñåãäà.'}
local gosrules = {'- 1. Âñÿêîå îáùåíèå â äåïàðòàìåíòå áåç èñïîëüçîâàíèÿ òåãà: [Òåã âàøåé îðãàíèçàöèè] - [all/äðóãàÿ îðãàíèçàöèÿ] - /mute (îò 1 äî 10 ìèíóò).',
'- 2. Èñïîëüçîâàíèå ôðàç, ñîäåðæàùèå êàïñ, ãðóáûå âûðàæåíèÿ, îñêîðáëåíèÿ (/d (/db), /r (/rb), /gov è.ò.ï) . - /mute (îò 1 äî 10 ìèíóò).',
'- 3. Ïèñàòü â ãîñóäàðñòâåííûå íîâîñòè, íå çàíÿâ ãîñóäàðñòâåííóþ âîëíó - /mute (îò 1 äî 10 ìèíóò).',
'- 4. NonRP Cop - /warn /jail (îò 1 äî 15 ìèíóò).',
'- 5. Óâîëüíåíèå ñ íåàäåêâàòíîé èëè áåç âåñîìîé ïðè÷èíû - /mute (îò 1 äî 10 ìèíóò).',
'- 6. Ñëèâ äîëæíîñòè - /auninvite + /jail (îò 1 äî 15 ìèíóò).',
'- 7. Íàõîæäåíèå ãîñ. ðàáîòíèêà â ãåòòî ñ öåëüþ àðåñòà - /jail (îò 1 äî 10 ìèíóò).',
'- 7.1. Ðàçðåøåíî íàõîäèòüñÿ â ìàñêå äëÿ ïðîñòîãî ïåðåìåùåíèÿ (áåç àðåñòîâ).',
'- 8. Íåñîáëþäåíèå ïðàâèë ïðè âûäà÷å ðîçûñêà (âûäà÷à ðîçûñêà ñ NonRP ïðè÷èíàìè èëè ïðè÷èíàìè, êîòîðûå íå óêàçàíû â óãîëîâíîì êîäåêñå: DM, óãîí, ïîõèùåíèå è ò.ä). - /warn /jail (îò 1 äî 15 ìèíóò).',
'- 8.1. Ðàçðåøåíî óêàçûâàòü òîëüêî ïîëíîå íàçâàíèå ñòàòüè èëè å¸ ïóíêò.',
'- 9. Ïðîÿâëåíèå íåãðàìîòíîñòè è íåàäåêâàòíîãî ïîâåäåíèÿ ïðè ïðîâåäåíèè ýôèðà èëè ïðè èñïîëüçîâàíèè ãîñóäàðñòâåííîé âîëíû - /mute (îò 1 äî 10 ìèíóò).',
'- 10. Íåñîáëþäåíèå ïðàâèë ïðîâåäåíèÿ ïðîâåðîê - /warn /jail (îò 1 äî 15 ìèíóò).',
'Ïðèìå÷àíèÿ:',
'- 1. Ïðè÷èíà äëÿ ðîçûñêà äîëæíà ñîîòâåòñòâîâàòü Óãîëîâíîìó êîäåêñó San Andreas.',
'- 2. Ïðè÷èíà óâîëüíåíèÿ äîëæíà áûòü íà ðóññêîì ÿçûêå. Èñïîëüçîâàíèå ïðè÷èíû íà äðóãîì ÿçûêå áóäåò íàêàçàíî.',
'- 3. Ïðè ìíîãîêðàòíîì íàðóøåíèè ïóíêòà ïîä íîìåðîì 9 - âû áóäåòå óâîëåíû èç îðãàíèçàöèè.'}
local orules = {'- 1. Íåîáõîäèìî óñòàíîâèòü ìèíèìàëüíûé îíëàéí â îäèí ÷àñ äëÿ âîçìîæíîñòè òåëåïîðòàöèè (èñïîëüçóÿ êîìàíäó /mp).',
'- 2. Àêòèâèðîâàòü ôóíêöèþ çàïèñè ýêðàíà.',
'- 3. Îãëàñèòü ó÷àñòíèêàì ïðàâèëà îòáîðà:',
'',
'Ïåðâûé ó÷àñòíèê èìååò 15 ñåêóíä íà îòâåò, îñòàëüíûå - 10.',
'Çàïðåùåíî ïðèìåíÿòü ÄÌ, ïåðåáåãàòü, ïèñàòü ñîîáùåíèÿ â ëþáîé ÷àò, çà èñêëþ÷åíèåì /rep è /sms.',
'',
'- 4. Ïåðåìåñòèòü íà ñïàâí òåõ èãðîêîâ, êîòîðûå áûëè ñíÿòû ñ ëèäåðñêèõ äîëæíîñòåé çà ïîñëåäíèå 30 ìèíóò, îíè íå ìîãóò ó÷àñòâîâàòü â îòáîðå.',
'- 5. Ïåðåìåñòèòü íà ñïàâí èãðîêîâ, ÿâëÿþùèõñÿ ëèäåðàìè äðóãèõ ôðàêöèé.',
'- 6. Ïðîâåðèòü, ÷òî íà îòáîðå ïðèñóòñòâóåò íå ìåíåå òð¸õ èãðîêîâ.'}
local tryrules = {'- 1. Íàïèñàòü ïðàâèëüíûå óñëîâèÿ è ïîëó÷èòü ñîãëàñèå äëÿ íà÷àëà èãðû',
'> Â óñëîâèÿõ äîëæíî áûòü íàïèñàíî: ñóììà, âàëþòà/ïðåäìåò, êîë-âî ïîáåä, êîë-âî íàïèñàííûõ /try',
'> Ïðèìåð: "Èãðàåì â /try íà 10êê ôê, 1 ïîáåäà, êèäàåì 3 ðàçà"',
'> Åñëè âàëþòà íå áûëà íàïèñàíà, èãðà áóäåò íà FCoins',
'> Ïðè îãëàøåíèè óñëîâèé èãðû Âû äîëæíû èìåòü îáãîâàðèâàåìóþ ñóììó íà òîì àêêàóíòå, íà êîòîðîì èãðàåòå â /try, ëèáî íà óêàçàííîì Âàì íèêå (ñì. ïóíêò 3.)',
'> Åñëè îáãîâîðåííîé ñóììû íå èìååòñÿ, íî Âû íà÷àëè èãðó, Âû ìîæåòå ïîëó÷èòü áëîêèðîâêó çà îáìàí â /try.',
'- 2. Â ñëó÷àå íàïèñàíèÿ æàëîáû íà îáìàí, òðåáóåòñÿ ñäåëàòü ñêðèíøîò /mm - 1.',
'> Äîêàçàòåëüñòâà íàïèñàíèÿ óñëîâèé è ñîãëàñèå íà íèõ, à òàê æå ñàìà èãðà (ñêðèíøîòû/âèäåîðîëèê òîãî, êàê îáà èãðîêà ïðîïèñûâàþò /try íóæíîå êîëè÷åñòâî ðàç).',
'> Íà äîêàçàòåëüñòâàõ äîëæíî áûòü âèäíî ñåðâåðíîå âðåìÿ.',
'- 3. Ïðè íàïèñàíèè óñëîâèé, åñëè êòî-òî ãîòîâ îïëàòèòü Âàø ïðîèãðûø, ñòîèò óêàçàòü åãî íèê. Åñëè íèê íå áûë óêàçàí èëè îïëàòû íå ïðîèçîøëî â òå÷åíèå 24÷, òî íàêàçàíèå ïîëó÷àåò òîò, êòî èãðàë â /try.',
'- 4. Â ñëó÷àå ïðîèãðûøà è ïåðåäà÷è ïîñòàâëåííîé ñóììû/ïðåäìåòà íà äðóãèå àêêàóíòû, îíè áóäóò çàáëîêèðîâàíû çà ó÷àñòèå â îáìàíå.',
'- 5. Â ñëó÷àå ïðîèãðûøà è íåæåëàíèÿ îòäàâàòü ïðîèãðàííîå, áóäåò âûäàíà áëîêèðîâêà àêêàóíòà.',
'- 6. Ïðè ðàâíîì âûïàäåíèè "Óäà÷íî" íóæíî ñîãëàñîâàòü äàëüíåéøåå ïðîäîëæåíèå èãðû, ïîäòâåðæäåíèå ñ îáåèõ ñòîðîí.',
'- 7. Ðàçðåøåíà èãðà òîëüêî íà âíóòðèèãðîâóþ âàëþòó/èìóùåñòâî.',
'- 8. Çàïðåùåíà èãðà íà æåëàíèÿ, âûèãðûø â äîëã.',
'- 9. Ïðè îáìàíå âîçâðàùàåòñÿ ñóììà ïðîèãðûøà ñ àêêàóíòîâ îáìàíùèêà (ïðè íàëè÷èè).'}
local capturerules = {'Íà çàõâàòå òåððèòîðèè ðàçðåøåíî:',
'',
'- Ìàñêè (/mask)',
'- Àïòå÷êè (/healme)',
'- Íàðêîòèêè (/drugs)',
'- Èñïîëüçîâàíèå áàãîâ ñòðåëüáû (Ñëàéäû, îòâîäû, ñáèâû ïåðåêàòîâ, +ñ)',
'Íà çàõâàòå òåððèòîðèè çàïðåùåíî:',
'',
'- TK, DB, áðîíåæèëåò | Íàêàçàíèå - Jail/Warn (1/3)',
'- Ñáèâ | Íàêàçàíèå: Jail/Warn (1/3)',
'- ×èòû: WH, SH, TP, PARKOUR, CLEO ANIM | Íàêàçàíèå - Jail/Warn (1/3)',
'- ×èòû: FLY, Êëåî ëàãè | Íàêàçàíèå - Jail/Warn (2/3)',
'- SK (Èñêëþ÷åíèå: åñëè áûëà ïðîâîêàöèÿ), Àíòèôðàã/îôô îò êèëëà, ïðîåçä ìèìî | Íàêàçàíèå - Jail/Warn (2/3)',
'- Âðåä ÷èòû: CARSHOT, DAMAGER, ÐÂÀÍÊÀ è äðóãèå | Íàêàçàíèå - Ban (3/3)',
'- Íå ïðèåçæàòü íà çàõâàòûâàåìóþ òåððèòîðèþ â òå÷åíèè 3-õ ìèíóò | (3/3)',
'- Êàïòèòü êóñêîì/îáðåçîì | Íàêàçàíèå - Jail/Warn (3/3)',
'- Ñòðåëüáà íà ïàññàæèðñêîì ñèäåíèè | (3/3)',
'- Àíòè-êàïòèòü | Íàêàçàíèå - Jail/Warn (3/3)',
'- AFK íà êàïòå îò 1+ ìèíóò | Íàêàçàíèå - Jail/Warn (1/3)',
'- ×èòû, êîòîðûå äàþò ïðåèìóùåñòâî â ñòðåëüáå: AIM, RAPID, AUTO +C, NO SPREAD, EXTRA W, èíâèç | Íàêàçàíèå - Jail/Warn (3/3)',
'- Òðóäíîäîñòóïíûå êðûøè (Èñêëþ÷åíèå: êðûøè, íà êîòîðûå ìîæíî çàëåçòü ñ îäíîãî ïðûæêà) | Íàêàçàíèå - Jail/Warn (2/3)',
'- Ïîìîùü äðóãîé áàíäå (Âûäà÷à òåððèòîðèè îò áàíäû, êîòîðàÿ ïîìîãàëà. Âûäà¸òñÿ áàíäå, ïðîòèâ êîòîðîé áûëè äâå áàíäû) | Íàêàçàíèå - jail/warn (3/3)',
'- Âûõîä èç èãðû, èíòåðüåð â áîþ íà ðåøàþùåì ôðàãå | Íàêàçàíèå - Jail/Warn (3/3)',
'- Èñïîëüçîâàíèå çàïðåùåííîãî òðàíñïîðòà (Âîåííàÿ òåõíèêà: "Hydra", "Hunter" è ïðî÷åå) | Íàêàçàíèå - Jail/Warn (3/3)',
'- +C íà êàïòàõ ñ Anti +C | Íàêàçàíèå: Jail/Warn (3/3)'}
local bizwarrules = {'Íà ñòðåëå ðàçðåøåíî:',
'',
'- Àïòå÷êè (/healme)',
'- Íàðêîòèêè (/drugs)',
'- Èñïîëüçîâàíèå áàãîâ ñòðåëüáû (Îòâîä ñ Desert Eagle ïîñëå 2-ãî âûñòðåëà, ñáèâû ïåðåêàòîâ)',
'Íà ñòðåëå çàïðåùåíî:',
'',
'- +C, îòâîä ïîñëå 1-ãî âûñòðåëà | Íàêàçàíèå: Jail/Warn (1/3)',
'- Ìàñêè (/mask) | Íàêàçàíèå - Jail/Warn (1/3)',
'- SK, TK, DB, áðîíåæèëåò | Íàêàçàíèå - Jail/Warn (1/3)',
'- ×èòû: SH, TP, FLY, PARKOUR, CLEO ANIM | Íàêàçàíèå - Jail/Warn (1/3)',
'- AFK íà ñòðåëå îò 1+ ìèíóò | Íàêàçàíèå - Jail/Warn (1/3)',
'- NO SPREAD, EXTRA WS, Àíòèôðàã/îôô îò êèëëà | Íàêàçàíèå - Jail/Warn (2/3)',
'- ×èòû, êîòîðûå äàþò ïðåèìóùåñòâî â ñòðåëüáå: AIM, RAPID, AUTO +C, èíâèç, ñòðåëüáà ñêâîçü îáúåêòû | Íàêàçàíèå - Jail/Warn (3/3)',
'- Âðåä ÷èòû: CARSHOT, DAMAGER, ÐÂÀÍÊÀ è äðóãèå | Íàêàçàíèå - Ban (3/3)',
'- Íå ïðèåçæàòü íà bizwar â òå÷åíèè 3-õ ìèíóò | (3/3)',
'- Àíòè-çàõâàò áèçíåñà | Íàêàçàíèå: Jail/Warn (3/3)',
'- Àïòå÷êà/íàðêîòèêè â áîþ | Íàêàçàíèå: Jail/Warn (1/3)',
'- Ñáèâ | Íàêàçàíèå: Jail/Warn (1/3)',
'- Òðóäíîäîñòóïíûå êðûøè (Èñêëþ÷åíèå: êðûøè, íà êîòîðûå ìîæíî çàëåçòü ñ îäíîãî ïðûæêà) | Íàêàçàíèå - Jail/Warn (2/3)',
'- Äîì íà êîë¸ñàõ/ñïàâí â äîìå, êîòîðûé íàõîäèò'}
local codex = {'Àäìèíèñòðàòèâíûé êîäåêñ (ÀÊ)',
'1. Ðàçäåë "Ïàðêîâêà":',
'1.1. Íåïðàâèëüíàÿ ïàðêîâêà â îáùåñòâåííîì ìåñòå: - Ñîòðóäíèê èìååò ïðàâî ýâàêóèðîâàòü òðàíñïîðò è âûïèñàòü øòðàô â ðàçìåðå îò 350 000$ äî 900 000$. - Çà íåïðàâèëüíóþ ïàðêîâêó â ìåñòå áîëüøîãî ñêîïëåíèÿ ëþäåé (8 ÷åëîâåê) øòðàô óâåëè÷èâàåòñÿ â 2 ðàçà.',
'1.2. Íåïðàâèëüíàÿ ïàðêîâêà çà ãîðîäîì: - Ñîòðóäíèê èìååò ïðàâî ýâàêóèðîâàòü ìàøèíó è âûïèñàòü øòðàô â ðàçìåðå îò 250 000$ äî 500 000$.',
'1.3. Íåïðàâèëüíàÿ ïàðêîâêà â ïðèãîðîäå: - Ñîòðóäíèê èìååò ïðàâî âûïèñàòü øòðàô â ðàçìåðå îò 150 000$ äî 300 000$.',
'1.4. Áðîøåííûé àâòîìîáèëü íà äîðîãå: - Ñîòðóäíèê èìååò ïðàâî ýâàêóèðîâàòü òðàíñïîðò è âûïèñàòü øòðàô â ðàçìåðå îò 350 000$ äî 600 000$. - Çà áðîøåííûé àâòîìîáèëü íà ñêîðîñòíûõ òðàññàõ ñîòðóäíèê èìååò ïðàâî ýâàêóèðîâàòü òðàíñïîðò è âûïèñàòü øòðàô â ðàçìåðå îò 350 000$ äî 500 000$.',
'1.5. Ïàðêîâêà íà êðûøàõ çäàíèé: - Ñîòðóäíèê èìååò ïðàâî ýâàêóèðîâàòü òðàíñïîðò è âûïèñàòü øòðàô â ðàçìåðå 500 000$.',
'1.6. Ïàðêîâêà âîçäóøíûõ òðàíñïîðòíûõ ñðåäñòâ èëè ñîçäàíèå ïîìåõ äâèæåíèþ ïðè ïðèçåìëåíèè íà ïàðêîâî÷íûå ìåñòà äëÿ àâòîìîáèëåé èëè èíûå íàðóøåíèÿ ÏÄÄ ïðè óïðàâëåíèè âîçäóøíûìè òðàíñïîðòíûìè ñðåäñòâàìè: - Øòðàô â ðàçìåðå 50 000$.',
'2. Ðàçäåë "Íàðóøåíèå îáùåñòâåííîãî ïîðÿäêà":',
'2.1. Èñïîëüçîâàíèå íåöåíçóðíîé ëåêñèêè â îáùåñòâåííîì ìåñòå: - Ñîòðóäíèê èìååò ïðàâî âûïèñàòü øòðàô â ðàçìåðå 50 000$.',
'2.2. Ðàñïèòèå àëêîãîëüíûõ íàïèòêîâ: - Ñîòðóäíèê èìååò ïðàâî âûïèñàòü øòðàô â ðàçìåðå 100 000$.',
'2.3. Êóðåíèå â îáùåñòâåííîì ìåñòå: - Ñîòðóäíèê èìååò ïðàâî âûïèñàòü øòðàô â ðàçìåðå 100 000$.',
'2.4. Íóæäà â îáùåñòâåííîì ìåñòå: - Øòðàô â ðàçìåðå 50 000$.',
'2.5. Ïðåáûâàíèå â àëêîãîëüíîì îïüÿíåíèè: - Øòðàô â ðàçìåðå 100 000$.',
'2.6. Îñêîðáëåíèå ñîòðóäíèêîâ ãîñóäàðñòâåííûõ îðãàíèçàöèé: - Øòðàô â ðàçìåðå 500 000$ ïðè ïðîäîëæåíèè íåïîäîáàþùåãî ïîâåäåíèÿ. Óðîâåíü ðîçûñêà: 2.',
'2.7. Çàïðåùåíî íàõîäèòüñÿ áåç çàùèòíîé ìàñêè â îáùåñòâåííûõ ìåñòàõ: - Øòðàô â ðàçìåðå 40 000$.',
' Ïóíêò 3. Íàðóøåíèå ÏÄÄ: Äëÿ âîäèòåëåé:',
'3.1. Ãðóáîå íàðóøåíèå ÏÄÄ: - Ñîòðóäíèê èìååò ïðàâî âûïèñàòü øòðàô â ðàçìåðå 300 000$.',
'3.2. Åçäà ïî âñòðå÷íîé ïîëîñå: - Øòðàô â ðàçìåðå 150 000$.',
'3.3. Ïðåâûøåíèå ñêîðîñòè: - Øòðàô â ðàçìåðå 100 000$.',
'3.4. Íàåçä íà ïåøåõîäà: - Óãîëîâíàÿ ñòàòüÿ, ëèøåíèå ïðàâ, øòðàô â ðàçìåðå 400 000$.',
'3.5. Óõîä ñ ìåñòà ÄÒÏ: - Óãîëîâíàÿ ñòàòüÿ, ëèøåíèå âîäèòåëüñêèõ ïðàâ, øòðàô â ðàçìåðå 450 000$.',
'3.6. Âîæäåíèå òðàíñïîðòíîãî ñðåäñòâà â íåòðåçâîì ñîñòîÿíèè: - Ëèøåíèå ïðàâ, øòðàô â ðàçìåðå 20 000$.',
'3.7. Ñîçäàíèå àâàðèéíîé ñèòóàöèè íà äîðîãå: - Óãîëîâíàÿ ñòàòüÿ, ëèøåíèå âîäèòåëüñêèõ ïðàâ, øòðàô â ðàçìåðå 250 000$.',
'3.8. Âûêëþ÷åííûå ôàðû â íî÷íîå âðåìÿ: - Øòðàô â ðàçìåðå 50 000$.',
'3.9. Âûêëþ÷åííûå ïîâîðîòíèêè ïðè ñîâåðøåíèè ïîâîðîòà: - Øòðàô â ðàçìåðå 50 000$.',
'3.10. Äâèæåíèå ïî îáî÷èíàì, òðîòóàðàì, æåëåçíîäîðîæíûì ïóòÿì: - Ëèøåíèå ïðàâ, øòðàô â ðàçìåðå îò 150 000$ äî 300 000$ (â çàâèñèìîñòè îò íàðóøåíèÿ).',
'3.11. Ïðîåçä íà êðàñíûé ñâåò: - Øòðàô â ðàçìåðå 500 000$.',
'3.12. Äâèæåíèå òðàíñïîðòíîãî ñðåäñòâà áåç ðåãèñòðàöèîííîãî çíàêà: - Øòðàô â ðàçìåðå 300 000$.',
'3.13. Íåâûïîëíåíèå òðåáîâàíèÿ Ïðàâèë äîðîæíîãî äâèæåíèÿ óñòóïèòü äîðîãó òðàíñïîðòíîìó ñðåäñòâó, ïîëüçóþùåìóñÿ ïðåèìóùåñòâåííûì ïðàâîì ïðîåçäà íà ïåðåêðåñòêå: - Øòðàô â ðàçìåðå 250 000$.',
'Äëÿ ïåøåõîäîâ:',
'3.13. Ñîçäàíèå àâàðèéíîé ñèòóàöèè: - Øòðàô â ðàçìåðå 200 000$.',
'3.14. Ïåðåäâèæåíèå ïî ïðîåçæåé ÷àñòè: - Øòðàô â ðàçìåðå 150 000$.',
'3.15. Ïåðåõîä íà êðàñíûé ñâåò: - Øòðàô â ðàçìåðå 50 000$.',
'3.16. Åçäà ñî ñëîìàííîé ìàøèíîé: - Øòðàô â ðàçìåðå 170 000$.',
'3.17. Èãíîðèðîâàíèå ñèðåíû ñïåöèàëüíîãî òðàíñïîðòà: - Ñîòðóäíèê âïðàâå âûïèñàòü øòðàô â ðàçìåðå 200 000$ è ëèøèòü âîäèòåëÿ ïðàâ.',
'4. Ðàçäåë "Êëåâåòà"',
'4.1. Êëåâåòà íà æèòåëÿ øòàòà: - Ñîòðóäíèê îáÿçàí âûïèñàòü øòðàô â ðàçìåðå 200 000$.',
'4.2. Ââîä â çàáëóæäåíèå ïðàâîîõðàíèòåëüíûõ îðãàíîâ: - Øòðàô â ðàçìåðå 300 000$.',
'Óãîëîâíûé êîäåêñ (ÓÊ)',
'1. Ðàçäåë "Íàïàäåíèå":',
'1.1. Íàïàäåíèå íà ãðàæäàíñêîå ëèöî ñ öåëüþ èçáèåíèÿ (Óðîâåíü ðîçûñêà: 4).',
'1.1.1. Íàïàäåíèå íà ñîòðóäíèêà ãîñóäàðñòâåííîé îðãàíèçàöèè ñ öåëüþ èçáèåíèÿ (Óðîâåíü ðîçûñêà: 6).',
'1.2. Íàïàäåíèå íà ãðàæäàíñêîå ëèöî ñ öåëüþ óáèéñòâà (Óðîâåíü ðîçûñêà: 6).',
'1.2.1. Íàïàäåíèå íà ñîòðóäíèêà ãîñóäàðñòâåííîé îðãàíèçàöèè ñ öåëüþ óáèéñòâà (Óðîâåíü ðîçûñêà: 6).',
'1.3. Ñîäåéñòâèå â âîîðóæåííîì íàïàäåíèè íà ãîñóäàðñòâåííîãî ñîòðóäíèêà èëè ãðàæäàíèíà (Óðîâåíü ðîçûñêà: 6).',
'1.3.1. Ñîäåéñòâèå â èçáèåíèè ãðàæäàíñêîãî ëèöà èëè ãîñóäàðñòâåííîãî ñîòðóäíèêà (Óðîâåíü ðîçûñêà: 4).',
'1.4. Íàïàäåíèå íà êîëîííó ãîñóäàðñòâåííûõ ñëóæàùèõ (Óðîâåíü ðîçûñêà: 6).',
'2. Ðàçäåë "Íåëåãàëüíàÿ äåÿòåëüíîñòü/Çàïðåùåííûå âåùè/Îðóæèå":',
'2.1. Îðãàíèçàöèÿ íåñàíêöèîíèðîâàííûõ ìèòèíãîâ (Óðîâåíü ðîçûñêà: 4).',
'2.1.1. Ó÷àñòèå â íåñàíêöèîíèðîâàííûõ ìèòèíãàõ (Óðîâåíü ðîçûñêà: 2).',
'2.2. Õèùåíèå ÷óæîãî èìóùåñòâà (Óðîâåíü ðîçûñêà: 3).',
'2.3. Îòêðûòàÿ ðåêëàìà ïðîäàæè èëè ïîêóïêè íàðêîòèêîâ è ìàòåðèàëîâ äëÿ îòìû÷åê (Óðîâåíü ðîçûñêà: 4).',
'2.4. Êðàæà ìàòåðèàëîâ íà òåððèòîðèè àðìèè (Óðîâåíü ðîçûñêà: 5).',
'2.5. Õðàíåíèå è ïåðåâîçêà íàðêîòè÷åñêèõ âåùåñòâ è ìàòåðèàëîâ äëÿ îòìû÷åê (Óðîâåíü ðîçûñêà: 6). Îäíàêî, åñëè íàðêîòèêè íàõîäÿòñÿ â íåáîëüøîì êîëè÷åñòâå è èñïîëüçóþòñÿ â ìåäèöèíñêèõ öåëÿõ, èõ íàëè÷èå ìîæåò áûòü èñêëþ÷åíèåì.',
'2.6. Ñáûò íàðêîòè÷åñêèõ âåùåñòâ è ìàòåðèàëîâ: - Ïðîäàâåö (Óðîâåíü ðîçûñêà: 5). - Ïîêóïàòåëü (Óðîâåíü ðîçûñêà: 4).',
'2.7. Óïîòðåáëåíèå íàðêîòè÷åñêèõ/ïñèõîòðîïíûõ âåùåñòâ (Óðîâåíü ðîçûñêà: 4).',
'2.8. Ðýêåò è êðûøåâàíèå áèçíåñîâ (Óðîâåíü ðîçûñêà: 5).',
'2.9. Îðãàíèçàöèÿ íåëåãàëüíûõ àçàðòíûõ èãð (Óðîâåíü ðîçûñêà: 5). 2.11. Íåçàêîííîå ïðèîáðåòåíèå è ñáûò îðóæèÿ (Óðîâåíü ðîçûñêà: 5). Â òàêèõ ñëó÷àÿõ ïðîèçâîäèòñÿ èçúÿòèå îðóæèÿ è ëèöåíçèé íà íåãî.',
'2.10. Õðàíåíèå èëè íîøåíèå îðóæèÿ áåç ëèöåíçèè (Óðîâåíü ðîçûñêà: 3).',
'2.11. Íîøåíèå îðóæèÿ â îòêðûòîì âèäå (Óðîâåíü ðîçûñêà: 3). Â òàêèõ ñëó÷àÿõ ïðîèçâîäèòñÿ èçúÿòèå ëèöåíçèè íà îðóæèå è ñàìîãî îðóæèÿ.',
'2.12. Âûðàùèâàíèå è ðàñïðîñòðàíåíèå çàïðåùåííûõ âåùåñòâ (Óðîâåíü ðîçûñêà: 3).',
'2.13. Ïðèíàäëåæíîñòü ê óëè÷íûì ãðóïïèðîâêàì/ìàôèè (Óðîâåíü ðîçûñêà: 6).',
'2.14. Îðãàíèçàöèÿ óëè÷íûõ ãðóïïèðîâîê/ìàôèè (Óðîâåíü ðîçûñêà: 6).',
'2.15. Íåçàêîííîå ïðåäñòàâëåíèå/íåçàêîííîå íîøåíèå ôîðìåííîé îäåæäû (Óðîâåíü ðîçûñêà: 6)',
'3. Ðàçäåë "Íàðóøåíèå ÏÄÄ":',
'3.1. Óõîä ñ ìåñòà ÄÒÏ (Óðîâåíü ðîçûñêà: 3).',
'3.2. Ñîçäàíèå àâàðèéíîé ñèòóàöèè íà äîðîãå (Óðîâåíü ðîçûñêà: 2).',
'3.3. Íàåçä íà ïåøåõîäà (óðîâåíü ðîçûñêà çàâèñèò îò òÿæåñòè íàðóøåíèÿ è ìîæåò áûòü îò 1 äî 3).',
'4. Ðàçäåë "Íåïîä÷èíåíèå":',
'4.1. Íåïîä÷èíåíèå ñîòðóäíèêó ïðàâîîõðàíèòåëüíûõ îðãàíîâ (Óðîâåíü ðîçûñêà: 4). Ïåðåä âûäà÷åé ðîçûñêà îáÿçàòåëüíî òðåáóåòñÿ ïðåäñòàâèòüñÿ è îáúÿñíèòü ïðè÷èíó.',
'4.2. Îòêàç âûïëàòû øòðàôà (Óðîâåíü ðîçûñêà: 5).',
'4.3. Îòêàç îñòàíîâèòüñÿ ïðè ïðîñüáå ÷åðåç ìåãàôîí (Óðîâåíü ðîçûñêà: 3). Âûäà÷à ðîçûñêà ïðîèñõîäèò ïîñëå óñòàíîâëåíèÿ ëè÷íîñòè âîäèòåëÿ.',
'4.4. Íåñîáëþäåíèå óêàçîâ Ïðåçèäåíòà (Óðîâåíü ðîçûñêà: 2).',
'4.5. Ñîäåéñòâèå àðåñòó èëè ñîïðîòèâëåíèå ñîäåéñòâèþ àðåñòà (Óðîâåíü ðîçûñêà: 5).',
'5. Ðàçäåë "Òåðàêòû":',
'5.1. Ïîõèùåíèå ãðàæäàí èëè ãîñóäàðñòâåííûõ ñîòðóäíèêîâ ñ öåëüþ âûêóïà (Óðîâåíü ðîçûñêà: 6).',
'5.2. Îãðàáëåíèå îðãàíèçàöèé, ìàãàçèíîâ èëè àâòîçàïðàâî÷íûõ ñòàíöèé (Óðîâåíü ðîçûñêà: 6).',
'5.3. Ïëàíèðîâàíèå òåðàêòà (Óðîâåíü ðîçûñêà: 6).',
'5.4. Îðãàíèçàöèÿ òåðàêòà (Óðîâåíü ðîçûñêà: 6).',
'5.5. Ñîçäàíèå òåððîðèñòè÷åñêèõ ãðóïïèðîâîê (Óðîâåíü ðîçûñêà: 6).',
'5.6. Âçÿòèå çàëîæíèêîâ è ïîõèùåíèå ëþäåé (Óðîâåíü ðîçûñêà: 6).',
'5.7. Ïîïûòêà ãîñóäàðñòâåííîãî ïåðåâîðîòà (Óðîâåíü ðîçûñêà: 6 + ×åðíûé Ñïèñîê ãîñóäàðñòâà + øòðàô â ðàçìåðå 20 000 000).',
'5.8. Òåëåôîííûé òåððîðèçì (Óðîâåíü ðîçûñêà: 6).',
'6. Ðàçäåë "Ïðîíèêíîâåíèå":',
'6.1. Ïðîíèêíîâåíèå íà îõðàíÿåìóþ òåððèòîðèþ, ïîä îõðàíîé ïðàâîîõðàíèòåëüíûõ îðãàíîâ (Óðîâåíü ðîçûñêà: 6).',
'6.2. Ïðîíèêíîâåíèå íà ÷àñòíóþ òåððèòîðèþ áåç ðàçðåøåíèÿ âëàäåëüöà (Óðîâåíü ðîçûñêà: 4).',
'6.3. Ïðîíèêíîâåíèå íà òåððèòîðèþ çàêðûòîé âîåííîé áàçû (Óðîâåíü ðîçûñêà: 6).',
'7. Ðàçäåë "Ïðîñòèòóöèÿ":',
'7.1. Ó÷àñòèå â ïðîñòèòóöèè (Óðîâåíü ðîçûñêà: 4).',
'7.2. Âîâëå÷åíèå â çàíÿòèå ïðîñòèòóöèåé (Óðîâåíü ðîçûñêà: 5).',
'7.3. Èçíàñèëîâàíèå (Óðîâåíü ðîçûñêà: 6).',
'8. Ðàçäåë "Äà÷à ëîæíûõ ïîêàçàíèé":',
'8.1. Äà÷à çàâåäîìî ëîæíûõ ïîêàçàíèé ñîòðóäíèêàì ïðàâîîõðàíèòåëüíûõ îðãàíîâ (Óðîâåíü ðîçûñêà: 4)',
'8.2. Ëîæíûé âûçîâ ñîòðóäíèêîâ ïîëèöèè/ÔÁÐ (Óðîâåíü ðîçûñêà: 4)',
'8.3. Óêðûâàòåëüñòâî ïðåñòóïíèêà (Óðîâåíü ðîçûñêà: 5)',
'8.4. Äà÷à ëîæíûõ ïîêàçàíèé â ñóäå. (Øòðàô 5.000.000 äîëëàðîâ è 4 óðîâåíü ðîçûñêà)',
'9. Ðàçäåë "Õóëèãàíñòâî":',
'9.1. Íåóâàæèòåëüíîå îòíîøåíèå ê äðóãèì ðàñàì/ìåíüøèíñòâàì (Óðîâåíü ðîçûñêà: 4).',
'9.2. Óãðîçà ðàñïðàâîé (Óðîâåíü ðîçûñêà: 3).',
'9.3. Ïîð÷à èìóùåñòâà ãîñóäàðñòâåííûõ îðãàíèçàöèé (Óðîâåíü ðîçûñêà: 2) èëè øòðàô â ðàçìåðå 500 000 äîëëàðîâ.',
'9.3.1. Ïîð÷à èìóùåñòâà ãðàæäàíñêèõ ëèö (Óðîâåíü ðîçûñêà: 1).',
'9.4. Ïîïûòêà óãîíà òðàíñïîðòíîãî ñðåäñòâà (Óðîâåíü ðîçûñêà: 3).',
'9.4.1. Óãîí òðàíñïîðòíîãî ñðåäñòâà (Óðîâåíü ðîçûñêà: 5).',
'9.5. Íîøåíèå ãðàæäàíñêèìè ëèöàìè ìàñêè, ñêðûâàþùåé ëèöî (Óðîâåíü ðîçûñêà: 1). Ïðèìå÷àíèå: Ñíà÷àëà ñëåäóåò ïîïðîñèòü ñíÿòü ìàñêó, òàê êàê äàííûå ëèöà âûçûâàþò ïîäîçðåíèÿ ó ñîòðóäíèêîâ ïðàâîîõðàíèòåëüíûõ îðãàíîâ.',
'10. Ðàçäåë "Ïîñÿãàòåëüñòâî íà ñîáñòâåííîñòü":',
'10.1. Ïîñÿãàòåëüñòâî íà ÷àñòíóþ ñîáñòâåííîñòü ñ ïðèìåíåíèåì ñèëû (Øòðàô äî 10 000 000 äîëëàðîâ, Óðîâåíü ðîçûñêà: 5).',
'10.2. Ïîñÿãàòåëüñòâî íà ÷àñòíóþ ñîáñòâåííîñòü ïóòåì ôàáðèêàöèè þðèäè÷åñêèõ äîêóìåíòîâ (Øòðàô äî 10 000 000 äîëëàðîâ, Óðîâåíü ðîçûñêà: 6).',
'10.3. Ïîñÿãàòåëüñòâî íà ãîñóäàðñòâåííóþ ñîáñòâåííîñòü â ëþáîì âèäå (Øòðàô äî 30 000 000 äîëëàðîâ, Óðîâåíü ðîçûñêà: 6).',
'10.4. Íåçàêîííàÿ êóïëÿ/ïðîäàæà ãîñóäàðñòâåííîé ñîáñòâåííîñòè (Ñíÿòèå ñ äîëæíîñòè, øòðàô äî 5 000 000 äîëëàðîâ, Óðîâåíü ðîçûñêà: 6).',
'11. Ðàçäåë "Ïðåâûøåíèå äîëæíîñòíûõ ïîëíîìî÷èé":',
'11.1. Ïðåâûøåíèå äîëæíîñòíûõ ïîëíîìî÷èé ñ êîðûñòíîé öåëüþ (Ñíÿòèå ñ äîëæíîñòè + ×åðíûé Ñïèñîê îðãàíèçàöèè, Óðîâåíü ðîçûñêà: 6).',
'Ôåäåðàëüíîå ïîñòàíîâëåíèå (ÔÏ)',
'1. Ðàçäåë "Ïîëîæåíèÿ ê Ôåäåðàëüíîìó Ïîñòàíîâëåíèþ"',
'1.1. Ôåäåðàëüíîå Ïîñòàíîâëåíèå âûïóñêàåòñÿ Àäìèíèñòðàöèåé Ïðåçèäåíòà è Ôåäåðàëüíûì Áþðî Ðàññëåäîâàíèé â îòíîøåíèè ãîñóäàðñòâåííûõ ñëóæàùèõ.',
'1.2. Èçìåíåíèå Ôåäåðàëüíîãî Ïîñòàíîâëåíèÿ ìîæåò áûòü îñóùåñòâëåíî Äèðåêòîðîì ÔÁÐ èëè Ãóáåðíàòîðîì øòàòà.',
'1.3. Îáÿçàííîñòü ñîáëþäåíèÿ Ôåäåðàëüíîãî Ïîñòàíîâëåíèÿ ëåæèò íà âñåì ïåðñîíàëå ãîñóäàðñòâåííûõ îðãàíèçàöèé.',
'1.4. Îòñóòñòâèå îñâåäîìëåííîñòè î ñîäåðæàíèè Ôåäåðàëüíîãî Ïîñòàíîâëåíèÿ íå îïðàâäûâàåò îáâèíÿåìîãî è íå îñâîáîæäàåò åãî îò îòâåòñòâåííîñòè.',
'1.5. Â ñëó÷àå, åñëè ãîñóäàðñòâåííûé ñëóæàùèé ñîâåðøàåò äåéñòâèå, êîòîðîå ìîæåò ðàññìàòðèâàòüñÿ êàê êîñâåííîå íàðóøåíèå íîðìàòèâíî-ïðàâîâîãî àêòà, ïðèìåíèìî ê ëþáîìó èç äåéñòâóþùèõ ïóíêòîâ çàêîíîäàòåëüíîé áàçû ñ ññûëêîé íà Ôåäåðàëüíîå Ïîñòàíîâëåíèå.',
'1.6. Ïîëîæåíèÿ, ïðåäîñòàâëÿþùèå âîçìîæíîñòü âûáîðà âèäà íàêàçàíèÿ, ïðåäïîëàãàþò ïðèìåíåíèå îäíîãî èç íèõ ïî óñìîòðåíèþ íàçíà÷àþùåãî íàêàçàíèå, ó÷èòûâàÿ òÿæåñòü íàðóøåíèÿ è íàëè÷èå ïðåäøåñòâóþùèõ ïðåäóïðåæäåíèé èëè íàðóøåíèé â ïðîøëîì.',
'',
'2. Ðàçäåë "Ïîëîæåíèÿ îòíîñèòåëüíî ãîñóäàðñòâåííûõ îðãàíèçàöèé"',
'2.1. Çàïðåùàåòñÿ íàðóøåíèå çàêîíîäàòåëüíîé áàçû øòàòà, âëåêóùåå çà ñîáîé óñòíîå ïðåäóïðåæäåíèå, âûãîâîð, ïîíèæåíèå èëè óâîëüíåíèå.',
'2.2. Çàïðåùàåòñÿ èñïîëüçîâàíèå ñëóæåáíîãî ïîëîæåíèÿ â ëè÷íûõ èíòåðåñàõ, ÷òî ìîæåò ïðèâåñòè ê ïîíèæåíèþ èëè óâîëüíåíèþ.',
'2.3. Çàïðåùàåòñÿ íåñàíêöèîíèðîâàííîå ïðèìåíåíèå ôèçè÷åñêîãî âîçäåéñòâèÿ íà ãðàæäàíñêèõ èëè ãîñóäàðñòâåííûõ ëèö, à òàêæå èõ èìóùåñòâî, ïîäëåæàùåå ïîíèæåíèþ èëè óâîëüíåíèþ.',
'2.4. Çàïðåùàåòñÿ ïðèíÿòèå, ïðåäëîæåíèå èëè ïðåäîñòàâëåíèå âçÿòîê, çà ÷òî ïðåäóñìîòðåíî óâîëüíåíèå ñ ïðèâëå÷åíèåì ê óãîëîâíîé îòâåòñòâåííîñòè.',
'2.5. Çàïðåùàåòñÿ ó÷àñòèå â ïðåñòóïíûõ äåéñòâèÿõ, ñãîâîðàõ èëè òåððîðèñòè÷åñêèõ àêòàõ, ÷òî âëå÷åò çà ñîáîé óâîëüíåíèå è âíåñåíèå â ÷åðíûé ñïèñîê ãîñóäàðñòâåííûõ ñòðóêòóð.',
'2.6. Çàïðåùàåòñÿ çàíèìàòüñÿ ëè÷íûìè äåëàìè â ðàáî÷åå âðåìÿ, ê ÷åìó ïðèìåíÿþòñÿ äâà âûãîâîðà èëè óâîëüíåíèå, çà èñêëþ÷åíèåì ñëó÷àåâ, êîãäà ñîòðóäíèê íàõîäèòñÿ â ñîñòîÿíèè ÷ðåçâû÷àéíîé ñèòóàöèè.',
'2.7. Çàïðåùàåòñÿ óïîòðåáëåíèå, ïîêóïêà, ïðîäàæà è õðàíåíèå íàðêîòè÷åñêèõ ñðåäñòâ, ïîäëåæàùèõ ïîíèæåíèþ èëè óâîëüíåíèþ, çà èñêëþ÷åíèåì ñëó÷àåâ, êîãäà ýòî íåîáõîäèìî ïðè ñëåäñòâåííûõ ìåðîïðèÿòèÿõ äëÿ àãåíòîâ ÔÁÐ.',
'2.8. Äëÿ ñëóæàùèõ àðìèé çàïðåùàåòñÿ íàõîæäåíèå çà ïðåäåëàìè ìåñò ïîñòîÿííîé äèñëîêàöèè ñâîåé âîèíñêîé ÷àñòè, êðîìå ñëó÷àåâ ïàòðóëèðîâàíèÿ, ïîñòàâîê, ×Ñ è äðóãèõ ìåðîïðèÿòèé, óòâåðæäåííûõ ðóêîâîäÿùèì ñîñòàâîì.',
'2.9. Çàïðåùàåòñÿ ïðåâûøåíèå äîëæíîñòíûõ ïîëíîìî÷èé, ÷òî ìîæåò ïðèâåñòè ê âûãîâîðó, ïîíèæåíèþ èëè óâîëüíåíèþ.',
'2.10. Çàïðåùàåòñÿ áåçäåéñòâèå èëè íåèñïîëíåíèå îáÿçàííîñòåé ïî îêàçàíèþ ïîìîùè ëèöàì â îïàñíîé äëÿ æèçíè ñèòóàöèè, ÷òî âëå÷åò çà ñîáîé âûãîâîð èëè ïîíèæåíèå.',
'2.11. Çàïðåùàþòñÿ ïðîÿâëåíèÿ íåàäåêâàòíîãî ïîâåäåíèÿ èëè ïðîâîêàöèé, çà ÷òî ïðåäóñìîòðåíû ïðåäóïðåæäåíèå, âûãîâîð èëè óâîëüíåíèå.',
'2.12. Çàïðåùàåòñÿ èãíîðèðîâàíèå íàðóøåíèé çàêîíîäàòåëüñòâà ãðàæäàíñêèìè èëè ñîòðóäíèêàìè ãîñóäàðñòâåííûõ ñòðóêòóð, ïîäëåæàùåå âûãîâîðó èëè óâîëüíåíèþ.',
'2.13. Çàïðåùàåòñÿ ïðîâîöèðîâàòü ãîñóäàðñòâåííûõ ñîòðóäíèêîâ, ÷òî ìîæåò ïîâëå÷ü çà ñîáîé âûãîâîð, ïîíèæåíèå èëè óâîëüíåíèå.',
'2.14. Çàïðåùàåòñÿ óãðîæàòü ãîñóäàðñòâåííûì ñëóæàùèì, çà èñêëþ÷åíèåì àãåíòîâ ÔÁÐ âî âðåìÿ ñëåäñòâåííûõ ìåðîïðèÿòèé, êîãäà îíè âïðàâå èñïîëüçîâàòü ñâîè ïîëíîìî÷èÿ äëÿ çàäåðæàíèÿ.',
'2.15. Çàïðåùåíî ïåðåäàâàòü èëè ïðîäàâàòü ãîñóäàðñòâåííîå èìóùåñòâî, ÷òî âåäåò ê óâîëüíåíèþ.',
'2.16. Çàïðåùàåòñÿ ïðåäîñòàâëåíèå çàâåäîìî ëîæíîé èíôîðìàöèè ãîñóäàðñòâåííûì ñîòðóäíèêàì, ÷òî ïîäëåæèò ïîíèæåíèþ èëè óâîëüíåíèþ.',
'2.17. Çàïðåùåíî èñïîëüçîâàíèå ëè÷íîãî òðàíñïîðòíîãî ñðåäñòâà âî âðåìÿ èñïîëíåíèÿ ñëóæåáíûõ îáÿçàííîñòåé, ÷òî ìîæåò ïðèâåñòè ê âûãîâîðó, ïîíèæåíèþ èëè óâîëüíåíèþ, çà èñêëþ÷åíèåì îïðåäåëåííûõ êàòåãîðèé ñîòðóäíèêîâ.',
'2.18. Çàïðåùàåòñÿ âñòóïëåíèå â ñãîâîðû ñ ïðåñòóïíûìè ñèíäèêàòàìè èëè óëè÷íûìè ãðóïïèðîâêàìè, ÷òî âëå÷åò çà ñîáîé óâîëüíåíèå è âíåñåíèå â ÷åðíûé ñïèñîê ãîñóäàðñòâåííûõ ñòðóêòóð, çà èñêëþ÷åíèåì àãåíòîâ ÔÁÐ â èíòåðåñàõ íàöèîíàëüíîé áåçîïàñíîñòè.',
'2.19. Çàïðåùàåòñÿ óïîòðåáëåíèå íåöåíçóðíîé áðàíè, çà ÷òî ïðåäóñìîòðåíû ïðåäóïðåæäåíèå èëè âûãîâîð.',
'2.20. Çàïðåùàåòñÿ çàíîñèòü â áàçó ðàçûñêèâàåìûõ ñòàòüè, êîòîðûõ íå ñóùåñòâóåò, ÷òî ïîäëåæèò ïðåäóïðåæäåíèþ èëè âûãîâîðó.',
'2.21. Çàïðåùàåòñÿ èñïîëüçîâàíèå ìåãàôîíà â ëè÷íûõ öåëÿõ â ðàìêàõ ïåðåãîâîðîâ, ÷òî ìîæåò ïðèâåñòè ê âûãîâîðó èëè ïîíèæåíèþ.',
'2.22. Çàïðåùàåòñÿ óïîòðåáëåíèå àëêîãîëÿ â ðàáî÷åå âðåìÿ, ÷òî âëå÷åò çà ñîáîé ïðåäóïðåæäåíèå, âûãîâîð èëè óâîëüíåíèå.',
'2.23. Çàïðåùàåòñÿ óíèæåíèå ÷åñòè è äîñòîèíñòâà ãðàæäàí, çà ÷òî ïðåäóñìîòðåíû ïðåäóïðåæäåíèå, âûãîâîð èëè óâîëüíåíèå, ñ íåêîòîðûìè èñêëþ÷åíèÿìè.',
'',
'3. Ðàçäåë "Ïîëîæåíèÿ îòíîñèòåëüíî ñîòðóäíèêîâ ÔÁÐ"',
'3.1. Çàïðåùàåòñÿ ïðåäîñòàâëåíèå ëîæíîé èíôîðìàöèè è ââîä â çàáëóæäåíèå Àãåíòà ÔÁÐ, Ãóáåðíàòîðà, Âèöå-Ãóáåðíàòîðà, Ñóäüè, ÷òî ïîäëåæèò óâîëüíåíèþ.',
'3.2. Çàïðåùàåòñÿ ïðîâîêàöèîííîå ïîâåäåíèå â îòíîøåíèè Àãåíòà ÔÁÐ, Ãóáåðíàòîðà, Âèöå-Ãóáåðíàòîðà è Ñóäüè, ÷òî ìîæåò ïðèâåñòè ê âûãîâîðó èëè óâîëüíåíèþ.',
'3.3. Çàïðåùàåòñÿ óãðîæàòü è îñêîðáëÿòü Àãåíòà ÔÁÐ, Ãóáåðíàòîðà, Âèöå-Ãóáåðíàòîðà è Ñóäüþ, ÷òî âëå÷åò çà ñîáîé óâîëüíåíèå.',
'3.4. Çàïðåùàåòñÿ ðàñïðîñòðàíåíèå êëåâåòû íà Àãåíòà ÔÁÐ, Ãóáåðíàòîðà, Âèöå-Ãóáåðíàòîðà è Ñóäüþ, ÷òî ïîäëåæèò âûãîâîðó èëè óâîëüíåíèþ.',
'3.5. Çàïðåùàåòñÿ èãíîðèðîâàíèå çàêîííûõ òðåáîâàíèé Àãåíòà ÔÁÐ, Ãóáåðíàòîðà, Âèöå-Ãóáåðíàòîðà, ÷òî ìîæåò ïðèâåñòè ê âûãîâîðó èëè óâîëüíåíèþ.',
'3.6. Àãåíò ÔÁÐ èìååò ïðàâî âûçâàòü ëþáîãî ãîñóäàðñòâåííîãî ñîòðóäíèêà â îôèñ Áþðî áåç îáúÿñíåíèÿ ïðè÷èí, íî ïðè÷èíà áóäåò ðàñêðûòà â îôèñå.',
'3.7. Ëþáîé ãîñóäàðñòâåííûé ñîòðóäíèê îáÿçàí ïðåäúÿâèòü ñâîå óäîñòîâåðåíèå ïî ïåðâîìó òðåáîâàíèþ Àãåíòà ÔÁÐ, Ãóáåðíàòîðà, Âèöå-Ãóáåðíàòîðà, èíà÷å ïðåäóñìîòðåíî âûãîâîð, ïîíèæåíèå èëè óâîëüíåíèå.',
'3.8. Çàïðåùàåòñÿ âúåçä íà òåððèòîðèþ Ôåäåðàëüíîãî Áþðî Ðàññëåäîâàíèé áåç ðàçðåøåíèÿ, êàðàþùèéñÿ óâîëüíåíèåì è ïðèðàâíèâàåìûé ê ñòàòüå 7.1 ÓÊ.',
'3.9. Çàïðåùàåòñÿ ðàñêðûâàòü ëè÷íîñòü àãåíòà ÔÁÐ, íàõîäÿùåãîñÿ â ìàñêèðîâêå, ÷òî ïîäëåæèò óâîëüíåíèþ.',
'3.10. Çàïðåùàåòñÿ ïðåñëåäîâàíèå àâòîìîáèëåé Ôåäåðàëüíîãî Áþðî Ðàññëåäîâàíèé, ÷òî ìîæåò ïîâëå÷ü çà ñîáîé ïðåäóïðåæäåíèå èëè óâîëüíåíèå.',
'3.11. Çàïðåùàåòñÿ áðàòü íà êóðèðîâàíèå ñïåöîïåðàöèè áåç ðàçðåøåíèÿ ÔÁÐ, çà èñêëþ÷åíèåì ñëó÷àåâ, êîãäà îòñóòñòâóåò S.W.A.T, â òàêîì ñëó÷àå êóðèðîâàíèå áåðåò Ëèäåð S.W.A.T.',
'3.12. Çàïðåùàåòñÿ èçáåãàòü ïðîâåðîê îò ÔÁÐ èëè ÀÏ, ÷òî ìîæåò ïðèâåñòè ê óâîëüíåíèþ.',
'3.13. Çàïðåùàåòñÿ îòäàâàòü ïðèêàçû àãåíòó ÔÁÐ èëè ñîòðóäíèêó ÀÏ ðàíãîì âûøå 7 áåç ñîîòâåòñòâóþùèõ ïîëíîìî÷èé, ïîäëåæàùåå âûãîâîðó èëè ïîíèæåíèþ.',
'3.14. Çàïðåùàåòñÿ ïðèìåíÿòü ñàíêöèè ïî îòíîøåíèþ ê àãåíòó ÔÁÐ èëè ñîòðóäíèêó ÀÏ ðàíãîì âûøå 8 ïðè èñïîëíåíèè (øòðàôû è ò.ï.), ÷òî âåäåò ê âûãîâîðó èëè ïîíèæåíèþ.',
'',
'4. Ðàçäåë "Ðàöèÿ äåïàðòàìåíòà è ãîñóäàðñòâåííàÿ âîëíà"',
'4.1. Çàïðåùàåòñÿ îáñóæäåíèå ðàáîòû äðóãèõ îðãàíèçàöèé â ðàöèè äåïàðòàìåíòà, ÷òî ìîæåò ïîâëå÷ü çà ñîáîé âûãîâîð, ïîíèæåíèå èëè óâîëüíåíèå.',
'4.2. Êàòåãîðè÷åñêè çàïðåùàåòñÿ èñïîëüçîâàíèå íåöåíçóðíîé áðàíè ïðè îáùåíèè â ðàöèè äåïàðòàìåíòà, ÷òî ïîäëåæèò âûãîâîðó èëè ïîíèæåíèþ.',
'4.3. Çàïðåùàåòñÿ çàíèìàòü ãîñóäàðñòâåííóþ âîëíó äëÿ ïðîâåäåíèÿ ñîáåñåäîâàíèÿ âî âðåìÿ ðåæèìà ×ðåçâû÷àéíîé Ñèòóàöèè, ÷òî âëå÷åò çà ñîáîé ïðåäóïðåæäåíèå èëè âûãîâîð.',
'4.4. Çàïðåùàåòñÿ ó÷àñòâîâàòü â ñîçäàíèè êîíôëèêòíûõ ñèòóàöèé ìåæäó îðãàíèçàöèÿìè, ÷òî ìîæåò ïðèâåñòè ê âûãîâîðó èëè óâîëüíåíèþ.',
'4.5. Åñëè ê âàì îáðàùàþòñÿ ïî çàêðûòîìó êàíàëó, òî çàïðåùàåòñÿ îòâå÷àòü â îòêðûòîì êàíàëå, ïîäëåæèò ïðåäóïðåæäåíèþ èëè âûãîâîðó.',
}

local AllWindowsPunish = imgui.OnFrame(function() return punishMenu[0] end, function()
	if punishSwitch == 0 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 205, 440
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.PushFont(myFont)
		imgui.Begin(u8'Ïðàâèëà', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.BeginChild('##punishMenu', imgui.ImVec2(195,400), false)
		if imgui.Button(u8'Ïðàâèëà àäìèíèñòðàöèè', imgui.ImVec2(190, 35)) then
			punishSwitch = 1
		end
		if imgui.Button(u8'Ïðàâèëà ëèäåðîâ', imgui.ImVec2(190, 35)) then
			punishSwitch = 2
		end
		if imgui.Button(u8'Ïðàâèëà ñàïïîðòîâ', imgui.ImVec2(190, 35)) then
			punishSwitch = 3
		end
		if imgui.Button(u8'Ïðàâèëà ãîñ. îðãàíèçàöèé', imgui.ImVec2(190, 35)) then
			punishSwitch = 4
		end
		if imgui.Button(u8'Ïðàâèëà ïðîâåäåíèÿ îòáîðà', imgui.ImVec2(190, 35)) then
			punishSwitch = 5
		end
		if imgui.Button(u8'Ïðàâèëà èãðû â /try', imgui.ImVec2(190, 35)) then
			punishSwitch = 6
		end
		if imgui.Button(u8'Îáùèå ïðàâèëà', imgui.ImVec2(190, 35)) then
			punishSwitch = 7
		end
		if imgui.Button(u8'Ïðàâèëà êàïòîâ', imgui.ImVec2(190, 35)) then
			punishSwitch = 8
		end
		if imgui.Button(u8'Ïðàâèëà áèçâàðîâ', imgui.ImVec2(190, 35)) then
			punishSwitch = 9
		end
		if imgui.Button(u8'ÓÊ/ÀÊ/ÔÏ', imgui.ImVec2(190, 35)) then
			punishSwitch = 10
		end
		imgui.EndChild()
		imgui.PopFont()
		imgui.End()
	elseif punishSwitch == 1 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 1250, 475
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'Ïðàâèëà àäìèíèñòðàöèè', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Separator()
		imgui.InputTextWithHint('##Search1',u8'Ïîèñê',search,256)
		imgui.Separator()
		for k,v in pairs(arules) do
            if u8(v):find(ffi.string(search)) then
                imgui.Text(u8(v))
            end
        end
        imgui.PopFont()
	elseif punishSwitch == 2 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 1250, 475
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'Ïðàâèëà ëèäåðîâ', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Separator()
		imgui.InputTextWithHint('##Search2',u8'Ïîèñê',search,256)
		imgui.Separator()
		for k,v in pairs(lrules) do
            if u8(v):find(ffi.string(search)) then
                imgui.Text(u8(v))
            end
        end
        imgui.PopFont()
	elseif punishSwitch == 3 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 1250, 475
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'Ïðàâèëà ñàïïîðòîâ', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Separator()
		imgui.InputTextWithHint('##Search3',u8'Ïîèñê',search,256)
		imgui.Separator()
		for k,v in pairs(srules) do
            if u8(v):find(ffi.string(search)) then
                imgui.Text(u8(v))
            end
        end
        imgui.PopFont()
	elseif punishSwitch == 4 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 1250, 375
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'Ïðàâèëà ãîñ. îðãàíèçàöèé', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Separator()
		imgui.InputTextWithHint('##Search4',u8'Ïîèñê',search,256)
		imgui.Separator()
		for k,v in pairs(gosrules) do
            if u8(v):find(ffi.string(search)) then
                imgui.Text(u8(v))
            end
        end
        imgui.PopFont()
	elseif punishSwitch == 5 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 1250, 275
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'Ïðàâèëà ïðîâåäåíèÿ îòáîðà', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Separator()
		imgui.InputTextWithHint('##Search5',u8'Ïîèñê',search,256)
		imgui.Separator()
		for k,v in pairs(orules) do
            if u8(v):find(ffi.string(search)) then
                imgui.Text(u8(v))
            end
        end
        imgui.PopFont()
	elseif punishSwitch == 6 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 1250, 375
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'Ïðàâèëà èãðû â /try', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Separator()
		imgui.InputTextWithHint('##Search6',u8'Ïîèñê',search,256)
		imgui.Separator()
		for k,v in pairs(tryrules) do
            if u8(v):find(ffi.string(search)) then
                imgui.Text(u8(v))
            end
        end
        imgui.PopFont()
	elseif punishSwitch == 7 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 1250, 475
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'Îáùèå ïðàâèëà', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Separator()
		imgui.InputTextWithHint('##Search7',u8'Ïîèñê',search,256)
		imgui.Separator()
		for k,v in pairs(punish) do
            if u8(v):find(ffi.string(search)) then
                imgui.Text(u8(v))
            end
        end
        imgui.PopFont()
	elseif punishSwitch == 8 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 1250, 475
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'Ïðàâèëà êàïòîâ', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Separator()
		imgui.InputTextWithHint('##Search8',u8'Ïîèñê',search,256)
		imgui.Separator()
		for k,v in pairs(capturerules) do
            if u8(v):find(ffi.string(search)) then
                imgui.Text(u8(v))
            end
        end
        imgui.PopFont()
	elseif punishSwitch == 9 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 1250, 475
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'Ïðàâèëà áèçâàðà', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Separator()
		imgui.InputTextWithHint('##Search9',u8'Ïîèñê',search,256)
		imgui.Separator()
		for k,v in pairs(bizwarrules) do
            if u8(v):find(ffi.string(search)) then
                imgui.Text(u8(v))
            end
        end
        imgui.PopFont()
	elseif punishSwitch == 10 then
		imgui.PushFont(myFont)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 1250, 475
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY))
		imgui.Begin(u8'ÓÊ/ÀÊ/ÔÏ', punishMenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Separator()
		imgui.InputTextWithHint('##Search10',u8'Ïîèñê',search,256)
		imgui.Separator()
		for k,v in pairs(codex) do
            if u8(v):find(ffi.string(search)) then
                imgui.Text(u8(v))
            end
        end
        imgui.PopFont()
    end
    imgui.End()
end)

function cyrillic(text)
    local convtbl = {
    	[230] = 155, [231] = 159, [247] = 164, [234] = 107, [250] = 144, [251] = 168,
    	[254] = 171, [253] = 170, [255] = 172, [224] = 097, [240] = 112, [241] = 099, 
    	[226] = 162, [228] = 154, [225] = 151, [227] = 153, [248] = 165, [243] = 121, 
    	[184] = 101, [235] = 158, [238] = 111, [245] = 120, [233] = 157, [242] = 166, 
    	[239] = 163, [244] = 063, [237] = 174, [229] = 101, [246] = 036, [236] = 175, 
    	[232] = 156, [249] = 161, [252] = 169, [215] = 141, [202] = 075, [204] = 077, 
    	[220] = 146, [221] = 147, [222] = 148, [192] = 065, [193] = 128, [209] = 067, 
    	[194] = 139, [195] = 130, [197] = 069, [206] = 079, [213] = 088, [168] = 069, 
    	[223] = 149, [207] = 140, [203] = 135, [201] = 133, [199] = 136, [196] = 131, 
    	[208] = 080, [200] = 133, [198] = 132, [210] = 143, [211] = 089, [216] = 142, 
    	[212] = 129, [214] = 137, [205] = 072, [217] = 138, [218] = 167, [219] = 145
    }
    local result = {}
    for i = 1, string.len(text) do
        local c = text:byte(i)
        result[i] = string.char(convtbl[c] or c)
    end
    return table.concat(result)
end

theme = {
	{
		change = function() -- classic
			
			local style = imgui.GetStyle()
			local colors = style.Colors

			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);

			style.Colors[imgui.Col.Text] = imgui.ImVec4(0.90, 0.90, 0.90, 1.00);
			style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.60, 0.60, 0.60, 1.00);
			style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.00, 0.00, 0.00, 0.70);
			style.Colors[imgui.Col.ChildBg] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
			style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.11, 0.11, 0.14, 0.92);
			style.Colors[imgui.Col.Border] = imgui.ImVec4(0.50, 0.50, 0.50, 0.50);
			style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
			style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.43, 0.43, 0.43, 0.39);
			style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.47, 0.47, 0.69, 0.40);
			style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.42, 0.41, 0.64, 0.69);
			style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.27, 0.27, 0.54, 0.83);
			style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.32, 0.32, 0.63, 0.87);
			style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.40, 0.40, 0.80, 0.20);
			style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.40, 0.40, 0.55, 0.80);
			style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.20, 0.25, 0.30, 0.60);
			style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.40, 0.40, 0.80, 0.30);
			style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.40, 0.40, 0.80, 0.40);
			style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.41, 0.39, 0.80, 0.60);
			style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.90, 0.90, 0.90, 0.50);
			style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(1.00, 1.00, 1.00, 0.30);
			style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.41, 0.39, 0.80, 0.60);
			style.Colors[imgui.Col.Button] = imgui.ImVec4(0.35, 0.40, 0.61, 0.62);
			style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.40, 0.48, 0.71, 0.79);
			style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.46, 0.54, 0.80, 1.00);
			style.Colors[imgui.Col.Header] = imgui.ImVec4(0.40, 0.40, 0.90, 0.45);
			style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.45, 0.45, 0.90, 0.80);
			style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.53, 0.53, 0.87, 0.80);
			style.Colors[imgui.Col.Separator] = imgui.ImVec4(0.50, 0.50, 0.50, 0.60);
			style.Colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.60, 0.60, 0.70, 1.00);
			style.Colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.70, 0.70, 0.90, 1.00);
			style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(1.00, 1.00, 1.00, 0.16);
			style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.78, 0.82, 1.00, 0.60);
			style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.78, 0.82, 1.00, 0.90);
			style.Colors[imgui.Col.Tab] = imgui.ImVec4(0.34, 0.34, 0.68, 0.79);
			style.Colors[imgui.Col.TabHovered] = imgui.ImVec4(0.45, 0.45, 0.90, 0.80);
			style.Colors[imgui.Col.TabActive] = imgui.ImVec4(0.40, 0.40, 0.73, 0.84);
			style.Colors[imgui.Col.TabUnfocused] = imgui.ImVec4(0.28, 0.28, 0.57, 0.82);
			style.Colors[imgui.Col.TabUnfocusedActive] = imgui.ImVec4(0.35, 0.35, 0.65, 0.84);
			style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(1.00, 1.00, 1.00, 1.00);
			style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00);
			style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00);
			style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1.00, 0.60, 0.00, 1.00);
			style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.00, 0.00, 1.00, 0.35);
			style.Colors[imgui.Col.DragDropTarget] = imgui.ImVec4(1.00, 1.00, 0.00, 0.90);
			style.Colors[imgui.Col.NavHighlight] = imgui.ImVec4(0.45, 0.45, 0.90, 0.80);
			style.Colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70);
			style.Colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.20);
			style.Colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.20, 0.20, 0.20, 0.35);
		end
	},
	{
		change = function() -- blue
			local style = imgui.GetStyle()
			local colors = style.Colors

			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
			

			style.Colors[imgui.Col.Text] = imgui.ImVec4(1.00, 1.00, 1.00, 1.00);
			style.Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.50, 0.50, 0.50, 1.00);
			style.Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.06, 0.06, 0.06, 0.94);
			style.Colors[imgui.Col.ChildBg] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
			style.Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.08, 0.08, 0.08, 0.94);
			style.Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.50, 0.50);
			style.Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
			style.Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.16, 0.29, 0.48, 0.54);
			style.Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.40);
			style.Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.26, 0.59, 0.98, 0.67);
			style.Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.04, 0.04, 0.04, 1.00);
			style.Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.16, 0.29, 0.48, 1.00);
			style.Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.00, 0.00, 0.00, 0.51);
			style.Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.14, 0.14, 0.14, 1.00);
			style.Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.02, 0.02, 0.02, 0.53);
			style.Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.31, 0.31, 0.31, 1.00);
			style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.41, 0.41, 1.00);
			style.Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.51, 0.51, 0.51, 1.00);
			style.Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
			style.Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.24, 0.52, 0.88, 1.00);
			style.Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
			style.Colors[imgui.Col.Button] = imgui.ImVec4(0.26, 0.59, 0.98, 0.40);
			style.Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
			style.Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.06, 0.53, 0.98, 1.00);
			style.Colors[imgui.Col.Header] = imgui.ImVec4(0.26, 0.59, 0.98, 0.31);
			style.Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.80);
			style.Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
			style.Colors[imgui.Col.Separator] = imgui.ImVec4(0.43, 0.43, 0.50, 0.50);
			style.Colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.10, 0.40, 0.75, 0.78);
			style.Colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.10, 0.40, 0.75, 1.00);
			style.Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.26, 0.59, 0.98, 0.25);
			style.Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.67);
			style.Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.26, 0.59, 0.98, 0.95);
			style.Colors[imgui.Col.Tab] = imgui.ImVec4(0.18, 0.35, 0.58, 0.86);
			style.Colors[imgui.Col.TabHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.80);
			style.Colors[imgui.Col.TabActive] = imgui.ImVec4(0.20, 0.41, 0.68, 1.00);
			style.Colors[imgui.Col.TabUnfocused] = imgui.ImVec4(0.07, 0.10, 0.15, 0.97);
			style.Colors[imgui.Col.TabUnfocusedActive] = imgui.ImVec4(0.14, 0.26, 0.42, 1.00);
			style.Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1.00);
			style.Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1.00, 0.43, 0.35, 1.00);
			style.Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00);
			style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1.00, 0.60, 0.00, 1.00);
			style.Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.26, 0.59, 0.98, 0.35);
			style.Colors[imgui.Col.DragDropTarget] = imgui.ImVec4(1.00, 1.00, 0.00, 0.90);
			style.Colors[imgui.Col.NavHighlight] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
			style.Colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70);
			style.Colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.20);
			style.Colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.35);
		end
	},
	{
		change = function() -- black-blue
			local style = imgui.GetStyle();
            local colors = style.Colors;

			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
			

            colors[imgui.Col.Text] = imgui.ImVec4(1.00, 1.00, 1.00, 1.00);
            colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.50, 0.50, 0.50, 1.00);
            colors[imgui.Col.WindowBg] = imgui.ImVec4(0.05, 0.10, 0.28, 0.94);
            colors[imgui.Col.ChildBg] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
            colors[imgui.Col.PopupBg] = imgui.ImVec4(0.05, 0.10, 0.28, 0.94);
            colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.50, 0.50);
            colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
            colors[imgui.Col.FrameBg] = imgui.ImVec4(0.13, 0.18, 0.38, 0.94);
            colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.12, 0.21, 0.53, 0.94);
            colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.14, 0.28, 0.83, 0.94);
            colors[imgui.Col.TitleBg] = imgui.ImVec4(0.05, 0.10, 0.28, 0.94);
            colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.05, 0.10, 0.28, 0.94);
            colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.00, 0.00, 0.00, 0.51);
            colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.14, 0.14, 0.14, 1.00);
            colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.00, 0.00, 0.00, 0.53);
            colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.17, 0.19, 0.29, 0.94);
            colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.41, 0.41, 1.00);
            colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.51, 0.51, 0.51, 1.00);
            colors[imgui.Col.CheckMark] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
            colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.24, 0.52, 0.88, 1.00);
            colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
            colors[imgui.Col.Button] = imgui.ImVec4(0.26, 0.59, 0.98, 0.40);
            colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
            colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.06, 0.53, 0.98, 1.00);
            colors[imgui.Col.Header] = imgui.ImVec4(0.26, 0.59, 0.98, 0.31);
            colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.80);
            colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
            colors[imgui.Col.Separator] = imgui.ImVec4(0.43, 0.43, 0.50, 0.50);
            colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.10, 0.40, 0.75, 0.78);
            colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.10, 0.40, 0.75, 1.00);
            colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.05, 0.10, 0.28, 0.94);
            colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.05, 0.10, 0.28, 0.94);
            colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.05, 0.10, 0.28, 0.94);
            colors[imgui.Col.Tab] = imgui.ImVec4(0.25, 0.33, 0.63, 0.94);
            colors[imgui.Col.TabHovered] = imgui.ImVec4(0.26, 0.59, 0.98, 0.80);
            colors[imgui.Col.TabActive] = imgui.ImVec4(0.20, 0.41, 0.68, 1.00);
            colors[imgui.Col.TabUnfocused] = imgui.ImVec4(0.07, 0.10, 0.15, 0.97);
            colors[imgui.Col.TabUnfocusedActive] = imgui.ImVec4(0.14, 0.26, 0.42, 1.00);
            colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1.00);
            colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1.00, 0.43, 0.35, 1.00);
            colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00);
            colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1.00, 0.60, 0.00, 1.00);
            colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.26, 0.59, 0.98, 0.35);
            colors[imgui.Col.DragDropTarget] = imgui.ImVec4(1.00, 1.00, 0.00, 0.90);
            colors[imgui.Col.NavHighlight] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
            colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70);
            colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.20);
            colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.35);
		end
	},
	{
		change = function() -- dark
			local style = imgui.GetStyle()


			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
			

			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
			
		
			imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.00, 0.00, 0.00, 0.82)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.82)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.00, 0.00, 0.00, 0.82)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.00, 0.00, 0.00, 0.82)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
            imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
            imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
            imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
            imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
		end
	},
	{
		change = function() -- softblue
			local style = imgui.GetStyle()
			local colors = style.Colors
		

			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
			

			style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.90, 0.90, 0.93, 1.00)
			style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
			style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
			style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.13, 0.13, 0.15, 1.00)
			style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.30, 0.30, 0.35, 1.00)
			style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.18, 0.18, 0.20, 1.00)
			style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
			style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
			style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.15, 0.17, 1.00)
			style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.10, 0.10, 0.12, 1.00)
			style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.15, 0.15, 0.17, 1.00)
			style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
			style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.14, 1.00)
			style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.30, 0.30, 0.35, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
			style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.70, 0.70, 0.90, 1.00)
			style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.70, 0.70, 0.90, 1.00)
			style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.80, 0.80, 0.90, 1.00)
			style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.18, 0.18, 0.20, 1.00)
			style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.60, 0.60, 0.90, 1.00)
			style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.28, 0.56, 0.96, 1.00)
			style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.20, 0.20, 0.23, 1.00)
			style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
			style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
			style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.40, 0.40, 0.45, 1.00)
			style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
			style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.60, 0.60, 0.65, 1.00)
			style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.20, 0.20, 0.23, 1.00)
			style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
			style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
			style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.64, 1.00)
			style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.70, 0.70, 0.75, 1.00)
			style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.61, 0.61, 0.64, 1.00)
			style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.70, 0.70, 0.75, 1.00)
			style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.30, 0.30, 0.34, 1.00)
			style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.10, 0.10, 0.12, 0.80)
			style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.18, 0.20, 0.22, 1.00)
			style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.60, 0.60, 0.90, 1.00)
			style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.28, 0.56, 0.96, 1.00)
		end
	},
	{
		change = function() -- softorange
			local style = imgui.GetStyle()
			local colors = style.Colors
		

			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
			

			style.Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 0.90, 0.85, 1.00)
			style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.75, 0.60, 0.55, 1.00)
			style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
			style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
			style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.80, 0.35, 0.20, 1.00)
			style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
			style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.45, 0.25, 0.20, 1.00)
			style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.55, 0.35, 0.25, 1.00)
			style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
			style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.20, 0.10, 0.05, 1.00)
			style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
			style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
			style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.25, 0.15, 0.10, 1.00)
			style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.80, 0.35, 0.20, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
			style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
			style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
			style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(1.00, 0.70, 0.55, 1.00)
			style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
			style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
			style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
			style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.45, 0.25, 0.20, 1.00)
			style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.55, 0.30, 0.25, 1.00)
			style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.65, 0.40, 0.30, 1.00)
			style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.80, 0.35, 0.20, 1.00)
			style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
			style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(1.00, 0.65, 0.50, 1.00)
			style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.45, 0.25, 0.20, 1.00)
			style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.55, 0.30, 0.25, 1.00)
			style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.65, 0.40, 0.30, 1.00)
			style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
			style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
			style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
			style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
			style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.55, 0.30, 0.25, 1.00)
			style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.25, 0.15, 0.10, 0.80)
			style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.30, 0.20, 0.15, 1.00)
			style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.90, 0.50, 0.35, 1.00)
			style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(1.00, 0.55, 0.40, 1.00)
		end
	},
	{
		change = function() -- softgrey
			local style = imgui.GetStyle()
			local colors = style.Colors
		

			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
			

			style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.80, 0.80, 0.83, 1.00)
			style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
			style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.16, 0.16, 0.17, 1.00)
			style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.18, 0.18, 0.19, 1.00)
			style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.31, 0.31, 0.35, 1.00)
			style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
			style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.35, 0.35, 0.37, 1.00)
			style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.45, 0.45, 0.47, 1.00)
			style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
			style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
			style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
			style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
			style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
			style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
			style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
			style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.60, 0.60, 0.63, 1.00)
			style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
			style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
			style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
			style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.45, 0.45, 0.47, 1.00)
			style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
			style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
			style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.45, 0.45, 0.48, 1.00)
			style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
			style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
			style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
			style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
			style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
			style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
			style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.65, 0.65, 0.68, 1.00)
			style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.75, 0.75, 0.78, 1.00)
			style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.65, 0.65, 0.68, 1.00)
			style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.75, 0.75, 0.78, 1.00)
			style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
			style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.20, 0.20, 0.22, 0.80)
			style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
			style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
			style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
		end
	},
	{
		change = function() -- softgreen
			local style = imgui.GetStyle()
			local colors = style.Colors
		

			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
			

			style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.85, 0.93, 0.85, 1.00)
			style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.55, 0.65, 0.55, 1.00)
			style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.13, 0.22, 0.13, 1.00)
			style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.15, 0.24, 0.15, 1.00)
			style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
			style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
			style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
			style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
			style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
			style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
			style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.18, 0.28, 0.18, 1.00)
			style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
			style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.15, 0.25, 0.15, 1.00)
			style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.35, 0.45, 0.35, 1.00)
			style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.50, 0.70, 0.50, 1.00)
			style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.50, 0.70, 0.50, 1.00)
			style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.55, 0.75, 0.55, 1.00)
			style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
			style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
			style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
			style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
			style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.28, 0.38, 0.28, 1.00)
			style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
			style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
			style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.30, 0.40, 0.30, 1.00)
			style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.35, 0.45, 0.35, 1.00)
			style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
			style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
			style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
			style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.60, 0.70, 0.60, 1.00)
			style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.65, 0.75, 0.65, 1.00)
			style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.60, 0.70, 0.60, 1.00)
			style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.65, 0.75, 0.65, 1.00)
			style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
			style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.15, 0.25, 0.15, 0.80)
			style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.19, 0.29, 0.19, 1.00)
			style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.23, 0.33, 0.23, 1.00)
			style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.25, 0.35, 0.25, 1.00)
		end
	},
	{
		change = function() -- softred 
			local style = imgui.GetStyle()
			local colors = style.Colors
		

			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
			

			style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.90, 0.85, 0.85, 1.00)
			style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
			style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.15, 0.03, 0.03, 1.00)
			style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.15, 0.03, 0.03, 1.00)
			style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.50, 0.10, 0.10, 1.00)
			style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
			style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.08, 0.08, 1.00)
			style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.30, 0.10, 0.10, 1.00)
			style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.20, 0.05, 0.05, 1.00)
			style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.15, 0.03, 0.03, 1.00)
			style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
			style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.20, 0.05, 0.05, 1.00)
			style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.15, 0.03, 0.03, 1.00)
			style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.50, 0.10, 0.10, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.60, 0.12, 0.12, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.70, 0.15, 0.15, 1.00)
			style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.90, 0.15, 0.15, 1.00)
			style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
			style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
			style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
			style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.80, 0.20, 0.20, 1.00)
			style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
			style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
			style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.80, 0.20, 0.20, 1.00)
			style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
			style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.50, 0.10, 0.10, 1.00)
			style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.60, 0.12, 0.12, 1.00)
			style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.70, 0.15, 0.15, 1.00)
			style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
			style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.80, 0.20, 0.20, 1.00)
			style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
			style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.80, 0.10, 0.10, 1.00)
			style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.90, 0.15, 0.15, 1.00)
			style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.80, 0.10, 0.10, 1.00)
			style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.90, 0.15, 0.15, 1.00)
			style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.90, 0.15, 0.15, 1.00)
			style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.20, 0.05, 0.05, 0.80)
			style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
			style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.80, 0.20, 0.20, 1.00)
			style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
		end
	},
	{
		change = function() -- softblack
			local style = imgui.GetStyle()
			local colors = style.Colors
		

			style.Alpha = 1;
			style.WindowPadding = imgui.ImVec2(8.00, 8.00);
			style.WindowRounding = 0;
			style.WindowBorderSize = 1;
			style.WindowMinSize = imgui.ImVec2(32.00, 32.00);
			style.WindowTitleAlign = imgui.ImVec2(0.50, 0.50);
			style.ChildRounding = 0;
			style.ChildBorderSize = 1;
			style.PopupRounding = 0;
			style.PopupBorderSize = 1;
			style.FramePadding = imgui.ImVec2(4.00, 3.00);
			style.FrameRounding = 0;
			style.FrameBorderSize = 0;
			style.ItemSpacing = imgui.ImVec2(8.00, 4.00);
			style.ItemInnerSpacing = imgui.ImVec2(4.00, 4.00);
			style.IndentSpacing = 21;
			style.ScrollbarSize = 14;
			style.ScrollbarRounding = 9;
			style.GrabMinSize = 10;
			style.GrabRounding = 0;
			style.TabRounding = 4;
			style.ButtonTextAlign = imgui.ImVec2(0.50, 0.50);
			style.SelectableTextAlign = imgui.ImVec2(0.00, 0.00);
			

			style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.90, 0.90, 0.80, 1.00)
			style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.60, 0.50, 0.50, 1.00)
			style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.10, 0.10, 0.10, 1.00)
			style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
			style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
			style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
			style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
			style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.25, 1.00)
			style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)
			style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.10, 0.10, 0.10, 1.00)
			style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
			style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.15, 0.15, 0.15, 1.00)
			style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.10, 0.10, 0.10, 1.00)
			style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
			style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
			style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.66, 0.66, 0.66, 1.00)
			style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.66, 0.66, 0.66, 1.00)
			style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
			style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
			style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
			style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
			style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
			style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
			style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.25, 0.25, 0.25, 1.00)
			style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
			style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
			style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
			style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
			style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.40, 0.40, 0.40, 1.00)
			style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
			style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
			style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.95, 0.95, 0.70, 1.00)
			style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
			style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.95, 0.95, 0.70, 1.00)
			style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.25, 0.25, 0.15, 1.00)
			style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.10, 0.10, 0.10, 0.80)
			style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
			style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
			style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.25, 0.25, 0.25, 1.00)
		end
	}
}
