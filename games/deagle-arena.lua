-- Deagle Arena Advanced Script
-- UnnamedScripts Hub
print("[UnnamedHub] Advanced Deagle Arena loaded!")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Notification
local function notify(text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "UnnamedHub",
            Text = text,
            Duration = duration or 3,
        })
    end)
end

notify("Advanced Script Loaded!", 5)

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UnnamedHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 400)
Frame.Position = UDim2.new(0.5, -140, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Deagle Arena - Advanced"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = Frame

-- Variables
local aimbotEnabled = false
local silentAimEnabled = false
local espEnabled = false
local triggerBotEnabled = false
local noRecoilEnabled = false
local rapidFireEnabled = false
local speedHackEnabled = false
local flyEnabled = false
local teleportEnabled = false

-- Speed values
local normalSpeed = 16
local hackedSpeed = 50

-- Fly variables
local flySpeed = 50
local flyKeys = {
    forward = false,
    backward = false,
    left = false,
    right = false,
    up = false,
    down = false
}

-- Aimbot Functions
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

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and not silentAimEnabled then
        pcall(function()
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local camera = workspace.CurrentCamera
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
            end
        end)
    end
end)

-- Silent Aim (requires remote access)
local function silentAim()
    spawn(function()
        while silentAimEnabled do
            pcall(function()
                local target = getClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        -- Try to find and fire remote
                        for _, remote in ipairs(tool:GetDescendants()) do
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer(target.Character.Head.Position)
                            end
                        end
                    end
                end
            end)
            wait(0.1)
        end
    end)
end

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
                                highlight.OutlineTransparency = 0
                                highlight.Parent = player.Character
                            end
                            
                            -- Also add name tag
                            local head = player.Character:FindFirstChild("Head")
                            if head and not head:FindFirstChild("ESP_Name") then
                                local billboard = Instance.new("BillboardGui")
                                billboard.Name = "ESP_Name"
                                billboard.Size = UDim2.new(0, 100, 0, 30)
                                billboard.StudsOffset = Vector3.new(0, 2, 0)
                                billboard.AlwaysOnTop = true
                                billboard.Parent = head
                                
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                                label.Text = player.Name
                                label.Font = Enum.Font.SourceSansBold
                                label.TextSize = 14
                                label.Parent = billboard
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
                
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local nameTag = head:FindFirstChild("ESP_Name")
                    if nameTag then nameTag:Destroy() end
                end
            end
        end
    end
end

-- Trigger Bot
local function triggerBot()
    spawn(function()
        while triggerBotEnabled do
            pcall(function()
                local target = getClosestPlayer()
                if target then
                    local camera = workspace.CurrentCamera
                    local mouse = LocalPlayer:GetMouse()
                    
                    -- Check if aiming at target
                    local ray = Ray.new(camera.CFrame.Position, (target.Character.Head.Position - camera.CFrame.Position).unit * 1000)
                    local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                    
                    if hit and hit:IsDescendantOf(target.Character) then
                        -- Auto click
                        mouse1click()
                    end
                end
            end)
            wait(0.05)
        end
    end)
end

-- No Recoil
local function toggleNoRecoil()
    spawn(function()
        while noRecoilEnabled do
            pcall(function()
                if LocalPlayer.Character then
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        -- Reduce recoil
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

-- Rapid Fire
local function rapidFire()
    spawn(function()
        while rapidFireEnabled do
            pcall(function()
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Try to fire rapidly
                    tool:Activate()
                    wait(0.05)
                    tool:Deactivate()
                end
            end)
            wait(0.1)
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
                    humanoid.WalkSpeed = hackedSpeed
                end
            end)
            wait(0.1)
        end
    end)
    
    -- Reset speed when disabled
    if not speedHackEnabled then
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = normalSpeed
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
            
            -- Reset when disabled
            pcall(function()
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end)
        end)
    end
end

-- Teleport to Player
local function teleportToNearest()
    local target = getClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            notify("Teleported to " .. target.Name, 3)
        end
    end
end

-- UI Functions
local function createButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.AutoButtonColor = true
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

-- Create all buttons
local aimbotBtn = createToggle("Aimbot", 40, function(enabled) aimbotEnabled = enabled end)
local silentAimBtn = createToggle("Silent Aim", 78, function(enabled) silentAimEnabled = enabled; if enabled then silentAim() end end)
local espBtn = createToggle("ESP", 116, function(enabled) espEnabled = enabled; toggleESP() end)
local triggerBtn = createToggle("Trigger Bot", 154, function(enabled) triggerBotEnabled = enabled; if enabled then triggerBot() end end)
local recoilBtn = createToggle("No Recoil", 192, function(enabled) noRecoilEnabled = enabled; if enabled then toggleNoRecoil() end end)
local rapidBtn = createToggle("Rapid Fire", 230, function(enabled) rapidFireEnabled = enabled; if enabled then rapidFire() end end)
local speedBtn = createToggle("Speed Hack", 268, function(enabled) speedHackEnabled = enabled; toggleSpeedHack() end)
local flyBtn = createToggle("Fly", 306, function(enabled) flyEnabled = enabled; toggleFly() end)

-- Teleport Button
createButton("Teleport to Nearest", 344, function()
    teleportToNearest()
end)

-- Close Button
createButton("Close", 382, function()
    aimbotEnabled = false
    silentAimEnabled = false
    espEnabled = false
    triggerBotEnabled = false
    noRecoilEnabled = false
    rapidFireEnabled = false
    speedHackEnabled = false
    flyEnabled = false
    
    pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = normalSpeed
            humanoid.PlatformStand = false
        end
    end)
    
    ScreenGui:Destroy()
end)

-- Fly Controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
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

-- Mobile Support
if _G.__UNNAMED and _G.__UNNAMED.isMobile then
    Frame.Size = UDim2.new(0, 300, 0, 450)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -225)
end

print("[UnnamedHub] Advanced script fully loaded!")
notify("All features ready!", 5)
