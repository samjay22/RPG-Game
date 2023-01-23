local WeldManager = {}

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

local WeaponWelds = {
	"LeftHand";
	"RightHand";
}

function MultiWeld(self, Item, ItemData)
	local Char = self.Char
	local R = Item:Clone()
	local L = Item:Clone()
	
	local RW = Instance.new("Motor6D", R)
	local LW = Instance.new("Motor6D", L)
	
	RW.Part0 = R.PrimaryPart
	LW.Part0 = L.PrimaryPart
	
	RW.C0 = ItemData.WeldCFrame
	LW.C0 = ItemData.WeldCFrame
	
	if ItemData.Slot == Enum.SlotType.Boots then
		RW.Part1 = Char.RightFoot
		LW.Part1 = Char.LeftFoot
		
		R.Parent = Char.RightFoot
		L.Parent = Char.LeftFoot
	elseif ItemData.Slot == Enum.SlotType.Shoulders then
		RW.Part1 = Char.RightUpperArm
		LW.Part1 = Char.LeftUpperArm

		R.Parent = Char.RightUpperArm
		L.Parent = Char.LeftUpperArm
	elseif ItemData.Slot == Enum.SlotType.Wrists then
		RW.Part1 = Char.RightLowerArm
		LW.Part1 = Char.LeftLowerArm

		R.Parent = Char.RightLowerArm
		L.Parent = Char.LeftLowerArm
	elseif ItemData.Slot == Enum.SlotType.Pants then
		RW.Part1 = Char.RightUpperLeg
		LW.Part1 = Char.LeftUpperLeg

		R.Parent = Char.RightUpperLeg
		L.Parent = Char.LeftUpperLeg
	end
	
end

function SingleWeld(self, Item, ItemData, Slot)
	
	local Char = self.Char
	local ItemClone = Item:Clone()
	local Weld = Instance.new("Motor6D", ItemClone)
	Weld.Part0 = ItemClone.PrimaryPart
	Weld.C0 = ItemData.WeldCFrame
	
	if Slot and type(ItemData.Slot) == 'table' then
		local WeldParent = WeaponWelds[Slot]
		if WeldParent then
			Weld.Part1 = Char[WeldParent]
			ItemClone.Parent = Char[WeldParent]
		end
	elseif ItemData.Slot == Enum.SlotType.Chest then
		Weld.Part1 = Char.UpperTorso
		ItemClone.Parent = Char.UpperTorso
	elseif ItemData.Slot == Enum.SlotType.Helm then
		Weld.Part1 = Char.Head
		ItemClone.Parent = Char.Head
	elseif ItemData.Slot == Enum.SlotType.Cape then -- Ehh physics
	print("Cape go woosh") -- smh
	elseif type(ItemData.Slot) ~= 'table' then 
		local WeldParent = WeaponWelds[ItemData.Slot]
		Weld.Part1 = Char[WeldParent]
		ItemClone.Parent = Char[WeldParent]
	end
end



function WeldManager.FormWeld(self, Item, ItemData, Slot)
	if ItemData.ArmourType then -- Armour
		local ArmourType = ItemData.ArmourType
		local SlotType = ItemData.Slot
		if SlotType == Enum.SlotType.Boots or SlotType == Enum.SlotType.Shoulders 
			or SlotType == Enum.SlotType.Wrists or SlotType == Enum.SlotType.Pants then
			MultiWeld(self, Item, ItemData)
		else
			SingleWeld(self, Item, ItemData)
		end
		
	elseif ItemData.WeaponType then -- Weapon
		local WeaponType = ItemData.WeaponType
		local SlotType = ItemData.Slot
		SingleWeld(self, Item, ItemData, Slot)
	end
end




return WeldManager