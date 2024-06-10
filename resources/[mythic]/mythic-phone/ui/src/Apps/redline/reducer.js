export const initialState = {
	tab: 0,
	inRace: false,
	creator: null,
	races: [],
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'SET_RACE_TAB':
			return {
				...state,
				tab: action.payload.tab,
			};
		case 'RACE_STATE_CHANGE':
			return {
				...state,
				creator: action.payload.state,
			};
		case 'EVENT_SPAWN':
			return {
				...state,
				races: action.payload.races.filter((r) => r.state != -1),
				inRace: false,
			};
		case 'I_RACE':
			return {
				...state,
				inRace: action.payload.state,
			};
		case 'ADD_PENDING_RACE':
			return {
				...state,
				races: [...state.races, action.payload],
			};
		case 'CANCEL_RACE':
			return {
				...state,
				races: [
					...state.races.filter((r) => r._id != action.payload.race),
				],
				inRace: action.payload.myRace ? false : state.inRace,
			};
		case 'STATE_UPDATE':
			return {
				...state,
				races: state.races.map((race, k) => {
					if (race._id == action.payload.race)
						return { ...race, state: action.payload.state };
					else return race;
				}),
			};
		case 'JOIN_RACE':
			return {
				...state,
				races: state.races.map((r) => {
					if (r._id == action.payload.race) {
						return {
							...r,
							racers: {
								...r.racers,
								[action.payload.racer]: Object(),
							},
						};
					} else return r;
				}),
			};
		case 'LEAVE_RACE':
			return {
				...state,
				races: state.races.map((r) => {
					if (r._id == action.payload.race) {
						return {
							...r,
							racers: Object.keys(r.racers).reduce(
								(result, key) => {
									if (key != action.payload.racer) {
										result[key] = r.racers[key];
									}
									return result;
								},
								{},
							),
						};
					} else return r;
				}),
			};
		case 'RACER_FINISHED':
			return {
				...state,
				races: state.races.map((r, k) => {
					if (r._id == action.payload.race) {
						return {
							...r,
							racers: {
								...r.racers,
								[action.payload.racer]: action.payload.finish,
							},
						};
					}
				}),
			};
		case 'FINISH_RACE':
			return {
				...state,
				races: [
					...state.races.map((r) => {
						if (r._id == action.payload.index)
							return action.payload.race;
						else return r;
					}),
				],
			};
		case 'UI_RESET':
			return {
				...initialState,
			};
		default:
			return state;
	}
};
