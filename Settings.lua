repeat wait() until _G.PhysicsEngine

_G.PhysicsEngine.Settings = {
	["Gravity"] = Vector3.new(0,-0.5,0),
	["CollisionOptomisationSize"] = 15, -- recommended, how close objects should be to calculate collisions with eachother
	["CollisionDetail"] = 128, -- keep atleast at 128, only make smaller if you plan on having alot of large physics objects
	["PhysicsOptomisation"] = true, -- recommended, enables or disables if sphere optomisation should happen
	["PhysicsOptomisationSize"] = 15,-- recommended, how large spheres need to be to start reducing collision detaik
	["PhysicsRate"] = 1
}