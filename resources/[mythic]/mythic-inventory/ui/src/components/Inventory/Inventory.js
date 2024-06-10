import React, { Fragment, useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	Fade,
	Menu,
	MenuItem,
	LinearProgress,
	CircularProgress,
	IconButton,
	Modal,
	Box,
	Typography,
	Alert,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Slot from './Slot';
import Nui from '../../util/Nui';
import { useItem } from './actions';
import Split from './Split';

const useStyles = makeStyles((theme) => ({
	root: {
		display: 'flex',
		justifyContent: 'center',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		width: '100%',
		height: '100%',
		gap: 200,
	},
	container: {
		userSelect: 'none',
		'-webkit-user-select': 'none',
		width: '100%',
		height: '90%',
	},
	inventoryGrid: {
		display: 'grid',
		gridTemplateColumns: '1fr 1fr 1fr 1fr',
		overflow: 'auto',
		height: '100%',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		gridAutoRows: 'max-content',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: `${theme.palette.primary.main}9e`,
			transition: 'background ease-in 0.15s',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: `${theme.palette.primary.main}61`,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	inventoryWeight: {
		padding: 5,
		position: 'relative',
	},
	weightText: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		top: 0,
		bottom: 0,
		right: '2%',
		margin: 'auto',
		zIndex: 1,
		fontSize: 16,
		textShadow: `0 0 10px ${theme.palette.secondary.dark}`,
		'&::after': {
			content: '"lbs"',
			marginLeft: 5,
			color: theme.palette.text.alt,
		},
	},
	inventoryWeightBar: {
		height: 25,
		borderRadius: 5,
	},
	inventoryLeftHeader: {
		paddingLeft: 15,
		fontWeight: 'bold',
		marginTop: 10,
		fontSize: 18,
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	inventoryLeftSubHeader: {
		paddingLeft: 15,
		fontSize: 13,
		marginBottom: 5,
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	inventoryRightHeader: {
		width: '100%',
		textAlign: 'right',
		paddingRight: 15,
		marginTop: 10,
		fontWeight: 'bold',
		fontSize: 18,
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	inventoryRightSubHeader: {
		width: '100%',
		textAlign: 'right',
		paddingRight: 15,
		fontSize: 13,
		height: 17,
		marginBottom: 5,
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	slot: {
		width: '100%',
		height: '120px',
		backgroundColor: theme.palette.secondary.dark,
		border: `1px solid ${theme.palette.secondary.light}`,
		position: 'relative',
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	count: {
		bottom: theme.spacing(1),
		right: theme.spacing(2),
		width: '10%',
		height: '10%',
		position: 'absolute',
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	useBtn: {
		width: 150,
		height: 175,
		lineHeight: '175px',
		textAlign: 'center',
		fontSize: 36,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		backgroundColor: `${theme.palette.secondary.dark}61`,
		border: `1px solid ${theme.palette.border.divider}`,
		borderRadius: 5,
		transition:
			'background ease-in 0.15s, border ease-in 0.15s, color ease-in 0.15s',
		'&:hover': {
			backgroundColor: `${theme.palette.secondary.dark}9e`,
			borderColor: theme.palette.primary.main,
			color: theme.palette.primary.main,
		},
	},
	loader: {
		position: 'absolute',
		width: 'fit-content',
		height: 'fit-content',
		top: 0,
		bottom: 0,
		right: 0,
		left: 0,
		margin: 'auto',
		textAlign: 'center',
		'& span': {
			display: 'block',
		},
	},
	help: {
		position: 'absolute',
		width: 40,
		height: 40,
		bottom: '5%',
		left: 0,
		right: 0,
		margin: 'auto',
	},
	helpModal: {
		position: 'absolute',
		top: '50%',
		left: '50%',
		transform: 'translate(-50%, -50%)',
		width: 400,
		background: theme.palette.secondary.dark,
		boxShadow: 24,
		padding: 10,
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const itemsLoaded = useSelector((state) => state.inventory.itemsLoaded);
	const playerInventory = useSelector((state) => state.inventory.player);
	const secondaryInventory = useSelector(
		(state) => state.inventory.secondary,
	);
	const showSecondary = useSelector((state) => state.inventory.showSecondary);
	const showSplit = useSelector((state) => state.inventory.splitItem);
	const hover = useSelector((state) => state.inventory.hover);
	const hoverOrigin = useSelector((state) => state.inventory.hoverOrigin);
	const items = useSelector((state) => state.inventory.items);
	const inUse = useSelector((state) => state.inventory.inUse);

	const [showHelp, setShowHelp] = useState(false);

	const calcPlayerWeight = () => {
		if (Object.keys(items) == 0) return 0;

		return Object.keys(playerInventory.inventory)
			.filter((a) => Boolean(playerInventory.inventory[a]))
			.reduce((a, b) => {
				return (
					a +
					(items[playerInventory.inventory[b].Name]?.weight || 0) *
						playerInventory.inventory[b].Count
				);
			}, 0);
	};

	const calcSecondaryWeight = () => {
		if (Object.keys(items) == 0) return 0;

		if (Boolean(secondaryInventory.inventory)) {
			return Object.keys(secondaryInventory.inventory)
				.filter((a) => Boolean(secondaryInventory.inventory[a]))
				.reduce((a, b) => {
					return (
						a +
						(items[secondaryInventory.inventory[b].Name]?.weight ||
							0) *
							secondaryInventory.inventory[b].Count
					);
				}, 0);
		} else {
			return 0;
		}
	};

	const playerWeight = calcPlayerWeight();
	const secondaryWeight = calcSecondaryWeight();

	useEffect(() => {
		return () => {
			closeContext();
			closeSplitContext();
		};
	}, []);

	const [offset, setOffset] = useState({
		left: 110,
		top: 0,
	});

	const isUsable = () => {
		if (Object.keys(items) == 0) return false;

		return (
			!Boolean(inUse) &&
			Boolean(hover) &&
			Boolean(items[hover.Name]) &&
			hoverOrigin?.owner == playerInventory.owner &&
			items[hover.Name].isUsable &&
			(!Boolean(items[hover.Name].durability) ||
				hover.MetaData?.CreateDate + items[hover.Name].durability >
					Date.now() / 1000)
		);
	};

	const onRightClick = (
		e,
		owner,
		invType,
		isShop,
		isFree,
		item,
		vehClass = false,
		vehModel = false,
	) => {
		e.preventDefault();
		if (Object.keys(items) == 0) return;
		if (hoverOrigin != null) return;

		setOffset({ left: e.clientX - 2, top: e.clientY - 4 });

		if (
			(isShop &&
				!playerInventory.isWeaponsEligble &&
				items[item.Name]?.type == 2) ||
			(items[item.Name]?.type == 10 &&
				secondaryInventory.owner ==
					`container:${item?.MetaData?.Container}`)
		) {
			Nui.send('FrontEndSound', 'DISABLED');
			return;
		}

		if (item.Name != null) {
			if (e.ctrlKey || !items[item.Name]?.isStackable) {
				dispatch({
					type: 'SET_HOVER',
					payload: {
						...item,
						slot: item.Slot,
						owner: owner,
						shop: isShop,
						free: isFree,
						invType: invType,
						Count: 1,
					},
				});
				dispatch({
					type: 'SET_HOVER_ORIGIN',
					payload: {
						...item,
						slot: item.Slot,
						owner: owner,
						shop: isShop,
						invType: invType,
						class: vehClass,
						model: vehModel,
					},
				});

				closeContext();
				closeSplitContext();
			} else if (e.shiftKey) {
				dispatch({
					type: 'SET_SPLIT_ITEM',
					payload: {
						owner,
						item,
						invType,
						shop: isShop,
						class: vehClass,
						model: vehModel,
					},
				});
			} else {
				dispatch({
					type: 'SET_HOVER',
					payload: {
						...item,
						slot: item.Slot,
						owner: owner,
						shop: isShop,
						free: isFree,
						invType: invType,
						Count: item.Count > 1 ? Math.floor(item.Count / 2) : 1,
					},
				});
				dispatch({
					type: 'SET_HOVER_ORIGIN',
					payload: {
						...item,
						slot: item.Slot,
						owner: owner,
						shop: isShop,
						invType: invType,
					},
				});

				closeContext();
				closeSplitContext();
			}
		}
	};

	const cancelDrag = (e) => {
		if (Boolean(hoverOrigin)) {
			Nui.send('FrontEndSound', 'DISABLED');
			dispatch({
				type: 'SET_HOVER',
				payload: null,
			});
			dispatch({
				type: 'SET_HOVER_ORIGIN',
				payload: null,
			});
		}
	};

	const closeContext = (e) => {
		if (e != null) e.preventDefault();
		dispatch({
			type: 'SET_CONTEXT_ITEM',
			payload: null,
		});
	};

	const closeSplitContext = (e) => {
		if (e != null) e.preventDefault();
		dispatch({
			type: 'SET_SPLIT_ITEM',
			payload: null,
		});
	};

	if (!itemsLoaded || Object.keys(items).length == 0) {
		return (
			<div className={classes.loader}>
				<CircularProgress size={36} style={{ margin: 'auto' }} />
				<span>Loading Inventory Items</span>
				<Alert
					style={{ marginTop: 20 }}
					variant="outlined"
					severity="info"
				>
					If you see this for a long period of time, there may be an
					issue. Try restarting your FiveM.
				</Alert>
			</div>
		);
	} else {
		return (
			<Fragment>
				<Fade in={isUsable()}>
					<div
						className={classes.useBtn}
						onMouseUp={() => {
							if (!Boolean(hover) || hover?.invType != 1) return;
							useItem(hover?.owner, hover?.Slot, hover?.invType);
							dispatch({
								type: 'USE_ITEM_PLAYER',
								payload: {
									originSlot: hover?.Slot,
								},
							});
							dispatch({
								type: 'SET_HOVER',
								payload: null,
							});
							dispatch({
								type: 'SET_HOVER_ORIGIN',
								payload: null,
							});
						}}
					>
						<FontAwesomeIcon icon={['fas', 'bullseye-pointer']} />
					</div>
				</Fade>
				<div className={classes.root} onClick={cancelDrag}>
					<div onClick={cancelDrag}>
						<div className={classes.inventoryLeftHeader}>
							{playerInventory.name}
						</div>
						<div className={classes.container}>
							<div className={classes.inventoryWeight}>
								<div className={classes.weightText}>
									{`${playerWeight.toFixed(
										2,
									)} / ${playerInventory.capacity.toFixed(
										2,
									)}`}
								</div>
								<LinearProgress
									className={classes.inventoryWeightBar}
									color="info"
									variant="determinate"
									value={Math.floor(
										(playerWeight /
											playerInventory.capacity) *
											100,
									)}
								/>
							</div>
							<div className={classes.inventoryGrid}>
								{[...Array(playerInventory.size).keys()].map(
									(value) => {
										return (
											<Slot
												key={value + 1}
												onUse={useItem}
												slot={value + 1}
												owner={playerInventory.owner}
												invType={
													playerInventory.invType
												}
												shop={false}
												free={false}
												hotkeys={true}
												onContextMenu={(e) => {
													if (
														playerInventory
															.disabled[value + 1]
													)
														return;
													onRightClick(
														e,
														playerInventory.owner,
														playerInventory.invType,
														false,
														false,
														playerInventory
															.inventory[
															value + 1
														]
															? playerInventory
																	.inventory[
																	value + 1
															  ]
															: {},
													);
												}}
												locked={
													playerInventory.disabled[
														value + 1
													]
												}
												data={
													playerInventory.inventory[
														value + 1
													]
														? playerInventory
																.inventory[
																value + 1
														  ]
														: {}
												}
											/>
										);
									},
								)}
							</div>
						</div>
					</div>
					<Fade in={showSecondary}>
						<div>
							<div className={classes.inventoryRightHeader}>
								{secondaryInventory.name}
							</div>
							<div className={classes.container}>
								<div className={classes.inventoryWeight}>
									{!secondaryInventory.shop && (
										<div className={classes.weightText}>
											{`${secondaryWeight.toFixed(
												2,
											)} / ${secondaryInventory.capacity.toFixed(
												2,
											)}`}
										</div>
									)}
									<LinearProgress
										className={classes.inventoryWeightBar}
										color="info"
										variant="determinate"
										value={
											secondaryInventory.shop
												? 0
												: Math.floor(
														(secondaryWeight /
															secondaryInventory.capacity) *
															100,
												  )
										}
									/>
								</div>
								{secondaryInventory.size <= 0 ? (
									<div className={classes.inventoryGrid}>
										<Alert
											variant="filled"
											severity="error"
										>
											{secondaryInventory.name} Has No
											Slots
										</Alert>
									</div>
								) : (
									<div className={classes.inventoryGrid}>
										{[
											...Array(
												secondaryInventory.size,
											).keys(),
										].map((value) => {
											return (
												<Slot
													slot={value + 1}
													key={value + 1}
													owner={
														secondaryInventory.owner
													}
													invType={
														secondaryInventory.invType
													}
													shop={
														secondaryInventory.shop
													}
													free={
														secondaryInventory.free
													}
													vehClass={
														secondaryInventory.class
													}
													vehModel={
														secondaryInventory.model
													}
													hotkeys={false}
													onContextMenu={(e) => {
														if (
															secondaryInventory
																.disabled[
																value + 1
															]
														)
															return;
														onRightClick(
															e,
															secondaryInventory.owner,
															secondaryInventory.invType,
															secondaryInventory.shop,
															secondaryInventory.free,
															secondaryInventory
																.inventory[
																value + 1
															]
																? secondaryInventory
																		.inventory[
																		value +
																			1
																  ]
																: {},
															secondaryInventory.class,
															secondaryInventory.model,
														);
													}}
													locked={
														secondaryInventory
															.disabled[value + 1]
													}
													data={
														secondaryInventory
															.inventory[
															value + 1
														]
															? secondaryInventory
																	.inventory[
																	value + 1
															  ]
															: {}
													}
												/>
											);
										})}
									</div>
								)}
							</div>
						</div>
					</Fade>
				</div>

				<IconButton
					className={classes.help}
					onClick={() => setShowHelp(true)}
				>
					<FontAwesomeIcon icon={['fas', 'question']} />
				</IconButton>

				<Modal open={showHelp} onClose={() => setShowHelp(false)}>
					<Box className={classes.helpModal}>
						<Typography
							id="modal-modal-title"
							variant="h6"
							component="h2"
						>
							Inventory Keys
						</Typography>
						<Typography id="modal-modal-description" sx={{ mt: 2 }}>
							Our inventory makes use of some hotkeys to
							facilitate quick operations. These keys can be found
							below;
						</Typography>
						<ul>
							<li>
								<b>Shift Left Click: </b>Quick Transfer. Move
								Stack To Other Inventory (If Possible)
							</li>
							<li>
								<b>Shift Right Click: </b>Split Stack. Brings Up
								Prompt To Split Stack (If Possible)
							</li>
							<li>
								<b>Control Left Click: </b>Half Stack. Starts
								Dragging Half Of The Selected Stack (If
								Possible)
							</li>
							<li>
								<b>Control Right Click: </b>Single Item. Starts
								Dragging A Single Item Of The Selected Stack
							</li>
							<li>
								<b>Middle Mouse Button: </b>Use Item. Uses
								Selected Item (If Possible)
							</li>
						</ul>
					</Box>
				</Modal>

				{showSplit != null ? (
					<Menu
						keepMounted
						onClose={closeSplitContext}
						onContextMenu={closeSplitContext}
						open={!!showSplit}
						anchorReference="anchorPosition"
						anchorPosition={offset}
						TransitionComponent={Fade}
					>
						<MenuItem disabled>Split Stack</MenuItem>
						<Split data={showSplit} />
					</Menu>
				) : null}
			</Fragment>
		);
	}
};
