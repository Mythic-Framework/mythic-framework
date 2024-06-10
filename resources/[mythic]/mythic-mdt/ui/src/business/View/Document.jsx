import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Divider, List, ListItem, ListItemText, Grid, Alert, Button, ButtonGroup } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { toast } from 'react-toastify';
import Moment from 'react-moment';
import { Link, useNavigate } from 'react-router-dom';
import { useParams } from 'react-router';

import { Loader, UserContent } from '../../components';
import Nui from '../../util/Nui';
import { usePermissions } from '../../hooks';
const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	notes: {
		color: theme.palette.text.alt,
		padding: '8px 16px',
		whiteSpace: 'pre-line',
		'& img': {
			width: '100%',
			maxWidth: 300,
		},
	},
	link: {
		color: theme.palette.text.alt,
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.main,
		},
	},
	officerLink: {
		color: theme.palette.text.alt,
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.main,
		},
		'&:not(:last-of-type)': {
			content: '", "',
			color: theme.palette.text.main,
		},
	},
}));

export default ({ match }) => {
	const classes = useStyles();
	const history = useNavigate();
	const hasPerms = usePermissions();
	const params = useParams();

	const [err, setErr] = useState(false);
	const [loading, setLoading] = useState(false);
	const [report, setReport] = useState(null);

	const onEdit = () => {
		history(`/business/create/document/${report._id}`);
	};

	const onDelete = async () => {
		if (hasPerms('TABLET_DELETE_DOCUMENT', false)) {
			try {
				let res = await (
					await Nui.send('BusinessDocumentDelete', {
						id: report._id,
					})
				).json();
				if (res) {
					toast.success('Document Deleted');
					history(`/business/search/document`);
				} else toast.error('Unable to Delete Document');
			} catch (err) {
				console.log(err);
				toast.error('Unable to Delete Document');
			}
		}
	};

	const canEditReport = () => {
		return hasPerms('TABLET_PIN_DOCUMENT', false);
	};

	const fetch = async () => {
		// setReport({
		//   _id: 0,
		//   title: 'This is a report title',
		//   notes: '<p><a title=\"sedfsdf\" href=\"https://google.com\">https://google.com</a></p>',
		//   author: {},
		//   lastUpdated: {
		//     SID: 3,
		//     Callsign: 302,
		//     First: 'Shit',
		//     Last: 'Cunt',
		//     Time: 1628967582 * 1000,
		//   }
		// });
		// return

		setLoading(true);
		try {
			let res = await (
				await Nui.send('BusinessDocumentView', {
					id: params.id,
				})
			).json();

			if (res) setReport(res);
			else toast.error('Unable to Load Document');
		} catch (err) {
			console.log(err);
			toast.error('Unable to Load Document');
			setErr(true);
		}
		setLoading(false);
	};

	useEffect(() => {
		fetch();
	}, []);

	return (
		<div>
			{loading || (!report && !err) ? (
				<div className={classes.wrapper} style={{ position: 'relative' }}>
					<Loader static text="Loading" />
				</div>
			) : err ? (
				<Grid className={classes.wrapper} container>
					<Grid item xs={12}>
						<Alert variant="outlined" severity="error">
							Invalid Document ID
						</Alert>
					</Grid>
				</Grid>
			) : (
				<>
					<Grid className={classes.wrapper} container spacing={2}>
						<Grid item xs={12}>
							<ButtonGroup fullWidth>
								<Button onClick={fetch} disabled={loading}>
									Refresh
								</Button>
								<Button disabled={!canEditReport} onClick={onEdit}>
									Edit Document
								</Button>
								{hasPerms('TABLET_DELETE_DOCUMENT', false) && <Button onClick={onDelete}>Delete Document</Button>}
							</ButtonGroup>
						</Grid>
						<Grid item xs={12}>
							<Grid container spacing={2}>
								<Grid item xs={6}>
									<ListItem>
										<ListItemText primary="Document Title" secondary={report.title} />
									</ListItem>
								</Grid>
								<Grid item xs={3}>
									<ListItemText
										primary={
											<span>
												Created <Moment date={report.time} fromNow />
											</span>
										}
										secondary={
											<span>
												By&nbsp;
												{`${report.author.First} ${report.author.Last} (${report.author.SID})`}
												&nbsp;on&nbsp;
												<Moment date={report.time} format="LLL" />
											</span>
										}
									/>
								</Grid>
								<Grid item xs={3}>
									{report.lastUpdated && (
										<ListItemText
											primary={
												<span>
													Last Updated <Moment date={report.lastUpdated?.Time} fromNow />
												</span>
											}
											secondary={
												<span>
													By&nbsp;
													{`${report.lastUpdated.First} ${report.lastUpdated.Last} (${report.lastUpdated.SID})`}
													&nbsp;on&nbsp;
													<Moment date={report.lastUpdated?.Time} format="LLL" />
												</span>
											}
										/>
									)}
								</Grid>
							</Grid>
							<Divider flexItem />
						</Grid>
						<Grid item xs={12}>
							<List>
								<ListItem>
									<ListItemText primary="Document" />
								</ListItem>
								<div className={classes.notes}>
									<UserContent wrapperClass={classes.notes} content={report.notes} />
								</div>
							</List>
						</Grid>
					</Grid>
				</>
			)}
		</div>
	);
};
