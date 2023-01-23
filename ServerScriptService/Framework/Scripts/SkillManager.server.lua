

game.ReplicatedStorage.Remotes.Client.UseSkill.OnServerEvent:Connect(function(Player, Skill, Slot, Target)
	if 	shared.Characters[Player] then
		shared.Characters[Player]:CastSkill(Skill, Slot, Target)
	end
end)