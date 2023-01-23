Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

local Damage = {
	Amount = 15;
	Duration = 20;
	Limit = 2;
	Image = 'http://www.roblox.com/asset/?id=79954274';
	EffectID = Enum.StatusEffects[script.Name];
	EffectType = Enum.EffectType.Buff;
	ActiveEffects = {};
}


function Damage:UseEffect(Data, Key, Player, CallBack, OtherInfo)

	local Amount = OtherInfo[2] or Damage.Amount 
	
	local TargetData = Data[1] or Data[2]
	local Caster = Data[2]
	
	Damage.ActiveEffects[Key] = true

	TargetData.WeaponDamage += Amount

	local Time = self.Tick or self.Duration

	for Num = 0, Time, Time / (40 * Time)  do
		game["Run Service"].Heartbeat:Wait()
		if not Damage.ActiveEffects[Key] then
			break
		end
	end

	TargetData.WeaponDamage -= Amount
	
	return CallBack(Key, Player)
end


return Damage
