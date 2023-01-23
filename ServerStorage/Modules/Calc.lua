shared.Calc = {}


local PlayerClasses = game.ServerStorage.Framework.PlayerClasses
local ItemManager = require(game.ServerStorage.Framework.Modules.ItemManager)
local DamageEffects = require(game.ServerStorage.Framework.Modules.Visuals.VisualEffects)
Enum = require(game.ServerStorage.Framework.Modules.Enum_Loader)

local Caps = {
	DMG = {
		LevelSeg = shared.Modifiers.MaxLevel;
		HardCap = 500;
		SoftCap = 700;
		BStart = 50;
		BEnd = 76 *  shared.Modifiers.MaxLevel;	
	};
	CRIT = {
		LevelSeg = shared.Modifiers.MaxLevel;
		HardCap = 30;
		SoftCap = 55;
		BStart = 50;
		BEnd = 100 *  shared.Modifiers.MaxLevel;	
	};
	MIT = {
		LevelSeg = shared.Modifiers.MaxLevel;
		HardCap = 85;
		SoftCap = 95;
		BStart = 50;
		BEnd = 95 *  shared.Modifiers.MaxLevel;	
	};
	REGEN = {
		LevelSeg = shared.Modifiers.MaxLevel;
		HardCap = .5;
		SoftCap = 5;
		BStart = 50;
		BEnd = 125 *  shared.Modifiers.MaxLevel;	
	};
	BLOCK = {
		LevelSeg = shared.Modifiers.MaxLevel;
		HardCap = 45;
		SoftCap = 60;
		BStart = 50;
		BEnd = 150 *  shared.Modifiers.MaxLevel;	
	};
	EVADE = {
		LevelSeg = shared.Modifiers.MaxLevel;
		HardCap = 45;
		SoftCap =60;
		BStart = 50;
		BEnd = 150 *  shared.Modifiers.MaxLevel;	
	};
	PARRY = {
		LevelSeg = shared.Modifiers.MaxLevel;
		HardCap = 45;
		SoftCap =60;
		BStart = 50;
		BEnd = 150 *  shared.Modifiers.MaxLevel;	
	};
	HEALING = {
		LevelSeg = shared.Modifiers.MaxLevel;
		HardCap = 200;
		SoftCap =250;
		BStart = 50;
		BEnd = 75*  shared.Modifiers.MaxLevel;	
	};
	TACTICAL = {
		LevelSeg = shared.Modifiers.MaxLevel;
		HardCap = 500;
		SoftCap =700;
		BStart = 50;
		BEnd = 175 *  shared.Modifiers.MaxLevel;	
	};
	
}

function CalcCap(Level, Type)
	local LStart = 1;
	local LEnd = shared.Modifiers.MaxLevel
	--Level = 60
	

	local B = (Caps[Type].BStart * (LEnd - Level)+(Level-LStart) * Caps[Type].BEnd) / (LEnd - LStart)

	local RCap = ((Caps[Type].HardCap) / (Caps[Type].SoftCap - Caps[Type].HardCap)) * B
	local C = (Caps[Type].HardCap) / (Caps[Type].SoftCap - Caps[Type].HardCap)

	local ROptimal = (math.sqrt(C + 1) - 1) / (C) * RCap

	return math.ceil(ROptimal)
end


function shared.Calc.DamageReduction(PlayerArmour, PlayerLevel)
--	print(PlayerArmour)
	local MaxReduction = .85
	local Resistance = CalcCap(PlayerLevel, "MIT")
--	print(PlayerArmour, Resistance)
	local Reduction = PlayerArmour / Resistance < MaxReduction and PlayerArmour / Resistance or MaxReduction
--	print(Reduction)
	return Reduction
end

function shared.Calc.CalcRegen(Data, DataRegen)
	local NeededRegen =  CalcCap(Data.Data.LevelInfo.Level, "REGEN")
	local MaxRegen = .005
--	print(DataRegen)
	local Regen = DataRegen / NeededRegen < MaxRegen and DataRegen / NeededRegen or MaxRegen
--	print(Regen)
	return Regen
end

function shared.Calc.CalcCrit(AttackerData, PlayerLevel, Crit)
--	print(AttackerData, EnemyLevel, PlayerLevel, Crit)
	local CritChance  = 0
	local CritCap = .5
--	print(AttackerData, PlayerLevel)
	local NeededCritChance = CalcCap(PlayerLevel, "CRIT")
	--print(NeededCritChance, AttackerData.CritRating)
	--local CritChance =  AttackerData.CritRating / ((AttackerData.MaxLevel * 6/3) * EnemyLevel + PlayerLevel)
	if AttackerData then
		CritChance =  AttackerData.CritRating / NeededCritChance < CritCap and AttackerData.CritRating / NeededCritChance or CritCap
	else
		CritChance = Crit / NeededCritChance < CritCap and Crit / NeededCritChance  or CritCap
	end	
----	print(Crit, NeededCritChance, CritChance)
	--print(CritChance)
	if math.random() <= CritChance/2 then
		return true, "Dev"
	elseif math.random() <= CritChance  then
		return true, "Normal"
	else
		return false
	end
	
end

function shared.Calc .CalcDamage(CasterLevel, Data, SkillDamage)
	local NeededMastery = CalcCap(CasterLevel, "DMG")
--	print(NeededMastery,Data.DamageMastery)
	local MaxDamage = 5
	
	local Multiplier = Data.DamageMastery / NeededMastery*MaxDamage < MaxDamage and Data.DamageMastery / NeededMastery*MaxDamage or MaxDamage
--	print(Data.DamageMastery, Multiplier)
	local DamageDelt = (Data.WeaponDamage + SkillDamage) + ((Data.WeaponDamage + SkillDamage)  * Multiplier)
	
  -- print(DamageDelt, Data.WeaponDamage)
	--print(math.ceil(Formula))
--	print(DamageDelt)
	return math.ceil(DamageDelt)
end

function shared.Calc .CalcHeal(CasterLevel, Data, HealAmount)
	local NeededMastery = CalcCap(CasterLevel, "DMG")
	--	print(NeededMastery,Data.DamageMastery)
	local MaxHeal = 2

	local Multiplier = Data.TacticalMastery / NeededMastery*MaxHeal < MaxHeal and Data.TacticalMastery / NeededMastery*MaxHeal or MaxHeal
	--	print(Data.DamageMastery, Multiplier)
	local DamageDelt = (Data.HealAmount + HealAmount) + ((Data.HealAmount + HealAmount)  * Multiplier)

	-- print(DamageDelt, Data.WeaponDamage)
	--print(math.ceil(Formula))
	--	print(DamageDelt)
	return math.ceil(DamageDelt)
end


--DMG = {
--	LevelSeg = shared.Modifers.MaxLevel;
--	HardCap = 200;
--	SoftCap = 400;
--	BStart = 270;
--	BEnd = 20250;	
--};

function  shared.Calc.CalculateEvade(TargetData)
	local NeededEvade = CalcCap(TargetData.Level or TargetData.Data.LevelInfo.Level, "EVADE")
	
	local MaxEvade = .45
--	print(TargetData)
	local EvadeChance = TargetData.Evade / NeededEvade < MaxEvade and  TargetData.Evade / NeededEvade or MaxEvade
	
	if math.random() <= EvadeChance then
		DamageEffects.Avoid("Evade", TargetData.Char)
		return true
	else
--		print("Hit")
		return false
	end
end

function  shared.Calc.CalculateParry(TargetData)
	local NeededEvade = CalcCap(TargetData.Level or TargetData.Data.LevelInfo.Level, "PARRY")

	local MaxEvade = .45
--	print(TargetData)
	local EvadeChance = TargetData.Parry / NeededEvade < MaxEvade and  TargetData.Parry / NeededEvade or MaxEvade

	if math.random() <= EvadeChance then
		DamageEffects.Avoid("Parry", TargetData.Char)
		return true
	else
--		print("Hit")
		return false
	end
end


function  shared.Calc.CalculateBlock(TargetData)
	local NeededEvade = CalcCap(TargetData.Level or TargetData.Data.LevelInfo.Level, "BLOCK")

	local MaxEvade = .45

	local EvadeChance = TargetData.Block / NeededEvade < MaxEvade and  TargetData.Block / NeededEvade or MaxEvade

	if math.random() <= EvadeChance then
		DamageEffects.Avoid("Block", TargetData.Char)
		return true
	else
--		print("Hit")
		return false
	end
end

function GetGearRating(Equipped, Trait)
	
	local Damage = 0
	local Armour = 0
	local GearBoost = 0
	
	for Slot, Gear in next, Equipped do
		local ItemData = ItemManager[Gear] 
		if ItemData then
			--			print(ItemData)
			if ItemData.Damage then
				Damage +=  ItemData.Damage
			elseif  ItemData.Armour then
				Armour +=  ItemData.Armour
			end
		--	print(Armour, Damage)
			if ItemData.Boosts[Trait] then
				GearBoost += ItemData.WeaponType == Enum.WeaponType.Dual and ItemData.Boosts[Trait]/2 or ItemData.Boosts[Trait]
			end

		end
	end
	return Damage, Armour, GearBoost
end

function shared.Calc.CalcPlayerStat(self, Trait, Stat)
	local ClassInfo = self:GetClass()
	local Equipped = self.Data.Equipped
	local Modifer = ClassInfo[Trait]
	local TraitStat = self.Data.Traits[Trait] or self.Traits[Trait] or 50
	local Damage, Armour, GearBoost = GetGearRating(Equipped, Trait)
	
	self.WeaponDamage = Damage
	self.CurrentArmour = Armour
	
	local Calc = ((TraitStat + GearBoost) * Modifer) 
--	print(Calc, Trait, Modifer, GearBoost, TraitStat)
----	print(Calc)
	--	print(math.ceil(ClassInfo[Stat] + Calc), Calc, ClassInfo[Stat])
	return math.ceil(ClassInfo[Stat] or 0 + Calc)
end


return shared.Calc 