local StatsManager = {}

local PlayerClasses = game.ServerStorage.Framework.PlayerClasses
local ItemManager = require(game.ServerStorage.Framework.Modules.ItemManager)
Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

--StatsManager.__index = StatsManager


--Vitality = 50;
--Might = 50;
--Will = 0;
--Fate = 0;
--Agility = 0;

function StatsManager:CalcStats(Load, Health, Mana)
	
	local Calc = shared.Calc.CalcPlayerStat
	
	self.RealMaxHealth = Calc(self, "Vitality", "BaseHealth")
	self.RealMaxMana  =  Calc(self, "Fate", "BaseMana");
	self.DamageMastery = Calc(self, "Might", "BaseMastery")
	self.TacticalMastery = Calc(self, "Will", "BaseTactical")
	self.CritRating = Calc(self, "Agility", "BaseCrit")
	self.RealMaxArmour = Calc(self, "Fate", "BaseArmour")
	self.HealthRegen = Calc(self, "Vitality", "BaseHealthRegen")
	self.ManaRegen = Calc(self, "Fate", "BaseManaRegen")
	self.Parry = Calc(self, "Agility", nil)
	self.Evade = Calc(self, "Agility", nil)
	self.Block = Calc(self, "Might", nil)
	self.HealAmount = self.TacticalMastery / 4;
	
--	print(self.ManaRegen)
--	print(self.CritRating)
	if Load then
		self.CurrentHealth = Calc(self, "Vitality", "BaseHealth")
		self.MaxMana =  Calc(self, "Fate", "BaseMana")
		self.CurrentMana =  Calc(self, "Fate", "BaseMana")
		self.RealMaxHealth = self.MaxHealth
		self.RealMaxMana =  self.MaxMana
		self.RealMaxArmour = self.CurrentArmour
	elseif Health then
		self.CurrentHealth = Calc(self, "Vitality", "BaseHealth")
	elseif Mana then
		self.MaxMana =  Calc(self, "Fate", "BaseMana")
		self.CurrentMana =  Calc(self, "Fate", "BaseMana")
	end
-----	print(self)
end



return StatsManager
