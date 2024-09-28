import { useDispatch } from 'react-redux';

export default () => {
	const dispatch = useDispatch();
	return (app) => {
		dispatch({
			type: 'OPEN_APP',
			payload: {
				state: {
					app,
				}
			},
		});
		// dispatch({
		// 	type: 'NOTIF_DISMISS_APP',
		// 	payload: { app: app },
		// });
	};
};
