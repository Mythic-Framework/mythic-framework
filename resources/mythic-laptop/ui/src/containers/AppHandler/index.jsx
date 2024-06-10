import React from 'react';
import { makeStyles } from '@mui/styles';
import loadable from '@loadable/component';
import { Route, Switch, Redirect, useHistory } from 'react-router';
import { withRouter } from 'react-router-dom';

import Window from '../../components/Window';
import { useMyApps } from '../../hooks';
import { useDispatch, useSelector } from 'react-redux';

const useStyles = makeStyles((theme) => ({
	appScreen: {
		height: '100%',
		width: '100%',
		position: 'absolute',
		top: 0,
		left: 0,
	},
	clickHandler: {
		height: '100%',
		width: '100%',
		position: 'absolute',
		top: 0,
		left: 0,
		zIndex: 1,
	},
}));

export default withRouter((props) => {
	const classes = useStyles();
	const apps = useMyApps();
	const dispatch = useDispatch();
	const focused = useSelector((state) => state.apps.focused);
	const openApps = useSelector((state) => state.apps.appStates);

	const onClick = () => {
		if (Boolean(focused)) {
			dispatch({
				type: 'UPDATE_FOCUS',
				payload: {
					app: null,
				},
			});
		}
	};

	return (
		<div className={classes.appScreen}>
			<div className={classes.clickHandler} onClick={onClick}></div>
			{openApps.map((appState, i) => {
				let appData = apps[appState.app];
				if (Boolean(appData)) {
					const Component = loadable(() =>
						import(`../../Apps/${appState.app}`),
					);
					return (
						<Window
							key={`app-${appState.app}`}
							app={appState.app}
							title={appData.label}
							color={appData.color}
							height={appData.size?.height}
							width={appData.size?.width}
							appState={appState}
							appData={appData}
						>
							<Component
								appId={i}
								appState={appState}
								appData={appData}
							/>
						</Window>
					);
				} else return null;
			})}
		</div>
	);
});
