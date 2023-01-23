local module = {}


function module.InitLoot()
	module.__index = function(_, Index)
		return module[Index] or script.Loot:FindFirstChild(Index) and require(script.Loot:FindFirstChild(Index)) or warn("No index: ",Index )
	end
	return setmetatable({}, module)
end


return module.InitLoot()
