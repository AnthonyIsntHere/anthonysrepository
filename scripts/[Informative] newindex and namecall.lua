--Made to assist scripters that are new to hooking metamethods
local OldIndex
local OldNamecall

--Prevents client scripts from detecting walkspeed changes made by exploit
OldIndex = hookmetamethod(game, "__newindex", function(self, index, value) --function(...) local self,index = ... etc
    if index == "WalkSpeed" and not checkcaller() then
        return
    end

    return OldIndex(self, index, value)
end)

--Prevents client scripts from calling breakjoints
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = {...}
    local Method = getnamecallmethod()

    if Method == "BreakJoints" and not checkcaller() then
        --print(Args[1])
        return
    end

    return OldNamecall(self, unpack(Args))
end)

--Old detectable method:

--[[
local Metatable = getrawmetatable(game)
local OldIndex = Metatable.__newindex
local OldNamecall = Metatable.__namecall
setreadonly(Metatable,false)

Metatable.__newindex = newcclosure(function(x,y,z)
    if y == "Health" or y == "WalkSpeed" and not checkcaller() then
        return
    end
    return OldIndex(x,y,z)
end)

Metatable.__namecall = newcclosure(function(self,...)
    if getnamecallmethod() == "BreakJoints" and not checkcaller() then
        return
    end
    return OldNamecall(self,...)
end)
]]--
