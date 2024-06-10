import { useDispatch } from 'react-redux';

export default () => {
	const dispatch = useDispatch();
	return (app) => {
		dispatch({
			type: 'APP_OPEN',
			payload: app,
		});
		// dispatch({
		// 	type: 'NOTIF_DISMISS_APP',
		// 	payload: { app: app },
		// });
	};
};
