import React, { useState } from 'react';
import { useSelector } from 'react-redux';
import { Tooltip, AppBar, Grid, IconButton } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import { Confirm, Loader } from '../../components';
import { useAlert } from '../../hooks';
import Workgroup from './component/Workgroup';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		position: 'relative',
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
	body: {
		padding: 10,
		height: '88.75%',
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
	buttons: {
		width: '100%',
		display: 'flex',
		marginTop: 10,
	},
	button: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.warning.main,
		'&:hover': {
			backgroundColor: `${theme.palette.warning.main}14`,
		},
	},
	buttonNegative: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.error.main,
		'&:hover': {
			backgroundColor: `${theme.palette.error.main}14`,
		},
	},
	buttonPositive: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.success.main,
		'&:hover': {
			backgroundColor: `${theme.palette.success.main}14`,
		},
	},
	buttonInfo: {
		width: '-webkit-fill-available',
		padding: 20,
		color: theme.palette.info.main,
		'&:hover': {
			backgroundColor: `${theme.palette.info.main}14`,
		},
	},
	emptyMsg: {
		width: '100%',
		textAlign: 'center',
		fontSize: 20,
		fontWeight: 'bold',
		marginTop: '25%',
	},
}));

export default ({ groups, myGroup, loading, onRefresh }) => {
	const classes = useStyles();
	const showAlert = useAlert();
	const player = useSelector((state) => state.data.data.player);

	const [creating, setCreating] = useState(false);
	const [leaving, setLeaving] = useState(false);
	const [disbanding, setDisbanding] = useState(false);

	const close = () => {
		setDisbanding(false);
		setCreating(false);
		setLeaving(false);
	};

	const onCreate = async () => {
		try {
			let res = await (await Nui.send('CreateWorkgroup')).json();
			if (res) {
				showAlert('Workgroup Created');
			} else showAlert('Unable to Create Workgroup');
			setTimeout(() => {
				onRefresh();
			}, 200);
			close();
		} catch (err) {
			console.log(err);
			showAlert('Unable to Create Workgroup');
			close();
		}
	};

	const onJoin = async (group) => {
		if (group.Working) return;

		try {
			let res = await (await Nui.send('JoinWorkgroup', group)).json();
			if (res) {
				showAlert('Sent Request To Join');
			} else showAlert('Unable to Join Workgroup');
			setTimeout(() => {
				onRefresh();
			}, 200);
			close();
		} catch (err) {
			console.log(err);
			showAlert('Unable to Join Workgroup');
			close();
		}
	};

	const onDisband = async () => {
		try {
			let res = await (await Nui.send('DisbandWorkgroup')).json();
			if (res) {
				showAlert('Workgroup Disbanded');
			} else showAlert('Unable to Disband Workgroup');
			setTimeout(() => {
				onRefresh();
			}, 200);
			close();
		} catch (err) {
			console.log(err);
			showAlert('Unable to Disband Workgroup');
			close();
		}
	};

	const onLeave = async () => {
		try {
			let res = await (await Nui.send('LeaveWorkgroup', myGroup)).json();
			if (res) {
				showAlert('Left Workgroup');
			} else showAlert('Unable to Leave Workgroup');
			setTimeout(() => {
				onRefresh();
			}, 200);
			close();
		} catch (err) {
			console.log(err);
			showAlert('Unable to Leave Workgroup');
			close();
		}
	};

	return (
		<>
			<div className={classes.wrapper}>
				<AppBar position="static" className={classes.header}>
					<Grid container>
						<Grid item xs={8}>
							Labor
						</Grid>
						<Grid item xs={4} className={classes.headerAction}>
							{Boolean(myGroup) ? (
								myGroup.Creator.ID == player.Source ? (
									<Tooltip title="Disband Workgroup">
										<IconButton
											disabled={loading}
											onClick={() => setDisbanding(true)}
										>
											<FontAwesomeIcon
												disabled={
													Boolean(player.TempJob) ||
													loading ||
													myGroup.Working
												}
												icon={['fas', 'trash']}
											/>
										</IconButton>
									</Tooltip>
								) : (
									<Tooltip title="Leave Workgroup">
										<IconButton
											disabled={
												Boolean(player.TempJob) ||
												loading ||
												myGroup.Working
											}
											onClick={() => setLeaving(true)}
										>
											<FontAwesomeIcon
												disabled={myGroup.Working}
												icon={['fas', 'sign-out']}
											/>
										</IconButton>
									</Tooltip>
								)
							) : (
								<Tooltip title="Create Workgroup">
									<IconButton
										disabled={
											Boolean(player.TempJob) ||
											loading ||
											Boolean(myGroup)
										}
										onClick={() => setCreating(true)}
									>
										<FontAwesomeIcon
											icon={['fas', 'plus']}
										/>
									</IconButton>
								</Tooltip>
							)}
							<Tooltip title="Refresh Workgroups">
								<IconButton onClick={onRefresh}>
									<FontAwesomeIcon
										className={`fa ${
											loading ? 'fa-spin' : ''
										}`}
										icon={['fas', 'arrows-rotate']}
									/>
								</IconButton>
							</Tooltip>
						</Grid>
					</Grid>
				</AppBar>
				<div className={classes.body}>
					{!Boolean(groups) ? (
						<Loader static text="Loading" />
					) : (
						<>
							{Boolean(groups) ? (
								groups.length > 0 ? (
									groups.map((workgroup, k) => {
										return (
											<Workgroup
												key={`wg-${k}`}
												group={workgroup}
												onJoin={onJoin}
												disabled={loading}
												isInGroup={Boolean(myGroup)}
											/>
										);
									})
								) : (
									<div className={classes.emptyMsg}>
										No Workgroups
									</div>
								)
							) : null}
						</>
					)}
				</div>
			</div>
			{Boolean(myGroup) ? (
				myGroup.Creator.ID == player.Source ? (
					<Confirm
						title="Disband Workgroup?"
						open={disbanding}
						confirm="Disband"
						decline="Cancel"
						onConfirm={onDisband}
						onDecline={() => setDisbanding(false)}
					/>
				) : (
					<Confirm
						title="Leave Workgroup?"
						open={leaving}
						confirm="Leave"
						decline="Cancel"
						onConfirm={onLeave}
						onDecline={() => setLeaving(false)}
					/>
				)
			) : (
				<Confirm
					title="Create Workgroup?"
					open={creating}
					confirm="Create"
					decline="Cancel"
					onConfirm={onCreate}
					onDecline={() => setCreating(false)}
				/>
			)}
		</>
	);
};
