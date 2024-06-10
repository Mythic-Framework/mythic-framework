import { useDispatch } from 'react-redux';

export default () => {
	const dispatch = useDispatch();
	return (text, icon, color, app) => {
		dispatch({
			type: 'NOTIF_ADD',
			payload: {
				notification: {
					text: text,
					icon: icon,
					color: color,
					time: Date.now(),
					app: app,
				},
			},
		});
	};
};
