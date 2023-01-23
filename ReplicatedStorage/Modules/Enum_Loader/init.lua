--[[
Sam
2/19/2021
Custom Enum Loader
2/19 
*** Added NewEnum function
]]

local Enum_Loader = {}

local CustomMadeEnums = {}

local Copy = Enum_Loader

function Enum_Loader.Setup()
	Enum_Loader.__index = function(Table, Index)
		return Copy[Index] or CustomMadeEnums[Index] or script.EnumItems:FindFirstChild(Index) and require(script.EnumItems:FindFirstChild(Index)) or Enum[Index]
	end
	return setmetatable({}, Enum_Loader)
end

function Enum_Loader:NewEnum(...)
	local Data = {...}
	local Name = Data[1]
	local Enums = Data[2]
	CustomMadeEnums[Name] = Enums
end

return Enum_Loader.Setup()












