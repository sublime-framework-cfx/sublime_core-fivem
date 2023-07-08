RegisterCommand('revive', function()
    sl:emitNet('onCharacterDeath', false)
end)