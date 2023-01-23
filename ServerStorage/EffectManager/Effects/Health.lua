Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

local Health = {
	Amount = 250;
	Duration = 1000;
	Limit = 3;
	EffectID = Enum.StatusEffects[script.Name];
	EffectType = Enum.EffectType.Buff;
	ActiveEffects = {};
	Image = 'http://www.roblox.com/asset/?id=1032918680';
}

function Health:UseEffect(Data, Key, Player, CallBack, OtherInfo)
--	print(TargetData)
	local Amount = OtherInfo[2] or Health.Amount 
	Health.ActiveEffects[Key] = true
	
	local TargetData = Data[1] or Data[2]
	local Caster = Data[2]

	
	local MaxHealth = TargetData.RealMaxHealth 
	

	TargetData.CurrentHealth = (Amount* OtherInfo[1] or 1) + MaxHealth
	TargetData.MaxHealth = (Amount * OtherInfo[1] or 1) + MaxHealth
	local Time = self.Tick or self.Duration
	
	for Num = 0, Time, Time / (40 * Time)  do
		game["Run Service"].Heartbeat:Wait()
		if not Health.ActiveEffects[Key] then
			break
		end
	end

	local Sub = TargetData.CurrentHealth -  Amount
	
--	print(Sub)
	
	if 	Sub <= 0 then
		TargetData.CurrentHealth = 15
		TargetData.MaxHealth = MaxHealth * OtherInfo[1] or 1
	else
		TargetData.CurrentHealth = Sub
		TargetData.MaxHealth = Sub
	end
	
	Health.ActiveEffects[Key]  = nil
	return CallBack(Key, Player)
end

return Health
