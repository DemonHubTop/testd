local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DdmonCustomGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Size = UDim2.new(0, 600, 0, 420)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.ClipsDescendants = true

local titleLabel = Instance.new("TextLabel", MainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = config.Title .. " - " .. config.SubTitle
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextSize = 18

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.Size = UDim2.new(0, 150, 1, -30)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local UIListLayout = Instance.new("UIListLayout", Sidebar)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local ContentFrames = {}
local function switchTab(tabTitle)
    for title, frame in pairs(ContentFrames) do
        frame.Visible = (title == tabTitle)
    end
end

for _, tab in ipairs(config.Tabs) do
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = tab.Title
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14

    local frame = Instance.new("Frame", MainFrame)
    frame.Name = tab.Title
    frame.Position = UDim2.new(0, 160, 0, 40)
    frame.Size = UDim2.new(1, -170, 1, -50)
    frame.BackgroundTransparency = 1
    frame.Visible = false

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    ContentFrames[tab.Title] = frame

    for _, element in ipairs(tab.Elements or {}) do
        if element.Type == "Paragraph" then
            local para = Instance.new("TextLabel", frame)
            para.Text = element.Title .. "\n" .. element.Content
            para.TextWrapped = true
            para.BackgroundTransparency = 1
            para.TextColor3 = Color3.fromRGB(200, 200, 200)
            para.Size = UDim2.new(1, 0, 0, 50)
            para.Font = Enum.Font.Gotham
            para.TextSize = 14

        elseif element.Type == "Button" then
            local btn = Instance.new("TextButton", frame)
            btn.Text = element.Title
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.MouseButton1Click:Connect(function()
                if element.Callback then
                    element.Callback()
                end
            end)

        elseif element.Type == "Toggle" then
            local toggle = Instance.new("TextButton", frame)
            toggle.Size = UDim2.new(1, 0, 0, 30)
            toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.Font = Enum.Font.Gotham
            toggle.TextSize = 14
            local state = element.Default or false
            toggle.Text = element.Title .. " [" .. (state and "ON" or "OFF") .. "]"
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = element.Title .. " [" .. (state and "ON" or "OFF") .. "]"
                if element.Callback then
                    element.Callback(state)
                end
            end)
        end
    end

    btn.MouseButton1Click:Connect(function()
        switchTab(tab.Title)
    end)
end

switchTab(config.Tabs[1].Title) -- Show first tab
