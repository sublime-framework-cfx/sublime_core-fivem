require(('modules.handlers.%s.events'):format(sl.service))

if sl.service == 'client' then
    require(('modules.handlers.%s.nui'):format(sl.service))

elseif sl.service == 'server' then
    ---@todo more modules soon like command ...
end 
