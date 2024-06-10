import React, { useState, useEffect } from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
import { AppBar, Grid, TextField, IconButton } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
const processString = require('react-process-string');
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';
import { useHistory } from 'react-router';

import Nui from '../../util/Nui';
import { Slugify } from '../../util/Parser';
import { LightboxImage, Confirm, Loader } from '../../components';
import { GetMessages, SendMessage } from './actions';
import { useAlert } from '../../hooks';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		height: '100%',
		background: theme.palette.secondary.main,
		overflow: 'hidden',
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
		height: '75%',
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
			background: '#1de9b6',
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
			color: '#1de9b6',
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
		color: '#1de9b6',
		textDecoration: 'underline',
		transition: 'filter ease-in 0.15s',
		'&:hover': {
			filter: 'brightness(0.7)',
			cursor: 'pointer',
		},
	},
	details: {
		fontSize: 12,
		color: theme.palette.text.alt,
	},
	username: {
		color: '#1de9b6',
		fontSize: 16,
	},
	msgText: {
		padding: 20,
		fontSize: 14,
		display: 'block',
		fontFamily: 'monospace',
		color: theme.palette.text.main,
		//wordBreak: 'break-all',
	},
	error: {
		width: 'fit-content',
		margin: 'auto',
		padding: 10,
		border: `1px solid #1de9b6`,
	},
}));

export default connect(null, {
	GetMessages,
})((props) => {
	const showAlert = useAlert();
	const classes = useStyles();
	const dispatch = useDispatch();
	const history = useHistory();
	const { channel } = props.match.params;
	const allMsgs = useSelector(
		(state) => state.data.data[`irc-${Slugify(channel)}`],
	);
	const player = useSelector((state) => state.data.data.player);
	const channelData = useSelector(
		(state) => state.data.data.ircChannels,
	).filter((c) => c.slug == channel)[0];

	const [leaveOpen, setLeaveOpen] = useState(false);
	const [messages, setMessages] = useState([]);
	const [loading, setLoading] = useState(false);
	useEffect(() => {
		const getMessages = async () => {
			setLoading(true);
			try {
				let res = await (
					await Nui.send('GetIRCMessages', Slugify(channel))
				).json();
				if (res) {
					setMessages(res);
					dispatch({
						type: 'SET_DATA',
						payload: {
							type: `irc-${channel}`,
							data: res,
						},
					});
				}
				setLoading(false);
			} catch (err) {
				console.log(err);
				setLoading(false);
			}
		};

		if (allMsgs) {
			setMessages(
				allMsgs
					.filter((m) => m.time >= channelData.joined)
					.sort((a, b) => b.time - a.time),
			);
		} else {
			if (channelData) {
				getMessages();
			}
		}
	}, [allMsgs]);
	const [pendingText, setPendingText] = useState('');

	const onLeave = async (e) => {
		try {
			let res = await (await Nui.send('LeaveIRCChannel', channel)).json();
			if (res) {
				showAlert('You Left The Channel');
				history.goBack();
				dispatch({
					type: 'REMOVE_DATA',
					payload: {
						type: 'ircChannels',
						id: channel,
						key: 'slug',
					},
				});
			} else {
				showAlert('Unable To Leave Channel');
			}
		} catch (err) {
			console.log(err);
			showAlert('Unable To Leave Channel');
		}
	};

	const onChange = (e) => {
		setPendingText(e.target.value);
	};

	const onSubmit = async (e) => {
		e.preventDefault();

		if (pendingText != '') {
			try {
				let msg = {
					message: pendingText,
					channel,
					time: Date.now(),
					from: player.Alias.irc,
				};

				let res = await (await Nui.send('SendIRCMessage', msg)).json();
				if (res) {
					dispatch({
						type: 'ADD_DATA',
						payload: {
							type: `irc-${channel}`,
							first: true,
							data: msg,
						},
					});
					showAlert('Message Sent');
					setPendingText('');
				} else {
					showAlert('Unable To Send Message');
				}
			} catch (err) {
				console.log(err);
				showAlert('Unable To Send Message');
			}
		}
	};

	const config = [
		{
			regex: /((https?:\/\/(www\.)?(i\.)?imgur\.com\/[a-zA-Z\d]+)(\.png|\.jpg|\.jpeg|\.gif)?)/gim,
			fn: (key, result) => (
				<LightboxImage
					key={key}
					className={classes.messageImg}
					src={result[0]}
				/>
			),
		},
		{
			regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)(mp4)/gim,
			fn: (key, result) => (
				<div>
					<ReactPlayer
						key={key}
						volume={0.25}
						width="100%"
						controls={true}
						url={`${result[0]}`}
					/>
				</div>
			),
		},
		{
			regex: /(http|https):\/\/(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)/gim,
			fn: (key, result) => (
				<CopyToClipboard
					text={result[0]}
					key={key}
					onCopy={() => showAlert('Link Copied To Clipboard')}
				>
					<a className={classes.copyableText}>{result.input}</a>
				</CopyToClipboard>
			),
		},
		{
			regex: /(\S+)\.([a-z]{2,}?)(.*?)( |\,|$|\.)/gim,
			fn: (key, result) => (
				<CopyToClipboard
					text={result[0]}
					key={key}
					onCopy={() => showAlert('Link Copied To Clipboard')}
				>
					<a className={classes.copyableText}>{result.input}</a>
				</CopyToClipboard>
			),
		},
	];

	return (
		<div className={classes.wrapper}>
			{channelData != null ? (
				<>
					<AppBar position="static" className={classes.header}>
						<Grid container>
							<Grid item xs={11}>
								#{channelData.slug}
							</Grid>
							<Grid item xs={1}>
								<Grid container>
									<Grid item xs={6}>
										<IconButton
											color="secondary"
											onClick={() => setLeaveOpen(true)}
										>
											<FontAwesomeIcon icon="right-from-bracket" />
										</IconButton>
									</Grid>
								</Grid>
							</Grid>
						</Grid>
					</AppBar>
					{loading ? (
						<div className={classes.body}>
							<Loader text="Loading Messages" />
						</div>
					) : (
						<div className={classes.body}>
							{messages.map((message, key) => {
								return (
									<div
										key={`msg-${key}`}
										className={classes.textWrap}
									>
										<span className={classes.details}>
											<span className={classes.username}>
												{message.from}
											</span>
											<Moment
												className={classes.timestamp}
												titleFormat="h:mm:ss A"
												withTitle
												fromNow
											>
												{+message.time}
											</Moment>
										</span>
										<span className={classes.msgText}>
											{processString(config)(
												message.message,
											)}
										</span>
									</div>
								);
							})}
							<div>
								<h3>Welcome To #{channelData.slug}</h3>
							</div>
						</div>
					)}
					<div className={classes.input}>
						<form onSubmit={onSubmit}>
							<Grid container>
								<Grid item xs={10}>
									<TextField
										variant="standard"
										className={classes.textInput}
										label="Send New Message"
										multiline
										rows="4"
										value={pendingText}
										onChange={onChange}
									/>
								</Grid>
								<Grid item xs={2}>
									<div
										className={
											pendingText !== ''
												? classes.submitBtn
												: classes.submitBtnDisabled
										}
										onClick={onSubmit}
									>
										<FontAwesomeIcon
											icon="paper-plane"
											className={classes.submitIcon}
										/>
									</div>
								</Grid>
							</Grid>
						</form>
					</div>
					<Confirm
						title="Leave Channel?"
						open={leaveOpen}
						confirm="Leave"
						decline="Cancel"
						onConfirm={onLeave}
						onDecline={() => setLeaveOpen(false)}
					/>
				</>
			) : (
				<div className={classes.error}>Invalid Channel</div>
			)}
		</div>
	);
});
