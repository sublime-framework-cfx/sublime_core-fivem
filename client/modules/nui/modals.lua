local onCallback, p

---@class DataConfirmProps
---@field title? string
---@field description? string
---@field transition? { name: string, duration: number, timingFunction: string } refer to MantineUI transition provider

---@class ModalConfirm
---@field data? DataConfirmProps

---@class DataCustomProps
---@field title string
---@field options { type: 'checkbox' | 'input' | 'select' | 'date' | 'password' | 'number', label: string }
---@field canCancel? boolean
---@field transition? { name: string, duration: number, timingFunction: string } refer to MantineUI transition provider

---@class ModalCustom
---@field data DataCustomProps
---@field callback fun(index: number, value: any)

---@param title string
---@param data DataCustomProps
---@param callback fun(index: number, value: any)
---@return table|nil
---@type ModalCustom
local function Custom(self, data, callback) 
    if type(data) ~= 'table' then return end
    if type(data.title) ~= 'string' then return end
    onCallback = callback

    self:sendReactMessage(true, {
        action = 'sl:modal:opened-custom',
        data = {
            title = data.title,
            canCancel = data.canCancel or true,
            transition = data.transition,
            options = data.options
        }
    }, {
        focus = true
    })

    p = promise.new()
    return self.await(p)
end

---@param data DataConfirmProps
---@return boolean
---@type ModalConfirm
local function Confirm(self, data)
    if type(data) ~= 'table' then return end
    
    self:sendReactMessage(true, {
        action = 'sl:modal:opened-confirm',
        data = data
    }, {
        focus = true
    })

    p = promise.new()
    return self.await(p)
end

---@param types custom | confirm as string
---@param data table
---@param callback fun(index: number, value: any)
---@return table|boolean|nil
function sl:openModal(types, data, callback)
    if p then return end
    if type(types) ~= 'string' then return end
    if types == 'custom' then
        return Custom(self, data, callback)
    elseif types == 'confirm' then
        return Confirm(self, data)
    end
end

---@param data boolean
sl:registerReactCallback('sl:modal:confirm', function(data, cb)
    if p then p:resolve(data) end p = nil
    cb(1)
end, true)

---@param data table
sl:registerReactCallback('sl:modal:submit', function(data, cb)
    cb(1)
    if p then p:resolve(data) end p, onCallback = nil, nil
end, true)

sl:registerReactCallback('sl:modal:callback', function(data, cb)
    cb(1)
    onCallback(data.index, data.value)
end)