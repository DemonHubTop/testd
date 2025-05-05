
getgenv().AutoStoreFruits = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local joinTeam = getgenv().join or "Pirates"

-- Auto Join Team
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", joinTeam)
end)

-- GUI
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

-- Bypass Teleport
local function bypassTeleport(pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
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

-- Webhook Notify
local function sendWebhook(fruitName)
    if getgenv().webhook and fruitName then
        local data = {
            ["embeds"] = {{
                ["title"] = "Fruit Found!",
                ["color"] = 65280,
                ["fields"] = {
                    {["name"] = "Fruit", ["value"] = fruitName, ["inline"] = true},
                    {["name"] = "Player", ["value"] = player.Name, ["inline"] = true}
                },
                ["thumbnail"] = {
                    ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
                },
                ["footer"] = {["text"] = "DemonHub | Fruit Finder"}
            }}
        }
        HttpService:PostAsync(getgenv().webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end
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
        task.wait(10)
        TeleportService:TeleportToPlaceInstance(gameId, pick, player)
    else
        task.wait(10)
        hopServer()
    end
end

-- Auto Store Setup
local Remote = ReplicatedStorage:WaitForChild("Remotes", 9e9):WaitForChild("CommF_", 9e9)
local Fruit_BlackList = {}
local function Get_Fruit(name)
    return name:match("(%w+)%sFruit")
end

task.spawn(function()
    while getgenv().AutoStoreFruits do
        task.wait()
        local plrBag = player.Backpack
        local plrChar = player.Character
        if plrChar then
            for _,Fruit in pairs(plrChar:GetChildren()) do
                if not table.find(Fruit_BlackList, Fruit.Name) and Fruit:IsA("Tool") and Fruit:FindFirstChild("Fruit") then
                    if Remote:InvokeServer("StoreFruit", Get_Fruit(Fruit.Name), Fruit) ~= true then
                        table.insert(Fruit_BlackList, Fruit.Name)
                    end
                end
            end
        end
        for _,Fruit in pairs(plrBag:GetChildren()) do
            if not table.find(Fruit_BlackList, Fruit.Name) and Fruit:IsA("Tool") and Fruit:FindFirstChild("Fruit") then
                if Remote:InvokeServer("StoreFruit", Get_Fruit(Fruit.Name), Fruit) ~= true then
                    table.insert(Fruit_BlackList, Fruit.Name)
                end
            end
        end
    end
end)

-- Main Loop
task.spawn(function()
    while true do
        local fruit = findFruit()
        if fruit then
            fruitLabel.Text = "Fruit: " .. fruit.Name
            bypassTeleport(fruit.Handle.Position)
            task.wait(2.5)
            fruitLabel.Text = "Fruit: Stored"
            sendWebhook(fruit.Name)
            task.wait(2)
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)
