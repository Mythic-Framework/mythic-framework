import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import loadable from '@loadable/component';
import {
	AppBar,
	Grid,
	Tooltip,
	IconButton,
	List,
	Tab,
	Tabs,
} from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Navigation from './components/Navigation';
import TitleBar from './components/TitleBar';

import { useJobPermissions } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: '#E95200',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	content: {
		height: '100%',
		overflow: 'hidden',
	},
	headerAction: {},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	tabPanel: {
		top: 0,
		height: '93.25%',
	},
	list: {
		height: '100%',
		overflow: 'auto',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '18%',
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const hasJobPerm = useJobPermissions();

	const [currentPage, setCurrentPage] = useState('Dashboard');
	const [currentData, setCurrentData] = useState(null);
	const pages = useSelector((state) => state.data.data.businessPages);
	const hasAccess = useSelector((state) => state.data.data.businessLogo);

	const onNav = async (id, data) => {
		// TODO: Check Permissions to View Page
		if (pages && pages.find((p) => p.id == id)) {
			setCurrentData(data);
			setCurrentPage(id);
		} else {
			setCurrentData({});
			setCurrentPage('Dashboard');
		}
	};

	const getCurrentPage = () => {
		const Component = loadable(() => import(`./pages/${currentPage}`));

		return <Component onNav={onNav} data={currentData} />;
	};

	const pageComponent = useMemo(() => getCurrentPage(), [currentPage]);

	if (!hasAccess || !pages) {
		return (
			<div className={classes.wrapper}>
				<Grid
					container
					direction="row"
					style={{ height: '100%', overflow: 'hidden' }}
				>
					<div className={classes.emptyMsg}>
						<span style={{ fontSize: 75 }}>
							<FontAwesomeIcon icon={['fas', 'business-time']} />
						</span>
						<br></br>
						<br></br>
						Must Be Clocked In at a Participating Business
					</div>
				</Grid>
			</div>
		);
	}

	return (
		<div className={classes.wrapper}>
			<Grid
				container
				direction="row"
				style={{ height: '100%', overflow: 'hidden' }}
			>
				<Grid item xs={2}>
					<TitleBar />
					<Navigation
						current={currentPage}
						items={pages}
						onNavSelect={onNav}
					/>
				</Grid>
				<Grid item xs={10}>
					{pageComponent}
				</Grid>
			</Grid>
		</div>
	);
};
