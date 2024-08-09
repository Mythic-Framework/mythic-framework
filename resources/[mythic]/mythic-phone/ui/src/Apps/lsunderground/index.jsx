import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@material-ui/styles';
import { useHistory } from 'react-router-dom';
import {
	AppBar,
	Grid,
	Tooltip,
	IconButton,
	List,
	Tab,
	Tabs,
} from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { throttle } from 'lodash';

import ChopList from './ChopList';
import Reputations from './Reputations';
import { useReputation } from '../../hooks';
import Nui from '../../util/Nui';

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
	},
}));

const YPTabs = withStyles((theme) => ({
	root: {
		borderBottom: '1px solid #E95200',
	},
	indicator: {
		backgroundColor: '#E95200',
	},
}))((props) => <Tabs {...props} />);

const YPTab = withStyles((theme) => ({
	root: {
		width: '50%',
		'&:hover': {
			color: '#E95200',
			transition: 'color ease-in 0.15s',
		},
		'&$selected': {
			color: '#E95200',
			transition: 'color ease-in 0.15s',
		},
		'&:focus': {
			color: '#E95200',
			transition: 'color ease-in 0.15s',
		},
	},
	selected: {},
	disabled: {
		color: '#333333 !important',
		transition: 'color ease-in 0.15s',
	},
}))((props) => <Tab {...props} />);

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useHistory();
	const hasRep = useReputation();

	const [loading, setLoading] = useState(false);
	const [tab, setTab] = useState(0);

	const [chops, setChops] = useState(Array());
	const [reps, setReps] = useState(Array());

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (await Nui.send('GetLSUDetails')).json();
					if (res) {
						setChops(res.chopList);
						setReps(res.reputations);
					} else {
						setChops(Array());
						setReps(Array());
					}
				} catch (err) {
					console.log(err);
					setChops(Array());
					setReps(Array());
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	const handleTabChange = (event, tab) => {
		setTab(tab);
	};

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={7} style={{ lineHeight: '50px' }}>
						LS Underground
					</Grid>
					<Grid item xs={5} style={{ textAlign: 'right' }}>
						<Tooltip title="Refresh">
							<span>
								<IconButton
									className={classes.headerAction}
									onClick={fetch}
								>
									<FontAwesomeIcon
										className={`fa ${
											loading ? 'fa-spin' : ''
										}`}
										icon={['fas', 'arrows-rotate']}
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
					{tab === 0 && <ChopList chopList={chops} />}
				</div>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 1}
					id="categories"
				>
					{tab === 1 && <Reputations myReputations={reps} />}
				</div>
			</div>
			<div className={classes.tabs}>
				<YPTabs
					value={tab}
					onChange={handleTabChange}
					scrollButtons={false}
					centered
				>
					<YPTab
						icon={
							<FontAwesomeIcon
								icon={['fas', 'screwdriver-wrench']}
							/>
						}
					/>
					<YPTab
						icon={
							<FontAwesomeIcon icon={['fas', 'list']} />
						}
					/>
				</YPTabs>
			</div>
		</div>
	);
};
