-- Prompt user for key
local userKey = getKeyFromUser()

-- Check if the key is valid
if not isValidKey(userKey) then
    -- Notify user that the key is invalid
    game.StarterGui:SetCore("SendNotification", {
        Title = "Demon";
        Text = "Invalid Key!";
        KeyLink = "",
        Keys = {"1234"},
        Icon = "";
        Duration = 5;
    })
    return
end

-- If the key is valid, continue with the script
wait(1.2)

game.StarterGui:SetCore("SendNotification", {
    Title = "Credits";
    Text = "Made by Demon/Jova,";
    Icon = "";
    Duration = 5;
})

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Window = Library:NewWindow("DemonHub")
local Section = Window:NewSection("Made by Demon")

Section:CreateToggle("Auto Parry", function(value)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/archangelmich/bladeball/main/beta.lua"))()
    print(value)
end)
