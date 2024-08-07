import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import {
	Avatar,
	Grid,
	TextField,
	ButtonGroup,
	Button,
	Switch,
	FormGroup,
	FormControlLabel,
	Paper,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import InputMask from 'react-input-mask';
import { updateContact } from './actions';
import { useAlert } from '../../hooks';
import { Modal, ColorPicker } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
		padding: '0  10px',
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
	avatar: {
		height: 100,
		width: 100,
		fontSize: 35,
		color: theme.palette.text.light,
		position: 'absolute',
		left: 0,
		right: 0,
		top: '10%',
		display: 'block',
		textAlign: 'center',
		lineHeight: '100px',
		margin: 'auto',
		border: '2px solid transparent',
		transition: 'border 0.15s ease-in',
		'&:hover': {
			filter: 'brightness(0.6)',
			transition: 'filter ease-in 0.15s',
			cursor: 'pointer',
		},
		'&.favorite': {
			border: '2px solid gold',
		}
	},
	contactHeader: {
		padding: 20,
		background: theme.palette.secondary.dark,
		width: '100%',
		margin: '70px auto 25px auto',
		textAlign: 'center',
	},
	contactName: {
		fontSize: 30,
		color: theme.palette.primary.main,
	},
	contactNumber: {
		fontSize: 15,
		color: theme.palette.text.main,
	},
	contactButtons: {
		marginTop: 25,
	},
	contactButton: {
		fontSize: 25,
		'&:hover': {
			color: theme.palette.primary.main,
			transition: 'color 0.15s ease-in',
			cursor: 'pointer',
		},
	},
	actions: {
		background: theme.palette.secondary.dark,
		borderRadius: 10,
		fontSize: 15,
		fontWeight: 'bold',
		margin: '0 auto 25px auto',
		width: '100%',
	},
	action: {
		width: '100%',
		padding: 20,
		margin: 'auto',
		'&:hover': {
			filter: 'brightness(0.6)',
			transition: 'filter 0.15s ease-in',
			cursor: 'pointer',
		},
	},
	actionIcon: {
		display: 'block',
		fontSize: 15,
		textAlign: 'center',
		position: 'relative',
		right: 0,
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
	editBody: {
		padding: 20,
		background: theme.palette.secondary.dark,
		borderRadius: 10,
		width: '100%',
		margin: 'auto',
	},
	editField: {
		width: '100%',
		marginBottom: 20,
		fontSize: 20,
	},
	buttons: {
		width: '100%',
		display: 'flex',
		margin: 'auto',
	},
	button: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.warning.main,
		'&:hover': {
			backgroundColor: `${theme.palette.warning.main}14`,
		},
	},
	buttonNegative: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.error.main,
		'&:hover': {
			backgroundColor: `${theme.palette.error.main}14`,
		},
	},
	buttonPositive: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.success.main,
		'&:hover': {
			backgroundColor: `${theme.palette.success.main}14`,
		},
	},
	avaBody: {
		background: theme.palette.secondary.main,
		padding: 20,
	},
	editAvatar: {
		position: 'absolute',
		background: theme.palette.secondary.main,
		padding: 25,
		width: '70%',
		left: 0,
		right: 0,
		margin: 'auto',
		zIndex: 15,
	},
	colorPreview: {
		marginBottom: 10,
	},
	colorLabel: {
		color: theme.palette.text.main,
		fontWeight: 'bold',
		marginBottom: 5,
	},
	colorDisplay: {
		width: '100%',
		height: 45,
		border: `1px solid ${theme.palette.text.main}`,
	},
}));

export default connect(null, { updateContact })((props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useHistory();
	const { id } = props.match.params;
	const contacts = useSelector((state) => state.data.data).contacts;
	const [contact, setContact] = useState(
		useSelector((state) => state.data.data.contacts).filter(
			(c) => c._id == id,
		)[0],
	);

	const [colorSelection, setColorSelection] = useState(false);
	const [avatarSelection, setAvatarSelection] = useState(false);

	const callContact = () => {};

	const textContact = () => {
		history.push(`/apps/messages/convo/${contact.number}`);
	};

	const onChange = (e) => {
		if (e.hex != null) {
			setContact({
				...contact,
				color: e.hex,
			});
		} else {
			switch (e.target.name) {
				case 'favorite':
					setContact({
						...contact,
						[e.target.name]: e.target.checked,
					});
					break;
				default:
					setContact({
						...contact,
						[e.target.name]: e.target.value,
					});
					break;
			}
		}
	};

	const onSubmit = (e) => {
		setAvatarSelection(false);
		e.preventDefault();

		if (
			contacts.filter(
				(c) => c.number === contact.number && c._id != contact._id,
			).length > 1 &&
			contacts.filter(
				(c) => c._id === contact._id && c.number !== contact.number,
			).length > 0
		) {
			showAlert('Contact Already Exists For This Number');
		} else {
			props.updateContact(contact._id, contact);
			showAlert(`${contact.name} Updated`);
			history.goBack();
		}
	};

	const removeImage = () => {
		showAlert('Avatar Image Removed');
		setAvatarSelection(false);
		setContact({
			...contact,
			avatar: '',
		});
	};

	return (
		<div className={classes.wrapper}>
			<Paper className={classes.contactHeader}>
				{contact.avatar != null && contact.avatar !== '' ? (
					<Avatar
						className={`${classes.avatar}${contact.favorite ? ' favorite' : ''}`}
						src={contact.avatar}
						alt={contact.name.charAt(0)}
						onClick={() => setAvatarSelection(true)}
					/>
				) : (
					<Avatar
						className={`${classes.avatar}${
							contact.favorite ? ' favorite' : ''
						}`}
						style={{
							background: contact.color,
						}}
						onClick={() => setAvatarSelection(true)}
					>
						{contact.name.charAt(0)}
					</Avatar>
				)}
				<div
					className={classes.contactName}
					style={{ color: contact.color }}
				>
					{contact.name}
				</div>
				<div className={classes.contactNumber}>{contact.number}</div>
				<Grid container className={classes.contactButtons}>
					<Grid
						item
						xs={6}
						onClick={callContact}
						className={classes.contactButton}
					>
						<FontAwesomeIcon icon="phone" />
					</Grid>
					<Grid
						item
						xs={6}
						onClick={textContact}
						className={classes.contactButton}
					>
						<FontAwesomeIcon icon="comment-sms" />
					</Grid>
				</Grid>
			</Paper>
			<Paper className={classes.editBody}>
				<div style={{ textAlign: 'center' }}>
					<h1>Edit Contact Details</h1>
				</div>
				<form autoComplete="off" onSubmit={onSubmit} id="contact-form">
					<TextField
						className={classes.editField}
						label="Name"
						name="name"
						type="text"
						required
						value={contact.name}
						onChange={onChange}
						InputLabelProps={{
							style: { fontSize: 20 },
						}}
					/>
					<InputMask
						mask="999-999-9999"
						value={contact.number}
						onChange={onChange}
					>
						{() => (
							<TextField
								className={classes.editField}
								label="Number"
								name="number"
								type="text"
								required
								InputLabelProps={{
									style: { fontSize: 20 },
								}}
							/>
						)}
					</InputMask>
					<div className={classes.colorPreview}>
						<div className={classes.colorLabel}>
							Contact Color *
						</div>
						<div
							className={classes.colorDisplay}
							style={{ background: contact.color }}
							onClick={() => setColorSelection(true)}
						></div>
					</div>
					<FormGroup row>
						<FormControlLabel
							style={{ width: '100%' }}
							control={
								<Switch
									checked={contact.favorite}
									onChange={onChange}
									value="favorite"
									name="favorite"
									color="primary"
								/>
							}
							label="Favorite"
						/>
					</FormGroup>
				</form>
			</Paper>
			<ButtonGroup
				variant="text"
				color="primary"
				className={classes.buttons}
			>
				<Button
					className={classes.button}
					onClick={() => history.goBack()}
				>
					Cancel
				</Button>
				<Button
					className={classes.buttonNegative}
					type="submit"
					form="contact-form"
				>
					Delete
				</Button>
				<Button
					className={classes.buttonPositive}
					type="submit"
					form="contact-form"
				>
					Save
				</Button>
			</ButtonGroup>

			<Modal
				open={avatarSelection}
				title="Avatar"
				onClose={() => setAvatarSelection(false)}
				onDelete={
					contact.avatar != null && Boolean(contact.avatar)
						? removeImage
						: null
				}
				deleteLang="Remove Avatar"
				closeLang="Done"
			>
				<TextField
					className={classes.editField}
					label="Link"
					name="avatar"
					type="text"
					onChange={onChange}
					value={contact.avatar}
					InputLabelProps={{
						style: { fontSize: 20 },
					}}
				/>
			</Modal>

			<Modal
				hideClose
				open={colorSelection}
				title="Contact Color"
				onClose={() => setColorSelection(false)}
				onAccept={() => setColorSelection(false)}
				acceptLang="Save"
			>
				<ColorPicker color={contact.color} onChange={onChange} />
			</Modal>
		</div>
	);
});
