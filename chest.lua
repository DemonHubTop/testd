local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local joinTeam = getgenv().join or "Pirates"
local webhook = getgenv().webhook or ""
local Fruit_BlackList = {}
getgenv().AutoStoreFruits = true

-- Auto Join Team
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", joinTeam)
end)

-- GUI
local function createGUI()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "DemonHubGUI"

    local frame = Instance.new("Frame", gui)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.Size = UDim2.new(0, 300, 0, 120)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local title = Instance.new("TextLabel", frame)
    title.Text = "DemonHub | Fruit Finder"
    title.Size = UDim2.new(1, 0, 0, 25)
    title.TextColor3 = Color3.fromRGB(255, 80, 80)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.BackgroundTransparency = 1

    local fruitLabel = Instance.new("TextLabel", frame)
    fruitLabel.Name = "FruitLabel"
    fruitLabel.Position = UDim2.new(0, 10, 0, 35)
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

-- Find Fruits
local function findFruit()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == workspace then
            return obj
        end
    end
    return nil
end

-- Webhook Log
local function sendWebhook(fruitName)
    if webhook == "" then return end
    local data = {
        ["embeds"] = {{
            ["title"] = "Fruit Detected!",
            ["fields"] = {{
                ["name"] = "Fruit",
                ["value"] = fruitName,
                ["inline"] = true
            }},
            ["color"] = 65280,
            ["footer"] = {["text"] = "DemonHub Fruit Logger"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    local payload = HttpService:JSONEncode(data)
    pcall(function()
        HttpService:PostAsync(webhook, payload, Enum.HttpContentType.ApplicationJson, false)
    end)
end

-- Store Fruits
local function Get_Fruit(name)
    return name:gsub(" ", ""):lower()
end

local function storeFruit()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    local function tryStore(container)
        for _,Fruit in pairs(container:GetChildren()) do
            if not table.find(Fruit_BlackList, Fruit.Name) and Fruit:IsA("Tool") and Fruit:FindFirstChild("Fruit") then
                local success = Remote:InvokeServer("StoreFruit", Get_Fruit(Fruit.Name), Fruit)
                if not success then
                    table.insert(Fruit_BlackList, Fruit.Name)
                end
            end
        end
    end
    if player.Character then tryStore(player.Character) end
    tryStore(player.Backpack)
end

-- Server Hop
local tried = {}
local function hopServer()
    local gameId = game.PlaceId
    local jobId = game.JobId
    local servers = {}
    local cursor = ""

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

-- MAIN LOOP
task.spawn(function()
    while true do
        local fruit = findFruit()
        if fruit then
            fruitLabel.Text = "Fruit: " .. fruit.Name
            teleportTo(fruit.Handle.Position)
            task.wait(2)
            storeFruit()
            sendWebhook(fruit.Name)
            fruitLabel.Text = "Fruit: Stored"
            task.delay(5, function()
                fruitLabel.Text = "Fruit: None"
            end)
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)
