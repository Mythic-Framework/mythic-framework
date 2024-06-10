import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { useHistory } from 'react-router-dom';
import { Tab, Tabs } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { throttle } from 'lodash';

import ChopList from './ChopList';
import Reputations from './Reputations';
import { useReputation } from '../../hooks';
import Nui from '../../util/Nui';
import Market from './Market';
import Boosting from './Boosting';
import BoostingMarket from './BoostingMarket';

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
		height: '94.5%',
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
		width: '20%',
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

	const [loading, setLoading] = useState(false);
	const [tab, setTab] = useState(0);

	const [chops, setChops] = useState(Array());
	const [reps, setReps] = useState(Array());
	const [items, setItems] = useState(Array());

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
						setItems(res.items);
					} else {
						setChops(Array());
						setReps(Array());
						setItems(Array());
					}
				} catch (err) {
					console.log(err);
					setChops(Array());
					setReps(Array());
					setItems([
						{
							id: 1,
							item: 'racing_crappy',
							itemData: {
								name: 'racing_crappy',
								label: 'Homemade Phone Dongle',
							},
							coin: 'PLEB',
							price: 10,
						},
					]);
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
			<div className={classes.content}>
				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 0}
					id="boosting"
				>
					{tab === 0 && <Boosting />}
				</div>

				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 1}
					id="boosting_market"
				>
					{tab === 1 && <BoostingMarket />}
				</div>

				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 2}
					id="latest"
				>
					{tab === 2 && <ChopList chopList={chops} />}
				</div>

				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 3}
					id="market"
				>
					{tab === 3 && <Market items={items} />}
				</div>

				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 4}
					id="categories"
				>
					{tab === 4 && <Reputations myReputations={reps} />}
				</div>

				<div className={classes.tabs}>
					<YPTabs
						value={tab}
						onChange={handleTabChange}
						scrollButtons={false}
						centered
					>
						<YPTab
							icon={<FontAwesomeIcon icon={['fab', 'nimblr']} />}
						/>
						<YPTab
							icon={
								<FontAwesomeIcon
									icon={['fas', 'file-contract']}
								/>
							}
						/>
						<YPTab
							icon={
								<FontAwesomeIcon
									icon={['fas', 'screwdriver-wrench']}
								/>
							}
						/>
						<YPTab
							icon={<FontAwesomeIcon icon={['fas', 'gavel']} />}
						/>
						<YPTab
							icon={
								<FontAwesomeIcon
									icon={['fas', 'list-timeline']}
								/>
							}
						/>
					</YPTabs>
				</div>
			</div>
		</div>
	);
};
