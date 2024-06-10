import Nui from '../../util/Nui';

export const ReadEmail = (email) => (dispatch) => {
	Nui.send('ReadEmail', email._id)
		.then((res) => {
			dispatch({
				type: 'UPDATE_DATA',
				payload: {
					type: 'emails',
					id: email._id,
					data: {
						...email,
						unread: false,
					},
				},
			});
		})
		.catch((err) => {
			return;
		});
};

export const DeleteEmail = (id) => (dispatch) => {
	Nui.send('DeleteEmail', id)
		.then(() => {
			dispatch({
				type: 'REMOVE_DATA',
				payload: { type: 'emails', id: id },
			});
			return true;
		})
		.catch((err) => {
			return false;
		});
};

export const GPSRoute = (id, location) => (dispatch) => {
	Nui.send('GPSRoute', {
		id,
		location,
	})
		.then((res) => {
			dispatch({ type: 'ALERT_SHOW', payload: { alert: 'GPS Marked' } });
		})
		.catch((err) => {
			dispatch({
				type: 'ALERT_SHOW',
				payload: { alert: 'Unable To Mark Location On GPS' },
			});
		});
};

export const Hyperlink = (id, hyperlink) => (dispatch) => {
	Nui.send('Hyperlink', {
		id,
		hyperlink,
	})
		.catch((err) => {
			dispatch({
				type: 'ALERT_SHOW',
				payload: { alert: 'Unable To Open Hyperlink' },
			});
		});
};
