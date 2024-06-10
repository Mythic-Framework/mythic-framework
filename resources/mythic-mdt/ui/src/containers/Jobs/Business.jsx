import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { Grid } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Route, Routes } from 'react-router';

import links from './links';
import { Navbar, ErrorBoundary } from '../../components';
import Titlebar from '../../components/Titlebar';

import { Error } from '../../pages/Shared';
import { 
	Dashboard,
	CreateNotice,
	CreateDocument,
	SearchDocument, ViewDocument,
	CreateReceipt,
	SearchReceipt,
	ReceiptCount,
	ViewReceipt,
	PDMSales,
	PDMCredit,
	PDMManage,
	PDMSalesHistory,
	Dyn8Properties,
	Dyn8Credit,
	CasinoBigWins,
} from '../../business';
import { usePermissions } from '../../hooks';

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
	const hasPerm = usePermissions();
	const tabletData = useSelector(state => state.app.tabletData);
	const permissions = useSelector(state => state.app.govJobPermissions);

	const [links, setLinks] = useState(Array());

	useEffect(() => {
		setLinks(tabletData?.links?.filter(l => !l.permission || hasPerm(l.permission, false)))
	}, [tabletData, permissions]);

	return (
		<div className={classes.container}>
			<Grid container className={classes.maxHeight}>
				<Grid item xs={12}>
					<Titlebar />
				</Grid>
				<Grid item xs={2} className={classes.wrapper}>
					<Navbar links={links} />
				</Grid>
				<Grid item xs={10} className={classes.wrapper}>
					<ErrorBoundary>
						<div className={classes.content}>
							<Routes>
								<Route exact path="/" element={<Dashboard />} />
								<Route exact path="/business/create/notice" element={<CreateNotice />} />

								<Route exact path="/business/create/document" element={<CreateDocument />} />
								<Route exact path="/business/create/document/:id" element={<CreateDocument />} />
								<Route exact path="/business/search/document" element={<SearchDocument />} />
								<Route exact path="/business/search/document/:id" element={<ViewDocument />} />

								<Route exact path="/business/create/receipt" element={<CreateReceipt />} />
								<Route exact path="/business/create/receipt/:id" element={<CreateReceipt />} />
								<Route exact path="/business/search/receipt" element={<SearchReceipt />} />
								<Route exact path="/business/search/receipt-count" element={<ReceiptCount />} />
								<Route exact path="/business/search/receipt/:id" element={<ViewReceipt />} />

								<Route exact path="/business/pdm-sales" element={<PDMSales />} />
								<Route exact path="/business/pdm-credit" element={<PDMCredit />} />
								<Route exact path="/business/pdm-manage" element={<PDMManage />} />
								<Route exact path="/business/pdm-saleshistory" element={<PDMSalesHistory />} />
								<Route exact path="/business/dyn8-properties" element={<Dyn8Properties />} />
								<Route exact path="/business/dyn8-credit" element={<Dyn8Credit />} />

								<Route exact path="/business/casino-big-wins" element={<CasinoBigWins />} />
								
								<Route element={<Error />} />
							</Routes>
						</div>
					</ErrorBoundary>
				</Grid>
			</Grid>
		</div>
	);
};
