string.to_utf8 = require ('server.modules.utf8').to_utf8
local config <const> = require 'config.server.webhook'
local toUpper <const> = require('imports.string.shared').firstToUpper
assert(os.setlocale(config.localization))

local PerformHttpRequest <const> = PerformHttpRequest
---@class WebhookDataProps
---@field bot_name? string
---@field avatar? string
---@field date_format? string
---@field footer_icon? string

---@class WebhookEmbedProps
---@field title? string
---@field description? string
---@field image? string
---@field color? integer

---@class WebhookMessageProps
---@field text string
---@field data WebhookDataProps

--- sl.webhook('embed')
---@param url string
---@param embeds WebhookEmbedProps
---@param data WebhookDataProps
local function embed(url, embeds, data)
    local date = {
        letter = ("\n%s %s"):format(toUpper(os.date("%A %d")), toUpper(os.date("%B %Y : [%H:%M:%S]"))):to_utf8(),
        numeric = ("\n%s"):format(os.date("[%d/%m/%Y] - [%H:%M:%S]"))
    }

    url = config.channel[url] or url

    local _embed = {
        {
			["color"] = data?.color or config.default.color,
			["title"] = embeds.title or '',
			["description"] = embeds.description or '',
			["footer"] = {
				["text"] = data?.date_format and date[data?.date_format] or config.default.date_format and date[config.default.date_format],
				["icon_url"] = data?.footer_icon or config.default.foot_icon,
			},
            ['image'] = {
                ['url'] = embeds.image or nil
            }
		},
    }

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({
        username = data?.bot_name or config.default.bot_name,
        embeds = _embed,
        avatar_url = data?.avatar or config.default.avatar,
    }), {['Content-Type'] = 'application/json'})
end

--- sl.webhook('message')
---@param url string
---@param text string
---@param data WebhookDataProps.bot_name
local function message(url, text, data)
    url = config.channel[url] or url

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({
        username = data.bot_name or config.default.bot_name,
        content = text
    }), {['Content-Type'] = 'application/json', ['charset'] = 'utf-8'})
end

---@param types string
---@param ... any
---@return void
function sl.webhook(types, ...)
    if types == 'embed' then
        return embed(...)
    elseif types == 'message' then
        return message(...)
    end
    return error("Invalid types of webhook", 1)
end

if config.played_from ~= 'shared' then return end

sl.onNet('webhook:received', function (source, types, ...)
    warn(source, 'play webhook from client')
    sl.webhook(types, ...)
end)