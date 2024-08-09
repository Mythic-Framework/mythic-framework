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
import Nui from '../../util/Nui';

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
}));

export default (props) => {
	const classes = useStyles();
	const history = useHistory();
	const callData = useSelector((state) => state.call.call);

	const callContact = async () => {
		if (callData == null) {
			try {
				let res = await (
					await Nui.send('CreateCall', {
						number: props.contact.number,
						isAnon: false,
					})
				).json();
				if (res) {
					history.push(`/apps/phone/call/${props.contact.number}`);
				} else showAlert('Unable To Start Call');
			} catch (err) {
				console.log(err);
				showAlert('Unable To Start Call');
			}
		}
	};

	const textContact = () => {
		history.push(`/apps/messages/convo/${props.contact.number}`);
	};

	const editContact = () => {
		history.push(`/apps/contacts/edit/${props.contact._id}`);
	};

	return (
		<Paper className={classes.paper}>
			<ExpansionPanel
				className={classes.contact}
				expanded={props.expanded == props.index}
				onChange={props.onClick}
			>
				<AccordionSummary
					expandIcon={
						<FontAwesomeIcon icon={['fas', 'chevron-down']} />
					}
					style={{ padding: '0 12px' }}
				>
					<Grid container>
						<Grid item xs={2}>
							{props.contact.avatar != null &&
							props.contact.avatar !== '' ? (
								<Avatar
									className={
										props.contact.favorite
											? classes.avatarFav
											: classes.avatar
									}
									src={props.contact.avatar}
									alt={props.contact.name.charAt(0)}
								/>
							) : (
								<Avatar
									className={
										props.contact.favorite
											? classes.avatarFav
											: classes.avatar
									}
									style={{ background: props.contact.color }}
								>
									{props.contact.name.charAt(0)}
								</Avatar>
							)}
						</Grid>
						<Grid item xs={10}>
							<div className={classes.contactName}>
								{props.contact.name}
							</div>
							<div className={classes.contactNumber}>
								{props.contact.number}
							</div>
						</Grid>
					</Grid>
				</AccordionSummary>
				<AccordionDetails>
					<Grid container className={classes.expandoContainer}>
						<Grid
							item
							xs={props.onDelete != null ? 3 : 4}
							className={classes.expandoItem}
							onClick={callContact}
						>
							<FontAwesomeIcon icon="phone" />
						</Grid>
						<Grid
							item
							xs={props.onDelete != null ? 3 : 4}
							className={classes.expandoItem}
							onClick={textContact}
						>
							<FontAwesomeIcon icon="comment-sms" />
						</Grid>
						<Grid
							item
							xs={props.onDelete != null ? 3 : 4}
							className={classes.expandoItem}
							onClick={editContact}
						>
							<FontAwesomeIcon icon="user-pen" />
						</Grid>
						{props.onDelete != null ? (
							<Grid
								item
								xs={3}
								className={classes.expandoItem}
								onClick={props.onDelete}
							>
								<FontAwesomeIcon icon="user-minus" />
							</Grid>
						) : null}
					</Grid>
				</AccordionDetails>
			</ExpansionPanel>
		</Paper>
	);
};
