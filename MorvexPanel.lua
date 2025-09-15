-- Morvex Tiny Panel (LocalScript) - put in StarterPlayerScripts
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Replace with your image asset id
local IMAGE_ASSET = "rbxassetid://YOUR_ASSET_ID"

-- Character reference
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MorvexTinyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Icon button
local iconBtn = Instance.new("ImageButton")
iconBtn.Name = "MorvexIcon"
iconBtn.Size = UDim2.new(0,60,0,60)
iconBtn.Position = UDim2.new(0.02,0,0.4,0)
iconBtn.Image = IMAGE_ASSET
iconBtn.BackgroundTransparency = 0.2
iconBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
iconBtn.AutoButtonColor = true
iconBtn.Active = true
iconBtn.Parent = screenGui
iconBtn.Draggable = true

-- Panel
local panel = Instance.new("Frame")
panel.Name = "MorvexPanel"
panel.Size = UDim2.new(0,240,0,170)
panel.Position = UDim2.new(0.05,0,0.45,0)
panel.BackgroundColor3 = Color3.fromRGB(18,18,18)
panel.BackgroundTransparency = 0.15
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = screenGui
panel.Active = true
panel.Draggable = true

-- Title
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,32)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Morvex Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,200,255)

-- Speed
local speedLbl = Instance.new("TextLabel", panel)
speedLbl.Size = UDim2.new(0.5,0,0,28)
speedLbl.Position = UDim2.new(0,8,0,40)
speedLbl.BackgroundTransparency = 1
speedLbl.Text = "Speed"
speedLbl.TextColor3 = Color3.fromRGB(220,220,220)

local speedBox = Instance.new("TextBox", panel)
speedBox.Size = UDim2.new(0.45,0,0,28)
speedBox.Position = UDim2.new(0.5, -8, 0, 40)
speedBox.Text = "55"
speedBox.ClearTextOnFocus = false
speedBox.PlaceholderText = "WalkSpeed"

-- Jump
local jumpLbl = Instance.new("TextLabel", panel)
jumpLbl.Size = UDim2.new(0.5,0,0,28)
jumpLbl.Position = UDim2.new(0,8,0,76)
jumpLbl.BackgroundTransparency = 1
jumpLbl.Text = "JumpPower"
jumpLbl.TextColor3 = Color3.fromRGB(220,220,220)

local jumpBox = Instance.new("TextBox", panel)
jumpBox.Size = UDim2.new(0.45,0,0,28)
jumpBox.Position = UDim2.new(0.5, -8, 0, 76)
jumpBox.Text = "55"
jumpBox.ClearTextOnFocus = false
jumpBox.PlaceholderText = "JumpPower"

-- Enable button
local enableBtn = Instance.new("TextButton", panel)
enableBtn.Size = UDim2.new(0.9,0,0,30)
enableBtn.Position = UDim2.new(0.05,0,0,116)
enableBtn.Text = "Enable"
enableBtn.Font = Enum.Font.GothamBold
enableBtn.TextSize = 16
enableBtn.BackgroundColor3 = Color3.fromRGB(100,50,150)
enableBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Persist button
local persistBtn = Instance.new("TextButton", panel)
persistBtn.Size = UDim2.new(0.9,0,0,24)
persistBtn.Position = UDim2.new(0.05,0,0,148)
persistBtn.Text = "Persist: OFF"
persistBtn.Font = Enum.Font.Gotham
persistBtn.TextSize = 14
persistBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
persistBtn.TextColor3 = Color3.fromRGB(230,230,230)

-- States
local active = false
local persist = false
local savedSpeed = 55
local savedJump = 55

-- Apply values
local function applyValuesToHumanoid(h)
    if not h then return end
    local s = tonumber(speedBox.Text) or savedSpeed
    local j = tonumber(jumpBox.Text) or savedJump
    savedSpeed = s
    savedJump = j
    pcall(function()
        h.UseJumpPower = true
        h.WalkSpeed = s
        h.JumpPower = j
    end)
end

-- Restore defaults
local function restoreHumanoidDefaults(h)
    if not h then return end
    pcall(function()
        h.WalkSpeed = 16
        h.JumpPower = 50
    end)
end

-- Toggle panel
iconBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- Enable button logic
enableBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if not h then return end

    if not active then
        applyValuesToHumanoid(h)
        active = true
        enableBtn.Text = "Disable"
        enableBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
    else
        restoreHumanoidDefaults(h)
        active = false
        enableBtn.Text = "Enable"
        enableBtn.BackgroundColor3 = Color3.fromRGB(100,50,150)
    end
end)

-- Persist button logic
persistBtn.MouseButton1Click:Connect(function()
    persist = not persist
    if persist then
        persistBtn.Text = "Persist: ON"
        persistBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
    else
        persistBtn.Text = "Persist: OFF"
        persistBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    end
end)

-- Respawn handler
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = char:WaitForChild("Humanoid")
    task.wait(0.3)
    if persist or active then
        applyValuesToHumanoid(humanoid)
        active = true
        enableBtn.Text = "Disable"
        enableBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
    end
end)
