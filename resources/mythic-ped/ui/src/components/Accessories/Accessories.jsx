import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { AppBar, Tab, Tabs } from '@mui/material';

import Wrapper from '../UIComponents/Wrapper/Wrapper';
import { TabPanel } from '../UIComponents';
import Props from './Props';
import Misc from './Misc';

export default (props) => {
	const ped = useSelector((state) => state.app.ped);
	const [value, setValue] = useState(0);

	const handleChange = (event, newValue) => {
		setValue(newValue);
	};

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
					<Tab label="Props" />
					<Tab label="Misc" />
				</Tabs>
			</AppBar>
			<TabPanel value={value} index={0}>
				<Props />
			</TabPanel>
			<TabPanel value={value} index={1}>
				<Misc />
			</TabPanel>
		</Wrapper>
	);
};
