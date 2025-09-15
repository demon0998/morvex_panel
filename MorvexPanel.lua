--// GUI Panel by Morvex (Delta Style)

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("ImageButton")
local Title = Instance.new("TextLabel")
local SpeedBox = Instance.new("TextBox")
local JumpBox = Instance.new("TextBox")
local AutoEnable = Instance.new("TextButton")
local ApplyButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

-- Parent GUI
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Toggle Button (صورتك)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundTransparency = 1
ToggleButton.Position = UDim2.new(0, 20, 0.5, -50)
ToggleButton.Size = UDim2.new(0, 80, 0, 80)
ToggleButton.Image = "rbxassetid://106976568325950"
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Main Frame (اللوحة الأساسية)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Visible = false

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 2

-- Title
Title.Parent = MainFrame
Title.Text = "⚡ Morvex Panel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Speed Box
SpeedBox.Parent = MainFrame
SpeedBox.PlaceholderText = "Speed"
SpeedBox.Text = ""
SpeedBox.Position = UDim2.new(0.1, 0, 0.25, 0)
SpeedBox.Size = UDim2.new(0.8, 0, 0, 30)
SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 8)

-- Jump Box
JumpBox.Parent = MainFrame
JumpBox.PlaceholderText = "JumpPower"
JumpBox.Text = ""
JumpBox.Position = UDim2.new(0.1, 0, 0.45, 0)
JumpBox.Size = UDim2.new(0.8, 0, 0, 30)
JumpBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
JumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpBox.Font = Enum.Font.Gotham
JumpBox.TextSize = 14
Instance.new("UICorner", JumpBox).CornerRadius = UDim.new(0, 8)

-- AutoEnable Button
AutoEnable.Parent = MainFrame
AutoEnable.Text = "Auto Enable: OFF"
AutoEnable.Position = UDim2.new(0.1, 0, 0.65, 0)
AutoEnable.Size = UDim2.new(0.8, 0, 0, 30)
AutoEnable.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
AutoEnable.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoEnable.Font = Enum.Font.Gotham
AutoEnable.TextSize = 14
Instance.new("UICorner", AutoEnable).CornerRadius = UDim.new(0, 8)

-- Apply Button
ApplyButton.Parent = MainFrame
ApplyButton.Text = "Apply"
ApplyButton.Position = UDim2.new(0.1, 0, 0.82, 0)
ApplyButton.Size = UDim2.new(0.8, 0, 0, 30)
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.Font = Enum.Font.GothamBold
ApplyButton.TextSize = 14
Instance.new("UICorner", ApplyButton).CornerRadius = UDim.new(0, 8)

-- Variables
local autoEnabled = false

-- AutoEnable toggle
AutoEnable.MouseButton1Click:Connect(function()
	autoEnabled = not autoEnabled
	AutoEnable.Text = autoEnabled and "Auto Enable: ON" or "Auto Enable: OFF"
end)

-- Apply button function
ApplyButton.MouseButton1Click:Connect(function()
	local plr = game.Players.LocalPlayer
	local char = plr.Character or plr.CharacterAdded:Wait()
	local hum = char:FindFirstChildOfClass("Humanoid")

	if hum then
		local speed = tonumber(SpeedBox.Text)
		local jump = tonumber(JumpBox.Text)

		if speed then hum.WalkSpeed = speed end
		if jump then
			hum.UseJumpPower = true
			hum.JumpPower = jump
		end
	end
end)

-- Reset detection
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
	if autoEnabled then
		local hum = char:WaitForChild("Humanoid")
		hum.WalkSpeed = tonumber(SpeedBox.Text) or 16
		hum.UseJumpPower = true
		hum.JumpPower = tonumber(JumpBox.Text) or 50
	end
end)
