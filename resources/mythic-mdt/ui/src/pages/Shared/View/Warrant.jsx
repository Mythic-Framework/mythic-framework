import React, { useState } from 'react';
import { Alert, Button, ButtonGroup, Grid, List, ListItem, ListItemText, TextField, MenuItem } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router';
import { Link } from 'react-router-dom';
import { useParams } from 'react-router';
import moment from 'moment';
import { usePerson } from '../../../hooks';

import { toast } from 'react-toastify';
import Nui from '../../../util/Nui';

import { Sanitize } from '../../../util/Parser';
import { Modal } from '../../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	notes: {
		color: theme.palette.text.alt,
		padding: '8px 16px',
		whiteSpace: 'pre-line',
	},
	link: {
		color: theme.palette.text.alt,
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.main,
		},
	},
}));

const WarrantStates = [
	{
		label: 'Active',
		value: 'active',
	},
	{
		label: 'Served',
		value: 'served',
	},
	{
		label: 'Expired',
		value: 'expired',
	},
	{
		label: 'Void',
		value: 'void',
	},
];

export default ({ match }) => {
	const classes = useStyles();
	const history = useNavigate();
	const formatPerson = usePerson();
	const params = useParams();
	const warrant = useSelector((state) => state.data.data.warrants).filter((w) => w._id == params.id)[0];

	const [updating, setUpdating] = useState(false);

	const onSubmit = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('Update', {
					type: 'warrant',
					id: warrant._id,
					state: updating,
				})
			).json();

			if (res) {
				setUpdating(false);
				history(-1);
				toast.success('Warrant Updated');
			} else toast.error('Unable to Update Warrant');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Update Warrant');
		}
	};

	return (
		<div className={classes.wrapper}>
			{Boolean(warrant) ? (
				<>
					<Grid container spacing={2}>
						<Grid item xs={12}>
							<ButtonGroup fullWidth>
								<Button onClick={() => setUpdating(warrant.state)}>Update Status</Button>
							</ButtonGroup>
						</Grid>
						<Grid item xs={6}>
							<List>
								<ListItem>
									<ListItemText
										primary="Suspect"
										secondary={
											<Link
												className={classes.link}
												to={`/search/people/${warrant.suspect.SID}`}
											>{`${warrant.suspect.First} ${warrant.suspect.Last}`}</Link>
										}
									/>
								</ListItem>
								<ListItem>
									<ListItemText
										primary="Issuing Officer"
										secondary={
											<Link className={classes.link} to={`/roster?id=${warrant.author.SID}`}>
												{formatPerson(
													warrant.author.First,
													warrant.author.Last,
													warrant.author.Callsign,
													warrant.author.SID,
												)}
											</Link>
										}
									/>
								</ListItem>
								<ListItem>
									<ListItemText
										primary="Report"
										secondary={
											<Link className={classes.link} to={`/search/reports/${warrant.report._id}`}>
												Report #{warrant.report.ID}
											</Link>
										}
									/>
								</ListItem>
								{warrant.status !== 'active' ? (
									<ListItem>
										<ListItemText
											primary="Status"
											secondary={WarrantStates.find((w) => w.value == warrant.state)?.label}
										/>
									</ListItem>
								) : warrant.expires > Date.now() ? (
									<ListItem>
										<ListItemText
											primary="Expires"
											secondary={moment(warrant.expires).format('LLLL')}
										/>
									</ListItem>
								) : (
									<ListItem>
										<ListItemText primary="Expires" secondary="Expired" />
									</ListItem>
								)}
							</List>
						</Grid>
						<Grid item xs={6}>
							<List>
								<ListItem>
									<ListItemText primary="Warrant Notes" />
								</ListItem>
								<div className={classes.notes}>{Sanitize(warrant.notes)}</div>
							</List>
						</Grid>
					</Grid>
					<Modal
						open={updating}
						title="Update Warrant"
						onSubmit={onSubmit}
						onClose={() => setUpdating(false)}
					>
						<TextField
							select
							fullWidth
							required
							label="State"
							name="state"
							className={classes.field}
							value={updating}
							onChange={(e) => setUpdating(e.target.value)}
						>
							{WarrantStates.map((option) => (
								<MenuItem key={option.value} value={option.value}>
									{option.label}
								</MenuItem>
							))}
						</TextField>
					</Modal>
				</>
			) : (
				<Alert variant="filled" severity="error">
					Invalid Warrant ID
				</Alert>
			)}
		</div>
	);
};
