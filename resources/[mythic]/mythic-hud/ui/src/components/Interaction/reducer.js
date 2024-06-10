export const initialState = {
    show: false,
    menuItems: Array(),
    layer: 0,
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_INTERACTION_MENU':
            return {
                ...state,
                show: action.payload.toggle,
            };
        case 'SET_INTERACTION_LAYER':
            return {
                ...state,
                layer: action.payload.layer,
            };
        case 'SET_INTERACTION_MENU_ITEMS':
            return {
                ...state,
                menuItems: action.payload.items.sort((a, b) => a.id - b.id),
            };
        default:
            return state;
    }
};
