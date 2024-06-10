import React from 'react';
import { useSelector } from 'react-redux';
import { Grid, Alert } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Route, Routes } from 'react-router';

import links from './links';
import { Navbar, AdminRoute, ErrorBoundary } from '../../components';

import {
	PenalCode,
	Error,
	CreateReport,
	ViewPerson,
	ViewVehicle,
	ViewFirearm,
	ViewReport,
	ViewWarrant,
	SearchPeople,
	SearchVehicle,
	SearchProperty,
	SearchFirearm,
	SearchReport,
	SearchWarrants,
	SearchEvidence,
	RosterIndex,
	PermissionManager,
} from '../../pages/Shared';

import { Dashboard, CreateBOLO } from '../../pages/Police';

import { AdminMetrics, AdminCharges, AdminTags, AdminRoster, AdminNotice } from '../../pages/Admin';
import Titlebar from '../../components/Titlebar';
import SOPs from '../../pages/Police/SOPs';
import Comms from '../../pages/Police/Comms';

const useStyles = makeStyles((theme) => ({
	container: {
		height: '100%',
	},
	wrapper: {
		height: '100%',
	},
	content: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	maxHeight: {
		height: 'calc(100% - 86px)',
	},
	noCallsign: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
}));

export default () => {
	const classes = useStyles();
	const user = useSelector((state) => state.app.user);
	const job = useSelector((state) => state.app.govJob);

	return (
		<div className={classes.container}>
			{!user.Callsign ? (
				<Alert variant="filled" severity="error" className={classes.noCallsign}>
					<p>
						Your callsign has not yet been assigned, in order to access the Electronic Records System you
						will need to have a callsign.
					</p>
					<p>If you're not sure why you're seeing this message, contact a superior.</p>
				</Alert>
			) : (
				<Grid container className={classes.maxHeight}>
					<Grid item xs={12}>
						<Titlebar />
					</Grid>
					<Grid item xs={2} className={classes.wrapper}>
						<Navbar links={links(job?.Id)} />
					</Grid>
					<Grid item xs={10} className={classes.wrapper}>
						<ErrorBoundary>
							<div className={classes.content}>
								<Routes>
									<Route exact path="/search/people" element={<SearchPeople />} />
									<Route exact path="/search/vehicles" element={<SearchVehicle />} />
									<Route exact path="/search/properties" element={<SearchProperty />} />
									<Route exact path="/search/firearms" element={<SearchFirearm />} />
									<Route exact path="/search/reports" element={<SearchReport />} />
									<Route exact path="/search/evidence" element={<SearchEvidence />} />
									<Route exact path="/create/report" element={<CreateReport />} />
									<Route exact path="/create/bolo" element={<CreateBOLO />} />
									<Route exact path="/search/people/:id" element={<ViewPerson />} />
									<Route exact path="/search/vehicles/:id" element={<ViewVehicle />} />
									<Route exact path="/search/firearms/:id" element={<ViewFirearm />} />
									<Route exact path="/search/reports/:id" element={<ViewReport />} />
									<Route exact path="/warrants/:id" element={<ViewWarrant />} />
									<Route exact path="/warrants" element={<SearchWarrants />} />
									<Route exact path="/roster" element={<RosterIndex />} />
									<Route exact path="/sops" element={<SOPs />} />
									<Route exact path="/comms" element={<Comms />} />
									<Route exact path="/penal-code" element={<PenalCode />} />

									<Route path="/system" element={<AdminRoute permission={true} />}>
										<Route index element={<AdminMetrics />} />
										<Route exact path="charges" element={<AdminCharges />} />
										<Route exact path="tags" element={<AdminTags />} />
										<Route exact path="gov-roster" element={<AdminRoster />} />
										<Route
											exact
											path="gov-permissions"
											element={<PermissionManager job="system" />}
										/>
									</Route>

									<Route exact path="create/notice" element={<AdminNotice />} />

									<Route path="/admin" element={<AdminRoute permission={'PD_HIGH_COMMAND'} />}>
										<Route index element={<AdminMetrics />} />
										<Route exact path="permissions" element={<PermissionManager job="police" />} />
									</Route>
									<Route exact path="/" element={<Dashboard />} />
									<Route element={<Error />} />
								</Routes>
							</div>
						</ErrorBoundary>
					</Grid>
				</Grid>
			)}
		</div>
	);
};
