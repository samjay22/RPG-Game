local HealthPotion_1 = {
	Amount = 75;
	
}


function HealthPotion_1.Use(self)
	if not self then return end
	if self.CurrentHealth + HealthPotion_1.Amount <= self.MaxHealth then
		self.CurrentHealth += HealthPotion_1.Amount
	else
		self.CurrentHealth = self.MaxHealth
	end
end

return HealthPotion_1
