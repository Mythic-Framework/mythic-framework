export const initialState = {
    showing: false,
    message: null,
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_ACTION':
            return {
                ...state,
                message: action.payload.message,
                buttons: action.payload.buttons,
                showing: true,
            };
        case 'HIDE_ACTION':
            return {
                ...state,
                showing: false,
            };
        default:
            return state;
    }
};
