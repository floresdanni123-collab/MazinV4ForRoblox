repeat task.wait() until game:IsLoaded()
if shared.mazin then shared.mazin:Uninject() end

if identifyexecutor and ({identifyexecutor()})[1] == 'Argon' then
	getgenv().setthreadidentity = nil
end

local mazin
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and mazin then
		mazin:CreateNotification('Katware', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local queue_on_teleport = queue_on_teleport or function() end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local cloneref = cloneref or function(obj)
	return obj
end
local playersService = cloneref(game:GetService('Players'))

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/MazinV4'..select(1, path:gsub('newmazin/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after mazin updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function finishLoading()
	mazin.Init = nil
	mazin:Load()
	task.spawn(function()
		repeat
			mazin:Save()
			task.wait(10)
		until not mazin.Loaded
	end)

	local teleportedServers
	mazin:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
		if (not teleportedServers) and (not shared.MazinIndependent) then
			teleportedServers = true
			local teleportScript = [[
				shared.mazinreload = true
				if shared.MazinDeveloper then
					loadstring(readfile('newmazin/loader.lua'), 'loader')()
				else
					loadstring(game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/MazinV4'..'/loader.lua', true), 'loader')()
				end
			]]
			if shared.MazinDeveloper then
				teleportScript = 'shared.MazinDeveloper = true\n'..teleportScript
			end
			if shared.MazinCustomProfile then
				teleportScript = 'shared.MazinCustomProfile = "'..shared.MazinCustomProfile..'"\n'..teleportScript
			end
			mazin:Save()
			queue_on_teleport(teleportScript)
		end
	end))

	if not shared.mazinreload then
		if not mazin.Categories then return end
		if mazin.Categories.Main.Options['GUI bind indicator'].Enabled then
			mazin:CreateNotification('Finished Loading', mazin.MazinButton and 'Press the button in the top right to open GUI' or 'Press '..table.concat(mazin.Keybind, ' + '):upper()..' to open GUI', 5)
		end
	end
end

if not isfile('newmazin/profiles/gui.txt') then
	writefile('newmazin/profiles/gui.txt', 'new')
end
local gui = readfile('newmazin/profiles/gui.txt')

if not isfolder('newmazin/assets/'..gui) then
	makefolder('newmazin/assets/'..gui)
end
mazin = loadstring(downloadFile('newmazin/guis/'..gui..'.lua'), 'gui')()
shared.mazin = mazin

if not shared.MazinIndependent then
	loadstring(downloadFile('newmazin/games/universal.lua'), 'universal')()
	if isfile('newmazin/games/'..game.PlaceId..'.lua') then
		loadstring(readfile('newmazin/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
	else
		if not shared.MazinDeveloper then
			local suc, res = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/MazinV4'..'/games/'..game.PlaceId..'.lua', true)
			end)
			if suc and res ~= '404: Not Found' then
				loadstring(downloadFile('newmazin/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
			end
		end
	end
	finishLoading()
else
	mazin.Init = finishLoading
	return mazin
end
