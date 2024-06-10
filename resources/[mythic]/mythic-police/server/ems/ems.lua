AddEventHandler("EMS:Shared:DependencyUpdate", EMSComponents)
function EMSComponents()
	Database = exports["mythic-base"]:FetchComponent("Database")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Damage = exports["mythic-base"]:FetchComponent("Damage")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("EMS", {
		"Database",
		"Middleware",
		"Callbacks",
		"Logger",
		"Fetch",
		"Inventory",
		"Damage",
		"Execute",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		EMSComponents()
		EMSCallbacks()
		EMSItems()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("EMS", _EMS)
end)

RegisterNetEvent("EMS:Server:CheckICUPatients", function()
	local src = source
	local count = 0
	for k, v in ipairs(Fetch:All()) do
		local c = v:GetData("Character")
		if c ~= nil then
			if c:GetData("ICU") ~= nil and not c:GetData("ICU").Released then
				count = count + 1
			end
		end
	end

	if count > 0 then
		if count == 1 then
			Execute:Client(src, "Notification", "Info", "There Is 1 Patient In ICU")
		else
			Execute:Client(src, "Notification", "Info", string.format("There Are %s Patients In ICU", count))
		end
	else
		Execute:Client(src, "Notification", "Info", "There Are No Patients In ICU")
	end
end)

RegisterNetEvent("EMS:Server:RequestHelp", function()
	local src = source
	TriggerEvent("EmergencyAlerts:Server:ServerDoPredefined", src, "injuredPerson")
end)

function EMSCallbacks()
	Callbacks:RegisterServerCallback("EMS:Stabilize", function(source, data, cb)
		local myChar = Fetch:Source(source):GetData("Character")
		local plyr = Fetch:Source(tonumber(data))
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if Inventory.Items:Has(myChar:GetData("SID"), 1, "traumakit", 1) then
				if Jobs.Permissions:HasJob(source, "ems") then
					Logger:Info(
						"EMS",
						string.format(
							"%s %s (%s) Stabilized %s %s (%s)",
							myChar:GetData("First"),
							myChar:GetData("Last"),
							myChar:GetData("SID"),
							char:GetData("First"),
							char:GetData("Last"),
							char:GetData("SID")
						),
						{
							console = true,
							file = true,
							database = true,
						}
					)
					Callbacks:ClientCallback(data, "Damage:FieldStabalize")
					cb({ error = false })
				else
					cb({ error = true, code = 3 })
				end
			else
				cb({ error = true, code = 2 })
			end
		else
			cb({ error = true, code = 1 })
		end
	end)

	Callbacks:RegisterServerCallback("EMS:FieldTreatWounds", function(source, data, cb)
		local myChar = Fetch:Source(source):GetData("Character")
		if Jobs.Permissions:HasJob(source, "ems") then
			if Inventory.Items:Has(myChar:GetData("SID"), 1, "traumakit", 1) then
				Execute:Client(data, "Notification", "Success", "Your Wounds Were Treated")
				cb({ error = false })
			else
				cb({ error = true, code = 2 })
			end
		else
			cb({ error = true, code = 1 })
		end
	end)

	-- Callbacks:RegisterServerCallback("EMS:ApplyGauze", function(source, data, cb)
	-- 	local myChar = Fetch:Source(source):GetData("Character")
	-- 	if Jobs.Permissions:HasJob(source, "ems") then
	-- 		if Inventory.Items:Remove(myChar:GetData("SID"), 1, "gauze", 1) then
	-- 			local target = Fetch:Source(data)
	-- 			if target ~= nil then
	-- 				local tChar = target:GetData("Character")
	-- 				if tChar ~= nil then
	-- 					local dmg = tChar:GetData("Damage")
	-- 					if dmg.Bleed > 1 then
	-- 						dmg.Bleed = dmg.Bleed - 1
	-- 						tChar:SetData("Damage", dmg)
	-- 					else
	-- 						Execute:Client(data, "Notification", "Error", "You continue bleeding through the gauze")
	-- 					end
	-- 					cb({ error = false })
	-- 				else
	-- 					cb({ error = true, code = 4 })
	-- 				end
	-- 			else
	-- 				cb({ error = true, code = 3 })
	-- 			end
	-- 		else
	-- 			cb({ error = true, code = 2 })
	-- 		end
	-- 	else
	-- 		cb({ error = true, code = 1 })
	-- 	end
	-- end)

	Callbacks:RegisterServerCallback("EMS:ApplyBandage", function(source, data, cb)
		local myChar = Fetch:Source(source):GetData("Character")
		if Jobs.Permissions:HasJob(source, "ems") then
			if Inventory.Items:Remove(myChar:GetData("SID"), 1, "bandage", 1) then
				local ped = GetPlayerPed(data)
				local currHp = GetEntityHealth(ped)
				if currHp < (GetEntityMaxHealth(ped) * 0.75) then
					local p = promise.new()

					Callbacks:ClientCallback(data, "EMS:ApplyBandage", {}, function(s)
						p:resolve(s)
					end)

					Citizen.Await(p)
					Execute:Client(data, "Notification", "Success", "A Bandage Was Applied To You")
					cb({ error = false })
				else
					cb({ error = true, code = 3 })
				end
			else
				cb({ error = true, code = 2 })
			end
		else
			cb({ error = true, code = 1 })
		end
	end)

	Callbacks:RegisterServerCallback("EMS:ApplyMorphine", function(source, data, cb)
		local myChar = Fetch:Source(source):GetData("Character")
		if Jobs.Permissions:HasJob(source, "ems") then
			if Inventory.Items:Remove(myChar:GetData("SID"), 1, "morphine", 1) then
				Damage.Effects:Painkiller(tonumber(data), 3)
				Execute:Client(data, "Notification", "Success", "You Received A Morphine Shot")
				cb({ error = false })
			else
				cb({ error = true, code = 2 })
			end
		else
			cb({ error = true, code = 1 })
		end
	end)

	Callbacks:RegisterServerCallback("EMS:TreatWounds", function(source, data, cb)
		local myChar = Fetch:Source(source):GetData("Character")
		if Jobs.Permissions:HasJob(source, "ems") then
			Callbacks:ClientCallback(data, "Damage:Heal", true)
			--TriggerClientEvent("Hospital:Client:GetOut", data)
			Execute:Client(source, "Notification", "Success", "Patient Has Been Treated")
			Execute:Client(data, "Notification", "Success", "You've Been Treated")
			cb({ error = false })
		else
			cb({ error = true, code = 1 })
		end
	end)

	Callbacks:RegisterServerCallback("EMS:CheckDamage", function(source, data, cb)
		local myChar = Fetch:Source(source):GetData("Character")
		if Jobs.Permissions:HasJob(source, "ems") or Jobs.Permissions:HasJob(source, "police") then
			local tPlyr = Fetch:Source(data)
			if tPlyr ~= nil then
				local tChar = tPlyr:GetData("Character")
				if tChar ~= nil then
					cb(tChar:GetData("Damage"))
				else
					cb(nil)
				end
			else
				cb(nil)
			end
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("EMS:DrugTest", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local pState = Player(source).state
				if pState.onDuty == "ems" then
					local target = Fetch:Source(data)
					if target ~= nil then
						local tarChar = target:GetData("Character")
						if tarChar ~= nil then
							local tarStates = tarChar:GetData("DrugStates") or {}
							local output = {}
							for k, v in pairs(tarStates) do
								if v.expires > os.time() then
									local item = Inventory.Items:GetData(v.item)
									local pct = ((v.expires - os.time()) / item.drugState.duration) * 100
									if pct <= 25 and pct >= 5 then
										table.insert(
											output,
											string.format("Low Presence of %s", Config.Drugs[item.drugState.type])
										)
									elseif pct <= 50 then
										table.insert(
											output,
											string.format("Moderate Presence of %s", Config.Drugs[item.drugState.type])
										)
									elseif pct <= 75 then
										table.insert(
											output,
											string.format("High Presence of %s", Config.Drugs[item.drugState.type])
										)
									elseif pct > 5 then
										table.insert(
											output,
											string.format("Very High Presence of %s", Config.Drugs[item.drugState.type])
										)
									end
								end
							end

							if #output > 0 then
								local str = string.format(
									"Drug Test Results For %s %s:<br/><ul>",
									tarChar:GetData("First"),
									tarChar:GetData("Last")
								)
								for k, v in ipairs(output) do
									str = str .. string.format("<li>%s</li>", v)
								end
								str = str .. "</ul>"
								Chat.Send.Services:TestResult(source, str)
							else
								Chat.Send.Services:TestResult(
									source,
									"Drug Test Results:<br/><ul><li>All Results Are Negative</li></ul>"
								)
							end
						end
					end
				end
			end
		end

		cb(true)
	end)
end

RegisterNetEvent("EMS:Server:Panic", function(isAlpha)
	local src = source
	local char = Fetch:Source(src):GetData("Character")
	if Player(src).state.onDuty == "ems" then
		local coords = GetEntityCoords(GetPlayerPed(src))
		Callbacks:ClientCallback(src, "EmergencyAlerts:GetStreetName", coords, function(location)
			if isAlpha then
				EmergencyAlerts:Create(
					"13-A",
					"Medic Down",
					2,
					location,
					string.format("%s - %s %s", char:GetData("Callsign"), char:GetData("First"), char:GetData("Last")),
					true,
					{
						icon = 303,
						size = 1.2,
						color = 48,
						duration = (60 * 10),
					},
					1
				)
			else
				EmergencyAlerts:Create(
					"13-B",
					"Medic Down",
					2,
					location,
					string.format("%s - %s %s", char:GetData("Callsign"), char:GetData("First"), char:GetData("Last")),
					false,
					{
						icon = 303,
						size = 0.9,
						color = 48,
						duration = (60 * 10),
					},
					1
				)
			end
		end)
	end
end)

_EMS = {}
