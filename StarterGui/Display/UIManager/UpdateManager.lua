local Manager = {}

local OpenUIs = {}
local CS = game:GetService("CollectionService")
local UIS = game:GetService("UserInputService")

function Manager.OpenFrame(Name, State, GUI)
	if State == Enum.UserInputState.Begin then
		local Frame = GUI:FindFirstChild(Name) 
		if Frame then
			if OpenUIs[Frame] == Frame then
				OpenUIs[Frame].Visible = false
				OpenUIs[Frame] = nil
			elseif not OpenUIs[Frame] then
				OpenUIs[Frame] = Frame
				Frame.Visible = true
			end
		end
	end
end

function Manager.DataEvent(Type, Data, CharacterStats, ToolBar)
	if Type == "Level" then
		local LevelBar = ToolBar.XPBar
		local Needed = Data[1]
		local Current = Data[2]
		local Level = Data[3]
		CharacterStats.LevelInfo.Text = Level
		CharacterStats.PlayerName.Text = game.Players.LocalPlayer.Name
		local Size = Current/Needed > 0 and Current/Needed or 0
		LevelBar.Bar.Size = UDim2.fromScale(Size, 1)
		LevelBar.XP.Text = tostring(Current).."/"..tostring(Needed)
	elseif Type ==  "CharacterStats" then

		local MaxHealth = Data.MaxHealth > 0 and  Data.MaxHealth or 0
		local MaxMana = Data.MaxMana > 0 and Data.MaxMana or 0
		--	print(MaxMana)
		--local MaxArmour = Data.MaxArmour

		local CurrentHealth = Data.CurrentHealth > 0 and Data.CurrentHealth  or 0
		local CurrentMana = Data.CurrentMana > 0 and Data.CurrentMana or 0
		--local CurrentArmour = Data.CurrentArmour
		--print(CurrentHealth)
		local HealthSize = CurrentHealth/MaxHealth > .01 and CurrentHealth/MaxHealth  or .01
		local ManaSize = CurrentMana/MaxMana > .01  and CurrentMana/MaxMana or .01
		ManaSize = CurrentMana/MaxMana <= 1 and CurrentMana/MaxMana or 1
		HealthSize = CurrentHealth/MaxHealth <= 1 and CurrentHealth/MaxHealth  or 1

		if ManaSize > 1 then 
			ManaSize = 1
		elseif HealthSize > 1 then
			HealthSize = 1
		end
		--	local ArmourSize
		--	print(HealthSize,ManaSize)
		CharacterStats.Health.Bar.Size = UDim2.fromScale(HealthSize,1)
		CharacterStats.Mana.Bar.Size = UDim2.fromScale(ManaSize,1)

		CharacterStats.Mana.ManaValue.Text = tostring(math.ceil(CurrentMana)).."/"..tostring(MaxMana)
		CharacterStats.Health.HealthValue.Text = tostring(math.ceil(CurrentHealth)).."/"..tostring(MaxHealth)
	end
end


function Manager.SkillUpdate(SkillName, Data, ToolBar)
	if not SkillName or not Data or not ToolBar then return end
	local CooldownTime = Data[1] 
	local SkillSlot = Data[2]
	--local SkillBar = ToolBar.Holder.Skills[SkillSlot].SkillSlot:FindFirstChildWhichIsA("ImageLabel").Frame
	for _, SkillFrame in next, CS:GetTagged("Draggable") do
		if SkillFrame:FindFirstAncestor("Skills") or SkillFrame:FindFirstAncestor("SkillBook") then
			if SkillFrame:FindFirstAncestor(game.Players.LocalPlayer.Name) and SkillFrame.SkillName.Value == SkillName then
				coroutine.wrap(function()
					local SkillBar = SkillFrame.Frame
					SkillBar.Size = UDim2.fromScale(1,-1)
					SkillBar.Visible = true
					for Num = 0, CooldownTime, CooldownTime/(CooldownTime * 60) do
						SkillBar.Size = UDim2.fromScale(1,-1+(Num / CooldownTime))
						game["Run Service"].RenderStepped:Wait()
					end
					SkillBar.Visible = false
				end)()
			end
		end
	end
end

function Manager.FindSlotWithItem(Item)
	local Slots = {"1", "2", "3", "4","5", "6", "7", "8", "9", "10", "11", "12"}
	for _, Slot in next, Slots do
		local SlotFound = Item:FindFirstAncestor(Slot) 
		if SlotFound then
			return SlotFound
		end
	end
end

function Manager.UpdateKeyBind(Key, KeyCode)
	local Slot = Manager.FindSlotWithItem(Key)
	local ReturnCode = game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer("KeyBindUpdate", {Slot, KeyCode})
	Key.Text  = tostring(game:GetService("UserInputService"):GetStringForKeyCode(ReturnCode))
end

function Manager.RefreshToolBar()
	local Skills = {}
	for _, Skill in next, CS:GetTagged("Draggable") do
		local SkillName = Skill:FindFirstChildWhichIsA("StringValue") 
		if SkillName and Skill:FindFirstAncestor("PlayerGui") then
			if Skill.Parent.Name == "SkillSlot" then
				local Slot = Manager.FindSlotWithItem(Skill)
				table.insert(Skills, {SkillName.Value,tonumber( Slot.Name), "Skill"})
			elseif Skill.Parent.Name ==  'Potion' then
				local Slot = Manager.FindSlotWithItem(Skill)
				table.insert(Skills, {SkillName.Value,tonumber( Slot.Name), "Potion"})
			end
		end
	end
	return Skills
end


return Manager
