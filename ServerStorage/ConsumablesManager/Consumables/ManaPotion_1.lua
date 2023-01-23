local ManaPotion_1 = {
	Amount = 75;
	
}


function ManaPotion_1.Use(self)
	if not self then return end
	if self.CurrentMana + ManaPotion_1.Amount <= self.MaxMana then
		self.CurrentMana += ManaPotion_1.Amount
	else
		self.CurrentMana = self.MaxMana
	end
end

return ManaPotion_1
