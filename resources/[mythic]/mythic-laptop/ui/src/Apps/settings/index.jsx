import React, { useEffect, useState, useMemo } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { makeStyles, withStyles } from '@mui/styles';
import {
	Grid,
	Avatar,
	Switch,
	Button,
	ButtonGroup,
	Paper,
} from '@mui/material';
import {
	green,
	purple,
	blue,
	orange,
	teal,
	deepOrange,
	deepPurple,
} from '@mui/material/colors';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { throttle } from 'lodash';

import Version from './components/Version';
import Wallpaper from './pages/Wallpaper';
import Colors from './pages/Colors';

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
		maxHeight: '95%',
		overflowY: 'auto',
		overflowX: 'hidden',
		'&::-webkit-scrollbar': {
			width: 8,
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
	rowWrapper2: {
		background: theme.palette.secondary.main,
		padding: '5px 10px',
		width: '95%',
		margin: '0 2.5% 0 2.5%',
		height: 'fit-content',
		userSelect: 'none',
		'-webkit-user-select': 'none',
		'&:hover': {
			background: theme.palette.secondary.light,
			transition: 'background ease-in 0.15s',
			cursor: 'pointer',
		},
	},
	sectionHeader2: {
		display: 'block',
		fontSize: 16,
		//fontWeight: 'bold',
		lineHeight: '30px',
	},
	arrow2: {
		fontSize: 20,
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		margin: 'auto',
	},
	mute: {
		color: theme.palette.error.main,
	},
	unmute: {
		color: theme.palette.error.main,
	},
	versionWrapper: {
		position: 'fixed',
		bottom: 10,
		width: '100%',
	}
}));

export default () => {
	const classes = useStyles();
	const dispatch = useDispatch();

	const [notifs, setNotifs] = useState(false);
	const [settingsPage, setSettingsPage] = useState(null);

	const settings = useSelector(
		(state) => state.data.data.player?.LaptopSettings,
	);

	const profileClicked = () => {
		//history.push(`/apps/settings/profile`);
	};

	const soundsClicked = () => {
		//history.push(`/apps/settings/sounds`);
	};

	const appNotifsClicked = () => {
		//history.push(`/apps/settings/app_notifs`);
	};

	const wallpaperClicked = () => {
		//history.push(`/apps/settings/wallpaper`);
		setSettingsPage('wallpaper');
	};

	const colorsClicked = () => {
		//history.push(`/apps/settings/colors`);
		setSettingsPage('colors');
	};

	const toggleNotifs = () => {
		//props.UpdateSetting('notifications', !notifs);
		//setNotifs(!notifs);
	};

	const volumeAdd = (e) => {
		e.preventDefault();
		//if (settings.volume < 100)
			//props.UpdateSetting('volume', settings.volume + 5);
	};

	const volumeMinus = (e) => {
		e.preventDefault();
		//if (settings.volume >= 5)
			//props.UpdateSetting('volume', settings.volume - 5);
	};

	const toggleMute = (e) => {
		e.preventDefault();
		//if (settings.volume === 0) props.UpdateSetting('volume', 100);
		//else props.UpdateSetting('volume', 0);
	};

	const goBack = (e) => {
		e.preventDefault();

		setSettingsPage(null);
	}

	if (settingsPage != null) {
		return <div className={classes.wrapper}>
			{settingsPage == "wallpaper" && <Wallpaper />}
			{settingsPage == "colors" && <Colors />}
			<Grid container spacing={2}>
				<Grid item xs={4}>
					<Paper
						className={classes.rowWrapper2}
						onClick={goBack}
					>
						<Grid item xs={12}>
							<Grid container>
								<Grid item xs={1} style={{ position: 'relative' }}>
									<FontAwesomeIcon
										className={classes.arrow2}
										icon={['fas', 'chevron-left']}
									/>
								</Grid>
								<Grid
									item
									xs={11}
									style={{ position: 'relative' }}
								>
									<span className={classes.sectionHeader2}>
										Go Back
									</span>
								</Grid>
							</Grid>
						</Grid>
					</Paper>
				</Grid>
				<Grid item xs={8}>
					<Version />
				</Grid>
			</Grid>
		</div>
	}

	return <div className={classes.wrapper}>
		<Grid
			className={classes.settingsList}
			container
			justify="flex-start"
		>
			{/* <Paper className={classes.rowWrapper} onClick={profileClicked}>
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
			</Grid> */}
			{/* <Paper className={classes.rowWrapper} onClick={toggleNotifs}>
				<Grid item xs={12}>
					<Grid container>
						<Grid item xs={2} style={{ position: 'relative' }}>
							<Avatar
								className={classes.avatar}
								style={{ background: green[500] }}
							>
								<FontAwesomeIcon
									className={classes.avatarIcon}
									icon={['fas', 'bell-on']}
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
			</Paper> */}
			{/* <Paper
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
									icon={['fas', 'bell-on']}
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
			</Paper> */}
			<Grid item xs={12} className={classes.rowHeader} style={{ fontSize: 20 }}>
				Settings
			</Grid>
			<Grid item xs={12} className={classes.rowHeader}>
				Personalization
			</Grid>
			{/* <Paper className={classes.rowWrapperNoHov}>
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
			</Paper> */}
			{/* <Paper className={classes.rowWrapper} onClick={soundsClicked}>
				<Grid item xs={12}>
					<Grid container>
						<Grid item xs={2} style={{ position: 'relative' }}>
							<Avatar
								className={classes.avatar}
								style={{ background: deepOrange[500] }}
							>
								<FontAwesomeIcon
									className={classes.avatarIcon}
									icon={['fas', 'waveform-lines']}
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
			</Paper> */}
			<Paper
				className={classes.rowWrapper}
				onClick={wallpaperClicked}
			>
				<Grid item xs={12}>
					<Grid container>
						<Grid item xs={1} style={{ position: 'relative' }}>
							<Avatar
								className={classes.avatar}
								style={{ background: orange[500] }}
							>
								<FontAwesomeIcon
									className={classes.avatarIcon}
									icon={['fas', 'image']}
								/>
							</Avatar>
						</Grid>
						<Grid
							item
							xs={9}
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
			<Paper className={classes.rowWrapper} onClick={colorsClicked}>
				<Grid item xs={12}>
					<Grid container>
						<Grid item xs={1} style={{ position: 'relative' }}>
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
							xs={9}
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
		<div className={classes.versionWrapper}>
			<Version />
		</div>
	</div>;
};
