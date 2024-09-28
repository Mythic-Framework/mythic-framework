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
	Tooltip,
	Button,
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
	// gridBg: {
	// 	background: `#00643a1a`,
	// 	padding: 25,
	// 	border: `1px solid rgba(255, 255, 255, 0.04)`,
	// 	height: 'fit-content',
	// },
	container: {
		userSelect: 'none',
		'-webkit-user-select': 'none',
		width: '100%',
		height: 'fit-content',
	},
	inventoryGrid: {
		display: 'grid',
		gridTemplateColumns: '1fr 1fr 1fr 1fr 1fr',
		overflowX: 'hidden',
		overflowY: 'scroll',
		maxHeight: 'calc(60vh - 90px)',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		minWidth: 645,
		gridAutoRows: 'max-content',
		gap: 1,
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: `${theme.palette.primary.light}9e`,
			transition: 'background ease-in 0.15s',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: `${theme.palette.primary.light}61`,
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
		fontSize: 12,
		textShadow: `0 0 10px ${'rgba(12,24,38, 0.733)'}`,
		'&::after': {
			content: '"lbs"',
			marginLeft: 5,
			color: theme.palette.text.alt,
		},
	},
	inventoryWeightBar: {
		height: 20,
		borderRadius: 5,
	},
	inventoryHeader: {
		paddingLeft: 5,
		// fontWeight: 'bold',
		fontSize: 15,
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	slot: {
		width: '100%',
		height: '120px',
		background: '0b0a25b7',
		// border: `1px solid rgba(12,24,38, 0.733)`, -- Removed to be more 1:1
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
		width: 130,
		height: 130,
		lineHeight: '130px',
		textAlign: 'center',
		fontSize: 36,
		position: 'absolute',
		forceVisibility: 'visible',
		visibility: 'visible',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		background: `rgb(13,22,37, 0.733)`,
		border: `1px solid transparent`,
		transition:
			'background ease-in 0.15s, border ease-in 0.15s, color ease-in 0.15s',
		'&:hover': {
			background: `${theme.palette.secondary.dark}9e`,
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
	buttons: {
		position: 'absolute',
		left: 0,
		right: 0,
		bottom: 125,
		margin: 'auto',
		width: 'fit-content',
		height: 40,
		display: 'flex',
		gap: 10,
	},
	button: {
		width: 40,
		height: 40,
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
	actionBtn: {
		textAlign: 'center',
		marginTop: 15,
		padding: 10,
		color: theme.palette.text.main,
		background: `rgba(12,24,38, 0.733)`,
		border: `1px solid transparent`,
		transition: 'border ease-in 0.15s',
		'&:hover': {
			background: `rgba(12,24,38, 0.733)`,
			borderColor: theme.palette.primary.main,
			cursor: 'pointer',
		},

		'& svg': {
			marginLeft: 6,
		},
	},
}));

export default (props) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const settings = useSelector((state) => state.app.settings);
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

	const onToggleSound = () => {
		Nui.send('UpdateSettings', {
			muted: !settings.muted,
		});
	};

	const calcPlayerWeight = () => {
		if (Object.keys(items) == 0 || !playerInventory.loaded) return 0;
		return playerInventory.inventory
			.filter((s) => Boolean(s))
			.reduce((a, b) => {
				return a + (items[b.Name]?.weight || 0) * b.Count;
			}, 0);
	};

	const calcSecondaryWeight = () => {
		if (Object.keys(items) == 0 || !secondaryInventory.loaded) return 0;
		return secondaryInventory.inventory
			.filter((s) => Boolean(s))
			.reduce((a, b) => {
				return a + (items[b.Name]?.weight || 0) * b.Count;
			}, 0);
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
				hover?.CreateDate + items[hover.Name].durability >
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
			(isShop && !playerInventory.isWeaponEligble && items[item.Name]?.type == 2) ||
			(items[item.Name]?.type == 10 && secondaryInventory.owner == `container:${item?.MetaData?.Container}`)
		) {
			console.log('yeetus deletus')
			Nui.send('FrontEndSound', 'DISABLED');
			return;
		}

		if (item.Name != null) {
			if (e.ctrlKey || !items[item.Name]?.isStackable) {
				dispatch({
					type: 'SET_HOVER',
					payload: {
						...item,
						slot: item?.Slot,
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
						slot: item?.Slot,
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
						slot: item?.Slot,
						owner: owner,
						shop: isShop,
						free: isFree,
						invType: invType,
						Count:
							item.Count > 1
								? Math.max(
										1,
										Math.min(
											Math.floor(item.Count / 2),
											10000,
										),
								  )
								: 1,
					},
				});
				dispatch({
					type: 'SET_HOVER_ORIGIN',
					payload: {
						...item,
						slot: item?.Slot,
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

	const onAction = () => {
		Nui.send('FrontEndSound', 'SELECT');
		Nui.send('SubmitAction', {
			owner: secondaryInventory.owner,
			invType: secondaryInventory.invType,
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
						<FontAwesomeIcon icon={['fas', 'fingerprint']} />
					</div>
				</Fade>
				<div 
					style ={{
						display: "flex",
						justifyContent: "center",
						alignItems: "center",
						width: '100%',
						height: '100%',
					}} 
				>
					<div
						style ={{
							width: '90%',
							height: '60%',
						}} 
					>
						<div className={classes.root} onClick={cancelDrag}>
							<div className={classes.gridBg} onClick={cancelDrag}>
								<div className={classes.inventoryHeader}>
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
										{playerInventory.loaded &&
											[...Array(playerInventory.size).keys()].map(
												(value) => {
													let slot =
														playerInventory.inventory.filter(
															(s) =>
																Boolean(s) &&
																s.Slot == value + 1,
														)
															? playerInventory.inventory.filter(
																	(s) =>
																		Boolean(s) &&
																		s.Slot ==
																			value + 1,
															)[0]
															: {};
													return (
														<Slot
															key={value + 1}
															onUse={useItem}
															slot={value + 1}
															data={slot}
															owner={
																playerInventory.owner
															}
															invType={
																playerInventory.invType
															}
															shop={false}
															free={false}
															hotkeys={true}
															onContextMenu={(e) => {
																if (
																	playerInventory
																		.disabled[
																		value + 1
																	]
																)
																	return;
																onRightClick(
																	e,
																	playerInventory.owner,
																	playerInventory.invType,
																	false,
																	false,
																	slot,
																);
															}}
															locked={
																playerInventory
																	.disabled[value + 1]
															}
														/>
													);
												},
											)}
									</div>
								</div>
							</div>
							<Fade in={showSecondary}>
								<div className={classes.gridBg}>
									<div className={classes.inventoryHeader}>
										{secondaryInventory.name}
									</div>
									<div className={classes.container}>
										<div className={classes.inventoryWeight}>
											{!secondaryInventory.shop && (
												<>
													<div className={classes.weightText}>
														{`${secondaryWeight.toFixed(
															2,
														)} / ${secondaryInventory.capacity.toFixed(
															2,
														)}`}
													</div>
													<LinearProgress
														className={
															classes.inventoryWeightBar
														}
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
												</>
											)}
										</div>
										<div className={classes.inventoryGrid}>
											{secondaryInventory.loaded &&
												[
													...Array(
														secondaryInventory.size,
													).keys(),
												].map((value) => {
													let slot =
														secondaryInventory.inventory.filter(
															(s) =>
																Boolean(s) &&
																s.Slot == value + 1,
														)
															? secondaryInventory.inventory.filter(
																	(s) =>
																		Boolean(s) &&
																		s.Slot ==
																			value + 1,
															)[0]
															: {};
													return (
														<Slot
															slot={value + 1}
															key={value + 1}
															data={slot}
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
															slotOverride={
																secondaryInventory.slotOverride
															}
															capacityOverride = {
																secondaryInventory.capacityOverride
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
																	slot,
																	secondaryInventory.class,
																	secondaryInventory.model,
																);
															}}
															locked={
																secondaryInventory
																	.disabled[value + 1]
															}
														/>
													);
												})}
										</div>
									</div>
									{Boolean(secondaryInventory.action) && (
										<Button
											fullWidth
											color="primary"
											className={classes.actionBtn}
											onClick={onAction}
										>
											{secondaryInventory.action.text}
											<FontAwesomeIcon
												icon={[
													'fas',
													secondaryInventory.action.icon ||
														'right-from-line',
												]}
											/>
										</Button>
									)}
								</div>
							</Fade>
						</div>
					</div>
				</div>

				<div className={classes.buttons}>
					<Tooltip title="Show UI Help">
						<IconButton
							className={classes.button}
							onClick={() => setShowHelp(true)}
						>
							<FontAwesomeIcon icon={['fas', 'question']} />
						</IconButton>
					</Tooltip>

					<Tooltip
						title={
							Boolean(settings.muted)
								? 'Unmute UI Sounds'
								: 'Mute UI Sounds'
						}
					>
						<IconButton
							className={classes.button}
							onClick={onToggleSound}
						>
							{Boolean(settings.muted) ? (
								<FontAwesomeIcon
									color="red"
									icon={['fas', 'volume-xmark']}
								/>
							) : (
								<FontAwesomeIcon
									color="green"
									icon={['fas', 'volume-high']}
								/>
							)}
						</IconButton>
					</Tooltip>
				</div>

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
