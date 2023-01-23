--[[
Sam
3/18/21

Brawler Class


This class is damage, main goal is to damage the enemy.
]]

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

return {
	ClassID = Enum.Classes.Clerk;
	
	BaseHealth = 100;
	BaseArmour = 5;
	BaseMana = 450;
	BaseMastery = 100;
	BaseDmg = 5;
	BaseCrit = 250;
	BaseHealthRegen = 10;
	BaseManaRegen = 15;
	BaseTactical = 500;
	--Stat Modifiers
	Vitality = 3;
	Might = 2;
	Will = 5;
	Fate = 5;
	Agility = 3;
	---
	
	Class = Enum.Classes.Clerk;
	WeaponType = Enum.WeaponType.Magic;
	Role = Enum.ClassRoles.Heal;
	WeaponHold = Enum.WeaponHold.Back;
	ArmourType ={Enum.ArmourType.Light };
	
	Image = 'http://www.roblox.com/asset/?id=6630920227';
	
	
	Skills = {
		["1"] = {
			["TreeName"] = "Debuffing";
		};
		["2"] = {
			["TreeName"] = "Buffing";
			"Deflecting Words";
		};
		["3"] = {
			["TreeName"] = "Healing";
			"Bolstered Courage";
			"Healing Might";
			"Resounding Touch";
		};
		
	}
	
	
}






