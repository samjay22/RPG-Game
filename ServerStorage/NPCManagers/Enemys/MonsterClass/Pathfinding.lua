local Pathfinding = {}

local Table = {}

function Pathfinding:SetupNodes()
	
	self.Nodes = {}
	local ZoneSize = Vector3.new(100,2,100)/2
	local ZonePos =  Vector3.new(0, 1, 0)
	
	local Min = ZoneSize - ZonePos
	local Max = ZoneSize + ZonePos


	
	for Num = 0,15 do
		local RandoPos = Vector3.new(math.random(-Min.X, Max.X), 0, math.random(-Min.Z, Max.Z))
		table.insert(self.Nodes,RandoPos)
	end
	
end


function Pathfinding:CheckNodeDistance()
		local Char = self.Char

		local CurrentNode = self.Nodes[self.CurrentNode]

		if (Char.PrimaryPart.Position - CurrentNode).Magnitude <= 5 then
			if 	self.CurrentNode ~= #self.Nodes then
				self.CurrentNode += 1
			else
				self.CurrentNode = 1
			end
		end

end

function Deb(self)
	coroutine.wrap(function()
		wait(math.random(1,4))
		self.Velocity.Velocity = Vector3.new()
		wait(math.random(1,4))
		self.Moving = false
	end)()
end

function Pathfinding:MoveToNode()
	if self.Target and self.InCombat then return end
	self:CheckNodeDistance()
	if self.Moving then return end
	
	self.Moving = true
	local Char = self.Char
	local Node = self.Nodes[self.CurrentNode]

	local Unit = (Node - Char.PrimaryPart.Position).Unit
	local Face = CFrame.new(Char.PrimaryPart.Position, Node)
	self.Gyro.CFrame = Face
	self.Velocity.Velocity = Unit * self.MoveSpeed
	Deb(self)
	self.Attackers = Table;
end


return Pathfinding
