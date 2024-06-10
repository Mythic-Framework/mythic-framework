import React, { useState } from 'react';
import {
	Chip,
	List,
	ListItem,
	ListItemText,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Link } from 'react-router-dom';
import { toast } from 'react-toastify';
import { usePerson, usePermissions } from '../../../../hooks';
import Moment from 'react-moment';

import { Modal } from '../../../../components';
import Nui from '../../../../util/Nui';

const useStyles = makeStyles((theme) => ({
	item: {
		margin: 4,
		'&.info': {
			backgroundColor: theme.palette.info.main,
		},
		'&.warning': {
			backgroundColor: theme.palette.warning.main,
			color: theme.palette.secondary.dark,
		},
		'&.error': {
			backgroundColor: theme.palette.error.main,
		},
		'&.success': {
			backgroundColor: theme.palette.success.main,
		},
	},
}));

export default ({ index, strike, onDismiss, ...rest }) => {
	const classes = useStyles();
	const formatPerson = usePerson();
	const hasPermission = usePermissions();

	const [open, setOpen] = useState(false);

	const inDismiss = async () => {
		onDismiss(index);
	};

	return (
		<div {...rest} style={{ display: 'inline-flex' }}>
			<Chip
				className={`${classes.item} error`}
				label={`Strike ${index + 1}`}
				onClick={() => setOpen(true)}
			/>
			<Modal
				open={open}
				maxWidth="sm"
				title={`Vehicle Strike ${index + 1}`}
				deleteLang="Remove Strike"
				onDelete={hasPermission('system-admin') ? inDismiss : null}
				onClose={() => setOpen(false)}
			>
				<List>
					<ListItem>
						<ListItemText primary="Title" secondary={`Vehicle Strike ${index + 1}`} />
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Issued"
							secondary={<Moment date={strike.Date} format="LLL" />}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Issued By"
							secondary={
								<Link
									className={classes.link}
									to={`/roster?id=${strike.Author.SID}`}
								>
									{formatPerson(strike.Author.First, strike.Author.Last, strike.Author.Callsign, strike.Author.SID)}
								</Link>
							}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							style={{ whiteSpace: 'pre-line' }}
							primary="Issued Reason"
							secondary={strike.Description}
						/>
					</ListItem>
				</List>
			</Modal>
		</div>
	);
};
