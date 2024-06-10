import React, { useEffect, useMemo, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { throttle } from 'lodash';
import { Tabs, Tab, AppBar, Grid, IconButton } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Loader } from '../../components';
import Nui from '../../util/Nui';
import Accounts from './Accounts';
import Bills from './Bills';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	titleBar: {
		padding: '10px 8px',
		textAlign: 'center',
	},
	accountTitle: {
		fontSize: 20,
		fontWeight: 'bold',
		margin: 'auto',
		width: '100%',
		whiteSpace: 'nowrap',
	},
	content: {
		height: '86%',
		padding: 15,
		overflowY: 'auto',
		overflowX: 'hidden',
		padding: 10,
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
	tabPanel: {},
	phoneTab: {
		minWidth: '25%',
	},
}));

export default ((props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const activeTab = useSelector((state) => state.bank.tab);
	const [loading, setLoading] = useState(false);

	const fetch = useMemo(() => throttle(async () => {
		if (loading) return;
		setLoading('Loading Accounts');
		try {
			let res = await (await Nui.send('Banking:GetData')).json();
			if (res) {
				dispatch({
					type: 'SET_DATA',
					payload: {
						type: 'bankAccounts',
						data: res,
					},
				});
			} else {
				throw res;
			}
		} catch (err) {
			// dispatch({
			// 	type: 'SET_DATA',
			// 	payload: {
			// 		type: 'bankAccounts',
			// 		data: {
			// 			accounts: Array(),
			// 			transactions: Object(),
			// 			pendingBills: Array()
			// 		},
			// 	},
			// });
		}
		setLoading(false);
	}, 2000), []);

	useEffect(() => {
		fetch();
	}, []);

	const handleTabChange = (event, tab) => {
		dispatch({
			type: 'SET_BANK_TAB',
			payload: { tab: tab },
		});
	};

	const getTabName = () => {
		switch(activeTab) {
			case 0:
				return 'Bank Accounts';
			case 1:
				return 'Pending Bills';
			default:
				return 'Banking';
		}
	};

	return (
		<div className={classes.wrapper}>
			<AppBar position="static">
				<Grid container className={classes.titleBar}>
					<Grid item xs={2} style={{ textAlign: 'left' }}>
						<IconButton disabled>
							<FontAwesomeIcon
								icon={['fas', 'bank']}
							/>
						</IconButton>
					</Grid>

					<Grid
						item
						xs={8}
						className={classes.accountTitle}
					>
						{getTabName()}
					</Grid>
					<Grid item xs={2} style={{ textAlign: 'right' }}>
						<IconButton onClick={() => fetch()} disabled={Boolean(loading)}>
							<FontAwesomeIcon
								icon={['fas', 'arrows-rotate']}
							/>
						</IconButton>
					</Grid>
				</Grid>
			</AppBar>
			{loading ? <Loader static text={loading} /> :
				<>
					<div className={classes.content}>
						<div
							className={classes.tabPanel}
							role="tabpanel"
							hidden={activeTab !== 0}
							id="accounts"
						>
							{activeTab === 0 && <Accounts />}
						</div>
						<div
							className={classes.tabPanel}
							role="tabpanel"
							hidden={activeTab !== 1}
							id="bills"
						>
							{activeTab === 1 && <Bills setLoading={(state) => setLoading(state)} refreshAccounts={() => fetch()} />}
						</div>
					</div> 
					<div className={classes.tabs}>
						<Tabs
							value={activeTab}
							onChange={handleTabChange}
							indicatorColor="primary"
							textColor="primary"
							variant="fullWidth"
							scrollButtons={false}
						>
							<Tab className={classes.phoneTab} label="Accounts" />
							<Tab className={classes.phoneTab} label="Bills" />
						</Tabs>
					</div>
				</>
			}
		</div>
	);
});
