import React, { useState } from 'react';
import { connect } from 'react-redux';
import { AppBar, Tab, Tabs } from '@mui/material';
import { makeStyles } from '@mui/styles';

import { TabPanel } from '../UIComponents';
import FaceShape from './FaceShape/FaceShape';
import Wrapper from '../UIComponents/Wrapper/Wrapper';
import FaceFeatures from './FaceFeatures/FaceFeatures';
import FaceOverlays from './FaceOverlays/FaceOverlays';

const useStyles = makeStyles((theme) => ({}));

export default connect()(() => {
	const classes = useStyles();
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
					<Tab label="Shape" />
					<Tab label="Features" />
					<Tab label="Skin" />
				</Tabs>
			</AppBar>
			<TabPanel value={value} index={0}>
				<FaceShape />
			</TabPanel>
			<TabPanel value={value} index={1}>
				<FaceFeatures />
			</TabPanel>
			<TabPanel value={value} index={2}>
				<FaceOverlays />
			</TabPanel>
		</Wrapper>
	);
});
