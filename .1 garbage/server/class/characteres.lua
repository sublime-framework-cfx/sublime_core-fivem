--[[
    fr:
        `char` est le personnage du joueur qu'il selectionne
    en:
        `char` is character of player selected
]]

local char = {
    id = {},
    identifier = {}
}

local function CreateCharObj(source, data)
    local self = {}

    self.source = source
    self.player = sl.players('id', self.source) ---@type object Can got player object in character object (example you can use -> char.player:setPermission(admin, 3))
    self.identifier = data.identifier ---@type string WARNING! isn't same of player.identifier, identifier here is identifier of your character, if you want global identifier you can use : char.player.identifier
    

    char.id[self.source] = self
    char.identifier[self.identifier] = self
    return self
end

function sl.chars(filter, key)
    --if filter and not char[filter] then return sl.log.print(3, 'function sl.chars filter (%s) not found', filter) end
    --if filter and key and not char[filter][key] then return sl.log.print(3, 'function sl.chars key (%s) not found', key) else return char[filter][key] end
    return char[filter] or char.id or nil
end

function sl.create_char_obj(source, data)
    if not source or not next(data) then return end
    return CreateCharObj(source, data)
end