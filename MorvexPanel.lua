--// GUI Panel by Morvex
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("ImageButton")
local SettingsFrame = Instance.new("Frame")
local SpeedBox = Instance.new("TextBox")
local JumpBox = Instance.new("TextBox")
local AutoEnable = Instance.new("TextButton")
local ApplyButton = Instance.new("TextButton")

-- Parent GUI
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 200)
MainFrame.Visible = false

-- Toggle Button (الصورة بتاعتك)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundTransparency = 1
ToggleButton.Position = UDim2.new(0, 20, 0.5, -50)
ToggleButton.Size = UDim2.new(0, 100, 0, 100)
ToggleButton.Image = "rbxassetid://106976568325950" -- صورتك
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Settings Frame
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Parent = MainFrame
SettingsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SettingsFrame.Size = UDim2.new(1, 0, 1, 0)

-- Speed Box
SpeedBox.Parent = SettingsFrame
SpeedBox.PlaceholderText = "Speed"
SpeedBox.Text = ""
SpeedBox.Position = UDim2.new(0.1, 0, 0.2, 0)
SpeedBox.Size = UDim2.new(0.8, 0, 0, 30)

-- Jump Box
JumpBox.Parent = SettingsFrame
JumpBox.PlaceholderText = "JumpPower"
JumpBox.Text = ""
JumpBox.Position = UDim2.new(0.1, 0, 0.4, 0)
JumpBox.Size = UDim2.new(0.8, 0, 0, 30)

-- AutoEnable Button
AutoEnable.Parent = SettingsFrame
AutoEnable.Text = "Auto Enable"
AutoEnable.Position = UDim2.new(0.1, 0, 0.6, 0)
AutoEnable.Size = UDim2.new(0.8, 0, 0, 30)

-- Apply Button
ApplyButton.Parent = SettingsFrame
ApplyButton.Text = "Apply"
ApplyButton.Position = UDim2.new(0.1, 0, 0.8, 0)
ApplyButton.Size = UDim2.new(0.8, 0, 0, 30)

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

		if speed then
			hum.WalkSpeed = speed
		end
		if jump then
			hum.UseJumpPower = true
			hum.JumpPower = jump
		end
	end
end)

-- Reset detection
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
	if autoEnabled then
		char:WaitForChild("Humanoid").WalkSpeed = tonumber(SpeedBox.Text) or 16
		char:WaitForChild("Humanoid").UseJumpPower = true
		char:WaitForChild("Humanoid").JumpPower = tonumber(JumpBox.Text) or 50
	end
end)

