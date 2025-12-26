-- Script made by AnthonyIsntHere
-- I don't think I'm the first one to discover this but making the script made my brain explode lol
-- It's literally a force right-to-left but for roblox chat :exploding-head:

-- use the loadstring below for automatic updates lol
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/refs/heads/main/scripts/Kasra%20Chat%20Bypass.lua", true))()

if not game:IsLoaded() then
    game.Loaded:wait()
end

local Kasra = "ﹺ"
local WordList = {
	["ass"] = "ﹺsﹺsﹺa",
	["asshole"] = "ﹺleﹺhoﹺsﹺsﹺa",
	["bastard"] = "ﹺrdﹺtaﹺbas",
	["beaner"] = "ﹺrﹺneﹺaﹺbe",
	["bitch"] = "ﹺhﹺcﹺitﹺb",
	["blowjob"] = "ﹺobﹺjﹺowﹺbl",
	["bullshit"] = "ﹺitﹺhﹺsﹺllﹺbu",
	["cock"] = "ﹺckﹺoﹺc",
	["cunt"] = "ﹺntﹺuﹺc",
	["dick"] = "ﹺkﹺcﹺdi",
	["dickhead"] = "ﹺadﹺheﹺkﹺcﹺdi",
	["dumbass"] = "ﹺsﹺsﹺaﹺmbﹺdu",
	["fatass"] = "ﹺsﹺsﹺaﹺtﹺfa",
	["fag"] = "ﹺgﹺaﹺf",
	["faggot"] = "ﹺotﹺggﹺaﹺf",
	["fuck"] = "ﹺkﹺcﹺuﹺf",
	["fucked"] = "ﹺedﹺkﹺcﹺuﹺf",
	["fucker"] = "ﹺerﹺkﹺcﹺuﹺf",
	["fucking"] = "ﹺgﹺinﹺkﹺcﹺuﹺf",
	["horseshit"] = "ﹺitﹺhﹺsﹺseﹺrﹺoﹺh",
	["jackass"] = "ﹺsﹺsﹺaﹺckﹺaﹺj",
	["jew"] = "ﹺwﹺeﹺj",
	["kike"] = "ﹺkeﹺki",
	["motherfucker"] = "ﹺerﹺkﹺcﹺuﹺfﹺerﹺthﹺmo",
	["nigga"] = "ﹺaﹺgﹺgﹺiﹺnﹺ",
	["nigger"] = "ﹺrﹺeﹺggﹺiﹺn",
	["retard"] = "ﹺrdﹺaﹺtﹺre",
	["pussy"] = "ﹺyﹺssﹺpu",
	["shit"] = "ﹺitﹺhﹺs",
	["slut"] = "ﹺlﹺuﹺsl",
	["tranny"] = "ﹺyﹺnnﹺaﹺtr",
	["whore"] = "ﹺreﹺoﹺhﹺw",

	--misc
	["discord"] = "ﹺrdﹺoﹺcﹺisﹺd",
	["kys"] = "ﹺsﹺyﹺk",
	["lmao"] = "ﹺoﹺaﹺlm",
	["lmfao"] = "ﹺoﹺaﹺmfﹺl",
	["porn"] = "ﹺnﹺrﹺoﹺp",
	["rape"] = "ﹺeﹺpﹺaﹺr",
	["raping"] = "gﹺnﹺiﹺpﹺaﹺr",
	["sex"] = "ﹺxﹺeﹺs",
	["sexy"] = "ﹺyﹺxﹺse",
	["stfu"] = "uﹺfﹺtﹺs",
	["virgin"] = "ﹺinﹺrgﹺvi",
	["wtf"] = "ﹺfﹺtﹺw",
	["yourself"] = "ﹺlfﹺseﹺurﹺyo",
}

local NotificationTitle = "Kasra bypass loaded"

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

local TextChannels = TextChatService:WaitForChild("TextChannels")
local Chat = TextChannels:WaitForChild("RBXGeneral")

local ExperienceChat = CoreGui:WaitForChild("ExperienceChat")
local ChatBar = ExperienceChat:FindFirstChildWhichIsA("TextBox", true) do
    if not ChatBar then
        local Timer = tick() + 5
        
        repeat task.wait() until ExperienceChat:FindFirstChildWhichIsA("TextBox", true) or (tick() > Timer)
       
        local ChatBar = ExperienceChat:FindFirstChildWhichIsA("TextBox", true) or false
        
        if not ChatBar then
            return Notify(NotificationTitle, "Failed to find ChatBar!", 10)
        end
    end
end

local Notify = function(_Title, _Text , Time)
    StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Icon = "rbxassetid://2541869220", Duration = Time})
end

ChatBar.FocusLost:Connect(function(Entered)
	if Entered then
		local Message = ChatBar.Text
		ChatBar.Text = ""
		ChatBar:ReleaseFocus()

		local Bypassed = false

		local Reversed = {}
		local Positions = {}

		local Words = Message:split(" ")

		local MatchWord = function(str)
			str = str:lower()

			for k, v in next, WordList do
				if str:match("^" .. k) then
					return v, k
				end
			end
		end

		for i = #Words, 1, -1 do
			Reversed[#Reversed + 1] = Words[i]
		end

		local FinalMessage = ""
		for i = 1, #Reversed do
			FinalMessage = FinalMessage .. Reversed[i]
			if i < #Reversed then
				FinalMessage = FinalMessage .. " " .. Kasra

				local Matched = MatchWord(Reversed[i])
				if Matched then
					Positions[#Positions + 1] = i
				end
			end
		end

		for _, x in next, Positions do
			local i = 0
			FinalMessage = FinalMessage:gsub(Kasra, function()
				i += 1
				
				if i == x - 1 then
					return ""
				end
			end)
		end

		for Index, Word in next, Words do
			local FoundWord, MatchedKey = MatchWord(Word)

			if FoundWord then
				local ExtraLetters = Word:sub(#MatchedKey + 1) or ""
				
				FoundWord = Kasra .. ExtraLetters .. FoundWord
				FoundWord = (FoundWord:gsub("%a", function(x)
					for y in Word:gmatch("%a") do
						if y:match("%u") and y:lower():match(x) then
							return x:upper()
						end
					end
				end))

				FinalMessage = FinalMessage:gsub("(%f[%a]" .. Word .. "%a*)", FoundWord .. Kasra)
				Bypassed = true
			end
		end

		if Bypassed then
			FinalMessage = Kasra .. FinalMessage
			FinalMessage = FinalMessage:gsub(Kasra .. Kasra .. "+", Kasra)
			Message = FinalMessage
		end

		if Message ~= "" then
			Chat:SendAsync(Message)
		end
	end
end)

Notify("Kasra Chat Bypass", "Script made by AnthonyIsntHere", 10)
