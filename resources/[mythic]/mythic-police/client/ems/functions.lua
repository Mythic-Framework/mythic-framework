RegisterNetEvent("EMS:Client:Test", function(src)
	BuildTreatmentMenu(src)
end)

function BuildTreatmentMenu(id)
	Callbacks:ServerCallback("Damage:GetLimbDamage", id, function(menu)
		local options = {}
		local ped = GetPlayerPed(GetPlayerFromServerId(tonumber(id)))
		local needsTreatment = false
		local targetState = Player(tonumber(id)).state

		table.insert(options, {
			label = "View Diagnosis",
			submenu = "view",
		})

		if targetState.isDead then
			if Jobs.Permissions:HasJob("ems") then
				table.insert(options, {
					label = string.format("Stabilize (Revive)"),
					description = "Requires Trauma Kit",
					event = "EMS:Client:Stabilize",
					data = id,
				})
				needsTreatment = true
			end
		else
			print(Jobs.Permissions:HasJob("ems"))
			if Jobs.Permissions:HasJob("ems") then
				local maxHp = GetEntityMaxHealth(ped) - 100
				local hp = GetEntityHealth(ped) - 100

				print(maxHp, hp)

				if hp < math.floor(maxHp / 2) then
					table.insert(options, {
						label = "Treat Wounds",
						description = "Requires Trauma Kit",
						event = "EMS:Client:FieldTreatWounds",
						data = id,
					})
					needsTreatment = true
				end

				if hp < math.ceil(maxHp / 4) then
					table.insert(options, {
						label = "Administer Morphine",
						description = "Requires 1x Morphine Vial",
						event = "EMS:Client:ApplyMorphine",
						data = id,
					})
					needsTreatment = true
				end
			end
		end

		if not needsTreatment then
			table.insert(options, {
				label = "Patient Doesn't Need Treatment",
				event = "EMS:Client:DismissTreatment",
			})
		end

		ListMenu:Show({
			main = {
				label = "Patient Treatment",
				items = options,
			},
			view = {
				label = "Diagnosis",
				items = menu,
			},
			treat = {
				label = "Treatments",
				items = {
					{
						label = "Field Treat",
						description = "Weak But Quick (Requires x1 Bandage)",
						event = "EMS:Client:FieldTreat",
					},
				},
			},
		})
	end)
end
