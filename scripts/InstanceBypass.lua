-- Made by AnthonyIsntHere
-- Used for bypassing client-sided anti-cheats that detect instantiated objects
-- Needs fixing... lines 150-178
local ProtectedInstances = {}
local RunningScripts = {}

local _Instance = Instance.new
local _tostring = tostring

for _, x in next, getrunningscripts() do
	RunningScripts[x] = true
end

local InstanceHook; InstanceHook = hookfunction(Instance.new, newcclosure(function(...)
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
		if ProtectedInstances[self] then
			return
		end

		if Method:lower():match("^findfirst") or Method:lower():match("^waitforchild") then
			local Instance = FunctionHook(self, ...)

			if Instance and ProtectedInstances[Instance] then
				return
			end
		end
	end

	return FunctionHook(self, ...)
end))

local PropertiesHook; PropertiesHook = hookmetamethod(game, "__index", newcclosure(function(self, index)
	if not checkcaller() then
		if (ProtectedInstances[self] and index:lower():match("^is")) or index:lower():match("^findfirst") then
			local IndexFunction = PropertiesHook(self, index)

			if typeof(IndexFunction) == "function" then
				if not isfunctionhooked(IndexFunction) then
					local IndexFunctionHook; IndexFunctionHook = hookfunction(IndexFunction, newcclosure(function(...)
						local Arguments = {...}
						restorefunction(IndexFunction)

						local Instance = IndexFunction(self, Arguments[2])
						if Instance and ProtectedInstances[Instance] or ProtectedInstances[self] then
							return
						end
					end))
				end
			end
		end
		
		if ProtectedInstances[self] and typeof(PropertiesHook(self, index)) ~= "function" and not checkcaller() then
			return
		end
	end

	return PropertiesHook(self, index)
end))

for _, x in next, getgc() do
	if type(x) == "function" and islclosure(x) then
		local Script = getfenv(x).script

		if Script and RunningScripts[Script] then
			for _, y in next, getconstants(x) do
				if y == "WaitForChild" then
					--can't catch me
					Script.Enabled = false
					Script.Enabled = true
				end
			end
		end
	end
end

print("AnthonyIsntHere's Instance-Spoofer has loaded!")

for _, Actor in next, getactors() do
	run_on_actor(Actor, [[
		local MainVMInstances = {}
		local RunningScripts = {}

		for _, x in next, getrunningscripts() do
			RunningScripts[x] = true
		end

		local _tostring = tostring

		local tostringHook; tostringHook = hookfunction(_tostring, newcclosure(function(...)
			if not checkcaller() then
				local Arguments = {...}
				local String = tostringHook(...)

				if Arguments[1] and Arguments[1].GetAttribute(Arguments[1], "MainVM") == true then
					return
				end
			end

			return tostringHook(...)
		end))

		local FunctionHook; FunctionHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
			local Arguments = {...}
			local Method = getnamecallmethod()

			if not checkcaller() then
				if self.GetAttribute(self, "MainVM") then
					return
				end

				if Method:lower():match("^findfirst") or Method:lower():match("^waitforchild") then
					local Instance = FunctionHook(self, ...)

					if Instance and Instance.GetAttribute(Instance, "MainVM") == true then
						return
					end
				end
			end
			
			return FunctionHook(self, ...)
		end))

		-- FIX LATER
		local PropertiesHook; PropertiesHook = hookmetamethod(game, "__index", newcclosure(function(self, index)
			if not checkcaller() then
				print(self.GetAttribute(self, "MainVM"))
				if (self.GetAttribute(self, "MainVM") == true and index:lower():match("^is")) or index:lower():match("^findfirst") then
					local IndexFunction = PropertiesHook(self, index)

					if typeof(IndexFunction) == "function" then
						if not isfunctionhooked(IndexFunction) then
							local IndexFunctionHook; IndexFunctionHook = hookfunction(IndexFunction, newcclosure(function(...)
								local Arguments = {...}
								restorefunction(IndexFunction)

								local Instance = IndexFunction(self, Arguments[2])
								if Instance and Instance.GetAttribute(Instance, "MainVM") == true or self.GetAttribute(self, "MainVM") == true then
									return
								end
							end))
						end
					end
				end
				
				if self.GetAttribute(self, "MainVM") == true and typeof(PropertiesHook(self, index)) ~= "function" and not checkcaller() then
					return
				end
			end

			return PropertiesHook(self, index)
		end))

		for _, x in next, getgc() do
			if type(x) == "function" and islclosure(x) then
				local Script = getfenv(x).script

				if Script and RunningScripts[Script] then
					for _, y in next, getconstants(x) do
						if y == "WaitForChild" then
							--can't catch me
							Script.Enabled = false
							Script.Enabled = true
						end
					end
				end
			end
		end

		print("Actor bypass loaded")
	]])
end
