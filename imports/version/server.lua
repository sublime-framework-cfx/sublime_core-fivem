local PerformHttpRequest <const>, GetResourceMetadata <const> = PerformHttpRequest, GetResourceMetadata
local version <const> = GetResourceMetadata(sl.env, 'version', 0)

---@todo rework this function without tebex value

--- sl.version.check
---@param url string
---@param webhook? table
---@param timer? number
---@param isBeta? boolean
---@param perso? fun(resp: table)
local function Checker(url, webhook, timer, isBeta, perso)
    local j <const> = require'imports.json.server'
    local message = j.load(('locales/%s'):format(sl.lang), sl.name)

    local from <const> = url
    url = from == 'github' and ('https://api.github.com/repos/SUBLiME-Association/%s/releases/latest'):format(sl.env) or url

    CreateThread(function() 
        Wait(timer or 2500)
        
        PerformHttpRequest(url, function(status, resp)
            if status ~= 200 then return print(message.error_update) end

            resp = json.decode(resp)
            -- print(json.encode(resp, {indent=true}))

            if from == 'github'then
                local lastVersion = from == 'github' and resp.tag_name
                lastVersion = lastVersion:gsub('v', '')

                if isBeta then
                    lastVersion = lastVersion:gsub('b', '')
                end

                local _version = {('.'):strsplit(version)}
                local _lastVersion = {('.'):strsplit(lastVersion)}
    
                for i = 1, #_version do
                    local current, minimum = tonumber(_version[i]), tonumber(_lastVersion[i])
                    if current ~= minimum then
                        if current < minimum then
                            print('^9---------------------------------------------------------')
                            print(message.need_update:format(sl.env, version, lastVersion, from == 'github' and resp.html_url))
                            print('^9---------------------------------------------------------')
                            return
                        else break end
                    end
                end
            else
                if perso then
                    perso(resp)
                end
            end            
        end, 'GET')
    end)
end

return {
    check = Checker
}