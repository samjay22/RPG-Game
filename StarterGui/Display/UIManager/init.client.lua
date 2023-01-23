local GUI = script.Parent

local SkillRemote = game.ReplicatedStorage.Remotes.Client.UseSkill

local StatusEffectsManager = require(game.ReplicatedStorage.Modules.StatusEffectsManager)
local DragManager = require(script.DragManager)
local UpdateManager = require(script.UpdateManager)

Enum = require(game.ReplicatedStorage.Modules.Enum_Loader)

local TS = game:GetService("TweenService")
local CAS = game:GetService("ContextActionService")
local CS = game:GetService("CollectionService")
local UIS = game:GetService("UserInputService")

local Player = game.Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local CharacterStats = GUI.CharacterStats
local ToolBar = GUI.ToolBar
local Inventory = GUI.Inventory
local LootFrame = GUI.LootFrame

local Player = game.Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Mouse = Player:GetMouse()

game.ReplicatedStorage.Remotes.Client.EffectsUpdate.OnClientEvent:Connect(function(EffectName, Key, Image, Remove)
	if not Remove then
		StatusEffectsManager.NewEffect(Key, Image)
	else
		StatusEffectsManager.RemoveEffect(Key)
	end
end)

function KeyPress(KeyCode)
	if not KeyCode then return end
	local KeyBinds = game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer("KeyBinds")
	local ToolBar = UpdateManager.RefreshToolBar()
	for _, Skill in next, ToolBar do
		if KeyBinds[Skill[2]] == KeyCode.Value and Skill[3] == "Skill" then
			print(ToolBar)
			print("Ran on cleint")
			game.ReplicatedStorage.Remotes.Client.UseSkill:FireServer(Skill[1], Skill[2], _G.SelectedTarget)
		elseif KeyBinds[Skill[2]] == KeyCode.Value and Skill[3] == "Potion" then
			game.ReplicatedStorage.Remotes.Client.UseConsumable:FireServer(Skill[1], Skill[2])
		end
	end
end

UIS.InputBegan:Connect(function(Input)
	
	local Type = Input.UserInputType
	local KeyCode = Input.KeyCode
	
	if Type == Enum.UserInputType.MouseButton1 then
		DragManager.Update(true)
	elseif KeyCode ~= Enum.KeyCode.Unknown then
		KeyPress(KeyCode)
	end
	
end)
UIS.InputEnded:Connect(function(Input)
	local Type = Input.UserInputType
	if Type == Enum.UserInputType.MouseButton1 then
		DragManager.Update(false)
	end
end)
--game["Run Service"].Stepped
--game["Run Service"].Stepped:Connect(function()
--	DragManager.DragItem()
--end)

coroutine.wrap(function()
	while true do
		DragManager.DragItem()
		game["Run Service"].Stepped:Wait()
	end
end)()

function OpenFrame(Name, State)
	if State == Enum.UserInputState.Begin then
		if Name == 'CloseAllFrames' then
			for _, Frame in next, GUI:GetChildren() do
				Frame.Visible = false
			end
		else
			UpdateManager.OpenFrame(Name, State, GUI)
		end
	end
end


LootFrame.ClaimLoot.MouseButton1Down:Connect(function()
	game.ReplicatedStorage.Remotes.Client.LootUpdate:FireServer("Claim")
end)

LootFrame.DestroyLoot.MouseButton1Down:Connect(function()
	game.ReplicatedStorage.Remotes.Client.LootUpdate:FireServer("Destroy")
end)

game.ReplicatedStorage.Remotes.Client.DataEvent.OnClientEvent:Connect(function(Type, Data)
	UpdateManager.DataEvent(Type, Data, CharacterStats, ToolBar)
end)

game.ReplicatedStorage.Remotes.Server.SkillUpdate.OnClientEvent:Connect(function(SkillName, Data)
	UpdateManager.SkillUpdate(SkillName, Data, ToolBar)
end)


game.ReplicatedStorage.Remotes.Server.UpdateToolBar.OnClientEvent:Connect(function(Type, Data)
	if Type == "RemoveSkill" then
		local ItemName = Data[1]
		local Slot = Data[2]
		
		for _, Slots in next, CS:GetTagged("Draggable") do
			local ItemNameValue = Slots:FindFirstChildWhichIsA("StringValue")
			if ItemNameValue and ItemNameValue.Value == ItemName and Slots:FindFirstAncestor("ToolBar") and Slots:FindFirstAncestor(tostring(Slot)) then
				if Slots then
					Slots:Destroy()
				end
			end
		end
	end
end)

game.ReplicatedStorage.Remotes.Client.UIUpdate.OnClientEvent:Connect(function(Type, Data)
	if Type == "Consumable" then
		local Name = Data[1]
		local Value = Data[2]
	end
end)

game.ReplicatedStorage.Remotes.Server.VisualUpdate.OnClientEvent:Connect(function(Message)
	local Clone = script.Message:Clone()
	Clone.Text = Message
	Clone.Parent = GUI.MessageList
	game.Debris:AddItem(Clone, 1)
end)

CAS:BindAction("Inventory", OpenFrame, false, Enum.KeyCode.E)
CAS:BindAction("GearFrame", OpenFrame, false, Enum.KeyCode.C)
CAS:BindAction("LootFrame", OpenFrame, false, Enum.KeyCode.L)
CAS:BindAction("SkillBook", OpenFrame, false, Enum.KeyCode.K)
CAS:BindAction("CloseAllFrames", OpenFrame, false, Enum.KeyCode.Escape)
