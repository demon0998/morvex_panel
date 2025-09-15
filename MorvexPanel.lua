-- Morvex Panel (Updated with Fly + Player Control)
-- UI + Functions

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.5, -125, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 255)

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Morvex Panel"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Fly Vars
local flying = false
local flySpeed = 50
local flyConnection

-- Walk/Jump
local WalkSpeedBox = Instance.new("TextBox", Frame)
WalkSpeedBox.PlaceholderText = "WalkSpeed"
WalkSpeedBox.Position = UDim2.new(0, 10, 0, 50)
WalkSpeedBox.Size = UDim2.new(0, 100, 0, 25)

local JumpPowerBox = Instance.new("TextBox", Frame)
JumpPowerBox.PlaceholderText = "JumpPower"
JumpPowerBox.Position = UDim2.new(0, 130, 0, 50)
JumpPowerBox.Size = UDim2.new(0, 100, 0, 25)

local ApplyButton = Instance.new("TextButton", Frame)
ApplyButton.Text = "Apply"
ApplyButton.Size = UDim2.new(0, 230, 0, 25)
ApplyButton.Position = UDim2.new(0, 10, 0, 80)
ApplyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Fly Speed
local FlySpeedBox = Instance.new("TextBox", Frame)
FlySpeedBox.PlaceholderText = "Fly Speed"
FlySpeedBox.Position = UDim2.new(0, 10, 0, 120)
FlySpeedBox.Size = UDim2.new(0, 100, 0, 25)

local FlyButton = Instance.new("TextButton", Frame)
FlyButton.Text = "Toggle Fly"
FlyButton.Size = UDim2.new(0, 100, 0, 25)
FlyButton.Position = UDim2.new(0, 130, 0, 120)
FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Player Fly
local PlayerBox = Instance.new("TextBox", Frame)
PlayerBox.PlaceholderText = "Player Name"
PlayerBox.Position = UDim2.new(0, 10, 0, 160)
PlayerBox.Size = UDim2.new(0, 100, 0, 25)

local PlayerFlyButton = Instance.new("TextButton", Frame)
PlayerFlyButton.Text = "Make Fly"
PlayerFlyButton.Size = UDim2.new(0, 100, 0, 25)
PlayerFlyButton.Position = UDim2.new(0, 130, 0, 160)
PlayerFlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerFlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Functions
ApplyButton.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if tonumber(WalkSpeedBox.Text) then
            hum.WalkSpeed = tonumber(WalkSpeedBox.Text)
        end
        if tonumber(JumpPowerBox.Text) then
            hum.JumpPower = tonumber(JumpPowerBox.Text)
        end
    end
end)

local function Fly(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    flying = true
    flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move = move + root.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move = move - root.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move = move - root.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move = move + root.CFrame.RightVector
        end
        root.Velocity = move * flySpeed
    end)
end

local function StopFly()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

FlyButton.MouseButton1Click:Connect(function()
    if flying then
        StopFly()
    else
        local char = LocalPlayer.Character
        if FlySpeedBox.Text ~= "" then
            flySpeed = tonumber(FlySpeedBox.Text) or 50
        end
        Fly(char)
    end
end)

-- Shortcut Key (F)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then
            StopFly()
        else
            local char = LocalPlayer.Character
            Fly(char)
        end
    end
end)

-- Player Fly
PlayerFlyButton.MouseButton1Click:Connect(function()
    local targetName = PlayerBox.Text
    if targetName ~= "" then
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Fly(target.Character)
        end
    end
end)
