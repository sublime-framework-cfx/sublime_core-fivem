local sublime_core <const> = 'sublime_core'
local IsDuplicityVersion <const>, await <const> = IsDuplicityVersion, Citizen.Await
local LoadResourceFile <const> = LoadResourceFile
local GetResourceState <const> = GetResourceState
local GetGameName <const> = GetGameName
local GetCurrentResourceName <const>, AddEventHandler <const> = GetCurrentResourceName, AddEventHandler
local export = exports[sublime_core]
local service <const> = (IsDuplicityVersion() and 'server') or 'client'

-- local function FormatEvent(self, name, from)
--     return ("__sl__:%s:%s"):format(from or service, joaat(name))
-- end

if not _VERSION:find('5.4') then
    error("^1 Vous devez activer Lua 5.4 dans la resources où vous utilisez l'import, (lua54 'yes') dans votre fxmanifest!^0", 2)
end

if not GetResourceState(sublime_core):find('start') then
	error('^1sublime_core doit être lancé avant cette ressource!^0', 2)
end

local function LoadModule(self, index)
    local func, err 
    local dir <const> = ('imports/%s'):format(index)
    local chunk <const> = LoadResourceFile(sublime_core, ('%s/%s.lua'):format(dir, service))
    local shared <const> = LoadResourceFile(sublime_core, ('%s/shared.lua'):format(dir))

    if chunk or shared then
        if shared then
            func, err = load(shared, ('@@%s/%s/%s'):format(sublime_core, index, 'shared'))
        else
            func, err = load(chunk, ('@@%s/%s/%s'):format(sublime_core, index, service))
        end
        
        if err then error(("Erreur pendant le chargement du module\n- Provenant de : %s\n- Modules : %s\n- Service : %s\n - Erreur : %s"):format(dir, index, service, err), 3) end

        local result = func()
        rawset(self, index, result)
        return self[index]
    end
end

local function CallModule(self, index, ...)
    local module = rawget(self, index)
    if not module then
        module = LoadModule(self, index)
        if not module then
            local function method(...)
                return export[index](nil, ...)
            end

            if not ... then
                self[index] = method
            end

            return method
        end
    end
    return module
end

sublime = setmetatable({
    name = sublime_core, 
    service = service,
    game = GetGameName(),
    env = GetCurrentResourceName(),
    -- lang = GetConvar('sublime:locale', 'fr'),
    cache = service == 'client' and {},
    await = await,
    hashEvent = FormatEvent,
    onPlayer = service == 'client' and function(key, cb)
        AddEventHandler('sublime:player:set:'..key, cb)
    end
},
{
    __index = CallModule,
    __call = CallModule
})

if sublime.service == 'client' then
    local player = {}
    setmetatable(player, {
        __index = function(self, key)
            AddEventHandler('sublime:player:set:'..key, function(value)
                self[key] = value
                return self[key]
            end)

            rawset(self, key, export:GetPlayer(key) or false)
            return self[key]
        end
    })

    _ENV.player = player
elseif sublime.service == 'server' then
    local MySQL = {}

    setmetatable(MySQL, {
        __index = function(self, key)
            local value = rawget(self, key)
            if not value then
                sublime.mysql()
                value = MySQL[key]
            end
            return value
        end
    })

    _ENV.MySQL = MySQL
end

require = sublime.require()