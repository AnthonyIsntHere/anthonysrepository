-- Made by AnthonyIsntHere
-- Should work for TextChatService

if not game:IsLoaded() then
    game.Loaded:wait()
end

local ACL_LoadTime = tick()
local NotificationTitle = "AnthonyIsntHere's ACL 2.0"

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

local TextChannels = TextChatService:WaitForChild("TextChannels")
local Chat = TextChannels:WaitForChild("RBXGeneral")

local ExperienceChat = CoreGui:WaitForChild("ExperienceChat")
local ChatBar = ExperienceChat:FindFirstChildWhichIsA("TextBox", true) do
    if not ChatBar then
        local Timer = tick() + 5
        
        repeat task.wait() until ExperienceChat:FindFirstChildWhichIsA("TextBox", true) or (tick() > Timer)
       
        local ChatBar = ExperienceChat:FindFirstChildWhichIsA("TextBox", true) or false
        
        if not ChatBar then
            return Notify(NotificationTitle, "Failed to find ChatBar!", 10)
        end
    end
end

local TextSource = Chat:WaitForChild(tostring(Player))

local Id = Player.UserId

local Notify = function(_Title, _Text , Time)
    StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Icon = "rbxassetid://2541869220", Duration = Time})
end

if getgenv().AntiChatLogger then
    return Notify(NotificationTitle, "Anti Chat & Screenshot Logger already loaded!", 15)
else
    getgenv().AntiChatLogger = true
end

ChatBar.FocusLost:Connect(function(Entered)
    if Entered then
        local Message = ChatBar.Text
        ChatBar.Text = ""
        ChatBar:ReleaseFocus()
        
        Chat:SendAsync(Message)

        Player.UserId = 0
        sethiddenproperty(TextSource, "UserIdReplicated", 0)
        Player.UserId = Id
        sethiddenproperty(TextSource, "UserIdReplicated", Id)
    end
end)

local ChatHook; ChatHook = hookmetamethod(Players, "__namecall", newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Arguments = {...}

    if self == Players and not checkcaller() then
        if Method == "Chat" then
            return
        end
    end

    return ChatHook(self, ...)
end))

print("Anti Chat Logger has loaded.")Notify(NotificationTitle, "Anti Chat Logger Loaded!", 15)
print(string.format("AnthonyIsntHere's Anti Chat-Logger has loaded in %s seconds.", string.format("%.2f", tostring(tick() - ACL_LoadTime))))
