const handoverData = window?.nuiHandoverData;

export const initialState = {
	stages: {
		INIT_BEFORE_MAP_LOADED: 0,
		INIT_AFTER_MAP_LOADED: 0,
		INIT_SESSION: 0,
	},
	completed: {},
	currentStage: null,
	test: {
		total: 410,
		current: 0,
	},
	name: handoverData?.name,
	priority: handoverData?.priority ?? 0,
	priorityMessage: handoverData?.priorityMessage,
};

let count = 0;
const appReducer = (state = initialState, action) => {
	switch (action.type) {
		case 'startInitFunction':
		case 'initFunctionInvoked':
		case 'startInitFunctionOrder':
		case 'startDataFileEntries':
		case 'initFunctionInvoking':
		case 'onDataFileEntry':
		case 'performMapLoadFunction':
		case 'endInitFunction':
		case 'endDataFileEntries':
			if (
				action.payload.type == null ||
				state.stages[action.payload.type] == null
			)
				return state;
			count++;
			let t = { ...state };

			if (
				action.payload.type == 'INIT_SESSION' &&
				t.stages.INIT_BEFORE_MAP_LOADED < 1
			) {
				t.stages.INIT_BEFORE_MAP_LOADED = 1;
				t.stages.INIT_AFTER_MAP_LOADED = 1;
				t.completed = {
					INIT_BEFORE_MAP_LOADED: true,
					INIT_AFTER_MAP_LOADED: true,
				};
				t.test.total -= 130;
			}

			if (
				state.currentStage != null &&
				action.payload.type !== state.currentStage &&
				t.completed[state.currentStage] == null
			) {
				t.completed[state.currentStage] = true;
			}

			if (t.test.current >= t.test.total) {
				t.completed.INIT_SESSION = true;
				t.currentStage = null;
			} else {
				t.currentStage = action.payload.type;
			}

			t.stages[action.payload.type] += action.payload.acount;
			return {
				...t,
				stages: {
					...t.stages,
					[action.payload.type]: t[action.payload.type] + 1,
				},
				test: {
					...t.test,
					current: count,
				},
			};
		default:
			return state;
	}
};

export default appReducer;
