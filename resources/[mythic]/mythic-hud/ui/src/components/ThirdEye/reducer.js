export const initialState = {
    showing: false,
    icon: null,
    menuOpen: false,
    menu: [],
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_EYE':
            return {
                ...state,
                ...action.payload,
                showing: true,
            };
        case 'HIDE_EYE':
            return {
                ...state,
                showing: false,
            };
        case 'OPEN_MENU':
            return {
                ...state,
                ...action.payload,
                menuOpen: true,
            };
        case 'CLOSE_MENU':
            return {
                ...state.icon,
                menuOpen: false,
                menu: [],
            };
        default:
            return state;
    }
};
