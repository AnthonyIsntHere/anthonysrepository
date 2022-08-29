-- Dupes sprays for you on fencing
-- https://www.roblox.com/games/12109643/Fencing

local Amount = 15

local Players = game:GetService("Players")
local Touch = firetouchinterest

local SprayHandle = workspace:FindFirstChild("Handle")
local Tools = {}

local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local RootPart = Humanoid.RootPart

local OldPos = RootPart.CFrame
local Iterator = 0

local DropSprays = function()
    Humanoid:UnequipTools()
    for _,x in next, Player.Backpack:GetChildren() do
        if x:IsA("Tool") and x.Name:match("Spray") then
            x.Parent = Character
            x.Parent = workspace
        end
    end
end

local EquipSprays = function()
    for _,x in next, workspace:GetChildren() do
        if x:IsA("Tool") and x.Name:match("Spray") then
            Humanoid:EquipTool(x)
        end
    end
end

RootPart.Velocity = Vector3.new()
RootPart.CFrame = CFrame.new(0, 500000, 0)
repeat wait(.1) until (RootPart.Position - OldPos.p).Magnitude >= 100000
RootPart.Anchored = true

repeat
    Iterator += 1
    
    DropSprays()
    
    Touch(SprayHandle, RootPart, 0)
    Touch(SprayHandle, RootPart, 1)
    
    local CurrentSpray = Character.ChildAdded:wait()
    task.wait()
    
    if CurrentSpray:IsA("Tool") and CurrentSpray.Name:match("Spray") then
        table.insert(Tools, CurrentSpray)
    end
    
    for _,x in next, Character:GetChildren() do
        if x:IsA("Tool") and x.Name:match("Spray") then
            x.Parent = workspace
        end
    end
    
    if tostring(Iterator):match("%d0+") then
        warn(1)
        EquipSprays()
        wait(.25)
    end
until #Tools >= Amount

EquipSprays()
RootPart.Anchored = false
RootPart.CFrame = OldPos
