
--- sl.npc.create_sync_npc : create synced npc
---@param model any
---@param coords any
---@param heading any
---@param cb any
local function CreateSyncNpc(model, coords, heading, cb)
    model = type(model) == 'string' and joaat(model) or model
    CreateThread(function()
        local npc <const> = CreatePed(0, model, coords.x, coords.y, coords.z, heading, true, true)
        while not DoesEntityExist(npc) do Wait(50) end
        local netWorkNpc <const> = NetworkGetNetworkIdFromEntity(npc)
        if cb then
            cb(npc, netWorkNpc)
        end
    end)
end

--- sl:createNpc [[CALLBACK]]
---@param source number
---@param model string|number
---@param coords vector3|table
---@param heading number
---@return number
sl.callback.register("sl:createNpc", function(source, model, coords, heading)
    local spawned_npc
    CreateSyncNpc(model, coords, heading, function(npc)
        spawned_npc = npc
    end)
    while not DoesEntityExist(spawned_npc) do 
        Wait(100)
    end
    return NetworkGetNetworkIdFromEntity(spawned_npc)
end)

return {
    create_sync_npc = CreateSyncNpc,
}