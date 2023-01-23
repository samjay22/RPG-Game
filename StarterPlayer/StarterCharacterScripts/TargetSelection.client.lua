local Icon = game.ReplicatedStorage.Objects.Selector

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local CurrentTarget = nil
local Selector = nil
local Connection = nil

_G.SelectedTarget = nil

local CS = game:GetService("CollectionService")

function Run()
	Connection = game["Run Service"].Stepped:Connect(function()
		Selector.CFrame = CurrentTarget.PrimaryPart.CFrame - Vector3.new(0,2.5,0)
		if (CurrentTarget.PrimaryPart.Position - Player.Character.PrimaryPart.Position).Magnitude >= 250 then
			Connection:Disconnect()
			Selector:Destroy()
			CurrentTarget = nil
			if CurrentTarget.Humanoid.Health <= 0 then
				_G.SelectedTarget = nil
				CurrentTarget = nil
				Selector:Destroy()
				return Connection:Disconnect()
			end
		end
	end)
end

Mouse.Button1Down:Connect(function()
	
	local MouseHit = Mouse.Target
	
	if MouseHit and MouseHit.Parent:IsA("Model")  and CS:HasTag(MouseHit.Parent, "Mob") and not CurrentTarget then
	
		CurrentTarget = MouseHit.Parent
		Selector = Icon:Clone()
		_G.SelectedTarget  = CurrentTarget
		Run()
		
		Selector.Parent = CurrentTarget
	elseif MouseHit and CurrentTarget and CurrentTarget ~= MouseHit.Parent and MouseHit.Parent:IsA("Model")  and CS:HasTag(MouseHit.Parent, "Mob") then
		
		Connection:Disconnect()
		Selector:Destroy()
		
		CurrentTarget = MouseHit.Parent
		Selector = Icon:Clone()
		_G.SelectedTarget  = CurrentTarget
		Run()
		
		Selector.Parent = CurrentTarget
		
	elseif CurrentTarget  and not MouseHit or MouseHit and not CS:HasTag(MouseHit.Parent, "Mob") then
		if Connection and Selector   then
			Connection:Disconnect()
			Selector:Destroy()
			CurrentTarget = nil
			_G.SelectedTarget = nil
		end
	end
end)