import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@material-ui/styles';
import { useHistory } from 'react-router-dom';
import { AppBar, Grid, Tooltip, IconButton, List, Tab, Tabs } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import DocumentList from './components/DocumentList';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	header: {
		background: '#696969',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
    content: {
		height: '83.5%',
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
		height: '97.5%',
	},
	list: {
		height: '100%',
		overflow: 'auto',
	}
}));

const YPTabs = withStyles((theme) => ({
	root: {
		borderBottom: '1px solid #696969',
	},
	indicator: {
		backgroundColor: '#696969',
	},
}))((props) => <Tabs {...props} />);

const YPTab = withStyles((theme) => ({
	root: {
		width: '50%',
		'&:hover': {
			color: '#696969',
			transition: 'color ease-in 0.15s',
		},
		'&$selected': {
			color: '#696969',
			transition: 'color ease-in 0.15s',
		},
		'&:focus': {
			color: '#696969',
			transition: 'color ease-in 0.15s',
		},
	},
	selected: {},
}))((props) => <Tab {...props} />);

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
    const history = useHistory();
	const documents = useSelector((state) => state.data.data.myDocuments);

    const [tab, setTab] = useState(0);

    const handleTabChange = (event, tab) => {
		setTab(tab);
	};

    const createNew = () => {
        history.push(`/apps/documents/view/doc/new`);
    };

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={7} style={{ lineHeight: '50px' }}>
						My Documents
					</Grid>
					<Grid item xs={5} style={{ textAlign: 'right' }}>
						<Tooltip title="Create">
							<span>
								<IconButton
									className={classes.headerAction}
                                    onClick={createNew}
								>
									<FontAwesomeIcon
										className={'fa'}
										icon={['fas', 'plus']}
									/>
								</IconButton>
							</span>
						</Tooltip>
					</Grid>
				</Grid>
			</AppBar>
            <div className={classes.content}>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 0}
					id="latest"
				>
					{tab === 0 && <DocumentList documents={documents} />}
				</div>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 1}
					id="categories"
				>
					{tab === 1 && <DocumentList documents={documents} showShared />}
				</div>
			</div>
            <div className={classes.tabs}>
				<YPTabs
					value={tab}
					onChange={handleTabChange}
					scrollButtons={false}
					centered
				>
					<YPTab label="My Documents" />
					<YPTab label="Shared With Me" />
				</YPTabs>
			</div>
		</div>
	);
};