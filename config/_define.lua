local config = {}

if sl.service == 'client' then
    config.client = {
        -- client
        ['firstspawn'] = require 'config.client.firstspawn',
        ['modules'] = require 'config.client.modules',
        ['rich-presence'] = require 'config.client.rich-presence',
        ['setting'] = require 'config.client.setting',

        -- shared
        ['models'] = require 'config.shared.models',
    }
else
    config.server = {
        ['permission'] = require 'config.server.permission',
        ['connect'] = require 'config.server.connect',
        ['setting'] = require 'config.server.setting',
        ['webhook'] = require 'config.server.webhook',

        --shared
        ['models'] = require 'config.shared.models',
    }
end

return config