-- UnnamedScripts Hub - Improved Loader
-- By: YouTube:@UnnamedScripts
-- Discord: https://discord.gg/KVPfgF5Wqe

local BASE = "https://raw.githubusercontent.com/coderplays507/UnnamedHub/refs/heads/main/"
local VERSION = "1.0.0"
local DISCORD_INVITE = "https://discord.gg/KVPfgF5Wqe"

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Mobile detection
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Executor functions with fallbacks
local writefile = writefile or function() end
local readfile = readfile
local isfile = isfile or function() return false end
local makefolder = makefolder or function() end
local delfile = delfile or function() end

-- Notification
local function notify(title, text, duration)
    print("[UnnamedHub] " .. text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "UnnamedHub",
            Text = text,
            Duration = duration or 4,
        })
    end)
end

-- HTTP Get with retry
local function httpGet(url, retries)
    retries = retries or 2
    for attempt = 1, retries do
        local ok, body = pcall(function() 
            return game:HttpGet(url) 
        end)
        if ok and type(body) == "string" and #body > 0 then 
            return body 
        end
        
        -- Try request function
        local req = (syn and syn.request) or request or http_request
        if req then
            local ok2, res = pcall(req, {Url = url, Method = "GET"})
            if ok2 and type(res) == "table" and res.StatusCode == 200 and res.Body then
                return res.Body
            end
        end
        
        if attempt < retries then wait(1) end
    end
    return nil
end

-- Fetch with cache
local function fetch(path, useCache)
    useCache = useCache ~= false
    local cached = "UnnamedHub/" .. path:gsub("/", "_")
    
    local body = httpGet(BASE .. path .. "?t=" .. tostring(os.time()))
    if body then
        pcall(function()
            if not isfolder("UnnamedHub") then makefolder("UnnamedHub") end
            writefile(cached, body)
        end)
        return body, "net"
    end
    
    if useCache and isfile and isfile(cached) and readfile then
        local ok, disk = pcall(readfile, cached)
        if ok and disk and #disk > 0 then 
            return disk, "cache" 
        end
    end
    
    return nil, "fail"
end

-- Wait for game to load
if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

-- Welcome notification
notify("UnnamedHub", "Loader activated!", 3)

-- Load registry
local indexBody = httpGet(BASE .. "index.json")
if not indexBody then
    notify("UnnamedHub", "Cannot connect to server! Check internet.", 8)
    return
end

local ok, INDEX = pcall(function() 
    return HttpService:JSONDecode(indexBody) 
end)
if not ok or type(INDEX) ~= "table" then
    notify("UnnamedHub", "Invalid registry!", 8)
    return
end

-- Find game
local function findGame()
    -- Check by Place ID
    for _, entry in ipairs(INDEX.games or {}) do
        if entry.places then
            for _, id in ipairs(entry.places) do
                if tonumber(id) == game.PlaceId then
                    return entry, "place"
                end
            end
        end
    end
    
    -- Check by detect function
    for _, entry in ipairs(INDEX.games or {}) do
        if entry.detect and entry.detect ~= "" then
            local ok, func = pcall(loadstring("return function() " .. entry.detect .. " end"))
            if ok and type(func) == "function" then
                local ok2, result = pcall(func)
                if ok2 and result == true then
                    return entry, "detect"
                end
            end
        end
    end
    
    return nil, "none"
end

-- Load game script
local function loadGame(entry, why)
    if not entry then return false end
    
    notify("UnnamedHub", "Loading: " .. entry.name .. "...", 3)
    
    local body, source = fetch(entry.file)
    if not body then
        notify("UnnamedHub", "Failed to load: " .. entry.name, 8)
        return false
    end
    
    local chunk, err = loadstring(body)
    if not chunk then
        notify("UnnamedHub", "Script error: " .. tostring(err), 8)
        return false
    end
    
    -- Set global
    _G.__UNNAMED = {
        version = VERSION,
        game = entry,
        index = INDEX,
        discord = DISCORD_INVITE,
        isMobile = IS_MOBILE,
        source = source,
    }
    
    -- Run script
    local ok, runErr = pcall(chunk)
    if not ok then
        notify("UnnamedHub", "Crash: " .. tostring(runErr), 8)
        warn("[UnnamedHub] " .. tostring(runErr))
        return false
    end
    
    notify("UnnamedHub", entry.name .. " loaded! (" .. source .. ")", 3)
    return true
end

-- Show game list if no match
local function showGameList()
    print("[UnnamedHub] Available games:")
    for _, entry in ipairs(INDEX.games or {}) do
        print("  - " .. entry.name .. " (" .. entry.alias .. ")")
    end
    
    -- Simple GUI for game selection
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UnnamedHubPicker"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 200 + (#INDEX.games * 35))
    Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "Select Script"
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 16
    Title.Parent = Frame
    
    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -20, 0, 25)
    Info.Position = UDim2.new(0, 10, 0, 40)
    Info.BackgroundTransparency = 1
    Info.TextColor3 = Color3.fromRGB(255, 255, 255)
    Info.Text = "No script found for this game. Select manually:"
    Info.Font = Enum.Font.SourceSans
    Info.TextSize = 12
    Info.Parent = Frame
    
    local yPos = 70
    for _, entry in ipairs(INDEX.games or {}) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = entry.name
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 13
        btn.Parent = Frame
        
        btn.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
            loadGame(entry, "manual")
        end)
        
        yPos = yPos + 35
    end
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(1, -20, 0, 30)
    CloseBtn.Position = UDim2.new(0, 10, 0, yPos + 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Text = "Close"
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.TextSize = 13
    CloseBtn.Parent = Frame
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
end

-- Background update check
spawn(function()
    while wait(300) do -- Every 5 minutes
        pcall(function()
            local versionData = httpGet(BASE .. "version.json")
            if versionData then
                local ok2, data = pcall(function() 
                    return HttpService:JSONDecode(versionData) 
                end)
                if ok2 and data and data.version and data.version ~= VERSION then
                    notify("UnnamedHub", "Update available: v" .. data.version, 6)
                end
            end
        end)
    end
end)

-- Main execution
local gameEntry, why = findGame()

if gameEntry then
    loadGame(gameEntry, why)
else
    notify("UnnamedHub", "No script for this game", 5)
    showGameList()
end

-- Console API
_G.__UNNAMED = _G.__UNNAMED or {}
_G.__UNNAMED.load = function(alias)
    for _, entry in ipairs(INDEX.games or {}) do
        if entry.alias:lower() == alias:lower() then
            loadGame(entry, "console")
            return true
        end
    end
    notify("UnnamedHub", "Game not found: " .. alias, 5)
    return false
end
_G.__UNNAMED.list = function()
    for _, entry in ipairs(INDEX.games or {}) do
        print(string.format("  %-14s %s", entry.alias, entry.name))
    end
end
_G.__UNNAMED.reload = function()
    local src = httpGet(BASE .. "Loader.lua")
    if src then
        local chunk = loadstring(src)
        if chunk then chunk() end
    end
end
