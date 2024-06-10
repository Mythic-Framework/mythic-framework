import React, { useState, useEffect, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	Tabs,
	Tab,
	AppBar,
	Grid,
	Tooltip,
	IconButton,
} from '@material-ui/core';
import { makeStyles, withStyles } from '@material-ui/styles';
import { throttle } from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import { useMyStates } from '../../hooks';
import Exchange from './Exchange';
import Portfolio from './Portfolio';
import { Loader } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '93.75%',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	tabPanel: {
		height: '89%',
	},
	phoneTab: {
		minWidth: '25%',
	},
	header: {
		background: '#b0e655',
		color: theme.palette.secondary.dark,
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	headerAction: {
		color: theme.palette.secondary.dark,
	},
}));

const CryptoTabs = withStyles((theme) => ({
	root: {
		borderBottom: '1px solid #b0e655',
	},
	indicator: {
		backgroundColor: '#b0e655',
	},
}))((props) => <Tabs {...props} />);

const CryptoTab = withStyles((theme) => ({
	root: {
		width: '50%',
		'&:hover': {
			color: '#b0e655',
			transition: 'color ease-in 0.15s',
		},
		'&$selected': {
			color: '#b0e655',
			transition: 'color ease-in 0.15s',
		},
		'&:focus': {
			color: '#b0e655',
			transition: 'color ease-in 0.15s',
		},
	},
	selected: {},
}))((props) => <Tab {...props} />);

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const hasState = useMyStates();
	const player = useSelector((state) => state.data.data.player);
	const activeTab = useSelector((state) => state.crypto.tab);

	const tcoins = useSelector((state) => state.data.data.cryptoCoins);

	const handleTabChange = (_, tab) => {
		dispatch({
			type: 'SET_CRYPTO_TAB',
			payload: { tab: tab },
		});
	};

	const [loading, setLoading] = useState(false);
	const [coins, setCoins] = useState(null);

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (await Nui.send('GetCryptoCoins')).json();
					if (res) {
						setCoins(res);
					} else {
						setCoins(Array());
					}
				} catch (err) {
					console.log(err);
					setCoins(tcoins);
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	return (
		<div className={classes.wrapper}>
			<div className={classes.content}>
				<div className={classes.wrapper}>
					<AppBar position="static" className={classes.header}>
						<Grid container>
							<Grid item xs={8}>
								CryptoX
							</Grid>
							<Grid item xs={4} style={{ textAlign: 'right' }}>
								<Tooltip title="Refresh Coin Listing">
									<IconButton
										onClick={fetch}
										className={classes.headerAction}
									>
										<FontAwesomeIcon
											className={`fa ${
												loading ? 'fa-spin' : ''
											}`}
											icon={['fas', 'arrows-rotate']}
										/>
									</IconButton>
								</Tooltip>
							</Grid>
						</Grid>
					</AppBar>
					{!Boolean(coins) ? (
						<>
							<Loader static text="Loading Coins" />
						</>
					) : (
						<>
							<div
								className={classes.tabPanel}
								role="tabpanel"
								hidden={activeTab !== 0}
								id="portfolio"
							>
								{activeTab === 0 && (
									<Portfolio
										coins={coins}
										loading={loading}
										onRefresh={fetch}
									/>
								)}
							</div>
							<div
								className={classes.tabPanel}
								role="tabpanel"
								hidden={activeTab !== 1}
								id="exchange"
							>
								{activeTab === 1 && (
									<Exchange
										coins={coins}
										loading={loading}
										onRefresh={fetch}
									/>
								)}
							</div>
						</>
					)}
				</div>
			</div>
			<div className={classes.tabs}>
				<CryptoTabs
					value={activeTab}
					onChange={handleTabChange}
					scrollButtons={false}
					centered
				>
					<CryptoTab label="Portfolio" />
					<CryptoTab label="Xchange" />
				</CryptoTabs>
			</div>
		</div>
	);
};
