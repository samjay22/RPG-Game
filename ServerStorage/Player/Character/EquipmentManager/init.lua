local Equip = {}

local ItemManager = require(game.ServerStorage.Framework.Modules.ItemManager)
local WeldManager = require(script.WeldManager)
local CS = game:GetService("CollectionService")
Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

function FindItem(ItemName)
	for _, Item in next, game.ServerStorage.Models:GetDescendants() do
		local Item = Item:FindFirstChild("ItemName") or Item.Name == ItemName and Item:IsA("Model") and Item  or Item.Parent:FindFirstChild("ItemName")
		if Item then
			return Item
		end
	end
end

local Slots = { -- for simple type checking
	"LeftHand";
	"RightHand";
	
}

function Del(Item, SlotName)
	local ItemLookup = ItemManager[Item.Name]
	print("Called")
	print(Slots[SlotName], ItemLookup.Name, ItemLookup.Slot)
	if ItemLookup then
		if ItemLookup.Slot == SlotName then
			Item:Destroy()
		end
	end
end

function ClearSlot(self, SlotName, OtherSlot) -- OtherSlot is for clearing selected slots
	local Gear = CS:GetTagged("GearItem")
	
	for _, Item in next, Gear do
		if Item:FindFirstAncestor(self.Player.Name) then
			local ItemLookup = ItemManager[Item.Name]
			print(Slots[OtherSlot] , Slots[SlotName] )
			if  Slots[OtherSlot] or Slots[SlotName] then
				if type(ItemLookup.Slot) == 'table'  then
					local Ob = self.Char[Slots[OtherSlot]]:FindFirstChildWhichIsA("Model")
					if Ob then
						Ob:Destroy()
						local Slot = type(SlotName) ~= 'table' and SlotName or OtherSlot and OtherSlot
						self.Data.Equipped[Slot] = ""
					end
				elseif type(ItemLookup.Slot) ~= 'table' and SlotName then
					local Ob = self.Char[Slots[SlotName]]:FindFirstChildWhichIsA("Model")
					if Ob then
						Ob:Destroy()
						local Slot = type(SlotName) ~= 'table' and SlotName or OtherSlot and OtherSlot
						self.Data.Equipped[Slot] = ""
					end
 				elseif  not Slots[OtherSlot] or not Slots[SlotName] then
					Del(Item, SlotName)
					local Slot = type(SlotName) ~= 'table' and SlotName or OtherSlot and OtherSlot
					self.Data.Equipped[Slot] = ""
				end
			elseif  not Slots[OtherSlot] or not Slots[SlotName] then
				Del(Item, SlotName)
				local Slot = type(SlotName) ~= 'table' and SlotName or OtherSlot and OtherSlot
				self.Data.Equipped[Slot] = ""
			end
		end
	end
end

function CheckEquipped(self, Slot)
	local Char = self.Char
	local Items = Char:GetDescendants() 
	for _, Item in next, Items do
		local FoundItem = FindItem(Item.Name)
		if FoundItem then
			local ItemData = ItemManager[FoundItem.Name]
			if ItemData.Slot == Slot then
				return ItemData
			end
		end
	end
end

function CheckWeapon(self, Type)
	local ClassData = self.Data.ActiveClass
	if type(ClassData.WeaponType) == 'table' then
		for _, TypeOf in next, ClassData.WeaponType do
			if Type == TypeOf then
				return  true 
			end
		end
	elseif type( ClassData.WeaponType) ~= 'table' then
		if  ClassData.WeaponType == Type then 
			return true 
		end
	end
	return false
end

function Equip:EquipItem(ItemName, Slot)
	local Item = FindItem(ItemName)
	local ItemData = ItemManager[ItemName]
	Slot = tonumber(Slot)
	
	if ItemData and Item then
		if not CheckWeapon(self, ItemData.WeaponType) then return false end
		if type(ItemData.Slot) ~= 'table' then
			
			if ItemData.WeaponType and ItemData.WeaponType == Enum.WeaponType.Heavy then
				
				self.Data.Equipped[Enum.SlotType.Primary] = ItemData.Name
				self.Data.Equipped[Enum.SlotType.Secondary] = ""
				
				ClearSlot(self, Enum.SlotType.Primary, Slot)
				ClearSlot(self, Enum.SlotType.Secondary, Slot)
				
				WeldManager.FormWeld(self, Item, ItemData)
		
			else
				ClearSlot(self, ItemData.Slot, Slot)
				self.Data.Equipped[ItemData.Slot] = ItemData.Name
				WeldManager.FormWeld(self, Item, ItemData)
			end
		elseif Slot and  type(ItemData.Slot) == 'table'  then

			self.Data.Equipped[Slot] = ItemData.Name
			ClearSlot(self,Slot, Slot)
			
			WeldManager.FormWeld(self, Item, ItemData, Slot)
			
		end
	end
	self:CalcStats()
	return true
end

function Equip:UnEquip(Slot)
	Slot = tonumber(Slot)
	print(Slot)
	ClearSlot(self, Slot, Slot) 
end

return Equip