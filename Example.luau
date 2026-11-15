--[[
    Radiance Example
    Loads Library + ESP, builds full menu, wires config + working ESP.

    Load (after uploading to your repo):
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSER/Radiance/main/Example.luau"))()

    Or local:
        loadstring(readfile("Radiance/Example.luau"))()
]]

if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end

-- ============================================================
-- Loader (works with HttpGet or readfile, no Instance require)
-- ============================================================
local function LoadModule(pathOrUrl)
    local src
    if isfile and isfile(pathOrUrl) then
        src = readfile(pathOrUrl)
    elseif pathOrUrl:match("^https?://") then
        src = game:HttpGet(pathOrUrl)
    else
        -- try relative to common drop locations
        local candidates = {
            pathOrUrl,
            "Radiance/" .. pathOrUrl,
            "Fallen/src/" .. pathOrUrl,
            "modules/libs/" .. pathOrUrl,
        }
        for _, c in ipairs(candidates) do
            if isfile and isfile(c) then
                src = readfile(c)
                break
            end
        end
        if not src then
            error("[Radiance] could not load module: " .. tostring(pathOrUrl))
        end
    end
    local fn, err = loadstring(src)
    if not fn then error("[Radiance] compile error: " .. tostring(err)) end
    return fn()
end

-- Change these to your raw github urls after upload, or leave as local filenames
local LIBRARY_SRC = "Library.luau"   -- or "https://raw.githubusercontent.com/whosnetworph/Radiance/main/Library.luau"
local ESP_SRC     = "ESP.luau"       -- or "https://raw.githubusercontent.com/whosnetworph/Radiance/main/ESP.luau"

local Library = LoadModule(LIBRARY_SRC)
local ESP     = LoadModule(ESP_SRC)

local Framework = Library.Framework
local Assets    = Library.Assets
local Services  = Library.Services
Flags = Library.Flags
getfenv(0)["Flags"] = Flags

local udim2 = UDim2.new
local color3new = Color3.new
local color3rgb = Color3.fromRGB

-- ============================================================
-- Window + Tabs
-- ============================================================
local Window = Library:Window({
    Name = "Radiance",
    Size = udim2(0, 550, 0, 600),
    Icon = "",
})

local AimbotTab   = Window:Tab({ Name = "Aimbot",   SubTabs = true, Icon = "http://www.roblox.com/asset/?id=12614416478" })
local VisualsTab  = Window:Tab({ Name = "Visuals",  SubTabs = true, Size = udim2(0, 16, 0, 17), Icon = Assets.Images:Require("Visuals") })
local MiscTab     = Window:Tab({ Name = "Misc",     SubTabs = true, Size = udim2(0, 25, 0, 25), Icon = Assets.Images:Require("Misc") })
local SettingsTab = Window:Tab({ Name = "Settings", SubTabs = true, Size = udim2(0, 12, 0, 12), Icon = "http://www.roblox.com/asset/?id=11385161073" })

-- ============================================================
-- Aimbot (stubs + keybinds so config system has flags)
-- ============================================================
do
    local AimbotGeneral = AimbotTab:SubTab({ Name = "General" })

    local AimbotSettings = AimbotGeneral:Section({ Name = "Aimbot Settings" })
    do
        local SilentAim = AimbotSettings:Toggle({ Name = "Silent Aim", Flag = "Silent Aim", Default = false })
        SilentAim:Tooltip({ Name = "Redirects bullet trajectory to the enemy." })
        SilentAim:Keybind({ Default = Enum.UserInputType.MouseButton1, Flag = "Silent Aim Keybind", Mode = "Hold" })

        AimbotSettings:Toggle({ Name = "Memory Aim", Default = true, Flag = "Memory Aim" })
            :Tooltip({ Name = "Assists aiming using memory-based tracking." })
            :Keybind({ Default = Enum.UserInputType.MouseButton2, Flag = "Memory Aim Keybind", Mode = "Hold" })

        AimbotSettings:Dropdown({
            Name = "Hitbox",
            Options = { "Head", "Body", "Legs", "Arms" },
            Default = "Head",
            Flag = "Hitbox",
        })
    end

    local Exploits = AimbotGeneral:Section({ Name = "Exploits", Side = "Right" })
    do
        Exploits:Toggle({ Name = "Manipulation", Default = false, Flag = "Manipulation" })
            :Tooltip({ Name = "Manipulates bullets to shoot past obstacles." })
    end

    local AimbotIndicators = AimbotGeneral:Section({ Name = "Aimbot Indicators" })
    do
        local FieldOfView = AimbotIndicators:Toggle({ Name = "Show Field Of View", Flag = "FOV", Default = false })
        FieldOfView:Tooltip({ Name = "Restricts the aimbot to targets inside the FOV circle." })
        FieldOfView:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0.5, Flag = "FOV Color" })
        AimbotIndicators:Slider({
            Name = "FOV Size",
            Flag = "FOV Size",
            Min = 10, Max = 400, Default = 120,
            ShowDecimals = false,
        })
    end
end

-- ============================================================
-- Visuals — full ESP controls
-- ============================================================
do
    local VisualsGeneral = VisualsTab:SubTab({ Name = "General" })

    local Visuals = VisualsGeneral:Section({ Name = "Visuals" })
    do
        Visuals:Toggle({ Name = "Enable", Flag = "Enable ESP", Default = false })
            :Tooltip({ Name = "Enable ESP." })

        Visuals:Label({ Name = "Boxes" })
        local Box = Visuals:Toggle({ Name = "Box", Flag = "Draw Box", Default = false })
            :Tooltip({ Name = "Draws boxes." })
        do
            local BoxOption = Box:Option({})
            local Color = BoxOption:Toggle({ Name = "Box Color", Flag = "Box Color Toggle", Default = false })
            Color:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Box Top Color" })
            Color:Colorpicker({ Transparency = 0, Flag = "Box Middle Color" })
            Color:Colorpicker({ Transparency = 0, Flag = "Box Bottom Color" })

            local Color2 = BoxOption:Toggle({ Name = "Filled Color", Flag = "Filled Color Toggle", Default = false })
            Color2:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Filled Top Color" })
            Color2:Colorpicker({ Transparency = 0, Flag = "Filled Middle Color" })
            Color2:Colorpicker({ Transparency = 0, Flag = "Filled Bottom Color" })

            BoxOption:Toggle({ Name = "Animated Box", Flag = "Box Animation", Default = false })
            BoxOption:Slider({ Name = "Animation Speed", Flag = "Animation Speed", ShowDecimals = true, Decimals = 1, Default = 2, Min = 1, Max = 6 })
            BoxOption:Toggle({ Name = "Box Glow", Flag = "Box Glow", Default = true })
                :Colorpicker({ Transparency = 0, Flag = "Box Glow Color" })
            BoxOption:Slider({ Name = "Glow Transparency", Flag = "Box Glow Transparency", ShowDecimals = true, Decimals = 2, Default = 0.4, Min = 0, Max = 1 })
            BoxOption:Toggle({ Name = "Filled Box", Flag = "Filled Box", Default = true })
            BoxOption:Toggle({ Name = "Rainbow Filled", Flag = "Rainbow Filled", Default = false })
            BoxOption:Slider({ Name = "Transparency", Flag = "Filled Transparency", Suffix = "%", ShowDecimals = false, Default = 70, Min = 0, Max = 100 })
        end

        Visuals:Label({ Name = "Health" })
        local Healthbar = Visuals:Toggle({ Name = "Healthbar", Flag = "Draw Healthbar", Default = false })
            :Tooltip({ Name = "Draws healthbars." })
        local HealthText = Visuals:Toggle({ Name = "Healthtext", Flag = "Draw Healthtext", Default = false })
            :Tooltip({ Name = "Draws healthtext." })
        HealthText:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "HealthText Color" })
        do
            local HealthbarOption = Healthbar:Option({})
            HealthbarOption:Dropdown({
                Name = "Healthbar Type",
                Options = { "Solid", "Gradient", "Rainbow" },
                Default = "Gradient",
                Flag = "Healthbar Type",
            })
            HealthbarOption:Dropdown({
                Name = "Healthbar Position",
                Options = { "Left", "Right", "Bottom", "Top" },
                Default = "Left",
                Flag = "Healthbar Position",
            })
            HealthbarOption:Slider({ Name = "Healthbar Thickness", Flag = "Healthbar Thickness", ShowDecimals = false, Default = 2, Min = 1, Max = 5 })
            local Gradient = HealthbarOption:Toggle({ Name = "Gradient Colors", Flag = "Health Gradient Toggle", Default = false })
            Gradient:Colorpicker({ Default = color3new(0, 1, 0), Transparency = 0, Flag = "Healthbar Top Color" })
            Gradient:Colorpicker({ Default = color3new(1, 1, 0), Transparency = 0, Flag = "Healthbar Middle Color" })
            Gradient:Colorpicker({ Default = color3new(1, 0, 0), Transparency = 0, Flag = "Healthbar Bottom Color" })
            HealthbarOption:Toggle({ Name = "Animated Healthbar", Flag = "Healthbar Animation", Default = true })
            HealthbarOption:Slider({ Name = "Animation Speed", Flag = "Healthbar Animation Speed", ShowDecimals = true, Decimals = 1, Default = 2, Min = 1, Max = 6 })
        end

        Visuals:Label({ Name = "Head" })
        local TargetIcon = Visuals:Toggle({ Name = "Target Icon", Flag = "Target Icon", Default = false })
        TargetIcon:Colorpicker({ Default = color3rgb(175, 0, 0), Transparency = 0, Flag = "Target Icon Color" })

        local HeadDot = Visuals:Toggle({ Name = "Head Circle", Flag = "Head Dot", Default = false })
        HeadDot:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Head Dot Color" })
        do
            local HeadDotOption = HeadDot:Option({})
            HeadDotOption:Toggle({ Name = "Filled Circle", Flag = "Filled Circle", Default = false })
                :Colorpicker({ Transparency = 0, Flag = "Filled Circle Color" })
            HeadDotOption:Slider({ Name = "Circle Fill Transparency", Flag = "Circle Fill Transparency", ShowDecimals = false, Default = 70, Min = 0, Max = 100 })
        end

        local ViewDirection = Visuals:Toggle({ Name = "View Direction", Flag = "View Direction", Default = false })
        ViewDirection:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "View Direction Color" })
        do
            local ViewDirectionOption = ViewDirection:Option({})
            ViewDirectionOption:Slider({ Name = "Length", Flag = "View Direction Length", ShowDecimals = false, Default = 5, Min = 3, Max = 10 })
        end
    end

    local PlayerChams = VisualsGeneral:Section({ Name = "Player Chams", Side = "Right" })
    do
        local Chams = PlayerChams:Toggle({ Name = "Chams", Flag = "Player Chams", Default = false })
        PlayerChams:Dropdown({ Name = "Type", Flag = "Chams Type", Options = { "Normal", "Breathe" }, Default = "Normal" })
        PlayerChams:Toggle({ Name = "Visible Check", Flag = "Visible Check", Default = false })
        Chams:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Chams Color" })
        Chams:Colorpicker({ Transparency = 0, Flag = "Chams Color2" })
        PlayerChams:Slider({ Name = "Fill Transparency", Flag = "Fill Transparency", ShowDecimals = false, Default = 0, Min = 0, Max = 100 })
        PlayerChams:Slider({ Name = "Outline Transparency", Flag = "Outline Transparency", ShowDecimals = false, Default = 0, Min = 0, Max = 100 })
    end

    local VisualOptions = VisualsGeneral:Section({ Name = "Visual Options", Side = "Right" })
    do
        local Username = VisualOptions:Toggle({ Name = "Username", Flag = "Draw Username", Default = false })
        Username:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Username Color" })

        local Distance = VisualOptions:Toggle({ Name = "Distance", Flag = "Draw Distance", Default = false })
        Distance:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Distance Color" })
        do
            local DistanceOption = Distance:Option({})
            DistanceOption:Dropdown({ Name = "Position", Options = { "Name", "Bottom" }, Flag = "Distance Option" })
        end

        local HeldItem = VisualOptions:Toggle({ Name = "Held Item", Flag = "Draw HeldItem", Default = false })
        HeldItem:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "HeldItem Color" })
        do
            local HeldItemOption = HeldItem:Option({})
            HeldItemOption:Toggle({ Name = "Held Item Image", Flag = "HeldItem Image", Default = false })
                :Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "HeldItem Image Color" })
            HeldItemOption:Slider({ Name = "Image Size", Flag = "Image Size", ShowDecimals = false, Default = 32, Min = 20, Max = 50 })
        end

        local PlayerFlags = VisualOptions:Toggle({ Name = "Player Flags", Flag = "Draw Flags", Default = false })
        do
            local PlayerFlagsOption = PlayerFlags:Option({})
            PlayerFlagsOption:Dropdown({
                Name = "Flags",
                Options = { "Reload", "Scoped", "Heal", "Downed", "Safezone" },
                Max = 5,
                Flag = "Flags",
            })
        end
    end

    -- World / config subtabs (render distance etc.)
    local VisualsWorld = VisualsTab:SubTab({ Name = "World" })
    do
        local Options = VisualsWorld:Section({ Name = "Render" })
        Options:Slider({
            Name = "Render Distance",
            Flag = "Render Distance",
            Suffix = " studs",
            ShowDecimals = false,
            Default = 500,
            Min = 250,
            Max = 2500,
        })
        Options:Dropdown({
            Name = "Units",
            Options = { "Studs", "Meters", "Feet" },
            Default = "Studs",
            Flag = "Render Units",
        })
    end

    local VisualsConfiguration = VisualsTab:SubTab({ Name = "Configuration" })
    do
        local BoxConfiguration = VisualsConfiguration:Section({ Name = "Box Configuration" })
        BoxConfiguration:Dropdown({ Name = "Scaling", Options = { "Static", "Dynamic" }, Default = "Static", Flag = "Box Scaling" })
        BoxConfiguration:Slider({ Name = "Box Width", Flag = "Box Width", ShowDecimals = true, Decimals = 2, Default = 3.5, Min = 2.5, Max = 5 })
        BoxConfiguration:Slider({ Name = "Box Height", Flag = "Box Height", ShowDecimals = true, Decimals = 2, Default = 5.5, Min = 5, Max = 6 })

        local TextConfiguration = VisualsConfiguration:Section({ Name = "Text Configuration" })
        TextConfiguration:Slider({ Name = "Name Offset", Flag = "Name Offset", ShowDecimals = false, Default = 8, Min = 1, Max = 35 })
        TextConfiguration:Slider({ Name = "Held Item Offset", Flag = "Held Item Offset", ShowDecimals = false, Default = 9, Min = 1, Max = 35 })
        TextConfiguration:Slider({ Name = "Distance Offset", Flag = "Distance Offset", ShowDecimals = false, Default = 16, Min = 1, Max = 35 })
        TextConfiguration:Dropdown({ Name = "Held Item Brackets", Options = { "Default", "[]", "()" }, Default = "[]", Flag = "Held Item Brackets" })
    end
end

-- ============================================================
-- Settings — UI + Config system (from Interface:General / Configs)
-- ============================================================
do
    local SettingsGeneral = SettingsTab:SubTab({ Name = "General" })
    Library:General(SettingsGeneral)

    local SettingsConfigs = SettingsTab:SubTab({ Name = "Configs" })
    Library:Configs(SettingsConfigs)
end

-- ============================================================
-- Start ESP
-- ============================================================
ESP.Start(Library)

Library:Notification("Radiance loaded.", 3)
print("[Radiance] Library + ESP + Config ready")
