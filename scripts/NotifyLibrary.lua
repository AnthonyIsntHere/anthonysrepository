-- Made by AnthonyIsntHere
-- Simple notify module
local NotifyModule = {}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

if not NotifyGui then
    getgenv().NotifyGui = Instance.new("ScreenGui")
    getgenv().Template = Instance.new("TextLabel")
    
    if syn then
        if gethui then
            gethui(NotifyGui)
        else
            syn.protect_gui(NotifyGui)
        end
    end
    
    NotifyGui.Name = "Notification"
    NotifyGui.Parent = CoreGui
    
    Template.Name = "Template"
    Template.Parent = NotifyGui
    Template.AnchorPoint = Vector2.new(.5, .5)
    Template.BackgroundTransparency = 1
    Template.BorderSizePixel = 0
    Template.Position = UDim2.new(.5, 0, 1.5, 0)
    Template.Size = UDim2.new(.8, 0, .1, 0)
    Template.Font = Enum.Font.Code
    Template.Text = ""
    Template.TextSize = 30
    Template.TextWrapped = true
end

local Tween = function(Object, Time, Style, Direction, Property)
	return TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction]), Property)
end

function NotifyModule:Notify(Text, TextColor, Duration)
    local Clone = Template:Clone()
    Clone.Name = "ClonedNotification"
    Clone.Parent = NotifyGui
    Clone.Text = Text
    Clone.TextColor3 = TextColor
    
    local FinalPosition = 0
    
    for _, x in next, NotifyGui:GetChildren() do
        if x.Name ~= "Template" then
            FinalPosition += .125
        end
    end
    
    local TweenPos = Tween(Clone, 1, "Quart", "InOut", {Position = UDim2.new(.5, 0, .95 - FinalPosition, 0)})
    TweenPos:Play()
    TweenPos.Completed:wait()
    
    wait(Duration)
    
    TweenPos = Tween(Clone, 1, "Quart", "InOut", {Position = UDim2.new(.5, 0, 1.5, 0)})
    TweenPos:Play()
    TweenPos.Completed:wait()
    
    Clone:Destroy()
end

return NotifyModule
