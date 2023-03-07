local events = {}

--- sl:callbacks
---@param key any
---@return function
RegisterNetEvent("sl:callbacks", function(key, ...)
	local cb <const> = events[key]
	return cb and cb(...)
end)

--- TriggerServerCallback
---@param _ any
---@param event string
---@param cb function or boolean
---@param ... any
---@return ...
local function TriggerServerCallback(_, event, cb, ...)
	local key repeat key = ('%s:%s'):format(event, math.random(0, 100000)) until not events[key]
	TriggerServerEvent(("sl:%s_cb"):format(event), key, ...)
    ---@type boolean or promise
	local promise = not cb and promise.new()
	events[key] = function(response, ...)
        response = {response, ...}
		events[key] = nil
		if promise then
			return promise:resolve(response)
		end
        if cb then
            cb(table.unpack(response))
        end
	end
	if promise then
		return table.unpack(Citizen.Await(promise))
	end
end

--- TriggerServerAwaitCallback
---@param event string
---@return function
local function TriggerServerAwaitCallback(event, ...)
	return TriggerServerCallback(nil, event, false, ...)
end

--- CallbackResponse
---@param success any
---@param result any
---@param ... any
---@return boolean or any
local function CallbackResponse(success, result, ...)
	if not success then
		if result then
			return sl.log.print(3, "^1Erreur callback (%s)", result)
		end
		return false
	end
	return result, ...
end

local pcall <const> = pcall

--- Register
---@param name string
---@param cb function
local function Register(name, cb)
    RegisterNetEvent(("sl:%s_cb"):format(name), function(resource, key, ...)
        TriggerServerEvent(("sl:%s_cb"):format(resource), key, CallbackResponse(pcall(cb, ...)))
    end)
end

return {
	trigger = TriggerServerCallback,
	trigger_await = TriggerServerAwaitCallback,
	register = Register,
}