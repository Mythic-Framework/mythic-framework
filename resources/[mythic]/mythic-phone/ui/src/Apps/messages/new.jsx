import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import {
	TextField,
	Avatar,
	Grid,
	InputAdornment,
	IconButton,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import InputMask from 'react-input-mask';

import { useAlert } from '../../hooks';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	newNumber: {
		marginTop: '1%',
		height: '9%',
		padding: '0 25px',
	},
	searchField: {
		width: '100%',
	},
	contactsList: {
		'&::before': {
			content: '"OR"',
			display: 'block',
			position: 'absolute',
			left: 0,
			right: 0,
			margin: 'auto',
			width: 'fit-content',
			top: '17.75%',
			background: theme.palette.secondary.main,
		},
		borderTop: `1px solid ${theme.palette.primary.main}`,
		height: '90%',
		padding: '15px 25px',
		overflow: 'hidden',
	},
	contactWrapper: {
		width: '100%',
		padding: '20px 12px',
		background: theme.palette.secondary.dark,
		border: '1px solid rgba(0, 0, 0, .25)',
		'&:not(:last-child)': {
			borderBottom: 'none',
		},
		'&:hover': {
			filter: 'brightness(0.75)',
			transition: 'filter ease-in 0.15s',
			cursor: 'pointer',
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
	noContacts: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		color: theme.palette.error.main,
	},
	contactsFilter: {
		height: '11%',
		overflow: 'hidden',
	},
	contactsBody: {
		height: '89%',
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
}));

export default (props) => {
	const showAlert = useAlert();
	const history = useHistory();
	const contacts = useSelector((state) => state.data.data.contacts);
	const classes = useStyles();

	const [filteredContacts, setFilteredContacts] = useState(contacts);
	const [rawNumber, setRawNumber] = useState('');
	const [searchVal, setSearchVal] = useState('');

	useEffect(() => {
		setFilteredContacts(
			contacts.filter((c) =>
				c.name.toUpperCase().includes(searchVal.toUpperCase()),
			),
		);
	}, [searchVal]);

	const onSearchChange = (e) => {
		setSearchVal(e.target.value);
	};

	const onRawChange = (e) => {
		setRawNumber(e.target.value);
	};

	const onContactClick = (contact) => {
		history.push(`/apps/messages/convo/${contact.number}`);
	};

	const sendMessageToRaw = () => {
		let r = /([0-9]){3}\-([0-9]){3}\-([0-9]){4}/gm.exec(rawNumber);

		if (r != null) {
			history.push(`/apps/messages/convo/${rawNumber}`);
		} else {
			showAlert('Not A Valid Number');
		}
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.newNumber}>
				<InputMask
					mask="999-999-9999"
					value={rawNumber}
					onChange={onRawChange}
				>
					{() => (
						<TextField
							className={classes.searchField}
							label="Enter Number"
							name="number"
							type="text"
							variant="outlined"
							InputProps={{
								endAdornment: (
									<InputAdornment position="end">
										<IconButton
											aria-label="toggle password visibility"
											onClick={sendMessageToRaw}
										>
											<FontAwesomeIcon
												icon={[
													'fas',
													'paper-plane-top',
												]}
											/>
										</IconButton>
									</InputAdornment>
								),
							}}
							InputLabelProps={{
								style: { fontSize: 16 },
							}}
						/>
					)}
				</InputMask>
			</div>
			<div className={classes.contactsList}>
				{contacts.length > 0 ? (
					<div style={{ height: '100%' }}>
						<div className={classes.contactsFilter}>
							<TextField
								className={classes.searchField}
								label="Search Contacts"
								name="number"
								type="text"
								variant="outlined"
								value={searchVal}
								onChange={onSearchChange}
								style={{ marginTop: 5 }}
								InputLabelProps={{
									style: { fontSize: 16 },
								}}
							/>
						</div>
						<div className={classes.contactsBody}>
							{filteredContacts
								.filter((c) => c.favorite)
								.sort((a, b) => {
									if (
										a.name.toLowerCase() >
										b.name.toLowerCase()
									)
										return 1;
									else if (
										b.name.toLowerCase() >
										a.name.toLowerCase()
									)
										return -1;
									else return 0;
								})
								.map((contact) => {
									return (
										<Grid
											container
											key={contact._id}
											className={classes.contactWrapper}
											onClick={() =>
												onContactClick(contact)
											}
										>
											<Grid item xs={2}>
												{contact.avatar != null &&
												contact.avatar !== '' ? (
													<Avatar
														className={
															classes.avatarFav
														}
														src={contact.avatar}
														alt={contact.name.charAt(
															0,
														)}
													/>
												) : (
													<Avatar
														className={
															classes.avatarFav
														}
														style={{
															background:
																contact.color,
														}}
													>
														{contact.name.charAt(0)}
													</Avatar>
												)}
											</Grid>
											<Grid item xs={10}>
												<div
													className={
														classes.contactData
													}
												>
													<div
														className={classes.name}
													>
														{contact.name}
													</div>
													<div
														className={
															classes.number
														}
													>
														{contact.number}
													</div>
												</div>
											</Grid>
										</Grid>
									);
								})}
							{filteredContacts
								.filter((c) => !c.favorite)
								.sort((a, b) => {
									if (a.name > b.name) return 1;
									else if (b.name > a.name) return -1;
									else return 0;
								})
								.map((contact) => {
									return (
										<Grid
											container
											key={contact._id}
											className={classes.contactWrapper}
											onClick={() =>
												onContactClick(contact)
											}
										>
											<Grid item xs={2}>
												{contact.avatar != null &&
												contact.avatar !== '' ? (
													<Avatar
														className={
															classes.avatar
														}
														src={contact.avatar}
														alt={contact.name.charAt(
															0,
														)}
													/>
												) : (
													<Avatar
														className={
															classes.avatar
														}
														style={{
															background:
																contact.color,
														}}
													>
														{contact.name.charAt(0)}
													</Avatar>
												)}
											</Grid>
											<Grid item xs={10}>
												<div
													className={
														classes.contactData
													}
												>
													<div
														className={classes.name}
													>
														{contact.name}
													</div>
													<div
														className={
															classes.number
														}
													>
														{contact.number}
													</div>
												</div>
											</Grid>
										</Grid>
									);
								})}
						</div>
					</div>
				) : (
					<div className={classes.noContacts}>
						You Have No Contacts
					</div>
				)}
			</div>
		</div>
	);
};
