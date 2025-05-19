local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Demon = {}

function Demon:Create(config)
    local player = game:GetService("Players").LocalPlayer
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "DemonHubUI"
    gui.ResetOnSpawn = false

    -- Main Window
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 650, 0, 400)
    main.Position = UDim2.new(0.5, -325, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.BackgroundTransparency = 0.1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true

    local UICorner = Instance.new("UICorner", main)
    UICorner.CornerRadius = UDim.new(0, 8)

    -- Title
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "Demon Hub"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Sidebar
    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, 150, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

    -- Content Area
    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -150, 1, -40)
    content.Position = UDim2.new(0, 150, 0, 40)
    content.BackgroundTransparency = 1

    local currentElements = {}

    local function clearContent()
        for _, v in ipairs(currentElements) do
            v:Destroy()
        end
        currentElements = {}
    end

    local function createTabButton(tab, index)
        local tabBtn = Instance.new("TextButton", sidebar)
        tabBtn.Size = UDim2.new(1, -20, 0, 40)
        tabBtn.Position = UDim2.new(0, 10, 0, 10 + (index - 1) * 50)
        tabBtn.Text = tab.Name
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 18
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

        tabBtn.MouseButton1Click:Connect(function()
            clearContent()

            local y = 10
            for _, item in ipairs(tab.Items or {}) do
                if item.Type == "Paragraph" then
                    local para = Instance.new("TextLabel", content)
                    para.Text = item.Title .. "\n" .. item.Content
                    para.Size = UDim2.new(1, -20, 0, 60)
                    para.Position = UDim2.new(0, 10, 0, y)
                    para.TextWrapped = true
                    para.TextXAlignment = Enum.TextXAlignment.Left
                    para.TextYAlignment = Enum.TextYAlignment.Top
                    para.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    para.TextColor3 = Color3.fromRGB(255, 255, 255)
                    para.Font = Enum.Font.Gotham
                    para.TextSize = 16
                    Instance.new("UICorner", para).CornerRadius = UDim.new(0, 6)
                    table.insert(currentElements, para)
                    y += 70
                elseif item.Type == "Button" then
                    local btn = Instance.new("TextButton", content)
                    btn.Text = item.Name
                    btn.Size = UDim2.new(1, -20, 0, 40)
                    btn.Position = UDim2.new(0, 10, 0, y)
                    btn.Font = Enum.Font.GothamBold
                    btn.TextSize = 18
                    btn.TextColor3 = Color3.new(1,1,1)
                    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                    btn.MouseButton1Click:Connect(item.Callback)
                    table.insert(currentElements, btn)
                    y += 50
                elseif item.Type == "Toggle" then
                    local toggle = Instance.new("TextButton", content)
                    toggle.Size = UDim2.new(1, -20, 0, 40)
                    toggle.Position = UDim2.new(0, 10, 0, y)
                    toggle.Font = Enum.Font.Gotham
                    toggle.TextSize = 18
                    local state = item.Default or false
                    local function update()
                        toggle.Text = item.Name .. ": " .. (state and "✅" or "❌")
                        toggle.BackgroundColor3 = state and Color3.fromRGB(60,180,75) or Color3.fromRGB(180,60,60)
                        toggle.TextColor3 = Color3.new(1,1,1)
                    end
                    update()
                    toggle.MouseButton1Click:Connect(function()
                        state = not state
                        update()
                        item.Callback(state)
                    end)
                    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)
                    table.insert(currentElements, toggle)
                    y += 50
                end
            end
        end)

        if index == 1 then
            tabBtn:MouseButton1Click()
        end
    end

    for i, tab in ipairs(config.Tabs or {}) do
        createTabButton(tab, i)
    end
end

return Demon
