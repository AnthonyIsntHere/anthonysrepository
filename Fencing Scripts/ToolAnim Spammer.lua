local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character

local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")

Humanoid:UnequipTools()

for _, x in next, Player.Backpack:GetChildren() do
    if x:IsA("Tool") and tostring(x):lower():match("foil") then
        x.Parent = Character
    end
end

for i = 1, 2 do
    for _, x in next, Character:GetChildren() do
        if x:IsA("Tool") and tostring(x):lower():match("foil") then
            local handle = x:FindFirstChild("Handle")

            x.RequiresHandle = false

            if handle then
                handle.Name = "deez nuts"
            end

            x:Activate()
        end
    end
    wait()
end
