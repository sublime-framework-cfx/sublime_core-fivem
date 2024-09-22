if not sublime or not sublime.service then return error("Cannot load init modules", 3) end
local folders = require 'config.modules'

for i = 1, #folders do
    local folder <const> = folders[i]
    local files <const> = require(('modules.%s.index'):format(folder))

    if files.shared then
        local t <const> = files.shared
        for j = 1, #t do
            local file <const> = t[j]
            require(('modules.%s.%s.%s'):format(folder, 'shared', file))
        end
    end

    if files[sublime.service] then
        local t <const> = files[sublime.service]
        for j = 1, #t do
            local file <const> = t[j]
            require(('modules.%s.%s.%s'):format(folder, sublime.service, file))
        end
    end
end

folders = nil