-- This script prevents client anti cheats from detecting guis
-- Place in autoexec folder

local MetamethodHolder = {
    AntiFlag = nil
}

MetamethodHolder.AntiFlag = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    if tostring(Method) == "PreloadAsync" and not checkcaller() then
        return
    end    
   
    return MetamethodHolder.AntiFlag(self, ...)    
end)
