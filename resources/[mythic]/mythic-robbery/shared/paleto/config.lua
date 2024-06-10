_pbDoorIds = {
	"bank_savings_paleto_office_1",
	"bank_savings_paleto_office_2",
	"bank_savings_paleto_office_3",
	"bank_savings_paleto_corridor_1",
	"bank_savings_paleto_corridor_2",
	"bank_savings_paleto_security",
	"bank_savings_paleto_back_1",
	"bank_savings_paleto_back_2",
	"bank_savings_paleto_gate",
	"bank_savings_paleto_vault",
}

_pbKillZones = {
	{
		coords = vector3(-104.65, 6460.56, 31.63),
		length = 4.8,
		width = 4.8,
		options = {
			heading = 315,
			--debugPoly = true,
			minZ = 30.63,
			maxZ = 33.43,
		},
		data = {
			isDeath = true,
			tpCoords = vector3(-113.465, 6460.281, 31.468),
			door = "bank_savings_paleto_office_1",
		},
	},
	{
		coords = vector3(-97.26, 6467.69, 31.63),
		length = 4.8,
		width = 4.8,
		options = {
			heading = 315,
			--debugPoly = true,
			minZ = 30.63,
			maxZ = 33.23,
		},
		data = {
			isDeath = true,
			tpCoords = vector3(-113.465, 6460.281, 31.468),
			door = "bank_savings_paleto_office_2",
		},
	},
	{
		coords = vector3(-105.54, 6477.56, 31.63),
		length = 6.0,
		width = 4.8,
		options = {
			heading = 45,
			--debugPoly = true,
			minZ = 30.63,
			maxZ = 33.43,
		},
		data = {
			isDeath = true,
			tpCoords = vector3(-113.465, 6460.281, 31.468),
			door = "bank_savings_paleto_office_3",
		},
	},
	{
		coords = vector3(-98.41, 6461.68, 31.63),
		length = 4.65,
		width = 5.4,
		options = {
			heading = 315,
			--debugPoly = true,
			minZ = 30.63,
			maxZ = 33.63,
		},
		data = {
			isDeath = true,
			tpCoords = vector3(-113.465, 6460.281, 31.468),
			door = "bank_savings_paleto_vault",
		},
	},
	{
		coords = vector3(-93.12, 6465.23, 31.63),
		length = 7.0,
		width = 3.6,
		options = {
			heading = 315,
			--debugPoly = true,
			minZ = 30.63,
			maxZ = 33.23,
		},
		data = {
			isDeath = true,
			tpCoords = vector3(-113.465, 6460.281, 31.468),
			door = "bank_savings_paleto_security",
		},
	},
}

_pbPCHackAreas = {
	{
		coords = vector3(-179.37, 6148.54, 42.64),
		length = 10.2,
		width = 21.2,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 41.64,
			maxZ = 47.64,
		},
		data = {
			pcId = 1,
		},
	},
	{
		coords = vector3(432.57, 6465.72, 35.78),
		length = 27.1,
		width = 8.4,
		options = {
			heading = 230,
			--debugPoly=true,
			minZ = 34.78,
			maxZ = 38.78,
		},
		data = {
			pcId = 2,
		},
	},
	{
		coords = vector3(-2174.1, 4290.36, 49.05),
		length = 9.6,
		width = 7.6,
		options = {
			heading = 326,
			--debugPoly=true,
			minZ = 48.05,
			maxZ = 50.45,
		},
		data = {
			pcId = 3,
		},
	},
	{
		coords = vector3(3616.07, 5024.11, 11.45),
		length = 7.6,
		width = 9.0,
		options = {
			heading = 290,
			--debugPoly=true,
			minZ = 10.45,
			maxZ = 13.65,
		},
		data = {
			pcId = 4,
		},
	},
}

_pbSubStationZones = {
	{
		coords = vector3(2589.08, 5060.17, 44.92),
		length = 20.4,
		width = 21.2,
		options = {
			heading = 16,
			--debugPoly = true,
			minZ = 43.92,
			maxZ = 51.52,
		},
		data = {
			subStationId = 1,
		},
	},
	{
		coords = vector3(1346.19, 6383.21, 33.41),
		length = 34.6,
		width = 25.2,
		options = {
			heading = 0,
			--debugPoly = true,
			minZ = 32.41,
			maxZ = 39.21,
		},
		data = {
			subStationId = 2,
		},
	},
	{
		coords = vector3(-288.54, 6019.09, 31.55),
		length = 20.2,
		width = 14.6,
		options = {
			heading = 45,
			--debugPoly = true,
			minZ = 30.55,
			maxZ = 35.55,
		},
		data = {
			subStationId = 3,
		},
	},
	{
		coords = vector3(234.31, 6402.54, 31.65),
		length = 19.8,
		width = 27.6,
		options = {
			heading = 26,
			--debugPoly = true,
			minZ = 30.65,
			maxZ = 35.45,
		},
		data = {
			subStationId = 4,
		},
	},
}

_pbPowerHacks = {
	{
		coords = vector3(-442.17, 5602.08, 68.38),
		length = 0.6,
		width = 1.0,
		options = {
			heading = 4,
			--debugPoly = true,
			minZ = 67.98,
			maxZ = 69.78,
		},
		data = {
			boxId = 1,
			ptFxPoint = vector3(-442.168, 5601.922, 68.80035),
		},
	},
	{
		coords = vector3(8.99, 6221.59, 31.47),
		length = 0.4,
		width = 0.8,
		options = {
			heading = 28,
			--debugPoly = true,
			minZ = 30.87,
			maxZ = 32.67,
		},
		data = {
			boxId = 2,
			ptFxPoint = vector3(8.950461, 6221.659, 31.73336),
		},
	},
	{
		coords = vector3(2872.15, 4869.36, 62.29),
		length = 1.0,
		width = 0.6,
		options = {
			heading = 31,
			--debugPoly = true,
			minZ = 62.09,
			maxZ = 63.69,
		},
		data = {
			boxId = 3,
			ptFxPoint = vector3(2872.163, 4869.374, 62.93316),
		},
	},
	{
		coords = vector3(-83.59, 6131.98, 30.46),
		length = 1.2,
		width = 0.6,
		options = {
			heading = 319,
			--debugPoly=true,
			minZ = 30.26,
			maxZ = 32.26,
		},
		data = {
			boxId = 4,
			ptFxPoint = vector3(-83.68681, 6132, 31.04742),
		},
	},
}

_pbDoorHacks = {
	{
		coords = vector3(-97.26, 6475.09, 31.3),
		length = 0.6,
		width = 0.4,
		options = {
			heading = 46,
			--debugPoly = true,
			minZ = 30.7,
			maxZ = 32.5,
		},
	},
	{
		coords = vector3(-118.76, 6477.38, 31.57),
		length = 1.0,
		width = 0.6,
		options = {
			heading = 317,
			--debugPoly = true,
			minZ = 30.37,
			maxZ = 32.77,
		},
	},
}

_pbLasers = {
	{
		origins = vec3(-101.190002, 6467.169922, 33.935001),
		targets = {
			vec3(-101.503998, 6463.251953, 30.646000),
			vec3(-100.108002, 6464.666016, 30.634001),
			vec3(-104.019997, 6464.421875, 30.634001),
		},
		options = {
			travelTimeBetweenTargets = { 1.0, 1.0 },
			waitTimeAtTargets = { 0.0, 0.0 },
			randomTargetSelection = true,
			name = "paleto1",
		},
	},
	{
		origins = vec3(-104.024002, 6464.348145, 33.953999),
		targets = {
			vec3(-100.125999, 6464.629883, 30.643999),
			vec3(-101.486000, 6463.270020, 30.635000),
			vec3(-101.257004, 6467.187012, 30.634001),
		},
		options = {
			travelTimeBetweenTargets = { 1.0, 1.0 },
			waitTimeAtTargets = { 0.0, 0.0 },
			randomTargetSelection = true,
			name = "paleto2",
		},
	},
	{
		origins = vec3(-102.140999, 6462.520996, 33.980000),
		targets = {
			vec3(-103.057999, 6465.428223, 30.634001),
			vec3(-102.267998, 6466.155762, 30.634001),
			vec3(-99.417999, 6465.327148, 30.634001),
			vec3(-102.188004, 6462.559082, 30.634001),
			vec3(-104.000999, 6464.437988, 30.634001),
			vec3(-101.267998, 6467.199219, 30.634001),
		},
		options = {
			travelTimeBetweenTargets = { 1.0, 1.0 },
			waitTimeAtTargets = { 0.0, 0.0 },
			randomTargetSelection = true,
			name = "paleto3",
		},
	},
	{
		origins = vec3(-99.348999, 6465.328125, 34.018002),
		targets = {
			vec3(-102.271004, 6466.204102, 30.634001),
			vec3(-103.042999, 6465.412109, 30.634001),
			vec3(-102.177002, 6462.564941, 30.634001),
			vec3(-101.299004, 6467.194824, 30.634001),
			vec3(-99.428001, 6465.315918, 30.634001),
			vec3(-101.489998, 6463.266113, 30.683001),
			vec3(-100.100998, 6464.654785, 30.643999),
		},
		options = {
			travelTimeBetweenTargets = { 1.0, 1.0 },
			waitTimeAtTargets = { 0.0, 0.0 },
			randomTargetSelection = true,
			name = "paleto4",
		},
	},
}

_pbOfficeHacks = {
	{
		coords = vector3(-103.82, 6460.55, 31.63),
		length = 1.4,
		width = 0.8,
		options = {
			heading = 314,
			--debugPoly=true,
			minZ = 30.63,
			maxZ = 32.63,
		},
		data = {
			door = "bank_savings_paleto_office_1",
			officeId = 1,
		},
	},
	{
		coords = vector3(-98.16, 6466.24, 31.63),
		length = 1.4,
		width = 0.8,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.63,
			maxZ = 32.43,
		},
		data = {
			door = "bank_savings_paleto_office_2",
			officeId = 2,
		},
	},
	{
		coords = vector3(-104.85, 6479.08, 31.63),
		length = 1.4,
		width = 0.8,
		options = {
			heading = 317,
			--debugPoly=true,
			minZ = 28.43,
			maxZ = 32.43,
		},
		data = {
			door = "bank_savings_paleto_office_3",
			officeId = 3,
		},
	},
}

_pbOfficeSearch = {
	{
		coords = vector3(-103.98, 6458.19, 31.63),
		length = 2.2,
		width = 0.8,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.63,
			maxZ = 32.23
		},
		data = {
			door = "bank_savings_paleto_office_1",
			searchId = 1,
		},
	},
	{
		coords = vector3(-106.94, 6460.9, 31.63),
		length = 1.8,
		width = 0.6,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.63,
			maxZ = 32.23
		},
		data = {
			door = "bank_savings_paleto_office_1",
			searchId = 2,
		},
	},
	{
		coords = vector3(-94.96, 6467.06, 31.63),
		length = 2.2,
		width = 0.8,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.63,
			maxZ = 32.23
		},
		data = {
			door = "bank_savings_paleto_office_2",
			searchId = 3,
		},
	},
	{
		coords = vector3(-97.89, 6470.08, 31.63),
		length = 1.8,
		width = 0.6,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.63,
			maxZ = 32.23
		},
		data = {
			door = "bank_savings_paleto_office_2",
			searchId = 4,
		},
	},
	{
		coords = vector3(-108.29, 6478.6, 31.63),
		length = 2.2,
		width = 0.8,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.63,
			maxZ = 32.23
		},
		data = {
			door = "bank_savings_paleto_office_3",
			searchId = 5,
		},
	},
	{
		coords = vector3(-102.78, 6476.56, 31.63),
		length = 2.4,
		width = 0.6,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.63,
			maxZ = 32.23
		},
		data = {
			door = "bank_savings_paleto_office_3",
			searchId = 6,
		},
	},
}

_pbDrillPoints = {
	{
		coords = vector3(-97.61, 6464.32, 31.63),
		length = 0.6,
		width = 1.2,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.83,
			maxZ = 33.23,
		},
		data = {
			drillId = 1,
		},
	},
	{
		coords = vector3(-95.85, 6462.88, 31.63),
		length = 0.6,
		width = 1.2,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.83,
			maxZ = 33.23,
		},
		data = {
			drillId = 2,
		},
	},
	{
		coords = vector3(-95.7, 6460.14, 31.63),
		length = 0.6,
		width = 1.2,
		options = {
			heading = 45,
			--debugPoly=true,
			minZ = 30.83,
			maxZ = 33.23,
		},
		data = {
			drillId = 3,
		},
	},
	{
		coords = vector3(-97.03, 6458.83, 31.63),
		length = 0.6,
		width = 1.2,
		options = {
			heading = 45,
			--debugPoly=true,
			minZ = 30.83,
			maxZ = 33.23,
		},
		data = {
			drillId = 4,
		},
	},
	{
		coords = vector3(-99.41, 6458.79, 31.63),
		length = 0.6,
		width = 1.2,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.83,
			maxZ = 33.23,
		},
		data = {
			drillId = 5,
		},
	},
	{
		coords = vector3(-100.33, 6459.83, 31.63),
		length = 0.6,
		width = 1.2,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.83,
			maxZ = 33.23,
		},
		data = {
			drillId = 6,
		},
	},
	{
		coords = vector3(-101.47, 6461.05, 31.63),
		length = 0.6,
		width = 1.2,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.83,
			maxZ = 33.23,
		},
		data = {
			drillId = 7,
		},
	},
}
