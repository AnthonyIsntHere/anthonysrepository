-- This is my fastest bring script!

local Target = [[ AnthonyIsntHere ]]

local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local Message = function(MTitle,MText,Time)
    game:GetService("StarterGui"):SetCore("SendNotification",{Title = MTitle,Text = MText,Icon = "rbxassetid://2541869220",Duration = Time})
end

local GetPlayer = function(Name)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    Name = Name:lower():gsub("%s","")
    for _,x in next, Players:GetPlayers() do
        if x ~= LocalPlayer then
            if x.Name:lower():match(Name) then
                return x
            elseif x.DisplayName:lower():match(Name) then
                return x
            end
        end
    end
end

if not GetPlayer(Target) then
    return Message("Error:","Target not valid.")
elseif GetPlayer(Target).Name == Player.Name then
    return Message("Error:","Target is equal to Player.")
end

local PlayerMetaVars = {}
local TargetMetaVars = {}

PlayerMetaVars["Character"] = Player.Character or false
PlayerMetaVars["Humanoid"] = PlayerMetaVars["Character"] and PlayerMetaVars["Character"]:FindFirstChildOfClass("Humanoid") or false
PlayerMetaVars["RootPart"] = PlayerMetaVars["Humanoid"] and PlayerMetaVars["Humanoid"].RootPart or false
PlayerMetaVars["Head"] = PlayerMetaVars["Character"] and PlayerMetaVars["Character"]:FindFirstChild("Head") or false
PlayerMetaVars["Torso"] = PlayerMetaVars["Character"] and PlayerMetaVars["Character"]:FindFirstChild("Torso") or PlayerMetaVars["Character"] and PlayerMetaVars["Character"]:FindFirstChild("UpperTorso") or false
PlayerMetaVars["Tool"] = PlayerMetaVars["Character"] and PlayerMetaVars["Character"]:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool") or false
PlayerMetaVars["Handle"] = PlayerMetaVars["Tool"] and PlayerMetaVars["Tool"]:FindFirstChild("Handle", true) or false

TargetMetaVars["TPlayer"] = GetPlayer(Target)
TargetMetaVars["TCharacter"] = TargetMetaVars["TPlayer"].Character or false
TargetMetaVars["THumanoid"] = TargetMetaVars["TCharacter"] and TargetMetaVars["TCharacter"]:FindFirstChildOfClass("Humanoid") or false
TargetMetaVars["TRootPart"] = TargetMetaVars["THumanoid"] and TargetMetaVars["THumanoid"].RootPart or false
TargetMetaVars["THead"] = TargetMetaVars["TCharacter"] and TargetMetaVars["TCharacter"]:FindFirstChild("Head") or false

local ErrorCheck = false

for _,x in next, PlayerMetaVars do
    if not x then
        Message("Error:", _.." not valid.")
        ErrorCheck = true
    end
end

for _,x in next, TargetMetaVars do
    if not x then
        Message("Error:", "Target".._.." not valid.")
        ErrorCheck = true
    end
end

if ErrorCheck then return end

local Bring = function()
    local Time = tick()
    local OldCoordinates = PlayerMetaVars.RootPart.CFrame
    local NewHumanoid = PlayerMetaVars.Humanoid:Clone()
    
    if not (TargetMetaVars.TCharacter:FindFirstChild("Right Shoulder", true) or TargetMetaVars.TCharacter:FindFirstChild("RightWrist", true)) then
        return
    end
    
    PlayerMetaVars.Humanoid:Destroy()
    NewHumanoid.Parent = PlayerMetaVars.Character
    NewHumanoid:UnequipTools()
    PlayerMetaVars.Tool.Parent = PlayerMetaVars.Character
    
    repeat
        firetouchinterest(TargetMetaVars.TRootPart, PlayerMetaVars.Handle, 0)
        firetouchinterest(TargetMetaVars.TRootPart, PlayerMetaVars.Handle, 1)
        task.wait()
    until Time > tick() + 1 or PlayerMetaVars.Tool.Parent ~= (PlayerMetaVars.Character or Player.Backpack)
    
    --TargetMetaVars.THumanoid:SetStateEnabled("FallingDown", false)
    
    table.foreach(PlayerMetaVars.Character:GetChildren(), function(_,x)
        if x:IsA("Accessory") then
            local Handle = x:FindFirstChild("Handle")
            if Handle then Handle:Destroy() end
        end
    end)
    Player.Character = PlayerMetaVars.Character:Destroy()
    
    PlayerMetaVars.Character = Player.CharacterAdded:wait()
    repeat task.wait() until PlayerMetaVars.Character and PlayerMetaVars.Character.PrimaryPart
    PlayerMetaVars.Character:SetPrimaryPartCFrame(OldCoordinates)
end
Bring()
