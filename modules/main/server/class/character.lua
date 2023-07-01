local GetEntityHeading <const> = GetEntityHeading
local GetEntityCoords <const> = GetEntityCoords
local GetPlayerPed <const> = GetPlayerPed
local mysql <const> = require 'modules.mysql.server.function'
local round <const> = require 'imports.math.shared'.round


local SublimeCharacter, characterExports = {}, {}
setmetatable(SublimeCharacter, {
    __newindex = function(self, key, value)
        rawset(self, key, value)
        characterExports[key] = true
    end
})

function sl.getCharacterExports()
    return characterExports
end

function sl.callCharacterMethod(source, method, ...)
    local player = sl.getCharacterFromId(source)

    if player then
        return player[method](player, ...)
    end
end

---@param source integer
---@return boolean | table
function sl.getCharacterFromId(source)
    local player <const> = sl.getPlayerFromId(source)
    return player.char
end

---@return table
function SublimeCharacter:getPlayer()
    return self.player
end

---@param heading? boolean
---@param update? boolean
function SublimeCharacter:getCoords(heading, notUpdate)
    if notUpdate then return heading and self.coords or vec3(self.coords.x, self.coords.y, self.coords.z) end

    self.coords = GetEntityCoords(self.ped)
    if heading then
        self.coords = vec4(self.coords.x, self.coords.y, self.coords.z, GetEntityHeading(self.ped))
    end

    --print('coords', self.coords.x, self.coords.y, self.coords.z, self.coords.w, GetEntityHeading(self.ped))
    return heading and self.coords or vec3(self.coords.x, self.coords.y, self.coords.z)
end

function SublimeCharacter:prepareSave()
    local coords <const> = self:getCoords(true)

    return {
        round(coords.x, 3),
        round(coords.y, 3),
        round(coords.z, 3),
        round(coords.w, 3),
        self.instance or 0,
        json.encode(self.status) or {},
        self.isDead,
        json.encode(self.metadata) or {},
        self.charid,
    }
end

function SublimeCharacter:save()
    local update <const> = mysql.updateCharacter(self:prepareSave())
    return update
end

function SublimeCharacter:getDistanceFromCoords(coords)
    return #(self:getCoords() - vec3(coords.x, coords.y, coords.z))
end

---@param coords table
---@return float
--local function GetDistanceBetweenCoords(self, coords)
--    return #(self:getCoords() - vec3(coords.x, coords.y, coords.z))
--end
--
--local function PrepareSave(self)
--    local coords <const> = self:getCoords(true)
--    return {
--        x = math.round(coords.x, 2),
--        y = math.round(coords.y, 2),
--        z = math.round(coords.z, 2),
--        w = math.round(coords.w, 2),
--        instance = self.instance,
--        status = json.encode(self.status),
--        isDead = self.isDead,
--        metadata = json.encode(self.metadata),
--        charid = self.charid,
--    }
--end
--
-- local function CreateCharacterObj(profile, data)
--     ---@todo implement data
--     local self = {}
-- 
--     self.source = profile.source
--     self.ped = GetPlayerPed(self.source)
--     self.charid = data.charid
--     self.firstname = data.firstname
--     self.lastname = data.lastname
--     self.height = data.height
--     self.sex = data.sex
--     self.isDead = data.isDead
--     self.dateofbirth = data.dateofbirth
--     self.inventory = data.inventory
--     self.skin = data.skin
--     self.model = data.model
--     self.metadata = data.metadata
--     self.status = data.status
--     self.instance = data.instance
--     self.name = ("%s %s"):format(self.firstname, self.lastname)
-- 
--     self.getCoords = GetCoords
--     self.prepareSave = PrepareSave
--     self.getDistanceFromCoords = GetDistanceBetweenCoords
-- 
--     local bags <const> = Player(self.source).state
--     bags:set('name', self.name, true)
-- 
--     return self
-- end

local class = require 'modules.class.shared.main'
return class.new(SublimeCharacter)