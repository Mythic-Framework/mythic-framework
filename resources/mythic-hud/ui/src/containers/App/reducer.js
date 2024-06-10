export const initialState = {
    hidden: false,
    sniper: false,
    armed: false,
    blindfolded: false,
    persistent: {},

    flashbanged: false,

    isDeathTexts: false,
    isReleasing: false,
    deathTime: false,
    releaseTimer: false,
    releaseType: false,
    releaseKey: false,
    helpKey: false,
    medicalPrice: false,
};

const appReducer = (state = initialState, action) => {
    switch (action.type) {
        case 'APP_SHOW':
            return {
                ...state,
                hidden: false,
            };
        case 'APP_HIDE':
            return {
                ...state,
                hidden: true,
            };
        case 'DO_DEATH_TEXT': {
            return {
                ...state,
                isDeathTexts: true,
                isReleasing: false,
                deathTime: action.payload.deathTime * 1000,
                releaseTimer: action.payload.timer * 1000,
                releaseType: action.payload.type,
                releaseKey: action.payload.key,
                helpKey: action.payload.f1Key,
                medicalPrice: action.payload.medicalPrice,
            };
        }
        case 'DO_DEATH_RELEASING':
            return {
                ...state,
                isReleasing: true,
            };
        case 'HIDE_DEATH_TEXT':
            return {
                ...state,
                isDeathTexts: false,
                isReleasing: false,
                deathTime: false,
                releaseTimer: false,
                releaseType: false,
                releaseKey: false,
                helpKey: false,
                medicalPrice: false,
            };
        case 'SHOW_SCOPE':
            return {
                ...state,
                sniper: true,
            };
        case 'ARMED':
            return {
                ...state,
                armed: action.payload.state,
            };
        case 'HIDE_SCOPE':
            return {
                ...state,
                sniper: false,
            };
        case 'SET_BLINDFOLD':
            return {
                ...state,
                blindfolded: action.payload.state,
            };
        case 'SET_FLASHBANGED':
            return {
                ...state,
                flashbanged: action.payload,
            };
        case 'CLEAR_FLASHBANGED':
            return {
                ...state,
                flashbanged: false,
            };
        default:
            return state;
    }
};

export default appReducer;
