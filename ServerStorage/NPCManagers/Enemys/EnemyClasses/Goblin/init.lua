
Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

return {
	
	ClassID = Enum.Classes.RegularMob;
	
	Name = "Goblin";
	
	UnitType = "Melee";
		
	Attacks = {"Bite"};--"Bite", "Claw"
	
	
	Level = 5;
	
	Health = 100;
	Mana = 50;
	
	Armour = 100;
	
	Parry = 50;
	Evade = 50;
	Block = 25;
	
	CritRating =  150;
	
	DamageMastery = 200;
	TacticalMastery = 100;
	HealAmount = 2;
	
	CharModel = script.Goblin;
	
	AgroDistance = 15;
	MaxChaseDistance = 25;
	
	AttackSpeed = 1;
	
	WeaponDamage = 5;
	
	MoveSpeed = 15;
	
	DiedAnimation = 'rbxassetid://6582808883';
	
	ImageFrame = 'http://www.roblox.com/asset/?id=6583058124';
	
	Loot = {
		{ItemName = "HealthPotion_1", Chance = 1, MinAmount = 1, MaxAmount = 5, EnumType = Enum.HolderType.Consumable};
	}
	
}