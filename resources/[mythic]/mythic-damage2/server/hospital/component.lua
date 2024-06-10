BED_LIMIT = #Config.Beds
_inBed = {}
_inBedChar = {}

AddEventHandler("Damage:Shared:DependencyUpdate", HospitalComponents)
function HospitalComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Damage = exports["mythic-base"]:FetchComponent("Damage")
	Hospital = exports["mythic-base"]:FetchComponent("Hospital")
	Crypto = exports["mythic-base"]:FetchComponent("Crypto")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Billing = exports["mythic-base"]:FetchComponent("Billing")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Labor = exports["mythic-base"]:FetchComponent("Labor")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Handcuffs = exports["mythic-base"]:FetchComponent("Handcuffs")
	Ped = exports["mythic-base"]:FetchComponent("Ped")
	Routing = exports["mythic-base"]:FetchComponent("Routing")
	Pwnzor = exports["mythic-base"]:FetchComponent("Pwnzor")
	Banking = exports["mythic-base"]:FetchComponent("Banking")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Hospital", {
		"Callbacks",
		"Middleware",
		"Fetch",
		"Damage",
		"Hospital",
		"Crypto",
		"Phone",
		"Execute",
		"Chat",
		"Billing",
		"Inventory",
		"Labor",
		"Jobs",
		"Handcuffs",
		"Ped",
		"Routing",
		"Pwnzor",
		"Banking",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		HospitalComponents()
		HospitalCallbacks()
		HospitalMiddleware()

		GlobalState["HiddenHospital"] = {
			coords = vector3(1730.343, 3029.604, 62.170),
			heading = 74.207,
		}

		Chat:RegisterAdminCommand("clearbeds", function(source, args, rawCommand)
			_inBed = {}
		end, {
			help = "Force Clear All Hospital Beds",
			params = {},
		}, -1)
	end)
end)

HOSPITAL = {
	RequestBed = function(self, source)
		--return math.random(#Config.Beds)
		for k, v in ipairs(Config.Beds) do
			if _inBed[k] == nil then
				return k
			end
		end
		return nil
	end,
	FindBed = function(self, source, location)
		for k, v in ipairs(Config.Beds) do
			if (#(vector3(v.x, v.y, v.z) - vector3(location.x, location.y, location.z)) <= 2.0) and not _inBed[k] then
				return k
			end
		end
		return nil
	end,
	OccupyBed = function(self, source, bedId)
		local char = Fetch:Source(source):GetData("Character")
		if char and Config.Beds[bedId] ~= nil then
			if _inBed[bedId] == nil then
				_inBedChar[char:GetData("ID")] = bedId
				_inBed[bedId] = char:GetData("ID")
				return true
			else
				return false
			end
		else
			return false
		end
	end,
	LeaveBed = function(self, source)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			local inBedId = _inBedChar[char:GetData("ID")]
			if inBedId ~= nil then
				_inBed[inBedId] = nil
				_inBedChar[char:GetData("ID")] = nil
				return true
			end
		end
		return false
	end,
	ICU = {
		Send = function(self, target)
			local plyr = Fetch:Source(target)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
						return false
					end

					Labor.Jail:Sentenced(target)

					Player(target).state.ICU = true
					char:SetData("ICU", {
						Released = false,
					})

					Citizen.CreateThread(function()
						Jobs.Duty:Off(target, Player(target).state.onDuty)
						Handcuffs:UncuffTarget(-1, target)
						Ped.Mask:UnequipNoItem(target)
						Inventory.Holding:Put(target)
					end)

					Pwnzor.Players:TempPosIgnore(target)
					TriggerClientEvent("Hospital:Client:ICU:Sent", target)
					TriggerClientEvent("Hospital:Client:ICU:Enter", target)
					Execute:Client(target, "Notification", "Info", "You Were Admitted To ICU")
				else
					return false
				end
			else
				return false
			end
		end,
		Release = function(self, target)
			local plyr = Fetch:Source(target)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					Player(target).state.ICU = false
					char:SetData("ICU", {
						Released = true,
						Items = false,
					})
					Execute:Client(target, "Notification", "Info", "You Were Released From ICU")
				else
					return false
				end
			else
				return false
			end
		end,
		GetItems = function(self, target)
			local plyr = Fetch:Source(target)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					Player(target).state.ICU = false
					char:SetData("ICU", {
						Released = true,
						Items = true,
					})
					Inventory.Holding:Take(target)
				else
					return false
				end
			else
				return false
			end
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Hospital", HOSPITAL)
end)
