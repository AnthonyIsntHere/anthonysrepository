-- This is a function that allows custom tweening and dragging of uis
-- A good config is Drag(UIObject, .25, "Circular", "Out") for background frames

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Tween = function(Object, Time, Style, Direction, Property)
	return TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction]), Property)
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

--3d illusion snake thing
for i = 1, 125 do
    local GUI = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame",GUI)
    Frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    Frame.Position = UDim2.new(0, 0 + i / 100, 0, 0)
    Frame.Size = UDim2.new(0, 50, 0, 50)

    Drag(Frame, .1 + i / 100, "Sine", "Out")
end
