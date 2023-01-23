--[[
Sam
3/20/21
Deals with effects and buffs of player
]]

local StatusManager = {
	A = 2;
}


local PlayerClasses = game.ServerStorage.Framework.PlayerClasses



function StatusManager:UpdateStatus()
--	print(self.MaxHealth)
	local ClassInfo = self:GetClass()

	if  self.CurrentHealth <= 0 then
		self:RemoveEffect(nil, true)
		self.Alive = false;
		self.Char.Humanoid.Health = 0
	end
	--print(self)
	game.ReplicatedStorage.Remotes.Client.DataEvent:FireClient(self.Player, "CharacterStats",  self)
end


return StatusManager
