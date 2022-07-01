-- This is more of an old script.
-- Requires Tools

local Message = function(MTitle,MText,Time)
    game:GetService("StarterGui"):SetCore("SendNotification",{Title = MTitle,Text = MText,Icon = "rbxassetid://2541869220",Duration = Time})
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid
local RootPart
local Head

local RigType

if not Character or Character == nil or Character.Name ~= Player.Name then return Message("Error:","Character not valid.") end
if Character:FindFirstChildOfClass("Humanoid") then
    Humanoid = Character:FindFirstChildOfClass("Humanoid") else return Message("Error:","Humanoid not valid.") end
if Humanoid and Humanoid["RootPart"] then
    RootPart = Humanoid.RootPart else return Message("Error:","RootPart not valid.") end
if Character:FindFirstChild("Head") then 
    Head = Character.Head else return Message("Error:","Head not valid.") end
if Humanoid.RigType == Enum.HumanoidRigType.R6 then
    RigType = "R6" elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then RigType = "R15" end

local OldGripVals = {}

Humanoid:UnequipTools()
for _,x in next, Player.Backpack:GetChildren() do
    if x:IsA("Tool") then
        if x:FindFirstChild("Handle") then
            x.Handle.Massless = true
        end
        table.insert(OldGripVals, x.Grip)
        x.Grip = CFrame.new(5000,6000,2000)
        x.Parent = Character
        x.Unequipped:Connect(function()
            x.Grip = OldGripVals[_]
        end)
    end
end
