import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import { Tab, Tabs } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { throttle } from 'lodash';

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
		height: '92.25%',
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
	const visible = useSelector((state) => state.laptop.visible);
	const [tab, setTab] = useState(0);

	const [reps, setReps] = useState(Array());
	const [items, setItems] = useState(Array());
	const [banned, setBanned] = useState(null);
	const [canBoost, setCanBoost] = useState(false);

	const fetch = useMemo(
		() =>
			throttle(async () => {
				if (loading) return;
				setLoading(true);
				try {
					let res = await (await Nui.send('GetLSUDetails')).json();
					if (res) {
						setReps(res.reputations);
						setItems(res.items);
						setBanned(res.banned);
						setCanBoost(res.canBoost);
					} else {
						setReps(Array());
						setItems(Array());
						setBanned(null);
						setCanBoost(false);
					}
				} catch (err) {
					console.log(err);
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
							qty: 3,
						},
					]);
					//setBanned(["Boosting"])
					setCanBoost(true);
				}
				setLoading(false);
			}, 1000),
		[],
	);

	useEffect(() => {
		fetch();
	}, []);

	useEffect(() => {
		if (visible) {
			fetch();
		}
	}, [visible]);

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
					{tab === 0 && <Boosting canBoost={canBoost} banned={banned} reputations={reps} />}
				</div>

				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 1}
					id="boosting_market"
				>
					{tab === 1 && <BoostingMarket banned={banned} />}
				</div>

				<div
					className={classes.tabPanel}
					role="tabpanel"
					hidden={tab !== 3}
					id="market"
				>
					{tab === 3 && <Market banned={banned} items={items} />}
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
							disabled
							icon={
								<FontAwesomeIcon
									icon={['fas', 'file-contract']}
								/>
							}
						/>
						<YPTab // shitty chopping
							disabled
							icon={
								<FontAwesomeIcon
									icon={['fas', 'screwdriver-wrench']}
								/>
							}
						/>
						<YPTab
							icon={<FontAwesomeIcon icon={['fas', 'cart-shopping']} />}
						/>
						<YPTab
							icon={
								<FontAwesomeIcon
									icon={['fas', 'list']}
								/>
							}
						/>
					</YPTabs>
				</div>
			</div>
		</div>
	);
};
