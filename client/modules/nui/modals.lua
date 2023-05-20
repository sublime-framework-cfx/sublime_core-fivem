local open, onCb, p = {}

---@class ModalConfrim
---@field type 'confirm'
---@field title? string
---@field subtitle? string
---@field description? string

---@class ModalCustom
---@field type 'custom'
---@field title? string
---@field options {type: 'checkbox' | 'input' | 'select' | 'textarea'}

--- supv.openModal
---@param data ModalConfrim|ModalCustom|...
---@return boolean
function sl:openModal(data, onCallback)
    if type(data) ~= 'table' then return end
    if type(data.type) ~= 'string' then return end
    if p then return end

    if data.type == 'custom' and (not data.options or #data.options < 1) then return end
    if onCallback then
        onCb = onCallback
        for i = 1, #data.options do
            local o = data.options[i]
            if o.callback then
                open[i] = true
            end
        end
    end

    self:sendReactMessage(true, {
        action = 'sl:modal:opened',
        data = data
    }, {
        focus = data.focus or true
    })

    p = promise.new()
    return self.await(p)
end

---@param data boolean
sl:registerReactCallback('sl:modal:closedCondirm', function(data, cb)
    if p then p:resolve(data) end p = nil
    cb(1)
end, true)

---@param data table
sl:registerReactCallback('sl:modal:closedCustom', function(data, cb)
    if p then
        local temp = {}
        for k, v in pairs(data) do
            temp[tonumber(k)+1] = v
        end
        p:resolve(temp)
    end p = nil
    open = {}
    cb(1)
end, true)

sl:registerReactCallback('sl:modal:callback', function(data, cb)
    cb(1)
    data.index += 1
    onCb(data.index, data.value)
end)