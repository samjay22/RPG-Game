shared.Modifiers = {
	MaxLevel = 60;
	Damage = 1;
	Skill = 1;
	Buffs = .5;
	Effects = 1;
	Traits = 1;
}

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)
local CharacterInit = require(game.ServerStorage.Framework.Player.Character)
require(game.ServerStorage.Framework.Modules.Calc)

--local SlotManager = require(game.ServerStorage.Framework.Modules.SlotManager)

local PossibleStores = {"Slot1", "Slot2", "Slot3", "Slot4", "Slot500", "Slot501", "Slot502"}

shared.Characters = {}
shared.Players = {}

game.ReplicatedStorage.Remotes.Server.DataRequest.OnServerInvoke = function(Player, Type, Data)
	if Type == "SlotLoad" then
		local ReturnTable = {}
		for _, Slot in next, PossibleStores do
			ReturnTable[Slot] = 	shared.Characters[Player]:RequestSlotData(Slot)
		end
		return ReturnTable
	end
end

--game:BindToClose(function()
--	for Index, P in  next, shared.Characters do
--		P:PushSaveSlot()
--	end
--	wait(10)
--end)

game.ReplicatedStorage.Remotes.Server.LoadSlot.OnServerInvoke = function(Player)
	local Slot, Class = "Slot501", "Brawler"
	if not table.find(PossibleStores, Slot) then return Player:Kick() end
	shared.Characters[Player] = CharacterInit.New(Player, Slot)
	shared.Characters[Player]:CheckSlotData(Slot)
	if shared.Characters[Player] then
		shared.Characters[Player] :RequestSlotData(Slot, Class)
		LoadChar(Player)
		local Data = shared.Characters[Player].Data
		shared.Characters[Player]:FirstLoad()
		return {Data.LevelInfo, Data.ActiveClass, Data.CharacterStats, Data.Traits}
	else
		warn("Error")
	end
	game.ReplicatedStorage.Remotes.Server.LoadSlot:Destroy()
	return false
end

function LoadChar(Player)
	if not shared.Characters[Player] then return end
	repeat wait() until Player.Character or Player.CharacterAdded:Wait()
	shared.Characters[Player] :LoadCharacter()
	coroutine.wrap(function()
		while shared.Characters[Player].Alive do
			game["Run Service"].Stepped:Wait()
			shared.Characters[Player]:UpdateStatus()
		end
	end)()
	
	for _ = 0,3 do
		shared.Characters[Player]:ActivateEffect("Health")
	end
--	shared.Characters[Player]:RemoveEffect(Enum.EffectType.Buff)
end
game.Players.PlayerRemoving:Connect(function(Player)
	--SlotManager.PushSaveSlot(Player)
end)

game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Char)
		LoadChar(Player)
		Char.Humanoid.Died:Connect(function()
			shared.Characters[Player]:RemoveEffect(nil, true)
		end)
	end)
end)

game.ReplicatedStorage.Remotes.Client.DataUpdate.OnServerInvoke = function(Player, Type, Data)
	if not  shared.Characters[Player] then return end
	if Type == "KeyBinds" then
		return shared.Characters[Player]:RequestKeyBinds()
	elseif Type == "KeyBindUpdate" then
		return shared.Characters[Player]:UpdateKeyBinds(Data[1], Data[2]) 
	elseif Type == "AddSkillToToolBar" then
		return shared.Characters[Player]:UpdateSkillBar(Data[1], Data[2], Data[3], Data[4])
	elseif Type == "AddPotionToToolBar" then
		return shared.Characters[Player]:UpdateConsumableBar(Data[1], Data[2], Data[3], Data[4])
	elseif Type == "UpdateItemInInventory" then
		return shared.Characters[Player]:UpdateInvItem(Data[1], Data[2], Data[3], Data[4], Data[5])
	elseif Type == 'PotionSlot' or Type == 'SkillSlot' then
		return shared.Characters[Player]:RemoveSlot(Data)
	elseif Type == 'SkillSlot' then
		return shared.Characters[Player]:RemoveSlot(Data)
	elseif Type == 'UIPositionUpdate' then
		return shared.Characters[Player]:UpdateUILocation(Data[1], Data[2])
	elseif Type == 'EquipItemInGearSlot' then
		return shared.Characters[Player]:UIEquipItem(Data[1], Data[2], Data[3], Data[4], Data[5])	
	elseif Type == 'UnequipItemInInventory' then
		return shared.Characters[Player]:UIUnequipItem(Data[1], Data[2], Data[3], Data[4], Data[5])	
	elseif Type == "MergeInvItem" then
		return shared.Characters[Player]:MergeItem(Data[1], Data[2], Data[3])	
	end
end

game.ReplicatedStorage.Remotes.Client.UseConsumable.OnServerEvent:Connect(function(Player, Data)
	shared.Characters[Player]:UseConsumable(Data)
end)

game.ReplicatedStorage.Remotes.Client.LootUpdate.OnServerEvent:Connect(function(Player, Type)
		shared.Characters[Player]:LootAction(Type)
end)