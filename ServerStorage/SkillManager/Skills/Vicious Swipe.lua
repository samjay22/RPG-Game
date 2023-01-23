--[[
Sam
3/18/21
Slash skill
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)


local Slash = {
	Classes = {Enum.Classes.Captian, Enum.Classes.Brawler};
	SkillType = Enum.SkillType.Melee;
	DamageType = Enum.DamageTypes.Normal;
	Damage = 10;
	Cooldown = 2;
	Range = 10;
	ManaCost = 10;
	Name = script.Name;
	Angles =  {-90, 90};
	AOE = false;
	Animation = 'rbxassetid://6574357486';
}

function Slash.RunSkill(CallerData, CallBack, Combat, Target)
	
	local RayCast = Combat[1]
	local CheckClass = Combat[2]
	local PlayAnimation = Combat[3]
	local SingleTarget = Combat[5]
	
	local CanUse = CheckClass(CallerData, Slash.Classes)
	if not CanUse then return end
	local Char = CallerData.Char
	--local Hits =	RayCast(CallerData, Slash)
	
	if Target then
		local TargetData = shared.Enemys[Target]
		if TargetData then
			SingleTarget(CallerData, Slash, TargetData)
		end
	end
	
	PlayAnimation(CallerData, Slash.Animation)
	CallBack(CallerData, Slash.Name, Slash.Cooldown)
end

return Slash