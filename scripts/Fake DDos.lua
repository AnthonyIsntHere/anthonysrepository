-- Fake ddos script
-- Made by AnthonyIsntHere
local TimeToWait = 5

local CoreGui = game:GetService("CoreGui")
local RobloxPromptGui = CoreGui:WaitForChild("RobloxPromptGui")

settings():GetService("NetworkSettings").IncomingReplicationLag = 1/0

RobloxPromptGui.DescendantAdded:Connect(function(x)
    if tostring(x):match("ErrorMessage") and x:IsA("TextLabel") then
        x.Text = "Please check your internet connection and try again.\n(Error Code: 277)"
        local t; t = x:GetPropertyChangedSignal("Text"):Connect(function()
            x.Text = "Please check your internet connection and try again.\n(Error Code: 277)"
        end)
    end
end)

task.wait(TimeToWait)
game:GetService("Players").LocalPlayer:Remove()
settings():GetService("NetworkSettings").IncomingReplicationLag = 0
