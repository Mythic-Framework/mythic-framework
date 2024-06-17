local CAR_BOMB_THREAD = false
local CAR_BOMB_ENABLED = false
local CAR_BOMB_TICK = 0
local CAR_BOMB_TIME = 0
local CAR_BOMB_SPEED = 0
local CAR_BOMB_TICK_MAX = 0

AddEventHandler('Vehicles:Client:StartUp', function()
    Callbacks:RegisterClientCallback('Vehicles:UseCarBomb', function(data, cb)
        local target = Targeting:GetEntityPlayerIsLookingAt()
        if target and target.entity and DoesEntityExist(target.entity) and IsEntityAVehicle(target.entity) then
            if Vehicles.Utils:IsCloseToVehicle(target.entity) then
                local carBombConfig = GetCarBombConfig()

                if type(carBombConfig.minSpeed) ~= 'number' then
                    return cb(false, 'Invalid Minimum Speed')
                elseif not carBombConfig.removalTime or carBombConfig.removalTime < 0 or carBombConfig.removalTime > 120 then
                    return cb(false, 'Invalid Removal Time')
                elseif not carBombConfig.preExplosionTicks or carBombConfig.preExplosionTicks < 5 or carBombConfig.preExplosionTicks > 60 then
                    return cb(false, 'Invalid Pre Explosion Time')
                end

                Progress:Progress({
                    name = "vehicle_install_carbomb",
                    duration = 5000,
                    label = "Installing Car Bomb",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = false,
                    },
                    animation = {
                        anim = "mechanic2",
                    },
                }, function(cancelled)
                    if not cancelled and Vehicles.Utils:IsCloseToVehicle(target.entity) then
                        cb(VehToNet(target.entity), false, carBombConfig)
                    else
                        cb(false)
                    end
                end)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

function ResetCarBomb()
    CAR_BOMB_THREAD = false
    CAR_BOMB_ENABLED = false
    CAR_BOMB_TICK = 0
    CAR_BOMB_TIME = 0
    CAR_BOMB_SPEED = 0
end

function DoCarBombDetonate(veh)
    for i = 1, 5 do
        Wait(100)
        PlaySoundFromEntity(-1, 'Beep_Red', veh, 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true, true)
    end

    NetSync:NetworkExplodeVehicle(veh, 1, 0)
    ResetCarBomb()

    TriggerServerEvent('Vehicles:Server:RemoveBomb', VehToNet(veh))
end

AddEventHandler('Vehicles:Client:StartUp', function()
    
end)

AddEventHandler('Vehicles:Client:BecameDriver', function(veh)
    local vehEnt = Entity(veh)
    if vehEnt and vehEnt.state and vehEnt.state.CarBomb then
        CAR_BOMB_THREAD = true
        CAR_BOMB_TIME = math.ceil((vehEnt.state.CarBomb.Removal or 1) * 60)
        CAR_BOMB_TICK = 0
        CAR_BOMB_TICK_MAX = vehEnt.state.CarBomb.ExplosionTicks or 5
        CAR_BOMB_SPEED = vehEnt.state.CarBomb.Speed or 0

        CreateThread(function()
            while CAR_BOMB_THREAD do

                if not CAR_BOMB_ENABLED then
                    if CAR_BOMB_SPEED <= 0 then
                        if GetIsVehicleEngineRunning(veh) then
                            DoCarBombDetonate(veh)
                        end
                    elseif GetVehicleMPH(veh) > CAR_BOMB_SPEED then
                        CAR_BOMB_ENABLED = true
                        Notification:Warn("THIS VEHICLE HAS A BOMB - STAY ABOVE " .. math.ceil(CAR_BOMB_SPEED) .. "MPH AND DO NOT LEAVE THE VEHICLE", 15000)
                    end
                else
                    CAR_BOMB_TIME -= 1

                    if CAR_BOMB_TIME <= 0 then
                        Notification:Info("Bomb Disarmed", 10000)

                        ResetCarBomb()
                        TriggerServerEvent('Vehicles:Server:RemoveBomb', VehToNet(veh))
                    else
                        if GetVehicleMPH(veh) < CAR_BOMB_SPEED then
                            CAR_BOMB_TICK += 1
                            PlaySoundFromEntity(-1, 'Beep_Red', veh, 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true, true)
                            if CAR_BOMB_TICK >= CAR_BOMB_TICK_MAX then
                                DoCarBombDetonate(veh)
                            end
                        elseif GetVehicleMPH(veh) > CAR_BOMB_SPEED and CAR_BOMB_TICK > 0 then
                            CAR_BOMB_TICK = 0
                        end
                    end
                end
                Wait(1000)
            end
        end)
    end
end)

AddEventHandler('Vehicles:Client:SwitchVehicleSeat', function(veh)
    if CAR_BOMB_ENABLED then
        print('switched from drivers seat when there was active bomb')
        DoCarBombDetonate(veh)
    end
end)

AddEventHandler('Vehicles:Client:ExitVehicle', function(veh)
    if CAR_BOMB_ENABLED then
        print('left vehicle when there was active bomb')
        DoCarBombDetonate(veh)
    end
end)

local linkPromise
function GetCarBombConfig()
    linkPromise = promise.new()
    Input:Show('Car Bomb', 'URL', {
		{
			id = 'minSpeed',
			type = 'number',
			options = {
                label = 'Minimum Speed (MPH) (0 for Ignition Bomb)',
				inputProps = {
                    maxLength = 3,
                },
			},
		},
        {
			id = 'removalTime',
			type = 'number',
			options = {
                label = 'Deactivation Time (Minutes)',
				inputProps = {
                    maxLength = 4,
                },
			},
		},
        {
			id = 'preExplosionTicks',
			type = 'number',
			options = {
                label = 'Ticks Before it Explodes',
				inputProps = {
                    defaultValue = '5',
                    maxLength = 2,
                },
			},
		},
	}, 'Vehicles:Client:RecieveCarBombConfig', {})

    return Citizen.Await(linkPromise)
end

AddEventHandler('Vehicles:Client:RecieveCarBombConfig', function(values)
    if linkPromise then
        linkPromise:resolve({
            minSpeed = tonumber(values?.minSpeed),
            removalTime = tonumber(values?.removalTime),
            preExplosionTicks = tonumber(values?.preExplosionTicks),
        })
        linkPromise = nil
    end
end)