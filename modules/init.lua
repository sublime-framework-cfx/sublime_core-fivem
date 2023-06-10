if not sl and not sl.service then return end

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
    
    if files[sl.service] then
        local t <const> = files[sl.service]
        for j = 1, #t do
            local file <const> = t[j]
            require(('modules.%s.%s.%s'):format(folder, sl.service, file))
        end
    end
end

folders = nil