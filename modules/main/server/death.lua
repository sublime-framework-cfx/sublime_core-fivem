sl:onNet('onCharacterDeath', function(source, playerDead)
    local character = sl.getCharacterFromId(source)
    print('played? here?', character, playerDead)
    if not character then return end
    character:set('isDead', playerDead)
    character:emitNet('onCharacterDeath', playerDead)
    print('onCharacterDeath', playerDead, character.isDead)
end)