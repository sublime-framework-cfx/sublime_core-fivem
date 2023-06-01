local discord <const> = require 'config.client.rich-presence'.discord
local AddStateBagChangeHandler <const> = AddStateBagChangeHandler
local SetRichPresence <const> = SetRichPresence
local GetGameTimer <const> = GetGameTimer
local richPresence = {}

function richPresence:set(key, value)
    if self[key] ~= value then self[key] = value end
    SetRichPresence(('Players: %s/%s\n[%s] - %s'):format(self.count or GlobalState.playersCount, discord.maxPlayers, cache.serverid, not LocalPlayer.state.username and self.username or LocalPlayer.state.username))
end

CreateThread(function()
    local SetDiscordAppId <const> = SetDiscordAppId
    local SetDiscordRichPresenceAsset <const> = SetDiscordRichPresenceAsset
    local SetDiscordRichPresenceAssetText <const> = SetDiscordRichPresenceAssetText
    local SetDiscordRichPresenceAssetSmall <const> = SetDiscordRichPresenceAssetSmall
    local SetDiscordRichPresenceAssetSmallText <const> = SetDiscordRichPresenceAssetSmallText

    SetDiscordAppId(discord.id)
    SetDiscordRichPresenceAsset(discord.largeIcon)
    SetDiscordRichPresenceAssetText(discord.largeIconText)
    SetDiscordRichPresenceAssetSmall(discord.smallIcon)
    SetDiscordRichPresenceAssetSmallText(discord.smallIconText)

    if discord.buttons and #discord.buttons > 0 then
        local SetDiscordRichPresenceAction <const> = SetDiscordRichPresenceAction
        for i = 0, #(discord.buttons) do
            local button <const> = discord.buttons[i]
            SetDiscordRichPresenceAction(i, button.text, button.url)
        end
    end

    local PlayerId <const> = PlayerId
    local GetPlayerServerId <const> = GetPlayerServerId

    cache.playerid = PlayerId()
    cache.serverid = GetPlayerServerId(cache.playerid)
    local playerName = GetPlayerName(cache.playerid)
    
    richPresence:set('username', playerName)
end)

AddStateBagChangeHandler('playersCount', 'global', function(bagName, key, value, reserved, replicated)
    local time <const>, timer <const> = GetGameTimer(), 4000
    while (time + timer) > GetGameTimer() do Wait(1000) end
    richPresence:set('count', GlobalState.playersCount == value and value or GlobalState.playersCount)
end)