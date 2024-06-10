import Nui from './util/Nui';
export const initialState = {
	data: {
		playerHistory: {
			current: 0,
			max: 64,
			queue: 0,
			history:  []
		}
	},
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'SET_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]: action.payload.data,
				},
			};
		case 'RESET_DATA':
			return initialState;
		case 'ADD_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]:
						state.data[action.payload.type] != null
							? Object.prototype.toString.call(
									state.data[action.payload.type],
							  ) == '[object Array]'
								? action.payload.first
									? [
											action.payload.data,
											...state.data[action.payload.type],
									  ]
									: [
											...state.data[action.payload.type],
											action.payload.data,
									  ]
								: action.payload.key
								? {
										...state.data[action.payload.type],
										[action.payload.key]:
											action.payload.data,
								  }
								: {
										...state.data[action.payload.type],
										...action.payload.data,
								  }
							: [action.payload.data],
				},
			};
		case 'UPDATE_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]:
						Object.prototype.toString.call(
							state.data[action.payload.type],
						) == '[object Array]'
							? state.data[action.payload.type].map((data) =>
									data._id == action.payload.id
										? { ...action.payload.data }
										: data,
							  )
							: (state.data[action.payload.type] = action.payload
									.key
									? {
											...state.data[action.payload.type],
											[action.payload.id]: {
												...state.data[
													action.payload.type
												][action.payload.id],
												[action.payload.key]:
													action.payload.data,
											},
									  }
									: {
											...state.data[action.payload.type],
											[action.payload.id]:
												action.payload.data,
									  }),
				},
			};
		case 'REMOVE_DATA':
			return {
				...state,
				data: {
					...state.data,
					[action.payload.type]:
						Object.prototype.toString.call(
							state.data[action.payload.type],
						) == '[object Array]'
							? state.data[action.payload.type].filter((data) => {
									return Object.prototype.toString.call(
										data,
									) == '[object Object]'
										? action.payload.key
											? data[action.payload.key] !=
											  action.payload.id
											: data._id != action.payload.id
										: data != action.payload.id;
							  })
							: (state.data[action.payload.type] = Object.keys(
									state.data[action.payload.type],
							  ).reduce((result, key) => {
									if (key != action.payload.id) {
										result[key] =
											state.data[action.payload.type][
												key
											];
									}
									return result;
							  }, {})),
				},
			};
		case 'LOGOUT':
			return {
				...initialState,
			};
		case 'COPY':
			Nui.copyClipboard(action.payload.data);
			return state;
		default:
			return state;
	}
};
