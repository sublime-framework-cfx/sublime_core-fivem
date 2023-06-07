---@create sql schema
local name = require 'server.sql'
if not name then return error("Database not found", 3) end
name = nil

---@load modules.important
require 'server.modules.utils.getIdentifier'

---@load modules.handlers
require 'server.modules.handlers.events'

---@load modules.nui
require 'server.modules.nui.notify'

---@load modules.main
require 'server.modules.main.security'
require 'server.modules.main.main'
require 'server.modules.main.class.profile'
require 'server.modules.main.profiles'