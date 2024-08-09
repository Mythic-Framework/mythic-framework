import React, { useEffect, useState } from 'react';
import {
	List,
	ListItem,
	ListItemText,
	Grid,
	Alert,
	Button,
	Avatar,
	TextField,
	InputAdornment,
	IconButton,
	ButtonGroup,
	FormGroup,
	FormControlLabel,
	Switch,
	Chip,
	MenuItem,
	ListItemButton,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { toast } from 'react-toastify';
import moment from 'moment';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Link, useHistory } from 'react-router-dom';

import { Loader, Modal } from '../../components';
import Nui from '../../util/Nui';
import { useSelector } from 'react-redux';
import { round } from 'lodash';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		height: '100%',
	},
	link: {
		color: theme.palette.text.alt,
		transition: 'color ease-in 0.15s',
		'&:hover': {
			color: theme.palette.primary.main,
		},
		'&:not(:last-of-type)::after': {
			color: theme.palette.text.main,
			content: '", "',
		},
	},
	item: {
		margin: 4,
		transition: 'background ease-in 0.15s',
		border: `1px solid ${theme.palette.border.divider}`,
		margin: 7.5,
        transition: 'filter ease-in 0.15s',
        '&:hover': {
			filter: 'brightness(0.8)',
			cursor: 'pointer',
		},
	},
	editorField: {
		marginBottom: 10,
	},
}));

const banLengths = [
	{
		name: '1 Day',
		value: 1,
		permissionLevel: 75,
	},
	{
		name: '2 Day',
		value: 2,
		permissionLevel: 75,
	},
	{
		name: '3 Day',
		value: 3,
		permissionLevel: 75,
	},
	{
		name: '7 Day',
		value: 7,
		permissionLevel: 75,
	},
	{
		name: '14 Day',
		value: 14,
		permissionLevel: 99,
	},
	{
		name: '30 Day',
		value: 30,
		permissionLevel: 99,
	},
	{
		name: 'Permanent',
		value: -1,
		permissionLevel: 99,
	},
]

export default ({ match }) => {
	const classes = useStyles();
	const history = useHistory();
	const user = useSelector(state => state.app.user);
	const permissionName = useSelector(state => state.app.permissionName);
	const permissionLevel = useSelector(state => state.app.permissionLevel);

	const [err, setErr] = useState(false);
	const [loading, setLoading] = useState(false);

	const [player, setPlayer] = useState(null);

	const [kick, setKick] = useState(false);
	const [pendingKick, setPendingKick] = useState('');

	const [ban, setBan] = useState(false);
	const [pendingBanReason, setPendingBanReason] = useState('');
	const [pendingBanLength, setPendingBanLength] = useState(1);

	const fetch = async (forced) => {
		if (!player || player.Source != match.params.id || forced) {
			setLoading(true);
			try {
				let res = await (await Nui.send('GetPlayer', parseInt(match.params.id))).json();
	
				
				if (res) {
					setPlayer(res);
				} else toast.error('Unable to Load');
			} catch (err) {
				console.log(err);
				toast.error('Unable to Load');
				setErr(true);

				// setPlayer({
				// 	AccountID: 1,
				// 	Source: 1,
				// 	Name: 'Dr Nick',
				// 	Level: 100,
				// 	Identifier: '7888128828188291',
				// 	StaffGroup: 'Staff',
				// 	Character: {
				// 		First: 'Walter',
				// 		Last: 'Western',
				// 		SID: 3,
				// 		DOB: 662687999,
				// 		Coords: {
				// 			x: 1000.123123123,
				// 			y: 1,
				// 			z: 9,
				// 		}
				// 	},
				// 	Disconnected: true,
				// 	DisconnectedTime: 1641993114,
				// 	Reconnected: 2,
				// 	Reason: 'Exiting',
				// })
			}
			setLoading(false);
		}
	};

	useEffect(() => {
		fetch();
	}, [match]);

	const onRefresh = () => {
		fetch(true);
	};

	const openForumUrl = () => {
		Nui.copyClipboard(`https://mythicrp.com/members/${player.AccountID}/`);
		toast.success('Copied URL');
	};

	const copyCoords = () => {
		Nui.copyClipboard(`vector3(${round(player.Character.Coords?.x, 3)}, ${round(player.Character.Coords?.y, 3)}, ${round(player.Character.Coords?.z, 3)})`);
		toast.success('Copied Coordinates');
	};

	const onAction = async (action) => {
		try {
			let res = await (await Nui.send('ActionPlayer', {
				targetSource: player?.Source,
				action: action,
			})).json();

			if (res && res.success) {
				toast.success(res.message);
			} else {
				if (res && res.message) {
					toast.error(res.message);
				} else {
					toast.error('Error');
				}
			}
		} catch (err) {
			toast.error('Error');
		}
	}

	const startKick = () => {
		setPendingKick('');
		setKick(true);
	}

	const onKick = async (e) => {
		e.preventDefault();
		setKick(false);
		setLoading(true);

		try {
			let res = await (await Nui.send('KickPlayer', {
				targetSource: player?.Source,
				reason: e.target.kickReason.value,
			})).json();

			if (res && res.success) {
				toast.success(`Kicked ${player?.Name ?? 'Player'}`);
				history.goBack();
			} else {
				if (res.message) {
					toast.error(res.message);
				} else {
					toast.error('Failed to Kick Player');
				}
			}
		} catch (err) {
			toast.error('Error Kicking Player');
		}

		setLoading(false);
	};

	const startBan = () => {
		setPendingBanLength(1);
		setPendingBanReason('');
		setBan(true);
	}

	const onBan = async (e) => {
		e.preventDefault();
		setBan(false);
		setLoading(true);

		try {
			let res = await (await Nui.send('BanPlayer', {
				targetSource: player?.Source,
				reason: e.target.banReason.value,
				length: parseInt(e.target.banLength.value),
			})).json();

			if (res && res.success) {
				toast.success(`Banned ${player?.Name ?? 'Player'}`);
			} else {
				if (res.message) {
					toast.error(res.message);
				} else {
					toast.error('Failed to Ban Player');
				}
			}
		} catch (err) {
			toast.error('Error Banning Player');
		}

		setLoading(false);
	};

	const onDisconnectedClick = () => {
		if (player?.Reconnected) {
			history.push(`/player/${player.Reconnected}`);
		}
	}

	return (
		<div>
			{loading || (!player && !err) ? (
				<div
					className={classes.wrapper}
					style={{ position: 'relative' }}
				>
					<Loader static text="Loading" />
				</div>
			) : err ? (
				<Grid className={classes.wrapper} container>
					<Grid item xs={12}>
						<Alert variant="outlined" severity="error">
							Invalid Player
						</Alert>
					</Grid>
				</Grid>
			) : (
				<>
					<Grid className={classes.wrapper} container spacing={2}>
						<Grid item xs={12}>
							<ButtonGroup fullWidth variant="contained">
								<Button onClick={() => onAction('goto')} disabled={!player?.Character || (user?.Source === player.Source) || player.Disconnected}>
									Goto
								</Button>
								<Button onClick={() => onAction('bring')} disabled={!player?.Character || (user?.Source === player.Source) || (permissionLevel < player.Level) || player.Disconnected}>
									Bring
								</Button>
								<Button onClick={() => onAction('heal')} disabled={!player?.Character || player.Disconnected || ((user?.Source === player.Source) && permissionLevel < 75)}>
									Heal
								</Button>
								<Button onClick={() => onAction('attach')} disabled={!player?.Character || (user?.Source === player.Source) || (permissionLevel < player.Level) || player.Disconnected}>
									Spectate
								</Button>
								<Button onClick={startKick} disabled={(user?.Source === player.Source) || (permissionLevel < player.Level)}>
									Kick
								</Button>
								<Button onClick={startBan} disabled={(user?.Source === player.Source) || (permissionLevel < player.Level) || (permissionLevel < 75)}>
									Ban
								</Button>
								<Button onClick={openForumUrl}>
									Copy Forum URL
								</Button>
								<Button onClick={onRefresh}>
									Refresh
								</Button>
								{(permissionLevel >= 90) && <Button onClick={() => onAction('marker')} disabled={(user?.Source === player.Source)}>
									GPS Marker
								</Button>}
							</ButtonGroup>
						</Grid>
						{player.Disconnected &&	<Grid item xs={12}>
							<ListItem>
								<ListItemButton onClick={onDisconnectedClick}>
									<ListItemText
										primary="Player Has Disconnected"
										secondary={`Disconnected ${moment(player.DisconnectedTime * 1000).fromNow()}${player.Reconnected ? `, they have since reconnected to the server.` : '.'} Reason: ${player.Reason}`}
									/>
								</ListItemButton>
							</ListItem>
						</Grid>}
						<Grid item xs={6}>
							<List>
								<ListItem>
									<ListItemText
										primary="Player Name"
										secondary={`${player.Name} ${player.Source == user.Source ? '(You)' : ''}`}
									/>
								</ListItem>
								<ListItem>
									<ListItemText
										primary="Player Account"
										secondary={player.AccountID}
									/>
								</ListItem>
								{player.StaffGroup && <ListItem>
									<ListItemText
										primary="Staff Group"
										secondary={player.StaffGroup}
									/>
								</ListItem>}
								<ListItem>
									<ListItemText
										primary="Player Source"
										secondary={player.Source}
									/>
								</ListItem>
								<ListItem>
									<ListItemText
										primary="Player Identifier"
										secondary={player.Identifier}
									/>
								</ListItem>
							</List>
						</Grid>
						<Grid item xs={6}>
							{player.Character ? (
								<>
									<List>
										<ListItem>
											<ListItemText
												primary="Character Name"
												secondary={`${player.Character.First} ${player.Character.Last}`}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="Character State ID"
												secondary={`${player.Character.SID}`}
											/>
										</ListItem>
										<ListItem>
											<ListItemText
												primary="DOB"
												secondary={moment(player.Character.DOB * 1000).format('LL')}
											/>
										</ListItem>
										{permissionLevel >= 90 && (<ListItem>
											<ListItemText
												primary="Character Phone #"
												secondary={`${player.Character.Phone}`}
											/>
										</ListItem>)}
										{permissionLevel >= 90 && (<ListItem onClick={copyCoords}>
											<ListItemText
												primary="Coordinates"
												secondary={`vector3(${round(player.Character.Coords?.x, 3)}, ${round(player.Character.Coords?.y, 3)}, ${round(player.Character.Coords?.z, 3)})`}
											/>
										</ListItem>)}
									</List>
								</>
							) : (
								<>
									<List>
										<ListItem>
											<ListItemText
												primary="Character"
												secondary="Not Logged In"
											/>
										</ListItem>
									</List>
								</>
							)}
						</Grid>
					</Grid>
					<Modal
						open={kick}
						title={`Kick ${player.Name}`}
						onSubmit={onKick}
						submitLang="Kick"
						onClose={() => setKick(false)}
					>
						<TextField
							fullWidth
							required
							variant="outlined"
							name="kickReason"
							value={pendingKick}
							onChange={(e) => setPendingKick(e.target.value)}
							label="Kick Reason"
							helperText="Please give a reason to kick the player."
							multiline
							InputProps={{
								endAdornment: (
									<InputAdornment position="end">
										{pendingKick != '' && (
											<IconButton
												onClick={() =>
													setPendingKick('')
												}
											>
												<FontAwesomeIcon
													icon={['fas', 'xmark']}
												/>
											</IconButton>
										)}
									</InputAdornment>
								),
							}}
						/>
					</Modal>
					<Modal
						open={ban}
						title={`Ban ${player.Name}`}
						onSubmit={onBan}
						submitLang="Ban"
						onClose={() => setBan(false)}
					>
						<TextField
							select
							fullWidth
							name="banLength"
							label="Ban Length"
							className={classes.editorField}
							value={pendingBanLength}
							onChange={(e) => setPendingBanLength(e.target.value)}
						>
							{banLengths.filter(l => (permissionLevel >= l.permissionLevel)).map((l) => (
								<MenuItem key={l.value} value={l.value}>
									{l.name}
								</MenuItem>
							))}
						</TextField>
						<TextField
							fullWidth
							required
							variant="outlined"
							name="banReason"
							value={pendingBanReason}
							onChange={(e) => setPendingBanReason(e.target.value)}
							label="Ban Reason"
							helperText="Please give a reason to ban the player."
							multiline
							InputProps={{
								endAdornment: (
									<InputAdornment position="end">
										{pendingKick != '' && (
											<IconButton
												onClick={() =>
													setPendingBanReason('')
												}
											>
												<FontAwesomeIcon
													icon={['fas', 'xmark']}
												/>
											</IconButton>
										)}
									</InputAdornment>
								),
							}}
						/>
					</Modal>
				</>
			)}
		</div>
	);
};
