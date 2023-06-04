return {
    population = {
        traffic = { --- integer: 3 = default and max / 0 = removed
            npc = 3,
            vehicle = 3,
            parked = 3
        }, ---@important if you want remove population use: set onesync_population false

        enable = {
            cops = true,
            boats = true,
            trains = true,
            garbage_truck = true
        },

        pedBlacklist = nil, -- exemple: { 'mp_f_freemode_01', 'mp_m_freemode_01' }
        vehicleBlacklist = nil -- exemple: { 'adder', 'zentorno' }
    }
}