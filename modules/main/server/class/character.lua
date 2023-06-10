local GetEntityHeading <const> = GetEntityHeading
local GetEntityCoords <const> = GetEntityCoords
local GetPlayerPed <const> = GetPlayerPed

local function GetCoords(self, heading)
    local coords = GetEntityCoords(self.ped)
    if heading then
        return vec4(coords.x, coords.y, coords.z, GetEntityHeading(self.ped))
    end
    return coords
end

---@param coords table
---@return float
local function GetDistanceBetweenCoords(self, coords)
    return #(self:getCoords() - vec3(coords.x, coords.y, coords.z))
end

local function PrepareSave(self)
    local coords <const> = self:getCoords(true)
    return {
        x = math.round(coords.x, 2),
        y = math.round(coords.y, 2),
        z = math.round(coords.z, 2),
        w = math.round(coords.w, 2),
        instance = self.instance,
        status = json.encode(self.status),
        isDead = self.isDead,
        metadata = json.encode(self.metadata),
        charid = self.charid,
    }
end

local function CreateCharacterObj(profile, data)
    ---@todo implement data
    local self = {}

    self.source = profile.source
    self.ped = GetPlayerPed(self.source)
    self.charid = data.charid
    self.firstname = data.firstname
    self.lastname = data.lastname
    self.height = data.height
    self.sex = data.sex
    self.isDead = data.isDead
    self.dateofbirth = data.dateofbirth
    self.inventory = data.inventory
    self.skin = data.skin
    self.model = data.model
    self.metadata = data.metadata
    self.status = data.status
    self.instance = data.instance
    self.name = ("%s %s"):format(self.firstname, self.lastname)

    self.getCoords = GetCoords
    self.prepareSave = PrepareSave
    self.getDistanceFromCoords = GetDistanceBetweenCoords

    local bags <const> = Player(self.source).state
    bags:set('name', self.name, true)

    return self
end

return CreateCharacterObj