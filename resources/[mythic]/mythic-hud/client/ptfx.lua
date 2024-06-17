local particleEffects = {}
local particleList = {
	smoke = { dic = "core", name = "exp_grd_grenade_smoke", loopAmount = 1, timeCheck = 12000, scale = 2.5 },
	flash = { dic = "core", name = "ent_anim_paparazzi_flash", loopAmount = 1, timeCheck = 250, scale = 5.0 },
	spark = { dic = "core", name = "ent_amb_sparking_wires", loopAmount = 1, timeCheck = 12000, scale = 1.0 },
}

RegisterNetEvent("Particles:Client:DoFx", function(x, y, z, particleId, allocatedID, rX, rY, rZ)
	if #(vector3(x, y, z) - GetEntityCoords(PlayerPedId())) < 100 then
		local particleDictionary = particleList[particleId].dic
		local particleName = particleList[particleId].name
		local scale = particleList[particleId].scale
		local loopAmount = particleList[particleId].loopAmount
		local duration = particleList[particleId].timeCheck

		if not HasNamedPtfxAssetLoaded(particleDictionary) then
			RequestNamedPtfxAsset(particleDictionary)
			while not HasNamedPtfxAssetLoaded(particleDictionary) do
				Wait(1)
			end
		end

		for i = 0, loopAmount do
			SetPtfxAssetNextCall(particleDictionary)
			local particle =
				StartParticleFxLoopedAtCoord(particleName, x, y, z, rX, rY, rZ, scale, false, false, false, false)
			local object = { ["particle"] = particle, ["id"] = allocatedID }
			particleEffects[allocatedID] = object
			Wait(duration)
			StopParticleFxLooped(particle, false)
		end

		particleEffects[allocatedID] = nil
	end
end)

RegisterNetEvent("Particles:Client:StopFx", function(allocatedID)
	for j, particle in pairs(particleEffects) do
		if allocatedID == particle.id then
			RemoveParticleFx(particle.particle, true)
		end
	end
end)
