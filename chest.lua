-- CONTENT
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0, 0, 0, 45)
content.Size = UDim2.new(1, 0, 1, -45)
content.BackgroundTransparency = 1

-- Layout biar rapi
local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 12)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Tab Label
local tab1 = Instance.new("TextLabel", content)
tab1.Text = "Tab 1"
tab1.Size = UDim2.new(1, -20, 0, 20)
tab1.TextColor3 = Color3.new(1, 1, 1)
tab1.Font = Enum.Font.Gotham
tab1.TextSize = 14
tab1.BackgroundTransparency = 1
tab1.LayoutOrder = 0
tab1.Position = UDim2.new(0, 10, 0, 0)

-- TextBox Label + Box Container
local boxContainer = Instance.new("Frame", content)
boxContainer.Size = UDim2.new(1, -20, 0, 50)
boxContainer.BackgroundTransparency = 1
boxContainer.LayoutOrder = 1

local labelBox = Instance.new("TextLabel", boxContainer)
labelBox.Text = "Text Box"
labelBox.Size = UDim2.new(0, 100, 1, 0)
labelBox.Position = UDim2.new(0, 0, 0, 0)
labelBox.BackgroundTransparency = 1
labelBox.TextColor3 = Color3.new(1, 1, 1)
labelBox.Font = Enum.Font.Gotham
labelBox.TextSize = 14
labelBox.TextXAlignment = Enum.TextXAlignment.Left

local box = Instance.new("TextBox", boxContainer)
box.Position = UDim2.new(0, 110, 0, 0)
box.Size = UDim2.new(0, 220, 0, 28)
box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
box.TextColor3 = Color3.new(1, 1, 1)
box.PlaceholderText = "Ketik sesuatu..."
box.Font = Enum.Font.Gotham
box.TextSize = 14
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

-- TOGGLE
local toggleContainer = Instance.new("Frame", content)
toggleContainer.Size = UDim2.new(1, -20, 0, 32)
toggleContainer.BackgroundTransparency = 1
toggleContainer.LayoutOrder = 2

local toggleLabel = Instance.new("TextLabel", toggleContainer)
toggleLabel.Text = "Toggle"
toggleLabel.Size = UDim2.new(0, 100, 1, 0)
toggleLabel.Position = UDim2.new(0, 0, 0, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.TextColor3 = Color3.new(1, 1, 1)
toggleLabel.Font = Enum.Font.Gotham
toggleLabel.TextSize = 14
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

local toggleBtn = Instance.new("TextButton", toggleContainer)
toggleBtn.Position = UDim2.new(0, 110, 0, 4)
toggleBtn.Size = UDim2.new(0, 50, 0, 24)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = ""
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

local toggleCircle = Instance.new("Frame", toggleBtn)
toggleCircle.Size = UDim2.new(0.5, -2, 1, -4)
toggleCircle.Position = UDim2.new(0, 2, 0, 2)
toggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)

local isToggle = false
toggleBtn.MouseButton1Click:Connect(function()
	isToggle = not isToggle
	toggleBtn.BackgroundColor3 = isToggle and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
	toggleCircle:TweenPosition(isToggle and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2), "Out", "Sine", 0.2)
end)

-- BUTTON
local powerBtn = Instance.new("TextButton", content)
powerBtn.Size = UDim2.new(0, 40, 0, 40)
powerBtn.Text = "⏻"
powerBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
powerBtn.TextColor3 = Color3.new(1, 1, 1)
powerBtn.Font = Enum.Font.GothamBold
powerBtn.TextSize = 22
powerBtn.LayoutOrder = 3
Instance.new("UICorner", powerBtn).CornerRadius = UDim.new(1, 0)
powerBtn.MouseButton1Click:Connect(function()
	print("Power button clicked!")
end)
