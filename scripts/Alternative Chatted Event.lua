--Old script I made for anti chat logger as an alternative to Player.Chatted
--This script makes it so you can use emotes by typing "emote dance" etc

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Chat = PlayerGui:FindFirstChild("Chat") 
local MessageDisplay = Chat and Chat:FindFirstChild("Frame_MessageLogDisplay", true)
local Scroller = MessageDisplay and MessageDisplay:FindFirstChild("Scroller")

local Gsub = string.gsub
local Lower = string.lower
local Split = string.split

local ChatAdded = Scroller.ChildAdded:Connect(function(x)
    local MessageTextLabel = x:FindFirstChildWhichIsA("TextLabel")
    local SenderTextButton = MessageTextLabel and MessageTextLabel:FindFirstChildWhichIsA("TextButton")
    if MessageTextLabel then
        repeat task.wait() until not MessageTextLabel.Text:match("__+")

        local Message = Gsub(MessageTextLabel.Text, "^%s+", "")
        local Sender = Gsub(SenderTextButton.Text, "[%[%]:]", "")

        if Players:FindFirstChild(Sender) then
            Sender = Players:FindFirstChild(Sender)
        else
            for _,x in next, Players:GetPlayers() do
                if Sender == x.DisplayName then
                    Sender = x
                end
            end
        end

        if type(Sender) == "string" then return end
        
        if Sender == Player then -- Target Choice
            local SplitMessage = Split(Lower(Message), " ")
            if SplitMessage[1] == "emote" then
                Players:Chat("/e "..SplitMessage[2])
            end
        end
    end
end)
