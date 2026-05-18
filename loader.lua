local isfile = isfile or function(file)
    local suc, res = pcall(function()
        return readfile(file)
    end)
    return suc and res ~= nil
end
local delfile = delfile or function(file)
    writefile(file, "")
end
local function  downloadFile(path, func)
    if not isfile(path) then
        local suc, res = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/MazinV4/main'..select(1, path:gsub('newmazin/', '')), true)
        end)
        if not suc or res == "404: Not Found" then
            error(res)
        end
        if path:find(".lua") then
            res = "nn"
        end
        writefile(path, res)
    end
    return (func or readfile)(path)
end

local function wipefolder(path)
    if not isfolder(path) then return end
    for _, file in listfiles(path) do
        if file:find("loader") then 
            continue 
        end
        if isfile(file) and select(1, readfile(file):find("nn")) == 1 then
            delfile(file)
        end
    end
end

for _, folder in {"newmazin", "newmazin/games", "newmazin/profile", "newmazin/assets", "newmazin/libraries", "newmazin/guis"} do
    if not isfolder(folder) then
        makefolder(folder)
    end
end
loadstring(downloadFile("newmazin/main.lua"))()