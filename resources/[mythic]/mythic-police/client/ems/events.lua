AddEventHandler("EMS:Client:OnDuty", function()
	if Jobs.Permissions:HasJob('ems', 'safd') and not LocalPlayer.state.Character:GetData("Callsign") then
		Notification:Error("Callsign Not Set, Unable To Go On Duty")
		return
	end

	Jobs.Duty:On('ems')
end)

AddEventHandler("EMS:Client:OffDuty", function()
	Jobs.Duty:Off('ems')
end)

RegisterNetEvent("Characters:Client:Logout", function()
	_evald = {}
end)

AddEventHandler("EMS:Client:Evaluate", function(entity, data)
	if not entity then return end

	Progress:ProgressWithStartEvent({
		name = "ems_eval",
		duration = 6000,
		label = "Evaluating Patient",
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "amb@medic@standing@tendtodead@idle_a",
			anim = "idle_b",
			flags = 9,
		},
	}, function() end, function(cancelled)
		if not cancelled then
			BuildTreatmentMenu(entity.serverId)
		end
	end)
end)

AddEventHandler("EMS:Client:DrugTest", function(entity, data)
	Progress:Progress({
		name = "drug_test_action",
		duration = 6000,
		label = "Performing Drug Test",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			task = "WORLD_HUMAN_STAND_MOBILE",
		},
	}, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback("EMS:DrugTest", entity.serverId, function() end)
		end
	end)
end)

AddEventHandler("EMS:Client:DismissTreatment", function()
	ListMenu:Close()
end)

AddEventHandler("EMS:Client:CheckICUPatients", function()
	TriggerServerEvent("EMS:Server:CheckICUPatients")
end)

AddEventHandler("EMS:Client:Stabilize", function(target, idk)
	if Inventory.Items:Has("traumakit", 1) then
		Progress:ProgressWithStartEvent({
			name = "ems_eval",
			duration = 10000,
			label = "Stabilizing",
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@medic@standing@tendtodead@idle_a",
				anim = "idle_b",
				flags = 9,
			},
		}, function() end, function(cancelled)
			if not cancelled then
				Callbacks:ServerCallback("EMS:Stabilize", target, function(res)
					if not res.error then
						Notification:Success("Patient Stabilized")
					else
						if res.code == 2 then
							Notification:Error("Need A Trauma Kit")
						else
							Notification:Error("Unable To Stabilize Patient")
						end
					end
				end)
			end
		end)
	else
		Notification:Error("Need A Trauma Kit")
	end
end)

-- AddEventHandler("EMS:Client:ApplyTourniquet", function(data)
-- 	if Inventory.Items:Has("tourniquet", 1) then
-- 		Progress:ProgressWithStartEvent({
-- 			name = "ems_eval",
-- 			duration = 4000,
-- 			label = "Applying Tourniquet",
-- 			canCancel = true,
-- 			controlDisables = {
-- 				disableMovement = true,
-- 				disableCarMovement = true,
-- 				disableMouse = false,
-- 				disableCombat = true,
-- 			},
-- 			animation = {
-- 				animDict = "amb@medic@standing@tendtodead@idle_a",
-- 				anim = "idle_b",
-- 				flags = 9,
-- 			},
-- 		}, function() end, function(cancelled)
-- 			if not cancelled then
-- 				Callbacks:ServerCallback("EMS:ApplyTourniquet", data, function(res)
-- 					if not res.error then
-- 						Notification:Success("Tourniquet Applied")
-- 					else
-- 						if res.code == 2 then
-- 							Notification:Error("Need A Tourniquet")
-- 						else
-- 							Notification:Error("Unable To Apply Tourniquet")
-- 						end
-- 					end
-- 				end)
-- 			end
-- 		end)
-- 	else
-- 		Notification:Error("Need A Tourniquet")
-- 	end
-- end)

AddEventHandler("EMS:Client:FieldTreatWounds", function(data)
	if Inventory.Items:Has("traumakit", 1) then
		Progress:ProgressWithStartEvent({
			name = "ems_eval",
			duration = 4000,
			label = "Treating Wounds",
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@medic@standing@tendtodead@idle_a",
				anim = "idle_b",
				flags = 9,
			},
		}, function() end, function(cancelled)
			if not cancelled then
				Callbacks:ServerCallback("EMS:FieldTreatWounds", data, function(res)
					if not res.error then
						local ped = GetPlayerPed(GetPlayerFromServerId(tonumber(data)))
						local mHp = GetEntityHealth(ped) - 100
						SetEntityHealth(ped, (mHp / 2))
						Notification:Success("Wounds Treated")
					else
						if res.code == 2 then
							Notification:Error("Need A Trauma Kit")
						else
							Notification:Error("Unable To Treat Patient")
						end
					end
				end)
			end
		end)
	else
		Notification:Error("Need A Trauma Kit")
	end
end)

AddEventHandler("EMS:Client:ApplyBandage", function(data)
	if Inventory.Items:Has("bandage", 1) then
		Progress:ProgressWithStartEvent({
			name = "ems_eval",
			duration = 3000,
			label = "Applying Bandage",
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@medic@standing@tendtodead@idle_a",
				anim = "idle_b",
				flags = 9,
			},
		}, function() end, function(cancelled)
			if not cancelled then
				Callbacks:ServerCallback("EMS:ApplyBandage", data, function(res)
					if not res.error then
						Notification:Success("Bandage Applied")
					else
						if res.code == 2 then
							Notification:Error("Need A Trauma Kit")
						else
							Notification:Error("Unable To Apply Bandage")
						end
					end
				end)
			end
		end)
	else
		Notification:Error("Need A Bandage")
	end
end)

AddEventHandler("EMS:Client:ApplyMorphine", function(data)
	if Inventory.Items:Has("morphine", 1) then
		Progress:ProgressWithStartEvent({
			name = "ems_eval",
			duration = 3000,
			label = "Administering Morphine",
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@medic@standing@tendtodead@idle_a",
				anim = "idle_b",
				flags = 9,
			},
		}, function() end, function(cancelled)
			if not cancelled then
				Callbacks:ServerCallback("EMS:ApplyMorphine", data, function(res)
					if not res.error then
						Notification:Success("Morphine Administered")
					else
						if res.code == 2 then
							Notification:Error("Need A Morphine Vial")
						else
							Notification:Error("Unable To Administer Morphine")
						end
					end
				end)
			end
		end)
	else
		Notification:Error("Need A Morphine Vial")
	end
end)

RegisterNetEvent("EMS:Client:TreatWounds", function(data)
	if Player(data).state.isHospitalized then
		Progress:ProgressWithStartEvent({
			name = "ems_eval",
			duration = 20000,
			label = "Treating Patient",
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "amb@medic@standing@tendtodead@idle_a",
				anim = "idle_b",
				flags = 9,
			},
		}, function() end, function(cancelled)
			if not cancelled then
				Callbacks:ServerCallback("EMS:TreatWounds", data, function(res)
					if res.error then
						Notification:Error("Unable To Treat Patient")
					end
				end)
			end
		end)
	else
		Notification:Error("Patient Is Not Hospitalized")
	end
end)
