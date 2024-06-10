import React from 'react';
import { useSelector } from 'react-redux';
import {
	Alert,
	Grid,
	List,
	ListItem,
	IconButton,
} from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Link } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Item from './components/BOLOItem';

const useStyles = makeStyles((theme) => ({
	container: {
		padding: 10,
	},
	block: {
		padding: 10,
		background: theme.palette.secondary.main,
		border: `1px solid ${theme.palette.border.divider}`,
	},
	header: {
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		color: theme.palette.primary.main,
		fontSize: 18,
		marginBottom: 10,
		position: 'relative',
	},
	create: {
		float: 'right',
		fontSize: 16,
		height: 32,
		width: 32,
		position: 'absolute',
		top: 0,
		right: 0,
	},
}));

export default () => {
	const classes = useStyles();
	const bolos = useSelector((state) => state.data.data.bolos);

	return (
		<Grid item xs={6} className={classes.container}>
			<div className={classes.block}>
				<div className={classes.header}>
					Active BOLO's
					<IconButton
						component={Link}
						to="/create/bolo"
						className={classes.create}
					>
						<FontAwesomeIcon icon={['fas', 'plus']} />
					</IconButton>
				</div>
				<List>
					{bolos && bolos.length > 0 ? (
						bolos
							.sort((a, b) => b.time - a.time)
							.map((bolo, k) => {
								return <Item key={`bolo-${k}`} bolo={bolo} />;
							})
					) : (
						<ListItem>
							<Alert variant="outlined" severity="info">
								No Active BOLO's
							</Alert>
						</ListItem>
					)}
				</List>
			</div>
		</Grid>
	);
};
