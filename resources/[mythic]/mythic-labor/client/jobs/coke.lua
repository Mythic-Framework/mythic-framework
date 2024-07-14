local _joiner = nil
local _working = false
local _state = nil
local _spawned = false
local _drop = nil

local _blip = nil
local _blipArea = nil

local cokePeds = {}

local eventHandlers = {}

local _cokeWeapons = {
    `WEAPON_APPISTOL`,
	`WEAPON_MG`,
	`WEAPON_COMBATMG`,
    `WEAPON_ASSAULTRIFLE`,
    `WEAPON_CARBINERIFLE`,
    `WEAPON_COMPACTRIFLE`,
    `WEAPON_SMG`,
    `WEAPON_SMG_MK2`,
    `WEAPON_ASSAULTSHOTGUN`,
    `WEAPON_SAWNOFFSHOTGUN`,

    --`WEAPON_PUMPSHOTGUN`,
}

function SpawnPeds()
	if _state ~= 3 or _spawned then
		return
	end

    loadModel(_drop.ped)
    for i = 1, 25 do
        local coords = vector3(_drop.coords.x + math.random(-math.abs(math.ceil(_drop.size / 2)), math.ceil(_drop.size / 2)), _drop.coords.y + math.random(-math.abs(math.ceil(_drop.size / 2)), math.ceil(_drop.size / 2)), _drop.coords.z)
        local found, gZ = GetGroundZFor_3dCoord(coords.x, coords.y, 100.0, true)

        local ped = CreatePed(5, _drop.ped, coords.x, coords.y, gZ, math.random(360) * 1.0, true, true)

        while not DoesEntityExist(ped) do
            Wait(1)
        end

        local w = _cokeWeapons[math.random(#_cokeWeapons)]
        Entity(ped).state:set('crimePed', true, true)
        Entity(ped).state:set('cokePed', _joiner, true)
        GiveWeaponToPed(ped, w, 99999, false, true)
        SetCurrentPedWeapon(ped, w, true)

        SetEntityMaxHealth(ped, 2000)
        SetEntityHealth(ped, 2000)
        SetPedArmour(ped, 1000)

        SetEntityInvincible(p, true)

        DecorSetBool(ped, 'ScriptedPed', true)
        SetEntityAsMissionEntity(ped, 1, 1)

        SetPedRelationshipGroupDefaultHash(ped, `BOBCAT_SECURITY`)
        SetPedRelationshipGroupHash(ped, `BOBCAT_SECURITY`)
        SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)
        SetCanAttackFriendly(ped, false, true)
        SetPedAsCop(ped)

        TaskTurnPedToFaceEntity(ped, LocalPlayer.state.ped, 1.0)

        SetPedCombatMovement(ped, 1)
        SetPedCombatRange(ped, 2)
        SetPedCombatAttributes(ped, 0, 1)
        SetPedCombatAttributes(ped, 46, 1)
        SetPedCombatAttributes(ped, 1424, 1)
        SetPedCombatAttributes(ped, 5000, 1)
        SetPedFleeAttributes(ped, 0, 0)
        SetPedAsEnemy(ped, true)
        
        SetPedSeeingRange(ped, 100.0)
        SetPedHearingRange(ped, 100.0)
        SetPedAlertness(ped, 3)

        TaskCombatHatedTargetsAroundPed(ped, 100.0, 0)

        local _, cur = GetCurrentPedWeapon(ped, true)
        SetPedInfiniteAmmo(ped, true, cur)
        SetPedDropsWeaponsWhenDead(ped, false)

        SetEntityInvincible(ped, false)
    end
end

AddEventHandler("Labor:Client:Setup", function()
	PedInteraction:Add(
		"CokeSeller",
		GetHashKey("IG_FBISuit_01"),
		vector3(GlobalState["CokeRuns"][1], GlobalState["CokeRuns"][2], GlobalState["CokeRuns"][3]),
		GlobalState["CokeRuns"][4],
		100.0,
		{
			{
				icon = "face-surprise",
				text = "Let's Have Some Fun ($100,000)",
				event = "Coke:Client:StartWork",
				isEnabled = function()
					return LocalPlayer.state.Character:GetData("TempJob") == nil
						and not GlobalState["CokeRunActive"]
						and (not GlobalState["CokeRunCD"] or GetCloudTimeAsInt() > GlobalState["CokeRunCD"])
						and not GlobalState["RestartLockdown"]
                        and (LocalPlayer.state.Character:GetData("CokeCD") == nil or GetCloudTimeAsInt() > LocalPlayer.state.Character:GetData("CokeCD"))
				end,
			},
			{
				icon = "ban",
				text = "Cancel That, Give Me My Money",
				event = "Coke:Client:Abort",
				isEnabled = function()
					return LocalPlayer.state.Character:GetData("TempJob") == "Coke"
                        and _working
                        and _state == 0
                        and _joiner == LocalPlayer.state.serverID
				end,
			},
		},
		"question",
		false,
		true,
		{
			animDict = "timetable@ron@ig_3_couch",
			anim = "base",
		}
	)
end)

AddEventHandler("Coke:Client:StartWork", function()
	Callbacks:ServerCallback("Coke:StartWork")
end)

AddEventHandler("Coke:Client:Abort", function()
	Callbacks:ServerCallback("Coke:Abort")
end)

RegisterNetEvent("Coke:Client:OnDuty", function(joiner, time)
	_working = true
	_joiner = joiner
	_state = 0

    eventHandlers["receive"] = RegisterNetEvent(string.format("Coke:Client:%s:Receive", joiner), function()
        _state = 1
        _blip = Blips:Add("CokeDrop", "Unknown Contact", { x = 4495.498, y = -4514.340, z = 3.021 }, 306, 2, 1.4)
    end)

	eventHandlers["poly-enter"] = AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZone, data)
		if id == "cayo_perico" and _state == 1 then
            Callbacks:ServerCallback("Coke:ArriveAtCayo", {}, function() end)
		elseif id == "CokeDrop" and _state == 3 and not _spawned and _joiner == LocalPlayer.state.serverID then
            Callbacks:ServerCallback("Coke:ArrivedAtPoint", {}, function()
                SpawnPeds(data)
                RegisterHatedTargetsAroundPed(LocalPlayer.state.ped, _drop.size * 2)
            end)
		end
	end)

	eventHandlers["poly-exit"] = AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZone, data)
		if id == "cayo_perico" then
            if _state == 5 then
                Callbacks:ServerCallback("Coke:LeftCayo", {}, function() end)
            else

            end
		end
	end)

    eventHandlers["cayo-contact"] = RegisterNetEvent(string.format("Coke:Client:%s:GoTo", joiner), function()
        if _state == 1 then
            _state = 2
            PedInteraction:Add(
                "CokeDrop",
                GetHashKey("S_M_M_HairDress_01"),
                vector3(4495.498, -4514.340, 3.021),
                61.210,
                25.0,
                {
                    {
                        icon = "comment-dots",
                        text = "Lets Do This",
                        event = "Coke:Client:StartHeist",
                        isEnabled = function()
                            return LocalPlayer.state.Character:GetData("TempJob") == "Coke" and _state == 2
                        end,
                    },
                },
                "question",
                "WORLD_HUMAN_AA_SMOKE"
            )
        end
    end)

    eventHandlers["cayo-start"] = AddEventHandler("Coke:Client:StartHeist", function()
        Callbacks:ServerCallback("Coke:StartHeist", {}, function() end)
    end)

    eventHandlers["cayo-setup"] = RegisterNetEvent(string.format("Coke:Client:%s:SetupHeist", joiner), function(drop)
        _state = 3
        _drop = drop
        Blips:Remove("CokeDrop")
        _blip = Blips:Add("CokeDrop", "Unknown Objective", { x = _drop.coords.x, y = _drop.coords.y, z = _drop.coords.z }, 306, 2, 1.4)
        _blipArea = AddBlipForRadius(_drop.coords.x, _drop.coords.y, _drop.coords.maxZ, _drop.size + 0.0)
		SetBlipColour(_blipArea, 3)
		SetBlipAlpha(_blipArea, 90)

        Polyzone.Create:Circle("CokeDrop", _drop.coords, _drop.size * 2.0, {
            --debugPoly = true
        }, _drop)
    end)

    eventHandlers["cayo-doshit"] = RegisterNetEvent(string.format("Coke:Client:%s:DoShit", joiner), function()
        _spawned = true
        RegisterHatedTargetsAroundPed(LocalPlayer.state.ped, _drop.size * 2)
    end)

    eventHandlers["fetch"] = RegisterNetEvent(string.format("Coke:Client:%s:FetchItems", joiner), function()
        _state = 4
    end)

    eventHandlers["go-back"] = RegisterNetEvent(string.format("Coke:Client:%s:GoBack", joiner), function()
        _state = 5
        Blips:Remove("CokeDrop")
        RemoveBlip(_blipArea)
        Polyzone:Remove("CokeDrop")
        _blip = Blips:Add("CokeDrop", "Unknown Contact", { x = 1292.455, y = -3170.885, z = 4.906 }, 306, 2, 1.4)
    end)

    eventHandlers["setup-finish"] = RegisterNetEvent(string.format("Coke:Client:%s:SetupFinish", joiner), function()
        _state = 6
        PedInteraction:Add(
            "CokeDrop",
            GetHashKey("A_M_Y_Beach_01"),
            vector3(1292.455, -3170.885, 4.906),
            140.973,
            25.0,
            {
                {
                    icon = "comment-dots",
                    text = "I've Done What You Asked",
                    event = "Coke:Client:Finish",
                    isEnabled = function()
                        return LocalPlayer.state.Character:GetData("TempJob") == "Coke" and _state == 6
                    end,
                },
            },
            " question",
            "WORLD_HUMAN_AA_SMOKE"
        )
    end)

    eventHandlers["finish"] = AddEventHandler("Coke:Client:Finish", function()
        Callbacks:ServerCallback("Coke:Finish", {}, function() end)
    end)
end)

AddEventHandler("Coke:Client:StartJob", function()
	Callbacks:ServerCallback("Coke:StartJob", _joiner, function(state)
		if not state then
			Notification:Error("Unable To Start Job")
		end
	end)
end)

RegisterNetEvent("Coke:Client:OffDuty", function(time)
	for k, v in pairs(eventHandlers) do
		RemoveEventHandler(v)
	end

    PedInteraction:Remove("CokeDrop")
    Polyzone:Remove("CokeDrop")
    Blips:Remove("CokeDrop")
    RemoveBlip(_blipArea)

	_joiner = nil
	_working = false
	_state = nil
    _spawned = false
	eventHandlers = {}
end)
