local nui <const> = require 'client.modules.nui'

local function notify(select, data)
    if not data.position then data.position = 'top-right' end

    if select == 'simple' then
        nui.SendReactMessage(true,{
            action = 'supv:notification:send',
            data = data
        })
    end
end

sl.notify = notify -- Export notify function
sl.onNet('notify', notify) -- Register notify event for server