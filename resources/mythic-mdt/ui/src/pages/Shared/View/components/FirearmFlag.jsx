import React, { useState } from 'react';
import {
	Chip,
	List,
	ListItem,
	ListItemText,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Link } from 'react-router-dom';
import { usePerson } from '../../../../hooks';
import Moment from 'react-moment';

import { Modal } from '../../../../components';
import Nui from '../../../../util/Nui';
import { toast } from 'react-toastify';

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

export const FlagTypes = [
	{
		label: 'Stolen',
		value: 'stolen',
		severity: 'error',
	},
	{
		label: 'Seized',
		value: 'seized',
		severity: 'error',
	},
];

export default ({ flag, onDismiss, ...rest }) => {
	const classes = useStyles();
	const data = FlagTypes.find((f) => f.value == flag.Type);
	const formatPerson = usePerson();

	const [open, setOpen] = useState(false);

	const inDismiss = async () => {
		try {
			let res = await (
				await Nui.send('Delete', {
					type: 'firearm-flag',
				})
			).json();

			if (res) {
				onDismiss(flag.Type);
			} else toast.error('Unable to Dismiss Flag');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Dismiss Flag');
		}
	};

	return (
		<div {...rest} style={{ display: 'inline-flex' }}>
			<Chip
				className={`${classes.item} ${data.severity}`}
				label={data.label}
				onDelete={inDismiss}
				onClick={() => setOpen(true)}
			/>
			<Modal
				open={open}
				maxWidth="sm"
				title="Firearm Flag"
				deleteLang="Remove Flag"
				onDelete={inDismiss}
				onClose={() => setOpen(false)}
			>
				<List>
					<ListItem>
						<ListItemText primary="Title" secondary={data.label} />
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Issued"
							secondary={<Moment date={flag.Date} format="LLL" />}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							primary="Issued By"
							secondary={
								Boolean(flag.Author) ? <Link
									className={classes.link}
									to={`/roster?id=${flag.Author.SID}`}
								>
									{formatPerson(flag.Author.First, flag.Author.Last, flag.Author.Callsign, flag.Author.SID)}
								</Link> : <span>Robbery Investigation</span>
							}
						/>
					</ListItem>
					<ListItem>
						<ListItemText
							style={{ whiteSpace: 'pre-line' }}
							primary="Issued Reason"
							secondary={flag.Description}
						/>
					</ListItem>
				</List>
			</Modal>
		</div>
	);
};
