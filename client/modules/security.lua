local AddEventHandler <const> = AddEventHandler

AddEventHandler('onClientResourceStop', function(resourceName)
    sl:emitNet('onResourceStop', resourceName)    
end)