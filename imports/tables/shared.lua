--- sl.table.pairByKeys: sort a table by keys
---@param t table
---@param f function
---@return function
local function pairByKeys(t, f)
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

--- sl.table.sortAlphabetically: sort a table alphabetically
---@param curTable table
---@return table
local function sortAlphabetically(curTable)
	local ret = {}
	for k, v in pairByKeys(curTable) do
		table.insert(ret, { name = k, count = v })
	end
	return ret
end

--- sl.table.count: count the number of elements in a table
---@param curTable table
---@return number
local function count(curTable)
	local count = 0
	for _, _ in pairs(curTable) do
		count = count + 1
	end
	return count
end

--- sl.table.print: print the contents of a table
---@param tableToPrint table
local function print(tableToPrint)
    for key, _ in pairs(tableToPrint) do
        print(key, _)
    end
end

--- sl.table.random: get a random element from a table
---@param tableToRandom table
---@return any
local function random(tableToRandom)
    local randomIndex <const> = math.random(0, #tableToRandom)
    return tableToRandom[randomIndex]
end

--- sl.table.shuffle: shuffle the elements of a table randomly
---@param tableS table
---@return table
local function shuffle(tableS)
    for i = #tableS, 2, -1 do
        local j = math.random(i)
        tableS[i], tableS[j] = tableS[j], tableS[i]
    end
    return tableS
end

--- sl.table.sizeOf: get the number of elements in a table
---@param t table
---@return number
local function sizeOf(t)
    local count = 0
    for _,_ in pairs(t) do
        count = count + 1
    end
    return count
end

--- sl.table.set: create a set from a table
---@param t table
---@return table
local function set(t)
    local set = {}
    for k,v in ipairs(t) do
        set[v] = true
    end
    return set
end

--- sl.table.indexOf: get the index of an element in a table
---@param t table
---@param value any
---@return number
local function indexOf(t, value)
    for i=1, #t, 1 do
        if t[i] == value then
            return i
        end
    end
    return -1
end

--- sl.table.findValueByIndex: get the value corresponding to a given index in a table
---@param t table
---@param value any
---@return any
local function findValueByIndex(t, value)
    for k, v in pairs(t) do
        if k == value then
            return v
        end
    end
    return "**NILL**"
end

--- sl.table.lastIndexOf: get the index of the last occurrence of an element in a table
---@param t table
---@param value any
---@return number
local function lastIndexOf(t, value)
    for i=#t, 1, -1 do
        if t[i] == value then
            return i
        end
    end
    return -1
end

--- sl.table.find: find an element in a table that satisfies a condition
---@param t table
---@param cb function
---@return any
local function find(t, cb)
    for i=1, #t, 1 do
        if cb(t[i]) then
            return t[i]
        end
    end
    return nil
end

--- sl.table.findIndex: find the index of an element in a table that satisfies a condition
---@param t table
---@param cb function
---@return number
local function findIndex(t, cb)
    for i=1, #t, 1 do
        if cb(t[i]) then
            return i
        end
    end
    return -1
end

--- sl.table.filter: create a new table with elements from the original table that satisfy a condition
---@param t table
---@param cb function
---@return table
local function filter(t, cb)
    local newTable = {}
    for i=1, #t, 1 do
        if cb(t[i]) then
            table.insert(newTable, t[i])
        end
    end
    return newTable
end

--- sl.table.map: create a new table by applying a function to each element of the original table
---@param t table
---@param cb function
---@return table
local function map(t, cb)
    local newTable = {}
    for i=1, #t, 1 do
        newTable[i] = cb(t[i], i)
    end
    return newTable
end

--- sl.table.reverse: create a new table with the elements of the original table in reverse order
---@param t table
---@return table
local function reverse(t)
    local newTable = {}
    for i=#t, 1, -1 do
        table.insert(newTable, t[i])
    end
    return newTable
end



--- sl.table.clone: create a new table with the same elements as the original table
---@param t table
---@return table
local function clone(t)
    if type(t) ~= 'table' then return t end
    local meta = getmetatable(t)
    local target = {}
    for k,v in pairs(t) do
        if type(v) == 'table' then
            target[k] = clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end

--- sl.table.concat: create a new table by concatenating two tables
---@param t1 table
---@param t2 table
---@return table
local function concat(t1, t2)
    local t3 = clone(t1)
    for i=1, #t2, 1 do
        table.insert(t3, t2[i])
    end
    return t3
end

--- sl.table.join: concatenate the elements of a table into a string, separated by a given separator
---@param t table
---@param sep any
---@return string
local function join(t, sep)
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

--- sl.table.sort: create an iterator function to iterate over a table in sorted order
---@param t table
---@param order any
---@return function
local function sort(t, order)
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

--- sl.table.dump: convert a table to a string representation with indentation for nested tables
---@param table table
---@param nb any
---@return string
local function dump(table, nb)
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
            s = s .. '['..k..'] = ' .. dump(v, nb + 1) .. ',\n'
        end
        for i = 1, nb, 1 do
            s = s .. "    "
        end
        return s .. '}'
    else
        return tostring(table)
    end
end


--- sl.table.serialize : serialize table to write table in .lua file
---@param t any
---@return string
local function serializeTable(t)
    local result = {}
    for k,v in pairs(t) do
        local key = k
        local value = v
        if type(k) == "string" then
            key = string.format("%q", k)
        end
        if type(v) == "table" then
            value = serializeTable(v)
        elseif type(v) == "string" then
            value = string.format("%q", v)
        elseif type(v) == "boolean" then
            value = v and "true" or "false"
        end
        table.insert(result, "[" .. key .. "] =" .. value)
    end
    return "{" .. table.concat(result, ",") .. "}"
end

return {
    serialize = serializeTable,
	pair_by_keys = pairByKeys,
	sort_alphabetically = sortAlphabetically,
	count = count,
	print = print,
	random = random,
	shuffle = shuffle,
	size_of = sizeOf,
	set = set,
	index_of = indexOf,
	last_index_of = lastIndexOf,
	find_value_by_index = findValueByIndex,
	find = find,
	find_index = findIndex,
	filter = filter,
	map = map,
	reverse = reverse,
	clone = clone,
	concat = concat,
	join = join,
	sort = sort,
	dump = dump
}