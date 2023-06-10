cache = {
    on = function(key, cb)
        sl:on(('cache:%s'):format(key), cb)
    end
}