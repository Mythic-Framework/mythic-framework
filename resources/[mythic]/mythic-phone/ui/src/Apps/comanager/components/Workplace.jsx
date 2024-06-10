import React from 'react';
import { useSelector } from 'react-redux';
import { List, ListItem, ListItemText } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import Employee from './Employee';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		background: theme.palette.secondary.dark,
		width: '90%',
		margin: 'auto',
	},
}));

export default ({ jobData, playerJob, workplace, onEmployeeClick }) => {
	const classes = useStyles();
	const roster = useSelector((state) => state.com.roster);

	let filtered = Array();
	if (Boolean(roster) && roster[jobData.Id]) {
		if (workplace) {
			filtered = roster[jobData.Id].filter((p) => p.JobData.Workplace?.Id == workplace.Id);
		} else {
			filtered = roster[jobData.Id];
		}
	};

	if (filtered.length == 0) return null;
	return (
		<List>
			{workplace && <ListItem>
				<ListItemText primary={workplace.Name} />
			</ListItem>}
			<ListItem>
				<List style={{ width: '100%' }}>
					{filtered
						.sort((a, b) => b.JobData.Grade.Level - a.JobData.Grade.Level)
						.map((person) => {
							return (
								<Employee
									key={person.SID}
									jobData={jobData}
									playerJob={playerJob}
									employee={person}
									onClick={onEmployeeClick}
								/>
							);
						})}
				</List>
			</ListItem>
		</List>
	);
};
