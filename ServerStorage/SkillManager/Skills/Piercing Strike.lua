--[[
Sam
3/18/21
Stab skill
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)


local Stab = {
	Classes = {Enum.Classes.Captian, Enum.Classes.Brawler};
	SkillType = Enum.SkillType.Melee;
	DamageType = Enum.DamageTypes.Normal;
	Damage = 5;
	--DOT info
	Ticks = 15;
	TickDamage = 10;
	Duration = 5;
	--
	Cooldown = 5;
	Range = 5;
	ManaCost = 6;
	Name = script.Name;
	Angles =  {-10, 10};
	AOE = true;
	Animation = 'rbxassetid://6574357486';
}

function Stab.RunSkill(CallerData, CallBack, Combat)

	local RayCast = Combat[1]
	local CheckClass = Combat[2]
	local PlayAnimation = Combat[3]

	local CanUse = CheckClass(CallerData, Stab.Classes)
	if not CanUse then return end
	local Char = CallerData.Char
	local Hits =	RayCast(CallerData, Stab)
	if Hits then
		for _, Hit in next, Hits do
			CallerData:ActivateEffect("Bleed", Hit, {Stab.TickDamage, Stab.Ticks, Stab.Duration})
		end
	end
	PlayAnimation(CallerData, Stab.Animation)
	CallBack(CallerData, Stab.Name, Stab.Cooldown)
end

return Stab