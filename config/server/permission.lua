local LoadJson <const> = require 'imports.json.server'.load
return LoadJson('permission')

-- permission.json

--[[

ps: false no one can change / true everyone can change / table only specific permission can change / number only specific permission can change with power >= number

--]]