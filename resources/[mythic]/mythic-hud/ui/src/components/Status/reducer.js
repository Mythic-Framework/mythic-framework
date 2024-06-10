export const initialState = {
    health: 100,
    armor: 100,
    isDead: false,
    statuses: [],
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SET_DEAD':
            return {
                ...state,
                isDead: action.payload.state,
            };
        case 'SHOW_HUD':
        case 'UPDATE_HP':
            return {
                ...state,
                health: action.payload.hp,
                armor: action.payload.armor,
            };
        case 'REGISTER_STATUS':
            return {
                ...state,
                statuses: [...state.statuses, action.payload.status],
            };
        case 'RESET_STATUSES':
            return {
                ...state,
                statuses: Array(),
            };
        case 'UPDATE_STATUS':
            return {
                ...state,
                statuses: state.statuses.map((status, i) =>
                    status.name == action.payload.status.name
                        ? { ...status, ...action.payload.status }
                        : status,
                ),
            };
        case 'UPDATE_STATUS_VALUE':
            return {
                ...state,
                statuses: state.statuses.map((status, i) =>
                    status.name == action.payload.name
                        ? { ...status, value: action.payload.value }
                        : status,
                ),
            };
        case 'UPDATE_STATUSES':
            return {
                ...state,
                statuses: action.payload.statuses,
            };
        default:
            return state;
    }
};
