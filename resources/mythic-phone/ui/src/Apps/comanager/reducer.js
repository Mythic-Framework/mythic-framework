export const initialState = {
	rosterUpdated: 0,
	roster: false,
	timeWorkedUpdated: 0,
	timeWorked: Array(),
	timeWorkedJob: '',
	//roster: {
	// 		police: [
	// 			{
	// 				SID: 2,
	// 				First: 'Bob',
	// 				Last: 'Smith',
	// 				Phone: '555-555-5555',
	// 				JobData: {
	// 					Workplace: {
	// 						Id: 'lspd',
	// 						Name: 'Los Santos Police Department',
	// 					},
	// 					Name: 'Police',
	// 					Grade: {
	// 						Id: 'dchief',
	// 						Name: 'Dep. Chief',
	// 						Level: 8,
	// 					},
	// 					Id: 'police',
	// 				},
	// 			}
	// 		]
	// 	},
	tab: 0,
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'SET_COM_TAB':
			return {
				...state,
				tab: action.payload.tab,
			};
		case 'UPDATE_ROSTERS':
			return {
				...state,
				rosterUpdated: Date.now(),
				roster: action.payload.roster,
			};
		case 'UPDATE_TIMEWORKED':
			return {
				...state,
				timeWorkedUpdated: Date.now(),
				timeWorked: action.payload.timeWorked,
				timeWorkedJob: action.payload.timeWorkedJob,
			};
		case 'UI_RESET':
			return {
				...initialState,
			};
		default:
			return state;
	}
};
