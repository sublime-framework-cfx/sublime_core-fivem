local function notify(source, select, data)
    sl:emitNet('notify', source, select, data)
end

sl.notify = notify