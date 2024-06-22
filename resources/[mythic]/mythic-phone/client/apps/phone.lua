_call = nil
local _calling = false

function StartCallTimeout()
	if _calling then
		return
	end
	_calling = true
	if LocalPlayer.state.phoneOpen then
		PhoneTextToCall()
	else
		PhonePlayCall(false)
	end
	CreateThread(function()
		local count = 0
		while _calling do
			Wait(1)
			if count < 3000 then
				count = count + 1
			else
				Phone.Call:End()
				_calling = false
			end
		end
	end)
end

function fucksound()
	Sounds.Stop:Distance(LocalPlayer.state.serverID, _settings.ringtone or "ringtone1.ogg")
	Sounds.Stop:One("ringing.ogg")
	Sounds.Stop:One("vibrate.ogg")
end

PHONE.Call = {
	Create = function(self, data)
		local p = promise.new()
		Sounds.Loop:One("ringing.ogg", 0.1 * (_settings.volume / 100))
		SendNUIMessage({ type = "SET_CALL_PENDING", data = { number = data.number } })
		data.limited = _limited

		if _payphone then
			data.isAnon = true
		end
		Callbacks:ServerCallback("Phone:Phone:CreateCall", data, function(status)
			if status then
				_call = {
					id = 1,
					state = 0,
					number = data.number,
					duration = -1,
					method = 1,
				}

				StartCallTimeout()
				p:resolve(true)
			else
				p:resolve(false)
			end
		end)
		return Citizen.Await(p)
	end,
	Recieve = function(self, id, number, limited)
		_call = {
			id = id,
			state = 1,
			number = number,
			duration = -1,
			method = 0,
		}
		SendNUIMessage({ type = "SET_CALL_INCOMING", data = { number = number, limited = limited } })
		if _settings.volume > 0 then
			Sounds.Loop:Distance(10, _settings.ringtone or "ringtone1.ogg", 0.1 * (_settings.volume / 100))
		else
			Sounds.Loop:One("vibrate.ogg", 0.1)
		end
	end,
	Accept = function(self)
		fucksound()
		if LocalPlayer.state.phoneOpen then
			PhoneTextToCall()
		end
		Callbacks:ServerCallback("Phone:Phone:AcceptCall", _call)
	end,
	End = function(self)
		_calling = false
		fucksound()
		Callbacks:ServerCallback("Phone:Phone:EndCall")
	end,
	Read = function(self)
		Callbacks:ServerCallback("Phone:Phone:ReadCalls")
	end,
	Status = function(self)
		return _call ~= nil
	end,
}

AddEventHandler("Characters:Client:Updated", function(key)
	if key == "States" and _call ~= nil then
		Phone.Call:End()
	end
end)

AddEventHandler("Phone:Client:RemovePhone", function()
	if _call ~= nil then
		Phone.Call:End()
	end
end)

AddEventHandler("Ped:Client:Died", function()
	if _call ~= nil then
		Phone.Call:End()
	end
end)

RegisterNetEvent("Jail:Client:Jailed", function()
	if _call ~= nil then
		Phone.Call:End()
	end
end)

RegisterNetEvent("Hospital:Client:ICU:Sent", function()
	if _call ~= nil then
		Phone.Call:End()
	end
end)

RegisterNetEvent("Characters:Client:Logout", function()
	if _call ~= nil then
		Phone.Call:End()
	end
end)

RegisterNetEvent("Phone:Client:Phone:EndCall", function()
	SendNUIMessage({ type = "END_CALL" })
	_call = nil

	fucksound()

	CreateThread(function()
		Wait(100)
		Sounds.Play:One("ended.ogg", 0.15)
	end)

	if LocalPlayer.state.phoneOpen then
		PhoneCallToText()
	else
		PhonePlayOut()
	end
end)

RegisterNetEvent("Phone:Client:Phone:RecieveCall", function(id, number, limited)
	if Jail:IsJailed() then
		TriggerEvent("Phone:Nui:Phone:EndCall")
	else
		Phone.Call:Recieve(id, number, limited)
	end
end)

RegisterNetEvent("Phone:Client:Phone:AcceptCall", function(number)
	_calling = false
	_call.state = 2
	_call.duration = 0
	fucksound()
	SendNUIMessage({ type = "SET_CALL_ACTIVE" })
	PhonePlayCall(false)
end)

AddEventHandler("Phone:Nui:Phone:AcceptCall", function()
	fucksound()
	Phone.Call:Accept()
end)

AddEventHandler("Phone:Nui:Phone:EndCall", function()
	fucksound()
	Phone.Call:End()
end)

RegisterNUICallback("CreateCall", function(data, cb)
	cb(Phone.Call:Create(data))
end)

RegisterNUICallback("AcceptCall", function(data, cb)
	cb("OK")
	fucksound()
	Phone.Call:Accept()
end)

RegisterNUICallback("EndCall", function(data, cb)
	cb("OK")
	fucksound()
	Phone.Call:End()
end)

RegisterNUICallback("ReadCalls", function(data, cb)
	cb("OK")
	Phone.Call:Read()
end)
