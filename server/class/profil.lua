sl.profils = {}

---@param source integer
---@return table
local function GetAllIdentifiers(self, source) ---@todo move in module
    local listId = { steam = true, license = true, xbl = true, ip = true, discord = true, live = true }
    self.identifiers = {}
    for _,v in ipairs(GetPlayerIdentifiers(source)) do
        if listId[v:match('([^:]+)')] then
            self.identifiers[v:match('([^:]+)')] = v:gsub('([^:]+):', '')
        end
    end
    self.identifiers.token = GetPlayerToken(source)
    return self.identifiers
end

---@return boolean|void
local function GetProfilsDb(self, from)
    local query, db = nil, {}

    if from == 'token' then
        query = MySQL.query.await('SELECT * FROM profils WHERE previousId = ?', {self.identifiers.token})
    else
        query = MySQL.query.await('SELECT * FROM profils WHERE user = ? AND password = ?', {self.username, self.password})
    end

    if query ~= '[]' then
        for i = 1, #query do
            local result <const> = query[i]
            db.id = result.id
            db.username = result.user
            db.password = result.password
            db.permission = result.permission
            db.stats = json.decode(result.stats)
            db.createdBy = json.decode(result.createdBy)
            return db
        end 
    end
end

---@param reason string
local function KickPlayer(self, reason)
    DropPlayer(self.source, reason)
end

---@return boolean
local function Disconnected(self)
    MySQL.update.await('UPDATE profils SET previousId = ? WHERE id = ?', {nil, self.id})
    sl.profils[self.source] = nil
    return true
end

---@param source integer
---@param username string
---@param password string
---@param external? boolean
---@return table
local function CreateProilsObj(source, username, password, external)
    local self = {}

    self.source = source
    self.kick = KickPlayer
    self.identifiers = GetAllIdentifiers(self, source)
    self.username = username

    password = password:gsub('%s+', '')

    self.password = joaat(password)

    local db = GetProfilsDb(self, external)
    if db then
        self.remove = Disconnected
        self.spawned = false
        self.id = db.id
        self.username = db.username
        self.password = db.password
        self.stats = db.stats
        self.permission = db.permission
        self.createdBy = db.createdBy
        sl.profils[source] = self
        sl.previousId[self.identifiers.token] = nil
        return self
    else 
        return false
    end
end

sl.createPlayerObj = CreateProilsObj