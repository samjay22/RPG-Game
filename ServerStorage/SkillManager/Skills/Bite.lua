--[[
Sam
3/18/21
Bite skill
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)


local Bite = {
	Classes = {Enum.Classes.RegularMob, Enum.Classes.BossMob};
	SkillType = Enum.SkillType.Melee;
	DamageType = Enum.DamageTypes.Normal;
	Damage = 10;
	Cooldown = 2;
	Range = 5;
	ManaCost = 2;
	Name = script.Name;
	Angles =  {-45, 45};
	AOE = true;
	Animation = 'rbxassetid://6574357486';
}

function Bite.RunSkill(CallerData, CallBack, Combat)

	local RayCast = Combat[1]
	local CheckClass = Combat[2]
	local PlayAnimation = Combat[3]

	local CanUse = CheckClass(CallerData, Bite.Classes)
	if not CanUse then return end
	local Char = CallerData.Char
	local Hits =	RayCast(CallerData, Bite)
	PlayAnimation(CallerData, Bite.Animation)
	CallBack(CallerData, Bite.Name, Bite.Cooldown)
end

return Bite