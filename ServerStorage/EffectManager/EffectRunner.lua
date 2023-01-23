local EffectRunner = {}

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)
local DamageEffects = require(game.ServerStorage.Framework.Modules.Visuals.VisualEffects)

local Deb = {}
local EffectRegistry = { -- keep track of all active effects across game
	
	[Enum.EffectType.Debuff] = {}; -- debuff
	[Enum.EffectType.Buff] = {}; -- buff
	
} 

--((EffectName, Key, Image, Remove)

local HTTP = game:GetService("HttpService")

function CallBack(Key, Char)
--	print("Called")
	local Player = game.Players:GetPlayerFromCharacter(Char)
	if Player then
		game.ReplicatedStorage.Remotes.Client.EffectsUpdate:FireClient(Player,nil, Key, nil, true)
	end
end

function WipeEffects(Type)
	print(EffectRegistry[Type])
	for Key, Effect in next, EffectRegistry[Type] do
		EffectRegistry[Type][Key].ActiveEffects[Key] = false
		EffectRegistry[Type][Key].ActiveEffects[Key]  = nil
		EffectRegistry[Type][Key] = nil
	end
end

function EffectRunner:RemoveEffect(EffectType, FullWipe)
	if not FullWipe then
		for Key, Effect in next, EffectRegistry[EffectType] do
			EffectRegistry[EffectType][Key].ActiveEffects[Key] = false
			EffectRegistry[EffectType][Key].ActiveEffects[Key]  = nil
			EffectRegistry[EffectType][Key] = nil
			return EffectRegistry[EffectType][Key].ActiveEffects[Key]
		end
	else
		WipeEffects(Enum.EffectType.Debuff)
		WipeEffects(Enum.EffectType.Buff)
	end
end


function MakeEffect(Target, Image)
	local Effect = script.Template:Clone()	
	Effect.Image = Image
	Effect.Parent = Target.VitalInfo.Holder.Effects
end


function EffectRunner:ActivateEffect(EffectName, Target, CastInfo)
    if self.CurrentHealth <= 0 or not self.Alive then return end
    if not self.Char then return end
	if not Deb[self.Char] then Deb[self.Char]  = {} end
	local EffectData = require(game.ServerStorage.Framework.EffectManager.Effects[EffectName])
	local ID = CastInfo and CastInfo[5] or EffectData.EffectID
	if not Deb[self.Char][ID] then Deb[self.Char][ID] = 0 end
--	print( Deb[self.Char])
	local Limit =  CastInfo and CastInfo[4] or EffectData.Limit  or 50
	
	if Deb[self.Char][ID]  < Limit  then
		Deb[self.Char][ID]  += 1 
		coroutine.wrap(function()
			
			local Key = HTTP:GenerateGUID()
			local Player = Target and Target.Player or self.Player
			if Target and Target.Name then
				
				print('Called')
				MakeEffect(Target,  EffectData.Image)
				
			elseif Target and Target.Player then
				game.ReplicatedStorage.Remotes.Client.EffectsUpdate:FireClient(Player, EffectName, Key, EffectData.Image)
			elseif self.Player then
				game.ReplicatedStorage.Remotes.Client.EffectsUpdate:FireClient(Player, EffectName, Key, EffectData.Image)
			end
			
			local Amount =  EffectData.Amount * 1
			--			print(Amount)
			
			EffectRegistry[EffectData.EffectType][Key] =  EffectData
			EffectData:UseEffect({Target , self}, Key, self.Char or self.Player, CallBack, {Deb[self.Char][ID],CastInfo}, DamageEffects)
			Deb[self.Char][ID]  -= 1
		end)()
	end
	
	
end



return EffectRunner
