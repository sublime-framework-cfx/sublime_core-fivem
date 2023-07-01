sl:onNet('onCharacterSpawn', function(source, charId)
    local player <const> = sl.getPlayerFromId(source)
    if not player then return end
    print(('Player %s is spawning character %s'):format(player.name, charId))
    print(type(charId))
    local char, init = player:spawnChar(charId)

    if not char then return end

    player:emitNet('onCharacterSpawn', init)

    Wait(1000)

    if char.isDead then
        print(("Char %s is dead?: %s"):format(char.name, char.isDead))
        player:emitNet('onCharacterDeath', char.isDead)
    end

    -- if char.instance then
    --     char:instanceLoad()
    -- end
end)