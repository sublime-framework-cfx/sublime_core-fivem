local events = {}
local cbEvent = ('__sl_cb_%s')

--- sl:callbacks
---@param key any
---@return function
RegisterNetEvent(cbEvent:format("sublime_core"), function(key, ...)
	local cb <const> = events[key]
	return cb and cb(...)
end)

---@param _ any
---@param event string
---@param playerId number
---@param cb function or boolean
---@param ... any
---@return ...
local function TriggerClientCallback(event, playerId, cb, ...)
	local key repeat key = ('%s:%s:%s'):format(event, math.random(0, 100000), playerId) until not events[key]
	TriggerClientEvent(cbEvent:format(event), playerId, "sublime_core", key, ...)
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
---@param playerId number
---@param ... any
---@return function
local function TriggerClientAwaitCallback(event, playerId, ...)
	return TriggerClientCallback(event, playerId, false, ...)
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
	RegisterNetEvent(cbEvent:format(name), function(resource, key, ...)
		TriggerClientEvent(cbEvent:format(resource), source, key, CallbackResponse(pcall(cb, source, ...)))
	end)
end

return {
	trigger = TriggerClientCallback,
	trigger_await = TriggerClientAwaitCallback,
	register = Register,
}