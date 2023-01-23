
Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

local Table = {
	Classes = {Enum.Classes.Captian, Enum.Classes.Brawler};
	SkillType = Enum.SkillType.Melee;
	DamageType = Enum.DamageTypes.Normal;
	Damage = 2;
	Cooldown = 10;
	Range = 10;
	ManaCost = 50;
	Name = script.Name;
	Angles =  {-90, 90};
	AOE = true;
	Animation = 'rbxassetid://6574357486';
}




function Table.RunSkill(CallerData, CallBack, Combat)

	local RayCast = Combat[1]
	local CheckClass = Combat[2]
	local PlayAnimation = Combat[3]

	local CanUse = CheckClass(CallerData, Table.Classes)
	if not CanUse then return end
	local Char = CallerData.Char
	local Hits =	RayCast(CallerData, Table)
	if Hits then
		for _, Hit in next, Hits do
			CallerData:ActivateEffect("ArmourDebuff", Hit)
			CallerData:ActivateEffect("DamageDebuff", Hit)
		end
	end
	PlayAnimation(CallerData, Table.Animation)
	CallBack(CallerData, Table.Name, Table.Cooldown)
end





return Table