local SkillVisuals = {}

function SkillVisuals.SkillCooldown(Player, SkillName, Duration, SkillSlot)
	if not Player then return end
	coroutine.wrap(function()
		local SkillUpdate = game.ReplicatedStorage.Remotes.Server.SkillUpdate
--		print(SkillSlot)
		SkillUpdate:FireClient(Player, SkillName, {Duration, SkillSlot})
	end)()
end

return SkillVisuals
