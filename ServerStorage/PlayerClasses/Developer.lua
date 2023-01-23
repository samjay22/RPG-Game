--[[
Sam
3/18/21

Captian Class


This class is support, main goal is to buff allies.
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

local WeaponTypes = {}
local ArmourTypes = {}

for _, Key in next, Enum.WeaponType do
	table.insert(WeaponTypes, Key)
end
for _, Key in next, Enum.ArmourType do
	table.insert(ArmourTypes, Key)
end

return {
	ClassID = Enum.Classes.Captian;
	
	BaseHealth = 2000;
	BaseArmour = 1000000000000000000000000000;
	BaseMana = 1000000000000000000000000000;
	BaseMastery = 1000000000000000000000000000;
	BaseDmg = 1000000000000000000000000000;
	BaseCrit = 1000000000000000000000000000;
	BaseHealthRegen = 1000000000000000000000000000;
	BaseManaRegen = 1000000000000000000000000000;
	BaseTactical = 1000000000000000000000000000;
	--Stat Modifiers
	Vitality = 200;
	Might = 200;
	Will = 200;
	Fate = 200;
	Agility = 200;
	---
	
	Class = Enum.Classes.Clerk;
	WeaponType = WeaponTypes;
	Role = Enum.ClassRoles.Support;
	WeaponHold = Enum.WeaponHold.Back;
	ArmourType = ArmourTypes;
	
	Image = 'http://www.roblox.com/asset/?id=6602050721';
	
	Skills = {
		["1"] = {
			["TreeName"] = "Damage";
			"Vicious Swipe";
			"Piercing Strike";
		};
		["2"] = {
			["TreeName"] = "Tank";
			"Defensive Strike";
			"Parry";
		};
		["3"] = {
			["TreeName"] = "Healing";
			"Bolstered Courage";
			"Healing Might";
		};

	}
	
	
}






