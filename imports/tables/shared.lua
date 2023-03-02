
--- sl.table_pairByKeys
---@param t table
---@param f table
sl.table_pairByKeys = function(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0
    local iter = function()
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end


--- sl.table_sortAlphabetically
---@param curTable table
sl.table_sortAlphabetically = function(curTable)
    local ret = {}
    for k, v in sl.table_pairByKeys(curTable) do
        table.insert(ret, { name = k, count = v })
    end
    return (ret)
end


--- sl.table_count
---@param curTable table
sl.table_count = function(curTable)
    local count = 0
    for _, _ in pairs(curTable) do
        count = count + 1
    end
    return (count)
end


--- sl.table_print
---@param tableToPrint table
sl.table_print = function(tableToPrint)
    for key, _ in pairs(tableToPrint) do
       print(key, _)
    end
end


--- sl.table_random
---@param tableToRandom table
sl.table_random = function(tableToRandom)
    local randomIndex <const> = math.random(0, #tableToRandom)
    return (tableToRandom[randomIndex])
end


--- sl.table_shuffle
---@param tableS table
sl.table_shuffle = function(tableS)
    for i = #tableS, 2, -1 do
      local j = math.random(i)
      tableS[i], tableS[j] = tableS[j], tableS[i]
    end
    return (tableS)
end


--- sl.table_sizeOf
---@param t table
sl.table_sizeOf = function(t)
    local count = 0
    for _,_ in pairs(t) do
        count = count + 1
    end
    return count
end


--- sl.table_set
---@param t table
sl.table_set = function(t)
	local set = {}
	for k,v in ipairs(t) do set[v] = true end
	return set
end


--- sl.table_indexOf
---@param t table
---@param value any
sl.table_indexOf = function(t, value)
	for i=1, #t, 1 do
		if t[i] == value then
			return i
		end
	end
	return -1
end


--- sl.table_findValueByIndex
---@param t table
---@param value any
sl.table_findValueByIndex = function(t, value)
    for k, v in pairs(t) do
        if k == value then
            return v
        end
    end
      return "**NILL**"
end


--- sl.table_lastIndexOf
---@param t table
---@param value any
sl.table_lastIndexOf = function(t,value)
	for i=#t, 1, -1 do
		if t[i] == value then
			return i
		end
	end
	return -1
end


--- sl.table_find
---@param t table
---@param cb function
sl.table_find = function(t, cb)
	for i=1, #t, 1 do
		if cb(t[i]) then
			return t[i]
		end
	end
	return nil
end


--- sl.table_findIndex
---@param t table
---@param cb function
sl.table_findIndex = function(t, cb)
	for i=1, #t, 1 do
		if cb(t[i]) then
			return i
		end
	end
	return -1
end


--- sl.table_filter
---@param t table
---@param cb function
sl.table_filter = function(t,cb)
	local newTable = {}
	for i=1, #t, 1 do
		if cb(t[i]) then
			table.insert(newTable, t[i])
		end
	end
	return newTable
end


--- sl.table_map
---@param t table
---@param cb function
sl.table_map = function(t, cb)
    local newTable = {}
	for i=1, #t, 1 do
		newTable[i] = cb(t[i], i)
	end
	return newTable
end


--- sl.table_reverse
---@param t table
sl.table_reverse = function(t)
	local newTable = {}
	for i=#t, 1, -1 do
		table.insert(newTable, t[i])
	end
	return newTable
end


--- sl.table_clone
---@param t table
sl.table_clone = function(t)
	if type(t) ~= 'table' then return t end
	local meta = getmetatable(t)
	local target = {}
	for k,v in pairs(t) do
		if type(v) == 'table' then
			target[k] = sl.table_clone(v)
		else
			target[k] = v
		end
	end
	setmetatable(target, meta)
	return target
end


--- sl.table_concat
---@param t1 table
---@param t2 table
sl.table_concat = function(t1, t2)
	local t3 = sl.table_clone(t1)
	for i=1, #t2, 1 do
		table.insert(t3, t2[i])
	end
	return t3
end


--- sl.table_join
---@param t table
---@param sep any
sl.table_join = function(t,sep)
	local sep = sep or ','
	local str = ''
	for i=1, #t, 1 do
		if i > 1 then
			str = str .. sep
		end
		str = str .. t[i]
	end
	return str
end


--- sl.table_sort
---@param t table
---@param order any
sl.table_sort = function(t, order)
	local keys = {}
	for k,_ in pairs(t) do
		keys[#keys + 1] = k
	end
	if order then
		table.sort(keys, function(a,b)
			return order(t, a, b)
		end)
	else
		table.sort(keys)
	end
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end


--- sl.table_dump
---@param table table
---@param nb any
sl.table_dump = function(table, nb)
	if nb == nil then
		nb = 0
    end
	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end
		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. ESX.DumpTable(v, nb + 1) .. ',\n'
		end
		for i = 1, nb, 1 do
			s = s .. "    "
		end
		return s .. '}'
	else
		return tostring(table)
	end
end