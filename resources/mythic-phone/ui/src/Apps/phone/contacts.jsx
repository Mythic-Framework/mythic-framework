import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Contact from '../contacts/contact';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const history = useHistory();
	const data = useSelector((state) => state.data.data);
	const contacts = data.contacts;
	const [expanded, setExpanded] = useState(-1);

	const handleClick = (index) => (event, newExpanded) => {
		setExpanded(newExpanded ? index : false);
	};

	return (
		<div className={classes.wrapper}>
			{contacts.length > 0 ? (
				<>
					{contacts
						.filter((c) => c.favorite)
						.sort((a, b) => {
							if (a.name.toLowerCase() > b.name.toLowerCase())
								return 1;
							else if (
								b.name.toLowerCase() > a.name.toLowerCase()
							)
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
								/>
							);
						})}
					{contacts
						.filter((c) => !c.favorite)
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
								/>
							);
						})}
				</>
			) : (
				<div className={classes.emptyMsg}>
					You Have No Recent Contacts
				</div>
			)}
		</div>
	);
};
