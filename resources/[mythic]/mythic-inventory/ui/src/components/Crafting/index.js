import React, { useEffect, useState } from 'react';
import {
	TextField,
	InputAdornment,
	IconButton,
	Alert,
	CircularProgress,
	Button,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useSelector, useDispatch } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Recipe from './recipe';
import { getItemImage } from '../Inventory/item';

import { useTheme } from '@mui/material/styles';

const useStyles = makeStyles((styles) => ({
	loadingScreen: {
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
	wrapper: {
		display: 'flex',
		justifyContent: 'space-between',
		alignItems: 'center',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		width: '100%',
		height: '100%',
		paddingTop: "11%",
		paddingBottom: "11%",
		paddingRight: "15%",
		paddingLeft: "15%",
	},
	wrapperContainer: {
		display: 'flex',
		justifyContent: 'center',
		alignItems: 'center',
		flexDirection: "column",
		userSelect: 'none',
		'-webkit-user-select': 'none',
		width: "100%",
		height: "100%",
		//backgroundColor: "white",
		//transform: 'rotate(-1deg)', 
    	//transition: 'transform 0.3s ease',
	},
	topContainer: {
		flex: '0 0 15%',
		//backgroundColor: 'red',
		width: "100%",
		display: 'flex',
		justifyContent: 'flex-start',
		alignItems: 'center',
	},
	topLeftContainer: {
		width: "15%",
		background: 'radial-gradient(circle at center, rgba(46, 62, 79, 0.6) 5%, rgba(10, 14, 18, 0.6) 80%)',
		//backgroundColor: "rgba(0, 0, 0, 0.5)",
		height: "60%",
		borderRadius: "0.5vh",
		display: "flex",
		justifyContent: "center",
		textAlign: "center",
		alignItems: "center",
		fontWeight: 600,
		fontSize: "2vh",
	},
	bottomContainer: {
		flex: '0 0 85%',
		//backgroundColor: 'orange',
		width: "100%",
		display: "flex",
		justifyContent: "space-between",
		alignItems: "center",
		//maxHeight: "100%",
		overflow: "hidden",
	},
	leftContainer: {
		flex: '0 0 49%',
		//backgroundColor: 'yellow',
		height: "100%",
		//padding: "10%",
		overflow: "hidden",
		// comment out if using search
		display: "flex",
		justifyContent: "center",
		alignItems: "center",
	},
	leftContainerTop: {
		width: "100%",
		height: "10%",
		//backgroundColor: "gray",
		display: "flex",
		justifyContent: "space-between",
		flexDirection: "row",
		alignItems: "center",
		paddingLeft: "1vh",
		paddingRight: "1vh",
		borderRadius: '1.25vh',
		boxShadow: 'inset 0 0 4vh rgba(13, 13, 13, 0.8)',
		overflow: "hidden",
		marginBottom: "2vh",
	},
	rightContainer: {
		flex: '0 0 49%',
		//backgroundColor: 'lightblue',
		height: "100%",
	},

	noRecipes: {
		fontWeight: 700,
		fontSize: "2vh",
		padding: "3vh",
		textAlign: 'center',
	},

	gridContainer: {
		//backgroundColor: "white",
		display: 'grid',
		gridAutoRows: 'max-content',
		gridTemplateColumns: 'repeat(5, 17%)',
		justifyContent: "space-between",
		width: "100%",
		maxWidth: "100%",
		overflowX: "hidden",
		gap: "2vh",
		overflowY: "auto",
		height: "92%",
		//height: "85%", // if using scroll bar set this
		// '&::-webkit-scrollbar': {
		// 	width: '12px', 
		// },
		// '&::-webkit-scrollbar-thumb': {
		// 	backgroundColor: 'rgba(0, 0, 0, 0.5)',
		// 	borderRadius: '6px', 
		// },
		// '&::-webkit-scrollbar-track': {
		// 	backgroundColor: 'rgba(0, 0, 0, 0.1)', 
		// },
	},
	gridItem: {
		display: "flex",
		justifyContent: "center",
		alignItems: "center",
		width: "auto",
		height: "100%",
		aspectRatio: '1 / 1',
		backgroundColor: "rgba(0, 0, 0, 0.5)",
		borderRadius: "1.25vh",
		padding: 0,
		margin: 0,
		flexDirection: "column",
		overflow: "hidden",
	},
	mainImage: {
		height: "auto",
		width: '50%',
		//backgroundColor: "orange",
		objectFit: 'contain', 
	},
	gridText: {
		fontSize: "1vh",
		fontWeight: 600,
		//backgroundColor: "rgba(0, 0, 0, 0.5)",
		//width: "100%",
		textTransform: "none",
	},
}));

const Crafting = () => {
	const classes = useStyles();
	const itemsLoaded = useSelector((state) => state.inventory.itemsLoaded);
	const items = useSelector((state) => state.inventory.items);
	const cooldowns =
		useSelector((state) => state.crafting.cooldowns) || {};
	const recipes = useSelector((state) => state.crafting.recipes);
	const crafting = useSelector((state) => state.crafting.crafting);
	const theme = useTheme();
	const [filtered, setFiltered] = useState(recipes);
	const [search, setSearch] = useState('');

	const benchName = useSelector((state) => state.crafting.benchName);

	const currentCraft = useSelector((state) => state.crafting.currentCraft);
	
	const dispatch = useDispatch();

	const setCurrentCraft = (number) => {
		//console.log("Setting Current Craft", number);
		dispatch({
			type: 'CURRENT_CRAFT',
			payload: { 
			  currentCraft: number
			},
		});
	};

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

	useEffect(() => {
		setFiltered(
			Object.keys(recipes)
				.filter((r) =>
					items[recipes[r].result.name]?.label
						.toLowerCase()
						.includes(search.toLowerCase())
				)
				.map((k) => recipes[k])
		);
	}, [search, recipes, items]);

	const onChange = (e) => {
		setSearch(e.target.value);
	};

	if (!itemsLoaded || Object.keys(items).length === 0) {
		return (
			<div className={classes.loadingScreen}>
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
			<div className={classes.wrapper}>
				<div className={classes.wrapperContainer}>
					<div className={classes.topContainer}>
						{benchName != 'none' &&
							<div className={classes.topLeftContainer}>
								{benchName}
							</div>
						}
					</div>
					<div className={classes.bottomContainer}>
						<div className={classes.leftContainer}>
							{/* <div className={classes.leftContainerTop}>
								<FontAwesomeIcon 
									icon={['fas', 'search']} 
									style={{ 
										color:"rgba(43, 168, 237, 0.7)",
										marginRight: "1vh",
										fontSize: "1.5vh", 
									}}
								/>

								<TextField
									fullWidth
									placeholder="Search" 
									variant="standard" 
									value={search}
									onChange={onChange}
									disabled={!Boolean(crafting)}
									InputProps={{
										disableUnderline: true, 
										endAdornment: (
										<InputAdornment position="end">
											<IconButton onClick={() => setSearch('')} edge="end">
												{Boolean(search) && (
													<FontAwesomeIcon 
														icon={['fas', 'times']}
														style={{
															fontSize: "1.5vh", 
														}}
													/>
												)}
											</IconButton>
										</InputAdornment>
										),
										style: {
											border: 'none',
											backgroundColor: 'transparent',
											fontSize: "1.5vh",
										},
									}}
									inputProps={{
										style: {
											padding: 0, 
										},
									}}
								/>
							</div>  */}
							{Boolean(filtered) && filtered.length > 0 && (
								<div className={classes.gridContainer} >
									{filtered.map((recipe, index) => (
										<Button		
											key={`${recipe.name}-${index}`}
											index={index}
											className={classes.gridItem}	
											onClick={() => setCurrentCraft(index)}
											style={{
												boxShadow: `inset 0 0 2vh ${getRarityColor(items[recipe.result.name]?.rarity)}`, 
												color: "white",
											}}
										>
											<img 
												className={classes.mainImage}
												src={getItemImage(
													recipe.result,
													items[recipe.result.name],
												)}
													//onMouseEnter={resultTPOpen}
													//onMouseLeave={resultTPClose}
											/>

											<div className={classes.gridText} >
												{items[recipe.result.name]?.label}
											</div>
										</Button>
									))}
								</div>
							// ):(
							// 	<div className={classes.noRecipes}>No Crafting Blueprints</div>
							)}
						</div>

						{Boolean(filtered) && filtered.length > 0 && currentCraft !== null && (
							<div className={classes.rightContainer}>
								{filtered[currentCraft] && (
									<Recipe
										key={`${filtered[currentCraft].name}-${currentCraft}`}
										index={currentCraft}
										recipe={filtered[currentCraft]}
										cooldown={cooldowns[filtered[currentCraft].id]}
									/>
								)}
							</div>
						)}
						
					</div>
				</div>
			</div>
		);
	}
};

export default Crafting;
