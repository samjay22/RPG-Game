Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)


local Armour = {
	Amount = 50;
	Duration = 30;
	Limit = 2;
	Image = 'http://www.roblox.com/asset/?id=57613004';
	EffectID = Enum.StatusEffects[script.Name];
	EffectType = Enum.EffectType.Buff;
	ActiveEffects = {};
}



function Armour:UseEffect(Data, Key, Player, CallBack, OtherInfo)
	local Amount = OtherInfo[2] or Armour.Amount 
	Armour.ActiveEffects[Key] = true
	
	local TargetData = Data[1] or Data[2]
	local Caster = Data[2]
	
	local MaxArmour = TargetData.RealMaxArmour 
	
	print(Amount, OtherInfo[1], MaxArmour)
	TargetData.CurrentArmour = (Amount[1] * (OtherInfo[1] or 1)) + MaxArmour
	--TargetData.MaxArmour = (Amount * OtherInfo[1] or 1) + MaxArmour

	local Time = self.Tick or self.Duration

	for Num = 0, Time, Time / (40 * Time)  do
		game["Run Service"].Heartbeat:Wait()
		if not Armour.ActiveEffects[Key] then
			break
		end
	end

	local Sub = TargetData.CurrentArmour -  Amount[1]

--	print(Sub)


		TargetData.CurrentArmour = Sub
		--TargetData.MaxArmour = Sub

	Armour.ActiveEffects[Key]  = nil
	
	print(	TargetData.CurrentArmour)
	return CallBack(Key, Player)
end

return Armour
