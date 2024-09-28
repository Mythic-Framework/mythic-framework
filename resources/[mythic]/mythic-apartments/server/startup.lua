_aptData = {
	{
		name = "Boring Tower",
		invEntity = 13,
		coords = vector3(-481.83, -690.74, 33.21),
		heading = 96.566,
		length = 8.4,
		width = 4.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 32.21,
			maxZ = 36.21
		},
		interior = {
			wakeup = {
				x = 351.1,
				y = -201.598,
				z = 53.1,
				h = 68.261,
			},
			spawn = {
				x = 347.826,
				y = -200.121,
				z = 54.239,
				h = 243.706
			},
			locations = {
				exit = {
					coords = vector3(347.41, -199.9, 54.24),
					length = 0.4,
					width = 1.2,
					options = {
						heading = 69,
						--debugPoly=true,
						minZ = 53.24,
						maxZ = 55.64
					},
				},
				wardrobe = {
					coords = vector3(351.89, -205.34, 54.23),
					length = 0.4,
					width = 2.0,
					options = {
						heading = 339,
						--debugPoly=true,
						minZ = 53.23,
						maxZ = 56.23
					},
				},
				stash = {
					coords = vector3(348.69, -208.74, 54.23),
					length = 2.4,
					width = 1.0,
					options = {
						heading = 339,
						--debugPoly=true,
						minZ = 53.23,
						maxZ = 54.63
					},
				},
				logout = {
					coords = vector3(346.02, -207.23, 54.23),
					length = 2.0,
					width = 2.8,
					options = {
						heading = 338,
						--debugPoly=true,
						minZ = 51.83,
						maxZ = 54.03
					},
				},
			},
		},
	},
}

function Startup()
	local aptIds = {}

	for k, v in ipairs(_aptData) do
		v.id = k
		GlobalState[string.format("Apartment:%s", k)] = v
		table.insert(aptIds, k)
	end

	GlobalState["Apartments"] = aptIds
end
