--[[
Sam
3/18/21
Heal skill
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)


local Heal = {
	Classes = {Enum.Classes.Clerk};
	SkillType = Enum.SkillType.Magic;
	DamageType = Enum.DamageTypes.Normal;
	
	--HOT effects
	Duration = 120;
	Ticks = 60;
	Amount = 85;
	Limit = 4;
	ID = script.Name;
	Induction = 1;
	--
	Cooldown = 15;
	Range = 45;
	ManaCost = 50;
	Name = script.Name;
	Angles =  {-90, 90};
	AOE = true;
	Animation = 'rbxassetid://6652367358';
}

function Heal.RunSkill(CallerData, CallBack, Combat)
	
	local CheckClass = Combat[2]
	local PlayAnimation = Combat[3]
	local Induction = Combat[4]
	
	local CanUse = CheckClass(CallerData, Heal.Classes)
	if not CanUse then return end
	local SelfChar = CallerData.Char
	local Done = Induction(CallerData, Heal.Induction)
	if not Done then return CallBack(CallerData, Heal.Name, Heal.Cooldown) end
	
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