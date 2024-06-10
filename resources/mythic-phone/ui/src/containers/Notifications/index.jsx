import React, { useEffect, useState } from 'react';
import { compose } from 'redux';
import { connect, useSelector } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { Slide } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Moment from 'react-moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { showIncoming } from '../../Apps/phone/action';
import CallTimer from '../../Apps/phone/timer';
import { useDismisser } from '../../hooks';
import phoneImg from '../../s10.png';

export default compose(
	withRouter,
	connect(null, { showIncoming }),
)((props) => {
	const notifications = useSelector(
		(state) => state.notifications.notifications,
	);
	const newNotifs = useSelector((state) => state.notifications.new);

	const useStyles = makeStyles((theme) => ({
		wrapper: {
			position: 'absolute',
			bottom: '5%',
			right: 468,
		},
		phoneImg: {
			position: 'absolute',
			left: -35,
			bottom: -965,
			zIndex: 100,
		},
		container: {},
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
			width: 435,
			height: 75,
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
	}));

	const classes = useStyles();
	const dismisser = useDismisser();
	const phoneOpen = useSelector((state) => state.phone.visible);

	const [show, setShow] = useState(false);
	const [newTimer, setNewTimer] = useState(null);
	useEffect(() => {
		if (newNotifs.length > 0 && !phoneOpen) {
			if (newTimer == null) {
				setShow(true);
				setNewTimer(
					setTimeout(() => {
						if (phoneOpen) return;
						setShow(false);
						setNewTimer(null);
					}, 2000),
				);
			}
		} else {
			setShow(false);
		}
	}, [newNotifs, phoneOpen]);

	const onAnimEnd = () => {
		dismisser('new');
	};

	if (phoneOpen) return null;

	return (
		<Slide
			direction="up"
			in={show}
			onExited={onAnimEnd}
			mountOnEnter
			unmountOnExit
		>
			<div className={classes.wrapper}>
				<img className={classes.phoneImg} src={phoneImg} />
				<div className={classes.container}>
						<div className={classes.newNotif}>
							{newNotifs[0] != null ? (
								<div className={classes.newText}>
									<FontAwesomeIcon
										className={classes.newNotifIcon}
										style={{ color: newNotifs[0].color }}
										icon={newNotifs[0].icon}
									/>{' '}
									{newNotifs[0].text}
									<Moment className={classes.newTime} fromNow>
										{Date.now()}
									</Moment>
								</div>
							) : null}
						</div>
				</div>
			</div>
		</Slide>
	);
});
