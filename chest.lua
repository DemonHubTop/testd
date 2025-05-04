-- SETUP JOIN TEAM DARI GETGENV
local join = (getgenv and getgenv().join) or "Pirates"

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local found = false
local lastFruitPosition = nil
local tried = {}

-- WAIT UNTIL GAME + REMOTES READY
repeat task.wait() until game:IsLoaded()
repeat task.wait() until ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
repeat task.wait() until player.PlayerGui:FindFirstChild("Main")

-- AUTO TEAM JOIN
if player.Team == nil and game:GetService("Teams"):FindFirstChild(join) then
    local success = pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", join)
    end)
end
repeat task.wait() until player.Team ~= nil

-- GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "DemonHubFruitFinder"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 300, 0, 140)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0

    local title = Instance.new("TextLabel", mainFrame)
    title.Text = "DEMONHUB | FRUIT FINDER"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true

    local fruitLabel = Instance.new("TextLabel", mainFrame)
    fruitLabel.Name = "FruitLabel"
    fruitLabel.Text = "Fruit: None"
    fruitLabel.Position = UDim2.new(0, 10, 0, 40)
    fruitLabel.Size = UDim2.new(1, -20, 0, 25)
    fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fruitLabel.Font = Enum.Font.Gotham
    fruitLabel.TextSize = 18
    fruitLabel.TextXAlignment = Enum.TextXAlignment.Left
    fruitLabel.BackgroundTransparency = 1

    local avatar = Instance.new("ImageLabel", mainFrame)
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 10, 1, -50)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"

    local nameLabel = Instance.new("TextLabel", mainFrame)
    nameLabel.Text = player.Name
    nameLabel.Position = UDim2.new(0, 60, 1, -40)
    nameLabel.Size = UDim2.new(0, 200, 0, 20)
    nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 16
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.BackgroundTransparency = 1

    local effectLabel = Instance.new("TextLabel", mainFrame)
    effectLabel.Text = "Fruit Finder Activated!"
    effectLabel.Size = UDim2.new(1, 0, 0, 25)
    effectLabel.Position = UDim2.new(0, 0, 0, 15)
    effectLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    effectLabel.Font = Enum.Font.GothamBold
    effectLabel.TextScaled = true
    effectLabel.BackgroundTransparency = 1
    effectLabel.TextTransparency = 1

    task.spawn(function()
        for i = 1, 0, -0.1 do
            effectLabel.TextTransparency = i
            task.wait(0.03)
        end
        task.wait(1.5)
        for i = 0, 1, 0.1 do
            effectLabel.TextTransparency = i
            task.wait(0.03)
        end
        effectLabel:Destroy()
    end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local found = false
local lastFruitPosition = nil

-- Join Team
task.spawn(function()
    local chosen = tostring(getgenv().join or "")
    repeat
        for _, v in pairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("TextButton") and string.lower(v.Text) == string.lower(chosen) then
                v:Click()
            end
        end
        task.wait(1)
    until player.Team and player.Team.Name == chosen
end)

-- GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "DemonHubFruitFinder"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 300, 0, 160)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local title = Instance.new("TextLabel", mainFrame)
    title.Text = "DEMONHUB | FRUIT FINDER"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true

    local fruitLabel = Instance.new("TextLabel", mainFrame)
    fruitLabel.Name = "FruitLabel"
    fruitLabel.Text = "Fruit: None"
    fruitLabel.Position = UDim2.new(0, 10, 0, 40)
    fruitLabel.Size = UDim2.new(1, -20, 0, 25)
    fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fruitLabel.Font = Enum.Font.Gotham
    fruitLabel.TextSize = 18
    fruitLabel.TextXAlignment = Enum.TextXAlignment.Left
    fruitLabel.BackgroundTransparency = 1

    local exp = Instance.new("TextLabel", mainFrame)
    exp.Name = "EXP"
    exp.Text = "Fruit Finder Active"
    exp.Size = UDim2.new(1, -20, 0, 20)
    exp.Position = UDim2.new(0, 10, 0, 70)
    exp.TextColor3 = Color3.new(1, 1, 1)
    exp.Font = Enum.Font.Gotham
    exp.TextSize = 14
    exp.BackgroundTransparency = 1
    exp.TextXAlignment = Enum.TextXAlignment.Left

    local avatar = Instance.new("ImageLabel", mainFrame)
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 10, 1, -50)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"

    local nameLabel = Instance.new("TextLabel", mainFrame)
    nameLabel.Text = player.Name
    nameLabel.Position = UDim2.new(0, 60, 1, -40)
    nameLabel.Size = UDim2.new(0, 200, 0, 20)
    nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 16
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.BackgroundTransparency = 1

    return fruitLabel
end

local fruitLabel = createGUI()

-- Functions
local function teleportToPosition(pos)
    character = player.Character or player.CharacterAdded:Wait()
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
end

local function findFruit()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == workspace then
            return obj
        end
    end
    return nil
end

local tried = {}
local function serverHop()
    local gameId, jobId = game.PlaceId, game.JobId
    local function getServerList()
        local cursor = ""
        local servers = {}

        repeat
            local url = "https://games.roblox.com/v1/games/"..gameId.."/servers/Public?sortOrder=2&limit=100"..(cursor ~= "" and "&cursor="..cursor or "")
            local body = HttpService:JSONDecode(game:HttpGet(url))
            for _, v in pairs(body.data) do
                if v.playing < v.maxPlayers and v.id ~= jobId and not tried[v.id] then
                    table.insert(servers, v.id)
                end
            end
            cursor = body.nextPageCursor
        until not cursor or #servers >= 5

        return servers
    end

    local servers = getServerList()
    if #servers > 0 then
        local target = servers[math.random(1, #servers)]
        tried[target] = true
        TeleportService:TeleportToPlaceInstance(gameId, target, player)
    else
        task.wait(5)
        serverHop()
    end
end

local function storeFruit(fruitName)
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", fruitName)
    end)
end

local function sendWebhook(fruitName)
    if not getgenv().webhook or getgenv().webhook == "" then return end

    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Fruit Collected!",
            ["color"] = 65280,
            ["fields"] = {{
                ["name"] = "Fruit:",
                ["value"] = fruitName,
                ["inline"] = false
            }},
            ["footer"] = {["text"] = "DemonHub | Fruit Finder"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    pcall(function()
        HttpService:PostAsync(getgenv().webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

-- Main Loop
task.spawn(function()
    while true do
        if found then break end

        local fruit = findFruit()
        if fruit then
            lastFruitPosition = fruit.Handle.Position
            fruitLabel.Text = "Fruit: " .. fruit.Name
            teleportToPosition(lastFruitPosition)
            task.wait(1)

            local dist = (humanoidRootPart.Position - lastFruitPosition).Magnitude
            if dist < 10 and not findFruit() then
                storeFruit(fruit.Name)
                sendWebhook(fruit.Name)
                fruitLabel.Text = "Fruit: Stored"
                found = true
                task.wait(3)
                found = false
            end
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            serverHop()
        end

        task.wait(2)
    end
end)

-- On Respawn
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    if lastFruitPosition and not found then
        teleportToPosition(lastFruitPosition)
    end
end)
