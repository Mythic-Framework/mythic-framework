-- Death reasons
local deathHashTable = {
    [GetHashKey('WEAPON_ANIMAL')] = 'Animal',
    [GetHashKey('WEAPON_COUGAR')] = 'Cougar',
    [GetHashKey('WEAPON_ADVANCEDRIFLE')] = 'Advanced Rifle',
    [GetHashKey('WEAPON_APPISTOL')] = 'AP Pistol',
    [GetHashKey('WEAPON_ASSAULTRIFLE')] = 'Assault Rifle',
    [GetHashKey('WEAPON_ASSAULTRIFLE_MK2')] = 'Assault Rifke Mk2',
    [GetHashKey('WEAPON_ASSAULTSHOTGUN')] = 'Assault Shotgun',
    [GetHashKey('WEAPON_ASSAULTSMG')] = 'Assault SMG',
    [GetHashKey('WEAPON_AUTOSHOTGUN')] = 'Automatic Shotgun',
    [GetHashKey('WEAPON_BULLPUPRIFLE')] = 'Bullpup Rifle',
    [GetHashKey('WEAPON_BULLPUPRIFLE_MK2')] = 'Bullpup Rifle Mk2',
    [GetHashKey('WEAPON_BULLPUPSHOTGUN')] = 'Bullpup Shotgun',
    [GetHashKey('WEAPON_CARBINERIFLE')] = 'Carbine Rifle',
    [GetHashKey('WEAPON_CARBINERIFLE_MK2')] = 'Carbine Rifle Mk2',
    [GetHashKey('WEAPON_COMBATMG')] = 'Combat MG',
    [GetHashKey('WEAPON_COMBATMG_MK2')] = 'Combat MG Mk2',
    [GetHashKey('WEAPON_COMBATPDW')] = 'Combat PDW',
    [GetHashKey('WEAPON_COMBATPISTOL')] = 'Combat Pistol',
    [GetHashKey('WEAPON_COMPACTRIFLE')] = 'Compact Rifle',
    [GetHashKey('WEAPON_DBSHOTGUN')] = 'Double Barrel Shotgun',
    [GetHashKey('WEAPON_DOUBLEACTION')] = 'Double Action Revolver',
    [GetHashKey('WEAPON_FLAREGUN')] = 'Flare gun',
    [GetHashKey('WEAPON_GUSENBERG')] = 'Gusenberg',
    [GetHashKey('WEAPON_HEAVYPISTOL')] = 'Heavy Pistol',
    [GetHashKey('WEAPON_HEAVYSHOTGUN')] = 'Heavy Shotgun',
    [GetHashKey('WEAPON_HEAVYSNIPER')] = 'Heavy Sniper',
    [GetHashKey('WEAPON_HEAVYSNIPER_MK2')] = 'Heavy Sniper',
    [GetHashKey('WEAPON_MACHINEPISTOL')] = 'Machine Pistol',
    [GetHashKey('WEAPON_MARKSMANPISTOL')] = 'Marksman Pistol',
    [GetHashKey('WEAPON_MARKSMANRIFLE')] = 'Marksman Rifle',
    [GetHashKey('WEAPON_MARKSMANRIFLE_MK2')] = 'Marksman Rifle Mk2',
    [GetHashKey('WEAPON_GLOCK19X2')] = 'PD Glock',
    [GetHashKey('WEAPON_G17')] = 'PD Glock',
    [GetHashKey('WEAPON_FNX')] = 'FNX-45',
    [GetHashKey('WEAPON_HK416B')] = 'PD HK416',
    [GetHashKey('WEAPON_BEANBAG')] = 'PD Beanbag',
    [GetHashKey('WEAPON_TASER')] = 'Taser',
    [GetHashKey('WEAPON_MG')] = 'MG',
    [GetHashKey('WEAPON_MICROSMG')] = 'Micro SMG',
    [GetHashKey('WEAPON_MINIGUN')] = 'Minigun',
    [GetHashKey('WEAPON_MINISMG')] = 'Mini SMG',
    [GetHashKey('WEAPON_MUSKET')] = 'Musket',
    [GetHashKey('WEAPON_PISTOL')] = 'Pistol',
    [GetHashKey('WEAPON_PISTOL_MK2')] = 'Pistol Mk2',
    [GetHashKey('WEAPON_PISTOL50')] = 'Pistol .50',
    [GetHashKey('WEAPON_PUMPSHOTGUN')] = 'Pump Shotgun',
    [GetHashKey('WEAPON_PUMPSHOTGUN_MK2')] = 'Pump Shotgun Mk2',
    [GetHashKey('WEAPON_RAILGUN')] = 'Railgun',
    [GetHashKey('WEAPON_REVOLVER')] = 'Revolver',
    [GetHashKey('WEAPON_REVOLVER_MK2')] = 'Revolver Mk2',
    [GetHashKey('WEAPON_SAWNOFFSHOTGUN')] = 'Sawnoff Shotgun',
    [GetHashKey('WEAPON_SMG')] = 'SMG',
    [GetHashKey('WEAPON_SMG_MK2')] = 'SMG Mk2',
    [GetHashKey('WEAPON_SNIPERRIFLE')] = 'Sniper Rifle',
    [GetHashKey('WEAPON_SNSPISTOL')] = 'SNS Pistol',
    [GetHashKey('WEAPON_SNSPISTOL_MK2')] = 'SNS Pistol Mk2',
    [GetHashKey('WEAPON_SPECIALCARBINE')] = 'Special Carbine',
    [GetHashKey('WEAPON_SPECIALCARBINE_MK2')] = 'Special Carbine Mk2',
    [GetHashKey('WEAPON_STINGER')] = 'Stinger',
    [GetHashKey('WEAPON_STUNGUN')] = 'Stungun',
    [GetHashKey('WEAPON_VINTAGEPISTOL')] = 'Vintage Pistol',
    [GetHashKey('VEHICLE_WEAPON_PLAYER_LASER')] = 'Vehicle Lasers',
    [GetHashKey('WEAPON_FIRE')] = 'Fire',
    [GetHashKey('WEAPON_FLARE')] = 'Flare',
    [GetHashKey('WEAPON_FLAREGUN')] = 'Flaregun',
    [GetHashKey('WEAPON_MOLOTOV')] = 'Molotov',
    [GetHashKey('WEAPON_PETROLCAN')] = 'Petrol Can',
    [GetHashKey('WEAPON_HELI_CRASH')] = 'Helicopter Crash',
    [GetHashKey('WEAPON_RAMMED_BY_CAR')] = 'Rammed by Vehicle',
    [GetHashKey('WEAPON_RUN_OVER_BY_CAR')] = 'Ranover by Vehicle',
    [GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET')] = 'Vehicle Space Rocket',
    [GetHashKey('VEHICLE_WEAPON_TANK')] = 'Tank',
    [GetHashKey('WEAPON_AIRSTRIKE_ROCKET')] = 'Airstrike Rocket',
    [GetHashKey('WEAPON_AIR_DEFENCE_GUN')] = 'Air Defence Gun',
    [GetHashKey('WEAPON_COMPACTLAUNCHER')] = 'Compact Launcher',
    [GetHashKey('WEAPON_EXPLOSION')] = 'Explosion',
    [GetHashKey('WEAPON_FIREWORK')] = 'Firework',
    [GetHashKey('WEAPON_GRENADE')] = 'Grenade',
    [GetHashKey('WEAPON_GRENADELAUNCHER')] = 'Grenade Launcher',
    [GetHashKey('WEAPON_HOMINGLAUNCHER')] = 'Homing Launcher',
    [GetHashKey('WEAPON_PASSENGER_ROCKET')] = 'Passenger Rocket',
    [GetHashKey('WEAPON_PIPEBOMB')] = 'Pipe bomb',
    [GetHashKey('WEAPON_PROXMINE')] = 'Proximity Mine',
    [GetHashKey('WEAPON_RPG')] = 'RPG',
    [GetHashKey('WEAPON_STICKYBOMB')] = 'Sticky Bomb',
    [GetHashKey('WEAPON_VEHICLE_ROCKET')] = 'Vehicle Rocket',
    [GetHashKey('WEAPON_BZGAS')] = 'BZ Gas',
    [GetHashKey('WEAPON_FIREEXTINGUISHER')] = 'Fire Extinguisher',
    [GetHashKey('WEAPON_SMOKEGRENADE')] = 'Smoke Grenade',
    [GetHashKey('WEAPON_BATTLEAXE')] = 'Battleaxe',
    [GetHashKey('WEAPON_BOTTLE')] = 'Bottle',
    [GetHashKey('WEAPON_KNIFE')] = 'Knife',
    [GetHashKey('WEAPON_MACHETE')] = 'Machete',
    [GetHashKey('WEAPON_SWITCHBLADE')] = 'Switch Blade',
    [GetHashKey('OBJECT')] = 'Object',
    [GetHashKey('VEHICLE_WEAPON_ROTORS')] = 'Vehicle Rotors',
    [GetHashKey('WEAPON_BALL')] = 'Ball',
    [GetHashKey('WEAPON_BAT')] = 'Bat',
    [GetHashKey('WEAPON_CROWBAR')] = 'Crowbar',
    [GetHashKey('WEAPON_FLASHLIGHT')] = 'Flashlight',
    [GetHashKey('WEAPON_GOLFCLUB')] = 'Golfclub',
    [GetHashKey('WEAPON_HAMMER')] = 'Hammer',
    [GetHashKey('WEAPON_HATCHET')] = 'Hatchet',
    [GetHashKey('WEAPON_HIT_BY_WATER_CANNON')] = 'Water Cannon',
    [GetHashKey('WEAPON_KNUCKLE')] = 'Knuckle',
    [GetHashKey('WEAPON_NIGHTSTICK')] = 'Night Stick',
    [GetHashKey('WEAPON_POOLCUE')] = 'Pool Cue',
    [GetHashKey('WEAPON_SNOWBALL')] = 'Snowball',
    [GetHashKey('WEAPON_UNARMED')] = 'Fist',
    [GetHashKey('WEAPON_WRENCH')] = 'Wrench',
    [GetHashKey('WEAPON_DROWNING')] = 'Drowned',
    [GetHashKey('WEAPON_DROWNING_IN_VEHICLE')] = 'Drowned in Vehicle',
    [GetHashKey('WEAPON_BARBED_WIRE')] = 'Barbed Wire',
    [GetHashKey('WEAPON_BLEEDING')] = 'Bleed',
    [GetHashKey('WEAPON_ELECTRIC_FENCE')] = 'Electric Fence',
    [GetHashKey('WEAPON_EXHAUSTION')] = 'Exhaustion',
    [GetHashKey('WEAPON_FALL')] = 'Falling',
    [GetHashKey('WEAPON_KATANA')] = 'Katana',
    [GetHashKey('WEAPON_SHIV')] = 'Shiv',    
    [GetHashKey('WEAPON_AR15')] = 'AR-15',
    [GetHashKey('WEAPON_P90FM')] = 'P90',
    [GetHashKey('WEAPON_SLEDGEHAMMER')] = 'Sledge Hammer',
    [GetHashKey('WEAPON_LUCILLE')] = 'Bat',
    [GetHashKey('WEAPON_DRBAT')] = 'Bat',
    [GetHashKey('WEAPON_CRUTCH')] = 'Crutch',
}

AddEventHandler('Ped:Client:Died', function()
    local ped = LocalPlayer.state.ped

    local killerPed = GetPedSourceOfDeath(ped)
    local causeHash = GetPedCauseOfDeath(ped)
    local killer = false

    if killerPed == ped then
        killer = false
    else
        if IsEntityAPed(killerPed) and IsPedAPlayer(killerPed) then
            killer = NetworkGetPlayerIndexFromPed(killerPed)
        elseif IsEntityAVehicle(killerPed) then
            local drivingPed = GetPedInVehicleSeat(killerPed, -1)
            if IsEntityAPed(drivingPed) == 1 and IsPedAPlayer(drivingPed) then
                killer = NetworkGetPlayerIndexFromPed(drivingPed)
            end
        end
    end

    local deathReason = deathHashTable[causeHash] or string.format('Unknown: %s', causeHash)

    if not killer then
        if deathReason ~= "unknown" then
            deathReason = "Suicide (" .. deathReason .. ")"
        else
            deathReason = "Suicide"
        end
    else
        killer = GetPlayerServerId(killer)
    end

    TriggerServerEvent("Damage:Server:LogDeath", killer, deathReason)
end)