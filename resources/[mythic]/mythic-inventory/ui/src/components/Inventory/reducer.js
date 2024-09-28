
export const initialState = process.env.NODE_ENV === 'production' ? {
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
	staticTooltip: false,
} : {
	player: {
		size: 40,
		invType: 1,
		name: 'Player Storage',
		isWeaponEligble: true,
		capacity: 100,
		disabled: Object(),
		inventory: {
			1: {
				Name: 'WEAPON_ADVANCEDRIFLE',
				Slot: 1,
				Count: 1,
				MetaData: {
					CreateDate: Date.now() / 1000,
				},
			},
			2: {
				Name: 'WEAPON_ADVANCEDRIFLE',
				Slot: 2,
				Count: 1,
				MetaData: {
					CreateDate: 1625461797,
				},
			},
			3: {
				Name: 'WEAPON_ADVANCEDRIFLE',
				Slot: 3,
				Count: 1,
				MetaData: {
					CreateDate: Date.now() / 1000 - 80000,
				},
			},
			4: {
				Name: 'WEAPON_ADVANCEDRIFLE',
				Slot: 4,
				Count: 1,
				MetaData: {
					CreateDate: 1225441797,
				},
			},
			5: {
				Name: 'burger',
				Slot: 5,
				Count: 10,
			},
			6: {
				Name: 'water',
				Slot: 6,
				Count: 10,
			},
			7: {
				Name: 'goldbar',
				Slot: 7,
				Count: 35,
			},
		},
		owner: '12214124',
	},
	equipment: {
		inventory: [],
	},
	secondary: {
		size: 40,
		name: 'Second Storage',
		invType: 11,
		capacity: 100,
		disabled: Object(),
		inventory: {
			1: {
				Name: 'water',
				Slot: 1,
				Count: 10,
			},
			2: {
				Name: 'water',
				Slot: 2,
				Count: 10,
				Price: 25,
			},
			3: {
				Name: 'burger',
				Slot: 3,
				Count: 10,
				Price: 25,
			},
			4: {
				Name: 'WEAPON_ADVANCEDRIFLE',
				Slot: 4,
				Count: 1,
			},
		},
		owner: '346346346',
	},
	showSecondary: true,
	hover: false,
	hoverOrigin: null,
	contextItem: null,
	splitItem: null,
	inUse: false,
	items: {
		burger: {
			label: 'Burger',
			price: 0,
			isUsable: true,
			isRemoved: true,
			isStackable: 100,
			type: 1,
			rarity: 1,
			metalic: false,
			weight: 1,
		},
		water: {
			label: 'Water',
			price: 0,
			isUsable: true,
			isRemoved: true,
			isStackable: 10,
			type: 1,
			rarity: 2,
			metalic: false,
			weight: 1,
		},
		goldbar: {
			label: 'Gold Bar',
			price: 0,
			isUsable: false,
			isRemoved: true,
			isStackable: 100,
			type: 1,
			rarity: 2,
			metalic: false,
			weight: 1,
		},
		WEAPON_ADVANCEDRIFLE: {
			label: 'Advanced Rifle',
			requiresLicense: true,
			price: 15000,
			isUsable: true,
			isRemoved: false,
			isStackable: false,
			type: 2,
			rarity: 3,
			metalic: false,
			weight: 1,
			durability: 86400,
		},
		heavy_glue: {
			label: 'Heavy Duty Glue',
			price: 200,
			isUsable: false,
			isRemoved: true,
			isStackable: 100,
			type: 4,
			rarity: 3,
			metalic: false,
			weight: 50,
		},
	},
	itemsLoaded: true,
}

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
		case 'OPEN_STATIC_TOOLTIP':
			return {
				...state,
				staticTooltip: action.payload.item,
			};

		case 'CLOSE_STATIC_TOOLTIP':
			return {
				...state,
				staticTooltip: false,
			};
		case 'RESET_INVENTORY':
			return {
				...state,
				player: {
					...initialState.player,
					disabled: { ...state.player.disabled },
				},
				secondary: {
					...initialState.secondary,
					disabled: { ...state.secondary.disabled },
				},
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
			return {
				...state,
				player: {
					...state.player,
					disabled: {
						...state.player.disabled,
						[action.payload.slot]: false,
					},
					// inventory: [
					// 	...state.player.inventory.map((slot) => {
					// 		if (slot?.Slot == action.payload.slot)
					// 			return { ...action.payload.data };
					// 		else return slot;
					// 	}),
					// ],
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
			return {
				...state,
				secondary: {
					...state.secondary,
					disabled: {
						...state.secondary.disabled,
						[action.payload.slot]: false,
					},
					// inventory: [
					// 	...state.secondary.inventory.map((slot) => {
					// 		if (slot?.Slot == action.payload.slot)
					// 			return { ...action.payload.data };
					// 		else return slot;
					// 	}),
					// ],
				},
			};
		}
		case 'SET_SPLIT_ITEM': {
			return {
				...state,
				splitItem: action.payload,
			};
		}
		case 'MERGE_ITEM_PLAYER_SAME': {
			let pInv = [
				...state.player.inventory
					.filter((slot) => slot?.Slot != action.payload.originSlot)
					.map((slot) => {
						if (slot?.Slot == action.payload.destSlot) {
							let originItem = state.player.inventory.filter(
								(slot) =>
									slot?.Slot == action.payload.originSlot,
							)[0];
							return {
								...slot,
								Count: slot.Count + originItem.Count,
							};
						} else return slot;
					}),
			];

			return {
				...state,
				player: {
					...state.player,
					disabled: {
						...state.player.disabled,
						[action.payload.originSlot]: true,
						[action.payload.destSlot]: true,
					},
					inventory: pInv,
				},
			};
		}
		case 'SPLIT_ITEM_PLAYER_SAME': {
			let pInv =
				state.player.inventory.filter(
					(s) => s?.Slot == action.payload.destSlot,
				).length > 0
					? [
							...state.player.inventory.map((slot) => {
								if (slot?.Slot == action.payload.originSlot) {
									return {
										...slot,
										Count:
											slot.Count -
											action.payload.origin.Count,
									};
								} else if (
									slot?.Slot == action.payload.destSlot
								) {
									return {
										...slot,
										Count:
											slot.Count +
											action.payload.origin.Count,
									};
								}
								return slot;
							}),
					  ]
					: [
							...state.player.inventory.map((slot) => {
								if (slot?.Slot == action.payload.originSlot) {
									return {
										...slot,
										Count:
											slot.Count -
											action.payload.origin.Count,
									};
								}
								return slot;
							}),
							{
								...action.payload.origin,
								Slot: action.payload.destSlot,
							},
					  ];

			return {
				...state,
				player: {
					...state.player,
					disabled: {
						...state.player.disabled,
						[action.payload.originSlot]: true,
						[action.payload.destSlot]: true,
					},
					inventory: pInv,
				},
			};
		}
		case 'SWAP_ITEM_PLAYER_SAME': {
			let pInv = [
				...state.player.inventory.map((slot) => {
					if (slot?.Slot == action.payload.originSlot) {
						return {
							...slot,
							Slot: action.payload.destSlot,
						};
					} else if (slot?.Slot == action.payload.destSlot) {
						return {
							...slot,
							Slot: action.payload.originSlot,
						};
					} else return slot;
				}),
			];

			return {
				...state,
				player: {
					...state.player,
					disabled: {
						...state.player.disabled,
						[action.payload.originSlot]: true,
						[action.payload.destSlot]: true,
					},
					inventory: pInv,
				},
			};
		}
		case 'MOVE_ITEM_PLAYER_SAME': {
			let pInv = [
				...state.player.inventory.map((slot) => {
					if (slot?.Slot == action.payload.originSlot) {
						return {
							...slot,
							Slot: action.payload.destSlot,
						};
					} else return slot;
				}),
			];

			return {
				...state,
				player: {
					...state.player,
					disabled: {
						...state.player.disabled,
						[action.payload.originSlot]: true,
						[action.payload.destSlot]: true,
					},
					inventory: pInv,
				},
			};
		}
		case 'MERGE_ITEM_SECONDARY_SAME': {
			let sInv = [
				...state.secondary.inventory
					.filter((slot) => slot?.Slot != action.payload.originSlot)
					.map((slot) => {
						if (slot?.Slot == action.payload.destSlot) {
							let originItem = state.secondary.inventory.filter(
								(slot) =>
									slot?.Slot == action.payload.originSlot,
							)[0];
							return {
								...slot,
								Count: slot.Count + originItem.Count,
							};
						} else return slot;
					}),
			];

			return {
				...state,
				secondary: {
					...state.secondary,
					disabled: {
						...state.secondary.disabled,
						[action.payload.originSlot]: true,
						[action.payload.destSlot]: true,
					},
					inventory: sInv,
				},
			};
		}
		case 'SPLIT_ITEM_SECONDARY_SAME': {
			let sInv =
				state.secondary.inventory.filter(
					(s) => s?.Slot == action.payload.destSlot,
				).length > 0
					? [
							...state.secondary.inventory.map((slot) => {
								if (slot?.Slot == action.payload.originSlot) {
									return {
										...slot,
										Count:
											slot.Count -
											action.payload.origin.Count,
									};
								} else if (
									slot?.Slot == action.payload.destSlot
								) {
									return {
										...slot,
										Count:
											slot.Count +
											action.payload.origin.Count,
									};
								}
								return slot;
							}),
					  ]
					: [
							...state.secondary.inventory.map((slot) => {
								if (slot?.Slot == action.payload.originSlot) {
									return {
										...slot,
										Count:
											slot.Count -
											action.payload.origin.Count,
									};
								}
								return slot;
							}),
							{
								...action.payload.origin,
								Slot: action.payload.destSlot,
							},
					  ];

			return {
				...state,
				secondary: {
					...state.secondary,
					disabled: {
						...state.secondary.disabled,
						[action.payload.originSlot]: true,
						[action.payload.destSlot]: true,
					},
					inventory: sInv,
				},
			};
		}
		case 'SWAP_ITEM_SECONDARY_SAME': {
			let sInv = [
				...state.secondary.inventory.map((slot) => {
					if (slot?.Slot == action.payload.originSlot) {
						return {
							...slot,
							Slot: action.payload.destSlot,
						};
					} else if (slot?.Slot == action.payload.destSlot) {
						return {
							...slot,
							Slot: action.payload.originSlot,
						};
					} else return slot;
				}),
			];

			return {
				...state,
				secondary: {
					...state.secondary,
					disabled: {
						...state.secondary.disabled,
						[action.payload.originSlot]: true,
						[action.payload.destSlot]: true,
					},
					inventory: sInv,
				},
			};
		}
		case 'MOVE_ITEM_SECONDARY_SAME': {
			let sInv = [
				...state.secondary.inventory.map((slot) => {
					if (slot?.Slot == action.payload.originSlot) {
						return {
							...slot,
							Slot: action.payload.destSlot,
						};
					} else return slot;
				}),
			];

			return {
				...state,
				secondary: {
					...state.secondary,
					disabled: {
						...state.secondary.disabled,
						[action.payload.originSlot]: true,
						[action.payload.destSlot]: true,
					},
					inventory: sInv,
				},
			};
		}
		case 'MERGE_ITEM_PLAYER_TO_SECONDARY': {
			let pInv = [
				...state.player.inventory.filter(
					(slot) => slot?.Slot != action.payload.originSlot,
				),
			];
			let sInv = [
				...state.secondary.inventory.map((s) => {
					if (s?.Slot == action.payload.destSlot)
						return {
							...s,
							Count: s.Count + action.payload.origin.Count,
						};
					else return s;
				}),
			];

			if (
				calcWeight(pInv, state.items) <= state.player.capacity &&
				calcWeight(sInv, state.items) <= state.secondary.capacity
			) {
				return {
					...state,
					player: {
						...state.player,
						disabled: {
							...state.player.disabled,
							[action.payload.originSlot]: true,
						},
						inventory: pInv,
					},
					secondary: {
						...state.secondary,
						disabled: {
							...state.secondary.disabled,
							[action.payload.destSlot]: true,
						},
						inventory: sInv,
					},
				};
			} else return state;
		}
		case 'SPLIT_ITEM_PLAYER_TO_SECONDARY': {
			let pInv = [
				...state.player.inventory.map((slot) => {
					if (slot?.Slot == action.payload.originSlot) {
						return {
							...slot,
							Count: slot.Count - action.payload.origin.Count,
						};
					} else return slot;
				}),
			];
			let sInv =
				state.secondary.inventory.filter(
					(s) => s?.Slot == action.payload.destSlot,
				).length > 0
					? [
							...state.secondary.inventory.map((s) => {
								if (s?.Slot == action.payload.destSlot)
									return {
										...s,
										Count:
											s.Count +
											action.payload.origin.Count,
									};
								else return s;
							}),
					  ]
					: [
							...state.secondary.inventory,
							{
								...action.payload.origin,
								Slot: action.payload.destSlot,
							},
					  ];

			if (
				calcWeight(pInv, state.items) <= state.player.capacity &&
				calcWeight(sInv, state.items) <= state.secondary.capacity
			) {
				return {
					...state,
					player: {
						...state.player,
						disabled: {
							...state.player.disabled,
							[action.payload.originSlot]: true,
						},
						inventory: pInv,
					},
					secondary: {
						...state.secondary,
						disabled: {
							...state.secondary.disabled,
							[action.payload.destSlot]: true,
						},
						inventory: sInv,
					},
				};
			} else return state;
		}
		case 'SWAP_ITEM_PLAYER_TO_SECONDARY': {
			let pInv = [
				...state.player.inventory.filter(
					(slot) => slot?.Slot != action.payload.originSlot,
				),
				...state.secondary.inventory
					.filter((s) => s?.Slot == action.payload.destSlot)
					.map((s) => ({
						...s,
						Slot: action.payload.originSlot,
					})),
			];
			let sInv = [
				...state.secondary.inventory.filter(
					(slot) => slot?.Slot != action.payload.destSlot,
				),
				...state.player.inventory
					.filter((s) => s?.Slot == action.payload.originSlot)
					.map((s) => ({
						...s,
						Slot: action.payload.destSlot,
					})),
			];

			if (
				calcWeight(pInv, state.items) <= state.player.capacity &&
				calcWeight(sInv, state.items) <= state.secondary.capacity
			) {
				return {
					...state,
					player: {
						...state.player,
						disabled: {
							...state.player.disabled,
							[action.payload.originSlot]: true,
						},
						inventory: pInv,
					},
					secondary: {
						...state.secondary,
						disabled: {
							...state.secondary.disabled,
							[action.payload.destSlot]: true,
						},
						inventory: sInv,
					},
				};
			} else return state;
		}
		case 'MOVE_ITEM_PLAYER_TO_SECONDARY': {
			let pInv = [
				...state.player.inventory.filter(
					(s) => Boolean(s) && s?.Slot != action.payload.originSlot,
				),
			];
			let sInv = [
				...state.secondary.inventory,
				...state.player.inventory
					.filter(
						(s) =>
							Boolean(s) && s?.Slot == action.payload.originSlot,
					)
					.map((s) => {
						return { ...s, Slot: action.payload.destSlot };
					}),
				,
			];

			if (
				calcWeight(pInv, state.items) <= state.player.capacity &&
				calcWeight(sInv, state.items) <= state.secondary.capacity
			) {
				return {
					...state,
					player: {
						...state.player,
						disabled: {
							...state.player.disabled,
							[action.payload.originSlot]: true,
						},
						inventory: pInv,
					},
					secondary: {
						...state.secondary,
						disabled: {
							...state.secondary.disabled,
							[action.payload.destSlot]: true,
						},
						inventory: sInv,
					},
				};
			} else return state;
		}
		case 'MERGE_ITEM_SECONDARY_TO_PLAYER': {
			let pInv = [
				...state.player.inventory.map((s) => {
					if (s?.Slot == action.payload.destSlot)
						return {
							...s,
							Count: s.Count + action.payload.origin.Count,
						};
					else return s;
				}),
			];
			let sInv = !Boolean(action.payload.origin.shop)
				? [
						...state.secondary.inventory.filter(
							(slot) =>
								Boolean(slot) &&
								slot?.Slot != action.payload.originSlot,
						),
				  ]
				: state.secondary.inventory;

			if (
				calcWeight(pInv, state.items) <= state.player.capacity &&
				(calcWeight(sInv, state.items) <= state.secondary.capacity ||
					action.payload.origin.shop)
			) {
				return {
					...state,
					player: {
						...state.player,
						disabled: {
							...state.player.disabled,
							[action.payload.destSlot]: true,
						},
						inventory: pInv,
					},
					secondary: {
						...state.secondary,
						disabled: {
							...state.secondary.disabled,
							[action.payload.originSlot]: true,
						},
						inventory: sInv,
					},
				};
			} else return state;
		}
		case 'SPLIT_ITEM_SECONDARY_TO_PLAYER': {
			let pInv =
				state.player.inventory.filter(
					(s) => s?.Slot == action.payload.destSlot,
				).length > 0
					? [
							...state.player.inventory.map((s) => {
								if (s?.Slot == action.payload.destSlot)
									return {
										...s,
										Count:
											s.Count +
											action.payload.origin.Count,
									};
								else return s;
							}),
					  ]
					: [
							...state.player.inventory,
							{
								...action.payload.origin,
								Slot: action.payload.destSlot,
							},
					  ];
			let sInv = !Boolean(action.payload.origin.shop)
				? [
						...state.secondary.inventory.map((slot) => {
							if (slot?.Slot == action.payload.originSlot) {
								return {
									...slot,
									Count:
										slot.Count -
										action.payload.origin.Count,
								};
							} else return slot;
						}),
				  ]
				: state.secondary.inventory;
			if (
				calcWeight(pInv, state.items) <= state.player.capacity &&
				(calcWeight(sInv, state.items) <= state.secondary.capacity ||
					action.payload.origin.shop)
			) {
				return {
					...state,
					player: {
						...state.player,
						disabled: {
							...state.player.disabled,
							[action.payload.destSlot]: true,
						},
						inventory: pInv,
					},
					secondary: {
						...state.secondary,
						disabled: {
							...state.secondary.disabled,
							[action.payload.originSlot]: true,
						},
						inventory: sInv,
					},
				};
			} else return state;
		}
		case 'SWAP_ITEM_SECONDARY_TO_PLAYER': {
			let pInv = !Boolean(action.payload.origin.shop)
				? [
						...state.player.inventory.filter(
							(slot) => slot?.Slot != action.payload.destSlot,
						),
						...state.secondary.inventory
							.filter((s) => s?.Slot == action.payload.originSlot)
							.map((s) => ({
								...s,
								Slot: action.payload.destSlot,
							})),
				  ]
				: state.player.inventory;
			let sInv = !Boolean(action.payload.origin.shop)
				? [
						...state.secondary.inventory.filter(
							(slot) => slot?.Slot != action.payload.originSlot,
						),
						...state.player.inventory
							.filter((s) => s?.Slot == action.payload.destSlot)
							.map((s) => ({
								...s,
								Slot: action.payload.originSlot,
							})),
				  ]
				: state.secondary.inventory;

			if (
				calcWeight(pInv, state.items) <= state.player.capacity &&
				(calcWeight(sInv, state.items) <= state.secondary.capacity ||
					action.payload.origin.shop)
			) {
				return {
					...state,
					player: {
						...state.player,
						disabled: {
							...state.player.disabled,
							[action.payload.destSlot]: true,
						},
						inventory: pInv,
					},
					secondary: {
						...state.secondary,
						disabled: {
							...state.secondary.disabled,
							[action.payload.originSlot]: true,
						},
						inventory: sInv,
					},
				};
			} else return state;
		}
		case 'MOVE_ITEM_SECONDARY_TO_PLAYER': {
			let pInv = [
				...state.player.inventory,
				...state.secondary.inventory
					.filter(
						(s) =>
							Boolean(s) && s?.Slot == action.payload.originSlot,
					)
					.map((s) => {
						return {
							...s,
							Slot: action.payload.destSlot,
							CreateDate: action.payload.origin.shop
								? Date.now() / 1000
								: s.CreateDate,
						};
					}),
			];
			let sInv = !action.payload.origin.shop
				? [
						...state.secondary.inventory.filter(
							(s) =>
								Boolean(s) &&
								s?.Slot != action.payload.originSlot,
						),
				  ]
				: state.secondary.inventory;

			if (
				calcWeight(pInv, state.items) <= state.player.capacity &&
				(calcWeight(sInv, state.items) <= state.secondary.capacity ||
					action.payload.origin.shop)
			) {
				return {
					...state,
					player: {
						...state.player,
						disabled: {
							...state.player.disabled,
							[action.payload.destSlot]: true,
						},
						inventory: pInv,
					},
					secondary: {
						...state.secondary,
						disabled: {
							...state.secondary.disabled,
							[action.payload.originSlot]: true,
						},
						inventory: sInv,
					},
				};
			} else return state;
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
	return inv
		.filter((a) => Boolean(a))
		.reduce((a, b) => {
			return a + (items[b.Name]?.weight || 0) * b.Count;
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

export default appReducer;
