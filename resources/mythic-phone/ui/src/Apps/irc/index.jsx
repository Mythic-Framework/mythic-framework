import React, { useEffect, useState } from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
import { useHistory } from 'react-router';
import { AppBar, Grid, TextField, IconButton } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Nui from '../../util/Nui';
import { Slugify } from '../../util/Parser';
import { Modal } from '../../components';
import Channel from './Channel';
import { useAlert, useNotification } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
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
	header: {
		background: '#1de9b6',
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
	},
	headerAction: {
		textAlign: 'center',
		color: theme.palette.text.main,
		'&:hover': {
			color: theme.palette.text.alt,
			transition: 'color ease-in 0.15s',
		},
	},
	buttons: {
		width: '100%',
		display: 'flex',
		margin: 'auto',
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
	error: {
		padding: 10,
		width: 'fit-content',
		height: 'fit-content',
		margin: 'auto',
		border: `1px solid #1de9b6`,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		left: 0,
	},
}));

export default connect(null)((props) => {
	const addNotif = useNotification();
	const showAlert = useAlert();
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useHistory();
	const joinedChannels = useSelector((state) => state.data.data.ircChannels);
	const player = useSelector((state) => state.data.data.player);

	const [config, setConfig] = useState(false);
	const [alias, setAlias] = useState(
		player.Alias?.irc ? player.Alias?.irc : '',
	);
	const onAliasChange = (e) => {
		setAlias(e.target.value);
	};
	const onConfig = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('UpdateAlias', {
					app: 'irc',
					alias,
					unique: true,
				})
			).json();

			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'player',
						id: 'Alias',
						key: 'irc',
						data: alias,
					},
				});
				showAlert('Alias Updated');
			} else {
				showAlert('Unable To Update Alias');
			}
			setConfig(false);
		} catch (err) {
			console.log(err);
			showAlert('Unable To Update Alias');
		}
	};

	const onJoinChange = (e) => {
		setJoinData(Slugify(e.target.value));
	};

	const [searchVal, setSearchVal] = useState('');
	const onSearchChange = (e) => {
		setSearchVal(Slugify(e.target.value));
	};

	const [channels, setChannels] = useState(
		joinedChannels.filter((c) => c.slug.includes(searchVal)),
	);
	useEffect(() => {
		setChannels(joinedChannels.filter((c) => c.slug.includes(searchVal)));
	}, [searchVal]);

	const [joinData, setJoinData] = useState('');
	const [join, setJoin] = useState(false);
	const onJoin = async (e) => {
		e.preventDefault();

		if (joinData && joinData.length > 0) {
			try {
				let chanData = {
					slug: joinData,
					joined: Date.now(),
				};
				let res = await (await Nui.send('JoinIRCChannel', chanData)).json();
				if (res) {
					dispatch({
						type: 'ADD_DATA',
						payload: {
							type: 'ircChannels',
							data: chanData,
						},
					});
					showAlert('Joined Channel');
					history.push(`/apps/irc/view/${joinData}`);
				} else {
					showAlert('Unable To Join Channel');
				}
			} catch (err) {
				console.log(err);
				showAlert('Unable To Join Channel');
			}
		} else {
			showAlert('Unable To Join Channel');
		}
		setJoin(false);
	};

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={9}>
						IRC
					</Grid>
					<Grid item xs={3}>
						<Grid container spacing={2}>
							<Grid item xs={6}>
								<IconButton
									color="secondary"
									onClick={() => setJoin(true)}
								>
									<FontAwesomeIcon icon="plus" />
								</IconButton>
							</Grid>
							<Grid item xs={6}>
								<IconButton
									color="secondary"
									onClick={() => setConfig(true)}
								>
									<FontAwesomeIcon icon="gear" />
								</IconButton>
							</Grid>
						</Grid>
					</Grid>
				</Grid>
			</AppBar>
			<TextField
				fullWidth
				variant="standard"
				label="Search For Channel"
				value={searchVal}
				onChange={onSearchChange}
				InputProps={{
					style: { padding: 10 },
				}}
				InputLabelProps={{
					style: { padding: 10 },
				}}
			/>
			{channels.length > 0 ? (
				<>
					{channels
						.sort((a, b) => b.joined - a.joined)
						.map((channel, index) => {
							return (
								<Channel
									key={`channel-${index}`}
									channel={channel}
								/>
							);
						})}
				</>
			) : (
				<div className={classes.error}>
					{searchVal == ''
						? "You're Not In Any Channels"
						: 'No Channels Match Your Search'}
				</div>
			)}

			<Modal
				form
				open={config || !player.Alias?.irc}
				title="IRC Settings"
				onClose={() => setConfig(false)}
				onAccept={onConfig}
				submitLang="Save"
				closeLang="Cancel"
			>
				<TextField
					className={classes.editField}
					label="Username"
					name="username"
					type="text"
					fullWidth
					onChange={onAliasChange}
					value={alias}
					InputLabelProps={{
						style: { fontSize: 20 },
					}}
				/>
			</Modal>

			<Modal
				form
				open={join}
				title="Join Channel"
				onClose={() => setJoin(false)}
				onAccept={onJoin}
				submitLang="Join"
				closeLang="Cancel"
			>
				<TextField
					className={classes.editField}
					label="Channel Name"
					name="channel"
					type="text"
					fullWidth
					onChange={onJoinChange}
					value={joinData}
					InputLabelProps={{
						style: { fontSize: 20 },
					}}
				/>
			</Modal>
		</div>
	);
});
