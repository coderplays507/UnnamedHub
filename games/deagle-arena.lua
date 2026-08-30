-- Deagle Arena with Key Generator System
-- UnnamedScripts Hub
-- Discord: https://discord.gg/KVPfgF5Wqe

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

-- KEY GENERATOR SYSTEM
local KEY_PREFIX = "UNNAMED"
local SECRET_SALT = "UnnamedScripts2026"

-- Executor functions
local writefile = writefile or function() end
local readfile = readfile
local isfile = isfile or function() return false end
local setclipboard = setclipboard or function() end

-- Notification
local function notify(text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "UnnamedHub",
            Text = text,
            Duration = duration or 5,
        })
    end)
end

-- Simple hash function
local function hashString(str)
    local hash = 0
    for i = 1, #str do
        hash = (hash * 31 + string.byte(str, i)) % 1000000
    end
    return tostring(hash)
end

-- Get HWID
local function getHWID()
    local ok, hwid = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and hwid and #hwid > 4 then
        return hwid
    end
    
    local ok2, hwid2 = pcall(function()
        return gethwid and gethwid()
    end)
    if ok2 and hwid2 and #hwid2 > 4 then
        return hwid2
    end
    
    return "HWID-" .. game.PlaceId .. "-" .. LocalPlayer.UserId
end

-- Generate key based on HWID
local function generateKey(hwid)
    local hwidHash = hashString(hwid .. SECRET_SALT)
    local randomPart = math.random(1000, 9999)
    local key = string.format("%s-%s-%s", KEY_PREFIX, hwidHash, randomPart)
    return key
end

-- Validate key
local function validateKey(key, hwid)
    local hwidHash = hashString(hwid .. SECRET_SALT)
    local parts = {}
    for part in string.gmatch(key, "[^-]+") do
        table.insert(parts, part)
    end
    
    if #parts >= 3 then
        if parts[1] == KEY_PREFIX and parts[2] == hwidHash then
            return true
        end
    end
    return false
end

-- Save and load key
local KEY_FILE = "UnnamedHub-key.txt"

local function saveKey(key)
    pcall(writefile, KEY_FILE, key)
end

local function loadKey()
    if isfile and readfile and isfile(KEY_FILE) then
        local ok, key = pcall(readfile, KEY_FILE)
        if ok and key then
            return string.gsub(key, "%s", "")
        end
    end
    return nil
end

-- Key GUI
local function showKeyGUI()
    local currentHWID = getHWID()
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeyGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 350, 0, 300)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "🔑 UnnamedHub Key System"
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 16
    Title.Parent = Frame
    
    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -20, 0, 25)
    Info.Position = UDim2.new(0, 10, 0, 40)
    Info.BackgroundTransparency = 1
    Info.TextColor3 = Color3.fromRGB(255, 255, 255)
    Info.Text = "Your HWID:"
    Info.Font = Enum.Font.SourceSans
    Info.TextSize = 13
    Info.Parent = Frame
    
    local HWIDBox = Instance.new("TextBox")
    HWIDBox.Size = UDim2.new(1, -20, 0, 30)
    HWIDBox.Position = UDim2.new(0, 10, 0, 65)
    HWIDBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    HWIDBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    HWIDBox.Text = currentHWID
    HWIDBox.Font = Enum.Font.SourceSans
    HWIDBox.TextSize = 10
    HWIDBox.ClearTextOnFocus = false
    HWIDBox.Parent = Frame
    
    local CopyHWIDBtn = Instance.new("TextButton")
    CopyHWIDBtn.Size = UDim2.new(1, -20, 0, 30)
    CopyHWIDBtn.Position = UDim2.new(0, 10, 0, 100)
    CopyHWIDBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CopyHWIDBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyHWIDBtn.Text = "📋 Copy HWID"
    CopyHWIDBtn.Font = Enum.Font.SourceSansBold
    CopyHWIDBtn.TextSize = 13
    CopyHWIDBtn.Parent = Frame
    
    CopyHWIDBtn.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(currentHWID)
        end)
        notify("HWID copied!", 3)
    end)
    
    local GenerateBtn = Instance.new("TextButton")
    GenerateBtn.Size = UDim2.new(1, -20, 0, 35)
    GenerateBtn.Position = UDim2.new(0, 10, 0, 135)
    GenerateBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    GenerateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GenerateBtn.Text = "🎲 GENERATE KEY"
    GenerateBtn.Font = Enum.Font.SourceSansBold
    GenerateBtn.TextSize = 14
    GenerateBtn.Parent = Frame
    
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -20, 0, 30)
    KeyBox.Position = UDim2.new(0, 10, 0, 175)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    KeyBox.TextColor3 = Color3.fromRGB(100, 255, 100)
    KeyBox.PlaceholderText = "Your key will appear here..."
    KeyBox.Font = Enum.Font.SourceSans
    KeyBox.TextSize = 12
    KeyBox.Parent = Frame
    
    GenerateBtn.MouseButton1Click:Connect(function()
        local generatedKey = generateKey(currentHWID)
        KeyBox.Text = generatedKey
        saveKey(generatedKey)
        notify("✅ Key generated and saved!", 5)
    end)
    
    local CopyKeyBtn = Instance.new("TextButton")
    CopyKeyBtn.Size = UDim2.new(1, -20, 0, 30)
    CopyKeyBtn.Position = UDim2.new(0, 10, 0, 210)
    CopyKeyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CopyKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyKeyBtn.Text = "📋 Copy Key"
    CopyKeyBtn.Font = Enum.Font.SourceSansBold
    CopyKeyBtn.TextSize = 13
    CopyKeyBtn.Parent = Frame
    
    CopyKeyBtn.MouseButton1Click:Connect(function()
        if KeyBox.Text ~= "" then
            pcall(function()
                setclipboard(KeyBox.Text)
            end)
            notify("Key copied!", 3)
        else
            notify("Generate a key first!", 3)
        end
    end)
    
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(1, -20, 0, 35)
    VerifyBtn.Position = UDim2.new(0, 10, 0, 245)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Text = "✅ VERIFY & LOAD"
    VerifyBtn.Font = Enum.Font.SourceSansBold
    VerifyBtn.TextSize = 14
    VerifyBtn.Parent = Frame
    
    VerifyBtn.MouseButton1Click:Connect(function()
        local key = KeyBox.Text
        if validateKey(key, currentHWID) then
            saveKey(key)
            notify("✅ Key verified! Loading...", 5)
            wait(1)
            ScreenGui:Destroy()
            loadMainScript()
        else
            notify("❌ Invalid key! Generate a new one.", 5)
        end
    end)
end

-- Main Script
local function loadMainScript()
    notify("✅ Deagle Arena Script Loaded!", 5)
    print("[UnnamedHub] Loading main script...")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UnnamedHubGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 280, 0, 300)
    Frame.Position = UDim2.new(0.5, -140, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "Deagle Arena"
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 16
    Title.Parent = Frame
    
    -- Variables
    local aimbotEnabled = false
    local espEnabled = false
    local noRecoilEnabled = false
    local speedHackEnabled = false
    local flyEnabled = false
    local flySpeed = 50
    local flyKeys = {forward = false, backward = false, left = false, right = false, up = false, down = false}
    
    -- Aimbot
    local function getClosestPlayer()
        local closest = nil
        local shortest = math.huge
        local camera = workspace.CurrentCamera
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                
                if head and humanoid and humanoid.Health > 0 then
                    local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                        if distance < shortest then
                            shortest = distance
                            closest = player
                        end
                    end
                end
            end
        end
        
        return closest
    end
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if aimbotEnabled then
            pcall(function()
                local target = getClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    local camera = workspace.CurrentCamera
                    camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
                end
            end)
        end
    end)
    
    -- ESP
    local function toggleESP()
        if espEnabled then
            spawn(function()
                while espEnabled do
                    pcall(function()
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local highlight = player.Character:FindFirstChild("ESP_Highlight")
                                if not highlight then
                                    highlight = Instance.new("Highlight")
                                    highlight.Name = "ESP_Highlight"
                                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    highlight.FillTransparency = 0.5
                                    highlight.Parent = player.Character
                                end
                            end
                        end
                    end)
                    wait(1)
                end
            end)
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("ESP_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end
    
    -- No Recoil
    local function toggleNoRecoil()
        spawn(function()
            while noRecoilEnabled do
                pcall(function()
                    if LocalPlayer.Character then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then
                            for _, child in ipairs(tool:GetDescendants()) do
                                if child.Name == "Recoil" or child.Name == "recoil" then
                                    if child:IsA("NumberValue") then
                                        child.Value = 0
                                    elseif child:IsA("Vector3Value") then
                                        child.Value = Vector3.new(0, 0, 0)
                                    end
                                end
                            end
                        end
                    end
                end)
                wait(0.05)
            end
        end)
    end
    
    -- Speed Hack
    local function toggleSpeedHack()
        spawn(function()
            while speedHackEnabled do
                pcall(function()
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = 50
                    end
                end)
                wait(0.1)
            end
        end)
        
        if not speedHackEnabled then
            pcall(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end)
        end
    end
    
    -- Fly
    local function toggleFly()
        if flyEnabled then
            spawn(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = true
                end
                
                while flyEnabled do
                    pcall(function()
                        local character = LocalPlayer.Character
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                        
                        if rootPart and humanoid then
                            local direction = Vector3.new(0, 0, 0)
                            
                            if flyKeys.forward then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
                            if flyKeys.backward then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
                            if flyKeys.left then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
                            if flyKeys.right then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
                            if flyKeys.up then direction = direction + Vector3.new(0, 1, 0) end
                            if flyKeys.down then direction = direction - Vector3.new(0, 1, 0) end
                            
                            if direction.Magnitude > 0 then
                                rootPart.Velocity = direction.Unit * flySpeed
                            else
                                rootPart.Velocity = Vector3.new(0, 0, 0)
                            end
                        end
                    end)
                    wait()
                end
                
                pcall(function()
                    if humanoid then
                        humanoid.PlatformStand = false
                    end
                end)
            end)
        end
    end
    
    -- Buttons
    local function createButton(name, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 35)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = name
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
        btn.Parent = Frame
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    local function createToggle(name, yPos, toggleFunc)
        local btn = createButton(name .. ": OFF", yPos, function()
            local enabled = not btn.Text:find("ON")
            btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
            btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(50, 50, 50)
            toggleFunc(enabled)
            notify(name .. " " .. (enabled and "Enabled" or "Disabled"), 2)
            return enabled
        end)
        return btn
    end
    
    createToggle("Aimbot", 40, function(enabled) aimbotEnabled = enabled end)
    createToggle("ESP", 78, function(enabled) espEnabled = enabled; toggleESP() end)
    createToggle("No Recoil", 116, function(enabled) noRecoilEnabled = enabled; if enabled then toggleNoRecoil() end end)
    createToggle("Speed Hack", 154, function(enabled) speedHackEnabled = enabled; toggleSpeedHack() end)
    createToggle("Fly", 192, function(enabled) flyEnabled = enabled; toggleFly() end)
    
    createButton("Close", 230, function()
        aimbotEnabled = false
        espEnabled = false
        noRecoilEnabled = false
        speedHackEnabled = false
        flyEnabled = false
        ScreenGui:Destroy()
    end)
    
    -- Fly controls
    local UserInputService = game:GetService("UserInputService")
    UserInputService.InputBegan:Connect(function(input)
        if not flyEnabled then return end
        if input.KeyCode == Enum.KeyCode.W then flyKeys.forward = true end
        if input.KeyCode == Enum.KeyCode.S then flyKeys.backward = true end
        if input.KeyCode == Enum.KeyCode.A then flyKeys.left = true end
        if input.KeyCode == Enum.KeyCode.D then flyKeys.right = true end
        if input.KeyCode == Enum.KeyCode.Space then flyKeys.up = true end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.down = true end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then flyKeys.forward = false end
        if input.KeyCode == Enum.KeyCode.S then flyKeys.backward = false end
        if input.KeyCode == Enum.KeyCode.A then flyKeys.left = false end
        if input.KeyCode == Enum.KeyCode.D then flyKeys.right = false end
        if input.KeyCode == Enum.KeyCode.Space then flyKeys.up = false end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.down = false end
    end)
end

-- Check for saved key
local savedKey = loadKey()
local currentHWID = getHWID()

if savedKey and validateKey(savedKey, currentHWID) then
    notify("✅ Key verified!", 3)
    loadMainScript()
else
    showKeyGUI()
end
