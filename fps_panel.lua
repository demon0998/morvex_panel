-- Smooth FPS + Ping viewer with auto-rebuild
-- Put this as a LocalScript in StarterPlayerScripts (best) or run with loadstring
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local player = Players.LocalPlayer
local guiName = "SmoothStatsViewer_v1"

-- smoothing factor (0..1) -- اقل = أهدأ/أبطأ في التحديث، اعلى = أسرع تغيّر
local SMOOTH = 0.12

-- helper lerp
local function lerp(a, b, t)
	return a + (b - a) * t
end

-- destroy safe
local function safeDestroy(obj)
	if obj and obj.Parent then
		pcall(function() obj:Destroy() end)
	end
end

local current = {
	screenGui = nil,
	renderConn = nil,
	pingTask = nil,
}

local function makeGui()
	-- لو موجود، نمسحه علشان نعيد بناءه بنظام نظيف
	if player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild(guiName) then
		player.PlayerGui[guiName]:Destroy()
	end

	-- GUI
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = guiName
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 200, 0, 70)
	frame.Position = UDim2.new(0, 12, 0, 12)
	frame.BackgroundTransparency = 0.25
	frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui
	frame.Visible = true
	frame.ZIndex = 5
	frame.ClipsDescendants = false
	frame.Name = "Container"

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 20)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "Stats"
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = Color3.fromRGB(200,200,200)
	title.Font = Enum.Font.SourceSansSemibold
	title.TextSize = 14
	title.BorderSizePixel = 0
	title.Padding = Enum.Padding.new(4)

	local fpsLabel = Instance.new("TextLabel", frame)
	fpsLabel.Size = UDim2.new(1, 0, 0, 24)
	fpsLabel.Position = UDim2.new(0, 6, 0, 22)
	fpsLabel.BackgroundTransparency = 1
	fpsLabel.Text = "FPS: 0"
	fpsLabel.Font = Enum.Font.Code
	fpsLabel.TextSize = 20
	fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
	fpsLabel.TextColor3 = Color3.fromRGB(110, 255, 110)
	fpsLabel.BorderSizePixel = 0

	local pingLabel = Instance.new("TextLabel", frame)
	pingLabel.Size = UDim2.new(1, 0, 0, 24)
	pingLabel.Position = UDim2.new(0, 6, 0, 46)
	pingLabel.BackgroundTransparency = 1
	pingLabel.Text = "Ping: 0 ms"
	pingLabel.Font = Enum.Font.Code
	pingLabel.TextSize = 18
	pingLabel.TextXAlignment = Enum.TextXAlignment.Left
	pingLabel.TextColor3 = Color3.fromRGB(255, 215, 110)
	pingLabel.BorderSizePixel = 0

	-- small nice touch: shadow (optional)
	local uicorner = Instance.new("UICorner", frame)
	uicorner.CornerRadius = UDim.new(0,6)

	-- state
	local smoothFPS = 60
	local smoothPing = 0

	-- cleanup old connections/tasks
	if current.renderConn then
		current.renderConn:Disconnect()
	end
	if current.pingTask and type(current.pingTask) == "thread" then
		-- nothing special, we'll overwrite
	end

	-- FPS update using RenderStepped deltaTime (accurate)
	current.renderConn = RunService.RenderStepped:Connect(function(delta)
		local instantFPS = 1 / math.max(delta, 1/1000)
		smoothFPS = lerp(smoothFPS, instantFPS, SMOOTH)
		local fpsText = math.floor(smoothFPS + 0.5)
		fpsLabel.Text = ("FPS: %d"):format(fpsText)
	end)

	-- Ping update (uses Stats if available). update every 0.6s
	current.pingTask = task.spawn(function()
		while screenGui and screenGui.Parent do
			local ok, pingVal = pcall(function()
				-- prefer numeric value if possible
				local item = Stats:FindFirstChild("Network")
				-- alternative access:
				-- Stats.Network.ServerStatsItem["Data Ping"]
				local raw = Stats.Network and Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem["Data Ping"]
				if raw then
					-- GetValueString returns "xx ms" sometimes; use GetValue for number
					local n = raw:GetValue()
					return tonumber(n) or 0
				end
				-- fallback: zero
				return 0
			end)
			if ok and pingVal then
				smoothPing = lerp(smoothPing, tonumber(pingVal) or 0, SMOOTH)
				pingLabel.Text = ("Ping: %d ms"):format(math.floor(smoothPing + 0.5))
			else
				-- if failed, show N/A
				pingLabel.Text = "Ping: N/A"
			end
			task.wait(0.6)
		end
	end)

	-- store refs for cleanup
	current.screenGui = screenGui

	-- return cleanup function
	return function()
		pcall(function()
			if current.renderConn then
				current.renderConn:Disconnect()
				current.renderConn = nil
			end
			if current.pingTask then
				-- can't directly kill thread; rely on screenGui Parent check to stop it
				current.pingTask = nil
			end
			safeDestroy(screenGui)
			current.screenGui = nil
		end)
	end
end

-- initial build
local cleanup = makeGui()

-- watchdog loop: لو اتشال الـ GUI، يرجع يعمله تاني
task.spawn(function()
	while true do
		task.wait(3)
		local ok = (player and player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild(guiName))
		if not ok then
			-- cleanup local refs then rebuild
			pcall(function()
				if current.renderConn then current.renderConn:Disconnect() end
				current.renderConn = nil
				current.screenGui = nil
			end)
			makeGui()
		end
	end
end)
