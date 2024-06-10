import { useDispatch } from 'react-redux';

export default () => {
	const dispatch = useDispatch();
	return (id = null) => {
		if (id != null) {
			if (id === 'new') {
				dispatch({
					type: 'REMOVE_NEW_NOTIF',
				});
			} else {
				dispatch({
					type: 'NOTIF_HIDE',
					payload: { id },
				});
			}
		} else {
			dispatch({
				type: 'NOTIF_DISMISS_ALL',
			});
		}
	};
};
