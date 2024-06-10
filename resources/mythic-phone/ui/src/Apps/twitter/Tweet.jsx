import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Grid, Avatar, IconButton } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import processString from 'react-process-string';
import { CopyToClipboard } from 'react-copy-to-clipboard';
import ReactPlayer from 'react-player';
import Moment from 'react-moment';

import Nui from '../../util/Nui';
import { Sanitize } from '../../util/Parser';
import { LightboxImage } from '../../components';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		paddingTop: 10,
		height: 'fit-content',
		background: theme.palette.secondary.main,
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	author: {
		color: theme.palette.primary.main,
		fontSize: 16,
	},
	date: {
		color: theme.palette.text.alt,
		fontSize: 12,
		marginLeft: 5,
	},
	avatar: {
		width: 60,
		height: 60,
		margin: 'auto',
	},
	actionBtn: {
		fontSize: 16,
	},
	content: {
		fontSize: 14,
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
	hashtag: {
		color: theme.palette.primary.light,
	},
	image: {
		width: '100%',
		border: `1px solid ${theme.palette.border.divider}`,
		borderRadius: 4,
	},
	rtLink: {
		color: theme.palette.primary.light,
	},
	btnCount: {
		marginRight: 5,
	},
}));

export default ({ tweet, rtcount, onReply, onRetweet }) => {
	const classes = useStyles();
	const dispatch = useDispatch();
	const player = useSelector((state) => state.data.data.player);

	const [favd, setFavd] = useState(false);

	const onFavorite = async () => {
		setFavd(true);
		let res = await (
			await Nui.send('FavoriteTweet', {
				id: tweet._id,
				state: tweet.likes.includes(player.ID),
			})
		).json();
		setFavd(false);
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
		{
			regex: /#(\w)+/g,
			fn: (key, result) => {
				return (
					<span key={key} className={classes.hashtag}>
						{result[0]}
					</span>
				);
			},
		},
		{
			regex: /@(\w)+/g,
			fn: (key, result) => {
				return (
					<span key={key} className={classes.hashtag}>
						{result[0]}
					</span>
				);
			},
		},
	];

	return (
		<Grid id={tweet._id} container className={classes.wrapper}>
			<Grid item xs={2}>
				<Avatar className={classes.avatar} src={tweet.author.avatar} />
			</Grid>
			<Grid item xs={10}>
				<div>
					<span className={classes.author}>{tweet.author.name}</span>
					<span className={classes.date}>
						<Moment date={tweet.time} interval={60000} fromNow />
					</span>
				</div>
				<div className={classes.content}>
					{processString(config)(Sanitize(tweet.content))}
				</div>
				{Boolean(tweet.image.using) && (
					<LightboxImage
						src={tweet.image.link}
						className={classes.image}
					/>
				)}
				{/* {Boolean(tweet.retweet) && (
					<a className={classes.rtLink} href={`#${tweet.retweet}`}>
						View Original
					</a>
				)} */}
				<Grid container spacing={2} style={{ textAlign: 'center' }}>
					<Grid item xs={4}>
						<IconButton
							className={classes.actionBtn}
							onClick={() => onReply(tweet.author.name)}
							disabled={player.Alias.twitter == null}
						>
							<FontAwesomeIcon icon={['fas', 'reply']} />
						</IconButton>
					</Grid>
					<Grid item xs={4}>
						<IconButton
							className={classes.actionBtn}
							onClick={() => onRetweet(tweet)}
							disabled={
								player.Alias.twitter == null ||
								tweet.retweet ||
								tweet.cid == player.ID
							}
						>
							<span className={classes.btnCount}>{rtcount}</span>
							<FontAwesomeIcon icon={['fas', 'retweet']} />
						</IconButton>
					</Grid>
					<Grid item xs={4}>
						<IconButton
							color={
								tweet.likes.includes(player.ID)
									? 'primary'
									: 'inherit'
							}
							className={classes.actionBtn}
							onClick={onFavorite}
							disabled={player.Alias.twitter == null || favd}
						>
							<span className={classes.btnCount}>
								{tweet.likes.length}
							</span>
							<FontAwesomeIcon icon={['fas', 'heart']} />
						</IconButton>
					</Grid>
				</Grid>
			</Grid>
		</Grid>
	);
};
