import React from 'react';
import { useSelector } from 'react-redux';
import { Avatar, Paper, Button } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { useMyApps, useAlert } from '../../hooks';
import Nui from '../../util/Nui';
import Version from './components/Version';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		position: 'relative',
	},
	dataWrapper: {
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
		height: 100,
		width: 100,
		color: theme.palette.text.light,
		background: theme.palette.primary.main,
		display: 'block',
		textAlign: 'center',
		margin: 'auto',
		marginTop: '-20%',
	},
	avatarIcon: {
		fontSize: 55,
		position: 'absolute',
		left: 0,
		right: 0,
		bottom: 0,
		top: 0,
		margin: 'auto',
	},
	contactHeader: {
		padding: 20,
		background: theme.palette.secondary.dark,
		width: '100%',
		margin: '70px auto 25px auto',
		textAlign: 'center',
	},
	profileSection: {
		padding: 20,
		background: theme.palette.secondary.dark,
		width: '100%',
		margin: 'auto',
		marginBottom: 25,
		'&::last-child': {
			marginBottom: 'none',
		},
	},
	name: {
		fontSize: 30,
		color: theme.palette.primary.main,
	},
	number: {
		fontSize: 15,
		color: theme.palette.text.main,
	},
	contactButtons: {
		marginTop: 25,
	},
	contactButton: {
		fontSize: 22,
		'&:hover': {
			color: theme.palette.primary.main,
			transition: 'color 0.15s ease-in',
			cursor: 'pointer',
		},
	},
	actions: {
		background: theme.palette.secondary.dark,
		borderRadius: 10,
		fontSize: 15,
		fontWeight: 'bold',
		margin: '0 auto 25px auto',
		width: '90%',
	},
	sectionHeader: {
		fontSize: 24,
		fontFamily: 'Aclonica',
		color: theme.palette.text.light,
		padding: 10,
		borderBottom: `1px solid ${theme.palette.primary.main}`,
	},
	sectionBody: {
		fontSize: 16,
	},
	bodyItem: {
		padding: 10,
	},
	highlight: {
		fontWeight: 'bold',
		color: theme.palette.primary.main,
	},
}));

export default (props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const myApps = useMyApps();
	const player = useSelector((state) => state.data.data.player);

	const onShare = async () => {
		try {
			let res = await (await Nui.send('ShareMyContact')).json();
			showAlert(
				res
					? 'Contact Shared to All Nearby'
					: 'Unable to Share Contact',
			);
		} catch (err) {
			console.log(err);
			showAlert('Unable to Share Contact');
		}
	};

	return (
		<div className={classes.wrapper}>
			<div className={classes.dataWrapper}>
				<Paper className={classes.contactHeader}>
					<Avatar className={classes.avatar}>
						<FontAwesomeIcon
							icon={['fas', 'user']}
							className={classes.avatarIcon}
						/>
					</Avatar>
					<div
						className={classes.name}
					>{`${player.First} ${player.Last}`}</div>
					<div className={classes.number}>{player.Phone}</div>
					<Button
						variant="outlined"
						color="primary"
						onClick={onShare}
						style={{ marginTop: 5 }}
					>
						Share Contact
					</Button>
				</Paper>
				<Paper className={classes.profileSection}>
					<div className={classes.sectionHeader}>
						Personal Details
					</div>
					<div className={classes.sectionBody}>
						<div className={classes.bodyItem}>
							<span className={classes.highlight}>
								Server ID:{' '}
							</span>
							{player.Source}
						</div>
						<div className={classes.bodyItem}>
							<span className={classes.highlight}>
								State ID:{' '}
							</span>
							{player.SID}
						</div>
						<div className={classes.bodyItem}>
							<span className={classes.highlight}>
								Passport ID:{' '}
							</span>
							{player.User}
						</div>
					</div>
				</Paper>
				<Paper className={classes.profileSection}>
					<div className={classes.sectionHeader}>Licenses</div>
					<div className={classes.sectionBody}>
						{Object.keys(player.Licenses)
							.sort((a, b) => (a < b ? -1 : a > b ? 1 : 0))
							.map((k) => {
								let licenseData = player.Licenses[k];

								if (licenseData?.Suspended) {
									return (
										<div className={classes.bodyItem}>
											<span className={classes.highlight}>
												{`${k}: `}
											</span>
											Suspended
										</div>
									);
								} else {
									if (licenseData?.Active) {
										return (
											<div className={classes.bodyItem}>
												<span
													className={
														classes.highlight
													}
												>
													{`${k}: `}
												</span>
												Valid
											</div>
										);
									} else {
										return (
											<div className={classes.bodyItem}>
												<span
													className={
														classes.highlight
													}
												>
													{`${k}: `}
												</span>
												None
											</div>
										);
									}
								}
							})}
					</div>
				</Paper>
				<Paper className={classes.profileSection}>
					<div className={classes.sectionHeader}>
						Application Aliases
					</div>
					<div className={classes.sectionBody}>
						{Object.keys(player.Alias).map((k) => {
							let alias = player.Alias[k];
							let app = myApps[k];
							if (!Boolean(app)) return null;
							if (alias instanceof Object) {
								return (
									<div
										key={`alias-${k}`}
										className={classes.bodyItem}
									>
										<span className={classes.highlight}>
											{`${app?.label} `}
										</span>
										{alias.name}
									</div>
								);
							} else {
								return (
									<div
										key={`alias-${k}`}
										className={classes.bodyItem}
									>
										<span className={classes.highlight}>
											{`${app?.label} `}
										</span>
										{alias}
									</div>
								);
							}
						})}
					</div>
				</Paper>
			</div>
			<Version />
		</div>
	);
};
