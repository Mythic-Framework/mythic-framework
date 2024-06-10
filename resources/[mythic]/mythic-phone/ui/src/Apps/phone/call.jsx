import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { Avatar, Grid, Button, IconButton } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { red } from '@material-ui/core/colors';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import { endCall } from './action';
import { DurationToTime } from '../../util/Parser';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '90.5%',
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
	tabPanel: {
		height: '100%',
	},
	phoneTab: {
		minWidth: '33.3%',
	},
	avatar: {
		height: 100,
		width: 100,
		fontSize: 35,
		color: theme.palette.text.dark,
		display: 'block',
		textAlign: 'center',
		lineHeight: '100px',
		margin: 'auto',
		transition: 'border 0.15s ease-in',
	},
	avatarFav: {
		height: 100,
		width: 100,
		fontSize: 35,
		color: theme.palette.text.dark,
		display: 'block',
		textAlign: 'center',
		lineHeight: '100px',
		margin: 'auto',
		border: '2px solid gold',
		transition: 'border 0.15s ease-in',
	},
	callData: {
		textAlign: 'center',
		marginTop: '10%',
		fontSize: 35,
		'& small': {
			display: 'block',
			fontSize: 20,
			marginTop: '2%',
		},
	},
	phoneBottom: {
		marginTop: '25%',
		textAlign: 'center',
	},
	keypadBtn: {
		textAlign: 'center',
		height: 75,
		fontSize: '25px',
		width: '100%',
	},
	keypadAction: {
		padding: 20,
		color: theme.palette.getContrastText(red[500]),
		backgroundColor: red[500],
		'&:hover': {
			backgroundColor: red[700],
		},
	},
}));

export default connect(null, { endCall })((props) => {
	const classes = useStyles();
	const history = useHistory();
	const { number } = props.match.params;

	const limited = useSelector((state) => state.phone.limited);
	const callLimited = useSelector((state) => state.call.callLimited);
	const contacts = useSelector((state) => state.data.data.contacts);
	const callData = useSelector((state) => state.call.call);

	const isContact = contacts.filter((c) => c.number === number)[0];

	const [isEnding, setIsEnding] = useState(false);

	useEffect(() => {
		setIsEnding(null);
	}, []);

	useEffect(() => {
		let fml = null;
		if (callData == null) {
			setIsEnding(true);
			fml = setTimeout(() => {
				history.goBack();
			}, 2500);
		}

		return () => {
			clearTimeout(fml);
		};
	}, [callData]);

	const holdCall = (e) => {};

	const putOnSpeaker = (e) => {};

	const endCall = (e) => {
		if (callData == null || isEnding) return;
		props.endCall();
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.phoneTop}>
				{isContact != null && callLimited ? (
					isContact.avatar != null && isContact.avatar !== '' ? (
						<Avatar
							className={
								isContact.favorite
									? classes.avatarFav
									: classes.avatar
							}
							src={isContact.avatar}
							alt={isContact.name.charAt(0)}
						/>
					) : (
						<Avatar
							className={
								isContact.favorite
									? classes.avatarFav
									: classes.avatar
							}
							style={{
								background: isContact.color,
							}}
						>
							{isContact.name.charAt(0)}
						</Avatar>
					)
				) : (
					<Avatar
						className={classes.avatar}
						style={{
							background: '#333',
						}}
					>
						#
					</Avatar>
				)}
				<div className={classes.callData}>
					{callLimited
						? 'Unknown Number'
						: isContact != null && !limited
						? isContact.name
						: number}
					{!isEnding ? (
						<small>
							{callData != null ? (
								callData.state > 0 ? (
									<Moment
										durationFromNow
										interval={1000}
										format="hh:mm:ss"
										date={callData.start}
									/>
								) : (
									<span>Calling</span>
								)
							) : (
								<span>Pending</span>
							)}
						</small>
					) : (
						<small>Call Ended</small>
					)}
				</div>
			</div>
			<div className={classes.phoneBottom}>
				<Grid container>
					<Grid item xs={6}>
						{/* <Button
							color="primary"
							className={classes.keypadBtn}
							onClick={holdCall}
						>
							<FontAwesomeIcon
								icon={['fas', 'pause']}
								style={{ fontSize: 40 }}
							/>
						</Button> */}
					</Grid>
					<Grid item xs={6}>
						{/* <Button
							color="primary"
							className={classes.keypadBtn}
							onClick={putOnSpeaker}
						>
							<FontAwesomeIcon
								icon={['fas', 'volume-high']}
								style={{ fontSize: 40 }}
							/>
						</Button> */}
					</Grid>
					<Grid
						item
						xs={12}
						className={classes.keypadBtn}
						style={{ marginTop: '60%' }}
					>
						<IconButton
							className={classes.keypadAction}
							onClick={endCall}
							disabled={callData == null}
						>
							<FontAwesomeIcon
								icon={['fas', 'phone']}
								style={{ fontSize: 40 }}
							/>
						</IconButton>
					</Grid>
				</Grid>
			</div>
		</div>
	);
});
