// My first attempt at a js script for roblox LOL

var SpecificGameId = false; 
var GameId = null; // gameId: 6711910361 [Set SpecificGameId to true to use this]
var CurrentGameId = null; // Leave SpecificGameId to false if you are on the game's page.

var JobId = null; // Change this if you have a JobId

function GetElement(Id){
	return document.getElementById(Id);
};

if (!SpecificGameId){
	let IdElement = GetElement("rbx-friends-running-games");
	let Data = IdElement.dataset;
	CurrentGameId = Data.placeid;
};

let GameLauncher = Roblox.GameLauncher;
let JoinId = GameLauncher.joinMultiplayerGame;
let JoinJobId = GameLauncher.joinGameInstance;

if (SpecificGameId){
	if (JobId != null) {
		JoinJobId(GameId, JobId);
	} else{
		JoinId(GameId);
	};
} else if (!SpecificGameId){
	if (JobId != null) {
		JoinJobId(CurrentGameId, JobId);
	} else{
		JoinId(CurrentGameId);
	};
};
