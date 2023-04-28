-- STORE IN AUTOEXEC FOLDER
repeat wait() until game:IsLoaded()

local Settings = {
    DarkTheme = true, -- requires new bubblechat
    NewBubbleChatEnabled = true,
    BubbleChatSettings = {
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    },
    ChatSettings = {
        BubbleChatEnabled = false,
        ChatWindowBackgroundFadeOutTime = .1,
        MessageHistoryLengthPerChannel = 1000,
        PlayerDisplayNamesEnabled = false
    }
}

local ChatService = game:GetService("Chat")
local ChatModule = ChatService:WaitForChild("ClientChatModules", 1/0):WaitForChild("ChatSettings", 1/0)

if Settings.NewBubbleChatEnabled and not ChatService.BubbleChatEnabled then
    ChatService.BubbleChatEnabled = true
end

for _, x in next, Settings.ChatSettings do
    require(ChatModule)[_] = x
end

if Settings.DarkTheme and Settings.NewBubbleChatEnabled then
    for i = 1, 10 do
        pcall(ChatService.SetBubbleChatSettings, ChatService, Settings.BubbleChatSettings)
        task.wait()
    end
end
