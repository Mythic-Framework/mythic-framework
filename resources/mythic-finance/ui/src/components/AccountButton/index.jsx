import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Button, Grid } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Truncate from 'react-truncate';

import { CurrencyFormat } from '../../util/Parser';

const useStyles = makeStyles((theme) => ({
	btn: {
		width: '95%',
		fontSize: 18,
		color: theme.palette.text.main,
		borderTopLeftRadius: 0,
		borderBottomLeftRadius: 0,
		display: 'block',
		marginBottom: '5%',
		'&.selected': {
			background: `${theme.palette.primary.dark}73`,
		},
		'& small': {
			display: 'block',
			fontSize: 12,
			color: theme.palette.success.main,
			'&::before': {
				color: theme.palette.text.alt,
				marginRight: 5,
				content: '"Balance:"',
			},
		},
	},
	btnIcon: {
		fontSize: 16,
		marginRight: 5,
		color: theme.palette.text.alt,
	},
}));

export default ({ account, onSelected }) => {
	const classes = useStyles();
	const selected = useSelector((state) => state.bank.selected);

	const isSelected = selected == account._id;

	return (
		<div>
			<Button
				className={`${classes.btn}${isSelected ? ' selected' : ''}`}
				color="primary"
				onClick={() => onSelected(isSelected ? null : account._id)}
			>
				<div style={{ width: '100%' }}>
					<Truncate lines={1}>{account.Name}</Truncate>
				</div>
				{account?.Permissions?.BALANCE && (
					<small>{CurrencyFormat.format(account.Balance)}</small>
				)}
			</Button>
		</div>
	);
};
