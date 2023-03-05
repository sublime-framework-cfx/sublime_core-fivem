if not _VERSION:find('5.4') then
	return error("Il manque lua54 'yes' dans votre fxmanifest.lua!", 3)
end

local sublime_core <const> = 'sublime_core'

if not GetResourceState(sublime_core):find('start') then
	return error('sublime_core doit être lancée avant cette ressource!', 3)
end

local exp = exports[sublime_core]
local LoadResourceFile <const>, IsDuplicityVersion <const> = LoadResourceFile, IsDuplicityVersion
local service <const> = (IsDuplicityVersion() and 'server') or 'client'

local function load_module(self, index)
    local dir <const> = ("imports/%s"):format(index)
    local chunk <const> = LoadResourceFile(sublime_core, ('%s/%s.lua'):format(dir, service))
    local shared <const> = LoadResourceFile(sublime_core, ('%s/shared.lua'):format(dir))
    local func, err

    if chunk or shared then
        if shared then
            func, err = load(shared, ('@@%s/%s/%s'):format(sublime_core, index, 'shared'))
        else
            func, err = load(chunk, ('@@%s/%s/%s'):format(sublime_core, index, service))
        end

        if not func or err then return error(("Erreur pendant le chargement du module\n- Provenant de : %s\n- Modules : %s\n- Service : %s\n - Erreur : %s"):format(dir, index, service, err), 3) end

        local result = func()
        self[index] = result
        return self[index]
    end
end

local function call_module(self, index, ...)
    local module = rawget(self, index)

    if not module then
        module = load_module(self, index)

        if not module then
            local function Export(...)
                return exp[index](nil, ...)
            end

            if not ... then self[index] = Export end

            return Export
        end

        return module
    end
end

sl = setmetatable({service = service, name = GetCurrentResourceName()}, {__index = call_module, __call = call_module})