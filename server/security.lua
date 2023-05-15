local permission <const> = require 'config.server.permission'

sl.onNet('onResourceStop', function(source, name) ---@todo Need to check who stop the resource to not kick all people doesn't have permission (if resource is stopped by console or player got permission)
    local player <const> = sl.getProfileFromId(source)
    if not player then
        return DropPlayer(source, 'You are not founded in memory of server. cya')
    end

    if not player:gotPerm(permission.resource.stop) then
        player:kick('You don\'t have permission to stop resource!')
        warn(('User %s tried to stop resource %s but he doesn\'t have permission (%s)!'):format(player.username, name, player.permission))
    end
end)