local _blacklistedClientEvents = {
	"esx:getSharedObject",
	"ambulancier:selfRespawn",
	"bank:transfer",
	"esx_ambulancejob:revive",
	"esx-qalle-jail:openJailMenu",
	"esx_jailer:wysylandoo",
	"esx_society:openBossMenu",
	"esx:spawnVehicle",
	"esx_status:set",
	"HCheat:TempDisableDetection",
	"UnJP",
}

local _blacklistedCommands = {
	"brutan",
	"chocolate",
	"haha",
	"killmenu",
	"KP",
	"lol",
	"lynx",
	"opk",
	--"panic",
	"panickey",
	"panik",
	-- "pk",
	"FunCtionOk",
	"porcodiooo",
	"demmerda",
	"puzzi",
	"jolmany",
}

local _retrieved = {}

function RegisterCallbacks()
	Chat:RegisterAdminCommand("pwnzorban", function(source, args, rawCommand)
		local player = Fetch:SID(tonumber(args[1]))
		if player ~= nil then
			Punishment.Ban:Source(player:GetData("Source"), -1, args[2], "Pwnzor")
		end
	end, {
		help = "Fake Pwnzor Ban",
		params = {
			{
				name = "Target",
				help = "State ID of Who You Want To Ban",
			},
			{
				name = "Reason",
				help = "Reason For The Ban",
			},
		},
	}, 2)
	
	Chat:RegisterAdminCommand("pwnzorsource", function(source, args, rawCommand)
		local player = Fetch:Source(tonumber(args[1]))
		if player ~= nil then
			Punishment.Ban:Source(tonumber(args[1]), -1, args[2], "Pwnzor")
		end
	end, {
		help = "Ban Player From Server",
		params = {
			{
				name = "Target",
				help = "Source of Who You Want To Ban",
			},
			{
				name = "Reason",
				help = "Reason For The Ban",
			},
		},
	}, 2)

	Callbacks:RegisterServerCallback("Pwnzor:GetEvents", function(source, data, cb)
		if not Pwnzor.Players:Get(source, "GetEvents") then
			Pwnzor.Players:Set(source, "GetEvents")
			cb(_blacklistedClientEvents)
		else
			if not Fetch:Source(source).Permissions:IsAdmin() then
				Punishment.Ban:Source(source, -1, "Attempt To Recall GetEvents", "Pwnzor")
			end
		end
	end)

	Callbacks:RegisterServerCallback("Pwnzor:GetCommands", function(source, data, cb)
		if not Pwnzor.Players:Get(source, "GetCommands") then
			Pwnzor.Players:Set(source, "GetCommands")
			cb(_blacklistedCommands)
		else
			if not Fetch:Source(source).Permissions:IsAdmin() then
				Punishment.Ban:Source(source, -1, "Attempt To Recall GetCommands", "Pwnzor")
			end
		end
	end)

	Callbacks:RegisterServerCallback("Pwnzor:AFK", function(source, data, cb)
		if Config.Components.AFK.Enabled then
			Punishment:Kick(source, "You Were Kicked For Being AFK", "Pwnzor")
		end
	end)

	Callbacks:RegisterServerCallback("Pwnzor:Trigger", function(source, data, cb)
		cb("💙 From Pwnzor 🙂")
		if not Fetch:Source(source).Permissions:IsAdmin() then
			Logger:Info(
				"Pwnzor",
				string.format("Pwnzor Trigger For %s: %s (check) %s (match)", source, data.check, data.match),
				{
					console = true,
					file = true,
					database = true,
					discord = {
						embed = true,
						type = "error",
						webhook = GetConvar("discord_pwnzor_webhook", ''),
					},
				}
			)
			Punishment.Ban:Source(
				source,
				-1,
				string.format("Pwnzor Trigger: %s (check) %s (match)", data.check, data.match),
				"Pwnzor"
			)
		end
	end)
end
