import React from 'react';
import { useSelector } from 'react-redux';
import { makeStyles } from '@mui/styles';

import { getItemLabel } from '../Inventory/item';

export default ({ item, count }) => {
	const items = useSelector((state) => state.inventory.items);
	const useStyles = makeStyles((theme) => ({
		body: {
			minWidth: 250,
		},
		itemName: {
			fontSize: 24,
			color: theme.palette.text.main,
		},
		itemType: {
			fontSize: 16,
			color: Boolean(theme.palette.rarities[`rare${item.rarity}`])
				? theme.palette.rarities[`rare${item.rarity}`]
				: theme.palette.text.main,
		},
		usable: {
			fontSize: 16,
			color: theme.palette.success.light,
			'&::before': {
				color: theme.palette.text.main,
				content: '" - "',
			},
		},
		tooltipDetails: {
			marginTop: 4,
			paddingTop: 4,
			borderTop: `1px solid ${theme.palette.border.input}`,
		},
		tooltipValue: {
			fontSize: 14,
			color: theme.palette.text.alt,
		},
		stackable: {
			fontSize: 10,
			marginLeft: 2,
		},
		description: {
			paddingLeft: 20,
			fontSize: 16,
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

	if (!Boolean(item)) return null;
	return (
		<div className={classes.body}>
			<div className={classes.itemName}>{getItemLabel(null, item)}</div>
			<div className={classes.itemType}>
				{`${getRarityLabel()} ${getTypeLabel()}`}
				{item.isUsable && (
					<span className={classes.usable}>Usable</span>
				)}
			</div>

			{Boolean(item.description) && (
				<div className={classes.description}>{item.description}</div>
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
			<div className={classes.tooltipDetails}>
				Weight:{' '}
				<span className={classes.tooltipValue}>
					{item?.weight || 0} lbs
					{count > 1 && (
						<span className={classes.stackable}>
							(Total: {(item?.weight || 0) * count} lbs)
						</span>
					)}
				</span>
				{' | '}Count:{' '}
				<span className={classes.tooltipValue}>
					{count}
					{Boolean(item.isStackable) && item.isStackable > 0 && (
						<span className={classes.stackable}>
							(Max Stack: {item.isStackable})
						</span>
					)}
				</span>
			</div>
		</div>
	);
};
