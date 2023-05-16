local RegisterNetEvent <const>, AddEventHandler <const>, TriggerEvent <const>, joaat <const> = RegisterNetEvent, AddEventHandler, TriggerEvent, joaat
local callback <const> = require 'imports.callback.server'

sl.token = require 'server.modules.packages.tokenizer'

local timers = {}

---@param name string
---@return table|false
local function IsEventCooldown(name, source)
    if timers[source] then
        return timers[source][name]
    elseif timers[name] then
        return timers[name]
    end
    return false
end

---@return boolean
local function GetCooldown(self)
    if not self then return end
    local time = GetGameTimer()
    if (time - self.time) < self.cooldown then
        return true
    end
    self.time = time
    return false
end

---@param name string
---@param timer number
---@param global? boolean
local function RegisterCooldown(name, timer, global)
    local self = {}
    
    self.time = GetGameTimer()
    self.cooldown = timer
    self.onCooldown = GetCooldown

    if global then
        timers[name] = self
    else
        if not timers[source] then
            timers[source] = {}
        end
        timers[source][name] = self
    end
end

function sl:eventHandler(name, token, source, cb, cooldown, global, ...)
    if not token or token ~= self.token then return end
    if cooldown and not global then
        local eventCooldown = IsEventCooldown(name, source)
        if eventCooldown and eventCooldown:onCooldown() then
            return warn('Ignoring event', name, 'because of cooldown for source : '..source..'\n')
        end
        RegisterCooldown(name, cooldown)
    elseif cooldown and global then
        local eventCooldown = IsEventCooldown(name)
        if eventCooldown and eventCooldown:onCooldown() then
            return warn('Ignoring event : '..name, 'because of global cooldown'..'\n')
        end
        RegisterCooldown(name, cooldown, global)
    end
    cb(source, ...)
end

function sl:on(name, cb, cooldown, global)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return end

    local eventHandler = function(token, ...)
        return self:eventHandler(name, token, source, cb, cooldown, global, ...)
    end
    return AddEventHandler(self:hashEvent(name), eventHandler)
end

function sl:onNet(name, cb, cooldown, global)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return RegisterNetEvent(self:hashEvent(name)) end

    local eventHandler = function(token, ...)
        return self:eventHandler(name, token, source, cb, cooldown, global, ...)
    end
    return RegisterNetEvent(self:hashEvent(name), eventHandler)
end

callback.register(joaat('token'), function(source)
    return sl.token
end)

local TriggerClientEvent <const> = TriggerClientEvent

function sl:emitNet(name, source, ...) -- @ TriggerClientEvent
    if type(name) ~= 'string' then return end
    TriggerClientEvent(self:hashEvent(name, 'client'), source, ...)
end

function sl:emit(name, ...) -- @ TriggerEvent
    if type(name) ~= 'string' then return end
    TriggerEvent(self:hashEvent(name), self.token, ...)
end
