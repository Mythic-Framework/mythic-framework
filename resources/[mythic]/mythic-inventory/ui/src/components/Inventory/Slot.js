import React, { useState, useEffect } from 'react';
import { LinearProgress, Popover } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { connect, useDispatch, useSelector } from 'react-redux';

import { moveSlot } from './actions';
import { getItemImage, getItemLabel } from './item';
import Nui from '../../util/Nui';
import { useSound } from '../../hooks';
import Tooltip from './Tooltip';
import { FormatThousands } from '../../util/Parser';

const useStyles = makeStyles((theme) => ({
	slotWrap: {
		display: 'inline-block',
		margin: 5,
		boxSizing: 'border-box',
		flexGrow: 0,
		width: 165,
		flexBasis: 165,
		zIndex: 1,
	},
	slot: {
		width: '100%',
		height: 190,
		backgroundColor: `${theme.palette.secondary.dark}61`,
		border: `1px solid ${theme.palette.border.divider}`,
		position: 'relative',
		zIndex: 2,
		borderRadius: 5,
		'&:not(.disabled):not(.empty)': {
			transition: 'background ease-in 0.15s',
			'&:hover': {
				backgroundColor: `${theme.palette.secondary.dark}9e`,
			},
		},
		'&.rarity-1': {
			borderColor: `${theme.palette.rarities.rare1}40`,
		},
		'&.rarity-2': {
			borderColor: `${theme.palette.rarities.rare2}80`,
		},
		'&.rarity-3': {
			borderColor: `${theme.palette.rarities.rare3}80`,
		},
		'&.rarity-4': {
			borderColor: `${theme.palette.rarities.rare4}80`,
		},
		'&.rarity-5': {
			borderColor: `${theme.palette.rarities.rare5}80`,
		},
		'&.disabled': {
			borderColor: `${theme.palette.error.main}`,
		},
	},
	slotDrag: {
		width: '100%',
		height: 190,
		border: `1px solid ${theme.palette.primary.main}`,
		position: 'relative',
		zIndex: 2,
		opacity: 0.35,
		transition: 'opacity ease-in 0.15s, border ease-in 0.15s',
	},
	img: {
		height: 190,
		width: '100%',
		zIndex: 3,
		backgroundSize: '70%',
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'center center',
	},
	count: {
		top: 0,
		right: 0,
		position: 'absolute',
		textAlign: 'right',
		padding: '0 5px',
		textShadow: `0 0 5px ${theme.palette.secondary.dark}`,
		color: theme.palette.text.main,
		zIndex: 4,
	},
	label: {
		bottom: 0,
		left: 0,
		position: 'absolute',
		textAlign: 'center',
		height: 30,
		lineHeight: '30px',
		fontSize: 16,
		width: '100%',
		maxWidth: '100%',
		overflow: 'hidden',
		whiteSpace: 'nowrap',
		color: theme.palette.text.main,
		background: theme.palette.secondary.light,
		borderTop: `1px solid ${theme.palette.border.divider}`,
		borderBottomLeftRadius: 6,
		borderBottomRightRadius: 6,
		zIndex: 4,
	},
	hotkey: {
		top: 0,
		left: 0,
		position: 'absolute',
		padding: '0 5px',
		width: '20px',
		color: theme.palette.primary.alt,
		background: theme.palette.secondary.light,
		borderRight: `1px solid ${theme.palette.border.divider}`,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		borderBottomRightRadius: 5,
		borderTopLeftRadius: 5,
		zIndex: 4,
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
		'& small': {
			marginLeft: 5,
			'&::before': {
				content: '"($"',
				color: theme.palette.text.alt,
			},
			'&::after': {
				content: '")"',
				color: theme.palette.text.alt,
			},
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
	},
	broken: {
		backgroundColor: theme.palette.text.alt,
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
		'&.rarity-5': {
			borderColor: theme.palette.rarities.rare5,
		},
	},
}));

export default connect()((props) => {
	const classes = useStyles();
	const hidden = useSelector((state) => state.app.hidden);
	const hover = useSelector((state) => state.inventory.hover);
	const hoverOrigin = useSelector((state) => state.inventory.hoverOrigin);
	const inUse = useSelector((state) => state.inventory.inUse);
	const showSecondary = useSelector((state) => state.inventory.showSecondary);
	const secondaryInventory = useSelector(
		(state) => state.inventory.secondary,
	);
	const playerInventory = useSelector((state) => state.inventory.player);
	const items = useSelector((state) => state.inventory.items);
	const itemData = useSelector((state) => state.inventory.items)[
		props?.data?.Name
	];
	const hoverData = useSelector((state) => state.inventory.items)[
		hover?.Name
	];
	const dispatch = useDispatch();
	const soundEffect = useSound();

	const calcDurability = () => {
		if (
			!Boolean(props?.data?.MetaData?.CreateDate) ||
			!Boolean(itemData?.durability)
		)
			null;
		return Math.ceil(
			100 -
				((Math.floor(Date.now() / 1000) -
					props?.data?.MetaData?.CreateDate) /
					itemData?.durability) *
					100,
		);
	};

	const isWeaponDisabled =
		props.shop &&
		itemData?.requiresLicense &&
		itemData?.type == 2 &&
		!playerInventory.isWeaponEligble;

	const isQualiDisabled =
		props.shop &&
		Boolean(itemData?.qualification) &&
		(!Boolean(playerInventory.qualifications) ||
			playerInventory.qualifications.filter(
				(q) => q == itemData?.qualification,
			).length == 0);

	const isOpenContainer =
		Boolean(props.data) &&
		itemData?.type == 10 &&
		secondaryInventory.owner ==
			`container:${props.data.MetaData.Container}`;

	const durability = calcDurability();

	const [anchorEl, setAnchorEl] = useState(null);
	const open = Boolean(anchorEl);
	const tooltipOpen = (event) => {
		setAnchorEl(event.currentTarget);
	};

	const tooltipClose = () => {
		setAnchorEl(null);
	};

	const isUsable = () => {
		return (
			!Boolean(inUse) &&
			props.owner == playerInventory.owner &&
			items[props.data.Name].isUsable &&
			(!Boolean(items[props.data.Name].durability) ||
				props.data.MetaData?.CreateDate +
					items[props.data.Name].durability >
					Date.now() / 1000)
		);
	};

	const moveItem = () => {
		if (
			hoverOrigin.slot !== props.slot ||
			hoverOrigin.owner !== props.owner
		) {
			if (isQualiDisabled || isWeaponDisabled || isOpenContainer) {
				return;
			}

			let origin;
			if (playerInventory.owner === hoverOrigin.owner) {
				origin = 'player';
			} else {
				origin = 'secondary';
			}
			let destination;
			if (playerInventory.owner === props.owner) {
				destination = 'player';
			} else {
				destination = 'secondary';
			}

			if (destination == 'secondary' && secondaryInventory.shop) {
				Nui.send('FrontEndSound', 'DISABLED');
				return;
			}

			if (
				destination == 'player' &&
				origin == 'secondary' &&
				secondaryInventory.shop &&
				Boolean(props?.data?.Name) &&
				hoverOrigin.Name != props.data.Name
			) {
				Nui.send('FrontEndSound', 'DISABLED');
				return;
			}

			soundEffect('drag');
			const payload = {
				origin: {
					...hover,
					isStackable: itemData?.isStackable,
				},
				destination: props.data,
				originSlot: hoverOrigin.slot,
				destSlot: props.slot,
				itemData: hoverData,
			};
			moveSlot(
				hoverOrigin.owner,
				props.owner,
				hoverOrigin.slot,
				props.slot,
				hoverOrigin.invType,
				props.invType,
				hoverOrigin.Name,
				hoverOrigin.Count,
				hover.Count,
				hoverOrigin.class,
				props.vehClass,
				hoverOrigin.model,
				props.vehModel,
			);
			setAnchorEl(null);
			if (origin === destination) {
				if (origin === 'player') {
					dispatch({
						type: 'MOVE_ITEM_PLAYER_SAME',
						payload,
					});
				} else {
					dispatch({
						type: 'MOVE_ITEM_SECONDARY_SAME',
						payload,
					});
				}
			} else {
				if (origin === 'player') {
					dispatch({
						type: 'MOVE_ITEM_PLAYER_TO_SECONDARY',
						payload,
					});
				} else {
					dispatch({
						type: 'MOVE_ITEM_SECONDARY_TO_PLAYER',
						payload,
					});
				}
			}
			setAnchorEl(null);
		}

		props.dispatch({
			type: 'SET_HOVER',
			payload: null,
		});
		props.dispatch({
			type: 'SET_HOVER_ORIGIN',
			payload: null,
		});
	};

	const onMouseDown = (event) => {
		event.preventDefault();
		if (props.locked) return;
		if (hoverOrigin == null) {
			if (!Boolean(props.data?.Name)) return;
			if (event.button !== 0 && event.button !== 1) return;

			if (isQualiDisabled || isWeaponDisabled || isOpenContainer) {
				Nui.send('FrontEndSound', 'DISABLED');
				return;
			}

			if (event.button === 1) {
				if (isUsable()) {
					props.onUse(props.owner, props.data.Slot, props.invType);
					dispatch({
						type: 'USE_ITEM_PLAYER',
						payload: {
							originSlot: props.data.Slot,
						},
					});
				} else {
					Nui.send('FrontEndSound', 'DISABLED');
					return;
				}
			} else {
				if (event.shiftKey && showSecondary) {
					let payload = {
						origin: {
							...props.data,
							slot: props.slot,
							owner: props.owner,
							invType: props.invType,
							shop: props.shop,
							isStackable: itemData.isStackable,
						},
						destination: Object(),
						originSlot: props.slot,
						itemData: itemData,
					};

					if (playerInventory.owner === props.owner) {
						if (secondaryInventory.shop) {
							Nui.send('FrontEndSound', 'DISABLED');
							return;
						}

						Object.keys(secondaryInventory.inventory)
							.filter((sId) =>
								Boolean(secondaryInventory.inventory[sId]),
							)
							.sort(
								(a, b) =>
									secondaryInventory.inventory[a].Slot -
									secondaryInventory.inventory[b].Slot,
							)
							.every((sId) => {
								let slot = secondaryInventory.inventory[sId];

								if (
									slot.Name == props.data.Name &&
									(itemData.isStackable == -1 || (Boolean(itemData.isStackable) && props.data.Count + slot.Count <= itemData.isStackable)) &&
									(itemData.durability == null || (Math.abs((props.data?.MetaData?.CreateDate || Date.now() / 1000) - (slot?.MetaData?.CreateDate || Date.now() / 1000)) <= 3600))
								) {
									payload.destination = slot;
									payload.destSlot = slot.Slot;
									return false;
								}
								return true;
							});

						if (!Boolean(payload.destSlot)) {
							for (let i = 1; i <= secondaryInventory.size; i++) {
								if (
									!Boolean(
										secondaryInventory.inventory[`${i}`],
									)
								) {
									payload.destSlot = i;
									break;
								}
							}
						}

						if (Boolean(payload.destSlot)) {
							soundEffect('drag');
							moveSlot(
								playerInventory.owner,
								secondaryInventory.owner,
								props.slot,
								payload.destSlot,
								props.invType,
								secondaryInventory.invType,
								props.data.Name,
								props.data.Count,
								props.data.Count,
								false,
								secondaryInventory.class,
								false,
								secondaryInventory.model,
							);
							dispatch({
								type: 'MOVE_ITEM_PLAYER_TO_SECONDARY',
								payload,
							});
							setAnchorEl(null);
						} else {
							Nui.send('FrontEndSound', 'DISABLED');
						}
					} else {
						Object.keys(playerInventory.inventory)
							.filter((sId) =>
								Boolean(playerInventory.inventory[sId]),
							)
							.sort(
								(a, b) =>
									playerInventory.inventory[a].Slot -
									playerInventory.inventory[b].Slot,
							)
							.every((sId) => {
								let slot = playerInventory.inventory[sId];

								if (
									slot.Name == props.data.Name &&
									(itemData.isStackable == -1 || (Boolean(itemData.isStackable) && props.data.Count + slot.Count <= itemData.isStackable)) &&
									(itemData.durability == null || (Math.abs((props.data?.MetaData?.CreateDate || Date.now() / 1000) - (slot?.MetaData?.CreateDate || Date.now() / 1000)) <= 3600))
								) {
									payload.destination = slot;
									payload.destSlot = slot.Slot;
									return false;
								}
								return true;
							});

						if (!Boolean(payload.destSlot)) {
							for (let i = 1; i <= playerInventory.size; i++) {
								if (
									!Boolean(playerInventory.inventory[`${i}`])
								) {
									payload.destSlot = i;
									break;
								}
							}
						}

						if (Boolean(payload.destSlot)) {
							soundEffect('drag');
							moveSlot(
								secondaryInventory.owner,
								playerInventory.owner,
								props.slot,
								payload.destSlot,
								props.invType,
								1,
								props.data.Name,
								props.data.Count,
								props.data.Count,
								secondaryInventory.class,
								false,
								secondaryInventory.model,
								false,
							);
							dispatch({
								type: 'MOVE_ITEM_SECONDARY_TO_PLAYER',
								payload,
							});
							setAnchorEl(null);
						} else {
							Nui.send('FrontEndSound', 'DISABLED');
						}
					}
					setAnchorEl(null);
				} else if (event.ctrlKey) {
					props.dispatch({
						type: 'SET_HOVER',
						payload: {
							...props.data,
							Count: Math.ceil(props.data.Count / 2),
							slot: props.slot,
							owner: props.owner,
							shop: props.shop,
							free: props.free,
							invType: props.invType,
						},
					});
					props.dispatch({
						type: 'SET_HOVER_ORIGIN',
						payload: {
							...props.data,
							slot: props.slot,
							owner: props.owner,
							shop: props.shop,
							invType: props.invType,
							class: props.vehClass || false,
							model: props.vehModel || false,
						},
					});
					setAnchorEl(null);
				} else {
					props.dispatch({
						type: 'SET_HOVER',
						payload: {
							...props.data,
							slot: props.slot,
							owner: props.owner,
							shop: props.shop,
							free: props.free,
							invType: props.invType,
						},
					});
					props.dispatch({
						type: 'SET_HOVER_ORIGIN',
						payload: {
							...props.data,
							slot: props.slot,
							owner: props.owner,
							shop: props.shop,
							invType: props.invType,
							class: props.vehClass || false,
							model: props.vehModel || false,
						},
					});
					setAnchorEl(null);
				}
			}
		} else {
			moveItem();
		}
	};

	const onMouseUp = (event) => {
		if (props.locked) return;
		if (hoverOrigin == null) return;
		if (event.button !== 0) return;

		if (!event.shiftKey || !showSecondary) {
			moveItem();
		}
	};

	return (
		<div
			className={classes.slotWrap}
			onMouseDown={onMouseDown}
			onMouseUp={onMouseUp}
			onContextMenu={Boolean(itemData) ? props.onContextMenu : null}
			onMouseEnter={Boolean(itemData) ? tooltipOpen : null}
			onMouseLeave={Boolean(itemData) ? tooltipClose : null}
		>
			<div
				className={`${classes.slot} ${
					!Boolean(props.data.Name)
						? ` empty`
						: ` rarity-${itemData.rarity}`
				}${
					hoverOrigin != null &&
					hoverOrigin.slot === props.slot &&
					hoverOrigin.owner === props.owner
						? ` ${classes.slotDrag}`
						: ''
				}${
					isQualiDisabled || isWeaponDisabled || isOpenContainer
						? ' disabled'
						: ''
				}`}
			>
				{Boolean(itemData) && (
					<div
						className={classes.img}
						style={{
							backgroundImage: `url(${getItemImage(
								props.data,
								itemData,
							)})`,
						}}
					></div>
				)}
				{Boolean(itemData) && props.data.Count > 0 && (
					<div className={classes.count}>{props.data.Count}</div>
				)}
				{props.hotkeys && props.slot <= 4 && (
					<div className={classes.hotkey}>{props.slot}</div>
				)}
				{props.shop &&
					Boolean(itemData) &&
					(props.free ? (
						<div className={classes.price}>FREE</div>
					) : (
						<div className={classes.price}>
							{FormatThousands(itemData.price * props.data.Count)}
							{props.data.Count > 1 && (
								<small>{FormatThousands(itemData.price)}</small>
							)}
						</div>
					))}
				{Boolean(itemData?.durability) &&
					Boolean(props?.data?.MetaData?.CreateDate) &&
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
							variant="determinate"
							value={durability}
						/>
					) : (
						<LinearProgress
							className={classes.durability}
							classes={{
								bar: classes.broken,
							}}
							variant="determinate"
							value={100}
						/>
					))}
				{Boolean(itemData) && (
					<div className={classes.label}>
						{getItemLabel(props.data, itemData)}
					</div>
				)}
			</div>
			{Boolean(itemData) && (
				<Popover
					className={classes.popover}
					classes={{
						paper: `${classes.paper} rarity-${itemData.rarity}`,
					}}
					open={
						open && !Boolean(hover) && !hidden && Boolean(anchorEl)
					}
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
					<Tooltip
						isEligible={!isWeaponDisabled}
						isQualified={!isQualiDisabled}
						item={itemData}
						instance={props.data}
						durability={durability}
						invType={props.invType}
						shop={props.shop}
						free={props.free}
					/>
				</Popover>
			)}
		</div>
	);
});
