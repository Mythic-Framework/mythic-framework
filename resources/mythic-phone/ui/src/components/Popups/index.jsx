import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@material-ui/styles';

import Popup from './Popup';
import { useMyApps } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		position: 'absolute',
		width: '75%',
		top: '10%',
		left: 0,
		right: 0,
		margin: 'auto',
		zIndex: 1000,
	},
	closedWrapper: {
		position: 'absolute',
		width: '15%',
		bottom: '2%',
		right: '2%',
		margin: 'auto',
		zIndex: 1000,
	},
}));

export default () => {
	const classes = useStyles();
	const phoneOpen = useSelector((state) => state.phone.visible);
	const newNotifs = useSelector((state) => state.notifications.notifications);
	const myApps = useMyApps();

	return (
		<div className={phoneOpen ? classes.wrapper : classes.closedWrapper}>
			{newNotifs
				.sort((a, b) => b.time - a.time)
				.filter(
					(n) =>
						n.show &&
						(typeof n.app == 'object' || Boolean(myApps[n.app])),
				)
				.slice(0, 5)
				.map((n, k) => {
					return <Popup key={n._id} notification={n} />;
				})}
		</div>
	);
};
