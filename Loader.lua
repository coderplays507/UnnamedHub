-- UnnamedScripts Hub
-- By: YouTube:@UnnamedScripts
-- Discord: https://discord.gg/KVPfgF5Wqe

local BASE = "https://raw.githubusercontent.com/coderplays507/UnnamedHub/main/"
local CACHE = "UnnamedHub/"
local VERSION = "1.0.0"
local DISCORD_INVITE = "https://discord.gg/KVPfgF5Wqe"
local DISCORD_KEY = "UNNAMED-ACCESS-2024"

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

-- Mobile detection
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Executor functions with fallbacks
local writefile = writefile or function() end
local readfile = readfile
local isfile = isfile or function() return false end
local makefolder = makefolder or function() end

-- Notification function
local function notify(text, duration)
    print("[UnnamedHub] " .. text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "UnnamedHub",
            Text = text,
            Duration = duration or 4,
        })
    end)
end

-- HTTP Get function
local function httpGet(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" and #body > 0 then return body end
    return nil
end

-- Fetch with cache
local function fetch(path)
    if not isfolder or not isfolder(CACHE) then
        if makefolder then makefolder(CACHE) end
    end
    local cached = CACHE .. path:gsub("/", "_")
    local body = httpGet(BASE .. path .. "?t=" .. tostring(os.time()))
    if body then
        pcall(writefile, cached, body)
        return body, "net"
    end
    if isfile and isfile(cached) and readfile then
        local ok, disk = pcall(readfile, cached)
        if ok and disk and #disk > 0 then return disk, "cache" end
    end
    return nil
end

-- Wait for game to load
if not game:IsLoaded() then game.Loaded:Wait() end

-- DISCORD VERIFICATION
local VERIFY_FILE = "UnnamedHub-verified.txt"

local function isVerified()
    if not isfile or not readfile then return true end
    local ok, content = pcall(function()
        if isfile(VERIFY_FILE) then return readfile(VERIFY_FILE) end
        return nil
    end)
    if ok and content then
        return string.find(content, "verified") ~= nil
    end
    return false
end

local function setVerified()
    pcall(writefile, VERIFY_FILE, "verified")
end

-- Check verification
if not isVerified() then
    notify("Join Discord: " .. DISCORD_INVITE, 10)
    print("[UnnamedHub] Discord: " .. DISCORD_INVITE)
    print("[UnnamedHub] Key: " .. DISCORD_KEY)
end

-- Load registry
local indexBody, indexFrom = fetch("index.json")
if not indexBody then
    notify("Cannot load index.json", 8)
    return
end

local ok, INDEX = pcall(function() return HttpService:JSONDecode(indexBody) end)
if not ok or type(INDEX) ~= "table" then
    notify("Invalid index.json", 8)
    return
end

-- Find game script
local function findGame()
    for _, entry in ipairs(INDEX.games) do
        if entry.places then
            for _, id in ipairs(entry.places) do
                if tonumber(id) == game.PlaceId then
                    return entry
                end
            end
        end
        if entry.detect and entry.detect ~= "" then
            local ok, func = pcall(loadstring("return function() " .. entry.detect .. " end"))
            if ok and type(func) == "function" then
                local ok2, result = pcall(func)
                if ok2 and result == true then
                    return entry
                end
            end
        end
    end
    return nil
end

-- Load game script
local function loadGame(entry)
    if not entry then
        notify("No script for this game: " .. game.PlaceId, 8)
        return
    end
    
    notify("Loading: " .. entry.name, 3)
    
    local body = fetch(entry.file)
    if not body then
        notify("Failed to load: " .. entry.name, 8)
        return
    end
    
    local chunk, err = loadstring(body)
    if not chunk then
        notify("Syntax error in " .. entry.name, 8)
        return
    end
    
    _G.__UNNAMED = {
        hubVersion = VERSION,
        game = entry,
        index = INDEX,
        discord = DISCORD_INVITE,
        isMobile = IS_MOBILE,
    }
    
    local ok, runErr = pcall(chunk)
    if not ok then
        notify("Script error: " .. tostring(runErr), 8)
        warn("[UnnamedHub] " .. tostring(runErr))
    end
end

-- Console UI
local function showGameList()
    print("[UnnamedHub] Available games:")
    for _, entry in ipairs(INDEX.games) do
        print("  - " .. entry.name .. " (" .. entry.alias .. ")")
    end
end

-- Main
print("[UnnamedHub] Loaded v" .. VERSION)
print("[UnnamedHub] By YouTube:@UnnamedScripts")

-- Background update check
spawn(function()
    while wait(300) do
        pcall(function()
            local versionData = httpGet(BASE .. "version.json?t=" .. tostring(os.time()))
            if versionData then
                local ok2, data = pcall(function() return HttpService:JSONDecode(versionData) end)
                if ok2 and data and data.version and data.version ~= VERSION then
                    notify("Update available: v" .. data.version .. "!", 6)
                    if data.announcement then
                        notify(data.announcement, 8)
                    end
                end
            end
        end)
    end
end)

-- Find and load game
local game = findGame()
if game then
    loadGame(game)
else
    notify("No script found for this game", 6)
    showGameList()
end
