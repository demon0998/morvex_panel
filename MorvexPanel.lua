-- Morvex Panel
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local FlyButton = Instance.new("TextButton")
local AutoEnableButton = Instance.new("TextButton")
local PlayerInput = Instance.new("TextBox")

-- Parent to CoreGui
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "MorvexPanel"

-- Main Frame
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title
Title.Parent = MainFrame
Title.Text = "Morvex Panel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Close Button
CloseButton.Parent = MainFrame
CloseButton.Text = "X"
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Fly Button
FlyButton.Parent = MainFrame
FlyButton.Text = "Fly"
FlyButton.Position = UDim2.new(0.05, 0, 0.3, 0)
FlyButton.Size = UDim2.new(0, 120, 0, 40)
FlyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.TextSize = 18

-- Auto Enable Button
AutoEnableButton.Parent = MainFrame
AutoEnableButton.Text = "Auto Enable"
AutoEnableButton.Position = UDim2.new(0.55, 0, 0.3, 0)
AutoEnableButton.Size = UDim2.new(0, 120, 0, 40)
AutoEnableButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
AutoEnableButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoEnableButton.Font = Enum.Font.GothamBold
AutoEnableButton.TextSize = 18

-- Player Input (for targeting players to fly)
PlayerInput.Parent = MainFrame
PlayerInput.PlaceholderText = "Enter player name"
PlayerInput.Position = UDim2.new(0.05, 0, 0.65, 0)
PlayerInput.Size = UDim2.new(0, 270, 0, 35)
PlayerInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerInput.Font = Enum.Font.Gotham
PlayerInput.TextSize = 16

-- Fly Function
local flying = false
local speed = 50

local function setFly(character, enabled)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if enabled then
            local BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            BodyVelocity.Parent = character.HumanoidRootPart
            humanoid.PlatformStand = true
        else
            humanoid.PlatformStand = false
            for _, v in pairs(character.HumanoidRootPart:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end

-- Fly button action
FlyButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    flying = not flying
    setFly(char, flying)
end)

-- Auto Enable button action
AutoEnableButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    setFly(char, true)
end)

-- Target other player
PlayerInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local name = PlayerInput.Text
        local target = game.Players:FindFirstChild(name)
        if target and target.Character then
            setFly(target.Character, true)
        end
    end
end)
