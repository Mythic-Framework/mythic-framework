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
import { usePerson } from '../../../../hooks';
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

export const FlagTypes = [
	{
		label: 'Stolen Vehicle',
		value: 'stolen',
		severity: 'error',
		radarFlag: true,
	},
	{
		label: 'Suspended Registration',
		value: 'suspended',
		severity: 'warning',
	},
	{
		label: 'BOLO',
		value: 'BOLO',
		severity: 'error',
		radarFlag: true,
	},
	{
		label: 'History of Evasion',
		value: 'evasion',
		severity: 'error',
	},
	{
		label: 'Suspected OC Involvement',
		value: 'oc',
		severity: 'error',
	},
];

export default ({ flag, onDismiss, ...rest }) => {
	const classes = useStyles();
	const data = FlagTypes.find((f) => f.value == flag.Type) ?? {
		label: 'Error - Flag Removed',
		value: 'error',
		severity: 'error',
	};
	const formatPerson = usePerson();

	const [open, setOpen] = useState(false);

	const inDismiss = async () => {
		onDismiss(flag.Type, flag.radarFlag);
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
				title="Vehicle Flag"
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
								<Link
									className={classes.link}
									to={`/roster?id=${flag.Author.SID}`}
								>
									{formatPerson(flag.Author.First, flag.Author.Last, flag.Author.Callsign, flag.Author.SID)}
								</Link>
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
