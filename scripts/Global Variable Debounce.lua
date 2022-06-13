if not getgenv().Debounce then
    getgenv().Debounce = false
end

if not getgenv().Debounce then
    getgenv().Debounce = true
    print("hi")
    wait(1)
    getgenv().Debounce = false
end

--i think it works for _G too
