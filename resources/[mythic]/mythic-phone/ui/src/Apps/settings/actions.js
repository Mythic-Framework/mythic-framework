import Nui from '../../util/Nui';

export const UpdateSetting = (type, val) => (dispatch) => {
	Nui.send('UpdateSetting', {
		type: type,
		val: val,
	})
		.then((res) => {
			dispatch({
				type: 'UPDATE_DATA',
				payload: {
					type: 'player',
					id: 'PhoneSettings',
					key: type,
					data: val,
				},
			});
		})
		.catch((err) => {
			console.log(err);
		});
};

export const TestSound = (type, val) => (dispatch) => {
	Nui.send('TestSound', {
		type: type,
		val: val,
	});
};
