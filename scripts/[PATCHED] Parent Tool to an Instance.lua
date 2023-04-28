-- Patched
--- // Drop tool (might have to firetouhcinterest to give to others)
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local Check = function(Name, ...)
    if not ... then
        return StarterGui:SetCore("SendNotification", {Title = "Error", Text = string.format("%s is invalid.", Name), Icon = "rbxassetid://2541869220", Duration = 5}) 
    else
        return ...
    end
end

local Player = Players.LocalPlayer
local Backpack = Player.Backpack
local Character = Check("Character", Player.Character)
local Humanoid = Check("Humanoid", Character and Character:FindFirstChildWhichIsA("Humanoid"))

local RightArm = Check("Right Arm", Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand"))

local Tool = Check("Tool", Character and Character:FindFirstChildWhichIsA("Tool") or Backpack:FindFirstChildWhichIsA("Tool"))
local Handle = Check("Handle", Tool and Tool:FindFirstChild("Handle"))

Humanoid:UnequipTools()

Tool.Parent = Character
Tool.Parent = Player
Tool.Parent = Backpack
Tool.Parent = RightArm
