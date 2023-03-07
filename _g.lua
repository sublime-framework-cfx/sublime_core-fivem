Config = {}

sl.__newindex = function(self, name, func)
    rawset(self, name, func)
    exports(name, func)
end