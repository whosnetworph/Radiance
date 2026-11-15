if (not game:IsLoaded()) then repeat task.wait() until game:IsLoaded() end;

-- Libs
local Assets    = require("./modules/libs/Assets");
local Framework = require("./modules/libs/Framework");
local Interface = require("./modules/libs/Interface");
local Services = Framework.Services;
Flags = Interface.Flags;
getfenv(0)["Flags"] = Flags;

-- Math
local udim2 = UDim2.new;
local vec2 = Vector2.new;
local clamp = math.clamp;
local floor = math.floor;
local rad = math.rad;
local tan = math.tan;
local color3new = Color3.new;
local color3rgb = Color3.fromRGB;

-- Variables
local Camera = workspace.CurrentCamera;
local Players = Services.Players;
local LocalPlayer = Players.LocalPlayer;
local Lighting = Services.Lighting;

-- Utility
local Utility = {
    Skyboxes = {
        ["Aurora"]     = {folder = "Aurora"};
        ["Blackhole"]  = {folder = "Blackhole"};
        ["Blue"]       = {folder = "Blue"};
        ["Cloudy"]     = {folder = "Cloudy"};
        ["Emo"]        = {folder = "Emo"};
        ["Hades"]      = {folder = "Hades"};
        ["Moonlight"]  = {folder = "Moonlight"};
        ["Oblivion"]   = {folder = "Oblivion"};
        ["Pandora"]    = {folder = "Pandora"};
        ["RemRam"]     = {folder = "RemRam"};
        ["Spooky"]     = {folder = "Spooky"};
        ["Evergarden"] = {folder = "Evergarden"};
        ["Yumeko"]     = {folder = "Yumeko"};
        ["Black"]      = {folder = "Black"};
        ["Nibiru"]     = {folder = "Nibiru"};
        ["Disaster"]   = {folder = "Disaster"};
    },
    Skys = {};
};

-- Functions
local Functions = { };
do

end;

do -- Bypass

end;

do -- Interface
    local Window = Interface:Window({ Icon = "", Name = 'Radiance', Size = udim2(0, 550, 0, 600) });
    --
    local AimbotTab = Window:Tab({ Name = "Aimbot", SubTabs = true, Icon = "http://www.roblox.com/asset/?id=12614416478" });
    local VisualsTab = Window:Tab({ Name = "Visuals", SubTabs = true, Size = udim2(0, 16, 0, 17), Icon = Assets.Images:Require("Visuals") });
    local MiscTab = Window:Tab({ Name = "Misc", SubTabs = true, Size = udim2(0, 25, 0, 25), Icon = Assets.Images:Require("Misc") });
    local SettingsTab = Window:Tab({ Name = "Settings", SubTabs = true, Size = udim2(0, 12, 0, 12), Icon = "http://www.roblox.com/asset/?id=11385161073" });
    --
    do -- Sections
        do -- Aimbot
            -- General
            local AimbotGeneral = AimbotTab:SubTab({Name = "General"});
            do
                local AimbotSettings = AimbotGeneral:Section({Name = "Aimbot Settings"});
                do -- Aimbot Settings
                    --
                    local SilentAim = AimbotSettings:Toggle({ Name = "Silent Aim", Flag = "Silent Aim", Default = false});
                    SilentAim:Tooltip({ Name = "Redirects bullet trajectory to the enemy." });
                    SilentAim:Keybind({ Default = Enum.UserInputType.MouseButton1, Flag = "Silent Aim Keybind", Mode = "Hold"});
                    --
                    do
                        local SilentAimOption = SilentAim:Option({})
                        SilentAimOption:Toggle({Name = "Toggle", Flag = "Silent Aim Option1"});
                        SilentAimOption:Slider({Name = "Slider", Flag = "Silent Aim Option2", ShowDecimals = false, Decimals = 1, Min = 0, Max = 100});
                        SilentAimOption:Dropdown({Name = "Dropdown", Flag = "Silent Aim Option3", Options = {"1", "2", "3"}, Default = "1"});
                    end;
                    AimbotSettings:Toggle({Name = "Memory Aim", Default = true, Flag = "Memory Aim"}):Tooltip({Name = "Assists aiming using memory-based tracking."}):Keybind({Default = Enum.UserInputType.MouseButton2, Flag = "Memory Aim Keybind", Mode = "Hold"});
                    AimbotSettings:Dropdown({ Name = "Hitbox", Options = {"Head", "Body", "Legs", "Arms" }, Default = "Head", Flag = "Hitbox" });
                end;

                -- Exploits
                local Exploits = AimbotGeneral:Section({Name = "Exploits", Side = "Right"});
                do
                    Exploits:Toggle({Name = "Manipulation", Default = false, Flag = "Manipulation"}):Tooltip({Name = "Manipulates bullets to shoot past obstacles."});
                end;

                -- Aimbot Indicators
                local AimbotIndicators = AimbotGeneral:Section({Name = "Aimbot Indicators"});
                do
                    local FieldOfView = AimbotIndicators:Toggle({ Name = "Show Field Of View", Flag = "FOV", Default = false})
                    FieldOfView:Tooltip({ Name = "Restricts the aimbot to targets inside the FOV circle. Larger circle = wider aim range." });
                    FieldOfView:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0.5, Flag = "FOV Color"});
                    do
                        local FieldOfViewOption = FieldOfView:Option({})
                        FieldOfViewOption:Toggle({Name = "Toggle", Flag = "Fov Option1"});
                        FieldOfViewOption:Slider({Name = "Slider", Flag = "Fov Option2", ShowDecimals = false, Decimals = 1, Min = 0, Max = 100});
                        FieldOfViewOption:Dropdown({Name = "Dropdown", Flag = "Fov Option2", Options = {"1", "2", "3"}, Default = "1"});
                    end;
                end;

                -- Ammunition Indicators
                local AmmunitionIndicators = AimbotGeneral:Section({Name = "Ammunition Indicators", Side = "Right"});
                do

                end;
            end;

            -- Weapon Modifications
            local AimbotWeaponMods = AimbotTab:SubTab({Name = "Weapon Mods"});
            do
                
            end;
        end

        do -- Visuals 
            -- VisualsGeneral
            local VisualsGeneral = VisualsTab:SubTab({Name = "General"});
            do -- General
                local Visuals = VisualsGeneral:Section({Name = "Visuals"});
                do -- Visuals
                    -- Boxes
                    Visuals:Toggle({ Name = "Enable", Flag = "Enable ESP", Default = false}):Tooltip({ Name = "Enable ESP." });
                    Visuals:Label({Name = "Boxes"});
                    local Box = Visuals:Toggle({ Name = "Box", Flag = "Draw Box", Default = false}):Tooltip({ Name = "Draws boxes." });
                    do -- Box
                        local BoxOption = Box:Option({});
                        local Color = BoxOption:Toggle({ Name = "Box Color", Flag = "Box Color", Default = false})
                        Color:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Box Top Color"});
                        Color:Colorpicker({ Transparency = 0, Flag = "Box Middle Color"});
                        Color:Colorpicker({ Transparency = 0, Flag = "Box Bottom Color"});
                        local Color2 = BoxOption:Toggle({ Name = "Filled Color", Flag = "Box Color", Default = false})
                        Color2:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Filled Top Color"});
                        Color2:Colorpicker({ Transparency = 0, Flag = "Filled Middle Color"});
                        Color2:Colorpicker({ Transparency = 0, Flag = "Filled Bottom Color"});
                        BoxOption:Toggle({Name = "Animated Box", Flag = "Box Animation", Default = false});
                        BoxOption:Slider({Name = "Animation Speed", Flag = "Animation Speed", ShowDecimals = true, Decimals = 1, Default = 2, Min = 1, Max = 6});
                        BoxOption:Toggle({Name = "Box Glow", Flag = "Box Glow", Default = true}):Colorpicker({ Transparency = 0, Flag = "Box Glow Color"});
                        BoxOption:Slider({Name = "Glow Transparency", Flag = "Box Glow Transparency", ShowDecimals = true, Decimals = 2, Default = 0.4, Min = 0, Max = 1});
                        BoxOption:Toggle({Name = "Filled Box", Flag = "Filled Box", Default = true});
                        BoxOption:Toggle({Name = "Rainbow Filled", Flag = "Rainbow Filled", Default = false});
                        BoxOption:Slider({Name = "Transparency", Flag = "Filled Transparency", Suffix = "%", ShowDecimals = false, Decimals = 1, Default = 70, Min = 0, Max = 100});
                    end;

                    -- Health
                    Visuals:Label({Name = "Health"});
                    local Healthbar = Visuals:Toggle({ Name = "Healthbar", Flag = "Draw Healthbar", Default = false}):Tooltip({ Name = "Draws healthbars." });
                    local HealthText = Visuals:Toggle({ Name = "Healthtext", Flag = "Draw Healthtext", Default = false}):Tooltip({ Name = "Draws healthtext." });
                    HealthText:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "HealthText Color"});
                    do -- Healthbar
                        local HealthbarOption = Healthbar:Option({});
                        HealthbarOption:Dropdown({ Name = "Healthbar Type", Options = { "Solid", "Gradient", "Rainbow" }, Default = "Gradient", Flag = "Healthbar Type"});
                        HealthbarOption:Dropdown({ Name = "Healthbar Position", Options = { "Left", "Right", "Bottom", "Top" }, Default = "Left", Flag = "Healthbar Position"});
                        HealthbarOption:Slider({Name = "Healthbar Thickness", Flag = "Healthbar Thickness", ShowDecimals = false, Decimals = 1, Default = 2, Min = 1, Max = 5});
                        local Gradient = HealthbarOption:Toggle({ Name = "Gradient", Flag = "Top Color2", Default = false})
                        Gradient:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Healthbar Top Color"});
                        Gradient:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Healthbar Middle Color"});
                        Gradient:Colorpicker({ Transparency = 0, Flag = "Healthbar Bottom Color"});
                        HealthbarOption:Toggle({ Name = "Animated Healthbar", Flag = "Healthbar Animation", Default = true});
                        HealthbarOption:Slider({ Name = "Animation Speed", Flag = "Healthbar Animation Speed", ShowDecimals = true, Decimals = 1, Default = 2, Min = 1, Max = 6});
                    end;

                    -- Head
                    Visuals:Label({Name = "Head"});
                    local TargetIcon = Visuals:Toggle({ Name = "Target Icon", Flag = "Target Icon", Default = false}):Tooltip({ Name = "Draws target icon." });
                    TargetIcon:Colorpicker({ Default = color3rgb(175, 0, 0), Transparency = 0, Flag = "Target Icon Color"});
                    local HeadDot = Visuals:Toggle({ Name = "Head Circle", Flag = "Head Dot", Default = false}):Tooltip({ Name = "Draws head dot." });
                    HeadDot:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Head Dot Color"});
                    do -- HeadDot
                        local HeadDotOption = HeadDot:Option({});
                        HeadDotOption:Toggle({Name = "Filled Circle", Flag = "Filled Circle", Default = false}):Colorpicker({ Transparency = 0, Flag = "Filled Circle Color"});
                        HeadDotOption:Slider({Name = "Circle Fill Transparency", Flag = "Circle Fill Transparency", ShowDecimals = false, Decimals = 1, Default = 70, Min = 0, Max = 100});
                    end;
                    local ViewDirection = Visuals:Toggle({ Name = "View Direction", Flag = "View Direction", Default = false}):Tooltip({ Name = "Draws view direction." });
                    ViewDirection:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "View Direction Color"});
                    do -- ViewDirection
                        local ViewDirectionOption = ViewDirection:Option({});
                        ViewDirectionOption:Slider({Name = "Length", Flag = "View Direction Length", ShowDecimals = false, Decimals = 1, Default = 5, Min = 3, Max = 10});
                    end;
                end;

                local PlayerChams = VisualsGeneral:Section({Name = "Player Chams", Side = "Right"});
                do -- Player Chams
                    local Chams = PlayerChams:Toggle({ Name = "Chams", Flag = "Player Chams", Default = false}):Tooltip({ Name = "Draws chams." });
                    PlayerChams:Dropdown({Name = "Type", Flag = "Chams Type", Options = {"Normal", "Breathe"}, Default = "Normal"});
                    PlayerChams:Toggle({ Name = "Visible Check", Flag = "Visible Check", Default = false});
                    Chams:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Chams Color" });
                    Chams:Colorpicker({ Transparency = 0, Flag = "Chams Color2" });
                    PlayerChams:Slider({Name = "Fill Transparency", Flag = "Fill Transparency", ShowDecimals = false, Decimals = 1, Default = 0, Min = 0, Max = 100});
                    PlayerChams:Slider({Name = "Outline Transparency", Flag = "Outline Transparency", ShowDecimals = false, Decimals = 1, Default = 0, Min = 0, Max = 100});
                end;

                local VisualOptions = VisualsGeneral:Section({Name = "Visual Options", Side = "Right"});
                do -- Visual Options
                    local Username = VisualOptions:Toggle({ Name = "Username", Flag = "Draw Username", Default = false}):Tooltip({ Name = "Draws usernames." });
                    Username:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Username Color"});
                    local Distance = VisualOptions:Toggle({ Name = "Distance", Flag = "Draw Distance", Default = false}):Tooltip({ Name = "Draws distance." });
                    Distance:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "Distance Color"});
                    do
                        local DistanceOption = Distance:Option({});
                        DistanceOption:Dropdown({ Name = "Position", Options = { "Name", "Bottom" }, Flag = "Distance Option" });
                    end;
                    local HeldItem = VisualOptions:Toggle({ Name = "Held Item", Flag = "Draw HeldItem", Default = false}):Tooltip({ Name = "Draws held item." });
                    HeldItem:Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "HeldItem Color"});
                    do
                        local HeldItemOption = HeldItem:Option({});
                        HeldItemOption:Toggle({ Name = "Held Item Image", Flag = "HeldItem Image", Default = false}):Colorpicker({ Default = color3new(1, 1, 1), Transparency = 0, Flag = "HeldItem Image Color"});
                        HeldItemOption:Slider({Name = "Image Size", Flag = "Image Size", ShowDecimals = false, Decimals = 1, Default = 32, Min = 20, Max = 50});
                    end;
                    local PlayerFlags = VisualOptions:Toggle({ Name = "Player Flags", Flag = "Draw Flags", Default = false}):Tooltip({ Name = "Draws player flags." });
                    do -- PlayerFlags
                        local PlayerFlagsOption = PlayerFlags:Option({});
                        PlayerFlagsOption:Dropdown({ Name = "Flags", Options = { "Reload", "Scoped", "Heal", "Downed", "Safezone", }, Max = 5, Flag = "Flags" });
                    end;
                end;
            end;

            -- VisualsWorld
            local VisualsWorld = VisualsTab:SubTab({Name = "World"});
            do -- World
                local Options = VisualsWorld:Section({Name = "Visuals"});
                do -- Options
                    Options:Toggle({ Name = "Enable", Flag = "Enable Entities", Default = false});
                    Options:Label({Name = "Options"});
                    Options:Toggle({ Name = "Show Icons", Flag = "Show Icons", Default = false});
                    Options:Toggle({ Name = "Show Distance", Flag = "Show Distance", Default = false});
                    Options:Toggle({ Name = "Show Health", Flag = "Show Health", Default = false});
                    Options:Label({Name = "Render"});
                    Options:Slider({Name = "Render Distance", Flag = "Render Distance", Suffix = " studs", ShowDecimals = false, Decimals = 1, Default = 500, Min = 250, Max = 2500});
                end;
                
                local Entities = VisualsWorld:Section({Name = "Entities", Side = "Right"});
                do -- Entities
                    Entities:ListBox({ Flag = "Entities Filter", Multi = true, Icon = false,
                        Options = {"Stone Ore","Iron Ore","Sulfur Ore","Hemp","Lootables","Dropped Items","Backpack"},
                    });
                end;

                local Environment = VisualsWorld:Section({Name = "Environment", Side = "Right"});
                do -- Environment
                    local S = Lighting:FindFirstChildOfClass("Sky");
                    local HadOriginalSky = S ~= nil;
                    local OriginalSky = S and {
                        SkyboxBk = S.SkyboxBk;
                        SkyboxDn = S.SkyboxDn;
                        SkyboxFt = S.SkyboxFt;
                        SkyboxLf = S.SkyboxLf;
                        SkyboxRt = S.SkyboxRt;
                        SkyboxUp = S.SkyboxUp;
                    } or nil;
                    Environment:Dropdown({ Name = "Skyboxes", Options = { "Default","Aurora","Blackhole","Blue","Cloudy","Emo","Hades","Moonlight","Oblivion","Pandora","RemRam","Spooky","Evergarden","Yumeko","Black","Nibiru","Disaster" }, Flag = "Skybox Options", Callback = function(State)
                        local Old = Lighting:FindFirstChildOfClass("Sky");
                        if Old then Old:Destroy() end;

                        if State == "Default" then
                            if HadOriginalSky then
                                local Sky = Instance.new("Sky", Lighting);
                                Sky.CelestialBodiesShown = true;
                                Sky.SkyboxBk = OriginalSky.SkyboxBk;
                                Sky.SkyboxDn = OriginalSky.SkyboxDn;
                                Sky.SkyboxFt = OriginalSky.SkyboxFt;
                                Sky.SkyboxLf = OriginalSky.SkyboxLf;
                                Sky.SkyboxRt = OriginalSky.SkyboxRt;
                                Sky.SkyboxUp = OriginalSky.SkyboxUp;
                            end;
                            return;
                        end;

                        local d = Utility.Skyboxes[State];
                        if not d then return end;

                        local f = d.folder;
                        local Sky = Instance.new("Sky", Lighting);
                        Sky.CelestialBodiesShown = false;
                        Sky.SkyboxBk = "";
                        Sky.SkyboxDn = "";
                        Sky.SkyboxFt = "";
                        Sky.SkyboxLf = "";
                        Sky.SkyboxRt = "";
                        Sky.SkyboxUp = "";
                        task.wait();

                        Sky.SkyboxBk = Assets.Skyboxes:Require(f, "sky512_bk");
                        Sky.SkyboxDn = Assets.Skyboxes:Require(f, "sky512_dn");
                        Sky.SkyboxFt = Assets.Skyboxes:Require(f, "sky512_ft");
                        Sky.SkyboxLf = Assets.Skyboxes:Require(f, "sky512_lf");
                        Sky.SkyboxRt = Assets.Skyboxes:Require(f, "sky512_rt");
                        Sky.SkyboxUp = Assets.Skyboxes:Require(f, "sky512_up");
                    end});

                    Environment:Toggle({ Name = "Weather Effects", Flag = "Weather Effects", Default = true, Callback = function(State)
                        
                    end}):Colorpicker({ Transparency = 0, Flag = "Weather Effects Color", Callback = function(State)
                        
                    end});
                    Environment:Dropdown({ Name = "Effect Type", Options = { "Snow", "Fire", "Energy orbs" }, Flag = "Weather Effects Options", Callback = function(State)
        
                    end});
                    Environment:Slider({ Name = "Effect Ammount", Flag = "Weather Effect Ammount", ShowDecimals = false, Decimals = 1, Default = 2, Min = 1, Max = 10, Callback = function(State)
                        
                    end});
                end;

                local Lighting = VisualsWorld:Section({Name = "Lighting"});
                do -- Lighting
                    
                end;
            end;

            -- VisualsConfiguration
            local VisualsConfiguration = VisualsTab:SubTab({Name = "Configuration"});
            do -- Configuration
                local BoxConfiguration = VisualsConfiguration:Section({Name = "Box Configuration"});
                do -- Box Configuration
                    BoxConfiguration:Label({Name = "Normal"});
                    BoxConfiguration:Dropdown({ Name = "Scaling", Options = { "Static", "Dynamic" }, Default = "Static", Flag = "Box Scaling" });
                    BoxConfiguration:Slider({ Name = "Box Width", Flag = "Box Width", ShowDecimals = true, Decimals = 2, Default = 3.5, Min = 2.5, Max = 5 });
                    BoxConfiguration:Slider({ Name = "Box Height", Flag = "Box Height", ShowDecimals = true, Decimals = 2, Default = 5.5, Min = 5, Max = 6 });
                end;

                local TextConfiguration = VisualsConfiguration:Section({Name = "Text Configuration"});
                do -- Text Configuration
                    TextConfiguration:Slider({ Name = "Name Offset", Flag = "Name Offset", ShowDecimals = false, Decimals = 1, Default = 8, Min = 1, Max = 35 });
                    TextConfiguration:Slider({ Name = "Held Item Offset", Flag = "Held Item Offset", ShowDecimals = false, Decimals = 1, Default = 9, Min = 1, Max = 35 });
                    TextConfiguration:Slider({ Name = "Distance Offset", Flag = "Distance Offset", ShowDecimals = false, Decimals = 1, Default = 16, Min = 1, Max = 35 });
                    TextConfiguration:Dropdown({ Name = "Held Item Brackets", Options = { "Default", "[]", "()" }, Default = "[]", Flag = "Held Item Brackets" });
                end;

                local RenderConfiguration = VisualsConfiguration:Section({Name = "Render Configuration", Side = "Right"});
                do -- Render Configuration
                    RenderConfiguration:Label({Name = "Render"});
                    RenderConfiguration:Slider({Name = "Render Distance", Flag = "Render Distance", Suffix = "", ShowDecimals = false, Decimals = 1, Default = 500, Min = 250, Max = 2500});
                    RenderConfiguration:Dropdown({ Name = "Render Units", Options = { "Studs", "Meters", "Feet" }, Default = "Studs", Flag = "Render Units" });
                    --
                    RenderConfiguration:Label({Name = "Wounded"});
                    local Wounded = RenderConfiguration:Toggle({ Name = "Show Wounded", Flag = "ShowWounded", Default = true});
                    Wounded:Colorpicker({ Default = Color3.fromRGB(255, 90, 0), Transparency = 0, Flag = "Wounded Color"});
                    --
                    RenderConfiguration:Label({Name = "Teammates"});
                    local Teammates = RenderConfiguration:Toggle({ Name = "Show Teammates", Flag = "ShowTeammates", Default = true});
                    Teammates:Colorpicker({ Default = Color3.fromRGB(0, 255, 0), Transparency = 0, Flag = "Teammates Color"});
                    --
                    RenderConfiguration:Label({Name = "NPC's"});
                    local NPCs = RenderConfiguration:Toggle({ Name = "Show NPCs", Flag = "ShowNPCs", Default = true});
                    NPCs:Colorpicker({ Default = Color3.fromRGB(50, 200, 255), Transparency = 0, Flag = "NPC Color"});
                    --
                    RenderConfiguration:Label({Name = "Safezone"});
                    local Safezone = RenderConfiguration:Toggle({ Name = "Show Safezone", Flag = "ShowSafezone", Default = true});
                    Safezone:Colorpicker({ Default = Color3.fromRGB(0, 255, 0), Transparency = 0, Flag = "Safezone Color"});
                end;
            end;
        end;
        
        do -- Misc
            -- General
            local MiscGeneral = MiscTab:SubTab({Name = "General"});
            do
                MiscGeneral:Section({Name = "Test"});
                MiscGeneral:Section({Name = "Test2", Side = "Right"});
                MiscGeneral:Section({Name = "Test3"});
                MiscGeneral:Section({Name = "Test4", Side = "Right"});
            end;

            -- Sub General
            local MiscSubGeneral = MiscTab:SubTab({Name = "Sub General"});
            do
                
            end;
        end;

        do -- Settings
            -- General
            local SettingsGeneral = SettingsTab:SubTab({Name = "General"});
            Interface:General(SettingsGeneral);

            -- Configs
            local SettingsConfigs = SettingsTab:SubTab({Name = "Configs"});
            Interface:Configs(SettingsConfigs);
        end;
    end;
end;

do -- Hooks

end;

do -- Player ESP
    local playerESP = {
        objects = {};
    };
    playerESP.__index = playerESP;

    do -- Functions
        playerESP.GetBounds = function(model)
            if not model or not model.Parent then return end

            local hrp = model:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local width = Flags["Box Width"]
            local height = Flags["Box Height"]
            local size = Vector3.new(width, height, 4)

            local offsetY = -0.4
            local center = hrp.Position + Vector3.new(0, offsetY, 0)

            return hrp.CFrame, size, center;
        end;
    end;

    do -- Create drawings
        do -- Create
            function playerESP:createtext(parent)
                local text = Framework:New("TextLabel", {
                    Visible                = false;
                    RichText               = true;
                    Parent                 = parent;
                    TextXAlignment         = Enum.TextXAlignment.Center,
                    BackgroundTransparency = 1;
                    TextStrokeTransparency = 1;
                    TextStrokeColor3       = color3new(0, 0, 0);
                    FontFace               = Framework.CurrentFont;
                    TextSize               = Framework.CurrentSize;
                    ZIndex                 = 5;
                });

                Framework:New("UIStroke", { 
                    Thickness       = 1,
                    LineJoinMode    = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                    Color           = Color3.fromRGB(0, 0, 0),
                    Parent = text
                });
                return text;
            end;
            --
            function playerESP:createbox(parent)
                local box = Framework:New("Frame", { Parent = parent, Visible = false, BackgroundTransparency = 1, ZIndex = 3 });
                Framework:New("UICorner", { CornerRadius = UDim.new(0, 1), Parent = box });

                local boxglow = Framework:New("ImageLabel", {
                    Visible = false;
                    ZIndex = -1,
                    SliceCenter = Rect.new(49, 49, 450, 450),
                    ScaleType = Enum.ScaleType.Slice,
                    Image = "rbxassetid://93984335181980",
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Parent = box
                });

                local boxstroke = Framework:New("UIStroke", {
                    Color                = color3new(1, 1, 1),
                    Parent               = box,
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner,
                    LineJoinMode         = Enum.LineJoinMode.Miter,
                    ZIndex               = 2,
                });

                local strokegradient = Framework:New("UIGradient", {
                    Parent   = boxstroke, 
                    Rotation = -90,
                    Enabled  = true
                });

                local boxgradient = Framework:New("UIGradient", {
                    Enabled  = true,
                    Parent   = box,
                    Rotation = -90
                });

                Framework:New("UIStroke", {
                    Parent               = box,
                    Color                = color3new(0, 0, 0),
                    Thickness            = 2,
                    BorderStrokePosition = Enum.BorderStrokePosition.Center,
                    LineJoinMode         = Enum.LineJoinMode.Miter,
                    ZIndex               = 1,
                });

                Framework:New("UIStroke", {
                    Parent               = box,
                    Color                = color3new(0, 0, 0),
                    Thickness            = 2,
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner,
                    LineJoinMode         = Enum.LineJoinMode.Miter,
                    ZIndex               = 1,
                });

                return box, boxgradient, boxstroke, strokegradient, boxglow;
            end;
            -- 
            function playerESP:createhealthbar(parent)
                local behindhealthbar = Framework:New("Frame", {
                    Visible = false;
                    Parent = parent,
                    BackgroundColor3 = Color3.fromRGB(0,0,0),
                    BorderSizePixel = 1, 
                    BorderColor3 = Color3.fromRGB(0,0,0),
                    ZIndex = 3
                });

                Framework:New("UICorner", {
                    CornerRadius = UDim.new(0, 1),
                    Parent = behindhealthbar
                });

                Framework:New("UIStroke", {
                    Parent               = behindhealthbar,
                    Color                = color3new(0, 0, 0),
                    Thickness            = 2,
                    BorderStrokePosition = Enum.BorderStrokePosition.Center,
                    LineJoinMode         = Enum.LineJoinMode.Miter,
                    ZIndex               = 1,
                });

                local healthbar = Framework:New("Frame", {
                    Visible = false;
                    Parent = parent,
                    BackgroundColor3 = Color3.fromRGB(255,255,255),
                    BorderSizePixel = 0,
                    ZIndex = 3
                });

                local healthbargradient = Framework:New("UIGradient", {
                    Enabled = true,
                    Parent = healthbar,
                    Rotation = -90
                });

                return behindhealthbar, healthbar, healthbargradient
            end;
            --
            function playerESP:createcircle(parent)
                local circle = Framework:New("Frame", {
                    Visible = false;
                    Parent = parent,
                    BackgroundTransparency = 1,
                    ZIndex = 2,
                    Size = UDim2.new(0, 30, 0, 30),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                });

                Framework:New("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = circle
                });

                Framework:New("UIStroke", {
                    Parent = circle,
                    Thickness = 3,
                    Color = Color3.fromRGB(0, 0, 0),
                    BorderStrokePosition = Enum.BorderStrokePosition.Center,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Round,
                    ZIndex = 1,
                });

                local circlecolor = Framework:New("UIStroke", {
                    Parent = circle,
                    Thickness = 1.5,
                    Color = Color3.fromRGB(255, 255, 255),
                    BorderStrokePosition = Enum.BorderStrokePosition.Center,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Round,
                    ZIndex = 2,
                });

                return circle, circlecolor;
            end;
            --
            function playerESP:createline(parent)
                local line = Framework:New("Frame", {
                    Parent = parent,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    ZIndex = 2,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Visible = false
                });

                Framework:New("UIStroke", {
                    Enabled = true,
                    Parent = line,
                    Thickness = 2,
                    Color = Color3.fromRGB(0, 0, 0),
                    BorderStrokePosition = Enum.BorderStrokePosition.Center,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Round,
                    ZIndex = 1,
                });

                local linecolor = Framework:New("UIStroke", {
                    Enabled = true,
                    Parent = line,
                    Thickness = 1,
                    Color = Color3.fromRGB(255, 255, 255),
                    BorderStrokePosition = Enum.BorderStrokePosition.Center,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Round,
                    ZIndex = 2,
                });

                return line, linecolor;
            end;
            --
            function playerESP:createimage(parent)
                local image = Framework:New("ImageLabel", {
                    Parent = parent,
                    Size = UDim2.new(0, 32, 0, 32),
                    Image = "http://www.roblox.com/asset/?id=17677455113",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    ZIndex = 5,
                    BorderSizePixel = 0,
                    Visible = false
                });

                return image;
            end;
            --
            function playerESP:createhighlight()
                local highlight = Framework:New("Highlight", {
                    Parent = (gethui and gethui()) or (cloneref and cloneref(Services.CoreGui)),
                    FillTransparency = 0.3,
                    OutlineTransparency = 0,
                    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
                    Enabled = false
                });

                return highlight;
            end;
        end;

        function playerESP.create(player)
            if (player == LocalPlayer) then return end;

            local self = setmetatable({
                player = player;
                char_conn = nil;
                drawings = {};
                hrp = nil;
                hum = nil;
                head = nil;
                healthlerp = 0;
            }, playerESP);

            local gui = Framework:New("ScreenGui", { Parent = (gethui and gethui()) or (cloneref and cloneref(Services.CoreGui)) });
            if (next(self.drawings) == nil) then
                self.drawings.username = self:createtext(gui); self.drawings.username.Text = player.DisplayName or "SigmaBoy";
                self.drawings.targeticon = self:createimage(gui);
                self.drawings.targeticon.Image = Assets.Images:Require("Crosshair");
                self.drawings.helditem = self:createtext(gui);
                self.drawings.helditemimage = self:createimage(gui);
                self.drawings.distance = self:createtext(gui);
                self.drawings.flags = self:createtext(gui);
                self.drawings.healthtext = self:createtext(gui);
                self.drawings.box, self.drawings.boxgradient, self.drawings.boxstroke, self.drawings.strokegradient, self.drawings.boxglow = self:createbox(gui);
                self.drawings.behindhealthbar, self.drawings.healthbar, self.drawings.healthbargradient = self:createhealthbar(gui);
                self.drawings.headcircle, self.drawings.circlecolor = self:createcircle(gui);
                self.drawings.viewdirection, self.drawings.viewdirectioncolor = self:createline(gui);
                self.drawings.highlight = self:createhighlight(player.Character);
            end;

            if (not self.char_conn) then
                self.char_conn = player.CharacterAdded:Connect(function(character)
                    self:characterAdded(character);
                end);
            end;

            if (player.Character) then
                self:characterAdded(player.Character);
            end;

            player.AncestryChanged:Connect(function(_, parent)
                if (not parent) then
                    for _, d in pairs(self.drawings) do
                        if typeof(d) == "Instance" then d:Destroy(); end;
                    end;
                    playerESP.objects[player] = nil;
                end;
            end);

            playerESP.objects[player] = self;
            return self;
        end;

        function playerESP.remove(player)
            local obj = playerESP.objects[player];
            if (obj) then
                if (obj.char_conn) then
                    obj.char_conn:Disconnect();
                end;
                obj:sethidden();
                playerESP.objects[player] = nil;
            end;
        end;

        function playerESP:sethidden()
            for _, drawing in pairs(self.drawings) do
                if (drawing) then
                    if drawing:IsA("GuiObject") then
                        drawing.Visible = false;
                    elseif drawing:IsA("UIStroke") or drawing:IsA("UIGradient") then
                        drawing.Enabled = false;
                    elseif drawing:IsA("Highlight") then
                        drawing.Enabled = false;
                    end;
                end;
            end;
        end;

        function playerESP:characterAdded(character)
            self.hrp = character:FindFirstChild("HumanoidRootPart");
            self.hum = character:FindFirstChildOfClass("Humanoid");
            self.head = character:FindFirstChild("Head");

            if (self.drawings.highlight) then
                self.drawings.highlight.Adornee = character;
                self.drawings.highlight.Enabled = Flags["Player Chams"];
            end;
        end;
    end;

    do -- Draw Functions
        function playerESP:drawtarget(x, y)
            local offset = self.drawings.username.TextBounds.Y;
            self.drawings.targeticon.Size = UDim2.new(0, 16, 0, 16);
            self.drawings.targeticon.Position = UDim2.new(0, x, 0, y - offset);
            self.drawings.targeticon.ImageColor3 = Flags["Target Icon Color"];
            self.drawings.targeticon.Visible = Flags["Target Icon"];
        end;
        --
        function playerESP:drawusername(x, y, distance)
            self.drawings.username.Position = UDim2.new(0, x, 0, y)

            local name = self.player.DisplayName
            if Flags["Draw Distance"] and Flags["Distance Option"] == "Name" and distance then
                name = name .. " [" .. tostring(distance) .. "]"
            end

            self.drawings.username.Text = name
            self.drawings.username.TextColor3 = Flags["Username Color"]
            self.drawings.username.Visible = Flags["Draw Username"]
            self.drawings.username.TextYAlignment = Enum.TextYAlignment.Top

            if (self.drawings.username.FontFace ~= Framework.CurrentFont) then self.drawings.username.FontFace = Framework.CurrentFont end;
            if (self.drawings.username.TextSize ~= Framework.CurrentSize) then self.drawings.username.TextSize = Framework.CurrentSize end;
        end;
        --
        function playerESP:drawdistance(distance)
            if Flags["Distance Option"] == "Name" then
                self.drawings.distance.Visible = false
            elseif Flags["Distance Option"] == "Bottom" then
                self.drawings.distance.Visible = Flags["Draw Distance"]
            end

            local unit = Flags["Render Units"]
            local text = tostring(distance)

            if unit == "Studs" then
                text = text .. "st"
            elseif unit == "Meters" then
                text = text .. "m"
            elseif unit == "Feet" then
                text = text .. "ft"
            end

            self.drawings.distance.Text = text
            self.drawings.distance.TextColor3 = Flags["Distance Color"]
            self.drawings.distance.TextYAlignment = Enum.TextYAlignment.Bottom
            if self.drawings.distance.FontFace ~= Framework.CurrentFont then self.drawings.distance.FontFace = Framework.CurrentFont; end; 
            if self.drawings.distance.TextSize ~= Framework.CurrentSize then self.drawings.distance.TextSize = Framework.CurrentSize; end;
        end;
        --
        function playerESP:drawhelditem(x, y)
            local item = "Salvaged AK47"
            local b = Flags["Held Item Brackets"]

            if b == "[]" then
                item = "[" .. item .. "]"
            elseif b == "()" then
                item = "(" .. item .. ")"
            end

            self.drawings.helditem.Position = UDim2.new(0, x, 0, y)
            self.drawings.helditem.Text = item
            self.drawings.helditem.TextColor3 = Flags["HeldItem Color"]
            self.drawings.helditem.Visible = Flags["Draw HeldItem"]
            self.drawings.helditem.TextYAlignment = Enum.TextYAlignment.Bottom
            if self.drawings.helditem.FontFace ~= Framework.CurrentFont then self.drawings.helditem.FontFace = Framework.CurrentFont end
            if self.drawings.helditem.TextSize ~= Framework.CurrentSize then self.drawings.helditem.TextSize = Framework.CurrentSize end

            local imgOffset = -2
            if Flags["Draw HeldItem"] then
                imgOffset = 8
            end

            self.drawings.helditemimage.Position = UDim2.new(0, x, 0, y + imgOffset)
            self.drawings.helditemimage.Size = UDim2.new(0, Flags["Image Size"], 0, Flags["Image Size"])
            self.drawings.helditemimage.ImageColor3 = Flags["HeldItem Image Color"]
            self.drawings.helditemimage.Visible = Flags["HeldItem Image"]

            local distOffset = Flags["Distance Offset"]
            if Flags["Draw HeldItem"] and not Flags["HeldItem Image"] then
                self.drawings.distance.Position = UDim2.new(0, x, 0, y + distOffset - 4)
            elseif not Flags["Draw HeldItem"] and not Flags["HeldItem Image"] then
                self.drawings.distance.Position = UDim2.new(0, x, 0, y)
            else
                self.drawings.distance.Position = UDim2.new(0, x, 0, y + distOffset + imgOffset)
            end;
        end;
        --
        function playerESP:drawflags(box_x, box_y, box_w)
            local pos = Flags["Healthbar Position"]
            local offsetX = (pos == "Right") and 13 or 4
            local offsetY = 3

            local t = {};
            t[#t+1] = '<font color="#888888">Rel</font>';
            t[#t+1] = '<font color="#00B7FF">Scope</font>';
            t[#t+1] = '<font color="#FFFF00">Heal</font>';
            t[#t+1] = '<font color="#FF4040">Manip</font>';
            t[#t+1] = '<font color="#00FF00">Safe</font>';

            local text = table.concat(t, '<font color="#FFFFFF">, </font>')
            self.drawings.flags.Visible = text ~= "" and Flags["Draw Flags"]
            self.drawings.flags.Text = text
            self.drawings.flags.Position = UDim2.new(0, box_x + box_w + offsetX, 0, box_y - offsetY)
            self.drawings.flags.TextXAlignment = Enum.TextXAlignment.Left
            self.drawings.flags.TextYAlignment = Enum.TextYAlignment.Top

            if self.drawings.flags.FontFace ~= Framework.CurrentFont then self.drawings.flags.FontFace = Framework.CurrentFont end;
            if self.drawings.flags.TextSize ~= Framework.CurrentSize then self.drawings.flags.TextSize = Framework.CurrentSize end;
        end;
        --
        function playerESP:drawbox(x, y, w, h)
            self.drawings.box.Position = UDim2.new(0, x, 0, y)
            self.drawings.box.Size = UDim2.new(0, w, 0, h)
            self.drawings.box.Visible = Flags["Draw Box"]
            self.drawings.box.BackgroundTransparency = Flags["Filled Box"] and Flags["Filled Transparency"] / 100 or 1

            self.drawings.boxgradient.Enabled = Flags["Filled Box"]
            self.drawings.boxgradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Flags["Filled Bottom Color"]),
                ColorSequenceKeypoint.new(0.5, Flags["Filled Middle Color"]),
                ColorSequenceKeypoint.new(1, Flags["Filled Top Color"])
            };

            self.drawings.boxstroke.Enabled = Flags["Draw Box"]

            if Flags["Rainbow Filled"] then
                local colors = { Color3.fromRGB(255,179,186), Color3.fromRGB(255,223,186), Color3.fromRGB(255,255,186),Color3.fromRGB(186,255,201), Color3.fromRGB(186,225,255), Color3.fromRGB(201,186,255) }
                if Flags["Box Animation"] then
                    local t = tick() * Flags["Animation Speed"]
                    local f = t % 6
                    local i = floor(f) + 1
                    local nexti = i % 6 + 1
                    local blend = f % 1
                    local rotated = {}
                    for idx = 1, 6 do
                        rotated[idx] = colors[((idx - 1 + i - 1) % 6) + 1]:Lerp(colors[((idx - 1 + nexti - 1) % 6) + 1], blend)
                    end
                    colors = rotated
                end
                self.drawings.boxgradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, colors[1]),
                    ColorSequenceKeypoint.new(0.2, colors[2]),
                    ColorSequenceKeypoint.new(0.4, colors[3]),
                    ColorSequenceKeypoint.new(0.6, colors[4]),
                    ColorSequenceKeypoint.new(0.8, colors[5]),
                    ColorSequenceKeypoint.new(1, colors[6])
                }
            end

            self.drawings.strokegradient.Enabled = Flags["Draw Box"]
            self.drawings.strokegradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Flags["Box Bottom Color"]),
                ColorSequenceKeypoint.new(0.5, Flags["Box Middle Color"]),
                ColorSequenceKeypoint.new(1, Flags["Box Top Color"])
            }

            if Flags["Box Animation"] then
                local s = Flags["Animation Speed"]
                local r = (tick()*60*s)%(720*2)
                if r > 720 then r = 720 - (r-720) end
                self.drawings.boxgradient.Rotation = r
                self.drawings.strokegradient.Rotation = r
            else
                self.drawings.boxgradient.Rotation = -90
                self.drawings.strokegradient.Rotation = -90
            end

            if Flags["Box Glow"] then
                self.drawings.boxglow.Visible = true
                self.drawings.boxglow.ImageColor3 = Flags["Box Glow Color"]
                self.drawings.boxglow.ImageTransparency = Flags["Box Glow Transparency"]
                local minW, maxW, minGlow, maxGlow = 6, 43, 7, 44
                local ratio = math.clamp((w - minW) / (maxW - minW), 0, 1)
                local s = minGlow + (maxGlow - minGlow) * ratio
                self.drawings.boxglow.Size = UDim2.new(1, s, 1, s)
            else
                self.drawings.boxglow.Visible = false
            end
        end;
        --
        function playerESP:drawhealthbar(box_height, box_x, box_y)
            local humanoid = self.hum;
            local health = humanoid and humanoid.Health or 0;
            local max_health = humanoid and humanoid.MaxHealth or 100;
            local healthp = clamp(health / max_health, 0, 1);

            if not self.healthlerp then self.healthlerp = healthp end
            self.healthlerp = self.healthlerp + (healthp - self.healthlerp) * 0.1

            local bar_width = Flags["Healthbar Thickness"]
            local filled_height = box_height * self.healthlerp
            local shift_x = bar_width > 2 and (bar_width - 2) or 0

            local box_width = 0
            if self.drawings.box and self.drawings.box.Size and self.drawings.box.Size.X then
                box_width = self.drawings.box.Size.X.Offset or 0
            end

            local pos = Flags["Healthbar Position"]
            local healthbar_x, healthbar_y, healthbar_w, healthbar_h

            if pos == "Right" then
                local bx = box_x + box_width + 5
                self.drawings.behindhealthbar.Position = UDim2.new(0, bx, 0, box_y)
                self.drawings.behindhealthbar.Size = UDim2.new(0, bar_width, 0, box_height)
                self.drawings.healthbar.Position = UDim2.new(0, bx, 0, box_y + (box_height - filled_height))
                self.drawings.healthbar.Size = UDim2.new(0, bar_width, 0, filled_height)
                healthbar_x = bx
                healthbar_y = box_y + (box_height - filled_height)
                healthbar_w = bar_width
                healthbar_h = filled_height
            elseif pos == "Bottom" then
                local by = box_y + box_height + 5
                self.drawings.behindhealthbar.Position = UDim2.new(0, box_x, 0, by)
                self.drawings.behindhealthbar.Size = UDim2.new(0, box_width, 0, bar_width)
                self.drawings.healthbar.Position = UDim2.new(0, box_x, 0, by)
                self.drawings.healthbar.Size = UDim2.new(0, box_width * self.healthlerp + 1, 0, bar_width)
                healthbar_x = box_x + box_width * self.healthlerp / 2
                healthbar_y = by
                healthbar_w = box_width * self.healthlerp
                healthbar_h = bar_width
            elseif pos == "Top" then
                local by = box_y - bar_width - 5
                self.drawings.behindhealthbar.Position = UDim2.new(0, box_x, 0, by)
                self.drawings.behindhealthbar.Size = UDim2.new(0, box_width, 0, bar_width)
                self.drawings.healthbar.Position = UDim2.new(0, box_x, 0, by)
                self.drawings.healthbar.Size = UDim2.new(0, box_width * self.healthlerp + 1, 0, bar_width)
                healthbar_x = box_x + box_width * self.healthlerp / 2
                healthbar_y = by
                healthbar_w = box_width * self.healthlerp
                healthbar_h = bar_width
            else
                local bx = box_x - 7 - shift_x
                self.drawings.behindhealthbar.Position = UDim2.new(0, bx, 0, box_y)
                self.drawings.behindhealthbar.Size = UDim2.new(0, bar_width, 0, box_height)
                self.drawings.healthbar.Position = UDim2.new(0, bx, 0, box_y + (box_height - filled_height))
                self.drawings.healthbar.Size = UDim2.new(0, bar_width, 0, filled_height)
                healthbar_x = bx
                healthbar_y = box_y + (box_height - filled_height)
                healthbar_w = bar_width
                healthbar_h = filled_height
            end

            self.drawings.behindhealthbar.Visible = Flags["Draw Healthbar"]
            self.drawings.healthbar.Visible = Flags["Draw Healthbar"]
            self.drawings.healthbargradient.Enabled = Flags["Draw Healthbar"]

            local health_color = Color3.new(1, 0, 0):lerp(Color3.new(0.7, 0.8, 0), self.healthlerp)
            health_color = health_color:lerp(Color3.new(0, 1, 0), math.clamp((self.healthlerp - 0.5) * 2, 0, 1))
            local health_offset = math.clamp((1 - self.healthlerp), 0, 1)

            if pos == "Top" or pos == "Bottom" then
                self.drawings.healthbargradient.Rotation = 0
                self.drawings.healthbargradient.Offset = Vector2.new(health_offset, 0)
            else
                self.drawings.healthbargradient.Rotation = -90
                self.drawings.healthbargradient.Offset = Vector2.new(0, -health_offset)
            end

            if Flags["Healthbar Type"] == "Solid" then
                self.drawings.healthbargradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, health_color), ColorSequenceKeypoint.new(1, health_color) }
            elseif Flags["Healthbar Type"] == "Rainbow" then
                local colors = { Color3.fromRGB(255,179,186), Color3.fromRGB(255,223,186), Color3.fromRGB(255,255,186), Color3.fromRGB(186,255,201), Color3.fromRGB(186,225,255), Color3.fromRGB(201,186,255) }
                if Flags["Healthbar Animation"] then
                    local t = tick() * Flags["Healthbar Animation Speed"]
                    local f = t % 6
                    local i = floor(f) + 1
                    local nexti = i % 6 + 1
                    local blend = f % 1
                    local rotated = {}
                    for idx = 1, 6 do
                        rotated[idx] = colors[((idx - 1 + i - 1) % 6) + 1]:Lerp(colors[((idx - 1 + nexti - 1) % 6) + 1], blend)
                    end
                    colors = rotated
                end
                self.drawings.healthbargradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, colors[1]), ColorSequenceKeypoint.new(0.2, colors[2]), ColorSequenceKeypoint.new(0.4, colors[3]), ColorSequenceKeypoint.new(0.6, colors[4]), ColorSequenceKeypoint.new(0.8, colors[5]), ColorSequenceKeypoint.new(1, colors[6]) }
            elseif Flags["Healthbar Type"] == "Gradient" then
                if Flags["Healthbar Animation"] then
                    local t = tick() * Flags["Healthbar Animation Speed"]
                    local colors = { Flags["Healthbar Bottom Color"], Flags["Healthbar Middle Color"], Flags["Healthbar Top Color"] }
                    local f = t % 3
                    local i = floor(f) + 1
                    local nexti = i % 3 + 1
                    local blend = f % 1
                    local rotated = {}
                    for idx = 1, 3 do
                        rotated[idx] = colors[((idx - 1 + i - 1) % 3) + 1]:Lerp(colors[((idx - 1 + nexti - 1) % 3) + 1], blend)
                    end
                    self.drawings.healthbargradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, rotated[1]), ColorSequenceKeypoint.new(0.5, rotated[2]), ColorSequenceKeypoint.new(1, rotated[3]) }
                else
                    self.drawings.healthbargradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Flags["Healthbar Bottom Color"]), ColorSequenceKeypoint.new(0.5, Flags["Healthbar Middle Color"]), ColorSequenceKeypoint.new(1, Flags["Healthbar Top Color"]) }
                end
            end

            if self.drawings.healthtext then
                if health >= max_health then
                    self.drawings.healthtext.Visible = false
                else
                    self.drawings.healthtext.Visible = Flags["Draw Healthtext"]
                    self.drawings.healthtext.TextColor3 = Flags["HealthText Color"]
                    self.drawings.healthtext.Text = tostring(floor(health))

                    if pos == "Right" then
                        self.drawings.healthtext.Position = UDim2.new(0, healthbar_x + healthbar_w, 0, healthbar_y)
                    elseif pos == "Left" then
                        self.drawings.healthtext.Position = UDim2.new(0, healthbar_x, 0, healthbar_y)
                    elseif pos == "Top" then
                        self.drawings.healthtext.Position = UDim2.new(0, healthbar_x + healthbar_w/2 - self.drawings.healthtext.TextBounds.X/2, 0, healthbar_y)
                    elseif pos == "Bottom" then
                        self.drawings.healthtext.Position = UDim2.new(0, healthbar_x + healthbar_w/2 - self.drawings.healthtext.TextBounds.X/2, 0, healthbar_y + healthbar_h)
                    end

                    if (self.drawings.healthtext.FontFace ~= Framework.CurrentFont) then self.drawings.healthtext.FontFace = Framework.CurrentFont end
                    if (self.drawings.healthtext.TextSize ~= Framework.CurrentSize) then self.drawings.healthtext.TextSize = Framework.CurrentSize end
                    self.drawings.healthtext.TextXAlignment = Enum.TextXAlignment.Center
                    self.drawings.healthtext.TextYAlignment = Enum.TextYAlignment.Center
                end
            end
        end;
        --
        function playerESP:drawviewdirection()
            local char = self.player.Character
            if not char then
                self.drawings.viewdirection.Visible = false;
                return;
            end;

            local head = char:FindFirstChild("Head")
            if not head or not head.CFrame then
                self.drawings.viewdirection.Visible = false;
                return;
            end;

            local startpos = head.Position;
            local endpos = startpos + head.CFrame.LookVector * (Flags["View Direction Length"] or 0);

            local s1, o1 = Camera:WorldToScreenPoint(startpos);
            local s2, o2 = Camera:WorldToScreenPoint(endpos);

            if not (o1 and o2) then
                self.drawings.viewdirection.Visible = false;
                return;
            end;

            local a = Vector2.new(s1.X, s1.Y);
            local b = Vector2.new(s2.X, s2.Y);
            local off = b - a;
            local mid = a + off/2;

            self.drawings.viewdirection.Position = UDim2.fromOffset(mid.X, mid.Y);
            self.drawings.viewdirection.Size = UDim2.fromOffset(off.Magnitude, 1);
            self.drawings.viewdirection.Rotation = math.deg(math.atan2(off.Y, off.X));
            self.drawings.viewdirection.Visible = Flags["View Direction"];
            self.drawings.viewdirectioncolor.Color = Flags["View Direction Color"];
            self.drawings.viewdirectioncolor.Enabled = true;
        end;
        --
        function playerESP:drawheadcircle(box_w, box_h)
            if not self.drawings.headcircle then return end;
            local char = self.player.Character;
            if not char then
                self.drawings.headcircle.Visible = false;
                return;
            end;

            local head = char:FindFirstChild("Head");
            if not head then
                self.drawings.headcircle.Visible = false;
                return;
            end;

            local pos, on = Camera:WorldToScreenPoint(head.Position);
            if not on then
                self.drawings.headcircle.Visible = false;
                return;
            end;

            if not box_w or not box_h then
                self.drawings.headcircle.Visible = false;
                return;
            end;

            local s = math.min(box_w, box_h * 0.24);
            if s < 4 then s = 4 end;
            self.drawings.headcircle.BackgroundColor3 = Flags["Filled Circle Color"];
            self.drawings.headcircle.BackgroundTransparency = Flags["Filled Circle"] and Flags["Circle Fill Transparency"] / 100 or 1
            self.drawings.headcircle.Size = UDim2.new(0, s, 0, s);
            self.drawings.circlecolor.Color = Flags["Head Dot Color"];
            self.drawings.headcircle.Position = UDim2.new(0, pos.X, 0, pos.Y);
            self.drawings.circlecolor.Enabled = Flags["Head Dot"];
            self.drawings.headcircle.Visible = Flags["Head Dot"];
        end;
        --
        function playerESP:drawchams()
            self.drawings.highlight.Adornee = self.player.Character
            self.drawings.highlight.Enabled = Flags["Player Chams"]
            self.drawings.highlight.FillColor = Flags["Chams Color"]
            self.drawings.highlight.OutlineColor = Flags["Chams Color2"]
            self.drawings.highlight.FillTransparency = Flags["Fill Transparency"] / 100
            self.drawings.highlight.OutlineTransparency = Flags["Outline Transparency"] / 100

            if Flags["Chams Type"] == "Breathe" then
                local e = math.atan(math.sin(tick()*3))*2/math.pi
                self.drawings.highlight.FillTransparency = Flags["Fill Transparency"] * e * 0.01
            end;

            self.drawings.highlight.DepthMode = Flags["Visible Check"] and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
        end;
    end;
    --
    do -- Update
        function Functions.UpdateESP()
            if (not Flags["Enable ESP"]) then
                for _, obj in pairs(playerESP.objects) do
                    obj:sethidden();
                end;
                return;
            end;

            for player, obj in pairs(playerESP.objects) do
                local hum = obj.hum;
                if (not hum and player.Character) then
                    hum = player.Character:FindFirstChildOfClass("Humanoid");
                    obj.hum = hum;
                end;

                if (not hum or hum.Health <= 0) then
                    obj:sethidden();
                    continue;
                end;

                local CFrame, size, position = playerESP.GetBounds(player.Character);
                if (not position) then
                    obj:sethidden();
                    continue;
                end;

                local screenpos, onscreen = Camera:WorldToScreenPoint(position);
                if (not onscreen) then
                    obj:sethidden();
                    continue;
                end;

                local distance = (position - Camera.CFrame.Position).Magnitude;
                if Flags["Render Units"] == "Meters" then
                    distance = distance * 0.28;
                elseif Flags["Render Units"] == "Feet" then
                    distance = distance * 0.92;
                end;
                distance = math.round(distance);
                if (distance >= Flags["Render Distance"]) then
                    obj:sethidden();
                    continue;
                end;

                local fov = Camera.FieldOfView;
                local zoom = clamp(60 / fov, 1, 1.25);
                local height = tan(rad(fov * 0.5)) * 2 * screenpos.Z;
                local scale = vec2(((Camera.ViewportSize.Y / height) * size.X) * zoom, ((Camera.ViewportSize.Y / height) * size.Y) * zoom);
                local box_x, box_y = screenpos.X - scale.X/2, screenpos.Y - scale.Y/2;

                do
                    obj:drawbox(box_x, box_y, scale.X, scale.Y);
                    obj:drawhealthbar(scale.Y, box_x, box_y);
                    obj:drawusername(box_x + scale.X / 2, box_y - Flags["Name Offset"], distance);
                    obj:drawtarget(box_x + scale.X / 2, box_y - Flags["Name Offset"]);
                    obj:drawhelditem(box_x + scale.X / 2, box_y + scale.Y + Flags["Held Item Offset"]);
                    obj:drawdistance(distance);
                    obj:drawheadcircle(scale.X, scale.Y);
                    obj:drawflags(box_x, box_y, scale.X);
                    obj:drawviewdirection();
                    obj:drawchams();
                end;
            end;
        end;
        --
        do
            Players.PlayerAdded:Connect(function(player)
                if (player) then playerESP.create(player) end;
            end);

            Players.PlayerRemoving:Connect(function(player)
                if (player) then playerESP.remove(player) end;
            end);

            for _, p in ipairs(Players:GetPlayers()) do
                if (p) then playerESP.create(p) end;
            end;
        end;
    end;
end;

do -- Connections
    Framework:Connect(Services.RunService.Heartbeat, function()

        do -- ESP
            Functions.UpdateESP();
        end;

    end);
end;