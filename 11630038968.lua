local mazin = shared.mazin
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and mazin then 
		mazin:CreateNotification('Mazin', 'Failed to load : '..err, 30, 'alert') 
	end
	return res
end
local isfile = isfile or function(file)
	local suc, res = pcall(function() 
		return readfile(file) 
	end)
	return suc and res ~= nil and res ~= ''
end
local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function() 
			return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/MazinV4ForRoblox/'..readfile('newmazin/profiles/commit.txt')..'/'..select(1, path:gsub('newmazin/', '')), true) 
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

mazin.Place = 8768229691
if isfile('newmazin/games/'..mazin.Place..'.lua') then
	loadstring(readfile('newmazin/games/'..mazin.Place..'.lua'), 'skywars')()
else
	if not shared.MazinDeveloper then
		local suc, res = pcall(function() 
			return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/MazinV4ForRoblox/'..readfile('newmazin/profiles/commit.txt')..'/games/'..mazin.Place..'.lua', true) 
		end)
		if suc and res ~= '404: Not Found' then
			loadstring(downloadFile('newmazin/games/'..mazin.Place..'.lua'), 'skywars')()
		end
	end
end