import React from 'react';
import { CurrencyFormat } from '../../../../../util/Parser';

import { Modal } from '../../../../../components';
import Moment from 'react-moment';

export default ({ open, vehicle, onSubmit, onClose }) => {

	const internalSubmit = (e) => {
		e.preventDefault();
		onSubmit();
	};

	return (
		<Modal
			open={open}
			maxWidth="md"
			title={`Sale History`}
			submitLang="Okay"
			onSubmit={internalSubmit}
			onClose={onClose}
		>
			<p>Vehicle: {`${vehicle?.vehicle?.data?.make} ${vehicle?.vehicle?.data?.model}`}</p>
			<p>Vehicle Class: {`${vehicle?.vehicle?.data?.class}`}</p>
			<p>Sale Price: {`${CurrencyFormat.format(vehicle?.salePrice)}`}</p>
			<p>Seller: {`${vehicle?.seller?.First} ${vehicle?.seller?.Last} (${vehicle?.seller?.SID})`}</p>
			<p>Commission: {`${CurrencyFormat.format(vehicle?.commission)}`}</p>
			<p>Buyer: {`${vehicle?.buyer?.First} ${vehicle?.buyer?.Last} (${vehicle?.buyer?.SID})`}</p>
			<p>Vehicle VIN: {`${vehicle?.vehicle?.VIN}`}</p>
			<p>Sale Time: <Moment unix date={vehicle?.time} format={'LLLL'} /></p>
		</Modal>
	);
};
