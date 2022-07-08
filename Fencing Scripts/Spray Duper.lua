local Amount = 25

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local RootPart = Humanoid.RootPart

local FireTI = firetouchinterest

local SprayHandle = workspace:FindFirstChild("Handle")
local OldPos = RootPart.CFrame

local DropSprays = function()
    Humanoid:UnequipTools()
    for _,x in next, Player.Backpack:GetChildren() do
        if x:IsA("Tool") and x.Name == "Spray" then
            x.Parent = Character
            x.Parent = workspace
        end
    end
end

local EquipSprays = function()
    for _,x in next, workspace:GetChildren() do
        if x:IsA("Tool") and x.Name == "Spray" then
            Humanoid:EquipTool(x)
        end
    end
end

RootPart.Velocity = Vector3.new()
RootPart.CFrame = CFrame.new(0, 500000, 0)
repeat wait(.1) until (RootPart.Position - OldPos.p).Magnitude >= 100000
RootPart.Anchored = true

for i = 1, Amount do
    DropSprays()
    repeat
        FireTI(SprayHandle, RootPart, 0)
        FireTI(SprayHandle, RootPart, 1)
        task.wait()
    until Character:FindFirstChild("Spray")
    for _,x in next, Character:GetChildren() do
        if x:IsA("Tool") and x.Name == "Spray" then
            x.Parent = workspace
        end
    end
    if tostring(i):match("%d0+") then
        EquipSprays()
        wait(.5)
    end
end

EquipSprays()
RootPart.Anchored = false
RootPart.CFrame = OldPos
