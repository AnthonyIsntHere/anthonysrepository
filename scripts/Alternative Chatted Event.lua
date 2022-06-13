--Old script I made for anti chat logger as an alternative to Player.Chatted
--This script makes it so you can use emotes by typing "emote dance" etc

local RunService = game:GetService("RunService")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Gsub = string.gsub
local Lower = string.lower
local Split = string.split
local Pattern = "^%s+" --gets all the beginning spaces

PlayerGui.Chat.Frame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller.ChildAdded:Connect(function(x)
    if x:FindFirstChildOfClass("TextLabel") then
        repeat RunService.Heartbeat:wait() until x:FindFirstChildOfClass("TextLabel") and not x:FindFirstChildOfClass("TextLabel").Text:match("__+")
        local MessageTextLabel = x:FindFirstChildOfClass("TextLabel")
        local SenderTextButton = MessageTextLabel:FindFirstChildOfClass("TextButton")
        local Message = Gsub(MessageTextLabel.Text, Pattern, "")
        local Sender = Gsub(SenderTextButton.Text, "%p", "")
        if Players:FindFirstChild(Sender) then
            Sender = Players:FindFirstChild(Sender)
        else
            for _,x in next, Players:GetPlayers() do
                if Sender == x.DisplayName then
                    Sender = x
                end
            end
        end

        if Sender == Player then
            local SplitMessage = Split(Lower(Message), " ")
            if SplitMessage[1] == "emote" then
                Players:Chat("/e " .. SplitMessage[2])
            end
        end
    end
end)
