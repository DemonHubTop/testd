
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local joinTeam = getgenv().join or "Pirates"
local webhookUrl = getgenv().webhook or ""
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- ✅ Auto Join Team
pcall(function()
    CommF_:InvokeServer("SetTeam", joinTeam)
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

-- ✅ Teleport
local function teleportTo(pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
end

-- ✅ Store Fruit
local function storeFruit(tool)
    if tool:IsA("Tool") and tool:FindFirstChild("Fruit") then
        CommF_:InvokeServer("StoreFruit", tool.Name, tool)
    end
end

local function storeAllFruits()
    for _, tool in pairs(player.Backpack:GetChildren()) do
        storeFruit(tool)
    end
    for _, tool in pairs(player.Character:GetChildren()) do
        storeFruit(tool)
    end
end

-- ✅ Webhook Log
local function sendWebhook(fruitName)
    if webhookUrl == "" then return end
    local data = {
        ["username"] = "DemonHub",
        ["embeds"] = {{
            ["title"] = "Fruit Collected!",
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
                ["text"] = "DemonHub Logger"
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    local jsonData = HttpService:JSONEncode(data)
    HttpService:PostAsync(webhookUrl, jsonData)
end

-- ✅ Get all fruits
local function getAllFruits()
    local fruits = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Parent == Workspace then
            table.insert(fruits, obj)
        end
    end
    return fruits
end

-- ✅ Main Loop
task.spawn(function()
    while true do
        local foundFruits = getAllFruits()
        if #foundFruits > 0 then
            for _, fruit in pairs(foundFruits) do
                fruitLabel.Text = "Fruit: " .. fruit.Name
                teleportTo(fruit.Handle.Position)
                task.wait(3)
                storeAllFruits()
                sendWebhook(fruit.Name)
                fruitLabel.Text = "Fruit Stored!"
                task.wait(1.5)
            end
        else
            fruitLabel.Text = "Fruit: None"
        end
        task.wait(10)
    end
end)
