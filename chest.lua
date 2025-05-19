local Demon = {}

function Demon:Create(config)
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui", playerGui)
    gui.Name = "DemonGui"

    local mainFrame = Instance.new("Frame", gui)
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = config.Title or "Demon GUI"
    title.TextSize = 32
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    title.Font = Enum.Font.GothamBold

    local tabBar = Instance.new("Frame", mainFrame)
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.new(0, 0, 0, 60)
    tabBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local contentArea = Instance.new("Frame", mainFrame)
    contentArea.Size = UDim2.new(1, -20, 1, -110)
    contentArea.Position = UDim2.new(0, 10, 0, 100)
    contentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true

    local currentContent = {}

    local function clearContent()
        for _, v in ipairs(currentContent) do
            v:Destroy()
        end
        currentContent = {}
    end

    for i, tab in ipairs(config.Tabs or {}) do
        local tabButton = Instance.new("TextButton", tabBar)
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.Position = UDim2.new(0, (i - 1) * 110 + 10, 0, 0)
        tabButton.Text = tab.Name
        tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 22

        tabButton.MouseButton1Click:Connect(function()
            clearContent()

            local y = 10
            for _, btnData in ipairs(tab.Buttons or {}) do
                local button = Instance.new("TextButton", contentArea)
                button.Size = UDim2.new(0, 250, 0, 50)
                button.Position = UDim2.new(0, 10, 0, y)
                button.Text = btnData.Name
                button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
                button.TextColor3 = Color3.new(1, 1, 1)
                button.Font = Enum.Font.Gotham
                button.TextSize = 28
                button.MouseButton1Click:Connect(btnData.Callback)
                table.insert(currentContent, button)
                y = y + 60
            end

            for _, toggleData in ipairs(tab.Toggles or {}) do
                local toggle = Instance.new("TextButton", contentArea)
                toggle.Size = UDim2.new(0, 250, 0, 50)
                toggle.Position = UDim2.new(0, 270, 0, y)
                toggle.TextSize = 28
                toggle.Font = Enum.Font.Gotham
                toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                toggle.TextColor3 = Color3.new(1, 1, 1)

                local state = toggleData.Default or false
                toggle.Text = toggleData.Name .. ": " .. (state and "ON" or "OFF")

                toggle.MouseButton1Click:Connect(function()
                    state = not state
                    toggle.Text = toggleData.Name .. ": " .. (state and "ON" or "OFF")
                    toggleData.Callback(state)
                end)

                table.insert(currentContent, toggle)
                y = y + 60
            end
        end)

        if i == 1 then
            tabButton:Activate()
            tabButton:MouseButton1Click()
        end
    end
end

return Demon
