local TableUtil = {}

--// Takes in a filter function and tuple tables, returns tables with elements filtered
function TableUtil:filter(filterFunc, ...)
	local cpytbl = {}
	
	for i, tbl in ipairs({...}) do
		cpytbl[i] = {}
		for a, b in ipairs(tbl) do
			if filterFunc(b) then
				cpytbl[i][a] = b
			end
		end
	end
	
	return table.unpack(cpytbl)
end

--// Takes in a map function and tuple tables, returns tables with values mapped
function TableUtil:map(mapFunc, ...)
	local cpytbl = {}
	
	for i, tbl in ipairs({...}) do
		cpytbl[i] = {}		
		for a, b in ipairs(tbl) do
			cpytbl[i][a] = mapFunc(b)
		end
	end
	
	return table.unpack(cpytbl)
end

--// Takes in tuple tables, returns a table with all elements from input tables combined
function TableUtil:concat(...)
	local result = {}
	
	for _, tbl in ipairs({...}) do
		for _, v in ipairs(tbl) do
			result[#result + 1] = v
		end
	end
	
	return result
end

--// Takes in tuple tables, returns each table in reversed format
function TableUtil:reverse(...)
	local tbls = {}
	
	for i, tbl in ipairs({...}) do
		local cpytbl = tbl
		local mid = math.floor(#cpytbl/2)
		
		for i = 1, mid do
			local End = (#cpytbl + 1) - i
			local Start = i
			
			TableUtil:swap(cpytbl, Start, End)
		end
		
		tbls[i] = cpytbl
	end
	
	return table.unpack(tbls)
end

--// Returns a flattened version of table, e.g. {1, {2, 3}, {4, 5, {6, 7, 8, {9, 10}}}} -> {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
function TableUtil:flat(tbl)
	local cpytbl = {}
	
	local function recurseFlat(item)
		local foundTblIndexes = {}
		
		for i, v in ipairs(item) do
			if type(v) ~= 'table' then
				cpytbl[#cpytbl + 1] = v
			else
				foundTblIndexes[#foundTblIndexes + 1] = i
			end
		end
		
		for _, index in ipairs(foundTblIndexes) do
			recurseFlat(item[index])
		end
	end
	
	for _, item in ipairs(tbl) do
		if type(item) ~= 'table' then
			cpytbl[#cpytbl + 1] = item
		else		
			recurseFlat(item)
		end
	end
	
	return cpytbl
end

--// Returns copy of provided table, works on >=1 dimensional tables
function TableUtil:deepCopy(tbl)
	local copy = {}

	for key, value in pairs(tbl) do
		if type(value) ~= 'table' then
			copy[key] = value
		else
			copy[key] = DeepCopyTable(value)
		end
	end

	return copy
end

--// Swaps specified indexes in table - directly edits table, does not return anything
function TableUtil:swap(tbl, a, b)
	local tmp = tbl[a]
	tbl[a] = tbl[b]
	tbl[b] = tmp
end

--// Works like join() in Python, takes a string seperator and a table, returns a string containing each element in table seperated by seperator
function TableUtil:toString(seperator, tbl)
	seperator = seperator or ''
	local result = ''
			
	for _, item in ipairs(tbl) do
		result ..= tostring(item)..seperator
	end

	return string.sub(result, 1, -2)
end

--// Returns a table sliced from specified start to end
function TableUtil:slice(tbl, Start, End)
	return {table.unpack(tbl, Start, End)}
end

--// Returns smallest number in a table
function TableUtil:min(tbl)
	return math.min(table.unpack(tbl))
end

--// Returns biggest number in a table
function TableUtil:max(tbl)
	return math.max(table.unpack(tbl))
end
