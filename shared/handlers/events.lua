local RegisterNetEvent <const>, AddEventHandler <const>, TriggerEvent <const>, joaat <const> = RegisterNetEvent, AddEventHandler, TriggerEvent, joaat
local tokenServer <const>, tokenClient = sl.service == 'server' and require('server.modules.tokenizer'), nil
local callback <const> = sl.service == 'server' and require 'imports.callback.server' or require 'imports.callback.client'

local timers = {}

---@param name string
---@return table|false
local function IsEventCooldown(name, source)
    if sl.service == 'server' then
        if timers[source] then
            return timers[source][name]
        end
    end
    if timers[name] then
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

    if sl.service == 'server' then
        if global then
            timers[name] = self
        else
            if not timers[source] then
                timers[source] = {}
            end
            timers[source][name] = self
        end
    elseif sl.service == 'client' then
        timers[name] = self
    end
end

local function FormatEvent(name, from)
    return ("__sl__:%s:%s"):format(from or sl.service, joaat(name))
end

function sl.on(name, cb, cooldown, global)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return end

    if sl.service == 'client' then
        if type(cooldown) == 'number' then
            RegisterCooldown(name, cooldown)
        end

        local eventHandler = function(...)
            local eventCooldown = IsEventCooldown(name)
            if eventCooldown and eventCooldown:onCooldown() then
                return warn('Ignoring event', name, 'because of cooldown'..'\n')
            end
            cb(...)
        end
        return AddEventHandler(FormatEvent(name), eventHandler)
    elseif sl.service == 'server' then
        local eventHandler = function(token, ...)
            if not token or token ~= tokenServer then return end
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
        return AddEventHandler(FormatEvent(name), eventHandler)
    end
end

function sl.onNet(name, cb, cooldown, global)
    if type(name) ~= 'string' then return end
    if cb and (type(cb) ~= 'table' and type(cb) ~= 'function') then return RegisterNetEvent(FormatEvent(name)) end
    if sl.service == 'client' then
        if type(cooldown) == 'number' then
            RegisterCooldown(name, cooldown)
        end
        local eventHandler = function(...)
            local eventCooldown = IsEventCooldown(name)
            if eventCooldown and eventCooldown:onCooldown() then
                return warn('Ignoring event', name, 'because of cooldown'..'\n')
            end
            cb(...)
        end
        return RegisterNetEvent(FormatEvent(name), eventHandler)
    elseif sl.service == 'server' then
        local eventHandler = function(token, ...)
            if not token or token ~= tokenServer then return warn(("source : %s a éxécuter un event sans avoir le token"):format(source)) end
            if cooldown and not global then
                local eventCooldown = IsEventCooldown(name, source)
                if eventCooldown and eventCooldown:onCooldown() then
                    return warn('Ignoring event', name, 'because of cooldown for source : '..source..'\n')
                end
                RegisterCooldown(name, cooldown)
            elseif cooldown and global then
                local eventCooldown = IsEventCooldown(name)
                if eventCooldown and eventCooldown:onCooldown() then
                    return warn('Ignoring event : '..name..'because of global cooldown'..'\n')
                end
                RegisterCooldown(name, cooldown, global)
            end
            cb(source, ...)
        end
        return RegisterNetEvent(FormatEvent(name), eventHandler)
    end
end

if sl.service == 'server' then
    callback.register(joaat('token'), function(source)
        return tokenServer
    end)

    local TriggerClientEvent <const> = TriggerClientEvent

    function sl.emitNet(name, source, ...) -- @ TriggerClientEvent
        if type(name) ~= 'string' then return end
        TriggerClientEvent(FormatEvent(name, 'client'), source, ...)
    end

    function sl.emit(name, ...) -- @ TriggerEvent
        if type(name) ~= 'string' then return end
        TriggerEvent(FormatEvent(name), tokenServer, ...)
    end
elseif sl.service == 'client' then
    local TriggerServerEvent <const> = TriggerServerEvent

    function sl.emitNet(name, ...) -- @ TriggerServerEvent
        if not tokenClient then tokenClient = callback.sync(joaat('token')) end
        if type(name) ~= 'string' then return end
        TriggerServerEvent(FormatEvent(name, 'server'), tokenClient, ...)
    end

    function sl.emit(name, ...) -- @ TriggerEvent
        if type(name) ~= 'string' then return end
        TriggerEvent(FormatEvent(name), ...)
    end
end