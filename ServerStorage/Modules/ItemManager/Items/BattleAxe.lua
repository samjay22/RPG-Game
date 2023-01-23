Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

return {
	
	Name = script.Name;
	Disc = "Heavy sword forged by the mighty kings";
	
	Damage = 15;
	--Armour = 60;
	Boosts = {
		Fate = 5;
		Might = 10;
	};
	
	WeaponType = Enum.WeaponType.Medium;
	WeaponHold = Enum.WeaponHold.Back;
	DamageType = Enum.DamageTypes.Normal;
	Slot ={ Enum.SlotType.Primary,  Enum.SlotType.Secondary};
	SlotSpace = 1;
	
	
	WeldCFrame = CFrame.Angles(math.rad(180),math.rad(90),math.rad(-90));

	SellPrice = 1000;
	BuyPrice = 5000;
	
	
	
}