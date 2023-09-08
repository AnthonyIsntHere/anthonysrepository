-- Made by AnthonyIsntHere
-- Basically this just allows you to hide stuff on your client
-- Common use: bypass any client anti-cheat fly/fling detection (hides bodymovers)

local Protected_Instances = {}

local ProtectHook; ProtectHook = hookmetamethod(game, "__namecall", function(self, ...)
    if table.find(Protected_Instances, self) and not checkcaller() then
        return nil
    end
    
    return ProtectHook(self, ...)
end)

local ClassNameHook; ClassNameHook = hookmetamethod(game, "__index", function(self, index)
    if index == "ClassName" and table.find(Protected_Instances, self) and not checkcaller() then
        return nil
    end

    return ClassNameHook(self, index)
end)

local InstanceHook; InstanceHook = hookfunction(Instance.new, function(...)
    local Arguments = {...}

    if checkcaller() and Arguments[1] then
        local CurrentInst = InstanceHook(...)
        table.insert(Protected_Instances, CurrentInst)
        return CurrentInst
    end

    return InstanceHook(...)
end)
