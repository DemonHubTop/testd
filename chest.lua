
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local joinTeam = getgenv().join or "Pirates"
local webhookURL = getgenv().webhook or nil
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local tried = {}

-- Auto Join Team
pcall(function()
    CommF:InvokeServer("SetTeam", joinTeam)
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

    local avatar = Instance.new("ImageLabel", frame)
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 10, 1, -50)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"

    local username = Instance.new("TextLabel", frame)
    username.Position = UDim2.new(0, 60, 1, -40)
    username.Size = UDim2.new(0, 200, 0, 20)
    username.Text = player.Name
    username.TextColor3 = Color3.fromRGB(200, 200, 200)
    username.Font = Enum.Font.Gotham
    username.TextSize = 16
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.BackgroundTransparency = 1

    return fruitLabel
end

local fruitLabel = createGUI()

-- Teleport Bypass
local function teleportTo(pos)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
    end
end

-- Webhook Sender
local function sendWebhook(fruitName)
    if webhookURL == nil or webhookURL == "" then return end
    local data = {
        ["username"] = "Fruit Logger",
        ["embeds"] = {{
            ["title"] = "New Fruit Found!",
            ["color"] = 65280,
            ["fields"] = {{
                ["name"] = "Fruit",
                ["value"] = fruitName,
                ["inline"] = true
            }},
            ["footer"] = {
                ["text"] = "DemonHub Fruit Logger"
            }
        }}
    }
    local payload = HttpService:JSONEncode(data)
    pcall(function()
        HttpService:PostAsync(webhookURL, payload, Enum.HttpContentType.ApplicationJson)
    end)
end

-- Store Fruit using spy method
local function storeFruits()
    local function tryStore(tool)
        if tool:IsA("Tool") and tool:FindFirstChild("Fruit") then
            local success, result = pcall(function()
                return CommF:InvokeServer("StoreFruit", tool.Name, tool)
            end)
            return success and result
        end
    end

    -- Backpack
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tryStore(tool) then
            sendWebhook(tool.Name)
        end
    end

    -- Character
    for _, tool in pairs(player.Character:GetChildren()) do
        if tryStore(tool) then
            sendWebhook(tool.Name)
        end
    end
end

-- Fruit Finder
local function findFruit()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == workspace then
            return obj
        end
    end
    return nil
end

-- Server Hop
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
        task.wait(10)
        hopServer()
    end
end

-- Main Loop
task.spawn(function()
    while true do
        local fruit = findFruit()
        if fruit then
            fruitLabel.Text = "Fruit: " .. fruit.Name
            teleportTo(fruit.Handle.Position)
            task.wait(2.5)
            storeFruits()
            fruitLabel.Text = "Fruit: Stored"
            task.wait(5) -- Reset after 5 seconds
            fruitLabel.Text = "Fruit: None"
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)
