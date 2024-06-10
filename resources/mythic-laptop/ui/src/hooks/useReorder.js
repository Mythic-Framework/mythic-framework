import { useDispatch } from 'react-redux';
import Nui from '../util/Nui';

export default () => {
	const dispatch = useDispatch();
	return async (qry) => {
		await Nui.send('Reorder', {
			type: qry.type,
			apps: qry.data,
		});

		dispatch({
			type: 'SET_DATA',
			payload: qry,
		});
	};
};
