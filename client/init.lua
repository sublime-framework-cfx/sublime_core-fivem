local modules <const> = require 'config.client.modules'

---@load modules.handlers
require 'client.modules.handlers.events'
require 'client.modules.handlers.nui'
require 'client.modules.handlers.statebags'

---@load modules.nui
require 'client.modules.nui.modals'
require 'client.modules.nui.login'
require 'client.modules.nui.profiles'
require 'client.modules.nui.notify'


---@load modules.?
require 'client.modules.main.cache'
require 'client.modules.main.firstspawn'

---
--require 'client.modules.main.main'
require 'client.modules.main.security'
--require 'client.modules.loadscreen.main'

if modules.richPresence then
    if modules.richPresence.discord then require 'client.modules.rich-presence.discord' end
end