_itemsSource["beanmachine"] = {
	{
		name = "million_shrtbread",
		label = "Millionare Shortbread",
		price = 50,
		isUsable = true,
		isRemoved = true,
		isStackable = 15,
		type = 1,
		rarity = 1,
		closeUi = true,
		weight = 0.25,
		statusChange = {
			Add = {
				PLAYER_HUNGER = 80,
			},
		},
		animConfig = {
			anim = "eat",
			time = 5000,
			pbConfig = {
				label = "Eating",
				useWhileDead = false,
				canCancel = true,
				vehicle = false,
				disarm = true,
				ignoreModifier = true,
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
		},
		metalic = false,
		isDestroyed = true,
		durability = (60 * 60 * 24 * 5),
		energyModifier = {
			modifier = 1.1,
			duration = 6, -- not seconds?
			cooldown = 60, -- seconds
			skipScreenEffects = true,
		},
	},
	{
		name = "carrot_cake",
		label = "Carrot Cake",
        description = "A Lovely Comforting Cake",
		price = 240,
		isUsable = true,
		isRemoved = true,
		isStackable = 15,
		type = 1,
		rarity = 1,
		closeUi = true,
		weight = 0.25,
		statusChange = {
			Add = {
				PLAYER_HUNGER = 100,
			},
			Ignore = {
				PLAYER_STRESS = 20,
			},
		},
        stressTicks = { "3", "3", "3", "3", "3", "3", "3", "3" },
		animConfig = {
			anim = "eat",
			time = 10000,
			pbConfig = {
				label = "Eating",
				useWhileDead = false,
				canCancel = true,
				vehicle = false,
				disarm = true,
				ignoreModifier = true,
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
		},
		metalic = false,
		isDestroyed = true,
		durability = (60 * 60 * 24 * 5),
	},


    {
		name = "smoothie_veg",
		label = "Veg Smoothie",
        description = "A Bean Machine Exclusive",
		price = 240,
		isUsable = true,
		isRemoved = true,
		isStackable = 15,
		type = 1,
		rarity = 1,
		closeUi = true,
		weight = 0.25,
		statusChange = {
			Add = {
				PLAYER_HUNGER = 10,
				PLAYER_THIRST = 75,
			},
            Remove = {
				PLAYER_DRUNK = 10,
			}
		},
		animConfig = {
			anim = "cup",
			time = 9000,
			pbConfig = {
				label = "Drinking",
				useWhileDead = false,
				canCancel = true,
				vehicle = false,
				disarm = true,
				ignoreModifier = true,
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
		},
		energyModifier = {
			modifier = 1.2,
			duration = 5, -- not seconds?
			cooldown = 60, -- seconds
			skipScreenEffects = true,
		},
		metalic = false,
		isDestroyed = true,
		durability = (60 * 60 * 24 * 5),
	},


    {
		name = "expresso",
		label = "Espresso",
		price = 200,
		isUsable = true,
		isRemoved = true,
		isStackable = 15,
		type = 1,
		rarity = 1,
		closeUi = true,
		weight = 0.25,
		metalic = false,
		isDestroyed = true,
		durability = (60 * 60 * 24 * 5),
		animConfig = {
			anim = "coffee",
			time = 7500,
			pbConfig = {
				label = "Drinking Espresso",
				useWhileDead = false,
				canCancel = true,
				vehicle = false,
				disarm = true,
				ignoreModifier = true,
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
		},
		statusChange = {
			Add = {
				PLAYER_THIRST = 25,
			},
		},
		progressModifier = {
			modifier = 50,
			min = 6,
			max = 10,
		}
	},
	{
		name = "beanmachine",
		label = "The Bean Machine",
		description = "We take beans and put them in machines",
		price = 200,
		isUsable = true,
		isRemoved = true,
		isStackable = 15,
		type = 1,
		rarity = 1,
		closeUi = true,
		weight = 0.25,
		metalic = false,
		isDestroyed = true,
		durability = (60 * 60 * 24 * 5),
		animConfig = {
			anim = "coffee",
			time = 7500,
			pbConfig = {
				label = "Drinking Coffee",
				useWhileDead = false,
				canCancel = true,
				vehicle = false,
				disarm = true,
				ignoreModifier = true,
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = true,
			},
		},
		statusChange = {
			Add = {
				PLAYER_THIRST = 15,
			},
		},
		progressModifier = {
			modifier = 60,
			min = 3,
			max = 6,
		}
	},
}