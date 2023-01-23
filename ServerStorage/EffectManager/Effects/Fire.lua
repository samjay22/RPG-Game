Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

local TicDeb = {}

local Fire = {
	Amount = 30;
	Duration = 20;
	Ticks = 30;
	Image = 'http://www.roblox.com/asset/?id=4681641501';
	EffectID = Enum.StatusEffects[script.Name];
	EffectType = Enum.EffectType.Debuff;
	ActiveEffects = {};
}


function Fire:UseEffect(Data, Key, Player, CallBack, OtherInfo, Visuals)
	
	Fire.ActiveEffects[Key] = true
	local Time = OtherInfo[2] and OtherInfo[2][3]/OtherInfo[2][2] or self.Duration/ self.Ticks
	TicDeb[Key] = {Time, 0}
	
	while Fire.ActiveEffects[Key] do
		game["Run Service"].Stepped:Wait()
		print( Fire.ActiveEffects[Key])
		if TicDeb[Key]  and (os.clock() - TicDeb[Key][1] ) >= Time and TicDeb[Key][2] < Fire.Ticks then
			TicDeb[Key][1] = os.clock()
			TicDeb[Key][2] += 1
			print(Time)
			
			local TargetData = Data[1] or Data[2]
			local Caster = Data[2]

			local Level =  TargetData.Level or TargetData.Data.LevelInfo.Level
			local Reduction = shared.Calc.DamageReduction(TargetData.CurrentArmour, Level)
			local Crit, Type = shared.Calc.CalcCrit(Caster,Level)
			local Amount = OtherInfo[2] and OtherInfo[2][1] 

			if Crit then
				if Type == "Dev" then
					Amount = (Amount or Fire.Amount) * 2
				else
					Amount = (Amount or Fire.Amount) * 1.5
				end
			else
				Amount =  (Amount or Fire.Amount)
			end
			local Damage = Amount - (Reduction * Amount)

			TargetData.CurrentHealth -= Damage
			if TargetData.CurrentHealth <= 0 then
				break
			end
			Visuals.Damage(Crit, math.ceil(Damage), TargetData.Char)
		elseif TicDeb[Key][2] >= Fire.Ticks then
			break
		end
	end
	TicDeb[Key] = nil
	Fire.ActiveEffects[Key]  = nil
	return CallBack(Key, Player)
end

return Fire
