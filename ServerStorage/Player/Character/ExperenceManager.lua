local XP = {}

--XP.__index = XP

local MaxLevel = shared.Modifiers.MaxLevel

function XP:Experence(Amount)
	local XPInfo = self.Data.LevelInfo
	
	if XPInfo.Level >= MaxLevel then XPInfo.Level = MaxLevel return game.ReplicatedStorage.Remotes.Client.DataEvent:FireClient(self.Player, "Level", {0, 0, XPInfo.Level}) end
	local Required = (50 * (XPInfo.Level- 2)^2 + 200 * (XPInfo.Level+ 1)^2 - 300)/4
--	print(Required)
	XPInfo.CurrentXP += Amount or 0
	XPInfo.TotalXP += Amount or 0

	repeat wait() if XPInfo.CurrentXP >= Required then  XPInfo.Level += 1 	XPInfo.CurrentXP -= Required XPInfo.SkillPoints += 2 end  until XPInfo.CurrentXP < Required 

	game.ReplicatedStorage.Remotes.Client.DataEvent:FireClient(self.Player, "Level", {Required, XPInfo.CurrentXP, XPInfo.Level})
end



return XP
