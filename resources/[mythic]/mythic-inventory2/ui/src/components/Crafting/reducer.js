const initialState = {
	bench: 'none',
	crafting: null,
	actionString: 'Crafting',
	myCounts: Object(),
	cooldowns: Object(),
	recipes: Array(),
	// myCounts: {
	// 	bread: 12,
	// },
	// cooldowns: Object({
	// 	3: Date.now() + 1000 * 60 * 60 * 25,
	// }),
	// recipes: [
	// 	{
	// 		id: '1',
	// 		result: { name: 'water', count: 5 },
	// 		items: [
	// 			{ name: 'bread', count: 3 },
	// 			{ name: 'bread', count: 3 },
	// 			{ name: 'bread', count: 3 },
	// 			{ name: 'bread', count: 3 },
	// 			{ name: 'bread', count: 3 },
	// 			{ name: 'bread', count: 3 },
	// 			{ name: 'bread', count: 3 },
	// 			{ name: 'bread', count: 3 },
	// 		],
	// 		time: 10000,
	// 	},
	// 	{
	// 		id: '2',
	// 		result: { name: 'water', count: 1123 },
	// 		items: [
	// 			{ name: 'bread', count: 3 },
	// 			{ name: 'bread', count: 3 },
	// 		],
	// 		time: 10000,
	// 	},
	// 	{
	// 		id: '3',
	// 		result: { name: 'water', count: 1 },
	// 		items: [
	// 			{ name: 'bread', count: 3 },
	// 			{ name: 'bread', count: 3 },
	// 		],
	// 		time: 10000,
	// 		cooldown: 1000 * 60 * 60 * 25,
	// 	},
	// ],
};

const reducer = (state = initialState, action) => {
	switch (action.type) {
		case 'SET_BENCH': {
			return {
				...state,
				bench: action.payload.bench,
				cooldowns: action.payload.cooldowns,
				recipes: action.payload.recipes,
				myCounts: action.payload.myCounts,
				actionString: action.payload.actionString,
			};
		}
		case 'SET_CRAFTING': {
			return {
				...state,
				crafting: {
					...action.payload,
					progress: 0,
				},
			};
		}
		case 'END_CRAFTING':
			return {
				...state,
				crafting: null,
			};
		case 'CRAFT_PROGRESS':
			return {
				...state,
				crafting: {
					...state.crafting,
					progress: action.payload.progress,
				},
			};
		case 'APP_HIDE':
			return {
				...state,
				recipes: Array(),
			};
		default: {
			return state;
		}
	}
};

export default reducer;
