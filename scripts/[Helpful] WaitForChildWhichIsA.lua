local WaitForChildWhichIsA = function(self, ClassName, Recursive)
    local Final = false

    if Recursive then
        while true do
            local x = self.DescendantAdded:wait()
            
            if x:IsA(ClassName) then
                Final = x
                break
            end
        end
    else
        while true do
            local x = self.ChildAdded:wait()
            
            if x:IsA(ClassName) then
                Final = x
                break
            end
        end
    end

    return Final
end
