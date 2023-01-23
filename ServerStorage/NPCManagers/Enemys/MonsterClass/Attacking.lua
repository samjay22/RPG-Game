local Attacking = {}

local Ranges = {
	Melee = 5;
	Ranged = 30;
}

local AttackDebs = {}


function Attacking:DebSkill(Name, CD)
	coroutine.wrap(function()
		self.CDs[Name] = true
		wait(CD)
		self.CDs[Name] = nil
	end)()
end

function Attacking:FindClosestTarget()
	if not self.Alive then return end
	local Chosen = nil
	
	for _, P in next, game.Players:GetChildren() do

		local PChar = P.Character or  P.CharacterAdded:Wait()
		local Char = self.Char

		local Mag = (PChar.PrimaryPart.Position - Char.PrimaryPart.Position).Magnitude

		if Mag < self.AgroDistance then
			Chosen = PChar
		end

	end
	if Chosen then
		self.InCombat  = true
		return Chosen
	else
		self.InCombat  = false
		return nil
	end
end

function Attacking:ChooseSkill()
	local Attacks = self.Attacks
	local ChosenAttack = Attacks[math.random(#Attacks)]
	return ChosenAttack
end

function AttackDeb(self, RestTime)
	coroutine.wrap(function()
		AttackDebs[self.Char] = true
		wait(RestTime)
		AttackDebs[self.Char] = false
	end)()
end

function SetTargetCombatState(Target)
		local Bool = Instance.new("BoolValue")
		Bool.Parent = Target
		Bool.Name = "InCombat"
		game.Debris:AddItem(Bool, 30)
end

function Attacking:ChaseTarget()
	if not self.Alive then return end
	local Target = self.Target
	local Char = self.Char
	if not Target then return end
	if not Target:FindFirstChild("InCombat") then
		SetTargetCombatState(Target)
	end
	local Range = (Target.PrimaryPart.Position - Char.PrimaryPart.Position).Magnitude
	if Target.Humanoid.Health <= 0 then self.Target = nil self.InCombat = false return end
	
	if Range > Ranges[self.UnitType] then
		
		local Unit = (Target.PrimaryPart.Position - Char.PrimaryPart.Position).Unit
		self.Velocity.Velocity = Unit * self.MoveSpeed
		self.Gyro.CFrame = CFrame.new(Char.PrimaryPart.Position, Target.PrimaryPart.Position)
		
	else
		
		self.Velocity.Velocity = Vector3.new()
		self.Gyro.CFrame = CFrame.new(Char.PrimaryPart.Position, Target.PrimaryPart.Position)
		local Attack = self:ChooseSkill()
		
		if Attack then
			self:CastSkill(Attack)
		end
		
	end
	
	
end




return Attacking
