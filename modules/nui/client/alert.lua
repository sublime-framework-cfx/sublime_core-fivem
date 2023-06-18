local p

local function Alert(data)
    
    sl.sendReactMessage(true, {
        action = 'sl:alert:show',
        data = data
    }, {
        focus = true
    })

    p = promise.new()
    return sl.await(p)
end

function sl.showAlert(data)
    if p then return end
    return Alert(data)
end

sl.registerReactCallback('sl:alert:submit', function(data, cb)
    cb(1)
    if p then p:resolve(data) end p = nil
end, true)