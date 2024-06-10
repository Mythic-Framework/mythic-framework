import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { List } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Loader } from '../../components';
import MyCoin from './components/MyCoin';

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
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	list: {
		position: 'inherit',
	},
}));

export default ({ coins, loading }) => {
	const classes = useStyles();
	const player = useSelector((state) => state.data.data.player);

	const ownedCoins =
		Boolean(coins) && Boolean(player.Crypto)
			? coins.filter((c) => Boolean(player.Crypto[c.Short]))
			: Array();

	return (
		<div className={classes.body}>
			{Boolean(ownedCoins) && Object.keys(ownedCoins).length > 0 ? (
				<List className={classes.list}>
					{Object.keys(player.Crypto).map((k) => {
						return (
							<MyCoin
								key={`coin-${k}`}
								coin={coins.filter((c) => c.Short == k)[0]}
								owned={{
									Short: k,
									Quantity: player.Crypto[k],
								}}
							/>
						);
					})}
				</List>
			) : (
				<div className={classes.emptyMsg}>You Don't Own Any Crypto</div>
			)}
		</div>
	);
};
