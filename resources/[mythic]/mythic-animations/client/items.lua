RegisterNetEvent("Animations:Client:CampChair", function()
    if LocalPlayer.state.loggedIn then
        local inAnim = Animations.Emotes:Get()
        if inAnim and inAnim == "campchair" then
            Animations.Emotes:Cancel()
        elseif not inAnim then
            Animations.Emotes:Play("campchair", false, false, false)
        end
    end
end)

RegisterNetEvent("Animations:Client:BeanBag", function()
    if LocalPlayer.state.loggedIn then
        local inAnim = Animations.Emotes:Get()
        if inAnim and inAnim == "beanbag" then
            Animations.Emotes:Cancel()
        elseif not inAnim then
            Animations.Emotes:Play("beanbag", false, false, false)
        end
    end
end)

local binocularConfig = {
    fovMax = 70.0,
    fovMin = 2.0,
    zoomSpeed = 10.0,
    moveSpeed = 8.0,
    fov = 0.0
}

binocularConfig.fov = (binocularConfig.fovMax + binocularConfig.fovMin) * 0.5


RegisterNetEvent('Animations:Client:Binoculars', function()
    if LocalPlayer.state.loggedIn then
        local inAnim = Animations.Emotes:Get()
        if inAnim and inAnim == "binoculars" then
            Animations.Emotes:Cancel()
        elseif not inAnim and not IsPedInAnyVehicle(LocalPlayer.state.ped, true) then
            Animations.Emotes:Play('binoculars', false, false, false)
            Hud:Hide()

            CreateThread(function()
                SetTimecycleModifier("default")
                SetTimecycleModifierStrength(0.3)

                local scaleform = RequestScaleformMovie("BINOCULARS")

                while not HasScaleformMovieLoaded(scaleform) do
                    Wait(10)
                end

                binocularConfig.fov = (binocularConfig.fovMax + binocularConfig.fovMin) * 0.5

                local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                AttachCamToEntity(cam, LocalPlayer.state.ped, 0.0, 0.0, 1.0, true)
                SetCamRot(cam, 0.0, 0.0, GetEntityHeading(LocalPlayer.state.ped))
                SetCamFov(cam, binocularConfig.fov)
                RenderScriptCams(true, false, 0, 1, 0)
                PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
                PushScaleformMovieFunctionParameterInt(0)
                PopScaleformMovieFunctionVoid()

                while Animations.Emotes:Get() == "binoculars" and LocalPlayer.state.loggedIn do
                    local zoomvalue = (1.0 / (binocularConfig.fovMax - binocularConfig.fovMin)) * (binocularConfig.fov - binocularConfig.fovMin)

                    HandleCameraPanning(cam, zoomvalue, binocularConfig)

                    HandleCameraZooming(cam, binocularConfig)

                    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                    Wait(1)
                end

                ClearTimecycleModifier()
                RenderScriptCams(false, false, 0, 1, 0)
                SetScaleformMovieAsNoLongerNeeded(scaleform)
                DestroyCam(cam, false)
                SetNightvision(false)
                SetSeethrough(false)

                Hud:Show()
            end)
        end
    end
end)

local camConfig = {
    fovMax = 40.0,
    fovMin = 2.0,
    zoomSpeed = 10.0,
    moveSpeed = 5.0,
    fov = 0.0
}

camConfig.fov = (camConfig.fovMax + camConfig.fovMin) * 0.5

RegisterNetEvent('Animations:Client:Camera', function()
    if LocalPlayer.state.loggedIn then
        local inAnim = Animations.Emotes:Get()
        if inAnim and inAnim == "camera_item" then
            Animations.Emotes:Cancel()
        elseif not inAnim and not IsPedInAnyVehicle(LocalPlayer.state.ped, true) then
            Animations.Emotes:Play('camera_item', false, false, false)
            Hud:Hide()

            TriggerEvent('Animations:Client:UsingCamera', true)

            CreateThread(function()
                SetTimecycleModifier("default")
                SetTimecycleModifierStrength(0.3)

                -- local scaleform = RequestScaleformMovie("security_cam")

                -- while not HasScaleformMovieLoaded(scaleform) do
                --     Wait(10)
                -- end

                camConfig.fov = (camConfig.fovMax + camConfig.fovMin) * 0.5
                camConfig.height = 1.0

                local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                AttachCamToEntity(cam, LocalPlayer.state.ped, 0.0, 1.0, 1.0, true)
                SetCamRot(cam, 0.0, 0.0, GetEntityHeading(LocalPlayer.state.ped))
                SetCamFov(cam, camConfig.fov)
                RenderScriptCams(true, false, 0, 1, 0)

                -- local playerCoords = GetEntityCoords(LocalPlayer.state.ped)
                -- PushScaleformMovieFunction(scaleform, "SET_LOCATION")
                -- PushScaleformMovieFunctionParameterString(GetLabelText(GetNameOfZone(playerCoords)))
                -- PopScaleformMovieFunctionVoid()

                -- local var1, var2 = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
                -- PushScaleformMovieFunction(scaleform, "SET_DETAILS")
                -- PushScaleformMovieFunctionParameterString(GetStreetNameFromHashKey(var1))
                -- PopScaleformMovieFunctionVoid()

                -- local year, month, day, hour, minute, second = GetLocalTime()
                -- PushScaleformMovieFunction(scaleform, "SET_TIME")
                -- PushScaleformMovieFunctionParameterString(tostring(hour))
                -- PushScaleformMovieFunctionParameterString(tostring(minute))
                -- PopScaleformMovieFunctionVoid()

                local tick = 0

                while Animations.Emotes:Get() == "camera_item" and LocalPlayer.state.loggedIn do
                    local zoomvalue = (1.0 / (camConfig.fovMax - camConfig.fovMin)) * (camConfig.fov - camConfig.fovMin)

                    HandleCameraPanning(cam, zoomvalue, camConfig)
                    HandleCameraZooming(cam, camConfig)

                    HandleCameraHeight(cam, camConfig)

                    --DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                    Wait(1)
                    -- tick = tick + 1
                    -- if tick > 500 then
                    --     tick = 0
                    --     local year, month, day, hour, minute, second = GetLocalTime()
                    --     PushScaleformMovieFunction(scaleform, "SET_TIME")
                    --     PushScaleformMovieFunctionParameterString(tostring(hour))
                    --     PushScaleformMovieFunctionParameterString(tostring(minute))
                    --     PopScaleformMovieFunctionVoid()
                    -- end
                end

                TriggerEvent('Animations:Client:UsingCamera', false)

                ClearTimecycleModifier()
                RenderScriptCams(false, false, 0, 1, 0)
                --SetScaleformMovieAsNoLongerNeeded(scaleform)
                DestroyCam(cam, false)
                SetNightvision(false)
                SetSeethrough(false)

                if LocalPlayer.state.loggedIn then
                    Hud:Show()
                end
            end)
        end
    end
end)

function HandleCameraPanning(cam, zoomvalue, config)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        newZ = rotation.z + rightAxisX * -1.0 * config.moveSpeed * (zoomvalue+0.1)
        newX = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * config.moveSpeed * (zoomvalue + 0.1)), -89.5)

        SetCamRot(cam, newX, 0.0, newZ, 2)
        SetEntityHeading(LocalPlayer.state.ped, newZ)
    end
end

function HandleCameraZooming(cam, config)
    if not (IsPedSittingInAnyVehicle(LocalPlayer.state.ped)) then
        if IsDisabledControlJustPressed(0, 241) then -- Scroll Up
            config.fov = math.max(config.fov - config.zoomSpeed, config.fovMin)
        elseif IsDisabledControlJustPressed(0, 242) then
            config.fov = math.min(config.fov + config.zoomSpeed, config.fovMax) -- Scroll Down
        end

        local current_fov = GetCamFov(cam)
        if math.abs(config.fov - current_fov) < 0.1 then
            config.fov = current_fov
        end
        SetCamFov(cam, current_fov + (config.fov - current_fov) * 0.05)
    else
        if IsControlJustPressed(0, 17) then -- Scroll Up
            config.fov = math.max(config.fov - config.zoomSpeed, config.fovMin)
        elseif IsControlJustPressed(0, 16) then
            config.fov = math.min(config.fov + config.zoomSpeed, config.fovMax) -- Scroll Down
        end

        local current_fov = GetCamFov(cam)
        if math.abs(fov - current_fov) < 0.1 then
            config.fov = current_fov
        end
        SetCamFov(cam, current_fov + (config.fov - current_fov) * 0.05) -- Smoothing of camera zoom
    end
end

function HandleCameraHeight(cam, config)
    if IsControlJustPressed(0, 172) then
        config.height += 0.05
        if config.height >= 1.0 then
            config.height = 1.0
        end
        AttachCamToEntity(cam, LocalPlayer.state.ped, 0.0, 1.0, config.height, true)
    elseif IsControlJustPressed(0, 173) then
        config.height -= 0.05
        if config.height <= -0.5 then
            config.height = -0.5
        end
        AttachCamToEntity(cam, LocalPlayer.state.ped, 0.0, 1.0, config.height, true)
    end
end

local _doingAnimState = false

AddEventHandler('Characters:Client:Spawn', function()
    _doingAnimState = false

    Wait(1000)
    EnsureCharacterAnimStates()
end)

local animStatePriority = {
    bigtv = 1000,
    tv = 999,
    house_art = 998,
    golfclubs = 997,
    bigbox = 996,
    box = 995,
    weed = 994,
    pc = 993,
    microwave = 992,
    boombox = 991,
}

function EnsureCharacterAnimStates()
local character = LocalPlayer.state.Character
    if character then
        local states = character:GetData('States') or {}
        local animStates = {}
        for k, v in ipairs(states) do
            if string.sub(v, 1, string.len("ANIM_")) == "ANIM_" then
                local s = string.gsub(v, "ANIM_", "")
                table.insert(animStates, s)
            end
        end

        if #animStates > 0 then
            table.sort(animStates, function(a, b)
                local aPrio = animStatePriority[a] or 1
                local bPrio = animStatePriority[b] or 1
                return aPrio > bPrio
            end)

            Animations.Emotes:Play(animStates[1], false, false, true)
            _doingAnimState = animStates[1]
        elseif _doingAnimState and _doingAnimState == Animations.Emotes:Get() then
            Animations.Emotes:ForceCancel()
        end
    end
end

RegisterNetEvent("Characters:Client:SetData", function()
    Wait(1000)
    if LocalPlayer.state.loggedIn then
        EnsureCharacterAnimStates()
    end
end)

RegisterNetEvent('Animations:Client:DoPDCallEmote', function(emote)
    if LocalPlayer.state.loggedIn then
        Animations.Emotes:Play('phonecall', false, 10000, true)
    end
end)

RegisterNetEvent('Animations:Client:DiceRoll', function()
    Animations.Emotes:Play('dice', true)

    Sounds.Play:Distance(3.0, 'dice.ogg', 0.8)
end)