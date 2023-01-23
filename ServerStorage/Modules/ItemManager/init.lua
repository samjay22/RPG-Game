--[[
Sam
3/20/21
EffectManager this holds all the items
]]



local Items = {}

function Items.LoadSkillBook(Skill)
	Items.__index = function(_, Index)
		return Items[Index] or Skill:FindFirstChild(Index) and require(Skill:FindFirstChild(Index))
	end
	return setmetatable({}, Items)
end

return Items.LoadSkillBook(script.Items)
