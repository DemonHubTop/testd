local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local joinTeam = getgenv().join or "Pirates"
local webhookURL = getgenv().webhook or ""

-- Auto Join Team
pcall(function()
	CommF_:InvokeServer("SetTeam", joinTeam)
end)

-- GUI Setup
local function createGUI()
	local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	gui.Name = "DemonHub"

	local frame = Instance.new("Frame", gui)
	frame.Position = UDim2.new(0, 20, 0, 20)
	frame.Size = UDim2.new(0, 300, 0, 130)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

	local title = Instance.new("TextLabel", frame)
	title.Text = "DEMONHUB | FRUIT FINDER"
	title.Size = UDim2.new(1, 0, 0, 30)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(255, 0, 0)
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true

	local fruitLabel = Instance.new("TextLabel", frame)
	fruitLabel.Position = UDim2.new(0, 10, 0, 40)
	fruitLabel.Size = UDim2.new(1, -20, 0, 20)
	fruitLabel.Text = "Fruit: None"
	fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	fruitLabel.Font = Enum.Font.Gotham
	fruitLabel.TextXAlignment = Enum.TextXAlignment.Left
	fruitLabel.BackgroundTransparency = 1

	return fruitLabel
end

local fruitLabel = createGUI()

-- Teleport To Fruit
local function teleportTo(pos)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
end

-- Store Fruit
local function storeFruit()
	for _, tool in ipairs(player.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Fruit") then
			CommF_:InvokeServer("StoreFruit", tool.Name)
		end
	end
	for _, tool in ipairs(player.Character:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Fruit") then
			CommF_:InvokeServer("StoreFruit", tool.Name)
		end
	end
end

-- Webhook Logger
local function sendWebhook(fruitName)
	if webhookURL == "" then return end

	local data = {
		["username"] = "DemonHub Logger",
		["embeds"] = {{
			["title"] = "Fruit Collected",
			["color"] = 65280,
			["fields"] = {
				{["name"] = "Fruit", ["value"] = fruitName, ["inline"] = true},
				{["name"] = "Player", ["value"] = player.Name, ["inline"] = true}
			},
			["footer"] = {["text"] = "DemonHub Fruit Logger"}
		}}
	}

	local success, err = pcall(function()
		HttpService:PostAsync(webhookURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)
end

-- Cari Buah
local function getFruits()
	local fruits = {}
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj:FindFirstChild("Fruit") and obj.Parent == workspace then
			table.insert(fruits, obj)
		end
	end
	return fruits
end

-- Server Hop
local tried = {}
local function hopServer()
	local gameId = game.PlaceId
	local jobId = game.JobId
	local cursor = ""
	local servers = {}

	repeat
		local url = "https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=2&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
		local response = HttpService:JSONDecode(game:HttpGet(url))
		for _, v in pairs(response.data) do
			if v.playing < v.maxPlayers and v.id ~= jobId and not tried[v.id] then
				table.insert(servers, v.id)
			end
		end
		cursor = response.nextPageCursor
	until not cursor or #servers >= 5

	if #servers > 0 then
		local pick = servers[math.random(1, #servers)]
		tried[pick] = true
		TeleportService:TeleportToPlaceInstance(gameId, pick, player)
	else
		task.wait(5)
		hopServer()
	end
end

-- MAIN LOOP
task.spawn(function()
	while true do
		local found = false
		for _, fruit in ipairs(getFruits()) do
			found = true
			local fruitName = fruit.Name
			fruitLabel.Text = "Fruit: " .. fruitName
			teleportTo(fruit.Handle.Position)
			task.wait(3)
			storeFruit()
			sendWebhook(fruitName)
			task.wait(2)
		end
		if not found then
			fruitLabel.Text = "Fruit: None"
			task.wait(10)
			hopServer()
		end
		task.wait(2)
	end
end)
