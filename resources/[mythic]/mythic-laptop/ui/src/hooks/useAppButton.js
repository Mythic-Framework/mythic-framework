import { useDispatch } from 'react-redux';
import Nui from '../util/Nui';

export default () => {
	const dispatch = useDispatch();
	return async (action, type, app) => {
		await Nui.send(type, {
			action,
			app,
		});

		if (action == 'add') {
			dispatch({
				type: 'ADD_DATA',
				payload: { type: type.toLowerCase(), data: app },
			});
		} else {
			dispatch({
				type: 'REMOVE_DATA',
				payload: { type: type.toLowerCase(), id: app },
			});
		}
	};
};
