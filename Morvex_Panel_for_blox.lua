-- LocalScript داخل StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local UIS = game:GetService("UserInputService")

-- القيم الافتراضية
local hitboxSize = Vector3.new(1,1,1)
local hitboxVisible = true

-- Function لتعديل Hitbox
local function modifyHitbox(tool)
    for _, part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Size = hitboxSize
            part.Transparency = hitboxVisible and 0.5 or 1
        end
    end
end

-- Function لإزالة الكول دون
local function removeCooldown(tool)
    if tool:FindFirstChild("Cooldown") then
        tool.Cooldown.Value = 0
    end
end

-- GUI صغير للتحكم
local gui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,200)
frame.Position = UDim2.new(0,50,0,50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Tool Modifier"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- زر إزالة Cooldown
local btnCooldown = Instance.new("TextButton", frame)
btnCooldown.Size = UDim2.new(1, -10, 0, 40)
btnCooldown.Position = UDim2.new(0,5,0,40)
btnCooldown.Text = "No Cooldown"
btnCooldown.MouseButton1Click:Connect(function()
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            removeCooldown(tool)
        end
    end
end)

-- زر تعديل Hitbox
local btnHitbox = Instance.new("TextButton", frame)
btnHitbox.Size = UDim2.new(1, -10, 0, 40)
btnHitbox.Position = UDim2.new(0,5,0,90)
btnHitbox.Text = "Toggle Hitbox"
btnHitbox.MouseButton1Click:Connect(function()
    hitboxVisible = not hitboxVisible
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            modifyHitbox(tool)
        end
    end
end)

-- زيادة / تقليل Hitbox بالكيبورد
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Up then
        hitboxSize = hitboxSize + Vector3.new(0.5,0.5,0.5)
    elseif input.KeyCode == Enum.KeyCode.Down then
        hitboxSize = hitboxSize - Vector3.new(0.5,0.5,0.5)
    end
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            modifyHitbox(tool)
        end
    end
end)
