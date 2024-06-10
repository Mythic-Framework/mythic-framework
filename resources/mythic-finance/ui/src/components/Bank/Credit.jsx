import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';
import { Grid } from '@material-ui/core';

import { Titlebar } from '../';
import Nui from '../../util/Nui';
import { toast } from 'react-toastify';

const useStyles = makeStyles((theme) => ({
	container: {
		height: '100%',
	},
	wrapper: {
		height: 'calc(100% - 115px)',
	},
	content: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	maxHeight: {
		height: '100%',
	},
	accountPanel: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	accountList: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
		backgroundColor: theme.palette.secondary.main,
		width: '100%',
		borderRight: `1px solid ${theme.palette.border.divider}`,
	},
}));

const testAccounts = [
	{
		_id: '612393033300ecacdd442ffa',
		Name: '994094',
		Account: 994094,
		Balance: 5000,
		Type: 'personal',
		Owner: 25,
	},
];

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const accounts = useSelector((state) => state.data.data.accounts);

	const onClick = (acc) => {
		setSelected(acc);
	};

	return (
		<Grid container className={classes.accountPanel}>
			<Grid
				item
				xs={6}
				sm={4}
				md={3}
				lg={2}
				className={classes.accountList}
			>
				{accounts.map((acc) => {
					return <div>{acc.Name}</div>;
				})}
			</Grid>
			<Grid
				item
				xs={6}
				sm={8}
				md={9}
				lg={10}
				className={classes.accountDetails}
			></Grid>
		</Grid>
	);
};
