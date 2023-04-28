-- Made in 2 minutes, don't feel like improving cuz lazy
-- This isn't detected on most games, unless they have some shitty anti cheat that detects you setting velocity on other players
-- Laggy on big servers

while true do
    for _,x in next, game:GetService("Players"):GetPlayers() do
        if x and x ~= game:GetService("Players").LocalPlayer and x.Character then
            pcall(function()
                for _,v in next, x.Character:GetChildren() do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                        if v.Name == "Torso" then
                            v.Massless = true
                        end
                        v.Velocity = Vector3.new()
                        v.RotVelocity = Vector3.new()
                    end
                end
            end)
        end
    end
    game:GetService("RunService").Stepped:wait()
end
