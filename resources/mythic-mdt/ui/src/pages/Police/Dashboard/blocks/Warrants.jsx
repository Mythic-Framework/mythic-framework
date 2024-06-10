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

import Item from './components/WarrantItem';

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
	const warrants = useSelector((state) => state.data.data.warrants);

	return (
		<Grid item xs={6} className={classes.container}>
			<div className={classes.block}>
				<div className={classes.header}>
					Active Warrants
					<IconButton
						component={Link}
						to="/warrants"
						className={classes.create}
					>
						<FontAwesomeIcon icon={['fas', 'eye']} />
					</IconButton>
				</div>
				<List>
					{warrants.filter(w => w.state == 'active').length > 0 ? (
						warrants
							.filter(w => w.state == 'active')
							.sort((a, b) => a.expires - b.expires)
							.map((warrant, k) => {
								return (
									<Item
										key={`warrant-${k}`}
										warrant={warrant}
									/>
								);
							})
					) : (
						<ListItem>
							<Alert variant="outlined" severity="info">
								No Active Warrants
							</Alert>
						</ListItem>
					)}
				</List>
			</div>
		</Grid>
	);
};
