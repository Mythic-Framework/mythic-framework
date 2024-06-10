export const initialState = {
    showing: false,
    event: null,
    title: null,
    label: null,
    type: null,
    data: null,
    options: Object(),

    // showing: true,
    // event: 'test',
    // title: 'Breaching',
    // label: 'Unit Number (Owner State ID)',
    // inputs: [
    //     {
    //         id: 'number',
    //         type: 'text',
    //         options: {
    //             inputProps: {
    //                 maxLength: 24,
    //             },
    //         },
    //     },
    // ],
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_INPUT':
            return {
                ...state,
                showing: true,
                ...action.payload,
                options: action.payload.options ?? Object(),
            };
        case 'CLOSE_UI':
        case 'RESET_UI':
        case 'CLOSE_INPUT':
            return {
                ...initialState,
            };
        default:
            return state;
    }
};
