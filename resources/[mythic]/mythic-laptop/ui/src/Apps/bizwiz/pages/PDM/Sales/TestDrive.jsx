import React, { useEffect, useState } from 'react';
import { makeStyles } from '@mui/styles';
import { Modal } from '../../../../../components';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

export default ({ open, vehicle, onSubmit, onClose }) => {
	const classes = useStyles();

	const initialState = {
		type: 'testdrive',
	}

	const [state, setState] = useState({
		...initialState,
	});

	const internalSubmit = (e) => {
		e.preventDefault();
		onSubmit(state);
		setState({ ...initialState });
	};

	return (
		<Modal
			open={open}
			maxWidth="md"
			title={`Test Drive ${vehicle?.data?.make} ${vehicle?.data?.model}`}
			submitLang="Confirm Test Drive"
			onSubmit={internalSubmit}
			onClose={onClose}
		>
			<p>Vehicle: {`${vehicle?.data?.make} ${vehicle?.data?.model}`}</p>
		</Modal>
	);
};
