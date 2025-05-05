--[[  
🧠 DemonHub Fruit Finder | FINAL FIXED VERSION
Usage:
getgenv().join = "Pirates" -- or "Marines"
getgenv().webhook = "https://your-webhook-url.com"
loadstring(game:HttpGet("https://your-link.lua"))()
--]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Variables
local Player = Players.LocalPlayer
local joinTeam = getgenv().join or "Pirates"
local webhookUrl = getgenv().webhook or ""
local triedServers = {}
local Fruit_BlackList = {}

-- Join Team
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", joinTeam)
end)

-- GUI
local function createGUI()
    local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
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

    local expLabel = Instance.new("TextLabel", frame)
    expLabel.Position = UDim2.new(0, 10, 0, 65)
    expLabel.Size = UDim2.new(1, -20, 0, 20)
    expLabel.Text = "EXP MODE"
    expLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    expLabel.Font = Enum.Font.Gotham
    expLabel.TextSize = 14
    expLabel.TextXAlignment = Enum.TextXAlignment.Left
    expLabel.BackgroundTransparency = 1

    local avatar = Instance.new("ImageLabel", frame)
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 10, 1, -50)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=150&h=150"

    local username = Instance.new("TextLabel", frame)
    username.Position = UDim2.new(0, 60, 1, -40)
    username.Size = UDim2.new(0, 200, 0, 20)
    username.Text = Player.Name
    username.TextColor3 = Color3.fromRGB(200, 200, 200)
    username.Font = Enum.Font.Gotham
    username.TextSize = 16
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.BackgroundTransparency = 1

    return fruitLabel
end

local fruitLabel = createGUI()

-- Teleport
local function teleportTo(pos)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
end

-- Auto Store Fruit
local function Get_Fruit(fruitName)
    return fruitName
end

local function storeFruit()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

    for _, loc in pairs({Player.Character, Player.Backpack}) do
        for _, fruit in pairs(loc:GetChildren()) do
            if fruit:IsA("Tool") and fruit:FindFirstChild("Fruit") and not table.find(Fruit_BlackList, fruit.Name) then
                if Remote:InvokeServer("StoreFruit", Get_Fruit(fruit.Name), fruit) ~= true then
                    table.insert(Fruit_BlackList, fruit.Name)
                end
            end
        end
    end
end

-- Find Fruit
local function findFruit()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == workspace then
            return obj
        end
    end
    return nil
end

-- Webhook
local function sendWebhook(fruitName)
    if webhookUrl == "" then return end

    local data = {
        ["embeds"] = {{
            ["title"] = "Fruit Detected!",
            ["fields"] = {
                {["name"] = "Fruit", ["value"] = fruitName, ["inline"] = true},
                {["name"] = "Player", ["value"] = Player.Name, ["inline"] = true}
            },
            ["thumbnail"] = {
                ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..Player.UserId.."&width=420&height=420&format=png"
            },
            ["color"] = 65280
        }}
    }

    local json = HttpService:JSONEncode(data)
    pcall(function()
        HttpService:PostAsync(webhookUrl, json, Enum.HttpContentType.ApplicationJson)
    end)
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
            if v.playing < v.maxPlayers and v.id ~= jobId and not triedServers[v.id] then
                table.insert(servers, v.id)
            end
        end
        cursor = response.nextPageCursor
    until not cursor or #servers >= 5

    if #servers > 0 then
        local pick = servers[math.random(1, #servers)]
        triedServers[pick] = true
        TeleportService:TeleportToPlaceInstance(gameId, pick, Player)
    else
        task.wait(5)
        hopServer()
    end
end

-- Main Loop
task.spawn(function()
    while true do
        local fruit = findFruit()
        if fruit and fruit.Parent == workspace then
            local handle = fruit:FindFirstChild("Handle") or fruit:WaitForChild("Handle", 3)
            if handle then
                fruitLabel.Text = "Fruit: " .. fruit.Name
                teleportTo(handle.Position)
                task.wait(2.5)
                storeFruit()
                fruitLabel.Text = "Fruit: Stored"
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
