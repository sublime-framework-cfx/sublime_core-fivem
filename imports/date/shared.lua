--- sl.date.format : convertit un temps (en seconde) en SEM JJ HH MM SS
---@param sec number
---@param value? string
---@return integer|nil
---@return integer|nil
---@return string|nil
---@return string|nil
---@return string|nil
local function DateFormat(sec, value)
    --valeur possible semaine, jour, heure, minute ou seconde
    local sem, jj, hh, mm, ss, reste = 0, 0, 0, 0, 0, nil
    if not value or value == 'semaine' or value == 'week' then 
        sem = math.floor(sec / (60 * 60 * 24 * 7))
        reste = sec % 604800
        jj = math.floor(reste / (60 * 60 * 24))
        reste = (reste % 86400)
        hh = math.floor(reste / (60 * 60))
        reste = (reste % 3600)
        mm = math.floor(reste / 60)
        ss = (reste % 60)
        return sem, jj, sl.math.two_digits(hh), sl.math.two_digits(mm), sl.math.two_digits(ss)
    elseif value == 'jour' or value == 'day' then
        jj = math.floor(sec / (60 * 60 * 24))
        reste = (sec % 86400)
        hh = math.floor(reste / (60 * 60))
        reste = (reste % 3600)
        mm = math.floor(reste / 60)
        ss = (reste % 60)
        return jj, sl.math.two_digits(hh), sl.math.two_digits(mm), sl.math.two_digits(ss)
    elseif value == 'heure' or value == 'hours' then
        hh = math.floor(sec / (60 * 60))
        reste = (sec % 3600)
        mm = math.floor(reste / 60)
        ss = (reste % 60)
        return sl.math.two_digits(hh), sl.math.two_digits(mm), sl.math.two_digits(ss)
    elseif value == 'minute' then
        mm = math.floor(sec / 60)
        reste = (sec % 60)
        ss = (reste)
        return sl.math.two_digits(mm), sl.math.two_digits(ss)
    elseif value == 'seconde' then
        ss = sec
        return sl.math.two_digits(ss)
    end
end

--- sl.date.valid : vérifie si une date est valide
---@param strDate string
---@return boolean
local function DateValid(strDate)
    local d, m, y = strDate:match("(%d+)/(%d+)/(%d+)")
    d, m, y = tonumber(d) or 0, tonumber(m) or 0, tonumber(y) or 0
    if y < 1920 or y > 2030 then
        return false
    else
        if d <= 0 or d > 31 or m <= 0 or m > 12 or y <= 0 then
            return false
        elseif m == 4 or m == 6 or m == 9 or m == 11 then 
            return d <= 30
        elseif m == 2 then
            if y%400 == 0 or (y%100 ~= 0 and y%4 == 0) then
                return d <= 29
            else
                return d <= 28
            end
        else
            return d <= 31
        end
    end
end

return {
    format = DateFormat,
    valid = DateValid
}