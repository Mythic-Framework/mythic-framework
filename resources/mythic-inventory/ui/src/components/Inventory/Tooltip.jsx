import React from 'react';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import { FormatThousands } from '../../util/Parser';
import { getItemLabel } from './item';
import { List, ListItem, ListItemText } from '@mui/material';
import { useSelector } from 'react-redux';

const ignoredFields = [
	'ammo',
	'clip',
	'CreateDate',
	'Container',
	'Quality',
	'mask',
	'accessory',
	'watch',
	'hat',
	'BankId',
	'VpnName',
	'EvidenceCoords',
	'EvidenceType',
	'EvidenceWeapon',
	'EvidenceDNA',
	'WeaponTint',
	'CustomItemLabel',
	'CustomItemImage',
	'Items',
	'Department',
	'Scratched',
	'PoliceWeaponId',
	'Mugshot',
];

export default ({
	item,
	instance,
	durability,
	invType,
	shop = false,
	free = false,
	rarity = false,
	isEligible = false,
	isQualified = false,
}) => {
	const items = useSelector((state) => state.inventory.items);
	const useStyles = makeStyles((theme) => ({
		body: {
			minWidth: 150,
		},
		itemName: {
			fontSize: 18,
			color: theme.palette.rarities[`rare${item.rarity}`]
				? theme.palette.rarities[`rare${item.rarity}`]
				: theme.palette.text.main,
		},
		rarity: {
			fontSize: 14,
			color: theme.palette.rarities[`rare${item.rarity}`]
				? theme.palette.rarities[`rare${item.rarity}`]
				: theme.palette.text.main,
		},
		count: {
			fontSize: 14,
			color: theme.palette.text.main,
			'&::before': {
				content: '"x"',
				marginLeft: 2,
			},
		},
		itemType: {
			fontSize: 14,
			color: theme.palette.text.alt,
		},
		usable: {
			fontSize: 14,
			color: theme.palette.success.light,
		},
		stackData: {
			fontSize: 12,
		},
		itemWeight: {
			fontSize: 14,
			color: theme.palette.info.light,
			'&::after': {
				color: theme.palette.text.alt,
				content: `"${(item?.weight || 0) > 1 ? 'lbs' : 'lb'}"`,
				marginLeft: 5,
			},
		},
		itemPrice: {
			fontSize: 14,
			color: theme.palette.success.main,
			'&::before': {
				content: '"$"',
				marginRight: 2,
				color: theme.palette.text.main,
			},
		},
		description: {
			paddingLeft: 20,
			fontSize: 14,
			color: theme.palette.text.alt,
		},
		metadata: {
			marginTop: 10,
			paddingTop: 10,
			borderTop: `1px solid ${theme.palette.border.input}`,
			fontSize: 12,
			color: theme.palette.text.alt,
		},
		inelig: {
			marginTop: 10,
			paddingTop: 10,
			borderTop: `1px solid ${theme.palette.border.input}`,
			fontSize: 14,
			color: theme.palette.error.light,
			'& svg': {
				marginRight: 10,
			},
		},
		elig: {
			marginTop: 10,
			paddingTop: 10,
			borderTop: `1px solid ${theme.palette.border.input}`,
			fontSize: 14,
			color: theme.palette.success.light,
			'& svg': {
				marginRight: 10,
			},
		},
		attachFitment: {
			fontSize: 14,
			'& li': {
				fontSize: 12,
			},
		},
		durability: {
			fontSize: 14,
			color: isNaN(durability)
				? theme.palette.text.alt
				: durability >= 75
				? theme.palette.success.light
				: durability >= 50
				? theme.palette.warning.light
				: theme.palette.error.light,
			'&::before': {
				content: '"Durability: "',
				marginRight: 2,
				color: theme.palette.text.alt,
			},
			'&::after': {
				content: '"%"',
			},
		},
		broken: {
			fontSize: 14,
			color: theme.palette.error.light,
		},
		title: {
			'& svg': {
				marginRight: 6,
				color: 'gold',
			},
		},
		attchList: {
			marginLeft: -6,
			listStyle: 'none',
		},
		attchSlot: {
			textTransform: 'capitalize',
		},
	}));
	const classes = useStyles();

	const getTypeLabel = () => {
		switch (item.type) {
			case 1:
				return 'Consumable';
			case 2:
				return 'Weapon';
			case 3:
				return 'Tool';
			case 4:
				return 'Crafting Ingredient';
			case 5:
				return 'Collectable';
			case 6:
				return 'Junk';
			case 8:
				return 'Evidence';
			case 9:
				return 'Ammunition';
			case 10:
				return 'Container';
			case 11:
				return 'Gem';
			case 12:
				return 'Paraphernalia';
			case 13:
				return 'Wearable';
			case 14:
				return 'Contraband';
			case 15:
				return 'Collectable (Gang Chain)';
			case 16:
				return 'Weapon Attachment';
			case 17:
				return 'Crafting Schematic';
			default:
				return 'Unknown';
		}
	};

	const getRarityLabel = () => {
		switch (item.rarity) {
			case 1:
				return 'Common';
			case 2:
				return 'Uncommon';
			case 3:
				return 'Rare';
			case 4:
				return 'Epic';
			case 5:
				return 'Objective';
			default:
				return 'Dogshit';
		}
	};

	const isDataBlacklisted = (key) => {
		return ignoredFields.includes(key);
	};

	const getDataLabel = (key, value) => {
		switch (key) {
			case 'SerialNumber':
				return (
					<span className={classes.metafield}>
						<b>Serial Number</b>: {value}
					</span>
				);
			case 'ScratchedSerialNumber':
				return (
					<span className={classes.metafield}>
						<b>Serial Number</b>: {'<scratched off>'}
					</span>
				);
			case 'StateID':
				return (
					<span className={classes.metafield}>
						<b>State ID</b>: {value}
					</span>
				);
			case 'PassportID':
				return (
					<span className={classes.metafield}>
						<b>Passport ID</b>: {value}
					</span>
				);
			case 'DOB':
				return (
					<span className={classes.metafield}>
						<b>Date of Birth</b>:
						<Moment date={value * 1000} format="YYYY/MM/DD" />
					</span>
				);
			case 'EvidenceAmmoType':
				return (
					<span className={classes.metafield}>
						<b>Ammo Type</b>: {value}
					</span>
				);
			case 'EvidenceId':
				return (
					<span className={classes.metafield}>
						<b>Evidence ID</b>: {value}
					</span>
				);
			case 'EvidenceColor':
				return (
					<span
						className={classes.metafield}
						style={{
							color: `rgb(${value.r} ${value.g} ${value.b})`,
						}}
					>
						<b>Fragment Color</b>:{' '}
						{`R: ${value.r} G: ${value.g} B: ${value.b}`}
					</span>
				);
			case 'EvidenceDegraded':
				return (
					<span className={classes.metafield}>
						<b>Evidence Degraded</b>: {value ? 'Yes' : 'No'}
					</span>
				);
			case 'EvidenceBloodPool':
				return (
					<span className={classes.metafield}>
						{value ? 'Pool of Blood' : 'Drops of Blood'}
					</span>
				);
			case 'CustomItemText':
				return <span className={classes.metafield}>{value}</span>;
			case 'VaultCode':
				return (
					<span className={classes.metafield}>
						<b>Vault Access Code</b>: {value}
					</span>
				);
			case 'BranchName':
				return (
					<span className={classes.metafield}>
						<b>Fleeca Branch</b>: {value}
					</span>
				);
			case 'Finished':
				return (
					<span className={classes.metafield}>
						<b>Ready</b>:{' '}
						{<Moment unix date={value} fromNow interval={60000} />}
					</span>
				);
			case 'CryptoCoin':
				return (
					<span className={classes.metafield}>
						<b>Currency</b>: ${value}
					</span>
				);
			case 'ChopList':
				return (
					<span className={classes.metafield}>
						<b>Request List</b>:{' '}
						<ul>
							{value.length > 0 ? (
								value
									.sort((a, b) => b.hv - a.hv)
									.map((chop, i) => {
										return (
											<li
												key={`chop-${i}`}
												className={classes.title}
											>
												{chop.hv && (
													<FontAwesomeIcon
														icon={[
															'fas',
															'diamond-exclamation',
														]}
													/>
												)}
												{chop.name}
											</li>
										);
									})
							) : (
								<b>No Vehicles On Chop List</b>
							)}
						</ul>
					</span>
				);
			case 'WeaponComponents':
				if (Object.keys(value).length == 0) return null;
				return (
					<span className={classes.metafield}>
						<b>Weapon Attachments</b>:{' '}
						<ul className={classes.attchList}>
							{Object.keys(value).map((attachKey) => {
								let attach = value[attachKey];
								let atchItem = items[attach.item];
								if (!Boolean(atchItem)) return null;
								return (
									<li>
										<b className={classes.attchSlot}>
											{attachKey}:{' '}
										</b>
										{atchItem.label}
									</li>
								);
							})}
						</ul>
					</span>
				);
			case 'FleecaSchedule':
				return (
					<span className={classes.metafield}>
						<b>Pickup Schedule</b>:{' '}
						<ul className={classes.attchList}>
							{value.map((branch) => {
								return (
									<li>
										<b className={classes.attchSlot}>
											{branch.time}:{' '}
										</b>
										{branch.name}
									</li>
								);
							})}
						</ul>
					</span>
				);
			default:
				return (
					<span className={classes.metafield}>
						<b>{key}</b>: {value}
					</span>
				);
		}
	};

	if (!Boolean(item)) return null;
	return (
		<div className={classes.body}>
			<div className={classes.itemName}>
				{getItemLabel(instance, item)}
				{Boolean(item.isStackable) && (
					<span className={classes.count}>{instance.Count}</span>
				)}
			</div>
			{rarity && <div className={classes.rarity}>{getRarityLabel()}</div>}
			<div className={classes.itemType}>{getTypeLabel()}</div>
			{item.isUsable && <div className={classes.usable}>Usable</div>}
			{(Boolean(item.isStackable) || item.isStackable == -1) && (
				<div className={classes.stackData}>
					{item.isStackable > 0 ? (
						<span>Stackable ({item.isStackable})</span>
					) : (
						<span>Stackable</span>
					)}
				</div>
			)}
			{(item?.weight || 0) > 0 && (
				<div>
					<span className={classes.itemWeight}>
						{((item?.weight || 0) * instance.Count).toFixed(2)}
					</span>
					(
					<span className={classes.itemWeight}>
						{item?.weight || 0}
					</span>
					)
				</div>
			)}
			{!isNaN(durability) &&
				(durability > 0 ? (
					<div className={classes.durability}>{durability}</div>
				) : (
					<div className={classes.broken}>Broken</div>
				))}
			{shop && !free && (
				<div className={classes.itemPrice}>
					{FormatThousands(item.price)}
				</div>
			)}
			{Boolean(item.description) && (
				<div className={classes.description}>{item.description}</div>
			)}
			{item.type == 2 && item.requiresLicense && shop && (
				<div className={isEligible ? classes.elig : classes.inelig}>
					{isEligible ? (
						<FontAwesomeIcon icon={['fas', 'circle-check']} />
					) : (
						<FontAwesomeIcon icon={['fas', 'x']} />
					)}
					Requires Weapons Permit
				</div>
			)}
			{shop && Boolean(item.qualification) && (
				<div className={isQualified ? classes.elig : classes.inelig}>
					{isQualified ? (
						<FontAwesomeIcon icon={['fas', 'circle-check']} />
					) : (
						<FontAwesomeIcon icon={['fas', 'x']} />
					)}
					Requires Additional Qualification
				</div>
			)}
			{Boolean(item?.component) && (
				<div className={classes.attachFitment}>
					<span className={classes.metafield}>
						<b>Attachment Fits On</b>:{' '}
						<ul className={classes.attchList}>
							{Object.keys(item.component.strings).length <=
							10 ? (
								Object.keys(item.component.strings).map(
									(weapon) => {
										let wepItem = items[weapon];
										if (!Boolean(wepItem)) return null;
										return <li>{wepItem.label}</li>;
									},
								)
							) : (
								<span>Fits On Most Weapons</span>
							)}
						</ul>
					</span>
				</div>
			)}
			{Boolean(item.schematic) &&
				Boolean(items[item.schematic.result.name]) && (
					<div className={classes.attachFitment}>
						<span className={classes.metafield}>
							<b>Teaches</b>:
							{` Crafting x${item.schematic.result.count} ${
								items[item.schematic.result.name].label
							}`}
						</span>
					</div>
				)}
			{Boolean(instance.MetaData) &&
				Object.keys(instance.MetaData).length > 0 &&
				Object.keys(instance.MetaData).filter(
					(k) => !isDataBlacklisted(k),
				).length > 0 && (
					<div className={classes.metadata}>
						{Object.keys(instance.MetaData)
							.filter((k) => !isDataBlacklisted(k))
							.sort((a, b) => (a < b ? -1 : a > b ? 1 : 0))
							.map((k) => {
								return (
									<div key={`${instance.Slot}-${k}`}>
										{getDataLabel(k, instance.MetaData[k])}
									</div>
								);
							})}
					</div>
				)}
		</div>
	);
};
