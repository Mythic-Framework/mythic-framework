import React, { useEffect, useState } from 'react';
import { TextField, MenuItem, Slider, Box, Typography } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { CurrencyFormat } from '../../../../../util/Parser';

import { Modal } from '../../../../../components';
import { useSelector } from 'react-redux';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

export default ({ open, property, upgradeData, onClose }) => {
	const classes = useStyles();

	let propertyUpgrades = upgradeData?.[property?.type];
	const interiorData = propertyUpgrades?.interior?.levels?.find(int => int.id == property?.upgrades?.interior);

	return (
		<Modal
			open={open}
			maxWidth="md"
			title={`${property?.label}`}
			onClose={onClose}
		>
			{propertyUpgrades && interiorData && (<>
				<p>Property: {property?.label}</p>
				<p>Property Owner: {property?.owner?.First} {property?.owner?.Last} ({property?.owner?.SID})</p>

				<p>Property Interior: {interiorData.name} - {interiorData?.info?.description}</p>
				{Object.keys(propertyUpgrades).filter(u => u !== "interior").map(upgrade => {
					const myUpgrade = propertyUpgrades[upgrade].levels[(property.upgrades[upgrade] ?? 1) - 1];
					return <p key={upgrade}>Property Upgrade: {myUpgrade.name} - {myUpgrade?.info}</p>
				})}
			</>)}
		</Modal>
	);
};
