--[[
Sam
3/18/21

Brawler Class


This class is damage, main goal is to damage the enemy.
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

return {
	ClassID = Enum.Classes.Brawler;
	
	BaseHealth = 150;
	BaseArmour = 15;
	BaseMana = 400;
	BaseMastery = 300;
	BaseDmg = 15;
	BaseCrit = 600;
	BaseHealthRegen = 10;
	BaseManaRegen = 15;
	BaseTactical = 100;
	--Stat Modifiers
	Vitality = 3;
	Might = 5;
	Will = 1;
	Fate = 4;
	Agility = 5;
	---
	
	Class = Enum.Classes.Brawler;
	WeaponType ={Enum.WeaponType.Medium, Enum.WeaponType.Dual};
	Role = Enum.ClassRoles.DPS;
	WeaponHold = Enum.WeaponHold.Back;
	ArmourType ={ Enum.ArmourType.Heavy,Enum.ArmourType.Medium, Enum.ArmourType.Light };
	
	Image = 'http://www.roblox.com/asset/?id=6602043963';
	
	
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






