Config = {}

sl = setmetatable({name = 'sublime_core', service = (IsDuplicityVersion() and 'server') or 'client'}, {
    __newindex = function(self, name, func)
        rawset(self, name, func)
        exports(name, func)
    end
})