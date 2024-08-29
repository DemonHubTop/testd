if not game:IsLoaded() then game.Loaded:Wait() end
local ScreenGui = Instance.new("ScreenGui")
            local Frame = Instance.new("Frame")
            local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
            local UICorner = Instance.new("UICorner")
            local UIListLayout = Instance.new("UIListLayout")
            local TextLabel = Instance.new("TextLabel")
            local TextButton = Instance.new("TextButton")
local TextButton_2 = Instance.new("TextButton")
            local UICorner_2 = Instance.new("UICorner")
 local UICorner_3 = Instance.new("UICorner")

            ScreenGui.Parent = game:GetService("CoreGui");
            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

            Frame.Parent = ScreenGui
            Frame.BackgroundColor3 = Color3.fromRGB(19, 24, 52)
            Frame.Position = UDim2.new(0.5, 0, .5, 0)
            Frame.Size = UDim2.new(.55, 0, .6, 0)
            Frame.AnchorPoint = Vector2.new(.5,.5)

            UIAspectRatioConstraint.Parent = Frame
            UIAspectRatioConstraint.AspectRatio = 2.000

            UICorner.CornerRadius = UDim.new(0, 15)
            UICorner.Parent = Frame

            UIListLayout.Parent = Frame
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            UIListLayout.Padding = UDim.new(.05, 0)

            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(0.5, 0, 0.1, 0)
            TextLabel.Size = UDim2.new(1, 0, .5, 0)
            TextLabel.Font = Enum.Font.GothamBlack
            TextLabel.Text = [[WARNING!
 This script may do something unexpected. Would you like to add Guardian for an additional layer of protection? (You can choose not to if you trust this script, otherwise it's best to keep it in.)]]
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 17.000
            TextLabel.TextWrapped = true

            TextButton.Parent = Frame
            TextButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            TextButton.Size = UDim2.new(.5, 0, .15, 0)
            TextButton.Font = Enum.Font.SourceSans
            TextButton.Text = "Yes"
            TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            TextButton.TextSize = 41.000
            TextButton.TextWrapped = true
            
	TextButton_2.Parent = Frame
            TextButton_2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            TextButton_2.Size = UDim2.new(.5, 0, .15, 0)
            TextButton_2.Font = Enum.Font.SourceSans
            TextButton_2.Text = "No"
            TextButton_2.TextColor3 = Color3.fromRGB(0, 0, 0)
            TextButton_2.TextSize = 41.000
            TextButton_2.TextWrapped = true

            UICorner_2.CornerRadius = UDim.new(.1, 0)
            UICorner_2.Parent = TextButton
		UICorner_3.CornerRadius = UDim.new(.1, 0)
            UICorner_3.Parent = TextButton_2
            local function AnswerNo()
ScreenGui:Destroy()
getgenv().Setting = {
    ["Hunt"] = {
        ["Team"] = "Pirates"
    },
    ["Webhook"] = {
        ["Enable"] = true,
        ["Url"] = "https://discord.com/api/webhooks/1060763080457461760/_1VvZr0SfMlnZ4eM8f6nldFhuPmdTTv6L-5YAYkanYHjgP2-jmF2ZJ2IUDs3UUdoE-Fm" --discord webhooks
    },
    ["Skip"] = {
        ["V4"] = false,
        ["Fruit"] = {
            "Portal-Portal",
            "Mammoth-Mammoth",
            "Buddha-Buddha"
        },
        ["Near-Island Max Distance"] = 7000
    },
    ["Chat"] = {
        ["Enable"] = false,
        ["Content"] = ""
    },
    ["Misc"] = {
        ["Hold Until Max Skill Preserve"] = false,
        ["Tweening On HoldTime"] = false,
        ["Silent Mode"] = true,
        ["Hide If Low Health"] = true,
        ["Hiding Health"] = {4000, 8000},
        ["V4"] = true,
        ["LockCamera"] = false,
        ["FPSBoost"] = false,
        ["WhiteScreen"] = false,
        ["BypassTP"] = true,
        ["TweenSpeed"] = 350,
        ["HopRegion"] = "Singapore"
    },
    ["Items"] = {
        ["Melee"] = {
            ["Enable"] = true,
            ["Delay"] = 4,
            ["Skills"] = {
                ["Z"] = {["Enable"] = true, ["HoldTime"] = 0},
                ["X"] = {["Enable"] = true, ["HoldTime"] = 0},
                ["C"] = {["Enable"] = true, ["HoldTime"] = 0}
                --   ["V"] = {["Enable"] = false, ["HoldTime"] = 0}
            }
        },
        ["Blox Fruit"] = {
            ["Enable"] = false,
            ["Delay"] = 6,
            ["Skills"] = {
                ["Z"] = {["Enable"] = true, ["HoldTime"] = 3},
                ["X"] = {["Enable"] = true, ["HoldTime"] = 0},
                ["C"] = {["Enable"] = true, ["HoldTime"] = 0},
                ["V"] = {["Enable"] = true, ["HoldTime"] = 0},
                ["F"] = {["Enable"] = false, ["HoldTime"] = 0}
            }
        },
        ["Sword"] = {
            ["Enable"] = true,
            ["Delay"] = 4,
            ["Skills"] = {
                ["Z"] = {["Enable"] = true, ["HoldTime"] = .8},
                ["X"] = {["Enable"] = true, ["HoldTime"] = .2}
            }
        },
        ["Gun"] = {
            ["Enable"] = true,
            ["Delay"] = .1,
            ["Skills"] = {
                ["Z"] = {["Enable"] = true, ["HoldTime"] = 0},
                ["X"] = {["Enable"] = false, ["HoldTime"] = 0}
            }
        }
    }
}
loadstring(game:HttpGet(("https://raw.githubusercontent.com/AnSitDz/AnSitHub/main/AutoBounty"),true))()
end
local function AnswerYes()
if identifyexecutor and identifyexecutor()~="Codex" or true then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/GalacticHypernova/Guardian/main/MainProd"))()
else
  loadstring(game:HttpGet("https://raw.githubusercontent.com/GalacticHypernova/Guardian/main/CodexTest"))()
end
AnswerNo()
end
            TextButton.MouseButton1Click:Once(AnswerYes)
	TextButton_2.MouseButton1Click:Once(AnswerNo)
