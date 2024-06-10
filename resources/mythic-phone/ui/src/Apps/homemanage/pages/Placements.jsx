import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
	List,
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

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		position: 'relative',
	},
	dataWrapper: {
		height: '95%',
		padding: 25,
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
	section: {
		padding: 20,
		background: theme.palette.secondary.dark,
		width: '100%',
		margin: 'auto',
		marginBottom: 25,
		'&::last-child': {
			marginBottom: 'none',
		},
	},
	actions: {
		background: theme.palette.secondary.dark,
		borderRadius: 10,
		fontSize: 15,
		fontWeight: 'bold',
		margin: '0 auto 25px auto',
		width: '90%',
	},
	sectionHeader: {
		fontSize: 24,
		fontFamily: 'Aclonica',
		color: theme.palette.text.light,
		padding: 10,
		borderBottom: `1px solid #30518c`,
	},
	sectionBody: {
		fontSize: 16,
	},
	bodyItem: {
		padding: 10,
	},
	highlight: {
		fontWeight: 'bold',
		color: '#30518c',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default ({ property, onRefresh }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const showAlert = useAlert();
	const player = useSelector((state) => state.data.data.player);
	const myProperties = useSelector((state) => state.data.data.myProperties);

	const startPlacement = async (type) => {
		try {
			let res = await (await Nui.send("Home:StartPlacement")).json();

			if (res) {
				showAlert("Object Placement Started");
			} else showAlert("Unable to Start Placement");
		} catch (err) {
			console.log(err);
			showAlert("Unable to Start Placement");
		}
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.dataWrapper}>
				{/* <Paper className={classes.section}>
					<div className={classes.sectionHeader}>
						<Grid container>
							<Grid item xs={8} style={{ lineHeight: '50px' }}>
								Stash
							</Grid>
							<Grid item xs={4} style={{ textAlign: 'right' }}>
								<IconButton
									onClick={() => startPlacement('stash')}
								>
									<FontAwesomeIcon
										icon={['fas', 'location-dot']}
									/>
								</IconButton>
							</Grid>
						</Grid>
					</div>
					<div className={classes.sectionBody}>
						<div className={classes.bodyItem}>
							<span className={classes.highlight}>
								{Boolean(property?.location?.stash)
									? 'Placed'
									: 'Not Placed'}
							</span>
						</div>
					</div>
				</Paper>
				<Paper className={classes.section}>
					<div className={classes.sectionHeader}>
						<Grid container>
							<Grid item xs={8} style={{ lineHeight: '50px' }}>
								Wardrobe
							</Grid>
							<Grid item xs={4} style={{ textAlign: 'right' }}>
								<IconButton
									onClick={() => startPlacement('closet')}
								>
									<FontAwesomeIcon
										icon={['fas', 'location-dot']}
									/>
								</IconButton>
							</Grid>
						</Grid>
					</div>
					<div className={classes.sectionBody}>
						<div className={classes.bodyItem}>
							<span className={classes.highlight}>
								{Boolean(property?.location?.closet)
									? 'Placed'
									: 'Not Placed'}
							</span>
						</div>
					</div>
				</Paper>
				<Paper className={classes.section}>
					<div className={classes.sectionHeader}>
						<Grid container>
							<Grid item xs={8} style={{ lineHeight: '50px' }}>
								Bed
							</Grid>
							<Grid item xs={4} style={{ textAlign: 'right' }}>
								<IconButton
									onClick={() => startPlacement('logout')}
								>
									<FontAwesomeIcon
										icon={['fas', 'location-dot']}
									/>
								</IconButton>
							</Grid>
						</Grid>
					</div>
					<div className={classes.sectionBody}>
						<div className={classes.bodyItem}>
							<span className={classes.highlight}>
								{Boolean(property?.location?.logout)
									? 'Placed'
									: 'Not Placed'}
							</span>
						</div>
					</div>
				</Paper> */}
				<Paper className={classes.section}>
					<div className={classes.sectionHeader}>
						<Grid container>
							<Grid item xs={8} style={{ lineHeight: '50px' }}>
								Furniture
							</Grid>
							<Grid item xs={4} style={{ textAlign: 'right' }}>
								<IconButton disabled>
									<FontAwesomeIcon
										icon={['fas', 'chair-office']}
									/>
								</IconButton>
							</Grid>
						</Grid>
					</div>
					<div className={classes.sectionBody}>
						<div className={classes.bodyItem}>
							<span className={classes.highlight}>
								Coming Soon...
							</span>
						</div>
					</div>
				</Paper>
			</div>
		</div>
	);
};
