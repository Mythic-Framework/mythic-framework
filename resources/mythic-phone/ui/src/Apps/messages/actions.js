import Nui from '../../util/Nui';

export const SendMessage = (message) => async (dispatch) => {
	try {
		let res = await (await Nui.send('SendMessage', message)).json();
		if (res != null) {
			dispatch({
				type: 'ADD_DATA',
				payload: {
					type: 'messages',
					first: true,
					data: {
						...message,
					},
				},
			});
			return true;
		} else {
			return false;
		}
	} catch (err) {
		console.log(err);
		return false;
	}
};

export const ReadConvo = (number, messages) => (dispatch) => {
	Nui.send('ReadConvo', number)
		.then(() => {
			dispatch({
				type: 'SET_DATA',
				payload: {
					type: 'messages',
					data: messages.map((message) => {
						return {
							...message,
							unread:
								message.number === number
									? false
									: message.unread,
						};
					}),
				},
			});
		})
		.catch((err) => {
			return;
		});
};

export const DeleteConvo = (number, myNumber, messages) => (dispatch) => {
	Nui.send('DeleteConvo', number)
		.then(() => {
			dispatch({
				type: 'SET_DATA',
				payload: {
					type: 'messages',
					data: messages.filter((m) => m.number != number),
				},
			});
			return true;
		})
		.catch((err) => {
			return false;
		});
};
