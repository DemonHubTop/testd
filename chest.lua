local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local webhook = getgenv().webhook or ""
local joinTeam = getgenv().join or "Pirates"
local triedServers = {}
local fruitLabel

-- Join team
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", joinTeam)
end)

-- GUI setup
local function createGUI()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "DemonHub"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Name = "MainFrame"
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size = UDim2.new(0, 420, 0, 170)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", frame)
    title.Text = "DEMONHUB | FRUIT FINDER"
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 100, 100)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true

    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)

    local openBtn = Instance.new("TextButton", gui)
    openBtn.Text = "☰"
    openBtn.Size = UDim2.new(0, 35, 0, 35)
    openBtn.Position = UDim2.new(0, 10, 1, -45)
    openBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = 18
    openBtn.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)

    fruitLabel = Instance.new("TextLabel", frame)
    fruitLabel.Position = UDim2.new(0, 10, 0, 45)
    fruitLabel.Size = UDim2.new(1, -20, 0, 25)
    fruitLabel.Text = "Fruit: None"
    fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fruitLabel.Font = Enum.Font.GothamBold
    fruitLabel.TextSize = 20
    fruitLabel.TextXAlignment = Enum.TextXAlignment.Left
    fruitLabel.BackgroundTransparency = 1

    local avatar = Instance.new("ImageLabel", frame)
    avatar.Size = UDim2.new(0, 50, 0, 50)
    avatar.Position = UDim2.new(0, 10, 1, -60)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"

    local username = Instance.new("TextLabel", frame)
    username.Position = UDim2.new(0, 70, 1, -45)
    username.Size = UDim2.new(1, -80, 0, 20)
    username.Text = "User: " .. player.Name
    username.TextColor3 = Color3.fromRGB(200, 200, 200)
    username.Font = Enum.Font.Gotham
    username.TextSize = 16
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.BackgroundTransparency = 1
end

createGUI()

-- Webhook
local function sendWebhook(fruitName)
    if webhook == "" then return end
    local data = {
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
            ["footer"] = {["text"] = "DemonHub | Fruit Finder"}
        }}
    }

    pcall(function()
        HttpService:RequestAsync({
            Url = webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- Teleport
local function teleportTo(pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
end

-- Store dari backpack & tangan
local function storeAllFruits()
    local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    local containers = {
        player.Backpack,
        player.Character or player.CharacterAdded:Wait()
    }

    for _, container in pairs(containers) do
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") and string.find(item.Name, "Fruit") then
                local raw = item.Name
                local short = string.gsub(raw, " Fruit", "")
                local full = short .. "-" .. short
                pcall(function()
                    Remote:InvokeServer("StoreFruit", full, item)
                end)
                fruitLabel.Text = "Fruit: Stored"
                task.delay(5, function()
                    if fruitLabel.Text == "Fruit: Stored" then
                        fruitLabel.Text = "Fruit: None"
                    end
                end)
            end
        end
    end
end

-- Cari buah
local function findFruit()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == Workspace then
            return obj
        end
    end
    return nil
end

-- Server hop
local function hopServer()
    local gameId, jobId = game.PlaceId, game.JobId
    local servers, cursor = {}, ""
    repeat
        local url = "https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=2&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local body = HttpService:JSONDecode(game:HttpGet(url))
        for _, v in ipairs(body.data) do
            if v.playing < v.maxPlayers and v.id ~= jobId and not triedServers[v.id] then
                table.insert(servers, v.id)
            end
        end
        cursor = body.nextPageCursor
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

-- Loop utama
task.spawn(function()
    while true do
        local fruit = findFruit()
        if fruit then
            fruitLabel.Text = "Fruit: " .. fruit.Name
            teleportTo(fruit.Handle.Position)
            sendWebhook(fruit.Name)
            task.wait(3)
            storeAllFruits()
        else
            fruitLabel.Text = "Fruit: None"
            task.wait(10)
            hopServer()
        end
        task.wait(2)
    end
end)
