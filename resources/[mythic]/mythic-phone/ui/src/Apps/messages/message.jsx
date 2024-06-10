import React from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { Grid, Avatar, Paper } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Moment from 'react-moment';

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
		color: '#fff',
		height: 55,
		width: 55,
		position: 'relative',
		top: 0,
	},
	avatarFav: {
		color: '#fff',
		height: 55,
		width: 55,
		position: 'relative',
		top: 0,
		border: '2px solid gold',
	},
	number: {
		fontSize: 16,
		fontWeight: 'bold',
		color: theme.palette.text.light,
	},
	message: {
		fontSize: 16,
		color: theme.palette.text.light,
		whiteSpace: 'nowrap',
		overflow: 'hidden',
		textOverflow: 'ellipsis',
	},
	time: {
		fontSize: 12,
		color: theme.palette.text.main,
	},
	unread: {
		width: 20,
		height: 20,
		lineHeight: '23px',
		position: 'absolute',
		bottom: '5%',
		right: '15%',
		textAlign: 'center',
		background: theme.palette.error.main,
		color: theme.palette.text.light,
		borderRadius: 100,
	},
}));

export default (props) => {
	const classes = useStyles();
	const history = useHistory();
	const contacts = useSelector((state) => state.data.data.contacts);
	const isContact = contacts.filter(
		(c) => c.number === props.message.number,
	)[0];

	const onClick = () => {
		history.push(`/apps/messages/convo/${props.message.number}`);
	};

	return (
		<Paper className={classes.convo} onClick={onClick}>
			<Grid container>
				<Grid item xs={2} style={{ position: 'relative' }}>
					{isContact != null ? (
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
								style={{ background: isContact.color }}
							>
								{isContact.name.charAt(0)}
							</Avatar>
						)
					) : (
						<Avatar className={classes.avatar}>#</Avatar>
					)}
					{props.unread > 0 ? (
						<div className={classes.unread}>{props.unread}</div>
					) : null}
				</Grid>
				<Grid item xs={10}>
					{isContact != null ? (
						<div className={classes.number}>{isContact.name}</div>
					) : (
						<div className={classes.number}>
							{props.message.number}
						</div>
					)}
					<div className={classes.message}>
						{props.message.message}
					</div>
					<div className={classes.time}>
						<Moment fromNow>{+props.message.time}</Moment>
					</div>
				</Grid>
			</Grid>
		</Paper>
	);
};
