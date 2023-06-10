---@todo Need to be tested more
local function GetTranslation(...)
    if type(...) == 'string' then
        return translate(...)
    elseif type(...) == 'table' then
        local array = table.type(...) == 'array'
        local t = {}
        if array then
            for i = 1, #(...) do
                local a = (...)[i]
                t[a] = translate(a)
            end
            return t
        else
            for k,v in pairs(...) do
                if type(v) == 'table' then
                    if table.type(v) ~= 'array' then
                        warn("Probleme pour récuperer les args de la traduction\n")
                    end
                    ---@todo listing args
                elseif type(v) == 'boolean' then
                    t[k] = translate(k)
                end
            end
            return t
        end
    end
end

sl.getTranslation = GetTranslation

declare(sl.getTranslation)