import React, { useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import {
	Fab,
	TextField,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import { Confirm } from '../../components';
import Contact from './contact';

import { deleteContact } from './actions';
import { useAlert } from '../../hooks';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		//position: 'relative',
	},
	content: {
		height: '90%',
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
	searchField: {
		height: '10%',
		padding: 10,
	},
	add: {
		position: 'absolute',
		bottom: '12%',
		right: '10%',
		'&:hover': {
			filter: 'brightness(0.75)',
			transition: 'filter ease-in 0.15s',
		},
	},
	closer: {
		position: 'fixed',
		top: 0,
		left: 0,
		height: '100%',
		width: '100%',
		background: 'rgba(0, 0, 0, 0.75)',
		zIndex: 10000,
	},
	createInput: {
		width: '100%',
		height: '100%',
		marginBottom: 10,
	},
	nocontacts: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

const fitSearchFilter = (name, number, term) => {
	if (term && term.length > 0 && name && number) {
		term = term.toLowerCase();

		return (name.toLowerCase().includes(term) || number.includes(term));
	} else return true;
}

export default connect(null, { deleteContact })((props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useHistory();
	const data = useSelector((state) => state.data.data);
	const contacts = data.contacts;
	const [expanded, setExpanded] = useState(-1);
	const [search, setSearched] = useState('');

	const create = () => {
		history.push('/apps/contacts/add');
	};

	const handleClick = (index) => (event, newExpanded) => {
		setExpanded(newExpanded ? index : false);
	};

	const [deleteOpen, setDeleteOpen] = useState(false);
	const handleDeleteOpen = (id) => {
		setDeleteOpen(id);
	};

	const onDecline = () => {
		setDeleteOpen(false);
	};

	const onDelete = () => {
		props.deleteContact(deleteOpen);
		setDeleteOpen(false);
		showAlert('Contact Deleted');
	};

	if (contacts != null && contacts.length > 0) {
		return (
			<div className={classes.wrapper}>
				<div className={classes.searchField}>
					<TextField
						fullWidth
						value={search}
						onChange={e => setSearched(e.target.value)}
						label="Search Contacts"
					/>
				</div>
				<div className={classes.content}>
					{contacts
						.filter((c) => c.favorite && fitSearchFilter(c.name, c.number, search))
						.sort((a, b) => {
							if (a.name.toLowerCase() > b.name.toLowerCase())
								return 1;
							else if (b.name.toLowerCase() > a.name.toLowerCase())
								return -1;
							else return 0;
						})
						.map((contact) => {
							return (
								<Contact
									key={contact._id}
									contact={contact}
									expanded={expanded}
									index={contact._id}
									onClick={handleClick(contact._id)}
									onDelete={() => handleDeleteOpen(contact._id)}
								/>
							);
						})}
					{contacts
						.filter((c) => !c.favorite && fitSearchFilter(c.name, c.number, search))
						.sort((a, b) => {
							if (a.name > b.name) return 1;
							else if (b.name > a.name) return -1;
							else return 0;
						})
						.map((contact) => {
							return (
								<Contact
									key={contact._id}
									contact={contact}
									expanded={expanded}
									index={contact._id}
									onClick={handleClick(contact._id)}
									onDelete={() => handleDeleteOpen(contact._id)}
								/>
							);
						})}
				</div>
				<Fab className={classes.add} color="primary" onClick={create}>
					<FontAwesomeIcon icon={['fas', 'plus']} />
				</Fab>
				<Confirm
					title="Delete Contact"
					open={deleteOpen}
					confirm="Delete"
					decline="Cancel"
					onConfirm={onDelete}
					onDecline={onDecline}
				/>
			</div>
		);
	} else {
		return (
			<div className={classes.wrapper}>
				<div className={classes.content}>
					<div className={classes.nocontacts}>You Have No Contacts</div>
				</div>
				<Fab className={classes.add} color="primary" onClick={create}>
					<FontAwesomeIcon icon={['fas', 'plus']} />
				</Fab>

				<Confirm
					title="Delete Contact"
					open={deleteOpen}
					confirm="Delete"
					decline="Cancel"
					onConfirm={onDelete}
					onDecline={onDecline}
				/>
			</div>
		);
	}
});
