-- Morvex Tiny Panel (LocalScript)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- حط هنا الـ AssetId بتاع الصورة اللي رفعتها
local IMAGE_ASSET = "rbxassetid://106976568325950"

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MorvexTinyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- الايقونة (مربع صغير عايم)
local iconBtn = Instance.new("ImageButton")
iconBtn.Name = "MorvexIcon"
iconBtn.Size = UDim2.new(0, 60, 0, 60)
iconBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
iconBtn.Image = IMAGE_ASSET
iconBtn.BackgroundTransparency = 0.2
iconBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
iconBtn.AutoButtonColor = true
iconBtn.Active = true
iconBtn.Draggable = true
iconBtn.Parent = screenGui

-- البانل
local panel = Instance.new("Frame")
panel.Name = "MorvexPanel"
panel.Size = UDim2.new(0, 250, 0, 200)
panel.Position = UDim2.new(0.05, 0, 0.45, 0)
panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
panel.BackgroundTransparency = 0.15
panel.BorderSizePixel = 0
panel.Visible = false
panel.Active = true
panel.Draggable = true
panel.Parent = screenGui

-- عنوان
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundTransparency = 1
title.Text = "Morvex Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = panel

-- Speed
local speedLbl = Instance.new("TextLabel", panel)
speedLbl.Size = UDim2.new(0.5, 0, 0, 28)
speedLbl.Position = UDim2.new(0, 8, 0, 40)
speedLbl.BackgroundTransparency = 1
speedLbl.Text = "Speed"
speedLbl.TextColor3 = Color3.fromRGB(255, 255, 255)

local speedBox = Instance.new("TextBox", panel)
speedBox.Size = UDim2.new(0.45, 0, 0, 28)
speedBox.Position = UDim2.new(0.5, -8, 0, 40)
speedBox.Text = "55"
speedBox.ClearTextOnFocus = false
speedBox.PlaceholderText = "WalkSpeed"

-- JumpPower
local jumpLbl = Instance.new("TextLabel", panel)
jumpLbl.Size = UDim2.new(0.5, 0, 0, 28)
jumpLbl.Position = UDim2.new(0, 8, 0, 76)
jumpLbl.BackgroundTransparency = 1
jumpLbl.Text = "JumpPower"
jumpLbl.TextColor3 = Color3.fromRGB(255, 255, 255)

local jumpBox = Instance.new("TextBox", panel)
jumpBox.Size = UDim2.new(0.45, 0, 0, 28)
jumpBox.Position = UDim2.new(0.5, -8, 0, 76)
jumpBox.Text = "55"
jumpBox.ClearTextOnFocus = false
jumpBox.PlaceholderText = "JumpPower"

-- زر التفعيل
local enableBtn = Instance.new("TextButton", panel)
enableBtn.Size = UDim2.new(0.9, 0, 0, 30)
enableBtn.Position = UDim2.new(0.05, 0, 0, 116)
enableBtn.Text = "تفعيل"
enableBtn.Font = Enum.Font.GothamBold
enableBtn.TextSize = 16
enableBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
enableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- زر قفل البانل
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0.9, 0, 0, 28)
closeBtn.Position = UDim2.new(0.05, 0, 0, 154)
closeBtn.Text = "إغلاق"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- حالة
local active = false
local savedSpeed = 55
local savedJump = 55

-- دوال
local function applyValues(h)
    if not h then return end
    local s = tonumber(speedBox.Text) or savedSpeed
    local j = tonumber(jumpBox.Text) or savedJump
    savedSpeed, savedJump = s, j
    pcall(function()
        h.UseJumpPower = true
        h.WalkSpeed = s
        h.JumpPower = j
    end)
end

-- لما تدوس على الايقونة يفتح/يقفل البانل
iconBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- زر التفعيل
enableBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if not h then return end

    if not active then
        applyValues(h)
        active = true
        enableBtn.Text = "إلغاء"
        enableBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    else
        h.WalkSpeed = 16
        h.JumpPower = 50
        active = false
        enableBtn.Text = "تفعيل"
        enableBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    end
end)

-- زر القفل
closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

