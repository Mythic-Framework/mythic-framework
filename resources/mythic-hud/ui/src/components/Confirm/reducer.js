export const initialState = {
    showing: false,
    yes: null,
    no: null,
    data: null,
    title: null,
    description: null,
    denyLabel: null,
    acceptLabel: null

    // showing: true,
    // yes: 'test',
    // no: 'test',
    // data: {
    //     penis: true,
    // },
    // title: 'Confirm?',
    // description: 'This is a description or something',
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_CONFIRM':
            return {
                ...state,
                showing: true,
                ...action.payload,
            };
        case 'CLOSE_UI':
        case 'RESET_UI':
        case 'CLOSE_CONFIRM':
            return {
                ...initialState,
            };
        default:
            return state;
    }
};
