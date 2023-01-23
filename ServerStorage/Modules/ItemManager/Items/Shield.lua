Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

return {
	
	Name = script.Name;
	Disc = "Heavy sword forged by the mighty kings";
	
	--Damage = 15;
	Armour = 50;
	Boosts = {
		Fate = 5;
		Might = 5;
	};
	
	WeaponType = Enum.WeaponType.Shield;
	WeaponHold = Enum.WeaponHold.Back;
	DamageType = Enum.DamageTypes.None;
	Slot = Enum.SlotType.Secondary;
	SlotSpace = 1;
	
	
	WeldCFrame = CFrame.Angles(math.rad(-15),math.rad(-100),math.rad(-15)) + Vector3.new(0,0,-.4);

	SellPrice = 1000;
	BuyPrice = 5000;
	
	
	
}