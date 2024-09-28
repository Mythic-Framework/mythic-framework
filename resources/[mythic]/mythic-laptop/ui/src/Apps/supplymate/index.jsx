import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import { makeStyles } from '@mui/styles';

import User from './components/User';
import Selector from './Screens/Selector';
import Buyer from './Screens/Buyer';
import Contractor from './Screens/Contractor';
import Admin from './Screens/Admin';
import { usePermissions } from '../../hooks';
import Banned from './Screens/Banned';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		position: 'relative',
	},
	header: {
		background: '#E95200',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	content: {
		height: '100%',
		overflow: 'hidden',
	},
	headerAction: {},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	tabPanel: {
		top: 0,
		height: '93.25%',
	},
	list: {
		height: '100%',
		overflow: 'auto',
	},
}));

export default ({ appId, appState, appData }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const hasPerm = usePermissions();

	const onClick = (panel) => {
		dispatch({
			type: 'UPDATE_APP_STATE',
			payload: {
				app: appState.app,
				state: {
					selected: panel,
				},
			},
		});
	};

	const getPanel = () => {
		if (!hasPerm('supplymate', 'banned')) {
			switch (appState?.selected) {
				case 1:
					return <Buyer />;
				case 2:
					return <Contractor />;
				case 3:
					return <Admin />;
				default:
					return <Selector onClick={onClick} />;
			}
		} else {
			return <Banned />;
		}
	};

	return (
		<div className={classes.wrapper}>
			<User appState={appState} onNav={onClick} />
			{getPanel()}
		</div>
	);
};
