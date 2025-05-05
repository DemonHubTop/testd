local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local joinTeam = getgenv().join or "Pirates"
local Webhook = getgenv().webhook or ""
local Fruit_BlackList = {}

-- Auto Join Team
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", joinTeam)
end)

-- GUI
local function createGUI()
    local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
    gui.Name = "DemonHubGUI"

    local frame = Instance.new("Frame", gui)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local fruitLabel = Instance.new("TextLabel", frame)
    fruitLabel.Position = UDim2.new(0, 10, 0, 10)
    fruitLabel.Size = UDim2.new(1, -20, 0, 20)
    fruitLabel.Text = "Fruit: None"
    fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fruitLabel.BackgroundTransparency = 1
    fruitLabel.Font = Enum.Font.Gotham
    fruitLabel.TextXAlignment = Enum.TextXAlignment.Left

    return fruitLabel
end

local fruitLabel = createGUI()

-- Bypass Teleport
local function teleportTo(pos)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
end

-- Get FruitType
local function Get_Fruit(str)
    return str:split("-")[1]
end

-- Webhook Kirim
local function sendWebhook(fruitName)
    if Webhook == "" then return end
    local data = {
        ["embeds"] = {{
            ["title"] = "DemonHub Fruit Found",
            ["color"] = 65280,
            ["fields"] = {
                {["name"] = "Fruit", ["value"] = fruitName, ["inline"] = true},
                {["name"] = "Player", ["value"] = Player.Name, ["inline"] = true}
            },
            ["thumbnail"] = {["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..Player.UserId.."&width=420&height=420"}
        }}
    }
    local body = HttpService:JSONEncode(data)
    pcall(function()
        HttpService:PostAsync(Webhook, body, Enum.HttpContentType.ApplicationJson)
    end)
end

-- Auto Store Fruit
getgenv().AutoStoreFruits = true
task.spawn(function()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    while getgenv().AutoStoreFruits do task.wait()
        local backpack = Player.Backpack:GetChildren()
        local char = Player.Character and Player.Character:GetChildren() or {}
        for _, tool in pairs(table.move(backpack, 1, #backpack, #char + 1, char)) do
            if tool:IsA("Tool") and tool:FindFirstChild("Fruit") and not table.find(Fruit_BlackList, tool.Name) then
                local result = Remote:InvokeServer("StoreFruit", Get_Fruit(tool.Name), tool)
                if result == true then
                    fruitLabel.Text = "Fruit: Stored"
                    sendWebhook(tool.Name)
                    task.delay(5, function()
                        fruitLabel.Text = "Fruit: None"
                    end)
                else
                    table.insert(Fruit_BlackList, tool.Name)
                end
            end
        end
    end
end)

-- Cari Fruit
local function findFruit()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == workspace then
            return obj
        end
    end
    return nil
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
        TeleportService:TeleportToPlaceInstance(gameId, pick, Player)
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
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)
