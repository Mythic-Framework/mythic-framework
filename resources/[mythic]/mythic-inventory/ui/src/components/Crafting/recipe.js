import React, { useState } from 'react';
import {
	LinearProgress,
	Button,
	Grid,
	TextField,
	IconButton,
	Popover,
} from '@mui/material';
import Truncate from 'react-truncate';
import { makeStyles } from '@mui/styles';
import { useDispatch, useSelector } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import NumberFormat from 'react-number-format';
import ReactMomentCountDown from 'react-moment-countdown';

import Nui from '../../util/Nui';
import Reagent from './Reagent';
import Tooltip from './Tooltip';
import { DurationToTime } from '../../util/Parser';
import Moment from 'react-moment';

const useStyles = makeStyles((theme) => ({
	recipe: {
		height: 250,
		border: `1px solid ${theme.palette.border.divider}`,
	},
	craftBtn: {
		width: '100%',
		height: '100%',
		borderRadius: 0,
		lineHeight: '200px',
		borderRight: `1px solid ${theme.palette.border.divider}`,
		'&.Mui-disabled': {
			background: '#1e1e1e',
		},
	},
	content: {
		height: 215,
		background: theme.palette.secondary.dark,
	},
	bottomBar: {
		height: 35,
		lineHeight: '35px',
		background: theme.palette.secondary.light,
		borderTop: `1px solid ${theme.palette.border.divider}`,
	},
	title: {
		width: '100%',
	},
	progress: {
		height: 35,
		borderTop: `1px solid ${theme.palette.border.divider}`,
		position: 'relative',
	},
	progressTxt: {
		position: 'absolute',
		width: 'fit-content',
		height: 'fit-content',
		top: 0,
		bottom: 0,
		left: 15,
		margin: 'auto',
		zIndex: 1,
	},
	progressBar: {
		height: '100%',
	},
	img: {
		width: '80%',
		maxWidth: 170,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	topBar: {
		height: 55,
		lineHeight: '55px',
		fontSize: 28,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		marginBottom: 5,
	},
	ingredients: {
		height: 155,
		overflow: 'auto',
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
	count: {
		color: theme.palette.primary.main,
		fontWeight: 'bold',
		marginRight: 2,
		fontSize: 16,
		'&::after': {
			content: '"x"',
		},
	},
	input: {
		width: 25,
		marginTop: 10,
		'& input': {
			textAlign: 'center',
			color: theme.palette.primary.main,
		},
		'& input::-webkit-clear-button, & input::-webkit-outer-spin-button, & input::-webkit-inner-spin-button':
			{
				display: 'none',
			},
	},
	popover: {
		pointerEvents: 'none',
	},
	paper: {
		padding: 20,
		border: `1px solid ${theme.palette.border.divider}`,
	},
	craftTime: {
		marginLeft: 15,
		'& span': {
			color: theme.palette.info.main,
			marginLeft: 5,
			'&::after': {
				content: '"s"',
			},
		},
	},
	cooldown: {
		display: 'inline-block',
		width: 'fit-content',
		height: 'fit-content',
		float: 'right',
		marginRight: 10,

		'& b': {
			marginLeft: 6,
		},
	},
}));

const getCraftingItemImage = (item, itemData) => {
	if (Boolean(itemData) && Boolean(itemData.iconOverride)) {
		return `../images/items/${itemData.iconOverride}.webp`;
	} else {
		return `../images/items/${item.name}.webp`;
	}
};

const Recipe = ({ index, recipe, cooldown }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const hidden = useSelector((state) => state.app.hidden);
	const items = useSelector((state) => state.inventory.items);
	const bench = useSelector((state) => state.crafting.bench);
	const action = useSelector((state) => state.crafting.actionString);
	const crafting = useSelector((state) => state.crafting.crafting);
	const myCounts = useSelector((state) => state.crafting.myCounts);

	const [qty, setQty] = useState(1);

	const [resultEl, setResultEl] = useState(null);
	const resultOpen = Boolean(resultEl);
	const resultTPOpen = (event) => {
		setResultEl(event.currentTarget);
	};

	const resultTPClose = () => {
		setResultEl(null);
	};

	const hasReagents = () => {
		let reagents = Object(); // Doing this so if some douche adds the same item multiple times it'll check for all
		recipe.items.map((item, k) => {
			if (!Boolean(reagents[item.name]))
				reagents[item.name] = item.count * qty;
			else reagents[item.name] += item.count * qty;
		});

		for (const item in reagents) {
			if (!Boolean(myCounts[item]) || reagents[item] > myCounts[item])
				return false;
		}

		return true;
	};

	const craft = async () => {
		if (Boolean(crafting)) return;

		try {
			let res = await (
				await Nui.send('Crafting:Craft', {
					bench,
					qty,
					result: recipe.id,
				})
			).json();

			if (res) {
				Nui.send('FrontEndSound', 'SELECT');
				dispatch({
					type: 'SET_CRAFTING',
					payload: {
						recipe: recipe.id,
						start: Date.now(),
						time: recipe.time * qty,
					},
				});
			} else {
				Nui.send('FrontEndSound', 'DISABLED');
			}
		} catch (err) {}
	};

	const cancel = async () => {
		let res = await (await Nui.send('Crafting:Cancel')).json();
		if (res) {
			Nui.send('FrontEndSound', 'BACK');
			dispatch({
				type: 'END_CRAFTING',
			});
		} else {
			Nui.send('FrontEndSound', 'DISABLED');
		}
	};

	const onQtyChange = (change) => {
		if (Boolean(recipe.cooldown)) return;

		if ((change < 0 && qty <= 1) || (change > 1 && qty >= 99)) return;
		setQty(qty + change);
	};

	return (
		<Grid container className={classes.recipe}>
			<Grid item xs={1}>
				{!Boolean(crafting) || crafting.recipe != recipe.id ? (
					<Button
						variant="contained"
						color="info"
						disabled={
							Boolean(crafting) ||
							!hasReagents() ||
							(Boolean(recipe.cooldown) &&
								Boolean(cooldown) &&
								cooldown > Date.now())
						}
						className={classes.craftBtn}
						onClick={craft}
					>
						{Boolean(crafting) || !hasReagents() ? (
							<FontAwesomeIcon icon={['fas', 'ban']} />
						) : (
							<FontAwesomeIcon icon={['fas', 'hammer']} />
						)}
					</Button>
				) : (
					<Button
						variant="contained"
						color="error"
						disabled={!Boolean(crafting)}
						className={classes.craftBtn}
						onClick={cancel}
					>
						<FontAwesomeIcon icon={['fas', 'x']} />
					</Button>
				)}
			</Grid>
			<Grid item xs={11}>
				<Grid container className={classes.content}>
					<Grid item xs={3} style={{ position: 'relative' }}>
						<img
							className={classes.img}
							src={getCraftingItemImage(
								recipe.result,
								items[recipe.result.name],
							)}
							onMouseEnter={resultTPOpen}
							onMouseLeave={resultTPClose}
						/>
					</Grid>
					<Grid item xs={9} style={{ height: '100%' }}>
						<Grid container className={classes.topBar}>
							<Grid item xs={9}>
								<span className={classes.count}>
									{recipe.result.count * qty}
								</span>
								<Truncate lines={1} className={classes.title}>
									{items[recipe.result.name].label}
								</Truncate>
							</Grid>
							<Grid item xs={3} style={{ textAlign: 'right' }}>
								{!Boolean(recipe.cooldown) && (
									<Grid container>
										<Grid
											item
											xs={4}
											style={{ textAlign: 'center' }}
										>
											<IconButton
												disabled={
													Boolean(recipe.cooldown) ||
													qty <= 1
												}
												onClick={() => onQtyChange(-1)}
											>
												<FontAwesomeIcon
													icon={['fas', 'minus']}
												/>
											</IconButton>
										</Grid>
										<Grid
											item
											xs={4}
											style={{ textAlign: 'center' }}
										>
											<span>
												<NumberFormat
													className={classes.input}
													value={qty}
													onChange={(e) =>
														setQty(+e.target.value)
													}
													isAllowed={({
														floatValue,
													}) => {
														return (
															floatValue >= 1 &&
															floatValue <= 99
														);
													}}
													disabled={Boolean(
														recipe.cooldown,
													)}
													type="tel"
													isNumericString
													variant="standard"
													customInput={TextField}
												/>
											</span>
										</Grid>
										<Grid
											item
											xs={4}
											style={{ textAlign: 'center' }}
										>
											<IconButton
												disabled={
													Boolean(recipe.cooldown) ||
													qty >= 99
												}
												onClick={() => onQtyChange(1)}
											>
												<FontAwesomeIcon
													icon={['fas', 'plus']}
												/>
											</IconButton>
										</Grid>
									</Grid>
								)}
							</Grid>
						</Grid>
						<Grid container className={classes.ingredients}>
							{recipe.items.map((item, k) => {
								return (
									<Reagent
										key={`${recipe.name}-${index}-ing-${k}`}
										item={item}
										qty={qty}
									/>
								);
							})}
						</Grid>
					</Grid>
				</Grid>

				{Boolean(recipe.cooldown) &&
				Boolean(cooldown) &&
				cooldown > Date.now() ? (
					<div className={classes.bottomBar}>
						<span className={classes.craftTime}>
							Craft Available{' '}
							<Moment date={cooldown} interval={1000} fromNow />
						</span>
					</div>
				) : Boolean(crafting) &&
				  crafting.recipe == recipe.id &&
				  recipe.time > 0 ? (
					<div className={classes.progress}>
						<span className={classes.progressTxt}>{`${Math.floor(
							crafting.progress,
						)}%`}</span>
						<LinearProgress
							color="info"
							className={classes.progressBar}
							value={Math.floor(crafting.progress)}
							variant={'determinate'}
						/>
					</div>
				) : (
					<div className={classes.bottomBar}>
						{recipe.time > 0 ? (
							<span className={classes.craftTime}>
								{action} Time:
								<span>{(recipe.time * qty) / 1000}</span>
							</span>
						) : (
							<span className={classes.craftTime}>Instant</span>
						)}
						{Boolean(recipe.cooldown) && (
							<span className={classes.cooldown}>
								Crafting Cooldown:
								<b>{DurationToTime(recipe.cooldown)}</b>
							</span>
						)}
					</div>
				)}
			</Grid>
			<Popover
				className={classes.popover}
				classes={{
					paper: classes.paper,
				}}
				open={resultOpen && !hidden}
				anchorEl={resultEl}
				anchorOrigin={{
					vertical: 'center',
					horizontal: 'right',
				}}
				transformOrigin={{
					vertical: 'top',
					horizontal: 'center',
				}}
				onClose={resultTPClose}
				disableRestoreFocus
			>
				<Tooltip
					item={items[recipe.result.name]}
					count={recipe.result.count}
				/>
			</Popover>
		</Grid>
	);
};

export default Recipe;
