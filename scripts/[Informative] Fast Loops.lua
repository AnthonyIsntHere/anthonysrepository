--Made this to help out people who are in need of fast wait loops

local RunService = game:GetService("RunService")

local DefaultWait = wait

--local Stepped = RunService.Stepped --(SPECIAL USES)
local RenderStepped = RunService.RenderStepped
local Heartbeat = RunService.Heartbeat

local TaskWait = task.wait

print(
    table.concat(
        {
            DefaultWait(),
            RenderStepped:Wait(),
            Heartbeat:Wait(),
            TaskWait()
        }, "\n"
    )
)

--I prefer to use task.wait() because it is as fast as heartbeat and much easier to access

--Method One
while true do
    --Input
    task.wait()
end

--Method Two
local Iterator = 0
while true do
    i += 1
    if i % 5 == 0 then
        task.wait()
    end
    print(i)
end

--Method Three
local Timer = 5 -- Seconds until stop
local OldTime = tick()
repeat
    --Input
until tick() > OldTime + Timer
