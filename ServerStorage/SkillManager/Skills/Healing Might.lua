--[[
Sam
3/18/21
Heal skill
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)


local Heal = {
	Classes = {Enum.Classes.Captian, Enum.Classes.Clerk};
	SkillType = Enum.SkillType.Melee;
	DamageType = Enum.DamageTypes.Normal;
	
	--HOT effects
	Duration = 15;
	Ticks = 5;
	Amount = 30;
	Limit = 4;
	ID = script.Name;
	--
	Cooldown = 1;
	Range = 25;
	ManaCost = 10;
	Name = script.Name;
	Angles =  {-90, 90};
	AOE = true;
	Animation = 'rbxassetid://65743571486';
}

function Heal.RunSkill(CallerData, CallBack, Combat)
	
	local CheckClass = Combat[2]
	local PlayAnimation = Combat[3]
	
	local CanUse = CheckClass(CallerData, Heal.Classes)
	if not CanUse then return end
	local SelfChar = CallerData.Char
	
	for _, P in next,game.Players:GetPlayers() do
		local Mag = (P.Character.PrimaryPart.Position - SelfChar.PrimaryPart.Position).Magnitude
		if Mag <= Heal.Range then
			local Data = shared.Characters[P]
			if Data then
				local Multiplier = shared.Calc .CalcHeal(CallerData.Level or CallerData.Data.LevelInfo.Level, Data, Heal.Amount)
				local Amount = Heal.Amount + (Multiplier * Heal.Amount)
				CallerData:ActivateEffect("HOT", Data, {Heal.Amount, Heal.Ticks, Heal.Duration, Heal.Limit, Heal.ID})
			end
		end
	end
	
	PlayAnimation(CallerData, Heal.Animation)
	CallBack(CallerData, Heal.Name, Heal.Cooldown)
end

return Heal