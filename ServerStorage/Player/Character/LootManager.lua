local LootManager = {}

local LootDirec = require(game.ServerStorage.Framework.Modules.LootDirectory)
Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

local Deb = {}

function MakeTemplate(self, CurrentDrop, Amount, LootFrame, Table)
	local Template = script.LootItem:Clone()

	Template.Holder.ItemInfo.ItemName.Text = CurrentDrop
	Template.Holder.ItemName.Value = CurrentDrop
	Template.Holder.ItemFrame.Amount.Text =  Amount
	Template.Parent = LootFrame
	
	Template.Holder.ItemInfo.MouseButton1Click:Connect(function()
		print(Deb[self.Player]  == {Template, Amount, CurrentDrop} )
		if Deb[self.Player] and Deb[self.Player][1]  == Template then
			
			Deb[self.Player][1].Transparency = 1
			Deb[self.Player] = nil
			
		elseif Deb[self.Player]  and Deb[self.Player][1]  ~= Template  then
			
			Deb[self.Player][1] .Transparency = 1
			Deb[self.Player]  =  {Template, Amount, CurrentDrop, Table} 
			Deb[self.Player][1] .Transparency = 0
			
		elseif not 	Deb[self.Player]  then
			
			Deb[self.Player]  =  {Template, Amount, CurrentDrop, Table} 
			Deb[self.Player][1] .Transparency = 0
			
		end
	end)
	
end

function InsertTable(self, CurrentDrop, Amount, EnumType, LootFrame)
	local Template = {CurrentDrop, Amount, EnumType}
	table.insert(self.Data.Loot, Template)
	MakeTemplate(self, CurrentDrop, Amount, LootFrame, Template)
end

function LootManager:GiveLoot(Drops)
	if #self.Data.Loot >= 25 then return warn("Inv full") end
	
	local PlayerGui = self.Player.PlayerGui
	local Display = PlayerGui.Display
	local LootFrame = Display.LootFrame.Loot
	
	local DropChance = math.random()
	
	local CurrentDrop, Amount, EnumType = nil, nil, nil
	
	for Index, DropData in next, Drops do
		if DropData.Chance >= DropChance then
			CurrentDrop = DropData.ItemName
			EnumType = DropData.EnumType
			Amount = math.random(DropData.MinAmount, DropData.MaxAmount)
		end
	end
	
	local FoundItem = false
	
	for Index, Items in next, self.Data.Loot do
		if Items[1] == CurrentDrop and Items[2] < LootDirec[CurrentDrop].StackSize then
			for Index, Item in next, LootFrame:GetChildren() do
				--print(Item)
				local StringValue = Item:IsA("Frame") and Item.Holder:FindFirstChildWhichIsA("StringValue") 
				if StringValue and StringValue.Value == CurrentDrop and not FoundItem then
					FoundItem = true
				--	print("X")
					Items[2] += Amount
					Item.Holder.ItemFrame.Amount.Text = tostring(	Items[2])
					--print("Print changed hsit", Item.Holder.ItemFrame.Amount.Text)
					end
			end
			
		elseif Items[1] == CurrentDrop and	Items[2] + Amount >=  LootDirec[CurrentDrop].StackSize then
			
			local Difference = 	math.abs((Items[2] + Amount) -  LootDirec[CurrentDrop].StackSize)
			local NewAmount = math.abs(Amount - Difference)
			local Template = {CurrentDrop, Amount, EnumType}
			
			for Index, Item in next, LootFrame:GetChildren() do
				local StringValue = Item:FindFirstChildWhichIsA("StringValue") 
				if StringValue and StringValue.Value == CurrentDrop  and tonumber(Item.ItemFrame.Amount.Text) == Item[2] then
					Items[2] += NewAmount
					Item.ItemFrame.Amount.Text = tostring(Items[2])
					FoundItem = true
					break
				end
				print(Item)
			end
			table.insert(self.Data.Loot, Template)
			
			MakeTemplate(self, CurrentDrop, Amount, LootFrame,Template)
			FoundItem = true
			break
		end
	end
	
	if #self.Data.Loot <= 0 then
		InsertTable(self, CurrentDrop, Amount, EnumType, LootFrame)
	elseif  CurrentDrop and not FoundItem then
		InsertTable(self, CurrentDrop, Amount, EnumType, LootFrame)
	end
	
	LootFrame.Parent.LootInfo.Holder.LootAmount.Text = tostring(#self.Data.Loot ) .. "/" .. tostring(25)
end

function ClearIndex(self, Table)
	for Index, Value in next, self.Data.Loot do
		if Value == Table then
			self.Data.Loot [Index] = nil
		end
	end
end

function ClearDeb(self)
	Deb[self.Player][1]:Destroy()
	ClearIndex(self, Deb[self.Player][4])
	Deb[self.Player] = nil
end

function LootManager:LootAction(Type)--Action loot, deals with destroying, claiming loot.
	
	local PlayerGui = self.Player.PlayerGui
	local Display = PlayerGui.Display
	local LootFrame = Display.LootFrame.Loot
	
	if Deb[self.Player] then
		
		if Type == 'Claim' then
			
			local RealInv = self.Data.RealInventory

			if RealInv[Deb[self.Player][3]] then
				RealInv[Deb[self.Player][3]]  += Deb[self.Player][4][2]
			else
				RealInv[Deb[self.Player][3]]  =  Deb[self.Player][4][2]
			end
			
			self:AddInvItem(Deb[self.Player][4])
			
			ClearDeb(self)
		elseif Type == 'Destroy' then
			ClearDeb(self)
		end
	end
	LootFrame.Parent.LootInfo.Holder.LootAmount.Text = tostring(#self.Data.Loot ) .. "/" .. tostring(25)
	
end

return LootManager
