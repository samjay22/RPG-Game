Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

return {
	
	Name = script.Name;
	Disc = "Heavy sword forged by the mighty kings";
	
	Damage = 160;
	
	Boosts = {
		Will = 25;
		TacticalMastery = 500;
		HealAmount = 500;
	};
	
	WeaponType = Enum.WeaponType.Magic;
	WeaponHold = Enum.WeaponHold.Back;
	DamageType = Enum.DamageTypes.Magic;
	Slot = Enum.SlotType.Primary;
	SlotSpace = 2;
	
	WeldCFrame = CFrame.Angles(math.rad(0),math.rad(180),math.rad(0)) + Vector3.new(0,0,-1.5);

	SellPrice = 1000;
	BuyPrice = 5000;
	
	
	
}