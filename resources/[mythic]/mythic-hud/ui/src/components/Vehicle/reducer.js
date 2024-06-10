export const initialState = {
    showing: false,
    ignition: true,
    speed: 0,
    speedMeasure: 'MPH',
    seatbelt: false,
    seatbeltHide: false,
    cruise: false,
    checkEngine: false,
    fuel: 100,
    fuelHide: false,
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'SHOW_VEHICLE':
            return {
                ...state,
                showing: true,
            };
        case 'HIDE_VEHICLE':
            return {
                ...state,
                showing: false,
            };
        case 'UPDATE_IGNITION':
            return {
                ...state,
                ignition: action.payload.ignition,
            };
        case 'UPDATE_SPEED':
            return {
                ...state,
                speed: action.payload.speed,
            };
        case 'UPDATE_SPEED_MEASURE':
            return {
                ...state,
                speedMeasure: action.payload.measurement,
            };
        case 'UPDATE_SEATBELT':
            return {
                ...state,
                seatbelt: action.payload.seatbelt,
            };
        case 'SHOW_SEATBELT':
            return {
                ...state,
                seatbeltHide: false,
            };
        case 'HIDE_SEATBELT':
            return {
                ...state,
                seatbeltHide: true,
            };
        case 'UPDATE_CRUISE':
            return {
                ...state,
                cruise: action.payload.cruise,
            };
        case 'UPDATE_ENGINELIGHT':
            return {
                ...state,
                checkEngine: action.payload.checkEngine,
            };
        case 'SHOW_HUD':
        case 'UPDATE_FUEL':
            return {
                ...state,
                fuel: Boolean(action.payload.fuel)
                    ? action.payload.fuel
                    : state.fuel,
                fuelHide: typeof(action.payload.fuelHide) == "boolean"
                    ? action.payload.fuelHide
                    : state.fuelHide
            };
        case 'SHOW_FUEL':
            return {
                ...state,
                fuelHide: false,
            };
        case 'HIDE_FUEL':
            return {
                ...state,
                fuelHide: true,
            };
        default:
            return state;
    }
};
