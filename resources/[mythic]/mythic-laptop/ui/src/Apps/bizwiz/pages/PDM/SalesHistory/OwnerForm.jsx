import React from 'react';
import { CurrencyFormat } from '../../../../../util/Parser';

import { Modal } from '../../../../../components';
import Moment from 'react-moment';

export default ({ open, vehicle, onClose, onSubmit }) => {

	const internalSubmit = (e) => {
		e.preventDefault();
		onSubmit();
	};

	return (
		<Modal
			open={open}
			maxWidth="md"
			title={`Current Ownership`}
			submitLang="Okay"
			onSubmit={internalSubmit}
			onClose={onClose}
		>
			<p>Vehicle: {`${vehicle?.Make} ${vehicle?.Model}`}</p>
			<p>Vehicle VIN: {`${vehicle?.VIN}`}</p>
			<p>Current Owner: {`${vehicle?.OwnerName}`}</p>
		</Modal>
	);
};
