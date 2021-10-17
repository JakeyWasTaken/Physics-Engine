repeat wait() until _G.PhysicsEngine
repeat wait() until _G.PhysicsEngine.CollisionsHandler
repeat wait() until _G.PhysicsEngine.CollisionsHandler.CollisionsThisFrame

_G.PhysicsEngine.CollisionSolver = {}
local collisionSolver = _G.PhysicsEngine.CollisionSolver
local collisionHandler = _G.PhysicsEngine.CollisionsHandler
local collisionsThisFrame = _G.PhysicsEngine.CollisionsHandler.CollisionsThisFrame

collisionSolver.solve = function() -- solves current frame, not certain parts
	local solved = false
	for i,v in pairs(collisionsThisFrame) do
		local sender,reciever = v["sender"],v["reciever"]
		
		local lookvectorA = CFrame.new(reciever.Position,sender.Position).LookVector
		local lookvectorB = CFrame.new(sender.Position,reciever.Position).LookVector
		
		local senderVelocity = sender:GetAttribute("VELOCITY")
		local recieverVelocity = reciever:GetAttribute("VELOCITY")
		
		local senderVelocity = reciever:GetAttribute("VELOCITY")
		local recieverVelocity = reciever:GetAttribute("VELOCITY")
		
		sender:SetAttribute("VELOCITY",Vector3.new(0,1,0))
		print("hh")
		--sender:SetAttribute("VELOCITY",senderVelocity - (lookvectorA * (senderVelocity/2)*10))
		--reciever:SetAttribute("VELOCITY",recieverVelocity - (lookvectorB * (senderVelocity/2)*10))
		
		if i == #collisionsThisFrame then
			solved = true
		end
	end
	if solved == true then
		collisionsThisFrame = {}
	end
end