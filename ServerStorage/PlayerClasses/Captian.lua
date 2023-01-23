--[[
Sam
3/18/21

Captian Class


This class is support, main goal is to buff allies.
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

return {
	ClassID = Enum.Classes.Captian;
	
	BaseHealth = 200;
	BaseArmour = 50;
	BaseMana = 250;
	BaseMastery = 50;
	BaseDmg = 5;
	BaseCrit = 200;
	BaseHealthRegen = 25;
	BaseManaRegen = 10;
	BaseTactical = 350;
	--Stat Modifiers
	Vitality = 5;
	Might = 5;
	Will = 1;
	Fate = 5;
	Agility = 3;
	---
	
	Class = Enum.Classes.Captian;
	WeaponType ={ Enum.WeaponType.Heavy,  Enum.WeaponType.Dual, Enum.WeaponType.Medium, Enum.WeaponType.Shield};
	Role = Enum.ClassRoles.Support;
	WeaponHold = Enum.WeaponHold.Back;
	ArmourType ={ Enum.ArmourType.Heavy,Enum.ArmourType.Medium, Enum.ArmourType.Light };
	
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






