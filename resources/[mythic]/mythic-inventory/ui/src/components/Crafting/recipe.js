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

import Nui from '../../util/Nui';
import Reagent from './Reagent';
import Tooltip from './Tooltip';
import { DurationToTime } from '../../util/Parser';
import Moment from 'react-moment';
import { getItemImage } from '../Inventory/item';
import { useTheme } from '@mui/material/styles';

const useStyles = makeStyles((theme) => ({
	customRippleGreen: {
		color: 'rgba(0, 36, 0, 0.9)', 
	},
	customRippleRed: {
		color: 'rgba(219, 40, 9, 0.9)', 
	},
	wrapper: {
		width: "100%",
		height: "100%",
		background: 'radial-gradient(circle at top, rgba(46, 62, 79, 0.8) 5%, rgba(10, 14, 18, 0.8) 80%)',
		backgroundColor: "rgba(9, 49, 71, 0.6)",
		borderRadius: '1.5vh',
		padding: "2%",      
		display: "flex",
		flexDirection: "column",
		justifyContent: "center",
		alignItems: "space-between",
		//maxHeight: "100%",
	},

	TopContainer: {
		flex: '0 0 25%',
		//backgroundColor: "yellow",
		width: "100%",
		//padding: "2%",   
		display: "flex",
		justifyContent: "space-between",
		alignItems: "center",
		flexDirection: "row", 
		overflow: 'hidden', 
	},
	topLeftContainer: {
		padding: "2%", 
		flex: '0 0 20%',
		height: "100%",
		//backgroundColor: "purple",
		display: "flex",
		justifyContent: "center",
		alignItems: "center",
		borderRadius: '1.5vh',
	},
	topRightContainer: {
		padding: "2%", 
		flex: '0 0 78%',
		height: "100%",
		//backgroundColor: "purple",
		display: "flex",
		justifyContent: "flex-start",
		alignItems: "space-between",
		borderRadius: '1.5vh',
		flexDirection: "column",
		overflow: "hidden",
	},
	toprightTopContainer: {
		overflow: "hidden",
		flex: '0 0 35%',
		//backgroundColor: "red",
		fontSize: "2.5vh",
		fontWeight: 700,
		display: "flex",
		justifyContent: "flex-start",
		alignItems: "center",
	},
	toprightSpaceContainer: {
		flex: '0 0 15%',
	},
	toprightMiddleContainer: {
		display: "flex",
		alignItems: "center",
		flex: '0 0 25%',
		color: "blue",
	},
	toprightBottomContainer: {
		display: "flex",
		alignItems: "center",
		flex: '0 0 25%',
		color: "blue",
	},
	mainImage: {
		height: "auto",
		width: '100%',
		//backgroundColor: "orange",
		objectFit: 'contain', 
	},

	MiddleContainer: {
		flex: '0 0 65%',
		width: "100%",  
		paddingTop: "4%",
		display: "flex",
		overflow: "hidden",
	},
	middleCraftContainer: {
		backgroundColor: "rgba(0, 18, 28, 0.5)",
		borderRadius: '1.25vh',
		padding: "2%",    
		//minHeight: "25%",
		height: "auto",
		width: "100%",
		display: "flex",
		flexDirection: "column",
		overflow: "hidden",
	},
	middleTopContainer: {
		display: "flex",
		flex: "0 0 15%",
		//backgroundColor: "yellow",
		fontSize: "2vh",
		fontWeight: 800,
		justifyContent: "flex-start",
		alignItems: "flex-start",
	},
	middleBottomContainer: {
		flex: "1 1 auto",
		overflow: "auto",
		//backgroundColor: "white",
		display: 'grid',
		gridTemplateColumns: 'repeat(4, 15%)',
		justifyContent: "center",
		gap: "3vh",
		gridAutoRows: 'max-content',
	},

	BottomContainer: {
		flex: '0 0 10%',
		//backgroundColor: "orange",
		width: "100%",
		paddingTop: "2%",    
		display: "flex",
		flexDirection: "row",
		justifyContent: "space-between",
		alignItems: "center",
		overflow: "hidden",
	},
	bottomLeftContainer: {
		flex: '0 0 15%',
		boxShadow: 'inset 0 0 4vh rgba(48, 48, 48, 0.8)',
		height: "100%",
		display: "flex",
		alignItems: "center",
		justifyContent: "space-evenly",
		borderRadius: "1.25vh"
	},

	bottomRightContainer: {
		flex: '0 0 83%',
		//backgroundColor: "green",
		height: "100%",
		display: "flex",
		justifyContent: "space-evenly",
		alignItems: "center",
	},
	craftButton: {
		width: "100%",
		height: '100%',
		//backgroundColor: "green",
		color: "white",
		fontWeight: 600,
		'&:hover': {
			backgroundColor: 'rgba(1, 77, 0, 0.8)',
			//color: 'white',
		},
		//border: '2px solid rgba(214, 145, 26, 0.7)',
		boxShadow: 'inset 0 0 4vh rgba(2, 191, 0, 0.8)',
		borderRadius: '1.25vh',
		textTransform: "none",
		display: "flex",
		justifyContent: "center",
		fontSize: "1.5vh",
	},


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
		//backgroundColor: "red",
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

	inputText: {
		// marginLeft: "1vh",
		// marginRight: "1vh",
		textAlign: 'center',
		height: "100%",
		//sbackgroundColor: "yellow",
		fontSize: "2vh",
		width: "75%",
	},



	
	popoverContainer: {
		pointerEvents: 'none',
		fontSize: "1.5vh",
	},
	paperContainer: {
		padding: "1vh",
		border: `0.25vh solid ${theme.palette.primary.dark}`,
		borderRadius: "1.25vh",
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

const Recipe = ({ index, recipe, cooldown }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const hidden = useSelector((state) => state.app.hidden);
	const items = useSelector((state) => state.inventory.items);
	const bench = useSelector((state) => state.crafting.bench);
	
	const action = useSelector((state) => state.crafting.actionString);
	const crafting = useSelector((state) => state.crafting.crafting);
	const myCounts = useSelector((state) => state.crafting.myCounts);
	const theme = useTheme();

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
		let reagents = {}; 
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
	//console.log("RECIPE DATA", recipe);
	//console.log("ITEM DATA", items[recipe.result.name])

	const getRarityColor = (rarity) => {
		switch (rarity) {
		  case 1:
			return theme.palette.rarities.rare1;
		  case 2:
			return theme.palette.rarities.rare2;
		  case 3:
			return theme.palette.rarities.rare3;
		  case 4:
			return theme.palette.rarities.rare4;
		  case 5:
			return theme.palette.rarities.rare5;
		  default:
			return theme.palette.rarities.rare1;
		}
	};

	const craftItemData = items[recipe.result.name];
	//console.log("RARITY", craftItemData.rarity )
	return (
		<div className={classes.wrapper}>
			
			<Popover
				className={classes.popoverContainer}
				classes={{
					paper: `${classes.paperContainer} rarity-${
						craftItemData?.rarity
					}`,
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

			<div className={classes.TopContainer}>
				<div className={classes.topLeftContainer}
				style={{
					boxShadow: `inset 0 0 4vh ${getRarityColor(craftItemData.rarity)}`,
				}}		  
				>
					<img 
						className={classes.mainImage}
						src={getItemImage(
							recipe.result,
							items[recipe.result.name],
						)}
						onMouseEnter={resultTPOpen}
						onMouseLeave={resultTPClose}
					/>
				</div>

				<div className={classes.topRightContainer} >
					<div className={classes.toprightTopContainer} 
					style={{
						color: `${getRarityColor(craftItemData?.rarity)}`,
					}}
					>
						<Truncate lines={1} >
							{craftItemData.label}
						</Truncate>
					</div>
					{/* <div className={classes.toprightSpaceContainer} >

					</div> */}
					<div className={classes.toprightMiddleContainer} >
						<div style={{
							color: "white",
							marginRight: "0.5vh",
							fontWeight: 700,
							fontSize: "1.5vh",
						}} >
							Yield:
						</div>
						<div style={{
							color: `${getRarityColor(craftItemData?.rarity)}`, 
							fontWeight: 700,
							fontSize: "1.5vh",
						}} >
							{recipe.result.count * qty}pcs
						</div>
					</div>

					<div className={classes.toprightBottomContainer} >
						<div style={{
							color: "white",
							marginRight: "0.5vh",
							fontWeight: 700,
							fontSize: "1.5vh",
						}} >
							Crafting Time:
						</div>
						<div style={{
							color: `${getRarityColor(craftItemData?.rarity)}`, 
							fontWeight: 700,
							fontSize: "1.5vh",
						}} >
							{recipe.time > 0 ? (
								<span>
									{(recipe.time * qty) / 1000}sec
								</span>
		 					) : (
		 						<span>
									Instant
								</span>
		 					)}
							
						</div>
					</div>
					
					{Boolean(recipe.cooldown) && Boolean(cooldown) && cooldown > Date.now() && (
					<span style={{
						color: "white",
						marginRight: "0.5vh",
						fontWeight: 700,
						fontSize: "1.5vh",
					}}>
						Craft Available{' '}
						<Moment date={cooldown} interval={1000} fromNow />
					</span>
				)}
				</div>
           	 </div>
            <div className={classes.MiddleContainer}>
                <div className={classes.middleCraftContainer}>
					<div className={classes.middleTopContainer}>
						Items Required
					</div>
					<div className={classes.middleBottomContainer}>
						{recipe.items.map((item, k) => {
		 					return (
		 						<Reagent
									key={`${recipe.name}-${index}-ing-${k}`}
	 								item={item}
									qty={qty}
		 						/>
		 					);
		 				})}
					</div>
                </div>
            </div>
            <div className={classes.BottomContainer}>
                <div className={classes.bottomLeftContainer}>
		 			{/* {!Boolean(recipe.cooldown) && ( */}
						<span style={{
							display: "flex",
							alignItems: "center",
							justifyContent: "space-evenly",
							width: "100%",
							//height: "100%",
						}}>
							<IconButton
								disabled={
									Boolean(recipe.cooldown) ||
									qty <= 1
								}
								onClick={() => onQtyChange(-1)}
								style={{
									fontSize: "1.5vh",
								}}
							>
								<FontAwesomeIcon
									icon={['fas', 'minus']}
								/>
							</IconButton>

							<div className={classes.inputText} >
								{qty}
							</div>

							<IconButton
								disabled={
									Boolean(recipe.cooldown) ||
									qty >= 99
								}
								onClick={() => onQtyChange(1)}
								style={{
									fontSize: "1.5vh",
								}}
							>
								<FontAwesomeIcon
									icon={['fas', 'plus']}
								/>
							</IconButton>
						</span>
					{/* )} */}
                </div>
                <div className={classes.bottomRightContainer}>
					{Boolean(crafting) && crafting.recipe === recipe.id && recipe.time > 0 ? (
						<Button
							disabled={!Boolean(crafting)}
							className={classes.craftButton}
							onClick={cancel}
							style={{
								boxShadow: 'inset 0 0 4vh rgba(110, 9, 9, 0.8)', 
							}}
							TouchRippleProps={{
								classes: { ripple: classes.customRippleRed },
							}}
						>
							
							{/* <span className={classes.progressTxt}>
								{`${Math.floor(crafting.progress)}%`}
							</span>
						
							
							<LinearProgress
								color="info"
								className={classes.progressBar}
								value={Math.floor(crafting.progress)}
								variant="determinate"
								style={{ width: '100%', marginTop: '5px' }} 
							/>  */}
						
							Cancel
						</Button>
						) : (
						<Button
							className={classes.craftButton}
							onClick={craft}
							TouchRippleProps={{
								classes: { ripple: classes.customRippleGreen },
							}}
							disabled={
								Boolean(crafting) ||
								!hasReagents() ||
								(Boolean(recipe.cooldown) &&
								Boolean(cooldown) &&
								cooldown > Date.now())
							}
							style={  
								Boolean(crafting) || !hasReagents() || (Boolean(recipe.cooldown) && Boolean(cooldown) && cooldown > Date.now()) ? 
								{
									boxShadow: 'inset 0 0 4vh rgba(48, 48, 48, 0.8)',
								} : {
									boxShadow: 'inset 0 0 4vh rgba(2, 191, 0, 0.8)', 
								}
							}
						>
							{Boolean(crafting) || !hasReagents() ? (
								"Cannot Craft"
								// <FontAwesomeIcon icon={['fas', 'ban']} />
							) : (
								"Craft"
								// <FontAwesomeIcon icon={['fas', 'hammer']} />
							)}
						</Button>
					)}
                </div>
            </div>
		</div>
	);
};

export default Recipe;
