loadstring(game:HttpGet(("https://raw.githubusercontent.com/REDzHUB/LibraryV2/main/redzLib")))()
MakeWindow({
  Hub = {
    Title = "DEMON HUB ",
    Animation = "by Jova"
  },
  Key = {
    KeySystem = true,
    Title = "Key System",
    Description = "",
    KeyLink = "",
    Keys = {"1234"},
    Notifi = {
      Notifications = true,
      CorrectKey = "Correct key",
      Incorrectkey = "invaild key",
      CopyKeyLink = "copy"
        -- Demon Hub🔥

wait(1.2)

game.StarterGui:SetCore("SendNotification", {

Title = "Credits"; -- the title (ofc)

Text = "Made by Demon/Jova,"; -- what the text says (ofc)

Icon = ""; -- the image if u want.

Duration = 5; -- how long the notification should in secounds

})

local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local Window = Library:NewWindow("DemonHub")
local Section = Window:NewSection("Made by Demon")

Section:CreateToggle("Auto Parry", function(value)
loadstring(game:HttpGet("https://raw.githubusercontent.com/archangelmich/bladeball/main/beta.lua"))()
print(value)
end)
