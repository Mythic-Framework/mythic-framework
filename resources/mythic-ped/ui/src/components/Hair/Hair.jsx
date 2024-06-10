import React, { useEffect, useState } from 'react';
import Wrapper from '../UIComponents/Wrapper/Wrapper';
import { AppBar, Tab, Tabs } from '@mui/material';
import { TabPanel } from '../UIComponents';
import HeadHair from './HeadHair/HeadHair';
import BodyHair from './BodyHair/BodyHair';
import FaceHair from './FaceHair/FaceHair';
import Nui from '../../util/Nui';

export default (props) => {
	const [value, setValue] = useState(0);
	useEffect(() => {
		Nui.send('GetNumHairColors');
	}, []);
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
					<Tab label="Head" />
					<Tab label="Face" />
					<Tab label="Body" />
				</Tabs>
			</AppBar>
			<TabPanel value={value} index={0}>
				<HeadHair />
			</TabPanel>
			<TabPanel value={value} index={1}>
				<FaceHair />
			</TabPanel>
			<TabPanel value={value} index={2}>
				<BodyHair />
			</TabPanel>
		</Wrapper>
	);
};
