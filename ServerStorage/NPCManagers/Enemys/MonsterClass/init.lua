local Monster = {}



local Modules = {
	require(script.Roaming);
	require(script.Attacking);
	require(script.Pathfinding);
	require(game.ServerStorage.Framework.EffectManager.EffectRunner);
	require(game.ServerStorage.Framework.SkillManager.SkillRunner);
}

Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

function Monster.New(MonsterName)

	Monster.__index = function(_, Index)
		if Monster[Index] then return Monster[Index] end
		for _, Manager in next, Modules do
			if Manager[Index] then
				return Manager[Index]
			end
		end
	end
	
	local MonsterData = require(game.ServerStorage.Framework.NPCManagers.Enemys.EnemyClasses[MonsterName])
	
	return setmetatable({
		--Vital Stats
		CurrentArmour = MonsterData.Armour;
		MaxArmour = MonsterData.Armour;
		
		CurrentHealth = MonsterData.Health;
		MaxHealth = MonsterData.Health;
		
		CurrentMana = MonsterData.Mana;
		MaxMana =MonsterData.Mana;
		
		RealMaxMana = MonsterData.Mana;
		RealMaxHealth = MonsterData.Health;
		RealMaxArmour = MonsterData.Armour;
		
		Level = MonsterData.Level;
		--Char model
		Name = MonsterData.Name;
		Char = MonsterData.CharModel:Clone();
		--Combat Stats
		AttackSpeed = MonsterData.AttackSpeed;
		WeaponDamage = MonsterData.WeaponDamage;
		
		Evade = MonsterData.Evade;
		Block = MonsterData.Block;
		Parry = MonsterData.Parry;
		
		AgroDistance = MonsterData.AgroDistance;
		MaxChaseDistance  = MonsterData.MaxChaseDistance;
		
		CritRating = MonsterData.CritRating;
		
		DamageMastery = MonsterData.DamageMastery;
		TacticalMastery =  MonsterData.TacticalMastery;
		HealAmount =  MonsterData.HealAmount;
		
		--Movment
		MoveSpeed = MonsterData.MoveSpeed;
		UnitType = MonsterData.UnitType;
		-- for attacking
		Target = nil;
		InCombat = nil;
		CDs = {};
		Attacks = MonsterData.Attacks;
		--Cosmetic
		VitalInfo = nil;		
		
		--Pathfinding data
		Nodes = {};
		CurrentNode = 1;
		Moving = false;
		
		--Mob Info
		MonsterData = MonsterData;
		Alive = true;
		DiedAnimation = MonsterData.DiedAnimation;
		KillXP = MonsterData.Level * 25;
		--Check who is attacking
		Attackers = {};
		
	}, Monster)
end

function Monster:SpawnCharacter(SpawnPosition)
	
	self.Char.Parent = game.Workspace
	self.Char:SetPrimaryPartCFrame(CFrame.new(SpawnPosition))
	self.VitalInfo = script.Status:Clone()
	local Info = self.VitalInfo
	Info.Parent = self.Char.Head
	Info.Adornee = self.Char.Head
	
	local HealthInfo = 	Info.Holder.Health
	local ManaInfo = Info.Holder.Mana
	local LevelInfo = Info.Holder.Level
	
	Info.Holder.Frame.Image = self.MonsterData.ImageFrame
	Info.Holder.MobName.Text = self.Name
	
	HealthInfo.HealthValue.Text = self.CurrentHealth .. "/" .. self.MaxHealth
	ManaInfo.ManaValue.Text = self.CurrentMana .. "/" .. self.MaxMana
	LevelInfo.CurrentLevel.Text = self.Level
	
	--setup movers
	
	self:SetupNodes()
end



function Died(self)
	for _, Player in next, self.Attackers do
		Player:Experence(self.KillXP)
		Player:GiveLoot(self.MonsterData.Loot)
	end
end


function Monster:UpdateInfo()
	
	
	local Info = self.VitalInfo
	
	local HealthInfo = 	Info.Holder.Health
	local ManaInfo = Info.Holder.Mana
	
	
	local Health =  self.CurrentHealth > 0 and  self.CurrentHealth  or 0
	local Mana =  self.CurrentMana > 0 and  self.CurrentMana or 0
	
	
	local HealthSize = self.CurrentHealth /  self.MaxHealth > .01 and self.CurrentHealth /  self.MaxHealth  or .01
	local ManaSize = self.CurrentMana /  self.MaxMana  > .01 and self.CurrentMana /  self.MaxMana  or .01
	
	HealthInfo.HealthValue.Text, HealthInfo.Bar.Size =  math.ceil(Health) .. "/" .. self.MaxHealth, UDim2.fromScale(HealthSize,1)
	ManaInfo.ManaValue.Text, ManaInfo.Bar.Size  = math.ceil(Mana) .. "/" .. self.MaxMana, UDim2.fromScale(ManaSize,1)
	
	if self.CurrentHealth <= 0 then
		Died(self)
		self.Velocity:Destroy()
		self.Gyro:Destroy()
		self.Char.Humanoid.Health -= 0 
		self.Alive= false
		self.__index = nil
		shared.Enemys[self.Char] = nil
		wait(2)
		self.Char:Destroy()
		setmetatable(Monster, nil)
	end
	
end

function Monster:GetClass()
	return self.MonsterData
end

function Monster:InitLoop()
	coroutine.wrap(function()
		while self.Alive do 
			game["Run Service"].Stepped:Wait()
			self:UpdateInfo()
			self.Target = self:FindClosestTarget()
			self:ChaseTarget()
			pcall(function()
				coroutine.wrap(function() -- avoid yeild
					self:Roam()
				end)()
			end)
		end
	end)()
	
end



return Monster