Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

local TicDeb = {}

local Heal = {
	Amount = 20;
	Duration = 5;
	Limit = 2;
	Image = 'http://www.roblox.com/asset/?id=167399370';
	EffectID = Enum.StatusEffects[script.Name];
	EffectType = Enum.EffectType.Buff;
	ActiveEffects = {};
}


function Heal:UseEffect(Data, Key, Player, CallBack, OtherInfo)
	Heal.ActiveEffects[Key] = true
	local Time = OtherInfo[2] and OtherInfo[2][3]/OtherInfo[2][2] or self.Duration/ self.Ticks
	TicDeb[Key] = {Time, 0}
	
	local TargetData = Data[1] or Data[2]
	local Caster = Data[2]

	local Amount = OtherInfo[2] or Heal.Amount 
	Heal.ActiveEffects[Key] = true

	local MaxHeal = TargetData.RealMaxHealth 

	TargetData.CurrentHealth = (Amount* OtherInfo[1] or 1) + MaxHeal

	local Time = self.Tick or self.Duration

	for Num = 0, Time, Time / (40 * Time)  do
		game["Run Service"].Heartbeat:Wait()
		if not Heal.ActiveEffects[Key] then
			break
		end
	end

	local Sub = TargetData.CurrentHealth -  Amount

	TargetData.CurrentHealth = Sub
	Heal.ActiveEffects[Key]  = nil

	print(	TargetData.CurrentHealth)
	return CallBack(Key, Player)
end

return Heal


--[[
	
]]