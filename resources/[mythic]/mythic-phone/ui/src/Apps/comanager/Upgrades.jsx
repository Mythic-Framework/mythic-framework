import React from 'react';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router';
import {
	List,
	AppBar,
	Grid,
	Tooltip,
	IconButton,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Truncate from 'react-truncate';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Upgrade from './components/Upgrade';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
	},
	header: {
		background: theme.palette.primary.main,
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
		height: 78,
	},
	headerAction: {
		textAlign: 'right',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	list: {
		position: 'inherit',
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default ({ jobData, playerJob }) => {
	const classes = useStyles();
	const history = useHistory();
	const upgrades = useSelector((state) => state.data.data.companyUpgrades);


	const home = () => {
		history.goBack();
	};

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={8}>
						<Truncate lines={1}>{jobData.Name}</Truncate>
					</Grid>
					<Grid item xs={4} className={classes.headerAction}>
						<Tooltip title="Home">
							<IconButton onClick={home}>
								<FontAwesomeIcon icon={['fas', 'house']} />
							</IconButton>
						</Tooltip>
					</Grid>
				</Grid>
			</AppBar>
			<List className={classes.list}>
				{!Boolean(upgrades) ? (
					<div className={classes.emptyMsg}>No Upgrades Available</div>
				) : (
					upgrades.map((upgrade, k) => {
						return (
							<Upgrade key={`upgrade-${k}`} upgrade={upgrade} />
						);
					})
				)}
			</List>
		</div>
	);
};
