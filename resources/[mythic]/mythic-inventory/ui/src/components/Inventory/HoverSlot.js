import React, { Fragment, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { LinearProgress } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { getItemImage, getItemLabel } from './item';

const initialState = {
	mouseX: null,
	mouseY: null,
};
const useStyles = makeStyles((theme) => ({
	hover: {
		position: 'absolute',
		top: 0,
		left: 0,
		pointerEvents: 'none',
		zIndex: 1,
	},
	img: {
		height: 125,
		width: '100%',
		overflow: 'hidden',
		zIndex: 3,
		backgroundSize: '55%',
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'center center',
	},
	label: {
		bottom: 0,
		left: 0,
		position: 'absolute',
		textAlign: 'center',
		padding: '0 5px',
		width: '100%',
		maxWidth: '100%',
		overflow: 'hidden',
		whiteSpace: 'nowrap',
		color: theme.palette.text.main,
		background: 'rgba(12,24,38, 0.933)',
		borderTop: `1px solid ${theme.palette.border.divider}`,
		borderBottomLeftRadius: 6,
		borderBottomRightRadius: 6,
		zIndex: 4,
	},
	slot: {
		width: 125,
		height: 125,
		background: `${theme.palette.secondary.dark}61`,
		border: `1px solid ${theme.palette.border.divider}`,
		position: 'relative',
		zIndex: 2,
		borderRadius: 5,
		'&.rarity-1': {
			// borderColor: `${theme.palette.rarities.rare1}40`,
		},
		'&.rarity-2': {
			// borderColor: `${theme.palette.rarities.rare2}80`,
		},
		'&.rarity-3': {
			// borderColor: `${theme.palette.rarities.rare3}80`,
		},
		'&.rarity-4': {
			// borderColor: `${theme.palette.rarities.rare4}80`,
		},
		'&.rarity-5': {
			// borderColor: `${theme.palette.rarities.rare5}80`,
		},
	},
	count: {
		top: 0,
		right: 0,
		position: 'absolute',
		textAlign: 'right',
		padding: '0 5px',
		color: theme.palette.text.main,
		zIndex: 4,
	},
	price: {
		top: 0,
		left: 0,
		position: 'absolute',
		padding: '0 5px',
		// textShadow: `0 0 5px ${theme.palette.secondary.dark}`,
		color: theme.palette.success.main,
		zIndex: 4,
		'&::before': {
			content: '"$"',
			marginRight: 2,
			color: theme.palette.text.main,
		},
	},
	durability: {
		bottom: 30,
		left: 0,
		position: 'absolute',
		width: '100%',
		maxWidth: '100%',
		overflow: 'hidden',
		height: 7,
		background: 'transparent',
		zIndex: 4,
		'&.broken': {
		background: theme.palette.text.alt,
		},
	},
	broken: {
		background: theme.palette.text.alt,
		transition: 'none !important',
	},
	progressbar: {
		transition: 'none !important',
	},
	price: {
		top: 0,
		left: 0,
		position: 'absolute',
		padding: '0 5px',
		textShadow: `0 0 5px ${theme.palette.secondary.dark}`,
		color: theme.palette.success.main,
		zIndex: 4,
		'&::before': {
			content: '"$"',
			marginRight: 2,
			color: theme.palette.text.main,
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const hover = useSelector((state) => state.inventory.hover);
	const itemData = useSelector((state) => state.inventory.items)[hover?.Name];
	const [state, setState] = React.useState(initialState);

	const calcDurability = () => {
		if (!Boolean(hover) || !Boolean(itemData?.durability)) null;
		return Math.ceil(
			100 -
				((Math.floor(Date.now() / 1000) - hover?.CreateDate) /
					itemData?.durability) *
					100,
		);
	};
	const durability = calcDurability();

	const mouseMove = (event) => {
		event.preventDefault();
		setState({
			mouseX: event.clientX,
			mouseY: event.clientY,
		});
	};

	useEffect(() => {
		document.addEventListener('mousemove', mouseMove);
		return () => document.removeEventListener('mousemove', mouseMove);
	}, []);

	if (hover) {
		return (
			<div
				className={classes.hover}
				style={
					state.mouseY !== null && state.mouseX !== null
						? {
								top: state.mouseY,
								left: state.mouseX,
								transform: 'translate(-50%, -50%)',
						  }
						: undefined
				}
			>
				<div className={`${classes.slot} rarity-${itemData.rarity}`}>
					{Boolean(hover) && (
						<div
							className={classes.img}
							style={{
								backgroundImage: `url(${getItemImage(
									hover,
									itemData,
								)})`,
							}}
						></div>
					)}
					{Boolean(itemData) && (
						<div className={classes.label}>
							{getItemLabel(hover, itemData)}
						</div>
					)}
					{Boolean(hover) && hover.Count > 0 && (
						<div className={classes.count}>{hover.Count}</div>
					)}
					{Boolean(itemData?.durability) &&
						Boolean(hover?.CreateDate) &&
						(durability > 0 ? (
							<LinearProgress
								className={classes.durability}
								color={
									durability >= 75
										? 'success'
										: durability >= 50
										? 'warning'
										: 'error'
								}
								classes={{
									determinate: classes.progressbar,
									bar: classes.progressbar,
									bar1: classes.progressbar,
								}}
								variant="determinate"
								value={durability}
							/>
						) : (
							<LinearProgress
								className={classes.durability}
								classes={{
									determinate: classes.broken,
									bar: classes.broken,
									bar1: classes.broken,
								}}
								color="secondary"
								variant="determinate"
								value={100}
							/>
						))}
					{hover.shop && Boolean(itemData) && (
						<div className={classes.price}>
							{hover.free ? 'FREE' : itemData.price * hover.Count}
						</div>
					)}
				</div>
			</div>
		);
	} else {
		return <Fragment />;
	}
};