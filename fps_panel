-- LocalScript داخل StarterPlayerScripts

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
gui.Name = "StatsViewer"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 70)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2

local fpsLabel = Instance.new("TextLabel", frame)
fpsLabel.Size = UDim2.new(1, 0, 0.5, 0)
fpsLabel.TextColor3 = Color3.new(0, 1, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 20
fpsLabel.Text = "FPS: 0"

local pingLabel = Instance.new("TextLabel", frame)
pingLabel.Size = UDim2.new(1, 0, 0.5, 0)
pingLabel.Position = UDim2.new(0, 0, 0.5, 0)
pingLabel.TextColor3 = Color3.new(1, 1, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.SourceSansBold
pingLabel.TextSize = 20
pingLabel.Text = "Ping: 0 ms"

-- FPS حساب
local lastUpdate = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount += 1
    if tick() - lastUpdate >= 1 then
        local fps = frameCount / (tick() - lastUpdate)
        fpsLabel.Text = "FPS: " .. math.floor(fps)
        frameCount = 0
        lastUpdate = tick()
    end
end)

-- Ping حساب
while true do
    local stats = game:GetService("Stats")
    local ping = stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
    pingLabel.Text = "Ping: " .. ping
    task.wait(1)
end
