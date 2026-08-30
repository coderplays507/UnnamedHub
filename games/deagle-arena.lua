-- Deagle Arena Script - Fixed Toggles
-- UnnamedScripts Hub

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Cam = workspace.CurrentCamera

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

notify("✅ Script Loaded!", 3)

-- Create Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UnnamedHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 320)
Frame.Position = UDim2.new(0.5, -125, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Deagle Arena"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 25)
MinimizeBtn.Position = UDim2.new(0.7, 0, 0, 2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 0, 290)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.BackgroundTransparency = 1
Content.Parent = Frame

-- Feature Variables (Global for easy access)
local features = {
    aimbot = false,
    esp = false,
    noRecoil = false,
    speedHack = false,
    fly = false,
}

local flySpeed = 50
local flyKeys = {forward = false, backward = false, left = false, right = false, up = false, down = false}
local isMinimized = false
local fov = 100

-- FOV Aimbot
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(128, 0, 128)
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

local function updateDrawings()
    FOVring.Position = Cam.ViewportSize / 2
end

local function lookAt(pos)
    local lookVector = (pos - Cam.CFrame.Position).Unit
    Cam.CFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
end

local function getTorso(character)
    return character:FindFirstChild("Head")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("HumanoidRootPart")
end

local function isVisible(part)
    local origin = Cam.CFrame.Position
    local direction = part.Position - origin
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}

    local result = workspace:Raycast(origin, direction, rayParams)
    return not result or result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestEnemyInFOV()
    local closestPlayer = nil
    local closestDistance = math.huge
    local screenCenter = Cam.ViewportSize / 2

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local torso = getTorso(char)
                if torso then
                    local screenPos, visible = Cam:WorldToViewportPoint(torso.Position)
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

                    if visible and distance < fov and distance < closestDistance and isVisible(torso) then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Aimbot Loop (Always running, checks feature state)
RunService:BindToRenderStep("FOVUpdate", Enum.RenderPriority.Camera.Value + 1, function()
    updateDrawings()
    if features.aimbot then
        local target = getClosestEnemyInFOV()
        if target and target.Character then
            local torso = getTorso(target.Character)
            if torso then
                lookAt(torso.Position)
            end
        end
    end
end)

-- ESP System (Runs in loop, checks feature state)
spawn(function()
    while true do
        if features.esp then
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
        else
            -- Remove all ESP
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("ESP_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
        wait(1)
    end
end)

-- No Recoil (Runs in loop, checks feature state)
spawn(function()
    while true do
        if features.noRecoil then
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
        end
        wait(0.1)
    end
end)

-- Speed Hack (Runs in loop, checks feature state)
spawn(function()
    while true do
        if features.speedHack then
            pcall(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 50
                end
            end)
        else
            pcall(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end)
        end
        wait(0.5)
    end
end)

-- Fly (Runs in loop, checks feature state)
spawn(function()
    while true do
        if features.fly then
            pcall(function()
                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                if humanoid then
                    humanoid.PlatformStand = true
                end
                
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
        else
            pcall(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end)
        end
        wait()
    end
end)

-- CREATE BUTTONS (Fixed toggle system)
local function createToggle(name, yPos, featureName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. ": OFF"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = Content
    
    btn.MouseButton1Click:Connect(function()
        features[featureName] = not features[featureName]
        
        if features[featureName] then
            btn.Text = name .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
            notify(name .. " Enabled!", 2)
        else
            btn.Text = name .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            notify(name .. " Disabled!", 2)
        end
        
        -- Special handling for FOV circle
        if featureName == "aimbot" then
            FOVring.Visible = features.aimbot
        end
        
        print("[UnnamedHub] " .. name .. " is now " .. (features[featureName] and "ON" or "OFF"))
    end)
    
    return btn
end

-- Create all toggle buttons
createToggle("FOV Aimbot", 5, "aimbot")
createToggle("ESP", 42, "esp")
createToggle("No Recoil", 79, "noRecoil")
createToggle("Speed Hack", 116, "speedHack")
createToggle("Fly", 153, "fly")

-- Kill Button
local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(1, -20, 0, 35)
KillBtn.Position = UDim2.new(0, 10, 0, 190)
KillBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.Text = "💀 KILL"
KillBtn.Font = Enum.Font.SourceSansBold
KillBtn.TextSize = 13
KillBtn.Parent = Content

KillBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end)
    notify("💀 Killed!", 3)
end)

-- Minimize
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Content.Visible = false
        Frame.Size = UDim2.new(0, 250, 0, 30)
    else
        Content.Visible = true
        Frame.Size = UDim2.new(0, 250, 0, 320)
    end
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    -- Turn off all features
    features.aimbot = false
    features.esp = false
    features.noRecoil = false
    features.speedHack = false
    features.fly = false
    FOVring.Visible = false
    
    -- Reset speed
    pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.PlatformStand = false
        end
    end)
    
    ScreenGui:Destroy()
    notify("Script closed!", 3)
end)

-- Fly Controls
UserInputService.InputBegan:Connect(function(input)
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

print("[UnnamedHub] Script loaded successfully!")
print("[UnnamedHub] Features ready: aimbot, esp, noRecoil, speedHack, fly")
