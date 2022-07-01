-- This script makes it so that whenever you attach to your target, you are giving them properties from your client that replicate to the server.
-- Credits to r_aincloud/riptxde for showing it to me back in 2019!

local Target = [[ AnthonyIsntHere ]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local function Message(MTitle,MText,Time)
    game:GetService("StarterGui"):SetCore("SendNotification",{Title = MTitle,Text = MText,Icon = "rbxassetid://2541869220",Duration = Time})
end

local function GetPlayer(Name)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    Name = Name:lower():gsub(" ","")
    for _,x in next, Players:GetPlayers() do
        if x ~= LocalPlayer then
            if x.Name:lower():match("^"..Name) then
                return x
            elseif x.DisplayName:lower():match("^"..Name) then
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

local Claim = function()
    local Old = PlayerMetaVars.RootPart.CFrame
    PlayerMetaVars.Humanoid:Destroy()
    local NewHumanoid = PlayerMetaVars.Humanoid:Clone()
    NewHumanoid.Parent = PlayerMetaVars.Character
    NewHumanoid:UnequipTools()
    PlayerMetaVars.Tool.Parent = PlayerMetaVars.Character
    PlayerMetaVars.RootPart.CFrame = TargetMetaVars.TRootPart.CFrame
    RunService.Heartbeat:wait()
    local TempOld = PlayerMetaVars.RootPart.CFrame
    PlayerMetaVars.RootPart.Velocity = Vector3.new()
    PlayerMetaVars.RootPart.CFrame = TempOld * CFrame.Angles(math.rad(90),0,0)
    firetouchinterest(TargetMetaVars.TRootPart, PlayerMetaVars.Handle, 0)
    PlayerMetaVars.Tool.AncestryChanged:wait()
    TargetMetaVars.THumanoid:SetStateEnabled("FallingDown", false)
    --TargetMetaVars.THumanoid:ChangeState("Dead") --DOESN'T WORK SO WELL XD
    TargetMetaVars.THumanoid.WalkSpeed = 100
    TargetMetaVars.THumanoid.JumpPower = 150
    PlayerMetaVars.Character = Player.CharacterAdded:wait()
    repeat RunService.Heartbeat:wait() until PlayerMetaVars.Character and PlayerMetaVars.Character.PrimaryPart
    RunService.Heartbeat:wait()
    PlayerMetaVars.Character:SetPrimaryPartCFrame(Old)
end
Claim()
