local sl_core <const> = 'sublime_core'
local LoadResourceFile <const>, IsDuplicityVersion <const> = LoadResourceFile, IsDuplicityVersion
local service <const> = (IsDuplicityVersion() and 'server') or 'client'
local GetGameName <const> = GetGameName
local GetCurrentResourceName <const> = GetCurrentResourceName

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

        if not func or err then return error(("Erreur pendant le chargement du module\n- Provenant de : %s\n- Modules : %s\n- Service : %s\n - Erreur : %s"):format(dir, index, service, err), 3) end

        local result = func()
        return result
    end
end

sl = setmetatable({
    service = service, 
    name = GetCurrentResourceName(),
    game = GetGameName(),
    env = GetCurrentResourceName(),
    await = Citizen.Await,
    lang = GetConvar('sl:locale', 'fr')
}, {
    __newindex = function(self, name, func)
    rawset(self, name, func)
    exports(name, func)
end})

require = load_module('require', 'shared').load
require('imports.locales.shared').init()

if sl.service == 'server' then
    require('imports.version.server').check('github', nil, 500)
    require('imports.mysql.server').init()
end

-- credit: ox_lib <https://github.com/overextended/ox_lib/blob/master/init.lua>
local intervals = {}
---@param callback function | number
---@param interval? number
---@param ... any
function SetInterval(callback, interval, ...)
	interval = interval or 0

    if type(interval) ~= 'number' then
        return error(('Interval must be a number. Received %s'):format(json.encode(interval --[[@as unknown]])))
    end

	local cbType = type(callback)

	if cbType == 'number' and intervals[callback] then
		intervals[callback] = interval or 0
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
			callback(table.unpack(args))
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
