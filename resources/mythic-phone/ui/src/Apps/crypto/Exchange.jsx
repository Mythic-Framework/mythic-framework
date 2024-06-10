import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import {
	AppBar,
	Grid,
	Tooltip,
	IconButton,
	List,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Loader } from '../../components';
import XchangeCoin from './components/XchangeCoin';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: '#61112b',
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
		height: 78,
	},
	headerAction: {
		textAlign: 'right',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	body: {
		padding: 10,
	},
	list: {
		position: 'inherit',
	},
	editorField: {
		marginBottom: 15,
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default ({ coins, loading }) => {
	const classes = useStyles();
	const player = useSelector((state) => state.data.data.player);

	const buyable = coins.filter((c) => c.Buyable);

	return (
		<div className={classes.body}>
			{buyable.length > 0 ? (
				<List className={classes.list}>
					{buyable.map((coin) => {
						return (
							<XchangeCoin
								key={`coin-${coin.Short}`}
								coin={coin}
							/>
						);
					})}
				</List>
			) : (
				<div className={classes.emptyMsg}>
					No Coins Listed On Xchange
				</div>
			)}
		</div>
	);
};
