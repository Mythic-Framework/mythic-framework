import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import {
	Grid,
	AppBar,
	Menu,
	MenuItem,
	Avatar,
	Paper,
	IconButton,
	Tooltip,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Moment from 'react-moment';
import { Sanitize } from '../../util/Parser';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { ReadEmail, DeleteEmail, GPSRoute, Hyperlink } from './action';
import { useAlert } from '../../hooks';


const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
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
	titleBar: {
		padding: 15,
		textAlign: 'center',
	},
	senderBar: {
		padding: 15,
		textAlign: 'left',
		lineHeight: '30px',
		backgroundColor: theme.palette.secondary.light,
	},
	sendTime: {
		margin: '0',
		marginTop: '10px',
		color: theme.palette.text.main,
	},
	expireBar: {
		padding: 15,
		textAlign: 'center',
		background: theme.palette.error.main,
	},
	emailTitle: {
		fontSize: 20,
		fontWeight: 'bold',
		width: '100%',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		whiteSpace: 'nowrap',
		lineHeight: '46px',
	},
	avatar: {
		color: theme.palette.text.light,
		height: 55,
		width: 55,
		position: 'relative',
		top: 0,
	},
	sender: {
		fontSize: 18,
		color: theme.palette.text.light,
	},
	recipient: {
		fontSize: 14,
		color: theme.palette.text.main,
	},
	emailBody: {
		padding: 20,
		background: theme.palette.secondary.dark,
		overflowX: 'hidden',
		overflowY: 'auto',
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
	actionButtons: {
		//position: 'absolute',
		right: 0,
	},
}));

const calendarStrings = {
	lastDay: '[Yesterday at] LT',
	sameDay: '[Today at] LT',
	nextDay: '[Tomorrow at] LT',
	lastWeek: '[last] dddd [at] LT',
	nextWeek: 'dddd [at] LT',
	sameElse: 'L',
};

export default connect(null, { ReadEmail, DeleteEmail, GPSRoute, Hyperlink })((props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useHistory();
	const { id } = props.match.params;
	const emails = useSelector((state) => state.data.data.emails);
	const email = emails.filter((e) => e._id === id)[0];

	useEffect(() => {
		let intrvl = null;
		if (!email) {
			showAlert('Email Has Been Deleted');
			history.goBack();
		}

		if (email?.unread) props.ReadEmail(email);

		if (email?.flags?.expires != null) {
			if (email.flags.expires < Date.now()) {
				showAlert('Email Has Expired');
				props.DeleteEmail(email._id);
				history.goBack();
			} else {
				intrvl = setInterval(() => {
					if (email.flags.expires < Date.now()) {
						showAlert('Email Has Expired');
						props.DeleteEmail(email._id);
						history.goBack();
					}
				}, 2500);
			}
		}
		return () => {
			clearInterval(intrvl);
		};
	}, [email]);

	const [open, setOpen] = useState(false);
	const [offset, setOffset] = useState({
		left: 110,
		top: 0,
	});

	const onClick = (e) => {
		e.preventDefault();
		setOffset({ left: e.clientX - 2, top: e.clientY - 4 });
		setOpen(true);
	};
	
	const onClose = () => {
		setOpen(false);
	};
	
	const deleteEmail = () => {
		onClose();
		showAlert('Email Deleted');
		props.DeleteEmail(email._id);
		history.goBack();
	};
	
	const gpsClicked = () => {
		if (email?.flags?.location != null)
		props.GPSRoute(email._id, email.flags.location);
	};

	const linkClicked = () => {
		if (email?.flags?.hyperlink != null)
			props.Hyperlink(email._id, email.flags.hyperlink);
		};
		
	return (
		<div className={classes.wrapper}>
			<AppBar position="static">
				<Grid container className={classes.titleBar}>
					<Grid item xs={2} style={{ textAlign: 'left' }}>
						<IconButton onClick={() => history.goBack()}>
							<FontAwesomeIcon icon={['fas', 'arrow-left']} />
						</IconButton>
					</Grid>
					<Grid
						item
						xs={8}
						className={classes.emailTitle}
						title={email?.subject}
					>
						{email?.subject}
					</Grid>
					<Grid item xs={2} style={{ textAlign: 'right' }}>
						<IconButton onClick={onClick}>
							<FontAwesomeIcon
								icon={['fas', 'ellipsis-vertical']}
							/>
						</IconButton>
					</Grid>
				</Grid>
				<Grid container className={classes.senderBar}>
					<Grid item xs={2}>
						<Avatar className={classes.avatar}>
							{email?.sender?.charAt(0)}
						</Avatar>
					</Grid>
					<Grid
						item
						xs={10}
						style={{
							overflow: 'hidden',
							whiteSpace: 'nowrap',
							textOverflow: 'ellipsis',
						}}
					>
						<div className={classes.sender}>{email?.sender}</div>
						<div className={classes.recipient}>to: me</div>
					</Grid>

					<Grid
						item
						xs={8}
						style={{ textAlign: 'left', position: 'relative' }}
					>
						<p className={classes.sendTime}>
							Received <Moment interval={60000} fromNow>
								{+email?.time}
							</Moment>.
						</p>
					</Grid>
					<Grid
						item
						xs={4}
						style={{ textAlign: 'right', position: 'relative' }}
					>
						<div className={classes.actionButtons}>
							{email?.flags?.location != null ? (
								<IconButton
									onClick={gpsClicked}
								>
									<FontAwesomeIcon
										icon={['fas', 'location-crosshairs']}
									/>
								</IconButton>
							) : null}
							{email?.flags?.hyperlink != null ? (
								<IconButton
									onClick={linkClicked}
								>
									<FontAwesomeIcon
										icon={['fas', 'link']}
									/>
								</IconButton>
							) : null}
						</div>
					</Grid>
				</Grid>
			</AppBar>
			<Menu
				anchorReference="anchorPosition"
				anchorPosition={offset}
				keepMounted
				open={open}
				onClose={onClose}
			>
				<MenuItem onClick={deleteEmail}>Delete Email</MenuItem>
			</Menu>
			{email?.flags?.expires != null ? (
				<AppBar className={classes.expireBar} position="static">
					<div>
						Email expires{' '}
						<Moment
							interval={10000}
							calendar={calendarStrings}
							fromNow
						>
							{+email.flags.expires}
						</Moment>
					</div>
				</AppBar>
			) : null}
			<Paper
				className={classes.emailBody}
				style={{
					height:
						email?.flags?.expires != null
							? '66.6%'
							: '73.5%',
				}}
			>
				{Sanitize(email?.body)}
			</Paper>
		</div>
	);
});
