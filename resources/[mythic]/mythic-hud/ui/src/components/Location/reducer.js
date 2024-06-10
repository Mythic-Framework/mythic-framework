export const initialState = {
    showing: true,
    location: {
        main: 'Alta St',
        cross: 'Forum Dr',
        area: 'Rancho',
        direction: 'W',
    },
    shifted: false,
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'TOGGLE_LOC':
            return {
                ...state,
                showing: action.payload.state,
            };
        case 'UPDATE_LOCATION':
            return {
                ...state,
                location: action.payload.location,
            };
        case 'SHIFT_LOCATION':
            return {
                ...state,
                shifted: action.payload.shift,
            };
        default:
            return state;
    }
};
