local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local webhook = getgenv().webhook or ""
local joinTeam = getgenv().join or "Pirates"
local fruitLabel
local triedServers = {}

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
    frame.Size = UDim2.new(0, 300, 0, 110)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local title = Instance.new("TextLabel", frame)
    title.Text = "DEMONHUB | FRUIT FINDER"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true

    fruitLabel = Instance.new("TextLabel", frame)
    fruitLabel.Position = UDim2.new(0, 10, 0, 35)
    fruitLabel.Size = UDim2.new(1, -20, 0, 25)
    fruitLabel.Text = "Fruit: None"
    fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fruitLabel.Font = Enum.Font.GothamBold
    fruitLabel.TextSize = 20
    fruitLabel.TextXAlignment = Enum.TextXAlignment.Left
    fruitLabel.BackgroundTransparency = 1

    local avatar = Instance.new("ImageLabel", frame)
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 10, 1, -45)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"

    local username = Instance.new("TextLabel", frame)
    username.Position = UDim2.new(0, 60, 1, -35)
    username.Size = UDim2.new(0, 200, 0, 20)
    username.Text = player.Name
    username.TextColor3 = Color3.fromRGB(200, 200, 200)
    username.Font = Enum.Font.Gotham
    username.TextSize = 16
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.BackgroundTransparency = 1
end

createGUI()

-- Webhook kirim saat teleport
local function sendWebhook(fruitName)
    if webhook == "" or not string.find(webhook, "http") then return end
    local payload = {
        ["embeds"] = {{
            ["title"] = "Fruit Detected!",
            ["color"] = 65280,
            ["fields"] = {
                {["name"] = "Fruit", ["value"] = fruitName, ["inline"] = true},
                {["name"] = "Player", ["value"] = player.Name, ["inline"] = true}
            },
            ["thumbnail"] = {
                ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150"
            },
            ["footer"] = {
                ["text"] = "DemonHub | Fruit Finder"
            }
        }}
    }

    local success, err = pcall(function()
        HttpService:RequestAsync({
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payload)
        })
    end)

    if success then
        print("[Webhook] Sent:", fruitName)
    else
        warn("[Webhook] Failed:", err)
    end
end

-- Teleport ke buah
local function teleportTo(position)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    root.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
end

-- Store dari tangan
local function storeFruit()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    local char = player.Character
    if not char then return end

    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Fruit") then
            local success, result = pcall(function()
                return Remote:InvokeServer("StoreFruit", tool.Name, tool)
            end)
            if success and result == true then
                fruitLabel.Text = "Fruit: Stored"
                print("[Store] Success:", tool.Name)
                task.delay(5, function()
                    if fruitLabel.Text == "Fruit: Stored" then
                        fruitLabel.Text = "Fruit: None"
                    end
                end)
            else
                warn("[Store] Failed:", tool.Name)
            end
        end
    end
end

-- Cari buah di world
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
        local pick = servers[math.random(1, #servers)]
        triedServers[pick] = true
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
            sendWebhook(fruit.Name)
            task.wait(3)
            storeFruit()
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)
