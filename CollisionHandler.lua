repeat wait() until _G.PhysicsEngine
repeat wait() until _G.PhysicsEngine.Settings

_G.PhysicsEngine.CollisionsHandler = {}
_G.PhysicsEngine.CollisionsHandler.CollisionPoints = {}
_G.PhysicsEngine.CollisionsHandler.CollisionsThisFrame = {}
local collisions_handler = _G.PhysicsEngine.CollisionsHandler
local collision_points = _G.PhysicsEngine.CollisionsHandler.CollisionPoints
local collisions_this_frame = _G.PhysicsEngine.CollisionsHandler.CollisionsThisFrame
local settings = _G.PhysicsEngine.Settings



collisions_handler.generateObjectPoints = function(object)
	local collisionDetail = settings["CollisionDetail"]
	local physicsOptomisation = settings["PhysicsOptomisation"]
	local physicsOptomisationSize = settings["PhysicsOptomisationSize"]
	
	local shape = object.Shape
	if shape == Enum.PartType.Ball then
		local samples = collisionDetail

		local positionpoints = {}

		do
			if physicsOptomisation == true then
				if math.abs(samples * object.Size.X-physicsOptomisationSize) == samples * object.Size.X-physicsOptomisationSize then
					samples = samples * (object.Size.X-physicsOptomisationSize)/2
				end 
			end
			
			local rnd = 1.0

			rnd = math.random() * samples

			local  offset = 2/samples
			local  increment = math.pi * (3. - math.sqrt(5));

			for i=1, samples+1 do
				local y = ((i * offset) - 1) + (offset / 2);
				local r = math.sqrt(1 - math.pow(y,2))

				local phi = ((i + rnd) % samples) * increment

				local 	x = math.cos(phi) * r
				local 	z = math.sin(phi) * r

				-- debug code
				--local part = Instance.new("Part")
				--part.Anchored = true
				--part.Parent = workspace
				--part.Size = Vector3.new(0.5,0.5,0.5)
				--part.CFrame = CFrame.new(Vector3.new(x,y,z)*(object.Size.X/2))

				local vector = Vector3.new(x,y,z)*(object.Size.X/2)
				table.insert(positionpoints,vector)
			end
		end
		
		collision_points[object] = positionpoints
	end
end


collisions_handler.check = function(object)
	local collisionOptomisationSize = settings["CollisionOptomisationSize"]
	
	local close_objects = {}
	for i,v in pairs(collision_points) do
		if i ~= object then
			if (object.Position-i.Position).Magnitude <= object.Size.X+object.Size.Z+object.Size.Y+collisionOptomisationSize then
				local objectPos = i.Position
				local selfPos = object.Position
				
				local objectPoints = v
				local selfPoints = collision_points[object]
				
				local temp = {}
				for _,p in pairs(objectPoints) do
					table.insert(temp,objectPos+p)
				end
				objectPoints=temp
				temp = {}
				
				for _,p in pairs(selfPoints) do
					table.insert(temp,selfPos+p)
				end
				selfPoints = temp
				temp = {}
				
				local closestA = 1000
				local closestAA = nil
				local closestB = 1000
				local closestBB = nil
				for _,v in pairs(objectPoints) do
					if (v-selfPos).Magnitude < closestA then
						closestA = (v-selfPos).Magnitude
						closestAA = v
					end 
				end
				
				for _,v in pairs(selfPoints) do
					if (v-objectPos).Magnitude < closestB then
						closestB = (v-selfPos).Magnitude
						closestBB = v
					end 
				end
				
				print(closestAA)
				
				local AADot = (closestAA-closestBB).Unit
				local BBDot = (closestBB-closestAA).Unit

				local LookAA = CFrame.new(closestAA,selfPos).LookVector
				local LookBB = CFrame.new(closestBB,objectPos).LookVector

				local aDot = LookAA:Dot(AADot)
				local bDot = LookBB:Dot(BBDot)
				print("A: "..aDot)
				print("B: "..bDot)
				
				local part = Instance.new("Part")
				part.Size = Vector3.new(0.25,.25,.25)
				part.Anchored = true
				part.Parent = workspace
				part.Position = closestAA
				
				
				local partb = Instance.new("Part")
				partb.Size = Vector3.new(0.25,.25,.25)
				partb.Anchored = true
				partb.Parent = workspace
				partb.Position = closestBB
				
				if aDot < 0 and bDot < 0 then
					warn("collision")
					table.insert(collisions_this_frame,{["sender"] = object,["reciever"] = i})
				end
				
				--part:Destroy()
				--partb:Destroy()
			end
		end
	end
end
