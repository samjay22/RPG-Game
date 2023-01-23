local Consumables = {}

local CS = game:GetService("CollectionService")

function Consumables:UpdateAmount(Name)
	
	local PlayerGui = self.Player.PlayerGui
	local Display = PlayerGui.Display
	local ToolBar = Display.ToolBar.Holder
	local Inv = Display.Inventory.Holder
	
	
	if Name then
		self.Data.RealInventory[Name] -= 1
		for _, SlotItem in next, CS:GetTagged("Draggable") do
			if CS:HasTag(SlotItem.Parent, "PotionSlot") and not SlotItem:FindFirstAncestor("Inventory") and SlotItem.ItemName.Value == Name then
				if 	self.Data.RealInventory[Name] > 0 then
					print("Ran")
					SlotItem.Amount.Text = 	self.Data.RealInventory[Name]
				else
					SlotItem:Destroy()
				end
			end
		end
		
		for Slot, Data in next, self.Data.Inventory do
			if Data[1] == Name then
				Data[3] -= 1
				if Data[3] > 0 then
					print(Data, Slot)
					Inv[Slot]:FindFirstChildWhichIsA("ImageLabel").Amount.Text = Data[3]
				else
					Inv[Slot]:FindFirstChildWhichIsA("ImageLabel"):Destroy()
					self.Data.Inventory[Slot] = nil
				end
				break
			end
		end
	end
	print(	self.Data.RealInventory[Name])
end

function Consumables:UseConsumable(Name)
	local ConsumableData = script.Parent.Consumables:FindFirstChild(Name) 
	if ConsumableData and self.Data.RealInventory[Name] > 0  then
		self:UpdateAmount(Name)
		local Runner = require(ConsumableData)
		Runner.Use(self)
	end
end


return Consumables
