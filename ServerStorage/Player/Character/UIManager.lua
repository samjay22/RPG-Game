local Images = require(game.ServerStorage.Framework.Modules.Images.GameImages)
local ItemInfo = require(game.ServerStorage.Framework.Modules.Images.ObjectInfo)
Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)
local UIManager = {}


function UIManager:RefreshUI() -- this updates the ui when player joins and resets
	print(self.Data.ToolBar)
	if self.Data.ActiveClass then
		
		local PlayerGui = self.Player.PlayerGui
		local Display = PlayerGui.Display
		local ToolBar = Display.ToolBar.Holder
		local Inv = Display.Inventory.Holder
		local GearFrame = Display.GearFrame
		local SkillBook = Display.SkillBook
		local CharStats = Display.CharacterStats
		
		local ClassImage = self.Data.ActiveClass.Image
		
		CharStats.ClassIcon.Image = ClassImage and ClassImage or ""
		
		
		local Skills = self.Data.ActiveClass.Skills
		
		for Name, Table in next, Skills do
			for Type, Value in next, Table do
				if Type ~= 'TreeName' then
					
					local Template = script.SkillInfo:Clone()
					Template.ItemFrame.SkillImage.Image = Images[Value]
					Template.ItemFrame.SkillImage.SkillName.Value = Value
					Template.ItemInfo.SkillInfo.Text = ItemInfo[Value].Info
					Template.ItemInfo.SkillName.Text = Value
					SkillBook.Holder[tostring(Name)].TreeName.Text = Table.TreeName
					Template.Parent = SkillBook.Holder[tostring(Name)].TreeSkills
				elseif Type == "TreeName" then
					SkillBook.Holder[tostring(Name)].TreeName.Text = Value
				end
			end
		end
		
		--	local Format = {ItemName, Slot, Enum.HolderType.Skill}
		for UIName, Data in next, self.Data.UIPositions do
			Display[UIName].Position = UDim2.new(Data[1], Data[2], Data[3], Data[4])	
		end
		
		for _, Item in next, self.Data.Inventory do
		
			
			if Item[4] ~= Enum.HolderType.Gear and Item[4] ~= Enum.HolderType.Loot then
				local Clone = script.ItemTemplate:Clone()
				Clone.Image = Images[Item[1]]
				Clone.ItemName.Value = Item[1]
				Clone.Parent = Inv[tostring(Item[2])]
				Clone.Amount.Text = Item[3]
--				print(	self.Data.RealInventory[Item[1]],  tonumber(Item[3]) )
				if 	self.Data.RealInventory[Item[1]] then
					self.Data.RealInventory[Item[1]] += tonumber(Item[3])
				else
					self.Data.RealInventory[Item[1]] =  tonumber(Item[3])
				end
				
			elseif Item[4] == Enum.HolderType.Gear then
				
				local Clone = script.GearTemplate:Clone()
				
				Clone.Image = Images[Item[1]]
				Clone.ItemName.Value = Item[1]
				Clone.Parent = Inv[tostring(Item[2])]
				
--				print(Item[1])
				end
		end
		
		for Slot, Item in next, self.Data.Equipped do
			if Item and string.len(Item) > 1 then
				print(Item,Slot)
				local Clone = script.GearTemplate:Clone()
				Clone.Image = Images[Item]
				Clone.ItemName.Value = Item
				for _, Frame in next, GearFrame:GetDescendants() do
					if Frame.Name == tostring(Slot) then
						Clone.Parent = Frame
					end
				end
			end
		end
		
		for _, Skill in next, self.Data.ToolBar  do 
			if Skill[3] == Enum.HolderType.Skill then
				local Clone = script.SkillTemplate:Clone()
				Clone.Image = Images[Skill[1]]
				Clone.SkillName.Value = Skill[1]
				Clone.Parent = ToolBar.Skills[tostring(Skill[2])].SkillSlot
				
			elseif Skill[3] == Enum.HolderType.Consumable then
			--	print(Skill)
				local Clone = script.ItemTemplate:Clone()
				Clone.Image = Images[Skill[1]]
				Clone.ItemName.Value = Skill[1]
				Clone.Parent = ToolBar.Consumables[tostring(Skill[2])].Potion
				Clone.Amount.Text = tostring(	self.Data.RealInventory[Skill[1]] or "") -- here we get the total amount for display
			end
		end
	end
--	print(self.Data.ToolBar)
--	print(	self.Data.RealInventory )
end

function UIManager:RemoveSlot(SlotToRemove)
	print(SlotToRemove)
	for Index, Item in next, self.Data.ToolBar do
		if Index == SlotToRemove then
			self.Data.ToolBar[tostring(Index)] = nil
		end
	end
end

function UIManager:MergeItem(Item, Slot, DragFromSlot)
	print(Item, Slot, DragFromSlot)
	if Item and Slot and DragFromSlot then
		print("Ran")
		local SlotData = self.Data.Inventory
		
		local PlayerGui = self.Player.PlayerGui
		local Display = PlayerGui.Display
		local Inv = Display.Inventory.Holder
		local GearFrame = Display.GearFrame
		print(SlotData[DragFromSlot.Name] [4])
		
		if SlotData[DragFromSlot.Name] and SlotData[Slot.Name] and Inv[Slot.Name] then
			local Image = Slot:FindFirstChildWhichIsA("ImageLabel")
			if SlotData[DragFromSlot.Name][1] == SlotData[Slot.Name][1] and Image and Item.Name == "ItemTemplate" then
				SlotData[Slot.Name][3] += SlotData[DragFromSlot.Name][3]
				Image.Amount.Text = SlotData[Slot.Name][3] 
				SlotData[DragFromSlot.Name] = nil
				Item:Destroy()
			elseif Item.Name == "ItemTemplate" then
				Item:Destroy()
				local Template = script.ItemTemplate:Clone()
				Template.Amount.Text = tostring(SlotData[DragFromSlot.Name][3])		
				Template.ItemName.Value = SlotData[DragFromSlot.Name][1]
				Template.Image = Images[SlotData[DragFromSlot.Name][1]]
				Template.Parent = DragFromSlot
			elseif Item.Name == "GearTemplate" then
				Item:Destroy()
				local Template = script.GearTemplate:Clone()
				Template.ItemName.Value = SlotData[DragFromSlot.Name][1]
				Template.Image = Images[SlotData[DragFromSlot.Name][1]]
				Template.Parent = DragFromSlot
			end
		end
	end
end

function FindFirstOpenSlot(self)
	
	local PlayerGui = self.Player.PlayerGui
	local Display = PlayerGui.Display
	local Inv = Display.Inventory.Holder
	local GearFrame = Display.GearFrame
	
	for _, Slot in next, Inv:GetChildren() do
		if Slot:IsA("Frame") or Slot:IsA("ImageLabel") then
			if #Slot:GetChildren() <= 1 then
				return Slot
			end
		end
	end
	
end

function UIManager:AddInvItem(Data)
	
	local Parent = FindFirstOpenSlot(self)
	print(Data)
	if Data[3] == Enum.HolderType.Loot then
		
		local TemplateClone = script.ItemTemplate:Clone()
		TemplateClone.ItemName.Value = Data[1]
		TemplateClone.Image = Images[Data[1]]
		TemplateClone.Amount.Text = Data[2]
		TemplateClone.Parent = Parent
		local Template = {Data[1], tonumber(Parent.Name), Data[2], Data[3]}
		self.Data.Inventory[tostring(Parent.Name)] = Template
		
	elseif Data[3] == Enum.HolderType.Gear then
		
		local TemplateClone = script.GearTemplate:Clone()
		TemplateClone.ItemName.Value = Data[1]
		TemplateClone.Image = Images[Data[1]]
		TemplateClone.Parent = Parent
		local Template = {Data[1], tonumber(Parent.Name), Data[2], Data[3]}
		self.Data.Inventory[tostring(Parent.Name)] = Template
		
	elseif Data[3] == Enum.HolderType.Consumable then
		local TemplateClone = script.ItemTemplate:Clone()
		TemplateClone.ItemName.Value = Data[1]
		TemplateClone.Image = Images[Data[1]]
		TemplateClone.Amount.Text = Data[2]
		TemplateClone.Parent = Parent
		local Template = {Data[1], tonumber(Parent.Name), Data[2], Data[3]}
		self.Data.Inventory[tostring(Parent.Name)] = Template
		
	end
	
end

function UIManager:UpdateInvItem(PlaceSlot, ItemName, DraggingSlot, CurrentSlot, DragFromFrame)
	
	local PlayerGui = self.Player.PlayerGui
	local Display = PlayerGui.Display
	local Inv = Display.Inventory.Holder
	local GearFrame = Display.GearFrame
	
--	print(PlaceSlot, ItemName, DraggingSlot, CurrentSlot)
	
	if PlaceSlot and ItemName and 	self.Data.Inventory[tostring(DraggingSlot)]  then
		local Template = {ItemName, PlaceSlot, 	self.Data.Inventory[tostring(DraggingSlot)][3],  self.Data.Inventory[tostring(DraggingSlot)][4]}
		CurrentSlot:Destroy()
		print(CurrentSlot)
		print(self.Data.Inventory[tostring(DraggingSlot)], DraggingSlot)
		if 	self.Data.Inventory[tostring(DraggingSlot)][4] == Enum.HolderType.Consumable then
			
			local TemplateClone = script.ItemTemplate:Clone()
			TemplateClone.Parent = Inv[PlaceSlot]
			TemplateClone.ItemName.Value = ItemName
			TemplateClone.Image = Images[ItemName]
			TemplateClone.Amount.Text = Template[3]
			
		elseif  	self.Data.Inventory[tostring(DraggingSlot)][4] == Enum.HolderType.Gear then
			
			local TemplateClone = script.GearTemplate:Clone()
			TemplateClone.Parent = Inv[PlaceSlot]
			TemplateClone.ItemName.Value = ItemName
			TemplateClone.Image = Images[ItemName]
			
		elseif  	self.Data.Inventory[tostring(DraggingSlot)][4] == Enum.HolderType.Loot then
			
			local TemplateClone = script.ItemTemplate:Clone()
			TemplateClone.Parent = Inv[PlaceSlot]
			TemplateClone.ItemName.Value = ItemName
			TemplateClone.Image = Images[ItemName]
			TemplateClone.Amount.Text = Template[3]
			
			
			
		end
		
		self.Data.Inventory[tostring(PlaceSlot)] = Template
		self.Data.Inventory[tostring(DraggingSlot)] = nil
		
		print(	self.Data.Inventory)
	elseif CurrentSlot and DraggingSlot and DragFromFrame and PlaceSlot then
		if GearFrame:FindFirstChild(DragFromFrame.Name) then
			local Template = {ItemName, PlaceSlot, 1,  Enum.HolderType.Gear}
			CurrentSlot:Destroy()
--			print("From GearFrame") 
			local TemplateClone = script.GearTemplate:Clone()
			TemplateClone.Parent = Inv[PlaceSlot]
			TemplateClone.ItemName.Value = ItemName
			TemplateClone.Image = Images[ItemName]
--			print(Template)
			self.Data.Inventory[tostring(PlaceSlot)] = Template
			--self.Data.Equipped[DraggingSlot] = ""
		else
			print("error")
		end
	else
		print("error")
	end
	
end

function UIManager:UpdateKeyBinds(Slot, KeyCode)
	if not Slot or not KeyCode then
		return KeyCode
	else
		self.Data.KeyBinds[Slot] = KeyCode.Value
	end
end

function UIManager:RequestKeyBinds()
	return self.Data.KeyBinds
end

function CheckToolBar(self, Data, Type)
	for Index, Slot in next, self.Data.ToolBar do
		print(Data, Slot)
		if Slot[1] == Data[1] and Data[2] ~= Slot[2] then
			self.Data.ToolBar[Index] = nil
			game.ReplicatedStorage.Remotes.Server.UpdateToolBar:FireClient(self.Player, Type, {Slot[1], Slot[2]})
		end
	end
end

function UIManager:UpdateSkillBar(Slot, ItemName)
	local Format = {ItemName, Slot, Enum.HolderType.Skill}
	print('Ran', self.Data.ToolBar)
	if not self.Data.ToolBar[Slot] then
		CheckToolBar(self, {ItemName, Slot}, "RemoveSkill")
		self.Data.ToolBar[tostring(Slot)] = Format
		return true
	else
		return false
	end
end

function UIManager:UpdateConsumableBar(Slot, ItemName, DragSlot, CurrentSlot)
	
	local Format = {ItemName, Slot, Enum.HolderType.Consumable, DragSlot}
	
	if not self.Data.ToolBar[Slot] then
		
		local PlayerGui = self.Player.PlayerGui
		local Display = PlayerGui.Display
		local ToolBar = Display.ToolBar.Holder.Consumables
		local Inv = Display.Inventory.Holder

		CurrentSlot:Destroy()
		
		if  self.Data.Inventory[tostring(DragSlot)] and self.Data.Inventory[tostring(DragSlot)][4] ~= Enum.HolderType.Consumable then
			local InvClone = script.GearTemplate:Clone() -- this one for inv
			InvClone.Parent = Inv[tostring(DragSlot)]
			InvClone.Image = Images[ItemName]
			InvClone.ItemName.Value = ItemName
			return
		end
		
		local InvClone = script.ItemTemplate:Clone() -- this one for inv
		local Template = script.ItemTemplate:Clone()
		
		
		if Inv:FindFirstChild(tostring(DragSlot)) then
			InvClone.Parent = Inv[tostring(DragSlot)]
			InvClone.Image = Images[ItemName]
			InvClone.ItemName.Value = ItemName
			InvClone.Amount.Text = self.Data.Inventory[tostring(DragSlot)][3]
		else
			InvClone:Destroy()
		end
		
		print(Slot)
		Template.Image = Images[ItemName]
		Template.Parent = ToolBar[tostring(Slot)].Potion
		Template.ItemName.Value = ItemName
		Template.Amount.Text = self.Data.RealInventory[ItemName]
		
		--CheckToolBar(self, ItemName, "RemovePotion")
		if DragSlot then
			self.Data.ToolBar[tostring(DragSlot)] = nil 
		end
		self.Data.ToolBar[tostring(Slot)] = Format
		return true
	else
		return false
	end
end

local ItemManager = require(game.ServerStorage.Framework.Modules.ItemManager)

function UIManager:UIEquipItem(Slot, HolderName ,ItemName, DragSlot, CurrentItem)
	print(Slot, HolderName ,ItemName, DragSlot, CurrentItem)
	if Slot and ItemName and CurrentItem then
		
		if self.Data.Inventory[tostring(DragSlot)]  then
			self.Data.Inventory[tostring(DragSlot)]  = nil
		end
		
		local PlayerGui = self.Player.PlayerGui
		local Display = PlayerGui.Display
		local ToolBar = Display.ToolBar.Holder.Consumables
		local Inv = Display.Inventory.Holder
		local GearFrame = Display.GearFrame
		
		if type(ItemManager[ItemName].Slot) ~= 'table' and ItemManager[ItemName].Slot == Slot  then
--			print("Ran 1")
			CurrentItem:Destroy()
			local GearTemplate = script.GearTemplate:Clone()
			GearTemplate.ItemName.Value = ItemName
			GearTemplate.Image = Images[ItemName]
			self.Data.Equipped[Slot] = ItemName
			local Done = self:EquipItem(ItemName, Slot)
			if Done then
				GearTemplate.Parent = GearFrame[HolderName][tostring(Slot)]
			else
				GearTemplate.Parent = Inv[tostring(DragSlot)]
			end
		elseif type(ItemManager[ItemName].Slot) == 'table' then
			local CanPlace = false
			
			for _, PlaceSlot in next, ItemManager[ItemName].Slot do
				if Slot == PlaceSlot then
					CurrentItem:Destroy()
					local GearTemplate = script.GearTemplate:Clone()
					GearTemplate.ItemName.Value = ItemName
					GearTemplate.Image = Images[ItemName]
					GearTemplate.Parent = GearFrame[HolderName][tostring(Slot)]
					self.Data.Equipped[Slot] = ItemName
					self:EquipItem(ItemName, Slot)
					break
				end
			end
			
			
		elseif DragSlot then
			print("Ran 2")
			CurrentItem:Destroy()
			local GearTemplate = script.GearTemplate:Clone()
			GearTemplate.ItemName.Value = ItemName
			GearTemplate.Image = Images[ItemName]
			GearTemplate.Parent = DragSlot
			self.Data.Equipped[Slot] = ItemName
		else
			print("Hella error")
		end
		
	end
end

function UIManager:UIUnequipItem(Slot, HolderName ,ItemName, DragSlot, CurrentItem)
	if Slot and HolderName and ItemName and CurrentItem then

		local PlayerGui = self.Player.PlayerGui
		local Display = PlayerGui.Display
		local ToolBar = Display.ToolBar.Holder.Consumables
		local Inv = Display.Inventory.Holder
		local GearFrame = Display.GearFrame
		print("RAn ", Slot, HolderName ,ItemName, DragSlot, CurrentItem)
		self:UnEquip(DragSlot.Name)
		
		CurrentItem:Destroy()
	end
end


function UIManager:UpdateUILocation(UI, Position)
	if UI and Position then
		self.Data.UIPositions[UI.Name] =  {Position.X.Scale, Position.X.Offset, Position.Y.Scale,Position.Y.Offset}
	end
end


return UIManager
