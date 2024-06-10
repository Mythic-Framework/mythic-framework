export const initialState = {
	player: {
		size: 4,
		invType: 1,
		name: null,
		inventory: [],
		disabled: {},
		owner: 0,
		capacity: 0,
		isWeaponEligble: false,
	},
	equipment: {
		inventory: [],
	},
	secondary: {
		size: 4,
		name: null,
		invType: 2,
		inventory: [],
		disabled: {},
		owner: 0,
		capacity: 0,
	},
	showSecondary: false,
	hover: false,
	hoverOrigin: null,
	contextItem: null,
	splitItem: null,
	inUse: false,
	items: {},
	itemsLoaded: false,

	// player: {
	// 	size: 40,
	// 	invType: 1,
	// 	name: 'Player Storage',
	// 	isWeaponEligble: true,
	// 	capacity: 100,
	// 	disabled: Object(),
	// 	inventory: {
	// 		1: {
	// 			Name: 'WEAPON_ADVANCEDRIFLE',
	// 			Slot: 1,
	// 			Count: 1,
	// 			MetaData: {
	// 				CreateDate: Date.now() / 1000,
	// 			},
	// 		},
	// 		2: {
	// 			Name: 'WEAPON_ADVANCEDRIFLE',
	// 			Slot: 2,
	// 			Count: 1,
	// 			MetaData: {
	// 				CreateDate: 1625461797,
	// 			},
	// 		},
	// 		3: {
	// 			Name: 'WEAPON_ADVANCEDRIFLE',
	// 			Slot: 3,
	// 			Count: 1,
	// 			MetaData: {
	// 				CreateDate: Date.now() / 1000 - 80000,
	// 			},
	// 		},
	// 		4: {
	// 			Name: 'WEAPON_ADVANCEDRIFLE',
	// 			Slot: 4,
	// 			Count: 1,
	// 			MetaData: {
	// 				CreateDate: 1225441797,
	// 			},
	// 		},
	// 		5: {
	// 			Name: 'bread',
	// 			Slot: 5,
	// 			Count: 10,
	// 		},
	// 		6: {
	// 			Name: 'water',
	// 			Slot: 6,
	// 			Count: 10,
	// 		},
	// 	},
	// 	owner: '12214124',
	// },
	// equipment: {
	// 	inventory: [],
	// },
	// secondary: {
	// 	size: 40,
	// 	name: 'Second Storage',
	// 	invType: 11,
	// 	capacity: 100,
	// 	disabled: Object(),
	// 	inventory: {
	// 		1: {
	// 			Name: 'water',
	// 			Slot: 1,
	// 			Count: 10,
	// 		},
	// 		2: {
	// 			Name: 'water',
	// 			Slot: 2,
	// 			Count: 10,
	// 			Price: 25,
	// 		},
	// 		3: {
	// 			Name: 'bread',
	// 			Slot: 3,
	// 			Count: 10,
	// 			Price: 25,
	// 		},
	// 		4: {
	// 			Name: 'WEAPON_ADVANCEDRIFLE',
	// 			Slot: 4,
	// 			Count: 1,
	// 		},
	// 	},
	// 	owner: '346346346',
	// },
	// showSecondary: true,
	// hover: false,
	// hoverOrigin: null,
	// contextItem: null,
	// splitItem: null,
	// inUse: false,
	// items: {
	// 	bread: {
	// 		label: 'Bread',
	// 		price: 0,
	// 		isUsable: true,
	// 		isRemoved: true,
	// 		isStackable: 100,
	// 		type: 1,
	// 		rarity: 1,
	// 		metalic: false,
	// 		weight: 1,
	// 	},
	// 	water: {
	// 		label: 'Water',
	// 		price: 0,
	// 		isUsable: true,
	// 		isRemoved: true,
	// 		isStackable: 10,
	// 		type: 1,
	// 		rarity: 2,
	// 		metalic: false,
	// 		weight: 1,
	// 	},
	// 	WEAPON_ADVANCEDRIFLE: {
	// 		label: 'Advanced Rifle',
	// 		requiresLicense: true,
	// 		price: 15000,
	// 		isUsable: true,
	// 		isRemoved: false,
	// 		isStackable: false,
	// 		type: 2,
	// 		rarity: 3,
	// 		metalic: false,
	// 		weight: 1,
	// 		durability: 86400,
	// 	},
	// },
	// itemsLoaded: true,
};

const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'UNLOAD_ITEMS':
			return {
				...state,
				items: {},
			};
		case 'RESET_ITEMS':
			return {
				...state,
				items: Object(),
				itemsLoaded: false,
			};
		case 'ADD_ITEM': {
			return {
				...state,
				items: {
					...state.items,
					[action.payload.id]: action.payload.item,
				},
			};
		}
		case 'ITEMS_LOADED':
			return {
				...state,
				itemsLoaded: true,
			};
		case 'ITEMS_UNLOADED':
			return {
				...state,
				itemsLoaded: false,
			};
		case 'SET_PLAYER_INVENTORY': {
			return {
				...state,
				player: {
					...action.payload,
					invType: 1,
					disabled: state.player.disabled,
				},
			};
		}
		case 'USE_IN_PROGRESS': {
			return {
				...state,
				inUse: action.payload.state,
			};
		}
		case 'SET_SECONDARY_INVENTORY': {
			return {
				...state,
				secondary: {
					...action.payload,
					disabled:
						state.secondary.owner == action.payload.owner &&
						state.secondary.invType == action.payload.invType
							? state.secondary.disabled
							: Object(),
				},
			};
		}
		case 'SET_AVALIABLE_ITEMS': {
			return {
				...state,
				items: action.payload,
			};
		}
		case 'SET_EQUIPMENT': {
			return {
				...state,
				equipment: action.payload,
			};
		}
		case 'SHOW_SECONDARY_INVENTORY': {
			return {
				...state,
				showSecondary: true,
			};
		}
		case 'HIDE_SECONDARY_INVENTORY': {
			return {
				...state,
				showSecondary: false,
				secondary: { ...initialState.secondary },
			};
		}
		case 'SET_HOVER': {
			return {
				...state,
				hover: action.payload,
			};
		}
		case 'SET_HOVER_ORIGIN': {
			return {
				...state,
				hoverOrigin: action.payload,
			};
		}
		case 'SET_CONTEXT_ITEM': {
			return {
				...state,
				contextItem: action.payload,
			};
		}
		case 'SET_PLAYER_SLOT': {
			const playerInventory = state.player.inventory;
			const disabled = state.player.disabled;
			playerInventory[action.payload.slot] = action.payload.slotData;
			disabled[action.payload.slot] = false;
			return {
				...state,
				player: {
					...state.player,
					disabled,
					inventory: playerInventory,
				},
			};
		}
		case 'SLOT_NOT_USED': {
			const disabled = state.player.disabled;
			disabled[action.payload.originSlot] = false;
			return {
				...state,
				player: {
					...state.player,
					disabled,
				},
			};
		}
		case 'SET_SECONDARY_SLOT': {
			const secondaryInventory = state.secondary.inventory;
			const disabled = state.secondary.disabled;
			secondaryInventory[action.payload.slot] = action.payload.slotData;
			disabled[action.payload.slot] = false;
			return {
				...state,
				secondary: {
					...state.secondary,
					disabled,
					inventory: secondaryInventory,
				},
			};
		}
		case 'SET_SPLIT_ITEM': {
			return {
				...state,
				splitItem: action.payload,
			};
		}
		case 'MOVE_ITEM_PLAYER_SAME': {
			const playerInventory = state.player.inventory;
			const playerDisabled = state.player.disabled;
			moveItem(
				action.payload,
				playerInventory,
				playerDisabled,
				playerInventory,
				playerDisabled,
				state.items,
			);
			return {
				...state,
				player: {
					...state.player,
					disabled: playerDisabled,
					inventory: playerInventory,
				},
			};
		}
		case 'MOVE_ITEM_SECONDARY_SAME': {
			if (state.secondary.shop) {
				return state;
			}

			const secondary = state.secondary.inventory;
			const secondaryDisabled = state.secondary.disabled;
			moveItem(
				action.payload,
				secondary,
				secondaryDisabled,
				secondary,
				secondaryDisabled,
				state.items,
			);
			return {
				...state,
				secondary: {
					...state.secondary,
					disabled: secondaryDisabled,
					inventory: secondary,
				},
			};
		}
		case 'MOVE_ITEM_PLAYER_TO_SECONDARY': {
			if (
				state.secondary.shop ||
				calcWeight(state.secondary.inventory, state.items) +
					action.payload.itemData.weight *
						action.payload.origin.Count >
					state.secondary.capacity
			) {
				return state;
			}
			const secondary = state.secondary.inventory;
			const secondaryDisabled = state.secondary.disabled;
			const player = state.player.inventory;
			const playerDisabled = state.player.disabled;
			moveItem(
				action.payload,
				player,
				playerDisabled,
				secondary,
				secondaryDisabled,
				state.items,
			);
			return {
				...state,
				player: {
					...state.player,
					disabled: playerDisabled,
					inventory: player,
				},
				secondary: {
					...state.secondary,
					disabled: secondaryDisabled,
					inventory: secondary,
				},
			};
		}
		case 'MOVE_ITEM_SECONDARY_TO_PLAYER': {
			if (
				calcWeight(state.player.inventory, state.items) +
					action.payload.itemData.weight *
						action.payload.origin.Count >
				state.player.capacity
			) {
				return state;
			}
			const secondary = state.secondary.inventory;
			const secondaryDisabled = state.secondary.disabled;
			const player = state.player.inventory;
			const playerDisabled = state.player.disabled;
			moveItem(
				action.payload,
				secondary,
				secondaryDisabled,
				player,
				playerDisabled,
				state.items,
			);
			return {
				...state,
				player: {
					...state.player,
					disabled: playerDisabled,
					inventory: player,
				},
				secondary: {
					...state.secondary,
					disabled: secondaryDisabled,
					inventory: secondary,
				},
			};
		}
		case 'USE_ITEM_PLAYER':
			const player = state.player.inventory;
			const disabled = state.player.disabled;
			useItem(action.payload, player, disabled);
			return {
				...state,
				player: {
					...state.player,
					disabled,
					inventory: player,
				},
			};
		case 'APP_HIDE':
			return {
				...state,
				hover: null,
				hoverOrigin: null,
			};
		default:
			return state;
	}
};

// Actually what the fuck is this reducer code at this point
const calcWeight = (inv, items) => {
	return Object.keys(inv)
		.filter((a) => Boolean(inv[a]))
		.reduce((a, b) => {
			return a + (items[inv[b].Name]?.weight || 0) * inv[b].Count;
		}, 0);
};

const useItem = (payload, origin, disabled) => {
	disabled[payload.originSlot] = true;
	// if (origin[payload.originSlot].Count > 1) {
	// 	origin[payload.originSlot].Count = origin[payload.originSlot].Count - 1;
	// } else {
	// 	delete origin[payload.originSlot];
	// }
};

const moveItem = (
	payload,
	origin,
	originDisabled,
	dest,
	destDisabled,
	items,
) => {
	if (!dest[payload.destSlot]) {
		dest[payload.destSlot] = payload.origin;
		destDisabled[payload.destSlot] = true;
		origin[payload.originSlot].Count = payload.origin.shop
			? origin[payload.originSlot].Count
			: origin[payload.originSlot].Count - payload.origin.Count;

		if (!payload.origin.shop) {
			originDisabled[payload.originSlot] = true;
		}

		if (origin[payload.originSlot].Count <= 0 && !payload.origin.shop) {
			delete origin[payload.originSlot];
		}
	} else {
		if (
			dest[payload.destSlot].Name === origin[payload.originSlot].Name &&
			((Boolean(payload.origin?.isStackable) &&
				dest[payload.destSlot].Count + payload.origin.Count <=
					items[origin[payload.originSlot].Name].isStackable) ||
				payload.origin?.isStackable == -1)
		) {
			if (
				Boolean(dest[payload.destSlot].MetaData) &&
				Boolean(origin[payload.originSlot].MetaData)
			) {
				if (
					origin[payload.originSlot].MetaData?.CreateDate <
					dest[payload.destSlot].MetaData?.CreateDate
				) {
					dest[payload.destSlot].MetaData.CreateDate =
						origin[payload.originSlot].MetaData?.CreateDate;
				}
			}

			dest[payload.destSlot].Count =
				dest[payload.destSlot].Count + payload.origin.Count;
			destDisabled[payload.destSlot] = true;
			origin[payload.originSlot].Count = payload.origin.shop
				? origin[payload.originSlot].Count
				: origin[payload.originSlot].Count - payload.origin.Count;

			if (!payload.origin.shop) {
				originDisabled[payload.originSlot] = true;
			}
			if (origin[payload.originSlot].Count <= 0 && !payload.origin.shop) {
				delete origin[payload.originSlot];
			}
		} else if (!payload.origin.shop) {
			const temp = dest[payload.destSlot];
			dest[payload.destSlot] = origin[payload.originSlot];
			destDisabled[payload.destSlot] = true;
			origin[payload.originSlot] = temp;

			if (!payload.origin.shop) {
				originDisabled[payload.originSlot] = true;
			}
		}
	}
};

export default appReducer;
