--[[
Sam
3/18/21
Buff skill
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)


local Buff = {
	Classes = {Enum.Classes.Clerk};
	SkillType = Enum.SkillType.Magic;
	DamageType = Enum.DamageTypes.Normal;
	Range = 60;
	ManaCost = 50;
	Cooldown = 15;
	
	Duration = 60;
	Amount = 150;
	Limit = 4;
	ID = script.Name;
	Induction = 3;
	
	Name = script.Name;
	Angles =  {-2, 2};
	AOE = true;
	Animation = 'rbxassetid://6574357486';
}

function Buff.RunSkill(CallerData, CallBack, Combat)

	local RayCast = Combat[1]
	local CheckClass = Combat[2]
	local PlayAnimation = Combat[3]
	local Induction = Combat[4]
	
	local CanUse = CheckClass(CallerData, Buff.Classes)
	if not CanUse then return end
	local Char = CallerData.Char
	local SelfChar = CallerData.Char
	local Done = Induction(CallerData, Buff.Induction)

	if not Done then return CallBack(CallerData, Buff.Name, Buff.Cooldown) end
	
	for _, P in next,game.Players:GetPlayers() do
		local Mag = (P.Character.PrimaryPart.Position - SelfChar.PrimaryPart.Position).Magnitude
		if Mag <= Buff.Range then
			local Data = shared.Characters[P]
			if Data then
				local Multiplier = shared.Calc .CalcHeal(CallerData.Level or CallerData.Data.LevelInfo.Level, Data, Buff.Amount)
				local Amount = Buff.Amount + (Multiplier * Buff.Amount)
				CallerData:ActivateEffect("Armour", Data, {Buff.Amount, nil, Buff.Duration, Buff.Limit, Buff.ID})
			end
		end
	end
	
	PlayAnimation(CallerData, Buff.Animation)
	CallBack(CallerData, Buff.Name, Buff.Cooldown)
end

return Buff