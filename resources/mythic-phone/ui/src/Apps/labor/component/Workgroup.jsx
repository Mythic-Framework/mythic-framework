import React from 'react';
import { useSelector } from 'react-redux';
import { Grid, Paper, Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: 10,
		background: theme.palette.secondary.dark,
		'&:not(:last-of-type)': {
			marginBottom: 10,
		},
	},
	details: {
		position: 'absolute',
		width: 'fit-content',
		height: 'fit-content',
		top: 0,
		bottom: 0,
		margin: 'auto',
	},
	title: {
		fontSize: 20,
		color: theme.palette.primary.main,
		fontWeight: 'bold',
	},
	pay: {
		fontSize: 16,
		color: theme.palette.success.main,
	},
	duty: {
		fontSize: 16,
		fontWeight: 'bold',
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	actions: {
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

export default ({ group, isInGroup, onJoin, disabled }) => {
	const classes = useStyles();
	const player = useSelector((state) => state.data.data.player);

	return (
		<Paper className={classes.wrapper}>
			<Grid container>
				<Grid item xs={7} style={{ position: 'relative', height: 65 }}>
					<div className={classes.details}>
						<div className={classes.title}>
							{group.Creator.ID == player.SID && (
								<FontAwesomeIcon
									style={{ marginRight: 5, color: 'gold' }}
									icon={['fas', 'crown']}
								/>
							)}
							{group.Creator.First} {group.Creator.Last}
						</div>
					</div>
				</Grid>
				<Grid item xs={2} style={{ position: 'relative' }}>
					<div className={classes.duty}>
						{group.Members.length + 1} / 5
					</div>
				</Grid>
				<Grid item xs={3} style={{ position: 'relative' }}>
					<Button
						variant="text"
						className={classes.actions}
						disabled={
							isInGroup ||
							group.Members.length >= 4 ||
							disabled ||
							group.Working ||
							Boolean(player.TempJob)
						}
						onClick={() => onJoin(group)}
					>
						Join
					</Button>
				</Grid>
			</Grid>
		</Paper>
	);
};
