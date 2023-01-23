Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

local Acid = {
	Amount = 5;
	Duration = 15;
	Ticks = 5;
	Limit = 2;
	Image = 'http://www.roblox.com/asset/?id=2174702810';
	EffectID = Enum.StatusEffects[script.Name];
	EffectType = Enum.EffectType.Debuff;
	ActiveEffects = {};
}


function Acid:UseEffect(Data, Key, Player, CallBack, OtherInfo, Visuals)

	Acid.ActiveEffects[Key] = true

	for Num = 0, OtherInfo[2] and OtherInfo[2][2] or self.Tick or self.Duration do
		
		local TargetData = Data[1] or Data[2]
		local Caster = Data[2]
		
		local Level =  TargetData.Level or TargetData.Data.LevelInfo.Level
		local Amount = OtherInfo[2] and OtherInfo[2][1] 
		
		Amount = Amount or Acid.Amount * Level
		
		TargetData.WeaponDamage -= Amount
		
		local Time = self.Tick or self.Duration

		for Num = 0, Time, Time / (40 * Time)  do
			game["Run Service"].Heartbeat:Wait()
			if not Acid.ActiveEffects[Key] then
				break
			end
		end
		
		TargetData.WeaponDamage += Amount
		
	end
	Acid.ActiveEffects[Key]  = nil
	return CallBack(Key, Player)
end
return Acid
