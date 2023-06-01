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

local power <const> = require 'config.server.permission'.power

sl.profiles = {}

---@return boolean|void
local function InitProfileFromDb(self, from)
    local row = nil

    if from == 'token' then
        row = MySQL.single.await('SELECT * FROM profils WHERE previousId = ?', {self.identifiers.token})
    else
        row = MySQL.single.await('SELECT * FROM profils WHERE user = ? AND password = ?', {self.username, self.password})
    end

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
    MySQL.update.await('UPDATE profils SET previousId = ? WHERE id = ?', {nil, self.id})
    sl.profiles[self.source] = nil
    GlobalState.playersCount -= 1
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
    local query <const> = MySQL.query.await('SELECT * FROM characters WHERE user = ?', {self.id})

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
            -- country = char.country,
        }
    end

    data.username = self.username
    data.permission = self.permission
    data.stats = self.stats
    data.logo = self.metadata.logo
    
    return data
end

---@return void
local function UpdateDb(self)
    local query = 'UPDATE profils SET user = ?, password = ?, stats = ?, metadata = ? WHERE id = ?'
    local update <const> = MySQL.update.await(query, {self.username, self.password, json.encode(self.stats or {}), json.encode(self.metadata), self.id})
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
    local query <const> = 'INSERT INTO `characters` (`user`, `firstname`, `lastname`, `sex`, `dateofbirth`, `height`, `model`) VALUES (?, ?, ?, ?, ?, ?, ?)'
    local insert <const> = MySQL.insert.await(query, {self.id, data.firstname, data.lastname, data.sex, data.dob, data.height, data.model})
    if insert then
        return true
    end
    return false
end

---@return array|false
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

---@param args string|number|table|boolean
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

local function SpawnCharacter(self)
    if self.char then return warn("character is already loaded, you need to unload char before!\n") end
    local data = {}

    ---@todo spawn character load data from db

    --self.char = require('server.class.character')(self, data)
    return self.char
end

---@param source integer
---@param username string
---@param password string
---@param external? boolean
---@return table|false
local function CreateProfileObj(obj, source, username, password, external)
    local self <const> = {}

    self.source = source
    self.identifiers = obj.getIdentifiersFromId(source)

    password = password:gsub('%s+', '')

    self.username = username
    self.password = joaat(password)
    self.kick = KickPlayer

    local can, err = pcall(InitProfileFromDb, self, external)

    if can then
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
        self.loadCharacters = LoadChars
        self.hasPermission = HasPermission
        --self.char = false
        --self.spawn = SpawnCharacter
        obj.profiles[source] = self
        obj.previousId[self.identifiers.token] = nil
        self.notify = function(select, data)
            obj:notify(self.source, select, data)
        end
        GlobalState.playersCount += 1
        return self
    end
    return false, err
end

local function GetProfile(source)
    return (source == true and sl.profiles) or (sl.profiles[source]) or false
end

sl.createProfileObj = CreateProfileObj
sl.getProfileFromId = GetProfile

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

function sl.getCharFromId(source) ---@todo
    local profil <const> = GetProfile(source)
    if not profil then return false end
    return profil.char
end