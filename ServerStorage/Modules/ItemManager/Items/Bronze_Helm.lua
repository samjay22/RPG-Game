Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

return {

	Name = script.Name;
	Disc = "Heavy Helm forged by the mighty kings";

	--Damage = 25;
	Armour = 50;
	Boosts = {
		Might = 5;
	};

	ArmourType = Enum.ArmourType.Heavy;
	--WeaponHold = Enum.WeaponHold.Back;
	--DamageType = Enum.DamageTypes.None;
	Slot = Enum.SlotType.Helm;
	SlotSpace = 1;

	WeldCFrame = CFrame.Angles(math.rad(0),math.rad(180),math.rad(0)) + Vector3.new(0,0,0);

	SellPrice = 1000;
	BuyPrice = 5000;



}