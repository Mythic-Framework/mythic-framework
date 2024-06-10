import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { Grid, Popover } from '@mui/material';
import { makeStyles } from '@mui/styles';

import Tooltip from './Tooltip';
import { getItemImage } from '../Inventory/item';

const useStyles = makeStyles((theme) => ({
	ingImg: {
		width: '100%',
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		maxWidth: 50,
	},
	ingCount: {
		lineHeight: '50px',
	},
	invalid: {
		color: theme.palette.error.main,
	},
	popover: {
		pointerEvents: 'none',
	},
	paper: {
		padding: 10,
		border: `1px solid ${theme.palette.primary.dark}`,
		borderRadius: 5,
		'&.rarity-1': {
			borderColor: theme.palette.rarities.rare1,
		},
		'&.rarity-2': {
			borderColor: theme.palette.rarities.rare2,
		},
		'&.rarity-3': {
			borderColor: theme.palette.rarities.rare3,
		},
		'&.rarity-4': {
			borderColor: theme.palette.rarities.rare4,
		},
	},
}));

export default ({ item, qty }) => {
	const classes = useStyles();
	const hidden = useSelector((state) => state.app.hidden);
	const items = useSelector((state) => state.inventory.items);
	const myCounts = useSelector((state) => state.crafting.myCounts);

	let itemData = items[item.name];

	const [anchorEl, setAnchorEl] = useState(null);
	const open = Boolean(anchorEl);
	const tooltipOpen = (event) => {
		setAnchorEl(event.currentTarget);
	};

	const tooltipClose = () => {
		setAnchorEl(null);
	};

	const hasItems =
		Boolean(myCounts[item.name]) && myCounts[item.name] >= item.count * qty;

	return (
		<Grid item xs={6}>
			<Grid
				container
				onMouseEnter={Boolean(itemData) ? tooltipOpen : null}
				onMouseLeave={Boolean(itemData) ? tooltipClose : null}
			>
				<Grid
					item
					xs={4}
					style={{
						position: 'relative',
					}}
				>
					<img
						className={classes.ingImg}
						src={getItemImage(null, itemData)}
					/>
				</Grid>
				<Grid item xs={8} className={classes.ingCount}>
					<span>
						<span>{`${
							Boolean(myCounts[item.name])
								? myCounts[item.name]
								: 0
						} / `}</span>
						<span className={hasItems ? null : classes.invalid}>
							{`${item.count * qty}`}
						</span>
					</span>
				</Grid>
			</Grid>
			<Popover
				className={classes.popover}
				classes={{
					paper: `${classes.paper} rarity-${itemData.rarity}`,
				}}
				open={open && !hidden}
				anchorEl={anchorEl}
				anchorOrigin={{
					vertical: 'center',
					horizontal: 'right',
				}}
				transformOrigin={{
					vertical: 'top',
					horizontal: 'center',
				}}
				onClose={tooltipClose}
				disableRestoreFocus
			>
				<Tooltip item={itemData} count={item.count} />
			</Popover>
		</Grid>
	);
};
