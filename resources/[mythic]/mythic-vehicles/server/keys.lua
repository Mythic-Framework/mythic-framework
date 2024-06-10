VEHICLE_KEYS = {}

RegisterServerEvent('Vehicles:Server:StealLocalKeys', function(vehNet)
    local src = source
    local veh = NetworkGetEntityFromNetworkId(vehNet)
    local vehEnt = Entity(veh)
    if vehEnt and vehEnt.state.VIN then
        Vehicles.Keys:Give(src, vehEnt.state.VIN)
    end
end)

_vehKeys = {
    Keys = {
        Has = function(self, source, VIN, groupKeys)
            local id = Fetch:Source(source):GetData('Character'):GetData('ID')
            if VEHICLE_KEYS[id] == nil then
                return false
            end
            return (VEHICLE_KEYS[id][VIN] or (groupKeys and Player(source).state.onDuty == groupKeys))
        end,
        Add = function(self, source, VIN)
            local id = Fetch:Source(source):GetData('Character'):GetData('ID')
            if VEHICLE_KEYS[id] == nil then
                VEHICLE_KEYS[id] = {}
            end
            VEHICLE_KEYS[id][VIN] = true

            TriggerClientEvent('Vehicles:Client:UpdateKeys', source, VEHICLE_KEYS[id])
        end,
        Remove = function(self, source, VIN)
            local id = Fetch:Source(source):GetData('Character'):GetData('ID')
            if VEHICLE_KEYS[id] == nil then
                VEHICLE_KEYS[id] = {}
                return
            end
            if Vehicles.Keys:Has(source, VIN, false) then
                VEHICLE_KEYS[id][VIN] = nil
                TriggerClientEvent('Vehicles:Client:UpdateKeys', source, VEHICLE_KEYS[id])
            end
        end,
    }
}

AddEventHandler('Proxy:Shared:ExtendReady', function(component)
    if component == 'Vehicles' then
        exports['mythic-base']:ExtendComponent(component, _vehKeys)
    end
end)