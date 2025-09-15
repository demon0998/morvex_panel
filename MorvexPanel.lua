-- Fly implementation (smooth CFrame movement)
local function startFly()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    flyActive = true

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyActive then return end
        if not root then return end

        local speed = tonumber(flyBox.Text) or 50
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir += cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir -= cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir -= cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir += cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir += Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveDir -= Vector3.new(0,1,0)
        end

        if moveDir.Magnitude > 0 then
            root.CFrame = root.CFrame + (moveDir.Unit * (speed / 60)) -- smooth step
        end
    end)
end

local function stopFly()
    flyActive = false
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
end
