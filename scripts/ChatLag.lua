-- Made by AnthonyIsntHere
local Message = "⛓" 
local Unicode = " "
Message = Message .. Unicode:rep(200 - #Message)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SayMessageRequest = ReplicatedStorage:FindFirstChild("SayMessageRequest", true)

if SayMessageRequest then
    for i = 1, 7 do
        SayMessageRequest:FireServer(Message, "All")
    end
end
