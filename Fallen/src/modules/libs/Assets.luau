local Assets = {
    Images = {};
    Sounds = {};
    Skyboxes = {};
};

local FontManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/sentineland/Sentinel/refs/heads/main/Fonts/FontManager.lua"))();
do -- Fonts
    Assets.Fonts = {
        SmallestPixel = FontManager:register("Radiance/Fonts", { name = "SmallestPixel", link = "https://raw.githubusercontent.com/judghementday2/bypass/refs/heads/main/smallest_pixel-7.ttf" });
        Templeos      = FontManager:register("Radiance/Fonts", { name = "Templeos", link = "https://raw.githubusercontent.com/judghementday2/bypass/refs/heads/main/Templeos.ttf" });
        ProggyTiny    = FontManager:register("Radiance/Fonts", { name = "ProggyTiny", link = "https://raw.githubusercontent.com/judghementday2/bypass/refs/heads/main/ProggyTiny.ttf" });
        ProggyClean   = FontManager:register("Radiance/Fonts", { name = "ProggyClean", link = "https://raw.githubusercontent.com/sentineland/Sentinel/refs/heads/main/Fonts/ProggyClean.ttf" });
        Retro         = FontManager:register("Radiance/Fonts", { name = "Retro", link = "https://raw.githubusercontent.com/sentineland/Sentinel/refs/heads/main/Fonts/Retro.ttf" });
        QuinqueFive   = FontManager:register("Radiance/Fonts", { name = "QuinqueFive", link = "https://raw.githubusercontent.com/sentineland/Sentinel/refs/heads/main/Fonts/QuinqueFive.ttf" });
        Micro         = FontManager:register("Radiance/Fonts", { name = "Micro", link = "https://raw.githubusercontent.com/sentineland/Sentinel/refs/heads/main/Fonts/Micro.ttf" });
        Elektr        = FontManager:register("Radiance/Fonts", { name = "Elektr", link = "https://raw.githubusercontent.com/sentineland/Sentinel/refs/heads/main/Fonts/Elektr.ttf" });
    };
end;

do -- Skyboxes
    local cache = {};
    function Assets.Skyboxes:Require(folder, face)
        if not cache[folder] then
            cache[folder] = tostring(os.time())
        end

        local tag = cache[folder]
        local path = ("Radiance/Skyboxes/%s/%s_%s.tex"):format(folder, face, tag)
        local url  = ("https://raw.githubusercontent.com/sentineland/Sentinel/refs/heads/main/Skyboxes/%s/%s.tex"):format(folder, face)

        writefile(path, game:HttpGet(url))
        return getcustomasset(path)
    end;
end;

do -- Images
    function Assets.Images:Require(name)
        local f = "Radiance/Images/" .. name .. ".png";
        if not isfile(f) then
            writefile(f, game:HttpGet("https://raw.githubusercontent.com/sentineland/Sentinel/refs/heads/main/Images/" .. name, true));
        end;
        return getcustomasset(f);
    end;
end;

do -- Sounds
    function Assets.Sounds:Require(name)
        local f = "Radiance/Sounds/" .. name .. ".mp3"
        if not isfile(f) then
            writefile(f, game:HttpGet("https://raw.githubusercontent.com/sentineland/Sentinel/refs/heads/main/Sounds/" .. name .. ".mp3", true))
        end
        return getcustomasset(f)
    end

    function Assets.Sounds:Play(name, volume, pitch)
        local sound = Instance.new("Sound")
        sound.SoundId = self:Require(name)
        sound.Parent = cloneref(workspace)
        sound.Volume = volume or 1
        sound.PlaybackSpeed = pitch or 1
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end
end;

return Assets;