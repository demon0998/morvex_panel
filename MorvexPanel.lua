-- Morvex Tiny Panel (LocalScript) - حط في StarterPlayerScripts
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- انتبه: حط هنا الـ AssetId بتاع الصورة اللي رفعتها
local IMAGE_ASSET = "rbxassetid://YOUR_ASSET_ID"

-- ريفرنس للشخصية (هنعيد تهيئته بعد كل ريسباون)
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MorvexTinyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- الـ أيقونة المربعة الصغيرة (صورة مربعة 60x60)
local iconBtn = Instance.new("ImageButton")
iconBtn.Name = "MorvexIcon"
iconBtn.Size = UDim2.new(0,60,0,60)        -- الحجم الصغير المربع
iconBtn.Position = UDim2.new(0.02,0,0.4,0) -- مكان ابتدائي (يسار الشاشة)
iconBtn.Image = IMAGE_ASSET
iconBtn.BackgroundTransparency = 0.2
iconBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
iconBtn.AutoButtonColor = true
iconBtn.Active = true
iconBtn.Parent = screenGui

-- خلي الايقونة قابلة للسحب
iconBtn.Draggable = true

-- البانل اللي هيفتح
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

-- عنوان
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,32)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Morvex Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,200,255)

-- Speed label + box
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

-- Jump label + box (حنستخدم JumpPower دايمًا)
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

-- تكتيف (Enable) زر
local enableBtn = Instance.new("TextButton", panel)
enableBtn.Size = UDim2.new(0.9,0,0,30)
enableBtn.Position = UDim2.new(0.05,0,0,116)
enableBtn.Text = "تفعيل"
enableBtn.Font = Enum.Font.GothamBold
enableBtn.TextSize = 16
enableBtn.BackgroundColor3 = Color3.fromRGB(100,50,150)
enableBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- استمرار بعد الموت
local persistBtn = Instance.new("TextButton", panel)
persistBtn.Size = UDim2.new(0.9,0,0,24)
persistBtn.Position = UDim2.new(0.05,0,0,148)
persistBtn.Text = "لا يستمر بعد الموت"
persistBtn.Font = Enum.Font.Gotham
persistBtn.TextSize = 14
persistBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
persistBtn.TextColor3 = Color3.fromRGB(230,230,230)

-- حالة المتغيرات
local active = false
local persist = false
local savedSpeed = 55
local savedJump = 55

-- دوال مساعدة لتطبيق القيم على الهومانويد
local function applyValuesToHumanoid(h)
    if not h then return end
    local s = tonumber(speedBox.Text) or savedSpeed
    local j = tonumber(jumpBox.Text) or savedJump
    savedSpeed = s
    savedJump = j
    -- force UseJumpPower = true عشان حتى R15 يستخدم JumpPower القديم
    pcall(function()
        h.UseJumpPower = true
        h.WalkSpeed = s
        h.JumpPower = j
    end)
end

local function restoreHumanoidDefaults(h)
    if not h then return end
    pcall(function()
        h.WalkSpeed = 16
        h.JumpPower = 50
    end)
end

-- ايقاف/فتح البانل لما تدوس الايقونة
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
        applyValuesToHumanoid(h)
        active = true
        enableBtn.Text = "إلغاء"
        enableBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
    else
        restoreHumanoidDefaults(h)
        active = false
        enableBtn.Text = "تفعيل"
        enableBtn.BackgroundColor3 = Color3.fromRGB(100,50,150)
    end
end)

-- زر استمرار بعد الموت
persistBtn.MouseButton1Click:Connect(function()
    persist = not persist
    if persist then
        persistBtn.Text = "يستمر بعد الموت ✔"
        persistBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
    else
        persistBtn.Text = "لا يستمر بعد الموت"
        persistBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    end
end)

-- لو الشخصية تولدت من جديد، نطبّق القيم لو الـ persist مفعل أو لو active مفعل
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = nil
    humanoid = char:WaitForChild("Humanoid")
    wait(0.3) -- نص ثانية عشان يستقر الهومانويد
    if persist or active then
        applyValuesToHumanoid(humanoid)
        active = true
        enableBtn.Text = "إلغاء"
        enableBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
    end
end)
