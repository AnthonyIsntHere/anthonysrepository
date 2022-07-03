-- This script prevents roblox from logging your chat messages, which means you won't be banned for saying bad stuff!
-- Put script in autoexec folder and join a game.

if not game:IsLoaded() then
    game.Loaded:wait()
end

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Notify = function(_Title, _Text , Time)
    StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Icon = "rbxassetid://2541869220", Duration = Time})
end

local OldTime = tick()
repeat task.wait() until StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) or tick() > OldTime + 10

local PostMessage = require(Player:WaitForChild("PlayerScripts"):WaitForChild("ChatScript"):WaitForChild("ChatMain")).MessagePosted
local MessageEvent = Instance.new("BindableEvent")

local OldFunctionHook
local PostMessageHook = function(self, Message)
    if not checkcaller() and self == PostMessage then
        MessageEvent:Fire(Message)
        return
    end
    return OldFunctionHook(self, Message)
end
OldFunctionHook = hookfunction(PostMessage.fire, PostMessageHook)

if setfflag then
    setfflag("AbuseReportScreenshot", "False")
    setfflag("AbuseReportScreenshotPercentage", 0)
end

Notify("Loaded Successfully", "Anti Chat and Screenshot Logger Loaded!", 15)
