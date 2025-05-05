local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local joinTeam = getgenv().join or "Pirates"
local webhook = getgenv().webhook or ""
local Fruit_Blacklist = {}

-- Auto Join Team
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", joinTeam)
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
    fruitLabel.Name = "FruitLabel"
    fruitLabel.Position = UDim2.new(0, 10, 0, 40)
    fruitLabel.Size = UDim2.new(1, -20, 0, 20)
    fruitLabel.Text = "Fruit: None"
    fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fruitLabel.Font = Enum.Font.Gotham
    fruitLabel.TextXAlignment = Enum.TextXAlignment.Left
    fruitLabel.BackgroundTransparency = 1

    local expLabel = Instance.new("TextLabel", frame)
    expLabel.Position = UDim2.new(0, 10, 0, 65)
    expLabel.Size = UDim2.new(1, -20, 0, 20)
    expLabel.Text = "EXP MODE"
    expLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    expLabel.Font = Enum.Font.Gotham
    expLabel.TextSize = 14
    expLabel.TextXAlignment = Enum.TextXAlignment.Left
    expLabel.BackgroundTransparency = 1

    return fruitLabel
end

local fruitLabel = createGUI()

-- Teleport to Fruit
local function teleportTo(pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
end

-- Webhook Send
local function sendWebhook(fruitName)
    if webhook == "" then return end

    local data = {
        ["username"] = "DemonHub Fruit Logger",
        ["embeds"] = {{
            ["title"] = "Fruit Collected",
            ["color"] = 65280,
            ["fields"] = {{
                ["name"] = "Fruit:",
                ["value"] = fruitName,
                ["inline"] = false
            }},
            ["footer"] = {
                ["text"] = "DemonHub | Fruit Finder"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local success, err = pcall(function()
        HttpService:PostAsync(webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)

    if not success then warn("Webhook failed:", err) end
end

-- Store Fruit
local function storeFruit()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

    for _, area in pairs({player.Backpack, player.Character}) do
        for _, item in pairs(area:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("Fruit") and not table.find(Fruit_Blacklist, item.Name) then
                local success = Remote:InvokeServer("StoreFruit", item.Name)
                if success then
                    sendWebhook(item.Name)
                else
                    table.insert(Fruit_Blacklist, item.Name)
                end
            end
        end
    end
end

-- Find All Fruits in World
local function findAllFruits()
    local fruits = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == workspace then
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

-- Main Loop
task.spawn(function()
    while true do
        local fruits = findAllFruits()
        if #fruits > 0 then
            for _, fruit in pairs(fruits) do
                fruitLabel.Text = "Fruit: " .. fruit.Name
                teleportTo(fruit.Handle.Position)
                task.wait(2.5)
                storeFruit()
                fruitLabel.Text = "Fruit Stored!"
                task.wait(1.5)
            end
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)
