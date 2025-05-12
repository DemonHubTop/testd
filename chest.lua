local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/1ForeverHD/Fluent/main/library.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Bubble Blitz",
    SubTitle = "By QuePro, with Fluent UI",
    TabWidth = 120,
    Size = UDim2.fromOffset(500, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

--// Tab: Automation
local Automation = Window:AddTab({ Title = "Automation", Icon = "rbxassetid://4483362458" })

Automation:AddToggle("AutoBlowBubbles", {
    Title = "Auto Blow Bubbles",
    Description = "Automatically Blows Bubbles.",
    Default = false,
    Callback = function(Value)
        AutoBlowBubbles = Value
    end
})

Automation:AddToggle("AutoSellBubbles", {
    Title = "Auto Sell Bubbles",
    Description = "Automatically Sells Bubbles.",
    Default = false,
    Callback = function(Value)
        AutoSellBubbles = Value
    end
})

Automation:AddDropdown("SelectedEgg", {
    Title = "Select Egg",
    Description = "Choose egg to hatch",
    Values = EggsTable,
    Multi = true,
    Default = {EggsTable[1]},
    Callback = function(Option)
        SelectedEgg = Option
    end
})

Automation:AddDropdown("HatchMode", {
    Title = "Hatch Mode",
    Description = "Single or Multi Egg Hatch",
    Values = {"Single Egg", "Multiple Eggs"},
    Default = "Single Egg",
    Callback = function(Option)
        MultiEggs = (Option == "Multiple Eggs")
    end
})

Automation:AddToggle("AutoHatch", {
    Title = "Auto Hatch",
    Description = "Automatically Hatches The Selected Egg.",
    Default = false,
    Callback = function(Value)
        AutoHatch = Value
    end
})

Automation:AddButton({
    Title = "Hatch Egg",
    Description = "Hatches The Selected Egg Once.",
    Callback = function()
        HatchEgg(SelectedEgg)
    end
})

Automation:AddDropdown("EquipStats", {
    Title = "Auto Equip Currency",
    Description = "Stat priority for pet equip",
    Values = {"Bubbles", "Coins", "Gems", "Cogwheels", "Pumpkins", "Candycorn"},
    Default = "Bubbles",
    Callback = function(Value)
        EquipStats = Value
    end
})

Automation:AddToggle("AutoEquipPets", {
    Title = "Auto Equip Best Pets",
    Description = "Auto equips best pets based on selected stat.",
    Default = true,
    Callback = function(Value)
        AutoEquipPets = Value
    end
})

Automation:AddToggle("AutoFusePets", {
    Title = "Auto Fuse Pets (Open Pet UI)",
    Description = "Fuses unlocked pets automatically.",
    Default = true,
    Callback = function(Value)
        AutoFusePets = Value
    end
})

Automation:AddToggle("AutoCollectChests", {
    Title = "Auto Collect Chests",
    Description = "Collects all chests every 3 minutes.",
    Default = true,
    Callback = function(Value)
        AutoCollectChests = Value
    end
})

Automation:AddToggle("AntiMod", {
    Title = "Kick On Mod Join",
    Description = "Kicks if mod joins game.",
    Default = true,
    Callback = function(Value)
        AntiMod = Value
    end
})

--// Tab: Pickups
local PickupsTab = Window:AddTab({ Title = "Pickups", Icon = "rbxassetid://4483362458" })

PickupsTab:AddToggle("AutoPickupPumpkins", {
    Title = "Auto Pickup Pumpkins",
    Description = "From Fall World",
    Default = false,
    Callback = function(Value)
        AutoPickupPumpkins = Value
    end
})

PickupsTab:AddToggle("AutoPickupCandyCorn", {
    Title = "Auto Pickup CandyCorn",
    Description = "From Halloween World",
    Default = false,
    Callback = function(Value)
        AutoPickupCandyCorn = Value
    end
})

PickupsTab:AddToggle("TrickOrTreats", {
    Title = "Auto Trick Or Treat",
    Description = "Goes Trick Or Treating repeatedly.",
    Default = false,
    Callback = function(Value)
        TrickOrTreats = Value
    end
})

PickupsTab:AddToggle("AutoPickupGold", {
    Title = "Auto Pickup Gold",
    Description = "From Space World",
    Default = false,
    Callback = function(Value)
        AutoPickupGold = Value
    end
})

PickupsTab:AddToggle("AutoPickupGems", {
    Title = "Auto Pickup Gems",
    Description = "From Void World",
    Default = false,
    Callback = function(Value)
        AutoPickupGems = Value
    end
})

PickupsTab:AddToggle("AutoPickupExp", {
    Title = "Auto Pickup EXP",
    Description = "From XP Island",
    Default = false,
    Callback = function(Value)
        AutoPickupExp = Value
    end
})

--// Tab: Spoofing
local Spoofing = Window:AddTab({ Title = "Spoofing", Icon = "rbxassetid://4483362458" })

Spoofing:AddTextbox("SpoofedText", {
    Title = "Spoofed Text",
    Default = "999999999",
    Callback = function(Text)
        SpoofedText = Text
    end
})

local spoofButtons = {
    {"Spoof Pity", function() LocalPlayer.PlayerGui.ScreenGui.StatsFrame.PlayerStats.PlayerPity.Text = SpoofedText end},
    {"Spoof Bubbles", function() LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Stats.Bubble.Amount.Text = SpoofedText end},
    {"Spoof Candycorn", function() LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Stats.Candycorn.Amount.Text = SpoofedText end},
    {"Spoof Cogwheels", function() LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Stats.Cogwheels.Amount.Text = SpoofedText end},
    {"Spoof Coins", function() LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Stats.Coins.Amount.Text = SpoofedText end},
    {"Spoof Gems", function() LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Stats.Gems.Amount.Text = SpoofedText end},
    {"Spoof Pumpkins", function() LocalPlayer.PlayerGui.ScreenGui.StatsFrame.Stats.Pumpkins.Amount.Text = SpoofedText end},
    {"Spoof Coins Leaderstat", function() LocalPlayer.leaderstats.Coins.Value = SpoofedText end},
    {"Spoof Gems Leaderstat", function() LocalPlayer.leaderstats.Gems.Value = SpoofedText end},
    {"Spoof Eggs Leaderstat", function() LocalPlayer.leaderstats["Eggs Opened"].Value = SpoofedText end},
    {"Spoof Bubbles Leaderstat", function() LocalPlayer.leaderstats["Bubbles Blown"].Value = SpoofedText end},
    {"Spoof Player Tag", function() LocalPlayer.Character.CustomPlayerTag.Username.Text = SpoofedText end},
    {"Spoof Username", function() LocalPlayer.Name = SpoofedText end},
    {"Spoof User ID", function() LocalPlayer.UserId = SpoofedText end},
    {"Spoof Display Name", function() LocalPlayer.DisplayName = SpoofedText end},
}

for _, spoof in ipairs(spoofButtons) do
    Spoofing:AddButton({
        Title = spoof[1],
        Callback = spoof[2]
    })
end

--// Tab: Misc
local MiscTab = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://4483362458" })

MiscTab:AddDropdown("TeleportWorld", {
    Title = "Teleport To",
    Description = "Select a world",
    Values = WorldTable,
    Callback = function(Option)
        TeleportToWorld(Option)
    end
})

MiscTab:AddButton({
    Title = "Unlock All Islands",
    Callback = function()
        for _, v in pairs(game:GetService("Workspace").FloatingIslands.Overworld:GetChildren()) do
            Character.HumanoidRootPart.CFrame = v.TeleportPoint.CFrame
            task.wait(1)
        end
    end
})

MiscTab:AddToggle("EnableNoclip", {
    Title = "Enable Noclip",
    Description = "Walk through walls",
    Default = false,
    Callback = function(Value)
        EnableNoclip = Value
    end
})

MiscTab:AddToggle("Float", {
    Title = "Enable Floating",
    Description = "Float above the ground",
    Default = false,
    Callback = function(Value)
        Float = Value
    end
})

MiscTab:AddDropdown("SelectedPet", {
    Title = "Select Pet To Show",
    Values = PetsTable,
    Default = "None",
    Callback = function(Value)
        SelectedPet = Value
    end
})

MiscTab:AddToggle("ShowPet", {
    Title = "View Pet",
    Description = "Shows the selected pet in workspace",
    Default = true,
    Callback = function(Value)
        if Value then
            for _, v in pairs(SelectedPet) do
                ClonedPet = game:GetService("ReplicatedStorage").Assets.Pets[v]:Clone()
                ClonedPet.Name = "DoggyCP"
                ClonedPet.Parent = workspace
                ClonedPet:PivotTo(Character.HumanoidRootPart.CFrame)
            end
        else
            if workspace:FindFirstChild("DoggyCP") then
                ClonedPet:Destroy()
                ClonedPet = nil
            end
        end
    end
})

Fluent:Notify({
    Title = "Script Loaded!",
    Content = "Fluent UI Loaded Successfully. Join Discord for feedback!\nhttps://dsc.gg/boatblitz",
    SubContent = "Toggle GUI with Left Ctrl",
    Duration = 6.5
})
