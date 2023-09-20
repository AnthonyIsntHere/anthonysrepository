-- CHAT BYPASS PROJECT
-- Script made by AnthonyIsntHere
-- Method made by cam1494

-- have fun skids!

local Emoji = "\226\172\156"
local SpaceOut = false

local Cyrillics = {
    ["a"] = "\208\176",
    ["c"] = "\209\129",
    ["e"] = "\208\181",
    ["h"] = "\210\187",
    ["i"] = "\209\150",
    ["j"] = "\209\152",
    ["l"] = "\211\143",
    ["o"] = "\208\190",
    ["p"] = "\209\128",
    ["y"] = "\209\131",
    ["x"] = "\209\133",
    ["A"] = "\208\144",
    ["B"] = "\208\146",
    ["C"] = "\208\161",
    ["E"] = "\208\149",
    ["H"] = "\208\157",
    ["I"] = "\208\134",
    ["J"] = "\208\136",
    ["K"] = "\226\132\170",
    ["M"] = "\208\156",
    ["O"] = "\208\158",
    ["P"] = "\208\160",
    ["T"] = "\208\162",
    ["X"] = "\208\165",
    ["Y"] = "\210\174"
}

local Bypasses = {
    ["anal"] = "an*al",
    ["ass"] = "as*s",
    ["asshole"] = "as*sh*o*le",
    ["autist"] = "au*ti*st",
    ["bastard"] = "ba*sta*rd",
    ["blackie"] = "bl*ack*ie",
    ["beaner"] = "beane*r", 
    ["bitch"] = "bit*ch",
    ["blowjob"] = "blow*job",
    ["boob"] = "boo*b",
    ["boner"] = "bon*er", 
    ["cock"] = "co*ck",
    ["condom"] = "co*ndo*m",
    ["coon"] = "co*on",
    ["creampie"] = "cr*eam*pie",
    ["cunt"] = "cu*nt",
    ["cum"] = "cu*m",
    ["dick"] = "di*ck",
    ["dildo"] = "di*ldo",
    ["dumbass"] = "du*mba*ss",
    ["dyke"] = "dy*ke",
    ["fag"] = "fa*g",
    ["fatass"] = "fa*ta*ss",
    ["fuck"] = "fu*ck",
    ["fucking"] = "fu*ck*in*g",
    ["gaylord"] = "gayl*ord",
    ["hentai"] = "hen*ta*i",
    ["hoe"] = "h*oe",
    ["holocaust"] = "hol*oca*st",
    ["hooker"] = "h*oo*ker",
    ["horny"] = "h*or*ny",
    ["http"] = "ht*tp",
    ["jew"] = "je*w",
    ["jiggabo"] = "ji*gga*bo",
    ["jizz"] = "ji*zz",
    ["kkk"] = "kk*k",
    ["kike"] = "ki*ke",
    ["kink"] = "ki*nk",
    ["kyke"] = "ky*ke",
    ["masturbate"] = "mas*tur*ba*te",
    ["masturbating"] = "mas*tur*bat*ing",
    ["masturbation"] = "mas*tur*bat*ion",
    ["midget"] = "mid*get",
    ["moan"] = "mo*an",
    ["molest"] = "mo*lest",
    ["motherfucker"] = "motherf*uc*ker",
    ["nazi"] = "na*zi",
    ["nignog"] = "ni*gno*g",
    ["nigga"] = "ni*gga",
    ["nigger"] = "ni*gger",
    ["nudes"] = "nu*des",
    ["piss"] = "pi*ss",
    ["pedo"] = "pe*do",
    ["pedophile"] = "pe*dophi*le",
    ["penis"] = "pe*ni*s",
    ["pussy"] = "pu*ssy",
    ["porn"] = "po*rn",
    ["rape"] = "ra*pe",
    ["raped"] = "ra*ped",
    ["raping"] = "ra*ping",
    ["rapist"] = "ra*pi*st",
    ["retard"] = "reta*rd",
    ["sex"] = "se*x",
    ["shit"] = "sh*it",
    ["slave"] = "sl*ave",
    ["slut"] = "sl*ut",
    ["sperm"] = "spe*rm",
    ["tampon"] = "tamp*on",
    ["terrorist"] = "ter*rori*st",
    ["testicle"] = "test*ic*le",
    ["tit"] = "ti*t",
    ["vagina"] = "va*gina",
    ["whore"] = "who*re",
    -- MISC.
    ["/byp"] = "",
    ["asf"] = "asf",
    ["balls"] = "b*al*ls",
    ["discord"] = "disco*rd",
    ["idfc"] = "idf*c",
    ["idfk"] = "idf*k",
    ["kill"] = "ki*ll",
    ["kys"] = "ky*s",
    ["lmao"] = "l*ma*o",
    ["lmfao"] = "l*mf*ao",
    ["love"] = "lo*ve",
    ["nuts"] = "n*uts", 
    ["schizo"] = "sch*izo",
    ["stfu"] = "stf*u",
    ["suck"] = "*suc*k",
    ["wtf"] = "wt*f",
    ["yourself"] = "y*our*se*lf"
}

if not getgenv().AntiChatLogger then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/main/scripts/AntiChatLogger.lua", true))()
end

local Bypass_Method = ""
local InvisUnicode = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/main/misc/ReservedUnicode.lua"))()

local Players = game:GetService("Players")
local ChatService = game:GetService("Chat")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage:FindFirstChild("SayMessageRequest", true)

local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui")

local Chat = PlayerGui and PlayerGui:FindFirstChild("Chat")
local ChatBar = Chat and Chat:FindFirstChild("ChatBar", true)

local GetRandomStr = function()
    local Letters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
    
    local Str = ""
    local Length = math.random(12, 32)

    for i = 1, Length do
        Str = Str .. Letters[math.random(#Letters)]
    end
    
    return Str
end

if ChatService.BubbleChatEnabled then
    Bypass_Method = ""
    Bypass_Method = Bypass_Method:gsub("*", string.rep(Emoji, 6))
    if SpaceOut then
        Bypass_Method = Bypass_Method .. ""
    end
else
    Bypass_Method = string.format(Bypass_Method, string.rep("\226\151\189", 6))
end

local FilterReset = task.spawn(function()
    while true do
        if ChatBar:IsFocused() then
            ChatService:FilterStringForBroadcast(GetRandomStr(), Player)
        end
        task.wait(.25)
    end
end)

local Chat_Bypass; Chat_Bypass = hookmetamethod(Remote, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    
    if self == Remote and Method == "FireServer" then
        local Message = Arguments[1]
        local Split = Message:split(" ")
        local Replaced = false
        local Whispered = ""

        for _, x in next, Split do
            if x:lower():match("/w") and Message:lower():match("^(/w )") then
                Whispered = x .. " " .. Split[2]
                Message = Message:gsub(Whispered, "")
            end
            
            for _, Bypass in next, Bypasses do
                local ExactMatchedWord = x:match(".+")
                local MatchedWord = ""
                
                if ExactMatchedWord and ExactMatchedWord:lower():match(_) then
                    Replaced = Bypass
                    for y in Replaced:gmatch("%a") do
                        for z in x:gmatch(".") do
                            if z:lower():match(y) then
                                if y == y:lower() then
                                    Replaced = Replaced:gsub(y, z:lower())
                                else
                                    Replaced = Replaced:gsub(y, z)
                                end
                            end
                        end
                    end

                    if ExactMatchedWord and ExactMatchedWord:lower():match("/byp$") then
                        Message = Message:gsub(ExactMatchedWord, "")
                    end

                    Replaced = Replaced:gsub("*", string.rep(InvisUnicode, 1))
                    MatchedWord = ExactMatchedWord:lower():match(_)
                    ExactMatchedWord = ExactMatchedWord:lower():match("^" .. _ .."$")

                    Message = Message:gsub("^%s+", "")

                    if ExactMatchedWord then
                        Message = Message:gsub(ExactMatchedWord, Replaced)
                        break
                    else
                        if MatchedWord then
                            Message = Message:gsub(MatchedWord, Replaced)
                        else
                            Replaced = ""
                        end
                    end
                end
            end
        end
        
        if type(Replaced) == "string" then
            for x in Message:gmatch("%a") do
                if Cyrillics[x] then
                    Message = Message:gsub(x, Cyrillics[x])
                end
            end
            
            Message = "%s" .. Message:gsub("%s", "")

            if Whispered ~= "" then
                Message = Message:format(Whispered .. " " .. Bypass_Method)
            else
                Message = Message:format(Bypass_Method)
            end
            
            Arguments[1] = Message
        end
        
        return Chat_Bypass(self, table.unpack(Arguments))
    end
    
    return Chat_Bypass(self, ...)
end)
