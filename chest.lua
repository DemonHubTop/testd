--[[  
🧠 DemonHub Fruit Finder FINAL VERSION
Usage:
getgenv().join = "Pirates" -- or "Marines"
getgenv().webhook = "https://yourwebhook.com"
loadstring(game:HttpGet("https://yourlink.lua"))()
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local joinTeam = getgenv().join or "Pirates"
local webhook = getgenv().webhook or ""
local triedServers, storedFruits = {}, {}

-- Join Team
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", joinTeam)
end)

-- GUI
local function createGUI()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "DemonHub"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 130)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local title = Instance.new("TextLabel", frame)
    title.Text = "DEMONHUB | FRUIT FINDER"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.BackgroundTransparency = 1

    local fruitLabel = Instance.new("TextLabel", frame)
    fruitLabel.Position = UDim2.new(0, 10, 0, 40)
    fruitLabel.Size = UDim2.new(1, -20, 0, 20)
    fruitLabel.TextColor3 = Color3.new(1, 1, 1)
    fruitLabel.Text = "Fruit: None"
    fruitLabel.Font = Enum.Font.Gotham
    fruitLabel.TextXAlignment = Enum.TextXAlignment.Left
    fruitLabel.BackgroundTransparency = 1

    local avatar = Instance.new("ImageLabel", frame)
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 10, 1, -50)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"

    local name = Instance.new("TextLabel", frame)
    name.Position = UDim2.new(0, 60, 1, -40)
    name.Size = UDim2.new(0, 200, 0, 20)
    name.Text = player.Name
    name.TextColor3 = Color3.fromRGB(200, 200, 200)
    name.Font = Enum.Font.Gotham
    name.TextSize = 16
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.BackgroundTransparency = 1

    return fruitLabel
end

local fruitLabel = createGUI()

-- Teleport
local function teleportTo(pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
end

-- Auto Store
local function storeFruit()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    local function get(fruit)
        return fruit:FindFirstChild("Fruit") and fruit or nil
    end
    for _, container in ipairs({player.Character, player.Backpack}) do
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and get(item) and not storedFruits[item.Name] then
                local result = Remote:InvokeServer("StoreFruit", item.Name)
                if result == true then
                    storedFruits[item.Name] = true
                    return item.Name
                end
            end
        end
    end
end

-- Webhook Log
local function sendWebhook(fruitName)
    if webhook == "" then return end
    pcall(function()
        local data = {
            ["embeds"] = {{
                ["title"] = "**Fruit Collected!**",
                ["color"] = 65280,
                ["fields"] = {
                    {["name"] = "Fruit", ["value"] = fruitName}
                },
                ["footer"] = {
                    ["text"] = os.date("Time: %X")
                }
            }}
        }
        HttpService:PostAsync(webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

-- Find All Fruits
local function getAllFruits()
    local fruits = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == workspace then
            table.insert(fruits, obj)
        end
    end
    return fruits
end

-- Server Hop
local function hopServer()
    local gameId, jobId = game.PlaceId, game.JobId
    local cursor, servers = "", {}
    repeat
        local url = "https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=2&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local response = HttpService:JSONDecode(game:HttpGet(url))
        for _, v in pairs(response.data) do
            if v.playing < v.maxPlayers and v.id ~= jobId and not triedServers[v.id] then
                table.insert(servers, v.id)
            end
        end
        cursor = response.nextPageCursor
    until not cursor or #servers >= 5
    if #servers > 0 then
        local target = servers[math.random(1, #servers)]
        triedServers[target] = true
        TeleportService:TeleportToPlaceInstance(gameId, target, player)
    else
        task.wait(5)
        hopServer()
    end
end

-- Main
task.spawn(function()
    while true do
        local fruits = getAllFruits()
        if #fruits > 0 then
            for _, fruit in ipairs(fruits) do
                if not storedFruits[fruit.Name] then
                    fruitLabel.Text = "Fruit: " .. fruit.Name
                    teleportTo(fruit.Handle.Position)
                    task.wait(2)
                    local stored = storeFruit()
                    if stored then
                        sendWebhook(stored)
                        fruitLabel.Text = "Fruit: Stored"
                        task.wait(1.5)
                    end
                end
            end
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)

-- On Death: Teleport again
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if gui and not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end
end)local Players = game:GetService("Players")
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
