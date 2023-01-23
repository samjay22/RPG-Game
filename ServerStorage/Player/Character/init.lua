--[[
Sam
3/20/21
Character manager/class, this is the main script
]]
Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)


local Managers = { -- allows for cleaner code
	require(script.ExperenceManager);
	require(script.StatsManager);
	require(script.StatusManager);
	require(script.EquipmentManager);
	require(game.ServerStorage.Framework.EffectManager.EffectRunner);
	require(game.ServerStorage.Framework.SkillManager.SkillRunner);
	require(game.ServerStorage.Framework.ConsumablesManager.ConsumableRunner);
	require(script.LootManager);
	require(script.UIManager);
	require(script.SlotManager);
}

local Character = {}

local HTTP = game:GetService("HttpService")


function Character.New(Player, SlotName)
	Character.__index = function(_, Index)
		for _, Manager in next, Managers do
			if Manager[Index] then
--				print(Index)
				return Manager[Index]
			elseif Character[Index] then
				return Character[Index]
			end
		end
--		warn("No index "..Index)
	end
	
	return setmetatable({
		
		Alive = true;
		SlotName = SlotName;
		Player = Player;
		Char = nil;
		Data = nil;
		ActiveBuffs = {};
		ActiveEffects = {};
		CDs = {};
		
		CurrentArmour = 0;
		CurrentHealth = 0;
		MaxHealth = 0;
		CurrentMana = 200;
		MaxMana = 200;
		
		DamageMastery = 0;
		TacticalMastery = 0;
		HealAmount = 0;
		
		CritRating = 0;
		
		ManaRegen = 0;
		HealthRegen = 0;
		
		WeaponDamage = 0;
		
		RealMaxHealth = 0;
		RealMaxMana = 0;
		
		PlayerItemLogic = {};
		
		Evade = 50;
		Block = 50;
		Parry = 50;
		
	}, Character)
end

function Character:FirstLoad()
	self:RefreshUI()
end

function Character:LoadCharacter()
	self.Char = self.Player.Character or self.Player.CharacterAdded:Wait()
	self.Alive = true
	self:RemoveEffect(nil, true)
	for Slot, Weapon in next, self.Data.Equipped do
		self:EquipItem(Weapon, Slot)
	end
	--self:EquipItem("Shield")
	self:CalcStats(true)
	self:Experence()
	game.ReplicatedStorage.Remotes.Client.DataEvent:FireClient(self.Player, "CharacterStats",  self)
	coroutine.wrap(function()
		while self.Alive do
			wait(2)
			if  self.CurrentHealth + (self.CurrentHealth * shared.Calc.CalcRegen(self, self.HealthRegen)) < self.MaxHealth then
				self.CurrentHealth += math.floor(self.CurrentHealth * shared.Calc.CalcRegen(self, self.HealthRegen))
			else
				self.CurrentHealth = self.MaxHealth
			end
			if self.CurrentMana + (self.CurrentMana * shared.Calc.CalcRegen(self, self.ManaRegen)) < self.MaxMana then
				self.CurrentMana += math.floor(self.CurrentMana * shared.Calc.CalcRegen(self, self.ManaRegen)) + 2
			else
				self.CurrentMana = self.CurrentMana
			end
		end
	end)()
end



function Character:GetClass()
    return self.Data.ActiveClass
end





return Character