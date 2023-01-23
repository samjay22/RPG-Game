local Skills = {}

local DamageEffects = require(game.ServerStorage.Framework.Modules.Visuals.VisualEffects)
Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)
local Visuals = require(script.SkillVisuals)

local Inductions = {}

function DebSkill(self, SkillName,Duration)
	coroutine.wrap(function()
		wait(Duration)
		self.CDs[SkillName] = nil
	end)()
end

function PlayAnimation(CallerData, AnimationID)
	local Char = CallerData.Char
	local Hum = Char:WaitForChild("Humanoid")
	local Animation = Instance.new("Animation", Hum)
	Animation.AnimationId = AnimationID
	local Track = Hum:LoadAnimation(Animation)
	game.Debris:AddItem(Track, Track.Length)
	Track:Play()
	return Track
end

function Induction(CallerData, InductionTime)
	Inductions[CallerData.Player] = true
	local Char = CallerData.Char
	local Done = nil
	local LastTime = os.clock()
	
	local AnimationID = 'rbxassetid://6652394459';
	local Track = PlayAnimation(CallerData, AnimationID)
	
	local Effect = script.Induction:Clone()
	Effect.Parent = game.Workspace
	Effect:SetPrimaryPartCFrame(Char.PrimaryPart.CFrame - Vector3.new(0,3,0))
	
	local CharPos = CallerData.Char.PrimaryPart.Position
	
	for Num = 0, 60, InductionTime/100 do
		game["Run Service"].Stepped:Wait()
		Effect:SetPrimaryPartCFrame(Effect:GetPrimaryPartCFrame() * CFrame.Angles(0,math.rad(5), 0))
		local Mag =  (CharPos - CallerData.Char.PrimaryPart.Position).Magnitude
		if( os.clock() - LastTime) >= InductionTime then
			Done = true
			break
		elseif Mag >= 5  then
			print("Moved")
			break
		end
	end
	print(Done)
	Effect:Destroy()
	--Con:Disconnect()
	Inductions[CallerData.Player] = false
	Track:Stop()
	return Done	
end

function CheckClass(CallerData, Classes)
	
	local ActiveClass = CallerData:GetClass()
--	print(ActiveClass)
	print(table.find(Classes, ActiveClass.ClassID), Classes, ActiveClass.ClassID)
	if table.find(Classes, ActiveClass.ClassID) then
		return true
	else
		return false
	end 
end

function CallBack(Data, SkillName, Duration, NPC)
----	print("Done", Data)
	DebSkill(Data, SkillName,Duration)
end

function GetIgnoreList(Char)
	local Ignore = {}
	Char = game.Players:GetPlayerFromCharacter(Char) or Char
--	print(shared.Enemys, shared.Characters, Char)
	local List = shared.Enemys[Char] and  shared.Enemys or shared.Characters[Char] and shared.Characters
	
	for _, C in next, List do
		table.insert(Ignore, C.Char)
	end
	return Ignore
end

function SingleTarget(self, Skill, Target)
	local Char = self.Char
	local Level = self.Level or self.Data.LevelInfo.Level
	
	local Evaded = shared.Calc.CalculateEvade(Target)
	local Parry = not Evaded and shared.Calc.CalculateParry(Target) or nil
	local Block = not Evaded and not Parry and shared.Calc.CalculateBlock(Target) or nil


	if Evaded or Block or Parry then  return end 
	local Damage = shared.Calc.CalcDamage(Level, self, Skill.Damage)
	local Reduction = shared.Calc.DamageReduction(Target.CurrentArmour, Level)
	local Crit, Type = shared.Calc.CalcCrit(self, Level)
	
	if Crit then 
		if Type == "Dev" then
			Damage -= (Damage * Reduction)
			Damage *= 2
		else
			Damage -= (Damage * Reduction)
			Damage *= 1.5
		end
	else
		Damage -= (Damage * Reduction)
	end
	
	Target.CurrentHealth -= Damage
	
	local Char = Target.Char
	if not Target.Player then
		Target.Attackers[self.Player] = self
	end
	
	DamageEffects.Damage(Crit, math.ceil(Damage), Char)
	
end

function RayCast(self, Skill)
	local HitDeb = {} -- make sure we dont damage more than once
--	print("Ran")
	if Skill.SkillType == Enum.SkillType.Melee then
		local Hits = {}
		
		local Char = self.Char
		local Level = self.Level or self.Data.LevelInfo.Level
		
		local Min, Max = Skill.Angles[1], Skill.Angles[2]
		local List = GetIgnoreList(Char)
		local Perams = RaycastParams.new()
		Perams.CollisionGroup = "Armour"
		Perams.FilterDescendantsInstances = List
		Perams.FilterType = Enum.RaycastFilterType.Blacklist
		
		for Radian = Min, Max do
			local Hit = game.Workspace:Raycast(Char.PrimaryPart.Position, (Char.PrimaryPart.CFrame * CFrame.Angles(math.rad(Radian),math.rad(Radian), math.rad(Radian))).LookVector * Skill.Range, Perams)
			if Hit then
				local HitChar = Hit.Instance.Parent
				local Player = game.Players:GetPlayerFromCharacter(HitChar)
				--print(HitChar)
				local HitData = shared.Enemys[HitChar] or shared.Characters[Player]
				
			--print(HitData)
				if HitData and not HitDeb[HitChar] then
--					print(HitData, HitData.Target)
					if HitData.CurrentHealth <= 0 then return {} end
					HitDeb[HitChar] = true
					Hits[HitChar] = HitData
					local Evaded = shared.Calc.CalculateEvade(HitData)
					local Parry = not Evaded and shared.Calc.CalculateParry(HitData) or nil
					local Block = not Evaded and not Parry and shared.Calc.CalculateBlock(HitData) or nil
					
					
					if Evaded or Block or Parry then  return end 
					local Damage = shared.Calc.CalcDamage(Level, self, Skill.Damage)
					local Reduction = shared.Calc.DamageReduction(HitData.CurrentArmour, Level)
					local Crit, Type = shared.Calc.CalcCrit(self, Level)
					
					if Crit then 
						if Type == "Dev" then
							Damage -= (Damage * Reduction)
							Damage *= 2
						else
							Damage -= (Damage * Reduction)
							Damage *= 1.5
						end
					else
						Damage -= (Damage * Reduction)
					end
					HitData.CurrentHealth -= Damage
					local Char = HitData.Char
					if not HitData.Player then
						HitData.Attackers[self.Player] = self
					end
					DamageEffects.Damage(Crit, math.ceil(Damage), Char)
--					print(Damage)
				end
			end
		end
		
		return Hits
	end
end


function Skills:CastSkill(SkillName, Slot, Target)
	local CDs = self.CDs
	if CDs[SkillName] or 	Inductions[self.Player]  then return end
	
	local Skill = script.Parent.Skills:FindFirstChild(SkillName)
	Skill = require(Skill)
	--print("Ran more than ONCE!!!!", self.Player)
	if Skill and self.CurrentMana - Skill.ManaCost >= 0 then
		if Skill.AOE then
			print("Ran")
			self.CurrentMana -= Skill.ManaCost 
			self.CDs[SkillName] = true
			Visuals.SkillCooldown(self.Player, SkillName, Skill.Cooldown, Slot)
			Skill.RunSkill(self, CallBack, {RayCast, CheckClass, PlayAnimation, Induction, SingleTarget}, Target or self.Target)
			--self:DebSkill(SkillName, Skill.Cooldown)]
		elseif  not Skill.AOE  and Target or not Skill.AOE  and  self.Target then
			
			local Range = Skill.Range
			local Char = self.Char 
			
			if (Char.PrimaryPart.Position - Target.PrimaryPart.Position).Magnitude <= Range then
				self.CurrentMana -= Skill.ManaCost 
				self.CDs[SkillName] = true
				Visuals.SkillCooldown(self.Player, SkillName, Skill.Cooldown, Slot)
				Skill.RunSkill(self, CallBack, {RayCast, CheckClass, PlayAnimation, Induction, SingleTarget}, Target or self.Target)
			else
				game.ReplicatedStorage.Remotes.Server.VisualUpdate:FireClient(self.Player, "You are to far away from the target!")
				print("Fire cleint with to far away message")
			end
			
		end
	end
	
end








return Skills