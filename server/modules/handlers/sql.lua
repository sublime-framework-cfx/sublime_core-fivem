local sql = {}

local update_characters <const> = 'UPDATE `characters` SET `x` = ?, `y` = ?, `z` = ?, `w` = ?, `instance` = ?, `status` = ?,`isDead` = ?, `isDead` = ?, `metadata` = ? WHERE charid = ?'
function sql.updateCharacters(parameters)
    MySQL.prepare.await(update_characters, {parameters})
end

return sql