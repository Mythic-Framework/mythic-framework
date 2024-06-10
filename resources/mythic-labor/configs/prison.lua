_prisonJobs = {
	{
		action = "Cleanup",
		blip = {
			name = "Prison Labor",
			sprite = 728,
			color = 56,
		},
		timeReduce = (60 * 10),
		locations = {
			{
				type = "box",
				coords = vector3(1787.14, 2547.33, 45.67),
				length = 2.4,
				width = 2.8,
				options = {
					name = "cleanup1",
					heading = 0,
					--debugPoly=true,
					minZ = 44.67,
					maxZ = 46.27,
				},
				data = {
					id = 1,
					label = "Cleaning",
					animation = {
						anim = "clean",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1787.08, 2550.78, 45.67),
				length = 2.4,
				width = 2.8,
				options = {
					name = "cleanup2",
					heading = 0,
					--debugPoly=true,
					minZ = 44.67,
					maxZ = 46.27,
				},
				data = {
					id = 2,
					label = "Cleaning",
					animation = {
						anim = "clean",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1787.1, 2554.52, 45.67),
				length = 2.4,
				width = 2.8,
				options = {
					name = "cleanup3",
					heading = 0,
					--debugPoly=true,
					minZ = 44.67,
					maxZ = 46.27,
				},
				data = {
					id = 3,
					label = "Cleaning",
					animation = {
						anim = "clean",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1781.28, 2547.28, 45.67),
				length = 2.4,
				width = 2.8,
				options = {
					name = "cleanup4",
					heading = 0,
					--debugPoly=true,
					minZ = 44.67,
					maxZ = 46.27,
				},
				data = {
					id = 4,
					label = "Cleaning",
					animation = {
						anim = "clean",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1781.28, 2550.9, 45.67),
				length = 2.4,
				width = 2.8,
				options = {
					name = "cleanup5",
					heading = 0,
					--debugPoly=true,
					minZ = 44.67,
					maxZ = 46.27,
				},
				data = {
					id = 5,
					label = "Cleaning",
					animation = {
						anim = "clean",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1781.28, 2554.52, 45.67),
				length = 2.4,
				width = 2.8,
				options = {
					name = "cleanup6",
					heading = 0,
					--debugPoly=true,
					minZ = 44.67,
					maxZ = 46.27,
				},
				data = {
					id = 6,
					label = "Cleaning",
					animation = {
						anim = "clean",
					},
					duration = 10000,
				},
			},
		},
	},
	{
		action = "Perform Maintenance",
		blip = {
			name = "Prison Labor",
			sprite = 566,
			color = 56,
		},
		timeReduce = (60 * 14),
		locations = {
			{
				type = "box",
				coords = vector3(1630.01, 2565.13, 45.56),
				length = 1.6,
				width = 4.0,
				options = {
					name = "maint1",
					heading = 0,
					--debugPoly=true,
					minZ = 44.56,
					maxZ = 47.16,
				},
				data = {
					id = 1,
					label = "Repairing",
					animation = {
						anim = "mechanic2",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1608.8, 2567.95, 45.56),
				length = 3.6,
				width = 1.8,
				options = {
					name = "maint2",
					heading = 315,
					--debugPoly=true,
					minZ = 44.56,
					maxZ = 47.56,
				},
				data = {
					id = 2,
					label = "Repairing",
					animation = {
						anim = "mechanic2",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1609.02, 2539.59, 45.56),
				length = 1.2,
				width = 3.4,
				options = {
					name = "maint3",
					heading = 314,
					--debugPoly=true,
					minZ = 44.56,
					maxZ = 47.36,
				},
				data = {
					id = 3,
					label = "Repairing",
					animation = {
						anim = "mechanic2",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1621.77, 2508.12, 45.56),
				length = 3.6,
				width = 1.0,
				options = {
					name = "maint4",
					heading = 4,
					--debugPoly=true,
					minZ = 44.56,
					maxZ = 47.76,
				},
				data = {
					id = 4,
					label = "Repairing",
					animation = {
						anim = "mechanic2",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1643.49, 2490.04, 45.56),
				length = 1.15,
				width = 3.4,
				options = {
					name = "maint5",
					heading = 5,
					--debugPoly=true,
					minZ = 44.56,
					maxZ = 47.56,
				},
				data = {
					id = 5,
					label = "Repairing",
					animation = {
						anim = "mechanic2",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1643.49, 2490.04, 45.56),
				length = 1.15,
				width = 3.4,
				options = {
					name = "maint6",
					heading = 5,
					--debugPoly=true,
					minZ = 44.56,
					maxZ = 47.56,
				},
				data = {
					id = 6,
					label = "Repairing",
					animation = {
						anim = "mechanic2",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1678.72, 2480.11, 45.56),
				length = 1.2,
				width = 3.2,
				options = {
					name = "maint7",
					heading = 312,
					--debugPoly=true,
					minZ = 44.56,
					maxZ = 47.36,
				},
				data = {
					id = 7,
					label = "Repairing",
					animation = {
						anim = "mechanic2",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1700.7, 2473.98, 45.56),
				length = 4.0,
				width = 1.6,
				options = {
					name = "maint8",
					heading = 315,
					--debugPoly=true,
					minZ = 44.16,
					maxZ = 47.16,
				},
				data = {
					id = 8,
					label = "Repairing",
					animation = {
						anim = "mechanic2",
					},
					duration = 10000,
				},
			},
			{
				type = "box",
				coords = vector3(1707.14, 2480.37, 45.56),
				length = 3.8,
				width = 1.4,
				options = {
					name = "maint9",
					heading = 317,
					--debugPoly=true,
					minZ = 44.36,
					maxZ = 47.16,
				},
				data = {
					id = 9,
					label = "Repairing",
					animation = {
						anim = "mechanic2",
					},
					duration = 10000,
				},
			},
		},
	},
	{
		action = "Repair",
		blip = {
			name = "Prison Labor",
			sprite = 728,
			color = 56,
		},
		timeReduce = (60 * 8),
		locations = {
			{
				type = "circle",
				coords = vector3(1761.52, 2541.4, 45.57),
				radius = 1.0,
				options = {
					name="reapir1",
					useZ=false,
					--debugPoly=true
				},
				data = {
					id = 1,
					label = "Repairing",
					animation = {
						anim = "hammer",
					},
					duration = 15000,
				},
			},
			{
				type = "circle",
				coords = vector3(1717.63, 2527.39, 45.56),
				radius = 1.0,
				options = {
					name="repair2",
					useZ=false,
					--debugPoly=true
				},
				data = {
					id = 2,
					label = "Repairing",
					animation = {
						anim = "hammer",
					},
					duration = 15000,
				},
			},
			{
				type = "circle",
				coords = vector3(1664.89, 2502.62, 45.56),
				radius = 1.0,
				options = {
					name="repair3",
					useZ=false,
					--debugPoly=true
				},
				data = {
					id = 3,
					label = "Repairing",
					animation = {
						anim = "hammer",
					},
					duration = 15000,
				},
			},
			{
				type = "circle",
				coords = vector3(1627.69, 2539.35, 45.56),
				radius = 1.0,
				options = {
					name="repair4",
					useZ=false,
					--debugPoly=true
				},
				data = {
					id = 4,
					label = "Repairing",
					animation = {
						anim = "hammer",
					},
					duration = 15000,
				},
			},
		},
	},
}
