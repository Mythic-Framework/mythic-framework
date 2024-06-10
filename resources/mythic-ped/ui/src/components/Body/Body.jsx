import React, { useState } from 'react';
import Wrapper from '../UIComponents/Wrapper/Wrapper';
import { AppBar, Tab, Tabs } from '@mui/material';
import { TabPanel } from '../UIComponents';
import BodyOverlays from './BodyOverlays/BodyOverlays';
import Component from '../PedComponents/Component/Component';
import { useSelector } from 'react-redux';
import Ped from './Ped';

export default ({ armsOnly, blockPed }) => {
	const ped = useSelector((state) => state.app.ped);
	const [value, setValue] = useState(0);

	const handleChange = (event, newValue) => {
		setValue(newValue);
	};

	if (armsOnly) {
		return (
			<Wrapper>
				<Component
					label={'Arms'}
					component={ped.customization.components.torso}
					name={'torso'}
				/>
			</Wrapper>
		);
	} else {
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
						<Tab label="Skin" />
						{!blockPed && <Tab label="Ped" />}
					</Tabs>
				</AppBar>
				<TabPanel value={value} index={0}>
					<Component
						label={'Arms'}
						component={ped.customization.components.torso}
						name={'torso'}
					/>
				</TabPanel>
				<TabPanel value={value} index={1}>
					<BodyOverlays />
				</TabPanel>
				{!blockPed && <TabPanel value={value} index={2}>
					<Ped />
				</TabPanel>}
			</Wrapper>
		);
	}
};
