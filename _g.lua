local sl_core <const>, service <const> = 'sublime_core', (IsDuplicityVersion() and 'server') or 'client'
local LoadResourceFile <const>, IsDuplicityVersion <const>, GetGameName <const>, joaat <const>, await <const>, GetCurrentResourceName <const> = LoadResourceFile, IsDuplicityVersion, GetGameName, joaat, Citizen.Await, GetCurrentResourceName

---@param index string
---@param service string<'client' | 'server'>
---@return any
local function load_module(index, service)
    local dir <const> = ("imports/%s"):format(index)
    local chunk <const> = LoadResourceFile(sl_core, ('%s/%s.lua'):format(dir, service))
    local shared <const> = LoadResourceFile(sl_core, ('%s/shared.lua'):format(dir))
    local func, err
    
    if chunk or shared then
        if shared then
            func, err = load(shared, ('@@%s/%s/%s'):format(sl_core, index, 'shared'))
        else
            func, err = load(chunk, ('@@%s/%s/%s'):format(sl_core, index, service))
        end

        if not func or err then return error(("Error to load module\n- From : %s\n- Module : %s\n- Service : %s\n - Error : %s"):format(dir, index, service, err), 3) end

        local result = func()
        return result
    end
end

---@param name string
---@param from? string<'client' | 'server'> default is sl.service
---@return string
local function FormatEvent(self, name, from)
    return ("__sl__:%s:%s"):format(from or self.service, joaat(name))
end

sl = setmetatable({
    service = service, ---@type string<'client' | 'server'>
    name = GetCurrentResourceName(), ---@type string<'sublime_core'>
    game = GetGameName(), ---@type string<'fivem' | 'redm'>
    env = GetInvokingResource() == GetCurrentResourceName() and sl_core or GetInvokingResource() or 'unknown',
    hashEvent = FormatEvent,
    await = await,
    lang = GetConvar('sl:locale', 'fr') ---@type string<'fr' | 'en' | unknown>
}, {
    __newindex = function(self, name, func)
    rawset(self, name, func)
    exports(name, func)
end})

require = load_module('require', 'shared').load ---@load require over write
require('imports.locales.shared').init() ---@load translation

if sl.service == 'server' then
print([[
^6###############################################################################
^6# ^2ssss   u  u  bbbbb   l    iii mm   mm  eeee      cccc   ooo   rrrrrr  eeee  ^6#
^6# ^2s      u  u  b    b  l     i  mmm mmm ee   e    c      o   o  rrr    ee   e ^6#
^6# ^2 sss   u  u  bbbbb   l     i  mm m mm eeeee     c      o   o  rr     eeeee  ^6#
^6# ^2    s  u  u  b    b  l     i  mm   mm ee    ^7...^2 c      o   o  rr     ee     ^6#
^6# ^2ssss   uuuu  bbbbbb  llll iii mm   mm  eeee ^7...^2  cccc   ooo   rr      eeee  ^6#
^6#                                                                             ^6#
^6#       ^7Github: ^4https://github.com/sublime-framework-cfx/sublime_core         ^6#
^6#                                                                             ^6#
^6###############################################################################
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