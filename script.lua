-- 🌌 Universal HD + Font Enhancer
-- Made by Jova

-- ✅ Config
local enableHD = getgenv().hd or false
local enableFont = getgenv().font or false

--------------------------------------
-- [HD MAP SYSTEM]
--------------------------------------
if enableHD then
    local Lighting = game:GetService("Lighting")

    -- Bersihin efek lama
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then
            v:Destroy()
        end
    end

    -- Lighting
    Lighting.Brightness = 4
    Lighting.GlobalShadows = true
    Lighting.EnvironmentDiffuseScale = 1
    Lighting.EnvironmentSpecularScale = 1
    Lighting.Ambient = Color3.fromRGB(100, 100, 100)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.ClockTime = 14

    -- Atmosphere
    local Atmos = Instance.new("Atmosphere")
    Atmos.Density = 0.3
    Atmos.Offset = 0.25
    Atmos.Glare = 0.3
    Atmos.Haze = 1
    Atmos.Color = Color3.fromRGB(200, 200, 220)
    Atmos.Decay = Color3.fromRGB(90, 100, 120)
    Atmos.Parent = Lighting

    -- Sky
    local Sky = Instance.new("Sky")
    Sky.SkyboxBk = "rbxassetid://7018684000"
    Sky.SkyboxDn = "rbxassetid://7018684000"
    Sky.SkyboxFt = "rbxassetid://7018684000"
    Sky.SkyboxLf = "rbxassetid://7018684000"
    Sky.SkyboxRt = "rbxassetid://7018684000"
    Sky.SkyboxUp = "rbxassetid://7018684000"
    Sky.SunAngularSize = 11
    Sky.MoonAngularSize = 8
    Sky.Parent = Lighting

    -- Bloom
    local Bloom = Instance.new("BloomEffect")
    Bloom.Intensity = 0.8
    Bloom.Size = 30
    Bloom.Threshold = 1
    Bloom.Parent = Lighting

    -- Sun rays
    local SunRays = Instance.new("SunRaysEffect")
    SunRays.Intensity = 0.25
    SunRays.Spread = 1
    SunRays.Parent = Lighting

    -- Color correction
    local ColorCorrection = Instance.new("ColorCorrectionEffect")
    ColorCorrection.Saturation = 0.35
    ColorCorrection.Contrast = 0.3
    ColorCorrection.Brightness = 0.1
    ColorCorrection.TintColor = Color3.fromRGB(240, 240, 255)
    ColorCorrection.Parent = Lighting

    -- Depth of Field
    local DoF = Instance.new("DepthOfFieldEffect")
    DoF.FarIntensity = 0.4
    DoF.FocusDistance = 25
    DoF.InFocusRadius = 20
    DoF.NearIntensity = 0.75
    DoF.Parent = Lighting

    print("✅ Ultra HD Map Activated - By Jova")
end

--------------------------------------
-- [FONT SYSTEM]
--------------------------------------
if enableFont then
    local MODE = "Arcade" -- bisa "Sprite" untuk Minecraft-style

    local MinecraftFont = {
        A = "rbxassetid://1234561",
        B = "rbxassetid://1234562",
        C = "rbxassetid://1234563",
        ["0"] = "rbxassetid://1234590",
        ["1"] = "rbxassetid://1234591",
    }

    local function toMinecraftSprite(label)
        local text = label.Text
        label.Text = ""
        local frame = Instance.new("Frame")
        frame.Parent = label
        frame.BackgroundTransparency = 1
        frame.Size = UDim2.new(1, 0, 1, 0)
        for i = 1, #text do
            local char = string.sub(text, i, i)
            local img = Instance.new("ImageLabel")
            img.Parent = frame
            img.Size = UDim2.new(0, label.TextSize, 0, label.TextSize)
            img.Position = UDim2.new(0, (i-1) * label.TextSize, 0, 0)
            img.BackgroundTransparency = 1
            img.Image = MinecraftFont[char:upper()] or ""
        end
    end

    local function toArcadeFont(label)
        label.Font = Enum.Font.Arcade
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    local function applyFont(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if MODE == "Sprite" then
                toMinecraftSprite(obj)
            else
                toArcadeFont(obj)
            end
        end
    end

    for _, obj in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
        applyFont(obj)
    end

    game.Players.LocalPlayer.PlayerGui.DescendantAdded:Connect(applyFont)

    -- Watermark GUI
    local gui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    gui.IgnoreGuiInset = true

    local box = Instance.new("Frame", gui)
    box.AnchorPoint = Vector2.new(1, 0)
    box.Position = UDim2.new(1, -10, 0, 10)
    box.Size = UDim2.new(0, 260, 0, 40)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.BackgroundTransparency = 0.2
    box.BorderSizePixel = 0

    local watermark = Instance.new("TextLabel", box)
    watermark.Size = UDim2.new(1, -10, 1, 0)
    watermark.Position = UDim2.new(0, 5, 0, 0)
    watermark.BackgroundTransparency = 1
    watermark.Text = "Font Active - Made by Jova"
    watermark.TextSize = 20

    if MODE == "Sprite" then
        toMinecraftSprite(watermark)
    else
        toArcadeFont(watermark)
    end

    task.delay(3, function()
        box:Destroy()
    end)

    print("✅ Font Enhancer Activated - By Jova")
end
