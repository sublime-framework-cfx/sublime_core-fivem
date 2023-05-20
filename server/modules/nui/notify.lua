local function notify(self, source, select, data)
    self:emitNet('notify', source, select, data)
end

sl.notify = notify