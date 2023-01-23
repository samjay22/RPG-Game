--[[
Sam
3/18/21
Claw skill
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)


local Claw = {
	Classes = {Enum.Classes.RegularMob, Enum.Classes.BossMob};
	SkillType = Enum.SkillType.Melee;
	DamageType = Enum.DamageTypes.Normal;
	Damage = 10;
	Cooldown = 1;
	Range = 5;
	ManaCost = 2;
	Name = script.Name;
	Angles =  {-45, 45};
	AOE = true;
	Animation = 'rbxassetid://6574357486';
}

function Claw.RunSkill(CallerData, CallBack, Combat)

	local RayCast = Combat[1]
	local CheckClass = Combat[2]
	local PlayAnimation = Combat[3]

	local CanUse = CheckClass(CallerData, Claw.Classes)
	if not CanUse then return end
	local Char = CallerData.Char
	local Hits =	RayCast(CallerData, Claw)
	PlayAnimation(CallerData, Claw.Animation)
	CallBack(CallerData, Claw.Name, Claw.Cooldown)
end

return Claw