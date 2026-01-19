--Made by AnthonyIsntHere
--Uses PhysicsRepRootPart to "attach" to players giving a weld-like effect on the server side
--Very cool gui i put together lol
local Players = game:GetService("Players")
local CoreGui = gethui() or game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player, TargetPlayer, LastPlayer = Players.LocalPlayer, false, false
local Camera = workspace.CurrentCamera
local MaxPosition, MaxAngle = 10, 360
local SpectateDB, AttachDB = false, false
local PosX, PosY, PosZ, AngX, AngY, AngZ = 0, 0, 0, 0, 0, 0

local LivePlayers = {}

local Tween = function(Object, Time, Style, Direction, Property)
	return TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction]), Property)
end

local GetPlayers = function(Name)
	local ReturnedPlayers = {}

    if type(Name) ~= "string" then
        return false
	else
		Name = Name:lower()
    end

    for _, x in next, Players:GetPlayers() do
        if x ~= Player then
            local MatchedName = "^" .. Name

            local Username = x.Name:lower()
            local DisplayName = x.DisplayName:lower()

            if Username:match(MatchedName) or DisplayName:match(MatchedName) then
                ReturnedPlayers[x] = true
            end
        end
    end

	return ReturnedPlayers
end

local Drag = function(GuiObject, Time, Style, Direction)
    task.spawn(function()
        local StartPosition, Dragging, DragInput
        local DragStart = Vector3.new()

        local Update = function(Input)
            local Delta = Input.Position - DragStart
            local NewPosition = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
            
            Tween(GuiObject, Time, Style, Direction, {Position = NewPosition}):Play()
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

local CreateSlider = function(Slider, Fill, SliderButton, Min, Max, Callback)
    local Dragging = false
	local InitialPercentage = (-Min) / (Max - Min)

	Fill.Size = UDim2.new(InitialPercentage, 0, 1, 0)

    local UpdateSlider = function(Input)
        local SliderPos = math.clamp(Input.Position.X - Slider.AbsolutePosition.X, 0, Slider.AbsoluteSize.X)
        local Percent = SliderPos / Slider.AbsoluteSize.X
        local Value = string.format("%.2f", Percent)
		Value = string.format("%.2f", Min + Percent * (Max - Min))

        Fill.Size = UDim2.new(Percent, 0, 1, 0)

        if Callback then
            Callback(Value)
        end
    end

    local BeginDrag = function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            UpdateSlider(Input)

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end

    Slider.InputBegan:Connect(BeginDrag)
    Slider.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(Input)
        end
    end)

    SliderButton.InputBegan:Connect(BeginDrag)
    SliderButton.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(Input)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(Input)
        end
    end)
end

local Attach = Instance.new("ScreenGui")
Attach.Name = "Attach"
Attach.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Attach.Parent = CoreGui

local MainContainer = Instance.new("Frame")
MainContainer.BackgroundTransparency = 1
MainContainer.Name = "MainContainer"
MainContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainContainer.Size = UDim2.new(1, 0, 1, 0)
MainContainer.BorderSizePixel = 0
MainContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainContainer.Parent = Attach

local UIContainer = Instance.new("Frame")
UIContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
UIContainer.AnchorPoint = Vector2.new(0.5, 0.5)
UIContainer.BackgroundTransparency = 0.25
UIContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
UIContainer.Name = "UIContainer"
UIContainer.Size = UDim2.new(0, 500, 0, 400)
UIContainer.BorderSizePixel = 0
UIContainer.BackgroundColor3 = Color3.fromRGB(17, 20, 27)
UIContainer.Parent = MainContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.075, 0)
UICorner.Parent = UIContainer

local LeftContainer = Instance.new("Frame")
LeftContainer.BackgroundTransparency = 1
LeftContainer.Name = "LeftContainer"
LeftContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
LeftContainer.Size = UDim2.new(0, 200, 1, 0)
LeftContainer.BorderSizePixel = 0
LeftContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LeftContainer.Parent = UIContainer

local Thumbnail = Instance.new("ImageLabel")
Thumbnail.BorderColor3 = Color3.fromRGB(0, 0, 0)
Thumbnail.Name = "Thumbnail"
Thumbnail.AnchorPoint = Vector2.new(0, 1)
Thumbnail.Image = "rbxthumb://type=AvatarHeadShot&id=1414978355&w=420&h=420"
Thumbnail.BackgroundTransparency = 0.95
Thumbnail.Position = UDim2.new(0, 20, 1, -15)
Thumbnail.Size = UDim2.new(0, 50, 0, 50)
Thumbnail.BorderSizePixel = 0
Thumbnail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Thumbnail.Parent = LeftContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Thumbnail

local DisplayName = Instance.new("TextLabel")
DisplayName.TextWrapped = true
DisplayName.Name = "DisplayName"
DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayName.BorderColor3 = Color3.fromRGB(0, 0, 0)
DisplayName.Text = "Anthony"
DisplayName.Size = UDim2.new(1, -80, 0, 15)
DisplayName.Position = UDim2.new(1, 0, 1, -45)
DisplayName.AnchorPoint = Vector2.new(1, 1)
DisplayName.BorderSizePixel = 0
DisplayName.BackgroundTransparency = 1
DisplayName.TextXAlignment = Enum.TextXAlignment.Left
DisplayName.TextScaled = true
DisplayName.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
DisplayName.TextSize = 14
DisplayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DisplayName.Parent = LeftContainer

local Username = Instance.new("TextLabel")
Username.TextWrapped = true
Username.Name = "Username"
Username.TextColor3 = Color3.fromRGB(178, 178, 178)
Username.BorderColor3 = Color3.fromRGB(0, 0, 0)
Username.Text = "AnthonyIsntHere"
Username.Size = UDim2.new(1, -80, 0, 12)
Username.Position = UDim2.new(1, 0, 1, -30)
Username.AnchorPoint = Vector2.new(1, 1)
Username.BorderSizePixel = 0
Username.BackgroundTransparency = 1
Username.TextXAlignment = Enum.TextXAlignment.Left
Username.TextScaled = true
Username.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Username.TextSize = 14
Username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Username.Parent = LeftContainer

local Icon = Instance.new("ImageLabel")
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.Name = "Icon"
Icon.Image = "rbxassetid://131893895617606"
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0, 15, 0, 15)
Icon.Size = UDim2.new(0, 40, 0, 40)
Icon.BorderSizePixel = 0
Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Icon.Parent = LeftContainer

local Title = Instance.new("TextLabel")
Title.TextWrapped = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.Text = "Attach Hub"
Title.Name = "Title"
Title.Size = UDim2.new(0, 125, 0, 15)
Title.Position = UDim2.new(0, 60, 0, 20)
Title.BorderSizePixel = 0
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 14
Title.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Title.TextScaled = true
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = LeftContainer

local Credits = Instance.new("TextLabel")
Credits.TextWrapped = true
Credits.TextColor3 = Color3.fromRGB(178, 178, 178)
Credits.BorderColor3 = Color3.fromRGB(0, 0, 0)
Credits.Text = "Made by AnthonyIsntHere"
Credits.Name = "Credits"
Credits.Size = UDim2.new(0, 125, 0, 12)
Credits.Position = UDim2.new(0, 60, 0, 35)
Credits.BorderSizePixel = 0
Credits.BackgroundTransparency = 1
Credits.TextXAlignment = Enum.TextXAlignment.Left
Credits.TextSize = 14
Credits.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Credits.TextScaled = true
Credits.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Credits.Parent = LeftContainer

local SearchBox = Instance.new("TextBox")
SearchBox.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SearchBox.AnchorPoint = Vector2.new(0.5, 0)
SearchBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
SearchBox.PlaceholderText = "Displayname/Username"
SearchBox.TextSize = 12
SearchBox.Size = UDim2.new(1, -20, 0, 20)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.BorderColor3 = Color3.fromRGB(24, 24, 24)
SearchBox.ClearTextOnFocus = false
SearchBox.Text = ""
SearchBox.Name = "SearchBox"
SearchBox.BackgroundTransparency = 0.9
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.TextWrapped = true
SearchBox.Position = UDim2.new(0.5, 0, 0, 65)
SearchBox.BorderSizePixel = 0
SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.ClipsDescendants = true
SearchBox.Parent = LeftContainer

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 25)
UIPadding.Parent = SearchBox

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.3, 0)
UICorner.Parent = SearchBox

local SearchIcon = Instance.new("ImageLabel")
SearchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
SearchIcon.Name = "SearchIcon"
SearchIcon.AnchorPoint = Vector2.new(1, 0.5)
SearchIcon.Image = "rbxassetid://96049338298945"
SearchIcon.BackgroundTransparency = 1
SearchIcon.Position = UDim2.new(0, -5, 0.5, 0)
SearchIcon.Size = UDim2.new(0, 16, 0, 16)
SearchIcon.BorderSizePixel = 0
SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SearchIcon.Parent = SearchBox

local PlayersContainerFrame = Instance.new("Frame")
PlayersContainerFrame.Name = "PlayersContainerFrame"
PlayersContainerFrame.BackgroundTransparency = 1
PlayersContainerFrame.Position = UDim2.new(0, 0, 0, 95)
PlayersContainerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayersContainerFrame.Size = UDim2.new(1, 0, 0, 230)
PlayersContainerFrame.BorderSizePixel = 0
PlayersContainerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayersContainerFrame.Parent = LeftContainer

local PlayersContainer = Instance.new("ScrollingFrame")
PlayersContainer.Active = true
PlayersContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayersContainer.ScrollBarThickness = 0
PlayersContainer.Name = "PlayersContainer"
PlayersContainer.Size = UDim2.new(1, -20, 1, 0)
PlayersContainer.AnchorPoint = Vector2.new(0.5, 0.5)
PlayersContainer.ScrollBarImageTransparency = 1
PlayersContainer.BackgroundTransparency = 0.9
PlayersContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
PlayersContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayersContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayersContainer.BorderSizePixel = 0
PlayersContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayersContainer.Parent = PlayersContainerFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.075, 0)
UICorner.Parent = PlayersContainer

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = PlayersContainer

local PlayerTemplateContainer = Instance.new("TextButton")
PlayerTemplateContainer.BackgroundTransparency = 0.9
PlayerTemplateContainer.Name = "PlayerTemplateContainer"
PlayerTemplateContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayerTemplateContainer.Size = UDim2.new(1, -20, 0, 40)
PlayerTemplateContainer.BorderSizePixel = 0
PlayerTemplateContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerTemplateContainer.Text = ""
PlayerTemplateContainer.Visible = false
PlayerTemplateContainer.Parent = PlayersContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = PlayerTemplateContainer

local PlayerThumbnail = Instance.new("ImageLabel")
PlayerThumbnail.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayerThumbnail.Image = "rbxthumb://type=AvatarHeadShot&id=1414978355&w=420&h=420"
PlayerThumbnail.BackgroundTransparency = 1
PlayerThumbnail.Name = "PlayerThumbnail"
PlayerThumbnail.Size = UDim2.new(0, 40, 0, 40)
PlayerThumbnail.BorderSizePixel = 0
PlayerThumbnail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerThumbnail.Parent = PlayerTemplateContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.10000000149011612, 0)
UICorner.Parent = PlayerThumbnail

local PlayerDisplayName = Instance.new("TextLabel")
PlayerDisplayName.TextWrapped = true
PlayerDisplayName.Name = "PlayerDisplayName"
PlayerDisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerDisplayName.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayerDisplayName.Text = "Anthony"
PlayerDisplayName.Size = UDim2.new(1, -45, 0, 15)
PlayerDisplayName.Position = UDim2.new(1, 0, 0, 5)
PlayerDisplayName.AnchorPoint = Vector2.new(1, 0)
PlayerDisplayName.BorderSizePixel = 0
PlayerDisplayName.BackgroundTransparency = 1
PlayerDisplayName.TextXAlignment = Enum.TextXAlignment.Left
PlayerDisplayName.TextScaled = true
PlayerDisplayName.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
PlayerDisplayName.TextSize = 14
PlayerDisplayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerDisplayName.Parent = PlayerTemplateContainer

local PlayerUsername = Instance.new("TextLabel")
PlayerUsername.TextWrapped = true
PlayerUsername.Name = "PlayerUsername"
PlayerUsername.TextColor3 = Color3.fromRGB(178, 178, 178)
PlayerUsername.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayerUsername.Text = "@AnthonyIsntHere"
PlayerUsername.Size = UDim2.new(1, -45, 0, 12)
PlayerUsername.Position = UDim2.new(1, 0, 0, 20)
PlayerUsername.AnchorPoint = Vector2.new(1, 0)
PlayerUsername.BorderSizePixel = 0
PlayerUsername.BackgroundTransparency = 1
PlayerUsername.TextXAlignment = Enum.TextXAlignment.Left
PlayerUsername.TextScaled = true
PlayerUsername.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PlayerUsername.TextSize = 14
PlayerUsername.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerUsername.Parent = PlayerTemplateContainer

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.Parent = PlayersContainer

local RightContainer = Instance.new("Frame")
RightContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
RightContainer.AnchorPoint = Vector2.new(1, 0)
RightContainer.BackgroundTransparency = 1
RightContainer.Position = UDim2.new(1, 0, 0, 0)
RightContainer.Name = "RightContainer"
RightContainer.Size = UDim2.new(0, 300, 1, 0)
RightContainer.BorderSizePixel = 0
RightContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RightContainer.Parent = UIContainer

local Close = Instance.new("TextButton")
Close.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Close.Active = false
Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close.Text = ""
Close.Name = "Close"
Close.AutoButtonColor = false
Close.AnchorPoint = Vector2.new(1, 0)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1, -15, 0, 15)
Close.BorderSizePixel = 0
Close.TextColor3 = Color3.fromRGB(0, 0, 0)
Close.TextSize = 14
Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close.Parent = RightContainer

local CloseIcon = Instance.new("ImageLabel")
CloseIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseIcon.Name = "CloseIcon"
CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
CloseIcon.Image = "rbxassetid://110786993356448"
CloseIcon.BackgroundTransparency = 1
CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
CloseIcon.Size = UDim2.new(0, 16, 0, 16)
CloseIcon.BorderSizePixel = 0
CloseIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseIcon.Parent = Close

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.25, 0)
UICorner.Parent = Close

local Minimize = Instance.new("TextButton")
Minimize.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Minimize.Active = false
Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
Minimize.Text = ""
Minimize.Name = "Minimize"
Minimize.AutoButtonColor = false
Minimize.AnchorPoint = Vector2.new(1, 0)
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.BackgroundTransparency = 1
Minimize.Position = UDim2.new(1, -50, 0, 15)
Minimize.BorderSizePixel = 0
Minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
Minimize.TextSize = 14
Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Minimize.Parent = RightContainer

local MinimizeIcon = Instance.new("ImageLabel")
MinimizeIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
MinimizeIcon.Name = "MinimizeIcon"
MinimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
MinimizeIcon.Image = "rbxassetid://118026365011536"
MinimizeIcon.BackgroundTransparency = 1
MinimizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
MinimizeIcon.Size = UDim2.new(0, 16, 0, 16)
MinimizeIcon.BorderSizePixel = 0
MinimizeIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinimizeIcon.Parent = Minimize

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.25, 0)
UICorner.Parent = Minimize

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.BackgroundTransparency = 0.9
Window.Position = UDim2.new(0, 0, 0, 50)
Window.BorderColor3 = Color3.fromRGB(0, 0, 0)
Window.Size = UDim2.new(1, -10, 1, -60)
Window.BorderSizePixel = 0
Window.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Window.Parent = RightContainer

local ScrollableWindow = Instance.new("ScrollingFrame")
ScrollableWindow.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
ScrollableWindow.Active = true
ScrollableWindow.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollableWindow.ScrollBarThickness = 0
ScrollableWindow.Name = "ScrollableWindow"
ScrollableWindow.Size = UDim2.new(1, 0, 0, 230)
ScrollableWindow.AnchorPoint = Vector2.new(0, 1)
ScrollableWindow.ScrollBarImageTransparency = 1
ScrollableWindow.BackgroundTransparency = 1
ScrollableWindow.Position = UDim2.new(0, 0, 1, 0)
ScrollableWindow.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollableWindow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollableWindow.BorderSizePixel = 0
ScrollableWindow.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollableWindow.Parent = Window

local Title3 = Instance.new("TextLabel")
Title3.TextWrapped = true
Title3.Name = "Title3"
Title3.TextColor3 = Color3.fromRGB(255, 255, 255)
Title3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title3.Text = "Rotation"
Title3.Size = UDim2.new(1, -45, 0, 20)
Title3.Position = UDim2.new(1, 0, 0, 100)
Title3.AnchorPoint = Vector2.new(1, 0)
Title3.BorderSizePixel = 0
Title3.BackgroundTransparency = 1
Title3.TextXAlignment = Enum.TextXAlignment.Left
Title3.TextScaled = true
Title3.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Title3.TextSize = 14
Title3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title3.Parent = ScrollableWindow

local RotationIcon = Instance.new("ImageLabel")
RotationIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationIcon.Name = "RotationIcon"
RotationIcon.Image = "rbxassetid://117383682863027"
RotationIcon.BackgroundTransparency = 1
RotationIcon.Position = UDim2.new(0, -25, 0, 0)
RotationIcon.Size = UDim2.new(0, 20, 0, 20)
RotationIcon.BorderSizePixel = 0
RotationIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationIcon.Parent = Title3

local Title2 = Instance.new("TextLabel")
Title2.TextWrapped = true
Title2.Name = "Title2"
Title2.TextColor3 = Color3.fromRGB(255, 255, 255)
Title2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title2.Text = "Position"
Title2.Size = UDim2.new(1, -45, 0, 20)
Title2.Position = UDim2.new(1, 0, 0, 0)
Title2.AnchorPoint = Vector2.new(1, 0)
Title2.BorderSizePixel = 0
Title2.BackgroundTransparency = 1
Title2.TextXAlignment = Enum.TextXAlignment.Left
Title2.TextScaled = true
Title2.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Title2.TextSize = 14
Title2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title2.Parent = ScrollableWindow

local PositionIcon = Instance.new("ImageLabel")
PositionIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionIcon.Name = "PositionIcon"
PositionIcon.Image = "rbxassetid://71917905228308"
PositionIcon.BackgroundTransparency = 1
PositionIcon.Position = UDim2.new(0, -25, 0, 0)
PositionIcon.Size = UDim2.new(0, 20, 0, 20)
PositionIcon.BorderSizePixel = 0
PositionIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionIcon.Parent = Title2

local PositionSliderZ = Instance.new("TextButton")
PositionSliderZ.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PositionSliderZ.TextColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderZ.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderZ.Text = ""
PositionSliderZ.AutoButtonColor = false
PositionSliderZ.Name = "PositionSliderZ"
PositionSliderZ.BackgroundTransparency = 0.9
PositionSliderZ.Position = UDim2.new(0, 70, 0, 80)
PositionSliderZ.Size = UDim2.new(1, -130, 0, 5)
PositionSliderZ.BorderSizePixel = 0
PositionSliderZ.TextSize = 14
PositionSliderZ.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderZ.Parent = ScrollableWindow

local PositionZAxis = Instance.new("TextLabel")
PositionZAxis.TextWrapped = true
PositionZAxis.TextColor3 = Color3.fromRGB(255, 255, 255)
PositionZAxis.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionZAxis.Text = "Z"
PositionZAxis.Name = "PositionZAxis"
PositionZAxis.Size = UDim2.new(0, 20, 0, 20)
PositionZAxis.AnchorPoint = Vector2.new(1, 0.5)
PositionZAxis.BorderSizePixel = 0
PositionZAxis.BackgroundTransparency = 1
PositionZAxis.Position = UDim2.new(0, -5, 0.5, -1)
PositionZAxis.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
PositionZAxis.TextSize = 14
PositionZAxis.TextScaled = true
PositionZAxis.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionZAxis.Parent = PositionSliderZ

local PositionSliderPercentageFrame_Z = Instance.new("Frame")
PositionSliderPercentageFrame_Z.Name = "PositionSliderPercentageFrame_Z"
PositionSliderPercentageFrame_Z.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderPercentageFrame_Z.Size = UDim2.new(0, 0, 1, 0)
PositionSliderPercentageFrame_Z.BorderSizePixel = 0
PositionSliderPercentageFrame_Z.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderPercentageFrame_Z.Parent = PositionSliderZ

local PositionSliderButton_Z = Instance.new("TextButton")
PositionSliderButton_Z.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PositionSliderButton_Z.TextColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderButton_Z.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderButton_Z.Text = ""
PositionSliderButton_Z.AnchorPoint = Vector2.new(0, 0.5)
PositionSliderButton_Z.Name = "PositionSliderButton_Z"
PositionSliderButton_Z.Position = UDim2.new(1, 0, 0.5, 0)
PositionSliderButton_Z.Size = UDim2.new(0, 2, 1, 10)
PositionSliderButton_Z.BorderSizePixel = 0
PositionSliderButton_Z.TextSize = 14
PositionSliderButton_Z.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
PositionSliderButton_Z.Parent = PositionSliderPercentageFrame_Z

local PositionSliderBox_Z = Instance.new("TextBox")
PositionSliderBox_Z.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PositionSliderBox_Z.TextColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderBox_Z.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderBox_Z.Text = ""
PositionSliderBox_Z.Name = "PositionSliderBox_Z"
PositionSliderBox_Z.AnchorPoint = Vector2.new(0, 0.5)
PositionSliderBox_Z.Size = UDim2.new(0, 40, 0, 20)
PositionSliderBox_Z.BackgroundTransparency = 0.9
PositionSliderBox_Z.Position = UDim2.new(1, 10, 0.5, 0)
PositionSliderBox_Z.BorderSizePixel = 0
PositionSliderBox_Z.ClearTextOnFocus = false
PositionSliderBox_Z.PlaceholderText = "0"
PositionSliderBox_Z.TextSize = 14
PositionSliderBox_Z.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderBox_Z.ClipsDescendants = true
PositionSliderBox_Z.Parent = PositionSliderZ

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = PositionSliderBox_Z

local PositionSliderY = Instance.new("TextButton")
PositionSliderY.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PositionSliderY.TextColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderY.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderY.Text = ""
PositionSliderY.AutoButtonColor = false
PositionSliderY.Name = "PositionSliderY"
PositionSliderY.BackgroundTransparency = 0.9
PositionSliderY.Position = UDim2.new(0, 70, 0, 55)
PositionSliderY.Size = UDim2.new(1, -130, 0, 5)
PositionSliderY.BorderSizePixel = 0
PositionSliderY.TextSize = 14
PositionSliderY.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderY.Parent = ScrollableWindow

local PositionYAxis = Instance.new("TextLabel")
PositionYAxis.TextWrapped = true
PositionYAxis.TextColor3 = Color3.fromRGB(255, 255, 255)
PositionYAxis.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionYAxis.Text = "Y"
PositionYAxis.Name = "PositionYAxis"
PositionYAxis.Size = UDim2.new(0, 20, 0, 20)
PositionYAxis.AnchorPoint = Vector2.new(1, 0.5)
PositionYAxis.BorderSizePixel = 0
PositionYAxis.BackgroundTransparency = 1
PositionYAxis.Position = UDim2.new(0, -5, 0.5, -1)
PositionYAxis.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
PositionYAxis.TextSize = 14
PositionYAxis.TextScaled = true
PositionYAxis.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionYAxis.Parent = PositionSliderY

local PositionSliderPercentageFrame_Y = Instance.new("Frame")
PositionSliderPercentageFrame_Y.Name = "PositionSliderPercentageFrame_Y"
PositionSliderPercentageFrame_Y.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderPercentageFrame_Y.Size = UDim2.new(0, 0, 1, 0)
PositionSliderPercentageFrame_Y.BorderSizePixel = 0
PositionSliderPercentageFrame_Y.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderPercentageFrame_Y.Parent = PositionSliderY

local PositionSliderButton_Y = Instance.new("TextButton")
PositionSliderButton_Y.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PositionSliderButton_Y.TextColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderButton_Y.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderButton_Y.Text = ""
PositionSliderButton_Y.AnchorPoint = Vector2.new(0, 0.5)
PositionSliderButton_Y.Name = "PositionSliderButton_Y"
PositionSliderButton_Y.Position = UDim2.new(1, 0, 0.5, 0)
PositionSliderButton_Y.Size = UDim2.new(0, 2, 1, 10)
PositionSliderButton_Y.BorderSizePixel = 0
PositionSliderButton_Y.TextSize = 14
PositionSliderButton_Y.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
PositionSliderButton_Y.Parent = PositionSliderPercentageFrame_Y

local PositionSliderBox_Y = Instance.new("TextBox")
PositionSliderBox_Y.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PositionSliderBox_Y.TextColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderBox_Y.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderBox_Y.Text = ""
PositionSliderBox_Y.Name = "PositionSliderBox_Y"
PositionSliderBox_Y.AnchorPoint = Vector2.new(0, 0.5)
PositionSliderBox_Y.Size = UDim2.new(0, 40, 0, 20)
PositionSliderBox_Y.BackgroundTransparency = 0.9
PositionSliderBox_Y.Position = UDim2.new(1, 10, 0.5, 0)
PositionSliderBox_Y.BorderSizePixel = 0
PositionSliderBox_Y.ClearTextOnFocus = false
PositionSliderBox_Y.PlaceholderText = "0"
PositionSliderBox_Y.TextSize = 14
PositionSliderBox_Y.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderBox_Y.ClipsDescendants = true
PositionSliderBox_Y.Parent = PositionSliderY

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = PositionSliderBox_Y

local PositionSliderX = Instance.new("TextButton")
PositionSliderX.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PositionSliderX.TextColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderX.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderX.Text = ""
PositionSliderX.AutoButtonColor = false
PositionSliderX.Name = "PositionSliderX"
PositionSliderX.BackgroundTransparency = 0.9
PositionSliderX.Position = UDim2.new(0, 70, 0, 30)
PositionSliderX.Size = UDim2.new(1, -130, 0, 5)
PositionSliderX.BorderSizePixel = 0
PositionSliderX.TextSize = 14
PositionSliderX.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderX.Parent = ScrollableWindow

local PositionXAxis = Instance.new("TextLabel")
PositionXAxis.TextWrapped = true
PositionXAxis.TextColor3 = Color3.fromRGB(255, 255, 255)
PositionXAxis.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionXAxis.Text = "X"
PositionXAxis.Name = "PositionXAxis"
PositionXAxis.Size = UDim2.new(0, 20, 0, 20)
PositionXAxis.AnchorPoint = Vector2.new(1, 0.5)
PositionXAxis.BorderSizePixel = 0
PositionXAxis.BackgroundTransparency = 1
PositionXAxis.Position = UDim2.new(0, -5, 0.5, -1)
PositionXAxis.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
PositionXAxis.TextSize = 14
PositionXAxis.TextScaled = true
PositionXAxis.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionXAxis.Parent = PositionSliderX

local PositionSliderPercentageFrame_X = Instance.new("Frame")
PositionSliderPercentageFrame_X.Name = "PositionSliderPercentageFrame_X"
PositionSliderPercentageFrame_X.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderPercentageFrame_X.Size = UDim2.new(0, 0, 1, 0)
PositionSliderPercentageFrame_X.BorderSizePixel = 0
PositionSliderPercentageFrame_X.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderPercentageFrame_X.Parent = PositionSliderX

local PositionSliderButton_X = Instance.new("TextButton")
PositionSliderButton_X.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PositionSliderButton_X.TextColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderButton_X.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderButton_X.Text = ""
PositionSliderButton_X.AnchorPoint = Vector2.new(0, 0.5)
PositionSliderButton_X.Name = "PositionSliderButton_X"
PositionSliderButton_X.Position = UDim2.new(1, 0, 0.5, 0)
PositionSliderButton_X.Size = UDim2.new(0, 2, 1, 10)
PositionSliderButton_X.BorderSizePixel = 0
PositionSliderButton_X.TextSize = 14
PositionSliderButton_X.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
PositionSliderButton_X.Parent = PositionSliderPercentageFrame_X

local PositionSliderBox_X = Instance.new("TextBox")
PositionSliderBox_X.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
PositionSliderBox_X.TextColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderBox_X.BorderColor3 = Color3.fromRGB(0, 0, 0)
PositionSliderBox_X.Text = ""
PositionSliderBox_X.Name = "PositionSliderBox_X"
PositionSliderBox_X.AnchorPoint = Vector2.new(0, 0.5)
PositionSliderBox_X.Size = UDim2.new(0, 40, 0, 20)
PositionSliderBox_X.BackgroundTransparency = 0.9
PositionSliderBox_X.Position = UDim2.new(1, 10, 0.5, 0)
PositionSliderBox_X.BorderSizePixel = 0
PositionSliderBox_X.ClearTextOnFocus = false
PositionSliderBox_X.PlaceholderText = "0"
PositionSliderBox_X.TextSize = 14
PositionSliderBox_X.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PositionSliderBox_X.ClipsDescendants = true
PositionSliderBox_X.Parent = PositionSliderX

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = PositionSliderBox_X

local RotationSliderZ = Instance.new("TextButton")
RotationSliderZ.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RotationSliderZ.TextColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderZ.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderZ.Text = ""
RotationSliderZ.AutoButtonColor = false
RotationSliderZ.Name = "RotationSliderZ"
RotationSliderZ.BackgroundTransparency = 0.9
RotationSliderZ.Position = UDim2.new(0, 70, 0, 180)
RotationSliderZ.Size = UDim2.new(1, -130, 0, 5)
RotationSliderZ.BorderSizePixel = 0
RotationSliderZ.TextSize = 14
RotationSliderZ.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderZ.Parent = ScrollableWindow

local RotationZAxis = Instance.new("TextLabel")
RotationZAxis.TextWrapped = true
RotationZAxis.TextColor3 = Color3.fromRGB(255, 255, 255)
RotationZAxis.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationZAxis.Text = "Z"
RotationZAxis.Name = "RotationZAxis"
RotationZAxis.Size = UDim2.new(0, 20, 0, 20)
RotationZAxis.AnchorPoint = Vector2.new(1, 0.5)
RotationZAxis.BorderSizePixel = 0
RotationZAxis.BackgroundTransparency = 1
RotationZAxis.Position = UDim2.new(0, -5, 0.5, -1)
RotationZAxis.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
RotationZAxis.TextSize = 14
RotationZAxis.TextScaled = true
RotationZAxis.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationZAxis.Parent = RotationSliderZ

local RotationSliderPercentageFrame_Z = Instance.new("Frame")
RotationSliderPercentageFrame_Z.Name = "RotationSliderPercentageFrame_Z"
RotationSliderPercentageFrame_Z.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderPercentageFrame_Z.Size = UDim2.new(0, 0, 1, 0)
RotationSliderPercentageFrame_Z.BorderSizePixel = 0
RotationSliderPercentageFrame_Z.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderPercentageFrame_Z.Parent = RotationSliderZ

local RotationSliderButton_Z = Instance.new("TextButton")
RotationSliderButton_Z.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RotationSliderButton_Z.TextColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderButton_Z.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderButton_Z.Text = ""
RotationSliderButton_Z.AnchorPoint = Vector2.new(0, 0.5)
RotationSliderButton_Z.Name = "RotationSliderButton_Z"
RotationSliderButton_Z.Position = UDim2.new(1, 0, 0.5, 0)
RotationSliderButton_Z.Size = UDim2.new(0, 2, 1, 10)
RotationSliderButton_Z.BorderSizePixel = 0
RotationSliderButton_Z.TextSize = 14
RotationSliderButton_Z.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
RotationSliderButton_Z.Parent = RotationSliderPercentageFrame_Z

local RotationSliderBox_Z = Instance.new("TextBox")
RotationSliderBox_Z.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RotationSliderBox_Z.TextColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderBox_Z.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderBox_Z.Text = ""
RotationSliderBox_Z.Name = "RotationSliderBox_Z"
RotationSliderBox_Z.AnchorPoint = Vector2.new(0, 0.5)
RotationSliderBox_Z.Size = UDim2.new(0, 40, 0, 20)
RotationSliderBox_Z.BackgroundTransparency = 0.9
RotationSliderBox_Z.Position = UDim2.new(1, 10, 0.5, 0)
RotationSliderBox_Z.BorderSizePixel = 0
RotationSliderBox_Z.ClearTextOnFocus = false
RotationSliderBox_Z.PlaceholderText = "0"
RotationSliderBox_Z.TextSize = 14
RotationSliderBox_Z.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderBox_Z.ClipsDescendants = true
RotationSliderBox_Z.Parent = RotationSliderZ

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = RotationSliderBox_Z

local RotationSliderY = Instance.new("TextButton")
RotationSliderY.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RotationSliderY.TextColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderY.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderY.Text = ""
RotationSliderY.AutoButtonColor = false
RotationSliderY.Name = "RotationSliderY"
RotationSliderY.BackgroundTransparency = 0.9
RotationSliderY.Position = UDim2.new(0, 70, 0, 155)
RotationSliderY.Size = UDim2.new(1, -130, 0, 5)
RotationSliderY.BorderSizePixel = 0
RotationSliderY.TextSize = 14
RotationSliderY.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderY.Parent = ScrollableWindow

local RotationYAxis = Instance.new("TextLabel")
RotationYAxis.TextWrapped = true
RotationYAxis.TextColor3 = Color3.fromRGB(255, 255, 255)
RotationYAxis.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationYAxis.Text = "Y"
RotationYAxis.Name = "RotationYAxis"
RotationYAxis.Size = UDim2.new(0, 20, 0, 20)
RotationYAxis.AnchorPoint = Vector2.new(1, 0.5)
RotationYAxis.BorderSizePixel = 0
RotationYAxis.BackgroundTransparency = 1
RotationYAxis.Position = UDim2.new(0, -5, 0.5, -1)
RotationYAxis.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
RotationYAxis.TextSize = 14
RotationYAxis.TextScaled = true
RotationYAxis.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationYAxis.Parent = RotationSliderY

local RotationSliderPercentageFrame_Y = Instance.new("Frame")
RotationSliderPercentageFrame_Y.Name = "RotationSliderPercentageFrame_Y"
RotationSliderPercentageFrame_Y.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderPercentageFrame_Y.Size = UDim2.new(0, 0, 1, 0)
RotationSliderPercentageFrame_Y.BorderSizePixel = 0
RotationSliderPercentageFrame_Y.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderPercentageFrame_Y.Parent = RotationSliderY

local RotationSliderButton_Y = Instance.new("TextButton")
RotationSliderButton_Y.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RotationSliderButton_Y.TextColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderButton_Y.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderButton_Y.Text = ""
RotationSliderButton_Y.AnchorPoint = Vector2.new(0, 0.5)
RotationSliderButton_Y.Name = "RotationSliderButton_Y"
RotationSliderButton_Y.Position = UDim2.new(1, 0, 0.5, 0)
RotationSliderButton_Y.Size = UDim2.new(0, 2, 1, 10)
RotationSliderButton_Y.BorderSizePixel = 0
RotationSliderButton_Y.TextSize = 14
RotationSliderButton_Y.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
RotationSliderButton_Y.Parent = RotationSliderPercentageFrame_Y

local RotationSliderBox_Y = Instance.new("TextBox")
RotationSliderBox_Y.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RotationSliderBox_Y.TextColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderBox_Y.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderBox_Y.Text = ""
RotationSliderBox_Y.Name = "RotationSliderBox_Y"
RotationSliderBox_Y.AnchorPoint = Vector2.new(0, 0.5)
RotationSliderBox_Y.Size = UDim2.new(0, 40, 0, 20)
RotationSliderBox_Y.BackgroundTransparency = 0.9
RotationSliderBox_Y.Position = UDim2.new(1, 10, 0.5, 0)
RotationSliderBox_Y.BorderSizePixel = 0
RotationSliderBox_Y.ClearTextOnFocus = false
RotationSliderBox_Y.PlaceholderText = "0"
RotationSliderBox_Y.TextSize = 14
RotationSliderBox_Y.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderBox_Y.ClipsDescendants = true
RotationSliderBox_Y.Parent = RotationSliderY

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = RotationSliderBox_Y

local RotationSliderX = Instance.new("TextButton")
RotationSliderX.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RotationSliderX.TextColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderX.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderX.Text = ""
RotationSliderX.AutoButtonColor = false
RotationSliderX.Name = "RotationSliderX"
RotationSliderX.BackgroundTransparency = 0.9
RotationSliderX.Position = UDim2.new(0, 70, 0, 130)
RotationSliderX.Size = UDim2.new(1, -130, 0, 5)
RotationSliderX.BorderSizePixel = 0
RotationSliderX.TextSize = 14
RotationSliderX.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderX.Parent = ScrollableWindow

local RotationXAxis = Instance.new("TextLabel")
RotationXAxis.TextWrapped = true
RotationXAxis.TextColor3 = Color3.fromRGB(255, 255, 255)
RotationXAxis.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationXAxis.Text = "X"
RotationXAxis.Name = "RotationXAxis"
RotationXAxis.Size = UDim2.new(0, 20, 0, 20)
RotationXAxis.AnchorPoint = Vector2.new(1, 0.5)
RotationXAxis.BorderSizePixel = 0
RotationXAxis.BackgroundTransparency = 1
RotationXAxis.Position = UDim2.new(0, -5, 0.5, -1)
RotationXAxis.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
RotationXAxis.TextSize = 14
RotationXAxis.TextScaled = true
RotationXAxis.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationXAxis.Parent = RotationSliderX

local RotationSliderPercentageFrame_X = Instance.new("Frame")
RotationSliderPercentageFrame_X.Name = "RotationSliderPercentageFrame_X"
RotationSliderPercentageFrame_X.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderPercentageFrame_X.Size = UDim2.new(0, 0, 1, 0)
RotationSliderPercentageFrame_X.BorderSizePixel = 0
RotationSliderPercentageFrame_X.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderPercentageFrame_X.Parent = RotationSliderX

local RotationSliderButton_X = Instance.new("TextButton")
RotationSliderButton_X.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RotationSliderButton_X.TextColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderButton_X.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderButton_X.Text = ""
RotationSliderButton_X.AnchorPoint = Vector2.new(0, 0.5)
RotationSliderButton_X.Name = "RotationSliderButton_X"
RotationSliderButton_X.Position = UDim2.new(1, 0, 0.5, 0)
RotationSliderButton_X.Size = UDim2.new(0, 2, 1, 10)
RotationSliderButton_X.BorderSizePixel = 0
RotationSliderButton_X.TextSize = 14
RotationSliderButton_X.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
RotationSliderButton_X.Parent = RotationSliderPercentageFrame_X

local RotationSliderBox_X = Instance.new("TextBox")
RotationSliderBox_X.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
RotationSliderBox_X.TextColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderBox_X.BorderColor3 = Color3.fromRGB(0, 0, 0)
RotationSliderBox_X.Text = ""
RotationSliderBox_X.Name = "RotationSliderBox_X"
RotationSliderBox_X.AnchorPoint = Vector2.new(0, 0.5)
RotationSliderBox_X.Size = UDim2.new(0, 40, 0, 20)
RotationSliderBox_X.BackgroundTransparency = 0.9
RotationSliderBox_X.Position = UDim2.new(1, 10, 0.5, 0)
RotationSliderBox_X.BorderSizePixel = 0
RotationSliderBox_X.ClearTextOnFocus = false
RotationSliderBox_X.PlaceholderText = "0"
RotationSliderBox_X.TextSize = 14
RotationSliderBox_X.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RotationSliderBox_X.ClipsDescendants = true
RotationSliderBox_X.Parent = RotationSliderX

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = RotationSliderBox_X

local SeparatorFrame = Instance.new("Frame")
SeparatorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
SeparatorFrame.AnchorPoint = Vector2.new(0.5, 0)
SeparatorFrame.BackgroundTransparency = 0.95
SeparatorFrame.Position = UDim2.new(0.5, 0, 0, 210)
SeparatorFrame.Name = "SeparatorFrame"
SeparatorFrame.Size = UDim2.new(1, -60, 0, 5)
SeparatorFrame.BorderSizePixel = 0
SeparatorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SeparatorFrame.Parent = ScrollableWindow

local Title4 = Instance.new("TextLabel")
Title4.TextWrapped = true
Title4.Name = "Title4"
Title4.TextColor3 = Color3.fromRGB(255, 255, 255)
Title4.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title4.Text = "Presets"
Title4.Size = UDim2.new(1, -45, 0, 20)
Title4.Position = UDim2.new(1, 0, 0, 220)
Title4.AnchorPoint = Vector2.new(1, 0)
Title4.BorderSizePixel = 0
Title4.BackgroundTransparency = 1
Title4.TextXAlignment = Enum.TextXAlignment.Left
Title4.TextScaled = true
Title4.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Title4.TextSize = 14
Title4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title4.Parent = ScrollableWindow

local PresetsIcon = Instance.new("ImageLabel")
PresetsIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
PresetsIcon.Name = "PresetsIcon"
PresetsIcon.Image = "rbxassetid://139402130494916"
PresetsIcon.BackgroundTransparency = 1
PresetsIcon.Position = UDim2.new(0, -25, 0, 0)
PresetsIcon.Size = UDim2.new(0, 20, 0, 20)
PresetsIcon.BorderSizePixel = 0
PresetsIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PresetsIcon.Parent = Title4

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.Parent = ScrollableWindow

local PresetsContainer = Instance.new("Frame")
PresetsContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
PresetsContainer.AnchorPoint = Vector2.new(0.5, 0)
PresetsContainer.BackgroundTransparency = 1
PresetsContainer.Position = UDim2.new(0.5, 0, 0, 250)
PresetsContainer.Name = "PresetsContainer"
PresetsContainer.Size = UDim2.new(1, -30, 0, 50)
PresetsContainer.BorderSizePixel = 0
PresetsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PresetsContainer.Parent = ScrollableWindow

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Wraps = true
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = PresetsContainer

local Speed = Instance.new("TextButton")
Speed.TextWrapped = true
Speed.TextColor3 = Color3.fromRGB(255, 255, 255)
Speed.BorderColor3 = Color3.fromRGB(0, 0, 0)
Speed.Text = "Speed"
Speed.Name = "Speed"
Speed.Size = UDim2.new(0, 80, 0, 20)
Speed.BorderSizePixel = 0
Speed.BackgroundTransparency = 0.9
Speed.Position = UDim2.new(0, 105, 0, 250)
Speed.TextSize = 14
Speed.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Speed.TextScaled = true
Speed.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Speed.Parent = PresetsContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = Speed

local InfJump = Instance.new("TextButton")
InfJump.TextWrapped = true
InfJump.TextColor3 = Color3.fromRGB(255, 255, 255)
InfJump.BorderColor3 = Color3.fromRGB(0, 0, 0)
InfJump.Text = "InfJump"
InfJump.Name = "InfJump"
InfJump.Size = UDim2.new(0, 80, 0, 20)
InfJump.BorderSizePixel = 0
InfJump.BackgroundTransparency = 0.9
InfJump.Position = UDim2.new(0, 20, 0, 250)
InfJump.TextSize = 14
InfJump.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
InfJump.TextScaled = true
InfJump.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InfJump.Parent = PresetsContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = InfJump

local NoJump = Instance.new("TextButton")
NoJump.TextWrapped = true
NoJump.TextColor3 = Color3.fromRGB(255, 255, 255)
NoJump.BorderColor3 = Color3.fromRGB(0, 0, 0)
NoJump.Text = "NoJump"
NoJump.Name = "NoJump"
NoJump.Size = UDim2.new(0, 80, 0, 20)
NoJump.BorderSizePixel = 0
NoJump.BackgroundTransparency = 0.9
NoJump.Position = UDim2.new(0, 150, 0, 275)
NoJump.TextSize = 14
NoJump.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
NoJump.TextScaled = true
NoJump.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoJump.Parent = PresetsContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = NoJump

local Climb = Instance.new("TextButton")
Climb.TextWrapped = true
Climb.TextColor3 = Color3.fromRGB(255, 255, 255)
Climb.BorderColor3 = Color3.fromRGB(0, 0, 0)
Climb.Text = "Climb"
Climb.Name = "Climb"
Climb.Size = UDim2.new(0, 80, 0, 20)
Climb.BorderSizePixel = 0
Climb.BackgroundTransparency = 0.9
Climb.Position = UDim2.new(0, 65, 0, 275)
Climb.TextSize = 14
Climb.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Climb.TextScaled = true
Climb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Climb.Parent = PresetsContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = Climb

local Skydive = Instance.new("TextButton")
Skydive.TextWrapped = true
Skydive.TextColor3 = Color3.fromRGB(255, 255, 255)
Skydive.BorderColor3 = Color3.fromRGB(0, 0, 0)
Skydive.Text = "Skydive"
Skydive.Name = "Skydive"
Skydive.Size = UDim2.new(0, 80, 0, 20)
Skydive.BorderSizePixel = 0
Skydive.BackgroundTransparency = 0.9
Skydive.Position = UDim2.new(0, 190, 0, 250)
Skydive.TextSize = 14
Skydive.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
Skydive.TextScaled = true
Skydive.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Skydive.Parent = PresetsContainer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = Float

local Title1 = Instance.new("TextLabel")
Title1.TextWrapped = true
Title1.Name = "Title1"
Title1.TextColor3 = Color3.fromRGB(255, 255, 255)
Title1.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title1.Text = "Selected Player"
Title1.Size = UDim2.new(1, -45, 0, 20)
Title1.Position = UDim2.new(1, 0, 0, 10)
Title1.AnchorPoint = Vector2.new(1, 0)
Title1.BorderSizePixel = 0
Title1.BackgroundTransparency = 1
Title1.TextXAlignment = Enum.TextXAlignment.Left
Title1.TextScaled = true
Title1.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Title1.TextSize = 14
Title1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title1.Parent = Window

local SelectedPlayerIcon = Instance.new("ImageLabel")
SelectedPlayerIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
SelectedPlayerIcon.Name = "SelectedPlayerIcon"
SelectedPlayerIcon.Image = "rbxassetid://84000073406100"
SelectedPlayerIcon.BackgroundTransparency = 1
SelectedPlayerIcon.Position = UDim2.new(0, -25, 0, 0)
SelectedPlayerIcon.Size = UDim2.new(0, 20, 0, 20)
SelectedPlayerIcon.BorderSizePixel = 0
SelectedPlayerIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SelectedPlayerIcon.Parent = Title1

local ViewButton = Instance.new("TextButton")
ViewButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ViewButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ViewButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ViewButton.Text = ""
ViewButton.Name = "ViewButton"
ViewButton.BackgroundTransparency = 0.9
ViewButton.Position = UDim2.new(0, 20, 0, 80)
ViewButton.Size = UDim2.new(0.5, -18, 0, 20)
ViewButton.BorderSizePixel = 0
ViewButton.TextSize = 14
ViewButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ViewButton.Parent = Window

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = ViewButton

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = ViewButton

local ViewIcon = Instance.new("ImageLabel")
ViewIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
ViewIcon.Name = "ViewIcon"
ViewIcon.AnchorPoint = Vector2.new(0.5, 0.5)
ViewIcon.Image = "rbxassetid://137944988884367"
ViewIcon.BackgroundTransparency = 1
ViewIcon.Position = UDim2.new(0.5, -35, 0.5, 0)
ViewIcon.Size = UDim2.new(0, 15, 0, 15)
ViewIcon.BorderSizePixel = 0
ViewIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ViewIcon.Parent = ViewButton

local ViewLabel = Instance.new("TextLabel")
ViewLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
ViewLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ViewLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ViewLabel.Text = "View"
ViewLabel.BackgroundTransparency = 1
ViewLabel.Name = "ViewLabel"
ViewLabel.Size = UDim2.new(0, 40, 0, 20)
ViewLabel.BorderSizePixel = 0
ViewLabel.TextSize = 14
ViewLabel.TextXAlignment = Enum.TextXAlignment.Left
ViewLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ViewLabel.Parent = ViewButton

local AttachButton = Instance.new("TextButton")
AttachButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AttachButton.TextColor3 = Color3.fromRGB(0, 0, 0)
AttachButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
AttachButton.Text = ""
AttachButton.AnchorPoint = Vector2.new(1, 0)
AttachButton.Name = "AttachButton"
AttachButton.BackgroundTransparency = 0.9
AttachButton.Position = UDim2.new(1, -10, 0, 80)
AttachButton.Size = UDim2.new(0.5, -18, 0, 20)
AttachButton.BorderSizePixel = 0
AttachButton.TextSize = 14
AttachButton.BackgroundColor3 = Color3.fromRGB(255, 183, 0)
AttachButton.Parent = Window

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = AttachButton

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Parent = AttachButton

local AttachIcon = Instance.new("ImageLabel")
AttachIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
AttachIcon.Name = "AttachIcon"
AttachIcon.AnchorPoint = Vector2.new(0.5, 0.5)
AttachIcon.Image = "rbxassetid://79652727279106"
AttachIcon.BackgroundTransparency = 1
AttachIcon.Position = UDim2.new(0.5, -35, 0.5, 0)
AttachIcon.Size = UDim2.new(0, 15, 0, 15)
AttachIcon.BorderSizePixel = 0
AttachIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AttachIcon.Parent = AttachButton

local AttachLabel = Instance.new("TextLabel")
AttachLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
AttachLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AttachLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
AttachLabel.Text = "Attach"
AttachLabel.BackgroundTransparency = 1
AttachLabel.Name = "AttachLabel"
AttachLabel.Size = UDim2.new(0, 40, 0, 20)
AttachLabel.BorderSizePixel = 0
AttachLabel.TextSize = 14
AttachLabel.TextXAlignment = Enum.TextXAlignment.Left
AttachLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AttachLabel.Parent = AttachButton

local SelectedPlayer = Instance.new("Frame")
SelectedPlayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
SelectedPlayer.AnchorPoint = Vector2.new(1, 0)
SelectedPlayer.BackgroundTransparency = 0.9
SelectedPlayer.Position = UDim2.new(1, -10, 0, 35)
SelectedPlayer.Name = "SelectedPlayer"
SelectedPlayer.Size = UDim2.new(1, -30, 0, 40)
SelectedPlayer.BorderSizePixel = 0
SelectedPlayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SelectedPlayer.Parent = Window

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = SelectedPlayer

local SelectedPlayerThumbnail = Instance.new("ImageLabel")
SelectedPlayerThumbnail.BorderColor3 = Color3.fromRGB(0, 0, 0)
SelectedPlayerThumbnail.Image = "rbxthumb://type=AvatarHeadShot&id=1414978355&w=420&h=420"
SelectedPlayerThumbnail.BackgroundTransparency = 1
SelectedPlayerThumbnail.Name = "PlayerThumbnail"
SelectedPlayerThumbnail.Size = UDim2.new(0, 40, 0, 40)
SelectedPlayerThumbnail.BorderSizePixel = 0
SelectedPlayerThumbnail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SelectedPlayerThumbnail.Parent = SelectedPlayer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.10000000149011612, 0)
UICorner.Parent = SelectedPlayerThumbnail

local SelectedPlayerDisplayName = Instance.new("TextLabel")
SelectedPlayerDisplayName.TextWrapped = true
SelectedPlayerDisplayName.Name = "PlayerDisplayName"
SelectedPlayerDisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedPlayerDisplayName.BorderColor3 = Color3.fromRGB(0, 0, 0)
SelectedPlayerDisplayName.Text = "Anthony"
SelectedPlayerDisplayName.Size = UDim2.new(1, -45, 0, 15)
SelectedPlayerDisplayName.Position = UDim2.new(1, 0, 0, 5)
SelectedPlayerDisplayName.AnchorPoint = Vector2.new(1, 0)
SelectedPlayerDisplayName.BorderSizePixel = 0
SelectedPlayerDisplayName.BackgroundTransparency = 1
SelectedPlayerDisplayName.TextXAlignment = Enum.TextXAlignment.Left
SelectedPlayerDisplayName.TextScaled = true
SelectedPlayerDisplayName.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
SelectedPlayerDisplayName.TextSize = 14
SelectedPlayerDisplayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SelectedPlayerDisplayName.Parent = SelectedPlayer

local SelectedPlayerUsername = Instance.new("TextLabel")
SelectedPlayerUsername.TextWrapped = true
SelectedPlayerUsername.Name = "PlayerUsername"
SelectedPlayerUsername.TextColor3 = Color3.fromRGB(178, 178, 178)
SelectedPlayerUsername.BorderColor3 = Color3.fromRGB(0, 0, 0)
SelectedPlayerUsername.Text = "@AnthonyIsntHere"
SelectedPlayerUsername.Size = UDim2.new(1, -45, 0, 12)
SelectedPlayerUsername.Position = UDim2.new(1, 0, 0, 20)
SelectedPlayerUsername.AnchorPoint = Vector2.new(1, 0)
SelectedPlayerUsername.BorderSizePixel = 0
SelectedPlayerUsername.BackgroundTransparency = 1
SelectedPlayerUsername.TextXAlignment = Enum.TextXAlignment.Left
SelectedPlayerUsername.TextScaled = true
SelectedPlayerUsername.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SelectedPlayerUsername.TextSize = 14
SelectedPlayerUsername.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SelectedPlayerUsername.Parent = SelectedPlayer

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.075, 0)
UICorner.Parent = Window


local AddPlayer = function(Player)
	if LastPlayer and Player.Name == LastPlayer.Name then
		TargetPlayer = Player
	end

	if not LivePlayers[Player] then
		local Thumbnail = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		local DisplayName = Player.DisplayName
		local Username = Player.Name

		if Thumbnail and DisplayName and Username then
			local ClonedTemplate = PlayerTemplateContainer:Clone()
			local PlayerThumbnail =  ClonedTemplate and ClonedTemplate:WaitForChild("PlayerThumbnail")
			local PlayerDisplayName = ClonedTemplate and ClonedTemplate:WaitForChild("PlayerDisplayName")
			local PlayerUsername = ClonedTemplate and ClonedTemplate:WaitForChild("PlayerUsername")

			ClonedTemplate.Visible = true
			ClonedTemplate.Parent = PlayersContainer
			PlayerThumbnail.Image = Thumbnail
			PlayerDisplayName.Text = DisplayName
			PlayerUsername.Text = Username

			ClonedTemplate.MouseButton1Click:Connect(function()
				TargetPlayer = Player
				LastPlayer = Player
				SelectedPlayerThumbnail.Image = Thumbnail
				SelectedPlayerDisplayName.Text = DisplayName
				SelectedPlayerUsername.Text = Username
			end)

			LivePlayers[Player] = ClonedTemplate
		end
	end
end

local RemovePlayer = function(Player)
	if Player == TargetPlayer then
		TargetPlayer = false
	end

	local ClonedTemplate = LivePlayers[Player]

	if ClonedTemplate then
		LivePlayers[Player] = false
		ClonedTemplate:Destroy()
	end
end

local SearchPlayerList = function()
	local BaseString = SearchBox.Text
	local ReturnedPlayers = GetPlayers(BaseString)

	if next(ReturnedPlayers) then
		for key, value in next, LivePlayers do
			value.Visible = false
			for plr, _ in next, ReturnedPlayers do
				if plr == key then
					value.Visible = true
				end
			end
		end
	else
		if BaseString == "" then
			for key, value in next, LivePlayers do
				value.Visible = true
			end
		else
			for key, value in next, LivePlayers do
				value.Visible = false
			end
		end
	end
end

local Spectate = function()
	if not SpectateDB then
		SpectateDB = true
		ViewLabel.Text = "Unview"
		ViewButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

		local SpectateThread = task.spawn(function()
			while SpectateDB do
				if TargetPlayer then
					local TargetCharacter = TargetPlayer.Character
					local TargetHumanoid = TargetCharacter and TargetCharacter:FindFirstChildWhichIsA("Humanoid")

					if TargetHumanoid then
						Camera.CameraSubject = TargetHumanoid
					end
				end

				task.wait()
			end
		end)
	else
		SpectateDB = false
		ViewLabel.Text = "View"
		ViewButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")

		if Humanoid then
			Camera.CameraSubject = Humanoid
		end
	end
end

local AttachFunc = function()
	if not AttachDB then
		AttachDB = true
		AttachLabel.Text = "Unattach"

		local AttachThread = task.spawn(function()
			while AttachDB do
				if TargetPlayer then
					local Character = Player.Character
					local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
					local RootPart = Character and Character:FindFirstChild("HumanoidRootPart") or Humanoid and Humanoid.RootPart

					local TargetCharacter = TargetPlayer.Character
					local TargetHumanoid = TargetCharacter and TargetCharacter:FindFirstChildWhichIsA("Humanoid")
					local TargetRootPart = TargetCharacter and TargetCharacter:FindFirstChild("HumanoidRootPart") or TargetHumanoid and TargetHumanoid.RootPart

					if RootPart and TargetRootPart then
						sethiddenproperty(RootPart, "PhysicsRepRootPart", TargetRootPart)
						RootPart.CFrame = TargetRootPart.CFrame * CFrame.new(PosX, PosY, PosZ) * CFrame.Angles(math.rad(AngX), math.rad(AngY), math.rad(AngZ))
						RootPart.AssemblyLinearVelocity = Vector3.zero
						RootPart.AssemblyAngularVelocity = Vector3.zero
					end
				end

				task.wait()
			end
		end)
	else
		AttachDB = false
		AttachLabel.Text = "Attach"
	end
end

local ReturnValues = function()
	local ParseText = function(Text)
		return tonumber(Text) or 0
	end

	PosX = ParseText(PositionSliderBox_X.Text)
	PosY = ParseText(PositionSliderBox_Y.Text)
	PosZ = ParseText(PositionSliderBox_Z.Text)

	AngX = ParseText(RotationSliderBox_X.Text)
	AngY = ParseText(RotationSliderBox_Y.Text)
	AngZ = ParseText(RotationSliderBox_Z.Text)

	PositionSliderPercentageFrame_X.Size = UDim2.new((math.clamp(PosX, -MaxPosition, MaxPosition) - -MaxPosition) / (MaxPosition - -MaxPosition), 0, 1, 0)
	PositionSliderPercentageFrame_Y.Size = UDim2.new((math.clamp(PosY, -MaxPosition, MaxPosition) - -MaxPosition) / (MaxPosition - -MaxPosition), 0, 1, 0)
	PositionSliderPercentageFrame_Z.Size = UDim2.new((math.clamp(PosZ, -MaxPosition, MaxPosition) - -MaxPosition) / (MaxPosition - -MaxPosition), 0, 1, 0)
	
	RotationSliderPercentageFrame_X.Size = UDim2.new((math.clamp(AngX, -MaxAngle, MaxAngle) - -MaxAngle) / (MaxAngle - -MaxAngle), 0, 1, 0)
	RotationSliderPercentageFrame_Y.Size = UDim2.new((math.clamp(AngY, -MaxAngle, MaxAngle) - -MaxAngle) / (MaxAngle - -MaxAngle), 0, 1, 0)
	RotationSliderPercentageFrame_Z.Size = UDim2.new((math.clamp(AngZ, -MaxAngle, MaxAngle) - -MaxAngle) / (MaxAngle - -MaxAngle), 0, 1, 0)
end

local AcceptDigitsOnly = function(...)
	local Arguments = {...}

	for _, x in next, Arguments do
		x:GetPropertyChangedSignal("Text"):Connect(function()
			local Digits = x.Text:match("^%-?%d*%.?%d*") or ""

			if x.Text ~= Digits then
				x.Text = Digits
			end

			ReturnValues()
		end)
	end
end

local PresetSpeed = function()
	PositionSliderBox_X.Text = "0"
	PositionSliderBox_Y.Text = "1"
	PositionSliderBox_Z.Text = "1"
	RotationSliderBox_X.Text = "-140"
	RotationSliderBox_Y.Text = "0"
	RotationSliderBox_Z.Text = "0"
	ReturnValues()
end

local PresetInfJump = function()
	PositionSliderBox_X.Text = "0"
	PositionSliderBox_Y.Text = "-5"
	PositionSliderBox_Z.Text = "0"
	RotationSliderBox_X.Text = "45"
	RotationSliderBox_Y.Text = "0"
	RotationSliderBox_Z.Text = "0"
	ReturnValues()
end

local PresetNoJump = function()
	PositionSliderBox_X.Text = "0"
	PositionSliderBox_Y.Text = "3"
	PositionSliderBox_Z.Text = "0"
	RotationSliderBox_X.Text = "-90"
	RotationSliderBox_Y.Text = "0"
	RotationSliderBox_Z.Text = "0"
	ReturnValues()
end

local PresetClimb = function()
	PositionSliderBox_X.Text = "0"
	PositionSliderBox_Y.Text = "-1.5"
	PositionSliderBox_Z.Text = "-1.75"
	RotationSliderBox_X.Text = "-45"
	RotationSliderBox_Y.Text = "0"
	RotationSliderBox_Z.Text = "0"
	ReturnValues()
end

local PresetSkydive = function()
	PositionSliderBox_X.Text = "0"
	PositionSliderBox_Y.Text = "-2"
	PositionSliderBox_Z.Text = "0"
	RotationSliderBox_X.Text = "90"
	RotationSliderBox_Y.Text = "0"
	RotationSliderBox_Z.Text = "0"
	ReturnValues()
end

local CloseGui = function()
	SpectateDB = false
	AttachDB = false
	Attach:Destroy()
end

Thumbnail.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
DisplayName.Text = Player.DisplayName
Username.Text = Player.Name

for _, x in next, Players:GetPlayers() do
	if x ~= Player then
		task.spawn(AddPlayer, x)
	end
end

Drag(UIContainer, .25, "Circular", "Out")
AcceptDigitsOnly(PositionSliderBox_X, PositionSliderBox_Y, PositionSliderBox_Z, RotationSliderBox_X, RotationSliderBox_Y, RotationSliderBox_Z)
CreateSlider(PositionSliderX, PositionSliderPercentageFrame_X, PositionSliderButton_X, -MaxPosition, MaxPosition, function(Value) PositionSliderBox_X.Text = Value end)
CreateSlider(PositionSliderY, PositionSliderPercentageFrame_Y, PositionSliderButton_Y, -MaxPosition, MaxPosition, function(Value) PositionSliderBox_Y.Text = Value end)
CreateSlider(PositionSliderZ, PositionSliderPercentageFrame_Z, PositionSliderButton_Z, -MaxPosition, MaxPosition, function(Value) PositionSliderBox_Z.Text = Value end)
CreateSlider(RotationSliderX, RotationSliderPercentageFrame_X, RotationSliderButton_X, -MaxAngle, MaxAngle, function(Value) RotationSliderBox_X.Text = Value end)
CreateSlider(RotationSliderY, RotationSliderPercentageFrame_Y, RotationSliderButton_Y, -MaxAngle, MaxAngle, function(Value) RotationSliderBox_Y.Text = Value end)
CreateSlider(RotationSliderZ, RotationSliderPercentageFrame_Z, RotationSliderButton_Z, -MaxAngle, MaxAngle, function(Value) RotationSliderBox_Z.Text = Value end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(SearchPlayerList)

Close.MouseButton1Click:Connect(CloseGui)
ViewButton.MouseButton1Click:Connect(Spectate)
AttachButton.MouseButton1Click:Connect(AttachFunc)
Speed.MouseButton1Click:Connect(PresetSpeed)
InfJump.MouseButton1Click:Connect(PresetInfJump)
NoJump.MouseButton1Click:Connect(PresetNoJump)
Climb.MouseButton1Click:Connect(PresetClimb)
Skydive.MouseButton1Click:Connect(PresetSkydive)
Players.PlayerAdded:Connect(AddPlayer)
Players.PlayerRemoving:Connect(RemovePlayer)
