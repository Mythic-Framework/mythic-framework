import React from 'react';
import { Grid, IconButton, Paper } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Moment from 'react-moment';

import Nui from '../../../util/Nui';
import { useAlert } from '../../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		background: theme.palette.secondary.dark,
		marginBottom: 10,
	},
	title: {
		fontSize: 18,
		fontWeight: 'bold',
	},
	code: {
		borderRadius: 4,
		background: theme.palette.warning.dark,
		padding: 3,
		marginRight: 5,
		fontSize: 12,
	},
	detailRow: {
		padding: 5,
		fontSize: 14,
	},
	detailIcon: {
		marginRight: 10,
	},
	pinBtn: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
}));

export default ({ alert }) => {
	const classes = useStyles();
	const showAlert = useAlert();

	const onClick = async () => {
		try {
			let res = await (await Nui.send('LEOPin', alert.location)).json();
			showAlert(res ? 'Location Pinned' : 'Unable to Pin Location');
		} catch (err) {
			console.log(err);
			showAlert('Unable to Pin Location');
		}
	};

	return (
		<Paper className={classes.wrapper}>
			<Grid container>
				<Grid item xs={10}>
					<div className={classes.title}>
						<span className={classes.code}>{alert.code}</span>
						{alert.title}
					</div>
					{alert.location.street1 != null && (
						<div className={classes.detailRow}>
							<FontAwesomeIcon
								className={classes.detailIcon}
								icon={['fas', 'globe']}
							/>
							{alert.location.street1}, {alert.location.area}
						</div>
					)}
					<div className={classes.detailRow}>
						<FontAwesomeIcon
							className={classes.detailIcon}
							icon={['fas', 'clock']}
						/>
						<Moment date={alert.time} fromNow interval={60000} />
					</div>
				</Grid>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<IconButton onClick={onClick} className={classes.pinBtn}>
						<FontAwesomeIcon icon={['fas', 'map-marker']} />
					</IconButton>
				</Grid>
			</Grid>
		</Paper>
	);
};
