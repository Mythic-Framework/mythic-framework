import Nui from '../../util/Nui';

export const GetMessages = async (channel, joined) => {
	try {
		return await Nui.send('GetMessages', {
			channel,
			joined,
		});
	} catch (err) {
		console.log(err);
		return Array();
	}
};

export const SendMessage = async (channel, message) => {
	try {
	} catch (err) {
		console.log(err);
		return false;
	}
};

const slugify = (input) => {
	return input
		.toLowerCase()
		.replace(/ /g, '-')
		.replace(/[^\w-]+/g, '');
};

export const JoinChannel = async (channel) => {
	try {
		let slug = slugify(channel);
		let res = await (await Nui.send('JoinChannel', slug)).json();
		if (res) {
			dispatch({
				type: 'ADD_DATA',
				payload: {
					type: 'ircChannels',
					data: {
						_id: slug,
						name: channel,
						joined: Date.now(),
						pinned: false,
					},
				},
			});
		} else {
			return false;
		}
	} catch (err) {
		console.log(err);
		return false;
	}
};

export const LeaveChannel = (channel) => async (dispatch) => {
	try {
		let res = await (await Nui.send('LeaveChannel', channel)).json();
		if (res) {
			dispatch({
				type: 'REMOVE_DATA',
				payload: {
					type: 'ircChannels',
					id: channel,
				},
			});
		} else {
			return false;
		}
	} catch (err) {
		console.log(err);
		return false;
	}
};
