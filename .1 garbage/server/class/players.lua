--[[
    fr:
        `players` est le profile du joueur
    en:
        `players` is profil of player
]]

local players = {
    id = {},
    --identifier = {}
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

local function SetPermission(self, name, rank)
    if type(name) == 'string' and type(rank) == 'number' and math.type(rank) == 'integer' then
        self.permission = {name = name, rank = rank}
    else
        self.permission = false
    end
end

local function UpdatePlayer(self)
    -- self.new
    -- player export from sublime_sql... write soon
end

local function Delete(self)
    -- write soon need more work on sublime_sql (delete player in database)
    self:remove()
end

--- player:remove => remove player of table when he log out
---@return nil
local function Remove(self)
    players.id[self.source] = nil
    players.identifier[self.identifier] = nil
    return nil, collectgarbage()
end

---@param source integer
---@param data table
---@return object
local function CreatePlayerObj(source, data, isNew)
    local self = {}

    self.source = source ---@type integer
    self.identifier = data.identifier ---@type string
    self.user = data.user or "" ---@type string
    self.password = data.password or "" ---@type string
    self.permission = data.permission or {name = 'player', rank = 1} ---@type table
    self.char = data.char or {} ---@type table
    self.stats = data.stats or {} ---@type table
    self.new = isNew or false ---@type boolean

    local sbag = Player(self.source).state
    sbag:set('source', self.source, true)
    sbag:set('identifier', self.identifier, true)
    sbag:set('user', self.user, true)

    self.editPassword = EditPassword
    self.addChar = AddChar
    self.removeChar = RemoveChar
    self.setPermission = SetPermission
    self.update = UpdatePlayer -- can be rewrite soon (sublime_sql)
    self.delete = Delete -- can be rewrite soon (sublime_sql)
    self.remove = Remove

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
    return players[filter] or players.id or nil
end

--- sl.create_player_obj
---@param source integer
---@param data table
---@return object
function sl.create_player_obj(source, data, isNew)
    if not source and not next(data) then return end
    return CreatePlayerObj(source, data, isNew)
end