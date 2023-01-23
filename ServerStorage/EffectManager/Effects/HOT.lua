Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)
local DamageEffects = require(game.ServerStorage.Framework.Modules.Visuals.VisualEffects)



local TicDeb = {}

local HOT = {
	Amount = 20;
	Duration = 5;
	Ticks = 10;
	Limit = 2;
	Image = 'http://www.roblox.com/asset/?id=167399370';
	EffectID = Enum.StatusEffects[script.Name];
	EffectType = Enum.EffectType.Buff;
	ActiveEffects = {};
}


function HOT:UseEffect(Data, Key, Player, CallBack, OtherInfo)
	HOT.ActiveEffects[Key] = true
	local Time = OtherInfo[2] and OtherInfo[2][2] and OtherInfo[2][3]/OtherInfo[2][2] or self.Duration/ self.Ticks
	TicDeb[Key] = {Time, 0}

	while HOT.ActiveEffects[Key] do
		game["Run Service"].Stepped:Wait()
		if TicDeb[Key]  and (os.clock() - TicDeb[Key][1] ) >= Time and TicDeb[Key][2] < HOT.Ticks then
			TicDeb[Key][1] = os.clock()
			TicDeb[Key][2] += 1
			

			local TargetData = Data[1] or Data[2]
			local Caster = Data[2]
			
			local Level =  TargetData.Level or TargetData.Data.LevelInfo.Level
			local Reduction = shared.Calc.DamageReduction(TargetData.CurrentArmour, Level)
			local Crit, Type = shared.Calc.CalcCrit(Caster,Level)
			local Amount = OtherInfo[2] and OtherInfo[2][1] 

			if Crit then
				if Type == "Dev" then
					Amount = (Amount or HOT.Amount) * 2
				else
					Amount = (Amount or HOT.Amount) * 1.5
				end
			else
				Amount =  (Amount or HOT.Amount)
			end

			if TargetData.CurrentHealth < TargetData.MaxHealth then
				TargetData.CurrentHealth += Amount
			else 
				TargetData.CurrentHealth = TargetData.MaxHealth
			end
			
			DamageEffects.Heal(Crit, Amount, TargetData.Char)
			
		elseif TicDeb[Key][2] >= HOT.Ticks then
			break
		end
	end
	TicDeb[Key] = nil
	HOT.ActiveEffects[Key]  = nil
	return CallBack(Key, Player)
end

return HOT


--[[
	
]]