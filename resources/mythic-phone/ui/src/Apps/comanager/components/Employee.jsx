import React from 'react';
import { useSelector } from 'react-redux';
import {
	ListItem,
	ListItemText,
	ListItemAvatar,
	Avatar,
	Tooltip,
	ListItemSecondaryAction,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useJobPermissions, useMyJob } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	item: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-child': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	avatar: {
		backgroundColor: theme.palette.primary.main,
	},
	myself: {
		fontSize: 14,
		color: theme.palette.info.main,
		marginRight: 5,
	},
	owner: {
		fontSize: 14,
		color: 'gold',
		marginRight: 5,
	},
}));

export default ({ jobData, playerJob, employee, onClick }) => {
	const classes = useStyles();
	const hasPerm = useJobPermissions();
	const isMyJob = useMyJob();
	const player = useSelector((state) => state.data.data.player);

	const isOwner = player.SID == jobData?.Owner;
	const manageCompany = hasPerm('JOB_MANAGEMENT', jobData.Id) || isOwner;
	const manageEmployees = hasPerm('JOB_MANAGE_EMPLOYEES', jobData.Id) || isOwner;
	const hireEmployee = hasPerm('JOB_HIRE', jobData.Id) || isOwner;
	const fireEmployee = hasPerm('JOB_FIRE', jobData.Id) || isOwner;

	return (
		<ListItem
			className={classes.item}
			button={
				(jobData?.Owner != employee.SID || isOwner) 
				&& (playerJob.Grade.Level > employee.JobData.Grade.Level || isOwner)
				&& (manageCompany || manageEmployees || fireEmployee)
			}
			onClick={
				(jobData?.Owner != employee.SID || isOwner) 
				&& (playerJob.Grade.Level > employee.JobData.Grade.Level || isOwner)
				&& (manageCompany || manageEmployees || fireEmployee)
				? () => onClick(employee)
				: null
			}
		>
			<ListItemAvatar>
				<Avatar className={classes.avatar}>
					<FontAwesomeIcon icon={['fas', 'user']} />
				</Avatar>
			</ListItemAvatar>
			<ListItemText
				primary={
					<span>
						{player.SID == employee.SID ? (
							<Tooltip title="You">
								<span>
									<FontAwesomeIcon
										className={classes.myself}
										icon={['fas', 'user']}
									/>
								</span>
							</Tooltip>
						) : jobData?.Owner == employee.SID ? (
							<Tooltip title="Business Owner">
								<span>
									<FontAwesomeIcon
										className={classes.owner}
										icon={['fas', 'crown']}
									/>
								</span>
							</Tooltip>
						) : null}
						{`${employee.First} ${employee.Last}`}
					</span>
				}
				secondary={`${employee.JobData.Grade.Name} - ${employee.Phone}`}
			/>
			{jobData.Owner != employee._id &&
				(playerJob.Grade.Level > employee.JobData.Grade.Level || isOwner)
				&& (manageCompany || manageEmployees || fireEmployee)
				&& (
					<ListItemSecondaryAction>
						<FontAwesomeIcon icon={['fas', 'pen-to-square']} />
					</ListItemSecondaryAction>
				)}
		</ListItem>
	);
};
