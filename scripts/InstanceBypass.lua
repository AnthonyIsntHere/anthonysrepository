-- Made by AnthonyIsntHere
-- Used for bypassing client-sided anti-cheats that detect instantiated objects
-- In the process of fixing 2.1.2026
local ProtectedInstances = {}

local _Instance = Instance.new
local _tostring = tostring
local MetatableInfo, MetatableInfo

local InstanceHook; InstanceHook = hookfunction(Instance.new, clonefunction(newcclosure(function(...)
	if checkcaller() then
		local NewInstance = InstanceHook(...)
		sethiddenproperty(NewInstance, "DefinesCapabilities", true)
		ProtectedInstances[NewInstance] =  true

        if Metatable and Metamethods then
            Metatable.__namecall = Metamethods.__namecall
            Metatable.__index = Metamethods.__index
        end

        Metatable = getrawmetatable(NewInstance)
        Metamethods = {
            __namecall = Metatable.__namecall,
            __index = Metatable.__index
        }
        
        setreadonly(Metatable, false)
        Metatable.__namecall = clonefunction(function(self, ...)
            if not checkcaller() then
                local Arguments = {...}
                local Method = getnamecallmethod()

                if ProtectedInstances[self] then
                    return
                end

                if typeof(Method) == "string" and Method:lower():match("^findfirst") or Method:lower():match("^waitforchild") then
                    local Instance = Metamethods.__namecall(self, ...)

                    if Instance and ProtectedInstances[Instance] then
                        return
                    end
                end
            end

            return Metamethods.__namecall(self, ...)
        end)

        Metatable.__index = clonefunction(function(self, index)
            if not checkcaller() then
                if typeof(index) == "string" and ((ProtectedInstances[self] and index:lower():match("^is")) or index:lower():match("^findfirst")) then
                    local IndexFunction = Metamethods.__index(self, index)

                    if typeof(IndexFunction) == "function" and not isfunctionhooked(IndexFunction) then
                        local IndexFunctionHook; IndexFunctionHook = hookfunction(IndexFunction, clonefunction(newcclosure(function(...)
                            local Arguments = {...}
                            restorefunction(IndexFunction)

                            local Instance = IndexFunction(self, Arguments[2])
                            if Instance and ProtectedInstances[Instance] or ProtectedInstances[self] then
                                return
                            end
                        end)))
                    end
                end
            end

            if ProtectedInstances[self] and typeof(Metamethods.__index(self, index)) ~= "function" and not checkcaller() then
                return
            end

            return Metamethods.__index(self, index)
        end)

		return NewInstance
	end

	return InstanceHook(...)
end)))

local tostringHook; tostringHook = hookfunction(_tostring, clonefunction(newcclosure(function(...)
	if not checkcaller() then
		local Arguments = {...}
		local String = tostringHook(...)

		if ProtectedInstances[Arguments[1]] then
			return
		end
	end

	return tostringHook(...)
end)))

local GetConstant = function(f, v)
    for _, Constant in next, debug.getconstants(f) do
        if not rawequal(Constant, v) then continue end
        return true
    end

    return false
end

for _, x in next, getreg() do -- Anbubu and Secment are amazing people <3
    local Function = type(x) == "thread" and coroutine.status(x) == "suspended" and debug.info(x, 1, "f")
    local ScriptInstance = Function and getfenv(Function) and typeof(getfenv(Function).script) == "Instance"

    if not Function or not ScriptInstance then continue end
    if GetConstant(Function, "WaitForChild") then
        task.cancel(x)
    end
end

local Actor = false
for _, Thread in next, getactorthreads() do
	run_on_thread(Thread, [[
        local RawMT = getrawmetatable(gethui())
        local PreviousNamecall = RawMT.__namecall
        local PreviousIndex = RawMT.__index

        local _tostring = tostring

        local tostringHook; tostringHook = hookfunction(_tostring, clonefunction(newcclosure(function(...)
            if not checkcaller() then
                setthreadidentity(8)

                local Arguments = {...}
                local String = tostringHook(...)

                if Arguments[1] and PreviousIndex(Arguments[1], "DefinesCapabilities") == true then
                    return
                end
            end

            return tostringHook(...)
        end)))

        setreadonly(RawMT, false)
        RawMT.__namecall = clonefunction(function(self, ...)
            local Arguments = {...}
            local Method = getnamecallmethod()

            if not checkcaller() then
                setthreadidentity(8)

                if PreviousIndex(self, "DefinesCapabilities") then
                    return
                end

                if typeof(Method) == "string" and Method:lower():match("^findfirst") or Method:lower():match("^waitforchild") then
                    local Instance = PreviousNamecall(self, ...)

                    if Instance and PreviousIndex(Instance, "DefinesCapabilities") then
                        return
                    end
                end
            end
            
            return PreviousNamecall(self, ...)
        end)

        RawMT.__index = clonefunction(function(self, index)		
            if not checkcaller() then
                setthreadidentity(8)

                local ProtectedInstance = PreviousIndex(self, "DefinesCapabilities")

                if typeof(index) == "string" and index ~= "DefinesCapabilities" then
                    if index:lower():match("^is") or index:lower():match("^findfirst") then
                        local IndexFunction = PreviousIndex(self, index)

                        if typeof(IndexFunction) == "function" then
                            if not isfunctionhooked(IndexFunction) then
                                local IndexFunctionHook; IndexFunctionHook = hookfunction(IndexFunction, clonefunction(newcclosure(function(...)
                                    local Arguments = {...}
                                    restorefunction(IndexFunction)

                                    local Instance = IndexFunction(self, Arguments[2])
                                    if Instance or ProtectedInstance then
                                        return
                                    end
                                end)))
                            end
                        end
                    end
                
                    if ProtectedInstance == true and typeof(PreviousIndex(self, index)) ~= "function" then
                        return
                    end
                end
            end

            return PreviousIndex(self, index)
        end)
        setreadonly(RawMT, true)

        local GetConstant = function(f, v)
            for _, Constant in next, debug.getconstants(f) do
                if not rawequal(Constant, v) then continue end
                return true
            end

            return false
        end

        for _, x in next, getreg() do
            local Function = type(x) == "thread" and coroutine.status(x) == "suspended" and debug.info(x, 1, "f")
            local ScriptInstance = Function and getfenv(Function) and typeof(getfenv(Function).script) == "Instance"

            if not Function or not ScriptInstance then continue end
            if GetConstant(Function, "WaitForChild") then
                task.cancel(x)
            end
        end
	]])

	Actor = not Actor or true
end

local LoadedThread = task.spawn(function()
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera

    local CreateNotification = function(Text, YOffset, Delay)
        local Notification = Drawing.new("Text") do
            Notification.Text = Text
            Notification.Size = 20
            Notification.Outline = true
            Notification.Color = Color3.fromRGB(200, 200, 200)
            Notification.Visible = true
        end

        local ScreenSize = Camera and Camera.ViewportSize
        if not ScreenSize then
            YOffset = 60 - YOffset
        end

        Notification.Position = ScreenSize and ScreenSize - Vector2.new(Notification.TextBounds.X + 20, Notification.TextBounds.Y + YOffset) or Vector2.new(20, YOffset)

        task.delay(type(Delay) == "number" and Delay or 5, function()
            if Notification then
                Notification:Remove()
                Notification = nil
            end
        end)

        return Notification
    end

    local Notification1 = CreateNotification("AnthonyIsntHere's Instance-Bypass (Protection) has been loaded", 40)

    if Actor then
        local Notification2 = CreateNotification("Loaded for Actor Threads", 20)
    end
end)
