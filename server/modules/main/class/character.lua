


local function LoadCharacterObj(profil, data)
    ---@todo implement data
    local self = {}

    self.charId = data.charId
    self.firstname = data.firstname
    self.lastname = data.lastname
    self.height = data.height
    self.sex = data.sex

    return setmetatable(self, {__index = profil})
end

return LoadCharacterObj