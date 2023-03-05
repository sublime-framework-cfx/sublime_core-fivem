local char = {
    id = {},
    identifier = {}
}

local function CreateCharObj(source, data)
    local self = {}

    self.source = source

    char.id[self.source] = self
    char.identifier[self.identifier] = self
    return self
end

function sl.chars()
    
end

function sl.create_char_obj(source, data)
    if not source or not next(data) then return end
    return CreateCharObj(source, data)
end