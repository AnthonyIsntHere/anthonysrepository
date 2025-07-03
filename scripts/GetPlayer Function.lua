-- Get Player Function by AnthonyIsntHere

local Target = "ArianWhiite"

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local GetPlayer = function(Name)
    if type(Name) ~= "string" then
        return false
    end

    for _, x in next, Players:GetPlayers() do
        if x ~= Player then
            local MatchedName = table.concat({"^", Name})

            local Username = tostring(x):lower()
            local DisplayName = x.DisplayName:lower()

            if Username:match(MatchedName) or DisplayName:match(MatchedName) then
                return x
            end
        end
    end

    return false
end

local TargetPlayer = GetPlayer(Target)
print(tostring(TargetPlayer))
