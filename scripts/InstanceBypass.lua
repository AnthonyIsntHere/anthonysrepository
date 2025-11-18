-- Made by AnthonyIsntHere
-- Used for bypassing client-sided anti-cheats that detect instantiated objects
-- Added dot notation bypass
local ProtectedInstances = {}

local _Instance = Instance.new
local _tostring = tostring

local InstanceHook; InstanceHook = hookfunction(_Instance, newcclosure(function(...)
	if checkcaller() then
		local NewInstance = InstanceHook(...)

		NewInstance:SetAttribute("MainVM", true)
		ProtectedInstances[NewInstance] =  true
		return NewInstance
	end

	return InstanceHook(...)
end))

local tostringHook; tostringHook = hookfunction(_tostring, newcclosure(function(...)
	if not checkcaller() then
		local Arguments = {...}
		local String = tostringHook(...)

		if ProtectedInstances[Arguments[1]] then
			return
		end
	end

	return tostringHook(...)
end))

local FunctionHook; FunctionHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local Arguments = {...}
	local Method = getnamecallmethod()

	if not checkcaller() then
		if ProtectedInstances[self] and Method:match("IsA") then
			return
		end

		if Method:match("^FindFirst") then
			local Instance = self[Method](self, Arguments[1])
			
			if Instance and ProtectedInstances[Instance] then
				return false
			end
		end

		if Method:match("Attribute") and Arguments[1] == "MainVM" then
			return false
		end
	end

	return FunctionHook(self, ...)
end))

local PropertiesHook; PropertiesHook = hookmetamethod(game, "__index", newcclosure(function(self, index)
	if index:match("^FindFirst") and not checkcaller() then
		local IndexFunction = self[index]

		if typeof(IndexFunction) == "function" then
			if not isfunctionhooked(IndexFunction) then
				local IndexFunctionHook; IndexFunctionHook = hookfunction(IndexFunction, newcclosure(function(...)
					if not checkcaller() then
						local Arguments = {...}
						restorefunction(IndexFunction)

						local Instance = IndexFunction(self, Arguments[2])

						if Instance and ProtectedInstances[Instance] then
							return false
						end
					end
				end))
			end
		end
	end
	
	if not checkcaller() and ProtectedInstances[self] then
		return
	end

	return PropertiesHook(self, index)
end))

print("loaded")

for _, Actor in next, getactors() do
	run_on_actor(Actor, [[
		local _tostring = tostring

		local tostringHook; tostringHook = hookfunction(_tostring, newcclosure(function(...)
			if not checkcaller() then
				local Arguments = {...}
				local String = tostringHook(...)

				if Arguments[1]:GetAttribute("MainVM") then
					return
				end
			end

			return tostringHook(...)
		end))

		local FunctionHook; FunctionHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
			local Arguments = {...}
			local Method = getnamecallmethod()

			if not checkcaller() then
				if self:GetAttribute("MainVM") and Method:match("IsA") then
					return
				end

				if Method:match("^FindFirst") then
					local Instance = self[Method](self, Arguments[1])

					if Instance and Instance:GetAttribute("MainVM") then
						return
					end
				end

				if Method:match("Attribute") and Arguments[1] == "MainVM" then
					return false
				end
			end

			return FunctionHook(self, ...)
		end))

		local PropertiesHook; PropertiesHook = hookmetamethod(game, "__index", newcclosure(function(self, index)
			if index:match("^FindFirst") and not checkcaller() then
				local IndexFunction = self[index]

				if typeof(IndexFunction) == "function" then
					if not isfunctionhooked(IndexFunction) then
						local IndexFunctionHook; IndexFunctionHook = hookfunction(IndexFunction, newcclosure(function(...)
							if not checkcaller() then
								local Arguments = {...}
								restorefunction(IndexFunction)

								local Instance = IndexFunction(self, Arguments[2])

								if Instance and Instance:GetAttribute("MainVM") then
									return false
								end
							end
						end))
					end
				end
			end
			
			if not checkcaller() and self:GetAttribute("MainVM") then
				return
			end

			return PropertiesHook(self, index)
		end))
		print("actor loaded")
	]])
end
