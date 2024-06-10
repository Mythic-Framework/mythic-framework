import React from 'react';
import { useSelector } from 'react-redux';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Route, Routes } from 'react-router';

import links from './links';
import { Navbar, ErrorBoundary } from '../../components';
import Titlebar from '../../components/Titlebar';

import { PenalCode, Error, SearchWarrants } from '../../pages/Shared';
import { Landing } from '../../pages/Public';

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
}));

export default () => {
	const classes = useStyles();
	const job = useSelector((state) => state.app.govJob);

	return (
		<div className={classes.container}>
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
								<Route exact path="/" element={<Landing />} />
								<Route exact path="/warrants" element={<SearchWarrants />} />
								<Route exact path="/penal-code" element={<PenalCode />} />
								<Route element={<Error />} />
							</Routes>
						</div>
					</ErrorBoundary>
				</Grid>
			</Grid>
		</div>
	);
};
