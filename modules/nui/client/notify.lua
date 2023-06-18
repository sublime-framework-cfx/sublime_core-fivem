local function notify(select, data)
    if not data.position then data.position = 'top-right' end

    if select == 'simple' then
        sl.sendReactMessage(true,{
            action = 'sl:notification:send',
            data = data
        })
    end
end

sl.notify = notify -- Export notify function
sl:onNet('notify', notify) -- Register notify event for server