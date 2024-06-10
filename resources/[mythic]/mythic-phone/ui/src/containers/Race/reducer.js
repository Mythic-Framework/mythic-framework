import moment from 'moment';
import Nui from '../../util/Nui';

export const initialState = {
	render: true,
	show: false,
	isLaps: true,
	lap: 0,
	lapTimes: Array(),
	totalLaps: 0,
	checkpoint: 0,
	totalCheckpoints: 0,
	lapStart: 0,
	laptime: 0,
	fastestLap: 0,
	dnfTime: null,
	trackId: null,
	dnf: false,
};

export default (state = initialState, action) => {
	switch (action.type) {
		case 'RACE_HUD_END':
			Nui.send('LapDetails', {
				track: state.trackId,
				laps: state.lapTimes,
			});
			return {
				...initialState,
			};
		case 'RACE_START':
			return {
				...state,
				dnf: false,
				show: true,
				totalCheckpoints: action.payload.totalCheckpoints,
				totalLaps: action.payload.totalLaps,
				lap: 1,
				checkpoint: 1,
				isLaps: action.payload.track.Type != 'p2p',
				trackId: action.payload.track._id,
				lapStart: Date.now(),
			};
		case 'RACE_END':
			return {
				...state,
				render: false,
			};
		case 'RACE_LAP':
			return {
				...state,
				lap: state.lap + 1,
				checkpoint: 1,
			};
		case 'ADD_LAP_TIME':
			return {
				...state,
				lapTimes: [...state.lapTimes, action.payload],
				lapStart: Date.now(),
			};
		case 'RACE_CP':
			return {
				...state,
				checkpoint: action.payload.cp,
			};
		case 'DNF_START':
			return {
				...state,
				dnfTime: action.payload.time,
			};
		case 'RACE_DNF':
			return {
				...state,
				dnf: true,
			};
		default:
			return state;
	}
};
