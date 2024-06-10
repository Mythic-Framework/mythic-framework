import React, { useState, useEffect } from 'react';
import { connect, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import {
	AppBar,
	Grid,
	Menu,
	MenuItem,
	TextField,
	Avatar,
	Paper,
	IconButton,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
const processString = require('react-process-string');
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';
import { Link } from 'react-router-dom';

import { SendMessage, DeleteConvo, ReadConvo } from './actions';
import { useAlert } from '../../hooks';
import Nui from '../../util/Nui';

export default connect(null, {
	SendMessage,
	DeleteConvo,
	ReadConvo,
})((props) => {
	const showAlert = useAlert();
	const history = useHistory();
	const { number } = props.match.params;
	const isContact = useSelector((state) => state.data.data.contacts).filter(
		(c) => c.number === number,
	)[0];
	const allMsgs = useSelector((state) => state.data.data.messages);
	const player = useSelector((state) => state.data.data.player);
	const callData = useSelector((state) => state.call.call);

	const [messages, setMessages] = useState([]);
	useEffect(() => {
		setMessages(
			allMsgs
				.filter((m) => m.number === number)
				.sort((a, b) => b.time - a.time),
		);

		if (allMsgs.filter((m) => m.number === number && m.unread).length > 0) {
			props.ReadConvo(number, allMsgs);
		}
	}, [allMsgs]);

	const useStyles = makeStyles((theme) => ({
		wrapper: {
			height: '100%',
			background: theme.palette.secondary.main,
			overflow: 'hidden',
		},
		header: {
			background:
				isContact != null
					? isContact.color
					: theme.palette.primary.main,
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
			marginTop: '0 !important',
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
			padding: '0 10px',
			color: theme.palette.text.light,
			'&:first-of-type': {
				marginTop: 0,
			},
		},
		myText: {
			marginLeft: 'auto',
			width: 'fit-content',
			maxWidth: '75%',
			padding: 15,
			borderRadius: 15,
			background: theme.palette.secondary.dark,
			overflowWrap: 'break-word',
			hyphens: 'auto',
		},
		otherText: {
			marginRight: 'auto',
			width: 'fit-content',
			maxWidth: '75%',
			padding: 15,
			borderRadius: 15,
			background:
				isContact != null
					? isContact.color
					: theme.palette.primary.main,
			overflowWrap: 'break-word',
			hyphens: 'auto',
		},
		timestamp: {
			color: theme.palette.text.main,
			fontSize: 12,
			padding: '5px 5px 0px 5px',
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
	}));
	const classes = useStyles();

	const [open, setOpen] = useState(false);
	const [pendingText, setPendingText] = useState('');
	const [offset, setOffset] = useState({
		left: 110,
		top: 0,
	});

	const onClick = (e) => {
		e.preventDefault();
		setOffset({ left: e.clientX - 2, top: e.clientY - 4 });
		setOpen(true);
	};

	const onClose = () => {
		setOpen(false);
	};

	const callNumber = async () => {
		if (callData == null) {
			try {
				let res = await (
					await Nui.send('CreateCall', {
						number,
						isAnon: false,
					})
				).json();
				if (res) {
					history.push(`/apps/phone/call/${number}`);
				} else showAlert('Unable To Start Call');
			} catch (err) {
				console.log(err);
				showAlert('Unable To Start Call');
			}
		}
	};

	const deleteConvo = () => {
		if (props.DeleteConvo(number, player.Phone, allMsgs)) {
			showAlert('Conversation Deleted');
			history.goBack();
		} else {
			showAlert('Unable To Delete Conversation');
		}
		onClose();
	};

	const editNumber = () => {
		if (isContact != null) {
			history.push(`/apps/contacts/edit/${isContact._id}`);
		} else {
			history.push(`/apps/contacts/add/${number}`);
		}
	};

	const onChange = (e) => {
		setPendingText(e.target.value);
	};

	const onSubmit = (e) => {
		e.preventDefault();

		if (pendingText !== '') {
			props.SendMessage({
				owner: player.Phone,
				number: number,
				method: 1,
				time: Date.now(),
				message: pendingText,
			});
			setPendingText('');
		}
	};

	const config = [
		{
			regex: /^https?:\/\/(\w+\.)?imgur.com\/(\w*\d\w*)+(\.[a-zA-Z]{3})?$/gim,
			fn: (key, result) => (
				<CopyToClipboard
					text={result[0]}
					key={key}
					onCopy={() => showAlert('Link Copied To Clipboard')}
				>
					<img
						key={key}
						className={classes.messageImg}
						src={result[0]}
					/>
				</CopyToClipboard>
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
		{
			regex: /ircinvite=(\d)+/gim,
			fn: (key, result) => {
				return (
					<Link
						key={key}
						className={classes.copyableText}
						to={`/apps/irc/join/${result[0].split('=')[1]}`}
					>
						IRC Invite: {result[0].split('=')[1]}
					</Link>
				);
			},
		},
	];

	return (
		<div className={classes.wrapper}>
			<AppBar position="static" className={classes.header}>
				<Grid container>
					<Grid item xs={2}>
						{isContact != null ? (
							isContact.avatar != null &&
							isContact.avatar !== '' ? (
								<Avatar
									className={
										isContact.favorite
											? classes.avatarFav
											: classes.avatar
									}
									src={isContact.avatar}
									alt={isContact.name.charAt(0)}
								/>
							) : (
								<Avatar
									className={
										isContact.favorite
											? classes.avatarFav
											: classes.avatar
									}
									style={{ background: isContact.color }}
								>
									{isContact.name.charAt(0)}
								</Avatar>
							)
						) : (
							<Avatar className={classes.avatar}>#</Avatar>
						)}
					</Grid>
					<Grid item xs={6}>
						{isContact != null ? isContact.name : number}
					</Grid>
					<Grid item xs={4}>
						<Grid container>
							<Grid item xs={6} className={classes.messageAction}>
								<IconButton onClick={callNumber}>
									<FontAwesomeIcon icon="phone" />
								</IconButton>
							</Grid>
							<Grid item xs={6} className={classes.messageAction}>
								<IconButton onClick={onClick}>
									<FontAwesomeIcon icon="ellipsis-vertical" />
								</IconButton>
							</Grid>
						</Grid>
					</Grid>
				</Grid>
				<Menu
					anchorReference="anchorPosition"
					anchorPosition={offset}
					keepMounted
					open={open}
					onClose={onClose}
				>
					<MenuItem onClick={editNumber}>
						{isContact != null ? 'View Contact' : 'Create Contact'}
					</MenuItem>
					<MenuItem onClick={deleteConvo}>
						Delete Conversation
					</MenuItem>
				</Menu>
			</AppBar>
			<div className={classes.body}>
				{messages.map((message, key) => {
					return (
						<div key={key} className={classes.textWrap}>
							<Paper
								className={
									message.method === 1
										? classes.myText
										: classes.otherText
								}
							>
								{processString(config)(message.message)}
							</Paper>
							<div
								className={classes.timestamp}
								style={{
									textAlign:
										message.method === 1 ? 'right' : 'left',
								}}
							>
								<Moment
									titleFormat="M/D/YYYY h:mm:ss A"
									withTitle
									fromNow
								>
									{+message.time}
								</Moment>
							</div>
						</div>
					);
				})}
			</div>
			<div className={classes.input}>
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
			</div>
		</div>
	);
});
