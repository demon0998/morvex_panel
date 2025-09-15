-- MorvexPanel v1.2 - Local client GUI
-- Put this as a LocalScript (StarterPlayerScripts) or run via executor as a client script.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then return end

-- Replace with your own public decal asset id if you like
local IMAGE_ASSET = "rbxassetid://106976568325950"

-- GUI root
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MorvexPanelGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Floating Icon (draggable)
local icon = Instance.new("ImageButton")
icon.Name = "MorvexIcon"
icon.Size = UDim2.new(0,64,0,64)
icon.Position = UDim2.new(0.02,0,0.4,0)
icon.Image = IMAGE_ASSET
icon.BackgroundColor3 = Color3.fromRGB(30,30,30)
icon.BackgroundTransparency = 0
icon.AutoButtonColor = true
icon.Parent = screenGui
local iconCorner = Instance.new("UICorner", icon)
iconCorner.CornerRadius = UDim.new(0,12)

-- Panel
local panel = Instance.new("Frame")
panel.Name = "MorvexPanel"
panel.Size = UDim2.new(0,300,0,260)
panel.Position = UDim2.new(0.06,0,0.45,0)
panel.BackgroundColor3 = Color3.fromRGB(18,18,18)
panel.BorderSizePixel = 0
panel.Visible = false
panel.Active = true
panel.Parent = screenGui
local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0,14)

-- Title
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,36)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Morvex Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)

-- Close button (inside panel)
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-34,0,4)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,6)

-- Labels and boxes
local function makeLabel(parent, text, posY)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(0.45,0,0,28)
    l.Position = UDim2.new(0.03,0,0,posY)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(220,220,220)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    return l
end
local function makeBox(parent, posX, posY, default)
    local b = Instance.new("TextBox", parent)
    b.Size = UDim2.new(0.44,0,0,28)
    b.Position = UDim2.new(posX,0,0,posY)
    b.Text = tostring(default)
    b.PlaceholderText = ""
    b.ClearTextOnFocus = false
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0,8)
    return b
end

makeLabel(panel, "Walk Speed", 44)
local walkBox = makeBox(panel, 0.51, 44, 55)

makeLabel(panel, "Jump Power", 84)
local jumpBox = makeBox(panel, 0.51, 84, 55)

makeLabel(panel, "Fly Speed", 124)
local flyBox = makeBox(panel, 0.51, 124, 50)

-- Buttons
local function makeButton(parent, text, posY, color)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.94,0,0,34)
    b.Position = UDim2.new(0.03,0,0,posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BackgroundColor3 = color or Color3.fromRGB(80,80,80)
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0,8)
    return b
end

local applyBtn = makeButton(panel, "Apply Walk/Jump", 164, Color3.fromRGB(110,55,160))
local flyToggleBtn = makeButton(panel, "Toggle Fly (F)", 204, Color3.fromRGB(50,120,210))
local autoEnableBtn = makeButton(panel, "Auto Enable: OFF", 232, Color3.fromRGB(80,80,80))

-- state
local flyActive = false
local flyConnection = nil
local autoEnable = false

-- helper apply function
local function applyWalkJump()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.UseJumpPower = true
        hum.WalkSpeed = tonumber(walkBox.Text) or 55
        hum.JumpPower = tonumber(jumpBox.Text) or 55
    end)
end

applyBtn.MouseButton1Click:Connect(applyWalkJump)
closeBtn.MouseButton1Click:Connect(function() panel.Visible = false end)

-- Fly implementation (client-side)
local function startFly()
    if flyConnection then flyConnection:Disconnect() end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    flyActive = true
    local speed = tonumber(flyBox.Text) or 50
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyActive then return end
        if not root then return end
        local dir = Vector3.new()
        local cam = workspace.CurrentCamera
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then
            root.Velocity = dir.Unit * (tonumber(flyBox.Text) or speed)
        else
            root.Velocity = Vector3.new(0,0,0)
        end
    end)
end

local function stopFly()
    flyActive = false
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
end

flyToggleBtn.MouseButton1Click:Connect(function()
    if flyActive then stopFly() else startFly() end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flyActive then stopFly() else startFly() end
    end
end)

-- Auto enable toggle
autoEnableBtn.MouseButton1Click:Connect(function()
    autoEnable = not autoEnable
    autoEnableBtn.Text = autoEnable and "Auto Enable: ON" or "Auto Enable: OFF"
    autoEnableBtn.BackgroundColor3 = autoEnable and Color3.fromRGB(70,160,70) or Color3.fromRGB(80,80,80)
end)

-- reapply after respawn if autoEnable true
player.CharacterAdded:Connect(function(char)
    wait(0.35)
    if autoEnable then
        applyWalkJump()
        if flyActive then
            startFly()
        end
    end
end)

-- Toggle panel by clicking icon
icon.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)
