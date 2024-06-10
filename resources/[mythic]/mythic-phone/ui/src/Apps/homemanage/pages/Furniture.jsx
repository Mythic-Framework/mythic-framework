import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	List,
	ListItem,
	ListItemText,
	Button,
	FormControl,
	FormHelperText,
	Select,
	MenuItem,
	Fab,
	AppBar,
	Grid,
	Tooltip,
	IconButton,
	Paper,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Nui from '../../../util/Nui';
import { useAlert } from '../../../hooks';

import { Loader, Modal } from '../../../components';
import FurnitureItem from '../components/Furniture';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	header: {
		background: '#30518c',
		fontSize: 20,
		padding: 15,
		lineHeight: '50px',
		height: 78,
	},
	headerAction: {},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
	outer: {
		height: "100%",
	},
	content: {
		height: '90%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 6,
		},
		'&::-webkit-scrollbar-thumb': {
			background: '#ffffff52',
		},
		'&::-webkit-scrollbar-thumb:hover': {
			background: theme.palette.primary.main,
		},
		'&::-webkit-scrollbar-track': {
			background: 'transparent',
		},
	},
	fab: {
		backgroundColor: '#30518c',
		position: 'absolute',
		bottom: '20%',
		right: '10%',
	},
	list: {
		position: 'inherit',
	},
	items: {
		height: 400,
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	item: {
		padding: '10px 5px 10px 10px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	editField: {
		marginBottom: 20,
		width: '100%',
	},
}));

export default ({ property, onRefresh, myKey }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const showAlert = useAlert();
	//const player = useSelector((state) => state.data.data.player);

	const [furniture, setFurniture] = useState(Array());
	const [cats, setCats] = useState(Array());
	const [catalog, setCatalog] = useState({});
	const [err, setErr] = useState("Must be inside property");
	const [expanded, setExpanded] = useState(-1);

	const [choosing, setChoosing] = useState(false);
	const [selectedCat, setSelectedCat] = useState("misc");

	useEffect(async () => {
		// setFurniture([
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// 	{ model: "bla_bla" },
		// ]);

		// setCatalog({
		// 	bla_bla: { cat: "misc", model: "bla_bla" },
		// 	bla_bla2: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla3: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla4: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla5: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla6: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla7: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla8: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla9: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla10: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla11: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla12: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla13: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla14: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla15: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla16: { cat: "misc", model: "bla_bla2" },
		// 	bla_bla17: { cat: "misc", model: "bla_bla2" },
		// })

		// setCats({
		// 	misc: { name: "Misc." },
		// });

		// setErr(null);

		// return;

		try {
			let res = await (
				await Nui.send('Home:GetCurrentFurniture', { property })
			).json();
			if (res && res.success) {
				setFurniture(res.furniture);
				setCatalog(res.catalog);
				setCats(res.categories);

				setErr(null);
			} else {
				setErr(res.err ?? "Error");
			}
		} catch (err) {
			console.log(err);
			setErr("Error");
		}
	}, []);

	const handleClick = (index) => (event, newExpanded) => {
		setExpanded(newExpanded ? index : -1);
	};

	const handleFurnitureChoose = (model) => {
		setChoosing(false);

		placeFurniture(selectedCat, model);
	}

	const toggleEditMode = () => {
		Nui.send("Home:EditMode");
	};

	const placeFurniture = async (category, model) => {
		try {
			let res = await (await Nui.send("Home:PlaceFurniture", { category, model })).json();

			if (res) {
				//showAlert("Object Placement Started");
			} else showAlert("Unable to Start Placement");
		} catch (err) {
			console.log(err);
			showAlert("Unable to Start Placement");
		}
	};

	const findFurniture = async (id) => {
		try {
			let res = await (await Nui.send("Home:HighlightFurniture", { id })).json();

			if (res) {
				showAlert("Furniture is Highlighted");
			} else showAlert("Unable to Find Furniture");
		} catch (err) {
			console.log(err);
			showAlert("Unable to Find Furniture");
		}
	};
	
	const editFurniture = async (id) => {
		try {
			let res = await (await Nui.send("Home:EditFurniture", { id })).json();

			if (res) {
				//showAlert("Furniture Deleted");
			} else showAlert("Unable to Edit Furniture");
		} catch (err) {
			console.log(err);
			showAlert("Unable to Edit Furniture");
		}
	};

	const deleteFurniture = async (id) => {
		try {
			let res = await (await Nui.send("Home:DeleteFurniture", { id })).json();

			if (res) {
				showAlert("Furniture Deleted");
				setFurniture(res);
			} else showAlert("Unable to Delete Furniture");
		} catch (err) {
			console.log(err);
			showAlert("Unable to Delete Furniture");
		}
	};

	if (!myKey?.Permissions?.furniture && !myKey?.Owner) {
		return (
			<div className={classes.wrapper}>
				<div className={classes.emptyMsg}>
					Invalid Permissions
				</div>
			</div>
		);
	} else {
		return (
			<div className={classes.wrapper}>
				{err != null || !furniture ? (
					<div className={classes.emptyMsg}>
						{err}
					</div>
				) : (
					<div className={classes.outer}>
						<Button onClick={toggleEditMode} size="medium" fullWidth color="success" style={{ width: "90%", margin: "2.5% 5%" }}>Toggle Edit Mode</Button>
						<div className={classes.content}>
							{furniture.sort((a, b) => a.dist - b.dist).map((f, i) => {
								return <FurnitureItem 
									key={i}
									index={i}
									expanded={expanded}
									onClick={handleClick(i)}
									onEdit={editFurniture}
									onFind={findFurniture}
									onClone={placeFurniture}
									onDelete={deleteFurniture}
									furniture={f}
								/>
							})}
						</div>
					</div>
				)}
				<Modal
					open={choosing}
					title="Place New Item"
					onClose={() => setChoosing(false)}
				>
					<p><i>You can browse through a category once in placement mode by using your arrow keys!</i></p>
					<FormControl className={classes.editField}>
						<Select
							id="selectedCat"
							name="selectedCat"
							value={selectedCat}
							onChange={e => setSelectedCat(e.target.value)}
						>
							{Object.keys(cats).map(c => {
								return <MenuItem
									key={c}
									value={c}
								>
									{cats[c].name}
								</MenuItem>
							})}
						</Select>
						<FormHelperText>Select a Category</FormHelperText>
					</FormControl>
					<List className={classes.items}>
						{Object.keys(catalog).filter(m => catalog[m].cat == selectedCat).sort((a, b) => catalog[a].id - catalog[b].id).map(m => {
							return <ListItem className={classes.item} button onClick={() => handleFurnitureChoose(m)}>
								<ListItemText
									primary={catalog[m].name}
									secondary={catalog[m].model}
								/>
							</ListItem>
						})}
					</List>
				</Modal>
				<Fab
					className={classes.fab}
					onClick={() => setChoosing(true)}
				>
					<FontAwesomeIcon icon={['fas', 'plus']} />
				</Fab>
			</div>
		);
	}
};
