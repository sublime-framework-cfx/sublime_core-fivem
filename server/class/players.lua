local players = {
    id = {},
    identifier = {}
}

--- player:addChar
---@param self object
---@param data table
local function AddChar(self, data)
    self.char[#self.char+1] = data
end

--- player:removeChar
---@param self object
---@param index integer
local function RemoveChar(self, index)
    table.remove(self.char, index)
end

--- player:editPassword
---@param self object
---@param password string
local function EditPassword(self, password)
    if self.password ~= password and #password > 6 and type(password) == 'string' then
        self.passsword = password
    end
end

--- player:getName
---@param self object
---@return string
local function GetName(self)
    return self.name
end

--- player:getIdentifier
---@param self object
---@return string
local function GetIdentifier(self)
    return self.identifier
end

---@param source integer
---@param data table
---@return object
local function CreatePlayerObj(source, data)
    local self = {}

    self.source = source ---@type integer
    self.identifier = data.identifier ---@type string
    self.name = data.name or '' ---@type string
    self.password = data.password or '' ---@type string
    self.permission = data.permission or false ---@type table|boolean
    self.char = data.char or {} ---@type table

    local sbag = Player(self.source).state
    sbag:set('source', self.source, true)
    sbag:set('identifier', self.identifier, true)
    sbag:set('profil_name', self.name, true)

    self.editPassword = EditPassword
    self.addChar = AddChar
    self.removeChar = RemoveChar
    self.getName = GetName
    self.getIdentifier = GetIdentifier

    players.id[self.source] = self
    players.identifier[self.identifier] = self
    return self
end

--- sl.players
---@param filter? string
---@param key? integer|string
---@return table
function sl.players(filter, key)
    if filter and not players[filter] then return sl.log.print(3, 'function sl.players filter (%s) not found', filter) end
    if filter and key and not players[filter][key] then return sl.log.print(3, 'function sl.players key (%s) not found', key) else return players[filter][key] end
    return players[filter] or players.id
end

--- sl.create_player_obj
---@param source integer
---@param data table
---@return object
function sl.create_player_obj(source, data)
    if not source and not next(data) then return end
    return CreatePlayerObj(source, data)
end