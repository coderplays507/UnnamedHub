-- Deagle Arena Script - Simple Test Version
print("[UnnamedHub] Deagle Arena script running!")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "UnnamedHub",
        Text = "Deagle Arena Script Loaded!",
        Duration = 5,
    })
end)

-- Create simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UnnamedHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Position = UDim2.new(0.5, -125, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Deagle Arena"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

-- Test Button
local TestButton = Instance.new("TextButton")
TestButton.Size = UDim2.new(1, -20, 0, 40)
TestButton.Position = UDim2.new(0, 10, 0, 45)
TestButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
TestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TestButton.Text = "Click Me!"
TestButton.Font = Enum.Font.SourceSansBold
TestButton.TextSize = 16
TestButton.Parent = Frame

TestButton.MouseButton1Click:Connect(function()
    print("[UnnamedHub] Button clicked!")
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "UnnamedHub",
            Text = "Button works!",
            Duration = 3,
        })
    end)
end)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(1, -20, 0, 35)
CloseButton.Position = UDim2.new(0, 10, 0, 95)
CloseButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "Close"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.Parent = Frame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("[UnnamedHub] GUI created!")
