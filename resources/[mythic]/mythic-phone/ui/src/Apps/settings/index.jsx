import React, { useEffect, useState } from 'react';
import { useHistory } from 'react-router-dom';
import { connect, useSelector } from 'react-redux';
import {
	Grid,
	Avatar,
	Switch,
	Button,
	ButtonGroup,
	Paper,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';

import {
	green,
	purple,
	blue,
	orange,
	teal,
	deepOrange,
	deepPurple,
} from '@material-ui/core/colors';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import Version from './components/Version';
import { Modal } from '../../components';
import { UpdateSetting } from './actions';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
	},
	rowWrapper: {
		background: theme.palette.secondary.main,
		padding: '25px 12px',
		width: '100%',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	rowWrapperNoHov: {
		background: theme.palette.secondary.main,
		padding: '25px 12px',
		width: '100%',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
	},
	rowHeader: {
		background: theme.palette.secondary.dark,
		fontSize: 18,
		padding: 15,
		color: theme.palette.text.main,
		fontWeight: 'bold',
		fontFamily: 'Aclonica',
	},
	settingsList: {
		height: '95%',
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
	avatar: {
		color: theme.palette.text.light,
		background: theme.palette.primary.main,
		height: 55,
		width: 55,
		fontSize: 35,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	},
	avatarIcon: {
		fontSize: 25,
	},
	sectionHeader: {
		display: 'block',
		fontSize: 20,
		fontWeight: 'bold',
		lineHeight: '35px',
	},
	arrow: {
		fontSize: 20,
		position: 'absolute',
		top: 0,
		bottom: 0,
		right: 0,
		margin: 'auto',
	},
	mute: {
		color: theme.palette.error.main,
	},
	unmute: {
		color: theme.palette.error.main,
	},
}));

export default connect(null, { UpdateSetting })((props) => {
	const classes = useStyles();
	const history = useHistory();
	const settings = useSelector(
		(state) => state.data.data.player.PhoneSettings,
	);
	const [notifs, setNotifs] = useState(settings.notifications);
	const [zoomInfo, setZoomInfo] = useState(false);

	const profileClicked = () => {
		history.push(`/apps/settings/profile`);
	};

	const soundsClicked = () => {
		history.push(`/apps/settings/sounds`);
	};

	const appNotifsClicked = () => {
		history.push(`/apps/settings/app_notifs`);
	};

	const wallpaperClicked = () => {
		history.push(`/apps/settings/wallpaper`);
	};

	const colorsClicked = () => {
		history.push(`/apps/settings/colors`);
	};

	const toggleNotifs = () => {
		props.UpdateSetting('notifications', !notifs);
		setNotifs(!notifs);
	};

	const volumeAdd = (e) => {
		e.preventDefault();
		if (settings.volume < 100)
			props.UpdateSetting('volume', settings.volume + 5);
	};

	const volumeMinus = (e) => {
		e.preventDefault();
		if (settings.volume >= 5)
			props.UpdateSetting('volume', settings.volume - 5);
	};

	const toggleMute = (e) => {
		e.preventDefault();
		if (settings.volume === 0) props.UpdateSetting('volume', 100);
		else props.UpdateSetting('volume', 0);
	};

	const zoomAdd = (e) => {
		e.preventDefault();
		if (settings.zoom < 100)
			props.UpdateSetting('zoom', settings.zoom + 10);
	};

	const zoomMinus = (e) => {
		e.preventDefault();
		if (settings.zoom >= 60)
			props.UpdateSetting('zoom', settings.zoom - 10);
	};

	return (
		<div className={classes.wrapper}>
			<Grid
				className={classes.settingsList}
				container
				justify="flex-start"
			>
				<Paper className={classes.rowWrapper} onClick={profileClicked}>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar className={classes.avatar}>
									<FontAwesomeIcon
										className={classes.avatarIcon}
										icon={['fas', 'user']}
									/>
								</Avatar>
							</Grid>
							<Grid
								item
								xs={8}
								style={{ paddingLeft: 5, position: 'relative' }}
							>
								<span className={classes.sectionHeader}>
									Personal Details
								</span>
								<span>View Personal Details</span>
							</Grid>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<FontAwesomeIcon
									className={classes.arrow}
									icon={['fas', 'chevron-right']}
								/>
							</Grid>
						</Grid>
					</Grid>
				</Paper>
				<Grid item xs={12} className={classes.rowHeader}>
					Notifications
				</Grid>
				<Paper className={classes.rowWrapper} onClick={toggleNotifs}>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar
									className={classes.avatar}
									style={{ background: green[500] }}
								>
									<FontAwesomeIcon
										className={classes.avatarIcon}
										icon={['fas', 'bell']}
									/>
								</Avatar>
							</Grid>
							<Grid
								item
								xs={8}
								style={{ paddingLeft: 5, position: 'relative' }}
							>
								<span className={classes.sectionHeader}>
									Notifications
								</span>
							</Grid>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Switch
									className={classes.arrow}
									checked={notifs}
									color="primary"
								/>
							</Grid>
						</Grid>
					</Grid>
				</Paper>
				<Paper
					className={classes.rowWrapper}
					onClick={appNotifsClicked}
				>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar
									className={classes.avatar}
									style={{ background: purple[500] }}
								>
									<FontAwesomeIcon
										className={classes.avatarIcon}
										icon={['fas', 'bell']}
									/>
								</Avatar>
							</Grid>
							<Grid
								item
								xs={8}
								style={{ paddingLeft: 5, position: 'relative' }}
							>
								<span className={classes.sectionHeader}>
									Application Notifications
								</span>
							</Grid>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<FontAwesomeIcon
									className={classes.arrow}
									icon={['fas', 'chevron-right']}
								/>
							</Grid>
						</Grid>
					</Grid>
				</Paper>
				<Grid item xs={12} className={classes.rowHeader}>
					Personalization
				</Grid>
				<Paper className={classes.rowWrapperNoHov}>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar
									className={classes.avatar}
									style={{ background: teal[500] }}
								>
									<FontAwesomeIcon
										className={classes.avatarIcon}
										icon={['fas', 'volume-high']}
									/>
								</Avatar>
							</Grid>
							<Grid
								item
								xs={5}
								style={{ paddingLeft: 5, position: 'relative' }}
							>
								<span className={classes.sectionHeader}>
									Volume
								</span>
							</Grid>
							<Grid item xs={5} style={{ position: 'relative' }}>
								<ButtonGroup className={classes.arrow}>
									<Button
										onClick={toggleMute}
										className={
											settings.volume === 0
												? classes.unmute
												: classes.mute
										}
									>
										{settings.volume === 0 ? (
											<FontAwesomeIcon
												icon={['fas', 'volume']}
											/>
										) : (
											<FontAwesomeIcon
												icon={['fas', 'volume-xmark']}
											/>
										)}
									</Button>
									<Button onClick={volumeMinus}>
										<FontAwesomeIcon
											icon={['fas', 'minus']}
										/>
									</Button>
									<Button disabled>{settings.volume}%</Button>
									<Button onClick={volumeAdd}>
										<FontAwesomeIcon
											icon={['fas', 'plus']}
										/>
									</Button>
								</ButtonGroup>
							</Grid>
						</Grid>
					</Grid>
				</Paper>
				<Paper className={classes.rowWrapper} onClick={soundsClicked}>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar
									className={classes.avatar}
									style={{ background: deepOrange[500] }}
								>
									<FontAwesomeIcon
										className={classes.avatarIcon}
										icon={['fas', 'music']}
									/>
								</Avatar>
							</Grid>
							<Grid
								item
								xs={8}
								style={{ paddingLeft: 5, position: 'relative' }}
							>
								<span className={classes.sectionHeader}>
									Sounds
								</span>
							</Grid>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<FontAwesomeIcon
									className={classes.arrow}
									icon={['fas', 'chevron-right']}
								/>
							</Grid>
						</Grid>
					</Grid>
				</Paper>
				<Paper
					className={classes.rowWrapper}
					onClick={wallpaperClicked}
				>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar
									className={classes.avatar}
									style={{ background: orange[500] }}
								>
									<FontAwesomeIcon
										className={classes.avatarIcon}
										icon={['fas', 'images']}
									/>
								</Avatar>
							</Grid>
							<Grid
								item
								xs={8}
								style={{ paddingLeft: 5, position: 'relative' }}
							>
								<span className={classes.sectionHeader}>
									Wallpaper
								</span>
							</Grid>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<FontAwesomeIcon
									className={classes.arrow}
									icon={['fas', 'chevron-right']}
								/>
							</Grid>
						</Grid>
					</Grid>
				</Paper>
				<Paper className={classes.rowWrapperNoHov}>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar
									className={classes.avatar}
									style={{ background: blue[500] }}
								>
									<FontAwesomeIcon
										className={classes.avatarIcon}
										icon={['fas', 'magnifying-glass']}
									/>
								</Avatar>
							</Grid>
							<Grid
								item
								xs={5}
								style={{ paddingLeft: 5, position: 'relative' }}
							>
								<span className={classes.sectionHeader}>
									Zoom
								</span>
							</Grid>
							<Grid item xs={5} style={{ position: 'relative' }}>
								<ButtonGroup className={classes.arrow}>
									<Button onClick={() => setZoomInfo(true)}>
										<FontAwesomeIcon
											icon={['fas', 'question']}
										/>
									</Button>
									<Button onClick={zoomMinus}>
										<FontAwesomeIcon
											icon={['fas', 'minus']}
										/>
									</Button>
									<Button disabled>{settings.zoom}%</Button>
									<Button onClick={zoomAdd}>
										<FontAwesomeIcon
											icon={['fas', 'plus']}
										/>
									</Button>
								</ButtonGroup>
							</Grid>
						</Grid>
					</Grid>
				</Paper>
				<Paper className={classes.rowWrapper} onClick={colorsClicked}>
					<Grid item xs={12}>
						<Grid container>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<Avatar
									className={classes.avatar}
									style={{ background: deepPurple[500] }}
								>
									<FontAwesomeIcon
										className={classes.avatarIcon}
										icon={['fas', 'swatchbook']}
									/>
								</Avatar>
							</Grid>
							<Grid
								item
								xs={8}
								style={{ paddingLeft: 5, position: 'relative' }}
							>
								<span className={classes.sectionHeader}>
									Colors
								</span>
							</Grid>
							<Grid item xs={2} style={{ position: 'relative' }}>
								<FontAwesomeIcon
									className={classes.arrow}
									icon={['fas', 'chevron-right']}
								/>
							</Grid>
						</Grid>
					</Grid>
				</Paper>
			</Grid>
			<Version />
			<Modal
				open={zoomInfo}
				title="Phone Zoom"
				onClose={() => setZoomInfo(false)}
			>
				<p>Zooming only works when the phone is minimized.</p>
				<p>
					Zooming may have adverse effects on some features, things
					like hover tooltips may not work correctly (or at all on
					lower zooms). <b>You've been warned</b>.
				</p>
			</Modal>
		</div>
	);
});
