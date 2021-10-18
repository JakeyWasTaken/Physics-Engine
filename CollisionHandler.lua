repeat wait() until _G.PhysicsEngine
repeat wait() until _G.PhysicsEngine.Settings

_G.PhysicsEngine.CollisionsHandler = {}
_G.PhysicsEngine.CollisionsHandler.CollisionPoints = {}
_G.PhysicsEngine.CollisionsHandler.CollisionsThisFrame = {}
local collisions_handler = _G.PhysicsEngine.CollisionsHandler
local collision_points = _G.PhysicsEngine.CollisionsHandler.CollisionPoints
local collisions_this_frame = _G.PhysicsEngine.CollisionsHandler.CollisionsThisFrame
local settings = _G.PhysicsEngine.Settings

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
				for _,p in pairs(selfPoints) do
					table.insert(temp,selfPos+p)
				end
				selfPoints = temp
				
				local closestA = math.huge
				local closestAA = nil
				
				for _,v in pairs(selfPoints) do
					if (v-objectPos).Magnitude < closestA then
						closestA = (v-selfPos).Magnitude
						closestAA = v
					end 
				end

				local touching = object:GetTouchingParts()

				for _,v in pairs(touching) do
					if v == i then
						warn("collision")
						table.insert(collisions_this_frame,{["sender"] = object,["reciever"] = i})
					end
				end
			end
		end
	end
end
