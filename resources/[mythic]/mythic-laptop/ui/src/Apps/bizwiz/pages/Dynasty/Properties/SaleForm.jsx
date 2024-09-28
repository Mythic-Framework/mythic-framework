import React, { useEffect, useState } from 'react';
import { TextField, MenuItem, Slider, Box, Typography } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { CurrencyFormat } from '../../../../../util/Parser';

import { Modal } from '../../../../../components';
import { useSelector } from 'react-redux';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

const saleTypes = [
	{
		value: 'full',
		label: 'Cash',
	},
	{
		value: 'loan',
		label: 'Loan',
	}
]

export default ({ open, property, onSubmit, interest=15, dealerData, onClose }) => {
	const classes = useStyles();

	const initialState = {
		type: 'loan',
		SID: '',
		weeks: 8,
		downpayment: 50,
	}

	const [state, setState] = useState({
		...initialState,
	});

	const internalSubmit = (e) => {
		e.preventDefault();
		onSubmit(state);
		setState({ ...initialState });
	};

	const onChange = (e) => {
		setState({
			...state,
			[e.target.name]: e.target.value,
		});
	};

	const salePrice = property?.price;

	const earnedCommission = salePrice * 0.05;

	const downPayment = salePrice * (state.downpayment / 100);
	const remainingCost = (salePrice - downPayment) * (1 + (interest / 100));
	const perWeek = remainingCost / state.weeks;

	return (
		<Modal
			open={open}
			maxWidth="md"
			title={`Sell ${property?.label}`}
			submitLang="Confirm Sale"
			onSubmit={internalSubmit}
			onClose={onClose}
		>
			<p>Property: {property?.label}</p>
			{state.type == 'loan' ? (
				<>
					<p>Loan Interest Rate: {interest}%</p>
					<p>Downpayment: {CurrencyFormat.format(Math.ceil(downPayment))} ({state.downpayment}%)</p>
					<p>Remaining Cost (Interest Applied): {CurrencyFormat.format(Math.ceil(remainingCost))}</p>
					<p>Loan Length in Weeks: {state.weeks}</p>
					<p>Weekly Payment: {CurrencyFormat.format(Math.ceil(perWeek))}</p>
					<p>Your Earned Commission: {CurrencyFormat.format(Math.ceil(earnedCommission))}</p>
				</>
			) : <>
				<p>Cost: {CurrencyFormat.format(Math.ceil(salePrice))}</p>
			</>}
			<br></br>
			<TextField
				required
				select
				fullWidth
				name="type"
				label="Type"
				className={classes.editorField}
				value={state.type}
				onChange={onChange}
			>
				{saleTypes.map((option) => (
					<MenuItem key={option.value} value={option.value}>
						{option.label}
					</MenuItem>
				))}
			</TextField>
			{state.type == 'loan' && (
				<>
					<p>Downpayment {state.downpayment}% ({CurrencyFormat.format(Math.ceil(downPayment))})</p>
					<Slider
						size="small"
						value={state.downpayment}
						name="downpayment"
						min={15}
						max={80}
						step={5}
						valueLabelDisplay="auto"
						onChange={onChange}
					/>
					<p>Loan Length ({state.weeks} Weeks)</p>
					<Slider
						size="small"
						value={state.weeks}
						name="weeks"
						min={8}
						max={24}
						step={1}
						valueLabelDisplay="auto"
						onChange={onChange}
					/>
				</>
			)}
			<TextField
				required
				fullWidth
				name="SID"
				label="Customer State ID"
				className={classes.editorField}
				value={state.SID}
				onChange={onChange}
			/>
		</Modal>
	);
};
