
--- CreateNPC
---@param model any
---@param coords any
---@param heading any
---@param cb any
local function CreateSyncNpc(model, coords, heading, cb)
    model = type(model) == 'string' and joaat(model) or model
    local netWorkNpc, npc
    CreateThread(function()
        npc = CreatePed(0, model, coords.x, coords.y, coords.z, heading, true, true)
        while not DoesEntityExist(npc) do Wait(50) end
        netWorkNpc = NetworkGetNetworkIdFromEntity(npc)
        if cb then
            cb(netWorkNpc, npc)
        end
    end)
    while not DoesEntityExist(npc) do Wait(50) end
    return netWorkNpc, npc
end

--- sl:createNpc
---@param source number
---@param model string|number
---@param coords vector3|table
---@param heading number
---@return number
sl.callback.register("sl:createNpc", function(source, model, coords, heading)
    local netWorkNpc, npc = CreateSyncNpc(model, coords, heading)
    while not DoesEntityExist(npc) do 
        Wait(100)
    end
    return netWorkNpc
end)


return {
    create_sync_npc = CreateSyncNpc,
    
}