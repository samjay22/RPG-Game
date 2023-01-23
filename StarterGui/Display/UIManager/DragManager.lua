local DragManager = {}

local CurrentItem = nil
local CurrentSlot = nil
local DragSlot = nil;
local Dragging = false
local DragPlace = "None" -- This tells us where we are dragging from to make sure we place it in right place.
local OldZIndex = nil;
local DraggingType = nil;
local CopyItem = nil; -- we delete this if we place in the place where it came from in inv/

local CS = game:GetService("CollectionService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

local Player = game.Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Mouse = Player:GetMouse()

function DragManager.Update(Status)
	Dragging = Status
end

function Reset()
	CurrentItem = nil
	CurrentItem = nil
	DraggingType = nil
	DragSlot = nil;
	CopyItem = nil;
end

function Finish(Table)
	CurrentItem.ZIndex = OldZIndex
	local ItemName = CurrentItem:FindFirstChildWhichIsA("StringValue")
	if DragPlace == "ToolBar" or DragPlace == "SkillSlot" or DragPlace == "PotionSlot" or DragSlot == "GearSlot" then
		if #Table <= 1  and not DragSlot:FindFirstAncestor("Inventory")  and DragSlot and CurrentItem and not DragSlot:FindFirstAncestor("GearFrame") then
			local Slot =  CurrentSlot or DragSlot
			game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer(DragPlace,Slot.Parent.Name)
			CurrentItem:Destroy()
		elseif DragPlace == "SkillSlot" or DragPlace == "Inventory" and #Table <= 2  and DragSlot and not DragSlot:FindFirstAncestor("Inventory") and CurrentItem  and not DragSlot:FindFirstAncestor("GearFrame")  then
			local Slot =  CurrentSlot or DragSlot
			game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer(DragPlace,Slot.Parent.Name)
			CurrentItem:Destroy()
		else
			print('Ran')
			local Slot = CurrentSlot or DragSlot
			CurrentItem.Parent = Slot
		end
	elseif CS:HasTag(CurrentItem, "UI") then
		game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer("UIPositionUpdate", {CurrentItem, CurrentItem.Position})
	else -- if there was an error we just place in the slot
		CurrentItem.Parent = DragSlot
		print("Error")
	end
	Reset()
end

function DragManager.DragItem()
	local Table = PlayerGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)
	
	local XS, YS = game.Workspace.Camera.ViewportSize.X * .05, game.Workspace.Camera.ViewportSize.Y * .1
	
	if not CurrentSlot then
		for _, Slot in next, Table do
			if DragPlace then
				if CS:HasTag(Slot, DragPlace) then --or  CS:HasTag(Slot.Parent, DragPlace) 
				--	print(Slot, DragPlace)
					CurrentSlot = Slot
				end
			end
		end
	end
	
	if CurrentItem and Dragging then -- if we have an item and we are dragging we move it
		CurrentSlot = nil

		if not CS:HasTag(CurrentItem, "UI") then
			local X,Y = Mouse.X/game.Workspace.Camera.ViewportSize.X, Mouse.Y/game.Workspace.Camera.ViewportSize.Y 
			CurrentItem.Position = UDim2.fromScale(X,Y) --UDim2.fromOffset(Mouse.X - 75,Mouse.Y - 50)
			CurrentItem.Size = UDim2.fromOffset(XS,YS) 
			print("Changed Size")
			CurrentItem.Parent = PlayerGui.Display
		else
			local X,Y = (Mouse.X + 0)/game.Workspace.Camera.ViewportSize.X, (Mouse.Y + 0)/game.Workspace.Camera.ViewportSize.Y 
			local Tween = TS:Create(CurrentItem, TweenInfo.new(.1), {Position =  UDim2.fromScale(X,Y)})
			Tween:Play()
			--CurrentItem.Position = UDim2.fromScale(X,Y)--UDim2.fromOffset(Mouse.X  -300,Mouse.Y - 50)
		end
		CurrentItem.ZIndex = 50
	
		
	elseif not Dragging and CurrentSlot and CurrentItem and not CS:HasTag(CurrentItem, "UIElement") then
		local ItemName = CurrentItem:FindFirstChildWhichIsA("StringValue")
		local Slot =  CurrentSlot or DragSlot
		
		if Slot:FindFirstAncestor("Inventory") and ItemName and not DragSlot:FindFirstAncestor("ToolBar") and not CurrentSlot:FindFirstChildWhichIsA("ImageLabel") then
			
			if DragPlace == "GearSlot" and DragSlot:FindFirstAncestor("GearFrame") then
				game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer("UnequipItemInInventory",{tonumber(Slot.Name), Slot.Parent.Name, ItemName.Value, DragSlot,CurrentItem})
				print("Dang bro stop uneqiping")
			end
			
			game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer("UpdateItemInInventory", {tonumber(Slot.Name), ItemName.Value, tonumber(DragSlot.Name), CurrentItem, DragSlot.Parent})
			
		elseif Slot:FindFirstAncestor("Inventory") and ItemName and not DragSlot:FindFirstAncestor("ToolBar") and CurrentSlot:FindFirstChildWhichIsA("ImageLabel") then
			
			game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer("MergeInvItem",{ CurrentItem, CurrentSlot, DragSlot})
			
		elseif DragPlace == "SkillSlot" and ItemName  and not CurrentSlot:FindFirstAncestor("Inventory") and not CurrentSlot:FindFirstChildWhichIsA("ImageLabel")  then
			
			CurrentItem.Parent = Slot
			game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer("AddSkillToToolBar", {tonumber(Slot.Parent.Name), ItemName.Value, tonumber(Slot.Name)})
			
		elseif DragPlace == "PotionSlot" and ItemName and not CurrentSlot:FindFirstAncestor("Inventory") and not CurrentSlot:FindFirstChildWhichIsA("ImageLabel") then
			
			game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer("AddPotionToToolBar", {tonumber(Slot.Parent.Name), ItemName.Value, tonumber(DragSlot.Name) or tonumber(DragSlot.Parent.Name), CurrentItem})
			
		elseif DragPlace == "GearSlot" and CS:HasTag(CurrentSlot, DragPlace) and not CurrentItem:FindFirstAncestor("Inventory") and Slot and not CurrentSlot:FindFirstChildWhichIsA("ImageLabel") then
			
			game.ReplicatedStorage.Remotes.Client.DataUpdate:InvokeServer("EquipItemInGearSlot",{tonumber(Slot.Name), Slot.Parent.Name, ItemName.Value, DragSlot,CurrentItem})
		elseif CurrentItem then
			CurrentItem.Parent = DragSlot
		end
		Reset()
		Dragging = false
		
	elseif not Dragging and CurrentItem and CS:HasTag(CurrentItem, "UIElement") then
		
	elseif not Dragging and  CS:HasTag(CurrentItem, "UIElement")  then 
		
	elseif not Dragging and not  CS:HasTag(CurrentItem, "UIElement")  then -- if we are not dragging then we reset the current item
		
		if CurrentItem then
			pcall(function()
				Finish(Table)
			end)
		end
		
	elseif not CurrentItem then -- if we dont have a current item then we look for one
		for _, Item in next, Table do
			if CS:HasTag(Item, "Draggable") or CS:HasTag(Item, "UIElement") then
				CurrentItem = not CS:HasTag(Item, "UIElement") and Item or Item.Parent
				OldZIndex = CurrentItem.ZIndex
				DragSlot = CurrentItem.Parent
				DragPlace = 
					CurrentItem:FindFirstAncestor("ToolBar") and CS:HasTag(CurrentItem.Parent, "SkillSlot") and "SkillSlot" 
					or  CurrentItem:FindFirstAncestor("ToolBar") and CS:HasTag(CurrentItem.Parent, "PotionSlot") and not CS:HasTag(CurrentItem, "GearSlot")  and "PotionSlot" 
					or  CurrentItem:FindFirstAncestor("Inventory") and CS:HasTag(CurrentItem.Parent, "PotionSlot") and not CS:HasTag(CurrentItem, "GearSlot") and "PotionSlot" 
					or  CurrentItem:FindFirstAncestor("Inventory") and CS:HasTag(CurrentItem.Parent, "GearSlot") and CS:HasTag(CurrentItem, "GearSlot")  and "GearSlot" 
					or  CurrentItem:FindFirstAncestor("ToolBar") and "ToolBar"
					or CurrentItem:FindFirstAncestor("SkillBook") and "SkillSlot"  
					or CurrentItem:FindFirstAncestor("Inventory") and "Inventory" 
					or CurrentItem:FindFirstAncestor("GearFrame") and "GearSlot"  -- this gets the parent so we can filter check the slots
				print(CurrentItem)
				if DragPlace == "SkillSlot" or DragPlace == "Inventory" then
					if not  CurrentItem:FindFirstAncestor("ToolBar") and not CS:HasTag(CurrentItem, "UIElement") then
						CopyItem = CurrentItem
						CurrentItem = CurrentItem:Clone()
					end
				end
			end
		end
	end
	
end

return DragManager
