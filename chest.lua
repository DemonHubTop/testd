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
    }
  }
})

 Main = MakeTab({Name = "Main"})
local section = AddSection(Main, {"Auto parry"})
loadstring(game:HttpGet("https://raw.githubusercontent.com/archangelmich/bladeball/main/beta.lua"))()
print(value)
end)
