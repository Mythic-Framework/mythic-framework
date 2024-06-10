import Nui from '../../util/Nui';

export const initialState = {
    showing: false,
    label: null,
    duration: 0,
    cancelled: false,
    failed: false,
    finished: false,
    startTime: null,
};

export default (state = initialState, action) => {
    switch (action.type) {
        case 'START_PROGRESS':
            return {
                ...state,
                ...action.payload,
                cancelled: false,
                failed: false,
                finished: false,
                showing: true,
                startTime: Date.now(),
            };
        case 'CANCEL_PROGRESS':
            return {
                ...state,
                failed: false,
                finished: false,
                cancelled: true,
            };
        case 'FAILED_PROGRESS':
            return {
                ...state,
                cancelled: false,
                finished: false,
                failed: true,
            };
        case 'FINISH_PROGRESS':
            Nui.send('Progress:Finish');
            return {
                ...state,
                failed: false,
                finished: true,
            };
        case 'HIDE_PROGRESS':
            return {
                ...initialState,
                cancelled: false,
                failed: false,
                finished: false,
                showing: false,
            };
        default:
            return state;
    }
};
