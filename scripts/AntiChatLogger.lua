-- This basically makes roblox unable to log your chat messages sent in-game. Meaning if you get reported for saying something bad, you won't get banned!
-- Store in autoexec folder
-- Credits: AnthonyIsntHere

-- 4/1/2023 - Rewritten

if not game:IsLoaded() then
    game.Loaded:wait()
end

local ACL_LoadTime = tick()

local OldCoreTypeSettings = {}
local WhitelistedCoreTypes = {
    "Chat",
    "All",
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.All
}

local OldCoreSetting = nil

local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local PlayerGui = Player:FindFirstChildWhichIsA("PlayerGui") do
    if not PlayerGui then
        repeat task.wait() until Player:FindFirstChildWhichIsA("PlayerGui")
        PlayerGui = Player:FindFirstChildWhichIsA("PlayerGui")
    end
end

local Notify = function(_Title, _Text , Time)
    StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Icon = "rbxassetid://2541869220", Duration = Time})
end

local Metatable = getrawmetatable(StarterGui)
setreadonly(Metatable, false)

local CoreHook; CoreHook = hookmetamethod(StarterGui, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    
    if self == StarterGui and not checkcaller() then
        if Method == "SetCoreGuiEnabled" then
            local CoreType = Arguments[1]
            local Enabled = Arguments[2]
            
            if table.find(WhitelistedCoreTypes, CoreType) and not Enabled then
                OldCoreTypeSettings[CoreType] = Enabled
                return
            end
        elseif Method == "SetCore" then
            local Core = Arguments[1]
            local Connection = Arguments[2]
            
            if Core == "CoreGuiChatConnections" then
                OldCoreSetting = Connection
                return
            end
        end
    end
    
    return CoreHook(self, ...)
end)

local EnabledChat = task.spawn(function()
    repeat
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
        task.wait()
    until StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
end)

local WarningGuiThread = task.spawn(function()
    WarningUI = Instance.new("ScreenGui")
    Main = Instance.new("Frame")
    BackgroundHolder = Instance.new("Frame")
    Background = Instance.new("Frame")
    TopBar = Instance.new("Frame")
    UIGradient = Instance.new("UIGradient")
    TitleHolder = Instance.new("Frame")
    Title = Instance.new("TextLabel")
    Holder = Instance.new("Frame")
    UIListLayout = Instance.new("UIListLayout")
    Reason_1 = Instance.new("TextLabel")
    Reason_2 = Instance.new("TextLabel")
    Reason_3 = Instance.new("TextLabel")
    WarningText = Instance.new("TextLabel")
    Exit = Instance.new("TextButton")
    ImageLabel = Instance.new("ImageLabel")
    
    if syn then
        syn.protect_gui(WarningUI)
    end
    
    WarningUI.Enabled = false
    WarningUI.Name = "WarningUI"
    WarningUI.Parent = CoreGui
    
    Main.Name = "Main"
    Main.Parent = WarningUI
    Main.AnchorPoint = Vector2.new(.5, .5)
    Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Main.BackgroundTransparency = 1
    Main.Position = UDim2.new(.5, 0, .5, 0)
    Main.Size = UDim2.new(0, 400, 0, 400)
    
    BackgroundHolder.Name = "BackgroundHolder"
    BackgroundHolder.Parent = Main
    BackgroundHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    BackgroundHolder.BackgroundTransparency = .25
    BackgroundHolder.BorderSizePixel = 0
    BackgroundHolder.Size = UDim2.new(1, 0, 1, 0)
    
    Background.Name = "Background"
    Background.Parent = BackgroundHolder
    Background.AnchorPoint = Vector2.new(.5, .5)
    Background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Background.BorderSizePixel = 0
    Background.Position = UDim2.new(.5, 0, .5, 0)
    Background.Size = UDim2.new(.96, 0, .96, 0)
    
    TopBar.Name = "TopBar"
    TopBar.Parent = Background
    TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 2)
    
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(53, 149, 146)), ColorSequenceKeypoint.new(.29, Color3.fromRGB(93, 86, 141)), ColorSequenceKeypoint.new(.50, Color3.fromRGB(126, 64, 138)), ColorSequenceKeypoint.new(.75, Color3.fromRGB(143, 112, 112)), ColorSequenceKeypoint.new(1, Color3.fromRGB(159, 159, 80))}
    UIGradient.Parent = TopBar
    
    TitleHolder.Name = "TitleHolder"
    TitleHolder.Parent = Background
    TitleHolder.AnchorPoint = Vector2.new(.5, .5)
    TitleHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TitleHolder.BorderColor3 = Color3.fromRGB(44, 44, 44)
    TitleHolder.BorderSizePixel = 2
    TitleHolder.Position = UDim2.new(.5, 0, .5, 0)
    TitleHolder.Size = UDim2.new(.9, 0, .9, 0)
    
    Title.Name = "Title"
    Title.Parent = TitleHolder
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0, 15, 0, -12)
    Title.Size = UDim2.new(0, 75, 0, 20)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Warning"
    Title.TextColor3 = Color3.fromRGB(235, 235, 235)
    Title.TextScaled = true
    Title.TextWrapped = true
    
    Holder.Name = "Holder"
    Holder.Parent = TitleHolder
    Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Holder.BackgroundTransparency = 1
    Holder.Position = UDim2.new(0, 30, .125, 0)
    Holder.Size = UDim2.new(1, -30, .875, 0)
    
    UIListLayout.Parent = Holder
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    Reason_1.Name = "Reason_1"
    Reason_1.Parent = Holder
    Reason_1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Reason_1.BackgroundTransparency = 1
    Reason_1.BorderSizePixel = 0
    Reason_1.Size = UDim2.new(1, 0, 0, 20)
    Reason_1.Font = Enum.Font.SourceSans
    Reason_1.Text = "- TextChatService is enabled"
    Reason_1.TextColor3 = Color3.fromRGB(199, 40, 42)
    Reason_1.TextScaled = true
    Reason_1.TextWrapped = true
    Reason_1.TextXAlignment = Enum.TextXAlignment.Left
    Reason_1.Visible = false
    
    Reason_2.Name = "Reason_2"
    Reason_2.Parent = Holder
    Reason_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Reason_2.BackgroundTransparency = 1
    Reason_2.BorderSizePixel = 0
    Reason_2.Size = UDim2.new(1, 0, 0, 20)
    Reason_2.Font = Enum.Font.SourceSans
    Reason_2.Text = "- Legacy chat module was not found"
    Reason_2.TextColor3 = Color3.fromRGB(199, 40, 42)
    Reason_2.TextScaled = true
    Reason_2.TextWrapped = true
    Reason_2.TextXAlignment = Enum.TextXAlignment.Left
    Reason_2.Visible = false
    
    Reason_3.Name = "Reason_3"
    Reason_3.Parent = Holder
    Reason_3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Reason_3.BackgroundTransparency = 1
    Reason_3.BorderSizePixel = 0
    Reason_3.Size = UDim2.new(1, 0, 0, 20)
    Reason_3.Font = Enum.Font.SourceSans
    Reason_3.Text = "- MessagePosted function was not found"
    Reason_3.TextColor3 = Color3.fromRGB(199, 40, 42)
    Reason_3.TextScaled = true
    Reason_3.TextWrapped = true
    Reason_3.TextXAlignment = Enum.TextXAlignment.Left
    Reason_3.Visible = false
    
    WarningText.Name = "WarningText"
    WarningText.Parent = TitleHolder
    WarningText.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    WarningText.BackgroundTransparency = 1
    WarningText.BorderSizePixel = 0
    WarningText.Position = UDim2.new(0, 30, .05, 0)
    WarningText.RichText = true
    WarningText.Size = UDim2.new(1, -30, 0, 20)
    WarningText.Font = Enum.Font.SourceSans
    WarningText.Text = "> Anti-<font color=\"#6ea644\">Chat Logger</font> will not work here!"
    WarningText.TextColor3 = Color3.fromRGB(255, 255, 255)
    WarningText.TextScaled = true
    WarningText.TextWrapped = true
    WarningText.TextXAlignment = Enum.TextXAlignment.Left
    
    Exit.Name = "Exit"
    Exit.Parent = TitleHolder
    Exit.AnchorPoint = Vector2.new(.5, .5)
    Exit.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    Exit.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Exit.Position = UDim2.new(.5, 0, .899999976, 0)
    Exit.Size = UDim2.new(0, 250, 0, 20)
    Exit.Font = Enum.Font.SourceSans
    Exit.Text = "Ok"
    Exit.TextColor3 = Color3.fromRGB(255, 255, 255)
    Exit.TextScaled = true
    Exit.TextWrapped = true
    
    ImageLabel.Parent = TitleHolder
    ImageLabel.AnchorPoint = Vector2.new(.5, .5)
    ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(.5, 0, .6, 0)
    ImageLabel.Size = UDim2.new(.3, 0, .3, 0)
    ImageLabel.ZIndex = 1
    ImageLabel.Image = "rbxassetid://12969025384"
    ImageLabel.ImageColor3 = Color3.fromRGB(40, 40, 40)
    ImageLabel.ImageTransparency = .5
    
    Exit.MouseButton1Down:Connect(function()
        WarningUI:Destroy()
    end)
end)

if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    WarningUI.Enabled = true
    Reason_1.Visible = true
    return
end

local PlayerScripts = Player:WaitForChild("PlayerScripts")
local ChatMain = PlayerScripts:FindFirstChild("ChatMain", true) or false

if not ChatMain then
    local Timer = tick()
    
    repeat task.wait() until PlayerScripts:FindFirstChild("ChatMain", true) or tick() > (Timer + 3)
    ChatMain = PlayerScripts:FindFirstChild("ChatMain", true)
    
    if not ChatMain then
        WarningUI.Enabled = true
        Reason_2.Visible = true
        return
    end
end

local PostMessage = require(ChatMain).MessagePosted

if not PostMessage then
    WarningUI.Enabled = true
    Reason_3.Visible = true
    return
end

local MessageEvent = Instance.new("BindableEvent")
local OldFunctionHook; OldFunctionHook = hookfunction(PostMessage.fire, function(self, Message)
    if not checkcaller() and self == PostMessage then
        MessageEvent:Fire(Message)
        return
    end
    return OldFunctionHook(self, Message)
end)

if setfflag then
    setfflag("AbuseReportScreenshot", "False")
    setfflag("AbuseReportScreenshotPercentage", "0")
end -- To disallow roblox from viewing screenshots.

task.delay(1, function() WarningUI:Destroy() end)

for _, x in next, OldCoreTypeSettings do
    if not x then
        StarterGui:SetCore("ChatActive", false)
    end
    StarterGui:SetCoreGuiEnabled(_, x)
end

if OldCoreSetting then
    StarterGui:SetCore("CoreGuiChatConnections", OldCoreSetting)
end

Metatable.__namecall = CoreHook
setreadonly(Metatable, true)

Notify("🔹Anthony's ACL🔹", "Anti Chat and Screenshot Logger Loaded!", 15)
print(string.format("Anti Chat-Logger has loaded in %s seconds.", tostring(tick() - ACL_LoadTime):sub(1, 4)))
