
local bindData = {}

--- Register
---@param key string
---@param name string
---@param desc string
---@param callback function
local function Register(key, name, desc, callback)
    key = string.upper(key)
    local cmd <const> = ("sl_%s"):format(name)
    if callback then
        bindData[#bindData+1] = {
            key = key,
            name = cmd,
            desc = desc,
            callback = callback,
            active = true,
        }
        RegisterCommand(cmd, function()
            for k,v in pairs(bindData) do
                if v.key == key then
                    if v.active then
                        callback()
                    end
                end
            end
        end, true)
        RegisterKeyMapping(cmd, desc, 'keyboard', key)
    else
        sl.log.print(3, "Regiser Keybind [%s - %s] Callback invalid or not found", key, name)
    end
end

--- Active
---@param state boolean
---@param btnIndex function
local function Active(state, btnIndex)
    for _,v in pairs(bindData) do
        if btnIndex then
            if v.key == string.upper(btnIndex) then
                v.active = state
            end
        else
            v.active = state
        end
    end
end

return {
    register = Register,
    active = Active,
}