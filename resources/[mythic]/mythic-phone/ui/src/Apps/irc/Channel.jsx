import React, { useEffect } from 'react';
import { connect } from 'react-redux';
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
		color: theme.palette.text.dark,
		height: 55,
		width: 55,
		background: '#1de9b6',
		position: 'relative',
		top: 0,
	},
	name: {
		fontSize: 18,
		color: '#1de9b6',
	},
	time: {
		fontSize: 12,
		color: theme.palette.text.main,
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

export default connect()((props) => {
	const classes = useStyles();
	const history = useHistory();

	const onClick = () => {
		history.push(`/apps/irc/view/${props.channel.slug}`);
	};

	return (
		<Paper className={classes.convo} onClick={onClick}>
			<Grid container>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<Avatar className={classes.avatar}>#</Avatar>
				</Grid>
				<Grid item xs={10} style={{ position: 'relative' }}>
					<div>
						<span className={classes.name}>
							{props.channel.slug}
						</span>
						<div className={classes.time}>
							Joined:{' '}
							<Moment interval={60000} fromNow>
								{+props.channel.joined}
							</Moment>
						</div>
					</div>
					{/* <div className={classes.subject}>{props.email.subject}</div>
					<div className={classes.body}>{props.email.body}</div> */}
				</Grid>
			</Grid>
		</Paper>
	);
});
