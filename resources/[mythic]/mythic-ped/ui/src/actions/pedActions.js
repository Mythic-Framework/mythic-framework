import Nui from '../util/Nui';

export const updatePed = (event, type, index, value) => (dispatch) => {
	switch (event) {
		case 'SetPedHeadOverlay':
			dispatch({
				type: 'UPDATE_PED_OVERLAY',
				payload: { index, value },
			});
			break;
		case 'SetPedFaceFeature':
			dispatch({
				type: 'UPDATE_PED_FACE_FEATURE',
				payload: { index, value },
			});
			break;
		case '':
			dispatch({
				type: 'UPDATE_PED_FACE',
				payload: { index, value },
			});
			break;
		default:
			dispatch({
				type: 'UPDATE_PED_MODEL',
				payload: { value },
			});
			break;
	}

	//   Nui.send(event, {
	//     data: {
	//       type,
	//       index,
	//       value,
	//     },
	//   });
};

export const SavePed = (state) => {
	return async (dispatch) => {
		let res = await (
			await Nui.send('Save', {
				state: state,
			})
		).json();
		if (res) {
			dispatch({
				type: 'APP_HIDE',
			});
		}
	};
};

export const SaveImport = (label, code) => {
    return (dispatch) => {
        Nui.send('Cancel');
        Nui.send('SaveImport', {
            Label: label,
            Code: code
        })
        dispatch({
            type: 'APP_HIDE',
        });
    };
};

export const CancelEdits = () => {
	return (dispatch) => {
		Nui.send('Cancel');
		dispatch({
			type: 'APP_HIDE',
		});
	};
};

export const SetPedHeadBlendData = (value, data) => {
	return (dispatch) => {
		const payload = { face: data.face, type: data.type, value };
		Nui.send('SetPedHeadBlendData', payload);
		dispatch({
			type: 'UPDATE_PED_FACE',
			payload,
		});
	};
};

export const SetPedFaceFeature = (value, data) => {
	return (dispatch) => {
		const payload = { index: data.index, value };
		Nui.send('SetPedFaceFeature', payload);
		dispatch({
			type: 'UPDATE_PED_FACE_FEATURE',
			payload,
		});
	};
};

export const SetPedHeadOverlay = (value, data) => {
	return (dispatch) => {
		const payload = { ...data, value };
		Nui.send('SetPedHeadOverlay', payload);
		dispatch({
			type: 'UPDATE_PED_OVERLAY',
			payload,
		});
	};
};

export const SetPedTattoo = (value, data) => {
	return (dispatch) => {
		const payload = { ...data, value };
		Nui.send('SetPedTattoo', payload);
		dispatch({
			type: 'UPDATE_PED_TATTOO',
			payload,
		});
	};
};

export const SetPedComponentVariation = (value, data) => {
	return (dispatch) => {
		const payload = { ...data, value };
		Nui.send('SetPedComponentVariation', payload);
		dispatch({
			type: 'UPDATE_PED_COMPONENT_VARIATION',
			payload,
		});
	};
};

export const SetPedHairColor = (value, data) => {
	return (dispatch) => {
		const payload = { ...data, value };
		Nui.send('SetPedHairColor', payload);
		dispatch({
			type: 'UPDATE_PED_HAIR_COLOR',
			payload,
		});
	};
};

export const SetPedHairOverlay = (value, data) => {
	return (dispatch) => {
		const payload = { value };
		Nui.send('SetPedHairOverlay', payload);
		dispatch({
			type: 'UPDATE_PED_HAIR_OVERLAY',
			payload,
		});
	};
};

export const SetPedHeadOverlayColor = (value, data) => {
	return (dispatch) => {
		const payload = { ...data, value };
		Nui.send('SetPedHeadOverlayColor', payload);
		dispatch({
			type: 'UPDATE_PED_OVERLAY_COLOR',
			payload,
		});
	};
};

export const SetPedPropIndex = (value, data) => {
	return (dispatch) => {
		const payload = { ...data, value };
		Nui.send('SetPedPropIndex', payload);
		dispatch({
			type: 'UPDATE_PED_PROP',
			payload,
		});
	};
};

export const SetPedEyeColor = (value) => {
	return (dispatch) => {
		const payload = { value };
		Nui.send('SetPedEyeColor', payload);
		dispatch({
			type: 'UPDATE_PED_EYE_COLOR',
			payload,
		});
	};
};

export const SetPed = (value) => {
	return (dispatch) => {
	};
};