import React, { useState, useEffect, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Tabs, Tab } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { throttle } from 'lodash';

import Nui from '../../util/Nui';
import { useMyStates } from '../../hooks';
import Jobs from './Jobs';
import Groups from './Groups';
import Reputations from './Reputations';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	content: {
		height: '93.75%',
	},
	tabPanel: {
		height: '100%',
	},
	phoneTab: {
		minWidth: '25%',
	},
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const hasState = useMyStates();
	const player = useSelector((state) => state.data.data.player);
	const activeTab = useSelector((state) => state.labor.tab);

	const handleTabChange = (_, tab) => {
		dispatch({
			type: 'SET_LABOR_TAB',
			payload: { tab: tab },
		});
	};

	const [loading, setLoading] = useState(false);
	const [jobs, setJobs] = useState(null);
	const [filtered, setFiltered] = useState(null);
	const [illegal, setIllegal] = useState(null);
	const [groups, setGroups] = useState(null);
	const [myGroup, setMyGroup] = useState(null);
	const [myReputations, setMyReputations] = useState(null);

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (await Nui.send('GetLaborDetails')).json();
					if (res) {
						setJobs(res.jobs);
						setGroups(res.groups);
						setMyReputations(res.reputations);
					} else {
						setJobs(Array());
						setGroups(Array());
						setMyReputations(Array());
					}
				} catch (err) {
					console.log(err);
					setJobs(Object());
					setGroups(Array());
					// setMyReputations([
					// 	{
					// 		id: 'mining',
					// 		label: 'Mining',
					// 		value: 500,
					// 		next: {
					// 			label: 'Rank 1',
					// 			value: 500,
					// 		},
					// 	},
					// ]);
					setMyReputations(Array());
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	useEffect(() => {
		if (!Boolean(groups)) return;
		setMyGroup(
			groups.filter(
				(wg) =>
					wg?.Creator?.ID == player.Source ||
					(Boolean(wg?.Members) &&
						wg?.Members.filter((m) => m.ID == player.Source)
							.length > 0),
			)[0],
		);
	}, [groups]);

	useEffect(() => {
		if (!Boolean(jobs) || !Boolean(player) || loading) return;
		setFiltered(
			Object.keys(jobs)
				.filter((k) => !jobs[k].Restricted)
				.reduce((obj, key) => {
					obj[key] = jobs[key];
					return obj;
				}, {}),
		);
	}, [jobs, player, loading]);

	useEffect(() => {
		if (!Boolean(jobs) || !Boolean(player) || loading) return;
		if (Object.keys(jobs).length > 0) {
			setIllegal(
				Object.keys(jobs)
					.filter(
						(k) =>
							Boolean(jobs[k].Restricted) &&
							Boolean(jobs[k].Restricted?.state) &&
							hasState(jobs[k].Restricted.state),
					)
					.reduce((obj, key) => {
						obj[key] = jobs[key];
						return obj;
					}, {}),
			);
		} else setIllegal(null);
	}, [jobs, player, loading]);

	return (
		<div className={classes.wrapper}>
			<div className={classes.content}>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={activeTab !== 0}
					id="jobs"
				>
					{activeTab === 0 && (
						<Jobs
							jobs={filtered}
							groups={groups}
							myGroup={myGroup}
							loading={loading}
							onRefresh={fetch}
						/>
					)}
				</div>
				{Boolean(illegal) && Object.keys(illegal).length > 0 && (
					<div
						className={classes.tabPanel}
						role="tabpanel"
						hidden={activeTab !== 1}
						id="illegal"
					>
						{activeTab === 1 && (
							<Jobs
								jobs={illegal}
								groups={groups}
								myGroup={myGroup}
								loading={loading}
								onRefresh={fetch}
							/>
						)}
					</div>
				)}
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={
						activeTab !==
						(Boolean(illegal) && Object.keys(illegal).length > 0 ? 2 : 1)
					}
					id="groups"
				>
					{activeTab === (Boolean(illegal) && Object.keys(illegal).length > 0)
						? 2
						: 1 && (
							<Groups
								groups={groups}
								myGroup={myGroup}
								loading={loading}
								onRefresh={fetch}
							/>
						  )}
				</div>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={
						activeTab !==
						(Boolean(illegal) && Object.keys(illegal).length > 0 ? 3 : 2)
					}
					id="groups"
				>
					{activeTab === (Boolean(illegal) && Object.keys(illegal).length > 0)
						? 3
						: 2 && (
							<Reputations
								myReputations={myReputations}
								loading={loading}
								onRefresh={fetch}
							/>
						  )}
				</div>
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
					<Tab className={classes.phoneTab} label="Jobs" />
					{Boolean(illegal) && Object.keys(illegal).length > 0 && (
						<Tab className={classes.phoneTab} label="Restricted" />
					)}
					<Tab className={classes.phoneTab} label="Groups" />
					<Tab className={classes.phoneTab} label="Reputation" />
				</Tabs>
			</div>
		</div>
	);
};
