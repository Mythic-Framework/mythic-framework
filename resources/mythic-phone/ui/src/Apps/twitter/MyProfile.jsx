import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import {
	Avatar,
	TextField,
	Paper,
	AppBar,
	Grid,
	IconButton,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import _ from 'lodash';

import Nui from '../../util/Nui';
import { useAlert } from '../../hooks';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '89%',
		background: theme.palette.secondary.main,
		overflowY: 'auto',
		overflowX: 'hidden',
		padding: '0  10px',
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
		height: 200,
		width: 200,
		fontSize: 55,
		color: theme.palette.text.light,
		background: '#00aced',
		position: 'absolute',
		left: 0,
		right: 0,
		bottom: '75%',
		display: 'block',
		textAlign: 'center',
		lineHeight: '200px',
		margin: 'auto',

		'&.pending': {
			border: `3px solid ${theme.palette.warning.main}`,
		},
	},
	fields: {
		paddingTop: 60,
	},
	contactHeader: {
		padding: 20,
		background: theme.palette.secondary.dark,
		width: '100%',
		margin: '150px auto 0 auto',
		textAlign: 'center',
		position: 'relative',
	},
	contactName: {
		fontSize: 30,
		color: theme.palette.primary.main,
	},
	editField: {
		width: '100%',
		marginBottom: 20,
		fontSize: 20,
	},
	header: {
		background: '#00aced',
		fontSize: 20,
		padding: 15,
		lineHeight: '45px',
		height: 78,
	},
}));

export default (props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const history = useHistory();
	const dispatch = useDispatch();
	const player = useSelector((state) => state.data.data.player);

	const [oProfile, setOProfile] = useState({
		name: player.Alias.twitter ? player.Alias.twitter.name : '',
		avatar: player.Alias.twitter ? player.Alias.twitter.avatar : '',
	});

	const [profile, setProfile] = useState({
		name: player.Alias.twitter ? player.Alias.twitter.name : '',
		avatar: player.Alias.twitter ? player.Alias.twitter.avatar : '',
	});

	const onChange = (e) => {
		setProfile({
			...profile,
			[e.target.name]: e.target.value,
		});
	};

	const onSubmit = async (e) => {
		e.preventDefault();

		try {
			let res = await (
				await Nui.send('UpdateAlias', {
					app: 'twitter',
					alias: profile,
					unique: true,
				})
			).json();
			if (res) {
				dispatch({
					type: 'UPDATE_DATA',
					payload: {
						type: 'player',
						id: 'Alias',
						key: 'twitter',
						data: profile,
					},
				});
				showAlert('Alias Updated');
			} else {
				showAlert('Unable To Update Alias');
			}
		} catch (err) {
			console.log(err);
		}
	};

	return (
		<form id="profile-form" onSubmit={onSubmit}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={8} style={{ lineHeight: '50px' }}>
						Twitter
					</Grid>
					<Grid item xs={4} style={{ textAlign: 'right' }}>
						<IconButton
							type="submit"
							className={classes.headerAction}
						>
							<FontAwesomeIcon icon={['fas', 'floppy-disks']} />
						</IconButton>
					</Grid>
				</Grid>
			</AppBar>
			<div className={classes.wrapper}>
				<Paper className={classes.contactHeader}>
					{Boolean(profile.avatar) ? (
						<Avatar
							className={`${classes.avatar}${
								!_.isEqual(oProfile, profile) ? ' pending' : ''
							}`}
							src={profile.avatar}
							alt={profile.name.charAt(0)}
						/>
					) : (
						<Avatar
							className={`${classes.avatar}${
								!_.isEqual(oProfile, profile) ? ' pending' : ''
							}`}
						>
							<FontAwesomeIcon icon={['fas', 'user']} />
						</Avatar>
					)}
					<div className={classes.fields}>
						<TextField
							required
							className={classes.editField}
							label="Username"
							name="name"
							type="text"
							onChange={onChange}
							value={profile.name}
							inputProps={{
								pattern: '[a-zA-Z0-9_-]+',
							}}
						/>
						<TextField
							className={classes.editField}
							label="Avatar Link"
							name="avatar"
							type="text"
							onChange={onChange}
							value={profile.avatar}
						/>
					</div>
				</Paper>
			</div>
		</form>
	);
};
