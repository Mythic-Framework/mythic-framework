import React, { useState } from 'react';
import { compose } from 'redux';
import { connect, useDispatch, useSelector } from 'react-redux';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Confirm } from '../../components';
import Nui from '../../util/Nui';
import { useAlert, useMyStates } from '../../hooks';
import { DurationToTime } from '../../util/Parser';

export default compose(
	connect(null, {}),
)((props) => {
	const hasState = useMyStates();
	const time = useSelector((state) => state.laptop.time);

	const useStyles = makeStyles((theme) => ({
		header: {
			background:
				props.location.pathname != '/' &&
				props.location.pathname != '/apps'
					? theme.palette.secondary.main
					: 'transparent',
			height: '8%',
			margin: 'auto',
			fontSize: '16px',
			lineHeight: '75px',
			padding: '0 20px',
			userSelect: 'none',
		},
		hLeft: {
			color: theme.palette.text.light,
		},
		hRight: {
			textAlign: 'right',
		},
		headerIcon: {
			marginLeft: 10,
			'&.clickable': {
				transition: 'color ease-in 0.15s',
				'&:hover': {
					color: theme.palette.primary.main,
				},
			},
			'&:first-of-type': {
				marginLeft: 0,
			},
			'&.signal': {
				color: hasState('PHONE_VPN')
					? theme.palette.error.main
					: theme.palette.text.main,
			},
			'&.race': {
				color: theme.palette.info.main,
			},
		},
		newNotifIcon: {
			marginRight: 10,
		},
		newTime: {
			display: 'block',
			color: theme.palette.text.main,
			fontSize: 12,
		},
		newText: {
			maxWidth: '80%',
			overflow: 'hidden',
			textOverflow: 'ellipsis',
		},
		newNotif: {
			zIndex: 5,
			position: 'absolute',
			width: '88%',
			height: '7%',
			padding: 25,
			background: theme.palette.secondary.dark,
			whiteSpace: 'nowrap',
			overflow: 'hidden',
			textOverflow: 'ellipsis',
			borderTopLeftRadius: 30,
			borderTopRightRadius: 30,
			'&:hover': {
				background: theme.palette.secondary.light,
				transition: 'background ease-in 0.15s',
				cursor: 'pointer',
			},
		},
		callActive: {
			marginLeft: 10,
			whiteSpace: 'nowrap',
			overflow: 'hidden',
			textOverflow: 'ellipsis',
		},
		timer: {
			fontSize: 12,
			color: theme.palette.text.alt,
		},
	}));

	const classes = useStyles();
	const dispatch = useDispatch();
	const showAlert = useAlert();

	return (
		<div>
			<Grid container className={classes.header}>
				<Grid item xs={6} className={classes.hLeft}>
					{(time?.hour ?? 0).toString().padStart(2, '0')}:
					{(time?.minute ?? 0).toString().padStart(2, '0')}
				</Grid>
				<Grid item xs={6} className={classes.hRight}>
					{hasState('RACE_DONGLE') && (
						<FontAwesomeIcon
							className={`${classes.headerIcon} race`}
							icon="flag-checkered"
						/>
					)}
					<FontAwesomeIcon
						className={`${classes.headerIcon} signal`}
						icon={'signal'}
					/>
					<FontAwesomeIcon
						className={classes.headerIcon}
						icon="wifi"
					/>
				</Grid>
			</Grid>
		</div>
	);
});
