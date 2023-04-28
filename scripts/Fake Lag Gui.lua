-- Fake Lag Gui 
-- Made by AnthonyIsntHere
-- Not my proudest gui LOL

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local NotiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/main/scripts/NotifyLibrary.lua"))()

local Tween = function(Object, Time, Style, Direction, Property)
	return TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction]), Property)
end

local Drag = function(GuiObject, Time, Style, Direction)
    task.spawn(function()
        local Dragging
        local DragInput
        local DragStart = Vector3.new()
        local StartPosition
        
        local Update = function(Input)
            local Delta = Input.Position - DragStart
            local Position = UDim2.new(StartPosition.X.Scale,StartPosition.X.Offset + Delta.X,StartPosition.Y.Scale,StartPosition.Y.Offset + Delta.Y)
            Tween(GuiObject, Time, Style, Direction, {Position = Position}):Play()
        end
        
        GuiObject.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = GuiObject.Position
                
                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)
        
        GuiObject.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                DragInput = Input
            end
        end)

		UserInputService.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				Update(Input)
			end
		end)
	end)
end

local Main = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Background = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ButtonHolder = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local PropertyFrame_1 = Instance.new("Frame")
local FpsTitle = Instance.new("TextLabel")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local UICorner = Instance.new("UICorner")
local ListDecor_1 = Instance.new("TextLabel")
local Switch_1 = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local SwitchIcon_1 = Instance.new("Frame")
local UICorner_3 = Instance.new("UICorner")
local PropertyFrame_2 = Instance.new("Frame")
local PingTitle = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local UICorner_4 = Instance.new("UICorner")
local ListDecor_2 = Instance.new("TextLabel")
local Switch_2 = Instance.new("Frame")
local UICorner_5 = Instance.new("UICorner")
local SwitchIcon_2 = Instance.new("Frame")
local UICorner_6 = Instance.new("UICorner")
local Exit = Instance.new("TextButton")

if not syn then
    NotiLib:Notify("You are not using Synapse, however you may still use this script. Just be aware of client sided anticheats.", 5)
else
    syn.protect_gui(Main)
end

Drag(MainFrame, .1, "Quint", "Out")

Main.Name = "Main"
Main.Parent = CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = Main
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 150)

Background.Name = "Background"
Background.Parent = MainFrame
Background.AnchorPoint = Vector2.new(0.5, 0.5)
Background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Background.BorderColor3 = Color3.fromRGB(115, 0, 255)
Background.Position = UDim2.new(0.5, 0, 0.5, 0)
Background.Size = UDim2.new(0, 300, 0, 100)

Title.Name = "Title"
Title.Parent = Background
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0.5, 0, 0, 0)
Title.Size = UDim2.new(0, 100, 0, 50)
Title.Font = Enum.Font.TitilliumWeb
Title.Text = "Fake Lag"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 30.000
Title.TextWrapped = true

ButtonHolder.Name = "ButtonHolder"
ButtonHolder.Parent = Background
ButtonHolder.AnchorPoint = Vector2.new(0.5, 0.5)
ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonHolder.BackgroundTransparency = 1.000
ButtonHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
ButtonHolder.Size = UDim2.new(0.899999976, 0, 0.600000024, 0)

UIListLayout.Parent = ButtonHolder
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

PropertyFrame_1.Name = "PropertyFrame_1"
PropertyFrame_1.Parent = ButtonHolder
PropertyFrame_1.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
PropertyFrame_1.BorderSizePixel = 0
PropertyFrame_1.Size = UDim2.new(1, 0, 0, 25)

FpsTitle.Name = "FpsTitle"
FpsTitle.Parent = PropertyFrame_1
FpsTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FpsTitle.BackgroundTransparency = 1.000
FpsTitle.BorderSizePixel = 0
FpsTitle.Position = UDim2.new(0.0900000036, 0, 0, 0)
FpsTitle.Size = UDim2.new(0.910000026, 0, 1, 0)
FpsTitle.Font = Enum.Font.Nunito
FpsTitle.Text = "Fps"
FpsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsTitle.TextSize = 14.000
FpsTitle.TextXAlignment = Enum.TextXAlignment.Left

UITextSizeConstraint.Parent = FpsTitle
UITextSizeConstraint.MaxTextSize = 50
UITextSizeConstraint.MinTextSize = 20

UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = PropertyFrame_1

ListDecor_1.Name = "ListDecor_1"
ListDecor_1.Parent = PropertyFrame_1
ListDecor_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ListDecor_1.BackgroundTransparency = 1.000
ListDecor_1.Size = UDim2.new(0, 25, 1, 0)
ListDecor_1.Font = Enum.Font.SourceSans
ListDecor_1.Text = "・"
ListDecor_1.TextColor3 = Color3.fromRGB(255, 255, 255)
ListDecor_1.TextScaled = true
ListDecor_1.TextSize = 14.000
ListDecor_1.TextTransparency = 0.500
ListDecor_1.TextWrapped = true

Switch_1.Name = "Switch_1"
Switch_1.Parent = PropertyFrame_1
Switch_1.AnchorPoint = Vector2.new(0.5, 0.5)
Switch_1.BackgroundColor3 = Color3.fromRGB(255, 25, 29)
Switch_1.Position = UDim2.new(0.899999976, 0, 0.5, 0)
Switch_1.Size = UDim2.new(0.119999997, 0, 0.699999988, 0)

UICorner_2.CornerRadius = UDim.new(2, 0)
UICorner_2.Parent = Switch_1

SwitchIcon_1.Name = "SwitchIcon_1"
SwitchIcon_1.Parent = Switch_1
SwitchIcon_1.AnchorPoint = Vector2.new(0.5, 0.5)
SwitchIcon_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SwitchIcon_1.BorderSizePixel = 0
SwitchIcon_1.Position = UDim2.new(0.29, 0, 0.49, 0)
SwitchIcon_1.Size = UDim2.new(0, 14, 0, 14)

UICorner_3.CornerRadius = UDim.new(2, 0)
UICorner_3.Parent = SwitchIcon_1

PropertyFrame_2.Name = "PropertyFrame_2"
PropertyFrame_2.Parent = ButtonHolder
PropertyFrame_2.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
PropertyFrame_2.BorderSizePixel = 0
PropertyFrame_2.Size = UDim2.new(1, 0, 0, 25)

PingTitle.Name = "PingTitle"
PingTitle.Parent = PropertyFrame_2
PingTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PingTitle.BackgroundTransparency = 1.000
PingTitle.BorderSizePixel = 0
PingTitle.Position = UDim2.new(0.0900000036, 0, 0, 0)
PingTitle.Size = UDim2.new(0.910000026, 0, 1, 0)
PingTitle.Font = Enum.Font.Nunito
PingTitle.Text = "Ping"
PingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PingTitle.TextSize = 14.000
PingTitle.TextXAlignment = Enum.TextXAlignment.Left

UITextSizeConstraint_2.Parent = PingTitle
UITextSizeConstraint_2.MaxTextSize = 50
UITextSizeConstraint_2.MinTextSize = 20

UICorner_4.CornerRadius = UDim.new(0, 5)
UICorner_4.Parent = PropertyFrame_2

ListDecor_2.Name = "ListDecor_2"
ListDecor_2.Parent = PropertyFrame_2
ListDecor_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ListDecor_2.BackgroundTransparency = 1.000
ListDecor_2.Size = UDim2.new(0, 25, 1, 0)
ListDecor_2.Font = Enum.Font.SourceSans
ListDecor_2.Text = "・"
ListDecor_2.TextColor3 = Color3.fromRGB(255, 255, 255)
ListDecor_2.TextScaled = true
ListDecor_2.TextSize = 14.000
ListDecor_2.TextTransparency = 0.500
ListDecor_2.TextWrapped = true

Switch_2.Name = "Switch_2"
Switch_2.Parent = PropertyFrame_2
Switch_2.AnchorPoint = Vector2.new(0.5, 0.5)
Switch_2.BackgroundColor3 = Color3.fromRGB(255, 25, 29)
Switch_2.Position = UDim2.new(0.899999976, 0, 0.5, 0)
Switch_2.Size = UDim2.new(0.119999997, 0, 0.699999988, 0)

UICorner_5.CornerRadius = UDim.new(2, 0)
UICorner_5.Parent = Switch_2

SwitchIcon_2.Name = "SwitchIcon_2"
SwitchIcon_2.Parent = Switch_2
SwitchIcon_2.AnchorPoint = Vector2.new(0.5, 0.5)
SwitchIcon_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SwitchIcon_2.BorderSizePixel = 0
SwitchIcon_2.Position = UDim2.new(0.29, 0, 0.49, 0)
SwitchIcon_2.Size = UDim2.new(0, 14, 0, 14)

UICorner_6.CornerRadius = UDim.new(2, 0)
UICorner_6.Parent = SwitchIcon_2

Exit.Name = "Exit"
Exit.Parent = MainFrame
Exit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Exit.BackgroundTransparency = 1.000
Exit.BorderSizePixel = 0
Exit.Position = UDim2.new(0.930000007, 0, 0, 0)
Exit.Size = UDim2.new(0, 25, 0, 25)
Exit.Font = Enum.Font.TitilliumWeb
Exit.Text = "X"
Exit.TextColor3 = Color3.fromRGB(255, 255, 255)
Exit.TextScaled = true
Exit.TextSize = 14.000
Exit.TextWrapped = true

local FpsDebounce = false
local PingDebounce = false

Switch_1.InputBegan:Connect(function(InputObj)
    if InputObj.UserInputType == Enum.UserInputType.MouseButton1 then
        if not FpsDebounce then
            FpsDebounce = true
            Tween(Switch_1, .25, "Quint", "InOut", {BackgroundColor3 = Color3.fromRGB(25, 255, 29)}):Play()
            Tween(SwitchIcon_1, .25, "Quart", "InOut", {Position = UDim2.new(0.69, 0, 0.49, 0)}):Play()
            task.spawn(function()
                while FpsDebounce do
                    if Player.Character and Player.Character:FindFirstChildWhichIsA("Humanoid") and Player.Character:FindFirstChildWhichIsA("Humanoid").RootPart then
                        sethiddenproperty(Player.Character:FindFirstChildWhichIsA("Humanoid").RootPart, "DraggingV1", true)
                        wait()
                        sethiddenproperty(Player.Character:FindFirstChildWhichIsA("Humanoid").RootPart, "DraggingV1", false)
                    end
                    wait()
                end
            end)
        else
            FpsDebounce = false
            Tween(Switch_1, .25, "Quint", "Out", {BackgroundColor3 = Color3.fromRGB(255, 25, 29)}):Play()
            Tween(SwitchIcon_1, .25, "Quart", "Out", {Position = UDim2.new(0.29, 0, 0.49, 0)}):Play()
            if Player.Character and Player.Character:FindFirstChildWhichIsA("Humanoid") and Player.Character:FindFirstChildWhichIsA("Humanoid").RootPart then
                sethiddenproperty(Player.Character:FindFirstChildWhichIsA("Humanoid").RootPart, "DraggingV1", false)
            end
        end
    end
end)

Switch_2.InputBegan:Connect(function(InputObj)
    if InputObj.UserInputType == Enum.UserInputType.MouseButton1 then
        if not PingDebounce then
            PingDebounce = true
            Tween(Switch_2, .25, "Quint", "InOut", {BackgroundColor3 = Color3.fromRGB(25, 255, 29)}):Play()
            Tween(SwitchIcon_2, .25, "Quint", "InOut", {Position = UDim2.new(0.69, 0, 0.49, 0)}):Play()
            task.spawn(function()
                while PingDebounce do
                    if Player.Character and Player.Character:FindFirstChild("Head") then
                        OldSize = Player.Character:FindFirstChild("Head").Size
                        Player.Character:FindFirstChild("Head").Size = Vector3.new()
                        for i = 1, 2 do task.wait() end
                        Player.Character:FindFirstChild("Head").Size = OldSize
                    end
                    RunService.RenderStepped:wait()
                end
            end)
        else
            PingDebounce = false
            Tween(Switch_2, .25, "Quint", "InOut", {BackgroundColor3 = Color3.fromRGB(255, 25, 29)}):Play()
            Tween(SwitchIcon_2, .25, "Quint", "InOut", {Position = UDim2.new(0.29, 0, 0.49, 0)}):Play()
            if Player.Character and Player.Character:FindFirstChild("Head") then
                Player.Character:FindFirstChild("Head").Size = OldSize
            end
        end
    end
end)

local Hover = function(x, IsHovering)
    if IsHovering then
        Tween(x, .25, "Quint", "InOut", {BackgroundColor3 = Color3.fromRGB(230, 230, 230)}):Play()
    else
        Tween(x, .25, "Quint", "InOut", {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end
end

-- This was a fast solution and I was too lazy to find a way to automate this lol
Switch_1.MouseEnter:Connect(function() Hover(SwitchIcon_1, true) end)
Switch_1.MouseLeave:Connect(function() Hover(SwitchIcon_1, false) end)

Switch_2.MouseEnter:Connect(function() Hover(SwitchIcon_2, true) end)
Switch_2.MouseLeave:Connect(function() Hover(SwitchIcon_2, false) end)

local ExitConnection; ExitConnection = Exit.MouseButton1Click:Connect(function()
    ExitConnection:Disconnect()
    FpsDebounce = false
    PingDebounce = false
    local TweenPos = Tween(MainFrame, 1, "Quint", "InOut", {Position = MainFrame.Position + UDim2.new(0, 0, 1.5, 0)})
    TweenPos:Play()
    TweenPos.Completed:wait()
    Main:Destroy()
end)
