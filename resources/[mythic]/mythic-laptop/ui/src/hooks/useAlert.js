import { useDispatch } from 'react-redux';

export default () => {
	const dispatch = useDispatch();
	return (message) => {
		if (message != null) {
			dispatch({
				type: 'ALERT_SHOW',
				payload: { alert: message },
			});
		}
	};
};
