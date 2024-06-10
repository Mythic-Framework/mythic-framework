import React, { useEffect, useState } from 'react';
import {
	TextField,
	InputAdornment,
	IconButton,
	Alert,
	CircularProgress,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { useSelector } from 'react-redux';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Recipe from './recipe';

const useStyles = makeStyles((styles) => ({
	ffs: {
		height: '100%',
	},
	search: {
		marginBottom: '1%',
	},
	wrapper: {
		display: 'flex',
		justifyContent: 'center',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		width: '100%',
		height: '99%',
	},
	container: {
		width: '100%',
		display: 'grid',
		gridTemplateColumns: '1fr 1fr',
		gridGap: '25px',
		overflow: 'auto',
		gridAutoRows: 'max-content',
	},
	noRecipes: {
		padding: 30,
		textAlign: 'center',
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
}));

const Crafting = () => {
	const classes = useStyles();
	const itemsLoaded = useSelector((state) => state.inventory.itemsLoaded);
	const items = useSelector((state) => state.inventory.items);
	const cooldowns =
		useSelector((state) => state.crafting.cooldowns) || Object();
	const recipes = useSelector((state) => state.crafting.recipes);
	const crafting = useSelector((state) => state.crafting.crafting);

	const [filtered, setFiltered] = useState(recipes);
	const [search, setSearch] = useState('');

	useEffect(() => {
		setFiltered(
			Object.keys(recipes)
				.filter((r) =>
					items[recipes[r].result.name].label
						.toLowerCase()
						.includes(search.toLowerCase()),
				)
				.map((k) => recipes[k]),
		);
	}, [search, recipes]);

	const onChange = (e) => {
		setSearch(e.target.value);
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
			<div className={classes.ffs}>
				<TextField
					fullWidth
					className={classes.search}
					label="Search"
					variant="outlined"
					value={search}
					onChange={onChange}
					disabled={Boolean(crafting)}
					InputProps={{
						endAdornment: (
							<InputAdornment position="end">
								<IconButton
									onClick={() => setSearch('')}
									edge="end"
								>
									{Boolean(search) && (
										<FontAwesomeIcon icon={['fas', 'x']} />
									)}
								</IconButton>
							</InputAdornment>
						),
					}}
				/>
				<div className={classes.wrapper}>
					{Boolean(filtered) && filtered.length > 0 ? (
						<div className={classes.container}>
							{filtered.map((recipe, index) => (
								<Recipe
									key={`${recipe.name}-${index}`}
									index={index}
									recipe={recipe}
									cooldown={cooldowns[recipe.id]}
								/>
							))}
						</div>
					) : (
						<div className={classes.noRecipes}>No Recipes</div>
					)}
				</div>
			</div>
		);
	}
};

export default Crafting;
