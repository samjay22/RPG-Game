local SlotManager = {}
local DS = game:GetService("DataStoreService")
local PlayerSlots = {}

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)
local HTTP =  game:GetService("HttpService")

function SlotManager:CheckSlotData(Slot)
	local Store = DS:GetDataStore(Slot)
	local Data = Store:GetAsync(self.Player.UserId)
	print(Data)
	if not Data then
		return false
	else
		return true
	end
end

function SlotManager:RequestSlotData(Slot, ActiveClass)
	--local HasData = self:CheckSlotData(Slot)
	print("Ran")
	local Store = DS:GetDataStore(Slot)
	local Data = Store:GetAsync(self.Player.UserId)
	self.SlotName = Slot
	if Data then
		self.Data = Data
	else
		print(ActiveClass)
		self.Data = self:PushNewSlot(Slot, ActiveClass)
	end
end


--function SlotManager.PushLoadSlot(Player, Slot)
--	local Store = DS:GetDataStore(Slot)
--	local Data = Store:GetAsync(Player.UserId)
--	PlayerSlots[Player] = {Data, Slot}
--	return Data
--end

--[[
	Primary = 1;
	Secondary = 2;
	Special = 3;
	Helm = 4;
	Shoulders = 5;
	Chest = 6;
	Pants = 7;
	Boots = 8;
	Neck = 9;
	Cape = 10;
	Wrists = 11;
	Hands = 12;
	Tome = 13;
]]


function SlotManager:PushNewSlot(Slot, ActiveClass)
	local Player = self.Player
	local ActiveClass = ActiveClass
	local Template =  {
		
		Equipped = { -- this goes in the gearframe and is also manged in equpment manager
			[1] = "Axe";
			[2] = "";
			[3] = "";
			[4] = "";--"Bronze_Helm";
			[5] = "";
			[6] = ""; --"Bronze_Chest";
			[7] = "";--"Bronze_Legs";
			[8] = "";
			[9] = "";
			[10] = "";
			[11] = "";
			[12] = "";
			[13] = "";
		};
		
		ToolBar = {
			--["1"] = {"Vicious Swipe", 1, Enum.HolderType.Skill}; -- SkillName, Slot, HolderType
			--["2"] = {"Parry", 2, Enum.HolderType.Skill};
			--["3"] = {"Defensive Strike", 3, Enum.HolderType.Skill};
			--["4"] = {"Piercing Strike", 4, Enum.HolderType.Skill};
			--["9"] = {"HealthPotion_1", 9, Enum.HolderType.Consumable}
			--{"HealthPotion_1", 10,Enum.HolderType.Consumable, 20} -- ItemName, Slot, HolderType, TotalAmount
		};
		
		Loot = {
	--	{"Sword", 1, Enum.HolderType.Gear} -- Name, Amount, ItemType;
		}; --- All player loot
		
		UIPositions = { -- we save the UI positions that played made
			
		};
		
		KeyBinds = {
			[1] = Enum.KeyCode.One.Value;
			[2] = Enum.KeyCode.Two.Value;
			[3] = Enum.KeyCode.Three.Value;
			[4] = Enum.KeyCode.Four.Value;
			[5] = Enum.KeyCode.Five.Value;
			[6] = Enum.KeyCode.Six.Value;
			[7] = Enum.KeyCode.Seven.Value;
			[8] = Enum.KeyCode.Eight.Value;
			[9] = Enum.KeyCode.Nine.Value;
			[10] = Enum.KeyCode.Zero.Value;
			[11] = Enum.KeyCode.Minus.Value;
			[12] = Enum.KeyCode.Equals.Value;
		}; -- keybinds for toolbar
		
		Inventory = { -- actual player inventory Holds up to 50 times, and some things can stack
			["0.2"] = {"HealthPotion_1", 0.2, 1, Enum.HolderType.Consumable};
			["0.3"] = {"ManaPotion_1", 0.3, 25, Enum.HolderType.Consumable};
			["0.4"] = {"HealthPotion_1", 0.4, 1, Enum.HolderType.Consumable};
			["0.5"] = {"Bronze_Chest", 0.5, 1, Enum.HolderType.Gear};
		};
		
		Curreny = {
			Gold = 500;
		};
		
		LevelInfo = {
			CurrentXP = 0;
			TotalXP = 0;
			Level = 5;
			SkillPoints = 0;
		};
		
		ActiveClass = nil;
		
		RealInventory = {
			["Bronze_Chest"] = 1;
			
		};
		
		Traits = {
			Vitality = 2;
			Might = 2;
			Will = 0;
			Fate = 0;
			Agility = 50;
		};
		
	}
	Template.ActiveClass = require(game.ServerStorage.Framework.PlayerClasses[ActiveClass])
	
	return Template
end

function SlotManager:PushSaveSlot()
	--	if true then return end
	local Player = self.Player
	if Player then
		print("Saving")
		local Data = self.Data
		print(PlayerSlots[Player] )
		local Store = DS:GetDataStore(self.SlotName)
		Store:UpdateAsync(Player.UserId, function(OldData)
			print("Saved")
			print(Data)
			if Data then return Data end -- HTTP:JSONEncode(Data)
		end)
	end
end
 

return SlotManager
