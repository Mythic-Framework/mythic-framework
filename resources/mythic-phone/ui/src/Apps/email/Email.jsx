import React, { useEffect } from 'react';
import { connect } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { Grid, Avatar, Paper } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Moment from 'react-moment';

import { DeleteEmail } from './action';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	convo: {
		'&::before': {
			background: 'transparent !important',
		},
		background: theme.palette.secondary.dark,
		padding: '20px 12px',
		border: '1px solid rgba(0, 0, 0, .25)',
		'&:not(:last-child)': {
			borderBottom: 'none',
		},
		'&:hover': {
			background: theme.palette.secondary.main,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	avatar: {
		color: theme.palette.text.light,
		height: 55,
		width: 55,
		position: 'relative',
		top: 0,
	},
	avatarUnread: {
		color: theme.palette.text.light,
		background: theme.palette.primary.main,
		height: 55,
		width: 55,
		position: 'relative',
		top: 0,
	},
	sender: {
		fontSize: 18,
		color: theme.palette.text.main,
	},
	senderUnread: {
		fontSize: 18,
		color: theme.palette.primary.main,
		fontWeight: 'bold',
	},
	time: {
		fontSize: 12,
		color: theme.palette.text.main,
		float: 'right',
		lineHeight: '25px',
	},
	subject: {
		fontSize: 16,
		color: theme.palette.text.light,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		marginTop: 5,
		maxWidth: '90%',
	},
	body: {
		fontSize: 14,
		color: theme.palette.text.main,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
		marginTop: 5,
		maxWidth: '90%',
	},
	specialIcon: {
		position: 'absolute',
		right: 0,
		bottom: 0,
		fontSize: 20,
	},
}));

export default connect(null, { DeleteEmail })((props) => {
	const classes = useStyles();
	const history = useHistory();

	const onClick = () => {
		history.push(`/apps/email/view/${props.email._id}`);
	};

	useEffect(() => {
		let intrvl = null;
		if (props.email.flags != null && props.email.flags.expires != null) {
			intrvl = setInterval(() => {
				if (props.email.flags.expires < Date.now()) {
					props.DeleteEmail(props.email._id);
				}
			}, 2500);
		}
		return () => {
			clearInterval(intrvl);
		};
	}, []);

	return (
		<Paper className={classes.convo} onClick={onClick}>
			<Grid container>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<Avatar
						className={
							props.email.unread
								? classes.avatarUnread
								: classes.avatar
						}
					>
						{props.email.sender?.charAt(0)?.toUpperCase() ?? '?'}
					</Avatar>
				</Grid>
				<Grid item xs={10} style={{ position: 'relative' }}>
					<div>
						<span
							className={
								props.email.unread
									? classes.senderUnread
									: classes.sender
							}
						>
							{props.email.sender}
						</span>
						<div className={classes.time}>
							<Moment interval={60000} fromNow>
								{+props.email.time}
							</Moment>
						</div>
					</div>
					{props.email.flags != null ? (
						<FontAwesomeIcon
							className={classes.specialIcon}
							icon={['fas', 'flag']}
						/>
					) : null}
					<div className={classes.subject}>{props.email.subject}</div>
					{/* <div className={classes.body}>{props.email.body}</div> */}
				</Grid>
			</Grid>
		</Paper>
	);
});
