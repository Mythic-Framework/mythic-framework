import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useHistory } from 'react-router';
import {
	List,
	AppBar,
	Grid,
	IconButton,
	Tooltip,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { throttle } from 'lodash';
import Truncate from 'react-truncate';
import { Loader } from '../../components';
import moment from 'moment';

import Nui from '../../util/Nui';
import { useAlert, useJobPermissions } from '../../hooks';
import { Modal, Confirm } from '../../components';
import TimeWorkedEmployee from './components/TimeWorkedEmployee';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	header: {
		background: theme.palette.primary.main,
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
		height: 78,
	},
	headerAction: {
		textAlign: 'right',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	item: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
	},
}));

const parseDutyTime = (dutyTime, job) => {
	if (dutyTime && dutyTime[job]) {
		const afterTime = moment().subtract(7, 'days').unix();
		let timeWorked = 0;
		dutyTime[job].forEach(t => {
			if (t.time >= afterTime) {
				timeWorked += t.minutes;
			}
		});

		if (timeWorked > 0) {
			return moment.duration(timeWorked, "minutes").humanize();
		} else {
			return '0 minutes';
		}
	
	} else {
		return '0 minutes';
	}
}

const parseLastDutyTime = (lastDuty, job) => {
	if (lastDuty && lastDuty[job]) {
		return `${moment(lastDuty[job] * 1000).format('LLL')} (${moment(lastDuty[job] * 1000).fromNow()})`;
	} else {
		return 'Never';
	}
}

export default ({ jobData, playerJob }) => {
	const classes = useStyles();
	const history = useHistory();
	const dispatch = useDispatch();
	const sendAlert = useAlert();

	const timeWorked = useSelector((state) => state.com.timeWorked);
	const timeWorkedUpdated = useSelector((state) => state.com.timeWorkedUpdated);
	const timeWorkedJob = useSelector((state) => state.com.timeWorkedJob);

	const [loading, setLoading] = useState(false);

	const home = () => {
		history.goBack();
	};

	const fetchTimeWorked = useMemo(() => throttle(async () => {
		setLoading(true);
		try {
			let res = await (await Nui.send('FetchTimeWorked', jobData.Id)).json();

			if (res) {
				dispatch({
					type: 'UPDATE_TIMEWORKED',
					payload: {
						timeWorked: res,
						timeWorkedJob: jobData.Id,
					},
				});
			} else throw res;
		} catch (err) {
			console.log(err);
			sendAlert('Unable to Load Time Worked');
		}

		setLoading(false);
	}, 5000), []);

	useEffect(() => {
		if (!timeWorked || (Date.now() - timeWorkedUpdated) >= 120000 || timeWorkedJob != jobData.Id) {
			fetchTimeWorked();
		}
    }, []);

	const [viewing, setViewing] = useState(null);

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={11}>
						<Truncate lines={1}>{jobData.Name}</Truncate>
					</Grid>
					<Grid item xs={1} className={classes.headerAction}>
						<Tooltip title="Home">
							<IconButton onClick={home}>
								<FontAwesomeIcon icon={['fas', 'house']} />
							</IconButton>
						</Tooltip>
					</Grid>
				</Grid>
			</AppBar>
				{timeWorked && timeWorked.length > 0 ? 
					timeWorked.map(employee => {
						return (
							<TimeWorkedEmployee
								key={employee.SID}
								employee={employee}
								jobData={jobData}
								onClick={(e) =>
									setViewing(employee)
								}
							/>
						);
					}) 
					: <Loader static text="Loading" />
				}

				<Modal
					open={viewing != null}
					title={'View Time Worked'}
					onClose={() => setViewing(null)}
					onAccept={null}
					onDelete={null}
				>
					{viewing != null && <>
						<p>{viewing.First} {viewing.Last} ({viewing.SID})</p>
						<p>Last Went on Duty: {parseLastDutyTime(viewing.LastClockOn, jobData.Id)}</p>
						<p>Has worked {parseDutyTime(viewing.TimeClockedOn, jobData.Id)} in the last week.</p>
					</>}
				</Modal>
		</div>
	);
};
