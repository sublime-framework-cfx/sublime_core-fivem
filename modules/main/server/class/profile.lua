local mysql <const> = require 'modules.mysql.server.function'
local CreateCharObj <const> = require 'modules.main.server.class.character'
local power <const> = require 'config.server.permission'.power

local SublimePlayer = {}
local playerExports = {}

setmetatable(SublimePlayer, {
    __newindex = function(self, key, value)
        rawset(self, key, value)
        playerExports[key] = true
    end
})

function sl.getPlayerFromId(source)
    return sl.players[source]
end

function sl.getPlayers(spawned)
    if type(spawned) == 'boolean' then
        local listed = {}
        for _, profil in pairs(sl.players) do
            if spawned then
                if profil.char then
                    listed[#listed+1] = profil
                end
            else
                if not profil.char then
                    listed[#listed+1] = profil
                end
            end
        end
        return listed
    end
    return sl.players
end

function sl.getPlayersExports()
    return playerExports
end

function sl.callPlayerMethod(source, method, ...)
    local player = sl.getPlayerFromId(source)

    if player then
        return player[method](player, ...)
    end
end

function SublimePlayer:hasPermission(args)
    if type(args) == 'string' and self.permission == args then return true
    elseif type(args) == 'number' and power[self.permission] and power[self.permission] >= args then return true
    elseif type(args) == 'boolean' then return not args
    elseif type(args) == 'table' then
        if table.type(args) == 'array' then
            for i = 1, #args do
                if self.permission == args[i] then
                    return true
                end
            end
        else
            if args[self.permission] then
                return true
            end
        end
    end
    return false
end

function SublimePlayer:set(key, value, replicated)
    self[key] = value

    if replicated then
        self:emitNet('setPlayerData', key, value) ---@todo: not implemented yet
    end
end

function SublimePlayer:get(key)
    return self[key]
end

function SublimePlayer:notify(select, data)
    sl.notify(self.source, select, data)
end

function SublimePlayer:getIdentifiersFromId(source)
    return GetPlayerIdentifiers(source)
end

function SublimePlayer:kick(reason)
    if self.quit then self:quit() end
    DropPlayer(self.source, reason)
end

function SublimePlayer:save()
    local update <const> = mysql.updateProfile(self)
    if update then 
        print('Update profil: '..self.username)
    else
        print('Error update profil: '..self.username)
    end
end

function SublimePlayer:quit()
    self:save()
    GlobalState.playersCount -= 1
    return nil, collectgarbage()
end

function SublimePlayer:state()
    return Player(self.source).state
end

function SublimePlayer:emitNet(eventName, ...)
    return sl:emitNet(eventName, self.source, ...)
end

function SublimePlayer:init(username, password)
    self.username = username or self.username
    self.password = password or self.password
    if type(self.password) == 'string' then
        self.password = self.password:gsub('%s+', '_')
        self.password = joaat(self.password)
    else
        self.password = self.password
    end

    local row <const> = mysql.initProfile(self.username, self.password)
    if not row or not next(row) then return false end

    self.id = row.id
    self.permission = row.permission
    self.stats = json.decode(row.stats) or {}
    self.createdBy = json.decode(row.createdBy)
    self.metadata = json.decode(row.metadata) or {}

    GlobalState.playersCount += 1
    return true
end

function SublimePlayer:loadNuiProfiles()
    if not self.id then return false end
    local query <const> = mysql.loadCharacters(self.id)
    if query == '[]' then return false end

    local data = {}
    data.chars = {}

    for i = 1, #query do
        local char <const> = query[i]

        data.chars[i] = {
            firstname = char.firstname,
            lastname = char.lastname,
            sex = char.sex,
            dob = char.dateofbirth,
            model = char.model,
            skin = json.decode(char.skin) or {},
            ---@todo will be available soon
            -- country = char.country,
        }
    end

    data.username = self.username
    data.permission = self.permission
    data.stats = self.stats
    data.logo = self.metadata?.logo
    
    return data
end

function SublimePlayer:addCharacter(data)
    if not self.id then return false end
    local insert <const> = mysql.createNewCharacter(self.id, data)
    if insert then
        return true
    end
    return false
end

local class = require 'modules.class.shared.main'
return class.new(SublimePlayer)