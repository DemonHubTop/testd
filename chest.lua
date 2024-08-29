loadstring(game:HttpGet(("https://raw.githubusercontent.com/REDzHUB/LibraryV2/main/redzLib")))()
MakeWindow({
  Hub = {
    Title = "Tbao Hub | Ball blade ",
    Animation = "by thaibao7444"
  },
  Key = {
    KeySystem = false,
    Title = "Key System",
    Description = "",
    KeyLink = "",
    Keys = {"1234"},
    Notifi = {
      Notifications = true,
      CorrectKey = "Running the Script...",
      Incorrectkey = "The key is incorrect",
      CopyKeyLink = "Copied to Clipboard"
    }
  }
})

-- Demon Hub🔥

wait(1.2)

game.StarterGui:SetCore("SendNotification", {

Title = "Credits"; -- the title (ofc)

Text = "Made by Jova,"; -- what the text says (ofc)

Icon = ""; -- the image if u want.

Duration = 5; -- how long the notification should in secounds

})

local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/DemonHubTop/test/main/autochest.lua"))()

local Window = Library:NewWindow("DemonHub")
local Section = Window:NewSection("Build A Boat V1")

Section:CreateToggle("Auto Win", function(value)
loadstring(game:HttpGet("https://raw.githubusercontent.com/DemonHubTop/test/main/autochest.lua"))()
print(value)
end)

Section:CreateButton("Fps Booster", function()
-- Made by Jova
_G.Settings = {
    Players = {
        ["Ignore Me"] = true, -- Ignore your Character
        ["Ignore Others"] = true -- Ignore other Characters
    },
    Meshes = {
        Destroy = false, -- Destroy Meshes
        LowDetail = true -- Low detail meshes (NOT SURE IT DOES ANYTHING)
    },
    Images = {
        Invisible = true, -- Invisible Images
        LowDetail = false, -- Low detail images (NOT SURE IT DOES ANYTHING)
        Destroy = false, -- Destroy Images
    },
    ["No Particles"] = true, -- Disables all ParticleEmitter, Trail, Smoke, Fire and Sparkles
    ["No Camera Effects"] = true, -- Disables all PostEffect's (Camera/Lighting Effects)
    ["No Explosions"] = true, -- Makes Explosion's invisible
    ["No Clothes"] = true, -- Removes Clothing from the game
    ["Low Water Graphics"] = true, -- Removes Water Quality
    ["No Shadows"] = true, -- Remove Shadows
    ["Low Rendering"] = true, -- Lower Rendering
    ["Low Quality Parts"] = true -- Lower quality parts
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/dqwchwqwuvbqvtwvq/ScriptV2/main/Boost.txt"))()
print("Clicked")
end)

Section:CreateButton("Speed up", function()
game.StarterGui:SetCore("SendNotification", { Title = "Strongest Battleground Script Loaded"; Text = "Made by JN HH Gaming. Subscribe him on youtube"; Icon = ""; Duration = 20; }) function isNumber(str) if tonumber(str) ~= nil or str == 'inf' then return true end end local tspeed = 1 local hb = game:GetService("RunService").Heartbeat local tpwalking = true local player = game:GetService("Players") local lplr = player.LocalPlayer local chr = lplr.Character local hum = chr and chr:FindFirstChildWhichIsA("Humanoid") while tpwalking and hb:Wait() and chr and hum and hum.Parent do if hum.MoveDirection.Magnitude > 0 then if tspeed and isNumber(tspeed) then chr:TranslateBy(hum.MoveDirection * tonumber(tspeed)) else chr:TranslateBy(hum.MoveDirection) end end end
print("Clicked")
end)

Section:CreateButton("inf jump", function()
-- Discord: Jova3435
local infjmp = true
game:GetService("UserInputService").jumpRequest:Connect(function()
    if infjmp then
        game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass"Humanoid":ChangeState("Jumping")
    end
end)
print("Clicked")
end)
