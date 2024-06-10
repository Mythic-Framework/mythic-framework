import React, { useState, useEffect } from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
import { AppBar, Grid, TextField } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
const processString = require('react-process-string');
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';
import Nui from '../../util/Nui';

import { LightboxImage, Loader } from '../../components';
import { GetMessages, SendMessage } from './actions';
import { useAlert } from '../../hooks';
import { useHistory } from 'react-router';

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
			background: '#1de9b6',
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
	avatar: {
		color: '#fff',
		height: 45,
		width: 45,
	},
	avatarFav: {
		color: '#fff',
		height: 45,
		width: 45,
		border: '2px solid gold',
	},
	messageAction: {
		textAlign: 'center',
		'&:hover': {
			color: theme.palette.text.main,
			transition: 'color ease-in 0.15s',
		},
	},
	body: {
		padding: 10,
		height: '77%',
		display: 'flex',
		flexDirection: 'column-reverse',
		overflowX: 'hidden',
		overflowY: 'auto',
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
	input: {
		width: '100%',
		padding: '0 10px',
	},
	textInput: {
		width: '100%',
	},
	submitBtn: {
		height: '100%',
		fontSize: 30,
		textAlign: 'center',
		borderBottom: '1px solid rgba(255, 255, 255, 0.7)',
		'&:hover': {
			borderBottom: '2px solid #fff',
			color: theme.palette.primary.main,
			transition: 'color, border-bottom ease-in 0.15s',
		},
	},
	submitBtnDisabled: {
		height: '100%',
		fontSize: 30,
		textAlign: 'center',
		borderBottom: '1px solid rgba(255, 255, 255, 0.7)',
		filter: 'brightness(0.25)',
	},
	submitIcon: {
		display: 'block',
		margin: 'auto',
		height: '100%',
		width: '40%',
	},
	textWrap: {
		width: '100%',
		fontSize: 16,
		margin: '20px 0px',
		color: theme.palette.text.light,
	},
	timestamp: {
		color: theme.palette.text.alt,
		fontSize: 12,
		marginLeft: 5,
	},
	messageImg: {
		display: 'block',
		maxWidth: 200,
	},
	copyableText: {
		color: theme.palette.primary.main,
		textDecoration: 'underline',
		'&:hover': {
			transition: 'color ease-in 0.15s',
			color: theme.palette.text.main,
			cursor: 'pointer',
		},
	},
	details: {
		fontSize: 12,
		color: theme.palette.text.alt,
	},
	username: {
		color: theme.palette.primary.main,
		fontSize: 14,
	},
	msgText: {
		padding: 20,
		fontSize: 12,
		display: 'block',
		fontFamily: 'monospace',
		color: theme.palette.text.main,
	},
}));

export default connect(null, {
	GetMessages,
})((props) => {
	const showAlert = useAlert();
	const dispatch = useDispatch();
	const history = useHistory();
	const classes = useStyles();
	const { channel } = props.match.params;

	useEffect(() => {
		const func = async () => {
			if (channel) {
				try {
					let res = await (await Nui.send('JoinIRCChannel', channel)).json();
					if (res) {
						dispatch({
							type: 'ADD_DATA',
							payload: {
								type: 'ircChannels',
								data: {
									slug: channel,
									joined: Date.now(),
									pinned: false,
								},
							},
						});
						history.replace(`/apps/irc/view/${channel}`);
						showAlert('Joined Channel');
					} else {
						history.goBack();
						showAlert('Unable To Join Channel');
					}
				} catch (err) {
					console.log(err);
					history.goBack();
					showAlert('Unable To Join Channel');
				}
			}
		};
		func();
	}, [channel]);

	return (
		<div className={classes.wrapper}>
			<Loader text="Joining Channel" />
		</div>
	);
});
