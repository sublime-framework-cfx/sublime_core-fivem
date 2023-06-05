local sql = {}

local update_characters <const> = 'UPDATE `characters` SET `x` = ?, `y` = ?, `z` = ?, `w` = ?, `instance` = ?, `status` = ?,`isDead` = ?, `isDead` = ?, `metadata` = ? WHERE charid = ?'
function sql.updateCharacters(parameters)
    MySQL.prepare.await(update_characters, {parameters})
end

local insert_new_char <const> = 'INSERT INTO `characters` (`user`, `firstname`, `lastname`, `sex`, `dateofbirth`, `height`, `model`) VALUES (?, ?, ?, ?, ?, ?, ?)'
function sql.createNewCharacter(userId, data) -- used to create new character
    return MySQL.insert.await(insert_new_char, {userId, data.firstname, data.lastname, data.sex, data.dob, data.height, data.model})
end

local update_profile <const> = 'UPDATE profils SET user = ?, password = ?, stats = ?, metadata = ? WHERE id = ?' -- used to update profile (on disconnect & change password ...)
function sql.updateProfile(user)
    return MySQL.update.await(query, {user.username, user.password, json.encode(user.stats or {}), json.encode(user.metadata or {}), user.id})
end

local load_character <const> = 'SELECT * FROM characters WHERE user = ?' -- used to show character selection
function sql.loadCharacter(userId)
    return MySQL.query.await(load_character, {userId})
end

local change_temp_id <const> = 'UPDATE profils SET tempId = ? WHERE id = ?' -- used to change temp id
function sql.changeTempId(value, userId)
    return MySQL.update.await(change_temp_id, {value, userId})
end

return sql