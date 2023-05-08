local sl_core <const> = 'sl_core'
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

require = load_module('require').load
require('imports.locales.shared').init()

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

if sl.service == 'server' then
    require('imports.version.server').check('github', nil, 500)
    require('imports.mysql.server').init()
end