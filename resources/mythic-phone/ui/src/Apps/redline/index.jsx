import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Tabs, Tab } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useHistory } from 'react-router';

import { usePermissions } from '../../hooks';
import Welcome from './components/Welcome';
import Tracks from './Tracks';
import Pending from './Pending';
import Recent from './Recent';
import Create from './Create';
import Unauthorized from './components/Unauthorized';

export const TrackTypes = {
	laps: 'Laps',
	p2p: 'Point to Point',
};

export default (props) => {
	const dispatch = useDispatch();
	const hasPerm = usePermissions();
	const history = useHistory();
	const activeTab = useSelector((state) => state.race.tab);
	const onDuty = useSelector((state) => state.data.data.onDuty);
	const alias = useSelector((state) => state.data.data.player.Alias?.redline);

	useEffect(() => {
		if (Boolean(props?.match?.params?.tab)) {
			dispatch({
				type: 'SET_RACE_TAB',
				payload: { tab: +props?.match?.params?.tab },
			});
			history.replace(`/apps/redline`);
		}
	}, [props.match.params]);

	const canCreate = hasPerm('redline', 'create');

	const useStyles = makeStyles((theme) => ({
		wrapper: {
			height: '100%',
			background: theme.palette.secondary.main,
		},
		header: {
			height: '5%',
			padding: 10,
			fontSize: 14,
			borderBottom: `1px solid ${theme.palette.border.divider}`,
			'& .name': {
				color: theme.palette.primary.light,
			},
			'& svg': {
				marginRight: 5,
			},
		},
		content: {
			height: '88.75%',
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
			minWidth: canCreate ? '25%' : '33.3%',
		},
	}));
	const classes = useStyles();

	const handleTabChange = (event, tab) => {
		dispatch({
			type: 'SET_RACE_TAB',
			payload: { tab: tab },
		});
	};

	return (
		<div className={classes.wrapper}>
			{!alias ? (
				<Welcome />
			) : onDuty == 'police' ? (
				<Unauthorized />
			) : (
				<>
					<div className={classes.header}>
						<FontAwesomeIcon icon={['fas', 'user']} />
						Welcome Back <span className="name">{alias}</span>
					</div>
					<div className={classes.content}>
						<div
							className={classes.tabPanel}
							role="tabpanel"
							hidden={activeTab !== 0}
							id="tracks"
						>
							{activeTab === 0 && <Tracks />}
						</div>
						<div
							className={classes.tabPanel}
							role="tabpanel"
							hidden={activeTab !== 1}
							id="pending"
						>
							{activeTab === 1 && <Pending />}
						</div>
						<div
							className={classes.tabPanel}
							role="tabpanel"
							hidden={activeTab !== 2}
							id="recent"
						>
							{activeTab === 2 && <Recent />}
						</div>
						{canCreate && (
							<div
								className={classes.tabPanel}
								role="tabpanel"
								hidden={activeTab !== 3}
								id="create"
							>
								{activeTab === 3 && <Create />}
							</div>
						)}
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
							<Tab className={classes.phoneTab} label="Tracks" />
							<Tab className={classes.phoneTab} label="Pending" />
							<Tab className={classes.phoneTab} label="Recent" />
							<Tab className={classes.phoneTab} label="Create" />
						</Tabs>
					</div>
				</>
			)}
		</div>
	);
};
