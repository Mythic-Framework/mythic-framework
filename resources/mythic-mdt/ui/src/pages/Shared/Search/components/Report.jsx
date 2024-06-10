import React from 'react';
import { ListItem, ListItemText, Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useNavigate } from 'react-router';
import { ReportTypes, GetOfficerNameFromReportType, GetOfficerJobFromReportType } from '../../../../data';
import { TitleCase } from '../../../../util/Parser';
import { usePerson } from '../../../../hooks';

import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
}));

export default ({ report }) => {
	const classes = useStyles();
	const history = useNavigate();
	const formatPerson = usePerson();

	const onClick = () => {
		history(`/search/reports/${report._id}`);
	};

	const reportTypeName = ReportTypes.find(r => r.value == report.type)?.label ?? 'Incident Report';
	const reporterName = GetOfficerNameFromReportType(report.type);

	return (
		<ListItem className={classes.wrapper} button onClick={onClick}>
			<Grid container spacing={1}>
				<Grid item xs={3}>
					<ListItemText primary={`Case #${report.ID ?? 0}`} secondary={report.title} />
				</Grid>
				<Grid item xs={2}>
					<ListItemText primary="Type" secondary={reportTypeName} />
				</Grid>
				<Grid item xs={2}>
					{report.suspects.length == 1 ? (
						<ListItemText
							primary={report.type === 0 ? "Suspects" : "People Involved"}
							secondary={`${report.suspects[0].suspect?.[0]?.First} ${report.suspects[0].suspect?.[0]?.Last}`}
						/>
					) : (
						<ListItemText
							primary={report.type === 0 ? "Suspects" : "People Involved"}
							secondary={`${report.suspects.length} ${report.type === 0 ? "Suspects" : "People Involved"}`}
						/>
					)}
				</Grid>
				<Grid item xs={4}>
					<ListItemText
						primary={report.type === 0 ? `Primary ${reporterName}` : `${reporterName} Involved`}
						secondary={`${report.primaries
							.slice(0, 2)
							.map((o) => {
								return formatPerson(o.First, o.Last, o.Callsign, o.SID, false, true);
							})
							.join(', ')}${
							report.primaries.length - 2 > 0
								? ` +${report.primaries.length - 2}`
								: ''
						}`}
					/>
				</Grid>
				<Grid item xs={1}>
					<ListItemText
						primary="Created"
						secondary={<Moment date={report.time} fromNow />}
					/>
				</Grid>
			</Grid>
		</ListItem>
	);
};
