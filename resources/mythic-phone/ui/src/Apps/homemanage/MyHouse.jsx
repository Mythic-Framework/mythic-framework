import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Tabs, Tab } from '@material-ui/core';
import { makeStyles, withStyles } from '@material-ui/styles';

import Furniture from './pages/Furniture';
import Keys from './pages/Keys';
import Upgrades from './pages/Upgrades';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '83.75%',
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
		height: '100%',
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
	indicator: {
		backgroundColor: '#30518c',
	},
}))((props) => <Tabs {...props} />);

const CryptoTab = withStyles((theme) => ({
	root: {
		width: '33.3%',
		'&:hover': {
			color: '#fff',
			transition: 'color ease-in 0.15s',
		},
		'&$selected': {
			color: '#fff',
			transition: 'color ease-in 0.15s',
		},
		'&:focus': {
			color: '#fff',
			transition: 'color ease-in 0.15s',
		},
	},
	selected: {},
	disabled: {
		textDecoration: 'line-through',
	}
}))((props) => <Tab {...props} />);

export default ({ property, onRefresh, setLoading }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const activeTab = useSelector((state) => state.home.tab);
	const charId = useSelector((state) => state.data.data.player.ID);

	const myKey = property.keys[charId];

	const handleTabChange = (_, tab) => {
		dispatch({
			type: 'SET_HOME_TAB',
			payload: { tab: tab },
		});
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.content}>
				<div className={classes.wrapper}>
					<div
						className={classes.tabPanel}
						role="tabpanel"
						hidden={activeTab !== 0}
						id="exchange"
					>
						{activeTab === 0 && <Keys property={property} onRefresh={onRefresh} myKey={myKey} />}
					</div>
					<div
						className={classes.tabPanel}
						role="tabpanel"
						hidden={activeTab !== 1}
						id="upgrades"
					>
						{activeTab === 1 && <Upgrades property={property} onRefresh={onRefresh} setLoading={setLoading} myKey={myKey} />}
					</div>
					<div
						className={classes.tabPanel}
						role="tabpanel"
						hidden={activeTab !== 2}
						id="furniture"
					>
						{activeTab === 2 && <Furniture property={property} onRefresh={onRefresh} myKey={myKey} />}
					</div>
				</div>
			</div>
			<div className={classes.tabs}>
				<CryptoTabs
					value={activeTab}
					onChange={handleTabChange}
					scrollButtons={false}
					centered
				>
					<CryptoTab label="DigiKeys" />
					<CryptoTab label="Upgrades" />
					<CryptoTab label="Furniture" />
				</CryptoTabs>
			</div>
		</div>
	);
};
