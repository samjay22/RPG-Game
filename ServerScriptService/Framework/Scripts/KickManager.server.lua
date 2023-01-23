local GroupID = 2722693

game.Players.PlayerAdded:Connect(function(Player)
	if Player:IsInGroup(GroupID) then
		if Player:GetRankInGroup(GroupID) < 30 then
			Player:Kick("Not an Alpha Tester")
		end
	end
end)