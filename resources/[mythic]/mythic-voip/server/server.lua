voiceData = {}
radioData = {}
callData = {}

function GetDefaultPlayerVOIPData(source)
	return {
		Radio = 0,
		Call = 0,
		LastRadio = 0,
		LastCall = 0
	}
end

-- temp fix before an actual fix is added
CreateThread(function()
    for i = 1, 1024 do
        MumbleCreateChannel(i)
    end
end)

AddEventHandler('VOIP:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Database = exports['mythic-base']:FetchComponent('Database')
    Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Fetch = exports['mythic-base']:FetchComponent('Fetch')
    Chat = exports['mythic-base']:FetchComponent('Chat')
	Middleware = exports['mythic-base']:FetchComponent('Middleware')
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Inventory = exports['mythic-base']:FetchComponent('Inventory')
    VOIP = exports['mythic-base']:FetchComponent('VOIP')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('VOIP', {
        'Database',
        'Callbacks',
        'Fetch',
        'Chat',
		'Middleware',
		'Logger',
		'Inventory',
		'VOIP'
    }, function(error)
        if #error > 0 then return end -- Do something to handle if not all dependencies loaded
        RetrieveComponents()
		RegisterMiddleware()

		--RegisterChatCommands()
		Inventory.Items:RegisterUse('radio', 'VOIP', function(source, itemData)
            TriggerClientEvent('Radio:Client:OpenUI', source, 1)
        end)

		Inventory.Items:RegisterUse('radio_shitty', 'VOIP', function(source, itemData)
            TriggerClientEvent('Radio:Client:OpenUI', source, 2)
        end)

		Inventory.Items:RegisterUse('megaphone', 'VOIP', function(source, itemData)
            TriggerClientEvent('VOIP:Client:Megaphone:Use', source)
        end)
    end)
end)

function RegisterMiddleware()
	Middleware:Add('Characters:Spawning', function(source)
        VOIP:AddPlayer(source)
    end, 3)

	Middleware:Add('Characters:Logout', function(source)
		VOIP:RemovePlayer(source)
	end, 3)
end

_fuckingVOIP = {
	AddPlayer = function(self, source)
		if not voiceData[source] then
			voiceData[source] = GetDefaultPlayerVOIPData()
			--Player(source).state:set('routingBucket', 0, true)
		end
	end,
	RemovePlayer = function(self, source)
		if voiceData[source] then
			local plyData = voiceData[source]
	
			if plyData.Radio > 0 then
				VOIP.Radio:SetChannel(source, 0)
			end
	
			if plyData.Call > 0 then
				VOIP.Phone:SetChannel(source, 0)
			end
	
			voiceData[source] = nil
		end
	end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('VOIP', _fuckingVOIP)
end)