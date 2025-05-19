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
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = config.Title or "Demon GUI"
    title.TextSize = 30
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    title.Font = Enum.Font.GothamBold

    local tabContainer = Instance.new("Frame", mainFrame)
    tabContainer.Size = UDim2.new(0, 100, 1, -50)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

    local contentArea = Instance.new("Frame", mainFrame)
    contentArea.Size = UDim2.new(1, -100, 1, -50)
    contentArea.Position = UDim2.new(0, 100, 0, 50)
    contentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentArea.ClipsDescendants = true
    contentArea.BorderSizePixel = 0

    local currentContent = {}

    local function clearContent()
        for _, v in ipairs(currentContent) do
            v:Destroy()
        end
        currentContent = {}
    end

    local totalTabs = #config.Tabs
    for i, tab in ipairs(config.Tabs or {}) do
        local tabButton = Instance.new("TextButton", tabContainer)
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Position = UDim2.new(0, 5, 1, -50 * (totalTabs - i + 1) - 10)
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
                button.Size = UDim2.new(0, 200, 0, 40)
                button.Position = UDim2.new(0, 10, 0, y)
                button.Text = btnData.Name
                button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
                button.TextColor3 = Color3.new(1, 1, 1)
                button.Font = Enum.Font.Gotham
                button.TextSize = 24
                button.MouseButton1Click:Connect(btnData.Callback)
                table.insert(currentContent, button)
                y = y + 50
            end

            for _, toggleData in ipairs(tab.Toggles or {}) do
                local toggle = Instance.new("TextButton", contentArea)
                toggle.Size = UDim2.new(0, 200, 0, 40)
                toggle.Position = UDim2.new(0, 220, 0, y)
                toggle.Font = Enum.Font.Gotham
                toggle.TextSize = 24
                toggle.TextColor3 = Color3.new(1, 1, 1)

                local state = toggleData.Default or false
                local function updateVisual()
                    toggle.Text = toggleData.Name .. ": " .. (state and "✅" or "❌")
                    toggle.BackgroundColor3 = state and Color3.fromRGB(60, 180, 75) or Color3.fromRGB(200, 60, 60)
                end
                updateVisual()

                toggle.MouseButton1Click:Connect(function()
                    state = not state
                    updateVisual()
                    toggleData.Callback(state)
                end)

                table.insert(currentContent, toggle)
                y = y + 50
            end
        end)

        if i == 1 then
            tabButton:MouseButton1Click()
        end
    end
end

return Demon
