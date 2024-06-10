import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { AppBar, Tab, Tabs } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Nui from '../../util/Nui';
import Wrapper from '../UIComponents/Wrapper/Wrapper';
import { TabPanel } from '../UIComponents';
import { Tattoo } from '../PedComponents';
import { Zones } from './Data';

const useStyles = makeStyles((theme) => ({
	count: {
		fontSize: 18,
		fontFamily: 'monospace',
	},
	highlight: {
		color: theme.palette.primary.main,
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const ped = useSelector((state) => state.app.ped);
	const [value, setValue] = useState(0);

	const handleChange = (event, newValue) => {
		setValue(newValue);
	};

	useEffect(() => {
		dispatch({
			type: 'FORCE_NEKKED',
			payload: { state: true },
		});

		return () => {
			dispatch({
				type: 'FORCE_NEKKED',
				payload: { state: false },
			});
		};
	}, []);

	return (
		<Wrapper>
			<AppBar
				position="static"
				color="secondary"
				style={{ paddingBottom: 15 }}
			>
				<Tabs
					value={value}
					onChange={handleChange}
					variant="scrollable"
					indicatorColor="primary"
					textColor="primary"
				>
					{Object.keys(Zones).map((zone) => {
						return (
							<Tab
								key={`tattootab-${zone}`}
								label={Zones[zone]}
							/>
						);
					})}
				</Tabs>
			</AppBar>
			<div className={classes.count}>
				<span>
					<span className={classes.highlight}>
						{ped.customization.tattoos.length}
					</span>
					/<span className={classes.highlight}>25</span> Tattoos
				</span>
			</div>
			{Object.keys(Zones).map((zone, k) => {
				return (
					<TabPanel
						key={`tattoopanel-${zone}`}
						value={value}
						index={k}
					>
						<Tattoo
							label={Zones[zone]}
							data={{
								type: zone,
							}}
							current={ped.customization.tattoos}
						/>
					</TabPanel>
				);
			})}
		</Wrapper>
	);
};
