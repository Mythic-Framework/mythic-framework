COMPONENTS.Spawn = COMPONENTS.Spawn or {
    _required = { 'InitCamera', 'Init' },
    _name = 'base',
}

COMPONENTS.Spawn.SpawnPoint = {
    x = -1044.84,
    y = -2749.85,
    z = 21.36,
    h = 0
}

function COMPONENTS.Spawn.InitCamera(self)
    return
end

function COMPONENTS.Spawn.Init(self)
    DoScreenFadeOut(500)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, self.SpawnPoint.x, self.SpawnPoint.y, self.SpawnPoint.z, false, false, false, false)
    SetEntityHeading(playerPed, self.SpawnPoint.h)
    ShutdownLoadingScreen()

    DoScreenFadeIn(500)

    while not IsScreenFadingIn() do
        Wait(10)
    end
end

AddEventHandler('playerSpawned', function()
    COMPONENTS.Spawn:Init()
end)

AddEventHandler('onClientMapStart', function()
    COMPONENTS.Spawn:InitCamera()
    exports['spawnmanager']:spawnPlayer()
    Wait(2500)
	exports['spawnmanager']:setAutoSpawn(false)
end)