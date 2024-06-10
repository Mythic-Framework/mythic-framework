import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Tabs, Tab } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import TweetList from './TweetList';
import MyProfile from './MyProfile';

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
		height: '100%',
	},
	phoneTab: {
		minWidth: '33.3%',
	},
}));

export default (props) => {
	const dispatch = useDispatch();
	const classes = useStyles();
	const activeTab = useSelector((state) => state.twitter.tab);

	const handleTabChange = (event, tab) => {
		dispatch({
			type: 'SET_TWITTER_TAB',
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
					id="recent"
				>
					{activeTab === 0 && <TweetList />}
				</div>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 1}
					id="keypad"
				>
					{activeTab === 1 && <MyProfile />}
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
					<Tab
						className={classes.phoneTab}
						icon={<FontAwesomeIcon icon={['fas', 'bars']} />}
					/>
					<Tab
						className={classes.phoneTab}
						icon={<FontAwesomeIcon icon={['fas', 'user']} />}
					/>
				</Tabs>
			</div>
		</div>
	);
};
