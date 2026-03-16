-- Custom R6 Character (Client-Sided)
-- Creates a fake character for yourself if you're using an alt
-- Feel free to use this if you're smart enough Lol
-- Made by AnthonyIsntHere
local ResetOnSpawn = true

local Accessories = {
    18367067759,
    1744060292,
    11748356,
    1029025,
    439945661
}

local PackageSettings = {
    ["Head"] = 15093053680,
    ["Torso"] = 0,
    ["LeftArm"] = 0,
    ["RightArm"] = 0,
    ["LeftLeg"] = 0,
    ["RightLeg"] = 139607718,

    ["HeadColor"] = Color3.fromRGB(255, 255, 204),
    ["TorsoColor"] = Color3.fromRGB(255, 255, 204),
    ["LeftArmColor"] = Color3.fromRGB(255, 255, 204),
    ["RightArmColor"] = Color3.fromRGB(255, 255, 204),
    ["LeftLegColor"] = Color3.fromRGB(255, 255, 204),
    ["RightLegColor"] = Color3.fromRGB(255, 255, 204),

    ["Shirt"] = 11334368468,
    ["Pants"] = 12116113949
}

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character ~= nil and Player.Character or Player.CharacterAppearanceLoaded:wait()

local OnSpawn = function(Character)
    Player:ClearCharacterAppearance()
    local Humanoid = Character:WaitForChild("Humanoid")
    local AppliedDesc = Humanoid:GetAppliedDescription()

    for k, v in next, PackageSettings do
        AppliedDesc[k] = v
    end

    for _, x in next, Accessories do
        local Response, Model = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(x))
        end)

        if Response and Model then
            for _, v in next, Model do
                if v:IsA("Accessory") then
                    v.Parent = Character
                end
            end
        end
    end

    Humanoid:ApplyDescriptionClientServer(AppliedDesc)
end

OnSpawn(Character)
Player.CharacterAppearanceLoaded:Connect(OnSpawn)
