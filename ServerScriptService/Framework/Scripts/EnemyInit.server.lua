local Enemys = game.ServerStorage.Framework.NPCManagers.Enemys

shared.Enemys = {}

local EnemySpawns = {}

local ZoneSize = Vector3.new(math.random(100,300),2,math.random(100,300))/2
local ZonePos =  Vector3.new(math.random(0,40), 1, math.random(-100,100))

local Min = ZoneSize - ZonePos
local Max = ZoneSize + ZonePos

for Num = 0,100 do
	local RandoPos = Vector3.new(math.random(-Min.X, Max.X), 0, math.random(-Min.Z, Max.Z))
--	print(RandoPos)
	local Pos = RandoPos
	table.insert(EnemySpawns,Pos)
end

local Monster = require(game.ServerStorage.Framework.NPCManagers.Enemys.MonsterClass)

for num = 0,10 do
	local SpawnPos = EnemySpawns[math.random(#EnemySpawns)]
	local Monster = Monster.New("Goblin")
	Monster:SpawnCharacter(SpawnPos)
	Monster:InitLoop()
	wait()
	shared.Enemys[Monster.Char] = Monster
end