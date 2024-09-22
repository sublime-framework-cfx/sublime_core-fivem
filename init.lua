local LoadResourceFile <const>, IsDuplicityVersion <const>, await <const> = LoadResourceFile, IsDuplicityVersion, Citizen.Await
local sublime_core <const>, service <const> = 'sublime_core', (IsDuplicityVersion() and 'server') or 'client'

---@param name string
---@param from? string<'client' | 'server'> default is sl.service
---@return string
-- local function FormatEvent(self, name, from)
--     return ("__sl__:%s:%s"):format(from or self.service, joaat(name))
-- end

sublime = setmetatable({
    service = service, ---@type string<'client' | 'server'>
    name = sublime_core, ---@type string<'sublime_core'>
    env = sublime_core, ---@type string<'resource_name?'>
    -- hashEvent = FormatEvent,
    await = await,
    lang = GetConvar('sublime:locale', 'fr') ---@type string<'fr' | 'en' | unknown>
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
            local resourceFile = LoadResourceFile(supv_core, scriptPath)
            if resourceFile then
                loaded[modname] = false
                scriptPath = ('@@%s/%s'):format(supv_core, scriptPath)

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

-- require('imports.locales.shared').init() ---@load translation

if sublime.service == 'server' then
    print([[
^6#####################################################################################
^6#^2                _       _   _                                                      ^6#
^6#^2               | |     | | (_)                                                     ^6#
^6#^2  ___   _   _  | |__   | |  _   _ __ ___     ___        ___    ___    _ __    ___  ^6#
^6#^2 / __| | | | | | '_ \  | | | | | '_ ` _ \   / _ \      / __|  / _ \  | '__|  / _ \ ^6#
^6#^2 \__ \ | |_| | | |_) | | | | | | | | | | | |  __/^7  _ ^2 | (__  | (_) | | |    |  __/ ^6#
^6#^2 |___/  \__,_| |_.__/  |_| |_| |_| |_| |_|  \___|^7 (_)^2  \___|  \___/  |_|     \___| ^6#
^6#                                                                                   ^6#
^6#^2        ^7Github: ^4https://github.com/sublime-framework-cfx/sublime_core-fivem        ^6#
^6#####################################################################################
]])
    -- require('imports.version.server').check('github', nil, 500) ---@load version check && check update
    -- require('imports.mysql.server').init() ---@load oxmysql
end