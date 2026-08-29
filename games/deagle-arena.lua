-- Deagle Arena Script
-- UnnamedScripts Hub

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Simple notification
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "UnnamedHub",
            Text = text or "",
            Duration = duration or 3,
        })
    end)
end

-- Welcome message
notify("UnnamedHub", "Deagle Arena Script Loaded!", 5)
print("[UnnamedHub] Deagle Arena Script Loaded!")

-- Simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UnnamedHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Deagle Arena"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = Frame

-- Aimbot button
local AimbotButton = Instance.new("TextButton")
AimbotButton.Size = UDim2.new(1, -20, 0, 35)
AimbotButton.Position = UDim2.new(0, 10, 0, 40)
AimbotButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.Text = "Aimbot: OFF"
AimbotButton.Font = Enum.Font.SourceSansBold
AimbotButton.TextSize = 14
AimbotButton.Parent = Frame

-- ESP button
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(1, -20, 0, 35)
ESPButton.Position = UDim2.new(0, 10, 0, 80)
ESPButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Text = "ESP: OFF"
ESPButton.Font = Enum.Font.SourceSansBold
ESPButton.TextSize = 14
ESPButton.Parent = Frame

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(1, -20, 0, 25)
CloseButton.Position = UDim2.new(0, 10, 0, 120)
CloseButton.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "Close"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 12
CloseButton.Parent = Frame

-- Variables
local aimbotEnabled = false
local espEnabled = false

-- Aimbot function
local function aimbot()
    spawn(function()
        while aimbotEnabled do
            pcall(function()
                local closest = nil
                local shortestDistance = math.huge
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        local head = player.Character:FindFirstChild("Head")
                        if head then
                            local distance = (LocalPlayer.Character.Head.Position - head.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                closest = player
                            end
                        end
                    end
                end
                
                if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                    local camera = workspace.CurrentCamera
                    camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Character.Head.Position)
                end
            end)
            wait()
        end
    end)
end

-- ESP function
local function esp()
    spawn(function()
        local highlights = {}
        
        while espEnabled do
            pcall(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        if not highlights[player] then
                            local highlight = Instance.new("Highlight")
                            highlight.Parent = player.Character
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlights[player] = highlight
                        end
                    end
                end
            end)
            wait(1)
        end
        
        -- Clean up
        for player, highlight in pairs(highlights) do
            if highlight then
                highlight:Destroy()
            end
        end
        highlights = {}
    end)
end

-- Toggle buttons
AimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    AimbotButton.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
    AimbotButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 60, 60)
    if aimbotEnabled then
        aimbot()
        notify("UnnamedHub", "Aimbot Enabled!", 3)
    else
        notify("UnnamedHub", "Aimbot Disabled!", 3)
    end
end)

ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    ESPButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 60, 60)
    if espEnabled then
        esp()
        notify("UnnamedHub", "ESP Enabled!", 3)
    else
        notify("UnnamedHub", "ESP Disabled!", 3)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Mobile support
if _G.__UNNAMED and _G.__UNNAMED.isMobile then
    Frame.Size = UDim2.new(0, 250, 0, 200)
    Frame.Position = UDim2.new(0.5, -125, 0.5, -100)
    AimbotButton.TextSize = 16
    ESPButton.TextSize = 16
end
