local Table = {}

local Inherits = {}

for _, Item in next, script:GetChildren() do
	table.insert(Inherits, require(Item))
end


Table.__index = function(_, Index)
	if Table[Index] then return Table[Index] end
	print(Index)
	for _, Class in next, Inherits do
		if Class[Index] then return Class[Index] end
	end
end

return setmetatable({}, Table)