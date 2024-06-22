AddEventHandler("Admin:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Database = exports["mythic-base"]:FetchComponent("Database")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Punishment = exports["mythic-base"]:FetchComponent("Punishment")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	C = exports["mythic-base"]:FetchComponent("Config")
	Properties = exports["mythic-base"]:FetchComponent("Properties")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
	Tasks = exports["mythic-base"]:FetchComponent("Tasks")
	Pwnzor = exports["mythic-base"]:FetchComponent("Pwnzor")
	WebAPI = exports["mythic-base"]:FetchComponent("WebAPI")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Admin", {
		"Database",
		"Logger",
		"Callbacks",
		"Fetch",
		"Utils",
		"Jobs",
		"Punishment",
		"Chat",
		"Middleware",
		"Config",
		"Properties",
		"Execute",
		"Tasks",
		"Pwnzor",
		"WebAPI",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterCallbacks()
		RegisterChatCommands()
		StartDashboardThread()

		Middleware:Add('Characters:Spawning', function(source)
			local player = Fetch:Source(source)

			if player and player.Permissions:IsStaff() then
				local highestLevel, highestGroup, highestGroupName = 0, nil, nil
				for k, v in ipairs(player:GetData('Groups')) do
					if C.Groups[tostring(v)] ~= nil and (type(C.Groups[tostring(v)].Permission) == 'table') then
						if C.Groups[tostring(v)].Permission.Level > highestLevel then
							highestLevel = C.Groups[tostring(v)].Permission.Level
							highestGroup = v
							highestGroupName = C.Groups[tostring(v)].Name
						end
					end
				end

				TriggerClientEvent('Admin:Client:Menu:RecievePermissionData', source, {
					Source = source,
					Name = player:GetData('Name'),
					AccountID = player:GetData('AccountID'),
					Identifier = player:GetData('Identifier'),
					Groups = player:GetData('Groups'),
				}, highestGroup, highestGroupName, highestLevel)
			end
		end, 5)
	end)
end)

function RegisterChatCommands()
	Chat:RegisterAdminCommand("admin", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:Menu:Open", source)
	end, {
		help = "[Admin] Open Admin Menu",
	}, 0)

	Chat:RegisterStaffCommand("staff", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:Menu:Open", source)
	end, {
		help = "[Staff] Open Staff Menu",
	}, 0)

	Chat:RegisterStaffCommand("lookup", function(source, args, rawCommand)
		if tonumber(args[1]) then
			local str = "Account ID: %s, Account Name: %s, State ID: %s, Character Name: %s, Deleted: %s"

			local target = Fetch:SID(tonumber(args[1]))
			if target ~= nil then
				local tChar = target:GetData("Character")
				str = str .. ", Server ID (Source): %s"
				Chat.Send.System:Single(
					source,
					string.format(
						str,
						target:GetData("AccountID"),
						target:GetData("Name"),
						args[1],
						string.format("%s %s", tChar:GetData("First"), tChar:GetData("Last")),
						"No",
						target:GetData("Source")
					)
				)
			else
				Database.Game:findOne({
					collection = "characters",
					query = {
						SID = tonumber(args[1]),
					},
				}, function(success, tChar)
					if #tChar == 0 then
						Chat.Send.System:Single(source, "Invalid State ID")
					else
						local tUser = WebAPI.GetMember:AccountID(tChar[1].User)
						if tUser ~= nil then
							Chat.Send.System:Single(
								source,
								string.format(
									str,
									tChar[1].User,
									tUser.name,
									tChar[1].SID,
									string.format("%s %s", tChar[1].First, tChar[1].Last),
									(tChar[1].Deleted and "Yes" or "No")
								)
							)
						else
							Chat.Send.System:Single(source, "Invalid State ID")
						end
					end
				end)
			end
		else
			Chat.Send.System:Single(source, "Invalid State ID")
		end
	end, {
		help = "[Staff] Lookup Data About A State ID",
		params = {
			{
				name = "State ID",
				help = "State ID of who you want to lookup",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("noclip", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:NoClip", source, false)
	end, {
		help = "[Admin] Toggle NoClip",
	}, 0)

	Chat:RegisterAdminCommand("noclip:dev", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:NoClip", source, true)
	end, {
		help = "[Developer] Toggle Developer Mode NoClip",
	}, 0)

	Chat:RegisterAdminCommand("noclip:info", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:NoClipInfo", source)
	end, {
		help = "[Developer] Get NoClip Camera Info",
	}, 0)

	Chat:RegisterAdminCommand("marker", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:Marker", source, tonumber(args[1]) + 0.0, tonumber(args[2]) + 0.0)
	end, {
		help = "Place Marker at Coordinates",
		params = {
			{
				name = "X",
				help = "X Coordinate",
			},
			{
				name = "Y",
				help = "Y Coordinate",
			},
		},
	}, 2)

	Chat:RegisterStaffCommand("cpcoords", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:CopyCoords", source, args[1])
		Execute:Client(source, "Notification", "Success", "Copied Coordinates")
	end, {
		help = "[Dev] Copy Coords",
		params = {
			{
				name = "Type",
				help = "Type of Coordinate (vec3, vec4, vec2, table, z, h, rot)",
			},
		},
	}, -1)

	Chat:RegisterAdminCommand("cpproperty", function(source, args, rawCommand)
		local nearProperty = Properties.Utils:IsNearProperty(source)
		if nearProperty?.propertyId then
			Execute:Client(source, "Admin", "CopyClipboard", nearProperty?.propertyId)
			Execute:Client(source, "Notification", "Success", "Copied Property ID")
		end
	end, {
		help = "[Dev] Copy Property ID of Closest Property",
	}, 0)

	-- Chat:RegisterStaffCommand("record", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Admin:Client:Recording", source, 'record')
	-- end, {
	-- 	help = "[Staff] Record With R* Editor",
	-- }, 0)

	-- Chat:RegisterStaffCommand("recordstop", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Admin:Client:Recording", source, 'stop')
	-- end, {
	-- 	help = "[Staff] Record With R* Editor",
	-- }, 0)

	-- Chat:RegisterStaffCommand("recorddel", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Admin:Client:Recording", source, 'delete')
	-- end, {
	-- 	help = "[Staff] Record With R* Editor",
	-- }, 0)

	-- Chat:RegisterStaffCommand("recordedit", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Admin:Client:Recording", source, 'editor')
	-- end, {
	-- 	help = "[Staff] Record With R* Editor",
	-- }, 0)

	Chat:RegisterAdminCommand("setped", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:ChangePed", source, args[1])
	end, {
		help = "[Admin] Set Ped",
		params = {
			{
				name = "Ped",
				help = "Ped Model",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("staffcam", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:NoClip", source, true)
	end, {
		help = "[Staff] Camera Mode",
	}, 0)

	Chat:RegisterAdminCommand("zsetped", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:ChangePed", tonumber(args[1]), args[2])
	end, {
		help = "[Admin] Set Ped",
		params = {
			{
				name = "Source (Lazy)",
				help = "Source",
			},
			{
				name = "Ped",
				help = "Ped Model",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("nuke", function(source, args, rawCommand)
		TriggerClientEvent("Admin:Client:NukeCountdown", -1)
		Wait(23000)
		TriggerClientEvent("Admin:Client:Nuke", -1)
	end, {
		help = "DO NOT USE",
	}, 0)
end