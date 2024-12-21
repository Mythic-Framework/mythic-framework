export const initialState = {
    showing: false,
    info: Object(),

    // showing: true,
    // info: {
    //     quality: 100,
    // }
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_GEM_TABLE':
            return {
                ...state,
                showing: true,
                info: action.payload.info,
            };
        case 'CLOSE_GEM_TABLE':
            return {
                ...state,
                showing: false,
            };
        default:
            return state;
    }
};
