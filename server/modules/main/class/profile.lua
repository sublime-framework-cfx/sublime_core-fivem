---@class CharsProfilsNuiProps
---@field firstname string
---@field lastname string
---@field sex string
---@field age number
---@field stats table

---@class ProfileNuiProps
---@field chars? CharsProfilsNuiProps
---@field username string
---@field stats table
---@field permission string

---@class AddCharProps
---@field firstname string
---@field lastname string
---@field dob string
---@field sex string
---@field height number
---@field model string

---@class LoadCharsProps[]
---@field firstname string
---@field lastname string
---@field dob string
---@field model string
---@field sex string
---@field height number
---@field skin table
---@field stats table
---@field isDead boolean

local mysql <const> = require 'server.modules.main.mysql'
local power <const> = require 'config.server.permission'.power
local CreateCharObj <const> = require 'server.modules.main.class.character'

---@return boolean|void
local function InitProfileFromDb(self, from)
    local row <const> = mysql.initProfile(self.username, self.password)
    if not row or not next(row) then return false end

    self.id = row.id
    self.username = row.user
    self.password = row.password
    self.permission = row.permission
    self.stats = json.decode(row.stats) or {}
    self.createdBy = json.decode(row.createdBy)
    self.metadata = json.decode(row.metadata) or {}

    return true
end


---@return boolean
local function Disconnected(self)
    mysql.changeTempId(nil, self.id)
    sl.profiles[self.source] = nil
    GlobalState.playersCount -= 1 -- that will be moved? maybe not
    return true
end

---@param key string
---@param value any
local function SetMetadata(self, key, value)
    self.metadata[key] = value
end

---@param key string
---@return any
local function GetMetadata(self, key)
    return self.metadata[key]
end

---@return loadNuiProfiles
local function LoadNuiProfiles(self)
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
            -- country = char.country, ---@todo will be available soon
        }
    end

    data.username = self.username
    data.permission = self.permission
    data.stats = self.stats
    data.logo = self.metadata?.logo
    
    return data
end

---@return void
local function UpdateDb(self)
    local update <const> = mysql.updateProfile(self)
    if update then 
        print('Update profil: '..self.username)
    else
        print('Error update profil: '..self.username)
    end
end

---@param reason string
local function KickPlayer(self, reason)
    if self.save then self:save() end
    DropPlayer(self.source, reason)
end

---@param key string
---@param value any
local function SetData(self, key, value)
    self[key] = value
end

---@param key string
---@return any
local function GetData(self, key)
    return self[key]
end

---@param data AddCharProps
---@return boolean
local function NewChar(self, data)
    local insert <const> = mysql.createNewCharacter(self.id, data)
    if insert then
        return true
    end
    return false
end

---@return table | table<LoadCharsProps>
--[[ not used yet
local function LoadChars(self)
    local query <const> = MySQL.query.await('SELECT * FROM characters WHERE user = ?', {self.id})
    if query == '[]' then return false end
    local data = {} ---@type LoadCharsProps[]
    for i = 1, #query do
        local r = query[i]
        data[i] = {
            firstname = r.firstname,
            lastname = r.lastname,
            dob = r.dateofbirth,
            height = r.height,
            sex = r.sex,
            stats = json.decode(r.stats) or {},
            skin = json.decode(r.skin) or {},
            isDead = r.isDead or false,
            model = r.model
        }
    end
    return data
end
--]]

---@param args string | number | table | boolean
---@return boolean
local function HasPermission(self, args)
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

---@todo
local function SpawnCharacter(self)
    if self.char then return warn("character is already loaded, you need to unload char before!\n") end
    local data = {}
    local query <const> = MySQL.query.await('SELECT * FROM characters WHERE user = ?', {self.id})
    if query == '[]' then return false end

    ---@todo implement data
    
    sl.profiles[self.source].char = CreateCharObj(self, data)
    return self.char
end

---@param _self table sl object
---@param source integer
---@param username string
---@param password string
---@param external? boolean
---@return table | false
local function CreateProfileObj(_self, source, username, password, external)
    local p = promise.new()
    local self = {}

    self.source = source
    self.identifiers = _self:getIdentifiersFromId(source)

    password = password:gsub('%s+', '_') ---@todo more check about password (because for some reason profile nui isn't loaded from that or user)

    self.username = username
    self.password = joaat(password)
    self.kick = KickPlayer

    local can, err = pcall(InitProfileFromDb, self, external)

    if not can then p:reject(err) end
    local bag <const> =  Player(self.source).state
    bag:set('username', username, true)

    self.remove = Disconnected
    self.save = UpdateDb
    self.loadNuiProfiles = LoadNuiProfiles
    self.setMetadata = SetMetadata
    self.getMetadata = GetMetadata
    self.set = SetData
    self.get = GetData
    self.addCharacter = NewChar
    --self.loadCharacters = LoadChars
    self.hasPermission = HasPermission
    self.char = false
    self.spawn = SpawnCharacter
    _self.profiles[self.source] = self
    --obj.tempid[self.identifiers.token] = nil
    self.notify = function(select, data)
        _self:notify(self.source, select, data)
    end
    print(_self.profiles, sl.profiles, 'is profile? from obj')
    GlobalState.playersCount += 1 -- that will be moved
    p:resolve(self)
    return _self.await(p)
end

---@param source boolean | integer
---@return boolean | table
local function GetProfile(self, source)
    local p = promise.new()
    --if not self.profiles then
    --    self.profiles = sl.profiles ---@debug call from external resource
    --end

    p:resolve(source == true and self.profiles or self.profiles[source] or nil)
    return self.await(p)
end

function sl:getProfileFromId(source)
    return GetProfile(self, source)
end

---@param source integer
---@param username string
---@param password string
---@param external? boolean
---@return table | false
function sl:createProfileObj(source, username, password, external)
    return CreateProfileObj(self, source, username, password, external)
end

---@param spawned? boolean
---@return table
function sl:getPlayers(spawned)
    if type(spawned) == 'boolean' then
        local listed = {}
        for _, profil in pairs(self.profiles) do
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
    return self.profiles
end

---@param source integer
---@return table | false
function sl:getCharFromId(source) ---@todo
    return GetProfile(self, source)?.char or false
end