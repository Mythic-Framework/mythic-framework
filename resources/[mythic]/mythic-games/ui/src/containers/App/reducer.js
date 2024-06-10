export const initialState = {
    hidden: false,
    sniper: false,
    armed: false,
    blindfolded: false,
    persistent: {},
};

const appReducer = (state = initialState, action) => {
    switch (action.type) {
        case 'APP_SHOW':
            return {
                ...state,
                hidden: false,
            };
        case 'APP_HIDE':
            return {
                ...state,
                hidden: true,
            };
        case 'SHOW_SCOPE':
            return {
                ...state,
                sniper: true,
            };
        case 'ARMED':
            return {
                ...state,
                armed: action.payload.state,
            };
        case 'HIDE_SCOPE':
            return {
                ...state,
                sniper: false,
            };
        case 'SET_BLINDFOLD':
            return {
                ...state,
                blindfolded: action.payload.state,
            };
        default:
            return state;
    }
};

export default appReducer;
