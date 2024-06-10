EVIDENCE_CACHE = {}

RegisterNetEvent('Evidence:Server:RecieveEvidence', function(newEvidence)
    local _src = source

    local time = os.time()

    for k, v in ipairs(newEvidence) do
        v.id = string.format('%s-%s', os.date('%d%m%y-%H%M%S', time), 100000 + #EVIDENCE_CACHE)
        v.time = GetGameTimer()
        v.client = _src

        table.insert(EVIDENCE_CACHE, v)
    end
end)

AddEventHandler('Evidence:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
	Fetch = exports['mythic-base']:FetchComponent('Fetch')
	Utils = exports['mythic-base']:FetchComponent('Utils')
    Execute = exports['mythic-base']:FetchComponent('Execute')
	Database = exports['mythic-base']:FetchComponent('Database')
	Middleware = exports['mythic-base']:FetchComponent('Middleware')
	Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Chat = exports['mythic-base']:FetchComponent('Chat')
	Logger = exports['mythic-base']:FetchComponent('Logger')
	Generator = exports['mythic-base']:FetchComponent('Generator')
	Phone = exports['mythic-base']:FetchComponent('Phone')
	Jobs = exports['mythic-base']:FetchComponent('Jobs')
	Vehicles = exports['mythic-base']:FetchComponent('Vehicles')
    Inventory = exports['mythic-base']:FetchComponent('Inventory')
    Sequence = exports['mythic-base']:FetchComponent('Sequence')
end

AddEventHandler('Core:Shared:Ready', function()
	exports['mythic-base']:RequestDependencies('Evidence', {
		'Fetch',
		'Utils',
        'Execute',
        'Chat',
		'Database',
		'Middleware',
		'Callbacks',
		'Logger',
		'Generator',
		'Phone',
		'Jobs',
		'Vehicles',
        'Inventory',
        'Sequence',
	}, function(error)
		if #error > 0 then 
            exports['mythic-base']:FetchComponent('Logger'):Critical('Evidence', 'Failed To Load All Dependencies')
			return
		end
		RetrieveComponents()

        StartDeletionThread()

        Callbacks:RegisterServerCallback('Evidence:Fetch', function(source, data, cb)
            cb(EVIDENCE_CACHE)
        end)

        RegisterBallisticsCallbacks()
        RegisterBallisticsItemUses()
	end)
end)

local _deletionThead = false

function StartDeletionThread()
    if not _deletionThead then
        _deletionThead = true

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait((60 * 1000) * 30)

                if #EVIDENCE_CACHE > 0 then
                    local removed = 0
                    local currentTimer = GetGameTimer()
                    for k, v in ipairs(EVIDENCE_CACHE) do
                        if (currentTimer - v.time) >= ((60 * 1000) * 120) then
                            table.remove(EVIDENCE_CACHE, k)
                            removed = removed + 1
                        end
                    end

                    if removed > 0 then
                        TriggerClientEvent('Evidence:Client:ForceUpdateEvidence', -1)
                        collectgarbage()
                    end
                end
            end
        end)
    end
end

AddEventHandler('Sync:Server:WeatherChange', function(weather)
    if IsWeatherTypeRain(weather) then
        -- Wash away evidence after a bit
        if #EVIDENCE_CACHE > 0 then
            Citizen.SetTimeout(45000, function()
                local removed = 0
                for k, v in ipairs(EVIDENCE_CACHE) do
                    if v.type == 'blood' then
                        table.remove(EVIDENCE_CACHE, k)
                        removed = removed + 1
                    end
                end

                if removed > 0 then
                    TriggerClientEvent('Evidence:Client:ForceUpdateEvidence', -1)
                    collectgarbage()
                end
            end)
        end
    end
end)

RegisterNetEvent('Evidence:Server:PickupEvidence', function(evidenceId)
    local _src = source
    local char = Fetch:Source(source):GetData('Character')
    if char and Jobs.Permissions:HasJob(_src, 'police') then
        for k, v in ipairs(EVIDENCE_CACHE) do
            if v.id == evidenceId then
                if v.type == 'paint_fragment' then
                    Inventory:AddItem(char:GetData('SID'), 'evidence-paint', 1, {
                        EvidenceType = v.type,
                        EvidenceId = v.id,
                        EvidenceCoords = { x = v.coords.x, y = v.coords.y, z = v.coords.z },
                        EvidenceColor = v.data and v.data.color,
                    }, 1)
                elseif v.type == 'projectile' then
                    Inventory:AddItem(char:GetData('SID'), 'evidence-projectile', 1, {
                        EvidenceType = v.type,
                        EvidenceId = v.id,
                        EvidenceCoords = { x = v.coords.x, y = v.coords.y, z = v.coords.z },
                        EvidenceWeapon = v.data and v.data.weapon,
                        EvidenceAmmoType = (v.data and v.data.weapon) and v.data.weapon.ammoTypeName,
                        EvidenceDegraded = v.data and v.data.tooDegraded,
                    }, 1)
                elseif v.type == 'casing' then
                    Inventory:AddItem(char:GetData('SID'), 'evidence-casing', 1, {
                        EvidenceType = v.type,
                        EvidenceId = v.id,
                        EvidenceCoords = { x = v.coords.x, y = v.coords.y, z = v.coords.z },
                        EvidenceWeapon = v.data and v.data.weapon,
                        EvidenceAmmoType = (v.data and v.data.weapon) and v.data.weapon.ammoTypeName,
                    }, 1)
                elseif v.type == 'blood' then
                    Inventory:AddItem(char:GetData('SID'), 'evidence-dna', 1, {
                        EvidenceType = v.type,
                        EvidenceId = v.id,
                        EvidenceCoords = { x = v.coords.x, y = v.coords.y, z = v.coords.z },
                        EvidenceDNA = v.data and v.data.DNA,
                        EvidenceBloodPool = v.data and v.data.IsBloodPool,
                        EvidenceDegraded = v.data and v.data.tooDegraded,
                    }, 1)
                end

                table.remove(EVIDENCE_CACHE, k)
                TriggerClientEvent('Evidence:Client:ForceUpdateEvidence', -1)
            end
        end
    end
end)