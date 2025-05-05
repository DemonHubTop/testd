local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local joinTeam = getgenv().join or "Pirates"
local webhook = getgenv().webhook or nil
local tried = {}

-- 🔁 Auto Join Team
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", joinTeam)
end)

-- ✅ GUI Setup
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
    fruitLabel.Name = "FruitLabel"

    return fruitLabel
end

local fruitLabel = createGUI()

-- ✨ Webhook Logger
local function sendWebhook(fruitName)
    if webhook and string.find(webhook, "discord.com/api/webhooks") then
        local data = {
            ["embeds"] = {{
                ["title"] = "DemonHub | Fruit Collected",
                ["color"] = 65280,
                ["fields"] = {
                    {["name"] = "Fruit:", ["value"] = fruitName},
                    {["name"] = "Player:", ["value"] = player.Name}
                },
                ["footer"] = {["text"] = "Fruit Finder - DemonHub"}
            }}
        }

        local req = syn and syn.request or http_request or request or (http and http.request)
        if req then
            pcall(function()
                req({
                    Url = webhook,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(data)
                })
            end)
        else
            warn("Executor tidak mendukung Webhook.")
        end
    end
end

-- ✅ Teleport
local function teleportTo(pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
end

-- ✅ Store All Fruit
local Fruit_Blacklist = {}
local function getFruitType(name)
    local fruitType = string.match(name, "^(.-) Fruit")
    return fruitType or name
end

local function storeAllFruit()
    local Remote = ReplicatedStorage:WaitForChild("Remotes", 9e9):WaitForChild("CommF_", 9e9)
    local bag = player.Backpack
    local char = player.Character

    for _, v in ipairs((char and char:GetChildren()) or {}) do
        if v:IsA("Tool") and v:FindFirstChild("Fruit") and not table.find(Fruit_Blacklist, v.Name) then
            local result = Remote:InvokeServer("StoreFruit", getFruitType(v.Name), v)
            if result ~= true then
                table.insert(Fruit_Blacklist, v.Name)
            end
        end
    end

    for _, v in ipairs(bag:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Fruit") and not table.find(Fruit_Blacklist, v.Name) then
            local result = Remote:InvokeServer("StoreFruit", getFruitType(v.Name), v)
            if result ~= true then
                table.insert(Fruit_Blacklist, v.Name)
            end
        end
    end
end

-- 🔍 Find Fruit
local function findAllFruits()
    local found = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == workspace then
            table.insert(found, obj)
        end
    end
    return found
end

-- 🌐 Server Hop
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

-- 🔁 MAIN LOOP
task.spawn(function()
    while true do
        local fruits = findAllFruits()
        if #fruits > 0 then
            for _, fruit in ipairs(fruits) do
                fruitLabel.Text = "Fruit: " .. fruit.Name
                teleportTo(fruit.Handle.Position)
                task.wait(1.8)
                storeAllFruit()
                fruitLabel.Text = "Stored: " .. fruit.Name
                sendWebhook(fruit.Name)
                task.wait(2)
            end
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)
