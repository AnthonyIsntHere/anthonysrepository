-- Made by AnthonyIsntHere
local ID = 694201337

local Settings = {
    Massplay = {
        Status = true,
        MaxAmount = 10,
    },
    Time = 0
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Character = Player.Character
local Backpack = Player.Backpack

local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false

local BoomBoxes = {}

local If_BoomBox = false

local Message = function(MTitle, MText, Time)
    StarterGui:SetCore("SendNotification",
        {
            Title = MTitle,
            Text = MText,
            Icon = "rbxassetid://2541869220",
            Duration = Time
        }
    )
end

local GetBoomBoxes = function()
    for _,x in next, Backpack:GetChildren() do
        if x:IsA("Tool") and x.Name:lower():match("boomb") then
            if not If_BoomBox then
                If_BoomBox = true
            end
            table.insert(BoomBoxes, x)
            if Settings.Massplay.Status then
                if _ == Settings.Massplay.MaxAmount then
                    break
                end
            end
        end
    end
end

if not Humanoid then return Message("Error:", "No Humanoid Found!", 5) end Humanoid:UnequipTools()
GetBoomBoxes() if not If_BoomBox then return Message("Error:", "No BoomBoxes Found!", 5) end

table.foreach(BoomBoxes, function(_, x)
    task.spawn(function()
        x.Parent = Character
        local Remote = x:FindFirstChildWhichIsA("RemoteEvent", true)
        if Remote then
            Remote:FireServer("PlaySong", ID)
        end
        x.DescendantAdded:wait() task.wait()
        x.Parent = Backpack
        local Sound = x:FindFirstChildWhichIsA("Sound", true)
        repeat task.wait() until not Sound.IsPlaying
        Sound:Play()
        Sound.TimePosition = Settings.Time
    end)
end)
