--loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/main/scripts/hiddenproperty.lua", true))()
getgenv().gethiddenproperty = gethiddenproperty or newcclosure(function(_Instance, _Property)
	local x, UGCValidationService = pcall(game.GetService, game, "UGCValidationService")

	if x then
		local y, z = pcall(UGCValidationService.GetPropertyValue, UGCValidationService, _Instance, _Property)
		
		if y then
			return z
		end
	end
end)

getgenv().sethiddenproperty = sethiddenproperty or newcclosure(function(_Instance, _Property, _Value)
	local setscriptable = setscriptable

	if setscriptable == nil then
		return warn("setscriptable does not exist")
	else
		setscriptable(_Instance, _Property, true)
		_Instance[_Property] = _Value
	end
end)
