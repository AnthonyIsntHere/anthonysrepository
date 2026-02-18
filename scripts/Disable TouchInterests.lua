-- Made by AnthonyIsntHere
-- replicates to da server
for _, x in next, workspace:GetDescendants() do
    if x:IsA("TouchTransmitter") then
        x:Destroy()
        continue
    end

    if x:IsA("BasePart") and (x.CanTouch or x.CanQuery) then
        x.CanTouch, x.CanQuery = false, false
    end
end
