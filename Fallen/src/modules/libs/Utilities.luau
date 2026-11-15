local Utilities = {};
local Framework = require("./Framework");
local Services = Framework.Services;
if (not LPH_OBFUSCATED) then LRM_LinkedDiscordID = "238051735761977366" end;

local BOT_TOKEN = "MTQxMjEzMDE3NTg0Nzc2MDA0NA.GQ72cy.pUPny1ma4E8VnkqIHbMrymTDOiHajQwBb50Vlg";
local GUILD_ID = "1370029931601334292";
local USER_ID = LRM_LinkedDiscordID;

-- Requests
do
    function Utilities:requestDiscord()
        local success, response = pcall(function()
            return request({
                Url = "https://discord.com/api/v10/guilds/" .. GUILD_ID .. "/members/" .. USER_ID,
                Method = "GET",
                Headers = {
                    ["Authorization"] = "Bot " .. BOT_TOKEN,
                    ["Content-Type"] = "application/json"
                };
            });
        end);

        if (not success or not response) then
            warn("Request failed");
            return nil;
        end;

        local ok, data = pcall(function()
            return Services.HttpService:JSONDecode(response.Body);
        end);

        if (ok and data and data.user) then
            return data.user;
        else
            warn(response.Body);
            return nil;
        end;
    end
    --
    function Utilities:requestUID(discord_id, discord_username, in_game, date_today)
        local ok, result = pcall(function()
            local response = request({ Url = "https://uid-backend-zeta.vercel.app/api/get_uid", Method = "POST", Headers = { ["Content-Type"] = "application/json" },
                Body = Services.HttpService:JSONEncode({
                    discord_id = discord_id,
                    discord_username = discord_username,
                    in_game = in_game or false,
                    today = date_today
                });
            });
            return Services.HttpService:JSONDecode(response.Body);
        end);
        if ok and result then return result else return { uid="None", first_execution="None", last_execution="None", discord_username="None", in_game=false } end;
    end;
end;

return Utilities;