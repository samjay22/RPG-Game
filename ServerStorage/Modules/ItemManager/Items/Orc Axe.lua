Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

return {
	
	Name = script.Name;
	Disc = "Heavy sword forged by the mighty kings";
	
	Damage = 35;
	
	Boosts = {
		Might = 15;
	};
	
	WeaponType = Enum.WeaponType.Medium;
	WeaponHold = Enum.WeaponHold.Back;
	DamageType = Enum.DamageTypes.Normal;
	Slot ={ Enum.SlotType.Primary,  Enum.SlotType.Secondary};
	SlotSpace = 1;
	
	
	WeldCFrame = CFrame.Angles(math.rad(0),math.rad(180),math.rad(90))  + Vector3.new(1,0,-1);

	SellPrice = 1000;
	BuyPrice = 5000;
	
	
	
}