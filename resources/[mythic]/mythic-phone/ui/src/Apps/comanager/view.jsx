import React, { useEffect, useState, useMemo, useCallback } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Tabs, Tab } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import { useHistory } from 'react-router';
import Nui from '../../util/Nui';
import { throttle } from 'lodash';
import { Loader } from '../../components';
import Management from './Management';
import Roster from './Roster';
import Upgrades from './Upgrades';
import TimeWorked from './TimeWorked';
import { useAlert, useJobPermissions } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
        overflow: 'hidden',
	},
	content: {
		height: '93.75%',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	tabPanel: {},
	phoneTab: {
		minWidth: '33.333%',
	},
	alert: {
		width: 'fit-content',
		margin: 'auto',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '35%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
    const sendAlert = useAlert();
    const history = useHistory();
	const hasPerm = useJobPermissions();

    const { jobId } = props.match.params;

    const [loading, setLoading] = useState(false);
    const [err, setErr] = useState(false);
    
	const player = useSelector((state) => state.data.data.player);
    const AllJobData = useSelector((state) => state.data.data.JobData);
	const activeTab = useSelector((state) => state.com.tab);

	const handleTabChange = (event, tab) => {
		dispatch({
			type: 'SET_COM_TAB',
			payload: { tab: tab },
		});
	};

    const playerJobData = player.Jobs.find(job => job.Id == jobId);
	const jobData = AllJobData.find(j => j.Id == playerJobData?.Id);
    if (!playerJobData || !jobData) {
        history.goBack();
    }

    const fetchRoster = useMemo(() => throttle(async () => {
		setLoading(true);
		try {
			let res = await (await Nui.send('FetchRoster', {
                ReqUpdate: true,
            })).json();

			if (res && res.rosterData) {
                dispatch({
                    type: 'UPDATE_ROSTERS',
                    payload: {
                        roster: res.rosterData,
                    },
                });

                if (res.jobData) {
                    dispatch({
                        type: 'SET_DATA',
                        payload: {
                            type: 'JobData',
                            data: res.jobData,
                        },
                    });
                }
			} else throw res;
		} catch (err) {
			console.log(err);
			sendAlert('Unable to Load Roster\'s');
			dispatch({
				type: 'UPDATE_ROSTERS',
				payload: {
					roster: false,
				},
			});
		}
		setLoading(false);
	}, 5000), []);

    if (loading) {
        return (
            <div className={classes.wrapper}>
                <Loader static text="Loading" />
            </div>
        );
    } else {
        return (
            <>
                {!err && playerJobData ? (
                    <div className={classes.wrapper}>
                        <div className={classes.content}>
                            <div
                                className={classes.tabPanel}
                                role="tabpanel"
                                hidden={activeTab !== 0}
                                id="notifications"
                            >
                                {activeTab === 0 && <Roster loading={loading} refreshRoster={() => fetchRoster()} jobData={jobData} playerJob={playerJobData} />}
                            </div>
                            <div
                                className={classes.tabPanel}
                                role="tabpanel"
                                hidden={activeTab !== 1}
                                id="person"
                            >
                                {activeTab === 1 && <Management refreshRoster={() => fetchRoster()} jobData={jobData} playerJob={playerJobData} />}
                            </div>
                            <div
                                className={classes.tabPanel}
                                role="tabpanel"
                                hidden={activeTab !== 2}
                                id="timeworked"
                            >
                                {activeTab === 2 && <TimeWorked refreshRoster={() => fetchRoster()} jobData={jobData} playerJob={playerJobData} />}
                            </div>
                            {/* <div
                                className={classes.tabPanel}
                                role="tabpanel"
                                hidden={activeTab !== 2}
                                id="upgrades"
                            >
                                {activeTab === 2 && <Upgrades refreshRoster={() => fetchRoster()} jobData={jobData} playerJob={playerJobData} />}
                            </div> */}
                        </div>
                        <div className={classes.tabs}>
                            <Tabs
                                value={activeTab}
                                onChange={handleTabChange}
                                indicatorColor="primary"
                                textColor="primary"
                                variant="fullWidth"
                                scrollButtons={false}
                            >
                                <Tab
                                    className={classes.phoneTab}
                                    label="Roster"
                                />
                                <Tab
                                    className={classes.phoneTab}
                                    disabled={!(hasPerm('JOB_MANAGEMENT', playerJobData.Id) || player.SID == jobData?.Owner)}
                                    label="Manage"
                                />
                                <Tab
                                    className={classes.phoneTab}
                                    disabled={!(hasPerm('JOB_MANAGEMENT', playerJobData.Id) || player.SID == jobData?.Owner)}
                                    label="Time Worked"
                                />
                            </Tabs>
                        </div>
                    </div>
                ) : (
                    <div className={classes.wrapper}>
                        <div className={classes.emptyMsg}>Error</div>
                    </div>
                )}
            </>
        );
    }

};