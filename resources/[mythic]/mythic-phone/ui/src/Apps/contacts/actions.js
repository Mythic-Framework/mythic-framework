import Nui from '../../util/Nui';

function uuidv4() {
	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (
		c,
	) {
		var r = (Math.random() * 16) | 0,
			v = c == 'x' ? r : (r & 0x3) | 0x8;
		return v.toString(16);
	});
}

export const createContact = (contact) => (dispatch) => {
	Nui.send('CreateContact', contact).then(async (res) => {
		if (res != null) {
			dispatch({
				type: 'ADD_DATA',
				payload: {
					type: 'contacts',
					data: {
						...contact,
						_id: await res.json(),
					},
				},
			});
		} else {
			// Things?
		}
	});
};

export const updateContact = (id, contact) => (dispatch) => {
	Nui.send('UpdateContact', {
		...contact,
		id: id,
	}).then((res) => {
		if (res) {
			dispatch({
				type: 'UPDATE_DATA',
				payload: { type: 'contacts', id: id, data: contact },
			});
		} else {
			// Things?
		}
	});
};

export const deleteContact = (id) => (dispatch) => {
	Nui.send('DeleteContact', id).then((res) => {
		if (res) {
			dispatch({
				type: 'REMOVE_DATA',
				payload: { type: 'contacts', id: id },
			});
		} else {
			// Things?
		}
	});
};
