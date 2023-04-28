-- // Status UI by AnthonyIsntHere
local ServerIp, NetworkClient = "", game:GetService("NetworkClient") do
    NetworkClient.ConnectionAccepted:Connect(function(Ip)
        if Ip then
            ServerIp = Ip:split("|")[1]
        end
    end)
end

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")

local OldTime = tick()
repeat task.wait() until CoreGui:FindFirstChild("TopBarFrame", true) or tick() > (OldTime + 5)
local TopBarFrame = CoreGui:FindFirstChild("TopBarFrame", true)
local RightFrame = TopBarFrame and TopBarFrame:WaitForChild("RightFrame")
local Layout = RightFrame:WaitForChild("Layout")

if not RightFrame then
    return warn("There is no TopBar UI.")
end

local Stats = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

if syn then
    syn.protect_gui(Stats)
end

Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom

Stats.Name = "Stats"
Stats.Parent = RightFrame
Stats.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Stats.BackgroundTransparency = 0.500
Stats.Size = UDim2.new(0, 285, 0, 32)
Stats.Font = Enum.Font.SourceSans
Stats.Text = "Fps [ 69 ]  Ping [ 420 ms ]  Region [ Unknown ]"
Stats.TextColor3 = Color3.fromRGB(255, 255, 255)
Stats.TextSize = 1
Stats.TextWrapped = true

UICorner.Parent = Stats

UITextSizeConstraint.Parent = Stats
UITextSizeConstraint.MaxTextSize = 25
UITextSizeConstraint.MinTextSize = 16

local StatsTbl = {
    Fps = "",
    Ping = "",
    Region = ""
}

local OutputFPS = function()
    local Time = time or os.clock
    local FramesTbl = {}
    local OldTime = Time()
    local UpdateTime
    
    RunService.Heartbeat:Connect(function()
        UpdateTime = Time()
        
    	for i = #FramesTbl, 1, -1 do
    		FramesTbl[i + 1] = FramesTbl[i] >= UpdateTime - 1 and FramesTbl[i] or nil
    	end
    
    	FramesTbl[1] = UpdateTime
    	
    	local FpsValue = tostring(math.floor(Time() - OldTime >= 1 and #FramesTbl or #FramesTbl / (Time() - OldTime)))
    	StatsTbl.Fps = string.format("Fps [ %s ] ", FpsValue)
    end)
end

local OutputPing = function()
    RunService.RenderStepped:Connect(function()
        local DataPing = StatsService:FindFirstChild("Data Ping", true)
        local PingValue = DataPing and DataPing:GetValueString() and DataPing:GetValueString():split(".")[1]
        
        if PingValue and  PingValue:match("%d+$") then
            PingValue = string.format("%s ms", PingValue)
            StatsTbl.Ping = string.format("Ping [ %s ] ", PingValue)
        end
    end)
end

local OutputRegion = function()
    repeat task.wait() until ServerIp
    local GetInfo = game:HttpGet(string.format("http://ip-api.com/json/%s", ServerIp))
    
    if GetInfo then
        local DecodedInfo = HttpService:JSONDecode(GetInfo)
        local ContinentalRegion = DecodedInfo.timezone:split("/")[1]
        StatsTbl.Region = string.format("Region [ %s ] ", ContinentalRegion)
    else
        StatsTbl.Region = "Unknown"
    end
end

OutputFPS()
OutputPing()
OutputRegion()

local DisplayStats = function()
    Stats.Text = StatsTbl.Fps .. StatsTbl.Ping .. StatsTbl.Region
end

RunService.Heartbeat:Connect(DisplayStats)
