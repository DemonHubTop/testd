local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local joinTeam = getgenv().join or "Pirates"
local webhook = getgenv().webhook or ""

local Fruit_BlackList = {}
local function Get_Fruit(name)
    return name:match("(%w+)%sFruit")
end

-- Auto Join
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", joinTeam)
end)

-- GUI Setup
local function createGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "DemonHub"
    gui.ResetOnSpawn = false
    repeat wait() until player:FindFirstChild("PlayerGui")
    gui.Parent = player.PlayerGui

    local frame = Instance.new("Frame", gui)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local fruitLabel = Instance.new("TextLabel", frame)
    fruitLabel.Position = UDim2.new(0, 10, 0, 10)
    fruitLabel.Size = UDim2.new(1, -20, 0, 20)
    fruitLabel.Text = "Fruit: None"
    fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fruitLabel.Font = Enum.Font.Gotham
    fruitLabel.TextXAlignment = Enum.TextXAlignment.Left
    fruitLabel.BackgroundTransparency = 1

    return fruitLabel
end

local fruitLabel = createGUI()

-- Teleport Bypass
local function bypassTeleport(pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
end

-- Webhook Function
local function sendWebhook(fruitName)
    if webhook == "" then return end

    local data = {
        embeds = {{
            title = "Fruit Found & Stored!",
            color = 65280,
            fields = {
                {name = "Player", value = player.Name},
                {name = "Fruit", value = fruitName},
                {name = "Time", value = os.date("%X")}
            },
            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
            }
        }}
    }

    local headers = {
        ["Content-Type"] = "application/json"
    }

    local success, err = pcall(function()
        HttpService:PostAsync(webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, headers)
    end)

    if not success then warn("Webhook error:", err) end
end

-- Store Fruit
local function storeFruit()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

    for _, src in pairs({player.Backpack, player.Character}) do
        for _, tool in pairs(src:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Fruit") and not table.find(Fruit_BlackList, tool.Name) then
                local success = Remote:InvokeServer("StoreFruit", Get_Fruit(tool.Name), tool)
                if success == true then
                    sendWebhook(tool.Name)
                else
                    table.insert(Fruit_BlackList, tool.Name)
                end
            end
        end
    end
end

-- Find Fruit
local function findFruit()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == Workspace then
            return obj
        end
    end
    return nil
end

-- Server Hop
local tried = {}
local function hopServer()
    local gameId, jobId = game.PlaceId, game.JobId
    local cursor, servers = "", {}

    repeat
        local url = "https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=2&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local res = HttpService:JSONDecode(game:HttpGet(url))
        for _, v in pairs(res.data) do
            if v.playing < v.maxPlayers and v.id ~= jobId and not tried[v.id] then
                table.insert(servers, v.id)
            end
        end
        cursor = res.nextPageCursor
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

-- Loop
task.spawn(function()
    while true do
        local fruit = findFruit()
        if fruit then
            fruitLabel.Text = "Fruit: " .. fruit.Name
            bypassTeleport(fruit.Handle.Position)
            task.wait(2.5)
            storeFruit()
            fruitLabel.Text = "Fruit: Stored"
            task.wait(2)
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)
