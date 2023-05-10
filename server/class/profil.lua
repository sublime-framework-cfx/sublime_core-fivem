sl.profils = {}

---@param source integer
---@return table
local function GetAllIdentifiers(self, source) ---@todo move in module
    self.identifiers = {}
    for _, v in ipairs(GetPlayerIdentifiers(source)) do
        if v:match('steam:') then
            self.identifiers.steam = v:gsub('steam:', '')
        end
        if v:match('license:') then
            self.identifiers.license = v:gsub('license:', '')
        end
        if v:match('xbl:') then
            self.identifiers.xbl = v:gsub('xbl:', '')
        end
        if v:match('ip:') then
            self.identifiers.ip = v:gsub('ip:', '')
        end
        if v:match('discord:') then
            self.identifiers.discord = v:gsub('discord:', '')
        end
        if v:match('live:') then
            self.identifiers.live = v:gsub('live:', '')
        end
        self.identifiers.token = GetPlayerToken(source)
    end
    return self.identifiers
end

---@return boolean|void
local function GetProfilsDb(self)
    local query <const> = MySQL.query.await('SELECT * FROM profils WHERE previousId = ?', {self.identifiers.token})
    if query ~= '[]' then
        self.id = self.id
        self.username = query.user
        self.password = query.password
        self.stats = json.decode(query.stats)
        self.permission = query.permission
        return true
    end
    self:kick('You are not registered in the database? WTF!')
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
---@return table
local function CreateProilsObj(source)
    local self = {}

    self.source = source
    self.kick = KickPlayer
    self.identifiers = GetAllIdentifiers(self, source)

    if GetProfilsDb(self) then
        self.remove = Disconnected
        self.spawned = false
        sl.profils[source] = self
        sl.previousId[self.identifiers.token] = nil
        return self
    end
end

sl.createPlayerObj = CreateProilsObj