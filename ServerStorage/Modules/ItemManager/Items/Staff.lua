Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

return {
	
	Name = script.Name;
	Disc = "Heavy sword forged by the mighty kings";
	
	Damage = 60;
	
	Boosts = {
		Will = 5;
	};
	
	WeaponType = Enum.WeaponType.Magic;
	WeaponHold = Enum.WeaponHold.Back;
	DamageType = Enum.DamageTypes.Magic;
	Slot = Enum.SlotType.Primary;
	SlotSpace = 2;
	
	WeldCFrame = CFrame.Angles(math.rad(90),math.rad(0),math.rad(90)) + Vector3.new(0,-1,0);

	SellPrice = 1000;
	BuyPrice = 5000;
	
	
	
}