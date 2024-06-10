import React from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { Tabs, Tab } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import Notifications from './Notifications';
import Person from './Person';
import Vehicle from './Vehicle';
import Property from './Property';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '93.75%',
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
		minWidth: '33.333%',
	},
}));

export default ((props) => {
	const classes = useStyles();
	const history = useHistory();
	const dispatch = useDispatch();
	const activeTab = useSelector((state) => state.leo.tab);

	const handleTabChange = (event, tab) => {
		dispatch({
			type: 'SET_LEO_TAB',
			payload: { tab: tab },
		});
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.content}>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 0}
					id="notifications"
				>
					{activeTab === 0 && <Notifications />}
				</div>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 1}
					id="person"
				>
					{activeTab === 1 && <Person />}
				</div>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 2}
					id="vehicle"
				>
					{activeTab === 2 && <Vehicle />}
				</div>
				{/* <div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 3}
					id="property"
				>
					{activeTab === 3 && <Property />}
				</div> */}
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
					<Tab className={classes.phoneTab} label="Activity" />
					<Tab className={classes.phoneTab} label="People" />
					<Tab className={classes.phoneTab} label="Vehicle" />
					{/* <Tab className={classes.phoneTab} label="Property" /> */}
				</Tabs>
			</div>
		</div>
	);
});
