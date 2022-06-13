--<Shorten Player Username>

local Target = [[ AnthonyIsntHere ]]

local GetPlayer = function(Name)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    Name = Name:lower():gsub("%s", "")
    for _,x in next, Players:GetPlayers() do
        if x ~= LocalPlayer then
            if x.Name:lower():match(Name) then
                return x
            elseif x.DisplayName:lower():match("^" .. Name) then
                return x
            end
        end
    end
end

pcall(function()
    game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = GetPlayer(Target).Character.Humanoid.RootPart.CFrame
end)
