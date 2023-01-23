Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)
local Table = {
	Acid = Enum.StatusEffects.Acid;
	Fire = Enum.StatusEffects.Fire;
	Health = Enum.StatusEffects.Health;
	Armour = Enum.StatusEffects.Armour;	
	Damage = Enum.StatusEffects.Damage;
	HOT = Enum.StatusEffects.HOT;
}
local Deb = false

for _, M in next, script.Parent:GetChildren() do
	if M:IsA("Model") then
		for _, P in next, M:GetChildren() do
			P.Touched:Connect(function(Hit)
				local Hum = Hit.Parent:FindFirstChild("Humanoid")
				if Hum then
					local Player = game.Players:GetPlayerFromCharacter(Hit.Parent)
					if Player and not Deb and	shared.Characters[Player] then
						Deb= true
						if M.Name == "Effect" and P.Name ~= "Remove" then
--							print(shared.Characters)
							shared.Characters[Player]:ActivateEffect(P.Name)
						elseif M.Name == "Effect" and P.Name == "Remove" then
							shared.Characters[Player]:RemoveEffect(Enum.EffectType.Debuff)
						elseif M.Name == "Buff" then
							shared.Characters[Player]:ActivateEffect(P.Name)
						end
						wait(.1)
						Deb = false
					end
				end
			end)
		end
	elseif M:IsA("Part") then
		M.Touched:Connect(function(Hit)
			local Hum = Hit.Parent:FindFirstChild("Humanoid")
			if Hum then
				local Player = game.Players:GetPlayerFromCharacter(Hit.Parent)
				shared.Characters[Player]:Experence(25000)
			end
		end)
	end
end