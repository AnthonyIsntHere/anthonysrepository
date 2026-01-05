-- Made by AnthonyIsntHere
-- Used for bypassing client-sided anti-cheats that detect instantiated objects
-- Fully Fixed 1.5.2026
local ProtectedInstances = {}

local _Instance = Instance.new
local _tostring = tostring

local InstanceHook; InstanceHook = hookfunction(Instance.new, newcclosure(function(...)
	if checkcaller() then
		local NewInstance = InstanceHook(...)
		sethiddenproperty(NewInstance, "DefinesCapabilities", true)
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

		if typeof(Script) == "Instance" and Script:IsA("BaseScript") then
			for _, y in next, getconstants(x) do
				if y == "WaitForChild" then
					Script.Enabled = false
					Script.Enabled = true
				end
			end
		end
	end
end

print("AnthonyIsntHere's Instance-Spoofer has loaded!")

local Actor = false
for _, Thread in next, getactorthreads() do
	run_on_thread(Thread, [[
		local _tostring = tostring

		local tostringHook; tostringHook = hookfunction(_tostring, newcclosure(function(...)
			if not checkcaller() then
				setthreadidentity(8)

				local Arguments = {...}
				local String = tostringHook(...)

				if Arguments[1] and gethiddenproperty(Arguments[1], "DefinesCapabilities") == true then
					return
				end
			end

			return tostringHook(...)
		end))

		local FunctionHook; FunctionHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
			local Arguments = {...}
			local Method = getnamecallmethod()

			if not checkcaller() then
				setthreadidentity(8)

				if gethiddenproperty(self, "DefinesCapabilities") == true then
					return
				end

				if Method:lower():match("^findfirst") or Method:lower():match("^waitforchild") then
					local Instance = FunctionHook(self, ...)

					if Instance and gethiddenproperty(Instance, "DefinesCapabilities") == true then
						return
					end
				end
			end
			
			return FunctionHook(self, ...)
		end))

		local PropertiesHook; PropertiesHook = hookmetamethod(game, "__index", newcclosure(function(self, index)		
			if not checkcaller() then
				setthreadidentity(8)
				local ProtectedInstance = gethiddenproperty(self, "DefinesCapabilities")

				if type(index) == "string" and index ~= "DefinesCapabilities" then
					if index:lower():match("^is") or index:lower():match("^findfirst") then
						local IndexFunction = PropertiesHook(self, index)

						if typeof(IndexFunction) == "function" then
							if not isfunctionhooked(IndexFunction) then
								local IndexFunctionHook; IndexFunctionHook = hookfunction(IndexFunction, newcclosure(function(...)
									local Arguments = {...}
									restorefunction(IndexFunction)

									local Instance = IndexFunction(self, Arguments[2])
									if Instance or ProtectedInstance == true then
										return
									end
								end))
							end
						end
					end
				
					if ProtectedInstance == true and typeof(PropertiesHook(self, index)) ~= "function" then
						return
					end
				end
			end

			return PropertiesHook(self, index)
		end))

		for _, x in next, getgc() do
			if type(x) == "function" and islclosure(x) then
				local Script = getfenv(x).script

				if typeof(Script) == "Instance" and Script:IsA("BaseScript") then
					for _, y in next, getconstants(x) do
						if y == "WaitForChild" then
							Script.Enabled = false
							Script.Enabled = true
						end
					end
				end
			end
		end
	]])

	if not Actor then
		Actor = true
	end
end

if Actor then
	print("Actor bypass has loaded!")
end
