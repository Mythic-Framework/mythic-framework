import React, { useState } from 'react';
import { compose } from 'redux';
import { connect, useDispatch, useSelector } from 'react-redux';
import { useHistory, withRouter } from 'react-router-dom';
import { Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { Confirm } from '../../components';
import { showIncoming } from '../../Apps/phone/action';
import Nui from '../../util/Nui';
import { useAlert, useMyStates } from '../../hooks';
import { DurationToTime } from '../../util/Parser';

export default compose(
	withRouter,
	connect(null, { showIncoming }),
)((props) => {
	const hasState = useMyStates();
	const limited = useSelector((state) => state.phone.limited);
	const callData = useSelector((state) => state.call.call);
	const time = useSelector(state => state.phone.time);

	const useStyles = makeStyles((theme) => ({
		header: {
			background:
				props.location.pathname != '/' &&
				props.location.pathname != '/apps'
					? theme.palette.secondary.main
					: 'transparent',
			height: '8%',
			margin: 'auto',
			borderTopLeftRadius: 30,
			borderTopRightRadius: 30,
			fontSize: '16px',
			lineHeight: '75px',
			padding: '0 105px 0 20px',
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
			'&.wifi': {
				color: limited
					? theme.palette.warning.main
					: hasState('PHONE_VPN')
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
	const history = useHistory();
	const dispatch = useDispatch();
	const showAlert = useAlert();
	const usb = useSelector((state) => state.usb.usb);
	const sharing = useSelector((state) => state.share.sharing);

	const onClickCall = () => {
		if (callData != null) {
			history.push(`/apps/phone/call/${callData.number}`);
		}
	};

	const installPrompt = (e) => {
		e.preventDefault();
		if (!usb) return;
		dispatch({
			type: 'USE_USB',
			payload: true,
		});
	};

	const sharePrompt = (e) => {
		e.preventDefault();
		if (!sharing) return;
		dispatch({
			type: 'USE_SHARE',
			payload: true,
		});
	};

	const [disabling, setDisabling] = useState(false);
	const disableVpn = async (e) => {
		e.preventDefault();
		if (!disabling || !hasState('PHONE_VPN')) return;
		try {
			let res = await (await Nui.send('RemoveVPN')).json();
			showAlert(res ? 'VPN Disabled' : 'Unable to Disable VPN');
		} catch (err) {
			console.log(err);
			showAlert('Unable to Disable VPN');
		}
		setDisabling(false);
	};

	return (
		<div>
			<Grid container className={classes.header}>
				<Grid item xs={6} className={classes.hLeft}>
					{(time?.hour ?? 0).toString().padStart(2, '0')}:{(time?.minute ?? 0).toString().padStart(2, '0')}
					{Boolean(callData) &&
						!props.location.pathname.startsWith(
							'/apps/phone/call',
						) &&
						(callData.state == 0 ? (
							<small
								className={classes.callActive}
								onClick={onClickCall}
							>
								Calling
							</small>
						) : callData.state == 1 ? (
							<small
								className={classes.callActive}
								onClick={onClickCall}
							>
								Call Incoming
							</small>
						) : (
							<small
								className={classes.callActive}
								onClick={onClickCall}
							>
								Call Active{' '}
								<Moment
									durationFromNow
									interval={1000}
									className={classes.timer}
									format="hh:mm:ss"
									date={callData.start}
								/>
							</small>
						))}
				</Grid>
				<Grid item xs={6} className={classes.hRight}>
					{sharing != null && (
						<FontAwesomeIcon
							className={`${classes.headerIcon} clickable`}
							onClick={sharePrompt}
							icon="share-nodes"
						/>
					)}
					{!limited && hasState('RACE_DONGLE') && (
						<FontAwesomeIcon
							className={`${classes.headerIcon} race`}
							icon="flag-checkered"
						/>
					)}
					<FontAwesomeIcon
						className={`${classes.headerIcon} wifi`}
						icon={limited ? 'wifi' : 'wifi'}
					/>
					<FontAwesomeIcon
						className={classes.headerIcon}
						icon="signal"
					/>
				</Grid>
			</Grid>
		</div>
	);
});
