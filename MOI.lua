_G.PhysicsEngine = {}
repeat wait() until _G.PhysicsEngine.CollisionsHandler
repeat wait() until _G.PhysicsEngine.CollisionSolver

local collisionHandler = _G.PhysicsEngine.CollisionsHandler

local ADD_BIND = Instance.new("BindableEvent",script)
local REMOVE_BIND = Instance.new("BindableEvent",script)

ADD_BIND.Name = "Add_Object"
REMOVE_BIND.Name = "Remove_Object"

function doesHaveAttributes(obj)
	local s,e = pcall(function()
		obj:GetAttribute("MASS")
		obj:GetAttribute("FORCE")
		obj:GetAttribute("VELOCITY")
		obj:GetAttribute("POSITION")
	end)
	if s then
		return true
	else
		return false
	end
end

function init()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsA("Terrain") then
			if not v:FindFirstChild("Locked") and doesHaveAttributes(v) then
				collisionHandler.generateObjectPoints(v)
				table.insert(_G.PhysicsEngine.ObjectList,v)
			end
		end
	end
	
	_G.PhysicsEngine.SolveReady = true
end

repeat
	wait()
until _G.PhysicsEngine.ObjectList and _G.PhysicsEngine.Settings

init()

ADD_BIND.Event:Connect(function(Object : Instance)
	if Object:IsA("BasePart") then
		if not Object:FindFirstChild("Locked") and doesHaveAttributes(Object) then
			table.insert(_G.PhysicsEngine.ObjectList,Object)
		end
	end
end)

REMOVE_BIND.Event:Connect(function(Object : Instance)
	if _G.PhysicsEngine.ObjectList[Object] then
		_G.PhysicsEngine.ObjectList[Object] = nil
	end
end)