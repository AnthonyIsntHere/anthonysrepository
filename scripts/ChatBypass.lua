-- Execute and say bad words to your hearts content! You can also add more if you know a bit of lua and how this works lol
-- Made by AnthonyIsntHere and DecayedK!
-- Anyone who says otherwise is stupid :p
local Bypasses = {
    ["ass"] = "as{{aieixzvzx:s}}",
    ["asshole"] = "as{{aieixzvzx:shole}}",
    ["bitch"] = "bit{{aieixzvzx:ch}}",
    ["cock"] = "co{{aieixzvzx:ck}}",
    ["cunt"] = "cu{{aieixzvzx:nt}}",
    ["dick"] = "di{{zczxczvz:ck}}",
    ["dyke"] = "dy{{aieixzvzx:ke}}",
    ["faggot"] = "fa{{aieixzvzx:ggot}}",
    ["fuck"] = "fu{{aieixzvzx:ck}}",
    ["gaylord"] = "gayl{{aieixzvzx:ord}}",
    ["kike"] = "ki{{aieixzvzx:ke}}",
    ["motherfucker"] = "motherf{{aieixzvzx:ucker}}",
    ["nigga"] = "ni{{aieixzvzx:gga}}",
    ["nigger"] = "ni{{aieixzvzx:gger}}",
    ["piss"] = "p{{aieixzvzx:iss}}",
    ["penis"] = "pe{{aieixzvzx:nis}}",
    ["pussy"] = "pu{{aieixzvzx:ssy}}",
    ["shit"] = "sh{{aieixzvzx:it}}",
    ["slut"] = "sl{{aieixzvzx:ut}}",
    ["whore"] = "who{{aieixzvzx:re}}",
    ["discord"] = "disco{{aieixzvzx:rd}}",
    ["kys"] = "k{{aieixzvzx:ys}}",
    ["kill"] = "ki{{aieixzvzx:ll}}"
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage:FindFirstChild("SayMessageRequest", true)

local ChatBypass; ChatBypass = hookmetamethod(Remote, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    
    if self == Remote and Method == "FireServer" then
        local Message = Arguments[1]
        local Split = Message:split(" ")
        local FinalMessage = ""

        for _, x in next, Split do
            for _, Bypass in next, Bypasses do
                if x:lower() == _ then
                    if x:upper() ~= x then
                        Message = Message:gsub(x, Bypass)
                        FinalMessage = Message .. " ng"
                    else
                        Message = Message:gsub(x, Bypass):upper()
                        FinalMessage = Message:gsub(x, Bypass):upper() .. " ng"
                    end
                end
            end
        end
        
        if FinalMessage ~= "" then
            Arguments[1] = FinalMessage
        end
        
        return ChatBypass(self, unpack(Arguments))
    end
    
    return ChatBypass(self, ...)
end)
