export const initialState = {
    hidden: process.env.NODE_ENV == 'production',
    inputting: process.env.NODE_ENV != 'production',
};

const appReducer = (state = initialState, action) => {
    switch (action.type) {
        case 'ON_OPEN':
            return {
                ...state,
                hidden: false,
                inputting: true,
            };
        case 'ON_SCREEN_STATE_CHANGE':
            return {
                ...state,
                hidden: action.payload.shouldHide,
                inputting:
                    action.payload.inputting != undefined
                        ? action.payload.inputting
                        : state.inputting,
            };
        default:
            return state;
    }
};

export default appReducer;
