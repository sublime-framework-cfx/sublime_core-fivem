local sl_core <const>, service <const> = 'sublime_core', (IsDuplicityVersion() and 'server') or 'client'
local LoadResourceFile <const>, IsDuplicityVersion <const>, joaat <const>, await <const>, GetCurrentResourceName <const> = LoadResourceFile, IsDuplicityVersion, joaat, Citizen.Await, GetCurrentResourceName

---@param name string
---@param from? string<'client' | 'server'> default is sl.service
---@return string
local function FormatEvent(self, name, from)
    return ("__sl__:%s:%s"):format(from or self.service, joaat(name))
end

sl = setmetatable({
    service = service, ---@type string<'client' | 'server'>
    name = sl_core, ---@type string<'sublime_core'>
    env = sl_core, ---@type string<'resource_name?'>
    hashEvent = FormatEvent,
    await = await,
    lang = GetConvar('sl:locale', 'fr') ---@type string<'fr' | 'en' | unknown>
}, {
    __newindex = function(self, name, value)
        rawset(self, name, value)
        if type(value) == 'function' then
            exports(name, value)
        end
    end
})

local loaded = {}

package = {
    loaded = setmetatable({}, {
        __index = loaded,
        __newindex = function() end,
        __metatable = false,
    }),
    path = './?.lua;'
}

local _require = require

function require(modname)
    --print('require', modname)

    local module = loaded[modname]
    if not module then
        if module == false then
            error(("^1circular-dependency occurred when loading module '%s'^0"):format(modname), 2)
        end

        local success, result = pcall(_require, modname)

        if success then
            loaded[modname] = result
            return result
        end

        local modpath = modname:gsub('%.', '/')
        local paths = { string.strsplit(';', package.path) }
        for i = 1, #paths do
            local scriptPath = paths[i]:gsub('%?', modpath):gsub('%.+%/+', '')
            local resourceFile = LoadResourceFile(sl_core, scriptPath)
            if resourceFile then
                loaded[modname] = false
                scriptPath = ('@@%s/%s'):format(sl_core, scriptPath)

                local chunk, err = load(resourceFile, scriptPath)

                if err or not chunk then
                    loaded[modname] = nil
                    return error(err or ("unable to load module '%s'"):format(modname), 3)
                end

                module = chunk(modname) or true
                loaded[modname] = module

                return module
            end
        end

        return error(("module '%s' not found"):format(modname), 2)
    end

    return module
end

require('imports.locales.shared').init() ---@load translation

if sl.service == 'server' then
    print([[
^6#####################################################################################
^6#^2                _       _   _                                                      ^6#
^6#^2               | |     | | (_)                                                     ^6#
^6#^2  ___   _   _  | |__   | |  _   _ __ ___     ___        ___    ___    _ __    ___  ^6#
^6#^2 / __| | | | | | '_ \  | | | | | '_ ` _ \   / _ \      / __|  / _ \  | '__|  / _ \ ^6#
^6#^2 \__ \ | |_| | | |_) | | | | | | | | | | | |  __/^7  _ ^2 | (__  | (_) | | |    |  __/ ^6#
^6#^2 |___/  \__,_| |_.__/  |_| |_| |_| |_| |_|  \___|^7 (_)^2  \___|  \___/  |_|     \___| ^6#
^6#                                                                                   ^6#
^6#^2           ^7Github: ^4https://github.com/sublime-framework-cfx/sublime_core           ^6#
^6#####################################################################################
]])
    require('imports.version.server').check('github', nil, 500) ---@load version check && check update
    require('imports.mysql.server').init() ---@load oxmysql
end

---@type table<string, function>
callback = require(('imports.callback.%s'):format(sl.service)) ---@load callback module

---@credit ox_lib <https://github.com/overextended/ox_lib/blob/master/init.lua>
local intervals = {}
---@param callback function | number
---@param interval? number
---@param ... any
function SetInterval(cb, interval, ...)
    interval = interval or 0

    if type(interval) ~= 'number' then
        return error(('Interval must be a number. Received %s'):format(json.encode(interval --[[@as unknown]])))
    end

    local cbType = type(cb)

    if cbType == 'number' and intervals[cb] then
        intervals[cb] = interval or 0
        return
    end

    if cbType ~= 'function' then
        return error(('Callback must be a function. Received %s'):format(cbType))
    end

    local args, id = { ... }

    Citizen.CreateThreadNow(function(ref)
        id = ref
        intervals[id] = interval or 0
        repeat
            interval = intervals[id]
            Wait(interval)
            cb(table.unpack(args))
        until interval < 0
        intervals[id] = nil
    end)

    return id
end

---@param id number
function ClearInterval(id)
    if type(id) ~= 'number' then
        return error(('Interval id must be a number. Received %s'):format(json.encode(id --[[@as unknown]])))
    end

    if not intervals[id] then
        return error(('No interval exists with id %s'):format(id))
    end

    intervals[id] = -1
end