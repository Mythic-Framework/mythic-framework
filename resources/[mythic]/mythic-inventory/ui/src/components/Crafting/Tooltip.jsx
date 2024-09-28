import React from 'react';
import { LinearProgress, Popover } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { getItemLabel } from '../Inventory/item';
import { Sanitize } from '../../util/Parser';

export default ({ item, count, rarity = false }) => {
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
			color: theme.palette.success.main,
		},
		stackData: {
			fontSize: 12,
		},
		itemWeight: {
			fontSize: 14,
			color: theme.palette.text.alt,
			'&::after': {
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
			case 18:
				return 'Equipment';
			default:
				return 'Unknown Item';
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

	if (!Boolean(item)) return null;
	return (
		<div className={classes.body}>
			<div className={classes.itemName}>
				{getItemLabel(null, item)}
				<span className={classes.count}>{count}</span>
			</div>
			{rarity && <div className={classes.rarity}>{getRarityLabel()}</div>}
			<div className={classes.itemType}>{getTypeLabel()}</div>
			{item.isUsable && <div className={classes.usable}>Usable</div>}
			{Boolean(item.isStackable) && (
				<div className={classes.stackData}>
					Stackable ({item.isStackable})
				</div>
			)}
			{(item?.weight || 0) > 0 && (
				<div className={classes.itemWeight}>
					{item.weight.toFixed(2)}
				</div>
			)}
			{Boolean(item.description) && (
				<div
					className={classes.description}
					dangerouslySetInnerHTML={{
						__html: Sanitize(item.description),
					}}
				></div>
			)}
		</div>
	);
};
