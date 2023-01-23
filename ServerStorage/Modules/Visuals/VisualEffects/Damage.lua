local DamageMarker = script.Damage
local TS = game:GetService("TweenService")

local SizeInfo = TweenInfo.new(.5, Enum.EasingStyle.Quad)
local PositionInfo = TweenInfo.new(1, Enum.EasingStyle.Bounce)

local Effects = {}

function Effects.Damage(Crit, Amount, Hit)
	
	local Clone = DamageMarker:Clone()
	
	coroutine.wrap(function()
		local Head =  Hit:FindFirstChild("Head") or  Hit.Parent:FindFirstChild("Head") or  Hit.Parent.Parent:FindFirstChild("Head")
		if Crit and Head then
			Clone.Holder.Damage.TextColor3 = Color3.fromRGB(85, 0, 0)
			Clone.Holder.Damage.Text = Amount
			local Tween = TS:Create(Clone.Holder.Damage, SizeInfo, {TextSize = 50})
			local Pos = TS:Create(Clone, PositionInfo, {StudsOffset = Vector3.new(math.random(0,3),math.random(0,3),math.random(0,3))})
			Clone.Parent = Head
			Clone.Adornee = Head
			Tween:Play()
			Pos:Play()
			Pos.Completed:Wait()
			Clone:Destroy()
		elseif Head then
			Clone.Holder.Damage.TextColor3 = Color3.fromRGB(255, 0, 0)
			Clone.Holder.Damage.Text = Amount
			local Tween = TS:Create(Clone.Holder.Damage, SizeInfo, {TextSize = 50})
			local Pos = TS:Create(Clone, PositionInfo, {StudsOffset = Vector3.new(math.random(0,3),math.random(0,3),math.random(0,3))})
			Clone.Parent = Head
			Clone.Adornee = Head
			Tween:Play()
			Pos:Play()
			Pos.Completed:Wait()
			Clone:Destroy()
		end
	end)()
end


return Effects