export const initialState = {
    showing: false,
    config: Object({
        ingredients: Array(),
        maxCookTime: 1,
    }),
    // config: Object({
    //     ingredients: [10, 10, 10, 10],
    //     maxCookTime: 60,
    // }),
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'OPEN_METH':
            return {
                ...state,
                showing: true,
                ...action.payload,
            };
        case 'CLOSE_UI':
        case 'RESET_UI':
        case 'CLOSE_METH':
            return {
                ...initialState,
            };
        default:
            return state;
    }
};
