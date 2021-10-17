repeat wait() until _G.PhysicsEngine
repeat wait() until _G.PhysicsEngine.SolveReady == true
local settings = _G.PhysicsEngine.Settings

function solve() 
	local ObjList = _G.PhysicsEngine.ObjectList
	
	for _,Object in pairs(ObjList) do
		local mass = Object:GetAttribute("MASS")
		local velocity = Object:GetAttribute("VELOCITY")
		local position = Object:GetAttribute("POSITION")
		local force = Object:GetAttribute("FORCE")
		
		local tempForce = force + mass * settings["Gravity"]

		
		local tempvelocity = velocity + (tempForce/mass)
		local tempposition = position + velocity
		
		if Object:FindFirstChild("PhysicsAnchor") then
			tempposition = position
		end
		
		_G.PhysicsEngine.CollisionsHandler.check(Object)
		
		Object:SetAttribute("VELOCITY",tempvelocity)
		Object:SetAttribute("POSITION",tempposition)
		
		--Object.Position = tempposition
	end
	_G.PhysicsEngine.CollisionSolver.solve()
end

repeat
	local physicsStep = 1/settings["PhysicsRate"]
	wait(physicsStep)
	
	solve()
until not game