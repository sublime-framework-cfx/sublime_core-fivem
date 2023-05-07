function sl.playerLoaded(source)
    sl.emitNet('playerLoaded', source)
end

sl.onNet('playerLoaded', function(source)
    local _source = source
    sl.playerLoaded(_source)
end)