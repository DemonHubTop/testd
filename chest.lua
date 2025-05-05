-- DemonHub Fruit Finder FINAL
-- Usage: 
-- getgenv().join = "Pirates" or "Marines"
-- getgenv().webhook = "https://discord.com/api/webhooks/..."
-- loadstring(game:HttpGet("URL_KAMU"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer
local joinTeam = getgenv().join or "Pirates"
local webhook = getgenv().webhook
local tried = {}

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

-- Teleport Bypass
local function teleportTo(position)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
end

-- Store Fruit
local function storeFruit()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    for _, inv in pairs({Player.Backpack, Player.Character}) do
        for _, tool in pairs(inv:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                pcall(function()
                    Remote:InvokeServer("StoreFruit", tool.Name)
                end)
            end
        end
    end
end

-- Webhook Logger
local function sendWebhook(fruitName)
    if webhook and fruitName then
        local data = {
            embeds = {{
                title = "Fruit Found!",
                fields = {
                    {name = "Fruit", value = fruitName, inline = true},
                    {name = "Player", value = Player.Name, inline = true}
                },
                color = 65280
            }}
        }
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local body = HttpService:JSONEncode(data)
        HttpService:PostAsync(webhook, body, Enum.HttpContentType.ApplicationJson)
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
        if fruit then
            local name = fruit.Name
            fruitLabel.Text = "Fruit: " .. name
            teleportTo(fruit.Handle.Position)
            task.wait(2)
            storeFruit()
-- DemonHub Fruit Finder FINAL
-- Usage:
-- getgenv().join = "Pirates" -- or "Marines"
-- getgenv().webhook = "https://yourwebhook.com"
-- loadstring(game:HttpGet("https://yoururl.com/script.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local joinTeam = getgenv().join or "Pirates"
local webhook = getgenv().webhook or ""
local tried = {}
local Fruit_BlackList = {}

-- ✅ Join Team
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", joinTeam)
end)

-- ✅ GUI
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

-- ✅ Teleport (Bypass)
local function teleportTo(pos)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
    end
end

-- ✅ Auto Store Fruit
local function storeFruit()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    local bag = player.Backpack
    local char = player.Character

    local function tryStore(tool)
        if not table.find(Fruit_BlackList, tool.Name) and tool:IsA("Tool") and tool:FindFirstChild("Fruit") then
            local result = Remote:InvokeServer("StoreFruit", tool.Name)
            if result ~= true then
                table.insert(Fruit_BlackList, tool.Name)
            end
        end
    end

    for _, tool in pairs(bag:GetChildren()) do tryStore(tool) end
    if char then for _, tool in pairs(char:GetChildren()) do tryStore(tool) end end
end

-- ✅ Webhook Logger
local function sendWebhook(fruitName)
    if webhook == "" then return end
    pcall(function()
        local data = {
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "**DemonHub Fruit Found!**",
                ["color"] = 65280,
                ["fields"] = {
                    {
                        ["name"] = "Fruit",
                        ["value"] = fruitName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player",
                        ["value"] = player.Name,
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "DemonHub | Fruit Finder"
                }
            }}
        }
        local json = HttpService:JSONEncode(data)
        HttpService:PostAsync(webhook, json)
    end)
end

-- ✅ Find Nearest Fruit
local function findFruit()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == Workspace then
            return obj
        end
    end
    return nil
end

-- ✅ Server Hop
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

-- ✅ Main Loop
task.spawn(function()
    while true do
        local fruit = findFruit()
        if fruit then
            fruitLabel.Text = "Fruit: " .. fruit.Name
            teleportTo(fruit.Handle.Position)
            task.wait(2.5)
            storeFruit()
            sendWebhook(fruit.Name)
            fruitLabel.Text = "Fruit: Stored"
            task.wait(3)
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)
