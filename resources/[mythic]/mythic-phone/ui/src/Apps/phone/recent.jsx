import React from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import {
	Grid,
	Avatar,
	Accordion,
	AccordionSummary,
	AccordionDetails,
	Paper,
} from '@material-ui/core';
import { makeStyles, withStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';

const ExpansionPanel = withStyles({
	root: {
		border: '1px solid rgba(0, 0, 0, .25)',
		boxShadow: 'none',
		'&:not(:last-child)': {
			borderBottom: 0,
		},
		'&:before': {
			display: 'none',
		},
		'&$expanded': {
			margin: 'auto',
		},
	},
	expanded: {},
})(Accordion);

const useStyles = makeStyles((theme) => ({
	contact: {
		'&::before': {
			background: 'transparent !important',
		},
		background: theme.palette.secondary.dark,
		'&:hover': {
			background: theme.palette.secondary.main,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	paper: {
		background: theme.palette.secondary.dark,
	},
	expandoContainer: {
		textAlign: 'center',
		fontSize: 30,
	},
	expandoItem: {
		'&:hover': {
			color: theme.palette.primary.main,
			transition: 'color ease-in 0.15s',
		},
	},
	avatar: {
		color: '#fff',
		height: 45,
		width: 45,
	},
	avatarFav: {
		color: '#fff',
		height: 45,
		width: 45,
		border: '2px solid gold',
	},
	contactName: {
		fontSize: 18,
		color: theme.palette.text.light,
	},
	contactNumber: {
		fontSize: 16,
		color: theme.palette.text.main,
	},
	expanded: {
		margin: 0,
	},
	missedIcon: {
		height: 16,
		width: 16,
		color: theme.palette.error.main,
	},
	incomingIcon: {
		height: 16,
		width: 16,
		color: '#5ec750',
	},
	outgoingIcon: {
		height: 16,
		width: 16,
		color: '#50a2c7',
	},
	callDate: {
		textAlign: 'right',
		fontSize: 12,
	},
}));

export default (props) => {
	const classes = useStyles();
	const history = useHistory();
	const showAlert = useAlert();
	const contacts = useSelector((state) => state.data.data.contacts);
	const callData = useSelector((state) => state.call.call);
	const player = useSelector((state) => state.data.data.player);
	const isContact = contacts.filter((c) => c.number === props.call.number)[0];

	const callContact = async () => {
		if (
			callData == null &&
			!props?.call?.limited &&
			!props?.call?.anonymous
		) {
			try {
				let res = await (
					await Nui.send('CreateCall', {
						number: props.call.number,
						isAnon: false,
					})
				).json();
				if (res) {
					history.push(`/apps/phone/call/${props.call.number}`);
				} else showAlert('Unable To Start Call');
			} catch (err) {
				console.log(err);
				showAlert('Unable To Start Call');
			}
		}
	};

	const textContact = () => {
		if (!props?.call?.limited && !props?.call?.anonymous) {
			history.push(`/apps/messages/convo/${props.call.number}`);
		}
	};

	const editContact = () => {
		if (!props?.call?.limited && !props?.call?.anonymous) {
			history.push(`/apps/contacts/edit/${isContact._id}`);
		}
	};

	const addContact = () => {
		if (!props?.call?.limited && !props?.call?.anonymous) {
			history.push(`/apps/contacts/add/${props.call.number}`);
		}
	};

	const getCallIcon = (call) => {
		if (call.duration < -1) {
			if (call.method) {
				return (
					<FontAwesomeIcon
						icon={['fas', 'phone-arrow-up-right']}
						className={classes.outgoingIcon}
					/>
				);
			} else {
				return (
					<FontAwesomeIcon
						icon={['fas', 'phone-arrow-down-left']}
						className={classes.incomingIcon}
					/>
				);
			}
		} else {
			if (call.method) {
				return (
					<FontAwesomeIcon
						icon={['fas', 'phone-arrow-up-right']}
						className={classes.missedIcon}
					/>
				);
			} else {
				return (
					<FontAwesomeIcon
						icon={['fas', 'phone-missed']}
						className={classes.missedIcon}
					/>
				);
			}
		}
	};

	if (props?.call?.limited && props?.call?.method) return null;
	return (
		<Paper className={classes.paper}>
			<ExpansionPanel
				className={classes.contact}
				expanded={
					props.expanded == props.index &&
					!props?.call?.limited &&
					!props?.call?.anonymous
				}
				onChange={props.onClick}
			>
				<AccordionSummary
					expandIcon={
						!props?.call?.limited && !props?.call?.anonymous ? (
							<FontAwesomeIcon icon={['fas', 'chevron-down']} />
						) : null
					}
				>
					<Grid container>
						<Grid item xs={2}>
							{!props?.call?.limited &&
							!props?.call?.anonymous &&
							isContact != null &&
							isContact.avatar != null &&
							isContact.avatar !== '' ? (
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
										!props?.call?.limited &&
										!props?.call?.anonymous &&
										isContact != null &&
										isContact.favorite
											? classes.avatarFav
											: classes.avatar
									}
									style={{
										background:
											!props?.call?.limited &&
											!props?.call?.anonymous &&
											isContact != null &&
											isContact.color
												? isContact.color
												: '#333',
									}}
								>
									{!props?.call?.limited &&
									!props?.call?.anonymous &&
									isContact != null
										? isContact.name.charAt(0)
										: props?.call?.limited
										? '?'
										: '#'}
								</Avatar>
							)}
						</Grid>
						<Grid item xs={10}>
							<div className={classes.contactName}>
								{!props?.call?.limited &&
								!props?.call?.anonymous &&
								isContact != null
									? isContact.name
									: 'Unknown Caller'}
							</div>
							<Grid container className={classes.contactNumber}>
								<Grid item xs={6}>
									{getCallIcon(props.call)}{' '}
									{!props?.call?.limited &&
									!props?.call?.anonymous
										? props.call.number
										: 'Unknown Number'}
								</Grid>
								<Grid item xs={6} className={classes.callDate}>
									<Moment fromNow>{+props.call.time}</Moment>
								</Grid>
							</Grid>
						</Grid>
					</Grid>
				</AccordionSummary>
				<AccordionDetails>
					{!props?.call?.limited && !props?.call?.anonymous && (
						<Grid container className={classes.expandoContainer}>
							<Grid
								item
								xs={4}
								className={classes.expandoItem}
								onClick={callContact}
							>
								<FontAwesomeIcon icon="phone" />
							</Grid>
							<Grid
								item
								xs={4}
								className={classes.expandoItem}
								onClick={textContact}
							>
								<FontAwesomeIcon icon="comment-sms" />
							</Grid>
							{isContact != null ? (
								<Grid item xs={4} onClick={editContact}>
									<FontAwesomeIcon icon="user-pen" />
								</Grid>
							) : (
								<Grid
									item
									xs={4}
									className={classes.expandoItem}
									onClick={addContact}
								>
									<FontAwesomeIcon icon="user-plus" />
								</Grid>
							)}
						</Grid>
					)}
				</AccordionDetails>
			</ExpansionPanel>
		</Paper>
	);
};
